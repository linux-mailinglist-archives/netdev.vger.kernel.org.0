Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21206E7F3A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 18:11:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232564AbjDSQLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 12:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbjDSQLb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 12:11:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10CB30C8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 09:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681920648;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FqblCBfQTxko5DZvP5yTi/xoUokqLe4XMeA4ezezFSA=;
        b=VDcAVd+uq54eG0fKsTULq8M6ipzoNSr9QPbClaYp+dUiO9cXqpyKxJddheU0OcXUstcnJx
        1+ecnR0UtBQ2H1ni5TSavxCz1K+r/nRTM4DQFeCom6DAV52b8wvixX1ndEGMjkr2baJ15o
        sCD/uHUnAbMuhyozNygst1se3SyqM/Y=
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com
 [209.85.218.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-413-Er7_WUqSPG2y5yamBWpLoA-1; Wed, 19 Apr 2023 12:10:47 -0400
X-MC-Unique: Er7_WUqSPG2y5yamBWpLoA-1
Received: by mail-ej1-f72.google.com with SMTP id a640c23a62f3a-94a348facbbso464139366b.1
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 09:10:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681920645; x=1684512645;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FqblCBfQTxko5DZvP5yTi/xoUokqLe4XMeA4ezezFSA=;
        b=letw044+ZVUQFElSZ+xSHUdFoSwE2NXqSx8ArVopd4zT6GmsZRAXb0t346reTiGLbV
         ec68GuyKrvRR0ok4sESJCoJbVKx9+Bi4uIkTo5YauxoCYsV3irAnb/R0R/BoNhxL5nsX
         /Wg5oUT3djH5NU04vzOtKoH8zVlOHp6kMU9mNmeg49Ut20ZZwmL93+n2SfygX64/Cm48
         3uJFui4McM3vNpGaw0j3Y24eIBz4/MrPJs/04jf+tOt2gc+pvC5fKqCUW6aTwThkak0t
         Yfl2EU7jkvyYiyzevBEmVeYNG19YuatASc6O+wHjSqeCA17KTT4uK0CpWGspyaONa6kh
         2wag==
X-Gm-Message-State: AAQBX9eQNLmRgLg75+K33EDfwFjnHu5cPlSK9dEwQf0j8dLy2C1qnwt9
        /UT2sYeXLuckB43i/S0hzgtwebf1aOE9DCsu2RzTJFsHl1+o0BGWwAlDDKIyk7DfF4rRf1gylRR
        IJoe4LJa5tY6ecx1HP1jPiTw4
X-Received: by 2002:aa7:cd95:0:b0:502:61d8:233b with SMTP id x21-20020aa7cd95000000b0050261d8233bmr7349195edv.19.1681920645644;
        Wed, 19 Apr 2023 09:10:45 -0700 (PDT)
X-Google-Smtp-Source: AKy350Zq4/RT/2JZGaEc3HOwChNgiJt5M7dDq/2w0V/eHwJYLg5ai4fINLQZ7RBZktfrTz/dwhfqCg==
X-Received: by 2002:aa7:cd95:0:b0:502:61d8:233b with SMTP id x21-20020aa7cd95000000b0050261d8233bmr7349183edv.19.1681920645325;
        Wed, 19 Apr 2023 09:10:45 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id 23-20020a508e17000000b0050692cfc24asm5685306edw.16.2023.04.19.09.10.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 09:10:44 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <f1b26313-c377-251d-97f6-b56671f98921@redhat.com>
Date:   Wed, 19 Apr 2023 18:10:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Cc:     brouer@redhat.com, Lorenzo Bianconi <lorenzo@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        pabeni@redhat.com, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, nbd@nbd.name,
        Toke Hoiland Jorgensen <toke@redhat.com>
Subject: Re: issue with inflight pages from page_pool
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <ZD2HjZZSOjtsnQaf@lore-desk>
 <CANn89iK7P2aONo0EB9o+YiRG+9VfqqVVra4cd14m_Vo4hcGVnQ@mail.gmail.com>
 <ZD2NSSYFzNeN68NO@lore-desk> <20230417112346.546dbe57@kernel.org>
 <ZD2TH4PsmSNayhfs@lore-desk> <20230417120837.6f1e0ef6@kernel.org>
 <ZD26lb2qdsdX16qa@lore-desk> <20230417163210.2433ae40@kernel.org>
 <ZD5IcgN5s9lCqIgl@lore-desk>
 <3449df3e-1133-3971-06bb-62dd0357de40@redhat.com>
 <CANn89iKAVERmJjTyscwjRTjTeWBUgA9COz+8HVH09Q0ehHL9Gw@mail.gmail.com>
 <ea762132-a6ff-379a-2cc2-6057754425f7@redhat.com>
 <CANn89iJw==Y9fqhc0Xpau_aH=Uq7kSNv8=MywdUgTGbLZHoisQ@mail.gmail.com>
In-Reply-To: <CANn89iJw==Y9fqhc0Xpau_aH=Uq7kSNv8=MywdUgTGbLZHoisQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19/04/2023 16.18, Eric Dumazet wrote:
> On Wed, Apr 19, 2023 at 4:02 PM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
> 
>> With TCP sockets (pipes etc) we can take care of closing the sockets
>> (and programs etc) to free up the SKBs (and perhaps wait for timeouts)
>> to make sure the page_pool shutdown doesn't hang.
> 
> This can not happen in many cases, like pages being now mapped to user
> space programs,
> or nfsd or whatever.
> 
> I think that fundamentally, page pool should handle this case gracefully.
> 
> For instance, when a TCP socket is closed(), user space can die, but
> many resources in the kernel are freed later.
> 
> We do not block a close() just because a qdisc decided to hold a
> buffer for few minutes.
> 

But page pool does handle this gracefully via scheduling a workqueue.

--Jesper

