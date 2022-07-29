Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76022584B12
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 07:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbiG2FZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 01:25:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiG2FZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 01:25:38 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DCC72EC9;
        Thu, 28 Jul 2022 22:25:37 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id r83-20020a1c4456000000b003a3a22178beso84449wma.3;
        Thu, 28 Jul 2022 22:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9B+fJLFGx39Gcy7aaco5Kc5jq5xG1Fk7EO3xuRz7x3o=;
        b=WkAkV/6cwsJb4o9WWErAaQfbeC1idvMXn0SMP+MW4GHMxK6PsP/z8boKVsBjRgrBBf
         oTzZu97jc2U65u1P6Aeax1Cx2y/v8P6B2wALgIA+8yV6tLI+duOfE+322vNNfQOQ92nY
         cvi3vuxawepQluJvA0jxIr5J1KlB3sMnlPvRs5kxlw05xLFG5FSx2+qjcfDdHdFbofbo
         G2JACbV2XIdc/DdeSZ93GoESs+YjDo9spRpFHgzvgzntUgtSJ2EfvZPrxQeH9qRlbl0E
         YHUEQ92oO2oiojydFNjNNwKUcQvn5OFQuYSljUJB5OOmZsBc7BmRmeVjJ1btvuhoRknf
         WmdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9B+fJLFGx39Gcy7aaco5Kc5jq5xG1Fk7EO3xuRz7x3o=;
        b=kQIteV21RtqZrLOA/GnpNA5+mz/5qTBAn478L7amMLyD+0hlee3qrH9A30Gh9TAPRh
         q1SyHS2bLDXhLEo9uWio4j9kiyr++b1E6Bb4Z5JlFtcC5JDj9BuSE9L54vmIub52KlRL
         TNwTNfPBNgK6Mv8YZOQ1r07iffQlMLtSF2mXJMWHmMMWOamMtYUB53AXLdoeI56Rsjtk
         Qpioroozz2nk9Ssuqsfk2egkMVnnIxyczDfSPIG1FDYSJAJgq80Hfv2fdDnr56xTj3fL
         wprfIhgPxGeQd78dCSAKuCoTBK+N25u+mtVynn1xApO6MO66ty/cyleBHSwzN74YMa8e
         4Q3Q==
X-Gm-Message-State: AJIora87r1TOnkujLFpsm692zoQLtlG7WZTJjcuaXKZGdC5v298BU30j
        423RS0qzGa7JvK9qrnhueAMuFtlLJ7HgduvwlCwLXPmrIQ0=
X-Google-Smtp-Source: AGRyM1u21Qu8cK2qjhPRLPYSYqEDJ79Ti7WsX0dOf0bYOn/l7dW8mWB/5YluKzXnT+O4cUxAXDTkdwF+WnqSyq2eEs0=
X-Received: by 2002:a05:600c:3593:b0:3a3:3a49:41a3 with SMTP id
 p19-20020a05600c359300b003a33a4941a3mr1533880wmq.166.1659072335895; Thu, 28
 Jul 2022 22:25:35 -0700 (PDT)
MIME-Version: 1.0
References: <Yr2LFI1dx6Oc7QBo@shredder> <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder> <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <20220717134610.k3nw6mam256yxj37@skbuf> <20220717140325.p5ox5mhqedbyyiz4@skbuf>
 <CAKUejP6g3HxS=Scj-2yhsQRJApxnq1e31Nkcc995s7gzfMJOew@mail.gmail.com>
 <20220717183852.oi6yg4tgc5vonorp@skbuf> <CAKUejP7WyL2r03EiZU4hA63u2e=Wz3KM4X=rDdji5pdZ0ptaZg@mail.gmail.com>
 <20220721114540.ovm22rtnwqs77nfb@skbuf> <CAKUejP6xR81p1QeSCnDP_3uh9owafdYr1pifeCzekzUvU3_dPw@mail.gmail.com>
In-Reply-To: <CAKUejP6xR81p1QeSCnDP_3uh9owafdYr1pifeCzekzUvU3_dPw@mail.gmail.com>
From:   Hans S <schultz.hans@gmail.com>
Date:   Fri, 29 Jul 2022 07:23:19 +0200
Message-ID: <CAKUejP5FGqJZ3HNUANsi4VzM5VRGYmDBRQt3Ohvd90wxyEhEqA@mail.gmail.com>
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

On Sun, Jul 24, 2022 at 10:09 AM Hans S <schultz.hans@gmail.com> wrote:
>
> On Thu, Jul 21, 2022 at 1:45 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > On Sun, Jul 17, 2022 at 09:20:57PM +0200, Hans S wrote:
> >
> > I'm only pointing out the obvious here, we need an opt in for MAB, and
> > the implemented behavior I've seen here kind of points to mapping this
> > to "+learning +locked", where the learning process creates locked FDB entries.
>
> I can go with the reasoning for the opt in for MAB, but disabling link
> local learning system wide I don't think is a good idea, unless
> someone can ensure me that it does not impact something else.
> In general locked ports should never learn from link local, which is a
> problem if they do, which suggests to me that this patch should
> eventually be accepted as the best solution.

Hi Vladimir,
sorry, I forget myself. We cannot use +learning as an opt in for MAB
with this driver, as there will be no HW refresh and other interrupts
like the age out violation will not occur either, which will be needed
further on.
If we really need an opt in for MAB, I think it will have to be a new flag.
Hans
