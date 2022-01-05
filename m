Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04223484F01
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 09:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238318AbiAEIIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 03:08:46 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:39713 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230005AbiAEIIn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 03:08:43 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id A0EFA58035C;
        Wed,  5 Jan 2022 03:08:42 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 05 Jan 2022 03:08:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=loyXCU6417rX16GHEn/ISzTNLPl
        e2vA9pVFu1dVyqOo=; b=vs+GGYihLVNGh92J4HffLjOA1b5Y5vtYWroHRah41Yf
        IfuEOJJGteBCGdtEn5/wvbFJqtf4SLoIKlq1c43EGMgx7MgmrutRbo177TnssWjT
        +3d9nmi2zAuXUpNluI12bpmtjZ4al+tTyA4WE1s+qcvsCcVDYvCxqbqbkYoz9ABh
        wTNW5QroKUkrHx8KjXfmLu0e+ydIvFR9gxafVaW+tv6vrgsbyHaIPaipSe3KAa5P
        KYJIHewX5YROcwrivs0AQOi93il5GG/pPHO389TPkmqAFsrwxnrdh+1lRsJznFyr
        1atNpLjkJYvj+GX8ZweLFD8lSokKmlBcsLYHRl3nnzw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=loyXCU
        6417rX16GHEn/ISzTNLPle2vA9pVFu1dVyqOo=; b=I/jBf6Fj9YqwcdykGYsuDO
        rsMrMFLqjSFGbMYGG9ykbStfXS/DZROPXYptO+MSP/1dk76b33iMrrZSnuUwqNMh
        cAS1lUTb9quD0d45F4BOB9s1a6WuaBglsNgyh6Dmn2T5BIYhzo8bi78c6F8GT6CL
        MaZz82yUuPkiZcThJGhQCJ/evvLnUDVDnOkk1muATsnodwF2T6AQicgFMxLVbBf+
        VIFLTjLx7a7O20AUvEqIVMoKv4SPYW1dIysYIjtsFZZM2wS8c1EWJbgvZFPVApO/
        HrCKcn5uKCjOoCieH/NCXdLYGu+MHwIH7j8pj1G+BWc4MGB8ghedarkPFe3lCggw
        ==
X-ME-Sender: <xms:CVLVYQLtaThXR_8yXR67VDplI-byTQLK4FTQYMvJGpnt083MTQ3u_w>
    <xme:CVLVYQLS17Ez1uGfUszHPL8cooDnaJnbcmzZR9QJl2ap7JSFM3L-JcfeTF4pVmNX4
    UTL1D44riM30g>
X-ME-Received: <xmr:CVLVYQuPyuy-2tRjGfEsa3Ijn9gkPnoVwrZ2w6X2T70sn_APiUIV5fNTTHqtp6pFj-fSZdzpUhbIKe8lav-qDkrgMfFPzuDp>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrudefgedguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:CVLVYdY1ynuihQV4ovWLFP8NzuFKffyQtWTOPD0MKtYm3MfXJTCp2g>
    <xmx:CVLVYXb0AtPFZy9w2dVR83OqzQiEUbIKZQuyznQTOnRawps4G-YC7w>
    <xmx:CVLVYZC2krFTnK49RirAq1VIgdArc21n07-jJpIjwxoQhnoDOf0lSw>
    <xmx:ClLVYUTGrMlVf-ULEyuqPNTd6le8BK3Ns3guYw19HUE91vtzbo4H2Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 5 Jan 2022 03:08:41 -0500 (EST)
Date:   Wed, 5 Jan 2022 09:08:39 +0100
From:   Greg KH <greg@kroah.com>
To:     Stefan Schmidt <stefan@datenfreihafen.org>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        "# 3.19.x" <stable@vger.kernel.org>,
        Alexander Potapenko <glider@google.com>
