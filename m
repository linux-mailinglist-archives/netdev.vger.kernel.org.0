Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51DF6E10EF
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 17:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbjDMPUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 11:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjDMPUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 11:20:13 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D889755
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:20:06 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id h198so22267155ybg.12
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 08:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1681399206; x=1683991206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KspaEPrDplSYvcKzIX5D8e6YFnwmmvrPbcdh5kQyGqQ=;
        b=dICJEbVyuhb0Z2H7pfk0rr3ktiBM0JmM+nCT95+leyFN0Trb0AS+/rBkALKrXarWtl
         dxgJaSy8Arj80zkVXrNb2n4f20TxFUtj3Am8PniZLkBF12JRzrzd0zt7R1v1Y/qmHxW6
         tW21HdraiUwLupjsKdmyCM15XBXeovSmiRPt1RWDhkh4JyFC84AXUJSw7ZL/bBsZXvOV
         YwXPW4nA4LANzq4z1NoSX/kqru2tj0uauZt0bAeIdUwaRQ/gqMR3Q4wj1cMzRLZIV8zV
         x++LFJ/yC+vx+iJRwF/A+jRnRs3CN3rkbqZg2mHTbXIHwwYHC+/MUffuJcExHPJJWw9h
         HeSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681399206; x=1683991206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KspaEPrDplSYvcKzIX5D8e6YFnwmmvrPbcdh5kQyGqQ=;
        b=TsjXQr/qyCCUNIMYezHvkp0T/Yh1oiZJPUy5Ekp/zixwFASaBwRBYR4o2elW936j4K
         JjPYJn33nNxJm74bsLw9Kb4uLRFXIxt15b/B5azp3KXvSkOgImVEuU4CKJz9WLa803sz
         yLM1PUtFOxlEZyAJ+7VhvvoJIVrRylXaizhgUqt/LKpOb1C6CQw1QtKJROaA/p2Jw3CO
         QTg3wJY5APtd79BxwPChoUGWyzz+idjkrwAP6c87BJmuq8zH5TpBkz5SrGFYRp3npMX6
         NSMdrkJQW614d0CEZ9pvVx38pbp07xoVsZZcuvCNbskzjFCKbUUYKLuGaXwTNz9jTnX5
         FF9Q==
X-Gm-Message-State: AAQBX9cfRljuUn0OiauTPkPo9ypVeHFTrpdtWhpN+obFno81aEy+2OyL
        adqaeOyUc0JVXM+/9TN17Q6CoWd5eN4y7UG9PQht
X-Google-Smtp-Source: AKy350bJPUvWcLZaaM0kHY/y3MXoFhJfvIHrtDKoCad0pksGkPPZzxEGyK/GfpgQZ7Mj6t5iYE1p77a5Wr3zfNz/la4=
X-Received: by 2002:a25:d2ce:0:b0:b8b:f1ac:9c6c with SMTP id
 j197-20020a25d2ce000000b00b8bf1ac9c6cmr1687953ybg.3.1681399204370; Thu, 13
 Apr 2023 08:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
 <ZCS5oxM/m9LuidL/@x130> <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
 <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info> <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
 <20230410054605.GL182481@unreal> <20230413075421.044d7046@kernel.org>
In-Reply-To: <20230413075421.044d7046@kernel.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 13 Apr 2023 11:19:53 -0400
Message-ID: <CAHC9VhRKBLHfGHvFAsmcBQQEmbOxZ=M9TE4-pV70E+Y6G=uXWA@mail.gmail.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Linux regressions mailing list <regressions@lists.linux.dev>,
        Saeed Mahameed <saeed@kernel.org>,
        Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 10:54=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
> On Mon, 10 Apr 2023 08:46:05 +0300 Leon Romanovsky wrote:
> > > I haven't seen any updates from the mlx5 driver folks, although I may
> > > not have been CC'd?
> >
> > We are extremely slow these days due to combination of holidays
> > (Easter, Passover, Ramadan, spring break e.t.c).
>
> Let's get this fixed ASAP, please. I understand that there are
> holidays, but it's been over 2 weeks, and addressing regressions
> should be highest priority for any maintainer! :(
>
> From what I gather all we need here is to throw in an extra condition
> for "FW is hella old" into mlx5_core_is_management_pf(), no?

That's my gut feeling too, at least for a quick solution.  I'd offer
to cobble together a fix, but my kernel expertise ends well before I
get to the mlx5 driver :)

I have been running for a while now with that small patch reverted on
my test machines (so I can keep my tests running) and everything seems
to be okay, but there may be other issues caused by the revert that
I'm not seeing.

--=20
paul-moore.com
