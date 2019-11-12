Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9377AF9E12
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 00:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKLXSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 18:18:30 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36414 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726932AbfKLXSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 18:18:30 -0500
Received: by mail-pg1-f194.google.com with SMTP id k13so29905pgh.3;
        Tue, 12 Nov 2019 15:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=P+GPyHpfQp0olbZndJxbHClEGpgQPr3NsOhOzsUz5oY=;
        b=IEYCpKokKjyt8Be7lGNHH25XLLLwrGMizo02agHfK7R+fAnUb8uUlRYPhkj8o3aYnD
         cXEaDncWNRbwJZr1NwIBj5mexFU9ABcZBdRExqyp1GWHXEkSAb4bEZoHIkoGw8rq5Dzr
         RpPgBwXq8ZykCmCBLgb+JqFdhzqiaKQmATQOAACWQkToD2/HVJUbCzh8Yp5nW/t7TpKN
         BJ7AbKjl2MrZa/rR1knJAZ7iV1GHOqVpiaGmTHdIAw2Dbe1wel6qI9lz8KbFyTPzXEL0
         prFj7coWJzen5qSMd8PSS2C3DKS1FlCj6vnXvninYlGbjIvmYSWxgnS9wwbUr2bq1/LU
         k7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=P+GPyHpfQp0olbZndJxbHClEGpgQPr3NsOhOzsUz5oY=;
        b=mbrJfppWcY0yae8db0DR34213asyJW+wslP1u07cdM3BAqO0DPIp8Q806fn5BVGqpQ
         Vp50K21GXsUhr26zIlGmAxY39U2aKzmVfRs6Jp2vpD/dDTGZ2oT7dM53BbakaPRGspBF
         sQRUkFwf+yjfrhdzw5Ttz3zatt9xwMZqrdaSAMh4ABvL/wgqm3mJM/7urXVxZeyjgpV0
         XELDrA3eXginf5NcRqtXxFbpqeLmMqXtpzteKpENJGI02g22ln+4eVqMuetIx7mI8P5P
         bcjQaup4pCh4s3t4unesMGabDpIQATTjZUyw9TzG0h0+ScdkAIzfIXq/gbxhqciSjjQj
         EOew==
X-Gm-Message-State: APjAAAXJ59QP3CX91B7I05C//BvfkErp3KXZBNoyqWf3/FRfQEjPKzbf
        Z7UryOdLKpzBmorZ4S/L5GI=
X-Google-Smtp-Source: APXvYqxRzVNcNrxpLc/pvrQok3tM4aZq49GHkprpqNB2ntuu/KTdlG9bSRFQy83JsAu7KM/iS35anA==
X-Received: by 2002:aa7:930c:: with SMTP id 12mr562863pfj.33.1573600708689;
        Tue, 12 Nov 2019 15:18:28 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::1:e001])
        by smtp.gmail.com with ESMTPSA id c12sm29678pfp.178.2019.11.12.15.18.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 12 Nov 2019 15:18:27 -0800 (PST)
Date:   Tue, 12 Nov 2019 15:18:26 -0800
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
Message-ID: <20191112231822.o3gir44yskmntgnq@ast-mbp.dhcp.thefacebook.com>
References: <f9d5f717-51fe-7d03-6348-dbaf0b9db434@solarflare.com>
 <87r23egdua.fsf@toke.dk>
 <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
 <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <87h839oymg.fsf@toke.dk>
 <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
 <8c251f3d-67bd-9bc2-8037-a15d93b48674@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8c251f3d-67bd-9bc2-8037-a15d93b48674@solarflare.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 09:25:06PM +0000, Edward Cree wrote:
> On 12/11/2019 19:52, Alexei Starovoitov wrote:
> > We haven't yet defined what 'extern' keyword in the program means.
> > There are a preliminary patches for llvm to support extern variables. Extern
> > functions are not done yet. We have to walk before we run. With dynamic linking
> > I'm proposing an api for the kernel that I think will work regardless of how
> > libbpf and llvm decide to define the meaning of 'extern'.
> Fwiw the 'natural' C way of doing it would be that for any extern symbol in
>  the C file, the ELF file gets a symbol entry with st_shndx=SHN_UNDEF, and
>  code in .text that uses that symbol gets relocation entries.  That's (AIUI)
>  how it works on 'normal' architectures, and that's what my ebld linker
>  understands; when it sees a definition in another file for that symbol
>  (matched just by the symbol name) it applies all the relocations of the
>  symbol to the appropriate progbits.
> I don't really see what else you could define 'extern' to mean.

That's exactly the problem with standard 'extern'. ELF preserves the name only.
There is no type. I think size is there, but linkers ignore it. There is also
no way to place extern into a section. Currently SEC("..") is a standard way to
annotate bpf programs. I think reliable 'extern' has to have more than just
name. 'extern int foo;' can be a reference to 'int foo;' in another BPF ELF
file, or it can be a reference to 'int foo;' in already loaded BPF prog, or it
can be a reference to 'int foo;' inside the kernel itself, or it can be a
reference to pseudo variable that libbpf should replace. For example 'extern
int kernel_version;' or 'extern int CONFIG_HZ;' would be useful extern-like
variables that program might want to use. Disambiguating by name is probably
not enough. We can define an order of resolution. libbpf will search in other
.o first, then will search in loaded bpf progs, than in kernel, and if all
fails than will resolve things like 'extern int CONFIG_HZ' on its own. It feels
fragile though. I think we need to be able to specify something like section to
extern variables and functions. That would be a compiler extension.

> > Partial verification should be available regardless of
> > whether kernel performs dynamic linking or libbpf staticly links multiple .o
> > together.
> It's not clear to me how partial verification would work for statically
>  linked programs — could you elaborate on this?

I was imagining that the verifier will do per-function verification
of program with sub-programs instead of analyzing from root.
Today the verifier is essentially told: Here is XDP program. Check that it's
valid with any valid context. Now imagine the verifier sees a function:
int foo(struct xdp_md *ctx);
The verifier can check that the function is safe when 'ctx' is valid. There is
no program type for the verifier to deal with. Such 'foo' is an abstract
program. It receives a valid pointer to xpd_md and can call any helper that
accepts xdp_md.

Applying the same logic for two arguments:
int foo(struct xdp_md *arg1, struct __sk_buff *arg2);
The verifier can check that such function is safe when both arg1 and arg2 are
valid pointers. This is not a realistic function. It illustrates the idea that
programs/functions can be abstract. Valid pointers of different types are
received and can be further passed into different helpers when types match.

The next step is to extend this thought process to integers.
int foo(struct xdp_md *arg1, int arg2);
The verifier can check that the program is valid for any valid arg1 and
arg2 = mark_reg_unbounded().

Support for pointers to non-context structs are a bit harder. That needs
more thinking. It should be possible to support:
int foo(struct xdp_md *arg1, char *arg2, bpf_size_t arg3);
The verifier will validate that arg2 array is accessed in [0, arg3] range.

I think that will cover most of the use cases. It won't be possible to support
aribtrary passing of pointers the way current bpf2bpf calls support, but I
think it's an acceptable limitation for partial verification.

