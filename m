Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35F7A64A6B7
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 19:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233181AbiLLSOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 13:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiLLSOF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 13:14:05 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E555018B3E;
        Mon, 12 Dec 2022 10:11:20 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id u5so597803pjy.5;
        Mon, 12 Dec 2022 10:11:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=e0uny2wKdDn2oX2hw7cfC9msWj09yDoQ8UJ3LtzZVJw=;
        b=QbnZ73cQ9n+oG+GCjoFxkRZNsVkSWAtgBbBBOgz6o7OIco1fo/5F7XqcBKIb4JTKy1
         CjJHHJ6bqkWIN2Br94R2xif2Q7427ix6/IVKZVt7SLioHCfh+FA56EiOpNHeb3Tynu3q
         kpgFzmIMaUt8rdyo4wMLhHLEe5OWgM0wKVUyylt0D5P2z5iniOO90CD3rqrPyW1sBm0R
         lGMwVWndZd90TIgLXetCHySw2tbe/qiIHAtr4aW6QefHIaLci97W6fPd1xAnkfIqddKb
         TLWnDLKMp6Wo+BWm3JtOxnGBjPPid7/1ltW3jUaM9QCpjJPwze7uk6Q30NfrWmZFUZxL
         Yj8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e0uny2wKdDn2oX2hw7cfC9msWj09yDoQ8UJ3LtzZVJw=;
        b=DhcZa6ebsd8mvz2wODWsF3jPI3vsRkLxJuXSoHUv24gEtr+OK3O9SIt/mQjZAy3JDk
         zmd4D8eMRT/bCyvBlL3jJIYVENXoe9TjX3aaNPAmmzsZhPCJBJQYr22fnbfgGi32uRwC
         7QG3hPN5J9+JMlAPf9tzIp2Y4XJsI5lZNggHMCSPbQqQ3n7Fqk16D98V72wGd5Jq5aDH
         1tJ8bTQ/nd0AYNtNK3dVX9owEMG6qHGnvnKL8LpdpAjRO7LToZogF03yrVuwm20JwSQ0
         JyW5ihJpr3tl4x8na4amh9bKAFbgHf5WJvRiAqyCjs1Jy9R53/vDZRve7hhXlbFRcqu3
         KnrQ==
X-Gm-Message-State: ANoB5pnF+Y5qnNOSzZHUTpjutTTcHn6u9a8CeqJkjyaRRc87Khk9DGkB
        lvubZeOM3j8WBxO1Rns9N2kj70YaupG22mXD15o=
X-Google-Smtp-Source: AA0mqf7ZnOHBqMXIEwxjjfVsE3wfcB/KvrCS/A+a57iUBBnI0sWiyVVNUpt73ry6+9AzBy7odrLC89UVWryENRGUSsY=
X-Received: by 2002:a17:902:8a98:b0:189:d081:1ebb with SMTP id
 p24-20020a1709028a9800b00189d0811ebbmr20776042plo.130.1670868674531; Mon, 12
 Dec 2022 10:11:14 -0800 (PST)
MIME-Version: 1.0
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 12 Dec 2022 15:10:56 -0300
Message-ID: <CAOMZO5AFsvwbC4Pr49WPFmZt7OnKjuJnYSf3cApGqtoZ_fFPPA@mail.gmail.com>
Subject: imx7: USB modem reset causes modem to not re-connect
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

Hi,

On an imx7d-based board running kernel 5.10.158, I noticed that a
Quectel BG96 modem is gone after sending a reset command via AT:

# microcom /dev/ttyUSB3
>AT+CFUN=1,1
OK
 usb 2-1: USB disconnect, device number 6
option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
option 2-1:1.0: device disconnected
option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
option 2-1:1.1: device disconnected
option1 ttyUSB2: GSM modem (1-port) converter now disconnected from ttyUSB2
option 2-1:1.2: device disconnected
option1 ttyUSB3: GSM modem (1-port) converter now disconnected from ttyUSB3
option 2-1:1.3: device disconnected
qmi_wwan 2-1:1.4 wwan0: unregister 'qmi_wwan' usb-ci_hdrc.1-1, WWAN/QMI device

# lsusb
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

The USB modem is gone.

Forcing an 'echo on' to power/control makes the USB modem reappear:

# echo 'on' > /sys/bus/usb/devices/usb2/power/control
usb 2-1: new high-speed USB device number 7 using ci_hdrc
 usb 2-1: New USB device found, idVendor=2c7c, idProduct=0296, bcdDevice= 0.00
 usb 2-1: New USB device strings: Mfr=3, Product=2, SerialNumber=4
usb 2-1: Product: Qualcomm CDMA Technologies MSM
 usb 2-1: Manufacturer: Qualcomm, Incorporated
usb 2-1: SerialNumber: 7d1563c1
option 2-1:1.0: GSM modem (1-port) converter detected
usb 2-1: GSM modem (1-port) converter now attached to ttyUSB0
 option 2-1:1.1: GSM modem (1-port) converter detected
usb 2-1: GSM modem (1-port) converter now attached to ttyUSB1
option 2-1:1.2: GSM modem (1-port) converter detected
 usb 2-1: GSM modem (1-port) converter now attached to ttyUSB2
option 2-1:1.3: GSM modem (1-port) converter detected
usb 2-1: GSM modem (1-port) converter now attached to ttyUSB3
qmi_wwan 2-1:1.4: cdc-wdm0: USB WDM device
qmi_wwan 2-1:1.4 wwan0: register 'qmi_wwan' at usb-ci_hdrc.1-1,
WWAN/QMI device, 12:bc:8c:zz:yy:xx

# lsusb
Bus 002 Device 007: ID 2c7c:0296 Quectel Wireless Solutions Co., Ltd.
BG96 CAT-M1/NB-IoT modem
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Sending the AT reset command afterward works fine, and the modem keeps
connected.

Previously, this board used a vendor-based 4.14 kernel and such a
problem did not happen.

Kernels 5.10 and 4.14 have the same 'auto' option selected by default.

Also tested kernel 6.1 and it behaves the same as 5.10.158.

What can be done so that the reset modem command does not cause the
modem to disappear by default?

Thanks,

Fabio Estevam
