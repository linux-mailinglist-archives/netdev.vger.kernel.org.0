Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D65775F505B
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 09:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiJEHd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 03:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJEHdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 03:33:21 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1867675388
        for <netdev@vger.kernel.org>; Wed,  5 Oct 2022 00:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1664955195;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E2k1PgA2CR3VCxL5MAhZqtc27ZkuYxK1uvHc3bfUye0=;
        b=DDIkkVXFE/cKMF7cQllS4TjW+SJD2YjwQtAxgaGd2dCkqPobvjPFKjQprUC0amOor8p/h2
        EM/nVhaUtvzsiX8QLGL5XU6OdI8vnoANIDy15ee/UZWde+jW4HwIrkw/bixvvWf1499LIx
        IBXGzx6QBfu204/bFXDE/b1CMC7EvD0=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-383-8e7mx178MEmZhJW9_b23cQ-1; Wed, 05 Oct 2022 03:33:13 -0400
X-MC-Unique: 8e7mx178MEmZhJW9_b23cQ-1
Received: by mail-wr1-f72.google.com with SMTP id r4-20020adfbb04000000b0022e5ec02713so505749wrg.18
        for <netdev@vger.kernel.org>; Wed, 05 Oct 2022 00:33:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date;
        bh=E2k1PgA2CR3VCxL5MAhZqtc27ZkuYxK1uvHc3bfUye0=;
        b=rS6z+oPcqhNBdpD8qXVBzHbu0jZIAQ35S3QaVEXStk5+MUBlWx8hn7bst1WA+TFTsL
         Bn/vn1aaspxIIP7E9QLMAn0Gmk7dfTpzdwxMAqQ5RxE52geVFIur2erijfNfigxaIbfo
         2BNG/DuxeMCJzxmGUBTssbYYscxdf12ExzJpAqCrduB5XZRNtf1JvFM5YIojq/ssx8x1
         kAwSmW/C8NH9V4d+EkFyihy6mBkfJiSEbXbz0ASMfXY2jGRcyta+ZkXUYrILkQRMof78
         8Zgak616BzJKseGki0x4uk6aooF8NAdbj6dc7SY44xoTQ1JBT9/9mG1lYbjIa49xQSSf
         3LiQ==
X-Gm-Message-State: ACrzQf3S2NLFO+RDIRtz/iT4HtS9+gaMjnRT8Ype/rWGd7gxI1Bltg5Q
        XFGW9jAplzXd8Wi7i8CGMwXMuREqvqbNU+BtAEwk7WLcO1Uylx0qyLTS3OBLpoANNcEmFNy4kvh
        Zg34ik4rhwEfJtzoK
X-Received: by 2002:a5d:52ca:0:b0:22c:c3eb:db3e with SMTP id r10-20020a5d52ca000000b0022cc3ebdb3emr19398721wrv.116.1664955192894;
        Wed, 05 Oct 2022 00:33:12 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5cd/ZWgobDsEVUxHaFtQhXcAGG+pftCOhuylbmELluvTEGnsEIVgg7QTG0+7h2/A+rbjqtOw==
X-Received: by 2002:a5d:52ca:0:b0:22c:c3eb:db3e with SMTP id r10-20020a5d52ca000000b0022cc3ebdb3emr19398712wrv.116.1664955192675;
        Wed, 05 Oct 2022 00:33:12 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-103-235.dyn.eolo.it. [146.241.103.235])
        by smtp.gmail.com with ESMTPSA id o11-20020a05600c510b00b003a83ca67f73sm1229261wms.3.2022.10.05.00.33.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Oct 2022 00:33:12 -0700 (PDT)
Message-ID: <4d710ac16e549225e0802657733ce4f773e632de.camel@redhat.com>
Subject: Re: [PATCH net-next v4] net: skb: introduce and use a single page
 frag cache
From:   Paolo Abeni <pabeni@redhat.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Date:   Wed, 05 Oct 2022 09:33:11 +0200
In-Reply-To: <CANn89iKXcagXP=QkYtrsk5jFXiyvhNL=bdXJZLc5T3e3=+jSiA@mail.gmail.com>
References: <6b6f65957c59f86a353fc09a5127e83a32ab5999.1664350652.git.pabeni@redhat.com>
         <166450446690.30186.16482162810476880962.git-patchwork-notify@kernel.org>
         <CANn89iJ=_e9-P4dvRcMzJYqpTBQ5kevEvaYFH1JVvSdv4sguhA@mail.gmail.com>
         <cdbfe4615ffec2bcfde94268dbc77dfa98143f39.camel@redhat.com>
         <CANn89i+SjRtpG9e3gJjh7sNELUYETSkOi86Qk_eC2sQOV39UGg@mail.gmail.com>
         <06a1cdb330980e3df051c95ae089fd77afee839b.camel@redhat.com>
         <d15aab527c1979e0bf539e8e1609f0770b4170fc.camel@redhat.com>
         <CANn89iKXcagXP=QkYtrsk5jFXiyvhNL=bdXJZLc5T3e3=+jSiA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-10-03 at 15:30 -0700, Eric Dumazet wrote:
> I was using neper ( https://github.com/google/neper ), with 100
> threads and 4000 flows.
> 
> I suspect contention is hard to see unless you use a host with at
> least 128 cores.
> Also you need a lot of NIC receive queues (or use RPS to spread
> incoming packets to many cores)

Nice tool! It looks like it can load the host very easily.

I still can't observe the regression on my H/W but I see some minor
improvement with the proposed patch, FWIW.

I'll try to look for an host with more cores, but that can take a lot
to unlimited time.

> 
Cheers,

Paolo

