Return-Path: <netdev+bounces-6608-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 836B0717130
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 01:03:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1D52A1C20DD6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 23:03:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A584134CE6;
	Tue, 30 May 2023 23:03:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94409A927
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:03:51 +0000 (UTC)
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B250710A
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:03:45 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-5346d150972so4532353a12.3
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 16:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685487825; x=1688079825;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VGBkdAioPYjKfdSzh76OpK2mIcPIL5KFujvfOfU06eY=;
        b=WbdSLQRbMMEAyjqgF7qFsaA8jmB8cgQ/GWIM42aQxj+UgRhPHJaXBrNdWKuqA92iK8
         9eHVSH/ptfI6twyyUoXz7WBpKNAPnj3kcoQsPHZRbOgNQug4MswjiINbhXQkc2p3SRv0
         H0iz7k++4epfU/zA79jgB4tJSSgWwAUGmUh3eRZGwEGDgDG9uP/vuCV2X1Yp5gHcSJn7
         wGQWqEXfy9ploAOjpQ+6O6ZE3aUyfvFxj95FM+e409lIJ/C8h9h3qjbI1uP2TGlBwGPn
         WFLnO7Sut0fdUYxc1DdY59sYIeRuWXeotN11FgWzO/FIJ74shO6r5KtfwUE+JSGFj3O8
         Uh3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685487825; x=1688079825;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGBkdAioPYjKfdSzh76OpK2mIcPIL5KFujvfOfU06eY=;
        b=GrGts7zXyLr7JqhSYdLtlpQYbY8M3wQPF3azjHE6YTuxp32cvRrKKm+w0OUc4FFyMw
         xyxZ9/wsCa/rwim7CjhbP4aEi8i4BvdGtTzHwrKsAKa/ZsaW1s0/AglppnKgRhHk8ecU
         wgOaQgtnC5jRM6bHC3OGY+IbFxmRt5K9+QSS+2ciTEZHRMy0e69Lo4k/JsVN5g/cB001
         Iiefu4Swm5DAb8yHSvkp8OdZdBfAgKI3RNsBt0mJMAwM/2T5WEduA23wVtgQ/+J3CA8/
         rlUG+FbUlrG9FmgjbeGNpB8hd9ZX1QBB6JWI6KShTL+YenE8TFaEIS0ZvUArj3XIGdUY
         fF/g==
X-Gm-Message-State: AC+VfDw8iftnd1Oj9R90+wmHZ4XbW9EVZfd6reeZGuiEqcuJeBu3OI2z
	tcQb4LgXBfAGYvDAvnKgZIQ6gElWUUDj7Q==
X-Google-Smtp-Source: ACHHUZ7rFRCMMzpCUOxbqbR/D5FYnERowZ16GtgXfFyDcDHMZauZ1+Wmc8KRMMVae1X4pSbBZyMkrQ==
X-Received: by 2002:a17:90a:af88:b0:253:3ed3:b212 with SMTP id w8-20020a17090aaf8800b002533ed3b212mr3824643pjq.20.1685487824906;
        Tue, 30 May 2023 16:03:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t3-20020a17090aba8300b00256833cd9a4sm3889188pjr.54.2023.05.30.16.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 16:03:43 -0700 (PDT)
Message-ID: <f31ea61f-ead3-e299-e4f2-f4914acc45ae@gmail.com>
Date: Tue, 30 May 2023 16:03:35 -0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [RFC/RFTv3 00/24] net: ethernet: Rework EEE
Content-Language: en-US
To: "Russell King (Oracle)" <linux@armlinux.org.uk>,
 Andrew Lunn <andrew@lunn.ch>
Cc: netdev <netdev@vger.kernel.org>, Heiner Kallweit <hkallweit1@gmail.com>,
 Oleksij Rempel <linux@rempel-privat.de>
References: <20230331005518.2134652-1-andrew@lunn.ch>
 <fa21ef50-7f36-3d01-5ecf-4a2832bcec89@gmail.com>
 <d753d72c-6b7a-4014-b515-121dd6ff957b@lunn.ch>
 <ZHZcc/E/Hx1bnjcx@shell.armlinux.org.uk>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <ZHZcc/E/Hx1bnjcx@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/30/23 13:28, Russell King (Oracle) wrote:
