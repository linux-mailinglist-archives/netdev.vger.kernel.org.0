Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB355497CDE
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 11:21:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233901AbiAXKVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 05:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232375AbiAXKVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 05:21:19 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93881C06173B
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 02:21:18 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id c2so22568977wml.1
        for <netdev@vger.kernel.org>; Mon, 24 Jan 2022 02:21:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oldum-net.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=KYtcGh/GP1tUxyaiLE2ChD6/79iw+Jj7+TlYu6cXTHs=;
        b=IO/7ufLJr1PCy+LIahgnJ9KS8S4l3QuZqAd+G1gHMxcPac+HaAaEP00kwNheaxRMIO
         qSsElsnXrY09z1dPDcaKFiZwbxsHsAoKiRqVUdYNaZgDB0F+M+xzG042aanrfZ+/QFZ0
         Hii8sjT9IBgisPugfl6Wumix4vj59yUfEj62Gh1T+Z2mgUlQRcaurDAPEjojgQC9+MZR
         5jvNBlMdM8CW0uWlr5NKrSA3UWoGHcwIoEG3i80ZQ232gHAli1JmKbzC+Y8aub/kKIty
         bbyME4jjnbZjuB7Gsb+l6RCoQBF350npuvBxzbWFURcBTUXITKOvyw7LhvdAyjF46F/B
         hiew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=KYtcGh/GP1tUxyaiLE2ChD6/79iw+Jj7+TlYu6cXTHs=;
        b=1ZQjuUNXOZZqI7fJJqXFCrw3/FbbY59S2GWriMh2jQFr1lFkSlhd3sXUPXJpIMfifo
         WG53xEZ0xlKIb64BR+kSKxbu9dW3aRhbJD08H8+sR8PMYhWNILjpCPVP65iEBvLFa4j6
         sM1/p16O6l/AdPguXLJog05bITJd8bJqbKxNcXzXl+Jnw9iTWmpuHGMydLQbnduDDDAE
         XpbH9F1MvLVcCugd91OZoKem92npxGqJl75sp0RQAIXr/WZ5xP+7HxNOGNv2r95FlfEz
         mMbaIiDhxowQtkNOCZTgRqQsBBDA6n/n/m6i9Yvcj/7BRixAwq0hG0YiO43/ceMenrxU
         IuvQ==
X-Gm-Message-State: AOAM531uXJ2cK/GkO6sCQJvkEEDLLyu3J0CsGNDjjtFDnrLAQ/Xuozpn
        rOF0qhEAvLtFjD0M8MI9awiFNg==
X-Google-Smtp-Source: ABdhPJx4OY3XdRL9HGCJWwspd4Mbl1sOgQjdVhzOAnEt4MWMpUts+IxcHA1Cx+T+h6Kbr9s8h2vLlg==
X-Received: by 2002:a05:600c:19cf:: with SMTP id u15mr1130233wmq.39.1643019676925;
        Mon, 24 Jan 2022 02:21:16 -0800 (PST)
Received: from [10.98.7.9] ([149.235.255.6])
        by smtp.googlemail.com with ESMTPSA id l13sm14756741wrs.109.2022.01.24.02.21.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 02:21:16 -0800 (PST)
Message-ID: <5111aae45d30df13e42073b0af4f16caf9bc79f0.camel@oldum.net>
Subject: Re: [PATCH v4 00/12] remove msize limit in virtio transport
From:   Nikolay Kichukov <nikolay@oldum.net>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org,
        Dominique Martinet <asmadeus@codewreck.org>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Greg Kurz <groug@kaod.org>, Vivek Goyal <vgoyal@redhat.com>
Date:   Mon, 24 Jan 2022 11:21:08 +0100
In-Reply-To: <1835287.xbJIPCv9Fc@silver>
References: <cover.1640870037.git.linux_oss@crudebyte.com>
         <29a54acefd1c37d9612613d5275e4bf51e62a704.camel@oldum.net>
         <1835287.xbJIPCv9Fc@silver>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Christian,
It works, sorry for overlooking the 'known limitations' in the first
place. When do we expect these patches to be merged upstream?

Cheers,
-N


On Sat, 2022-01-22 at 14:34 +0100, Christian Schoenebeck wrote:
> On Donnerstag, 20. Januar 2022 23:43:46 CET Nikolay Kichukov wrote:
> > Thanks for the patches. I've applied them on top of 5.16.2 kernel
> > and it
> > works for msize=1048576. Performance-wise, same throughput as the
> > previous patches, basically limiting factor is the backend block
> > storage.
> 
> Depends on how you were testing exactly. I assume you just booted a
> guest and 
> then mounted a humble 9p directory in guest to perform some isolated
> I/O 
> throughput tests on a single file. In this test scenario yes, you
> would not 
> see much of a difference between v3 vs. v4 of this series.
> 
> However in my tests I went much further than that by running an entire
> guest 
> on top of 9p as its root filesystem:
> https://wiki.qemu.org/Documentation/9p_root_fs
> With this 9p rootfs setup you get a completely different picture. For
> instance 
> you'll notice with v3 that guest boot time *increases* with rising
> msize, 
> whereas with v4 it shrinks. And also when you benchmark throughput on
> a file 
> in this 9p rootfs setup with v3 you get worse results than with v4,
> sometimes 
> with v3 even worse than without patches at all. With v4 applied though
> it 
> clearly outperforms any other kernel version in all aspects.
> 
> I highly recommend this 9p rootfs setup as a heterogenous 9p test
> environment, 
> as it is a very good real world test scenario for all kinds of
> aspects.
> 
> > However, when I mount with msize=4194304, the system locks up upon
> > first
> > try to traverse the directory structure, ie 'ls'. Only solution is
> > to
> > 'poweroff' the guest. Nothing in the logs.
> 
> I've described this in detail in the cover letter under "KNOWN
> LIMITATIONS" 
> already. Use max. msize 4186112.
> 
> > Qemu 6.0.0 on the host has the following patches:
> > 
> > 01-fix-wrong-io-block-size-Rgetattr.patch
> > 02-dedupe-iounit-code.patch
> > 03-9pfs-simplify-blksize_to_iounit.patch
> 
> I recommend just using QEMU 6.2. It is not worth to patch that old
> QEMU 
> version. E.g. you would have a lousy readdir performance with that
> QEMU 
> version and what not.
> 
> You don't need to install QEMU. You can directly run it from the build
> directory.
> 
> > The kernel patches were applied on the guest kernel only.
> > 
> > I've generated them with the following command:
> > git diff
> > 783ba37c1566dd715b9a67d437efa3b77e3cd1a7^..8c305df4646b65218978fc647
> > 4aa0f5f
> > 29b216a0 > /tmp/kernel-5.16-9p-virtio-drop-msize-cap.patch
> > 
> > The host runs 5.15.4 kernel.
> 
> Host kernel version currently does not matter for this series.
> 
> Best regards,
> Christian Schoenebeck
> 
> 

