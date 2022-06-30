Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3E5E56189F
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 12:59:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233795AbiF3K7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 06:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230341AbiF3K7E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 06:59:04 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D16A142A3F
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656586742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=u4SjDbVVWNYM18ADMvqxFYQQNU0RZaZbfLhHUkl51ig=;
        b=OgzphNkWLKzxoAYpYv3ar4IryIB8tBL+607RriuqQzm/8Ny4fIiSBASrbnQ71+tSuL+VFl
        xtB9QvgVa65IcggoK/0wn4E+gldTTDCuk3nPeCiTjcCBmROswN74F3Uk9VjY7tzLGzYF2L
        vKjIyvObjXl0oMvdNohZvoZRshf367A=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-578-1P_0_hk4On-65SBe3wEurw-1; Thu, 30 Jun 2022 06:59:01 -0400
X-MC-Unique: 1P_0_hk4On-65SBe3wEurw-1
Received: by mail-qk1-f198.google.com with SMTP id m15-20020a05620a290f00b006a74cf760b2so19196871qkp.20
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 03:59:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=u4SjDbVVWNYM18ADMvqxFYQQNU0RZaZbfLhHUkl51ig=;
        b=jZhREXrvR4f9dZCRBq+kfQqrC8oTW/4c9gKZFhBCpVc98aozEHs+0qzfyZaYc823+s
         wOlMaXABaYM4rVPznrd02T8heV55brPdT6+lj6L12OP2zjuS0YaN4h1sWkzGGq5h4ldR
         ODquwVEqz4ZeqWWTrw1hir1UI7cWqg0eto2577Ggg+yMjZ8FSCtI3ogS/q+IAcCRWLBV
         38jvAjyFuyMOx3xzJDXTT1KQ2p5sN1Z8gXeVsBse4wMKTh4+vTcu9BELAv4uh4al9oUt
         87bGCylNOx0maFMCDfcM7hsit5nUvuchRSHyQT6DLO4NXdvqZNr9CeXQATBFZP66gosB
         6wXw==
X-Gm-Message-State: AJIora/bbeWga6MRpecMOqGS8ZBtEpZZJxL+Y8rGw2xgWVT13cW3qNtc
        TyCoLzAyIMfR0w0PpY84dqkvd4P9Mfh9oeQQgVgoMBzKc91MkhEyFHRQGqED2g959etkgZmP+C3
        uEv6KmG6+5fjA+2yP
X-Received: by 2002:a05:620a:4249:b0:6a8:b684:a1c6 with SMTP id w9-20020a05620a424900b006a8b684a1c6mr5671158qko.64.1656586741117;
        Thu, 30 Jun 2022 03:59:01 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sdcMLjk9I06I9o/rnhA8cBS87Y2V9VdLcS6owOG/4P0/PUwML68oPAoacDdDraAX6CSTrlaA==
X-Received: by 2002:a05:620a:4249:b0:6a8:b684:a1c6 with SMTP id w9-20020a05620a424900b006a8b684a1c6mr5671153qko.64.1656586740888;
        Thu, 30 Jun 2022 03:59:00 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-106-148.dyn.eolo.it. [146.241.106.148])
        by smtp.gmail.com with ESMTPSA id n8-20020a05620a222800b006ab935c1563sm14397231qkh.8.2022.06.30.03.58.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jun 2022 03:59:00 -0700 (PDT)
Message-ID: <0cddb061e2b863c9f4a652e923d0b689ec7ecd30.camel@redhat.com>
Subject: Re: [PATCH] drivers: Remove extra commas and align them
From:   Paolo Abeni <pabeni@redhat.com>
To:     Li kunyu <kunyu@nfschina.com>, rajur@chelsio.com,
        edumazet@google.com, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 30 Jun 2022 12:58:56 +0200
In-Reply-To: <20220629083530.48186-1-kunyu@nfschina.com>
References: <20220629083530.48186-1-kunyu@nfschina.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-29 at 16:35 +0800, Li kunyu wrote:
> There is an extra comma and space in this sentence when I read the code.
> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>

Sorry, I'm going to be quite nitpicking on this kind of patches. Please
try to stick to a consistent format, see Jakub guidance:

https://lore.kernel.org/all/20220623092208.1abbd9dc@kernel.org/

e.g.

<sub-system>: fix typo in <somewhere>

Remove the repeated <what> from <somewhere>

Thanks!

Paolo

