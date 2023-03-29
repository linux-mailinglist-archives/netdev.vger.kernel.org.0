Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2078A6CCE7B
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 02:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjC2AHP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 20:07:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjC2AHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 20:07:15 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E844D2111
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 17:07:13 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id s8so9185567pfk.5
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 17:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680048432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iGGacsNROXFqbCSpM1UhzcQ5jzqIVBCAlM6ogL7NNh4=;
        b=VTIfFadxfKzYc5ZvYAL3hr/jRZaDhvhWlZ6SIL0y9Fgm/Z2ZtuoI2idXK1NbzJs1FR
         ZcVU5m+AJqmShNj8sjDCsudLbqcUS6wrNIkEUeOzlrYZou9lupXHt7yZ7vW1pDsvChEZ
         bjkDtyoLgnzyuYolvPa+N1pvLy5abt+KYbu1aCwfS7iZ7LhcnYUJG4G0+c0Z6+tBW+Gi
         uCQRDFibgLkd4BD33IKTFh+NC4Xfvi+TpTKNwtaxNaLKLLA4K7bp2QNmkHdtBu0npOC/
         TCJocRcJrU8kb4+q7bvH18i7sMoKzr82iEy3QUL1ynVxshH/QO7IXjjB5By7ngJS8k85
         3J8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680048432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iGGacsNROXFqbCSpM1UhzcQ5jzqIVBCAlM6ogL7NNh4=;
        b=OZ0keZLBqQwB0rUPXHztHiIbAPzue6J89K2dcXKXHt7zZFCMv+hIeVX7+ciwhK+6Ty
         d7umMgtqvHp9LE88W3NGgWOeVlVZa3FTqpOWTCXqxIGCLrCNkRfJWo5/f4v8/zQfzHnv
         K2bM7rglB7ntnZA+aKSS1Q1XiV58lbSowv3vqXkWcZbHuGgWGLiCSS+IrvI/l6feQLGg
         eTFIaYNiaB3R4Q9lo81uACqRgv+i4HnSkmKDwyvIBJcNM26rNTW6cKQ363kxhD4ZEWua
         WoZctGOuz9kUheMaMwK/VdD1xC4FVk4Fn4flSadG/S7DCHSo2yRbY4RJZg8460AOlL+6
         UNug==
X-Gm-Message-State: AAQBX9eNxasVx++YQ/KrG3Oxw4HhIuzlYUiz0/+59yk6JjLKJEkwHQwO
        5dY83wt0YpmZI5PapW45Dqrgbn3NEjKSM5wzgt2ZXQ==
X-Google-Smtp-Source: AKy350bUMu0iHTUv33wap0R444e3mFWYFCGIT+lU1w7044wJ5ftPQ/VoWuUdw1e8M9FJ+bei5q5l7MVlxGztL94Mtbw=
X-Received: by 2002:a63:d201:0:b0:503:7be2:19a7 with SMTP id
 a1-20020a63d201000000b005037be219a7mr4656730pgg.1.1680048432551; Tue, 28 Mar
 2023 17:07:12 -0700 (PDT)
MIME-Version: 1.0
References: <20230324225656.3999785-1-sdf@google.com> <20230324225656.3999785-2-sdf@google.com>
 <20230324203340.712824b8@kernel.org>
In-Reply-To: <20230324203340.712824b8@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Tue, 28 Mar 2023 17:07:01 -0700
Message-ID: <CAKH8qBvPKdRPZpTiihZKhLixcbSyp-UPAOM+0_TuFHOUruSFSQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/4] tools: ynl: support byte-order in cli
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 24, 2023 at 8:33=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 24 Mar 2023 15:56:53 -0700 Stanislav Fomichev wrote:
> > @@ -250,7 +258,7 @@ genl_family_name_to_id =3D None
> >                                  if entry_attr.type =3D=3D Netlink.CTRL=
_ATTR_MCAST_GRP_NAME:
> >                                      mcast_name =3D entry_attr.as_strz(=
)
> >                                  elif entry_attr.type =3D=3D Netlink.CT=
RL_ATTR_MCAST_GRP_ID:
> > -                                    mcast_id =3D entry_attr.as_u32()
> > +                                    mcast_id =3D entry_attr.as_u32(Non=
e)
>
> I wonder if it's worth using a default value for the argument:
>
>         def as_u32(self, byte_order=3DNone):
>
> the number of Nones is very similar to number of meaningful args.
> And only spec-based decoding needs the arg so new cases beyond
> the 4 x2 are unlikely.
>
> > -                decoded =3D attr.as_u64()
> > +                decoded =3D attr.as_u64(attr_spec.get('byte-order'))
>
> Could you add a field in class SpecAttr, like is_multi and read
> a field instead of the get? I'm trying to avoid raw YAML access
> outside of nlspec.py classes as much as possible.

Sure, will do this and the above suggestions!
