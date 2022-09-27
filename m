Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0118B5ECC23
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 20:26:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231846AbiI0S0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 14:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231721AbiI0S01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 14:26:27 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365B2DF044;
        Tue, 27 Sep 2022 11:26:26 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id s14so16365991wro.0;
        Tue, 27 Sep 2022 11:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=T9mgYmd86XdemvaSKD7SCs2XkzuFJtwfsDjs/pRyThA=;
        b=nOj8AnDIe75AfAO4VchkMKmg5BAMDXNZw2EAsnB4/oF/oZuVIolHIoTC9bOv+rAJuu
         wHgeMu1Axd94nSUv1sxjX7rrZrtJgiXEyJNrISP5gonPVzxoKZVddanaE/ha+vqv93is
         /e+WXlShdXf6RT3MCgK93k6HCTZVvYFombEGaFRVto1PQ7I1fY2Y56d7AUNO1hWX9m97
         lAtIIhVtj15g43IbhUtJtJs5zvOzStnNgsO3fYZpY/xS0DBo13qziLVd5dii6W6praGx
         TSLg/Rij3llzh/yT7s72Et3AqVb1YTi+HRWiuvgkjY9BppBM/kQJhiEy2NWcE0iJhz6v
         3qXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=T9mgYmd86XdemvaSKD7SCs2XkzuFJtwfsDjs/pRyThA=;
        b=6HnCK6uT7grqmbvGhq1ADyeENseOWJD6wzI3dKKTsVUMHG8kgR7ROOc/TR8Cos1d2f
         GPCItIa8vC3m/b9e9a19gz38WRRu2ILEjD9gx3OT6142iqQZaA1IdywM6TG4FiWMbZ6X
         5yf4qw62tz3O6qcpOxlI2ADSfPCvWgH3JIF7eumdv1YZXOUWZuBNSJnGIJq76EZuXCUH
         lxXs/ERFdVUY1OQVhnMWebB2geIIJq0CrBG+Px5Jbw0R0tNHpn9pAXWSO6rjLtlHlSi1
         mioRezppcuwonXcPkK1RDYvSvlG0yjF94m3rBGAemHDbCBRvai6KBzU8MO7oqyolyLxl
         nR/w==
X-Gm-Message-State: ACrzQf2YhQsuhN1TtnDD3xmu0yFqWiB8eZ20np7m+jt0AW0aOD9wikkg
        e+EMC1GEuoidHBxsbLqj3wzt2bUY85+7fqQB1yY=
X-Google-Smtp-Source: AMsMyM5DQ8LC2iHP1lq0rf/iklDDElVZoP0loHSEvuVqHRJ8lQjJY6VeRrufLJhs7LICdnseKa1ZDHSLbq9pVF9N34I=
X-Received: by 2002:a05:6000:1565:b0:22c:8da7:3cf8 with SMTP id
 5-20020a056000156500b0022c8da73cf8mr12472975wrz.688.1664303184639; Tue, 27
 Sep 2022 11:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220927132753.750069-1-kuba@kernel.org> <CANn89iL4m=aMjZ1XWFNWDyyyDBF1uhNocN0OFqhm2VMm_JQOog@mail.gmail.com>
In-Reply-To: <CANn89iL4m=aMjZ1XWFNWDyyyDBF1uhNocN0OFqhm2VMm_JQOog@mail.gmail.com>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Tue, 27 Sep 2022 11:26:12 -0700
Message-ID: <CAA93jw7oY+m3c83b0qgoJjxG=rL6ErnrF2_+UZ9hiQ85H9ZSdg@mail.gmail.com>
Subject: Re: [PATCH net-next] net: drop the weight argument from netif_napi_add
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Kalle Valo <kvalo@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
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

On Tue, Sep 27, 2022 at 11:21 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Tue, Sep 27, 2022 at 6:28 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > We tell driver developers to always pass NAPI_POLL_WEIGHT
> > as the weight to netif_napi_add(). This may be confusing
> > to newcomers, drop the weight argument, those who really
> > need to tweak the weight can use netif_napi_add_weight().
> >
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>
> Sure, but this kind of patch makes backports harder.
> Not sure how confused are newcomers about this NAPI_POLL_WEIGHT....

Ironically we've been fiddling with dramatically reducing the
NAPI_POLL_WEIGHT (8) on
several multicore arm systems, with good results, especially on ath10k.


--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
