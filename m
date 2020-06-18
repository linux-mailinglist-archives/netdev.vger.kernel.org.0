Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE501FFDB3
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731660AbgFRWGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731651AbgFRWGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 18:06:19 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A367C06174E;
        Thu, 18 Jun 2020 15:06:19 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 10so3458005pfx.8;
        Thu, 18 Jun 2020 15:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=LAFncSfCGWvLRoCJ8bDyyKXciwSiLuc1buVG0qkSipE=;
        b=dyKvm0p8Xn8Ka8yXL4IqpnA9tpQuyPoTPA2kgTn0L65RV1h0W/95MZ/lo78FKYCEdm
         wE3UajDwIgRfHq6eA4Glx2md7CUpKtsU+ndaOSXMzHccUinr6PDa/NEZpKDJbfn5eDSR
         LvoB0Idcl4tYcs6qmUv9E6CiCC6y5cSzMvW3d+ZZItyGp7ATODmLz4CNU+UZc/t3DZWB
         wXd74sEpoCgkDuC2BohcB6utiC6wqWjBYHlk4PvcE61oovn752TpFQvljo9IY3cIWGxR
         h6UzM6pWg/5UQ9HBlkuFM12GWRd9uW6ybGyoYIAyiBSWWivaH9IqFO/ul4DFiHki1iua
         Hokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=LAFncSfCGWvLRoCJ8bDyyKXciwSiLuc1buVG0qkSipE=;
        b=hvUtCQ3uQ/CVb5oMblqO95aBPvdRCy5TFdq1/X2vffUaFNdqpbDoHXF8VV0M5WG7kV
         totH7ufLGcaEXCOpQQNqxGS+k1zHNmbeJf1ddrr1VZNzweY4E4U+6gVg2CsdkfLqev0B
         DjQmmTaygE+nlvwhODWnPyxplXjwDOh5zzIUJRxz6iO69guNAosRA3ky6GaxiApUIgP6
         fagvxc7LhciP87QYftP7BbO9VO51cBGKfyLdNDNt5lWZa2nKs2PN+8NmjWrV+trRGB+Z
         7B6+BrN7KW9HucPyIJdAmS8psxSG4EoM8Vw/qoG1fLldLAX28r7g0YZFHWAMBVUK5xGB
         grAw==
X-Gm-Message-State: AOAM533LMToEB451norC9QSrYIZvUBTmT1o5GKvRuUTadnJ8rLJtgr5c
        d3sHF0i5Rhsv0L6TjG0M8mJeWDlD1CE=
X-Google-Smtp-Source: ABdhPJxAPLxUaSW11bH8DjM9DwDGQrCDeR2AvCudxlzs16mZFVRoTA3eO74fTBahhX9WmXuHuP357w==
X-Received: by 2002:a63:591e:: with SMTP id n30mr538273pgb.429.1592517978456;
        Thu, 18 Jun 2020 15:06:18 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e5sm3234549pjv.18.2020.06.18.15.06.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 15:06:17 -0700 (PDT)
Date:   Thu, 18 Jun 2020 15:06:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        KP Singh <kpsingh@chromium.org>,
        Masanori Misono <m.misono760@gmail.com>
Message-ID: <5eebe552dddc1_6d292ad5e7a285b83f@john-XPS-13-9370.notmuch>
In-Reply-To: <20200618114806.GA2369163@krava>
References: <20200616173556.2204073-1-jolsa@kernel.org>
 <5eeaa556c7a0e_38b82b28075185c46a@john-XPS-13-9370.notmuch>
 <20200618114806.GA2369163@krava>
Subject: Re: [PATCH] bpf: Allow small structs to be type of function argument
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa wrote:
> On Wed, Jun 17, 2020 at 04:20:54PM -0700, John Fastabend wrote:
> > Jiri Olsa wrote:
> > > This way we can have trampoline on function
> > > that has arguments with types like:
> > > 
> > >   kuid_t uid
> > >   kgid_t gid
> > > 
> > > which unwind into small structs like:
> > > 
> > >   typedef struct {
> > >         uid_t val;
> > >   } kuid_t;
> > > 
> > >   typedef struct {
> > >         gid_t val;
> > >   } kgid_t;
> > > 
> > > And we can use them in bpftrace like:
> > > (assuming d_path changes are in)
> > > 
> > >   # bpftrace -e 'lsm:path_chown { printf("uid %d, gid %d\n", args->uid, args->gid) }'
> > >   Attaching 1 probe...
> > >   uid 0, gid 0
> > >   uid 1000, gid 1000
> > >   ...
> > > 
> > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > ---
> > >  kernel/bpf/btf.c | 12 +++++++++++-
> > >  1 file changed, 11 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> > > index 58c9af1d4808..f8fee5833684 100644
> > > --- a/kernel/bpf/btf.c
> > > +++ b/kernel/bpf/btf.c
> > > @@ -362,6 +362,14 @@ static bool btf_type_is_struct(const struct btf_type *t)
> > >  	return kind == BTF_KIND_STRUCT || kind == BTF_KIND_UNION;
> > >  }
> > >  
> > > +/* type is struct and its size is within 8 bytes
> > > + * and it can be value of function argument
> > > + */
> > > +static bool btf_type_is_struct_arg(const struct btf_type *t)
> > > +{
> > > +	return btf_type_is_struct(t) && (t->size <= sizeof(u64));
> > 
> > Can you comment on why sizeof(u64) here? The int types can be larger
> > than 64 for example and don't have a similar check, maybe the should
> > as well?
> > 
> > Here is an example from some made up program I ran through clang and
> > bpftool.
> > 
> > [2] INT '__int128' size=16 bits_offset=0 nr_bits=128 encoding=SIGNED
> > 
> > We also have btf_type_int_is_regular to decide if the int is of some
> > "regular" size but I don't see it used in these paths.
> 
> so this small structs are passed as scalars via function arguments,
> so the size limit is to fit teir value into register size which holds
> the argument
> 
> I'm not sure how 128bit numbers are passed to function as argument,
> but I think we can treat them separately if there's a need
> 

Moving Andrii up to the TO field ;)

Andrii, do we also need a guard on the int type with sizeof(u64)?
Otherwise the arg calculation might be incorrect? wdyt did I follow
along correctly.
