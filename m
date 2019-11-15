Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37654FD296
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbfKOBuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:50:06 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34041 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726956AbfKOBuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:50:06 -0500
Received: by mail-pf1-f195.google.com with SMTP id n13so5554321pff.1;
        Thu, 14 Nov 2019 17:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c61Ig9SwSoDqV7zYUXQJVmC/opkuC1ckBKs3j2LfZ8E=;
        b=X6cVeiofk1m8oDoYmfhokhr3mDnJcd6YUIivEM8+ec8ZYmmMpARpo2iMJLxrvQk7Ll
         09YorFNiMK6vBqQi4MMXXc+Pw6ANivhcI2G0zJZ2ssO72/fif7cwwi0ZuUg7yqsN00GS
         iy+2N59lvsdwVCk9lVsLEfU51xfTceJ+FpxYEDdJ04dTCShiU/0/BKnON3bSC6sz0NBP
         awAFgc/WuB2JpgkGubQacYjGS0Zk3AXgBJHuhCr2vbzlEi0hlpeqzCtkC+/nN9XECtSC
         7kxP1/5hC2kfPiwY8249dyf6vXAdPGwOXNGMHzcHKlcSvomXrPpvk+Pn2wo0iRWc4n00
         U7Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c61Ig9SwSoDqV7zYUXQJVmC/opkuC1ckBKs3j2LfZ8E=;
        b=sV26QJC6Icbc2Vkm8190t1ntQW35ngGZ6h9FFoauQded4OpfL5ELQQp4tOhNgs6VTb
         zv7TvJMk1uvXLX5Z3cxV4wTIJvAxFUHoLnonXLoqF6Du0B+G7izPeXzsonfPxw+PGY/n
         SibYH1t6LBvYeKmulZS/WsePFelXa8FhTdMUN3Dq8JxoF264YxH1ePL8GU+o3iPofqla
         jLpRAzob1tt/D92CaMzg6L2Ul8b9aZClzAyP203Rmf9NCUomi4K8vezXQ/F8Dm7rEYZY
         BrPv2yRUDwEAZ1yM7lx0/KJleYub5sU9jM9yMdPGkI4jydXxJOYt5PkoYQXuuvxNKovV
         vFAg==
X-Gm-Message-State: APjAAAVaUt4of8riQyqILlv2qhJGLakg2IcDPTY+L06VPu1MR1UiHhi6
        D+hHVDMYM5Cj3dTsznqK4bA=
X-Google-Smtp-Source: APXvYqweRFwLYD1YzcH+8o+vHooL43IMa8Qu6x4b+uHj1uQmVERPeMJ4ClvjfiV8YKDES/ckY8kDIA==
X-Received: by 2002:a17:90a:ba81:: with SMTP id t1mr16166868pjr.139.1573782605331;
        Thu, 14 Nov 2019 17:50:05 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::6ab4])
        by smtp.gmail.com with ESMTPSA id w15sm7407109pfn.13.2019.11.14.17.50.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 17:50:04 -0800 (PST)
Date:   Thu, 14 Nov 2019 17:50:02 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
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
Message-ID: <20191115015001.iyqipxhoqt77iade@ast-mbp.dhcp.thefacebook.com>
References: <70142501-e2dd-1aed-992e-55acd5c30cfd@solarflare.com>
 <874l07fu61.fsf@toke.dk>
 <aeae7b94-090a-a850-4740-0274ab8178d5@solarflare.com>
 <87eez4odqp.fsf@toke.dk>
 <20191112025112.bhzmrrh2pr76ssnh@ast-mbp.dhcp.thefacebook.com>
 <87h839oymg.fsf@toke.dk>
 <20191112195223.cp5kcmkko54dsfbg@ast-mbp.dhcp.thefacebook.com>
 <5dcb3f4e8be4_3202ae6af4ec5bcac@john-XPS-13-9370.notmuch>
 <20191113002058.bkch563wm6vhmn3l@ast-mbp.dhcp.thefacebook.com>
 <5dcb959eb9d15_6dcc2b08358745c0f9@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5dcb959eb9d15_6dcc2b08358745c0f9@john-XPS-13-9370.notmuch>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 09:33:18PM -0800, John Fastabend wrote:
