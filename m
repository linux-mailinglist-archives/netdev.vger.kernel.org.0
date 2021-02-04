Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9CD30EA76
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 03:54:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234150AbhBDCyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 21:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhBDCyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 21:54:10 -0500
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D9DC061573;
        Wed,  3 Feb 2021 18:53:29 -0800 (PST)
Received: by mail-il1-x136.google.com with SMTP id q5so1252072ilc.10;
        Wed, 03 Feb 2021 18:53:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=go2HYs26cOfYUYY2faa5eBuiVSTmo5KLa3Wxaa/G6Cs=;
        b=U/A//T+olYXqgyQ1IiAI1wfiwB4ssDjIj9cwpOPpx68cmlDlBrM79dkJJBHdYJ8YdJ
         dvPAh7jnYgh6ZkbAvEmumiV1uPPfU6AGfWgIRzAhW52xnowZDi6Pdk3liWdwoVTdE2j1
         0MathdjF6PAvUhuGQjANqw6F9PqlJ/i3bUtmz2cglQjOB+PouPei9rbKStT31m30aS4Y
         kwuBdWrl1g8GiM6ZlMXuMCPfdAt84bpLhSBqvb5odskKPepc8sjLigA5EF3BJOeb5svs
         AysrapGjJhRRptlxJKvV+lPXsFj3UwqC8p3lKion+tjECFKJ0HyslADLqe5ObEOBazRI
         Y5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=go2HYs26cOfYUYY2faa5eBuiVSTmo5KLa3Wxaa/G6Cs=;
        b=QtZw/Psnnp2lXyzdUbQFP+Vm8yP76jYwe3cwf8WFzTVwbwDuFDeg1k3YHcpkqaP54s
         U7Pm2kqbCW6+mJFfUZnI30Mgxu2iN6E+ibhLZlJghcAhhJ0mwnlGPYpJTvLAnJi39u8g
         IJsFdWQKQhLgZO7KsLyrNTSY72HMRNHJX99xFqvvfiOAekB4pMvCv7yvhicLTNBy06rF
         ufaPhv5547ktX4epcSgQeHkKmYhue4O66WQgKpcCo55SO+p0UxazfwBIUGc99SVHJMfC
         8Xy+PQmXxWWFc7KtNk8CURKAV51R8lqBzP8bMPvPq34pEiDrTdHdxTmfabgD2qEF871g
         TGTw==
X-Gm-Message-State: AOAM531OZR65/gg5PPywV+3LRv12a8QU4D2lrHwJnEIz8qG4UYlo7AEM
        DShpeCZVeuKITCPjOsGS+ec=
X-Google-Smtp-Source: ABdhPJz/pwOulosmkM8/ZyQsw9sbB4dUY5ED2KPMhp3ir7XbRnDgHgdC8T7DSPmmx1CtQvdi2gxLdw==
X-Received: by 2002:a92:d249:: with SMTP id v9mr4990284ilg.305.1612407209400;
        Wed, 03 Feb 2021 18:53:29 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id e1sm2005405iod.17.2021.02.03.18.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 18:53:28 -0800 (PST)
Date:   Wed, 03 Feb 2021 18:53:20 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     netdev@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>, ast@kernel.org,
        bpf@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <601b61a0e4868_194420834@john-XPS-13-9370.notmuch>
In-Reply-To: <20210204001458.GB2900@Leo-laptop-t470s>
References: <20210122074652.2981711-1-liuhangbin@gmail.com>
 <20210125124516.3098129-1-liuhangbin@gmail.com>
 <20210204001458.GB2900@Leo-laptop-t470s>
Subject: Re: [PATCHv17 bpf-next 0/6] xdp: add a new helper for dev map
 multicast support
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hangbin Liu wrote:
> Hi Daniel, Alexei,
> 
> It has been one week after Maciej, Toke, John's review/ack. What should
> I do to make a progress for this patch set?
> 

Patchwork is usually the first place to check:

 https://patchwork.kernel.org/project/netdevbpf/list/?series=421095&state=*

Looks like it was marked changed requested. After this its unlikely
anyone will follow up on it, rightly so given the assumption another
revision is coming.

In this case my guess is it was moved into changes requested because
I asked for a change, but then after some discussion you convinced me
the change was not in fact needed.

Alexei, Daniel can probably tell you if its easier to just send a v18
or pull in the v17 assuming any final reviews don't kick anything
else up.

Thanks
John
