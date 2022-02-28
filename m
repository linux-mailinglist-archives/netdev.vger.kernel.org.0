Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 897BD4C71CA
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 17:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237954AbiB1Qei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 11:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237943AbiB1Qef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 11:34:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB3A146B24;
        Mon, 28 Feb 2022 08:33:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 642596123C;
        Mon, 28 Feb 2022 16:33:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2BF2C340E7;
        Mon, 28 Feb 2022 16:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646066035;
        bh=5TnaHWBObWPu9LztXoyemUFcbfrnH0z+xI99F3n3R8g=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=kZ7m26CkOlcamcJdE9TffN0PMCAyW+ITFSrvbw+O5Isw9bz+NzyxDoTqwC2Vx70/l
         dI+voha1t1y0FCt5boFo/mFFvqOweUkVd64clVQVww3Dfl+irtWa2J8hfSj08w+tw4
         SqkvSmHe6m++E1niteZAnImg6RU/XmxMKbFgfiOP1f4lE8HGkR2xzafac0ZuxYfzPu
         yISiQuBFePoqFsZnNMSf/zNmjhHoN7XMOYrqIXaa5YcDJfiQj3ZOfopuPhSRzCmPIj
         KawGoJ3iGh/jLrPQQHu/Mr3+j2Ik+onCBFgt5xR8kl68ALhhWpHzMK5b/LgEbHe0OF
         htDcjt9pjubFg==
Date:   Mon, 28 Feb 2022 17:33:49 +0100 (CET)
From:   Jiri Kosina <jikos@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
cc:     Benjamin Tissoires <benjamin.tissoires@redhat.com>,
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
        lkml <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Peter Hutterer <peter.hutterer@redhat.com>
Subject: Re: [PATCH bpf-next v1 0/6] Introduce eBPF support for HID devices
In-Reply-To: <YhkEqpF6QSYeoMQn@kroah.com>
Message-ID: <nycvar.YFH.7.76.2202281733000.11721@cbobk.fhfr.pm>
References: <20220224110828.2168231-1-benjamin.tissoires@redhat.com> <YhdsgokMMSEQ0Yc8@kroah.com> <CAO-hwJJcepWJaU9Ytuwe_TiuZUGTq_ivKknX8x8Ws=zBFUp0SQ@mail.gmail.com> <YhjbzxxgxtSxFLe/@kroah.com> <CAO-hwJJpJf-GHzU7-9bhMz7OydNPCucTtrm=-GeOf-Ee5-aKrw@mail.gmail.com>
 <YhkEqpF6QSYeoMQn@kroah.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Feb 2022, Greg KH wrote:

> > I mean that if you need a bpf program to be loaded from userspace at
> > boot to make your keyboard functional, then you need to have the root
> > partition mounted (or put the program in the initrd) so udev can load
> > it. Now if your keyboard is supposed to give the password used to
> > decrypt your root partition but you need a bpf program on that said
> > partition to make it functional, you are screwed :)
> 
> True, but that's why the HID boot protocol was designed for keyboards
> and mice, so that they "always" work.  Yeah, I know many devices ignore
> it, oh well...

That's a very mild statement :)

*Most* of the recent modern HW doesn't support it as far as I can say.

Thanks,

-- 
Jiri Kosina
SUSE Labs

