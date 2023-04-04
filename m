Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FF736D5C76
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 11:56:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234211AbjDDJ4v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 05:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbjDDJ4u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 05:56:50 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3493D2686
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 02:56:49 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id cn12so128273054edb.4
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 02:56:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680602207;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mQMc29IUk6E+ep05u7/y0jtFFk3zeRGAVA0UueY64OY=;
        b=a/uIztRG/3RYYdzv4Hgsa/BJVKY76EL3IqD0upDVmMpYQdMJGn4Y6OxP6lN1M6EEy/
         qZ1MiVoZ44gq7MNqUgMheDnQSwINBqBerhJsv9DyIfGLfWlmyWzl+JmFPF0utyb3gpI2
         fHU42eSIm2QjyIEi7TBjCVdVpNeKahMyDYI3C2cKPZfQOijJkIUKVQ21x7asnkoWDMzn
         z88jVzJ+a/ryiVMhn8UrKzKfWTYb3cOHu8vDBw1lmjdCLN2XZs5KwXf49Xc3uvbsdPdh
         PnqyBqMbu8xkY+5DUBzRqybB893Dale2fDKY96Fz7dyo4hORq6IlRvcJLQyFKe13s2PR
         SF3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680602207;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mQMc29IUk6E+ep05u7/y0jtFFk3zeRGAVA0UueY64OY=;
        b=AVcFdHIAcpv9C+4ZOoGvGWUFv/Tk82DHTTPmyUVQFqY+biYJhK4jCq17HCth1osFgv
         yd6iXX/Hlenug3Fbk7KnqXW49wCrk0LMOjlwsC9RHkmYRM8ZsBptQfhbYbQx1FRB7Ust
         p8GSNr4A+p8gp71TioCPlpZ6xXebKIhVmeSU6+h5a4OIuTKKjcKeQ0243jLhj7P/rwU7
         lC1WNCF1Ey0mQQhFpvlQg6Sa9mlFtPBvx4sSI5x9lCnfapI2H18SAGy7LwYAWRqDC+A+
         RB+ObCBlHVSTIzqMYQGY59pSTXWLVTbhYLsMWPe3xsY2HNLSRKRkGeik+YZ3lVFE31FU
         FY5w==
X-Gm-Message-State: AAQBX9e5wtCMV/9atWRmGlCvVj2vj04ewW44GITi3H9eaoHZWDCpU+TO
        AcG11NpIAh3e48f6ho5EJGA=
X-Google-Smtp-Source: AKy350Y1z1dlFP9ex5M/Rzti8KiJK7PAPIpe0rCi5w3byhU8bb+YDHUXgIllIkapxGrYJVqSIsp9ow==
X-Received: by 2002:a17:906:eca6:b0:8de:502e:2061 with SMTP id qh6-20020a170906eca600b008de502e2061mr2052155ejb.3.1680602207480;
        Tue, 04 Apr 2023 02:56:47 -0700 (PDT)
Received: from ?IPV6:2a02:3100:946d:f000:858:f63d:e126:2fab? (dynamic-2a02-3100-946d-f000-0858-f63d-e126-2fab.310.pool.telefonica.de. [2a02:3100:946d:f000:858:f63d:e126:2fab])
        by smtp.googlemail.com with ESMTPSA id qb34-20020a1709077ea200b00948f41af90dsm966103ejc.166.2023.04.04.02.56.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 02:56:47 -0700 (PDT)
Message-ID: <539986da-0bf7-8dd3-73d7-a2a584846f18@gmail.com>
Date:   Tue, 4 Apr 2023 11:56:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Alexander 'lynxis' Couzens <lynxis@fe80.eu>,
        Chukun Pan <amadeus@jmu.edu.cn>,
        John Crispin <john@phrozen.org>
References: <ZCtvaxY2d74XLK6F@makrotopia.org>
 <a0570b00-669f-120d-2700-a97317466727@gmail.com>
 <ZCvqJAVjOdogEZKD@makrotopia.org>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: Convention regarding SGMII in-band autonegotiation
