Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEF6732FB5E
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 16:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230425AbhCFPel (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 10:34:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbhCFPeL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 10:34:11 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E20DC06174A
        for <netdev@vger.kernel.org>; Sat,  6 Mar 2021 07:34:08 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id p1so7401918edy.2
        for <netdev@vger.kernel.org>; Sat, 06 Mar 2021 07:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=SQ30eMA6RhuA0taoMsUKUyHVlgrwjZzvoU0yEGveTv0=;
        b=PdFRZP24ad66D56cq1uOxI0VLbBOEp30DG1rDKQ1nsuqiFA2mHJHZzS2KDqNVyVoRl
         VkWBiZD39eeHLR/gcaxaJI3yhnf7JRWeJdOlynmS3p7SFsqsuovlrJl6H8mrO7zlnbvY
         xmolRStvDdV4F5VmvGcCHPFpLl+RZv9xwstlpIsm66vAjqrhWz8qfHiL6XoVyHdYv0bC
         MfYDnkjBihSk9YqIh3CXPim93oVQGvc2rrBD6PZfH/JoXmqg5NbCEzxX2c4TI4lGEsq/
         9/sordhrhPtvOg8VXlfUry0E6B1uxLR2TWBY3ODJQO1jxSfpP74RDDqSUQ9HV3I56EPJ
         bDoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=SQ30eMA6RhuA0taoMsUKUyHVlgrwjZzvoU0yEGveTv0=;
        b=s2EdNmFR68JAmTcxjlR8oTLXAHld1U4aBfNz7hsjeBXdG8RfdjK7bY0gyAU6uJDSsQ
         hguKiKioNW/WXAY8PsCx94eC4SUx5RL7WkXxalxFLlGorwLlx+WSL1WIgEWXeHSaGTys
         OXTlvnxCrwOxEhenaFaiLWRK/sn2lND87PGI5INdpyWNvPtLs1NsNXstqTJRm74ay+nk
         oJBh2IlKR0Sre/+21cqrrrBQRfIWb26XjdAL82BV3DAbe6sRi4YQmqzb4zV0AfpJ/zXP
         eYI09KOaEGxCpa/ohh531aeuXcw7lS7euxGqpC6ycpe01as+22yp9MfIB1WcY9EjFBPZ
         7LSQ==
X-Gm-Message-State: AOAM532zcI+G1cHs5zwm09lxpfJm5S+wueEKt7nU058x/nalmjyTa6aI
        07/hbmxL30C3IkRUj6rxrpOP76D4hOtH5mR8xhnf4059S+M=
X-Google-Smtp-Source: ABdhPJy57kR9tcmwWWpSf1NSRd3KX5jij0qRNISdlTFc1kXxPzshd3WZOZNJ1Ozy668e70nuf43m325ziv6zUosXPlQ=
X-Received: by 2002:aa7:c6d2:: with SMTP id b18mr14164851eds.183.1615044846611;
 Sat, 06 Mar 2021 07:34:06 -0800 (PST)
MIME-Version: 1.0
From:   Jax Jiang <jax.jiang.007@gmail.com>
Date:   Sat, 6 Mar 2021 23:33:57 +0800
Message-ID: <CAGCQqYbjG5_jxsC3+ONTRg=ow8BqWvkau2j4k=Fs+-hzsyYFjQ@mail.gmail.com>
Subject: [BUG] Thunderbolt network package forward speed problem.
To:     michael.jamet@intel.com, mika.westerberg@linux.intel.com,
        YehezkelShB@gmail.com
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!
Authors of Linux thunderbolt-network driver:

Problem:

Thunderbolt network <- Software Router(NUC 11) <- 10G NIC   Speed is normal=
 about 9-10Gbps
Thunderbolt network -> Software Router(NUC 11) -> 10G NIC   Speed is super =
slow about 1Mbps-100Kbps

Thunderbolt network <- Software Router(NUC 11) <- 2.5G NIC(I225-V)   Speed =
is normal about 2.3-2.4Gbps
Thunderbolt network -> Software Router(NUC 11) -> 10G NIC   Speed is super =
slow about 1Mbps-100Kbps

I have already tested:
MAC<-> Thunderbolt network <-> Software Router(NUC11)     17Gpbs on both tw=
o direction.

Hardware: Intel NUC11 I5
CPU: Intel TigerLake 1135G7 4Core 8Thread
OS:  OpenWRT 19.07
Linux Kernel Version: 5.10.20
Already Tested Software that have problem: iperf3 smb
Network Layout:

 PC(With 2.5G NIC)

           ^

           |

           v
[macbook pro] <-----thunderbolt 3------------> Software
Router<---------------> NAS(With 10G NIC)
                           thunderbolt network         (NUC11 With 10G NIC)

I met problem like this in some network switch which does not support flow =
control.
So I guess maybe thunderbolt-network driver miss flow control support.

I am try to build a software router with using latest NUC hardware. Use thu=
nderbolt network to trans 10G NIC card or 2.5G NIC to latest having thunder=
bolt port laptop or devices. Latest intel mobile chip had internal thunderb=
olt controller, which is cheaper than previous devices. I think it=1B$B!G=
=1B(Bs a chance to bring high speed network to general consumer.
I am a coder but not familiar with Linux kernel source code.
At same time I am a want to build a cool product geek.
Any help would be great  ;-)

Thanks

A want to build a geek products geek.
Jax
