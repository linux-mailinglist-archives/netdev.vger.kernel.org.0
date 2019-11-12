Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0D8F86C0
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 03:11:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727302AbfKLCLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 21:11:34 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43197 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfKLCLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 21:11:33 -0500
Received: by mail-qt1-f193.google.com with SMTP id l24so18019971qtp.10;
        Mon, 11 Nov 2019 18:11:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sS3SfEiHaLmdK9FoxXeUPs5m4L36caVxBC6k3Us9y2w=;
        b=OfEzPLX0Q/6DW99OCas6gtFDIbZE81w5FgVmcf+Afh99WBLUjtbUqnWlaKk9Ofbt1Q
         wOQy9tj3Ent8H1WbCFOWGNP3tsR8RTwGgG0wVDQM4tA8Dn6915wuin1n2wv8yf4Irw6Z
         ZBkle36jVnvZhmyUD3W6NFulmxnknNh03IGREv13z/UGGRYv7X0BJQ3LjO7qU9108xzV
         COsfTJubzMVRUYn2eoC7alntHRL+yaNWbN4k57m+uPir6KGuk9QN0E041r65etpgds4o
         UGo9m7CXp0idTVY9n1s/uP1iJkpKCwqAvQA9hvIRouHX1rWkV4E99GVdsbhbGaxdR0Yf
         e0TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sS3SfEiHaLmdK9FoxXeUPs5m4L36caVxBC6k3Us9y2w=;
        b=fFt21/h/7D1ijVnvKFCXDly+Crg8ROE3euJGBGwTJ1WE74breLKd7rNepTHCDItBNm
         YMdz2VWELPSPAn3zLJQ1UXcNgwuKqfkJ1jKJoWdhK2HE6Ht4V2TyGVLo+rCP7qzp4eVO
         5N6EbHxDkAm5b3Mi1ac5VkufjU0rHf6ET0SeFJxtGQuFp4KVZMe8cmcWa+BRlTodRZqR
         B9SoRf4vrq19YbDCmoXaPAjPMqTrZ6GAizj4Y90cZqTk/uX/Bz84nNqlP4KqpF8TcD+W
         vVO0Ehb/WA9BN8tOzhmmfx7mLjlS6cFV4zdWAa3pwhv8RkUl7DGcgD0OG+oA0ArYtcIn
         TeAw==
X-Gm-Message-State: APjAAAVH2p1Q7rqv1FS/b8XxzP7oH4hDZJQTBle0WhJP/EyhZsXkrgnG
        3Fp2xpfmo+yWfdUtNWkp0dGU2TfQenpUkfh0W/Y=
X-Google-Smtp-Source: APXvYqyXCcGPV+icXglJPd6k7E9LV1pRPC5k2l7veXi0pXdhpQXn3z5k+0W/+b3NWCXvR//fb7sWJE5x72ZEu+fgPM8=
X-Received: by 2002:aed:35e7:: with SMTP id d36mr28589959qte.59.1573524692659;
 Mon, 11 Nov 2019 18:11:32 -0800 (PST)
MIME-Version: 1.0
References: <20191109080633.2855561-1-andriin@fb.com> <20191109080633.2855561-3-andriin@fb.com>
 <20191111104057.0a9dfd84@cakuba>
In-Reply-To: <20191111104057.0a9dfd84@cakuba>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 11 Nov 2019 18:11:21 -0800
Message-ID: <CAEf4Bzb_49EvfBP0P-jo5=Rg9cP26_hSCztK4HcUMHD-4fPA=g@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/3] libbpf: make global data internal arrays
 mmap()-able, if possible
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 10:41 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Sat, 9 Nov 2019 00:06:31 -0800, Andrii Nakryiko wrote:
> > +static int bpf_object__probe_array_mmap(struct bpf_object *obj)
> > +{
> > +     struct bpf_create_map_attr attr = {
> > +             .map_type = BPF_MAP_TYPE_ARRAY,
> > +             .map_flags = BPF_F_MMAPABLE,
> > +             .key_size = sizeof(int),
> > +             .value_size = sizeof(int),
> > +             .max_entries = 1,
> > +     };
> > +     int fd = bpf_create_map_xattr(&attr);
> > +
> > +     if (fd >= 0) {
>
> The point of the empty line between variable declarations and code in
> the Linux coding style is to provide a visual separation between
> variables and code.
>
> If you call a complex function in variable init and then check for
> errors in the code that really breaks that principle.

I'll split declaration and initialization, no problem

>
> > +             obj->caps.array_mmap = 1;
> > +             close(fd);
> > +             return 1;
> > +     }
> > +
> > +     return 0;
> > +}
>
