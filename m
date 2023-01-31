Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93C286838B7
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 22:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbjAaVeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 16:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbjAaVeB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 16:34:01 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73A6D28D35;
        Tue, 31 Jan 2023 13:34:00 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id d132so19916097ybb.5;
        Tue, 31 Jan 2023 13:34:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Bex9GgFK9X9Xksw4jkg93+WqmLepRNAqsl/ryrOCgaA=;
        b=LU6Au0EYECbR7tKLVHr3umh33ht0uGr6A31DerKVAE8/jxpHv5HSw6enaPhXhfEJfz
         x5xuVoMqccQHi2PIV/KWCQIGBj4fW1d2F/TQwa5Ibe0HDF6F5Vmn9B2Th0Bh9Nqn67we
         iHbjv+reD4VdgpEbSIgSivQ1Y9PNmUIP5YMVVpmwGy9o1baUYK8zoanJTVZPAsg6ZfpV
         X4774ZrGV4QExSDnsAxjoJ80NmPLCx/xkdLrT8Kbu8wJWrk9qrMtIh65l5QWPxXcSLaN
         7r6rwruracH3kRkbD1giTC2N4kQI8nbq/FhWhrvUA6tpEAEAnA8w99ZlKYoE6jZa7iUV
         DqvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Bex9GgFK9X9Xksw4jkg93+WqmLepRNAqsl/ryrOCgaA=;
        b=ZQ3YAFwWx5R2nCcQ1jzc9wGg4lrjoiFTkZ+zavXcIrEch1189f/dod86VwRv/OOA3L
         u0r5foB7CPKTe9kEszYIxrn+KGAAri36zkULbWTqxe/zoLc5iCpxFHv+bcup/7JUvZY7
         0O/KkzZZy5xPGkVrCZPTVZ3l0DGngw3mxaqMRPvh6BcIldjQ+U4tHHAP2mkf23Pi6VLl
         War7Mvsae8suNq2QyK9mk5tp59mMXyLQXHzWEPtmKcGWq+G/rwT61PS5QVt+vWPnR2Kl
         m3dhQfo5nfea3pojryqFDj1Uroml+10DpPNJy4WX38YQeG64xskAOzzV6JoQaTtNOV+O
         cILw==
X-Gm-Message-State: AO0yUKUZC/J7GJC7937DI4TZ1ya/U73q//CKegEVRdYEyEqW9Xxe2Q04
        HXkQE+WfFwioB+eLQOi5zJBYIiPwKry5GOBLH+UERuA+ZJE=
X-Google-Smtp-Source: AK7set+PfM0lAh9orNmDXrDVUnIRwd9P44LzKOBw0IEOPR9+L28XZ/dLQu5W20aWtjQ7aSaNO5GcXNZf8mXA/iYD0kI=
X-Received: by 2002:a25:2515:0:b0:727:e539:452f with SMTP id
 l21-20020a252515000000b00727e539452fmr45508ybl.552.1675200839600; Tue, 31 Jan
 2023 13:33:59 -0800 (PST)
MIME-Version: 1.0
References: <20230127191703.3864860-1-joannelkoong@gmail.com>
 <20230127191703.3864860-4-joannelkoong@gmail.com> <5715ea83-c4aa-c884-ab95-3d5e630cad05@linux.dev>
 <20230130223141.r24nlg2jp5byvuph@macbook-pro-6.dhcp.thefacebook.com>
 <CAEf4Bzb9=q9TKutW8d7fOtCWaLpA12yvSh-BhL=m3+RA1_xhOQ@mail.gmail.com>
 <CAJnrk1Y9jf7PQ0sHF+hfW0TD+W8r3WzJCu-pJjT3zsZCGt343w@mail.gmail.com>
 <CAADnVQJ9Pb10boAR=ZVaXOJwjHPkFXKn9n9RWrzXgK3GaQ1N0g@mail.gmail.com>
 <CAJnrk1a2SY5NqhibczOhd+jqL3W9U1rbTeiQpYw-oUS8_Cr1_g@mail.gmail.com> <CAADnVQ+N76ed0h9GJyQfVQiN2pmcqJdjeM5rOPdFv2LfZ9eahQ@mail.gmail.com>
In-Reply-To: <CAADnVQ+N76ed0h9GJyQfVQiN2pmcqJdjeM5rOPdFv2LfZ9eahQ@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Tue, 31 Jan 2023 13:33:48 -0800
Message-ID: <CAJnrk1YuCUKUmG0s_maz_ZNNCxWhcut-29qmaXghLotqyq2fFA@mail.gmail.com>
Subject: Re: [PATCH v9 bpf-next 3/5] bpf: Add skb dynptrs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Kernel Team <kernel-team@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 1:11 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Tue, Jan 31, 2023 at 12:48 PM Joanne Koong <joannelkoong@gmail.com> wrote:
> > > > >
> > > > > p = bpf_dynptr_slice(dp, off, 16, buf);
> > > > > if (p == NULL) {
> > > > >    /* out of range */
> > > > > } else {
> > > > >    /* work with p directly */
> > > > > }
> > > > >
> > > > > /* if we wrote something to p and it was copied to buffer, write it back */
> > > > > if (p == buf) {
> > > > >     bpf_dynptr_write(dp, buf, 16);
> > > > > }
> > > > >
> > > > >
> > > > > We'll just need to teach verifier to make sure that buf is at least 16
> > > > > byte long.
> > > >
> > > > I'm confused what the benefit of passing in the buffer is. If it's to
> > > > avoid the uncloning, this will still need to happen if the user writes
> > > > back the data to the skb (which will be the majority of cases). If
> > > > it's to avoid uncloning if the user only reads the data of a writable
> > > > prog, then we could add logic in the verifier so that we don't pull
> > > > the data in this case; the uncloning might still happen regardless if
> > > > another part of the program does a direct write. If the benefit is to
> > > > avoid needing to pull the data, then can't the user just use
> > > > bpf_dynptr_read, which takes in a buffer?
> > >
> > > There is no unclone and there is no pull in xdp.
> > > The main idea of this semantics of bpf_dynptr_slice is to make it
> > > work the same way on skb and xdp for _read_ case.
> > > Writes are going to be different between skb and xdp anyway.
> > > In some rare cases the writes can be the same for skb and xdp
> > > with this bpf_dynptr_slice + bpf_dynptr_write logic,
> > > but that's a minor feature addition of the api.
> >
> > bpf_dynptr_read works the same way on skb and xdp. bpf_dynptr_read
> > takes in a buffer as well, so what is the added benefit of
> > bpf_dynptr_slice?
>
> That it doesn't copy most of the time.

Ohh I see, I missed that bpf_dynptr_slice also returns back a ptr.
This makes sense to me now, thanks for clarifying.
