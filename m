Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530E357963D
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 11:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235990AbiGSJWi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 05:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbiGSJWd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 05:22:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 45C86D52
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 02:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658222552;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f6sBKLrVXYlyxkScgL1jtWjKEqDacx9EU64k8Ml2D4o=;
        b=jR/+MFVL0yu6JudP7RD1l/H/E+ha+cbPtxYX6vvaeQUvjq0F1d8xoHMbQdCvt0anHCIJ+4
        CcvCyO8s8XKUb+eWRZof0wXR2awBwpuIerJhOU6rXSORKv7lWW79Ylt/8j+8shekJeae+A
        gnGnQ7dXSSgczvfSl5cG9NSPDvqOLUA=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-39-xBj58Q0JMcizES1yXEdIjg-1; Tue, 19 Jul 2022 05:22:31 -0400
X-MC-Unique: xBj58Q0JMcizES1yXEdIjg-1
Received: by mail-qk1-f199.google.com with SMTP id de4-20020a05620a370400b006a9711bd9f8so11258492qkb.9
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 02:22:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=f6sBKLrVXYlyxkScgL1jtWjKEqDacx9EU64k8Ml2D4o=;
        b=b+xvzdYaQFj8XUlVBWPXGdYUSHYBMpxCqOaEK3kAVZD4WWWwfnh0S1eMIFacFR6m2e
         Pu+hkNvZIVze6pyyBBxiG88lCrjI1ggN1pw/2aVKltpGI5Y/tiAIGaK2FnNxV3eosatX
         GN6y9gl4DemQwPHhTDnJFv33/xI4HbKrJIS2b6BnxJkjOMcHpsR4WzR6/AdRiHg9FpHt
         buWeV+TTtrClitSmq939lnXylQi9/URn9TY3tzlME/qNLvsd2T/DUji3OlR/QQJUH1W+
         HHr4MF0zGkUo+QR3EQVYSFbILukK8vywlf72/ed63O70mm040grGe+zHSjse2CKxNFWe
         /jnw==
X-Gm-Message-State: AJIora+UTOXJBCfeanN+OBZzwpC49SHL4hk4/LwCcDnM+bCZ6Ua+UOTG
        tcbbIiLiNF7gwsT9nywi/L8rxlY+ikJPkhLu54ZfyhNTuBMArftfd61xiRWTnD5M/ZHk3Sazc7E
        x4wVE7qnd6YitAIMP
X-Received: by 2002:ac8:5a4d:0:b0:31d:c63:5637 with SMTP id o13-20020ac85a4d000000b0031d0c635637mr24267814qta.102.1658222550591;
        Tue, 19 Jul 2022 02:22:30 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ta6RBeMCca4dcr7N4HKWm9/CbhNzTlB7iOKWildOahnuuuK5LJ69MgTFKI2a0pLvQcNMl5Ow==
X-Received: by 2002:ac8:5a4d:0:b0:31d:c63:5637 with SMTP id o13-20020ac85a4d000000b0031d0c635637mr24267796qta.102.1658222550359;
        Tue, 19 Jul 2022 02:22:30 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-104-164.dyn.eolo.it. [146.241.104.164])
        by smtp.gmail.com with ESMTPSA id t18-20020a05620a451200b006a6b374d8bbsm199262qkp.69.2022.07.19.02.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 02:22:29 -0700 (PDT)
Message-ID: <5b6d4061bd12a9079e882742c750962816ee6567.camel@redhat.com>
Subject: Re: [PATCH v3 net-next 2/5] net: ethernet: mtk_eth_soc: add basic
 XDP support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, matthias.bgg@gmail.com,
        linux-mediatek@lists.infradead.org, ilias.apalodimas@linaro.org,
        lorenzo.bianconi@redhat.com, jbrouer@redhat.com
Date:   Tue, 19 Jul 2022 11:22:26 +0200
In-Reply-To: <b4c7646e70b1b719b8ae87a90bb8e4cf57b1a26d.1657956652.git.lorenzo@kernel.org>
References: <cover.1657956652.git.lorenzo@kernel.org>
         <b4c7646e70b1b719b8ae87a90bb8e4cf57b1a26d.1657956652.git.lorenzo@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2022-07-16 at 09:34 +0200, Lorenzo Bianconi wrote:
> Introduce basic XDP support to mtk_eth_soc driver.
> Supported XDP verdicts:
> - XDP_PASS
> - XDP_DROP
> - XDP_REDIRECT
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 147 +++++++++++++++++---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h |   2 +
>  2 files changed, 131 insertions(+), 18 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> index 9a92d602ebd5..bc3a7dcab207 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -1494,11 +1494,44 @@ static void mtk_rx_put_buff(struct mtk_rx_ring *ring, void *data, bool napi)
>  		skb_free_frag(data);
>  }
>  
> +static u32 mtk_xdp_run(struct mtk_eth *eth, struct mtk_rx_ring *ring,
> +		       struct xdp_buff *xdp, struct net_device *dev)
> +{
> +	struct bpf_prog *prog = rcu_dereference(eth->prog);

It looks like here you need to acquire the RCU read lock. lockdep
should splat otherwise.

/P

