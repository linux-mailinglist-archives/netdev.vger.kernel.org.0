Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C974B629ECE
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238544AbiKOQT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:19:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238548AbiKOQTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:19:11 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B7331FCEC;
        Tue, 15 Nov 2022 08:18:51 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id l11so22625803edb.4;
        Tue, 15 Nov 2022 08:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uINY/jIMIxRyn6m5pdLz4FKta5fxJkrYSOuMFgbaZyk=;
        b=nNkc8aWzbTjyfUr8kEZx+5alsQ68tw9ghy1Szis2HjFmXT40tm5T6ddp4pxL12POxZ
         c141tfSBWGqFAIw5gScAlVp79RWvnaHk0hssR9rWDYCYqYhU3+9isAEjE34yIyUWoPIn
         EOqiO1h2hzyioaChAQKNdG0mWUlmnys2wCBtLjifrGfJC83MCs0IDZKK+Rk1Qqkdpiyd
         mCWSJNXoyjslI1iBD7+8DmgIlggBP34oFVVFVELlnDvOCP3SMRRiUyY0vgeRnbXZqf4h
         EctjONEQtVI++e0BUc73h71UtVhy+LJtvAKDdnmGzK0uI7mTcNSHMkslpIu46KAMYjUV
         qCuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uINY/jIMIxRyn6m5pdLz4FKta5fxJkrYSOuMFgbaZyk=;
        b=ogDdQ9pk2MiCJMZt58NZfB/3cOqj9/o5/dFNgpcBBIM3lDfT/e10ZK7bvJrH7oxFF5
         HjCG9BPxyUp5vfvlq8Sx07ZkU5GgciLPw6rx7gzPjIbKrjbXlu3Hl/SnDyWbTvonQwXH
         Bo2FtwOxIYCE3eb4DLbvf+OI/9lZUcnCP91baQ1E76sjVAiH466/b6hqJFpqLPgcGyTr
         /9opHkiJ71Rt1KD8VUpElOT6ty7vDV8U3A6cSdiEdXKME99Wsa7DQfu3Xx0Jt5CkVDdy
         V6K7xFpzksggodyfw0CCUUVsAMMvVuTWBYt2n2W2faqA3iNxOOV+ReeGnCqY7EaHvMwr
         Kaqw==
X-Gm-Message-State: ANoB5plA9hh4m7GIm69GoVW5BlLJRVAlNTKNGnrny2ITul6y0DIrkWiX
        5x+wajzVGhbCW5+MseLRdws=
X-Google-Smtp-Source: AA0mqf5Pcwb4Fcrg3PPWz2jGjAx09kUO3+McZ/HW63p07odhpPSiUWELlzhFb/g/4JGD3FZmF4kT1w==
X-Received: by 2002:a05:6402:1856:b0:461:dc29:275b with SMTP id v22-20020a056402185600b00461dc29275bmr15819135edy.108.1668529129431;
        Tue, 15 Nov 2022 08:18:49 -0800 (PST)
Received: from skbuf ([188.26.57.19])
        by smtp.gmail.com with ESMTPSA id 10-20020a170906210a00b0078dce9984afsm5625377ejt.220.2022.11.15.08.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 08:18:48 -0800 (PST)
Date:   Tue, 15 Nov 2022 18:18:46 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     Ido Schimmel <idosch@idosch.org>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 net-next 0/2] mv88e6xxx: Add MAB offload support
Message-ID: <20221115161846.2st2kjxylfvlncib@skbuf>
References: <Y3NcOYvCkmcRufIn@shredder>
 <5559fa646aaad7551af9243831b48408@kapio-technology.com>
 <20221115102833.ahwnahrqstcs2eug@skbuf>
 <7c02d4f14e59a6e26431c086a9bb9643@kapio-technology.com>
 <20221115111034.z5bggxqhdf7kbw64@skbuf>
 <0cd30d4517d548f35042a535fd994831@kapio-technology.com>
 <20221115122237.jfa5aqv6hauqid6l@skbuf>
 <fb1707b55bd8629770e77969affaa2f9@kapio-technology.com>
 <20221115145650.gs7crhkidbq5ko6v@skbuf>
 <f229503b98d772c936f1fc8ca826a14f@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f229503b98d772c936f1fc8ca826a14f@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 05:03:01PM +0100, netdev@kapio-technology.com wrote:
> Yes, so you want me to simply increase the 50ms on line 58 in smi.c...
> 
> I have now tried to increase it even to 10000ms == 10s and it didn't help,
> so something else must be needed...

Not only that, but also the one in mv88e6xxx_wait_mask().
