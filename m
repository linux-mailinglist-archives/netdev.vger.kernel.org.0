Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBFE568C88
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 17:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiGFPVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 11:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbiGFPVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 11:21:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AFE0B1EEFE
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 08:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657120909;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HcS3uejzMuAs7Fc/x+INtudJrA9wFk21WgYmtKtnXTU=;
        b=OcSyshMTP5v9Rx90yftKl+I0T33oo1S/ks/AJKHIpi++38EiABnFajAVmk/rEPKMq4VsQd
        3AX5hB2cr16rtnA9+u/chBFlroFFhRS/FdygTDLq593qPnk0E1GjcfWuWsdlUwl1nFP30B
        Su4Dn+rBSA8UDzyChBIJ3nibZjlM4ac=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-178-_x6_3kFOO5mz4zrveRe8kw-1; Wed, 06 Jul 2022 11:21:42 -0400
X-MC-Unique: _x6_3kFOO5mz4zrveRe8kw-1
Received: by mail-ua1-f71.google.com with SMTP id q74-20020a9f37d0000000b00381f3cac330so4845387uaq.16
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 08:21:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HcS3uejzMuAs7Fc/x+INtudJrA9wFk21WgYmtKtnXTU=;
        b=geJK4ncYwc2tWKSBDLSjwLb3buDdFie1H/Rk25pE+p0kYr6nWcLHzPcWsSEuI5UdeQ
         8Ws7MEqE/YLOOsBVcAwqWiqUI9Oh54YM+vJiUOn7GUn3S+dT/QZ4c9hG9SHptyEIcMrO
         dU8/cCZ26+AHf9Uhdfi8oKmD2z3vTJ0Y6HxHnVCeP7uRxhZOYpc19LHfymEuQxipeY18
         JeiOPWVOzcsgcjXcOIJZw6jXgWWmsU9tZeZX++3q5cNa4k0NeDN6ybPPy07WwdikKpiF
         Fxe8xUHU0Rzb5x7iozXMlH2AOqT9yM11lFzIzGu2WtCjKjv6uNRmc+GO0ltRC6mBFulr
         fQ0Q==
X-Gm-Message-State: AJIora/QCyHgdwhWmLCM9rfjtc0k68KFgPBzqTrivkrdNns/6vd6NLAZ
        Plhyztlz+28fVBOue0j1+t1pRga226GzXGgDXL2NMatoVjkkQWpngip6IwRQDXOYgFTb/D/d3qZ
        paJKC0uvE9JXpCfvRsTKNqS64ZzGS5Sju
X-Received: by 2002:a67:4347:0:b0:356:37f7:6fa3 with SMTP id q68-20020a674347000000b0035637f76fa3mr24958237vsa.40.1657120902145;
        Wed, 06 Jul 2022 08:21:42 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1s2+Xffu3s3AfptA3eZWELbrOWi/CqyYzom+y2gsOdu+DMe8X2B0ID45kOQWpCgGgbCy69x8Nld6DIcmyOzSyw=
X-Received: by 2002:a67:4347:0:b0:356:37f7:6fa3 with SMTP id
 q68-20020a674347000000b0035637f76fa3mr24958223vsa.40.1657120901924; Wed, 06
 Jul 2022 08:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <20220531081412.22db88cc@kernel.org> <1654011382-2453-1-git-send-email-chen45464546@163.com>
 <20220531084704.480133fa@kernel.org> <CAKgT0UfQsbAzsJ1e__irHY2xBRevpB9m=FBYDis3C1fMua+Zag@mail.gmail.com>
 <3498989.c69f.1811f41186e.Coremail.chen45464546@163.com> <CAKgT0UdoGJ_dG9vZ3aqQhTagCGf_J3H9A8yJbO5mWCgrt6vd4Q@mail.gmail.com>
In-Reply-To: <CAKgT0UdoGJ_dG9vZ3aqQhTagCGf_J3H9A8yJbO5mWCgrt6vd4Q@mail.gmail.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Wed, 6 Jul 2022 17:21:31 +0200
Message-ID: <CAFL455=bAEXeyUPjDPZm-hK-K8aKJSw7wRQ0CCYoKWO8VMJUqw@mail.gmail.com>
Subject: Re: Re: [PATCH v2] mm: page_frag: Warn_on when frag_alloc size is
 bigger than PAGE_SIZE
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     =?UTF-8?B?5oSa5qCR?= <chen45464546@163.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

st 1. 6. 2022 v 17:05 odes=C3=ADlatel Alexander Duyck
<alexander.duyck@gmail.com> napsal:
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index e6f211d..ac60a97 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5580,6 +5580,7 @@ void *page_frag_alloc_align(struct page_frag_cach=
e *nc,
> >                 /* reset page count bias and offset to start of new fra=
g */
> >                 nc->pagecnt_bias =3D PAGE_FRAG_CACHE_MAX_SIZE + 1;
> >                 offset =3D size - fragsz;
> > +               BUG_ON(offset < 0);
> >         }
> >
> >         nc->pagecnt_bias--;
> >
>
>
> I think I could be onboard with a patch like this. The test shouldn't
> add more than 1 instruction since it is essentially just a jump if
> signed test which will be performed after the size - fragsz check.

FYI, I hit this problem a few days ago with the nfp network driver, it uses
page_frag_alloc() with a frag size larger than PAGE_SIZE when MTU is
set to 9000,
this may result in memory corruptions when the system runs out of memory.

The solution I was working on was something like the following, this
makes the allocation
fail if fragsz is greater than the cache size.

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4dc0d333279f..c6b40b85c55d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5544,12 +5544,17 @@ void *page_frag_alloc_align(struct page_frag_cache =
*nc,
                /* if size can vary use size else just use PAGE_SIZE */
                size =3D nc->size;
 #endif
-               /* OK, page count is 0, we can safely set it */
-               set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1);
-
                /* reset page count bias and offset to start of new frag */
                nc->pagecnt_bias =3D PAGE_FRAG_CACHE_MAX_SIZE + 1;
                offset =3D size - fragsz;
+               if (unlikely(offset < 0)) {
+                       free_the_page(page, compound_order(page));
+                       nc->va =3D NULL;
+                       return NULL;
+               }
+
+               /* OK, page count is 0, we can safely set it */
+               set_page_count(page, PAGE_FRAG_CACHE_MAX_SIZE + 1);
        }

        nc->pagecnt_bias--;


Maurizio

