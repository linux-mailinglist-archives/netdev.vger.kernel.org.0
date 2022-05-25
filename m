Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D30EB53412B
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 18:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244687AbiEYQOf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 12:14:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbiEYQOd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 12:14:33 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBFBFB82D4;
        Wed, 25 May 2022 09:14:32 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2ff155c239bso220436857b3.2;
        Wed, 25 May 2022 09:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=0OFqrXuImZJ1QHruFjMQp8w4cuEiDQ7xQP/GMHCAhJY=;
        b=NZb2TVTyLSrz0MvL0fBXLy5oGjFQG/H9d1h+txMTknr0acBycmk9fjM3n+zjLLUxJV
         tj3NOfd8aCQiF7nidb17ItiYNS+9rZjqTWJBwvzEplThHfpAXfl57RO5Ixf7f8HxFlNS
         yrMG/QdmpSjyRBrDTHSkjNLCMNWxO9SpeZFiteyHI8yL8T7u/D0k7yYcEtslgmMqkBRX
         WXmf1QI73G0fTxU3rjAjuP3MOmlMhS5sEfKPBgbyMJKPPQQAIyv/VDGFEsHkNn+dtYQX
         V/minu4VsCviH5Erjrr6Br3g3PToUEilx9oiNyqFtCKUoJgmfX/JAAvAon2sTzMcpPKn
         zZbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=0OFqrXuImZJ1QHruFjMQp8w4cuEiDQ7xQP/GMHCAhJY=;
        b=AZQbt/u+cyLdatgTcRcbMgxtvKgDBgAnKmZo15h30nQ7vENttpwcr889E3f7MuCRX0
         eJcmblO611ECMj1xNmvOtbaNkE4/luJ5WtrJiXDiJvf+kHfXyxPs7SUmfBuPUrmHdyh5
         cqgEK4j2axD/uu1EKibwTr/Bc+3ZEhxdezMcRKp2zrUiAYN/8DbbyER87+Hn43SAdUPd
         CwbcDG9duZLNBIN/hFIujI0qLIqvfL7StvZTZZS5PTUrzUijxV0ApPPbvmaQdcJZpIip
         XatNcfyQGm3GpldVQrAL39RMQf0Neg1DtS+djVGg6bsS7Yfr1HipEaQGtDJdPPo8mzO2
         hGow==
X-Gm-Message-State: AOAM531NIJ9n97S+el9Ct7Vystg+xh0iq8oI92H9CBM3zXBrPSKmbe3g
        eEXPe4Wc/Fh1j3wNqgSmtoKRddTUJOGnuN84PIvVDMEzh4sVXA==
X-Google-Smtp-Source: ABdhPJxpctBdlgAa+953y+3qR+MS6shcBLBYjnqEh+3tGxXq2fN556+22WZoG10mGy8P8jNYfhB4FFdmcqSlNa3zb3g=
X-Received: by 2002:a81:fcb:0:b0:2f7:d547:7188 with SMTP id
 194-20020a810fcb000000b002f7d5477188mr34569820ywp.202.1653495272006; Wed, 25
 May 2022 09:14:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220521075736.1225397-1-zenczykowski@gmail.com>
 <CAADnVQJcDvyeQ3y=uVDj-7JfqtxE+nJk+d5oVQrBhhQpicYk6A@mail.gmail.com>
 <CANP3RGcn6ta7uZH7onuRwOzx_2UmizEtgOTMKvbMOL8FER0MXQ@mail.gmail.com> <CAADnVQKWxzwAbZFAfOB2hxwOVP1mCfwpx30rcdRkCO-4DMxsZw@mail.gmail.com>
