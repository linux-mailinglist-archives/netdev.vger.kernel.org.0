Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ECCA618D59
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 01:56:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiKDA4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 20:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKDA4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 20:56:46 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 199F01C418
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 17:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667523352;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0bu70cyek0T6oUQkJvlNZ6y2ULUUanZ7+edNBuJSUrk=;
        b=d6jjz7MsTUZRoWLPr5WPxWV+E5iJlU7JPClcDVcSknQpa/W1iGG8a4eX8bd3lRR167lpNf
        kWcUf7YEZBMOEfcRMcGglw4IKVIMQilOPChvOncrCXZqfxS00usAczeT0Q1baa/kbEB9hG
        2hHDR1s95G4ikVpMEncgjEwYwgjUmjw=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-150-G2N57yjePZ2A6ma6qztZdA-1; Thu, 03 Nov 2022 20:55:51 -0400
X-MC-Unique: G2N57yjePZ2A6ma6qztZdA-1
Received: by mail-ed1-f69.google.com with SMTP id q13-20020a056402518d00b00462b0599644so2475931edd.20
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 17:55:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0bu70cyek0T6oUQkJvlNZ6y2ULUUanZ7+edNBuJSUrk=;
        b=fvxt2EuvisInF4v8zE2iGDrQeElKM9p3HDFydSpE/fttc7fxSNk0PyHEQGkjNfFkBC
         scjuVNSb9cD9UOkt+BL6aiTZXACVxUUrbWdFxN+8yOJ947ZglklJ8Yhl0f8GUpFg0wJs
         F/qE2FL5E1mVB0f6r3qXb/JPX0J1iyvi9eoXbJgygi4c0vAQon3ROhXcSo0ET8ekGFH+
         IgXeho6FbMwT6dUsTuHggH/tro6JO9SRtxIeeehXf6+ETJKp4QQyzyptt7764PuIiAnp
         Kf4K6ddvfnz6NBAmGGp6P82Ww2SOoct/JiXMWus522fOY4iw84Akbm54Il6NLbTL5nW+
         QnEQ==
X-Gm-Message-State: ACrzQf16EyYZSFQwTT/ODP8Kwo0pH2eRzuM5xFazaIguE4my1QsRc6xg
        5neVrwwW87ogHBOOC1UjBHeyXurWx0u1ir22dT+ii9me0y7HUEMcGB/+EmixTvzJxmjN1o3OYh8
        /oHRiCp2OFnwQwn0yC6RXQhpvw1vxFqN+
X-Received: by 2002:aa7:dad9:0:b0:462:e628:185b with SMTP id x25-20020aa7dad9000000b00462e628185bmr33269899eds.33.1667523349436;
        Thu, 03 Nov 2022 17:55:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7JBM5gBOz2wO5X4Ev6BkgDVLxPc5660eoJpGMo11FEdj4Hf8i2SAHcrGjmMv+l0Efq66jD/X2tRnVLmK/Tv9Q=
X-Received: by 2002:aa7:dad9:0:b0:462:e628:185b with SMTP id
 x25-20020aa7dad9000000b00462e628185bmr33269880eds.33.1667523349230; Thu, 03
 Nov 2022 17:55:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221026093502.602734-1-miquel.raynal@bootlin.com>
 <CAK-6q+jXPyruvdtS3jgzkuH=f599EiPk7vWTWLhREFCMj5ayNg@mail.gmail.com> <20221102155240.71a1d205@xps-13>
In-Reply-To: <20221102155240.71a1d205@xps-13>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Thu, 3 Nov 2022 20:55:38 -0400
Message-ID: <CAK-6q+hi1dhyfoYAGET55Ku=_in7BbNNaqWQVX2Z_iOg1+0Nyg@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 0/3] IEEE 802.15.4: Add coordinator interfaces
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, Nov 2, 2022 at 10:52 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> aahringo@redhat.com wrote on Sun, 30 Oct 2022 22:20:03 -0400:
>
> > Hi,
> >
> > On Wed, Oct 26, 2022 at 5:35 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > >
> > > Hello,
> > > These three patches allow the creation of coordinator interfaces, which
> > > were already defined without being usable. The idea behind is to use
> > > them advertizing PANs through the beaconing feature.
> > >
> >
> > I still don't know how exactly those "leaves" and "non-leaves" are
> > acting here regarding the coordinator interfaces. If this is just a
> > bit here to set in the interface I am fine with it. But yea,
> > "relaying" feature is a project on its own, as we said previously.
> >
> > Another mail I was asking myself what a node interface is then,
> > currently it is a mesh interface with none of those 802.15.4 PAN
> > management functionality?
>
> Not "none", because I would expect a NODE to be able to perform minimal
> management operations, such as:
> - scanning
> - requesting an association
> But in no case it is supposed to:
> - send beacons
> - manage associations
> - be the PAN coordinator
> - act as a relay
>

perfect, thanks. But still there is something which I don't get.

The split you mentioned about the functionality is for me being a
coordinator (IEEE spec) or pan coordinator (IEEE spec) which has the
additional functionality of "send beacons, manage assocs, act as
relay".
So a coordinator (iftype) is a pan coordinator (IEEE spec) and a node
(iftype) is a coordinator (IEEE spec), but _only_ when it's
associated, before it is just a manually setup mesh node?

I hope it's clear when meaning iftype and when meaning IEEE spec, but
for the manual setup thing (node iftype) there is no IEEE spec,
although it is legal to do it in my opinion.

Thanks.

- Alex

