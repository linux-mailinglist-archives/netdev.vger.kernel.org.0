Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2D0F5339B3
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 11:14:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241162AbiEYJN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 05:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241314AbiEYJNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 05:13:20 -0400
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C9647090B;
        Wed, 25 May 2022 02:11:04 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id e4so23219468ljb.13;
        Wed, 25 May 2022 02:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=J5DCkWestgVKoHEZoLossBiU0LtcBuAy5pRj+r09hN4=;
        b=XP3vHIYmf/Ce3FGxCzpcX7HjyAZBtPpnAymzxt8qes+BDIeDOh6F7lvUPFfx9tnC2d
         +xpmCEvfyTHqVlt9SBLYRRGulX1GyGwjXVwLdpwO14peVNHNhC/MII2rabef1oU1ErBK
         uZNvN3T5485zyLUgwwpDngrc7ZKytkgjUuSjRsNTvH9Df89NPu+mu9qTsDxub0/hnh6C
         byCcXLsQtqiFctApMaQMfD87zErzxamzEsrJpPNHWIcIzFKIGY+PgHKumqiyb4GOareT
         KhMZwEFZbM0wSipJvO7WkM2n+0uetym0XUO7zrCJcc94gdFBZglaLeYg2gOGwAWC740i
         G1nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=J5DCkWestgVKoHEZoLossBiU0LtcBuAy5pRj+r09hN4=;
        b=M6Dta61jLTY0DIhkMCsMyM3jThlE/oKFDew0BeYpP+PNsfswhYgeLI/hgqITHSIpYW
         14Gy7CV7fnT7t/cCz78TPcDTP8p6C/MKaXoA2LhSiiuaUIaZX/TOUpNGX6B9eQ732BO+
         I8GrCXribvfJ20zm9Yoee49jFtSsLN/383aL7659Wsn+zAJBlzKY+WilNBhgs6Ywbepq
         1oh7fTRFv4o30/tOMwW1aEMC7aHSuGw6rx2lGjUYkohIT7V+TC2+MM4knMlHqGhB3ruY
         iEsWdQ+EX94rMhARIR0HfVueFUikzfH4NJirn0hdyCNB/pfb+eoWDrl0OQU+jFCS4+lF
         2NgA==
X-Gm-Message-State: AOAM531KrsIDtT7wHe9CrKHuupqypp68h/CNJvR0gXLyBAV4yMaIi3XK
        LebKEHd60S8MeE0Sqd48IV8cESznXN0f4A==
X-Google-Smtp-Source: ABdhPJxIXYAN5qFD5hWU5lh23XROsNBf9wj+TE2QF64dbWr41TJAr6prDo9vAodw5m5Udb8lTpYjkQ==
X-Received: by 2002:a2e:888f:0:b0:253:f1af:7577 with SMTP id k15-20020a2e888f000000b00253f1af7577mr5922075lji.99.1653469862534;
        Wed, 25 May 2022 02:11:02 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id h4-20020ac250c4000000b00477be45fb23sm2951020lfm.56.2022.05.25.02.11.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 02:11:01 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
In-Reply-To: <040a1551-2a9f-18d0-9987-f196bb429c1b@blackwall.org>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <01e6e35c-f5c9-9776-1263-058f84014ed9@blackwall.org>
 <86zgj6oqa9.fsf@gmail.com>
 <b78fb006-04c4-5a25-7ba5-94428cc9591a@blackwall.org>
 <86fskyggdo.fsf@gmail.com>
 <040a1551-2a9f-18d0-9987-f196bb429c1b@blackwall.org>
Date:   Wed, 25 May 2022 11:11:00 +0200
Message-ID: <86v8tu7za3.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On ons, maj 25, 2022 at 11:38, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 25/05/2022 11:34, Hans Schultz wrote:
>> On ons, maj 25, 2022 at 11:06, Nikolay Aleksandrov <razor@blackwall.org> wrote:
>>> On 24/05/2022 19:21, Hans Schultz wrote:
>>>>>
>>>>> Hi Hans,
>>>>> So this approach has a fundamental problem, f->dst is changed without any synchronization
>>>>> you cannot rely on it and thus you cannot account for these entries properly. We must be very
>>>>> careful if we try to add any new synchronization not to affect performance as well.
>>>>> More below...
>>>>>
>>>>>> @@ -319,6 +326,9 @@ static void fdb_delete(struct net_bridge *br, struct net_bridge_fdb_entry *f,
>>>>>>  	if (test_bit(BR_FDB_STATIC, &f->flags))
>>>>>>  		fdb_del_hw_addr(br, f->key.addr.addr);
>>>>>>  
>>>>>> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &f->flags) && !test_bit(BR_FDB_OFFLOADED, &f->flags))
>>>>>> +		atomic_dec(&f->dst->locked_entry_cnt);
>>>>>
>>>>> Sorry but you cannot do this for multiple reasons:
>>>>>  - f->dst can be NULL
>>>>>  - f->dst changes without any synchronization
>>>>>  - there is no synchronization between fdb's flags and its ->dst
>>>>>
>>>>> Cheers,
>>>>>  Nik
>>>>
>>>> Hi Nik,
>>>>
>>>> if a port is decoupled from the bridge, the locked entries would of
>>>> course be invalid, so maybe if adding and removing a port is accounted
>>>> for wrt locked entries and the count of locked entries, would that not
>>>> work?
>>>>
>>>> Best,
>>>> Hans
>>>
>>> Hi Hans,
>>> Unfortunately you need the correct amount of locked entries per-port if you want
>>> to limit their number per-port, instead of globally. So you need a
>>> consistent
>> 
>> Hi Nik,
>> the used dst is a port structure, so it is per-port and not globally.
>> 
>> Best,
>> Hans
>> 
>
> Yeah, I know. :) That's why I wrote it, if the limit is not a feature requirement I'd suggest
> dropping it altogether, it can be enforced externally (e.g. from user-space) if needed.
>
> By the way just fyi net-next is closed right now due to merge window. And one more
> thing please include a short log of changes between versions when you send a new one.
> I had to go look for v2 to find out what changed.
>

Okay, I will drop the limit in the bridge module, which is an easy thing
to do. :) (It is mostly there to ensure against DOS attacks if someone
bombards a locked port with random mac addresses.)
I have a similar limitation in the driver, which should then probably be
dropped too?

The mayor difference between v2 and v3 is in the mv88e6xxx driver, where
I now keep an inventory of locked ATU entries and remove them based on a
timer (mv88e6xxx_switchcore.c).

I guess the mentioned log should be in the cover letter part?


>>> fdb view with all its attributes when changing its dst in this case, which would
>>> require new locking because you have multiple dependent struct fields and it will
>>> kill roaming/learning scalability. I don't think this use case is worth the complexity it
>>> will bring, so I'd suggest an alternative - you can monitor the number of locked entries
>>> per-port from a user-space agent and disable port learning or some similar solution that
>>> doesn't require any complex kernel changes. Is the limit a requirement to add the feature?
>>>
>>> I have an idea how to do it and to minimize the performance hit if it really is needed
>>> but it'll add a lot of complexity which I'd like to avoid if possible.
>>>
>>> Cheers,
>>>  Nik
