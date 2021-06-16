Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8DF3AA184
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 18:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhFPQkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 12:40:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhFPQkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 12:40:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623861521;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rV563dQo7m5y1S0K2xW4WWnPeVAJwFzr/pJdFlp2kRg=;
        b=WFWvYUtkFRDxtaAQgt4zn+4w2yFctTPLToDP6aUpge/vHoRyBSiI8EnXSy7IdCJ+tougcJ
        IDb1R85aAVL2Rz88PfOe4zDWM8aeCCgWs453euELxFnyVAoqkLK6I+8Adz7r6h/QX/2Na2
        ZCUnPHMCR6zHxoIfgxbA6olG67Y8LsA=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-469-QhSn9v8RPzC_pf0Z5LuG1A-1; Wed, 16 Jun 2021 12:38:39 -0400
X-MC-Unique: QhSn9v8RPzC_pf0Z5LuG1A-1
Received: by mail-ed1-f69.google.com with SMTP id z16-20020aa7d4100000b029038feb83da57so7422edq.4
        for <netdev@vger.kernel.org>; Wed, 16 Jun 2021 09:38:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rV563dQo7m5y1S0K2xW4WWnPeVAJwFzr/pJdFlp2kRg=;
        b=sYYOijUxFVzxM0QELXhnq6Q8t5COqsNezpLhBdxEb5dkO8gGGK4PJkOvOHHJYxx9nT
         r9JtMNnAqij0ZPHXHNfC2TAny1flYjHrhL594UReVj9HdqFyfjRDUZJ0nLHNFeXBdAJ7
         u13/SGSIwSU7+wKKquxvUNGSBMR3C+kO8s0cYmn+Kf2tuau5C36Gy2VMxJ8Wh0fakNOT
         23vz26cmk6g9LkVklptE+LM8Y9dCfodRTGC9VOSjDcU2SzoIkkF2JDa3pvt/hrAUWR5B
         TtvYEuGuAYWr5vDZikkIiIow5wLFkNaJHBm4YyfdkvKnPNquBvnNFwEWfgCN0dbNEoDE
         V0Cw==
X-Gm-Message-State: AOAM532rc00qSMAbzdJaWOBk2UgoOgPSMtizhxg/lU0rixLUhjZtuBGI
        uBUQZ9eJdRH1qhiyOlCosNPXgIle/0e0VpgqYjw3iDAHOAKvvvoWdZOoQCdcDihz7CzmPJlFLvH
        RshAPufsBaiYQs4HB
X-Received: by 2002:a17:906:144b:: with SMTP id q11mr426406ejc.478.1623861518437;
        Wed, 16 Jun 2021 09:38:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyxStRsLIlP9rxp/QI8AhSgSGsGy+DTj5KjZFu8fPauNQTeUOAENsFL+oSLy1pNIyZGWb3g6w==
X-Received: by 2002:a17:906:144b:: with SMTP id q11mr426379ejc.478.1623861518209;
        Wed, 16 Jun 2021 09:38:38 -0700 (PDT)
Received: from krava ([83.240.60.126])
        by smtp.gmail.com with ESMTPSA id r29sm2424547edc.52.2021.06.16.09.38.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Jun 2021 09:38:35 -0700 (PDT)
Date:   Wed, 16 Jun 2021 18:38:33 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Tony Ambardar <tony.ambardar@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Jiri Olsa <jolsa@kernel.org>, Frank Eigler <fche@redhat.com>,
        Mark Wielaard <mjw@redhat.com>
Subject: Re: [PATCH bpf v1] bpf: fix libelf endian handling in resolv_btfids
Message-ID: <YMopCb5CqOYsl6HR@krava>
References: <20210616092521.800788-1-Tony.Ambardar@gmail.com>
 <caf1dcbd-7a07-993c-e940-1b2689985c5a@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <caf1dcbd-7a07-993c-e940-1b2689985c5a@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 16, 2021 at 08:56:42AM -0700, Yonghong Song wrote:
> 
> 
> On 6/16/21 2:25 AM, Tony Ambardar wrote:
> > While patching the .BTF_ids section in vmlinux, resolve_btfids writes type
> > ids using host-native endianness, and relies on libelf for any required
> > translation when finally updating vmlinux. However, the default type of the
> > .BTF_ids section content is ELF_T_BYTE (i.e. unsigned char), and undergoes
> > no translation. This results in incorrect patched values if cross-compiling
> > to non-native endianness, and can manifest as kernel Oops and test failures
> > which are difficult to debug.

nice catch, great libelf can do that ;-)

> > 
> > Explicitly set the type of patched data to ELF_T_WORD, allowing libelf to
> > transparently handle the endian conversions.
> > 
> > Fixes: fbbb68de80a4 ("bpf: Add resolve_btfids tool to resolve BTF IDs in ELF object")
> > Cc: stable@vger.kernel.org # v5.10+
> > Cc: Jiri Olsa <jolsa@kernel.org>
> > Cc: Yonghong Song <yhs@fb.com>
> > Link: https://lore.kernel.org/bpf/CAPGftE_eY-Zdi3wBcgDfkz_iOr1KF10n=9mJHm1_a_PykcsoeA@mail.gmail.com/
> > Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> > ---
> >   tools/bpf/resolve_btfids/main.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/tools/bpf/resolve_btfids/main.c b/tools/bpf/resolve_btfids/main.c
> > index d636643ddd35..f32c059fbfb4 100644
> > --- a/tools/bpf/resolve_btfids/main.c
> > +++ b/tools/bpf/resolve_btfids/main.c
> > @@ -649,6 +649,9 @@ static int symbols_patch(struct object *obj)
> >   	if (sets_patch(obj))
> >   		return -1;
> > +	/* Set type to ensure endian translation occurs. */
> > +	obj->efile.idlist->d_type = ELF_T_WORD;
> 
> The change makes sense to me as .BTF_ids contains just a list of
> u32's.
> 
> Jiri, could you double check on this?

the comment in ELF_T_WORD declaration suggests the size depends on
elf's class?

  ELF_T_WORD,                   /* Elf32_Word, Elf64_Word, ... */

data in .BTF_ids section are allways u32

I have no idea how is this handled in libelf (perhaps it's ok),
but just that comment above suggests it could be also 64 bits,
cc-ing Frank and Mark for more insight

thanks,
jirka

> 
> > +
> >   	elf_flagdata(obj->efile.idlist, ELF_C_SET, ELF_F_DIRTY);
> >   	err = elf_update(obj->efile.elf, ELF_C_WRITE);
> > 
> 

