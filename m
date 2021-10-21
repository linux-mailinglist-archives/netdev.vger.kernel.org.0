Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88693436B19
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 21:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231984AbhJUTLo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 15:11:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbhJUTLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 15:11:44 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6A7AC061764;
        Thu, 21 Oct 2021 12:09:27 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id y67so2311235iof.10;
        Thu, 21 Oct 2021 12:09:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=FeQZrD/GFZW0JDU3zbGskN7ftzFdVtgjVzqDu9TS7Ms=;
        b=ZOEG6xzVpPFX81pZlgezkubTtjkxCzAWHJDE1K3kfPKKdwXaX5QeHrRpJlliqVCh4v
         Zth87NUyTgm6i2SF8XbHRAt/WH/qijrwdDgWtAFMjVDsoMdWX9flsyCeksirfvteTMEq
         4HgR2ojwPl1ce8ZONS2heuc1t2ALBchInx+C9rmfD/kbD3nkQw6XHYmCrmdFnQdUWTKw
         FLnaSb8lFUzY98+ykmcHxwTGr6/EJm+6A9OeYlaaNBo1C4c4/qWhznIspztKVanDHwAB
         tiyfloX4PqAkcACJ33DXOIu3im6+ND+2F30aXR0jdmfQRAAENnt+b+44OJLbSlrPVEwp
         9Q6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=FeQZrD/GFZW0JDU3zbGskN7ftzFdVtgjVzqDu9TS7Ms=;
        b=Puv/NTmQGiNrs0k12OCmZnhtx1M/C+BE3hGE1yl3uuipAQu459bnAYcbenKgwklBQW
         mZmymV5Rd0pdQkSOGIkazF3TPU0JatN2mxgfgrLgBSEMMDwGc59nWW7yWyzeODP+M0TV
         GPboPg1tT/Zfd+hc0+owZyfxXmIW07xJ2Z4nZi9Lf+9PQeXgEM7dodhxAdUfb666wDW8
         LRhAgWaqOMQu6Rpjnc6S2zuLWX7lVMfG+S2IS/B7NWRUYHd+H7MfUfnj8wD2UXURR2tl
         S/meo5JuXdD5EkO88zNUDZzghlFKAkyYc2KopCoBacA4FzCO46sio9F0xsqaHDDj7xn+
         qxXQ==
X-Gm-Message-State: AOAM533QrYFFX/BR27UtAoD5+pgH/MNcD9KDpi2TDFjEGaqOheUkMSN+
        aC3DykaPh2kaWRu/UfLveD0=
X-Google-Smtp-Source: ABdhPJxYyS8b782rgYOGxv8K3HN9v7F49gRdG5Mhz7caoiUI9oVCOzAetXVZSMCTjzqPwVhxMFvVkA==
X-Received: by 2002:a05:6602:1799:: with SMTP id y25mr5062542iox.38.1634843367364;
        Thu, 21 Oct 2021 12:09:27 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id 16sm2911923ioc.39.2021.10.21.12.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 12:09:26 -0700 (PDT)
Date:   Thu, 21 Oct 2021 12:09:18 -0700
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
Message-ID: <6171bade5c0c_663a720836@john-XPS-13-9370.notmuch>
In-Reply-To: <20211015112336.1973229-3-markpash@cloudflare.com>
References: <20211015112336.1973229-1-markpash@cloudflare.com>
 <20211015112336.1973229-3-markpash@cloudflare.com>
Subject: RE: [PATCH bpf-next 2/2] selftests/bpf: Add tests for accessing
 ifindex in bpf_sk_lookup
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mark Pashmfouroush wrote:
> A new field was added to the bpf_sk_lookup data that users can access.
> Add tests that validate that the new ifindex field contains the right
> data.
> 
> Signed-off-by: Mark Pashmfouroush <markpash@cloudflare.com>

LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
