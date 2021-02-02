Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DD9D30B570
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231455AbhBBCob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:44:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:60074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231433AbhBBCo3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 21:44:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5085C64E9C;
        Tue,  2 Feb 2021 02:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612233828;
        bh=yB4dIAgdx6JgqjAQE8EtvwN1FxRmtG5cGe3FVIIhvdI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bfwbWDMdU0ujoNjUeq00mRYjHqVLs+Sjg+OpUdvk7pogUgS0ujJn4UjdZTYKt+0J9
         nQPjldv3n9cvQYndWiJEq/UZ8j4A0dcnSBZSW1LCXSf00IftBB0TbILg6HqoYrYGox
         imvs7jVcnyMtpytj/aVQsT8xkqEX9qPz21LJcDnBFcoG0f1exSKFjwsK8vNW1v7g89
         q/cxF7dmwbNP253YREzYmLtto7eLN6NlH0HdMVTHY1o8EZDqVGtxWI9zHiTxKiABrj
         5n6w3QPwCMyOaiFOH7imNI3ZZy2+KPC4Bw/q17IrKK0sCVEEAux1owySX6Nc5OOqXR
         ZToTJ0qHoK3wQ==
Date:   Mon, 1 Feb 2021 18:43:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christoph Schemmel <christoph.schemmel@gmail.com>
Cc:     bjorn@mork.no, avem@davemloft.net, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        hans-christoph.schemmel@thalesgroup.com
Subject: Re: [PATCH] NET: usb: qmi_wwan: Adding support for Cinterion MV31
Message-ID: <20210201184347.5efe7ec2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210129133001.8240-1-christoph.schemmel@gmail.com>
References: <20210129133001.8240-1-christoph.schemmel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 14:30:01 +0100 Christoph Schemmel wrote:
> Adding support for Cinterion MV31 with PID 0x00B7.
> 
> T:  Bus=04 Lev=01 Prnt=01 Port=00 Cnt=01 Dev#= 11 Spd=5000 MxCh= 0
> D:  Ver= 3.20 Cls=ef(misc ) Sub=02 Prot=01 MxPS= 9 #Cfgs=  1
> P:  Vendor=1e2d ProdID=00b7 Rev=04.14
> S:  Manufacturer=Cinterion
> S:  Product=Cinterion PID 0x00B3 USB Mobile Broadband
> S:  SerialNumber=b3246eed
> C:  #Ifs= 4 Cfg#= 1 Atr=a0 MxPwr=896mA
> I:  If#=0x0 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=ff Prot=ff Driver=qmi_wwan
> I:  If#=0x1 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x2 Alt= 0 #EPs= 3 Cls=ff(vend.) Sub=00 Prot=00 Driver=option
> I:  If#=0x3 Alt= 0 #EPs= 2 Cls=ff(vend.) Sub=ff Prot=30 Driver=option
> 
> Signed-off-by: Christoph Schemmel <christoph.schemmel@gmail.com>

Thanks for the patch, could you repost? We had some issues with the
mailing list and this patch did not get into patchwork.

> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
> index cc4819282820..b1784db6b098 100644
> --- a/drivers/net/usb/qmi_wwan.c
> +++ b/drivers/net/usb/qmi_wwan.c
> @@ -1309,6 +1309,7 @@ static const struct usb_device_id products[] = {
>  	{QMI_FIXED_INTF(0x1e2d, 0x0082, 5)},	/* Cinterion PHxx,PXxx (2 RmNet) */
>  	{QMI_FIXED_INTF(0x1e2d, 0x0083, 4)},	/* Cinterion PHxx,PXxx (1 RmNet + USB Audio)*/
>  	{QMI_QUIRK_SET_DTR(0x1e2d, 0x00b0, 4)},	/* Cinterion CLS8 */
> +	{QMI_FIXED_INTF(0x1e2d, 0x00b7, 0)},	/* Cinterion MV31 RmNet*/

nit: missing space before */

>  	{QMI_FIXED_INTF(0x413c, 0x81a2, 8)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
>  	{QMI_FIXED_INTF(0x413c, 0x81a3, 8)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
>  	{QMI_FIXED_INTF(0x413c, 0x81a4, 8)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */
