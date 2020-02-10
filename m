Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA7F915859B
	for <lists+netdev@lfdr.de>; Mon, 10 Feb 2020 23:33:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727516AbgBJWde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Feb 2020 17:33:34 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:42840 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727422AbgBJWde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Feb 2020 17:33:34 -0500
Received: by mail-lf1-f66.google.com with SMTP id y19so5504648lfl.9;
        Mon, 10 Feb 2020 14:33:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V9XkxYkaG0B+nnEMVRxPtaSnXiCsxqB6sbkGiIdacvU=;
        b=HXEHJjzML3XxoB15B/F6ZuwkValmyqmVqMBma19E1Ygn2SaMdMsjUiU2eSS+fIpc1Q
         HHZM7jaeEaw+yOvhHixtJmCMy/Ja8cqoLBWVwPYYrfHO1QuAB1OSAy8nQ74Ui0ln2z+F
         GprwVdJySan5zmoasJUX5DWiOzdqMArG+y3UpFfLOGdEfbxkzLf68LOxEHTjw+PiYyMg
         Ki5HUHic5WMX3tkU2zced1uuY1tQBKEnNpfMatJ2c9zX6VL6zSworR+EX3LN99uE+ZA2
         G+KlDCr/idOl+SQhrV37TkWNKorXeVnFO9zlwbJtiOOxagUilEBCz4OSWirZKH4ejTvw
         jLig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V9XkxYkaG0B+nnEMVRxPtaSnXiCsxqB6sbkGiIdacvU=;
        b=LipJMnUtqiFWnha8jKObKXSyzueypF7x7LzIlaJH9qUO1qAXgjsc/HgdU3v0FSCI8q
         DYM3rtlvJmjB06usFnovuB1jp0mqsWd+a4K63jW4c1QfK+srJ7fF++EGjlUatOnuum0f
         PkI9T5tCPw/MG/p7gpCwdlh4Zk8kTnYDVQBAvMqN8DxhgbLeYRfGNMbXJ4JakLeuT6JC
         zn9bG8TQSOo6yyIYNXRcn0edHT4iuWRQ3tlGuxQNW7NuZYE1TPIR2Jyv9hNByOaM861A
         Y7mPSZCea1rhiO7ERTv7p7rIUEHf24UwHnU0ihG/1uDiezoe9DqYkEqJCVLxRXKSHd7w
         J0lg==
X-Gm-Message-State: APjAAAV7eVxR8uKHZst6ZumYu9Oa+t4KdPpcUUVly1+S733YKHFzphSx
        QZYR7ijlzFO2263KyZrdRSajgtI9zgY+W0QFYjU=
X-Google-Smtp-Source: APXvYqwcsxbmeYdyFqIdbutRPJ+eeMTWtggT+/1ngme9JHcO65/+eGyis5qROdf2Hy+h1k3wSEQsEO3Ba97WEh7/o8g=
X-Received: by 2002:ac2:5626:: with SMTP id b6mr1849832lff.134.1581374011555;
 Mon, 10 Feb 2020 14:33:31 -0800 (PST)
MIME-Version: 1.0
References: <158131347731.21414.12120493483848386652.stgit@john-Precision-5820-Tower>
 <87d0amahk9.fsf@cloudflare.com>
In-Reply-To: <87d0amahk9.fsf@cloudflare.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 10 Feb 2020 14:33:20 -0800
Message-ID: <CAADnVQJ0kSjGjj9N3Jt2t=i+aVWvJ8iUzuSJV90997gbX-Ah1Q@mail.gmail.com>
Subject: Re: [PATCH] bpf: selftests build error in sockmap_basic.c
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 10, 2020 at 1:59 AM Jakub Sitnicki <jakub@cloudflare.com> wrote=
:
>
> On Mon, Feb 10, 2020 at 05:44 AM GMT, John Fastabend wrote:
> > Fix following build error. We could push a tcp.h header into one of the
> > include paths, but I think its easy enough to simply pull in the three
> > defines we need here. If we end up using more of tcp.h at some point
> > we can pull it in later.
> >
> > /home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic=
.c: In function =E2=80=98connected_socket_v4=E2=80=99:
> > /home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic=
.c:20:11: error: =E2=80=98TCP_REPAIR_ON=E2=80=99 undeclared (first use in t=
his function)
> >   repair =3D TCP_REPAIR_ON;
> >            ^
> > /home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic=
.c:20:11: note: each undeclared identifier is reported only once for each f=
unction it appears in
> > /home/john/git/bpf/tools/testing/selftests/bpf/prog_tests/sockmap_basic=
.c:29:11: error: =E2=80=98TCP_REPAIR_OFF_NO_WP=E2=80=99 undeclared (first u=
se in this function)
> >   repair =3D TCP_REPAIR_OFF_NO_WP;
> >
> > Then with fix,
> >
> > $ ./test_progs -n 44
> > #44/1 sockmap create_update_free:OK
> > #44/2 sockhash create_update_free:OK
> > #44 sockmap_basic:OK
> >
> > Fixes: 5d3919a953c3c ("selftests/bpf: Test freeing sockmap/sockhash wit=
h a socket in it")
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> > ---
> >  .../selftests/bpf/prog_tests/sockmap_basic.c       |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c b/t=
ools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > index 07f5b46..aa43e0b 100644
> > --- a/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > +++ b/tools/testing/selftests/bpf/prog_tests/sockmap_basic.c
> > @@ -3,6 +3,11 @@
> >
> >  #include "test_progs.h"
> >
> > +#define TCP_REPAIR           19      /* TCP sock is under repair right=
 now */
> > +
> > +#define TCP_REPAIR_ON                1
> > +#define TCP_REPAIR_OFF_NO_WP -1      /* Turn off without window probes=
 */
> > +
> >  static int connected_socket_v4(void)
> >  {
> >       struct sockaddr_in addr =3D {
>
> Neat, I haven't thought of that. Thank you for fixing up my mistake.
>
> Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

I also think this is the better approach.
Applied. Thanks.
