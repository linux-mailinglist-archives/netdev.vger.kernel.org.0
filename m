Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B1A5F8537
	for <lists+netdev@lfdr.de>; Sat,  8 Oct 2022 14:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbiJHMcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 08:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiJHMcf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 08:32:35 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A4C50726
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 05:32:34 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id o64so8345502oib.12
        for <netdev@vger.kernel.org>; Sat, 08 Oct 2022 05:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=09SmPRCirrdw52U5aAUOER2EAOZqynZVFpG4iCHSwHU=;
        b=QbJ5Nub6pcTxKY0m2PP++M2lQgEJlSBljZFxqLbaXjSqMepAL+QuN65C/OANaPeq5I
         KSpyUi/tso1gQcWVEEdMwhf0XVymvJ+T9t4HUBMHokOwyuPecEZLdUo5SWbslVEFniTX
         Pi3EDG8zgrXb7rsBNp6F+f4BJNmFZrQoO6Gkj7QH3Z1mVSa7TOZU6SxGc0t/BbGFbjz5
         XRqyDwUW29W3sR9SFxGpFcebCG0nGusMpZzscxf8W1DC6OjxHKtUQZlm1JtWSHOwwk8u
         xze1u2W9c8cqdJpuyCbCfdUx6rjxELkEMqAXCVMIbMKoJFk9Cnjx3Pn72uoL4rYtm8te
         m/4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=09SmPRCirrdw52U5aAUOER2EAOZqynZVFpG4iCHSwHU=;
        b=tNIqKeSYAvUI+5fhEbtJj5FmgKnRI7epY39aL6nYC/84RojcTJihqDhWRrwia8L4xP
         JeqLsgJdRiV4di0e7zwbcRcou4EdIRGBYWpSHHCS73AVDki6DpJGJ1ecd5SMzMFqVD60
         v4hRqIWEdg+sFJNaBBB3VlJ7zW7Gyi0z8DPd6fnhA+R9REfR7r3L7W3pKlTkZdQW6sUe
         dL3h7fv72YWvGEsRlke9okX8q3h4/fwPD1ghfkvLJw/iyOOghkeXDFMKleok0APy/8F6
         5WvdjT8X7Jt67Dnh7genKBAGn29n68rnddUUvOtKGClRFlkoPg53kuXMU+1LWoy9E/yX
         oHGw==
X-Gm-Message-State: ACrzQf08g17G7oapxpyrd92dK9KwXPoZ925T8tGxem+snEahT1i46aCs
        2HZYKsyPaAIIdI49gUyLKRlmrmtqGseIVQlTlSz6t2k742Dlveqj
X-Google-Smtp-Source: AMsMyM77FJnU63XjoN0mErB5M20TngpJUVRPO6thkr356/KggVNAQp0DDUWL/ythAFyfDs1KcfHTOhqRwNRhg/RM7kk=
X-Received: by 2002:a05:6808:148d:b0:350:7858:63ce with SMTP id
 e13-20020a056808148d00b00350785863cemr4742752oiw.106.1665232354162; Sat, 08
 Oct 2022 05:32:34 -0700 (PDT)
MIME-Version: 1.0
References: <eeb0c590-7364-a00e-69fc-2326678d6bdf@ovn.org> <PH0PR13MB4793A85169BB60B8609B192194499@PH0PR13MB4793.namprd13.prod.outlook.com>
 <0aac2127-0b14-187e-0adb-7d6b8fe8cfb1@ovn.org> <e71b2bf2-cfd5-52f4-5fd4-1c852f2a8c6c@ovn.org>
 <00D45065-3D74-4C4C-8988-BFE0CEB3BE2F@redhat.com> <fe0cd650-0d4a-d871-5c0b-b1c831c8d0cc@ovn.org>
 <CALnP8ZYcGvtP_BV=2gy0v3TtSfD=3nO-uzbG8E1UvjoDYD2+7A@mail.gmail.com>
 <CAKa-r6sn1oZNn0vrnrthzq_XsxpdHGWyxw_T9b9ND0=DJk64yQ@mail.gmail.com>
 <CALnP8ZaZ5zGD4sP3=SSvC=RBmVOOcc9MdA=aaYRQctaBOhmHfQ@mail.gmail.com>
 <CAM0EoM=zWBzivTkEG7uBJepZ0=OZmiuqDF3RmgdWA=FgznRF6g@mail.gmail.com> <CALnP8ZY2M3+m_qrg4ox5pjGJ__CAMKfshD+=OxTHCWc=EutapQ@mail.gmail.com>
In-Reply-To: <CALnP8ZY2M3+m_qrg4ox5pjGJ__CAMKfshD+=OxTHCWc=EutapQ@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sat, 8 Oct 2022 08:32:22 -0400
Message-ID: <CAM0EoM=5wqbsOL-ZPkuhQXTJh3pTGqhdDDXuEqsjxEoAapApdQ@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH] tests: fix reference output for meter offload stats
To:     Marcelo Leitner <mleitner@redhat.com>
Cc:     Davide Caratti <dcaratti@redhat.com>,
        Ilya Maximets <i.maximets@ovn.org>,
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

On Fri, Oct 7, 2022 at 1:37 PM Marcelo Leitner <mleitner@redhat.com> wrote:
>
> On Fri, Oct 07, 2022 at 11:59:42AM -0400, Jamal Hadi Salim wrote:
> > On Fri, Oct 7, 2022 at 11:01 AM Marcelo Leitner <mleitner@redhat.com> wrote:
> > >

[..]
> >
> > It's mostly how people who offload (not sure about OVS) do it;
> > example some of the switches out there.
>
> You mean with OK, DROP, TRAP or GOTO actions, right?
>
> Because for PIPE, it has:
>                 } else if (is_tcf_gact_pipe(act)) {
>                         NL_SET_ERR_MSG_MOD(extack, "Offload of
> \"pipe\" action is not supported");
>                         return -EOPNOTSUPP;
>

I thought it was pipe but maybe it is OK(in my opinion that is a bad code
for just "count"). We have some (at least NIC) hardware folks on the list.
Note: we could create an alias to PIPE and call it COUNT if it helps.
And yes, in retrospect we should probably have separated out accounting
from the actions in tc. It makes a lot of sense in s/w - and would work fine for
modern hardware but when you dont have as many counters as actions
it's a challenge. Same thing with policers/meters.

cheers,
jamal
