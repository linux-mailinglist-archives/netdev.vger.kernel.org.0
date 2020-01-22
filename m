Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B493B144C7E
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 08:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgAVHcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 02:32:36 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:54353 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVHcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 02:32:36 -0500
Received: by mail-wm1-f66.google.com with SMTP id b19so5682292wmj.4;
        Tue, 21 Jan 2020 23:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fm/bzorqFXGRjSleITF9pD+r1ENd6CB0azL8igPUALM=;
        b=VDzeQxeEhDd8ZKku1Vsa6Rm+0dEX0MsSrnfFkdfeGLwJy/mHgwEerx7eS8/YGXEbxr
         fyEL+uolSK2w7xtim5NpnRib0fMpIpzzD4fTzsPKUkHpTmHE2AJMShtmpCJAYDJkeJfi
         V9M2aHfVdu8ai4eNZ8fDRxLyX+uaMPI3rK/B5Dv5n6RV0aIWB2x6tFbIRGtF93S+yJD7
         P4Km/plRniTRmu24NArSI3NaiO9WS4KR483rANpvgUlGIQ/eFZh9G5TaKcRj/x4m86MZ
         yWIy330NA0EvuDPtSQ2KQbJIFWWKPn32Q6b3HiCm6rvGSriyBRD4L3WquLLdMYnW+ei2
         hV3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fm/bzorqFXGRjSleITF9pD+r1ENd6CB0azL8igPUALM=;
        b=glXZx9tBqWzQV8e5dxs0Q3m6plOiWkbBHYmubFfqtXgy/Ie5c9IhG+Lt/tJKdmBjgj
         HyCcABnvB+ZJoEgRRkie7ai+PJD2OmgBr/62lw00Qq9FZ9W6C0937NyfUft6eFIZZtEo
         WKNFPxHa1SBvaDPO+zMuoOQN/XecCFN1Tvn+OeO98w+VMs+RUKV3WLKaPwVf7BTg9rze
         jWea9lx+1/dbBCYuikRkKSilKsEgodzjxGSekTz6grrMksUS3KGln0wyoIJFIeIRibvE
         zi6dkFDljcweW+iANLMhP3N8fPWzSi5wwahWCjmQB6+Zs/uPD+yvqpbqYi16ewYVnHq7
         f+LQ==
X-Gm-Message-State: APjAAAUDMHIXp1qHxqA55Bda7lXyiwy6IA/BDaPeANMWovS36puYbIw+
        45b1vg1BG7VqNql9+N20EdEjpAWT
X-Google-Smtp-Source: APXvYqxsj7I9WlzOG+WOoPFUiCwN4qWOvJotIYRZmaWyfy5/ihC4mSOyzoLZoK6R3hu9TVPC7u6gzA==
X-Received: by 2002:a7b:cf0d:: with SMTP id l13mr1458811wmg.13.1579678354144;
        Tue, 21 Jan 2020 23:32:34 -0800 (PST)
Received: from ?IPv6:2003:ea:8f36:6800:9425:8dfb:676f:4467? (p200300EA8F36680094258DFB676F4467.dip0.t-ipconnect.de. [2003:ea:8f36:6800:9425:8dfb:676f:4467])
        by smtp.googlemail.com with ESMTPSA id a132sm2495983wme.3.2020.01.21.23.32.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 23:32:33 -0800 (PST)
Subject: Re: [PATCH v2 net-next] net: convert suitable drivers to use
 phy_do_ioctl_running
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Doug Berger <opendmb@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Timur Tabi <timur@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        linux-renesas-soc@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <2db5d899-a550-456d-a725-f7cf009f53a3@gmail.com>
 <9d2dbcc0-7e22-601a-35f6-135f2a9e6f99@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ec2a401d-e504-da38-8bc7-1826f5de7941@gmail.com>
Date:   Wed, 22 Jan 2020 08:28:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <9d2dbcc0-7e22-601a-35f6-135f2a9e6f99@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.01.2020 05:04, Florian Fainelli wrote:
> 
> 
> On 1/21/2020 1:09 PM, Heiner Kallweit wrote:
>> Convert suitable drivers to use new helper phy_do_ioctl_running.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> The vast majority of drivers that you are converting use the following
> convention:
> 
> - !netif_running -> return -EINVAL
> - !dev->phydev -> return -ENODEV
> 
> so it may make sense to change the helper to accommodate the majority
> here, not that I believe this is going to make much practical
> difference, but if there were test cases that were specifically looking
> for such an error code, they could be failing after this changeset.
> 
Right, I also stumbled across the different error codes, mainly as you
say -EINVAL. However there is no "wrong value", if netdev isn't running,
then typically the PHY is not attached, and from a netdev point of view
it's not there. So ENODEV seems to be best suited.
In kernel code the changed return code doesn't make a difference,
but yes, in theory there could be userspace programs checking for
-EINVAL. However such userspace programs should check for ENODEV too
anyway to cover the second check that already returns -ENODEV.

> For bgmac.c, bcmgenet.c and cpmac.c:
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> Whether you decide to spin another version or not.
> 
Heiner
