Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3EC6D58C9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232605AbjDDGbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbjDDGbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:31:18 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA8F8122
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 23:31:16 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id cn12so126286162edb.4
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 23:31:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680589875;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pv2oUJAE+rLFtOeK6dzRsHk8Ej+DmZs14rXkWmH2Wog=;
        b=qsnm7S+ANWJ2V+Ovs2QKcTDBJG5CPtDfchnVDazqMzEQyRpJnFJquBHvvOEgTeOxMx
         8zgl86nhdVz16lacnjwvjbaExVawLJPI46i35fc6YT3AtGZ3vpRw/xO3NCNmZoXCWTav
         W7L8SIJOuCpf0/RNYF1BINSpp0svEBSPyC68UbU5lgOmXEmcptw2P0OtSOYkKLO9QnkR
         gfr+q3Ede1vcngN0IEXWoVS+O/4jHexVPUJ3kW1mbfqVRD0P4UvH1avh6njDZnVO5IjH
         WVZXAv7neaZPeRb7vxKld3yoOKrHcexBN1n7R1LLwX5KKD0PIi70nkhdHpfKw5z5B9KL
         MU3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680589875;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pv2oUJAE+rLFtOeK6dzRsHk8Ej+DmZs14rXkWmH2Wog=;
        b=sxZpwh2Wv4JKJVaQHhE6DXIUnVzbAveHH22egYcDMG6FC4lvEY2Yd63sQBBFHMWwa/
         BTXSzQsZ97M2FNzfMuMwwQYK9WMkKWoGdAnrKh+2FHqBe5o5nY9uDfM6IzzedUE92fsl
         3WEhGAG/jDT/QDK1wXYgR5iuXO5odExkBKgoxZKQYAuD/3Z1yGAvMcKy+y2B6wLmYgIi
         9IgVYK5fmzS4prMdsxib6725Ipkk7nsdWG26OSUcCtmCOuDPrxN8HyyqIpG3+6YPF9cu
         tGDGI5RYAYjWUhqtbysAnK4aU5RErPpzHGfGGatsWH8K8L8vCXN/nMaViDAREzGdZCor
         CKPg==
X-Gm-Message-State: AAQBX9eCzDe1PQJERI3e04+Xt1zhiUcct3N/hINDvPTW7ATPL0alMv7P
        1GsDuvnvTGGS8PPY29rePlKMQzM8ORk=
X-Google-Smtp-Source: AKy350bhvtE9yoTVKRPDbox2yxutAx/ED8IiEtwRZLsWpAeE6XIR/3DRH53K4IWMrVxU+vwRKgmCcA==
X-Received: by 2002:a17:906:cc49:b0:931:7adf:547e with SMTP id mm9-20020a170906cc4900b009317adf547emr1048239ejb.70.1680589875101;
        Mon, 03 Apr 2023 23:31:15 -0700 (PDT)
Received: from ?IPV6:2a02:3100:946d:f000:7455:b7f7:370f:be1a? (dynamic-2a02-3100-946d-f000-7455-b7f7-370f-be1a.310.pool.telefonica.de. [2a02:3100:946d:f000:7455:b7f7:370f:be1a])
        by smtp.googlemail.com with ESMTPSA id g19-20020a17090613d300b0091fdd2ee44bsm5460189ejc.197.2023.04.03.23.31.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Apr 2023 23:31:14 -0700 (PDT)
Message-ID: <a0570b00-669f-120d-2700-a97317466727@gmail.com>
Date:   Tue, 4 Apr 2023 08:31:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>,
        Chukun Pan <amadeus@jmu.edu.cn>
