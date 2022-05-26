Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CD5F534C1E
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:59:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234066AbiEZI7b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232391AbiEZI7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:59:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 38705A7E39
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653555568;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QBuQubLXsKdHypsOLS0DFxdMqRgrnMQKA1oWPGoQKlI=;
        b=Ljly1e9wzrW8u5S9J4AMm5uY2/UH3i0p3kWkw38uFTCnONZpVTWSIHgd9fL6XITOIhjf1k
        vpjYGbHspViSqCnN8VTEUzR+v9/t7wb4WVpyqLUHDxqWAyQFtES3Obg+6TlVEYbBvOvtEx
        7nxM5S4JJC9ki+H08qci5b5dJX/hHGw=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-642-R9eumCLiMFiPioJRX9m8lg-1; Thu, 26 May 2022 04:59:26 -0400
X-MC-Unique: R9eumCLiMFiPioJRX9m8lg-1
Received: by mail-wr1-f71.google.com with SMTP id w17-20020adf8bd1000000b0020fc99aee61so151909wra.18
        for <netdev@vger.kernel.org>; Thu, 26 May 2022 01:59:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QBuQubLXsKdHypsOLS0DFxdMqRgrnMQKA1oWPGoQKlI=;
        b=shZnl/KQhwEbH+g6dRMeNx35ov2pRhQH1SUfUc18us00YSkrAs4K3w8yQvcs9jF1O3
         IV/hPWJyNZ8wKGWMF8pETQA+6LgAAbWLzrGj+4Wyx3bVzI5ynLDuOXUMizVbhfhD/+es
         DRBUK5YVNoAfcndej4cjSis4CAAryzS8PrUeOlgdAae46P8JbsjYFgyh6qlSQbAS2rek
         j0s+DDvf2bT5Dhk0hqLCW2bb9a6NUPU5GZUI4kzRQudsqlHA9A5Y1D6fNPuyPTKXjdjX
         LtrVUIcgMh3Z9muiOXgSSTSOJrlQYrMJGxJxi9C4Vo3zv55ovDVuaOQELkvkYcLfpJWJ
         y0fg==
X-Gm-Message-State: AOAM530j7shQEbO4V5amMZWax04PBYdlkG/VoKLqtOzKCByOoxmOafPL
        mIUKlRjSCrhCBMz1e5marxAeIQmdELy4WVSn3+p4fpTIE4oks6+fDhqdcWO4RXVAyUyzM2kQEGk
        aT8uK6AX3Rjf2gk3Q
X-Received: by 2002:a05:6000:1acc:b0:20f:f12a:a535 with SMTP id i12-20020a0560001acc00b0020ff12aa535mr10151109wry.375.1653555565582;
        Thu, 26 May 2022 01:59:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxCzonV2Cu3c/gBioAW18CkReONSq7IWRWZkImNQWIDlZfYH8w2iZN8Bzrt8eIEu0exVcGFWg==
X-Received: by 2002:a05:6000:1acc:b0:20f:f12a:a535 with SMTP id i12-20020a0560001acc00b0020ff12aa535mr10151093wry.375.1653555565296;
        Thu, 26 May 2022 01:59:25 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id c124-20020a1c3582000000b003973ea7e725sm4616302wma.0.2022.05.26.01.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 01:59:25 -0700 (PDT)
Message-ID: <de4aab60766b3de8705b09e36b8050feb92865ec.camel@redhat.com>
Subject: Re: [PATCH net] net: macsec: Retrieve MACSec-XPN attributes before
 offloading
From:   Paolo Abeni <pabeni@redhat.com>
To:     Carlos Fernandez <carlos.escuin@gmail.com>
Cc:     carlos.fernandez@technica-engineering.de,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Era Mayflower <mayflowerera@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Date:   Thu, 26 May 2022 10:59:23 +0200
In-Reply-To: <20220524114134.366696-1-carlos.fernandez@technica-engineering.de>
References: <20220524114134.366696-1-carlos.fernandez@technica-engineering.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-05-24 at 13:41 +0200, Carlos Fernandez wrote:
> When MACsec offloading is used with XPN, before mdo_add_rxsa
> and mdo_add_txsa functions are called, the key salt is not
> copied to the macsec context struct. Offloaded phys will need
> this data when performing offloading.
> 
> Fix by copying salt and id to context struct before calling the
> offloading functions.
> 
> Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>

I'm sorry to nick-picking again, but this patch don't pass checkpatch
validation:

https://patchwork.kernel.org/project/netdevbpf/patch/20220524114134.366696-1-carlos.fernandez@technica-engineering.de/

Specifically, you should add a 'From:' tag as the first line:

From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>

(Or send this patch from the above email address)

Thanks!

