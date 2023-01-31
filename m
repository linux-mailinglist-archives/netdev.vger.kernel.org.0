Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBFAB683994
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 23:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbjAaWuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 17:50:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjAaWuR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 17:50:17 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BF013519
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:50:16 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id t16so20145348ybk.2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 14:50:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JzvU3hptPAwa4hkUBvtSs4yLQLzV+1FO0XItHguv9so=;
        b=7E4TzeO3XGWuwC+c1e90YBXr+jlCwzaCHxqo7v8G3CqvM3iu7/gTEWyDVXT6Ik29WK
         MrA0jTLonPNhCKOmB1Zm8LYNQQqCZlOzPA57NpcNQYbnShxPGr8WL/pvwFBWQVxMkOEq
         4JD/pgdDGbhR82bxG56KfYKkRq7q5plWWMDVEECQWfd5LcITqQDnY6zHsBiXHUqz4Zi1
         K/5guFdzh6D4mnZnWCQIqRDyE4zc2U0hRXs0o0T7Pq2QVTZ/Cd6TT2YMFME1BxxF6u5S
         3unsc+FDp/vbUzuESiYGkHLvURtFCga4iz3XgBY8I2wkodtJOS7oT56rFHtfPFUci63d
         6Pxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JzvU3hptPAwa4hkUBvtSs4yLQLzV+1FO0XItHguv9so=;
        b=nxs9lunGDxFJgaO47xMxOG9kP1Wilhot8bwtI5ABwTu54biZw/S1cxk4VOtZOLalK3
         XbFILG36X+D6NEdgjcVWkQl02VBhNPLS2/NsgIRjuS4yByrKO+KtBvg8z2M3cDdfbWbh
         WgNOvblUYBbCPziP4RKcNddDnr9trgLVL/qCyVaWUMjqvXu6Eezk6c8CK9KNhRIFxdDq
         MZOUXT0BsdMa41yX1uU9IB9rGlpunlc1WDhoOow5hbsYUiArbhX/hTMj5DbshwE8LJuj
         6tKxlV100RnAWIIUtnLueA8u+luokcVBvnFrX/OwulHHVYON/+5Yl5KwM2kZ1yTgi/jG
         8/cA==
X-Gm-Message-State: AO0yUKUktyY9cLtbOrjQELPecLT/d3zmCsIqv3OGDAGgmgj8PLXTprOk
        GgRqlyyK2xuD0phf8XU68Mw1ApqwULiLUMXMJaTxCw==
X-Google-Smtp-Source: AK7set9Vsv9mWxHzzIoczFJ/w9GH67ltUCqqwdURW63RDSH8ejtIiXFO5vh9MuhwG2HE8wtbjlim9S+wkVTcKKVUf54=
X-Received: by 2002:a25:d106:0:b0:7e3:5539:9cb5 with SMTP id
 i6-20020a25d106000000b007e355399cb5mr99751ybg.188.1675205416015; Tue, 31 Jan
 2023 14:50:16 -0800 (PST)
MIME-Version: 1.0
References: <CAAFAkD8kahd0Ao6BVjwx+F+a0nUK0BzTNFocnpaeQrN7E8VRdQ@mail.gmail.com>
 <63d747d91add9_3367c208f1@john.notmuch> <Y9eYNsklxkm8CkyP@nanopsycho>
 <87pmawxny5.fsf@toke.dk> <CAM0EoM=u-VSDZAifwTiOy8vXAGX7Hwg4rdea62-kNFGsHj7ObQ@mail.gmail.com>
 <878rhkx8bd.fsf@toke.dk> <CAAFAkD9Sh5jbp4qkzxuS+J3PGdtN-Kc2HdP8CDqweY36extSdA@mail.gmail.com>
 <87wn53wz77.fsf@toke.dk> <63d8325819298_3985f20824@john.notmuch>
 <87leljwwg7.fsf@toke.dk> <CAM0EoM=i_pTSRokDqDo_8JWjsDYwwzSgJw6sc+0c=Ss81SyJqg@mail.gmail.com>
 <CO1PR11MB4993CA55EDF590EF66FF3D4893D39@CO1PR11MB4993.namprd11.prod.outlook.com>
 <63d85b9191319_3d8642086a@john.notmuch> <CAM0EoMk8e4rR5tX5giC-ggu_h-y32hLN=ENZ=-A+XqjvnbCYpQ@mail.gmail.com>
 <20230130201224.435a4b5e@kernel.org> <CAM0EoMkR0+5YHwnrJ_TnW53MAfTC2Y9Wq0WFcEWTq3V=P0OzAg@mail.gmail.com>
 <CAM0EoMmPbdZD7ZNn2UWKQWnWTnAnnWhdSQtq05PvejAz0Jfx9w@mail.gmail.com>
 <20230131111020.2821ea17@kernel.org> <CAM0EoMnKk9=WFm7ZtPbHDRc6_J7Xw8WR3TG2_Em4ucJ6nCNJOw@mail.gmail.com>
 <20230131143623.738f232e@kernel.org>
In-Reply-To: <20230131143623.738f232e@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 31 Jan 2023 17:50:04 -0500
Message-ID: <CAM0EoMkqhODxc=_J41=UxEnf5jKGXnQT5TVc8TjOMzYRr2Myjw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 00/20] Introducing P4TC
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        "Singhai, Anjali" <anjali.singhai@intel.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jamal Hadi Salim <hadi@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Willem de Bruijn <willemb@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel@mojatatu.com" <kernel@mojatatu.com>,
        "Chatterjee, Deb" <deb.chatterjee@intel.com>,
        "Limaye, Namrata" <namrata.limaye@intel.com>,
        "khalidm@nvidia.com" <khalidm@nvidia.com>,
        "tom@sipanda.io" <tom@sipanda.io>,
        "pratyush@sipanda.io" <pratyush@sipanda.io>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "vladbu@nvidia.com" <vladbu@nvidia.com>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "stefanc@marvell.com" <stefanc@marvell.com>,
        "seong.kim@amd.com" <seong.kim@amd.com>,
        "mattyk@nvidia.com" <mattyk@nvidia.com>,
        "Daly, Dan" <dan.daly@intel.com>,
        "Fingerhut, John Andy" <john.andy.fingerhut@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 5:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 31 Jan 2023 17:32:52 -0500 Jamal Hadi Salim wrote:
> > > > Sorry didnt finish my thought here, wanted to say: The loading of the
> > > > P4 binary over devlink drew (to some people) suspicion it is going to
> > > > be used for loading kernel bypass.
> > >
> > > The only practical use case I heard was the IPU. Worrying about devlink
> > > programming being a bypass on an IPU is like rearranging chairs on the
> > > Titanic.
> >
> > BTW, I do believe FNICs are heading in that direction as well.
> > I didnt quiet follow the titanic chairs analogy, can you elaborate on
> > that statement?
>
> https://en.wiktionary.org/wiki/rearrange_the_deck_chairs_on_the_Titanic

LoL. Lets convince Jiri then.
On programming devlink for the runtime I would respectfully disagree
that it is the right interface.

cheers,
jamal
