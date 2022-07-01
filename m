Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 955955633FB
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 15:04:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236143AbiGANEp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 09:04:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbiGANEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 09:04:43 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EB91DA7D;
        Fri,  1 Jul 2022 06:04:42 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id r20so3179510wra.1;
        Fri, 01 Jul 2022 06:04:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6yQ/Ybxs/FeC8Yf6z24bF3+durgoCtXEuKWYb2rjDmE=;
        b=gWYDht32suKdgvkpxu9xwdi10igo9pi6gutPFiT71MmtnfgNW8yC6mlF8qE1F2KAR2
         iYYdBQnFRoRq7HGSJc5QI3uau1prmX7g04fpfrjz5PnrYI0SCEDucsNTGdkxqHcyTMhk
         jx6KnpyFVIGdlgeAiCzQ/o8j52h+icPwVVFMHf2R7nBSX0ftLMrhGD7UKaYs8pB989hI
         9fTQCUwIiAxE04REZI7mlWJoGYQ1uPgSuiut19nrrZSv5+YGNHoDCUzQfXU4qoTxHEk8
         dmyeekEEe5Y0Y9YN7ZSTl3ZSaiWCd4m44Xi8C41HKFdnPw1ixxo7PSHYuB3C64k50F8J
         lRfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6yQ/Ybxs/FeC8Yf6z24bF3+durgoCtXEuKWYb2rjDmE=;
        b=ZYhWkGSkkYT079jN2e/Ifba95ftW7KRUesDwduX/MHxcRMo6Nb65mykak0qfglPs+H
         9+zBce9P5KJVWlCfFfSjRunX7zttCjGR9Fy03iSmJM5z1sbEgHORl6nFT/XAHBNpk46r
         +erGlQAgeQ1fjZIa1QKPIyGFGNsVRQLgGsZtmBzd4ZoIRMM8LB5IAAC/Bwtvi5nrNWRP
         yytyD97UmZpKxQqgrP+xfGtnjYSarQdopX+5rMfYH2vbWKsjSzeEuROgry6oqSpFRDfh
         +TkfpF8i+T6QnUva76sFL7Hg4Snkwii6p6D+5LeADzLJ5RPFhok1HRcsJhsiREoCspPC
         68qQ==
X-Gm-Message-State: AJIora9fD2HBtOjP23q7UgdjmOKmis5gWFqPR+f+spXAF31esj0a0iD3
        hnksEPC87NYF5QndMkf12aDOvhnxXmdurTDLcI+63Rdw
X-Google-Smtp-Source: AGRyM1t+emToFrYDmuWYvx+MVwKCifekSLnhwn1uxzrflbVgjLMp3ozOKDPETXGgNbhkevCNj5srktfuY1pOMTWgXbM=
X-Received: by 2002:a5d:5108:0:b0:21b:964d:3241 with SMTP id
 s8-20020a5d5108000000b0021b964d3241mr13664236wrt.532.1656680681089; Fri, 01
 Jul 2022 06:04:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220630093717.8664-1-magnus.karlsson@gmail.com>
 <fa929729-6122-195f-aa4b-e5d3fedb1887@redhat.com> <CAJ8uoz2KmpVf7nkJXUsHhmOtS2Td+rMOX8-PRqzz9QxJB-tZ3g@mail.gmail.com>
In-Reply-To: <CAJ8uoz2KmpVf7nkJXUsHhmOtS2Td+rMOX8-PRqzz9QxJB-tZ3g@mail.gmail.com>
From:   Srivats P <pstavirs@gmail.com>
Date:   Fri, 1 Jul 2022 18:34:01 +0530
Message-ID: <CANzUK58FPeKa_b36=9Wnb2g7fVppmMGBnjORb-dkZUZk3mvp8A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests, bpf: remove AF_XDP samples
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Xdp <xdp-newbies@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I can push xsk_fwd to BPF-examples. Though I do think that xdpsock has
> become way too big to serve as a sample. It slowly turned into a catch
> all demonstrating every single feature of AF_XDP. We need a minimal
> example and then likely other samples for other features that should
> be demoed. So I suggest that xdpsock dies here and we start over with
> something minimal and use xsk_fwd for the forwarding and mempool
> example.

As an AF_XDP user, I want to say that I often refer to xdpsock to
understand how to use a feature - it is very useful especially when
there's a lack of good AF_XDP documentation.

Srivats
