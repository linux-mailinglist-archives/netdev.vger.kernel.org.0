Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB46F5D27D
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 17:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726375AbfGBPO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 11:14:57 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:34916 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbfGBPO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 11:14:57 -0400
Received: by mail-qk1-f195.google.com with SMTP id l128so14313283qke.2;
        Tue, 02 Jul 2019 08:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pi1nh7s28JCd7cXoJd4FqcUDBBYW5zsbcCvVRkQ6Vow=;
        b=nnWrWqOZ1wLoFkcXoMiQBQusAYkI0QYuL56bMQbbJpM/Hb+tOWqFjsb79+gpCY7HRA
         y3P54S6wQhZeInCzWT03pl36mScP34ommCDNON77/fOiIFwEkmg/FeBAwkSGJ9fluRY8
         SzHThv+XHKRuLX8OrlsFtBTsrmsyVNfOeNvC9c8E5QgM6LFgYXe9uYWD/465RDZ22D+8
         SgOxe8eT9A9ZZHVDcTVZSwjm9AN7fRgc7Ed9/+AfTt5k2/m6f7vY5fq2y3LK8mAFcWyw
         EQyd2RYLhgfjbH6gTD7OD4tj+SlPmJZLvfZ/TpT9nBCvj5JXsqMU/dMMWhGq8XfJraBt
         2LUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pi1nh7s28JCd7cXoJd4FqcUDBBYW5zsbcCvVRkQ6Vow=;
        b=WT+DdG0Ya96AtQZ13bXQhkq+1tc4A7x8CmJbzYksiCtupHnl5yXDxmt3lFTSUrSDAj
         GTyCJ+3FHYnRCqH2yclMilXLnyiFSf85TZVNWgSeLPPslF+llUViO5EpO/+YTrdPPvVb
         itR4PRoF1VlkCDDlAAtRAD7Y4lyghcErgsrxBsEj7F31gJ9EYc5KnnNm1ibxaQr34O11
         K9Vdkfl6N29AefCrYAjnxaSqhzaGVyKXJTeMbFYBe3k/8LYv/6scFzqGkM3JEm5DHtG1
         AR8QHOOzdx6CxJh09oQ7smnMrEBVQ11uMptiLOTOppFRVlL2cZ1UOeLgdQ1d5QLnAehB
         zwLg==
X-Gm-Message-State: APjAAAW+yC0C2q1jLcPSz/Z7K240lMD7EVdN3G7/2ePwekjVRlFZqR2H
        Bz+yod1ElbI1rGYSuup7LeTgdpPotV3V6MeOsHg=
X-Google-Smtp-Source: APXvYqxf5gYsiyVSZvRHsY1r2Xd1vF45LX0OO3ci5JWNiR8qJ9NpQkDfQZFY4F6VrpmlSHuaoTSjfPe8pDw0pZS2hIA=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr25606835qkj.39.1562080496435;
 Tue, 02 Jul 2019 08:14:56 -0700 (PDT)
MIME-Version: 1.0
References: <20190702054647.1686489-1-andriin@fb.com> <CAH3MdRUv9eJuecKq7weG614+6oEtfLeUHnTxoU19qr39p9-mrQ@mail.gmail.com>
In-Reply-To: <CAH3MdRUv9eJuecKq7weG614+6oEtfLeUHnTxoU19qr39p9-mrQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 2 Jul 2019 08:14:45 -0700
Message-ID: <CAEf4BzYAvnFteb4ePTOEvcuS1ivBp-ZJvtxVw551mum5Pd4z6A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: fix GCC8 warning for strncpy
To:     Y Song <ys114321@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Magnus Karlsson <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 1, 2019 at 11:10 PM Y Song <ys114321@gmail.com> wrote:
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

Yes. I somehow misread description of strncpy and assumed it does that
automatically (which would make sense), but it actually doesn't. Only
strlcpy does. v2 with fix is coming.

>
> >         err = ioctl(fd, SIOCETHTOOL, &ifr);
> >         if (err && errno != EOPNOTSUPP) {
> >                 ret = -errno;
> > --
> > 2.17.1
> >
