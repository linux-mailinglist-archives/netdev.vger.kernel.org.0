Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF6ACFD2D7
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 03:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbfKOCNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 21:13:24 -0500
Received: from mail-pl1-f181.google.com ([209.85.214.181]:37991 "EHLO
        mail-pl1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727053AbfKOCNY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 21:13:24 -0500
Received: by mail-pl1-f181.google.com with SMTP id w8so3579032plq.5;
        Thu, 14 Nov 2019 18:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=+CdVfcfXukusFlzSs9OadIqqjeGIFwrHJWdF7J1JrZk=;
        b=TqvcFOyT07AzXsW+lDTtfRhowXoqJH/+f9rgPSyQQuviDUUDBdAPMfQ02LGKVkeWAM
         X5Oh3nmWirKkU4EChJXlm3US5ZMjhfIm+uk7KNp5acN51KZnKrr5StzNuLN/S9J0zBIj
         mRGWjxR08gdrFSWgX+7yE7qvFq1jW3QTGSw5XD9KbroUScsVJ2lMVUPRK2aGr9oRZc/u
         HPt3+C8yImykHqmg9V7DYdQ8KCgBLwCmORWihjNzzzysXs6LySjWpzZQBzfhAN7MCqCz
         BXKvx8wD+PeJu5Gv12zFx31mOyrYTUs1m/dTZ0kOdIG2ujn42LhzQDXNaO8ztwo3LI2Y
         iOUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=+CdVfcfXukusFlzSs9OadIqqjeGIFwrHJWdF7J1JrZk=;
        b=NBCXRHCT8xPFNYGmiimsVoDWv2B+MC9r6tuQEpG1y6r3rc2A0bEjBY0dsva+CSUo/q
         RdWhD66XurtYAJfnPg/+u0hjEig04BHQKrByvZ79bm5s3Z0zHhJoJ866lUcM+gZPzqXq
         5Pgi5ZpUk2pyMJ1zlXi7xg/h8+VMyxXMQfmY5LPNstwyVHokXOJQJ0TUHh7sJD4r1w04
         Td6wDWL6K/KIVQs3KgNymQYaXUBr7zfN8x+NIylwWtMz10si6KMtR1uMDg+sU9MYX9to
         slK+bZqlfeVxViRdObYr8Cs8i0+BIx01jbEl/PpA9kDIzsiBi3Gxavr/hJmEMTSksYJ0
         J9lQ==
X-Gm-Message-State: APjAAAXA0W/hFRRPwfFUF9uwkDZKuXuNrul/ZYKDOAJiGSc10cAc5X6k
        6GB39XoNeZKehw0kchveSqbKIQ0R
X-Google-Smtp-Source: APXvYqzzOuHDtgVFgkH1+adMfwt2qKexKxa7pYaEglmRDGzwX06iBm4DMtR3Jjm2mlvXhb/LF41Uag==
X-Received: by 2002:a17:90a:fc91:: with SMTP id ci17mr16190432pjb.13.1573784003140;
        Thu, 14 Nov 2019 18:13:23 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::6ab4])
        by smtp.gmail.com with ESMTPSA id v15sm8810994pfc.85.2019.11.14.18.13.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 18:13:22 -0800 (PST)
Date:   Thu, 14 Nov 2019 18:13:19 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: static and dynamic linking. Was: [PATCH bpf-next v3 1/5] bpf:
 Support chain calling multiple BPF
Message-ID: <20191115021318.sj5zfokruljugcno@ast-mbp.dhcp.thefacebook.com>
References: <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
 <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <87h839oymg.fsf@toke.dk>
 <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
 <8c251f3d-67bd-9bc2-8037-a15d93b48674@solarflare.com>
 <20191112231822.o3gir44yskmntgnq@ast-mbp.dhcp.thefacebook.com>
 <0c90adc4-5992-8648-88bf-4993252e8992@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0c90adc4-5992-8648-88bf-4993252e8992@solarflare.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 13, 2019 at 06:30:04PM +0000, Edward Cree wrote:
> > There is also
> > no way to place extern into a section. Currently SEC("..") is a standard way to
> > annotate bpf programs.
> While the symbol itself doesn't have a section, each _use_ of the symbol has a
>  reloc, and the SHT_REL[A] in which that reloc resides has a sh_info specifying
>  "the section header index of the section to which the relocation applies."  So
>  can't that be used if symbol visibility needs to depend on section?  Tbh I
>  can't exactly see why externs need placing in a section in the first place.

I think section for extern can give a scope of search and make libbpf decisions
more predictable? May be we can live without it for now, but we need BTF of
extern symbols. See my example in reply to John.

> > I think we need to be able to specify something like section to
> > extern variables and functions.
> It seems unnecessary to have the user code specify this.  Another a bad
>  analogy: in userland C code you don't have to annotate the function protos in
>  your header files to say whether they come from another .o file, a random
>  library or the libc.  You just declare "a function called this exists somewhere
>  and we'll find it at link time".

yeah. good analogy.

> > I was imagining that the verifier will do per-function verification
> > of program with sub-programs instead of analyzing from root.
> Ah I see.  Yes, that's a very attractive design.
> 
> If we make it from a sufficiently generic idea of pre/postconditions, then it
>  could also be useful for e.g. loop bodies (user-supplied annotations that allow
>  us to walk the body only once instead of N times); then a function call just
>  gets standard pre/postconditions generated from its argument types if the user
>  didn't specify something else.

regarding pre/post conditions.
I think we have them already. These conditions are the function prototypes.
Instead of making the verifier figuring the conditions it's simpler to use
function prototypes instead. If program author is saying that argument to the
function is 'struct xpd_md *' the verifier will check that the function is safe
when such pointer is passed into it. Then to verify the callsite the verifier
only need to check that what is passed into such function matches the type. I
think it's easy to see when such type is context. Like 'struct __sk_buff *'.
But the idea applies to pointer to int too. I believe you were arguing that
instead of tnum_unknown there could be cases with tnum_range(0-2) as
pre-condition is useful. May be. I think it will simplify the verifier logic
quite a bit if we avoid going fine grain.
Say we have a function:
int foo(struct __sk_buff *skb, int arg)
{
   if (arg > 2)
      return 0;
   // do safe stuff with skb depending whether arg is 0, 1, or 2.
}
That first 'if' is enough to turn pre-conditions into 'any skb' and 'any arg'.
That is exactly what BTF says about this function.

