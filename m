Return-Path: <netdev+bounces-2819-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 710CF704318
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 03:46:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E42161C20CA8
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 01:46:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 946EF1FC1;
	Tue, 16 May 2023 01:46:49 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C4171FB0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:46:49 +0000 (UTC)
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967FCE4A;
	Mon, 15 May 2023 18:46:47 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id 71dfb90a1353d-45046c21e55so3447321e0c.1;
        Mon, 15 May 2023 18:46:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684201606; x=1686793606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fcw/atW51mgbVwTH4USOTRlFF9OK4r1s1etFUmDFJ98=;
        b=VNkpiOUGMUigCL23X7MQWB88J2ylhb3KmIvpYDPvgLOoynrYCAMAqjDK8dgBOnwUHJ
         fghfIxxiynkJ9HI5K+/b4QUldMYjo4w4LHeHFl45ByFnBJCj+r8P3MRNvbHs4B3vTJod
         enuHr0plZAtOXa2A+2Nv1zoipTgxdlggpvvN15vB9ohGjIo243s6EIPtVOKS0T8yCjCY
         9kEmnq0z7GXN/rbOGOcYBGkVkCjYQdyrLG/Z8XOx36iFxkB/seJ4QlX5DAuW+T67xnig
         19d4uKWmSx44A7rwNL7lGYnn08MXT+uvbSbUXq6uJ48AJ7ct0MyUoWUM3+qCjDP7Zgyq
         QUzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684201606; x=1686793606;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fcw/atW51mgbVwTH4USOTRlFF9OK4r1s1etFUmDFJ98=;
        b=DbkrnL9GIe9aF76t89s17AAXU79Zce8GUbzDYtFcfShGp88cIyz3ntyY1Wswwcot6Q
         QT6kF7QqKQiL7iYVzUZ0BGTXNWIoBFpSMBzkuAnRH5wiBi+ojUWiT28aowx8EssbCXUD
         z7ApShhUQA5XvJZJSeA3aZP5Bq2lewrtZ/46uMcpJyQtcsC2cOq5spIbill8dwg7i2UP
         D/Q8Hv560vCCWoCU9DNhvBy8P75VOUo8FAInkBusgcsIlEIZ/LSq+RQ1Yq6zS/q6C+tp
         /xP1+ozReVKES4eYRZUxorJBljDr6xilwdsv9eRRP5fDne+mzVfOITazewIcYaNrVUbW
         lXBw==
X-Gm-Message-State: AC+VfDyJb3oRO8VK//gXdTQph9D1qMXBf2jm4UqZw3h3FZ/yS/YKtnEp
	G+ClKgdiH4lSdZbTJbGYV95ZX3WAMuxONWnGGStA2E4W7ZQ=
X-Google-Smtp-Source: ACHHUZ4iM+AF+aVGcHvCFIhQX4yXng4lz+U/av6CcLOSLXhgdFfK4DhSX38mCQV1nWshsLiAwJiF+W8TulqEjPUTiNA=
X-Received: by 2002:a1f:c112:0:b0:439:bd5c:630 with SMTP id
 r18-20020a1fc112000000b00439bd5c0630mr11969562vkf.6.1684201606376; Mon, 15
 May 2023 18:46:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230412-increase_ipvs_conn_tab_bits-v2-1-994c0df018e6@gmail.com> <56b88a99-db88-36e4-9ff1-a5d940578108@ssi.bg>
In-Reply-To: <56b88a99-db88-36e4-9ff1-a5d940578108@ssi.bg>
From: Abhijeet Rastogi <abhijeet.1989@gmail.com>
Date: Mon, 15 May 2023 18:46:09 -0700
Message-ID: <CACXxYfy+yoLLFr0W9HYuM78GjzJsQvbHnm43uRQbor_ncQdMgw@mail.gmail.com>
Subject: Re: [PATCH v2] ipvs: increase ip_vs_conn_tab_bits range for 64BIT
To: Julian Anastasov <ja@ssi.bg>
Cc: Simon Horman <horms@verge.net.au>, Pablo Neira Ayuso <pablo@netfilter.org>, netdev@vger.kernel.org, 
	lvs-devel@vger.kernel.org, netfilter-devel@vger.kernel.org, 
	coreteam@netfilter.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Julian Anastasov,

>Can you keep the previous line width of the above help
because on standard 80-width window the help now gets truncated in
make menuconfig.

Refer this screenshot: https://i.imgur.com/9LgttpC.png

Sorry for the confusion, I was already expecting this comment. The
patch had a few words added, hence it feels like many lines have
changed. However, no line actually exceeds 80 width.

Longest line is still 80-width max. Do you prefer I reduce it to a
lower number like 70?

Thanks,
Abhijeet


