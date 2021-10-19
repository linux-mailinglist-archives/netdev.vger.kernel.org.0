Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB7C0432AA6
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 02:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233627AbhJSADP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 20:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233662AbhJSADN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 20:03:13 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DA93C06161C;
        Mon, 18 Oct 2021 17:01:01 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id y7so16040668pfg.8;
        Mon, 18 Oct 2021 17:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CsvmshUK1J5oLgHlkNzVwU1CrFBDnoDJiUW4z7Gb9/k=;
        b=UJWjY63bLaZzldwpkWRcKrmeXvsgYJu0Z59gypu6tOjd8wMJ5EYIeKpAkJ05nRmxzQ
         yWYhvBpAcwi4K0JIFAMep9yV1a4DHcJwAx6N0Pumx9FG8aHHuUzM/u8N/d+hg8A4UqoV
         4+kyLwF7MjLr7dv9YW/DMDiVQtem48XRPKRwF2Qn5kNOqzRDF2dfCPAK1/jS7eph+dXU
         ldDdt4X1KZNm+yOEc+oRs+qrHeEkv4N6TaY1qTM5t6BKa7zC1G3NodhgSnfRBsi3Dxu+
         nvxYl//ZiWslR+d9vub/OMCLrczrN7Cpbg7LzT4UQhR5AvY2MaHg2VvJ5hlfMcjUGLRs
         wK5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CsvmshUK1J5oLgHlkNzVwU1CrFBDnoDJiUW4z7Gb9/k=;
        b=wyaF9ZOnu8yOQt9sObUoUg6OCpLMSkj6AsZdOiPfTH+2uhKnKMN1d6bANbTylzWcIh
         Tw/eYSyoiuU5+yYom/4JU3cLWNd7NFx18NxzqyZ1HwZ+F1PpCaAZP71GFllK5vj41QyJ
         lLvKYCqAP5hvnmkXrRBNqF58k5BcsiBlOmdVVXIRYR464ACj3a6Xysf0WujZcjM6+dAr
         NISiHCe773czbBDpNK3hQPWEn2cgzAFp3QkqTmfg/d64gfCRGZ0BXBp4lWAoe9SXKfrY
         wOFsOhEFoBqNkXchLxDIzNpFkuwqvQ5vkzYAhoG8h1M3SUuhRoxhFMVdThYFFhQ9AG9G
         9kSg==
X-Gm-Message-State: AOAM530oZlxgGCd6gxyUEaLEoyxtWtbhlEksr1W1Hquc7HoOj17lbDKq
        MT4yi+2/D9ufLpzlof/6YCo=
X-Google-Smtp-Source: ABdhPJz2uYeVgr44Dl+rmwluHMNM5vtCNcpNBtKHRctEMRzWIOonaskLJb2hbvfRXV5kjo3nNzTlwQ==
X-Received: by 2002:a63:1d25:: with SMTP id d37mr26010213pgd.52.1634601660981;
        Mon, 18 Oct 2021 17:01:00 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:f01f])
        by smtp.gmail.com with ESMTPSA id mi8sm556618pjb.20.2021.10.18.17.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 17:01:00 -0700 (PDT)
Date:   Mon, 18 Oct 2021 17:00:58 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Joanne Koong <joannekoong@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Kernel-team@fb.com
Subject: Re: [PATCH bpf-next v2 0/3] Add XDP support for bpf_load_hdr_opt
Message-ID: <20211019000058.ghklvg4saybzqk3o@ast-mbp>
References: <20211006230543.3928580-1-joannekoong@fb.com>
 <87h7dsnbh5.fsf@toke.dk>
 <9f8c195c-9c03-b398-2803-386c7af99748@fb.com>
 <43bfb0fe-5476-c62c-51f2-a83da9fef659@iogearbox.net>
 <20211007235203.uksujks57djohg3p@kafai-mbp>
 <87lf33jh04.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87lf33jh04.fsf@toke.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 12:20:27AM +0200, Toke Høiland-Jørgensen wrote:
> 
> So if we can't fix the verifier, maybe we could come up with a more
> general helper for packet parsing? Something like:
> 
> bpf_for_each_pkt_chunk(ctx, offset, callback_fn, callback_arg)
> {
>   ptr = ctx->data + offset;
>   while (ptr < ctx->data_end) {
>     offset = callback_fn(ptr, ctx->data_end, callback_arg);
>     if (offset == 0)
>       return 0;
>     ptr += offset;
>   }
>   
>   // out of bounds before callback was done
>   return -EINVAL;
> }

We're starting to work on this since it will be useful not only for
packet parsing, TLV parsing, but potentially any kind of 'for' loop iteration.

> This would work for parsing any kind of packet header or TLV-style data
> without having to teach the kernel about each header type. It'll have
> quite a bit of overhead if all the callbacks happen via indirect calls,
> but maybe the verifier can inline the calls (or at least turn them into
> direct CALL instructions)?

Right. That's the main downside.
If the bpf_for_each*() helper is simple enough the verifier can inline it
similar to map_gen_lookup. In such case the indirect call will be a direct call,
so the overhead won't be that bad, but it's still a function call and
static function will have full prologue+epilogue.
Converting static function into direct jump would be really challenging
for the verifier and won't provide much benefit, since r6-r9 save/restore
would need to happen anyway even for such 'inlined' static func, since
llvm will be freely using r6-r9 for insns inside function body
assuming that it's a normal function.

May be there is a way to avoid call overhead with with clang extensions.
If we want to do:
int mem_eq(char *p1, char *p2, int size)
{
  int i;
  for (i = 0; i < size; i++)
    if (p1[i] != p2[i])
      return 0;
  return 1;
}

With clang extension we might write it as:
int bpf_mem_eq(char *p1, char *p2, int size)
{
  int i = 0;
  int iter;

  iter = __builtin_for_until(i, size, ({
      if (p1[i] != p2[i])
        goto out;
  }));
  out:
  if (iter != size)
    return 0;
  return 1;
}

The llvm will generate pseudo insns for this __builtin_for.
The verifier will analyze the loop body for the range [0, size)
and replace pseudo insns with normal branches after the verification.
We might even keep the normal C syntax for loops and use
llvm HardwareLoops pass to add pseudo insns.
It's more or less the same ideas for loops we discussed before
bounded loops were introduced.
The main problem with bounded loops is that the loop body will
typically be verified the number of times equal to the number of iterations.
So for any non-trivial loop such iteration count is not much more
than 100. The verifier can do scalar evolution analysis, but
it's likely won't work for many cases and user experience
will suffer. With __builtin_for the scalar evolution is not necessary,
since induction variable is one and explicit and its range is explicit too.
That enables single pass over loop body.
One might argue that for (i = 0; i < 10000; i += 10) loops are
necessary too, but instead of complicating the verifier with sparse
ranges it's better to put that on users that can do:
  iter = __builtin_for_until(i, 10000 / 10, ({
      j = i * 10;
      use j;
  }));
Single explicit induction variable makes the verification practical.
The loop body won't be as heavily optimized as normal loop,
but it's a good thing.
