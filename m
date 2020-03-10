Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95DD61807EB
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 20:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgCJTYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 15:24:49 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37635 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726497AbgCJTYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 15:24:48 -0400
Received: by mail-pl1-f194.google.com with SMTP id f16so3685052plj.4;
        Tue, 10 Mar 2020 12:24:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=an1zJNlOWuUIz2oNaVfrUBr4Ao72myPWF081MtHFXEI=;
        b=QqP8ZvmM8VUK6EFmRJwqSTwVbEkNmGufxoM1zZxVm0uHbdNSXdslvh9Rx5/2mEwJB6
         LQ6i0uv/Bv27kk8+7pRQSXGI3m62GQ9MVwIXUZrbzED4nGmeBgaMoAKEyMPgAlibBMAk
         lxAD3WqGW6QP67J5BdNhXyoT26oQk8PDgBGAKgqT1yb9DHsgez+rLe8hLEkO7ZCOr4Hd
         N4JpRf+n1y+QxizAXu1QhwAzi5UUSmUUn2n+zLGUDaxuZQnoTLi86ZCfIBk8nDq+eVb1
         pjM6lOn6usakAL6uBrA19CxnGqbeOdHSkApEvILGR4D62Bym0gTcRelSYLIhUbT9mIk0
         O5OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=an1zJNlOWuUIz2oNaVfrUBr4Ao72myPWF081MtHFXEI=;
        b=qhDUcMz1n5cz2+XehpvzFLACwTJ4Tuzb+ZfSdbNVPnqSPCHnpL0S68bWE1J61t6cIh
         1oNQUC8ZiS6NsfDgTwMQPrpF00segNKy7+ED0sMoicfnTtOSJDCeCeOfrpqbjAe8WG+P
         zefgDc5KN0pOphUusAOfQT51T277EGis22pwcX5JIXsMa66doOJdxHy+cXDuZP7V5p3n
         G8FJU2gnYLKd4weDfq9o0zUqU2xi1orny3Ur/bkKvO4K/6qc3DUM6sV/So+FOAf2csvt
         SBnOQ5sqVh7K4SCqMye03keDT6qpgYfwhHB/0jpvgZk5wF5W1LWgAb9Fwq04mPXZHZNO
         jlIA==
X-Gm-Message-State: ANhLgQ0lvFk6E+0ZCQ1gsmjnnAPIaR94+dU0vEqGi5lveE4lzWmyUdfy
        POHmhNirTS2iE25U6MdV5Wg=
X-Google-Smtp-Source: ADFU+vu6SjkMXfaKScuq1VfqFqaWGPjshNRVZidOq8PW6NUqBG4gaZU5pApbn+H/724K9pYPr1YrYQ==
X-Received: by 2002:a17:90a:48:: with SMTP id 8mr3338757pjb.84.1583868287703;
        Tue, 10 Mar 2020 12:24:47 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p14sm45789719pgm.49.2020.03.10.12.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 12:24:47 -0700 (PDT)
Date:   Tue, 10 Mar 2020 12:24:39 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     yhs@fb.com, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Message-ID: <5e67e977eb4f_586d2b10f16785b8f5@john-XPS-13-9370.notmuch>
In-Reply-To: <3f80b587-c5b0-0446-8cbc-eff1758496e9@solarflare.com>
References: <158353965971.3451.14666851223845760316.stgit@ubuntu3-kvm2>
 <158353986285.3451.6986018098665897886.stgit@ubuntu3-kvm2>
 <20200309235828.wldukb66bdwy2dzd@ast-mbp>
 <3f80b587-c5b0-0446-8cbc-eff1758496e9@solarflare.com>
Subject: Re: [RFC PATCH 2/4] bpf: verifier, do explicit u32 bounds tracking
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Edward Cree wrote:
> On 09/03/2020 23:58, Alexei Starovoitov wrote:> Thinking about it diffe=
rently... var_off is a bit representation of
> > 64-bit register. So that bit representation doesn't really have
> > 32 or 16-bit chunks. It's a full 64-bit register. I think all alu32
> > and jmp32 ops can update var_off without losing information.
> Agreed; AFAICT the 32-bit var_off should always just be the bottom
>  32 bits of the full var_off.

This seems to work.


> In fact, it seems like the only situations where 32-bit bounds are
>  needed are (a) the high and low halves of a 64-bit register are
>  being used separately, so e.g. r0 =3D (x << 32) | y with small known
>  bounds on y you want to track, or (b) 32-bit signed arithmetic.
> (a) doesn't seem like it's in scope to be supported, and (b) should
>  (I'm na=C3=AFvely imagining) only need the s32 bounds, not the u32 or
>  var32.

I guess I'm not opposed to supporting (a) it seems like it should
be doable.

For (b) the primary reason is to keep symmetry between 32-bit and
64-bit cases. But also we could have mixed signed 32-bit comparisons
which this helps with.

Example tracking bounds with [x,y] being signed 32-bit
bounds and [x',y'] being unsigned 32-bit bounds.

    r1 =3D #                   [x,y],[x',y']
    w1 >    0 goto pc+y      [x,y],[1 ,y']
    w1 s> -10 goto pc+x      [-10,y],[1 ,y']

We can't really deduce much from that in __reg_deduce_bounds so
we get stuck with different bounds on signed and unsigned space.
Same case as 64-bit world fwiw. I guess we could do more work
and use 64-bit/32-bit together and deduce something but I find
this more work than its worth. Keeping separate signed/unsigned
makes things easy.

> =

> John Fastabend wrote:
> > For example, BPF_ADD will do a tnum_add() this is a different
> > operation when overflows happen compared to tnum32_add(). Simply
> > truncating tnum_add result to 32-bits is not the same operation.
> I don't see why.  Overflows from the low (tracked) 32 bits can only
>  affect the high 32.
>  Truncation should be a homomorphism from
>  Z_2^n to Z_2^m wrt. both addition and multiplication, and tnums
>  are just (a particular class of) subsets of those rings.

Agreed, no need for 32bit ops on tnums.

> Can you construct an example of a tnum addition that breaks the
>  homomorphism?

no, I'm convinced. There seems to be a proof that the above is
true if n>m.

> =

> -ed


