Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7B83C1AA9
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 22:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbhGHUpR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 16:45:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhGHUpQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 16:45:16 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87DAC061574;
        Thu,  8 Jul 2021 13:42:33 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id w1so5979800ilg.10;
        Thu, 08 Jul 2021 13:42:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=mcRsSmxEOFOrcrZe9XK0I7V82WeLfiBYyU2jR/XHrcU=;
        b=DbKo04gTazWy3ShCL3LD1QhRTLtu4dfxUN6oeNbVX1Q73HxHUkdIL0vtpNpuHieq17
         NkZKTt0FJdadJl+vRV0YIGiqLKXWJnqbn/YoBaj1uAePX/VDiwh8B9cYlUebgdNt32Ai
         bbNuOmjyyyo9qUl604XYPGshQ+UVGueNnPr1h3yLskCY7AOE5wK5jGQvA0xTngBlpqbt
         IBkaurZIORU2JNnhPklJKi3t7Zg9mdEogqB+CjQplIz18XcQcRoRzfR+TaGaudoU8xOV
         Mc5QLeN5vbje5wpvhOmP853IkWf2z1/6E+FryqsWSuXpgwOXt5F4oF9zGRGKyop6xp/E
         bZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=mcRsSmxEOFOrcrZe9XK0I7V82WeLfiBYyU2jR/XHrcU=;
        b=FwgJ7VaDclD+9IV9SjlcgOfkmNP+oUJxMfJ+dwDymWWjebHSR2I/DUUNMjEHVyHKTO
         KZp0Ojk3BfjuK+7pLnv64nx+tJJ4eoepY0+8jlRGQP3xR5ucz8BmTtziKhTGGw/ePNYC
         GzRm61IsZPLiXAoi3g0rsQOPYWTGvaR56RxMms9xBWOFJ35VCQfQrpLoMNiZu6FEAaqa
         2l6tmSOt63wJzniAZXUcaCBEEt4mnzc4TnuOp/22yviU4DoJGOgzQ8I0fmWhf6HweEgU
         eq2+eUkjg9hOaQCnQLoUnNnQrloSA5/nDFlrAXg9J8mhjoIKqor9dLNvLmkteD2SakrY
         BByQ==
X-Gm-Message-State: AOAM530VpRhRfED8BywQEjl0GL2cbe3O15f8TRUTh/fqtwe/e17Z8U2u
        zGEXWd+oPTFyaDQx+p/yWj4=
X-Google-Smtp-Source: ABdhPJwW/yCqcxYvBn6Ez8ztOngxBPEiblGnu56OtP/zsVgT4u27pXhfOK1/aDLDMMpVFM0G1dMYPQ==
X-Received: by 2002:a05:6e02:ecb:: with SMTP id i11mr21519384ilk.40.1625776953266;
        Thu, 08 Jul 2021 13:42:33 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id h11sm1844754ilc.1.2021.07.08.13.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jul 2021 13:42:32 -0700 (PDT)
Date:   Thu, 08 Jul 2021 13:42:25 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Message-ID: <60e76331bf27e_653a42085@john-XPS-13-9370.notmuch>
In-Reply-To: <CAADnVQLUDh1vJGc8sC2_uaY2uEQU_DeHdaMbNx9VhOMbSH-Ezg@mail.gmail.com>
References: <20210707223848.14580-1-john.fastabend@gmail.com>
 <20210707223848.14580-3-john.fastabend@gmail.com>
 <CAADnVQLUDh1vJGc8sC2_uaY2uEQU_DeHdaMbNx9VhOMbSH-Ezg@mail.gmail.com>
Subject: Re: [PATCH bpf v2 2/2] bpf: selftest to verify mixing bpf2bpf calls
 and tailcalls with insn patch
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov wrote:
> On Wed, Jul 7, 2021 at 3:39 PM John Fastabend <john.fastabend@gmail.com> wrote:
> >
> > -static volatile int count;
> > +int count = 0;
> > +int noise = 0;
> > +
> > +__always_inline int subprog_noise(void)
> > +{
> > +       __u32 key = 0;
> > +
> > +       bpf_printk("hello noisy subprog %d\n", key);
> > +       bpf_map_lookup_elem(&nop_table, &key);
> > +       return 0;
> > +}
> 
> This selftest patch I had to apply manually due to conflicts.
> I've also removed the noisy printk before pushing.

Thanks! I had the printk there to verify the code was actually
being run, but forgot to remove it before submitting.

> I verified that I saw the spam before removing it.

Great.

> The patch 1 looks great. Thanks a lot for the fix.
