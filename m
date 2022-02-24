Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2B3A4C2B35
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 12:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234111AbiBXLyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 06:54:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbiBXLyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 06:54:06 -0500
X-Greylist: delayed 599 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 24 Feb 2022 03:51:53 PST
Received: from wnew1-smtp.messagingengine.com (unknown [64.147.123.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F48F457A4;
        Thu, 24 Feb 2022 03:51:51 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id EF73B2B01789;
        Thu, 24 Feb 2022 06:34:03 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Thu, 24 Feb 2022 06:34:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=IW6ZF7jJlvH0wnSPVJN305buP+XUnsj/j2eLpQ
        e9IRA=; b=fyq4KR64kAUkX1w4kjHgqt6y2G5Yzr0CK9WMz/ZLHTc2XDCLOGpHGG
        bC2UBwU3mPf8mTvq6doDnGaQBIxAGFXbzWMwIwSdQE3mVSM/mhbvTWr/bF4wZ5Tm
        kC9N+IRGUfD2nhlhwdC2qv7D+/GFkhOQP7c4jD4IWinW0ysmz+DgqxumbaEjJKPI
        xwMzuTv8RbvhbY9j3lxNQxkaaZFBaKjVLSGvVaf9VD2yvk/Ijz2bzLk4uuvo6ep1
        D+L3pLBmH550om7F02JMG7kv3dGGiOzoJOTk9uqgQciy+CLQXnWFeZRJ4xFZVFv0
        od3BunfUoRISe23G5RGFDSd57grE4zyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=IW6ZF7jJlvH0wnSPV
        JN305buP+XUnsj/j2eLpQe9IRA=; b=W1yQ8dqf5MusPM/VuBD1og+qv0ByHaoeN
        SypZYFaPyLr1cZgMdQqp6I52mwFaTbB42C2UlBsrYJgvb0eXU156XRQ5YqfnBNHo
        Q8gZN0/y5igYQRLWFrINYDE63ACCnv4AbzGFRmZSFFJ4nyZVHXEVDJ5gM8A/Jdx8
        vNJHvI5SM1dPlYSXuZvrKbQBFCDXcZ9w8KTTU3tX+mxzMomQT1l9yHuEOsyWQWNw
        Jaq//zQsRX2b+Rs3/g6S8RbPh5ym8ZJCfU53Foezq5q8PZHUj+aKD53uh5EvOBLB
        hUFtuOhvYJtWq7tZACmOhCCikB50N/Wv9WDNRgMyzBNfnFqEM34NQ==
X-ME-Sender: <xms:Km0XYqG1JGN9f31kSGe0b--yiWe9O6_4wdTlN3M_VfDMNLmhswHi_Q>
    <xme:Km0XYrUXMoiGArpDio6JDH_ZKbSjNadUq3IzKrZRL0Ay0IUwAma0Edku9o3rRe_Zg
    bgeTFYfxK058w>
X-ME-Received: <xmr:Km0XYkIO3caPr1J9Rr7GbF6YDZUJ95eriB1w-NcxWNwij8Uspue3CitaLVySdZBvrjYCe1Ps83Kzd0MzBkN0c_j7_Q8cCX4k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrledvgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:K20XYkHKqezn-B2fQnhQRNFYvP3gjBIRR024DSiXURnn5ANMMU-80Q>
    <xmx:K20XYgVIMV41dw6TkHECwcAcrrMCMLvPXoXBhc142qQ4MR56GIucjQ>
    <xmx:K20XYnPEMp2ylJleWvT5dAruf1uSCPRoGmpItBiOjSjkrf_Bsd47sw>
    <xmx:K20XYpUrME8rdFLEUSvF3kucOFhBvJ1kHdkCJtbG7BYAQy2qc7b2aHuDGJY>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 24 Feb 2022 06:34:02 -0500 (EST)
Date:   Thu, 24 Feb 2022 12:34:00 +0100
From:   Greg KH <greg@kroah.com>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v1 1/6] HID: initial BPF implementation
Message-ID: <YhdtKN7qodX7VDPV@kroah.com>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com>
 <20220224110828.2168231-2-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220224110828.2168231-2-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RDNS_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 24, 2022 at 12:08:23PM +0100, Benjamin Tissoires wrote:
> index 000000000000..243ac45a253f
> --- /dev/null
> +++ b/include/uapi/linux/bpf_hid.h
> @@ -0,0 +1,39 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later WITH Linux-syscall-note */
> +
> +/*
> + *  HID BPF public headers
> + *
> + *  Copyright (c) 2021 Benjamin Tissoires
> + */
> +
> +#ifndef _UAPI__LINUX_BPF_HID_H__
> +#define _UAPI__LINUX_BPF_HID_H__
> +
> +#include <linux/types.h>
> +
> +#define HID_BPF_MAX_BUFFER_SIZE		16384		/* 16kb */
> +
> +struct hid_device;
> +
> +enum hid_bpf_event {
> +	HID_BPF_UNDEF = 0,
> +	HID_BPF_DEVICE_EVENT,
> +};
> +
> +/* type is HID_BPF_DEVICE_EVENT */
> +struct hid_bpf_ctx_device_event {
> +	__u8 data[HID_BPF_MAX_BUFFER_SIZE];
> +	unsigned long size;

That's not a valid type to cross the user/kernel boundry, shouldn't it
be "__u64"?  But really, isn't __u32 enough here?

thanks,

greg k-h
