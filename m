Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14AC43BA31F
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 18:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229771AbhGBQPi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 12:15:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhGBQPi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 12:15:38 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35793C061762;
        Fri,  2 Jul 2021 09:13:05 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id j24so9294481pfi.12;
        Fri, 02 Jul 2021 09:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=enA65zqKHPjCHiso0vecqolYZvIy86ulRNV4aOxTN78=;
        b=lWmd+O0+ABAz4EIEb7Y3dOwaeRpp4XDl0XWYQC50aQZYbCc3LX9fnw4HYZY8vfssaH
         NseRUtOaMGRIy8DdO7MdkjiukVqTjccsfYS0OWI+Mgc0/fkZZNquN5g/F9GoXzK9QCnE
         TMnj9U+4eWgCuKVLPnExWbbka7rNLpwe04yd4lqGx/Ivpa4p6W+ayK/LKuV3cBxXHp0U
         2X70LdIgYVzJ1vCYFenBEdznP0BusxEQXtwBeSDOvEQ2WuzeWh8L/655TU+xRirIjhxW
         dvp24uCNYABf1tkzXL/R+Srp1pWTT9SikI1uLC9P2VMBITkp+vd/x/gKjWMjjYpx9ZWJ
         OnWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=enA65zqKHPjCHiso0vecqolYZvIy86ulRNV4aOxTN78=;
        b=ntzeAjduCp580OUuMXwS9lx1mkEFoZR3LsirdmpzaK7nKvH0Hn58aafjS51YxzW5ec
         +gmN0NtyCoI8GiYVsPKhdqaMzreBYLUf2swhqNn3qtF66xq7/ruJQrKAFLWf0MXRAlSV
         7SDxpn+uvGSLa8dMdmmy/8RsXy3WR1YgkrH5tx+aRTVoqAE0osdhKkPahq7PhZrq3N/S
         OjAWErRE15A0e1fMIFwahgHDWJaAj/6bDAXUJ+lEQFJ3xJXFAhNw+6wXWpoKmV7nt4eP
         rm8/SrLLoGiusK/w+tBwKyZ0yBmrAkMc7ECDNu6kXayqxn+iN6S/I9539+F80GAS2vhv
         4gRw==
X-Gm-Message-State: AOAM531NKrvbSCe5f58IgqJ22OgR0xMD1MmMnqX/yJqbwLeRs4gEnwu0
        6qr/P9I0fzIj4+ANQCA7Neg=
X-Google-Smtp-Source: ABdhPJwBVgr9gVu1zblC8JTmpsbb39Amcx1P8hDNYEfk6i7/3vorveCNI+FK5TEuvhXTmZhAGzF9rg==
X-Received: by 2002:aa7:818a:0:b029:309:a073:51cb with SMTP id g10-20020aa7818a0000b0290309a07351cbmr372228pfi.40.1625242384643;
        Fri, 02 Jul 2021 09:13:04 -0700 (PDT)
Received: from localhost ([2409:4063:4d83:c0b5:70cd:e919:ab0c:33ce])
        by smtp.gmail.com with ESMTPSA id x13sm3116094pjk.37.2021.07.02.09.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 09:13:02 -0700 (PDT)
Date:   Fri, 2 Jul 2021 21:41:09 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Leblond <eric@regit.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next v6 2/5] bitops: add non-atomic bitops for
 pointers
Message-ID: <20210702161109.q2cep7hmxyvfelh5@apollo>
References: <20210702111825.491065-1-memxor@gmail.com>
 <20210702111825.491065-3-memxor@gmail.com>
 <0660a065aad94979a560682cef5d573c@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0660a065aad94979a560682cef5d573c@AcuMS.aculab.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 02, 2021 at 08:17:47PM IST, David Laight wrote:
> From: Kumar Kartikeya Dwivedi
> > Sent: 02 July 2021 12:18
> >
> > cpumap needs to set, clear, and test the lowest bit in skb pointer in
> > various places. To make these checks less noisy, add pointer friendly
> > bitop macros that also do some typechecking to sanitize the argument.
>
> Would this work?
> #define BIT_OP(val, op) ((typeof (val))((unsigned long)(val) op))
>
> Should let you do:
> 	ptr = BIT_OP(ptr, | 1);
> 	ptr = BIT_OP(ptr, & ~1);
> 	if (BIT_OPT(ptr, & 1))
> 		...
>
> See https://godbolt.org/z/E57aGK4js
>

This certainly works, but my preference for keeping it this way was reusing the
existing infrastructure (which also has KASAN/KCSAN instrumentation) and avoids
UB while shifting. Ofcourse for this particular case, anything works, but if
putting this in bitops, I thought we should keep it as simple wrappers over
__set_bit/__clear_bit/test_bit.

Also, I compared codegen for both, and it looks pretty much the same to me...

See https://godbolt.org/z/s9cjEnYKj

Let me know if I'm missing something.

> 	David
>
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)

--
Kartikeya
