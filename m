Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB2F1436AFF
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 21:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhJUTCj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 15:02:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbhJUTCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 15:02:37 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F35C061764;
        Thu, 21 Oct 2021 12:00:20 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id e144so2330820iof.3;
        Thu, 21 Oct 2021 12:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=iFcW2waaDzlWoT00moK0M/0BZk8C4xXdFBWVDWe8eJ4=;
        b=nW7EgpfP4RXYOxTA9VizbvEzUB9pQnDkWmZP+ZNSLmefHDcihr1RYZ7f5BxV4MVyPy
         gPnFDmYgfZnKPuktv2H/T+j9keOajGzK4I0EGYP7e5uZxNuLrzU90qznQUlGwMHd2VdS
         XP8nYtph9QMAFGqSIP82G98WBRHti7QmqnFmoW/1Net8m9GfUHxGsdkg67tsPPYTtB5M
         RYsYJUWhYtDaLS/vduAZPe3jJbCN9Xy952bMDNP/OXJSJzgJ0MTyWc8nmMuYe0cV+98y
         BRzcorBTMjiaNatXLs3AqBiAUaq/pr8gg4gvBSWqEznjpoZ/BkhIJohA+ag8TMI6jhIM
         RCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=iFcW2waaDzlWoT00moK0M/0BZk8C4xXdFBWVDWe8eJ4=;
        b=Z+Nj6W2Hz/zqVE00wlQW0ZRKzyQAOtoBOb/1yveLS8BbAK5V7zbvbMyEc31xzd/kUL
         Ni3jceEy4P76/+sxy348nrHL1Xvi18f2ddu3gChyJTgvQxDPYel63TmKGMPy2GIP5tQW
         1RUuaJmP3/SW/4KiXpAszIhXfT5CYG6pIhx23venW2ebzUL5sXiR/sWgz66UVjDoRlC8
         ygRQjCOvDZRyCx1DlCyKqGNxO8CPJxBkmIT21zJSscnx5Fvr9QzZzCMJegute6ZnW8QQ
         C2thlVCrc5IhQN9a1YJ36QmgQVS/SXFrLrfE40dLVMUsRKDYN/AOk3SrLD6HEtgu1Xxo
         QBkg==
X-Gm-Message-State: AOAM533hBymHtlEm/ITej9zU+9r4P+QMymwXHfaSsYMtVLXwfWjTko2U
        smanI2chgqQw/E+573+s3Io=
X-Google-Smtp-Source: ABdhPJx9ZbjJxJZGLhodnAG1wzsJI+/xZfsA/Wmh62lOdGlrgYKbw7FJ6bDFny8bjjAUPNQzEPuVfw==
X-Received: by 2002:a02:6f5d:: with SMTP id b29mr5101929jae.113.1634842820282;
        Thu, 21 Oct 2021 12:00:20 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id m5sm3041706ild.45.2021.10.21.12.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 12:00:19 -0700 (PDT)
Date:   Thu, 21 Oct 2021 12:00:11 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Mark Pashmfouroush <markpash@cloudflare.com>,
        markpash@cloudflare.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florent Revest <revest@chromium.org>,
        Brendan Jackman <jackmanb@google.com>,
        Joe Stringer <joe@cilium.io>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Message-ID: <6171b8bbe35a7_663a72084f@john-XPS-13-9370.notmuch>
In-Reply-To: <20211015112336.1973229-2-markpash@cloudflare.com>
References: <20211015112336.1973229-1-markpash@cloudflare.com>
 <20211015112336.1973229-2-markpash@cloudflare.com>
Subject: RE: [PATCH bpf-next 1/2] bpf: Add ifindex to bpf_sk_lookup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark Pashmfouroush wrote:
> It may be helpful to have access to the ifindex during bpf socket
> lookup. Add this to the bpf_sk_lookup API.
> 
> Signed-off-by: Mark Pashmfouroush <markpash@cloudflare.com>
> 

Would be nice to have more details on the 'use case' here. I
don't know off-hand how it 'may be helpful'.

For the actual code though LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
