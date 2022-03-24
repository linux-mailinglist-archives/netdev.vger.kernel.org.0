Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBA454E6269
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 12:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346119AbiCXLZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 07:25:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236913AbiCXLZR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 07:25:17 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141173ED1E;
        Thu, 24 Mar 2022 04:23:45 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id h11so5711030ljb.2;
        Thu, 24 Mar 2022 04:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=zbdwVgmEzDHA4WNpeMf8bwrU5wjzXUixO+mPzgyLSZI=;
        b=UpFKoE+XZn1XgesQCFLWG+c4rStcpUK9jHmSYwU5uRzUVpZXQnBJDo+rMH+3h7n/12
         72ptiKgHeuDJZPiu6fwyPB26xc0C2Vs/ZeE3hjWjx4SM3AC7FhLRs2j+5pwfeHhuSiaA
         KBG2+6ngx4lRKZLxTRkgJG5JrySYO5rMXWM1nCC+hXprBjkk7l144WjsfcQaZ/bwMyPv
         BDpy0tIM0YCzILV5Nlnces8sVUAIrtdezsexH7cu9PR2YPfcRRdpb3gYTOlzxC7FohSq
         6dOVBzI0kiyYFTd5biaLHNaRmOLpy1HsIg2L13+u6BaSTot8UcrGL0UCPAbu2iZOn01X
         Q9SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=zbdwVgmEzDHA4WNpeMf8bwrU5wjzXUixO+mPzgyLSZI=;
        b=0zNy0KM9qMggpMH1SmCXfAK3mvNw+mF0BP7x0bwYgUWp2YzQXaab5tZfgFHEzZj3lD
         xoFuUAUugceJ9DdZLOnsIRn8lLbTr+i3bRW+6Km6T6HC5IR3EOdBWUMkDIRQm9I7js3f
         9dUC4qesLdVkVX9o+29kE/691BjCpw55aUYody6gBPKS9vtbbj028A1JmPM6mmKFWFz1
         aDPQWyF//EGllCSqNwEZGjByMjxQLk9HCKYZiETSq3i9fLYKHy9D335wyWEQyjXo+2mN
         R238jnAowPHRYiDJSiPD+nR85fG9D+gXeTb4tmh1+g96Yt1IuKyVGLCPzLEcxO3JJWYE
         8evw==
X-Gm-Message-State: AOAM532FSH1qnruBjeLWHt7bUUkWbpDKfiOPoL20LkibB+v4vsaSzV1M
        +ZzvUzBl8yQ4qY4y4tuaFa6BVSHCHZDIAgET
X-Google-Smtp-Source: ABdhPJzUbdvFK0PzuPbcYo1YnvFUJKYjAXVakppqx3v8jhG8emZHBuIPJU6uBBIjOEdMZeQZ+8rh0w==
X-Received: by 2002:a2e:8547:0:b0:248:b0a:bc45 with SMTP id u7-20020a2e8547000000b002480b0abc45mr3774397ljj.271.1648121023224;
        Thu, 24 Mar 2022 04:23:43 -0700 (PDT)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id i6-20020a2ea366000000b00248073ae9a2sm311183ljn.84.2022.03.24.04.23.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Mar 2022 04:23:42 -0700 (PDT)
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
In-Reply-To: <20220324110959.t4hqale35qbrakdu@skbuf>
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-3-schultz.hans+netdev@gmail.com>
 <86o81whmwv.fsf@gmail.com> <20220323123534.i2whyau3doq2xdxg@skbuf>
 <86wngkbzqb.fsf@gmail.com> <20220323144304.4uqst3hapvzg3ej6@skbuf>
 <86lewzej4n.fsf@gmail.com> <20220324110959.t4hqale35qbrakdu@skbuf>
Date:   Thu, 24 Mar 2022 12:23:39 +0100
Message-ID: <86v8w3vbk4.fsf@gmail.com>
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

On tor, mar 24, 2022 at 13:09, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Mar 24, 2022 at 11:32:08AM +0100, Hans Schultz wrote:
>> On ons, mar 23, 2022 at 16:43, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Wed, Mar 23, 2022 at 01:49:32PM +0100, Hans Schultz wrote:
>> >> >> Does someone have an idea why there at this point is no option to add a
>> >> >> dynamic fdb entry?
>> >> >> 
>> >> >> The fdb added entries here do not age out, while the ATU entries do
>> >> >> (after 5 min), resulting in unsynced ATU vs fdb.
>> >> >
>> >> > I think the expectation is to use br_fdb_external_learn_del() if the
>> >> > externally learned entry expires. The bridge should not age by itself
>> >> > FDB entries learned externally.
>> >> >
>> >> 
>> >> It seems to me that something is missing then?
>> >> My tests using trafgen that I gave a report on to Lunn generated massive
>> >> amounts of fdb entries, but after a while the ATU was clean and the fdb
>> >> was still full of random entries...
>> >
>> > I'm no longer sure where you are, sorry..
>> > I think we discussed that you need to enable ATU age interrupts in order
>> > to keep the ATU in sync with the bridge FDB? Which means either to
>> > delete the locked FDB entries from the bridge when they age out in the
>> > ATU, or to keep refreshing locked ATU entries.
>> > So it seems that you're doing neither of those 2 things if you end up
>> > with bridge FDB entries which are no longer in the ATU.
>> 
>> Any idea why G2 offset 5 ATUAgeIntEn (bit 10) is set? There is no define
>> for it, so I assume it is something default?
>
> No idea, but I can confirm that the out-of-reset value I see for
> MV88E6XXX_G2_SWITCH_MGMT on 6190 and 6390 is 0x400. It's best not to
> rely on any reset defaults though.

I see no age out interrupts, even though the ports Age Out Int is on
(PAV bit 14) on the locked port, and the ATU entries do age out (HoldAt1
is off). Any idea why that can be?

I combination with this I think it would be nice to have an ability to
set the AgeOut time even though it is not per port but global.
