Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CAB4E74A4
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 15:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346959AbiCYOBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 10:01:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359119AbiCYOBv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 10:01:51 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69EDB63390;
        Fri, 25 Mar 2022 07:00:08 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id yy13so15577303ejb.2;
        Fri, 25 Mar 2022 07:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=E3/UBDuXc/UMmAXiWRPwW4yrgBs5CuzWGxqSCJFk/HA=;
        b=jWTwiuS5J1LrH6cNNWJ4K0NyE7bDgt9LgcQhvS3W40AjSY7EmaEqafmoyHMSa3VizF
         VoEWDjJDMheSWhOWi+x5jJN2F5AFrOL/bVupo+noUKAbAoVJHeVH+wqHRazBsqnbCIH8
         QKhnL2aSKn5nuHFty6ORYnsb7WsnVurJYPxNIjZcxTJPb4GqhBgc7Qcn7reHuH7jxI+M
         wKHfKCOBuNk69pCNkRVrQ6s5keW2Wl49PGXgCkAzapgAW2/cNVJZcMNtc8xUxclNd28F
         459h0EbhHdNZUZ+rohyB+u+7hR+x1bq5oZMWVyxwy5M3W7SWdewbgV9mY7tEFZbE/dCa
         0kdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E3/UBDuXc/UMmAXiWRPwW4yrgBs5CuzWGxqSCJFk/HA=;
        b=AGkLXktG+8i5a5zmuw0vclhCuKN8yjW0xETkGun6mooaxoiViNkyBZSzV4FyDdYLbP
         c8+GBpG3mkYiYjHrECh7OARDxrDsSRZNow465p9iDNj0w6e2ZmNDJuXrYJFX0Hdu7aS0
         661Fg33ztQ5jnjcSDscEMs/Na3ZLygpbow8ez9ANMV2yiAbbt5/9zXD1U8tDl2C+iGUO
         mPGGnKcUXS1hG7aS3I70mkdXpMeJd+RBmSQDq5cHBxJGsGroX5FHctjkaKuwCcYmF6D7
         vB2qISKTGaGpkY7ewtewWiunxBWcqeALwjPMZfKH2Dn1KW2+aSv+geS0USUFFmD6lwWu
         yfbw==
X-Gm-Message-State: AOAM5321EZ/4MLGCbucnhaw1XE2aZ0CEubr8Xdv4iIUvXgC+rZDZqtRm
        RIwTv6BKgg3IcwCb/5eOI2Y=
X-Google-Smtp-Source: ABdhPJyc2AGROsTgH7tBlOTLHPM9gCauyoGQNJXHixZDBfPKeV6KEk95m7F6VkXZKLLztYxtxjTSJw==
X-Received: by 2002:a17:907:9956:b0:6b9:a6d9:a535 with SMTP id kl22-20020a170907995600b006b9a6d9a535mr11905555ejc.64.1648216806904;
        Fri, 25 Mar 2022 07:00:06 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id z1-20020a05640235c100b004192c7266f5sm2840616edc.16.2022.03.25.07.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 07:00:06 -0700 (PDT)
Date:   Fri, 25 Mar 2022 16:00:03 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
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
Message-ID: <20220325140003.a4w4hysqbzmrcxbq@skbuf>
References: <20220323123534.i2whyau3doq2xdxg@skbuf>
 <86wngkbzqb.fsf@gmail.com>
 <20220323144304.4uqst3hapvzg3ej6@skbuf>
 <86lewzej4n.fsf@gmail.com>
 <20220324110959.t4hqale35qbrakdu@skbuf>
 <86v8w3vbk4.fsf@gmail.com>
 <20220324142749.la5til4ys6zva4uf@skbuf>
 <86czia1ned.fsf@gmail.com>
 <20220325132102.bss26plrk4sifby2@skbuf>
 <86fsn6uoqz.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86fsn6uoqz.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 02:48:36PM +0100, Hans Schultz wrote:
> > If you'd cache the locked ATU entry in the mv88e6xxx driver, and you'd
> > notify switchdev only if the entry is new to the cache, then you'd
> > actually still achieve something major. Yes, the bridge FDB will contain
> > locked FDB entries that aren't in the ATU. But that's because your
> > printer has been silent for X seconds. The policy for the printer still
> > hasn't changed, as far as the mv88e6xxx, or bridge, software drivers are
> > concerned. If the unauthorized printer says something again after the
> > locked ATU entry expires, the mv88e6xxx driver will find its MAC SA
> > in the cache of denied addresses, and reload the ATU. What this
> > achieves
> 
> The driver will in this case just trigger a new miss violation and add
> the entry again I think.
> The problem with all this is that a malicious attack that spams the
> switch with random mac addresses will be able to DOS the device as any
> handling of the fdb will be too resource demanding. That is why it is
> needed to remove those fdb entries after a time out, which dynamic
> entries would serve.

An attacker sweeping through the 2^47 source MAC address range is a
problem regardless of the implementations proposed so far, no?
If unlimited growth of the mv88e6xxx locked ATU entry cache is a
concern (which it is), we could limit its size, and when we purge a
cached entry in software is also when we could emit a
SWITCHDEV_FDB_DEL_TO_BRIDGE for it, right?
