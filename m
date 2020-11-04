Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2A62A5FE8
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 09:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbgKDIwT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 03:52:19 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:51275 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728523AbgKDIwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 03:52:18 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 7A5E55C00A6;
        Wed,  4 Nov 2020 03:52:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 04 Nov 2020 03:52:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm2; bh=Y
        8LJ5umULDHAIpEYaXzyYeM+GS4L5A6niQs7elTurAE=; b=X8geIWFVc1/enc9Ho
        +ZdZEKemTJP7yP1wY2nb/FikyTeMZPJRwLwSaZhDG9cqaNAJNvgKDTzjPft68vT8
        bNtjgz1wrfAMFC2YqAqROld+++9CoJfsEvRfvj+BBtEcCzRlH/qJ3ZhW9hoqnM08
        Z150cRbqaPvNHVYYP4vlPE3Srl2o3ynA65QwUspHAoQY9N2a7p+FnImScpVt3VZp
        G+eCBOayLrRmrK5M4lRnB3/rPP38a8nvPpQnnfWSkIcIgLVltm+Hk8Fm7TSYMCPO
        Nu5R2icMqZgB8xAL7jJsIJu51jwzeCoulTEpax80Uami6DxoQhOCDPxLvts9Pbi8
        lYypg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=Y8LJ5umULDHAIpEYaXzyYeM+GS4L5A6niQs7elTur
        AE=; b=mhd6PTlXl4YyghcUHJUAyONiaEd8vzgAPv7k5CXFKUdG8o6VQYI3QLlAg
        Tw5rBZjrCIs3j0gxuKMNjfenfe5E8Kr0vQ5Uz5A+NX5pwfhxOiA94vbw82X9b0XB
        gUQv6MdXHPIDB48ysJZmqXczv5mODXTu2hSKq3MdJX+E5On3nurRFUFb76cfzs22
        RbdlvWqRKXUC0cC96ZNqiXu4cLYyZbZURxV7lQhtuGaqvZgd1e5dW6PBnbEDi4gW
        4dcEHtk1FbYhBlvOpKRWsht8pyTRTax+9eD41anoSiWJVSNysBosZJuQEDkP4QxO
        knT8o2E9KZjvwxxY7/khaMjm4nuAQ==
X-ME-Sender: <xms:v2uiX5kPXNZ3ByUyuDm86hQrAySCUVL6MrivtPnOxNLAPH2w5mUCfg>
    <xme:v2uiX002OFLdYNTo4PLqoL_BSZRfFQOmwWzJwvt8xT2KWsPr8eILLYc8GlH1j8-Rq
    H2cHTvJKMp54A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddtgedguddvvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevtd
    eileeuteeggefgueefhfevgfdttefgtefgtddvgeejheeiuddvtdekffehffenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:wGuiX_qkFE9SeF7B7FSMnGNhL8rGmEKX84uFMw73lT-l-TxyeHLylw>
    <xmx:wGuiX5lGXl95kBoR72KA4TWzuZTwtamdComPjp1xpTEzZGs5AjMHeA>
    <xmx:wGuiX31J4U0ebWtnqF88HYFfew8-cVqqo8RNbYLDAKyqGmyEjB1pMQ>
    <xmx:wGuiXw8sdC_NncpKb0admznhj5DR5FFiYzAzwINoMQvPMc8Sxece-g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6FD943064680;
        Wed,  4 Nov 2020 03:52:15 -0500 (EST)
Date:   Wed, 4 Nov 2020 09:53:07 +0100
From:   Greg KH <greg@kroah.com>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: [PATCH net-next 1/5] r8152: use generic USB macros to define
 product table
Message-ID: <20201104085307.GA1028805@kroah.com>
References: <20201103192226.2455-1-kabel@kernel.org>
 <20201103192226.2455-2-kabel@kernel.org>
 <b83ddcca96cb40cf8785e6b44f9838e0@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b83ddcca96cb40cf8785e6b44f9838e0@realtek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 01:57:10AM +0000, Hayes Wang wrote:
> Marek Behún <kabel@kernel.org>
> > Sent: Wednesday, November 4, 2020 3:22 AM
> > diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> > index b1770489aca5..85dda591c838 100644
> > --- a/drivers/net/usb/r8152.c
> > +++ b/drivers/net/usb/r8152.c
> > @@ -6862,20 +6862,12 @@ static void rtl8152_disconnect(struct
> > usb_interface *intf)
> >  }
> > 
> >  #define REALTEK_USB_DEVICE(vend, prod)	\
> > -	.match_flags = USB_DEVICE_ID_MATCH_DEVICE | \
> > -		       USB_DEVICE_ID_MATCH_INT_CLASS, \
> > -	.idVendor = (vend), \
> > -	.idProduct = (prod), \
> > -	.bInterfaceClass = USB_CLASS_VENDOR_SPEC \
> > +	USB_DEVICE_INTERFACE_CLASS(vend, prod, USB_CLASS_VENDOR_SPEC)
> > \
> >  }, \
> >  { \
> > -	.match_flags = USB_DEVICE_ID_MATCH_INT_INFO | \
> > -		       USB_DEVICE_ID_MATCH_DEVICE, \
> > -	.idVendor = (vend), \
> > -	.idProduct = (prod), \
> > -	.bInterfaceClass = USB_CLASS_COMM, \
> > -	.bInterfaceSubClass = USB_CDC_SUBCLASS_ETHERNET, \
> > -	.bInterfaceProtocol = USB_CDC_PROTO_NONE
> > +	USB_DEVICE_AND_INTERFACE_INFO(vend, prod, USB_CLASS_COMM, \
> > +				      USB_CDC_SUBCLASS_ETHERNET, \
> > +				      USB_CDC_PROTO_NONE)
> > 
> >  /* table of devices that work with this driver */
> >  static const struct usb_device_id rtl8152_table[] = {
> 
> I don't use these, because checkpatch.pl would show error.
> 
> 	$ scripts/checkpatch.pl --file --terse drivers/net/usb/r8152.c
> 	ERROR: Macros with complex values should be enclosed in parentheses

checkpatch is wrong.