In-Reply-To: <ZCvqJAVjOdogEZKD@makrotopia.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.04.2023 11:13, Daniel Golle wrote:
> On Tue, Apr 04, 2023 at 08:31:12AM +0200, Heiner Kallweit wrote:
>> On 04.04.2023 02:29, Daniel Golle wrote:
>>> Hi!
>>>
>>> I've been dealing with several SGMII TP PHYs, some of them with support
>>> for 2500Base-T, by switching to 2500Base-X interface mode (or by using
>>> rate-adaptation to 2500Base-X or proprietary HiSGMII).
>>>
>>> Dealing with such PHYs in MAC-follow-PHY-rate-mode (ie. not enabling
>>> rate-adaptation which is worth avoiding imho) I've noticed that the
>>> current behavior of PHY and MAC drivers in the kernel is not as
>>> consistent as I assumed it would be.
>>>
>>> Background:
>>> >From Russell's comments and the experiments carried out together with
>>> Frank Wunderlich for the MediaTek SGMII PCS found in mtk_eth_soc I
>>> understood that in general in-band autonegotiation should always be
>>> switched off unless phylink_autoneg_inband(mode) returns true, ie.
>>> mostly in case 'managed = "in-band-status";' is set in device tree,
>>> which is generally the case for SFP cages or PHYs which are not
>>> accessible via MDIO.
>>>
>>> As of today this is what pcs-mtk-lynxi is now doing as this behavior
>>> was inherited from the implementation previously found at
>>> drivers/net/ethernet/mediatek/mtk_sgmii.c.
>>>
>>> Hence, with MLO_AN_PHY we are expecting both MAC and PHY to *not* use
>>> in-band autonegotiation. It is not needed as we have out-of-band status
>>> using MDIO and maybe even an interrupt to communicate the link status
>>> between the two. Correct so far?
>>>
>>> I've also previously worked around this using Vladimir Oltean's patch
>>> series introducing sync'ing and validation of in-band-an modes between
>>> MAC and PHY -- however, this turns out to be overkill in case the
>>> above is true and given there is a way to always switch off in-band-an
>>> on both, the MAC and the PHY.
>>>
>>> Or should PHY drivers setup in-band AN according to
>>> pl->config->ovr_an_inband...?
>>>
>>> Also note that the current behavior of PHY drivers is that consistent:
>>>
>>>  * drivers/net/phy/mxl-gpy.c
>>>    This goes through great lengths to switch on inband-an when initially
>>>    coming up in SGMII mode, then switches is off when switching to
>>>    2500Base-X mode and after that **never switches it on again**. This
>>>    is obviously not correct and the driver can be greatly reduced if
>>>    dropping all that (non-)broken logic.
>>>    Would a patch like [1] this be acceptable?
>>>
>>>  * drivers/net/phy/realtek.c
>>>    The driver simply doesn't do anything about in-band-an and hence looks
>>>    innocent. However, all RTL8226* and RTL8221* PHYs enable in-band-an
>>>    by default in SGMII mode after reset. As many vendors use rate-adapter-
>>>    mode, this only surfaces if not using the rate-adapter and having the
>>>    MAC follow the PHY mode according to speed, as we do using [2] and [3].
>>>
>> These PHY's are supported as internal PHY's in RTL8125 MAC/PHY chips
>> where the MAC/PHY communication is handled chip-internally.
>> Other use cases are not officially supported (yet), also due to lack of
>> public datasheets.
> 
> The PHYs I've been encountering in the wild are those which were added by
> 74d155be2677a ("net: phy: realtek: Add support for RTL8221B-CG series")
> 
> They are independently packaged ICs. The relevant datasheets are
> not public, but do provide documentation of some but not all registers
> of those PHYs.
> 
>>
>>>    SGMII in-band AN can be switched off using a magic sequence carried
>>>    out on undocumented registers [5].
>>>
>>>    Would patches [2], [3], [4], [5] be acceptable?
>>>
>> Ideas from the patches can be re-used. Some patches itself are not ready
>> for mainline (replace magic numbers with proper constants (as far as
>> documented by Realtek), inappropriate use of phy_modify_mmd_changed,
>> read_status() being wrong place for updating interface mode).
> 
> Unfortunately the registers used to switch off rate-adapter-mode and
> also to switch off (Hi)SGMII in-band autonegotation are entirely
> undocumented even in the non-public datasheet.
> They read/write/read-poll sequences supposedly appear in a document
> called "SERDES Mode Setting Flow Application Note" which also doesn't
> explain the meaning of the registers and their bits.
> 
> Where is updating the interface mode supposed to happen?
> 
> I was looking at drivers/net/phy/mxl-gpy.c which calls its
> gpy_update_interface() function also from gpy_read_status(). If that is
> wrong it should probably be fixed in mxl-gpy.c as well...
> 

Right, several drivers use the read_status() callback for this, I think
the link_change_notify() callback would be sufficient.
In interrupt mode this doesn't really make a difference, however in
polling mode we can avoid polling the register with the interface mode
information (if it's a register that isn't used for other purposes
in read_status() too).

>>
>>>
>>> Thank you for your advise!
>>>
>>>
>>> Daniel
>>>
>>> [1]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/mediatek/patches-5.15/731-net-phy-hack-mxl-gpy-disable-sgmii-an.patch;hb=HEAD
>>> [2]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/721-net-phy-realtek-rtl8221-allow-to-configure-SERDES-mo.patch;hb=HEAD
>>> [3]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/722-net-phy-realtek-support-switching-between-SGMII-and-.patch;hb=HEAD
>>> [4]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/724-net-phy-realtek-use-genphy_soft_reset-for-2.5G-PHYs.patch;hb=HEAD
>>> [5]: https://git.openwrt.org/?p=openwrt/openwrt.git;a=blob_plain;f=target/linux/generic/pending-5.15/725-net-phy-realtek-disable-SGMII-in-band-AN-for-2-5G-PHYs.patch;hb=HEAD
>>

