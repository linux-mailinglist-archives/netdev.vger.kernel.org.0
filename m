Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33E6358D856
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 13:45:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242525AbiHILpv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 07:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242461AbiHILpm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 07:45:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 01E681928E
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 04:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660045539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YrRdlwFzhyL1JgoDWLNI0P7/kC4GOv+tysqYh41vN90=;
        b=LhKk2yA6C5vuF1/HIZPZLow0mmjuRwohaYaPn4JA8Mlahv1DeVpSOye78HZIkXixhRB8d1
        a9zhPocz3gxSJphgK+fOBbuL4z+GKR6fFgSOlrWCj7D3zMbxaULd8tRbEtT1wwv9z0QxnX
        yVXBAzQzsxoBa3q4DlJqDnYmZ+hLL+4=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-625-7G6VOaWmNpWNdooVZCZpcQ-1; Tue, 09 Aug 2022 07:45:31 -0400
X-MC-Unique: 7G6VOaWmNpWNdooVZCZpcQ-1
Received: by mail-vk1-f198.google.com with SMTP id i194-20020a1f9fcb000000b00378d8296805so2428414vke.1
        for <netdev@vger.kernel.org>; Tue, 09 Aug 2022 04:45:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YrRdlwFzhyL1JgoDWLNI0P7/kC4GOv+tysqYh41vN90=;
        b=30Af24thb06yTVtN/Yb8ePcWnF2ntcewizucd4CBKc4K9vZ5Wm2xqqlc1cor3T6VHh
         +J3YYxI9JII62WpVtriAZxgkpVSO5GZYeZNeCLb6mHPnReJepZr+jjgyq5HtlPYvAnB6
         j9sIcwDWN6KSNK+BHqwFHE4jIC6YovYglkdiL2Bqu6hMfEgsNsPkvkvpTSB9x05Cp1pK
         56+1/M2PuC/7avmIFFnOjW77kG+mtTAH4WTyuei6KDQtcyaE7qcvUzE591RmM44lKTdG
         XRYtwRlAplChusRLEt6f1HfgmSI2NXDDnoaZibgXG45nZwcFm2bVcyzjMu2aXKlgptXq
         XK+A==
X-Gm-Message-State: ACgBeo3x6icipnCWeBm3ja8oIzIlDgeXyjKnd45gkzXZkICnQ4FM6SR2
        x+tFdPcfnhGUWAX98PMUBpTNY6yoOlJAQpcKFLBikzguSRAn/BL57zyVRmgFjhawj4GQAckQUXF
        +xHZguouBMd6+9B6o/K1SicwdqR+p5VeJ
X-Received: by 2002:a05:6102:5cb:b0:388:9ab7:5f58 with SMTP id v11-20020a05610205cb00b003889ab75f58mr5724775vsf.68.1660045530353;
        Tue, 09 Aug 2022 04:45:30 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7ATkZeriMmKJlv9Q/gYEYNsFbbd3PSLoYo/Er47sV5yGli/esQODsILES0uQaO3ilqkvc1/fcF5waK8hyF1xI=
X-Received: by 2002:a05:6102:5cb:b0:388:9ab7:5f58 with SMTP id
 v11-20020a05610205cb00b003889ab75f58mr5724765vsf.68.1660045530147; Tue, 09
 Aug 2022 04:45:30 -0700 (PDT)
MIME-Version: 1.0
References: <20220715125013.247085-1-mlombard@redhat.com> <20220808171452.d870753e1494b92ba2142116@linux-foundation.org>
In-Reply-To: <20220808171452.d870753e1494b92ba2142116@linux-foundation.org>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 9 Aug 2022 13:45:19 +0200
Message-ID: <CAFL455nMBPMD2KkdnsWrq6x_XjwdRCTsCe0Ohbm9Df7aTfiq_A@mail.gmail.com>
Subject: Re: [PATCH V3] mm: prevent page_frag_alloc() from corrupting the memory
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?UTF-8?B?5oSa5qCR?= <chen45464546@163.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=C3=BAt 9. 8. 2022 v 2:14 odes=C3=ADlatel Andrew Morton
<akpm@linux-foundation.org> napsal:
>
> On Fri, 15 Jul 2022 14:50:13 +0200 Maurizio Lombardi <mlombard@redhat.com=
> wrote:
>
> > A number of drivers call page_frag_alloc() with a
> > fragment's size > PAGE_SIZE.
> > In low memory conditions, __page_frag_cache_refill() may fail the order=
 3
> > cache allocation and fall back to order 0;
> > In this case, the cache will be smaller than the fragment, causing
> > memory corruptions.
> >
> > Prevent this from happening by checking if the newly allocated cache
> > is large enough for the fragment; if not, the allocation will fail
> > and page_frag_alloc() will return NULL.
>
> Can we come up with a Fixes: for this?

I think the bug has been introduced in kernel 3.19-rc1
Fixes: ffde7328a36d16e626bae8468571858d71cd010b

>
> Should this fix be backported into -stable kernels?

Yes, IMO this should be backported to -stable

Thanks,
Maurizio

