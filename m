Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B98A55130A
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 10:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239898AbiFTIli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 04:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238955AbiFTIlh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 04:41:37 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AD612ACC;
        Mon, 20 Jun 2022 01:41:36 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id a14so93040pgh.11;
        Mon, 20 Jun 2022 01:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UyZN/z+R30sBWAH4bVCY1NOY8McXNrBdunEmtVZ9mPY=;
        b=mQ0aMR6ajaqbIiBajcKyiiTf/Wbvfs3E/Kv/ATVMG+KK4bbOIYzQJqBMIaieRJQuY4
         kUFMWf7MSpfO+El4ibxZK0No0IbuVW+a2xc6qldbOEmiJ6J/LZUAN/xPiRgZWpdCbuhu
         sObASb4o5R8HHelsfMzX/mDPqAXJ6OVMlH3INVkg/e8h2f76ZRkJcflb0hrPLcFv9XFY
         PWnagtYx4JmT7h4ct1yrcszq8zFL56kBlb2wlrkY36fcyJhPkN1/YbPIq0F/zxS2Cvmy
         TAaNOmMm5vuNcdOCggY7R+8I4oZdhS0LcOms5OhN/q10D+14wfF0UiSBoNOs0Bk/XlcE
         PYfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UyZN/z+R30sBWAH4bVCY1NOY8McXNrBdunEmtVZ9mPY=;
        b=pZuoBnMvtfVsI5JUCoU6bqp9HXvpf1qePBYSLbmht8vsWtdsbzAiMYQC7qX+UQDNDs
         ncxb3ieoHTws6ojEQnyDDeYCJFigbVsixF0JjWGeVgokwkAWi4nTbDemTbc/s0fwDI5I
         FnRBc9iGZSIzqb8JpL3JddorFk9uyBspIpOp85/1sc5t7g79PBLJyLmFkqe4zOVubo1d
         osuZ6/eXigNt9NR8sP2GJMDxWgw3bcCqMdwhQL6shYktiHtuLwVfqYmFX/ht3EE4Pt0O
         SRWOuo4sc6EQ2XOyhf7FeVu5ACU08iW52Q4fZhkwI1I6N/QdwYL/9WBpetfJHNimoVzM
         pa8A==
X-Gm-Message-State: AJIora/lpXB7O+luPUhgiemL+e5Bb4DdNz7ONYWNxoC60AxHV1eU4TGt
        zm6Z+AczMGbrliJnXqU3LzHKVzqer7SQuEtQUHl4VU4j8H4=
X-Google-Smtp-Source: AGRyM1vf5K2vEQX3/dhEfGzqGGOkheMj5WaGL5y8tC2PJRX8OPDw1jAE06454GF6OdLbhaw2hyIcXcu1M+k7VS/iIH4=
X-Received: by 2002:a63:7c5a:0:b0:40c:a376:6176 with SMTP id
 l26-20020a637c5a000000b0040ca3766176mr5416672pgn.156.1655714496150; Mon, 20
 Jun 2022 01:41:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-8-maciej.fijalkowski@intel.com> <62ad3b4f60ece_24b34208d@john.notmuch>
In-Reply-To: <62ad3b4f60ece_24b34208d@john.notmuch>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 20 Jun 2022 10:41:25 +0200
Message-ID: <CAJ8uoz0DZXMVYETSzjWY-VGfy0vi7tYMod7_9E395B1x+-zJEw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 07/10] selftests: xsk: introduce default Rx
 pkt stream
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
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

On Sat, Jun 18, 2022 at 4:44 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Maciej Fijalkowski wrote:
> > In order to prepare xdpxceiver for physical device testing, let us
> > introduce default Rx pkt stream. Reason for doing it is that physical
> > device testing will use a UMEM with a doubled size where half of it will
> > be used by Tx and other half by Rx. This means that pkt addresses will
> > differ for Tx and Rx streams. Rx thread will initialize the
> > xsk_umem_info::base_addr that is added here so that pkt_set(), when
> > working on Rx UMEM will add this offset and second half of UMEM space
> > will be used. Note that currently base_addr is 0 on both sides. Future
> > commit will do the mentioned initialization.
> >
> > Previously, veth based testing worked on separate UMEMs, so single
> > default stream was fine.
> >
> > Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> > ---
>
> Just curious why can't we make veth use a single umem with double size?
> Would be nice to have a single test setup. Why choose two vs a single
> size.

Good point. We could do that, but I prefer if we keep the two modes as
one uses the XDP_SHARED_UMEM feature and the other one does not as it
uses private umems. The more modes we can test, the better. But what
we should do is test both modes when possible and also the third mode
when a umem is shared between separate queue ids and netdevs,
something we do not test at all today. So I say, keep it like this for
now and I can submit another patch set that extends the veth tests to
also use a shared umem (the double umem size case) and introduce
testing of the third mode when applicable.

> Thanks.
