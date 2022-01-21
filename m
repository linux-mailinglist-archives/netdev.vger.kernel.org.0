Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0AF6F49606D
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 15:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350899AbiAUOG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 09:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348573AbiAUOGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 09:06:25 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02523C061574
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:06:25 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id s5so447433ejx.2
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 06:06:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=E/jmg0rb3j3DO2U/1rofjOfrOnRHKTCChPpLlL5AjeI=;
        b=b7DIScpEfIlrb3403xPlBNBEmR0/Gy/74JIVUUAE7LGeDE9NRmF+YvfFeYQhBswCrv
         uZxAzAA3LpUEIO9p1u4pVp6l171p2YckjLjzLNBP4yp3Cwz0OL7HhDJWJ+SdRAR/NR7x
         gYsM0liEvAJFm4wagBjl8+mMNqnBzbWVwnFzKCvHN/Z1xy4g4SO72YqK9HJk5fsTnwL+
         vQ72I0FWs5FlIzrSvfrL9rHJl8Zgt0y6iZjDUOL/NpPBjfYYApd8SKStdXyR4uaqy/Dw
         b136Otqn9ZwlcKVBwJc4dHSduQqJUBxaHpVvUWbpU2yZcYH8y27aJ1tn8B7lKbIkBshL
         y2sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=E/jmg0rb3j3DO2U/1rofjOfrOnRHKTCChPpLlL5AjeI=;
        b=UhuBzTnVML1cCrSeUTuHLqONLJrbM2jgWP8Fr+HeFpeN73/0bFweBTTmyLx98adJLF
         8dMFjaLTKvUElAjeBcVLJfvk4lFVsxnWV0/wIT+l7doVXtDb90yv+r6b06DUBnqU8EnM
         ucL/RZC3ugS6hcCi18nKnWVNcff/5wG2KkXRn+FAQenI8RCsnomHf6hijzN3NDp+ydzb
         dC9i4c3XBcSpnlvwWTibHX6QNjxtrVPkQLdBCavPTW5gLjMJgg+i0XYDPNLPHvYMdL/+
         0QXr1YC99KlTBcD3pWiw++Z7v3mpaA3FtWyk6puYT7lQ9rrIob5wKVBjCp5QPapTZWIl
         x01Q==
X-Gm-Message-State: AOAM532n3OCQ1gFIpW2ukxyBO/KNf72jKg8e91TMVQUofDqtFDJRvgig
        VKRld+afwkePBJUKYCZV172ArRlRrgNwQ8Osb0Q=
X-Google-Smtp-Source: ABdhPJwN98A205m07Buy3yEg9XEcGUiQa4R+BpHeZz4XEiM5e7pefrplwjYSIRhICERJxdHNgDAZEj1bWBVl44LjV90=
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr3432410ejc.696.1642773983516;
 Fri, 21 Jan 2022 06:06:23 -0800 (PST)
MIME-Version: 1.0
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 21 Jan 2022 11:06:12 -0300
Message-ID: <CAOMZO5BJRVt7dG=76j8RZ63Wgr4eyZdZNPU5dz=1uG+PBQGyMw@mail.gmail.com>
Subject: rfkill: wwan does not show up in rfkill command
To:     Johannes Berg <johannes@sipsolutions.net>, bjorn@mork.no
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I am running kernel 5.10.92 on an imx7d SoC.

The wwan interface is brought up:

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
WWAN/QMI device, 0e:31:86:6b:xx:xx

When I run the rfkill command, only the Wifi interface shows up:

root@CGW0000000:~# rfkill
ID TYPE DEVICE      SOFT      HARD
 0 wlan phy0   unblocked unblocked

Shouldn't the wwan interface also be listed in the rfkill output?

Is there anything that needs to be done for wwan to appear there?

Also, there is a GPIO that connects to the modem (W_DISABLE) pin, but
it seems it is not possible currently to use rkfill gpio with device
tree, right? I saw some previous attempts to add rfkill gpio support
in devicetree, but none was accepted.

Any suggestions are welcome.

Thanks,

Fabio Estevam
