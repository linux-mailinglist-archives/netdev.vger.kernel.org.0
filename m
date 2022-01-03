Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5241348313C
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 14:04:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiACNEb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 08:04:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34126 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbiACNEa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 08:04:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50CE6B80EC9;
        Mon,  3 Jan 2022 13:04:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C951C36AEB;
        Mon,  3 Jan 2022 13:04:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641215068;
        bh=G9yBPxqi2rlVdbB+i4diWtdjmgeT/eOXzQVYwsumJqY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RUzTCjAzawfeNetbpl6NGKT1rqm8pZpzWGz+6Wd5O+xcIJamyngKS/WKOpxx6GkHz
         jVTwI6n05FrS0IA86Zx3qB3QFgZpWF++RrUNfQAD7PpewvLjiJ676Il58WLre1Tu3b
         kUzTdOUsX7IcRMyMvPnWalXo0CfG8MoYcTYBx9Ho=
Date:   Mon, 3 Jan 2022 14:04:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Pavel Skripkin <paskripkin@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "# 3.19.x" <stable@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH RFT] ieee802154: atusb: move to new USB API
Message-ID: <YdL0WHrRZpz9tJjX@kroah.com>
References: <CAG_fn=VDEoQx5c7XzWX1yaYBd5y5FrG1aagrkv+SZ03c8TfQYQ@mail.gmail.com>
 <20220102171943.28846-1-paskripkin@gmail.com>
 <CAB_54W6i9-fy8Vc-uypXPtj3Uy0VuZpidFuRH0DVoWJ8utcWiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB_54W6i9-fy8Vc-uypXPtj3Uy0VuZpidFuRH0DVoWJ8utcWiw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 02, 2022 at 05:15:38PM -0500, Alexander Aring wrote:
> Hi,
> 
> On Sun, 2 Jan 2022 at 12:19, Pavel Skripkin <paskripkin@gmail.com> wrote:
> >
> > Alexander reported a use of uninitialized value in
> > atusb_set_extended_addr(), that is caused by reading 0 bytes via
> > usb_control_msg().
> >
> 
> Does there exist no way to check on this and return an error on USB
> API caller level?
> 
> > Since there is an API, that cannot read less bytes, than was requested,
> > let's move atusb driver to use it. It will fix all potintial bugs with
> > uninit values and make code more modern
> >
> 
> If this is not possible to fix with the "old" USB API then I think the
> "old" USB API needs to be fixed.

We can not get rid of the "old" api calls, as sometimes they are needed
for some corner cases where you want to know if you read/wrote a
shorter/larger message than expected.

> Changing to the new USB API as "making the code more modern" is a new
> feature and is a candidate for next.

Fixing bugs is a good thing to do no matter when it happens.

thanks,

greg k-h
