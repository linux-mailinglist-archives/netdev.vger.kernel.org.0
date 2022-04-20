Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E59A508DCD
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 18:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380791AbiDTQ4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 12:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234342AbiDTQ4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 12:56:31 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8FB3E5C4;
        Wed, 20 Apr 2022 09:53:43 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id lc2so4733866ejb.12;
        Wed, 20 Apr 2022 09:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rfm74VEUMWZeXlpuLUyC+UQS6WldzCAHTX0ZUV4DSls=;
        b=blpgcPwCTkxucUu2qZrWjwcq7sstE9xLRf5AbMMlxE8YZrJ0K0DNZxOq4mCHEiyIyZ
         XdoMlOsuUf/eyx3g2tt7V7BIGpKZARWCyw1YovPsqhkocExAa58e2kNc0dv0QBaUvZTa
         ObRRFqQ4FyNMmEiFGHCCqZyPP+x7gzFpMJbnyt2QOVwKfhkFb3cu+p9W2jcva0Vxo2JL
         lO9F9NUmdDYZfFpt3wm6+UBs1MD6omwNrsa9yUtpOxuAmZ8f7zy3kfQpG3afpx91hIaT
         XBh/sjnCyaTmpslP6liNlZldDuaPtD9AyVqE2rsH4dciA+m8PBxfVU+bGhG2acy4lRXn
         OzIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rfm74VEUMWZeXlpuLUyC+UQS6WldzCAHTX0ZUV4DSls=;
        b=Ga428sQXnIt8y9TLN9dmCYe7YR4MYziCIzq3hq6bdMmKcZjyn51xtepg9cix9q1RA8
         pkag3NnZqTrXRckXKQaAMxunTI6ms+d7r+DFWUXPYsFuoi7izJZpaDR5ftEtCEMKvCiX
         MWlGxUl0BholX0v6rqAxngtSDTAtbsCfYcGs8S1+4lm+WunImFlqgcZ42noHAHKGByPU
         y63dpo+dMTy5vkjtG5pEfJZSJoWtvrzTcaZCfaVBF1ZPHxU1KaYysuhW5jKs/FaIs6Et
         a18e+jT6b9HcTy9Pv4Y22CVLcFlyp/hVNjrp7owktUwWiOedrtEZPS5XKE6l/fR7n2C8
         e3yg==
X-Gm-Message-State: AOAM533pMuWmFHM8YB4K9t2ki8U9RAy6SevE0cKDGC0pvkmwPvcvu2Ef
        vET3Dw2uUYnREZoxJil+5dk=
X-Google-Smtp-Source: ABdhPJxQ3uQH39NmcFzDqchDbenZC7Dj2C9W1dhPLDuReZA2QBfhi5bpkVEuZLM9fty7klo1viKK2g==
X-Received: by 2002:a17:907:6d96:b0:6e8:d7d9:d573 with SMTP id sb22-20020a1709076d9600b006e8d7d9d573mr19276189ejc.90.1650473621788;
        Wed, 20 Apr 2022 09:53:41 -0700 (PDT)
Received: from leap.localnet (host-79-50-86-254.retail.telecomitalia.it. [79.50.86.254])
        by smtp.gmail.com with ESMTPSA id ee17-20020a056402291100b0041fe1e4e342sm10006539edb.27.2022.04.20.09.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 09:53:40 -0700 (PDT)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     Jaehee Park <jhpark1013@gmail.com>, Kalle Valo <kvalo@kernel.org>
Cc:     =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        outreachy@lists.linux.dev, Stefano Brivio <sbrivio@redhat.com>
Subject: Re: [PATCH] wfx: use container_of() to get vif
Date:   Wed, 20 Apr 2022 18:53:39 +0200
Message-ID: <2258432.bcXerOTE6V@leap>
In-Reply-To: <87y200nf0a.fsf@kernel.org>
References: <20220418035110.GA937332@jaehee-ThinkPad-X1-Extreme> <87y200nf0a.fsf@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On mercoled=C3=AC 20 aprile 2022 13:57:57 CEST Kalle Valo wrote:
> Jaehee Park <jhpark1013@gmail.com> writes:
>=20
> > Currently, upon virtual interface creation, wfx_add_interface() stores
> > a reference to the corresponding struct ieee80211_vif in private data,
> > for later usage. This is not needed when using the container_of
> > construct. This construct already has all the info it needs to retrieve
> > the reference to the corresponding struct from the offset that is
> > already available, inherent in container_of(), between its type and
> > member inputs (struct ieee80211_vif and drv_priv, respectively).
> > Remove vif (which was previously storing the reference to the struct
> > ieee80211_vif) from the struct wfx_vif, define a function
> > wvif_to_vif(wvif) for container_of(), and replace all wvif->vif with
> > the newly defined container_of construct.
> >
> > Signed-off-by: Jaehee Park <jhpark1013@gmail.com>
>=20
> [...]
>=20
> > +static inline struct ieee80211_vif *wvif_to_vif(struct wfx_vif *wvif)
> > +{
> > +	return container_of((void *)wvif, struct ieee80211_vif,=20
drv_priv);
> > +}
>=20
> Why the void pointer cast? Avoid casts as much possible.

In a previous email Jaehee wrote that she could compile her changes only by=
=20
using that "(void *)" cast.

I replied that probably this is a hint that something is broken, although=20
my argument is not necessarily a "proof". Might very well be that this cast=
=20
was needed in this particular situation but I cannot see why.

@Jaehee, please try to explain why this "(void *)" cast is actually=20
necessary and why your changes cannot avoid it.

Thanks,

=46abio M. De Francesco



