Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2C76D01FE
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 12:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231419AbjC3Kqz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 06:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjC3Kpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 06:45:54 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39ED77EC0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:45:17 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id x3so74585576edb.10
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 03:45:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112; t=1680173115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nJ4kHmOyB5GJCNT97r/CEXr1tfWeNmV/zja7PhdakrM=;
        b=lGerEYp3RodGDGGbu9v46KqIKVUtY8TeLHCWxCyKo+lIj9VCOEqmYXb5Luv5Icdw83
         /Q3ohcVMs8/k4KEjqUfKTm0pm1obz2hYyDJZEGwY4xvSV70Uh8/o0fRR62eoC40mv/Bv
         UEBYsZ9wt18DBWpVrq6PHs0ItsJPyhMLJmMVYdRNaFyf6g5o43qmVx2ExIW9JPB5NAcT
         SXRLeONaXaaxnx6NDDtdppC3NfBaEjMNaKyBR43dlSVVCegyF8RxQYNMsOAzUTzA2au6
         2XuJdBK+c0uj4WiQDcWKQjhPoR9V9sl3rqUkq8GEkpgIesqP2468KV0nJR3pSnsRbAgW
         ihWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680173115;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nJ4kHmOyB5GJCNT97r/CEXr1tfWeNmV/zja7PhdakrM=;
        b=6pzRKcbXx5N7oFwI8N0KYCK3+Cp9R8p0ndx8bIGSOFl5P2qGyy5yUUqUTKGbrvh6yF
         bAQXXjfbFdk526xyql5kk8XG6QQgnUqJdzYgtONDw8PwQSpj+Ks0N77C79zKH6LVOXaL
         e5CPdLaUZwRp3nluZHe7Gxcx18dukwOIzt5qe5C0+WcQUpL3B75NLy8fyhyF8py8LsWl
         QbpwiGJhElweFtjDI7zIVRKbcvLnaBKqByvyVFsWCfNjDdPn0yq95Naywt3ljrlQ7Ltz
         TvIJGJKKyHjmVLPD9aVWD4DvsQV9xdxE5k+D9Aaf+/nd3VwlTgk1zL1kZtpGJmDy+Cey
         xQCA==
X-Gm-Message-State: AAQBX9dzHXh8YgYLScBgPn8kSaL4cqOJ89iekSYeaXFPWPWk5kkJIdF1
        I4IzP7u/G1Xdv5INA5vkdV6cFA==
X-Google-Smtp-Source: AKy350ZCwuMbyX3imXZjyklWc/tn6fTJgMv803a+AfMakTywcrCsiPGJxBzQ+0cpDFJ7UWixfjodXw==
X-Received: by 2002:a17:906:738a:b0:878:58e6:f1eb with SMTP id f10-20020a170906738a00b0087858e6f1ebmr20132191ejl.23.1680173115494;
        Thu, 30 Mar 2023 03:45:15 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id p25-20020a50cd99000000b004bf76fdfdb3sm17878396edi.26.2023.03.30.03.45.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Mar 2023 03:45:15 -0700 (PDT)
Message-ID: <6f0d0f2d-474b-caaf-78a7-289e660c3aa0@blackwall.org>
Date:   Thu, 30 Mar 2023 13:45:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v2 net-next 6/6] selftests: forwarding: add dynamic FDB
 test
Content-Language: en-US
To:     Hans Schultz <netdev@kapio-technology.com>,
        Ido Schimmel <idosch@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-7-netdev@kapio-technology.com>
 <ZBgdAo8mxwnl+pEE@shredder> <87a5zzh65p.fsf@kapio-technology.com>
 <ZCMYbRqd+qZaiHfu@shredder> <87fs9ollmn.fsf@kapio-technology.com>
 <ZCUuMosWbyq1pK8R@shredder> <87mt3u7csh.fsf@kapio-technology.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <87mt3u7csh.fsf@kapio-technology.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=3.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/03/2023 13:29, Hans Schultz wrote:
> On Thu, Mar 30, 2023 at 09:37, Ido Schimmel <idosch@nvidia.com> wrote:
>> On Tue, Mar 28, 2023 at 09:30:08PM +0200, Hans Schultz wrote:
>>>
>>> Sorry, but I have sent you several emails telling you about the problems
>>> I have with running the selftests due to changes in the phy etc. Maybe
>>> you have just not received all those emails?
>>>
>>> Have you checked spamfilters?
>>>
>>> With the kernels now, I cannot even test with the software bridge and
>>> selftests as the compile fails - probably due to changes in uapi headers
>>> compared to what the packages my system uses expects.
>>
>> My spam filters are fine. I saw your emails where you basically said
>> that you are too lazy to setup a VM to test your patches and that your
>> time is more valuable than mine, which is why I should be testing them.
>> Stop making your problems our problems. It's hardly the first time. If
>> you are unable to test your patches, then invest the time in fixing your
>> setup instead of submitting completely broken patches and making it our
>> problem to test and fix them. I refuse to invest time in reviewing /
>> testing / reworking your submissions as long as you insist on doing less
>> than the bare minimum.
>>
>> Good luck
> 
> I never said or indicated that my time is more valuable than yours. I
> have a VM to run these things that some have spent countless hours to
> develop with the right tools etc installed and set up. Fixing that
> system will take quite many hours for me, so I am asking for some simple
> assistance from someone who already has a system running supporting the
> newest kernel.
> 
> Alternatively if there is an open sourced system available that would be
> great.
> 
> As this patch-set is for the community and some companies that would
> like to use it and not for myself, I am asking for some help from the
> community with a task that when someone has the system in place should
> not take more than 15-20 minutes, maybe even less.

I'm sorry but this is absolutely the wrong way to go about this. Your setup's
problems are yours to figure out and fix, if you are going to send *any* future
patches make absolutely sure they build, run and work as intended.
Please do not send any future patches without them being fully tested and, as
Ido mentioned, cover at least the bare minimum for a submission.

Thanks,
 Nik

