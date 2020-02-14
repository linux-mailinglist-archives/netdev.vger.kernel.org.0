Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 936B515EB92
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391939AbgBNRVg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:21:36 -0500
Received: from mail-lj1-f170.google.com ([209.85.208.170]:36341 "EHLO
        mail-lj1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391360AbgBNRVe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 12:21:34 -0500
Received: by mail-lj1-f170.google.com with SMTP id r19so11570324ljg.3
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 09:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=lht9Ow2Bc9TICgWtrUEjSgRB5YD4jANMEWWhF66y+Uw=;
        b=exO8OgKLgG7Je+5M79ItGEEWeTRy2APsEOlFOQNXXIwfCGqAl7Ym3fTThwg/RAQVsj
         tl+LT47E6vZGSK/6XtOW6TIQpAl8qX7HH68Qc5Lb3gEioYxR7UGrOoQvC02A2uE7IF9+
         UhqyEN3So7zsU4jIPlITjOC/Vsr4GzZSpozU9vgZRppGNVMZBY6H/FsbYUc9P1nw3kzz
         QS5GxCy2cDKS4yTAXpj2LJMT7Vrq2oZJnHfWwoIMBWoAPhOZmw3UtNW2QIS0OrAzhsOQ
         M69MBziY9N73BQgmNtp62vXUnlg9j76H4wciXOZRzX3zz5h9MivhI2LSDyI/uDlizqu4
         2Wyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=lht9Ow2Bc9TICgWtrUEjSgRB5YD4jANMEWWhF66y+Uw=;
        b=C6rmVTjq0yWKnttTns9sbW8duQIrNon53faTuE4YxzUY7BXN3jmdhx05s6HYeFkJ0m
         bo+w7YVO3OuJ6V+TgD1vwUooEaJwWA0xz3WHgOtM8RhgXFSC3CsTpdxK9knX7dHCaxGZ
         PKXv8z71Jgw7647xQI+73AXcfxwLIEGoi1xqv0wV3SZNe2MNttQMhpS+zT0zYeMEIz1r
         5dUos4Cu3dqcMedR/9Wyeft/0R00UbOV6IbmSy2cXPhaOxGJw8rGwpfwMFJzEdlBHKDy
         HFaL9zirGi3t8BBSZed6k1ala0kVgD1sgb/H6q6QrlxnGHO4ACUI9YTI40C2q2SmPEFS
         jFRQ==
X-Gm-Message-State: APjAAAVzJH/FYPhbA0++9xi87PHH2iylSm6WAb5IaLiadrn9b/Jrw71v
        8ufrKMMxNglMmVpCsqbzUUNsSBGX
X-Google-Smtp-Source: APXvYqyLoBPNkGju+/86VPuw4TG11aF4pg8caFGOtDZYooohI2nPHbtdC0AkBAZmF3skud7IjarUkg==
X-Received: by 2002:a2e:b5ac:: with SMTP id f12mr2807594ljn.0.1581700892203;
        Fri, 14 Feb 2020 09:21:32 -0800 (PST)
Received: from [192.168.1.10] (hst-227-49.splius.lt. [62.80.227.49])
        by smtp.gmail.com with ESMTPSA id l3sm3804059lja.78.2020.02.14.09.21.31
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 09:21:31 -0800 (PST)
To:     netdev@vger.kernel.org
From:   Vincas Dargis <vindrg@gmail.com>
Subject: About r8169 regression 5.4
Message-ID: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
Date:   Fri, 14 Feb 2020 19:21:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've found similar issue I have myself since 5.4 on mailing list archive [0], for this device:

05:00.1 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit 
Ethernet Controller (rev 12)
         Subsystem: ASUSTeK Computer Inc. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller


It works fine as long as I select 5.3 in Grub (it seems no longer maintained in Debian Sid though...)

I see number of commits in net/etherenet/realtek tree, not sure if fix is there, or do we need 
another fix for this particular device? I've keep testing latest Debian kernel updates (latest is 
5.4.19-1), and no good news yet.

There's Debian bug report [1] which might contain more information.

Some extra info:

$ sudo ethtool -i enp5s0f1
driver: r8169
version:
firmware-version: rtl8411-2_0.0.1 07/08/13
expansion-rom-version:
bus-info: 0000:05:00.1
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no


$ sudo mii-tool -v enp5s0f1
enp5s0f1: negotiated 1000baseT-FD flow-control, link ok
   product info: vendor 00:07:32, model 0 rev 0
   basic mode:   autonegotiation enabled
   basic status: autonegotiation complete, link ok
   capabilities: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
   advertising:  1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
   link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control


[0] https://lkml.org/lkml/2019/11/30/119
[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=947685
