Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14530101A5A
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKSHeD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:34:03 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39389 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfKSHeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:34:03 -0500
Received: by mail-ed1-f65.google.com with SMTP id l25so16201888edt.6
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 23:34:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qApaQo+lQhR7vlym3b3DBFIvQdTgF4044lCRX+Gfqgo=;
        b=YCB3jsOyMgwsxEjc0W4geAmZsl/HqMjX1xFb3JQclYOSSB+oIS3Y40TKVQnTMbTW1t
         soedH8K7ajZYRvBFjkboeGdnFnKFQyev1O06AOHez/MAfyt3mTKoEjU1SfEo6Uti9uNT
         V/7jZbrPaDXwkgCC7Mru50aYkCnQdZt9gLMy82/b2l8iBZoptUrgGKCTAbp1GyYA3Bm1
         5HAVa5xwkg0f1l7xRCuSdTgUGz5ILreUW+Ir9/EXbJtKe8i9LPOkoH+WZ49fdwa/qg/7
         qbREdkfv8oq3JbVRIOmMj2/0jt40ydRQ667SeLkxsbZ91Qn3QPGjdiYbTI74zpTVg5Pi
         NjZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qApaQo+lQhR7vlym3b3DBFIvQdTgF4044lCRX+Gfqgo=;
        b=jvRiy4rDdBorm5ebgBlE6sRgJjDGrgpOpb1U/wCtUoiHZS+w/xMreUb2gsSRISOky4
         V8FS3neKf/jSg/Xb0630+HY2N6/eYhoGASXz+/ihTqJDwfp/N6IJIn9RzjLCE7FIT//O
         PIyY2nZ43H330cqJepO1mLq9COXfrLms7ME2eN52gfvPYbbg/5kSEcgXFKmaFsu7HMXv
         wG/U16qjR5BjKuPdFgsqOAL7lOCqj6r6GELwk7hr8zb3AzDUXGpx9inraEZ61g993ipx
         445vT0SWEyoLVO3QPMm35k7v9wmbAP7n6kAnCV5TOuoN1jfFsFdA9i+KVycuCIkTyE5h
         nIEQ==
X-Gm-Message-State: APjAAAW3kYl4PYb5Vvfzr1HjXArbZqY9Coe3D42fJ4uwBegmtTaHRiro
        IVOxWMz81oCZPxA/hgOKJkWG64H6RyIK5E1wDaktjiRR
X-Google-Smtp-Source: APXvYqz//tfO+5hHVkZHUhwQxN6jglvWT1NkgzvStYtUTpoaPkcMv/8gE1x1eG6BxkSU5dYEyWWDGZSj9eq5Z4BnOu0=
X-Received: by 2002:adf:efcb:: with SMTP id i11mr14174875wrp.229.1574148841385;
 Mon, 18 Nov 2019 23:34:01 -0800 (PST)
MIME-Version: 1.0
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
 <1574007266-17123-4-git-send-email-sunil.kovvuri@gmail.com> <20191117.103332.318543543712297736.davem@davemloft.net>
In-Reply-To: <20191117.103332.318543543712297736.davem@davemloft.net>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Tue, 19 Nov 2019 13:03:50 +0530
Message-ID: <CA+sq2Cd0uKo9P7d-Wos_oPQBshKkQ0Cyk1_C0sjKqNaMeBrOKA@mail.gmail.com>
Subject: Re: [PATCH 03/15] octeontx2-af: Cleanup CGX config permission checks
To:     David Miller <davem@davemloft.net>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 18, 2019 at 12:03 AM David Miller <davem@davemloft.net> wrote:
>
> From: sunil.kovvuri@gmail.com
> Date: Sun, 17 Nov 2019 21:44:14 +0530
>
> > From: Sunil Goutham <sgoutham@marvell.com>
> >
> > Most of the CGX register config is restricted to mapped RVU PFs,
> > this patch cleans up these permission checks spread across
> > the rvu_cgx.c file by moving the checks to a common fn().
> >
> > Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
> > ---
> >  .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 55 ++++++++++------------
> >  1 file changed, 24 insertions(+), 31 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> > index 0bbb2eb..5790a76 100644
> > --- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> > +++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
> > @@ -350,6 +350,18 @@ int rvu_cgx_exit(struct rvu *rvu)
> >       return 0;
> >  }
> >
> > +/* Most of the CGX configuration is restricted to the mapped PF only,
> > + * VF's of mapped PF and other PFs are not allowed. This fn() checks
> > + * whether a PFFUNC is permitted to do the config or not.
> > + */
> > +inline bool is_cgx_config_permitted(struct rvu *rvu, u16 pcifunc)
> > +{
> > +     if ((pcifunc & RVU_PFVF_FUNC_MASK) ||
> > +         !is_pf_cgxmapped(rvu, rvu_get_pf(pcifunc)))
> > +             return false;
> > +     return true;
> > +}
>
> Do not use inline in foo.c files, let the compiler decide.

Sorry for the trouble.. i did check and removed 'inline' from
different patches of this patchset.
Somehow missed this, will fix and resubmit,

Thanks,
Sunil.
