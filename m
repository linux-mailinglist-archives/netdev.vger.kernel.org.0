Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400941FB2EC
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 15:56:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgFPNz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 09:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728869AbgFPNzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jun 2020 09:55:46 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D8DC061755
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 06:55:45 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id q11so20897486wrp.3
        for <netdev@vger.kernel.org>; Tue, 16 Jun 2020 06:55:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HswXvwCk8Oqat+UrWACbhD1zb+LAki7BWt8l9dOzHic=;
        b=s2INJfPJBk4nY1hKcSrylqnPFf3Ap2wrNDzLjwIR2VPnOpY0G9SbTH4vR2Hk0J/MoP
         TOHmKp+mHTAX2RhTDpXAg2rOPh1mCTLpL44Wwm5/58FkoGpgMKi2bdYUSPAmtYYQGqn6
         4TILObqDGG6H+G673wFyS4vPLu+6kYLVZTxzfUcZgPtrxskrnJF3vQFVHs7wlWL4aG71
         GO8bOAIqz0TK6xtCB0K1nBKaDIzDPnyx/Cw/eaHzLXzh/RvQoq7BVx+5KdSyuAqi0TY4
         2pwWWGyHaPbpzsBzZKaprAJebrLVv1BnNvSJy73eQ2G4et61u2XB3EbcrqimhQ7XwfOW
         Oi/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HswXvwCk8Oqat+UrWACbhD1zb+LAki7BWt8l9dOzHic=;
        b=cEsqtRFq5vmcECnGwMFP5BLhgNfW0hD7BVV1XcCMHeefgOz+GyGwKq9obn7erK+JyS
         wNNMTjvuUNEyBEGhxRs+mvZdAJuHF3ceyspUmJRNYiqSIMLel3uSSYiWhg/ZpaKnVgOj
         V63QXuzH8FCX1OVOjGRAeaV4RdmlIRRCnV6SyJAVYWxrPtxntPpfwExBefmFc8HbKW7Z
         IEtPWfD8lDJ0NRGcZAVj7u8sfQMvb66s8YPzrVrXyiBpqclsdECKK5oEpVuqLtcqzCad
         c4uI+Q6flK4MpsV7IUXzan1MWY6U5CPhtHe8mTKMLdPWvhwtplWNLxAtXQIc8a8xnxeU
         pc+g==
X-Gm-Message-State: AOAM532J/F/qN1ZRORXOylJ+pMlBlsa4sxd4aDHb5niSrSxnNH5YvGmo
        Ze4pLck9VHOMALmwIA/SXopPONXxzAxP79WZfLoCb6dqf7Y=
X-Google-Smtp-Source: ABdhPJyXiG12Yb2kRZdYqAOob8+aZlbFEqsDZGzQsWqyJqo0FlYO9p2bNUUkqT7Lx8ncK/HXulMBI9x6JJGDNbytNXQ=
X-Received: by 2002:a5d:6b83:: with SMTP id n3mr3189014wrx.395.1592315744337;
 Tue, 16 Jun 2020 06:55:44 -0700 (PDT)
MIME-Version: 1.0
References: <8f83e18b1bed3a19b32b6632c563d86a88e6fa25.1592209510.git.lucien.xin@gmail.com>
 <b1656226-4caf-466e-8175-48431752286d@strongswan.org>
In-Reply-To: <b1656226-4caf-466e-8175-48431752286d@strongswan.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 16 Jun 2020 22:04:14 +0800
Message-ID: <CADvbK_ciXNO+iMHY7FGOAQiERbkmFncgo4AXPkbaA5Ek8apPyQ@mail.gmail.com>
Subject: Re: [PATCH ipsec] xfrm: policy: match with both mark and mask on user interfaces
To:     Tobias Brunner <tobias@strongswan.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <hadi@cyberus.ca>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 15, 2020 at 5:56 PM Tobias Brunner <tobias@strongswan.org> wrote:
>
> Hi Xin,
>
> > To fix this duplicated policies issue, and also fix the issue in
> > commit ed17b8d377ea ("xfrm: fix a warning in xfrm_policy_insert_list"),
> > when doing add/del/get/update on user interfaces, this patch is to change
> > to look up a policy with both mark and mask by doing:
> >
> >   mark.v == pol->mark.v && mark.m == pol->mark.m
>
> Looks good, thanks a lot for your work on this.  All tests in our
> regression test suite complete successfully with this patch applied.
>
> Tested-by: Tobias Brunner <tobias@strongswan.org>
>
> > and leave the check:
> >
> >   ((mark.v & mark.m) & pol->mark.m) == pol->mark.v.
> >
> > for tx/rx path only.
>
> If you are referring to the check in xfrm_policy_match() it's actually:
>
>   (fl->flowi_mark & pol->mark.m) != pol->mark.v
>
> Or more generically something like:
>
>   (mark & pol->mark.m) == pol->mark.v
>
> As we only have the mark on the packets/flow (no mask) to match against.
>
> > -static bool xfrm_policy_mark_match(struct xfrm_policy *policy,
> > +static bool xfrm_policy_mark_match(const struct xfrm_mark *mark,
> >                                  struct xfrm_policy *pol)
> >  {
> > -     if (policy->mark.v == pol->mark.v &&
> > -         policy->priority == pol->priority)
> > -             return true;
> > -
> > -     return false;
> > +     return mark->v == pol->mark.v && mark->m == pol->mark.m;
> >  }
>
> I guess you could make that function `static inline`.
>
Thanks, Tobias, I will post v2 with your suggestion.

Just note that I have another patch similar to this one,
but for xfrm_state's mark. I will post it later too.
Please also check if it may cause any regression.
