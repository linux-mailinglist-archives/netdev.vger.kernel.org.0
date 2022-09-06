Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59615AF6B2
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230266AbiIFVR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:17:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbiIFVRW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:17:22 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09826B8F30
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 14:17:22 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id n65-20020a17090a5ac700b001fbb4fad865so12730021pji.1
        for <netdev@vger.kernel.org>; Tue, 06 Sep 2022 14:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date;
        bh=oTzUbb/6CE82vCLs9D17/mfJjdHTEO8Nl2XjNtgXIo8=;
        b=Q/8sqYK1JYCg2PiqbQ6C9Ur5SfeZjAuqMCsg11XEUl/9n4pnQTq/AJIggRCUahkgtC
         ZHz0Kccp+S9Cd5+DPM/Wiiw/ujq3aOuJQNpftLzHvxgDG7/yvG7Nph6VnQXxv/p7Rt6J
         /3jBFw+aU+OXPwzIaazEYrplnryVnEd/SeMxNPkNzRvl6823kjsQEY9SB+uTfqbRX0U6
         dNr8h2uavWOxjbeKYchLu0Cu2vfGNSoRWZyVD/xcI+cgGIHadoqVnAUlK1trMNZY13dN
         LD6HsZq6lSEKBXgUm3qkZk9N794/+ZB5gGd7/LyqHw0tQL9lUmKx77ozLiymYL+cz+6Y
         XcZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date;
        bh=oTzUbb/6CE82vCLs9D17/mfJjdHTEO8Nl2XjNtgXIo8=;
        b=zU+BcIsfycqnIspZIBhcgDpQFHQIQsW1sPbGtEmFpCaa22BH8KOe0Uw388qDjIvp3M
         P+hHouo5K+Ey3AD46pfNS+gs9dQ1sgiEZ76zh0tZrr4UUFzoMb8yVjSmd0FxufShy9Az
         XPv5ZISeLyoNS3sICwxLulK0aIEhM8gxzqxTqn6vd13klk2mDZnJh37VFjuO7lxSqYNv
         oEs/xkKj3Ikj3N0M1f27PK4G3dsuYyR93Gmq6iqq+6t6RyL1lB2Ip2swgOuseuS9kqhe
         OwqzB98EuHbrRQu5J/VL3EwSV1/diZj9fCgliW51OvJlSDidQe2DeNoU3hgDj1HKa1TB
         ZWBA==
X-Gm-Message-State: ACgBeo0/6EQ9aZwftN7BgCDTd+cWPQDTJXKN9IukEJ3s2qdHAfOhwRcM
        ksYKY8TNaByvhnnYoE17lcFPkg==
X-Google-Smtp-Source: AA6agR78gk9guthLs/jjz6UEIg1HSfT3QiIV/A2uKhPOi29K7tILy0Gn9FqMCESig/8XYKzwhWwoeg==
X-Received: by 2002:a17:90b:1804:b0:1fb:141:a09d with SMTP id lw4-20020a17090b180400b001fb0141a09dmr26306332pjb.170.1662499041494;
        Tue, 06 Sep 2022 14:17:21 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id n2-20020a170902f60200b00174c0dd29f0sm10375285plg.144.2022.09.06.14.17.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Sep 2022 14:17:21 -0700 (PDT)
Date:   Tue, 6 Sep 2022 14:17:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH iproute2] ip link: add sub-command to view and change
 DSA master
Message-ID: <20220906141719.4482f31d@hermes.local>
In-Reply-To: <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
References: <20220904190025.813574-1-vladimir.oltean@nxp.com>
        <20220906082907.5c1f8398@hermes.local>
        <20220906164117.7eiirl4gm6bho2ko@skbuf>
        <20220906095517.4022bde6@hermes.local>
        <20220906191355.bnimmq4z36p5yivo@skbuf>
        <YxeoFfxWwrWmUCkm@lunn.ch>
        <05593f07-42e8-c4bd-8608-cf50e8b103d6@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 6 Sep 2022 13:33:09 -0700
Florian Fainelli <f.fainelli@gmail.com> wrote:

> On 9/6/2022 1:05 PM, Andrew Lunn wrote:
> >> [ Alternative answer: how about "schnauzer"? I always liked how that word sounds. ]  
> > 
> > Unfortunately, it is not gender neutral, which i assume is a
> > requirement?
> > 
> > Plus the plural is also schnauzer, which would make your current
> > multiple CPU/schnauzer patches confusing, unless you throw the rule
> > book out and use English pluralisation.  
> 
> What a nice digression, I had no idea you two mastered German that well 
> :). How about "conduit" or "mgmt_port" or some variant in the same lexicon?

Is there an IEEE or PCI standard for this? What is used there?
