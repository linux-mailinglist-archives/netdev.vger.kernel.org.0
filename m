Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA4C5A626D
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbiH3LuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiH3Ltx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:49:53 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72E3615C;
        Tue, 30 Aug 2022 04:49:51 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-3378303138bso266228387b3.9;
        Tue, 30 Aug 2022 04:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=5PLSJHa8w6OwGuD5lJARZZs+KKmBDPnoAl8FZnIJYzo=;
        b=bqGFQVKPcAzrHDMkGrkhp6+CBfKxiESZ9WWneeg5m32wxi6OBBtU3abXZhzyMkIONp
         zUS71pGnXMvRIITR6yBDe7FJoSnTURWua07+NK9NCWtENrQO65J7XOrc/X7fSv9gGKrp
         jEWTFgijC39dqzoKnnZ3PMqEyRFrhZn4KGkxznRNmSVhzb11LXnSbU4aPKTFUy7r589M
         /AuyINX77EwlDfqTVe14KwLRht/kQMdbrJ7ghDPbZxqU4Bg7xtaDhfldhywCSWs3pSAm
         8Oamf1Va0dY8+ZWP/JkkmSDjhyUOSVpRKz355cKkFB0tTDC4XPhVk5IWNoix2FDuyoVJ
         xrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=5PLSJHa8w6OwGuD5lJARZZs+KKmBDPnoAl8FZnIJYzo=;
        b=Bqv4Oq0m9w93H3UiOo8W22Tbavq6JkUrUjFv+BfCdZKy+L40f5jn1xSeB66BvrZO4B
         uzVnYBIRAy0WKswrYW2NH0bddRBdCZ0a63VtbydWSkni77QA5T3czzUVq7bv2yRBkkKy
         n29l8+EWuI5Hdzv//DYXeHgvdjdsDEMW5I96uWzTdiJepxVt+zcalOkKE1+C0hhRQrp8
         L+/1b1mWTgukHsgYn+HOEeSZS1DG2SwXzv2c0iFOvTwBDE1iIlLbPkcXy36WBOyDmh8q
         8g7E7Bp93Bn2QbdK6Lg7oeOR/gdWpb6vH8V86uU++ML9iW2mBr/XRWRmFaHNlpoUX7xg
         P/5Q==
X-Gm-Message-State: ACgBeo0Q6YWzwGlv3eijuNm4AymxkNj7zSLsQP0UN7gQiQIBMnC9YIgO
        AZcBbe0EH3tni0R0ckLYDfbcxEvfWHpKqR+OIccLUzDlVeg=
X-Google-Smtp-Source: AA6agR7LnDnGLIhZq0Fh8Z1cpViaRf1uPZO+5wWs+X6fb2yOi9zxs4QF/pope73o2EEVFT5lYhjdB9Bk71TXTiZ6tn8=
X-Received: by 2002:a81:7882:0:b0:339:802b:b4c0 with SMTP id
 t124-20020a817882000000b00339802bb4c0mr13825925ywc.488.1661860191125; Tue, 30
 Aug 2022 04:49:51 -0700 (PDT)
MIME-Version: 1.0
References: <Yw3X1cB1j+r8uj7W@debian> <09270720-bc55-29e5-2310-980cabb444f4@nvidia.com>
In-Reply-To: <09270720-bc55-29e5-2310-980cabb444f4@nvidia.com>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 30 Aug 2022 12:49:15 +0100
Message-ID: <CADVatmP7Du5WS4tJ=q4Ruvr+r-=mnWpUmvXCQu2r=Kjm5kh2bw@mail.gmail.com>
Subject: Re: build failure of next-20220830 due to 9c5d03d36251 ("genetlink:
 start to validate reserved header bytes")
To:     Gal Pressman <gal@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-wpan@vger.kernel.org,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 11:19 AM Gal Pressman <gal@nvidia.com> wrote:
>
> On 30/08/2022 12:26, Sudip Mukherjee (Codethink) wrote:
> > Hi All,
> >
> > The builds of arm pxa_defconfig have failed to build next-20220830 with
> > the error:
> >
> > net/ieee802154/nl802154.c:2503:26: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?
> >  2503 |         .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
> >       |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~
> >       |                          NL802154_CMD_SET_CCA_ED_LEVEL
> >
> > git bisect pointed to 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> >
> > I will be happy to test any patch or provide any extra log if needed.
> >
> >
>
> I posted a fix:
> https://lore.kernel.org/netdev/20220830101237.22782-1-gal@nvidia.com/

Thanks. Fixed the failure for me.


-- 
Regards
Sudip