> 
> In addition to above flow something like this to load libraries first should
> also work?
> 
>    // here fw2 is a library its never attached to anything but can be
>    // used to pull functions from
>    obj = bpf_object__open("fw2.o", attr);
>    bpf_object__load(obj);
>    prog = bpf_object__find_program_by_title(obj);
>    subprog_btf_id0 = libbpf_find_obj_btf_id("name of function", obj);
>    subprog_btf_id1 = libbpf_find_obj_btf_id("name of function", obj);
> 
>    // all pairs of (prog_fd, btf_id) need to be specified at load time
>    attr.attach[0].prog_fd = fw2_fd;
>    attr.attach[0].btf_id = subprog_btf_id0;
>    attr.attach[1].prog_fd = fw2_fd;
>    attr.attach[1].btf_id = subprog_btf_id1;
>    obj = bpf_object__open("rootlet.o", attr)
>    bpf_object__load(obj)
>    prog = bpf_object__find_program_by_title(obj);
>    link = bpf_program__replace(prog);
>    // attach rootlet.o at this point with subprog_btf_id

The point I'm arguing that these:
   attr.attach[0].prog_fd = fw2_fd;
   attr.attach[0].btf_id = subprog_btf_id0;
   attr.attach[1].prog_fd = fw2_fd;
   attr.attach[1].btf_id = subprog_btf_id1;
should not be part of libbpf api. Instead libbpf should be able to adjust
relocations inside the program. You're proposing to do linking via explicit
calls, I'm saying such linking should be declarative. libbpf should be able to
derive the intent from the program and patch calls.

Example:
helpers.o:
int foo(struct xdp_md *ctx, int var) {...}
int bar(int *array, bpf_size_t size) {...}
obj = bpf_object__open("helpers.o", attr)
bpf_object__load(obj);
// load and verify helpers. 'foo' and 'bar' are not attachable to anything.
// These two programs don't have program type.
// The kernel loaded and verified them.
main_prog.o:
int foo(struct xdp_md *ctx, int var);
int bar(int *array, bpf_size_t size);
int main_prog(struct xdp_md *ctx) 
{ 
  int ar[5], ret;
  ret = foo(ctx, 1) + bar(ar, 5);
}
// 'foo' and 'bar' are extern functions from main_prog pov.
obj = bpf_object__open("main_prog.o", attr)
bpf_object__load(obj);
// libbpf finds foo/bar in the kernel and adjusts two call instructions inside
// main_prog to point to prog_fd+btf_id

That is the second use case of dynamic linking I've been talking earlier. The
same thing should be possible to do with static linking. Then libbpf will
adjust calls inside main_prog to be 'call pc+123' and 'foo' and 'bar' will
become traditional bpf subprograms. main_prog() has single 'struct xdp_md *'
argument. It is normal attachable XDP program.

Loading main_prog.o first and then loading helpers.o should be possible as
well. The verifier needs BTF of extern 'foo' and 'bar' symbols to be able to
verify main_prog() independently. For example to check that main_prog() is
passing correct ctx into foo(). That is the main difference vs traditional
dynamic linking. I think we all agree that we want bpf programs to be verified
independently. To do that the verifier needs to have BTF (function prototypes)
of extern symbols. One can argue that it's not necessary and helpers.o can be
loaded first. I don't think that will work in all cases. There could be many
dependencies between helpers1.o calling another helpers2.o and so on and there
will be no good order where calling extern foo() can be avoided.

This thread is getting long :) and sounds like we're converging. I'm thinking
to combine everything we've discussed so far into dynamic/static linking doc.

