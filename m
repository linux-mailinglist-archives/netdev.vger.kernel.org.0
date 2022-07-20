Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCA6157B8FA
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 16:54:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241010AbiGTOye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 10:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240821AbiGTOyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 10:54:33 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C43ED1F2D1;
        Wed, 20 Jul 2022 07:54:32 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n12so13638418wrc.8;
        Wed, 20 Jul 2022 07:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=yt+ngO8tmWj/KwQcOUTeK5RaJ2ek4CEzrTIRXEZHAOs=;
        b=RWgbiuU/cvPX+h0opH2QrKUcF1f35fLSeVIBPTODegHvcQF1C1Gac5Xj4lEiH7z+aw
         aqixvLfNXF0egWiZWeklp84n8XhYxK3u1bUG47zEDPz7woIa6PkxxGm7VEN9iz2JcIea
         uCHaWLZSI2FPoIHZtT7gnAoomuie9FmTCrnDitK86iEBau1xL2dG8bQ2HdPMuptOn7PG
         wFJ3oUw0i05d2GQV5Q75ZZxX93wN7rxvn2K0V2KN/COcaPilsQmyUPhAuvJywOBD+wk5
         +twk6DST3iNAOVBzNkfGYFO+uabyqoqzSK9j7Fd4eyCy4mkKmgxcEg0foxtN4bI5hBzm
         CKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=yt+ngO8tmWj/KwQcOUTeK5RaJ2ek4CEzrTIRXEZHAOs=;
        b=tsQ8tYTjrXYtoaWrO7rkyGkAJOJw+wZEqYB1rNGb2h8pt69Og/lIVbsz3Vm8u1riym
         u9Y1KmJoK3+U1nVHBR5YANh0eiT5MWMJylBhT/JO2VtcPcjIJs48UnAub5R68WOxH+N5
         bxeSykIBAl/+Q7uuW/uNSiZ5HJaLhSwMvHoAKr84Ws6T49qUHRrPfm77YpwfwUg0lZ5w
         kaJuNiXNQXAB4uwp3QR2XDmbTXavqh3Sr7k0g+V5o/9AaZ4UQAKQIGAoyUiNdaz2b0M4
         p1vF0JOx9aIkUuUfPWLVCc76LnPOmTYU/cIfS19c/cWCUL+BEZWvYQu3l++/0iIAGNQm
         cqug==
X-Gm-Message-State: AJIora+JFsxC5xWaNMeJ8zFZO0IQLTQcvDLNPoyVfdEI5dd+9YvMYkg6
        qiYY/kMqwsFcSUIs2Rue66U4dRfsf+ek2D37DvE=
X-Google-Smtp-Source: AGRyM1u2P5XbvgKRTsW66zBf0bTO0ggXnr+RwjXdB2tcSNL9DspNLx9EDuFXv7g/hzXtCaAHKIODXoPbI4So8lly2TY=
X-Received: by 2002:a5d:5f05:0:b0:21d:9ad7:f281 with SMTP id
 cl5-20020a5d5f05000000b0021d9ad7f281mr32547285wrb.4.1658328871258; Wed, 20
 Jul 2022 07:54:31 -0700 (PDT)
MIME-Version: 1.0
References: <20220715125013.247085-1-mlombard@redhat.com> <5a469c5a.8b85.1821171d9de.Coremail.chen45464546@163.com>
 <CAFL455nnc04q8TohH+Qbv36Bo3=KKxMWr=diK_F5Ds5K-h5etw@mail.gmail.com>
 <22bf39a6.8f5e.18211c0898a.Coremail.chen45464546@163.com> <CAFL455mXFY5AFOoXxhpUY6EkPzc1677cRPQ8UX-RSykhm_52Nw@mail.gmail.com>
 <CAKgT0Uejy66aFAdD+vMPYFtSu2BWRgTxBG0mO+BLayk3nNuQMw@mail.gmail.com> <8a7e9cf.1b9.18218925734.Coremail.chen45464546@163.com>
