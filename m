Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 449C95A617E
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 13:18:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbiH3LSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 07:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiH3LSW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 07:18:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEEBF32D5
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 04:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661858299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4JiCrE3IiQ8+CEWNeSS2asHnnk4i6y9uPZlIK6ZR5Vo=;
        b=CXLfW2x3JptwX1+XI6FB+q3v79MalWmzXlyhXYtAKH6Dkztc2a3jrHvrTGxY5dfaoPGCrL
        yeIuryopN3By6Ii4DtmYVKtztiverSMO7juNkGmyndnYjB4eAWP+wR3ex0UbB6MzxvRjAj
        51yC24omGiGo69I/fl7DhnGd3Ufcvr4=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-574-bHl1VotkNA24-1aQ72JtKg-1; Tue, 30 Aug 2022 07:18:18 -0400
X-MC-Unique: bHl1VotkNA24-1aQ72JtKg-1
Received: by mail-wr1-f72.google.com with SMTP id d11-20020adfc08b000000b002207555c1f6so1675780wrf.7
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 04:18:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:to:from:subject:message-id:x-gm-message-state:from
         :to:cc;
        bh=4JiCrE3IiQ8+CEWNeSS2asHnnk4i6y9uPZlIK6ZR5Vo=;
        b=LxnuaXWN7NKr5QfsM9Lzx8yDUwYsaQ629pyewHC0BvK0zzDOPORh3V1/XLv83PyttI
         645IGqn/1NYXGgrTGxAiACjESamw5Hbb5czpwcYI/CfWDIQazHPAYB08/FTievL1pg8H
         5heT1BzyjlnT+5/095UIfwspmZDTRa/tuzZw3/KeikjYcYLlseEXiWrjfsUB/anmSmiM
         Fe/l08TEnllG3j7YGLQF1NNQadQ5xvwTNC1lG4yMXOltZoUoCMVAdMaFddVQ7Fo2lNpY
         e1G5SnALUXNuLZUAsiOlb4/n+CkhTK6a7b7AXYUp4inYHmQRjuFM7ULe9q5rviXmQ+H4
         NbFg==
X-Gm-Message-State: ACgBeo0JlCg8DOTRU2Em9pZJ5tNDI94PqyS6qo/Y6eQmByOw1x3jYkaU
        8sIqXl/c8BVHaoyDK2IbJi3VO+uYeqayvkMQjACPBJaVYIkWd6WBgP9yKYorV5lQdVV2THkmLyF
        0cCRgDdzEv1zLZy62
X-Received: by 2002:a05:600c:3509:b0:3a6:1888:a4bd with SMTP id h9-20020a05600c350900b003a61888a4bdmr9447096wmq.191.1661858297249;
        Tue, 30 Aug 2022 04:18:17 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4HvigwPSq8EiiHGqkmNWGcILJriKSRCBxytXiIBYXM6+WZflMGWDs2vCn+PQYGB3CfWu298A==
X-Received: by 2002:a05:600c:3509:b0:3a6:1888:a4bd with SMTP id h9-20020a05600c350900b003a61888a4bdmr9447079wmq.191.1661858297005;
        Tue, 30 Aug 2022 04:18:17 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-97-176.dyn.eolo.it. [146.241.97.176])
        by smtp.gmail.com with ESMTPSA id e29-20020a5d595d000000b0022584e771adsm9252134wri.113.2022.08.30.04.18.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 04:18:16 -0700 (PDT)
Message-ID: <686875c4c9b6d8c2ad17b506f7784a8fb8bf351b.camel@redhat.com>
Subject: Re: [net-next PATCH V5] octeontx2-pf: Add egress PFC support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Suman Ghosh <sumang@marvell.com>, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, jerinj@marvell.com,
        hkelam@marvell.com, sbhatta@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, netdev@vger.kernel.org
Date:   Tue, 30 Aug 2022 13:18:15 +0200
In-Reply-To: <20220826075751.2005604-1-sumang@marvell.com>
References: <20220826075751.2005604-1-sumang@marvell.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Just a couple of minor nit, see below.

On Fri, 2022-08-26 at 13:27 +0530, Suman Ghosh wrote:
[...]
> +int otx2_pfc_txschq_update(struct otx2_nic *pfvf)
> +{
> +	u8 pfc_en = pfvf->pfc_en, pfc_bit_set;
> +	struct mbox *mbox = &pfvf->mbox;
> +	bool if_up = netif_running(pfvf->netdev);

please, respect the reverse x-mas tree in variables declaration.

[...]
> @@ -1853,6 +1880,32 @@ static netdev_tx_t otx2_xmit(struct sk_buff *skb, struct net_device *netdev)
>  	return NETDEV_TX_OK;
>  }
>  
> +static u16 otx2_select_queue(struct net_device *netdev, struct sk_buff *skb,
> +			     struct net_device *sb_dev)
> +{
> +	struct otx2_nic *pf = netdev_priv(netdev);
> +#ifdef CONFIG_DCB
> +	u8 vlan_prio;
> +#endif
> +	int txq;
> +
> +#ifdef CONFIG_DCB
> +	if (!skb->vlan_present)
> +		goto pick_tx;
> +
> +	vlan_prio = skb->vlan_tci >> 13;
> +	if ((vlan_prio > pf->hw.tx_queues - 1) ||
> +	    !pf->pfc_alloc_status[vlan_prio])
> +		goto pick_tx;
> +
> +	return vlan_prio;
> +
> +pick_tx:
> +#endif
> +	txq = netdev_pick_tx(netdev, skb, NULL);
> +	return txq;

You can just
	return netdev_pick_tx(netdev, skb, NULL);

and avoid declaring txq.

Cheers,

Paolo

