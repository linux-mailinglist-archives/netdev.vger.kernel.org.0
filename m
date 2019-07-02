Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE7A5C9FA
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 09:33:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725922AbfGBHdK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 03:33:10 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45593 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725802AbfGBHdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 03:33:10 -0400
Received: by mail-ot1-f65.google.com with SMTP id x21so16187601otq.12;
        Tue, 02 Jul 2019 00:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1c0hWyTMkj4M+bWpR7NkP+GHPURV06a0lFDJPeh6SBw=;
        b=dYpGDVbArAc99DHzSwo7ccPqV8Y4tPzGnaOgB9C3wmDHAQTLRsbaaMKGkTJBV/KDZb
         Rc5BmjQTVZFDcQAW3Axi3RcTtpXoA54Z4SYQv03df6Q+98kojc1RUtV0XsAuOQe4JDVg
         G6mcjb3XMihaYiqNV30XIdEl/zAoyLhQ1+xzZ+D4w0dd+dYpX+ihpYthMF9SUtPrDswr
         jz6VTb8OotAJEdX9TrFuDwzKmG9QVeRDCHLRCOuNlr8NLorCVX6WmrTjOT28ia/n58+6
         cSZKjd7FmAK5ixcWXfq8iNExQEvVmXo3bD6ZV3O2G6ALOwVzqjuTa5RKwZRvrzFyTNEu
         IlbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1c0hWyTMkj4M+bWpR7NkP+GHPURV06a0lFDJPeh6SBw=;
        b=XAbvY0hZc9jovr1bg5KnaCboti7Kl7cw4Aux7EVPjZAYlpPRegQsNgkk15gM5MQLlL
         lD/E6+FCw/b2QpVcdBlr5cPmbg9mWBVHZbCzVfzrKDN2thsANXMQMgEBiVcEexVDDJJS
         SRTt6qDbAy95jcB/ORQe3Tiw+ovtEmmvnq0x7KtvdbFrHXdiVGNHIoYWiyNs41/Yxb9+
         VK13He1fknBMp1yZ+3IAWahdGDeUgzsCNWNc483UElRzDH5MjfoL92phNTcSGeVDeAqt
         Uas6GdZ73NPqINElAesTroYgxn25OdVhksAz0rF4Hpm2w9tGjrOrgmiYfRVuP8jsCNdR
         zfbg==
X-Gm-Message-State: APjAAAWzGKALaRdJ9uqRWhpzvODBFoiAz45I8nRn3OXPL7zRKTcumvnW
        e4JFolviFNrxCz9tPpTj6sKbGbG32wQ4b7h790A=
X-Google-Smtp-Source: APXvYqxlKK9A0mURV2hWmdOgaTtmQLWnHF4lSa0SKZWdnTafzGv326O9eqka9xWFakaz/hlxNK54s7pdkvnQb8gpvdM=
X-Received: by 2002:a9d:7259:: with SMTP id a25mr6155854otk.30.1562052789656;
 Tue, 02 Jul 2019 00:33:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190702054647.1686489-1-andriin@fb.com> <CAH3MdRUv9eJuecKq7weG614+6oEtfLeUHnTxoU19qr39p9-mrQ@mail.gmail.com>
In-Reply-To: <CAH3MdRUv9eJuecKq7weG614+6oEtfLeUHnTxoU19qr39p9-mrQ@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 2 Jul 2019 09:32:58 +0200
Message-ID: <CAJ8uoz3BuPumnS_mY3eQf4oH3x2PFdPTScmxDCfgU6=1aDrnew@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix GCC8 warning for strncpy
To:     Y Song <ys114321@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 2, 2019 at 8:10 AM Y Song <ys114321@gmail.com> wrote:
>
> On Mon, Jul 1, 2019 at 10:47 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > GCC8 started emitting warning about using strncpy with number of bytes
> > exactly equal destination size, which is generally unsafe, as can lead
> > to non-zero terminated string being copied. Use IFNAMSIZ - 1 as number
> > of bytes to ensure name is always zero-terminated.
> >
> > Cc: Magnus Karlsson <magnus.karlsson@intel.com>
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  tools/lib/bpf/xsk.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
> > index bf15a80a37c2..9588e7f87d0b 100644
> > --- a/tools/lib/bpf/xsk.c
> > +++ b/tools/lib/bpf/xsk.c
> > @@ -327,7 +327,7 @@ static int xsk_get_max_queues(struct xsk_socket *xsk)
> >
> >         channels.cmd = ETHTOOL_GCHANNELS;
> >         ifr.ifr_data = (void *)&channels;
> > -       strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ);
> > +       strncpy(ifr.ifr_name, xsk->ifname, IFNAMSIZ - 1);
>
> To accommodate the xsk->ifname string length FNAMSIZ - 1, we need to have
>     ifr.ifr_name[FNAMSIZ - 1] = '\0';
> right?

Yes. Since the ifr struct is allocated from the stack and not zeroed,
we should do this.

Thanks to both of you for catching this.

/Magnus

> >         err = ioctl(fd, SIOCETHTOOL, &ifr);
> >         if (err && errno != EOPNOTSUPP) {
> >                 ret = -errno;
> > --
> > 2.17.1
> >
