Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0C4C5243F7
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 06:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346372AbiELENV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 00:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346361AbiELENN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 00:13:13 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698441E5EC8;
        Wed, 11 May 2022 21:13:10 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 2E9B8320095C;
        Thu, 12 May 2022 00:13:06 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 12 May 2022 00:13:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1652328785; x=1652415185; bh=++9cjqTrJI
        qEH8YtpOmDN60mAdRnMXZTS8IHv1/ADcs=; b=L1hyfQpF8Men26wyTDvTc/dzjm
        4JuARr2MOwOL+av3HTtphEnMBQTYWSzs2NRE5iDynW5valvCWx3GqSipXhwYJTJy
        TCxC9DpH7p7+NRfy46K8t1bv/MZ6vGOGI27Zk9vE9vfn2+ufFSAoyNHeVcb/P2d2
        fzFPEs6mwgT/lcT0m50IJeeM7TBS+wuZhqkiVKvaGRL4WBJRJqdk6J3Xa3gw7sS+
        wFilpLhb8LiUaku9tiatELwUpbwlh9eEL5wpU36BPYxXRiLVyRjZCfOi+ovvgXeU
        oJ9sv3nCWEsst0Sl89aOfzSnEx8pEuVmMBQ4b1kJRomRje8UIXYdcBOFf3BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652328785; x=
        1652415185; bh=++9cjqTrJIqEH8YtpOmDN60mAdRnMXZTS8IHv1/ADcs=; b=v
        bA3T8Ma8YQLMs6W59OHH3pBfAaQCebZSszHDBYaR0cZXN2rLStWTvYjDz4U7+cOi
        DzS2Gs314yxOybPSCBXmHlMBYOiJMbnh1icAC0T2uqgfLHz3cpQeFwf9vwlrv3e2
        dEBJQUkfK93Nf/i8nwFqMRu0vQenn+/gZHluiNRc0Wkcrz8ZUvQIPp4QwGGNme/G
        o1xK2mnhdXed11RJhratjbaTPRix1+58kEfz6XLp6RPLzr2QJZi7WdcBfJiA7Bdh
        qHot5EQPqfA6zFqFwgK9ByYWsBNHZZerw9LKW8MHI8dbArEzK9MTGWRhof6RuSGq
        kMPtFSS4Kysq5r0HNIrhg==
X-ME-Sender: <xms:UIl8Ykgos9QtlPKgTyhgnMoELD9W9ABtB2Vf2hRl9WNeRGy3khe4rw>
    <xme:UIl8YtDyzmC-sQ16ncKfGwuIN3xv6q5Q894ybyOHWED50kRAo8_F7KMITea3zyOkj
    RX_a52DVSbMPw>
X-ME-Received: <xmr:UIl8YsGaZFX-Mk9kACLZRSTSisC0KirTFsJsxlotzmwnyOk4Ydkf-VrDhuDxkd3fJvu0QeLFkC0SJzOfIzrYk7tz65iqZDYq>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgeeigdektdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdortddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeejhfelff
    ejkeejheetgfeigeekueeuuddvveekjeekueeggfdvhfefteelgefgvdenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:UIl8YlS2rgsrlK9k3Ev8Pz1WmtfqGTNneHoGv5BUvnCYTuZ-7ZrHLQ>
    <xmx:UIl8Yhze5hrKNidZ_Bex1WpkCDWE-TTZCO__inSPmFADvMxu_zYnbQ>
    <xmx:UIl8Yj5WkGov7dYi6dK78WLKKegQo8bWIbkq8KOdI5sO11D5fkc4mA>
    <xmx:UYl8YmIfhxUo8puFeVoHbhM263xvPcGVGM_YOK_DBbuPkz85Po5OJQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 May 2022 00:13:04 -0400 (EDT)
Date:   Thu, 12 May 2022 06:13:00 +0200
From:   Greg KH <greg@kroah.com>
To:     David Ober <dober6023@gmail.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, aaron.ma@canonical.com,
        markpearson@lenovo.com, dober@lenovo.com
Subject: Re: [PATCH v3] net: usb: r8152: Add in new Devices that are
 supported for Mac-Passthru
Message-ID: <YnyJTLOdhAXJGxzG@kroah.com>
References: <20220511193015.248364-1-dober6023@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220511193015.248364-1-dober6023@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 03:30:15PM -0400, David Ober wrote:
> Lenovo Thunderbolt 4 Dock, and other Lenovo USB Docks are using the
> original Realtek USB ethernet Vendor and Product IDs
> If the Network device is Realtek verify that it is on a Lenovo USB hub
> before enabling the passthru feature
> 
> This also adds in the device IDs for the Lenovo USB Dongle and one other
> USB-C dock
> 
> Signed-off-by: David Ober <dober6023@gmail.com>
> ---
>  drivers/net/usb/r8152.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index c2da3438387c..482f54625411 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -771,6 +771,8 @@ enum rtl8152_flags {
>  };
>  
>  #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
> +#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3		0x3062
> +#define DEVICE_ID_THINKPAD_USB_C_DONGLE			0x720c
>  #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387
>  
>  struct tally_counter {
> @@ -9644,10 +9646,18 @@ static int rtl8152_probe(struct usb_interface *intf,
>  
>  	if (le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_LENOVO) {
>  		switch (le16_to_cpu(udev->descriptor.idProduct)) {
> +		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3:
> +		case DEVICE_ID_THINKPAD_USB_C_DONGLE:
>  		case DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2:
>  		case DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2:
>  			tp->lenovo_macpassthru = 1;
>  		}
> +	} else if ((le16_to_cpu(udev->descriptor.idVendor) == VENDOR_ID_REALTEK) &&
> +		   (le16_to_cpu(udev->parent->descriptor.idVendor) == VENDOR_ID_LENOVO)) {
> +		switch (le16_to_cpu(udev->descriptor.idProduct)) {
> +		case 0x8153:
> +			tp->lenovo_macpassthru = 1;
> +		}
>  	}
>  
>  	if (le16_to_cpu(udev->descriptor.bcdDevice) == 0x3011 && udev->serial &&
> -- 
> 2.30.2
> 

Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/SubmittingPatches for what needs to be done
  here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
