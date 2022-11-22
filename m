Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C123633721
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 09:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232883AbiKVIaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 03:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232866AbiKVIaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 03:30:12 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B22B41988
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 00:28:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669105729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Z94rTogxpTfB3zkjuR47qQ/M+hZd3Seb7BgxdhYJsLY=;
        b=HYwzO/2qwXKZdVlv3ii5rGeS6c8pkk/CyOs7lkWS8c450kkiDQ0jMJAug2Du9q0nTM7LzU
        lgpSqsIWVpLjHASlMe119CzoDioMKZj8mRMhSVk67Bkq6mctc48AnLg6PDVH053xTqc4vw
        ePU/LviwRwqDkiB1Egvk5wo010D0gdo=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-615-eGu0gKSMOjGJWXWmOjH7hw-1; Tue, 22 Nov 2022 03:28:47 -0500
X-MC-Unique: eGu0gKSMOjGJWXWmOjH7hw-1
Received: by mail-qt1-f200.google.com with SMTP id i13-20020ac8764d000000b003a4ec8693dcso14121750qtr.14
        for <netdev@vger.kernel.org>; Tue, 22 Nov 2022 00:28:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Z94rTogxpTfB3zkjuR47qQ/M+hZd3Seb7BgxdhYJsLY=;
        b=O9M+wRPKpjliwL29/FgvZ2Omf6XsXW6zQcin5PVgdk1dZV6KLPoACV8JyAJmAodR/C
         Z7wk/5rf/Jr/mB6FSBl0pv9IyDkoCW0crDf5LAF0ccd4JChvL+fhTC7rXH9wCs+um+a9
         gl/Tu0wjwFZb8727sXR7T4dkbc0PVhLOrxRQ5UFuWejfEwy1r9QTee6SVLR94SZr+tXM
         v9+kv83LIRErUoqnFF1WluEsymDiY3eMS8msb6wD4CqMwK5h1hzyKJsFj8TWJIlCqEl2
         Lipm+v6Klj8LYYI6MHI/aisLO+pwY2OLVsGjMIi4YCoYM45Lm+GT76g4tNs2PZXlQfOn
         oJ9A==
X-Gm-Message-State: ANoB5pnjTAtuHIjk3DLQuQDfIwsLBFM7Z3qnBtP2X91FAO3shDgQObMx
        57iLg6lPrr84tln+BIyZ1iWfCNegUz4+5Q3Inti1CwrUkUqzi6YJIRSx3ou2V+atAz9vpleF6Fc
        3KS2YWZwyPXxpiKrs
X-Received: by 2002:a37:80c:0:b0:6fa:2cab:4945 with SMTP id 12-20020a37080c000000b006fa2cab4945mr4570779qki.256.1669105727020;
        Tue, 22 Nov 2022 00:28:47 -0800 (PST)
X-Google-Smtp-Source: AA0mqf6Pliy5jAIfnm9v3oSdvBPyuy3r56Bwe/AXa5iDcJN9dM4Xf2uSXIiYOCiXMtfAJUuyEn+oOQ==
X-Received: by 2002:a37:80c:0:b0:6fa:2cab:4945 with SMTP id 12-20020a37080c000000b006fa2cab4945mr4570766qki.256.1669105726782;
        Tue, 22 Nov 2022 00:28:46 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id x10-20020a05620a258a00b006bb82221013sm9827463qko.0.2022.11.22.00.28.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 00:28:46 -0800 (PST)
Message-ID: <0a568e890497f4066128b1ce957904e0c5540c16.camel@redhat.com>
Subject: Re: [PATCH net] sfc: fix potential memleak in
 __ef100_hard_start_xmit()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Leon Romanovsky <leon@kernel.org>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 22 Nov 2022 09:28:42 +0100
In-Reply-To: <Y3e8wEZme3OpMZKV@unreal>
References: <1668671409-10909-1-git-send-email-zhangchangzhong@huawei.com>
         <Y3YctdnKDDvikQcl@unreal> <efedaa0e-33ce-24c6-bb9d-8f9b5c4a1c38@huawei.com>
         <Y3YxlxPIiw43QiKE@unreal> <Y3dNP6iEj2YyEwqJ@gmail.com>
         <Y3e8wEZme3OpMZKV@unreal>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Fri, 2022-11-18 at 19:11 +0200, Leon Romanovsky wrote:
> On Fri, Nov 18, 2022 at 09:15:43AM +0000, Martin Habets wrote:
> > On Thu, Nov 17, 2022 at 03:05:27PM +0200, Leon Romanovsky wrote:
> > > Please take a look __ef100_enqueue_skb() and see if it frees SKB on
> > > error or not. If not, please fix it.
> > 
> > That function looks ok to me, but I appreciate the extra eyes on it.
> 
> __ef100_enqueue_skb() has the following check in error path:
> 
>   498 err:
>   499         efx_enqueue_unwind(tx_queue, old_insert_count);
>   500         if (!IS_ERR_OR_NULL(skb))
>   501                 dev_kfree_skb_any(skb);
>   502
> 
> The issue is that skb is never error or null here and this "if" is
> actually always true and can be deleted.

I think that such additional change could be suite for a different net-
next patch, while this -net patch could land as is, @Leon: do you
agree?

Thanks!

Paolo

