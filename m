Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 249B04B1014
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242722AbiBJORv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:17:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242718AbiBJORu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:17:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64683F5;
        Thu, 10 Feb 2022 06:17:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F3EC4618F7;
        Thu, 10 Feb 2022 14:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10849C004E1;
        Thu, 10 Feb 2022 14:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644502670;
        bh=F2jco4umO41jqvhPHCc98q52Dx6qp1ImOp6/7sup8FU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sH2mfjWOO2Vq7KwO9/5Pb8s/hKmpdJBbLx6rqM0meoAToUI/UkcsWqZHD/A1s/5dQ
         1JpPRrdfHpkiHMc3ojcnQAG7rrtFKZhCg/gTORPe8ztjAka6vdkwvc8WPqFqxNAjYs
         XWHPHstC1oMHOAqGPPOx56YRQZiqJUvHjqsVOQGI=
Date:   Thu, 10 Feb 2022 15:17:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Oliver Neukum <oneukum@suse.com>
Cc:     bids.7405@bigpond.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [PATCH] USB: zaurus: support another broken Zaurus
Message-ID: <YgUei+MqkHAE2Oet@kroah.com>
References: <20220210122643.12274-1-oneukum@suse.com>
 <YgUL6y4F34ZgC2K/@kroah.com>
 <6d5a8cb4-1823-cecb-a31e-2118a95c96a6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d5a8cb4-1823-cecb-a31e-2118a95c96a6@suse.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 03:13:49PM +0100, Oliver Neukum wrote:
> 
> On 10.02.22 13:58, Greg KH wrote:
> > On Thu, Feb 10, 2022 at 01:26:43PM +0100, Oliver Neukum wrote:
> >> This SL-6000 says Direct Line, not Ethernet
> >>
> >> Signed-off-by: Oliver Neukum <oneukum@suse.com>
> >> ---
> >>  drivers/net/usb/cdc_ether.c | 12 ++++++++++++
> >>  drivers/net/usb/zaurus.c    | 12 ++++++++++++
> >>  2 files changed, 24 insertions(+)
> >>
> >> diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
> >> index eb3817d70f2b..9b4dfa3001d6 100644
> >> --- a/drivers/net/usb/cdc_ether.c
> >> +++ b/drivers/net/usb/cdc_ether.c
> >> @@ -583,6 +583,11 @@ static const struct usb_device_id	products[] = {
> >>  	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET, \
> >>  	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
> >>  
> >> +#define ZAURUS_FAKE_INTERFACE \
> >> +	.bInterfaceClass	= USB_CLASS_COMM, \
> >> +	.bInterfaceSubClass	= USB_CDC_SUBCLASS_MDLM, \
> >> +	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
> >> +
> >>  /* SA-1100 based Sharp Zaurus ("collie"), or compatible;
> >>   * wire-incompatible with true CDC Ethernet implementations.
> >>   * (And, it seems, needlessly so...)
> >> @@ -636,6 +641,13 @@ static const struct usb_device_id	products[] = {
> >>  	.idProduct              = 0x9032,	/* SL-6000 */
> >>  	ZAURUS_MASTER_INTERFACE,
> >>  	.driver_info		= 0,
> >> +}, {
> >> +	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
> >> +		 | USB_DEVICE_ID_MATCH_DEVICE,
> >> +	.idVendor               = 0x04DD,
> >> +	.idProduct              = 0x9032,	/* SL-6000 */
> >> +	ZAURUS_FAKE_INTERFACE,
> >> +	.driver_info		= 0,
> >>  }, {
> >>  	.match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
> >>  		 | USB_DEVICE_ID_MATCH_DEVICE,
> >> diff --git a/drivers/net/usb/zaurus.c b/drivers/net/usb/zaurus.c
> >> index 8e717a0b559b..9243be9bd2aa 100644
> >> --- a/drivers/net/usb/zaurus.c
> >> +++ b/drivers/net/usb/zaurus.c
> >> @@ -256,6 +256,11 @@ static const struct usb_device_id	products [] = {
> >>  	.bInterfaceSubClass	= USB_CDC_SUBCLASS_ETHERNET, \
> >>  	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
> >>  
> >> +#define ZAURUS_FAKE_INTERFACE \
> >> +	.bInterfaceClass	= USB_CLASS_COMM, \
> >> +	.bInterfaceSubClass	= USB_CDC_SUBCLASS_MDLM, \
> >> +	.bInterfaceProtocol	= USB_CDC_PROTO_NONE
> >> +
> >>  /* SA-1100 based Sharp Zaurus ("collie"), or compatible. */
> >>  {
> >>  	.match_flags	=   USB_DEVICE_ID_MATCH_INT_INFO
> >> @@ -313,6 +318,13 @@ static const struct usb_device_id	products [] = {
> >>  	.idProduct              = 0x9032,	/* SL-6000 */
> >>  	ZAURUS_MASTER_INTERFACE,
> >>  	.driver_info = ZAURUS_PXA_INFO,
> >> +}, {
> >> +        .match_flags    =   USB_DEVICE_ID_MATCH_INT_INFO
> >> +                 | USB_DEVICE_ID_MATCH_DEVICE,
> >> +        .idVendor               = 0x04DD,
> >> +        .idProduct              = 0x9032,       /* SL-6000 */
> >> +        ZAURUS_FAKE_INTERFACE,
> >> +        .driver_info = (unsigned long) &bogus_mdlm_info,
> > No tabs here?
> Checking ...
> >
> > And isn't there a needed "Reported-by:" for this one as it came from a
> > bug report?
> Do we do these for reports by the kernel.org bugzilla?

We should, why not?

