Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2ED4D3B41
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 21:42:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236566AbiCIUnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 15:43:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbiCIUnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 15:43:11 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F05114D9F8
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 12:42:11 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id q7-20020a7bce87000000b00382255f4ca9so4189285wmj.2
        for <netdev@vger.kernel.org>; Wed, 09 Mar 2022 12:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=aSOCxd0O0AlSABEw2+WmMslTuNXzOT8psYUKdCBZjow=;
        b=iDcQWsrBUQBbOYpkdV/CKJL8qJq5WWMmLaX1Qzg+fJOoD2jytPJDY7x1Az2iaD1WIP
         UOXtgCvsRC8f4nVQFEO6lUFkEWq2gsgVHQ5q9RSXlcJUNj8cxEVoXBKDLazyevhQYLZq
         ce/g6buwwH7nstsQOJkuU1tk3Zl7BaLGCIEovkxHTpISFK+W4DowavUXX6bqokYAykWu
         lEDwcAOkIn22scFP/WqhKCep3FLwxOW75H5aQHsWeKbFXSvYXbg0eBK4K2/sZYn4uwi5
         h10BTo9eBedCvGMAJE4YgRvhm2efV+HnZXG+gCXZEVHiYYG1USxmldmohtySVC+pX+1F
         yYqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=aSOCxd0O0AlSABEw2+WmMslTuNXzOT8psYUKdCBZjow=;
        b=gUhMKH5urGlT4No+iBcRxrnCMir7cOukvCWW05Kv8bTZjTTubQJi4nPw0QyiEHlT5C
         FvrhS47d/D0a8jwh8SuC2LiZkEaJ8Cwopp20/EvVv0+l3AMsLEKnS+GPsmy21TfSSBjk
         MEcM8vG62FyGra2xKwrYkY7JFoWqtAr0+RgtnvBHe434kv6EpP4nC/aHIW9YiuXnJ/UG
         6md/r2PcJbPftIXcAMTHLGjtwYv/c5MOD2rba137egzwQocPK//l5fB3zgkyEPPT2qM5
         tg3eRxgve1q0YZfEjt/ZRh7KbP/1m8xqgO7KjoUd6bFSyH44WewDRJOwJ8RnjKTStsCH
         X0tA==
X-Gm-Message-State: AOAM533NwjOIYcYhkUwyo1CMY5n9pxKRrZrVnEI4k01d/1iwE5cxUPCW
        L69WeD0NITDPZKMLVO6zhMM=
X-Google-Smtp-Source: ABdhPJyOGhORUyM5EXeW2PmVMEuYS8h2EGD1SJyFy4GGHmjvmuDHXyH+wyKl36U7mJjN9GdoJ0W6CA==
X-Received: by 2002:a7b:c114:0:b0:381:f7ee:e263 with SMTP id w20-20020a7bc114000000b00381f7eee263mr9091536wmi.30.1646858530342;
        Wed, 09 Mar 2022 12:42:10 -0800 (PST)
Received: from ?IPV6:2a01:c22:7793:600:9d6a:7788:3389:da6c? (dynamic-2a01-0c22-7793-0600-9d6a-7788-3389-da6c.c22.pool.telefonica.de. [2a01:c22:7793:600:9d6a:7788:3389:da6c])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c410f00b00389d35f7624sm2351990wmi.0.2022.03.09.12.42.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 12:42:09 -0800 (PST)
Message-ID: <44006194-eab1-7ae2-3cc8-41c210efd0b1@gmail.com>
Date:   Wed, 9 Mar 2022 21:42:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Content-Language: en-US
To:     Jerome Brunet <jbrunet@baylibre.com>,
        Erico Nunes <nunes.erico@gmail.com>
