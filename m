Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F5944587D
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233881AbhKDRhq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:37:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231667AbhKDRhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 13:37:45 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A250DC061714;
        Thu,  4 Nov 2021 10:35:07 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id v7so16363162ybq.0;
        Thu, 04 Nov 2021 10:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HXMmxerWsHoAig78gXzz6FMUQTXAAZJzxN8/uFzHHBM=;
        b=BPafI1z3T/ADJ3SE5KwmpwdBChiWzglBJywq/CDW7bG9rp+/VUQIwlfeD4IpTd0EUj
         hX+Kebwh+pn0V84WmmMWPhEdDqqiNvebfE7Bziz1nuHBMIKwSycGFYxAl/2a5v4wehun
         y7hX6ABf3phyynw6+kGo58niQlWzRbSv2cEBvosaRKcBgwxrD0FXYYJPzaZiFVXsTwH6
         J6r92hhmTVaRW1gB9Su0DQQOpjUnfM5GdWii4Y8Y3hdOVJeRR4C9efhA28uajoXbqc/G
         8nvMxdbX3yBipZWbAU1kcEFAPV4gwa4pBELzieYKfPAhGQnAUMKUKPddl/yxCeUllF6b
         eIcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HXMmxerWsHoAig78gXzz6FMUQTXAAZJzxN8/uFzHHBM=;
        b=QQnN3/iolEEn1rwtt5ME8Iv/OdOU7gS8gM5yWKOB/CXxai+L+I/jNWnnxyfBc1DYZs
         HdhWv9HRpR2vFCW5+KEgouxWScacfCfQ4TRymsi/ekBF6bmRFWsioiA5Ff4r2UMajI73
         fAAIqpdw/9LHr7PBzsx5aNqLfOs9nsaSb6hQyWz6mwKDn/mex7S4FZc9+5J9idbnHSPa
         KGcPD190Yu4WHxP1WT/OU5QMJN/OPXOpguqgn/53cHneF+kLmyw6xR8V82ErIUOrR0ud
         5sZlbQdXkHt/NjJS3YmkgfqgSSpXKXRzEMZrywjPjPkE8vyO2FDwUdGM1O+2J3it615I
         O7Kw==
X-Gm-Message-State: AOAM531VVqoziG4MdBlk2w1eVr2+RXsdwg2HoN+40ET2YFGRsWDIrAto
        zhYvBIC3pbrgSO698DO4z/Z/Q9gTzdtL24CSZT4=
X-Google-Smtp-Source: ABdhPJzw/R4ALi8F6XZhYhFGdn9amaBDivjO/FThrVioSA532x6T2BNbGQzOhZg0Y6R57O22sPKS/nDfqXjubXAd8NM=
X-Received: by 2002:a25:d187:: with SMTP id i129mr45038538ybg.2.1636047306789;
 Thu, 04 Nov 2021 10:35:06 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
 <CAHap4zt7B1Zb56rr55Q8_cy8qdyaZsYcWt7ZHrs3EKr50fsA+A@mail.gmail.com>
 <CAEf4BzbDBGEnztzEcXmCFMNyzTjJ3pY41ahzieu9yJ+EDHU0dg@mail.gmail.com>
 <CAHap4zutG7KXywstCHcTbATN8iVCKuN84ZHxLfdsXDJS9sDmEA@mail.gmail.com>
 <CAEf4BzbALXu7ucrVcNdT38od5fU2Cd9qMncbXGJGe-KG1NOdNw@mail.gmail.com> <CAHap4zvYaj9pnmgMLa9-B+3sbypj=OA0smrsJewyP+T-rsDtWA@mail.gmail.com>
In-Reply-To: <CAHap4zvYaj9pnmgMLa9-B+3sbypj=OA0smrsJewyP+T-rsDtWA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 4 Nov 2021 10:34:55 -0700
Message-ID: <CAEf4BzbW-fYc2dqL4VvC7saBGyHNw0LF4F9Otgd+ozqOk8ERXg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] libbpf: Implement BTF Generator API
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 4, 2021 at 7:58 AM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> > > ```
> > > /* reduced version of struct bpf_core_spec */
> > > struct bpf_core_spec_pub {
> > > const struct btf *btf;
> > > __u32 root_type_id;
> > > enum bpf_core_relo_kind kind;
> > > /* raw, low-level spec: 1-to-1 with accessor spec string */ --> we ca=
n
> > > also use access_str_off and let the user parse it
> > > int raw_spec[BPF_CORE_SPEC_MAX_LEN];
> >
> > string might be a more "extensible" way, but we'll need to construct
> > that string for each relocation
> >
> > > /* raw spec length */
> > > int raw_len;
> >
> > using string would eliminate the need for this
> >
> > > };
> > >
> > > struct bpf_core_relo_pub {
> > > const char *prog_name; --> if we expose it by program then it's not n=
eeded.
> >
> > yep, not sure about per-program yet, but that's minor
> >
> > > int insn_idx;
> > >
> > > bool poison; --> allows the user to understand if the relocation
> > > succeeded or not.
> > >
> > > /* new field offset for field based core relos */
> > > __u32 new_offset;
> > >
> > > // TODO: fields for type and enum-based relos
> >
> > isn't it always just u64 new_value for all types of relos? We can also
> > expose old_value just for completeness
> >
>
> Oh right. We can expose new_val, orig_val and let the user interpret
> their meaning based on the relo_kind.

yep

>
> > >
> > > struct bpf_core_spec_pub local_spec, targ_spec; --> BTFGen only needs
> > > targ_spec, I suppose local spec would be useful for other use cases.
> >
> > targ_spec doesn't seem necessary given we have root_type_id, relo
> > kind, access_string (or raw_spec). What am I missing?
> >
>
> Not sure I follow. root_type, relo kind and access_string are all part
> of bpf_core_spec_pub, there are two instances of this structure,
> targ_spec and local_spec.

Ah, ok, I got a bit confused by the formatting of your response. I got
the impression that we are exposing the same thing twice (and I'm not
talking about local vs target). So never mind.
