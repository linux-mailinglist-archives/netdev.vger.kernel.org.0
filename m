Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 983883803C0
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 08:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhENGuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 02:50:06 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:56717 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231741AbhENGuF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 02:50:05 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailnew.nyi.internal (Postfix) with ESMTP id 6DF7E581119;
        Fri, 14 May 2021 02:48:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 14 May 2021 02:48:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=nq4wATHZa1IcXgPqo1r1s13/RAx
        BQUj7qBKm49N4hi4=; b=vVrhisulHii45TWUytq4TpjfNCSq+FeM1fXbrcnTGC6
        rMpO4+A1vq2jz0ye5q9tKC+r1u5S8hJW0ZzUMV9Xq8oDNAd6GxCBFShUBBUCEYkr
        LabevX5XTVNFZbSymm1b8s1IIshAsV76q7YLj7HXjx7ZTXRXmYo4ZB8XHpueJonZ
        R9jE3hpdUThYjPN8kkHBFF60ZKELNZN+M+YfxpHYD3CU3fyXD3026lpIDDGF6kHY
        bx2flLsyDFTmxlDs9zbMWaJF59HB0zfwUkjMWfmAiK9f1HrIbLewmtTfBUZuapkM
        dUF88HmFAom0HxwHVRRUNZ4JdZTURNYVmtbkSw7ZgDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=nq4wAT
        HZa1IcXgPqo1r1s13/RAxBQUj7qBKm49N4hi4=; b=unuQ2lBKXTbSB/MqJU3X39
        U6liNAMd66PtA0UprxVm9aIIpQBP03Azq1vyqFcxayl9TkcsBQMyTL345q2fgdWw
        KfCptKWtNB94tJKrrqMqgE8Trhfm1nHNFuGbMv69rHUTGtIWukIUNy87UGTOa4Ob
        YE4j69xZHof5Iylim1ZJ1wE6CYBYVdK+wpUjSAv5Egvc2nVHtk9Jz1jraPdYYd8/
        HGZ7jKNOgzLZ1Qp+gWLy0kynj/0RsWN7GP5mkTM+wQ/3pU8jRZ8zUNbsm9RTx/js
        1F8x40rATqYfxomemgpIypxJc+uIIsVSBsxGh6h7mLEf61EapimzI8uV8oLGMlPg
        ==
X-ME-Sender: <xms:VR2eYPo-9iIoly19HBufDAesMQqGBNaqiiITdBl4xVDy5fB1XBpyIQ>
    <xme:VR2eYJqI20GvDBiwFpfIv6KLuH6bBvEIoTJnA0Ub3HqiBBxTQt2KRp8caKChiOCX7
    pV1JFQZEk5k9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehhedguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:VR2eYMPdi7gcnakWvpNREvXNbFncghaV017Z8uxTuKTHDZ9rJ2XUHw>
    <xmx:VR2eYC4Kcgt8SNo2dik1X6clwR9Tr7BbADg0PbPvSVPhALPYIXLw4A>
    <xmx:VR2eYO5tX9c3S9wI3qgeNbzBH8Byhzr1bHK-pN-IL2cXikQuz7ENFA>
    <xmx:Vh2eYDPrk0_kjqqYaYx8-jzVxpZUQ8B-fYN_3X2Hka4PRJSgFfG_-A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Fri, 14 May 2021 02:48:53 -0400 (EDT)
Date:   Fri, 14 May 2021 08:48:51 +0200
From:   Greg KH <greg@kroah.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        syzbot <syzbot+95afd23673f5dd295c57@syzkaller.appspotmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        nic_swsd <nic_swsd@realtek.com>
Subject: Re: [syzbot] WARNING in rtl8152_probe
Message-ID: <YJ4dU3yCwd2wMq5f@kroah.com>
References: <0000000000009df1b605c21ecca8@google.com>
 <7de0296584334229917504da50a0ac38@realtek.com>
 <20210513142552.GA967812@rowland.harvard.edu>
 <bde8fc1229ec41e99ec77f112cc5ee01@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bde8fc1229ec41e99ec77f112cc5ee01@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 14, 2021 at 02:58:00AM +0000, Hayes Wang wrote:
> Alan Stern <stern@rowland.harvard.edu>
> > Sent: Thursday, May 13, 2021 10:26 PM
> [...]
> > Syzbot doesn't test real devices.  It tests emulations, and the emulated
> > devices usually behave very strangely and in very peculiar and
> > unexpected ways, so as to trigger bugs in the kernel.  That's why the
> > USB devices you see in syzbot logs usually have bizarre descriptors.
> 
> Do you mean I have to debug for a device which doesn't exist?
> I don't understand why I must consider a fake device
> which provide unexpected USB descriptor deliberately?

Because people can create "bad" devices and plug them into a system
which causes the driver to load and then potentially crash the system or
do other bad things.

USB drivers now need to be able to handle "malicious" devices, it's been
that way for many years now.

thanks,

greg k-h

