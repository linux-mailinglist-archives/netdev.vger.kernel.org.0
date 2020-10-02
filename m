Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88CA42811AD
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 13:55:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387869AbgJBLy5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 07:54:57 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:53167 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387765AbgJBLy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 07:54:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 3E0EAA5C;
        Fri,  2 Oct 2020 07:54:55 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 02 Oct 2020 07:54:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=xtRK2xXZ/v/QUkP9zj3e/x8jRHl
        U4UVCaVvPb2DgxG4=; b=mpYT5qPrblB6kHeE4d72vu8RAsUDsA3t5Mk27Yf5XzJ
        f4oUugKCSduLv109iXqKbeF2uT8CM9lwtNXg3vf0AIpQqhcPZxsfNjIOoOK2M/JE
        Zz6/MSA3XbDhjuY05UgrW5fBIcCbYwdYiLp7bVsAXsk3C9XbuIM4v0K/X/9T0cWE
        pyRi7acAGE1Sqarj9wIObjuLWTQRD26v/VFgWhIpWU/GsU5clmp7j2VINCyTlUwF
        rQiKkyoeQgrVog2bz3PiG52qdEH9Ch/3DMOqRN3jz4tKLNjLFh+1DZO2mJQrjKYz
        0Yf3lGumjWm8FCYnKdIpyab5Pa4fiA6BAQgn7J8sy4A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=xtRK2x
        XZ/v/QUkP9zj3e/x8jRHlU4UVCaVvPb2DgxG4=; b=Ns6oCo38v3htoZZ46HHJp+
        0ndfOAdzg+SfkYWsjVmmnZ3LYYIIib4EMqXDGdPewMe2vgCEF8Cs+FI5IkFHNRfr
        3CXiw2JqrNd52Klzpf6Jyktd1J1vyFDsSG76wg93NO78QsgNzplwDhM5VrUUuK40
        rifXvUvIhA2lRMe8gRVrkj3xorETFOZXCika8iXQtONmW85H027myEkzCXxdFZ50
        bhO23rgvy27LRQi5p0bM1pu0GwZ9ctZqlGHfoy4xk8GffvH4VT2yOUVo5Ak5AP29
        SsGDsYSdDxEa7ZXBlshob9NrlsRJoL/v3MvFHAuqPTUOfIMnU3ZURIVzHKonYsUA
        ==
X-ME-Sender: <xms:DhV3X1nA-tG7JmA4GNrYz6672e4qbC9YMRLZo99gIw3Jh1dvCD5axQ>
    <xme:DhV3Xw34lXhNY1bNYF0q5KHIZWgIQ2p1mmGv2e7iB093N4eavaccrUwUftBIjPwVJ
    dRWFJUxIw8zUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrfeeigdegfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:DhV3X7qjEv4QQlNqQJEV1mqdBoQBZYSKTCuTet0JuFnZmVsCMdridA>
    <xmx:DhV3X1k-ZG0HWDkWUnYNafo8RbKvjXXIsOwKls1m9cK2HSuOWjmzhQ>
    <xmx:DhV3Xz1GAog33lwpBCDxz8fHFzMvywyqHbWtno6ziWbici93TOFUFQ>
    <xmx:DhV3X9rt7HntiM2qDPe6t7M8xZvOE2PkPwrqA6vKm7TqQdBFbx_gng>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C14CE3064683;
        Fri,  2 Oct 2020 07:54:53 -0400 (EDT)
Date:   Fri, 2 Oct 2020 13:54:53 +0200
From:   Greg KH <greg@kroah.com>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        petkan@nucleusys.com, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: rtl8150: prevent set_ethernet_addr from
 setting uninit address
Message-ID: <20201002115453.GA3338729@kroah.com>
References: <20201001073221.239618-1-anant.thazhemadam@gmail.com>
 <20201001.191522.1749084221364678705.davem@davemloft.net>
 <83804e93-8f59-4d35-ec61-e9b5e6f00323@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83804e93-8f59-4d35-ec61-e9b5e6f00323@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 02, 2020 at 05:04:13PM +0530, Anant Thazhemadam wrote:
> 
> On 02/10/20 7:45 am, David Miller wrote:
> > From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> > Date: Thu,  1 Oct 2020 13:02:20 +0530
> >
> >> When get_registers() fails (which happens when usb_control_msg() fails)
> >> in set_ethernet_addr(), the uninitialized value of node_id gets copied
> >> as the address.
> >>
> >> Checking for the return values appropriately, and handling the case
> >> wherein set_ethernet_addr() fails like this, helps in avoiding the
> >> mac address being incorrectly set in this manner.
> >>
> >> Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> >> Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> >> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
> >> Acked-by: Petko Manolov <petkan@nucleusys.com>
> > First, please remove "Linux-kernel-mentees" from the Subject line.
> >
> > All patch submitters should have their work judged equally, whoever
> > they are.  So this Subject text gives no extra information, and it
> > simply makes scanning Subject lines in one's mailer more difficult.
> I will keep that in mind for all future submissions. Thank you.
> 
> > Second, when a MAC address fails to probe a random MAC address should
> > be selected.  We have helpers for this.  This way an interface still
> > comes up and is usable, even in the event of a failed MAC address
> > probe.
> 
> Okay... I see.
> But this patch is about ensuring that an uninitialized variable's
> value (whatever that may be) is not set as the ethernet address
> blindly (without any form of checking if get_registers() worked
> as expected, or not). And I didn't think uninitialized values being
> set as MAC address was considered a good outcome (after all, it
> seemed to have triggered a bug), especially when it could have
> been avoided by introducing a simple check that doesn't break
> anything.

If the read from the device for the MAC address fails, don't abort the
whole probe process and make the device not work at all, call the
networking core to assign a random MAC address.

> However, if I was mistaken, and if that is something that we can live
> with after all, then I don't really see the understand the purpose of
> similar checks being made (in all the many places that the return
> value of get_registers() (or a similar function gets checked) in the first
> place at all.

Different values and registers determine what should be done with an
error.  It's all relative.

For this type of error, we should gracefully recover and keep on going.
For others, maybe we just ignore the issue, or log it, or something
else, it all depends.

hope this helps,

greg k-h
