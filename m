Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E184F9D6C
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 21:03:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232858AbiDHTFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 15:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbiDHTFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 15:05:36 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAEDF8EC7
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 12:03:31 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id d4so6457198iln.6
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 12:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=EmpIHUvvLvr9CA1iFxWo85RHuJ+tJ93BQ1YVBcvN1g4=;
        b=l+vUAqvhqxl6jbomX8ReSfNPzhLq3OjbhSYzdde6TcTKBEbfjDBkC6/6Bt7qYA3biS
         NtjgjWpszwjupJZlw1OnTK6+jRMM94FzUN4EWiPLYK8iFFdTTIWjr0Uj+gQ63EvkhYHo
         x3yp7Y0VX+VaFhluGBQRX7PGxbIxy7HDe358Qpd2fdLAxtnAncWJL6UD+H9YP2FWjbaO
         VdMToInUwz9uyVkp3aqzuDw2wMJoa9GGHrCr3/EDQQRalYSz3abTFDhfLLsfInuzdyJi
         Ltyghie7q8eZN3DIjHm38iCrqwxLQY0+RY0qHbU9XPVxgDUfNC+e1lgZUNhFAmT6xbTi
         +WdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=EmpIHUvvLvr9CA1iFxWo85RHuJ+tJ93BQ1YVBcvN1g4=;
        b=32ih29W/jkbdEOLntrzknLnA2ZrbBIz/yCVmkv7/FQaLnXx57jOND444Co6rE0BQGZ
         rjyCgH1UI8+KwuF2RoQpbPVlysdCzGVGfOwIPu8uzi8sx7BFGvz2IIXpy536uqV47jPh
         hpLA0OvIqbeGIZmjN0eBnKhMrr9qDrvBYCqaKM4gmL85RY3paSUdkm9x8D68BO/BZEWP
         IIlYYOpEvkFKpv16r8/HhcDIMBCLhBs0+GijSgZgj6sfSvGnSNaOKd9LcNNILmBaGtd9
         aC9LjXbqjW82q0/gNkNQrakwrpCAzUWeBGv4DAhjmowDdxdAR59jvS9PPr7nJuIISI/N
         FGiQ==
X-Gm-Message-State: AOAM533kmLb+WLBDGfxv0k7JEzPuSNob+CBAVL2QdBb6quAsH3Zcryb+
        SQrVfHJp+2n1LuTOcUaiGRU=
X-Google-Smtp-Source: ABdhPJzWtk/h7aPKe25/M3QkJ6kO4OxUA0UeT9siclb/HtLtC/G3MeWYCkQvtKQTKQWvNPcXELhCOg==
X-Received: by 2002:a05:6e02:1d16:b0:2c9:d7e1:e949 with SMTP id i22-20020a056e021d1600b002c9d7e1e949mr8623414ila.125.1649444611165;
        Fri, 08 Apr 2022 12:03:31 -0700 (PDT)
Received: from localhost ([99.197.200.79])
        by smtp.gmail.com with ESMTPSA id l9-20020a922909000000b002ca4ef64362sm8518903ilg.84.2022.04.08.12.03.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Apr 2022 12:03:30 -0700 (PDT)
Date:   Fri, 08 Apr 2022 12:03:22 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net,
        vfedorenko@novek.ru, Jakub Kicinski <kuba@kernel.org>
Message-ID: <625086fa2faf3_3f3c220854@john.notmuch>
In-Reply-To: <20220408183134.1054551-1-kuba@kernel.org>
References: <20220408183134.1054551-1-kuba@kernel.org>
Subject: RE: [PATCH net-next 00/11] tls: rx: random refactoring part 2
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski wrote:
> TLS Rx refactoring. Part 2 of 3. This one focusing on the main loop.
> A couple of features to follow.
> 
> Jakub Kicinski (11):
>   tls: rx: drop unnecessary arguments from tls_setup_from_iter()
>   tls: rx: don't report text length from the bowels of decrypt
>   tls: rx: wrap decryption arguments in a structure
>   tls: rx: simplify async wait
>   tls: rx: factor out writing ContentType to cmsg
>   tls: rx: don't handle async in tls_sw_advance_skb()
>   tls: rx: don't track the async count
>   tls: rx: pull most of zc check out of the loop
>   tls: rx: inline consuming the skb at the end of the loop
>   tls: rx: clear ctx->recv_pkt earlier
>   tls: rx: jump out for cases which need to leave skb on list
> 
>  include/net/tls.h |   1 -
>  net/tls/tls_sw.c  | 264 ++++++++++++++++++----------------------------
>  2 files changed, 104 insertions(+), 161 deletions(-)
> 
> -- 
> 2.34.1
> 

Thanks for doing this Jakub much appreciated on my side and been on my todo
list for way too long.

Acked-by: John Fastabend <john.fastabend@gmail.com>
