Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C3F54A8A7D
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:44:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349896AbiBCRoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234361AbiBCRoe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:44:34 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03B3FC061714;
        Thu,  3 Feb 2022 09:44:34 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id k17so2808047plk.0;
        Thu, 03 Feb 2022 09:44:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1PIvakgPFU06Hp4Wyu28bq75cjKrDt9/2hkcT6oy8B8=;
        b=jqWD7y7l24rzAY2r4cTnoMEwqrdR367M/pL26PNezgtGIblwqP5jGiFLOacVgxBSI5
         /UrD70K785TyqqNR/63BqFVwnyxpBscZO1GPMjIA26Sncjd9fhQ48/gOioDSLyokYpxB
         vOOKnVdWU7G4JG59klQJugO+P3ac1SXdXAn2Pggg08Eosp1X4vYt6VdO6IQGNdNAh0m0
         U4VciJWUZ4beEduPSpY15KWjbFS7ljEGW8EH5aXX3GIngBixNi/jmm858xujJnlmq1M1
         NLXABfcDLs5/iwMMQn9bMv9Lh51C2R9BHoSqXnG7mV4eA46GUoxZMuU0aooxAQXUrdss
         tNtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1PIvakgPFU06Hp4Wyu28bq75cjKrDt9/2hkcT6oy8B8=;
        b=figYy7nEyUxOsn8uLRuZKwiWqDH5X82xDw0sHz8cG0CMHmmu+Cyuo+RHAocyDB5FHO
         10lNiOMHcP/17uLMaayyL6xUXQOi93hETaG+igtIkyszWYHnMTubt9cIteKJnZvr9tmW
         0Vn/2yd9fo2dTGIonw5U9QkVAb2Sv8FFcGAWtm4hgyPWf7fSzSUksdam9zA+yfv1EBqG
         URzHojrJywmqtGgCLvpyM7HartxmawavqjlvMBA2cMeZQhaZuW0Hb5DeN4Cu0g16IMFB
         frCE9cRADnw2K8XNz3uXytsHTQ/3vEw8ZcUjDUSvWn3la7VIAEqt/p+uJKAvG3jZIkpf
         IcNA==
X-Gm-Message-State: AOAM533xt4tbcv2Asm31w21Gbg/VFQjUTtrOHWoFJ/ED1tpDvsBC74RA
        AjUM624DVg/e2QHeG4wHdzQUwbzTd9vxxFx9h4/0g9tlscs=
X-Google-Smtp-Source: ABdhPJwk6b5mVjhJlsjDQFvnbOwkZywl0OAwUc8iIBA6PBbi6UPk4UepfIHCiOqVQstFxbxcBNExZrN8kBQxwNNQNKw=
X-Received: by 2002:a17:90a:d203:: with SMTP id o3mr15085386pju.122.1643910273543;
 Thu, 03 Feb 2022 09:44:33 -0800 (PST)
MIME-Version: 1.0
References: <20220131183638.3934982-1-hch@lst.de> <20220131183638.3934982-4-hch@lst.de>
 <CAADnVQLiEQFzON5OEV_LVYzqJuZ68e0AnqhNC++vptbed6ioEw@mail.gmail.com> <20220203174010.GA16681@lst.de>
In-Reply-To: <20220203174010.GA16681@lst.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 3 Feb 2022 09:44:22 -0800
Message-ID: <CAADnVQKjdVybM4-62BP_P5cyMxs7x9G7OpjFqv-tQtVMP4X+hw@mail.gmail.com>
Subject: Re: [PATCH 3/5] bpf, docs: Better document the legacy packet access instruction
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 9:40 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Thu, Feb 03, 2022 at 09:32:38AM -0800, Alexei Starovoitov wrote:
> > These two places make it sound like it's interpreter only behavior.
> > I've reworded it like:
> > -the interpreter context is a pointer to networking packet.  ``BPF_ABS``
> > +the program context is a pointer to networking packet.  ``BPF_ABS``
> >
> > -interpreter will abort the execution of the program.
> > +program execution will be aborted.
> >
> > and pushed to bpf-next with the rest of patches.
>
> The interpreter thing is actually unchanged from the old text, but I
> totally agree with your fixup.  Thanks!

The old doc had:
"the interpreter will abort the execution of the program. JIT compilers
therefore must preserve this property."

Since the latter sentence is now gone the former got ambiguous.
