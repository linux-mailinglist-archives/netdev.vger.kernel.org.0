Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9F59553259
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 14:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349712AbiFUMoR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 08:44:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231252AbiFUMoQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 08:44:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id F393212091
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 05:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655815455;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pd3J8JPqD6kQCuJIr3RkUpHfIhmcn3pD2QOgK4NseCA=;
        b=HIG/I/DuWYsuYf2KzovT85afEtuYj1GOvXIzlfUy78VHi30k4w05w9VweSEcqmrDb7Ibax
        KcAMVRrZsk0+HUlJNn3VkdnsfzJstmtMm+Ttb6oSnlfmlaaKtRljQhcUEQFvC26Gk289M3
        rd9meM688BpnKcGZqRpOxt2usZyc0EE=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-a2nXg2nVO8S2uEz_FOCwuQ-1; Tue, 21 Jun 2022 08:44:14 -0400
X-MC-Unique: a2nXg2nVO8S2uEz_FOCwuQ-1
Received: by mail-qk1-f197.google.com with SMTP id f2-20020a05620a408200b006ab94bb9d09so12470127qko.8
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 05:44:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=pd3J8JPqD6kQCuJIr3RkUpHfIhmcn3pD2QOgK4NseCA=;
        b=zXdbGjniwKvXPx4OApKTypJXljM3C2FSZrw74DW1yr7pggTPCaqyy+jqAA+vUNZMzc
         7qLPdRIQLVRHaaNXvi7JtfISZ60pYLbVJ8H3Wtkjmeye3iSRmTsUwmQEJcObslbQ2dCc
         4QPQcZRf3uN621TseiftKWkIV68repHM0M2x6Yycv+LH7ZY0HJvWVY/EJTFu88bHJmHZ
         M3JgV8JuSIBz5kE492Ldy1chPqhO4pqxp1VcgK418tCbCbWkfwLRUBH/amNQWX1JBEfD
         Ls7CdDuLHy6FOC6zy6d7A9VlzkB56nms4xlRZV41z9lHzRAbkikdc+BIRJbmynv7spSp
         PWEg==
X-Gm-Message-State: AJIora+Lv15FzEuZFwlVGomZ4T0U5xMeEQNAF+6K4NAbYd3778QPnZiS
        6qJFO+vrgCNDlfDAunv/nGlQzbdKQdN0JYvJtmgRh2UxdNAuO7vIe2HG3jwyvSNVYzkSXuj5HwI
        di7fGguFpi20RPGS3
X-Received: by 2002:a05:6214:2387:b0:462:1026:b5bb with SMTP id fw7-20020a056214238700b004621026b5bbmr22701918qvb.38.1655815453522;
        Tue, 21 Jun 2022 05:44:13 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tl5Wy1PtQlDXj7T0ffzeIB1VreIVB3C7u7MFwraFIWuaNtbq29rZAPOM9xwPa1YpQlcmTPbA==
X-Received: by 2002:a05:6214:2387:b0:462:1026:b5bb with SMTP id fw7-20020a056214238700b004621026b5bbmr22701903qvb.38.1655815453299;
        Tue, 21 Jun 2022 05:44:13 -0700 (PDT)
Received: from [192.168.98.18] ([107.12.98.143])
        by smtp.gmail.com with ESMTPSA id d14-20020a05620a240e00b006a6b6638a59sm14835072qkn.53.2022.06.21.05.44.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jun 2022 05:44:13 -0700 (PDT)
Message-ID: <91d441d8-ee1a-4ab3-fe04-1d7ff13fc6f1@redhat.com>
Date:   Tue, 21 Jun 2022 08:44:11 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCHv3 iproute2-next] iplink: bond_slave: add per port prio
 support
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>, netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        David Ahern <dsahern@gmail.com>
References: <20220621074919.2636622-1-liuhangbin@gmail.com>
 <20220621075105.2636726-1-liuhangbin@gmail.com>
From:   Jonathan Toppins <jtoppins@redhat.com>
In-Reply-To: <20220621075105.2636726-1-liuhangbin@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/22 03:51, Hangbin Liu wrote:
> Add per port priority support for active slave re-selection during
> bonding failover. A higher number means higher priority.
> 
> This option is only valid for active-backup(1), balance-tlb (5) and
> balance-alb (6) mode.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Acked-by: Jonathan Toppins <jtoppins@redhat.com>

> ---
> v3: no update
> v2: update man page
> ---
>   ip/iplink_bond_slave.c | 12 +++++++++++-
>   man/man8/ip-link.8.in  |  8 ++++++++
>   2 files changed, 19 insertions(+), 1 deletion(-)
> 

