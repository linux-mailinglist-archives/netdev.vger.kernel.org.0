Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3096F48CE8B
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:53:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234621AbiALWxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234580AbiALWxo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:53:44 -0500
Received: from mail-ua1-x92f.google.com (mail-ua1-x92f.google.com [IPv6:2607:f8b0:4864:20::92f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94BCC06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:53:43 -0800 (PST)
Received: by mail-ua1-x92f.google.com with SMTP id r15so7812573uao.3
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BcQfi/Qaw/T7F3yZ34+Th1wg4+z1Bm9VT37+cgN7j0U=;
        b=GWs9U740fWXOM5JiLRbovnAzD8cmkMNrhPEfLpGNzsfWlbF6Zg3uA2N4YwSKD4OHEw
         dBTTJKhKziZAJJ6t2Wl+chIGkZP8G7aYsoFM5NbgNLVQJEjY2ALvEGCLFWMpVgNTedWc
         Rb4r3mGnulkVk7qRNLBqL2gB/b3q5sXpr54v8VF+XcKIMcw05/Rid7vBZjKfUedIIRoJ
         +W9N+byIEfnb3Fom9+eMzdwGaRZ1wkuO0s4N6bT3yQANoR7rgMC3OElIUii0loYHqGkL
         +EmN3lvn/kc2dqOO1XmynQByw6KXir8Ly2n6W6mzUIofVpJ0iH609k1dKC1dJtK5IWLZ
         k10g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BcQfi/Qaw/T7F3yZ34+Th1wg4+z1Bm9VT37+cgN7j0U=;
        b=RP0+lu/8QMM8WK0eSDzY3qPGMoHnVohKeEfY+VshhuHDXDH4fWEPBge8ipg9UZrGoR
         ru4J9mui9SYXMOxCdV+1BVXSqgh63gy9gerf0/cLYLGxUBiXy289RPKl9eToOoAoLKX0
         /B/O/jUJQ6h3CRWfTIPLmahiGMdzHtULYLNdjCHsVtASB5dz+4WKhYf4acnbB48NbO1E
         fjenB43+orNkU9ifq+Q82tlxgTd6C5JpSi5d9AdjQTF9G/mgUujcfowb7fGeTpviad0d
         +jsPYNQTPJduEK5u108vdATb/EPKzZIW3g75JVKdsAU+OQTP6C/dc+5PjRfseOzTeHPz
         rqHg==
X-Gm-Message-State: AOAM533ckQ08aYYe6M+puw8AWMRQZwPgqqaubkESEfjjR9IARDoxEt/9
        x7ah68+xB9saoKLYKXwDfPv33KFbQp2asJewsdu/mQ==
X-Google-Smtp-Source: ABdhPJyuZFFY37x1IAcnBcHsgwA1KMBLyZ69Gzhdffgk1ULLpJrMAQZ2SUQVAgjmftT71NC6L84nGT9ivuh1DyLO6oY=
X-Received: by 2002:ab0:7201:: with SMTP id u1mr1227981uao.4.1642028022325;
 Wed, 12 Jan 2022 14:53:42 -0800 (PST)
MIME-Version: 1.0
References: <20220108013230.56294-1-evitayan@google.com> <20220112073242.GA1223722@gauss3.secunet.de>
In-Reply-To: <20220112073242.GA1223722@gauss3.secunet.de>
From:   Yan Yan <evitayan@google.com>
Date:   Wed, 12 Jan 2022 14:53:31 -0800
Message-ID: <CADHa2dAaG4Pgxk7gmDbBnVSYJ_eBtJY3KaR94fY=wp+Pmt0EoA@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] xfrm: Check if_id in xfrm_migrate
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     netdev@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Nathan Harold <nharold@google.com>,
        Benedict Wong <benedictwong@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steffen,

The Jan 7th patch fixes the following warning (reported by the kernel
test robot) by adding parentheses.
   net/xfrm/xfrm_policy.c: In function 'xfrm_migrate':
>> net/xfrm/xfrm_policy.c:4403:21: warning: suggest parentheses around assignment used as truth value [-Wparentheses]
    4403 |                 if (x = xfrm_migrate_state_find(mp, net, if_id)) {
         |                     ^

In the Jan 7th patch, this line becomes "if ((x =
xfrm_migrate_state_find(mp, net, if_id))) {"


On Tue, Jan 11, 2022 at 11:32 PM Steffen Klassert
<steffen.klassert@secunet.com> wrote:
>
> On Fri, Jan 07, 2022 at 05:32:30PM -0800, Yan Yan wrote:
> > This patch enables distinguishing SAs and SPs based on if_id during
> > the xfrm_migrate flow. This ensures support for xfrm interfaces
> > throughout the SA/SP lifecycle.
> >
> > When there are multiple existing SPs with the same direction,
> > the same xfrm_selector and different endpoint addresses,
> > xfrm_migrate might fail with ENODATA.
> >
> > Specifically, the code path for performing xfrm_migrate is:
> >   Stage 1: find policy to migrate with
> >     xfrm_migrate_policy_find(sel, dir, type, net)
> >   Stage 2: find and update state(s) with
> >     xfrm_migrate_state_find(mp, net)
> >   Stage 3: update endpoint address(es) of template(s) with
> >     xfrm_policy_migrate(pol, m, num_migrate)
> >
> > Currently "Stage 1" always returns the first xfrm_policy that
> > matches, and "Stage 3" looks for the xfrm_tmpl that matches the
> > old endpoint address. Thus if there are multiple xfrm_policy
> > with same selector, direction, type and net, "Stage 1" might
> > rertun a wrong xfrm_policy and "Stage 3" will fail with ENODATA
> > because it cannot find a xfrm_tmpl with the matching endpoint
> > address.
> >
> > The fix is to allow userspace to pass an if_id and add if_id
> > to the matching rule in Stage 1 and Stage 2 since if_id is a
> > unique ID for xfrm_policy and xfrm_state. For compatibility,
> > if_id will only be checked if the attribute is set.
> >
> > Tested with additions to Android's kernel unit test suite:
> > https://android-review.googlesource.com/c/kernel/tests/+/1668886
> >
> > Signed-off-by: Yan Yan <evitayan@google.com>
>
> What is the difference between this patch and the one with
> the same subject you sent on Jan 5th?



-- 
--
Best,
Yan