On Mon, May 15, 2023 at 8:18=E2=80=AFAM Julian Anastasov <ja@ssi.bg> wrote:
>
>
>         Hello,
>
> On Sun, 14 May 2023, Abhijeet Rastogi wrote:
>
> > Current range [8, 20] is set purely due to historical reasons
> > because at the time, ~1M (2^20) was considered sufficient.
> > With this change, 27 is the upper limit for 64-bit, 20 otherwise.
> >
> > Previous change regarding this limit is here.
> >
> > Link: https://lore.kernel.org/all/86eabeb9dd62aebf1e2533926fdd13fed48ba=
b1f.1631289960.git.aclaudi@redhat.com/T/#u
> >
> > Signed-off-by: Abhijeet Rastogi <abhijeet.1989@gmail.com>
> > ---
> > The conversation for this started at:
> >
> > https://www.spinics.net/lists/netfilter/msg60995.html
> >
> > The upper limit for algo is any bit size less than 32, so this
> > change will allow us to set bit size > 20. Today, it is common to have
> > RAM available to handle greater than 2^20 connections per-host.
> >
> > Distros like RHEL already allow setting limits higher than 20.
> > ---
> > Changes in v2:
> > - Lower the ranges, 27 for 64bit, 20 otherwise
> > - Link to v1: https://lore.kernel.org/r/20230412-increase_ipvs_conn_tab=
_bits-v1-1-60a4f9f4c8f2@gmail.com
> > ---
> >  net/netfilter/ipvs/Kconfig      | 26 +++++++++++++-------------
> >  net/netfilter/ipvs/ip_vs_conn.c |  4 ++--
> >  2 files changed, 15 insertions(+), 15 deletions(-)
> >
> > diff --git a/net/netfilter/ipvs/Kconfig b/net/netfilter/ipvs/Kconfig
> > index 271da8447b29..aac5d6bd82e6 100644
> > --- a/net/netfilter/ipvs/Kconfig
> > +++ b/net/netfilter/ipvs/Kconfig
> > @@ -44,7 +44,8 @@ config      IP_VS_DEBUG
> >
> >  config       IP_VS_TAB_BITS
> >       int "IPVS connection table size (the Nth power of 2)"
> > -     range 8 20
> > +     range 8 20 if !64BIT
> > +     range 8 27 if 64BIT
> >       default 12
> >       help
> >         The IPVS connection hash table uses the chaining scheme to hand=
le
> > @@ -52,18 +53,17 @@ config    IP_VS_TAB_BITS
> >         reduce conflicts when there are hundreds of thousands of connec=
tions
> >         in the hash table.
> >
> > -       Note the table size must be power of 2. The table size will be =
the
> > -       value of 2 to the your input number power. The number to choose=
 is
> > -       from 8 to 20, the default number is 12, which means the table s=
ize
> > -       is 4096. Don't input the number too small, otherwise you will l=
ose
> > -       performance on it. You can adapt the table size yourself, accor=
ding
> > -       to your virtual server application. It is good to set the table=
 size
> > -       not far less than the number of connections per second multiply=
ing
> > -       average lasting time of connection in the table.  For example, =
your
> > -       virtual server gets 200 connections per second, the connection =
lasts
> > -       for 200 seconds in average in the connection table, the table s=
ize
> > -       should be not far less than 200x200, it is good to set the tabl=
e
> > -       size 32768 (2**15).
> > +       Note the table size must be power of 2. The table size will be =
the value
> > +       of 2 to the your input number power. The number to choose is fr=
om 8 to 27
> > +       for 64BIT(20 otherwise), the default number is 12, which means =
the table
> > +       size is 4096. Don't input the number too small, otherwise you w=
ill lose
> > +       performance on it. You can adapt the table size yourself, accor=
ding to
> > +       your virtual server application. It is good to set the table si=
ze not far
> > +       less than the number of connections per second multiplying aver=
age lasting
> > +       time of connection in the table.  For example, your virtual ser=
ver gets
> > +       200 connections per second, the connection lasts for 200 second=
s in
> > +       average in the connection table, the table size should be not f=
ar less
> > +       than 200x200, it is good to set the table size 32768 (2**15).
>
>         Can you keep the previous line width of the above help
> because on standard 80-width window the help now gets truncated in
> make menuconfig.
>
>         After that I'll send a patch on top of yours to limit the
> rows depending on the memory.
>
> >         Another note that each connection occupies 128 bytes effectivel=
y and
> >         each hash entry uses 8 bytes, so you can estimate how much memo=
ry is
> > diff --git a/net/netfilter/ipvs/ip_vs_conn.c b/net/netfilter/ipvs/ip_vs=
_conn.c
> > index 13534e02346c..e1b9b52909a5 100644
> > --- a/net/netfilter/ipvs/ip_vs_conn.c
> > +++ b/net/netfilter/ipvs/ip_vs_conn.c
> > @@ -1484,8 +1484,8 @@ int __init ip_vs_conn_init(void)
> >       int idx;
> >
> >       /* Compute size and mask */
> > -     if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 20) {
> > -             pr_info("conn_tab_bits not in [8, 20]. Using default valu=
e\n");
> > +     if (ip_vs_conn_tab_bits < 8 || ip_vs_conn_tab_bits > 27) {
> > +             pr_info("conn_tab_bits not in [8, 27]. Using default valu=
e\n");
> >               ip_vs_conn_tab_bits =3D CONFIG_IP_VS_TAB_BITS;
> >       }
> >       ip_vs_conn_tab_size =3D 1 << ip_vs_conn_tab_bits;
> >
> > ---
>
> Regards
>
> --
> Julian Anastasov <ja@ssi.bg>
>


--
Cheers,
Abhijeet (https://abhi.host)

