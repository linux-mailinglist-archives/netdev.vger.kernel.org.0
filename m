Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A918F6EB63B
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 02:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbjDVAKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 20:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233985AbjDVAKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 20:10:00 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 333A72711
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 17:09:53 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-74dd7f52f18so757155185a.0
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 17:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682122192; x=1684714192;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WNjW7f471JL4W1ME4i5jfMUu4UnLz7UzihUF+iDnRmE=;
        b=bpQ/d9Ojk7k7tTlu4jYG3q7l7e53J7vuJgO+C3W5sUU5tpsBrzkL6oarq/bvFkYC6E
         xD/I6HqFgR3sZIHYsyJXhhpFbNsfP27XmH61WrPhbAJpyEc+J7cs1U/GXuevtP69bwG4
         kb6wu732N1DkXAo10RkEZKKFxlJIiSpc2s0kylB2hdq4/AIbc9SvQTiD1KmanhfKptRq
         LpEr3ipYzefRyiSvqqipas0umiGdQ+HkTv9RlRY4jWA1ulRP+HF+U+r4RKx6kZdUmS+D
         gF2tJMy3IgZ9qg3YHmf4W2bHDvP5gZU6bC3KhyW4LlIboOTibaueompvEVVdJoc6Rr/K
         Z/kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682122192; x=1684714192;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WNjW7f471JL4W1ME4i5jfMUu4UnLz7UzihUF+iDnRmE=;
        b=Q3f1XVMH5jYcU3uED+6TtFGDQ2xzY5tZrMb9y/Qgy2DdTNHl0+7WPEdO6YSH9cs3C7
         KlgEmOG13uZT8zpzgqN7zVOUcnKAEpb5a/kT7nVomX6GN8CD3fgRlnrTAwz29Ja6nYzL
         c2FNEg7PYT1bj89YzYq4eofVMZMeWai0GojGANDSBCYOPwdD5ZZM9Reim8auruifArDS
         juuPZfTTZ7i+LyS8PEqi8uAXlpE7VLrkuJYqyomFI46Gx3+sawHJRRcd+EJfjSdF88IW
         B6v5N70374cs5JL8nuB6qjo/1qqxeDsXH3M8aqz0l4ouY3rOGZUK6bzJ9P0Mt59Q2dnG
         fnKg==
X-Gm-Message-State: AAQBX9deik4GWVmfWxNjA7kJHXwKCp0nhbpjhGlMwrhvU3tcupVtyvvs
        1ByNLj1yQvJ+YC2ouCEsSvgOtz+MBmI=
X-Google-Smtp-Source: AKy350Zl+q6+kwiqP6U+TY7o6ZBmhepPJxp494xMOGZItIhjloiCC4ILBcX7JpX//Jvm3KLhykaT8Q==
X-Received: by 2002:a05:622a:5d0:b0:3ed:164c:6834 with SMTP id d16-20020a05622a05d000b003ed164c6834mr13150086qtb.27.1682122192197;
        Fri, 21 Apr 2023 17:09:52 -0700 (PDT)
Received: from ?IPV6:2607:fb90:584:fcdd:fd95:2484:da72:9562? ([2607:fb90:584:fcdd:fd95:2484:da72:9562])
        by smtp.gmail.com with ESMTPSA id c17-20020a05620a269100b0074e005d1f2csm1707871qkp.43.2023.04.21.17.09.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 17:09:51 -0700 (PDT)
Message-ID: <e65a8575-8a76-4b09-c398-aee5272921a7@gmail.com>
Date:   Fri, 21 Apr 2023 17:09:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: issues to bring up two VSC8531 PHYs
Content-Language: en-US
To:     Ron Eggler <ron.eggler@mistywest.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
 <bb62e044-034e-771e-e3a9-a4b274e3dec9@gmail.com>
 <46e4d167-5c96-41a0-8823-a6a97a9fa45f@lunn.ch>
 <ba56f0a4-b8af-a478-7c1d-e6532144b820@gmail.com>
 <59fc6f98-0f67-f4a3-23c9-cd589aaa6af8@mistywest.com>
 <b3776edd-e337-44a4-8196-a6a94b498991@lunn.ch>
 <02b26c6f-f056-cec6-daf1-5e7736363d4e@mistywest.com>
 <7bb09c7c-24fc-4c8d-8068-f163082ab781@lunn.ch>
 <fa806e4a-b706-ce54-b3e0-b95d065e8d4a@mistywest.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <fa806e4a-b706-ce54-b3e0-b95d065e8d4a@mistywest.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/2023 3:55 PM, Ron Eggler wrote:
> 
> On 4/21/23 09:35, Andrew Lunn wrote:
>>>> You can also try:
>>>>
>>>> ethtool --phy-statistics ethX
>>> after appliaction of the above patch, ethtool tells me
>>>
>>> # ethtool --phy-statistics eth0
>>> PHY statistics:
>>>       phy_receive_errors: 65535
>>>      phy_idle_errors: 255
>> So these have saturated. Often these counters don't wrap, they stop at
>> the maximum value.
>>
>> These errors also indicate your problem is probably not between the
>> MAC and the PHY, but between the PHY and the RJ45 socket. Or maybe how
>> the PHY is clocked. It might not have a stable clock, or the wrong
>> clock frequency.
> 
> The man page (https://www.man7.org/linux/man-pages/man8/ethtool.8.html) 
> does not give any details about what phy_receive_errors or 
> phy_idle_errors refer to exactly, is there any documentation about it 
> that I could not find?

The statistics are inherently PHY specific and how a driver writer 
choses to map a name to a specific PHY counter is backed within the driver.
-- 
Florian
