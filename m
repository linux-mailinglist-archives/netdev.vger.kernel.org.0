Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 150E5571228
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 08:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiGLGO2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 02:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiGLGO1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 02:14:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 464E92F029
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 23:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657606466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eYT+ITlCaYSMnMjS+YUZvQG77DKux5aQt8JEfh9jXQI=;
        b=iFxw4/9nMxjjopTepAmNfqtshKJTBdvf371GqD+ohE8w9L0KLJv24AlfwzMlYZYfAp/cJI
        25vJIkIBaq5sRQ+aEIfaWGCCbGyA+xdmpVui62XsdH2IZqjTDxzVLmvgx32x7F9x5lzlVO
        uuBinIo8duZ6GDvucGFXl+MNvVRWwgo=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-374-BtY-cSp3MB2eASSpo9kGbg-1; Tue, 12 Jul 2022 02:14:24 -0400
X-MC-Unique: BtY-cSp3MB2eASSpo9kGbg-1
Received: by mail-qk1-f199.google.com with SMTP id k190-20020a37bac7000000b006af6d953751so7108201qkf.13
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 23:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=eYT+ITlCaYSMnMjS+YUZvQG77DKux5aQt8JEfh9jXQI=;
        b=heZ+DCE0ETJ+bmZjBLix5qj13+/Yh6ij1cu43c+L0oQKPKL8Vc8nWrNst3EIMRUu5S
         ddOcztyIsYA8ELv+2afk5XdEUu68me/PZ8uftDQM7HWCQUUNwv4MV40NmmfbbT6WPf0r
         cJeVS2pC8O7BHE8Y2PXxR982C2StfF8QXMsBqbNbTqmfFm6PDkv8rWP8PPiEh10Q45d4
         hMSBI4TIVuOBKYSK721zzdJO/MZ4ZEHYQzq9WX8iPC3FZlnzQxKZgDkgg5r4GoKe6s0L
         O72ZOwcuE58PUtsTE41QMy1KarE53Xi8AidG/Bcn+RrYRlhSLA0/yoAkp5TC+Ubgx4o4
         Od7g==
X-Gm-Message-State: AJIora+zNjTeC3GTwLlhAJsBX2IIk+WYeCXEj/A2WZwY1Rbtsc9D7u36
        lzkmn0NoRAzgDcz96Ny3JKDYcRsoRxTpKNVrpBOKCvcGhuzMSttFNv0RR3P8pVasRQfhxcIHouo
        lLfBcCt8V3E+GbJd55uUi0GgvhnXkoor6
X-Received: by 2002:a05:620a:f12:b0:6b5:4524:37f8 with SMTP id v18-20020a05620a0f1200b006b5452437f8mr14282725qkl.77.1657606464065;
        Mon, 11 Jul 2022 23:14:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vn8y6LDQfjdSpBmMDJICjGUMAJ4OyT/vDJ4ZZaEy9bDr033DYhi2SSTSMCxiu3Bv+J2irvwbAqigXw7/0lbyo=
X-Received: by 2002:a05:620a:f12:b0:6b5:4524:37f8 with SMTP id
 v18-20020a05620a0f1200b006b5452437f8mr14282717qkl.77.1657606463864; Mon, 11
 Jul 2022 23:14:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220711134520.10466-1-ihuguet@redhat.com> <20220711203853.72f7565d@kernel.org>
In-Reply-To: <20220711203853.72f7565d@kernel.org>
From:   =?UTF-8?B?w43DsWlnbyBIdWd1ZXQ=?= <ihuguet@redhat.com>
Date:   Tue, 12 Jul 2022 08:14:13 +0200
Message-ID: <CACT4ouf8whj4s5DxROOFpmPGCk92N+3iJh383n0ULP5he+pMYw@mail.gmail.com>
Subject: Re: [PATCH net] sfc: fix use after free when disabling sriov
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Yanghang Liu <yanghliu@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 5:39 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 11 Jul 2022 15:45:20 +0200 =C3=8D=C3=B1igo Huguet wrote:
> > Use after free is detected by kfence when disabling sriov. What was rea=
d
> > after being freed was vf->pci_dev: it was freed from pci_disable_sriov
> > and later read in efx_ef10_sriov_free_vf_vports, called from
> > efx_ef10_sriov_free_vf_vswitching.
> >
> > Set the pointer to NULL at release time to not trying to read it later.
>
> Please add a Fixes tag and repost. Does ef100 need the same fix? :(
>

OK, will do. ef100 doesn't seem to need this, but I can't test because
I don't have any of these cards.

--=20
=C3=8D=C3=B1igo Huguet

