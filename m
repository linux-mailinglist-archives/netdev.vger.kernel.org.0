Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5224E6515
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 15:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350864AbiCXO3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 10:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350874AbiCXO31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 10:29:27 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A9748D69B;
        Thu, 24 Mar 2022 07:27:53 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id u26so5794720eda.12;
        Thu, 24 Mar 2022 07:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1mgEXiGsl/QB+QMzYaAJ1iJlTHeb5P/3V+slUcvUq3s=;
        b=HkLs3ydga3kzDShY5kesQY6pvgLG5b4VivoBF9GRfwQCnwDTa6+r4SH9B+hvZULlfz
         WQhCnPBcSUu7WJCKzEqlXjm+q/03DKkvnXvhx2wE/I80mGP4/cEzI0BzKbuX8v2T2mDz
         T0C6cdVXNcmYq4Ef7Z7VKdIQ1CoujNRHZwQzi06BcEDl6+9T1r+Km5XOsuVmTmgjg61h
         VFvHyCEPFH/8wpG8TxX/hGngtuLKIHzehJvgaaGGSLSsuX+OWquqxMZynye6r6UJSj/9
         6vv7E0/wtf5J0HEwsiPnTptnSYEHYo4e+px95qs+4wOU+hD4550OyVwq14mEjblNwwcr
         KmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1mgEXiGsl/QB+QMzYaAJ1iJlTHeb5P/3V+slUcvUq3s=;
        b=qK4FCPg8UlbkgTw1ZF5Oo7UMVa6GE7Z0YykwRg/6BsJ5U1xggZQnIb+DwygMt0cp03
         7yYwQ95J3AXhYOwKS4V2CDXsxtLTzmTuEv+UplvMOZZn5y08EVH5rspJ1+Qt6+43mOY0
         /rRqCgG4fj9KcTSLib+Uoyeuqs21+OAEXouanabT4hGQDj7anbmzpoI0DuaV6o7CNGfp
         +rprJw9tQBH1dy097t9KWs62I2acEtti6e0TePP1lEAIlIk4u8obHl8Gv5uWlr+sye8k
         nXUvhnLzjXhRS7xVuswSltPP9oTQqNLgBKJ7ZxEWkfqJx0MQaxwwUepT7tVv9YEC9kXy
         ecNQ==
X-Gm-Message-State: AOAM532+CZ8fFFHWNCYuDhwDJoDe3AB5Jt8ae0VSZPerkNMtXX7kXb7W
        Ls3OKYuSz9+NX9fQq9ma2Zc=
X-Google-Smtp-Source: ABdhPJz8hv+O8YQYYkQf4DDoWTJbyIxKafa4a90+aQAukFcxiwWWyQOJoJoLat0TXOhj7hUbKHuE/w==
X-Received: by 2002:aa7:da1a:0:b0:419:b08:476f with SMTP id r26-20020aa7da1a000000b004190b08476fmr6883648eds.281.1648132071780;
        Thu, 24 Mar 2022 07:27:51 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id f15-20020a50e08f000000b004134a121ed2sm1522159edl.82.2022.03.24.07.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 07:27:50 -0700 (PDT)
Date:   Thu, 24 Mar 2022 16:27:49 +0200
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
Message-ID: <20220324142749.la5til4ys6zva4uf@skbuf>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
 <86o81whmwv.fsf@gmail.com>
 <20220323123534.i2whyau3doq2xdxg@skbuf>
 <86wngkbzqb.fsf@gmail.com>
 <20220323144304.4uqst3hapvzg3ej6@skbuf>
 <86lewzej4n.fsf@gmail.com>
 <20220324110959.t4hqale35qbrakdu@skbuf>
 <86v8w3vbk4.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86v8w3vbk4.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 12:23:39PM +0100, Hans Schultz wrote:
> On tor, mar 24, 2022 at 13:09, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Thu, Mar 24, 2022 at 11:32:08AM +0100, Hans Schultz wrote:
> >> On ons, mar 23, 2022 at 16:43, Vladimir Oltean <olteanv@gmail.com> wrote:
> >> > On Wed, Mar 23, 2022 at 01:49:32PM +0100, Hans Schultz wrote:
> >> >> >> Does someone have an idea why there at this point is no option to add a
> >> >> >> dynamic fdb entry?
> >> >> >> 
> >> >> >> The fdb added entries here do not age out, while the ATU entries do
> >> >> >> (after 5 min), resulting in unsynced ATU vs fdb.
> >> >> >
> >> >> > I think the expectation is to use br_fdb_external_learn_del() if the
> >> >> > externally learned entry expires. The bridge should not age by itself
> >> >> > FDB entries learned externally.
> >> >> >
> >> >> 
> >> >> It seems to me that something is missing then?
> >> >> My tests using trafgen that I gave a report on to Lunn generated massive
> >> >> amounts of fdb entries, but after a while the ATU was clean and the fdb
> >> >> was still full of random entries...
> >> >
> >> > I'm no longer sure where you are, sorry..
> >> > I think we discussed that you need to enable ATU age interrupts in order
> >> > to keep the ATU in sync with the bridge FDB? Which means either to
> >> > delete the locked FDB entries from the bridge when they age out in the
> >> > ATU, or to keep refreshing locked ATU entries.
> >> > So it seems that you're doing neither of those 2 things if you end up
> >> > with bridge FDB entries which are no longer in the ATU.
> >> 
> >> Any idea why G2 offset 5 ATUAgeIntEn (bit 10) is set? There is no define
> >> for it, so I assume it is something default?
> >
> > No idea, but I can confirm that the out-of-reset value I see for
> > MV88E6XXX_G2_SWITCH_MGMT on 6190 and 6390 is 0x400. It's best not to
> > rely on any reset defaults though.
> 
> I see no age out interrupts, even though the ports Age Out Int is on
> (PAV bit 14) on the locked port, and the ATU entries do age out (HoldAt1
> is off). Any idea why that can be?
> 
> I combination with this I think it would be nice to have an ability to
> set the AgeOut time even though it is not per port but global.

Sorry, I just don't know. Looking at the documentation for IntOnAgeOut,
I see it says that for an ATU entry to trigger an age out interrupt, the
port it's associated with must have IntOnAgeOut set.
But your locked ATU entries aren't associated with any port, they have
DPV=0, right? So will they never trigger any age out interrupt according
to this? I'm not clear.
