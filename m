Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1353652305
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 15:48:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233790AbiLTOsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 09:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233886AbiLTOr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 09:47:57 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2583D1AA04
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 06:47:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671547629;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0z2BB7HZepudK9U4VAxjDq32wvem0CZa2ZoIWPry1PE=;
        b=J7teKICn23dn9MqEIqJQ5iyT5x1kBUg3+E9dN9Q4nopARXSFnIkn/9VGwIfEB1hktN6wFx
        IHOkyg8lgUCtMFZhoNIuSY+k/qCpWUvemhbFDwFFCjlS5b6UH8Tdm88CATPNc6Mv+AQ35J
        wLFQWzG3UOTSfEMW8tj7XUXnuUwiETA=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-301-emW8P2FNN_yRG13ge14SYQ-1; Tue, 20 Dec 2022 09:47:02 -0500
X-MC-Unique: emW8P2FNN_yRG13ge14SYQ-1
Received: by mail-qk1-f198.google.com with SMTP id h8-20020a05620a284800b006b5c98f09fbso9556575qkp.21
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 06:47:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0z2BB7HZepudK9U4VAxjDq32wvem0CZa2ZoIWPry1PE=;
        b=gm2hW4UIvVTjoIb3KNS5B+1p4B5kKDRMDajFABA5We78wkqj15z2rsyoVde9NBmVAR
         ZOPYsjo9Ei2+7FIfCgBj2nEEGKtsEjCM39zjLIVEde0E+1165woFEKO8oE9hqILvc39S
         iQf084bFhfUEdW/LFwl/DV2c46VcHTIECFtgX/3ui3rq/gbOFUWZt44kIcMf6haTiZ/X
         hicwZaG278s2UGZWn4r8yFTUMylD5/GDNwow8lq6mPnhz9P7ibZHpntmtoKSy4y37aTO
         DhIpcTVFWLuLmZp3+xeFHVKJe4fTJnFzo7doq6uUuAJ5AAx99gyQWV1x2o0T3wwuUs62
         MplQ==
X-Gm-Message-State: AFqh2krObxWmEN/jJwKaCjR6TxvdY7tSNOlQDEJYiwRy5lwW8DXseWmH
        VjBKoD0X8wRYOhRPSc9XSksB4sKthjla6NkCtf+UNiHD1+AghERKT/hP81Y7rmc3MOQh8dNnbKn
        l8TK+8yF5u84PGtii
X-Received: by 2002:a0c:c210:0:b0:4c6:e48c:be32 with SMTP id l16-20020a0cc210000000b004c6e48cbe32mr18364189qvh.17.1671547620909;
        Tue, 20 Dec 2022 06:47:00 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsMEBtuagmbBe6KrwoaOPH1vEEQMfGXchud6JSoqnl5N1KzPW1meaxpM4qob1da1TNN0knbqw==
X-Received: by 2002:a0c:c210:0:b0:4c6:e48c:be32 with SMTP id l16-20020a0cc210000000b004c6e48cbe32mr18364170qvh.17.1671547620655;
        Tue, 20 Dec 2022 06:47:00 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-101-173.dyn.eolo.it. [146.241.101.173])
        by smtp.gmail.com with ESMTPSA id c24-20020a05620a11b800b006fc2cee4486sm8843945qkk.62.2022.12.20.06.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 06:47:00 -0800 (PST)
Message-ID: <90ff72e75142e377273ef980ca2d26951449610c.camel@redhat.com>
Subject: Re: [PATCH net] net: fec: Coverity issue: Dereference null return
 value
From:   Paolo Abeni <pabeni@redhat.com>
To:     wei.fang@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, xiaoning.wang@nxp.com, shenwei.wang@nxp.com,
        linux-imx@nxp.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Tue, 20 Dec 2022 15:46:56 +0100
In-Reply-To: <20221215091149.936369-1-wei.fang@nxp.com>
References: <20221215091149.936369-1-wei.fang@nxp.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, 2022-12-15 at 17:11 +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> The build_skb might return a null pointer but there is no check on the
> return value in the fec_enet_rx_queue(). So a null pointer dereference
> might occur. To avoid this, we check the return value of build_skb. If
> the return value is a null pointer, the driver will recycle the page and
> update the statistic of ndev. Then jump to rx_processing_done to clear
> the status flags of the BD so that the hardware can recycle the BD.
> 
> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> Reviewed-by: Shenwei Wang <Shenwei.wang@nxp.com>

You need to include a suitable fixes tag here. Please repost adding it
and retaining  Alex's reviwed-by tag, thanks!

Paolo

