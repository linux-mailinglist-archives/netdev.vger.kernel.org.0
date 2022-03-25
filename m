Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 023264E7893
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 17:02:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376663AbiCYQDq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 12:03:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbiCYQDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 12:03:45 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360C19F38E;
        Fri, 25 Mar 2022 09:02:10 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id s25so10906107lji.5;
        Fri, 25 Mar 2022 09:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=+OD60eQPT0VQTzE/zXfu180JDdeuowENv4FkX1dVZFE=;
        b=I8MvfJJg21hFIKhtqvvBctr1gAN5m6sffrS0rOoehEmmIPayRpaTUaRe/GPXScZ/SH
         2azU1M4fHHMRKTdXW6AxUyl/Slloo0KWbjmm4M6AA2COT0ckYY06spj7vr4L/0t+aHuP
         49Dw0R1j2j1bA4IMtVa6mKBme6bH63fkqKJwWv9OP7F3lxP+P4hUmeF5xx+NKJnFMIFr
         3QQetM/VX8SOp7DeM8FnVuM01Q37nBCTnGwbiujgazzVfNlfdxp70Wqa+R8ryl0ACD52
         kBx2038L1+1KxinXX1O1I2hOFRB3gq89vkJrGAO+noJWzqsKm7N7ZEokizNpdn9IS/Ys
         TMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=+OD60eQPT0VQTzE/zXfu180JDdeuowENv4FkX1dVZFE=;
        b=Y0lQvnkgwzpLZpRALFTDji3IqRAImXsj4GerD+lFueVTwrWj7wZIvhoKHDvzat+Wr/
         2ELo5fs/WQDhdV8xg9/v/4mBF4l5hQEqGpMQPn2aOFLtI1JF9CJYb3tK2TQv9OovUkXA
         sYRkTc8wlcfGKxZPSEfX4t4qEB/KxWn+zyvrJhsSWYvIeLpOo4YOuyI4AfmhFHXBugve
         cCia46/7CIEHWdeHyCT2XCZ6KikllvlGXBZ7MRS4J53QPhcRKH+GZLoP4ZNtTVBJ20p2
         G64kagx/r48yUWGxAmO0F7J0ejbevahHXhnDriGVwznKYtMDUD2Kbb4+JSFskWtjNs7q
         XpZg==
X-Gm-Message-State: AOAM5303TAy/d2S/OAOvsY5glHLgRHpWgZvNX6r5czxDMJ+Sz2pMa8YI
        V9/yiGb73pxviOo9aRo5KrIMR0CBEZJQug==
X-Google-Smtp-Source: ABdhPJy6jB+HkWeuu+mr4Nf5L0XiH1JsJt71ZKa7Kvg7YTo3UzTPXUwRdrvEMV0xlzbN7/m6plkcTA==
X-Received: by 2002:a05:651c:198b:b0:249:8bf4:498b with SMTP id bx11-20020a05651c198b00b002498bf4498bmr8914549ljb.441.1648224128413;
        Fri, 25 Mar 2022 09:02:08 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id i24-20020a2e8658000000b0024806af7079sm744149ljj.43.2022.03.25.09.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 09:02:07 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2 net-next 2/4] net: switchdev: add support for
 offloading of fdb locked flag
In-Reply-To: <20220325140003.a4w4hysqbzmrcxbq@skbuf>
References: <20220323123534.i2whyau3doq2xdxg@skbuf>
 <86wngkbzqb.fsf@gmail.com> <20220323144304.4uqst3hapvzg3ej6@skbuf>
 <86lewzej4n.fsf@gmail.com> <20220324110959.t4hqale35qbrakdu@skbuf>
 <86v8w3vbk4.fsf@gmail.com> <20220324142749.la5til4ys6zva4uf@skbuf>
 <86czia1ned.fsf@gmail.com> <20220325132102.bss26plrk4sifby2@skbuf>
 <86fsn6uoqz.fsf@gmail.com> <20220325140003.a4w4hysqbzmrcxbq@skbuf>
Date:   Fri, 25 Mar 2022 17:01:59 +0100
Message-ID: <86tubmt408.fsf@gmail.com>
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

On fre, mar 25, 2022 at 16:00, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Fri, Mar 25, 2022 at 02:48:36PM +0100, Hans Schultz wrote:
>> > If you'd cache the locked ATU entry in the mv88e6xxx driver, and you'd
>> > notify switchdev only if the entry is new to the cache, then you'd
>> > actually still achieve something major. Yes, the bridge FDB will contain
>> > locked FDB entries that aren't in the ATU. But that's because your
>> > printer has been silent for X seconds. The policy for the printer still
>> > hasn't changed, as far as the mv88e6xxx, or bridge, software drivers are
>> > concerned. If the unauthorized printer says something again after the
>> > locked ATU entry expires, the mv88e6xxx driver will find its MAC SA
>> > in the cache of denied addresses, and reload the ATU. What this
>> > achieves
>> 
>> The driver will in this case just trigger a new miss violation and add
>> the entry again I think.
>> The problem with all this is that a malicious attack that spams the
>> switch with random mac addresses will be able to DOS the device as any
>> handling of the fdb will be too resource demanding. That is why it is
>> needed to remove those fdb entries after a time out, which dynamic
>> entries would serve.
>
> An attacker sweeping through the 2^47 source MAC address range is a
> problem regardless of the implementations proposed so far, no?

The idea is to have a count on the number of locked entries in both the
ATU and the FDB, so that a limit on entries can be enforced.

> If unlimited growth of the mv88e6xxx locked ATU entry cache is a
> concern (which it is), we could limit its size, and when we purge a
> cached entry in software is also when we could emit a
> SWITCHDEV_FDB_DEL_TO_BRIDGE for it, right?

I think the best would be dynamic entries in both the ATU and the FDB
for locked entries. How the two are kept in sync is another question,
but if there is a switchcore, it will be the 'master', so I don't think
the bridge module will need to tell the switchcore to remove entries in
that case. Or?
