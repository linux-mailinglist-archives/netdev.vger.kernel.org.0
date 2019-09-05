Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4544CAA7B3
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 17:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389017AbfIEPvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 11:51:50 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:40724 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730518AbfIEPvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Sep 2019 11:51:50 -0400
Received: by mail-pg1-f194.google.com with SMTP id w10so1643545pgj.7
        for <netdev@vger.kernel.org>; Thu, 05 Sep 2019 08:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Wbr92vuCnFDA/vontCE25W1hX8WUPt6NK5MN3lIE6ng=;
        b=1oqURt5Sk+OvCI4jpBDj3V2hj6ADSbq9iXL4N+buGx3Vx4USBQXP40XhbXT8uNvpem
         7Ry9z9k1ThkM2GtqPlQ8PHPiBGTEURAsp6cyp54AbjT83+740sBSQxHvgpV62sUyBsZ7
         w+9PnaQvwQEy7Sp1eB63owb+R89rez/8QxyHhF6LbuNZflne4nv2q35iY1ZAqQRtd8AN
         XOplV44+3fIWoxk5ruuqD6uvMtodlr6w3irfOD30irDhWgcvTTYT9k6xhgJ4yYNxF22p
         aDiqGET0FmXTnPvndT4Y88vUBQ0p4A/pamI3WlqOZ7dZTEd5rw4Ho5QrZzOhCbGVhkt3
         ibBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Wbr92vuCnFDA/vontCE25W1hX8WUPt6NK5MN3lIE6ng=;
        b=MCRernUnFAqJO6QrnfpuOyhGMQWJZOZhLZLsFpSHeJ1B6TrsjtK8pkqngFLqSSX+ev
         oBwefe3cvzTCtoQnm/5hNu2QS9YMOTR6WSialefLpk33+dqDD9kXyeluh8NyoLCyd0mn
         TC6nFOtBGKWlxWsXu41e5Fz2y2GEYi8dcT99cqZc5+yX/Xek2Eq7uGHC9saevKThruKe
         tW73NZjQQNH4G0DWsU0g1bU91RJWEAFqStm2exmayjCNcT51LaS91sDdXLN1K3ZqO/wt
         fKP3Hup20xRp9Qr2PshxOwhBpxtuhLcDU9VcKsNIeAA40ZnKeqzXrNbcdgluwZj0ipRu
         Mbhw==
X-Gm-Message-State: APjAAAUC/sVeBUnlUHTfiVgpv05ts/R4OdOnjRMLBxsDt77HGVMyoBTD
        GnUVTXlNf6ph2L/a+xJYDZkhcg==
X-Google-Smtp-Source: APXvYqxQyuQYEDz8E7shNET/rOfz2jtyarIhFlMSf6tH7g0UTI82mWNA+KG25eviBw0ACLeAmSej2Q==
X-Received: by 2002:aa7:8744:: with SMTP id g4mr4580992pfo.129.1567698709258;
        Thu, 05 Sep 2019 08:51:49 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w207sm3310816pff.93.2019.09.05.08.51.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 08:51:49 -0700 (PDT)
Date:   Thu, 5 Sep 2019 08:51:47 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andrea Claudi <aclaudi@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>,
        linux-netdev <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2-next] bpf: fix snprintf truncation warning
Message-ID: <20190905085147.72772bba@hermes.lan>
In-Reply-To: <CAPpH65xtgWp2ELuPBdDOFfhJfHCA6brwxqbPxZogTnnnQ26CmA@mail.gmail.com>
References: <12a9cb8d91e41a08466141d4bb8ee659487d01df.1567611976.git.aclaudi@redhat.com>
        <83242eb4-6304-0fcf-2d2a-6ef4de464e81@gmail.com>
        <CAPpH65xtgWp2ELuPBdDOFfhJfHCA6brwxqbPxZogTnnnQ26CmA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Sep 2019 13:44:55 +0200
Andrea Claudi <aclaudi@redhat.com> wrote:

> On Thu, Sep 5, 2019 at 12:15 AM David Ahern <dsahern@gmail.com> wrote:
> >
> > On 9/4/19 9:50 AM, Andrea Claudi wrote: =20
> > > gcc v9.2.1 produces the following warning compiling iproute2:
> > >
> > > bpf.c: In function =E2=80=98bpf_get_work_dir=E2=80=99:
> > > bpf.c:784:49: warning: =E2=80=98snprintf=E2=80=99 output may be trunc=
ated before the last format character [-Wformat-truncation=3D]
> > >   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
> > >       |                                                 ^
> > > bpf.c:784:2: note: =E2=80=98snprintf=E2=80=99 output between 2 and 40=
97 bytes into a destination of size 4096
> > >   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir), "%s/", mnt);
> > >       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >
> > > Fix it extending bpf_wrk_dir size by 1 byte for the extra "/" char.
> > >
> > > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > > ---
> > >  lib/bpf.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/lib/bpf.c b/lib/bpf.c
> > > index 7d2a322ffbaec..95de7894a93ce 100644
> > > --- a/lib/bpf.c
> > > +++ b/lib/bpf.c
> > > @@ -742,7 +742,7 @@ static int bpf_gen_hierarchy(const char *base)
> > >  static const char *bpf_get_work_dir(enum bpf_prog_type type)
> > >  {
> > >       static char bpf_tmp[PATH_MAX] =3D BPF_DIR_MNT;
> > > -     static char bpf_wrk_dir[PATH_MAX];
> > > +     static char bpf_wrk_dir[PATH_MAX + 1];
> > >       static const char *mnt;
> > >       static bool bpf_mnt_cached;
> > >       const char *mnt_env =3D getenv(BPF_ENV_MNT);
> > > =20
> >
> > PATH_MAX is meant to be the max length for a filesystem path including
> > the null terminator, so I think it would be better to change the
> > snprintf to 'sizeof(bpf_wrk_dir) - 1'. =20
>=20
> With 'sizeof(bpf_wrk_dir) - 1' snprintf simply truncates at byte 4095
> instead of byte 4096.
> This means that bpf_wrk_dir can again be truncated before the final
> "/", as it is by now.
> Am I missing something?
>=20
> Trying your suggestion I have this slightly different warning message:
>=20
> bpf.c: In function =E2=80=98bpf_get_work_dir=E2=80=99:
> bpf.c:784:52: warning: =E2=80=98/=E2=80=99 directive output may be trunca=
ted writing 1
> byte into a region of size between 0 and 4095 [-Wformat-truncation=3D]
>   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir) - 1, "%s/", mnt);
>       |                                                    ^
> bpf.c:784:2: note: =E2=80=98snprintf=E2=80=99 output between 2 and 4097 b=
ytes into a
> destination of size 4095
>   784 |  snprintf(bpf_wrk_dir, sizeof(bpf_wrk_dir) - 1, "%s/", mnt);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Why not rework this to use asprintf and avoid having huge buffers on stack?
