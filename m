Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757CB25B877
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 03:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgICByi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 21:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgICByg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 21:54:36 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA46FC061244;
        Wed,  2 Sep 2020 18:54:33 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id m8so920936pfh.3;
        Wed, 02 Sep 2020 18:54:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AbX3xaVNmMCXv/ZEBehiM7Hryv15WbixbRnad2CHtUg=;
        b=ZzFyR8SHD1+4u3C7J7jw1/tujGX13Bx5EFcya7APsryvND/NRi7BLyCVvpA2Ws8Ena
         M1nlQzEdvXCcdvPIxo6Wpxj3rGGvRi9NbwXEuErTFHGln18t8ziIUTktXDbFxPEDMrZ4
         xqYKpebMtf1wNxgvSfjK8IsuuARWIN7oN+GZRRmaGcv729huR3rSUdYBhTkPp1n7nAre
         HyLHmR9sClEVSL5HwwcQQ+qUL7Is/5SWZqAfLs+wqZzQcSXzHR23tzKjGTwLq+2EyJ3I
         1KOHhnSmojF2TA6tQDgzkioNJ74GAyXtU1It7kATUMfWRfOlNirZ5BYonQgDhQIViu3W
         Uv/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AbX3xaVNmMCXv/ZEBehiM7Hryv15WbixbRnad2CHtUg=;
        b=ccWxFxLFdRN7dsEWOtTQV7C1xF20xGhAFObWwCW9/m8udDNe5pAOH6bfkNU6F58Nm/
         oTuo/7qS7wR1Iygzv+LrmT8luLdM58QSQRkYGQfH+GyDdet4QSkhg9klTQPBNyAZYyQe
         mpC3pVMipOSNyLU+lZZIU1MRwSYR69vjATJnbkmj+1gttE2WCl+BS+ePuUQO+wr7k7Nv
         X2quSZTOvnHYiKJKFfmmcL3oXyg3IqkLqHDh6BhbnibV8I1dUWBferEhiJc3GOpHtya3
         fxHS6GIxo+cYU2kmUcxcTCeKSbx+6lbD2MmC1Qco6LHPe05uYf5u9z0p8W/dcrrQ0urP
         WFOA==
X-Gm-Message-State: AOAM530NAy7nemxlW1Gx3ptBfPzjH+jJCsphLz+AfuRA3wogiKM5V0Rd
        MgumCsc3dJPAHI0JHbjJXu2+cMOEWhw=
X-Google-Smtp-Source: ABdhPJxDHudhWPHWrlgxHskQUXK7dkcDapJ2y21vEcm9he+gMBa63RCZCmbHjzUmyFjo4N9kH0gV1A==
X-Received: by 2002:a62:fb05:: with SMTP id x5mr1307011pfm.121.1599098072426;
        Wed, 02 Sep 2020 18:54:32 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 65sm846228pfx.104.2020.09.02.18.54.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 18:54:31 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: bcm_sf2: Ensure that MDIO diversion is
 used
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20200902210328.3131578-1-f.fainelli@gmail.com>
 <20200903011324.GE3071395@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <28177f17-1557-bd69-e96b-c11c39d71145@gmail.com>
Date:   Wed, 2 Sep 2020 18:54:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200903011324.GE3071395@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/2020 6:13 PM, Andrew Lunn wrote:
> On Wed, Sep 02, 2020 at 02:03:27PM -0700, Florian Fainelli wrote:
>> Registering our slave MDIO bus outside of the OF infrastructure is
>> necessary in order to avoid creating double references of the same
>> Device Tree nodes, however it is not sufficient to guarantee that the
>> MDIO bus diversion is used because of_phy_connect() will still resolve
>> to a valid PHY phandle and it will connect to the PHY using its parent
>> MDIO bus which is still the SF2 master MDIO bus.
>>
>> Ensure that of_phy_connect() does not suceed by removing any phandle
>> reference for the PHY we need to divert. This forces the DSA code to use
>> the DSA slave_mii_bus that we register and ensures the MDIO diversion is
>> being used.
> 
> Hi Florian
> 
> Sorry, i don't get this explanation. Can you point me towards a device
> tree i can look at to maybe understand what is going on.
The firmware provides the Device Tree but here is the relevant section 
for you pasted below. The problematic device is a particular revision of 
the silicon (D0) which got later fixed (E0) however the Device Tree was 
created after the fixed platform, not the problematic one. Both 
revisions of the silicon are in production.

