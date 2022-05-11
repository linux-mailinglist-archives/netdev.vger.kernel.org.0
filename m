Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B72752339D
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 15:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiEKNEG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 09:04:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiEKNEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 09:04:05 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C423A232773
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 06:04:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652274243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pinb/em9ISqaN/ggUqq9o9xe3fwXzrQO5qBY9zBva64=;
        b=Bu3592Uu/wVzc7BlvEXLpBN6iKSxLmpJIlizCRra7PTg/QdS5ykNuT2+aC7o2BeYnq0wwt
        3EkD9fRJSQBju+Q43FqMolLJE4+vfwYA6gbBwQ7fcyxYmTOKVYVboY2vnLAWQErbDZtnUr
        M8xy11yewlQitE1rckTlmHi3RhfSj9o=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-8u0p9AQcO_-5XXk9hhJ7tQ-1; Wed, 11 May 2022 09:04:02 -0400
X-MC-Unique: 8u0p9AQcO_-5XXk9hhJ7tQ-1
Received: by mail-il1-f197.google.com with SMTP id j5-20020a056e020ee500b002cbc90840ecso1313079ilk.23
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 06:04:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=pinb/em9ISqaN/ggUqq9o9xe3fwXzrQO5qBY9zBva64=;
        b=FG2WoiiRaREUYa7HR9vxN0QWNqJs8q5XHqwn3c9JrjKVpP+ho57u85o7nUSkTLfWZe
         tm0OtTBNCHmqwsj6kZ7CEzU0P+1VcrnUYvxIggAVnU7B2iVqJwhM6vOn0t3iJ7OQHwn1
         1Zi2SrXqCI+JLEB+LPGGMpBg+z4ESTCa4xl/XB1ROubBYzi2S9XwSmwPBR+pQt6cFI9O
         HqqWBQ1fMC+zgzrVjr/vJkpWncR60nA6ZWPSqr2gpqCK3zHBgK9cqgFAmluPy+5vNxWg
         321URQ4nvG2PYuqeJtAUHCDLMC6XQi01fIsqbd4i1Jg3yEiJ6ICZpWJfi7oyMkadePct
         amiw==
X-Gm-Message-State: AOAM531/04fITpOuXJciYjvONBT4OJCL10yx73KZ67zEzNaLAc6Pfq4R
        5ZlHw0tdGzzVAGP7WAfBlLJSEvqxbmzZF1cZIO3k4gAZxj1dJ7JoQDDhMNwC2r//+p3Q3keEhMC
        Nkstus2Y44xBNzGm0AY+j95BFkOnwv8zH
X-Received: by 2002:a02:aa94:0:b0:32a:e769:af1 with SMTP id u20-20020a02aa94000000b0032ae7690af1mr11798141jai.0.1652274240658;
        Wed, 11 May 2022 06:04:00 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy01vRY/G7ehYrNqKKq9hDNjGA8R7dXzFOdqqrFGnHcZbrBqvvfa757akpfds5dn+rJxmJwdnHw/2ZnG0R6Hnk=
X-Received: by 2002:a02:aa94:0:b0:32a:e769:af1 with SMTP id
 u20-20020a02aa94000000b0032ae7690af1mr11798119jai.0.1652274240201; Wed, 11
 May 2022 06:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220511103604.37962-1-ihuguet@redhat.com> <20220511103604.37962-2-ihuguet@redhat.com>
 <20220511125819.nz6ethnd2yyljdj6@gmail.com>
In-Reply-To: <20220511125819.nz6ethnd2yyljdj6@gmail.com>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Wed, 11 May 2022 15:03:49 +0200
Message-ID: <CACT4ouczOjY9xUgDh4FbXGz_Q-4j24M+CJqrB0jrtTYbYMjFdg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] sfc: fix memory leak on mtd_probe
To:     =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Liang Li <liali@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 11, 2022 at 2:58 PM Martin Habets <habetsm.xilinx@gmail.com> wr=
ote:
>
> The same patch was submitted earlier, see
> https://lore.kernel.org/netdev/20220510153619.32464-1-ap420073@gmail.com/