Cc:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-sunxi@lists.linux.dev
References: <CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com>
 <1jczjzt05k.fsf@starbuckisacylon.baylibre.com>
 <CAK4VdL2=1ibpzMRJ97m02AiGD7_sN++F3SCKn6MyKRZX_nhm=g@mail.gmail.com>
 <6b04d864-7642-3f0a-aac0-a3db84e541af@gmail.com>
 <CAK4VdL0gpz_55aYo6pt+8h14FHxaBmo5kNookzua9+0w+E4JcA@mail.gmail.com>
 <1e828df4-7c5d-01af-cc49-3ef9de2cf6de@gmail.com>
 <1j8rts76te.fsf@starbuckisacylon.baylibre.com>
 <a4d3fef1-d410-c029-cdff-4d90f578e2da@gmail.com>
 <CAK4VdL08sdZV7o7Bw=cutdmoCEi1NYB-yisstLqRuH7QcHOHvA@mail.gmail.com>
 <435b2a9d-c3c6-a162-331f-9f47f69be5ac@gmail.com>
 <CAK4VdL28nWstiS09MYq5nbtiL+aMbNc=Hzv5F0-VMuNKmX9R+Q@mail.gmail.com>
 <1j5yonnp1a.fsf@starbuckisacylon.baylibre.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: net: stmmac: dwmac-meson8b: interface sometimes does not come up
 at boot
In-Reply-To: <1j5yonnp1a.fsf@starbuckisacylon.baylibre.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.03.2022 15:57, Jerome Brunet wrote:
> 
> On Wed 09 Mar 2022 at 15:45, Erico Nunes <nunes.erico@gmail.com> wrote:
> 
>> On Sun, Mar 6, 2022 at 1:56 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>> You could try the following (quick and dirty) test patch that fully mimics
>>> the vendor driver as found here:
>>> https://github.com/khadas/linux/blob/buildroot-aml-4.9/drivers/amlogic/ethernet/phy/amlogic.c
>>>
>>> First apply
>>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=a502a8f04097e038c3daa16c5202a9538116d563
>>> This patch is in the net tree currently and should show up in linux-next
>>> beginning of the week.
>>>
>>> On top please apply the following (it includes the test patch your working with).
>>
>> I triggered test jobs with this configuration (latest mainline +
>> a502a8f0409 + test patch for vendor driver behaviour), and the results
>> are pretty much the same as with the previous test patch from this
>> thread only.
>> That is, I never got the issue with non-functional link up anymore,
>> but I get the (rare) issue with link not going up.
>> The reproducibility is still extremely low, in the >1% range.
> 
> Low reproducibility means the problem is still there, or at least not
> understood completly.
> 
> I understand the benefit from the user standpoint.
> 
> Heiner if you are going to continue from the test patch you sent,
> I would welcome some explanation with each of the changes.
> 
The latest test patch was purely for checking whether we see any
difference in behavior between vendor driver and the mainlined
version. It's in no way meant to be applied to mainline.

> We know very little about this IP and I'm not very confortable with
> tweaking/aligning with AML sdk "blindly" on a driver that has otherwise
> been working well so far.
> 

This touches one thing I wanted to ask anyway: Supposedly Amlogic
didn't develop an own Ethernet PHY, and if they licensed an existing
IP then it should be similar to some other existing PHY (that may
have a driver in phylib).

Then what I'll do is submit the following small change that brought
the error rate significantly down according to Erico's tests.

-       phy_trigger_machine(phydev);
+       if (irq_status & INTSRC_ANEG_COMPLETE)
+               phy_queue_state_machine(phydev, msecs_to_jiffies(100));
+       else
+               phy_trigger_machine(phydev);


> Thx
> 
>>
>> So at this point, I'm not sure how much more effort to invest into
>> this. Given the rate is very low and the fallback is it will just
>> reset the link and proceed to work, I think the situation would
>> already be much better with the solution from that test patch being
>> merged. If you propose that as a patch separately, I'm happy to test
>> the final submitted patch again and provide feedback there. Or if
>> there is another solution to try, I can try with that too.
>>
>> Thanks
>>
>>
>> Erico
> 

Heiner