In-Reply-To: <8a7e9cf.1b9.18218925734.Coremail.chen45464546@163.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 20 Jul 2022 07:54:18 -0700
Message-ID: <CAKgT0Ueq=9XGW4uySmDj1sa9MYosaF4S6Na_jcVyiofW_TqgwA@mail.gmail.com>
Subject: Re: Re: Re: [PATCH V3] mm: prevent page_frag_alloc() from corrupting
 the memory
To:     Chen Lin <chen45464546@163.com>
Cc:     Maurizio Lombardi <mlombard@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 3:27 PM Chen Lin <chen45464546@163.com> wrote:
>
> At 2022-07-18 23:33:42, "Alexander Duyck" <alexander.duyck@gmail.com> wro=
te:
> >On Mon, Jul 18, 2022 at 8:25 AM Maurizio Lombardi <mlombard@redhat.com> =
wrote:
> >>
> >> po 18. 7. 2022 v 16:40 odes=C3=ADlatel Chen Lin <chen45464546@163.com>=
 napsal:
> >> >
> >> > But the original intention of page frag interface is indeed to alloc=
ate memory
> >> > less than one page. It's not a good idea to  complicate the definiti=
on of
> >> > "page fragment".
> >>
> >> I see your point, I just don't think it makes much sense to break
> >> drivers here and there
> >> when a practically identical 2-lines patch can fix the memory corrupti=
on bug
> >> without changing a single line of code in the drivers.
> >>
> >> By the way, I will wait for the maintainers to decide on the matter.
> >>
> >> Maurizio
> >
> >I'm good with this smaller approach. If it fails only under memory
> >pressure I am good with that. The issue with the stricter checking is
> >that it will add additional overhead that doesn't add much value to
> >the code.
> >
> >Thanks,
> >
>
> >- Alex
>
> One additional question=EF=BC=9A
> I don't understand too much about  why point >=EF=BC=A1<  have more overh=
ead than point >B<.
> It all looks the same, except for jumping to the refill process, and the =
refill is a very long process.
> Could you please give more explain=EF=BC=9F
>
>         if (unlikely(offset < 0)) {
>                  -------------->=EF=BC=A1<------------

In order to verify if the fragsz is larger than a page we would have
to add a comparison between two values that aren't necessarily related
to anything else in this block of code.

Adding a comparison at this point should end up adding instructions
along the lines of
        cmp $0x1000,%[some register]
        jg <return NULL block>

These two lines would end up applying to everything that takes this
path so every time we hit the end of a page we would encounter it, and
in almost all cases it shouldn't apply so it is extra instructions. In
addition they would be serialized with the earlier subtraction since
we can't process it until after the first comparison which is actually
using the flags to perform the check since it is checking if offset is
signed.

>                 page =3D virt_to_page(nc->va);
>
>                 if (!page_ref_sub_and_test(page, nc->pagecnt_bias))
>                         goto refill;
>
>                 if (unlikely(nc->pfmemalloc)) {
>                         free_the_page(page, compound_order(page));
>                         goto refill;
>                 }
>
> #if (PAGE_SIZE < PAGE_FRAG_CACHE_MAX_SIZE)
>                 /* if size can vary use size else just use PAGE_SIZE */
>                 size =3D nc->size;
> #endif
>                 /* OK, page count is 0, we can safely set it */
>                 set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1);
>
>                 /* reset page count bias and offset to start of new frag =
*/
>                 nc->pagecnt_bias =3D PAGE_FRAG_CACHE_MAX_SIZE + 1;
>                 offset =3D size - fragsz;
>                  -------------->B<------------

At this point we have already excluded the shared and pfmemalloc
pages. Here we don't have to add a comparison. The comparison is
already handled via the size - fragsz, we just need to make use of the
flags following the operation by checking to see if offset is signed.

So the added assembler would be something to the effect of:
        js <return NULL block>

In addition the assignment operations there should have no effect on
the flags so the js can be added to the end of the block without
having to do much in terms of forcing any reordering of the
instructions.
