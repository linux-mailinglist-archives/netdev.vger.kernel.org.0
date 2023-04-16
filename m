Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F3A06E36AD
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 11:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbjDPJic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 05:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjDPJib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 05:38:31 -0400
Received: from sender3-op-o19.zoho.com (sender3-op-o19.zoho.com [136.143.184.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47AE226A0
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 02:38:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681637892; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=cFFMwzraYK+KuxPM69hvSZ+IK0SSJ8wAlPi1N4cPiuC0tMaHs30VzNrAcaPhLRpvavIIamHG+RT7pgla5/442dfLfIxDEAyR/fth51Q3t6E2LaUzUm+Wc3S17rLbpBpQ19HzFQRgSPh1b/QON8XqqyKN1RqkIn5fcXS4zGSHB4w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681637892; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=tvrOzz6+xGmgVvh/aEzUOHUvqKP9hyuu1e3eqS9nJeE=; 
        b=NYq6mW3eXD/iAPnTLMcLGFRQjL6wwCTp0I60ZsiiEJBQVuiY5E1Qxd+dynSYbXzkzV1s8kH7g6tQXsOh2AwsZaH8EHE74akrNvCttTWDM6uybGRfFdGJBSyBRNMKqa6TNC/I9RbEG0JLN0GpXQKqr/ff2SMJY6uIWOfAhnEY9m0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681637892;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:From:From:To:To:Cc:Cc:References:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=tvrOzz6+xGmgVvh/aEzUOHUvqKP9hyuu1e3eqS9nJeE=;
        b=SXh/3W2XPlGCb+ajrORtfuhquGXDBqlXL3RLOJyV0YnESUIecrNgNPjm9/w/E7k+
        s9BVBAoK2rlro3QbYE9UKgIa0GocEjqAl4N2NOSSrlS9yP2+N87q3jgOtcujKVGaNTp
        7n0zmLA7JnFsv3Dt1863DAiGO9E0NJd/YJR5zcBY=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1681637889741573.8601874554939; Sun, 16 Apr 2023 02:38:09 -0700 (PDT)
Message-ID: <2f3796e3-438c-604f-1e61-ccb2fa118aff@arinc9.com>
Date:   Sun, 16 Apr 2023 12:38:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: mt7530: dsa_switch_parse_of() fails, causes probe code to run
 twice
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
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
 <ef677f5f-07a3-2cf7-79d1-ae8980b73701@arinc9.com>
Content-Language: en-US
In-Reply-To: <ef677f5f-07a3-2cf7-79d1-ae8980b73701@arinc9.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15.04.2023 17:57, Arınç ÜNAL wrote:
> On 15.04.2023 17:20, Vladimir Oltean wrote:
>> On Sat, Apr 15, 2023 at 03:02:10PM +0100, Daniel Golle wrote:
>>> As the PHYs are accessed over the MDIO bus which is exposed by the 
>>> mt7530.c
>>> DSA driver the only middle ground would possibly be to introduce a MFD
>>> driver taking care of creating the bus access regmap (MDIO vs. MDIO) and
>>> expose the mt7530-controlled MDIO bus.
>>
>> Which is something I had already mentioned as a possible way forward in
>> the other thread. One would need to take care of ensuring a reasonable
>> migration path in terms of device tree compatibility though.
>>
>>>
>>> Obviously that'd be a bit more work than just moving some things from 
>>> the
>>> switch setup function to the probe function...
>>
>> On the other hand, it would actually work reliably, and would not depend
>> on whomever wanted to reorder things just a little bit differently for
>> his system to probe faster.
> 
> Ok thanks. I will investigate how the switch would be set up with an MFD 
> driver, and how it would affect dt-bindings.
> 
> Looking back at my patch series, currently with this [0], SGMII on 
> MT7531BE's port 6 starts working, and with Daniel's addition [1], the 
> regulator warnings disappear.
> 
> I will submit the patch series as an RFC after addressing Daniel's 
> inline functions suggestion.

I've been giving this some thought. My understanding of probe in this 
context has changed drastically. The probe here is supposed to probe the 
driver, like setting up the pointers, reading from the devicetree, 
filling up the info table, and finally calling dsa_register_switch(). It 
would not necessarily do anything to the switch hardware like resetting 
and reading information from the registers. This is currently how 
mt7530-mdio and mt7530-mmio already operate. So I'm not going to move 
anything from setup to probe.

The duplicate code on mt7530_setup() and mt7531_setup() could rather be 
put on mt753x_setup() instead. But now there's ID_MT7988 also going 
through mt753x_setup, so it's not very feasible to do this anymore, too 
many ID checks there would be.

Moving forward, I will send a separate bugfix patch that makes port 6 on 
MT7531BE work. My patch series will solely be for improving the driver.

Daniel, can you confirm this patch is enough to make port 6 work on 
MT7531BE? I won't touch the PCS creation code here as it'd be an 
improvement rather than a fix, if this works.

https://github.com/arinc9/linux/commit/bb55b97b8f600cf28433e7ff494d296a15191cb3

Arınç
