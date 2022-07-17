Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA38E5777F0
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 21:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbiGQTXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 15:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231240AbiGQTXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 15:23:04 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F289DEFE;
        Sun, 17 Jul 2022 12:23:03 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d16so14302239wrv.10;
        Sun, 17 Jul 2022 12:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qR5n9WUGINQgKnZyU5jQ5QNhAVmTXkoQM4VlFrsXDgk=;
        b=ROVMbcMOPv+gSbm3EJ0AYvQs8xJipm3EB1VIKbnQn0ywYyjAGUA0Sburuurfmr9fUI
         rXNM9c07v1017JK3vINOTZx/AP9ykov02Jip4XVZnRtdWqGlyYt0b7KURU1CVr5wzdhp
         1lvZdqtbFjtmc7jGXNELiIePVrkhIL++Y0v1Aq7AwuWe0ansFrJW49xDHVWY7rdOoYVC
         7Wsn78PS/3tFE8TP6FafTmxr6V3M3z9c7hZSHZVILX6qzAVgd+KXlezcymqZVSCDuiVV
         SHKpRhuds0LZqUWv1a1DfGN/NCy+t8089iHEj92aJDiFrtNMqN/wlagxvmDCmnfmd39k
         fK7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qR5n9WUGINQgKnZyU5jQ5QNhAVmTXkoQM4VlFrsXDgk=;
        b=t/limwnQZrB0uI1QoVZJiFunrZqrv9z6aPMf26GLGpBfiYSIkh9GvyfJDwZ0SXxfcM
         R6sJreh67n2GMTassuYfpWpKkd0IqSg1j5D1JqXDDluHOeYX6ssvORTGOEcptiPKa0Lh
         RwbxAs7BnS3HNnTQBzM9rAGAvSmJoh58RHqBnfJ8KEefYExLity676cFKH8KIvjcxZd8
         UNRdZzL/KqUnPwXJbTgv0h5G+bspyMACSv4hzC4G9R0tZpHoXqcatirOfoI4J3rrAU3Z
         S+YpEs72jti4UBGMMgRDCQA09kLiOE1wJ19I6j6/vKld2MwK0mbyGGgKOPfehwFl044z
         pk/g==
X-Gm-Message-State: AJIora9VPCvZBEdGzXODqqL0XfTU40fwZc/Xi6mPAbCbncruHB7SDUg9
        tu6v+32OXMMIdCVy2PdDulYltRmPeuc9rWsZGpo=
X-Google-Smtp-Source: AGRyM1txFQkvnskZOx8Nkr/djQB1K/63SDxcCZP7vECAW1wAAJ2eJEJotJhzOPoLVauSB6Lzds4zlNU6k6ARgwyQb6w=
X-Received: by 2002:a5d:6e8e:0:b0:21d:ea5:710f with SMTP id
 k14-20020a5d6e8e000000b0021d0ea5710fmr27515wrz.48.1658085782164; Sun, 17 Jul
 2022 12:23:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220630111634.610320-1-hans@kapio-technology.com>
 <Yr2LFI1dx6Oc7QBo@shredder> <CAKUejP6LTFuw7d_1C18VvxXDuYaboD-PvSkk_ANSFjjfhyDGkg@mail.gmail.com>
 <Yr778K/7L7Wqwws2@shredder> <CAKUejP5w0Dn8y9gyDryNYy7LOUytqZsG+qqqC8JhRcvyC13=hQ@mail.gmail.com>
 <20220717134610.k3nw6mam256yxj37@skbuf> <20220717140325.p5ox5mhqedbyyiz4@skbuf>
 <CAKUejP6g3HxS=Scj-2yhsQRJApxnq1e31Nkcc995s7gzfMJOew@mail.gmail.com> <20220717183852.oi6yg4tgc5vonorp@skbuf>
In-Reply-To: <20220717183852.oi6yg4tgc5vonorp@skbuf>
From:   Hans S <schultz.hans@gmail.com>
Date:   Sun, 17 Jul 2022 21:20:57 +0200
Message-ID: <CAKUejP7WyL2r03EiZU4hA63u2e=Wz3KM4X=rDdji5pdZ0ptaZg@mail.gmail.com>
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

On Sun, Jul 17, 2022 at 8:38 PM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Sun, Jul 17, 2022 at 06:22:57PM +0200, Hans S wrote:
> > On Sun, Jul 17, 2022 at 4:03 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > Yes, it creates an FDB entry in the bridge without the locked flag
> > set, and sends an ADD_TO_DEVICE notice with it.
> > And furthermore link-local packets include of course EAPOL packets, so
> > that's why +learning is a problem.
>
> So if we fix that, and make the dynamically learned FDB entry be locked
> because the port is locked (and offload them correctly in mv88e6xxx),
> what would be the problem, exactly? The +learning is what would allow
> these locked FDB entries to be created, and would allow the MAB to work.
> User space may still decide to not authorize this address, and it will
> remain locked.

The alternative is to have -learning and let the driver only enable
the PAV to admit the interrupts, which is what this implementation
does.
The plus side of this is that having EAPOL packets triggering locked
entries from the bridge side is not really so nice IMHO. In a
situation with 802.1X and MAB on the same port, there will then not be
any triggering of MAB when initiating the 802.1X session, which I
think is the best option. It then also lessens the confusion between
hostapd and the daemon that handles MAB sessions.
