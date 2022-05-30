Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA0D053763D
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 10:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbiE3IJn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 04:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230296AbiE3IJm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 04:09:42 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D603975212
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 01:09:41 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y8so10577287iof.10
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 01:09:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=H1k6YyHYB8zGydJ1b/kZ7lKw/xGrSzBdbtn1ycq9nic=;
        b=TYGpTAcimxGhGbdUVye2FO/8Qel/kTK5VaOI5yUl/gJ4WOXSqNCi1/y/IID0wGp+KT
         wuyznvHpoxhQlA5DZIcz/ElLpqhrBdItulPIw89m65aD/xqsDdXL6RiqGYTCuax9VwGT
         1uKX0++fiY5KAmhtBGRPUwFKaMK0e0ddDntoenV04AeOp7NA0FAEJzE1x769l5or5TT7
         WA+aRjj01NoS2UjM7nWx7vUoHShnOjEyKXFOlk3U5f5fWIotOVhlYBHKlaUqwcewMjpS
         FI7Q+nxM6pi980Yl52lCfhCen/2iRt78Eb57YU2UJlcXqgMPdgNywguV7B7bAP3mqzk5
         U6wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=H1k6YyHYB8zGydJ1b/kZ7lKw/xGrSzBdbtn1ycq9nic=;
        b=RrZap4JJqwPr6Tw5ISVhAl42hBLubgPcrs5t/RHjBvWLKvrEKoOJlGV3+lIPBkw+fT
         1BXOtA4+FBO1+UKdB6aVoI8s1ud8v4vAlNIOK2L/4Qlv0yid6Y6tOyeTGUmZepBU+M5z
         ehNLAtP3lLWDaWIPuFXYBPtZpkva8so119jYHQ23LctU8HuctYfSd22A9S8LuoH5PS55
         iunbW91sM8Da1IWgrP6mFmO1ZWqbNFZ6y2BK3lG7+S7ondGW2tqqEyO3DQEBlQAPxm55
         D26eSsa1RBdU4nGGiercnP5WRNQBTT0bTuAegGN3t50L3SE4gHQa5zl9+HHoODZTDzwJ
         fWEQ==
X-Gm-Message-State: AOAM53028X1mMpJ7Ldn//uM+xicvtOYdMYrmD1O6RrtYcD0l+Xt1BKaZ
        mqdI3W6rFWKMcukQe47QTtA1AC/p8l0YDAzfmtpXIg==
X-Google-Smtp-Source: ABdhPJwDynuz/ssxd1uNc+6/GukgF14eUKx3S6uc5UdpQsUIsv/Dn3CWe9zqm/K9BN6KXPCsz8qYpp3uVJHqGaVW7f4=
X-Received: by 2002:a05:6638:2648:b0:330:be8e:9cc with SMTP id
 n8-20020a056638264800b00330be8e09ccmr11037648jat.85.1653898181054; Mon, 30
 May 2022 01:09:41 -0700 (PDT)
MIME-Version: 1.0
References: <CANP3RGcW6DWei2bXrAQn8B4Uf0ggx_MgEfVyX_D7AaYZcYOchQ@mail.gmail.com>
 <20220530070256.GA2517843@gauss3.secunet.de>
In-Reply-To: <20220530070256.GA2517843@gauss3.secunet.de>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Mon, 30 May 2022 01:09:28 -0700
Message-ID: <CANP3RGfbz-gwY9FZtwygvuOFB5p39zRgNsUkvP7HfrWOVNZGOA@mail.gmail.com>
Subject: Re: 5.18 breaks Android net test PFKEY AddSA test case
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Benedict Wong <benedictwong@google.com>,
        Yan Yan <evitayan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 30, 2022 at 12:03 AM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
> On Sat, May 28, 2022 at 01:54:25AM -0700, Maciej =C5=BBenczykowski wrote:
> > I've not gotten to the bottom of the root cause, since I'm hoping
> > someone will know off the top of their head,
> > why this might now be broken...
> I guess that is because of
>
> commit 4dc2a5a8f6754492180741facf2a8787f2c415d7
> net: af_key: add check for pfkey_broadcast in function pfkey_process
>
> This is already reverted in the ipsec tree and will go upstream
> this week.

Yes, reverting that does indeed appear to fix things.
Thanks!
