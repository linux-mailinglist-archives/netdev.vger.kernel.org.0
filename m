Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79A44E3A66
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230197AbiCVIT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiCVITy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:19:54 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E35657B35
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 01:18:26 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v2-20020a7bcb42000000b0037b9d960079so920937wmj.0
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 01:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5UxJmCwjEEag9rjBtl+ewwyVb4cWzauTAa4F8rEsb6k=;
        b=JXTVpg4QjROIqpgL1Um2mz5wNyA+41lhiKq5OgVagcXfDCtHsjHD8IoFbfLwBF+7Hh
         BrpSNYYj7j3I3Y2ms/nqoVMaqpJYsCcdaKwjIsVvXGCtpmFDJFjeCKlcpPJKVFv8Ai5w
         VKmmPSP+Eg9te9VqvtzYBmodvDoALl1AlPdkUt0x97/14gDkCDyYPsPhG0E+CDeOERqT
         QNgtA5IY8ca/rjs2rJGg5GQVcmIhPgQ2haV0cWpbttfk3USbkn7K7pdqk+TZT4oWecwX
         iXS/LHoyrw8AoC/ZV59UHoFnUfV0ZBuygueoMM6Vi1cZvgsx5ye1UAiiOn8ARKU7qUkl
         Jjzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5UxJmCwjEEag9rjBtl+ewwyVb4cWzauTAa4F8rEsb6k=;
        b=eYkVLJ6iRZ1GC0Ec3cKFTAcXHFPY78fb98x1St6ZEBsHgfyNoLunY2KagcebLmy4BE
         6FhVo4fywkU3XB+W0NRwULIeMHLZBXQz+FJPigoXe1goX1TZjBP521HR37PvqFVmETnS
         0zyDSEmdh3CPhEaOrlo4mxl7kseiKZR3Gn7OZDH5FkWkB9i7xb7ZJNwgbBV/QvpJ01VN
         HksirVJV8oFfZQKdwXsa+SfnOYye4/X/iPB6D7u+RpLiC6kvQ+4NI9tgOiFxu+unHTmR
         uRlHmQUfo+QSV5aRFHVrNhsVj2kIISN2GqCdmStLF1BGD5H4wuedZNCzM6yz/lenb3wL
         W6+Q==
X-Gm-Message-State: AOAM532e8WvuYM/lrL75AUf633VLEJ76t/tmyS7NZ8UiyJj1awZdc91p
        T4Ww+KPmKo2o1lxj6LtpEt4=
X-Google-Smtp-Source: ABdhPJzPlIlD/kEdLzHE+WsZ750OIU8WjxLEaPZUPn3r3ivZ00ch2SCE4pYqsC68oJgyU50aSgldfw==
X-Received: by 2002:a7b:c24d:0:b0:38c:68a4:eb4b with SMTP id b13-20020a7bc24d000000b0038c68a4eb4bmr2531419wmj.108.1647937104783;
        Tue, 22 Mar 2022 01:18:24 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id t127-20020a1c4685000000b0038c9eee54eesm1306354wma.26.2022.03.22.01.18.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Mar 2022 01:18:24 -0700 (PDT)
Date:   Tue, 22 Mar 2022 09:18:23 +0100
From:   Casper Andersson <casper.casan@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pabeni@redhat.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next 0/2] net: sparx5: Add multicast support
Message-ID: <20220322081823.wqbx7vud4q7qtjuq@wse-c0155>
References: <20220321101446.2372093-1-casper.casan@gmail.com>
 <164786941368.23699.3039977702070639823.git-patchwork-notify@kernel.org>
 <2c3b730d91c8a39e3e6131237ff1274dbd4b9cbb.camel@microchip.com>
 <20220321124717.610fdcdf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a47d223f28d9aa72536344f1cd7ab3c6cf91fca8.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a47d223f28d9aa72536344f1cd7ab3c6cf91fca8.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I will do a follow up. Thanks for the feedback, Steen.

BR
Casper

On 2022-03-22 09:06, Steen Hegelund wrote:
> Hi Jacub,
> 
> I guess that Casper can fix the issues in a follow up.
> What do you say Casper?
> 
> BR
> Steen
> 
> On Mon, 2022-03-21 at 12:47 -0700, Jakub Kicinski wrote:
> > EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > 
> > On Mon, 21 Mar 2022 14:33:34 +0100 Steen Hegelund wrote:
> > > I have just added some comments to the series, and I have not had
> > > more than a few hours to look at it, so I do not think that you have
> > > given this enough time to mature.
> > 
> > Sorry about that. Is it possible to fix the issues in a follow up
> > or should we revert the patches?
> 
