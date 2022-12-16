Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1239764F347
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 22:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiLPVj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 16:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiLPVjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 16:39:53 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3145715F2E;
        Fri, 16 Dec 2022 13:39:52 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id b81so1765066vkf.1;
        Fri, 16 Dec 2022 13:39:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2YwHluyp3ck6gPBrjl88W1jVft6fBZI+9SdreHduMN0=;
        b=GtGWVbz0c2WgE+RG3BiXxLNwl9nZXPjfa5FYmWxDRsdWg+qdUGF4gup7cMciZSOm65
         aQ0Fo9m4WEc/aWx8COWkmnw+hrNrUqBSLUf4IWlXXFCygc0qbQBD3rskaE5tIM7PrDwn
         dIYB47y7W1XWuQFb/NxXqh+ykWVDDwFzdORYwvZtW5ISa2Eco/BDqZJbSjZzrtYFn/DK
         IQXYo1I+M5WWzTW0ss475sY8S88Z5zs0befRTApEk5YweiHoXAk3PzVPfYV8D+Jxbf9t
         +rb09waY6JHBp2tVRcZTQG6C9sHTMKmH6KG7RormYh77I65UJP++1NBWjhkpSSRD/67g
         O6OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2YwHluyp3ck6gPBrjl88W1jVft6fBZI+9SdreHduMN0=;
        b=yXzBIBkwdPRc+Q9knnMwoeCAEWEVs+Zo1IWpoTqqsSZbwSkzukX5Q0wu2dcFrs/TMl
         SKHrx8xtG64tiNDpsjP4X5jQiGQSm9LJ3GEj33CrJRdOp63RJr/LJvUAV4N0DlQTqtoh
         NesUq0u53Jm8g/1+D2TvcjaPXcYCQyLTkk8hyHRJCKor1qwlj+bowJLOahBq19smyd6W
         zi8HdU3Zdf96Zt0aImLwb7hgPuJ7FLri7E2/g01ZoBGpMZkuG0IqUSEWuwQ/uNfnniuq
         cww/je5C9M3xjLGm8OVBEzYh7noVeJ2vBoSgUJluhpm95iz7p5uitABVaQV2WBHNn41h
         8tTg==
X-Gm-Message-State: ANoB5pmcAbT8rJ0Ei4rQgEuYNmkd18pl+hNKFP1rTUbHepYvcEuiGoC8
        knRHzfO/4/D8egc8nf+RcW3nLIW8H+dfUKcKjRLHUGIs28WooQ==
X-Google-Smtp-Source: AA0mqf48eDYlvrjk/0EJkS9A6SI+FR+Sf30IMBeLcCft/jWeVbWdmcXlU6ZLBtCoPY497SmK9xYxo2/sPrrmcAsjyV4=
X-Received: by 2002:a1f:9b03:0:b0:3c1:780:3bfe with SMTP id
 d3-20020a1f9b03000000b003c107803bfemr2597787vke.26.1671226791221; Fri, 16 Dec
 2022 13:39:51 -0800 (PST)
MIME-Version: 1.0
References: <20221216211124.154459-1-tegongkang@gmail.com> <941d8fa9-9c7b-8e06-e87a-b1c9ed80a639@ieee.org>
In-Reply-To: <941d8fa9-9c7b-8e06-e87a-b1c9ed80a639@ieee.org>
From:   Kang Minchul <tegongkang@gmail.com>
Date:   Sat, 17 Dec 2022 06:39:42 +0900
Message-ID: <CA+uqrQCChwyE--PDxvrGMnfk9W1Nf0C4kS9fW0Ozmx-mQpyH8w@mail.gmail.com>
Subject: Re: [PATCH net-next v3] net: ipa: Remove redundant comparison with zero
To:     Alex Elder <elder@ieee.org>
Cc:     Alex Elder <elder@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2022=EB=85=84 12=EC=9B=94 17=EC=9D=BC (=ED=86=A0) =EC=98=A4=EC=A0=84 6:34, =
Alex Elder <elder@ieee.org>=EB=8B=98=EC=9D=B4 =EC=9E=91=EC=84=B1:
>
> On 12/16/22 3:11 PM, Kang Minchul wrote:
> > platform_get_irq_byname() returns non-zero IRQ number on success,
> > and negative error number on failure.
> >
> > So comparing return value with zero is unnecessary.
> >
> > Signed-off-by: Kang Minchul <tegongkang@gmail.com>
> > ---
> >   drivers/net/ipa/gsi.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
> > index bea2da1c4c51..e05e94bd9ba0 100644
> > --- a/drivers/net/ipa/gsi.c
> > +++ b/drivers/net/ipa/gsi.c
> > @@ -1302,7 +1302,7 @@ static int gsi_irq_init(struct gsi *gsi, struct p=
latform_device *pdev)
> >       int ret;
> >
> >       ret =3D platform_get_irq_byname(pdev, "gsi");
> > -     if (ret <=3D 0)
> > +     if (ret < 0)
> >               return ret ? : -EINVAL;
>
> In doing this, you assume platform_get_irq_byname() never
> returns 0.  I accept that assumption now.  But in that case,
> ret will *always* be non-zero if the branch is taken, so the
> next line should simply be:
>
>                 return ret;
>
> There are two other places in the IPA driver that follow exactly
> the same pattern of getting the IRQ number and handling the
> possibility that the value returned is (erroneously) 0.  If
> you're making this change in one place, please do so in all
> of them.
>
> Frankly though, I think this change adds little value, and I
> would be content to just leave everything as-is...
>
>                                         -Alex
>
> >
> >       gsi->irq =3D ret;
>

Hmm, yes.
I think you're right.
I don't think this code is worth much either.
Please ignore this patch and leave everything as-is.

Thanks for your feedback though :)

Kang Minchul
