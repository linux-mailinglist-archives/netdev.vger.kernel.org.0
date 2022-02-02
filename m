Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56B9E4A783E
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 19:50:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346766AbiBBStz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 13:49:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346631AbiBBStz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 13:49:55 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53FF3C061714;
        Wed,  2 Feb 2022 10:49:55 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id y8so66086qtn.8;
        Wed, 02 Feb 2022 10:49:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VTOPnaRquWicISMRZD83cjOQfdkXCxYB8Ac7cHDsTWs=;
        b=HOGlJ2+27xL5/WqxZJdwbp7tuNHB36A0n0ah5gbe2JaqwLe6kVXWNbHx47yMO+j51x
         fPTa6ZTGRy8Dzk9PLpGA5X3sDbNQXspYP6nSzZqzzwtDSnZcwM9QXQQz3Ai6SwHowsdH
         mzplefphGpL2xJGlKs6rUevuGCVHhqLiEIfyuk4LQJ4kOPRAAuatau+gN4AYIK0kZ0l0
         HcpT2KMNmVvC+E39EiBvqtDTtq8xzKS74fTjw8B9MfN6+za7P4s8Vli16oJlQ628izLi
         juEG/Ot8g6dvQRKzO+8DCSD4CEgMJZuWhCvqIOF7AIojYxpI7IRHl8J6+iaCvWi7+H5a
         eJ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VTOPnaRquWicISMRZD83cjOQfdkXCxYB8Ac7cHDsTWs=;
        b=s484Ftw6yHX9+ngYzS64rijkPmaCzTMTAeykvzCdHG7BMTbD2Ib711powpRg92SqEP
         REUTWVKruAR8cTQ8RVNMlbR9M2JF6OHGWEsWGX+3iDqpV6u+qQD0bcoylMRirZqQCd7i
         vgicVUNW5UxLb2mxh7ltrgRquaCswMxbRt4SIwNLNBuqidr6wKxaOigbskx6AnGH3RkQ
         YTl2Pn0a75YuV2YsJRnWxrwSn4TcIFhWYA9cWlh8sDDY+ODVTMDjzypSIV4agvMX1WHO
         SMo/KcXN8N3IGKxLZoDNLP0AD1Hlf132KVJKflS467QEmd2HUXR+aZID29cLOSMlATl7
         EJIw==
X-Gm-Message-State: AOAM5323VMxWksBNVfkGtZN2eGFSieQDwX8pXxOn9Aaw3nNSwSmiyOMF
        CCqqam16y5pczZsv2VbBKsFatsow6GC3AeilXQ8=
X-Google-Smtp-Source: ABdhPJyNh4rrva9Cl9WwnJRevXEYp1kCMhFJpdL0zn7uL+gxD+3diJFsD4DsVeW3oAB+6T9DgGwsQ/BKN7HxE8V81WU=
X-Received: by 2002:ac8:5c49:: with SMTP id j9mr18334765qtj.297.1643827794431;
 Wed, 02 Feb 2022 10:49:54 -0800 (PST)
MIME-Version: 1.0
References: <20211009221711.2315352-1-robimarko@gmail.com> <163890036783.24891.8718291787865192280.kvalo@kernel.org>
 <CAOX2RU5mqUfPRDsQNSpVPdiz6sE_68KN5Ae+2bC_t1cQzdzgTA@mail.gmail.com>
 <09a27912-9ea4-fe75-df72-41ba0fa5fd4e@gmail.com> <CAOX2RU6qaZ7NkeRe1bukgH6OxXOPvJS=z9PRp=UYAxMfzwD2oQ@mail.gmail.com>
 <EC2778B3-B957-4F3F-B299-CC18805F8381@slashdirt.org>
In-Reply-To: <EC2778B3-B957-4F3F-B299-CC18805F8381@slashdirt.org>
From:   Robert Marko <robimarko@gmail.com>
Date:   Wed, 2 Feb 2022 19:49:43 +0100
Message-ID: <CAOX2RU7FOdSuo2Jgo0i=8e-4bJwq7ahvQxLzQv_zNCz2HCTBwA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: support bus and device specific API 1 BDF selection
To:     Thibaut <hacks@slashdirt.org>
Cc:     Christian Lamparter <chunkeey@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kalle,

What is your opinion on this?
I would really love to see this get merged as we are having more and
more devices that are impacted without it.

Regards,
Robert

On Fri, 17 Dec 2021 at 13:25, Thibaut <hacks@slashdirt.org> wrote:
>
>
>
> > Le 17 d=C3=A9c. 2021 =C3=A0 13:06, Robert Marko <robimarko@gmail.com> a=
 =C3=A9crit :
> >
> > On Wed, 8 Dec 2021 at 15:07, Christian Lamparter <chunkeey@gmail.com> w=
rote:
> >>
> >> Isn't the only user of this the non-upstreamable rb_hardconfig
> >> mikrotik platform driver?
>
> The driver could be upstreamed if desirable.
> Yet I think it=E2=80=99s quite orthogonal to having the possibility to dy=
namically load a different BDF via API 1 for each available radio, which be=
fore this patch couldn=E2=80=99t be done and is necessary for this particul=
ar hardware.
>
> >> So, in your case the devices in question
> >> needs to setup a detour through the userspace firmware (helper+scripts=
)
> >> to pull on the sysfs of that mikrotik platform driver? Wouldn't it
> >> be possible to do this more directly?
> >
> > Yes, its the sole current user as its the only vendor shipping the BDF
> > as part of the
> > factory data and not like a userspace blob.
> >
> > I don't see how can it be more direct, its the same setup as when
> > getting pre-cal
> > data for most devices currently.
>
> Indeed, not sure how it could be more direct than it already is. I=E2=80=
=99m open to suggestions though.
>
> > I am adding Thibaut who is the author of the platform driver.
>
> Best,
> Thibaut