Seriously? It has been there for 9 years and 2 persons find it and
send the fix with hours of difference? Is someone spying me?

Please review the other one and if it's OK, I will send it alone.

>
> Martin
>
> On Wed, May 11, 2022 at 12:36:03PM +0200, =C3=8D=C3=B1igo Huguet wrote:
> > In some cases there is no mtd partitions that can be probed, so the mtd
> > partitions list stays empty. This happens, for example, in SFC9220
> > devices on the second port of the NIC.
> >
> > The memory for the mtd partitions is deallocated in efx_mtd_remove,
> > recovering the address of the first element of efx->mtd_list and then
> > deallocating it. But if the list is empty, the address passed to kfree
> > doesn't point to the memory allocated for the mtd partitions, but to th=
e
> > list head itself. Despite this hasn't caused other problems other than
> > the memory leak, this is obviously incorrect.
> >
> > This patch deallocates the memory during mtd_probe in the case that
> > there are no probed partitions, avoiding the leak.
> >
> > This was detected with kmemleak, output example:
> > unreferenced object 0xffff88819cfa0000 (size 46560):
> >   comm "kworker/0:2", pid 48435, jiffies 4364987018 (age 45.924s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<000000000f8e92d9>] kmalloc_order_trace+0x19/0x130
> >     [<0000000042a03844>] efx_ef10_mtd_probe+0x12d/0x320 [sfc]
> >     [<000000004555654f>] efx_pci_probe.cold+0x4e1/0x6db [sfc]
> >     [<00000000b03d5126>] local_pci_probe+0xde/0x170
> >     [<00000000376cc8d9>] work_for_cpu_fn+0x51/0xa0
> >     [<00000000141f8de9>] process_one_work+0x8cb/0x1590
> >     [<00000000cb2d8065>] worker_thread+0x707/0x1010
> >     [<000000001ef4b9f6>] kthread+0x364/0x420
> >     [<0000000014767137>] ret_from_fork+0x22/0x30
> >
> > Fixes: 8127d661e77f ("sfc: Add support for Solarflare SFC9100 family")
> > Reported-by: Liang Li <liali@redhat.com>
> > Signed-off-by: =C3=8D=C3=B1igo Huguet <ihuguet@redhat.com>
> > ---
> >  drivers/net/ethernet/sfc/ef10.c        | 5 +++++
> >  drivers/net/ethernet/sfc/siena/siena.c | 5 +++++
> >  2 files changed, 10 insertions(+)
> >
> > diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc=
/ef10.c
> > index c9ee5011803f..15a229731296 100644
> > --- a/drivers/net/ethernet/sfc/ef10.c
> > +++ b/drivers/net/ethernet/sfc/ef10.c
> > @@ -3579,6 +3579,11 @@ static int efx_ef10_mtd_probe(struct efx_nic *ef=
x)
> >               n_parts++;
> >       }
> >
> > +     if (n_parts =3D=3D 0) {
> > +             kfree(parts);
> > +             return 0;
> > +     }
> > +
> >       rc =3D efx_mtd_add(efx, &parts[0].common, n_parts, sizeof(*parts)=
);
> >  fail:
> >       if (rc)
> > diff --git a/drivers/net/ethernet/sfc/siena/siena.c b/drivers/net/ether=
net/sfc/siena/siena.c
> > index 741313aff1d1..32467782e8ef 100644
> > --- a/drivers/net/ethernet/sfc/siena/siena.c
> > +++ b/drivers/net/ethernet/sfc/siena/siena.c
> > @@ -943,6 +943,11 @@ static int siena_mtd_probe(struct efx_nic *efx)
> >               nvram_types >>=3D 1;
> >       }
> >
> > +     if (n_parts =3D=3D 0) {
> > +             kfree(parts);
> > +             return 0;
> > +     }
> > +
> >       rc =3D siena_mtd_get_fw_subtypes(efx, parts, n_parts);
> >       if (rc)
> >               goto fail;
> > --
> > 2.34.1
>


--=20
=C3=8D=C3=B1igo Huguet

