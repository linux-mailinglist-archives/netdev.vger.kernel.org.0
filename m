Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48DB64B06E
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 08:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234667AbiLMHb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 02:31:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234485AbiLMHbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 02:31:25 -0500
Received: from mx1.tq-group.com (mx1.tq-group.com [93.104.207.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C261AF26;
        Mon, 12 Dec 2022 23:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1670916683; x=1702452683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9366RXwxTTJ4NdfsIPFfbNX3LynlC5Fa1dlBXeQMq+I=;
  b=naLgdqBiH4SJakqf26hAphukKn0faTm6YJHJ7VHhctm2S/LZVbz59PGY
   ehCWxs81vDKwOFf2BDAst6cRyJMQ5mf88kNyrjA+5ud3NC+GS08QY8qED
   WGIZIR1eRYYUjI+jFJHevBWGOgTmkT0uzHYk4NTlC0/7lL33cpET7bBsY
   FtlEVKlqNWwJNMfUe9i4EGOLvXFCH42+IjyYu29XwU9iYSDTHcFHO4bIS
   kKQhJ3IXqnZX+9xLlPeG5e60UKU0U0A5ResokMF2i7prKl/yriXb67UqG
   6jt7ZZxzKyTbhC8NvDcduePv9LGIm3XXfESlhtlxdFm82Hiascdoh/VlM
   w==;
X-IronPort-AV: E=Sophos;i="5.96,240,1665439200"; 
   d="scan'208";a="27910777"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 13 Dec 2022 08:31:21 +0100
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Tue, 13 Dec 2022 08:31:21 +0100
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Tue, 13 Dec 2022 08:31:21 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1670916681; x=1702452681;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9366RXwxTTJ4NdfsIPFfbNX3LynlC5Fa1dlBXeQMq+I=;
  b=hvLB55i0b3EbmEQTDq77D5sra8j8KoSdGh1nZH6W4t7+mHJ70HstWkyW
   0pkyNIlihMDto4wWSZG+DepHDMBtgMUoxbQpi013oSJAVF0PflHvrnt2r
   fzCvvaptixRLMWNWJU+kKgXbT8TFxlp3zSsG/9KNg2pi7sb//nzU5wE2h
   Bncg5CvM7lDPK+pC00X4JjFgU3wuU4E632M8sUq6klqitpp9iyR0p2mJ4
   eqMXbunE2xH/CftPudP/yTkYdPmJZAHcRcqsY5x+1Jhksls6pj9r9Owsr
   P+RCbdV8uJVB5Lfry2mLlN5q6y+AUdOKOGDKinucq3+yA17E1BSH5vxo5
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,240,1665439200"; 
   d="scan'208";a="27910776"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 13 Dec 2022 08:31:21 +0100
Received: from steina-w.localnet (unknown [10.123.53.21])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by vtuxmail01.tq-net.de (Postfix) with ESMTPSA id 2493B280071;
        Tue, 13 Dec 2022 08:31:21 +0100 (CET)
From:   Alexander Stein <alexander.stein@ew.tq-group.com>
To:     Fabio Estevam <festevam@gmail.com>
Cc:     bjorn@mork.no, Peter Chen <peter.chen@kernel.org>,
        Marek Vasut <marex@denx.de>, Li Jun <jun.li@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Schrempf Frieder <frieder.schrempf@kontron.de>
Subject: Re: imx7: USB modem reset causes modem to not re-connect
Date:   Tue, 13 Dec 2022 08:31:17 +0100
Message-ID: <12353052.O9o76ZdvQC@steina-w>
Organization: TQ-Systems GmbH
In-Reply-To: <CAOMZO5AWRDLu5t0O=AG7CxNLv20HTmMTRh=so=s7+nTH0_qYgQ@mail.gmail.com>
References: <CAOMZO5AFsvwbC4Pr49WPFmZt7OnKjuJnYSf3cApGqtoZ_fFPPA@mail.gmail.com> <CAOMZO5AWRDLu5t0O=AG7CxNLv20HTmMTRh=so=s7+nTH0_qYgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Fabio,

I had a problem regarding runtime suspend and detecting USB hub events on a 
non-removable downstream hub. Disabling runtime suspend did work as well, but
this was eventually fixed by 552ca27929ab2 ("ARM: dts: imx7: Move hsic_phy 
power domain to HSIC PHY node").
Maybe your USB device doesn't support some low power mode, but I'm not well 
versed in that area.

Best regards,
Alexander

Am Montag, 12. Dezember 2022, 20:01:25 CET schrieb Fabio Estevam:
> On Mon, Dec 12, 2022 at 3:10 PM Fabio Estevam <festevam@gmail.com> wrote:
> > Hi,
> > 
> > On an imx7d-based board running kernel 5.10.158, I noticed that a
> 
> > Quectel BG96 modem is gone after sending a reset command via AT:
> Disabling runtime pm like this:
> 
> diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c
> b/drivers/usb/chipidea/ci_hdrc_imx.c
> index 9ffcecd3058c..e2a263d583f9 100644
> --- a/drivers/usb/chipidea/ci_hdrc_imx.c
> +++ b/drivers/usb/chipidea/ci_hdrc_imx.c
> @@ -62,7 +62,6 @@ static const struct ci_hdrc_imx_platform_flag
> imx6ul_usb_data = {
>  };
> 
>  static const struct ci_hdrc_imx_platform_flag imx7d_usb_data = {
> -       .flags = CI_HDRC_SUPPORTS_RUNTIME_PM,
>  };
> 
>  static const struct ci_hdrc_imx_platform_flag imx7ulp_usb_data = {
> 
> makes the USB modem to stay connected after the reset command:
> 
> # microcom /dev/ttyUSB3
> 
> >AT+CFUN=1,1
> 
> OK
> [   31.339416] usb 2-1: USB disconnect, device number 2
> [   31.349480] option1 ttyUSB0: GSM modem (1-port) converter now
> disconnected from ttyUSB0
> [   31.358298] option 2-1:1.0: device disconnected
> [   31.366390] option1 ttyUSB1: GSM modem (1-port) converter now
> disconnected from ttyUSB1
> [   31.374883] option 2-1:1.1: device disconnected
> [   31.383359] option1 ttyUSB2: GSM modem (1-port) converter now
> disconnected from ttyUSB2
> [   31.391800] option 2-1:1.2: device disconnected
> [   31.404700] option1 ttyUSB3: GSM modem (1-port) converter now
> disconnected from ttyUSB3
> # [   31.413261] option 2-1:1.3: device disconnected
> [   36.151388] usb 2-1: new high-speed USB device number 3 using ci_hdrc
> [   36.354398] usb 2-1: New USB device found, idVendor=2c7c,
> idProduct=0296, bcdDevice= 0.00
> [   36.362768] usb 2-1: New USB device strings: Mfr=3, Product=2,
> SerialNumber=4 [   36.370031] usb 2-1: Product: Qualcomm CDMA Technologies
> MSM
> [   36.375818] usb 2-1: Manufacturer: Qualcomm, Incorporated
> [   36.381355] usb 2-1: SerialNumber: 7d1563c1
> [   36.389915] option 2-1:1.0: GSM modem (1-port) converter detected
> [   36.397679] usb 2-1: GSM modem (1-port) converter now attached to ttyUSB0
> [   36.412591] option 2-1:1.1: GSM modem (1-port) converter detected [  
> 36.420237] usb 2-1: GSM modem (1-port) converter now attached to ttyUSB1 [ 
>  36.434988] option 2-1:1.2: GSM modem (1-port) converter detected [  
> 36.442792] usb 2-1: GSM modem (1-port) converter now attached to ttyUSB2 [ 
>  36.457745] option 2-1:1.3: GSM modem (1-port) converter detected [  
> 36.465709] usb 2-1: GSM modem (1-port) converter now attached to ttyUSB3
> 
> Does anyone have any suggestions as to what could be the problem with
> runtime pm?




