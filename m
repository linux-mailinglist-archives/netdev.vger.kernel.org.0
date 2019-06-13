Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6920244AE4
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 20:40:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbfFMSka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 14:40:30 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:33786 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbfFMSk3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 14:40:29 -0400
Received: by mail-pl1-f194.google.com with SMTP id c14so2238240plo.0
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 11:40:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZBLJkWoDHozeLOOiHlcC/C1fGPQ1Btlliv90RJ67WDA=;
        b=AZfxwZwxAWkNke2ugY0ZX4VKJ55pjslbALHoQFuEqLgTwPAY4Gvg9xc1lDTTN6BWln
         32mlitup7fK7JQXNfVKqbkzdznaQ/Q9Oqzp2YVCCuEm52Whpa8+6nZdDSGaM26u4nPKq
         gMt9/YH47YVy4i6NIyNPzJIPeFgliomuQ7/fnDUFVz0nJxHYX1vdItSfGO26sHGeGbRx
         E7lkjgaBYzE4tbsZUWwIN2pyXgdZ4hvfbGMgu+qK0RQK7mNtC+DBfD2R1LS/iOHn9ysh
         BJFaC3/ifgNVdKcycTGGRjPOHJFvLJcwwhRIOvYJIOEbPpOyVJ3wsbiKUTCs4EEUqxDA
         YIzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZBLJkWoDHozeLOOiHlcC/C1fGPQ1Btlliv90RJ67WDA=;
        b=Pu4QaQaDNd0JjB1OixHLembUOqM1rELDlVTgt+uzElePpmd/dyj2gOWXsMAHyhQlIe
         Ywwpr4VSiRqqfRb1dBp76kbLu7hbU/ztNFdIDLgZtCo2Yibfo6chuL1nEq5kLiN015+8
         v4+dDjKrY8xYCx5ZIcX4iypZRiX4Bma9+APDpMzv19uyNT13NiAgcEIx3Dgty4TmprK2
         hSL7xU5ui3wX4290oz4A9BU3w3vuC69V8QoRBctTnOnzWNfi3hKpfz/8Hm++Bi5hzNTq
         1poTOWPwnYyGobqsopn0JiFNu1ukTGjxrqMoaI+3OKj/ggR69Ydjx8pnnylEEGf4sDcZ
         jieg==
X-Gm-Message-State: APjAAAXb3C7QCKCtQCLuelsuIuH6rSbWtb37BZR/KpDRs43Y1AGBJLAk
        DGD2lZczFsSeaBNP/BianOM=
X-Google-Smtp-Source: APXvYqyfKGvdDzZbVVD7cQhB5qMuiQEUfst8S2GUGkY7BCROLIjT2PkYsLmV7yB5d+Y4ACqJQFX72Q==
X-Received: by 2002:a17:902:b94a:: with SMTP id h10mr89385318pls.265.1560451229064;
        Thu, 13 Jun 2019 11:40:29 -0700 (PDT)
Received: from [172.26.120.221] ([2620:10d:c090:180::1:f576])
        by smtp.gmail.com with ESMTPSA id r1sm626521pji.15.2019.06.13.11.40.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 11:40:28 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>
Cc:     netdev@vger.kernel.org,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH bpf-next v4 0/3] xdp: Allow lookup into devmaps before
 redirect
Date:   Thu, 13 Jun 2019 11:40:25 -0700
X-Mailer: MailMate (1.12.5r5635)
Message-ID: <C4A2FB53-8D56-4C3D-A106-EEEFC1C88A97@gmail.com>
In-Reply-To: <156042464138.25684.15061870566905680617.stgit@alrua-x1>
References: <156042464138.25684.15061870566905680617.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13 Jun 2019, at 4:17, Toke Høiland-Jørgensen wrote:

> When using the bpf_redirect_map() helper to redirect packets from XDP, 
> the eBPF
> program cannot currently know whether the redirect will succeed, which 
> makes it
> impossible to gracefully handle errors. To properly fix this will 
> probably
> require deeper changes to the way TX resources are allocated, but one 
> thing that
> is fairly straight forward to fix is to allow lookups into devmaps, so 
> programs
> can at least know when a redirect is *guaranteed* to fail because 
> there is no
> entry in the map. Currently, programs work around this by keeping a 
> shadow map
> of another type which indicates whether a map index is valid.
>
> This series contains two changes that are complementary ways to fix 
> this issue:
>
> - Moving the map lookup into the bpf_redirect_map() helper (and 
> caching the
>   result), so the helper can return an error if no value is found in 
> the map.
>   This includes a refactoring of the devmap and cpumap code to not 
> care about
>   the index on enqueue.
>
> - Allowing regular lookups into devmaps from eBPF programs, using the 
> read-only
>   flag to make sure they don't change the values.
>
> The performance impact of the series is negligible, in the sense that 
> I cannot
> measure it because the variance between test runs is higher than the 
> difference
> pre/post series.
>
> Changelog:
>
> v4:
>   - Fix a few nits from Andrii
>   - Lose the #defines in bpf.h and just compare the flags argument 
> directly to
>     XDP_TX in bpf_xdp_redirect_map().
>
> v3:
>   - Adopt Jonathan's idea of using the lower two bits of the flag 
> value as the
>     return code.
>   - Always do the lookup, and cache the result for use in 
> xdp_do_redirect(); to
>     achieve this, refactor the devmap and cpumap code to get rid the 
> bitmap for
>     selecting which devices to flush.
> v2:
>   - For patch 1, make it clear that the change works for any map type.
>   - For patch 2, just use the new BPF_F_RDONLY_PROG flag to make the 
> return
>     value read-only.
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
