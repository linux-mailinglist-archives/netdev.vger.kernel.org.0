Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 738B66A2D1E
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 03:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbjBZCJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 21:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjBZCJ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 21:09:58 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9707A12843;
        Sat, 25 Feb 2023 18:09:53 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id t7-20020a9d7487000000b00693d565b852so1787478otk.5;
        Sat, 25 Feb 2023 18:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Cdf17NqA+jaB/gdMQ7hVa+nSi8Np813wqLCsDdd+xBI=;
        b=bBIXigGsPjnbg0/Hkz7XTzap2YhNYqp/+XLQ2h6BOoJpPBW3tOMrQ6BM5uYC2VZIuo
         WA/S/p0svOnrTGAJaMNW+VYWU2wPOJmbZVuKsk4ErDqLa4fsEiBhzWGiJTVVgLoaysO1
         vpzEGig7wkmDeAcE/zdCZef5rtyLfnoFYp8wyPFWEFoMss9EroLQxKAkp8/aRwuktHFa
         FjOl6jDn8ZXCmPx40eV/P15AvYQws0IZMByjzMMiLGDEuN2iBSfOpUnHKmK0hXmlfjuN
         twd+oGyRt31PsL1JB/dYNONn3xvJ7GoEvuSY2PPOZwMjAhBDv/URO+HswV8ksBW+qLAs
         wwGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Cdf17NqA+jaB/gdMQ7hVa+nSi8Np813wqLCsDdd+xBI=;
        b=Wz7DfQWedqxUJCaUe9dAq02A0ZbTeAQFLH4cqa//ZVZBb0FKsr71lYpPCztU0M6W2s
         ziiWc2SiKTLDm+LXZqnBfn7HsufZKC1RVf+ib/WtzQeHU/675si+FtF5Zv5V/jNsoVBZ
         eNjKy8PPBeIz0GGtRbMgwOpFsxUV7qagqj5PeQdg0mR+j9ILXEb7dI42DZdEoPZQVV31
         ONf/+YYoO8NF20IoITPePh/iRN5SekRExEfSrf4kgmrvUGYUrzXaReXQow+Udqjsx8Pd
         t+UvzVCLt3sHZbLAA33iNcbc/YXOgoJ4woX+nfReUREsI90SysevHSF1VAneKNHaYu6E
         kghg==
X-Gm-Message-State: AO0yUKXwuROPE+9ToW7SCUoZKN/XbgJ4R53cOTAamQeRGNxL11ynnGJr
        uOl3osfsgTeqyN/n3bCtD4J+4Erx4/Q=
X-Google-Smtp-Source: AK7set9jZpMy/AxCG66VWPMCmP69hZH8yNHOuZFm63M6zUNpqNnpBoL+pr4Fpe4t+aQGmhw9edTeUA==
X-Received: by 2002:a9d:383:0:b0:68b:d3b7:cb72 with SMTP id f3-20020a9d0383000000b0068bd3b7cb72mr7474568otf.5.1677377392877;
        Sat, 25 Feb 2023 18:09:52 -0800 (PST)
Received: from [192.168.1.119] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id z14-20020a9d468e000000b00686a19ffef1sm1153256ote.80.2023.02.25.18.09.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 25 Feb 2023 18:09:52 -0800 (PST)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <121c0039-5f0c-7c4e-5b07-9193ed547079@lwfinger.net>
Date:   Sat, 25 Feb 2023 20:09:51 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] wifi: wext: warn about usage only once
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Kalle Valo <kvalo@kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Nicolas Cavallari <Nicolas.Cavallari@green-communications.fr>,
        Johannes Berg <johannes.berg@intel.com>,
        Jan Engelhardt <jengelh@inai.de>
References: <20230224135933.94104aeda1a0.Ie771c6a66d7d6c3cf67da5f3b0c66cea66fd514c@changeid>
 <dff29d82-9c4b-1933-c1c1-a3becf2a0f1f@lwfinger.net>
 <CAHk-=whwDRefJJq0K8bXXSNY3-Zy8=Z3ZiKYh2mOOvfT-MqNhA@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAHk-=whwDRefJJq0K8bXXSNY3-Zy8=Z3ZiKYh2mOOvfT-MqNhA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/23 13:44, Linus Torvalds wrote:
> You *could* improve on it further by having some kind of timed
> rate-limiting, where every 24 hours you'd clear the warning mask, so
> that you'd warn about these things once a day. That *can* be useful
> for when people just don't notice the warning the first time around,
> and "once a day" is not a horribly problem that fills up the logs like
> the current situation does.
> 
> But again - I personally think even just a pr_warn_once() is likely
> good enough. Because all I want is to not have that horrible
> log-flushing behavior.

To all,

I posted my list of 8 different tasks that generated this warning to the 
openSUSE developers mailing list, and got back a reply from Jan Engelhardt 
pointed me toward the libqt5-qtbase project, which contains the following snippet:

     case ARPHRD_ETHER:
         // check if it's a WiFi interface
         if (qt_safe_ioctl(socket, SIOCGIWMODE, req) >= 0)
             return QNetworkInterface::Wifi;
         return QNetworkInterface::Ethernet;

I am not entirely sure why Qt needs to know what type of device the network is 
using. I tested by replacing this with

     case ARPHRD_ETHER:
         return QNetworkInterface::Ethernet;


After rebuilding the entire project, and reinstalling all 31 packages generated 
in a new build, my system now displays only 3 remaining warnings, namely

warning: `nspr-2' uses wireless extensions that are deprecated for modern 
drivers; use nl80211
warning: `ThreadPoolForeg' uses wireless extensions that are deprecated for 
modern drivers; use nl80211
warning: `nspr-8' uses wireless extensions that are deprecated for modern 
drivers; use nl80211

To answer Kalle's question, libQt is responsible for most of the warnings that 
were reported here.

In case Qt really needs to know what network it is on, what is a better way to 
detect if the network is on a Wifi device?

Larry



