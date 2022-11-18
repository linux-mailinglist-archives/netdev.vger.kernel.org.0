Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAF562FDF6
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 20:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbiKRT0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 14:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235205AbiKRT0S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 14:26:18 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B606E554
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 11:26:17 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id bs21so10775665wrb.4
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 11:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UiYdwUovpj+8zYq76hNMqjsM7Wc7EJzxAYy9GseHgc8=;
        b=IDCooI4WAbZISxUFtZOrYGVvhXBAluTbL1+il2TfhpAMze03xtPnq/fpgIEtdVxJmT
         yKGRn/bj4b/2xouT+1j4SnbM8IpGmjMe9OXONpnpbAMN1hjJ1fWZVHgI3WZUN/VVkBdd
         1szyDU1MEiusTQWjJceMrKHM4fWuYDUCdz+6++adcCaMeJZ3Lozh7Mo1XEDW06xT9DEH
         ULy0lXGHuK/otetRQByrGibWztLEkaWl25h6ACnfs7GkbJt0iVED652oU2z1N9pTUjSf
         ShdYCjbchI04ofELXbxt+S9S1nhCg1m1cuE0LcsdgieGxPiGhcVsWSfT48M2SJ0Rcxus
         2hWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UiYdwUovpj+8zYq76hNMqjsM7Wc7EJzxAYy9GseHgc8=;
        b=0ZjiIdo1hxgTP5cT2QJcSHps05pjsr6kl8zAfzCzJK4AEuWbOA2U/MU2M0anCehoC1
         7TB/BD94d2vg0Y0SbpUtxq2y8EmqdG7/NTc9i3r3XPGiekm4Au3rn+gipbUJkYsQ4Inw
         eI42S2oC/KZRFAFhA1360hqBKfKOPl/uvIxi1irwVZt/pHw3AAwHsEbuqho+p1+KAFwm
         96uFB6p0qDNazH+IldoP9SD6tCmYgvO9QS02cOgTUwxTcPwj2pu7+l7D3U1kEPIPdgQb
         B3JfM2Nx+a3v1CefYeoWNcuWb5HF13X1xP6YXLdl29QBd95C/iQniJk21mPWN1Gf2i1K
         ikqg==
X-Gm-Message-State: ANoB5pks2MIVyrSRaD7RyXz2xGj1RNG4EGf8A3ggeknrxVx+SlX8CH5X
        WNeKuFUKZIi6MLCGF7+WnxbTJux/4c0=
X-Google-Smtp-Source: AA0mqf6p0ODQSdh89OtlDrtJTcL6rnbRWzynKB8w7EB8DisrAiIVU8DjHBr38jMTyocJFyNYjFXyaw==
X-Received: by 2002:a5d:6512:0:b0:241:c221:c191 with SMTP id x18-20020a5d6512000000b00241c221c191mr2536915wru.279.1668799575118;
        Fri, 18 Nov 2022 11:26:15 -0800 (PST)
Received: from suse.localnet (host-79-26-100-208.retail.telecomitalia.it. [79.26.100.208])
        by smtp.gmail.com with ESMTPSA id c9-20020a5d5289000000b00236545edc91sm4226764wrv.76.2022.11.18.11.26.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 11:26:14 -0800 (PST)
From:   "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
To:     netdev@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Cc:     Ira Weiny <ira.weiny@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>
Subject: Re: [PATCH net-next 2/5] sfc: Use kmap_local_page() instead of kmap_atomic()
Date:   Fri, 18 Nov 2022 20:26:13 +0100
Message-ID: <2153769.NgBsaNRSFp@suse>
In-Reply-To: <164778f1-f2a6-1e82-8924-a4d7ba073e23@intel.com>
References: <20221117222557.2196195-1-anirudh.venkataramanan@intel.com> <8192948.T7Z3S40VBb@suse> <164778f1-f2a6-1e82-8924-a4d7ba073e23@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On venerd=EC 18 novembre 2022 18:47:52 CET Anirudh Venkataramanan wrote:
> On 11/18/2022 12:23 AM, Fabio M. De Francesco wrote:
> > On gioved=EC 17 novembre 2022 23:25:54 CET Anirudh Venkataramanan wrote:
> >> kmap_atomic() is being deprecated in favor of kmap_local_page().
> >> Replace kmap_atomic() and kunmap_atomic() with kmap_local_page()
> >> and kunmap_local() respectively.
> >>=20
> >> Note that kmap_atomic() disables preemption and page-fault processing,=
=20
but
> >> kmap_local_page() doesn't. Converting the former to the latter is safe=
=20
only
> >> if there isn't an implicit dependency on preemption and page-fault=20
handling
> >> being disabled, which does appear to be the case here.
> >=20
> > NIT: It is always possible to disable explicitly along with the=20
conversion.
>=20
> Fair enough. I suppose "convert" is broader than "replace". How about thi=
s:
>=20
> "Replacing the former with the latter is safe only if there isn't an
> implicit dependency on preemption and page-fault handling being
> disabled, which does appear to be the case here."
>=20
> Ani

Let's start with 2/5 because it looks that here we are talking of a sensiti=
ve=20
subject. Yesterday something triggered the necessity to make a patch for=20
highmem.rst for clarifying that these conversions can _always_ be addressed=
=2E =20

I sent it to Ira and I'm waiting for his opinion before submitting it.

The me explain better... the point is that all kmap_atomic(), despite the=20
differences, _can_ be converted to kmap_local_page().

What I care of is the safety of the conversions. I trust your commit messag=
e=20
where you say that you inspected the code and that "there isn't an implicit=
=20
dependency on preemption and page-fault handling being disabled".

I was talking about something very different: what if the code between mapp=
ing=20
and unmapping was relying on implicit page-faults and/or preemption disable=
? I=20
read between the lines that you consider a conversion of that kind somethin=
g=20
that cannot be addressed because "kmap_atomic() disables preemption and pag=
e-
fault processing, but kmap_local_page() doesn't" (which is true).

The point is that you have the possibility to convert also in this=20
hypothetical case by doing something like the following.

Old code:

ptr =3D kmap_atomic(page);
do something with ptr;
kunmap_atomic(ptr);

You checked the code and understood that that "something" can only be carri=
ed=20
out with page-faults disabled (just an example). Conversion:

pagefault_disable();
ptr =3D kmap_local_page(page);
do something with ptr;
kunmap_local(ptr);
pagefault_enable();

I'm not asking to reword your commit message only for the purpose to clear=
=20
that your changes are "safe" because you checked the code and can reasonabl=
y=20
affirm that the conversion doesn't depend on further disables.

I just said it to make you notice that every kmap_atomic() conversion to=20
kmap_local_page() is "safe", but only if you really understand the code and=
=20
act accordingly.

I'm too wordy, Ira said it so many times. Unfortunately, I'm not able to=20
optimize English text and need to improve. I'm sorry.

Does my long explanation make any sense to you?

If so, I'm happy. I'm not asking to send v2. I just desired that you realiz=
e=20
(1) how tricky these conversions may be and therefore how much important is=
=20
not to do them mechanically (2) how to better craft your next commit messag=
e=20
(if you want to keep on helping with these conversions).

I'm OK with this patch. Did you see my tag? :-)

Thanks for helping,

=46abio =20


