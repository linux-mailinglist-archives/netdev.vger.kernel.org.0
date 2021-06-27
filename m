Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A1873B516B
	for <lists+netdev@lfdr.de>; Sun, 27 Jun 2021 05:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230463AbhF0Dzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Jun 2021 23:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbhF0Dzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Jun 2021 23:55:54 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B84C061574
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 20:53:30 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id h23so7846674pjv.2
        for <netdev@vger.kernel.org>; Sat, 26 Jun 2021 20:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=bZYC/uTqPVj2rQUdmUn+18OGlkwPdwPlgd7F9r5gohQ=;
        b=cPn2hMc/05DfNH/m9D8/Fh4EnA8CQMJkHm6L2HI45hQazIK2T5tlRtPDAuXGWlABOR
         FCUW1uf4+CbP690XtJ22LCl0+/lNOc5e3PJCs0xEQ8eB0Ee9EIYROMFVCyY05DCvh10h
         bJew0Z2C937fR+PDaOUNWNynN7no6hFmT7KU3et/HTCbJuRuEHtWiELH3f2E25fP3EGh
         UnqDWy62jzp4nd3nipb6Z3UZ7S6WqCP7efaKXwbWrxB8YKeDbQmZTn+NReLSycQpb2r3
         XkJBLhw4qo2+lXTOeFHiGHre64SIJzXGloUt8zVNUTa6XighVVtgH22xnPtSY6swE24t
         hkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=bZYC/uTqPVj2rQUdmUn+18OGlkwPdwPlgd7F9r5gohQ=;
        b=CBXGPC+oVOfpQbtxoC3p4VflNNs48sXM3PBf5OvjF1DAeAL/zJTK9NIvcCXc5QGDWA
         ISmWPqiaWrBn39amASnhvCjQPYDmDcfO1vxAM6VOAOsUuuIukdEEdxzyalHZ7gM8cbP4
         7xVkWZTxItNf8Z/oasb+UgCMq/Vuc2njS3VsLSthjnLIdHSu8La7HMeyIGTqZ9JZBvqn
         I4ikvxpcwjGtNNWJhPLKn7buorbmSwWOd/kbmgZdx1wpx3rvfemu5SvqMHXGT27G3SCN
         r09VOW0EzAFBTdOLKFVL87n7CwrT3fAASPDPfBOZCOFygwfKNlNgQ5Niejvk8vpc2KUg
         JcUQ==
X-Gm-Message-State: AOAM533XG2tUgFfs+NPn6lMeK9LvKBzbVV8+TYbyLAGxrIVmdRim2nFV
        KvOj1pOkS6KqClyrFoW5JBY=
X-Google-Smtp-Source: ABdhPJzhGKRabVL7248N//Yeha7QU2N0T9TZXukBeLEBhPgOlWFZgl+QMONGL9oJ3h6U83L6p5fZFQ==
X-Received: by 2002:a17:902:7c8b:b029:124:d6df:8d99 with SMTP id y11-20020a1709027c8bb0290124d6df8d99mr16375453pll.8.1624766010022;
        Sat, 26 Jun 2021 20:53:30 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id 3sm10420071pfb.202.2021.06.26.20.53.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Jun 2021 20:53:29 -0700 (PDT)
To:     Linux Netdev List <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Michal Kubecek <mkubecek@suse.cz>,
        Heiner Kallweit <hkallweit1@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: PHY vs. MAC ethtool Wake-on-LAN selection
Message-ID: <554fea3f-ba7c-b2fc-5ee6-755015f6dfba@gmail.com>
Date:   Sat, 26 Jun 2021 20:53:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

I would like to request your feedback on implementing a solution so that 
we can properly deal with choosing PHY or MAC Wake-on-LAN configuration.

The typical use case that I am after is the following: an Android TV box 
which is asleep as often as possible and needs to wake-up when a local 
network device wants to "cast" to the box. This happens when your phone 
does a mDNS query towards a multicast IPv4 address and searches for a 
particular service.

Now, consider the existing system's capabilities:

- system supports both "standby" (as written in /sys/power/state) with 
all the blocks powered on and "mem" with only a subset of the SoC 
powered on (a small always on island and supply)

- Ethernet MAC (bcmgenet) is capable of doing Wake-on-LAN using Magic 
Packets (g) with password (s) or network filters (f) and is powered on 
in the "standby" (as written in /sys/power/state) suspend state, and 
completely powered off (by hardware) in the "mem" state

- Ethernet PHY (broadcom.c, no code there to support WoL yet) is capable 
of doing Wake-on-LAN using Magic Packets (g) with password (s) or a 
48-bit MAC destination address (f) match allowing us to match on say, 
Broadcom and Multicast. That PHY is on during both the "standby" and 
"mem" suspend states

The network filtering capability of the Ethernet MAC in the "standby" 
state is superior to that of the Ethernet PHY and would allow for finer 
filtering of the network packets, so it should be preferred when the 
standby state is "standby" so we can limit spurious wake-ups on 
multicast traffic and specifically that not matching the desired 
service. There may also be capability to match on all of "gsf" instead 
of just "g" or "s" so it is preferred.

When the standby state is "mem" however we would want to use the PHY 
because that is the only one in the always-on island that can be active, 
even if it has coarse filtering capabilities.

Since bd8c9ba3b1e2037af5af4e48aea1087212838179 ("PM / suspend: Export 
pm_suspend_target_state") drivers do have the ability to determine which 
suspend state we are about to enter at ->suspend() time, so with the 
knowledge about the system as to which of the MAC or the PHY will remain 
on (using appropriate Device Tree properties for instance: always-on) 
and service Wake-on-LAN, a driver could make an appropriate decision as 
to whether it wants to program the MAC or the PHY with the Wake-on-LAN 
configuration.

The programming of the Wake-on-LAN is typically done at ->suspend() time 
and not necessarily at the time the user is requesting it, and at the 
time the user configures Wake-on-LAN we do not know yet the target 
suspend state.

This is a problem that could be punted to user-space in that it controls 
which suspend mode the system will enter. We could therefore assume that 
user space should know which Wake-on-LAN configuration to apply, even if 
that could mean "double" programming of both the MAC and PHY, knowing 
that the MAC will be off so the PHY will take over. The problem I see 
with that is that approach:

- you must always toggle between Wake-on-LAN programming depending upon 
the system standby mode which may not always be practical

- the behavior can vary wildly between platforms depending upon 
capabilities of the drivers and their bugs^w implementation

- we are still missing the ability to install a specific Wake-on-LAN 
configuration towards the desired MAC or PHY entity

The few drivers that call phy_ethtool_{set,get}_wol() except lan743x do 
not actually support Wake-on-LAN at the MAC level, so that is an easy 
decision to make for them because it is the only way they can support 
Wake-on-LAN.

What I envision we could do is add a ETHTOOL_A_WOL_DEVICE u8 field and 
have it take the values: 0 (default), 1 (MAC), 2 (PHY), 3 (both) and you 
would do the following on the command line:

ethtool -s eth0 wol g # default/existing mode, leave it to the driver
ethtool -s eth0 wol g target mac # target the MAC only
ethtool -s eth0 wol g target phy # target the PHY only
ethtool -s eth0 wol g target mac+phy # target both MAC and PHY

Is that over engineering or do you see other platforms possibly needing 
that distinction? Heiner, how about r8169, are there similar constraints 
with respect to which part of the controller is on/off during S2, S3 or S5?

Thanks!
-- 
Florian
