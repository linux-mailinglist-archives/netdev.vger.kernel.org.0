Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB6A7115013
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 12:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbfLFLzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 06:55:47 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:54600 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726157AbfLFLzq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Dec 2019 06:55:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1575633345;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qvrWOY/mDsm5ZPXnW8CWyEAMsFxUXzDOi446+ej6uuM=;
        b=NQTFjElwsC9W231Sbgkv0GeHNUQCZfRGQfsO09CnRaI7dSj7edj40zZzX6SOqFfXS+OBLg
        xz+OqK/eXvUYPfoj2768h8BdQ0HI2MykdaEO+8qPYnYlF6YVyVzx8WasceriRBc4BdArYu
        YK4oN+U/T8mQpiP1PytplHm9pjmCeIk=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-MljJs31qMtmTM3eP2lfBew-1; Fri, 06 Dec 2019 06:55:38 -0500
Received: by mail-il1-f199.google.com with SMTP id j17so5032693ilc.10
        for <netdev@vger.kernel.org>; Fri, 06 Dec 2019 03:55:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=D46zLJiJlJlaw4yoI/L3PmfI3JwX15Yspc8I4PkHuIw=;
        b=FdKNyqImAgw7WdLAaZbJTQm+xaB3FrSiW4dkJqvlMUQtpYrGO8Ef7WGj7FxX7iqdLw
         gLio9H/IUc0alm8l9y8Q7go9Yaph0d9B2chTUv55Wa2JcDvESQzE9XClEyeRWByseHrb
         1ORiKSh4Lx2ZjGnSpdZbMQHsg9juzC7VUH7iNoyruv0UYrqe/u1RAmmvaAOR1wUGVsCa
         trxj7pUhzxXAmUATiCSdu1Whli/pB+jZMaxBF529J3ZndJmZarsNIjNFzkq3cBnn63BI
         fQ2cOoLSWDJQNhHWSDUI3sE8lRnNOTZUrN5g/QimD9aTlWAchDdhc6VKy9mFJmdNIcnU
         /9Vg==
X-Gm-Message-State: APjAAAWgkHv13Ai1icSpN7IJxtpV3NVEMeh2bxPTRFKOPQuWYdsUnaXB
        9PJ7y94HLi/JyGfGNn/skVrLzNPC26waXXqCtaLnLS/WHouNUvGkpGbzAMXxBhT1dqXtORd4TkC
        xiSZd7PQUrI6/CjtSKz/bNgcY+opJjqKz
X-Received: by 2002:a02:52c9:: with SMTP id d192mr6691386jab.29.1575633337899;
        Fri, 06 Dec 2019 03:55:37 -0800 (PST)
X-Google-Smtp-Source: APXvYqw2QAMSovwKjPY/zWPk3L1ZL82Bz2vxr6sZFcv7qpW0i1XeV5jr09hv96PMV24NVSF+LXLBw9NJXe2lRPtpyMQ=
X-Received: by 2002:a02:52c9:: with SMTP id d192mr6691373jab.29.1575633337667;
 Fri, 06 Dec 2019 03:55:37 -0800 (PST)
MIME-Version: 1.0
References: <20191206033902.19638-1-xiyou.wangcong@gmail.com> <20191206104212.GE27144@netronome.com>
In-Reply-To: <20191206104212.GE27144@netronome.com>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Fri, 6 Dec 2019 13:55:25 +0200
Message-ID: <CAJ0CqmWjh1bAOwx25tVE_yDbzCbf9dCXsFE7ZV_1N7Tt-DF64A@mail.gmail.com>
Subject: Re: [Patch net] gre: refetch erspan header from skb->data after pskb_may_pull()
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>
X-MC-Unique: MljJs31qMtmTM3eP2lfBew-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>
> Hi Cong,
>
> On Thu, Dec 05, 2019 at 07:39:02PM -0800, Cong Wang wrote:
> > After pskb_may_pull() we should always refetch the header
> > pointers from the skb->data in case it got reallocated.
> >
> > In gre_parse_header(), the erspan header is still fetched
> > from the 'options' pointer which is fetched before
> > pskb_may_pull().
> >
> > Found this during code review of a KMSAN bug report.
> >
> > Fixes: cb73ee40b1b3 ("net: ip_gre: use erspan key field for tunnel look=
up")
> > Cc: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> > ---
> >  net/ipv4/gre_demux.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/net/ipv4/gre_demux.c b/net/ipv4/gre_demux.c
> > index 44bfeecac33e..5fd6e8ed02b5 100644
> > --- a/net/ipv4/gre_demux.c
> > +++ b/net/ipv4/gre_demux.c
> > @@ -127,7 +127,7 @@ int gre_parse_header(struct sk_buff *skb, struct tn=
l_ptk_info *tpi,
> >               if (!pskb_may_pull(skb, nhs + hdr_len + sizeof(*ershdr)))
> >                       return -EINVAL;
> >
> > -             ershdr =3D (struct erspan_base_hdr *)options;
> > +             ershdr =3D (struct erspan_base_hdr *)(skb->data + nhs + h=
dr_len);
>
> It seems to me that in the case of WCCPv2 hdr_len will be 4 bytes longer
> than where options would be advanced to. Is that a problem here?
>

Hi Simon,

I guess the two conditions are mutually exclusive since tpi->proto is
initialized with greh->protocol. Am I missing something?

Regards,
Lorenzo

> >               tpi->key =3D cpu_to_be32(get_session_id(ershdr));
> >       }
> >
> > --
> > 2.21.0
> >
>

