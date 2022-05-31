Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD494539440
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 17:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345876AbiEaPto (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 11:49:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345784AbiEaPtn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 11:49:43 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A16E3055A;
        Tue, 31 May 2022 08:49:41 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id a23so15122078ljd.9;
        Tue, 31 May 2022 08:49:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=A44GayFxXseGVVD0HVJY3qkIMetyjm2M3KFYhOBPZao=;
        b=Lc2SkHq0n+vROccbAbpL/H+0Dgf53+UBnImyq5CgM9VVRWDpx10kq2qoKeRy5CiiNv
         FpYqx7RLrPfzOXP1dLFMNnKOMJjfs0j3CllR2+GJRAa+xeBU5+JbMkHbXZorezgexw5d
         HGgZ4udmYbVkujDnMOIolsGQ7yZ9Um0MhApXuj0MmHNdk/aseo7VgnbONDaDGCgKVE3c
         FuTyGFUkXda1QvJT4RQyWKfbQAi8S/iBAKCnvKjFKVSRdK55tF/42d80eLGIxnVHMeV9
         i67I3EIzPReqjqpeR0xbzcuj79b5DdwnddziDXHyUbsQumSonS/xMlSxLAb4ToZY3hR+
         QdzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=A44GayFxXseGVVD0HVJY3qkIMetyjm2M3KFYhOBPZao=;
        b=t4Ead4NSPuX1/HrbMeDCne6KnyP8cpdd33kTfZfanLUzISYgtq3SIvgyJWKjvZ5P0v
         Kkss2wuxMUqGkudW4OFlWYjKyhLKL1HWBzeMBUVI7+betapHrI3+sMHAA1aakFQa/C3h
         QYK8Y8mggHwOfOomk4jBt7Z/SqvtrdvOwZOmugdx+Y0alH9Jm7mKspQbeG7YelARQ6S7
         gPbhmPRPotqWafAPZPaFZXCvJQMWxIEyGvIF1YP+Zb35/PwApFw1PVoblTHSS4Dm9Zs0
         etKA8SC9QgVBymaNX1s7be1LmSEPiRxLkJZJIoyBjQPeVufqueaE8QHy4+uW7ZP0fKF0
         oS/g==
X-Gm-Message-State: AOAM532xhJctZoN/bvQNXsYpneGWEqpnfYCfNqdJUNxEVEimPMWef+ZN
        C1+FhF18JP0yXosn/y6E/W5cHuf98W5bdg==
X-Google-Smtp-Source: ABdhPJyayYqbFsxb0MdWRwSCpz3NUX9pwUjHVkmGzVQskq93loEB+jvYxlRiwE+Ww+vF4RZ2rUjS3w==
X-Received: by 2002:a05:651c:1a22:b0:255:61fc:4645 with SMTP id by34-20020a05651c1a2200b0025561fc4645mr1543446ljb.99.1654012179713;
        Tue, 31 May 2022 08:49:39 -0700 (PDT)
Received: from wse-c0127 (2-104-116-184-cable.dk.customer.tdc.net. [2.104.116.184])
        by smtp.gmail.com with ESMTPSA id p16-20020a2e9ad0000000b002556428fcb6sm233597ljj.61.2022.05.31.08.49.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 May 2022 08:49:39 -0700 (PDT)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Ido Schimmel <idosch@nvidia.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH V3 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
In-Reply-To: <YpYk4EIeH6sdRl+1@shredder>
References: <20220524152144.40527-1-schultz.hans+netdev@gmail.com>
 <20220524152144.40527-2-schultz.hans+netdev@gmail.com>
 <Yo+LAj1vnjq0p36q@shredder> <86sfov2w8k.fsf@gmail.com>
 <YpCgxtJf9Qe7fTFd@shredder> <86sfoqgi5e.fsf@gmail.com>
 <YpYk4EIeH6sdRl+1@shredder>
Date:   Tue, 31 May 2022 17:49:32 +0200
Message-ID: <868rqh3do3.fsf@gmail.com>
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

On tis, maj 31, 2022 at 17:23, Ido Schimmel <idosch@nvidia.com> wrote:
> On Tue, May 31, 2022 at 11:34:21AM +0200, Hans Schultz wrote:
>> > Just to give you another data point about how this works in other
>> > devices, I can say that at least in Spectrum this works a bit
>> > differently. Packets that ingress via a locked port and incur an FDB
>> > miss are trapped to the CPU where they should be injected into the Rx
>> > path so that the bridge will create the 'locked' FDB entry and notify it
>> > to user space. The packets are obviously rated limited as the CPU cannot
>> > handle billions of packets per second, unlike the ASIC. The limit is not
>> > per bridge port (or even per bridge), but instead global to the entire
>> > device.
>> 
>> Btw, will the bridge not create a SWITCHDEV_FDB_ADD_TO_DEVICE event
>> towards the switchcore in the scheme you mention and thus add an entry
>> that opens up for the specified mac address?
>
> It will, but the driver needs to ignore FDB entries that are notified
> with locked flag. I see that you extended 'struct
> switchdev_notifier_fdb_info' with the locked flag, but it's not
> initialized in br_switchdev_fdb_populate(). Can you add it in the next
> version?

Yes, definitely. I have only had focus on it in the messages coming up
from the driver, and neglected it the other way.
