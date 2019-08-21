Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D700497597
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726863AbfHUJF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 05:05:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45550 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbfHUJF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 05:05:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id q12so1240235wrj.12
        for <netdev@vger.kernel.org>; Wed, 21 Aug 2019 02:05:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=fQeTw8XVpz3MXJ+9QKUltKbufjCfYbnuGVJHHdsUDLI=;
        b=eN2sJxBYytWmV3/n076E7pwNxHyBqPih6k1yaMTSgWesLfORTfAQd/TyGk2BSf6eDw
         OTh9CSsPjuOfOv+ZYebNkiivlWNXMt3AWrscTv4UmcqfK3bvUEiI9sjHdDpJ5U1JrXtG
         PVfMJKDMCk7WSQ0dnvEFFQiJS+Rwz3XRCMLCflYtp7yecqs+fBoJ9udb+dMYH7Ka9+VE
         iaBGNJmfnZSOqQVqUEKnIQjlYppxz9AotT+CDtLRDn5JYGqQy9GibuJ8n/zwK3KZoy+1
         yFN/6kJyjNUE/X4QgWakwmg3FJEgjx8TyiP/2HLaWHDxdIRt39KUcrClx9ExN44FOYAj
         sQDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=fQeTw8XVpz3MXJ+9QKUltKbufjCfYbnuGVJHHdsUDLI=;
        b=Z15yKzcUJQd36IEQsZpNs9lVnzYtQUF/ukMjmd42r7pNceaiSCU07D8bOAmAYd1ns+
         l12As5xoFuVa7fxk2q1fCm81J/TnvDy3weuU4lAc8IbPAGXPLB/2w4Vp5xsOGPnXK1Qh
         nOPRF35KpLi50U/atN7VOZY6C655+JXKzDZBbHdQs2Olrt3NxhoSx3y41XCRvxHNXrMm
         qIDxcY54sAvn/9VdSrRMS08hUQWI4WQkDAagxC8eleqjTk0Rnyd0XpfgGVR8kJqkT9zB
         182YZ6J21J6Lw0oe5g98Tglm68H+5TXeBJ0NZHRB1VExFMi5VEJMc6hqfd6elcEJ7fPx
         2xYw==
X-Gm-Message-State: APjAAAWws2YIeeSTRQ2BypfVvYLHepQrsWqvPc9yucxoofIpEbIM9Zx7
        oZ5Fs+oPodvOtEVq8jDJn/EhVvBfpDM=
X-Google-Smtp-Source: APXvYqyjvAvT4fg2ukxmE0qZ9tQtEBd7iI0jte/BSRbLASZkZ+xMjQBSSJvfCpxW0Oo/+1F7zkzQbQ==
X-Received: by 2002:adf:ed4a:: with SMTP id u10mr14236353wro.284.1566378355151;
        Wed, 21 Aug 2019 02:05:55 -0700 (PDT)
Received: from LAPTOP-V3S7NLPL ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id 91sm64065796wrp.3.2019.08.21.02.05.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 21 Aug 2019 02:05:54 -0700 (PDT)
References: <20190813171018.28221-1-naveen.n.rao@linux.vnet.ibm.com> <1566376025.68ldwx3wc7.naveen@linux.ibm.com>
User-agent: mu4e 0.9.18; emacs 25.2.2
From:   Jiong Wang <jiong.wang@netronome.com>
To:     "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiong Wang <jiong.wang@netronome.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org
Subject: Re: [RFC PATCH] bpf: handle 32-bit zext during constant blinding
In-reply-to: <1566376025.68ldwx3wc7.naveen@linux.ibm.com>
Date:   Wed, 21 Aug 2019 10:05:53 +0100
Message-ID: <87y2zmubv2.fsf@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Naveen N. Rao writes:

> Naveen N. Rao wrote:
>> Since BPF constant blinding is performed after the verifier pass, there
>> are certain ALU32 instructions inserted which don't have a corresponding
>> zext instruction inserted after. This is causing a kernel oops on
>> powerpc and can be reproduced by running 'test_cgroup_storage' with
>> bpf_jit_harden=2.
>> 
>> Fix this by emitting BPF_ZEXT during constant blinding if
>> prog->aux->verifier_zext is set.
>> 
>> Fixes: a4b1d3c1ddf6cb ("bpf: verifier: insert zero extension according to analysis result")
>> Reported-by: Michael Ellerman <mpe@ellerman.id.au>
>> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
>> ---
>> This approach (the location where zext is being introduced below, in 
>> particular) works for powerpc, but I am not entirely sure if this is 
>> sufficient for other architectures as well. This is broken on v5.3-rc4.
>
> Alexie, Daniel, Jiong,
> Any feedback on this?

The fix on BPF_LD | BPF_IMM | BPF_DW looks correct to me, but the two other
places looks to me is unnecessary, as those destinations are exposed to
external and if they are used as 64-bit then there will be zext inserted
for them.

Have you verified removing those two fixes will still cause the bug?

Regards,
Jiong

>
> - Naveen

