Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 212E26E3201
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 16:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229805AbjDOO51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Apr 2023 10:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjDOO50 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Apr 2023 10:57:26 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48A983AB7
        for <netdev@vger.kernel.org>; Sat, 15 Apr 2023 07:57:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681570631; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=NDdXah+VJZlYMlwsKOaJAvgwR463hYpAbfE9iA9NhNW8OpYjP7dMo5rzDsJTbCytG5avl3ZAeOfvNhFXNgZqfBWhueMLfm3cDyscxpYvAEv7yGKDfo2RMD6NDIjPz+pgmcQPB+ruEFSNdyMjiNJtIbiDacmOCb60TVvh7agoIl4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681570631; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=1qbfWPGXjyalJRbeTznr3SDg1+TE5UPEz+ltBkVqmuU=; 
        b=PHZqgsanYOK4wxOTED2UCIbndvSEwfy4d0cDKTDBADGaYLYqnLyS1Rs8WMYe0O7Ostu0vsEIz+8ubKJ12J00JRWX0OdYz9ax3a6TGDaKsEHxIAnB5qZunXDoz8sbn1du+78m111IbQ7IFOe1fE2vaW0stWoq6CfMd2RzfbdwDWs=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681570631;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=1qbfWPGXjyalJRbeTznr3SDg1+TE5UPEz+ltBkVqmuU=;
        b=K/Ij1V+f5jd8sXxYzUpIlA7Iah0RotIO0iEEKdbotAUmvmgciBTjvbi9JEOQQJ8v
        0eOl65ewfkVptN94r9KoFfr+vMf27fxXOc0xpsjPKUlboE/Zu86q8UedkClFWvUlIKF
        S85GAG99jXy/NtfNDiZHnwoEX+SO6Rr0fWC4uCcs=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681570630944404.14742198509464; Sat, 15 Apr 2023 07:57:10 -0700 (PDT)
Message-ID: <ef677f5f-07a3-2cf7-79d1-ae8980b73701@arinc9.com>
Date:   Sat, 15 Apr 2023 17:57:05 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        netdev <netdev@vger.kernel.org>, erkin.bozoglu@xeront.com,
        Thibaut <hacks@slashdirt.org>
References: <ZDnnjcG5uR9gQrUb@makrotopia.org>
 <5e10f823-88f1-053a-d691-6bc900bd85a6@arinc9.com>
 <ZDn1QabUsyZj6J0M@makrotopia.org>
 <01fe9c85-f1e0-107a-6fb7-e643fb76544e@arinc9.com>
 <ZDqb9zrxaZywP5QZ@makrotopia.org>
 <9284c5c0-3295-92a5-eccc-a7b3080f8915@arinc9.com>
 <20230415133813.d4et4oet53ifg2gi@skbuf>
 <5f7d58ba-60c8-f635-a06d-a041588f64da@arinc9.com>
 <20230415134604.2mw3iodnrd2savs3@skbuf> <ZDquYkt_5Ku2ysSA@makrotopia.org>
 <20230415142014.katsq5axop6gov3i@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230415142014.katsq5axop6gov3i@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.04.2023 17:20, Vladimir Oltean wrote:
> On Sat, Apr 15, 2023 at 03:02:10PM +0100, Daniel Golle wrote:
>> As the PHYs are accessed over the MDIO bus which is exposed by the mt7530.c
>> DSA driver the only middle ground would possibly be to introduce a MFD
>> driver taking care of creating the bus access regmap (MDIO vs. MDIO) and
>> expose the mt7530-controlled MDIO bus.
> 
> Which is something I had already mentioned as a possible way forward in
> the other thread. One would need to take care of ensuring a reasonable
> migration path in terms of device tree compatibility though.
> 
>>
>> Obviously that'd be a bit more work than just moving some things from the
>> switch setup function to the probe function...
> 
> On the other hand, it would actually work reliably, and would not depend
> on whomever wanted to reorder things just a little bit differently for
> his system to probe faster.

Ok thanks. I will investigate how the switch would be set up with an MFD 
driver, and how it would affect dt-bindings.

Looking back at my patch series, currently with this [0], SGMII on 
MT7531BE's port 6 starts working, and with Daniel's addition [1], the 
regulator warnings disappear.

I will submit the patch series as an RFC after addressing Daniel's 
inline functions suggestion.

[0] 
https://github.com/arinc9/linux/commit/89230fc01c86ec7e6b8a43a7f54ba8db97aaa4cd
[1] 
https://github.com/dangowrt/linux/commit/55035b5ac739914166ed4f026262d0fc9b17bc76

Arınç
