Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1AA5FF080
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 16:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbiJNOlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 10:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbiJNOkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 10:40:51 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3962213D31
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:40:43 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id l5so5232976oif.7
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=HZa46c30unM25MuQTDwPkEaLzFAs0PSz9tbfi7EIH2A=;
        b=oSnLNh7v61+s6xj2JWX/OD9O7Dy9Lml3+xo4vK4SPGjGhkkMAQQGEpvmsBITFJhjQ0
         Z0PkONI4QAKZlrWItxLn3fa5kFka6WAbm+W+NPgwhY+o+t9crYuKCxOFaPP1ZfvEmpja
         MYPyw2YTP9E2KcDzEaRvgPDcNVd8omqdZyE5MDYA9rXiqd5GpbC0E4UqGGvTFGGQYpLk
         nPd2PDfJUZ73cHEeLYLeqk3LhRjBK/Nwb+BwapXVNDcLSRp27h5DK+4XWR46T5za9tYw
         0YuA1UGuYoahyekw2P7YByw3TnEKj7XUsui9zrt5h4q/WuJJj/78X6gor2aIDLqnWQwE
         Zmeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HZa46c30unM25MuQTDwPkEaLzFAs0PSz9tbfi7EIH2A=;
        b=UD3GU3iRD6OoyFPE+1vG9CkkjTddat1+44M6j7QKpvLo7n1bgJakyQLep/Bey7h0G5
         8KIK8htkjqYFO3dQ64B/MdPJ3HFgFKWMV8qVPUTBdQWi48Q/++lv7tl7vgckBN8aID02
         JQcLzSzHkiBkrwV7IRBk7djjlNchgVyYvVGynTaYJC4eVF60yyJCpP/QdgPfqEwzHod7
         +BZS7XOZcBIq01KQyA/E7XtW+SbHQOvxaBlZ8i50tReQxXmTXer5BWkULn/Q+/WhxI/W
         +WHWCYd1+IXFNKCAh+eg7AtpdlNjz95zN1ZAwlSnjd9xb2iAeiTsHdj/DJH6NWpDSv8z
         s5Lw==
X-Gm-Message-State: ACrzQf1M1wkAHVz1rsiDkDReB5mMw3vh/qrPN3735ZDd4vfoX8Pb+yEL
        bSQje0rydmi3El1DEhH09R/ftKKpMtncJc38Ld44Rg==
X-Google-Smtp-Source: AMsMyM6kFTLmnWh/762itXbxG4DtkC/NpgAqD+hpJWGexkcIDjTVeOsTP0PcelgTNEkd0TEN85r+H/fBQhgh7METxZ8=
X-Received: by 2002:a05:6808:219a:b0:354:daec:53cb with SMTP id
 be26-20020a056808219a00b00354daec53cbmr2536482oib.2.1665758441818; Fri, 14
 Oct 2022 07:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <eeb0c590-7364-a00e-69fc-2326678d6bdf@ovn.org> <PH0PR13MB4793A85169BB60B8609B192194499@PH0PR13MB4793.namprd13.prod.outlook.com>
 <0aac2127-0b14-187e-0adb-7d6b8fe8cfb1@ovn.org> <e71b2bf2-cfd5-52f4-5fd4-1c852f2a8c6c@ovn.org>
 <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com> <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
 <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
 <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
 <CALnP8ZaZ5zGD4sP3=SSvC=RBmVOOcc9MdA=aaYRQctaBOhmHfQ@mail.gmail.com>
 <CAM0EoM=zWBzivTkEG7uBJepZ0=OZmiuqDF3RmgdWA=FgznRF6g@mail.gmail.com>
 <CALnP8ZY2M3+m_qrg4ox5pjGJ__CAMKfshD+=OxTHCWc=EutapQ@mail.gmail.com>
 <CAM0EoM=5wqbsOL-ZPkuhQXTJh3pTGqhdDDXuEqsjxEoAapApdQ@mail.gmail.com> <b9e25530-e618-421c-922e-b9f2380bc19f@ovn.org>
In-Reply-To: <b9e25530-e618-421c-922e-b9f2380bc19f@ovn.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 14 Oct 2022 10:40:30 -0400
Message-ID: <CAM0EoMkFhGtT5t0103V=h0YVddBrkwiAngP7BZY-vStijUVvtw@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload stats
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     Marcelo Leitner <mleitner@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Tianyu Yuan <tianyu.yuan@corigine.com>,
        Simon Horman <simon.horman@corigine.com>, dev@openvswitch.org,
        oss-drivers <oss-drivers@corigine.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 14, 2022 at 9:00 AM Ilya Maximets <i.maximets@ovn.org> wrote:
>

[..]
> > I thought it was pipe but maybe it is OK(in my opinion that is a bad code
> > for just "count"). We have some (at least NIC) hardware folks on the list.
>
> IIRC, 'OK' action will stop the processing for the packet, so it can
> only be used as a last action in the list.  But we need to count packets
> as a very first action in the list.  So, that doesn't help.
>

That's why i said it is a bad code - but i believe it's what some of
the hardware
people are doing. Note: it's only bad if you have more actions after because
it aborts the processing pipeline.

> > Note: we could create an alias to PIPE and call it COUNT if it helps.
>
> Will that help with offloading of that action?  Why the PIPE is not
> offloadable in the first place and will COUNT be offloadable?

Offloadable is just a semantic choice in this case. If someone is
using OK to count  today - they could should be able to use PIPE
instead (their driver needs to do some transformation of course).

cheers,
jamal
