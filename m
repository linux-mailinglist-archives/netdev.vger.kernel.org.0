Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C84C75658C2
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 16:36:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbiGDOg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 10:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234383AbiGDOg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 10:36:26 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89A47AE5A;
        Mon,  4 Jul 2022 07:36:25 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 205-20020a1c02d6000000b003a03567d5e9so7694905wmc.1;
        Mon, 04 Jul 2022 07:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8FvyoCcZIIWT/+d0TYytTEN4tkuREx1whLnCxZohGlQ=;
        b=KHZG5UXy9v/MjhNrt3cHkM3YTmdVYJaL2BcNPKrJQaopiKoqiAyrqNgWY49OmWQyCL
         7DC45L0lQS0jnG9b6KpwONbUHu7Vp0wjfNIctqYY10AJ2IOAocf+gUe8Edg3O3pyQ1Og
         VweJVuLEdPT50/6ORDjR5bhbKJGdZZInziAksmp1ZS1qZNrzdyTeWUBTJJg9AY8VAPwb
         CFAiwK21HXoBexPaEQtykodppTzSk4sjV2+CRP6ZzUXDDK0YsSnS244i7bMljTk4JYf8
         eDn6nfn+TT8vWK1rsJPtM1dP1oPs5OyriPhBZ8SM/osUaOHwtijzHOT6r7pkRdsKgKyp
         xdVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8FvyoCcZIIWT/+d0TYytTEN4tkuREx1whLnCxZohGlQ=;
        b=tM4y6qmWH4aUh2AXtnfHRmfVehHMKrteOOggqE1Z52zPGgyC2FgwvS42BmR8Q0PPK4
         Ug15apvADQDcVP8EJlgHYwfLvVqh3f7EKLDUNrVggkNTQxHJECd+bsuQd9DPSk+KmBRJ
         q+DJyrTGXRfA3p3N1lU54/OFzBtG3BvC0lOsZkaALJSiKtovY4NMQNJJ2TvBn2CFunTg
         rhs0easR3DdC5sOEp3wbFZRSoJTGCWjLnsasFleOXutkWxsmzTmDU0727thF0mfNGXMn
         Gd+efDy9X65I4tg2yTcmJZcK1DI2/m6HjNBunmO+hVisY5CRcz/sUR40oL0D9VWTRpI1
         oIKQ==
X-Gm-Message-State: AJIora9JFfps+q5ndXSEpVPa5nj3GzAE7jNm9rsnXCmsGgvM8W7RmB2G
        3lh38psIicrz+UyhJ3HEjjXc8ZCbe87lfvuGKI4=
X-Google-Smtp-Source: AGRyM1u7HbD+/JJKPGW955kb9W8u+xDxmUQN73RgzFx9ZGPMg4WQt8xMOQemSUXBmNjV7kNDwYM2t8gxMOO2lnh9xKc=
X-Received: by 2002:a05:600c:386:b0:3a1:8cd8:fee4 with SMTP id
 w6-20020a05600c038600b003a18cd8fee4mr18584805wmd.44.1656945383975; Mon, 04
 Jul 2022 07:36:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder> <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder> <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <Yr8oPba83rpJE3GV@shredder> <CAKUejP4_05E0hfFp-ceXLgPuid=MwrAoHyQ-nYE3qx3Tisb4uA@mail.gmail.com>
 <YsE+hreRa0REAG3g@shredder> <CAKUejP4H4yKu6LaLUUUWypt7EPuYDK-5UdUDHPF8F2U5hGnzOQ@mail.gmail.com>
 <YsLILMpLI3alAj+1@shredder>
In-Reply-To: <YsLILMpLI3alAj+1@shredder>
From:   Hans S <schultz.hans@gmail.com>
Date:   Mon, 4 Jul 2022 16:36:12 +0200
Message-ID: <CAKUejP5=eNyAso=MW2nb2o=OKMaysmWUJ-zqLcerPg6EzsQVYQ@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/1] net: bridge: ensure that link-local
 traffic cannot unlock a locked port
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
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
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 4, 2022 at 1:00 PM Ido Schimmel <idosch@nvidia.com> wrote:
>
> On Mon, Jul 04, 2022 at 09:54:31AM +0200, Hans S wrote:
> > >
> > > IIUC, with mv88e6xxx, when the port is locked and learning is disabled:
> > >
> > > 1. You do not get miss violation interrupts. Meaning, you can't report
> > > 'locked' entries to the bridge driver.
> > >
> > > 2. You do not get aged-out interrupts. Meaning, you can't tell the
> > > bridge driver to remove aged-out entries.
> > >
> > > My point is that this should happen regardless if learning is enabled on
> > > the bridge driver or not. Just make sure it is always enabled in
> > > mv88e6xxx when the port is locked. Learning in the bridge driver itself
> > > can be off, thereby eliminating the need to disable learning from
> > > link-local packets.
> >
> > So you suggest that we enable learning in the driver when locking the
> > port and document that learning should be turned off from user space
> > before locking the port?
>
> Yes. Ideally, the bridge driver would reject configurations where
> learning is enabled and the port is locked, but it might be too late for
> that. It would be good to add a note in the man page that learning
> should be disabled when the port is locked to avoid "unlocking" the port
> by accident.

Well you cannot unlock the port by either enabling or disabling
learning after the port is locked, but Mac-Auth and refreshing might
not work. I clarify just so that no-one gets confused.

I can do so that the driver returns -EINVAL if learning is on when
locking the port, but that would of course only be for mv88e6xxx...
