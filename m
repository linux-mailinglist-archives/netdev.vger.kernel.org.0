Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B2F578431
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 15:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235371AbiGRNrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 09:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235454AbiGRNrI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 09:47:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1C80825EA9
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 06:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658152027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RtcmjGXV4czePnEOaU9k1n+wgG1RmX/RhdWW1Odaz3Q=;
        b=b2o1zTtjxv3LoGnwI3uWWLRyW+Kc8GzOLbiZnQHYpmDSl3K8Yx3QuJLpSqXkxZ/+O5ydiW
        YGTN6sMpCA+/iOGNFNwCqMVisLc7uNdo1lN9b8x+MEzr3A1dF+1VmSVYnPkGiwITCaJECw
        g3LJVLlb0mQDlymOrm0SJpDuvFzSq4k=
Received: from mail-ua1-f71.google.com (mail-ua1-f71.google.com
 [209.85.222.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-38-gctiP5UrP4af6sxEkfnStQ-1; Mon, 18 Jul 2022 09:47:05 -0400
X-MC-Unique: gctiP5UrP4af6sxEkfnStQ-1
Received: by mail-ua1-f71.google.com with SMTP id l35-20020ab043a6000000b003840a6b6534so587241ual.0
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 06:47:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=RtcmjGXV4czePnEOaU9k1n+wgG1RmX/RhdWW1Odaz3Q=;
        b=fLe5naiXeK5rRlRs/3TZg7fnLcxniCFNy6ehGEoyDGteEbiUAL3Etw5BWiMWjXuLme
         qbJ53BDNaaLdXhUurUd3SdB7/IRo/rvFjwvV42k5qrTCQSax7imeyuhl6oeiE2tHKhOm
         UjXKUhP6V54NS8Addgtuq06zd5Nz8JEAae6XYayTx18xKRHXFfp9G4WSMQGLTsaS32YK
         gtwuYgk7ULB2wZTlpfbL+y0hfxC4Dl0j4PCXgRMUWinWAqNi6uKF9afizVTxpU0HpMZ2
         XGDoLjFzLNnX7NWfwFKxhI3AvDVRaARPPkH5EmXehbfMXl5kiK8q123aV1mjnxruhXz7
         10Bw==
X-Gm-Message-State: AJIora8XLP+VpxRt+q7lnqyTQqPeq3Ak7lPekMJxoe61+iKaCaexuCyJ
        IhAWjvD38l2lPDv6XgV3ObJYFX91v0Gmql8eiBnCYZ0aecO9cEt/4ynUvkJNRqU80GQJ/JSd7dT
        XC2fjZr6hBC+LGR7av0ne12XWi4JGH55+
X-Received: by 2002:a67:c894:0:b0:324:c5da:a9b5 with SMTP id v20-20020a67c894000000b00324c5daa9b5mr9160121vsk.33.1658152024942;
        Mon, 18 Jul 2022 06:47:04 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uiBu7OtwOgQIzMRRe6G0eAhpYwuwmFJy8ENPD1LcyPCRQSKTZ0hfu7BXyhst+U/lKFwugYJ1Hu0+fBVs8yG0c=
X-Received: by 2002:a67:c894:0:b0:324:c5da:a9b5 with SMTP id
 v20-20020a67c894000000b00324c5daa9b5mr9160107vsk.33.1658152024680; Mon, 18
 Jul 2022 06:47:04 -0700 (PDT)
MIME-Version: 1.0
References: <20220715125013.247085-1-mlombard@redhat.com> <62aacb46.a9b1.182110646cf.Coremail.chen45464546@163.com>
In-Reply-To: <62aacb46.a9b1.182110646cf.Coremail.chen45464546@163.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 18 Jul 2022 15:46:53 +0200
Message-ID: <CAFL455kBP+_PTgDY51V2YgbMCLjYDKS_Jh4k6pvDnqUnYCf-TA@mail.gmail.com>
Subject: Re: [PATCH V3] mm: prevent page_frag_alloc() from corrupting the memory
To:     Chen Lin <chen45464546@163.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

po 18. 7. 2022 v 13:17 odes=C3=ADlatel Chen Lin <chen45464546@163.com> naps=
al:
>
> Will  this lead to memory leak when device driver miss use this interface=
 muti-times=EF=BC=9F

No, I tested it and pagecnt_bias and the page refcnt are always consistent.

Maurizio

