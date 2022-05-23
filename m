Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFBDD531A83
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:55:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232940AbiEWUVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 16:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233192AbiEWUVf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 16:21:35 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CABDB396AD;
        Mon, 23 May 2022 13:21:30 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id q21so10988157ejm.1;
        Mon, 23 May 2022 13:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Xpk4VozFypQwdAnoMWUHqSuM53R/LuJLDwWIhAlawxE=;
        b=m2xI4B4TDbd3qO+Wxg3OqG7NnKMYmxRwujSKy1x+MSz+9wzdKoXA8SgWoc8ZieI+sr
         3jbLR2GUuYofU0yChlCji63iswyzvDIFblqtUYVeTkY3fUqQUL8oiZSk739cIZawJ8A2
         dUwWX86nOdGLVIfIoKRypa88tpZJTCbgtnABTJTo9bVe1bAlTv4n335Fi3r7R7cDTgUY
         OWN5rBuGouNCXWBs7GYbIWX/b1STdNMysNsq1mVd/iW5ynE8LLqpnYqoCkuC3V2wZDCB
         1DflRufe9BX3vTdFqlGMRETpVfcTlEIwqwOHABIGI+FEtvdiPipShbmq8nXpKhMiToli
         cDQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Xpk4VozFypQwdAnoMWUHqSuM53R/LuJLDwWIhAlawxE=;
        b=AvYyG9FPYS54bPhXPdH7kQ6byXTt2M8BHPuj1kcbaVcMliLsm164kDQkah5rW606/8
         CfiJWES+6bg46MlxISRuAsNNObUZ8CGWn4kLZpwp5/DjUoYmMVbRRC6vY89n7xHCmZ9C
         2PD/MuLShO3OYFe0MgyaTdDUuEhZ33ZMzKsaXm980aWZ8HQZe0YzxSOyhqCfdX4f/XIH
         UdKPEo08Z8VRgW4NzkafJ29Yv15kP1Sxr0x/iNhD0bEFdupbbmsxWTJi6dXwhWVGJ2gb
         kAmTy482DiJbi0cu23WFhK4lv4hU7NEsZra1y3ekdvByt8yPk0xJunkfqVPaxdLirhqe
         D65w==
X-Gm-Message-State: AOAM532joyMndLB1MAV5yjSsdO6AF1E2GngXbXth7KxMHWoWOH4o8ndg
        qR4YW6dmFptpK7lAA1g72gajUW8Us2XCe/wRMNo=
X-Google-Smtp-Source: ABdhPJxPqfHj7ELFQEQnA2wVSY7wnuTdvdH7lr+Ez4lHPs3ZZmBaxYczEI02fODeSQ+UMAjfkY89mZmqVBOSDJqRwhI=
X-Received: by 2002:a17:907:c26:b0:6fe:bd5e:2bb6 with SMTP id
 ga38-20020a1709070c2600b006febd5e2bb6mr11039638ejc.708.1653337288834; Mon, 23
 May 2022 13:21:28 -0700 (PDT)
MIME-Version: 1.0
References: <20220521075736.1225397-1-zenczykowski@gmail.com>
 <CAADnVQJcDvyeQ3y=uVDj-7JfqtxE+nJk+d5oVQrBhhQpicYk6A@mail.gmail.com> <CANP3RGcn6ta7uZH7onuRwOzx_2UmizEtgOTMKvbMOL8FER0MXQ@mail.gmail.com>
In-Reply-To: <CANP3RGcn6ta7uZH7onuRwOzx_2UmizEtgOTMKvbMOL8FER0MXQ@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 23 May 2022 13:21:16 -0700
Message-ID: <CAADnVQKWxzwAbZFAfOB2hxwOVP1mCfwpx30rcdRkCO-4DMxsZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: print a little more info about maps via cat /sys/fs/bpf/pinned_name
To:     =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 1:14 PM Maciej =C5=BBenczykowski
<zenczykowski@gmail.com> wrote:
>
> On Mon, May 23, 2022 at 12:32 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Sat, May 21, 2022 at 12:57 AM Maciej =C5=BBenczykowski
> > <zenczykowski@gmail.com> wrote:
> > >
> > > From: Maciej =C5=BBenczykowski <maze@google.com>
> > >
> > > While this information can be fetched via bpftool,
> > > the cli tool itself isn't always available on more limited systems.
> > >
> > > From the information printed particularly the 'id' is useful since
> > > when combined with /proc/pid/fd/X and /proc/pid/fdinfo/X it allows
> > > tracking down which bpf maps a process has open (which can be
> > > useful for tracking down fd leaks).
> > >
> > > Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> > > ---
> > >  kernel/bpf/inode.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> > > index 4f841e16779e..784266e258fe 100644
> > > --- a/kernel/bpf/inode.c
> > > +++ b/kernel/bpf/inode.c
> > > @@ -257,6 +257,9 @@ static int map_seq_show(struct seq_file *m, void =
*v)
> > >         if (unlikely(v =3D=3D SEQ_START_TOKEN)) {
> > >                 seq_puts(m, "# WARNING!! The output is for debug purp=
ose only\n");
> > >                 seq_puts(m, "# WARNING!! The output format will chang=
e\n");
> > > +               seq_printf(m, "# type: %d, key_size: %d, value_size: =
%d, max_entries: %d, id: %d\n",
> > > +                          map->map_type, map->key_size, map->value_s=
ize, map->max_entries,
> > > +                          map->id);
> >
> > Maybe use cat /sys/fs/bpf/maps.debug instead?
> > It prints map id.
>
> Is this something that was very recently added?
> I'm not seeing it on my 5.16 machine with bpffs mounted at /sys/fs/bpf.

It was there since 2020.
Make sure you have CONFIG_BPF_PRELOAD.
