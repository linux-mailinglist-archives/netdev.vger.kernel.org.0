Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA0C63A1F3
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 08:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbiK1HZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 02:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiK1HZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 02:25:36 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B9DA463;
        Sun, 27 Nov 2022 23:25:35 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id w23so9306432ply.12;
        Sun, 27 Nov 2022 23:25:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gZsvAB7+KMmeT51IDp0sVTDeYAZgr+2zN8e+PrTd+Uk=;
        b=WeyZhwB5mrh4BETatjx32hXPF69BDlypKUCvSLDGeY40SLG7v71TzYzVgST1uaBANy
         o6uXJZyQRonxAyaZr+83o4kD/DFg1I7VIr/9doF8XnHLIb9ADo6ekVrn3/d7aU0oCYqi
         YTnwrPqmht1NgXQRVPEaUzrtN59UWacEpxKQeIxv0UD1UWT1YTt+n6Pse3MOcPs2zzcn
         esUDzDTB5/6xXSq0ks8p7XeIQ9Ihb6NLuY5+42zo31BawAVngQBqbi5zIEo+ugnM2Y8v
         6ojmKRWTTCQsDfZe6J8Banow13iK/ytdfT8ZXsKHatoHaXROpZ7ihz5YS06V/eEaG1jK
         FpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gZsvAB7+KMmeT51IDp0sVTDeYAZgr+2zN8e+PrTd+Uk=;
        b=uNq8ALhXLTCRxAmPS9bUchZ90gbz2T3Qi0mnMIBdY5MkZjje8NiIheFyWpTZxXm/q+
         K8gX3QFQiWxdlZa0F4UXnMD+o0nOEPwz9gVXcjG2Vfr8HcrYBSEdNv0mmcwHHbpsDeG/
         k9V3Fo/ew9iPjpBSf7veCuJXyyChhHpnfBdcQCeh/rvu3sMFUIEVI8PIkrmUp0CSkDXE
         tlqBy0SMUqy6S8oFnjxz4NqeDwjfixD6mriQILT+k/AUxBVsL7LXt8opiJXmqbJRwl/+
         pypJoWXfhTES1fIWITXTENoKz+oKrd9qQBuHjUBOMqshWQCzd7fRT0PMi58LRhg+YQdJ
         dMiQ==
X-Gm-Message-State: ANoB5pkq14jUc/iKMTBhjU+aufGrFPCGAXkruqvmeD5xgyd1staJ5hEc
        or7W4gQjj0pZKs+wo4k5Ops=
X-Google-Smtp-Source: AA0mqf5nmOWufo7aRQ/ePgMfq5CkCGRjDBV1BJYeukGhz9Ywc/Lbh5aHF7Q5xZecq56Zs3MOHo9s7Q==
X-Received: by 2002:a17:90a:9f03:b0:211:59c6:6133 with SMTP id n3-20020a17090a9f0300b0021159c66133mr53036655pjp.238.1669620334871;
        Sun, 27 Nov 2022 23:25:34 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id g199-20020a6252d0000000b005742ee445fdsm7264625pfb.70.2022.11.27.23.25.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Nov 2022 23:25:34 -0800 (PST)
Date:   Mon, 28 Nov 2022 15:25:28 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/tls: Fix tls selftests dependency to correct
 algorithm
Message-ID: <Y4RiaNlXlaHK55Ih@Laptop-X1>
References: <20221125121905.88292-1-tianjia.zhang@linux.alibaba.com>
 <Y4NVcV1D/MhFJpOc@Laptop-X1>
 <4f84f23e-2835-c1b7-93f5-2730ec8b94fc@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4f84f23e-2835-c1b7-93f5-2730ec8b94fc@linux.alibaba.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 28, 2022 at 03:14:16PM +0800, Tianjia Zhang wrote:
> Hi Hangbin,
> 
> On 11/27/22 8:17 PM, Hangbin Liu wrote:
> > On Fri, Nov 25, 2022 at 08:19:05PM +0800, Tianjia Zhang wrote:
> > > Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory") moves
> > > the SM3 and SM4 stand-alone library and the algorithm implementation for
> > > the Crypto API into the same directory, and the corresponding relationship
> > > of Kconfig is modified, CONFIG_CRYPTO_SM3/4 corresponds to the stand-alone
> > > library of SM3/4, and CONFIG_CRYPTO_SM3/4_GENERIC corresponds to the
> > > algorithm implementation for the Crypto API. Therefore, it is necessary
> > > for this module to depend on the correct algorithm.
> > > 
> > > Fixes: d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory")
> > > Cc: Jason A. Donenfeld <Jason@zx2c4.com>
> > > Cc: stable@vger.kernel.org # v5.19+
> > > Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> > > ---
> > >   tools/testing/selftests/net/config | 2 +-
> > >   1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
> > > index ead7963b9bf0..bd89198cd817 100644
> > > --- a/tools/testing/selftests/net/config
> > > +++ b/tools/testing/selftests/net/config
> > > @@ -43,5 +43,5 @@ CONFIG_NET_ACT_TUNNEL_KEY=m
> > >   CONFIG_NET_ACT_MIRRED=m
> > >   CONFIG_BAREUDP=m
> > >   CONFIG_IPV6_IOAM6_LWTUNNEL=y
> > > -CONFIG_CRYPTO_SM4=y
> > > +CONFIG_CRYPTO_SM4_GENERIC=y
> > >   CONFIG_AMT=m
> > > -- 
> > > 2.24.3 (Apple Git-128)
> > > 
> > 
> > Looks the issue in this discuss
> > https://lore.kernel.org/netdev/Y3c9zMbKsR+tcLHk@Laptop-X1/
> > related to your fix.
> > 
> 
> Thanks for your information, it is indeed the same issue.I don’t know if
> there is a patch to fix it. If not, can this patch solve this issue? If
> so, can I add Reported-by or Tested-by tag?
> 

Feel free to add Reported-by flag. I can't test this unless the patch merged
to upstream.

Thanks
Hangbin
