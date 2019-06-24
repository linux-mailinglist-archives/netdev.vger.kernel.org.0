Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54E9F51F28
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 01:35:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbfFXXfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 19:35:19 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:37021 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfFXXfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 19:35:19 -0400
Received: by mail-lj1-f196.google.com with SMTP id 131so14301585ljf.4;
        Mon, 24 Jun 2019 16:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IvGfUsEsPfILP2JsuYFvKK2rmUrap93sJGjxp5w61WY=;
        b=ZexGESd2sbrcoHawQOWaaPxCngJqUh4OV23ETrO6o22YScx//Qbj3/ocqGOZGCIZUy
         GcPca+zC8Su66++qVCX4TpMs09R0syQMTjIiTJ1pRuHX7QLOgmVrO3Q9Nu4R9rNkeDPV
         hMibTNmHxr+H8W/p3iZdoQOocQehqUdjwdQvp61vga2WviZUNEqIUbp/q4dHrtLLQd5X
         Fky8UBT+kRcLF7pcMANeuMYWvnW1SfpD0cI+Ti+cMwELgxMX7vigpZiec4T/yxfoE9wB
         uedXRbL4KWsG7gYBhBigccWi/R6cCl68qR3obOdIbWTgnYD2rsUBwM3BsZk2WnGlsvrr
         7oSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IvGfUsEsPfILP2JsuYFvKK2rmUrap93sJGjxp5w61WY=;
        b=K7XTBp8pxOw62zx0najiSZ20/QpTT9VmGhmBJi+kahiSEqKiqVjHoRKfAcYtMM8AAZ
         hm9btwLdDo+3eqsvuuvtl2xma6P81Ol24+Wq/x46iPqNT6rqhGK9Q77ZiomuhomQFY5y
         u78E+3+1Z6rrl4yXUiiLfhE71c7jarKc4mUorjxjWoHHDToGDNz/uRqUYX2/HkOJ4E2M
         hOE5+Z1pJQbyVGLEdQjQVDZCMdxaqWMcO5b4mJZtT0bT0OCMjTWkTSxeGdnHbaXDNHKd
         P23AqqksU5eGmetpDxTr3RD2Zj4/j2QpEQ3o7TNLs9KXPg8RZp7/jH7h5HgrS9l0DjSP
         m8Dw==
X-Gm-Message-State: APjAAAUWgsXidzGfApbBvFRv96LDBBOXju7YbPrtMQiUhJw+Ky6ScT60
        Q8i2Jjclvky4u05HOpEExSWcrvQrvEikOR3ZzZ8=
X-Google-Smtp-Source: APXvYqziSryBpZbr4FqRjAhwFUa0RwgdClngxZGrqEXbOXHzWLAm2wr6tgY3okW5B8Ea57NLNHi94eFducexe72BgxI=
X-Received: by 2002:a2e:b047:: with SMTP id d7mr10251853ljl.8.1561419316476;
 Mon, 24 Jun 2019 16:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190621231650.32073-1-brianvv@google.com> <20190621231650.32073-3-brianvv@google.com>
 <20190624154558.65c31561@cakuba.netronome.com>
In-Reply-To: <20190624154558.65c31561@cakuba.netronome.com>
From:   Brian Vazquez <brianvv.kernel@gmail.com>
Date:   Mon, 24 Jun 2019 16:35:05 -0700
Message-ID: <CABCgpaUhHmLaWUg-x_X+yYD6pnoAcMLw9jr1BPnv5vrM-NYmqQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/6] bpf: add BPF_MAP_DUMP command to access more than
 one entry per call
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 3:46 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Fri, 21 Jun 2019 16:16:46 -0700, Brian Vazquez wrote:
> > @@ -385,6 +386,14 @@ union bpf_attr {
> >               __u64           flags;
> >       };
> >
> > +     struct { /* struct used by BPF_MAP_DUMP command */
> > +             __u32           map_fd;
>
> There is a hole here, perhaps flags don't have to be 64 bit?
The command implementation is wrapping BPF_MAP_*_ELEM commands, I
would expect this one to handle the same flags which are 64 bit.
Note that there's a hole in the anonymous structure used by the other
commands too:
        struct { /* anonymous struct used by BPF_MAP_*_ELEM commands */
                __u32           map_fd;
                __aligned_u64   key;
                union {
                        __aligned_u64 value;
                        __aligned_u64 next_key;
                };
                __u64           flags;
        };
