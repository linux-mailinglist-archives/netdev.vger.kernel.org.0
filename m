Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FF95AB248
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 15:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236173AbiIBNzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 09:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238636AbiIBNyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 09:54:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C8D1573E0
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662125307;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=10S2baNmGpvfbB3rWC8TV3GU8jc51um5+NmqwLplTxA=;
        b=iLJZKQpSxZ7oz7VwUYQDKIMN5qpOtrpqHod7EPwT82RTaBsGNaiTXzp+wUAuODrujCzCbJ
        90pNMh84os6Hq+iWSWG0Vju1J+WUrRHErxGkQQ7fZMPrJaFz165kTtdr3SFa6CfZb03hU1
        3Ab8L2yrVEJmT3l+ftWghpqsneWJaiE=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-217-EJCBgUNrN6y-py4zVE7iBA-1; Fri, 02 Sep 2022 09:11:50 -0400
X-MC-Unique: EJCBgUNrN6y-py4zVE7iBA-1
Received: by mail-pl1-f199.google.com with SMTP id h12-20020a170902f54c00b0016f8858ce9bso1270053plf.9
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 06:11:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=10S2baNmGpvfbB3rWC8TV3GU8jc51um5+NmqwLplTxA=;
        b=Wkcdfs/2Dibdtaemn9B1EL5kd0BZaXzCq+EZ2dJrK7YY0r3uufaDyOAid6GjclgquX
         4WgIM5OPYMNBvBnEr8X7VizCktCI7YsWwPmlFyDa9xBX2KmGBqwBvo6+FxfmWwyjgj7G
         5CEays8LKCD+Rfia3SRZRMhr0dPpR53kKDuXRM1hWSWIfSlJ+vbyRv6xqiKr+8wTYnDU
         5HA9a8hDh2UN7gEp0YwnGA0Aj0YnZmGaHqMkgbzzbf4F0qiJI+6MHKgsl9PaYhaHOehf
         EMbd2zi+SDdYNSexhMVoDWw05V6ONbzZEm1AdQkctG8dkrc5z09/io0S1kk8oHLm2MhG
         fOdw==
X-Gm-Message-State: ACgBeo0coHVy1qkRP+DRR5VFfTVafqvyrBUftVEN+duHzUySllfKejs8
        0lYpiMyp9Oth1WZlCa9bIrQGg1clGTkmnnwLfCEt1BibbZJHMBMwtbTpZTNuQICyKnIvxapDjuA
        XFqqUcl92TWHMaRZ789r3BL6yF6gXOdnj
X-Received: by 2002:a17:902:b58a:b0:16e:f91a:486b with SMTP id a10-20020a170902b58a00b0016ef91a486bmr36558490pls.119.1662124309710;
        Fri, 02 Sep 2022 06:11:49 -0700 (PDT)
X-Google-Smtp-Source: AA6agR72EpfhkEK4ko7qYW4nPa0blgG/78lQfqmeZeVLgOOiuWSw4Fu8+YGj6zLNMt/u79Hm3xPofVjqghC/L9D7cM4=
X-Received: by 2002:a17:902:b58a:b0:16e:f91a:486b with SMTP id
 a10-20020a170902b58a00b0016ef91a486bmr36558475pls.119.1662124309461; Fri, 02
 Sep 2022 06:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220824134055.1328882-1-benjamin.tissoires@redhat.com>
 <20220824134055.1328882-2-benjamin.tissoires@redhat.com> <CAADnVQKgkFpLh_URJn6qCiAONteA1dwZHd6=4cZn15g1JCAPag@mail.gmail.com>
 <CAP01T75ec_T0M6DU=JE2tfNsWRZuPSMu_7JHA7ZoOBw5eDh1Bg@mail.gmail.com>
 <CAO-hwJLd9wXx+ppccBYPKZDymO0sk++Nt2E3-R97PY7LbfJfTg@mail.gmail.com>
 <CAADnVQK8dS+2KbWsqktvxoNKhHtdD5UPiaWVfNu=ESdn_OHpgQ@mail.gmail.com>
 <CAO-hwJK9uHTWCg3_6jrPF6UKiamkNfj=cuH5mHauoLX+0udV9w@mail.gmail.com>
 <CAADnVQLuL045Sxdvh8kfcNkmD55+Wz8fHU3RtH+oQyOgePU5Pw@mail.gmail.com>
 <CAO-hwJJJJRtoq2uTXRKCck6QSH8SFDSTpHmvTyOieczY7bdm8g@mail.gmail.com> <CAP01T77SJyiDxv0A++_mNw7JZ-Mzh4B1FAM6zLiP6n75MNY0uQ@mail.gmail.com>
In-Reply-To: <CAP01T77SJyiDxv0A++_mNw7JZ-Mzh4B1FAM6zLiP6n75MNY0uQ@mail.gmail.com>
From:   Benjamin Tissoires <benjamin.tissoires@redhat.com>
Date:   Fri, 2 Sep 2022 15:11:38 +0200
Message-ID: <CAO-hwJLbbB0Abw3d4pJPnYTAzQNdtgBTpuNz4zVUTFXCbZEEbQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v9 01/23] bpf/verifier: allow all functions to
 read user provided context
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 2, 2022 at 5:50 AM Kumar Kartikeya Dwivedi <memxor@gmail.com> wrote:
>
> On Thu, 1 Sept 2022 at 18:48, Benjamin Tissoires
> <benjamin.tissoires@redhat.com> wrote:
> >
> > [...]
> > If the above is correct, then yes, it would make sense to me to have 2
> > distinct functions: one to check for the args types only (does the
> > function definition in the problem matches BTF), and one to check for
> > its use.
> > Behind the scenes, btf_check_subprog_arg_match() calls
> > btf_check_func_arg_match() which is the one function with entangled
> > arguments type checking and actually assessing that the values
> > provided are correct.
> >
> > I can try to split that  btf_check_func_arg_match() into 2 distinct
> > functions, though I am not sure I'll get it right.
>
> FYI, I've already split them into separate functions in my tree
> because it had become super ugly at this point with all the new
> support and I refactored it to add the linked list helpers support
> using kfuncs (which requires some special handling for the args), so I
> think you can just leave it with a "processing_call" check in for your
> series for now.
>

great, thanks a lot.
Actually, writing the patch today with the "processing_call" was
really easy now that I have turned the problem in my head a lot
yesterday.

I am about to send v10 with the reviews addressed.

Cheers,
Benjamin