There should have been an internal MDIO bus created for that chip 
revision such that we could have correctly parented phy@0 (bcm53125 
below) as child node of the internal MDIO bus, but you have to realize 
that this was done back in 2014 when DSA was barely revived as an active 
subsystem. The BCM53125 node should have have been converted to an 
actual switch node at some point, I use a mdio_boardinfo overlay 
downstream to support the switch as a proper b53/DSA switch, anyway.

The problem is that of_phy_connect() for port@1 will resolve the 
phy-handle from the mdio@403c0 node, which bypasses the diversion 
completely. This results in this double programming that the diversion 
refers to. In order to force of_phy_connect() to fail, and have DSA call 
to dsa_slave_phy_connect(), we must deactivate ethernet-phy@0 from 
mdio@403c0, and the best way to do that is by removing the phandle 
property completely.

Hope this clarifies the mess :)


		switch_top@f0b00000 {
			#address-cells = <0x01>;
			#size-cells = <0x01>;
			compatible = "brcm,bcm7445-switch-top-v2.0\0simple-bus";
			ranges = <0x00 0xf0b00000 0x40804>;

			ethernet_switch@0 {
				#address-cells = <0x02>;
				#size-cells = <0x00>;
				brcm,num-acb-queues = <0x40>;
				brcm,num-gphy = <0x01>;
				brcm,num-rgmii-ports = <0x02>;
				compatible = "brcm,bcm7445-switch-v4.0\0brcm,bcm53012";
				dsa,ethernet = <0x16>;
				dsa,mii-bus = <0x17>;
				resets = <0x18 0x1a>;
				reset-names = "switch";
				reg = <0x00 0x40000 0x40000 0x110 0x40340 0x30 0x40380 0x30 0x40400 
0x34 0x40600 0x208>;
				reg-names = "core\0reg\0intrl2_0\0intrl2_1\0fcb\0acb";
				interrupts = <0x00 0x18 0x04 0x00 0x19 0x04>;
				interrupt-names = "switch_0\0switch_1";
				brcm,fcb-pause-override;
				brcm,acb-packets-inflight;
				clocks = <0x0a 0x6d 0x0a 0x76>;
				clock-names = "sw_switch\0sw_switch_mdiv";

				ports {
					#address-cells = <0x01>;
					#size-cells = <0x00>;

					port@0 {
						phy-mode = "internal";
						phy-handle = <0x29>;
						linux,phandle = <0x2a>;
						phandle = <0x2a>;
						reg = <0x00>;
						label = "gphy";
					};

					port@1 {
						phy-mode = "rgmii-txid";
						phy-handle = <0x2c>;
						linux,phandle = <0x2d>;
						phandle = <0x2d>;
						reg = <0x01>;
						label = "rgmii_1";
					};

					port@2 {
						phy-mode = "rgmii-txid";
						fixed-link = <0x02 0x01 0x3e8 0x00 0x00>;
						linux,phandle = <0x2f>;
						phandle = <0x2f>;
						reg = <0x02>;
						label = "rgmii_2";
					};

					port@7 {
						phy-mode = "moca";
						fixed-link = <0x07 0x01 0x3e8 0x00 0x00>;
						linux,phandle = <0x31>;
						phandle = <0x31>;
						reg = <0x07>;
						label = "moca";
					};

					port@8 {
						linux,phandle = <0x33>;
						phandle = <0x33>;
						reg = <0x08>;
						label = "cpu";
						ethernet = <0x16>;
					};
				};
			};

			mdio@403c0 {
				reg = <0x403c0 0x08 0x40300 0x18>;
				#address-cells = <0x01>;
				#size-cells = <0x00>;
				compatible = "brcm,bcm7445-mdio-v4.0\0brcm,unimac-mdio";
				reg-names = "mdio\0mdio_indir_rw";
				clocks = <0x0a 0x6d>;
				clock-names = "sw_switch";
				linux,phandle = <0x17>;
				phandle = <0x17>;

				ethernet-phy@0 {
					linux,phandle = <0x2c>;
					phandle = <0x2c>;
					broken-turn-around;
					device_type = "ethernet-phy";
					max-speed = <0x3e8>;
					reg = <0x00>;
					compatible = "brcm,bcm53125\0ethernet-phy-ieee802.3-c22";
				};

				ethernet-phy@5 {
					linux,phandle = <0x29>;
					phandle = <0x29>;
					clock-names = "sw_gphy";
					clocks = <0x0a 0x63>;
					device_type = "ethernet-phy";
					max-speed = <0x3e8>;
					reg = <0x05>;
					compatible = "brcm,28nm-gphy\0ethernet-phy-ieee802.3-c22";
				};
			};
		};
-- 
Florian
