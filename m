Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A56C57CCE6
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:08:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbiGUOIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiGUOIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:08:39 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3559546DA6;
        Thu, 21 Jul 2022 07:08:38 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d8so2452491wrp.6;
        Thu, 21 Jul 2022 07:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AO1GlvcSPQHdOPNES0k1UPLRvC6PrOllsEsT128vMLI=;
        b=pehk5KzD58O/08ENd7lSRD4mx7T9HMiPOXsm6nLxCxgGJzKWLxnOuWb9/36V2baHhC
         jdOihHICyJYRsw386pYSSlQhr7jbegBgeaigTEOSl+oV16j7x62rM4lY1XO6vHv1X4PA
         Bee6VGr8GyjQOv4NL2KxJmBXWJFiRgmH0k/o27hOdUjYwUeRRWJfr+iPlybacat0VmQF
         iybUQWFJGRd38Us9mVSQkHfNq1AhNaHLM3Ug8K2I9xBzjsYZAQBNMPK1oZu29p2BsNp2
         1x6Q3Ojh/zNVWIbIngRkNrRoLL4FCWDNEtPRTk99Aos+HoeUsmWsKAO/lAMR7D/Vs4n1
         UT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AO1GlvcSPQHdOPNES0k1UPLRvC6PrOllsEsT128vMLI=;
        b=XDkPoVkB7Bf5Htle17FrMq56gWgmsXfwTEjnWHg1s67/qlSwLAJueSpoy7J6rnYXw+
         g8lcTo4rGfPJmeGA16XSin1URB5n/3IaSWCpNYz2utOwk8h4bPPsrU5G24z+qWUAFtwd
         WOZ6kLJhnviLL0BFy4Z5PT0sodii6EeAEycmSKhhjGaIsxtycU2E0zHUoR/r6o+SGjUQ
         zmCI96TGfJvNL3oIPYJ2STLw6/hGIgjiLd+y/gOWR1cEnyK3BDJkzQD9Ct9/9Lzr9YyZ
         uAxI7dRt7/QAdVuRBeNWFuKqQwd2487prVbNm/A0PDUliqDhNB06pclLWoqrcqDJZtuU
         XhjA==
X-Gm-Message-State: AJIora+TK9p/MhZX39xmt5YjbvwLvR4A1rXFUOJtMHl8j7Ds+pvLizEs
        dLoA+RQRv1PqD3C1J1nLETzZQS/bfisXQCa7sps=
X-Google-Smtp-Source: AGRyM1s3kwqmgD+NsnlwCnD8s2G/ku3ybFCEBiAV91puZSFvk+GoHergDEbKulo3B05w+z8fd7tf7YxymwGozUHrJEo=
X-Received: by 2002:a5d:42c4:0:b0:21e:2cd4:a72e with SMTP id
 t4-20020a5d42c4000000b0021e2cd4a72emr11435970wrr.249.1658412516553; Thu, 21
 Jul 2022 07:08:36 -0700 (PDT)
MIME-Version: 1.0
References: <Yr2LFI1dx6Oc7QBo@shredder> <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder> <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <20220717134610.k3nw6mam256yxj37@skbuf> <20220717140325.p5ox5mhqedbyyiz4@skbuf>
 <CAKUejP6g3HxS=Scj-2yhsQRJApxnq1e31Nkcc995s7gzfMJOew@mail.gmail.com>
 <20220717183852.oi6yg4tgc5vonorp@skbuf> <CAKUejP7WyL2r03EiZU4hA63u2e=Wz3KM4X=rDdji5pdZ0ptaZg@mail.gmail.com>
 <20220721114540.ovm22rtnwqs77nfb@skbuf>
In-Reply-To: <20220721114540.ovm22rtnwqs77nfb@skbuf>
From:   Hans S <schultz.hans@gmail.com>
Date:   Thu, 21 Jul 2022 16:06:27 +0200
Message-ID: <CAKUejP6wCaOKiafvbxYqQs0-RibC0FMKtvkiG=R2Ts0Xfa3-tg@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Ido Schimmel <idosch@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 1:45 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> Why is it "not really so nice" to "trigger MAB" (in fact only to learn a
> locked entry on a locked port) when initiating the 802.1X session?

The consideration is mostly to limit (not eliminate) double
actrivation, e.g. activation of 802.1X and MAB at roughly the same
time, so that the daemons will have more to do coordinating which has
the session.

> You can disable link-local learning via the bridge option if you're

The issue here is that you can only disable it bridge wide and not per port.

> really bothered by that. When you have MAB enabled on an 802.1X port,
> I think it's reasonable to expect that there will be some locked entries
> which user space won't ever unlock via MAB. If those entries happen to
> be created as a side effect of the normal EAPOL authentication process,
> I don't exactly see where is the functional problem. This shouldn't
> block EAPOL from proceeding any further, because this protocol uses
> link-local packets which are classified as control traffic, and that
> isn't subject to FDB lookups but rather always trapped to CPU, so locked
> or not, it should still be received.
>
> I'm only pointing out the obvious here, we need an opt in for MAB, and
> the implemented behavior I've seen here kind of points to mapping this
> to "+learning +locked", where the learning process creates locked FDB entries.

If we need an opt in for MAB, you are right. Only then I think that we
need to solve the link-local learning issue so that it is disabled per
port?