In-Reply-To: <CAADnVQKWxzwAbZFAfOB2hxwOVP1mCfwpx30rcdRkCO-4DMxsZw@mail.gmail.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Wed, 25 May 2022 09:14:20 -0700
Message-ID: <CAHo-Oow9u0QGwGuB4u4Uusv_2N70HbWZT6-cM_av8pqwychT9g@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: print a little more info about maps via cat /sys/fs/bpf/pinned_name
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Mon, May 23, 2022 at 1:21 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, May 23, 2022 at 1:14 PM Maciej =C5=BBenczykowski
> <zenczykowski@gmail.com> wrote:
> >
> > On Mon, May 23, 2022 at 12:32 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Sat, May 21, 2022 at 12:57 AM Maciej =C5=BBenczykowski
> > > <zenczykowski@gmail.com> wrote:
> > > >
> > > > From: Maciej =C5=BBenczykowski <maze@google.com>
> > > >
> > > > While this information can be fetched via bpftool,
> > > > the cli tool itself isn't always available on more limited systems.
> > > >
> > > > From the information printed particularly the 'id' is useful since
> > > > when combined with /proc/pid/fd/X and /proc/pid/fdinfo/X it allows
> > > > tracking down which bpf maps a process has open (which can be
> > > > useful for tracking down fd leaks).
> > > >
> > > > Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
> > > > ---
> > > >  kernel/bpf/inode.c | 3 +++
> > > >  1 file changed, 3 insertions(+)
> > > >
> > > > diff --git a/kernel/bpf/inode.c b/kernel/bpf/inode.c
> > > > index 4f841e16779e..784266e258fe 100644
> > > > --- a/kernel/bpf/inode.c
> > > > +++ b/kernel/bpf/inode.c
> > > > @@ -257,6 +257,9 @@ static int map_seq_show(struct seq_file *m, voi=
d *v)
> > > >         if (unlikely(v =3D=3D SEQ_START_TOKEN)) {
> > > >                 seq_puts(m, "# WARNING!! The output is for debug pu=
rpose only\n");
> > > >                 seq_puts(m, "# WARNING!! The output format will cha=
nge\n");
> > > > +               seq_printf(m, "# type: %d, key_size: %d, value_size=
: %d, max_entries: %d, id: %d\n",
> > > > +                          map->map_type, map->key_size, map->value=
_size, map->max_entries,
> > > > +                          map->id);
> > >
> > > Maybe use cat /sys/fs/bpf/maps.debug instead?
> > > It prints map id.
> >
> > Is this something that was very recently added?
> > I'm not seeing it on my 5.16 machine with bpffs mounted at /sys/fs/bpf.
>
> It was there since 2020.
> Make sure you have CONFIG_BPF_PRELOAD.

Hmm.  This seems very annoying to use in practice.

* it seems to default to disabled, and as such is disabled on:
- my Debian laptop and desktop (well google's corp Linux distro, but
it should be close enough to Debian here)
- my latest Fedora 36 Desktop and VMs
- our production (server) kernels
- all current Android Common Kernel / Generic Kernel Image / Pixel kernel t=
rees
- Android UML test image kernel build scripts
* enabling it on our server kernels results in a compilation failure
(probably some missing backports, they're backported up the wazoo)
* enabling it on ACK 5.10 tree results in a very different build failure
* enabling it on ACK 5.15 successfully builds, but doesn't seem to work:

# uname -r
5.15.41-04342-g39bba8f6b9fe

# zcat /proc/config.gz  | egrep BPF_PRELOAD
CONFIG_BPF_PRELOAD=3Dy
CONFIG_BPF_PRELOAD_UMD=3Dy

# cat /proc/mounts | egrep sys
none /sys sysfs rw,relatime 0 0
none /sys/fs/bpf bpf rw,relatime 0 0

# cd /sys/fs/bpf
root@uml-x86-64:/sys/fs/bpf# ls -al
total 0
drwxrwxrwt 2 root root 0 May 25 15:13 .
drwxr-xr-x 6 root root 0 May 25 15:13 ..

Perhaps a limitation of UML, or something funky in the build process,
or the files don't show up until maps/progs are pinned?
Hard to say - this is after running our bpf (python) test suite
(though it might not use pinned maps/programs)...

* finally.. I think it increases kernel size by a lot since I see:
120K ./kernel/bpf/preload/bpf_preload_kern.o
and in a different tree:
232K ./kernel/bpf/preload/bpf_preload.ko

I did get it to work by building a net next tree with the option
manually enabled and installing it on some dev servers.
Those by default have some pinned progs/maps, and I do see the debug files.

When it works it's really nice... but I don't think I'm willing to pay
the complexity/memory costs.