> On Tue, May 30, 2023 at 09:48:00PM +0200, Andrew Lunn wrote:
>> On Tue, May 30, 2023 at 11:31:04AM -0700, Florian Fainelli wrote:
>>> Hi Andrew, Russell,
>>>
>>> On 3/30/23 17:54, Andrew Lunn wrote:
>>>> Most MAC drivers get EEE wrong. The API to the PHY is not very
>>>> obvious, which is probably why. Rework the API, pushing most of the
>>>> EEE handling into phylib core, leaving the MAC drivers to just
>>>> enable/disable support for EEE in there change_link call back, or
>>>> phylink mac_link_up callback.
>>>>
>>>> MAC drivers are now expect to indicate to phylib/phylink if they
>>>> support EEE. If not, no EEE link modes are advertised. If the MAC does
>>>> support EEE, on phy_start()/phylink_start() EEE advertisement is
>>>> configured.
>>>
>>> Thanks for doing this work, because it really is a happy mess out there. A
>>> few questions as I have been using mvneta as the reference for fixing GENET
>>> and its shortcomings.
>>>
>>> In your new patches the decision to enable EEE is purely based upon the
>>> eee_active boolean and not eee_enabled && tx_lpi_enabled unlike what mvneta
>>> useed to do.
>>
>> I don't really care much what we decide means 'enabled'. I just want
>> it moved out of MAC drivers and into the core so it is consistent.
>>
>> Russel, if you want to propose something which works for both Copper
>> and Fibre, i'm happy to implement it. But as you pointed out, we need
>> to decide where. Maybe phylib handles copper, and phylink is layered
>> on top and handles fibre?
> 
> Phylib also handles fibre too with dual-media PHYs (such as 88E151x
> and 88X3310), and as I've just pointed out, the recent attempts at
> "fixing" phylib's handling particularly with eee_enabled have made it
> rather odd.
> 
> That said, the 88E151x resolution of 1000BASE-X negotiation is also
> rather odd, particularly with pause modes. So I don't trust one bit
> that anyone is even using 88E151x in fibre setups - or if they are
> they don't care about this odd behaviour.
> 
> Before we go any further, I think we need to hammer out eactly how the
> ethtool EEE interface is supposed to work, because right now I can't
> say that I fully understand it - and as I've said in my replies to
> Florian recently, phylib's EEE implementation becomes utterly silly
> when it comes to fibre.
> 
> In particular, we need to hammer out what the difference exactly is
> between "eee_enabled" and "tx_lpi_enabled", and what they control,
> and I suggest we look at it from the point of view of both copper
> (where EEE is negotiated) and fibre (were EEE is optional, no
> capability bits, no negotiation, so no advertisement.)
> 
> It seems fairly obvious to me that tx_lpi* are about the MAC
> configuration, since that's the entity which is responsible for
> signalling LPI towards the PHY(PCS) over GMII.

Yes that much we can agree on that tx_lpi* is from the perspective of 
the MAC.

> 
> eee_active... what does "active" actually mean? From the API doc, it
> means the "Result of the eee negotiation" which is fine for copper
> links where EEE is negotiated, but in the case of fibre, there isn't
> EEE negotiation, and EEE is optionally implemented in the PCS.

Is there any way to feed back whether EEE is actually being used at the 
time on a fiber link? In which case eee_active would reflect that state.

> 
> eee_enabled... doesn't seem to have a meaning as far as IEEE 802.3
> goes, it's a Linux invention. Documentation says "EEE configured mode"
> which is just as useful as a chocolate teapot for making tea, that
> comment might as well be deleted for what use it is. To this day, I
> have no idea what this setting is actually supposed to be doing.
> It seemed sane to me that if eee_enabled is false, then we should
> not report eee_active as true, nor should we allow the MAC to
> generate LPI. Whether the advertisement gets programmed into the PHY
> or not is something I never thought about, and I can't remember
> phylib's old behaviour. Modern phylib treats eee_enabled = false to
> program a zero advertisement, which means when reading back via
> get_eee(), you get a zero advertisement back. Effectively, eee_active
> in modern phylib means "allow the advertisement to be programmed
> if enabled, otherwise clear the advertisement". >
> If it's simply there to zero the advertisement, then what if the
> media type has no capability for EEE advertisement, but intrinsically
> supports EEE. That's where phylib's interpretation falls down IMHO.
> 
> Maybe this ethtool interface doesn't work very well for cases where
> there is EEE ability but no EEE advertisement? Not sure.

At the time it was introduced, there certainly was not much care being 
given to fiber use cases.

> 
> Until we get that settled, we can't begin to fathom how phylib (or
> phylink) should make a decision as to whether the MAC should signal
> LPI towards the media or not.

Now that we have SmartEEE and AutogrEEEn as additional supported modes 
by certain PHY drivers for MACs that lack any LPI signaling capability 
towards the PHY, there may be a reason for re-purposing or clarifying 
the meaning of eee_enabled=true with tx_lpi_enabled=false. Although in 
those cases, I would just issue a warning that tx_lpi_enabled is ignored 
because the MAC is incapable of LPI signaling.

It seems that eee_enabled is intended to be a local administrative 
parameter that provides an additional gating level to the local & remote 
advertisement resolution. As a driver you can only enable EEE at the MAC 
and/or PHY level if local & remote & enabled = true.
-- 
Florian


