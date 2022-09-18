Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BEB5BC04F
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 00:11:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiIRWLy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 18:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiIRWLx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 18:11:53 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D39FF17593;
        Sun, 18 Sep 2022 15:11:50 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id i15-20020a17090a4b8f00b0020073b4ac27so4410234pjh.3;
        Sun, 18 Sep 2022 15:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Sy4r0WjfjVrjcfEvaSP88S+n0l6KDV7pVO2qpx67ucY=;
        b=dXnxJZlR1kRI0Y2QLs09BU+ofbs3tKjLtLatklxr5ZER1DQy4WK5hRSI+jUKH2YJB+
         1daeCwnkGBtn4gH8l5R9ckUiuVPhO7SHlQF+cFB8bfJVFP97By+kvbH3iWqp2wbn1ju4
         apWtUWZxZKKHqKfdIHJ6wjVlmLoL2hGfRoFIVLEsvzR7dXcJJMDaxvQbkIdIqQNEQQXn
         ih/NkWAcZ+rKSDNVOw/kQ8yWzaZHvZPeuaEXistzQGCWgW+mN+nmM6sUsnHs3+KUg2Vx
         9FUwx7Md6g9DynMqJfQeFxqZyBWNeatdrdHkke8ijKBWDYIAIu5QzmYv375FhOyOB/Ra
         k2+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Sy4r0WjfjVrjcfEvaSP88S+n0l6KDV7pVO2qpx67ucY=;
        b=7LaRl9G3xqyW44jqBM1TRdWH+luBQiedEcNh0cGlPwGZOKjY3GQUZvJIIMNkqjTsYY
         MIjV+EsF0berdZ0H9pdFxqhCqu8b7wP93swJQ46xHI+xTQzngUD+y6otZ1+gZ2Wulxc9
         pbMkh1vPtMQerfC/lcXU8rL7H8Q9hyzwX9ZwuAHWcAfYBVD3KlRodFeKZ4YU6NmDHMLE
         2g8n8pcJEs6H5m7xn39TA0oSJpm6ysLBI7ZHyBc3rJ0OV1NxVo3esqr/28yw7+aVT+2J
         6vw3szpxuAe2o6PqfbGVKzQA9x8kDzmJ95ZGq9pLQ1pzfSv/qV4SJR6KUhEOiXdaClEM
         9P0w==
X-Gm-Message-State: ACrzQf0LOOCpn8CvChgPiqyWSUksP84OglI5olhkD2MSneuN/npE8nvE
        PaZlCYjke/9C760BgzQAShg=
X-Google-Smtp-Source: AMsMyM79LEEV4jWCLdWZcyBi6StD5RQCoRM+1+cKc7E0nfnidwFL7hIDXBpgAEk9XfovAHzGbA8N9A==
X-Received: by 2002:a17:902:8c81:b0:178:a33f:8b8f with SMTP id t1-20020a1709028c8100b00178a33f8b8fmr1017858plo.50.1663539110235;
        Sun, 18 Sep 2022 15:11:50 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:4c3d:6f64:77e4:9b52? ([2600:8802:b00:4a48:4c3d:6f64:77e4:9b52])
        by smtp.gmail.com with ESMTPSA id q7-20020a170902a3c700b0016f1319d2a7sm18750283plb.297.2022.09.18.15.11.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 18 Sep 2022 15:11:49 -0700 (PDT)
Message-ID: <adb2de4e-0ad0-a94a-93e6-572f58a2141b@gmail.com>
Date:   Sun, 18 Sep 2022 15:11:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH net-next v3 5/7] usbnet: smsc95xx: Forward PHY interrupts
 to PHY driver to avoid polling
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>
Cc:     Marek Szyprowski <m.szyprowski@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Ferry Toth <fntoth@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        'Linux Samsung SOC' <linux-samsung-soc@vger.kernel.org>
References: <20220519190841.GA30869@wunner.de>
 <31baa38c-b2c7-10cd-e9cd-eee140f01788@samsung.com>
 <e598a232-6c78-782a-316f-77902644ad6c@samsung.com>
 <20220826071924.GA21264@wunner.de>
 <2b1a1588-505e-dff3-301d-bfc1fb14d685@samsung.com>
 <20220826075331.GA32117@wunner.de>
 <093730dd-2f2c-bd0b-bd13-b97f8a2898bd@samsung.com>
 <81c0f21f-f8f1-f7b3-c52f-c6a564c6a445@samsung.com>
 <20220918191333.GA2107@wunner.de>
 <d963b1a3-e18d-25d5-f07c-42d17d382174@gmail.com>
 <20220918205516.GA13914@wunner.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220918205516.GA13914@wunner.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/18/2022 1:55 PM, Lukas Wunner wrote:
> On Sun, Sep 18, 2022 at 01:41:13PM -0700, Florian Fainelli wrote:
>> On 9/18/2022 12:13 PM, Lukas Wunner wrote:
>>> On Mon, Aug 29, 2022 at 01:40:05PM +0200, Marek Szyprowski wrote:
>>>> I've finally traced what has happened. I've double checked and indeed
>>>> the 1758bde2e4aa commit fixed the issue on next-20220516 kernel and as
>>>> such it has been merged to linus tree. Then the commit 744d23c71af3
>>>> ("net: phy: Warn about incorrect mdio_bus_phy_resume() state") has been
>>>> merged to linus tree, which triggers a new warning during the
>>>> suspend/resume cycle with smsc95xx driver. Please note, that the
>>>> smsc95xx still works fine regardless that warning. However it look that
>>>> the commit 1758bde2e4aa only hide a real problem, which the commit
>>>> 744d23c71af3 warns about.
>>>>
>>>> Probably a proper fix for smsc95xx driver is to call phy_stop/start
>>>> during suspend/resume cycle, like in similar patches for other drivers:
>>>>
>>>> https://lore.kernel.org/all/20220825023951.3220-1-f.fainelli@gmail.com/
>>>
>>> No, smsc95xx.c relies on mdio_bus_phy_{suspend,resume}() and there's
>>> no need to call phy_{stop,start}() >
>>> 744d23c71af3 was flawed and 6dbe852c379f has already fixed a portion
>>> of the fallout.
>>>
>>> However the WARN() condition still seems too broad and causes false
>>> positives such as in your case.  In particular, mdio_bus_phy_suspend()
>>> may leave the device in PHY_UP state, so that's a legal state that
>>> needs to be exempted from the WARN().
>>
>> How is that a legal state when the PHY should be suspended? Even if we are
>> interrupt driven, the state machine should be stopped, does not mean that
>> Wake-on-LAN or other activity interrupts should be disabled.
> 
> mdio_bus_phy_suspend()
>    phy_stop_machine()
>      phydev->state = PHY_UP  #  if (phydev->state >= PHY_UP)
> 
> So apparently PHY_UP is a legal state for a suspended PHY.

It is not clear to me why, however. Sure it does ensure that when we 
resume we set needs_aneg = true but this feels like a hack in the sense 
that we are setting the PHY in a provisional state in anticipation for 
what might come next.

> 
> 
>>> Does the issue still appear even after 6dbe852c379f?
>>>
>>> If it does, could you test whether exempting PHY_UP silences the
>>> gratuitous WARN splat?  I.e.:
>>
>> If you allow PHY_UP, then the warning becomes effectively useless, so I
>> don't believe this is quite what you want to do here.
> 
> Hm, maybe the WARN() should be dropped altogether?

And then be left with debugging similar problems that prompted me to 
submit the patch in the first place, no thank you. I guess I would 
rather accept that PHY_UP needs to be special cased then.
-- 
Florian
