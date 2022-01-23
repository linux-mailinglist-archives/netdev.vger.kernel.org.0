Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2936A497095
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 09:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235980AbiAWIdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 03:33:50 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17475 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiAWIdt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 03:33:49 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1642926791; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=UEM8SjEDx008A9t5vs3nG2qeP4NsC/+JKMgHHzxUIsIPW3F/9SXE4HPmHOO4+aNesEqX5pn33L6CS1KJQqVH7wea2P2AlxlMK7lhtcPsrDX4iXaD43RsU19iU972lToYEIZcwWjCqnqUJWi8Nrb3UPev6F46/eS5jdHH8wUJ9lc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1642926791; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=zGbxDYRTYsCzoHNVUcU5t+8ReMmKxJuY1o4AwKRRb0w=; 
        b=II0VwVD4g0VVNgnbEoA0FKB5CAkS0VrjME0VOGCQ1LPayFcqvz+yl5vL39ujPgJEfLtnv4b4IZQg7DETQ6tGyasjRz7OR/i9RvV4Zqh2YFIcvc0gI5J1KdGW47KyD7xHWMofy0wF2KvlsvmS4cqYFiUGxntyw8P1N5vm0rNgjhw=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1642926791;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=zGbxDYRTYsCzoHNVUcU5t+8ReMmKxJuY1o4AwKRRb0w=;
        b=KxwGjN17pINllD0XcsnaaCkD8TaO8+LnWe89Nein21vY1qANrB/2yEBBlXzBB4jH
        Y2LyZFZEw7ku3cFZK88CJKla8+dtOXLMnR0dPDfB4Z75+Wz7Mr/nUSFOhFqCNwJUd1H
        t637xGky0Ni86z4yTSYsDrt5Yx47xZacFs2ixjMQ=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 164292679058419.182476398373183; Sun, 23 Jan 2022 00:33:10 -0800 (PST)
Message-ID: <02ecce91-7aad-4392-c9d7-f45ca1b31e0b@arinc9.com>
Date:   Sun, 23 Jan 2022 11:33:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: MT7621 SoC Traffic Won't Flow on RGMII2 Bus/2nd GMAC
Content-Language: en-US
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Siddhant Gupta <siddhantgupta416@gmail.com>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        netdev <netdev@vger.kernel.org>, linux-mips@vger.kernel.org,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, openwrt-devel@lists.openwrt.org,
        erkin.bozoglu@xeront.com
References: <83a35aa3-6cb8-2bc4-2ff4-64278bbcd8c8@arinc9.com>
 <CALW65jZ4N_YRJd8F-uaETWm1Hs3rNcy95csf++rz7vTk8G8oOg@mail.gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <CALW65jZ4N_YRJd8F-uaETWm1Hs3rNcy95csf++rz7vTk8G8oOg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Deng,

On 23/01/2022 09:51, DENG Qingfang wrote:
> Hi,
> 
> Do you set the ethernet pinmux correctly?
> 
> &ethernet {
>      pinctrl-names = "default";
>      pinctrl-0 = <&rgmii1_pins &rgmii2_pins &mdio_pins>;
> };

This fixed it! We did have &rgmii2_pins on the gmac1 node (it was 
originally on external_phy) so we never thought to investigate the 
pinctrl configuration further! Turns out &rgmii2_pins needs to be 
defined on the ethernet node instead.

I'll send a patch to address this on mt7621.dtsi.

You saved us a bunch of time, thank you very much!

Cheers.
Arınç
