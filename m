Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715CF566B99
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 14:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbiGEMJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 08:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiGEMIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 08:08:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 02010186EF
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 05:07:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657022874;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rtU/kjgULaXwcfy8e9s7Yd/T+aye61K0bMduomyl2x8=;
        b=ET8aILWa/kDf21auaaZsqvrfavaQc+pcj4IOjSzXbtR5VtSQS4O2Dphs5zfApiwu5f6un7
        GylpZWdDNnUQJ9jdE03EnjhQ+gprUo2F8LXR7Gk1Ohz4DSm9oZCpummFGgI6N2U0pshxrA
        cmjTpZ5dP8nzvRlqbfqrnUT7kqseHcE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-92-7Ak-kYg9ND2PDHynedkCuA-1; Tue, 05 Jul 2022 08:07:53 -0400
X-MC-Unique: 7Ak-kYg9ND2PDHynedkCuA-1
Received: by mail-ed1-f72.google.com with SMTP id g7-20020a056402424700b00435ac9c7a8bso9185912edb.14
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 05:07:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rtU/kjgULaXwcfy8e9s7Yd/T+aye61K0bMduomyl2x8=;
        b=7W3EQIPzZ1oMatbkfygTwvyrfiU5TGMmXgw6zq8sPVQnJ9dYU2Ekd8svABgY+u+mgM
         NZBeGCpk2II29ZNmJ8A+jF4R9ZqmkElgBakVadATZTrs8Q/OoYTTeeRHxroHbaUrgEU/
         tnD82Pi5zBERXtOCotjfP2fqg9bJJgZFXu0N7MQuJkKwM2OrVKfVOgVmQMKLoCZJtDu/
         L0IE4HtIvH5t5MZw8zFrpZwbCx20EXZvdaEGZ1EOcZXqltr9wjm9reQQGU0OZzhfN5es
         BayMt6kyuSQccdeBZKOBx3lPB0QKr3iEF9FzATs5HhUaaULUBpYUCzPEuzoV3sYlG3aU
         /oxA==
X-Gm-Message-State: AJIora+P/K3aV+uMAQbpJ1EPiTTloUHD9AuRQnZhECCkOcohBi+dihrr
        6mPRmLNQvQqo0C1RWDpHpFvCGqNCbSdzbgZNLqRLFNt9eM6AhiHNuVVmXMtDbkYlhZQbMkKcZUP
        XhaX/YifI1kyKUXWjFoARRUtHdDBRTrS0
X-Received: by 2002:a17:907:60cb:b0:726:a69a:c7a with SMTP id hv11-20020a17090760cb00b00726a69a0c7amr34652268ejc.156.1657022871631;
        Tue, 05 Jul 2022 05:07:51 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uhvLESVkJqLMUVkS1+sqRcYMDYYv/DpSqkaUqCJgY9nCI7teVnX7sRGbX5NjXfak1s0+Cw2DXmD+gxM4e1w/E=
X-Received: by 2002:a17:907:60cb:b0:726:a69a:c7a with SMTP id
 hv11-20020a17090760cb00b00726a69a0c7amr34652242ejc.156.1657022871395; Tue, 05
 Jul 2022 05:07:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220704191535.76006-1-vdronov@redhat.com> <YsOKj/GE2Mb2UsYa@zx2c4.com>
 <YsOY/eWq7gRjXJK1@zx2c4.com>
In-Reply-To: <YsOY/eWq7gRjXJK1@zx2c4.com>
From:   Vlad Dronov <vdronov@redhat.com>
Date:   Tue, 5 Jul 2022 14:07:40 +0200
Message-ID: <CAMusb+RLB6-oz10yp9Cdigt0TeJ_85M30bH8snZaeM2CyvUiYA@mail.gmail.com>
Subject: Re: [PATCH] wireguard: Kconfig: select CRYPTO_CHACHA_S390
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        wireguard@lists.zx2c4.com, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Tue, Jul 5, 2022 at 3:51 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> On Tue, Jul 05, 2022 at 02:49:19AM +0200, Jason A. Donenfeld wrote:
> > Hi Vladis,
> >
> > On Mon, Jul 04, 2022 at 09:15:35PM +0200, Vladis Dronov wrote:
> > > Select the new implementation of CHACHA20 for S390 when available,
> > > it is faster than the generic software implementation.
> > >
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Link: https://lore.kernel.org/linux-kernel/202207030630.6SZVkrWf-lkp@intel.com/
> > > Signed-off-by: Vladis Dronov <vdronov@redhat.com>
> > > ... skip ...
> >
> > Thanks for the patch. Queued up as:
> > https://git.zx2c4.com/wireguard-linux/commit/?id=1b4ab028730cd00c144eaa51160865504b780961
> >
> > I'll include this in my series to net.git soon.

Thanks a ton, Jason!
Most appreciated.

> This actually leads to a minor problem:
>
>   WARNING: unmet direct dependencies detected for CRYPTO_CHACHA_S390
>     Depends on [n]: CRYPTO [=y] && CRYPTO_HW [=n] && S390 [=y]
>
> This is of course harmless, since this doesn't *actually* depend on
> CRYPTO_HW. In fact, the dependency on CRYPTO_HW is entirely a mistake
> here that was repeated a few times. I cleaned this up and fixed it in
> this patch:
>
>     https://lore.kernel.org/linux-crypto/20220705014653.111335-1-Jason@zx2c4.com/
>
> So hopefully Herbert will take that for 5.19 and then we'll be all set
> here.
>
> Jason

Whoa, that's... funny. Honestly, I was always wondering why CRYPTO_CHACHA_S390
and friends live in drivers/crypto/Kconfig. Now I know why. The patch
looks great, thank you.

Best regards,
Vladis Dronov | Red Hat, Inc. | The Core Kernel | Senior Software Engineer

