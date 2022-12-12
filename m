Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EDF564A7D7
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 20:03:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232271AbiLLTC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 14:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233406AbiLLTCF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 14:02:05 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9943B313;
        Mon, 12 Dec 2022 11:01:44 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id jl24so13043795plb.8;
        Mon, 12 Dec 2022 11:01:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jXiYAyiEKIzocsl5NzqmaacJdcUm5UXG1kgIVkOG/n0=;
        b=qjdG8SL+m9W7uH+If41w2e6S/DNskVQVQlzod3pjlLA40ep41oDNvZHWwI/AE+r+kE
         yR3I/i7UBrTxIfDv+/jpPAvwogrwNg2JZ6SmeHn+a86rHnvb0N57HczIFoGwyrT3Zlnk
         PNepCf6M28d//2kuLN6mOaJF8ZZlpN4qMthHlxgfxrHdsqkW7nlhhucoeLk72cnd5/e/
         gft0/DY+U+zOBu6CSfBSzaeBzCnmqWlHLh7BI0pPlL477+U83XU841GfBwKkvG6UiyJT
         WP3ZVC0CmDHhbuFhSrIgdJKizbCD7scMKDN9nqFj+jaVaM87dLbKG8duI9eagp0kZU5i
         /zqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jXiYAyiEKIzocsl5NzqmaacJdcUm5UXG1kgIVkOG/n0=;
        b=Dkiw4kIRC6XgHEAFsUA03viB6FnqDnHs+sdJybatSaXKV35Jc3S9MvKcwuVCWSVDd4
         5zAs+0yBbsw4D9KRpgPTYVWMORQck1x9eZOo7Ai3vA1zjH+VoEWj2DScMo+AKZXdi0Gw
         keGjLL6UbpSyz4xq15t9nr6Xm2wZG9wZ3RBnO/VxmkDD6ykpLae/OBzlMYuvEraf+mOd
         VR4Ax9RheNkhmTJm6bl36YRhVrDFRmJWCaqrddpiJT6hfkMqKO9uEEIGnYHNfuRgUw0f
         1A2aeYHyewMFOx7B33iyEt9mBbJOYiEcqvdHOmIWbHVPqe7rojRLyEUtvReY6gMvrEoe
         NpwA==
X-Gm-Message-State: ANoB5pl5gjsuOxjMe2lP8BJKYsAWZCooi7jyACR+szo0g0AGJy3SJgyP
        Ewe6nGtODYP50CFskyPPBvc9XgSKUn+i8HKsCSg=
X-Google-Smtp-Source: AA0mqf6ywgPV6ixT/JKHYQHS5vnWMLGv5H5QT3Oa20cy+YfMiCg1cCcKnS49cbY+WI3V/ELjcv/H4nkHMjLkEbr+Z+o=
X-Received: by 2002:a17:902:b40b:b0:188:75bb:36d4 with SMTP id
 x11-20020a170902b40b00b0018875bb36d4mr81059962plr.55.1670871704005; Mon, 12
 Dec 2022 11:01:44 -0800 (PST)
MIME-Version: 1.0
References: <CAOMZO5AFsvwbC4Pr49WPFmZt7OnKjuJnYSf3cApGqtoZ_fFPPA@mail.gmail.com>
In-Reply-To: <CAOMZO5AFsvwbC4Pr49WPFmZt7OnKjuJnYSf3cApGqtoZ_fFPPA@mail.gmail.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 12 Dec 2022 16:01:25 -0300
Message-ID: <CAOMZO5AWRDLu5t0O=AG7CxNLv20HTmMTRh=so=s7+nTH0_qYgQ@mail.gmail.com>
Subject: Re: imx7: USB modem reset causes modem to not re-connect
To:     bjorn@mork.no, Peter Chen <peter.chen@kernel.org>,
        Marek Vasut <marex@denx.de>, Li Jun <jun.li@nxp.com>
Cc:     netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 12, 2022 at 3:10 PM Fabio Estevam <festevam@gmail.com> wrote:
>
> Hi,
>
> On an imx7d-based board running kernel 5.10.158, I noticed that a
> Quectel BG96 modem is gone after sending a reset command via AT:

Disabling runtime pm like this:

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c
b/drivers/usb/chipidea/ci_hdrc_imx.c
index 9ffcecd3058c..e2a263d583f9 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -62,7 +62,6 @@ static const struct ci_hdrc_imx_platform_flag
imx6ul_usb_data = {
 };

 static const struct ci_hdrc_imx_platform_flag imx7d_usb_data = {
-       .flags = CI_HDRC_SUPPORTS_RUNTIME_PM,
 };

 static const struct ci_hdrc_imx_platform_flag imx7ulp_usb_data = {

makes the USB modem to stay connected after the reset command:

# microcom /dev/ttyUSB3
>AT+CFUN=1,1
OK
[   31.339416] usb 2-1: USB disconnect, device number 2
[   31.349480] option1 ttyUSB0: GSM modem (1-port) converter now
disconnected from ttyUSB0
[   31.358298] option 2-1:1.0: device disconnected
[   31.366390] option1 ttyUSB1: GSM modem (1-port) converter now
disconnected from ttyUSB1
[   31.374883] option 2-1:1.1: device disconnected
[   31.383359] option1 ttyUSB2: GSM modem (1-port) converter now
disconnected from ttyUSB2
[   31.391800] option 2-1:1.2: device disconnected
[   31.404700] option1 ttyUSB3: GSM modem (1-port) converter now
disconnected from ttyUSB3
# [   31.413261] option 2-1:1.3: device disconnected
[   36.151388] usb 2-1: new high-speed USB device number 3 using ci_hdrc
[   36.354398] usb 2-1: New USB device found, idVendor=2c7c,
idProduct=0296, bcdDevice= 0.00
[   36.362768] usb 2-1: New USB device strings: Mfr=3, Product=2, SerialNumber=4
[   36.370031] usb 2-1: Product: Qualcomm CDMA Technologies MSM
[   36.375818] usb 2-1: Manufacturer: Qualcomm, Incorporated
[   36.381355] usb 2-1: SerialNumber: 7d1563c1
[   36.389915] option 2-1:1.0: GSM modem (1-port) converter detected
[   36.397679] usb 2-1: GSM modem (1-port) converter now attached to ttyUSB0
[   36.412591] option 2-1:1.1: GSM modem (1-port) converter detected
[   36.420237] usb 2-1: GSM modem (1-port) converter now attached to ttyUSB1
[   36.434988] option 2-1:1.2: GSM modem (1-port) converter detected
[   36.442792] usb 2-1: GSM modem (1-port) converter now attached to ttyUSB2
[   36.457745] option 2-1:1.3: GSM modem (1-port) converter detected
[   36.465709] usb 2-1: GSM modem (1-port) converter now attached to ttyUSB3

Does anyone have any suggestions as to what could be the problem with
runtime pm?
