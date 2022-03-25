Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A074E6FF2
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 10:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356801AbiCYJZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 05:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243091AbiCYJZ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 05:25:56 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAB1EC6271;
        Fri, 25 Mar 2022 02:24:22 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id t25so12325932lfg.7;
        Fri, 25 Mar 2022 02:24:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=SSlLErNJDYMhv4sM1Ccd3PQZryIRODWgd2EpDE7WzJU=;
        b=ImL22cgHLGRLQQxTNXhpXmDpiXyJG03HzVsLsMEkEtHc3oKTUje3duGQDbBq+V+Neh
         tmPsIpdPpvQtTLdPpg2Lu0lcrXwOQvzbWvadlNb7yw5V4kMhpIY4YXykVkHCOILSnX96
         JhgL+uZPAevLVwGZE2D782FRMRQoUY0iZ4g3J99icI/q32uPlkNr3WxpnJGOoJsrBua8
         77kxf2YMTUq4IDc+TzyZHXVTj96S+jNl/uLu6AiRB8fhY3dJjmy2oFPYlEifrLwYbHaS
         YOBEYOH2Y26DpmbXAB6sFoUw/AxPKgOSQfqvPS5Bx+XZt1SuKWw1jywskDS6lWllOrgj
         PdRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=SSlLErNJDYMhv4sM1Ccd3PQZryIRODWgd2EpDE7WzJU=;
        b=lUVZpCrsHLjxoFvfJG1fAYXVS0MB6kAI/hjcx5YZ35IgouV5LjpN6xcJY55OlPw7pX
         LehD+U2UCGc+SOvpkdRiiCdE2/Ur3ymhQ1DRUjL5my3MIySrjnR9JolgRDwVJpzljRJq
         1pkylPuPQJ1Q6IAqM6w8a1t+KTyg7SXHbgif9wuQ8mcRk/Cljf6kmh8ZaNcQM4wHrsgm
         0NXBt9fN64hsP5X85HtH+QPbzZxQShM6bB/tQch1Eau5Ia7WMkkJdabHfsuK3D6yicJM
         sMGU1f5UysfymOeEBAi3RqOc/j7xPTFPvg5HM5s/wL1LAqwV2W6MGW5E4Q8u6KScJVbg
         mNZQ==
X-Gm-Message-State: AOAM533Z3CTGko9QJ+dCh0TpbEbf+1GzFicffabjtFJVMPZ3fe5ZtjvE
        8Ugz38u2hN4Qhn76B21lVQ32xVkP0iv+Ig==
X-Google-Smtp-Source: ABdhPJxUl03eI7VIoMcm91yImWCR15ZIRnY2kcIx5G8CT1JoWCIArZwUr9kqUwyPTAjkH7G0HgV4pA==
X-Received: by 2002:ac2:4477:0:b0:44a:55c6:155d with SMTP id y23-20020ac24477000000b0044a55c6155dmr7015681lfl.376.1648200261100;
        Fri, 25 Mar 2022 02:24:21 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id q20-20020a2e8754000000b002497cfaf36csm614439ljj.42.2022.03.25.02.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 02:24:20 -0700 (PDT)
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
In-Reply-To: <20220324142749.la5til4ys6zva4uf@skbuf>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
 <86o81whmwv.fsf@gmail.com> <20220323123534.i2whyau3doq2xdxg@skbuf>
 <86wngkbzqb.fsf@gmail.com> <20220323144304.4uqst3hapvzg3ej6@skbuf>
 <86lewzej4n.fsf@gmail.com> <20220324110959.t4hqale35qbrakdu@skbuf>
 <86v8w3vbk4.fsf@gmail.com> <20220324142749.la5til4ys6zva4uf@skbuf>
Date:   Fri, 25 Mar 2022 10:24:17 +0100
Message-ID: <865yo21j26.fsf@gmail.com>
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

On tor, mar 24, 2022 at 16:27, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Mar 24, 2022 at 12:23:39PM +0100, Hans Schultz wrote:
>> On tor, mar 24, 2022 at 13:09, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Thu, Mar 24, 2022 at 11:32:08AM +0100, Hans Schultz wrote:
>> >> On ons, mar 23, 2022 at 16:43, Vladimir Oltean <olteanv@gmail.com> wrote:
>> >> > On Wed, Mar 23, 2022 at 01:49:32PM +0100, Hans Schultz wrote:
>> >> >> >> Does someone have an idea why there at this point is no option to add a
>> >> >> >> dynamic fdb entry?
>> >> >> >> 
>> >> >> >> The fdb added entries here do not age out, while the ATU entries do
>> >> >> >> (after 5 min), resulting in unsynced ATU vs fdb.
>> >> >> >
>> >> >> > I think the expectation is to use br_fdb_external_learn_del() if the
>> >> >> > externally learned entry expires. The bridge should not age by itself
>> >> >> > FDB entries learned externally.
>> >> >> >
>> >> >> 
>> >> >> It seems to me that something is missing then?
>> >> >> My tests using trafgen that I gave a report on to Lunn generated massive
>> >> >> amounts of fdb entries, but after a while the ATU was clean and the fdb
>> >> >> was still full of random entries...
>> >> >
>> >> > I'm no longer sure where you are, sorry..
>> >> > I think we discussed that you need to enable ATU age interrupts in order
>> >> > to keep the ATU in sync with the bridge FDB? Which means either to
>> >> > delete the locked FDB entries from the bridge when they age out in the
>> >> > ATU, or to keep refreshing locked ATU entries.
>> >> > So it seems that you're doing neither of those 2 things if you end up
>> >> > with bridge FDB entries which are no longer in the ATU.
>> >> 
>> >> Any idea why G2 offset 5 ATUAgeIntEn (bit 10) is set? There is no define
>> >> for it, so I assume it is something default?
>> >
>> > No idea, but I can confirm that the out-of-reset value I see for
>> > MV88E6XXX_G2_SWITCH_MGMT on 6190 and 6390 is 0x400. It's best not to
>> > rely on any reset defaults though.
>> 
>> I see no age out interrupts, even though the ports Age Out Int is on
>> (PAV bit 14) on the locked port, and the ATU entries do age out (HoldAt1
>> is off). Any idea why that can be?
>> 
>> I combination with this I think it would be nice to have an ability to
>> set the AgeOut time even though it is not per port but global.
>
> Sorry, I just don't know. Looking at the documentation for IntOnAgeOut,
> I see it says that for an ATU entry to trigger an age out interrupt, the
> port it's associated with must have IntOnAgeOut set.
> But your locked ATU entries aren't associated with any port, they have
> DPV=0, right? So will they never trigger any age out interrupt according
> to this? I'm not clear.

If it could be possible to add a dynamic entry to the bridge module from
the driver, that would be a solution, and since in the ATU in this case
ages out entries learned, I don't see why __br_fdb_add() insists that an
external learned entry must be permanent?
