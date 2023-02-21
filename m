Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D8169DE5F
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233222AbjBULDP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:03:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbjBULDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:03:14 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EA6222E5
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 03:03:11 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id p8so4094930wrt.12
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 03:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=A8XGVBuie0/uNyjuFwf1Y0bMcEjFE4nOgVnkNYKNNe0=;
        b=HMtMfCoOLW9YRxrRBXH4l1PW00ZsVn5qfNHJDVYdXdUJwly5ByapZJFQ52kuf9zayn
         dfyXi9/LR1IxHGV/ZZwxxo1nV6EWlsiF0zLx88+bcjMsfeBvlAzsBPq+GMefVN/+TeWT
         ApUTHW2FvD2wtE+hyhCIeKwJeBgfUJvv4/iu7BCAqPrJivOsIqEfSeHYFZPJzREgXCx3
         c517p4GtAPAsHARZ2nbph/E2ybHaiwKXn4mFkrGGr1hWY00A5rRjRzOi6YJLsN0HZfhe
         wTUOghRVOsc8KmPQpuGtXshkwT6IG37wNuVhraVE0siP7HpXZz+ubJBDCzrfpvvsHh/c
         pPew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=A8XGVBuie0/uNyjuFwf1Y0bMcEjFE4nOgVnkNYKNNe0=;
        b=DP6eI2xaVj1Jt0Vb/w+n1KVtEPPh9NIGc4NFboSr4w6jocuZLD8hMKAG1wprfPI/y0
         Tm8Hq7Ey1YyZV2rPaL/15xmv969HCWtmY8eq5MSJIfoIumH+Dxryiea2pU0p4FW5KCmN
         WbskoIGheRVFzqXpUlQ04Lyk3ERnsc+3Mh02YHt+YOEY08lqNX5K6ilj47W+8IfGRLeF
         /7dvvVX98t9LQkefBW2fzTSgmfto27ncWvilPHjPAfZsUCNlII7lWaKRMFCNZMDEKm8j
         IsRQbcnDkSa7qGGZxpXDh9rNQivTJq5W1SJdzKCW6vNPD0vdFkrL1rkyxUfe/Tp9luju
         OMkw==
X-Gm-Message-State: AO0yUKV/3QYNv89M2f26nscMnmDRMUrG2575euEXLumGhXFDDxeJAApy
        mZn/+jxr+uTBtvH07M6w/bQ=
X-Google-Smtp-Source: AK7set/PYioEf/rO+okUbjNWR3Z843wMcyaMFkxO9rm3wFF4N3IDbJpP2wXfjoT1cBVN/Vefrqq+LQ==
X-Received: by 2002:a05:6000:cd:b0:2c6:e7f2:6e83 with SMTP id q13-20020a05600000cd00b002c6e7f26e83mr2975286wrx.42.1676977389448;
        Tue, 21 Feb 2023 03:03:09 -0800 (PST)
Received: from [10.148.80.132] ([195.228.69.10])
        by smtp.gmail.com with ESMTPSA id y16-20020a5d4710000000b002c553509db7sm8453452wrq.52.2023.02.21.03.03.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 03:03:08 -0800 (PST)
Message-ID: <e928f31c8a2e6775c3f64ce20365998ab00b22ed.camel@gmail.com>
Subject: Re: [EXT] Re: [PATCH net-next] net/hanic: Add the hanic network
 interface for high availability links
From:   Ferenc Fejes <primalgamer@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jiri Pirko <jiri@resnulli.us>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Steve Williams <steve.williams@getcruise.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        vinicius.gomes@intel.com, xiaoliang.yang_1@nxp.com
Date:   Tue, 21 Feb 2023 12:03:08 +0100
In-Reply-To: <Y344ShAVEjFtKyXA@lunn.ch>
References: <20221118232639.13743-1-steve.williams@getcruise.com>
         <20221121195810.3f32d4fd@kernel.org>
         <20221122113412.dg4diiu5ngmulih2@skbuf>
         <CALHoRjcw8Du+4Px__x=vfDfjKnHVRnMmAhBBEznQ2CfHPZ9S0A@mail.gmail.com>
         <20221123142558.akqff2gtvzrqtite@skbuf> <Y34zoflZsC2pn9RO@nanopsycho>
         <Y344ShAVEjFtKyXA@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Wed, 2022-11-23 at 16:12 +0100, Andrew Lunn wrote:
> > I guess for the same reason other soft netdevice driver are in the
> > kernel. You can do bridge, bond, etc in a silimilar way you
> > described
> > here...
>=20
> Performance of tun/tap is also not great.

Yes, but mostly because of the throughput. It also that severe the
latency issue too?

FRER tipically used in TSN use-cases, where 10 and 100 Mbps covers like
90% what you need. 1Gbps at max. Yes I agree that the concept can be
useful everywhere when redundancy over multiple hops necessary but I
cant see other than industrial use-cases (like datacenter or so)

>=20
> Doing this in the kernel does seem correct. But we need one
> implementation which can be expanded over time to cover everything in
> the standard. From what has been said so far, it seems like this
> implementation focuses on leaf nodes, because that is what the author
> of the code is interested in. But is the design generic enough it can
> be expanded to cover everything else? I'm not saying it actually
> needs
> to implement it now, we just need to have a vision of how it can be
> extended to implement the rest. What we don't want is one way for
> leaf
> nodes, and a completely different code base for other nodes.
>=20
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Andrew

I'm afraid not generic enough.
There are MPLS encapsulated DetNet flows as well (PREOF) which is
different than .1CB but replication/elimination concept is the same.
Also it would be nice to have to store the R-tag seq as a metadata and
replicate it in hybrid L2/L3 fashion (TSN and DetNet member streams)

Best,
Ferenc
