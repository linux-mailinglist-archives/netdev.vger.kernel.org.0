Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9244BF54F
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 11:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230357AbiBVKCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 05:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230320AbiBVKCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 05:02:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CEC4D9E1;
        Tue, 22 Feb 2022 02:01:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB4E3B81979;
        Tue, 22 Feb 2022 10:01:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748F6C340F1;
        Tue, 22 Feb 2022 10:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645524106;
        bh=WlKysR3fh9cyTsBx7g4oItMVVN2tFxPCnNUbkhVb5nw=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=NF0HYkUOI0T/c3YEkbbhITM2wsz8a1nY+2BBS7Ae1Qq3VQlDKXDwweAiLgzY07a0D
         CkamuFzar7TxDgxm+QX7I/1Fq1DUFGwnXlPyDla0GiaEX32655LtgKJLcX4zJTFjls
         61Il/UAGUO7DOVokjixgZgiqpmyhPo1jYvg7/pAGch63DfOdl2iFR/rng+VPpn2ELs
         xtC7Z1kwFlCUqvcnqxPJ9osES2woTYbxMPm+oOe4oBRJa2GDNGjQmvr70CX22+ay6d
         vDTZuWldYKrdJnsT7LE8zzB82pPUU2Dr/XdVS2sUIOGL4KiX3Iste78hkfDogmOIH0
         zRPc6i0BqFc6A==
Received: by mail-yb1-f178.google.com with SMTP id v186so39969219ybg.1;
        Tue, 22 Feb 2022 02:01:46 -0800 (PST)
X-Gm-Message-State: AOAM533Zan2M52b4S0gar/jlnhE6g/l27hzEhWn7rRiAdM2DOCpyI3FT
        lPxte3sYTSsuCD51QJNxGp1zSUR9DasvpfhiaZ8=
X-Google-Smtp-Source: ABdhPJzlvtAFNBuRnF7Dm7wHjcBG42cmva1ven6sDLXUphEjMJfNZZBaJeENh17z+ZNcYmS98StpGZzI20vsmBNiZmw=
X-Received: by 2002:a25:4214:0:b0:624:6215:4823 with SMTP id
 p20-20020a254214000000b0062462154823mr13087478yba.432.1645524105607; Tue, 22
 Feb 2022 02:01:45 -0800 (PST)
MIME-Version: 1.0
References: <20220216113323.53332-1-Jason@zx2c4.com> <164543897830.26423.13654986323403498456.kvalo@kernel.org>
In-Reply-To: <164543897830.26423.13654986323403498456.kvalo@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 22 Feb 2022 11:01:34 +0100
X-Gmail-Original-Message-ID: <CAMj1kXFLx1xGexd5P9xnB-2=cFn1DScCa8U6a7AyRAxQPLCWLw@mail.gmail.com>
Message-ID: <CAMj1kXFLx1xGexd5P9xnB-2=cFn1DScCa8U6a7AyRAxQPLCWLw@mail.gmail.com>
Subject: Re: [PATCH v3] ath9k: use hw_random API instead of directly dumping
 into random.c
To:     Kalle Valo <kvalo@kernel.org>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, miaoqing@codeaurora.org,
        Rui Salvaterra <rsalvaterra@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Feb 2022 at 11:57, Kalle Valo <kvalo@kernel.org> wrote:
>
> "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:
>
> > Hardware random number generators are supposed to use the hw_random
> > framework. This commit turns ath9k's kthread-based design into a proper
> > hw_random driver.
> >
> > Cc: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> > Cc: Kalle Valo <kvalo@kernel.org>
> > Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> > Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> > Cc: Herbert Xu <herbert@gondor.apana.org.au>
> > Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
> > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
> > Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
>
> Patch applied to ath-next branch of ath.git, thanks.
>
> fcd09c90c3c5 ath9k: use hw_random API instead of directly dumping into ra=
ndom.c
>

With this patch, it seems we end up registering the hw_rng every time
the link goes up, and unregister it again when the link goes down,
right?

Wouldn't it be better to split off this driver from the 802.11 link
state handling?