Subject: Re: [PATCH RFT] ieee802154: atusb: move to new USB API
Message-ID: <YdVSBy47e0+OdXAo@kroah.com>
References: <CAG_fn=VDEoQx5c7XzWX1yaYBd5y5FrG1aagrkv+SZ03c8TfQYQ@mail.gmail.com>
 <20220102171943.28846-1-paskripkin@gmail.com>
 <YdL0GPxy4TdGDzOO@kroah.com>
 <CAB_54W7HQmm1ncCEsTmZFR+GVf6p6Vz0RMWDJXAhXQcW4r3hUQ@mail.gmail.com>
 <ab1ec1c0-389c-dcae-9cd8-6e6771a94178@datenfreihafen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab1ec1c0-389c-dcae-9cd8-6e6771a94178@datenfreihafen.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 08:41:23PM +0100, Stefan Schmidt wrote:
> Hello.
> 
> On 03.01.22 16:35, Alexander Aring wrote:
> > Hi,
> > 
> > On Mon, 3 Jan 2022 at 08:03, Greg KH <greg@kroah.com> wrote:
> > > 
> > > On Sun, Jan 02, 2022 at 08:19:43PM +0300, Pavel Skripkin wrote:
> > > > Alexander reported a use of uninitialized value in
> > > > atusb_set_extended_addr(), that is caused by reading 0 bytes via
> > > > usb_control_msg().
> > > > 
> > > > Since there is an API, that cannot read less bytes, than was requested,
> > > > let's move atusb driver to use it. It will fix all potintial bugs with
> > > > uninit values and make code more modern
> > > > 
> > > > Fail log:
> > > > 
> > > > BUG: KASAN: uninit-cmp in ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
> > > > BUG: KASAN: uninit-cmp in atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
> > > > BUG: KASAN: uninit-cmp in atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
> > > > Uninit value used in comparison: 311daa649a2003bd stack handle: 000000009a2003bd
> > > >   ieee802154_is_valid_extended_unicast_addr include/linux/ieee802154.h:310 [inline]
> > > >   atusb_set_extended_addr drivers/net/ieee802154/atusb.c:1000 [inline]
> > > >   atusb_probe.cold+0x29f/0x14db drivers/net/ieee802154/atusb.c:1056
> > > >   usb_probe_interface+0x314/0x7f0 drivers/usb/core/driver.c:396
> > > > 
> > > > Fixes: 7490b008d123 ("ieee802154: add support for atusb transceiver")
> > > > Cc: stable@vger.kernel.org # 5.9
> > > > Reported-by: Alexander Potapenko <glider@google.com>
> > > > Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
> > > > ---
> > > >   drivers/net/ieee802154/atusb.c | 61 +++++++++++++++++++++-------------
> > > >   1 file changed, 38 insertions(+), 23 deletions(-)
> > > > 
> > > > diff --git a/drivers/net/ieee802154/atusb.c b/drivers/net/ieee802154/atusb.c
> > > > index 23ee0b14cbfa..43befea0110f 100644
> > > > --- a/drivers/net/ieee802154/atusb.c
> > > > +++ b/drivers/net/ieee802154/atusb.c
> > > > @@ -80,10 +80,9 @@ struct atusb_chip_data {
> > > >    * in atusb->err and reject all subsequent requests until the error is cleared.
> > > >    */
> > > > 
> > > > -static int atusb_control_msg(struct atusb *atusb, unsigned int pipe,
> > > > -                          __u8 request, __u8 requesttype,
> > > > -                          __u16 value, __u16 index,
> > > > -                          void *data, __u16 size, int timeout)
> > > > +static int atusb_control_msg_recv(struct atusb *atusb, __u8 request, __u8 requesttype,
> > > > +                               __u16 value, __u16 index,
> > > > +                               void *data, __u16 size, int timeout)
> > > 
> > > Why do you need a wrapper function at all?  Why not just call the real
> > > usb functions instead?
> 
> > ...
> 
> > > 
> > > I would recommend just moving to use the real USB functions and no
> > > wrapper function at all like this, it will make things more obvious and
> > > easier to understand over time.
> > 
> > okay.
> 
> With the small fix handle the actual KASAN report applied now

It was?  What is the git commit id?

thanks,

greg k-h
