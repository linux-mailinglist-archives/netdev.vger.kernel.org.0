Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C19E3E4D17
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 21:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbhHITbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 15:31:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231439AbhHITbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 15:31:32 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 542C1C0613D3
        for <netdev@vger.kernel.org>; Mon,  9 Aug 2021 12:31:09 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id qk33so30862652ejc.12
        for <netdev@vger.kernel.org>; Mon, 09 Aug 2021 12:31:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=e02C7uRqGfTlJ1NI6vZSalj/qxawB+R1DCOirtdhgFI=;
        b=KvxYLuehcaYVJJ3QRZNiVqKHHjSmpJHVJ6niltRgpLp33xo82sICTV/+EFAzMu3SnP
         KsrP7rFK11he9BeFc5aZtaWDkTbDBy8K2mniHyBnsVtzeKpcIU6D+YHSfLiKGboqqLTk
         eD2cR3RxUgFUjh6nEaYDjZH5ArOo7YfS634UVgprYL8Xjgd+dGq7NvgMBDSKO/KJwq6q
         zCBnyaYWNrhrS5IzyZNe6koHk8n2LV69rNTgo5BWbM9lFI/Ns4JgPxyP/8LV1rFirSfr
         nadB9BvqpbeSzf2dpHOp+eOGTwFiMfEgyCBhwxowpOZwixZM6IB5QmUk2M3Mtv3/FhaW
         JMeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=e02C7uRqGfTlJ1NI6vZSalj/qxawB+R1DCOirtdhgFI=;
        b=JJTn6pliKMdMiwrfbcTvWZGAnJuoFjHgu0lMoREEQPqh7EQ21mCwDVi64Nm4e2ivjq
         kiCgD5Lu7bGSU4w/OiirkNmttlVWplNPW244rgPD+bY2gTu6MckdIYQ2so5OCC5QeUwu
         UT/6GUYpptbqiYTwpZe0E5LKMOuc5lLZ3TkGKNkoHnd6av7Cn2JE9vFLBH7iwForc2/T
         tPCDR0byST/cKKmx7ayGUdk+sVR9vzgTWd8Yu7SY8PJB19ZcRR5yKPWNAmc0dr5o8Kmp
         j2glKdW+EIBloTfdIpPIYu0uHNc8EzDEkKc3JO/sENVxal2Paq8Y1gufnuXAahfF0c+L
         3Mhw==
X-Gm-Message-State: AOAM531nYu5VlLOdPxV/7WvqrlswTF5gkCyAwxTgvUPFWDISvN7jkPlB
        m1Ctk2f04G+IzJDLDQQWj8E=
X-Google-Smtp-Source: ABdhPJzU9xMPn2Y+4ghfMSRH0HH4zHhftZPRfPzNXFrNqfcsRFByUtIE+GFUJ7mC+9PVxz74SLLI1g==
X-Received: by 2002:a17:906:4156:: with SMTP id l22mr8517200ejk.75.1628537467844;
        Mon, 09 Aug 2021 12:31:07 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id s20sm6103063eji.116.2021.08.09.12.31.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 12:31:07 -0700 (PDT)
Date:   Mon, 9 Aug 2021 22:31:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>
Subject: Re: [RFC PATCH net-next 0/4] Remove the "dsa_to_port in a loop"
 antipattern
Message-ID: <20210809193105.ijzvvkdwvtgkihun@skbuf>
References: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809190320.1058373-1-vladimir.oltean@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

FWIW, I also have a small test: on my Turris MOX with 25 mv88e6xxx user
ports, I have a script which sets up the bridge for my network:

-----------------------------[ cut here ]-----------------------------
# cat /etc/init.d/S50bridge
#!/bin/bash

ip link del br0
ip link add br0 type bridge vlan_filtering 1
for eth in lan1 lan2 lan3 lan4 lan5 lan6 lan7 lan8 lan9 lan10 lan11 lan12 lan13 lan14 lan15 lan16 lan17 lan18 lan19 lan20 lan21 lan22 lan23 lan24 sfp; do
        ip link set ${eth} master br0
done

# For TFTP, the server is connected to sfp
# bridge vlan add dev sfp vid 100
bridge vlan add dev lan19 vid 100

# lan1-lan24 are the for board access to TFTP. Use VLAN 100.
# FIXME: I removed lan19 from this list and now use it for TFTP server
for eth in lan1 lan2 lan3 lan4 lan5 lan6 lan7 lan8 lan9 lan10 lan11 lan12 lan13 lan14 lan15 lan16 lan17 lan18 lan20 lan21 lan22 lan23 lan24; do
        bridge vlan del dev ${eth} vid 1
        bridge vlan add dev ${eth} vid 100 pvid untagged
done

ip link set br0 up
-----------------------------[ cut here ]-----------------------------

Before this series:

time /etc/init.d/S50bridge
real    0m8.809s
user    0m0.253s
sys     0m2.614s

time ip link del br0
real    0m4.509s
user    0m0.006s
sys     0m1.184s

After:

time /etc/init.d/S50bridge
real    0m8.270s
user    0m0.199s
sys     0m2.468s

time ip link del br0
real    0m3.964s
user    0m0.000s
sys     0m1.024s

So there is a (small, but still visible) improvement - note that
mv88e6xxx is heavily limited by MDIO access anyway, and that would be
the predominant latency.

Also, I noticed that I forgot an unused "int port" variable in
felix_vsc9959.c variable, that I'm sure the kernel test robot will
complain about. So this is just RFC for now.