Cc:     John Crispin <john@phrozen.org>
References: <ZCtvaxY2d74XLK6F@makrotopia.org>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Convention regarding SGMII in-band autonegotiation
In-Reply-To: <ZCtvaxY2d74XLK6F@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.04.2023 02:29, Daniel Golle wrote:
> Hi!
> 
> I've been dealing with several SGMII TP PHYs, some of them with support
> for 2500Base-T, by switching to 2500Base-X interface mode (or by using
> rate-adaptation to 2500Base-X or proprietary HiSGMII).
> 
> Dealing with such PHYs in MAC-follow-PHY-rate-mode (ie. not enabling
> rate-adaptation which is worth avoiding imho) I've noticed that the
> current behavior of PHY and MAC drivers in the kernel is not as
> consistent as I assumed it would be.
> 
> Background:
>>From Russell's comments and the experiments carried out together with
> Frank Wunderlich for the MediaTek SGMII PCS found in mtk_eth_soc I
> understood that in general in-band autonegotiation should always be
> switched off unless phylink_autoneg_inband(mode) returns true, ie.
> mostly in case 'managed = "in-band-status";' is set in device tree,
> which is generally the case for SFP cages or PHYs which are not
> accessible via MDIO.
> 
> As of today this is what pcs-mtk-lynxi is now doing as this behavior
> was inherited from the implementation previously found at
> drivers/net/ethernet/mediatek/mtk_sgmii.c.
> 
> Hence, with MLO_AN_PHY we are expecting both MAC and PHY to *not* use
> in-band autonegotiation. It is not needed as we have out-of-band status
> using MDIO and maybe even an interrupt to communicate the link status
> between the two. Correct so far?
> 
> I've also previously worked around this using Vladimir Oltean's patch
> series introducing sync'ing and validation of in-band-an modes between
> MAC and PHY -- however, this turns out to be overkill in case the
> above is true and given there is a way to always switch off in-band-an
> on both, the MAC and the PHY.
> 
> Or should PHY drivers setup in-band AN according to
> pl->config->ovr_an_inband...?
> 
> Also note that the current behavior of PHY drivers is that consistent:
> 
>  * drivers/net/phy/mxl-gpy.c
>    This goes through great lengths to switch on inband-an when initially
>    coming up in SGMII mode, then switches is off when switching to
>    2500Base-X mode and after that **never switches it on again**. This
>    is obviously not correct and the driver can be greatly reduced if
>    dropping all that (non-)broken logic.
>    Would a patch like [1] this be acceptable?
> 
>  * drivers/net/phy/realtek.c
>    The driver simply doesn't do anything about in-band-an and hence looks
>    innocent. However, all RTL8226* and RTL8221* PHYs enable in-band-an
>    by default in SGMII mode after reset. As many vendors use rate-adapter-
>    mode, this only surfaces if not using the rate-adapter and having the
>    MAC follow the PHY mode according to speed, as we do using [2] and [3].
> 
These PHY's are supported as internal PHY's in RTL8125 MAC/PHY chips
where the MAC/PHY communication is handled chip-internally.
Other use cases are not officially supported (yet), also due to lack of
public datasheets.

>    SGMII in-band AN can be switched off using a magic sequence carried
>    out on undocumented registers [5].
> 
>    Would patches [2], [3], [4], [5] be acceptable?
> 
Ideas from the patches can be re-used. Some patches itself are not ready
for mainline (replace magic numbers with proper constants (as far as
documented by Realtek), inappropriate use of phy_modify_mmd_changed,
read_status() being wrong place for updating interface mode).

> 
> Thank you for your advise!
> 
> 
> Daniel
> 
> [1]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/mediatek/patches-5.15/731-net-phy-hack-mxl-gpy-disable-sgmii-an.patch;hb=HEAD
> [2]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/721-net-phy-realtek-rtl8221-allow-to-configure-SERDES-mo.patch;hb=HEAD
> [3]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/722-net-phy-realtek-support-switching-between-SGMII-and-.patch;hb=HEAD
> [4]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/724-net-phy-realtek-use-genphy_soft_reset-for-2.5G-PHYs.patch;hb=HEAD
> [5]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/725-net-phy-realtek-disable-SGMII-in-band-AN-for-2-5G-PHYs.patch;hb=HEAD

