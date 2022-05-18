Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC0BB52C4B2
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 22:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242752AbiERUmu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 16:42:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242734AbiERUmt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 16:42:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 411267093D
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:42:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652906567;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Eci3SfR9YUT02jjJEGOCrPhcn1ykfe0qhbLzqAWYbYc=;
        b=H8XTlsIQ68/CD4Ahe+jpAAz9el+0Nyx0w8q6E4W7ziwSnYGH4zLRzTAkAfaUxP7jbMrtGg
        sao3jHZM/mJ9wXQdl+tDKAmE+VFu6Vqrpp50u6cxsIPvYyymOyAIgx2N1C/g32N0toDY65
        8jI+gb5vKAh2ApYA9WiHpoabjEJjX9Y=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-489-JteCan_aPF-ppUjGYM8XdA-1; Wed, 18 May 2022 16:42:45 -0400
X-MC-Unique: JteCan_aPF-ppUjGYM8XdA-1
Received: by mail-ej1-f70.google.com with SMTP id sc20-20020a1709078a1400b006f4a358c817so1507009ejc.16
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 13:42:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=Eci3SfR9YUT02jjJEGOCrPhcn1ykfe0qhbLzqAWYbYc=;
        b=IfaaBcac88nD0mk/zQEWWyotj+KFjDJg76cNHVO2vZ/XZDTJdGx1MexHEiJo88TShm
         7X5UDESS4+k5PbtrTyu269IJHUry/JLWBYQC7U/TWUDQ9kc5dVsib3KQGRLVqlCyXAs4
         Cz7683TO3RmhwcRDjxTvBwtFcusNFjSszRGzfe6on/OVjwz4r1odnNbTfF8jNz3lVw0E
         MP7Y99nFlyrIEoA7Pp5T+qlo4y61HkFy5O+J+qmyGGUB9EutvXzB72hS8HZLvg0AsZx3
         IeIxrguIMDvDT9vVl2H4ipB44dRw+0GtKSHLh6ggQE/E32og2MMgQ5Y/V4wXK92KWVfr
         rjLg==
X-Gm-Message-State: AOAM530fMF7CHagJtOxaTxCBaeMBzUbWQTLa3ykCW00GvQ/B289J+2aH
        eeRLBnDeX8VhAv+Zf0gPfhQaSwNgxz1L7p2ZJV4759gQ4wdN1b4twGigFcSh4AUxkwDS6tMhhUe
        daQX2PFI3QlaoOn41
X-Received: by 2002:aa7:d4c8:0:b0:42a:a406:a702 with SMTP id t8-20020aa7d4c8000000b0042aa406a702mr1680061edr.129.1652906564010;
        Wed, 18 May 2022 13:42:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyaqWlxarRMeh6CgpYv/fRqcKPVWXuO9Nbg7+k5CvmvDj/SuWDwKuUZSM9e5xnDaJyqDSUDhQ==
X-Received: by 2002:aa7:d4c8:0:b0:42a:a406:a702 with SMTP id t8-20020aa7d4c8000000b0042aa406a702mr1680003edr.129.1652906563243;
        Wed, 18 May 2022 13:42:43 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id a2-20020aa7d742000000b0042617ba638esm1840273eds.24.2022.05.18.13.42.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 13:42:42 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id DA44A38ECC3; Wed, 18 May 2022 22:42:41 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com, brouer@redhat.com, memxor@gmail.com
Subject: Re: [PATCH v3 bpf-next 3/5] net: netfilter: add kfunc helper to
 update ct timeout
In-Reply-To: <9651ce53e74ce0d0b200fe9d40875e5119ba6c94.1652870182.git.lorenzo@kernel.org>
References: <cover.1652870182.git.lorenzo@kernel.org>
 <9651ce53e74ce0d0b200fe9d40875e5119ba6c94.1652870182.git.lorenzo@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 May 2022 22:42:41 +0200
Message-ID: <871qwqa7y6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

> Introduce bpf_ct_refresh_timeout kfunc helper in order to update
> nf_conn lifetime. Move timeout update logic in nf_ct_refresh_timeout
> utility routine.
>
> Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

