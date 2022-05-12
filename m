Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE84A524881
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 11:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351748AbiELJC3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 05:02:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbiELJC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 05:02:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 078D037AB5
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 02:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652346144;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aiyKQYemSTtBVw0MoWjhk0ljF2zV+oylz2KWEb6PUpE=;
        b=MwK5knf+x2W6b/qWOhIhiTrki4BzZhnO3tabUCa/Zrz5rvd6r5YWpGziOoAUmHDStvYemT
        1S1Hyh4TxFuI02NSoDKp67Q0edBDK8OSxIBnES1RisWnxW91Q6XSKzfM1RlhaQE7Slb2aO
        ygwuPghNbFG3Ai324vRDR3Qo39iu5lY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-27-mE9xzZwUONyCVLCjnrF4xg-1; Thu, 12 May 2022 05:02:22 -0400
X-MC-Unique: mE9xzZwUONyCVLCjnrF4xg-1
Received: by mail-wr1-f70.google.com with SMTP id j21-20020adfa555000000b0020adb9ac14fso1813529wrb.13
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 02:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=aiyKQYemSTtBVw0MoWjhk0ljF2zV+oylz2KWEb6PUpE=;
        b=3VrtRe9vt7IBFv6K6RmhbeNUL80Qz2BY16t49pjaf9X6BmueUbcV9Vec/5rbRehYfZ
         GS3d/4Ut3ikoNVwJ3PFY/9zNqDwMBZXJR/9IQw2pdOd1ASdtec7xi134B5zRZNXbPsqY
         W4nC1Zl/dRvUvpQBDRVk45p0Um6EGOUwtjcdxIw4SjZD9ylKNzmC/gctY+/D7N+K+VHn
         P1yd8dezTxv4Z7mYO4U/5bSWbR2hLzgrD/IQkM700XzqQfx61y1+GjV+XBXd6x25Lutm
         ZeZrSD7DNEyC7/wjXemxOdz63QeKWv1K1z1o+fDc7cD4MRRxHZgzm8ludE+KXystmRqW
         RszQ==
X-Gm-Message-State: AOAM531c2on3W/CO3aSpQDXoXqpG5D+ZtjhrV0bwnZNORbBN2McjSUOy
        oCIUDi7JVPOANlGw9Aj3HAkW8MrZ7iuwBe/pC4gDx72bFaDlmT1+zIct/4wKVQUQkRhrjRYYs43
        /HoCPblYH6aHsWuz5
X-Received: by 2002:a5d:5051:0:b0:20c:884b:2347 with SMTP id h17-20020a5d5051000000b0020c884b2347mr26531025wrt.224.1652346141763;
        Thu, 12 May 2022 02:02:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzltmgxEPTjSbLxx5Q+qHJZ3y25HcxLx6cYMLQmgDQkL3DcskA3NNyCqVGf1aBsyNLV7/8FDg==
X-Received: by 2002:a5d:5051:0:b0:20c:884b:2347 with SMTP id h17-20020a5d5051000000b0020c884b2347mr26531015wrt.224.1652346141568;
        Thu, 12 May 2022 02:02:21 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-89.dyn.eolo.it. [146.241.113.89])
        by smtp.gmail.com with ESMTPSA id c6-20020a056000104600b0020c6fa5a797sm3539018wrx.91.2022.05.12.02.02.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 May 2022 02:02:20 -0700 (PDT)
Message-ID: <51bc118ff452c42fef489818422f278ab79e6dd4.camel@redhat.com>
Subject: Re: [PATCH v6 net-next 13/13] mlx5: support BIG TCP packets
From:   Paolo Abeni <pabeni@redhat.com>
To:     Saeed Mahameed <saeedm@nvidia.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Coco Li <lixiaoyan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
Date:   Thu, 12 May 2022 11:02:19 +0200
In-Reply-To: <20220512084023.tgjcecnu6vfuh7ry@LT-SAEEDM-5760.attlocal.net>
References: <20220510033219.2639364-1-eric.dumazet@gmail.com>
         <20220510033219.2639364-14-eric.dumazet@gmail.com>
         <20220512084023.tgjcecnu6vfuh7ry@LT-SAEEDM-5760.attlocal.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-05-12 at 01:40 -0700, Saeed Mahameed wrote:
> On 09 May 20:32, Eric Dumazet wrote:
> > From: Coco Li <lixiaoyan@google.com>
> > 
> > mlx5 supports LSOv2.
> > 
> > IPv6 gro/tcp stacks insert a temporary Hop-by-Hop header
> > with JUMBO TLV for big packets.
> > 
> > We need to ignore/skip this HBH header when populating TX descriptor.
> > 
> 
> Sorry i didn't go through all the documentations or previous discussions,
> please bare with me, so why not clear HBH just before calling the
> driver xmit ndo ? 

I guess this way is more efficient: the driver copies IP hdr and TCP
hdr directly in the correct/final location into the tx descriptor,
otherwise the caller would have to memmove L2/L3 just before the driver
copies them again.
> 
> Or if HBH has to stick, 

My understanding is that this is not the case.

Cheers,

Paolo

