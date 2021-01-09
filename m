Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DBF2EFDA5
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 05:07:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbhAIEG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 23:06:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbhAIEG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 23:06:26 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05ABC061573
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 20:05:45 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y12so491006pji.1
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 20:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kdQkyUxxGDk7qMa1WSeOYT4EhY1gS3x3LZAIiY+B7+M=;
        b=BiZaTF8N3eaCaPfqD5EyTLLdl7TJuCXbXOQ3BbDN3mmBisAf+Wvd/RTpuBk4JFUM6r
         Ou/Pe5wQjiOP7NpttoS4QnIt1Plncf1ZX1GJ0J1UKEfsLcMZfNhOYLdtbJsOwohCDaRs
         CtaAxABB0n9knDpgju9dYoMoQuKp9hwZHM8YN+kMdxnPaRnD+Hn/2adZ3luPShukJuws
         PwzcBZKFQN7Zc8G/w3Ttdw8Z/20HZF0psPcfT+vB+YNqiFYE51NR/EMIdgMLSaGdoGs2
         2mSv9QwhtjC2vbC/jJAbDEsR8hkc5rv/R1VE9hOKXzvhkI7e3fuLRixFcx8AssyPGXMX
         ByGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kdQkyUxxGDk7qMa1WSeOYT4EhY1gS3x3LZAIiY+B7+M=;
        b=sSm3iwllpw2E8ac52cnvneyPJAyTJjppqc90AwNKmVoCf1igDWo6gGgwbF3vQe1r6h
         FfU5Onh1DfdjEmZjKn8EtTF/Yn51kIIG86XvWvLgmjuPhZXSrlGEVhPkZgm+7C6h5zod
         4bEhU80BkzxokMyA5Z5sazdvnUvutXLYqnTsuKiE6mEhem1F/TMCJbgYRrpBUk4LZZ1X
         vOGKDipfNlS4U5iNe72V+28lmhxr38vR0lbKRWY+rEUPQB4B4cyC40tCPdLE0khhuMP2
         xeGIBuHZKyc86s1/b5TNBh7idm8tgPemKIH272TIwd7fpDSZNlLpm4xKaNIL5V76YXhu
         TSyg==
X-Gm-Message-State: AOAM532VPk8vWD7AqNiKW1pl3lx8umfgdDqaGN3gi1Qq75/9/3Ao6w6B
        coBiKzLyidKHb05w5tlR/S4=
X-Google-Smtp-Source: ABdhPJzA+lRexjuRv/mLLJdPrjeRVZpM8dEBujUYtzQkKNSRnXmPI9XJTvD3xRjYdhDE2urDPEob4Q==
X-Received: by 2002:a17:902:ed0d:b029:da:c83b:5f40 with SMTP id b13-20020a170902ed0db02900dac83b5f40mr10253451pld.20.1610165145353;
        Fri, 08 Jan 2021 20:05:45 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m4sm10739296pgv.16.2021.01.08.20.05.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 20:05:44 -0800 (PST)
Subject: Re: [PATCH v4 net-next 02/11] net: dsa: mv88e6xxx: deny vid 0 on the
 CPU port and DSA links too
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Petr Machata <petrm@nvidia.com>
References: <20210109000156.1246735-1-olteanv@gmail.com>
 <20210109000156.1246735-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <eec03805-d240-07c5-f5a1-5a0248419666@gmail.com>
Date:   Fri, 8 Jan 2021 20:05:41 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210109000156.1246735-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 4:01 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> mv88e6xxx apparently has a problem offloading VID 0, which the 8021q
> module tries to install as part of commit ad1afb003939 ("vlan_dev: VLAN
> 0 should be treated as "no vlan tag" (802.1p packet)"). That mv88e6xxx
> restriction seems to have been introduced by the "VTU GetNext VID-1
> trick to retrieve a single entry" - see commit 2fb5ef09de7c ("net: dsa:
> mv88e6xxx: extract single VLAN retrieval").
> 
> There is one more problem. The mv88e6xxx CPU port and DSA links do not
> report properly in the prepare phase what are the VLANs that they can
> offload. They'll say they can offload everything:
> 
> mv88e6xxx_port_vlan_prepare
> -> mv88e6xxx_port_check_hw_vlan:
> 
> 	/* DSA and CPU ports have to be members of multiple vlans */
> 	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
> 		return 0;
> 
> Except that if you actually try to commit to it, they'll error out and
> print this message:
> 
> [   32.802438] mv88e6085 d0032004.mdio-mii:12: p9: failed to add VLAN 0t
> 
> which comes from:
> 
> mv88e6xxx_port_vlan_add
> -> mv88e6xxx_port_vlan_join:
> 
> 	if (!vid)
> 		return -EOPNOTSUPP;
> 
> What prevents this condition from triggering in real life? The fact that
> when a DSA_NOTIFIER_VLAN_ADD is emitted, it never targets a DSA link
> directly. Instead, the notifier will always target either a user port or
> a CPU port. DSA links just happen to get dragged in by:
> 
> static bool dsa_switch_vlan_match(struct dsa_switch *ds, int port,
> 				  struct dsa_notifier_vlan_info *info)
> {
> 	...
> 	if (dsa_is_dsa_port(ds, port))
> 		return true;
> 	...
> }
> 
> So for every DSA VLAN notifier, during the prepare phase, it will just
> so happen that there will be somebody to say "no, don't do that".
> 
> This will become a problem when the switchdev prepare/commit transactional
> model goes away. Every port needs to think on its own. DSA links can no
> longer bluff and rely on the fact that the prepare phase will not go
> through to the end, because there will be no prepare phase any longer.
> 
> Fix this issue before it becomes a problem, by having the "vid == 0"
> check earlier than the check whether we are a CPU port / DSA link or not.
> Also, the "vid == 0" check becomes unnecessary in the .port_vlan_add
> callback, so we can remove it.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
