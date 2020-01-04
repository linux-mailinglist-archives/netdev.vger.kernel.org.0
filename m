Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 443E512FFF6
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 02:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgADBcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 20:32:05 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:37145 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbgADBcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 20:32:05 -0500
Received: by mail-il1-f195.google.com with SMTP id t8so38094901iln.4
        for <netdev@vger.kernel.org>; Fri, 03 Jan 2020 17:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=iKdXV40zp7HYQhCw5RprjfcGR+hom7KuV7z8YSCgMYs=;
        b=HmRuxu85O6nXMh3jZKc0jQ4vIRFwSX7D1SDnRXGAlQJlFXBJTiUs5MQzfLSpm3iX5v
         yn01sJE8UQj+QFu6XeqVbvbjhNUlkV9K2k1a3Sz5ksjhuzlDtSBDHt1kYkcgToGD1Srs
         2y7sh8jVk9CJYRYursqhw/FJi1XOLlIWjh6vE00ty231/eeQOkr46nnXnzWNmRuzkw3k
         hy2BeeYy0zIFLUOJ0FQzRgocSV1exn3sxnjceHNWp5xLehgeUYUHmcavpP6mwGRBCofU
         m4EfZmBz3TJsQp4PbBAQISdlk5+YHy4XGV6LIcwVkyYvgsa46SCwnKd66J1fr3XQh62a
         b2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=iKdXV40zp7HYQhCw5RprjfcGR+hom7KuV7z8YSCgMYs=;
        b=hueLuJVBGU+PzUf4gDaLZvPctZPKVqs+cduJY42QS57OWEvQK+ULloipNXsucxsJF1
         jxQS3Z9jXoa/VlCAd3lTIzvJqBb5F8bXUxLh0LIPml08BtGv3oIMvgE+5ODGezRidhVD
         NacL+cWGIy+rmYL7m/9L7cT0UdWEeGr0BfXL1UlRwZkoic0kptmQ30FQ9p0/BfDhu/v8
         7hQVnTcYIodMJX0OKyYhMjgHMErJqCpOF4+nl6SovdEbjTgmtTlCUwV3i5Vw3uFgLDIk
         4lSzGQUcJeKKFi4I87eDx8rBhMMPuHZiN70YMKh/Bf0FO5PxMspLyYKwBSd1ZV3XOj5Y
         aGGA==
X-Gm-Message-State: APjAAAVd+6KEYgjoSbwMjsmIIuEYFpi/KoMzO0ifHBqiGIydglSq9fxb
        y1TCBX4EFlfOrqg0Qb5U+ftUaA==
X-Google-Smtp-Source: APXvYqxC81dX9dHMssrjHa5TmlbNO4RsuH5crfUxEdlHwXaJLKMHx5AGZAhB3yUDZRovGPY/3S4k2g==
X-Received: by 2002:a92:884e:: with SMTP id h75mr78174164ild.199.1578101524531;
        Fri, 03 Jan 2020 17:32:04 -0800 (PST)
Received: from localhost ([64.62.168.194])
        by smtp.gmail.com with ESMTPSA id 75sm21496162ila.61.2020.01.03.17.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 17:32:03 -0800 (PST)
Date:   Fri, 3 Jan 2020 17:32:02 -0800 (PST)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     =?ISO-8859-15?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Alexei Starovoitov <ast@kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-riscv@lists.infradead.org,
        bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2 6/9] riscv, bpf: provide RISC-V specific JIT
 image alloc/free
In-Reply-To: <CAJ+HfNgmcjLniyG0oj7OE60=NASfskVzP_bgX_JXp+SLczmyOQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.21.9999.2001031730370.283180@viisi.sifive.com>
References: <20191216091343.23260-1-bjorn.topel@gmail.com> <20191216091343.23260-7-bjorn.topel@gmail.com> <7ceab77a-92e7-6415-3045-3e16876d4ef8@iogearbox.net> <CAJ+HfNgmcjLniyG0oj7OE60=NASfskVzP_bgX_JXp+SLczmyOQ@mail.gmail.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-452107929-1578101522=:283180"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-452107929-1578101522=:283180
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

On Wed, 18 Dec 2019, Bj=C3=B6rn T=C3=B6pel wrote:

> On Mon, 16 Dec 2019 at 16:09, Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
> >
> > On 12/16/19 10:13 AM, Bj=C3=B6rn T=C3=B6pel wrote:
> > > This commit makes sure that the JIT images is kept close to the kerne=
l
> > > text, so BPF calls can use relative calling with auipc/jalr or jal
> > > instead of loading the full 64-bit address and jalr.
> > >
> > > The BPF JIT image region is 128 MB before the kernel text.
> > >
> > > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> > > ---
> > >   arch/riscv/include/asm/pgtable.h |  4 ++++
> > >   arch/riscv/net/bpf_jit_comp.c    | 13 +++++++++++++
> > >   2 files changed, 17 insertions(+)
> > >
> > > diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/as=
m/pgtable.h
> > > index 7ff0ed4f292e..cc3f49415620 100644
> > > --- a/arch/riscv/include/asm/pgtable.h
> > > +++ b/arch/riscv/include/asm/pgtable.h
> > > @@ -404,6 +404,10 @@ static inline int ptep_clear_flush_young(struct =
vm_area_struct *vma,
> > >   #define VMALLOC_END      (PAGE_OFFSET - 1)
> > >   #define VMALLOC_START    (PAGE_OFFSET - VMALLOC_SIZE)
> > >
> > > +#define BPF_JIT_REGION_SIZE  (SZ_128M)
> > > +#define BPF_JIT_REGION_START (PAGE_OFFSET - BPF_JIT_REGION_SIZE)
> > > +#define BPF_JIT_REGION_END   (VMALLOC_END)
> > > +
> >
> > Series looks good to me, thanks; I'd like to get an ACK from Palmer/oth=
ers on this one.
> >
>=20
> Palmer/Paul/Albert, any thoughts/input? I can respin the the series
> w/o the call optimizations (excluding this patch and the next), but
> I'd prefer not given it's a nice speed/clean up for calls.

Looks like Palmer's already reviewed it.  One additional request: could=20
you update the VM layout debugging messages in arch/riscv/mm/init.c to=20
include this new area?

thanks,

- Paul
--8323329-452107929-1578101522=:283180--
