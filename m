Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F131363BFB5
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 13:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233794AbiK2MGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 07:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233709AbiK2MFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 07:05:52 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B7343A3
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 04:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669723443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1imltAz45YNaotAIbFUcpudsIMx54FwHI8IznpWl/fg=;
        b=bLB6rPbTG57CoHNkzIqxXBuU1XTo8cf9WmfQLdsPnnFGaMZZlQW8pnHevZEoQgO6Aq4T18
        OoHTL7yqRmZmbRK62151QfVVaRxBd8FAdNqWkfWEU9OWnq5b7548i8j143BTJfM4waoyGD
        vjWGP5CIWnhr0JBPz3BFAiRzoxvbUbI=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-589-KL1KiifBPtideCmK3mnxsA-1; Tue, 29 Nov 2022 07:04:00 -0500
X-MC-Unique: KL1KiifBPtideCmK3mnxsA-1
Received: by mail-qk1-f199.google.com with SMTP id bp11-20020a05620a458b00b006fc8fa99f8eso3769846qkb.11
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 04:04:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1imltAz45YNaotAIbFUcpudsIMx54FwHI8IznpWl/fg=;
        b=xpr10wJtzlXNSYGMv0Ldd1JpwEMGAFDNK33G7iLezmjueZ2KRZg8vQotGSHgLpzQot
         RPDDnTs1uZ29YyOiJd6wVMU6x1CZWlznY83zBQqblnQ2Ncs6n+GfhlNFB0eGW74qwd9A
         IwNElwM/XatfwlDS9IQEozls1W7aI6isLgbf8+d2rrUcT+8xrfpXG36aBPUyM32PVNXm
         lvpK5l0dDYT+PO+FibwGkv8hb9GtESSV+8UwEbicuhXODCCMSA3P2lnHhd3OnRNHoU1R
         DHnPS/tU7MfeKek4Dup8uvfj+AtPGkHF3hA6K07NVCS1SE5QfMTBDTEXmRGp56+Dw/yX
         sXow==
X-Gm-Message-State: ANoB5pmT09YHhZp54DstRu2YR/KhTpQpL86340CFyqD0S/VfSOkoXHuO
        e4AeiEXeFiysUMLin+kc6IXEYMakXt7LNOKWfA9edkiu+rbu0aTgAda9+T/UKNK9HKkeGvrfLrE
        32XJsmem+t6GtYxTe
X-Received: by 2002:ac8:528d:0:b0:3a5:1eb:d8ab with SMTP id s13-20020ac8528d000000b003a501ebd8abmr51370141qtn.443.1669723440197;
        Tue, 29 Nov 2022 04:04:00 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4TSSLYpVE0Uu3PxfwqDzgVNsZDT5tCMmzPIkbJ3ObJ76V32f4dpT3251cTf8VlB2c+vPqSCQ==
X-Received: by 2002:ac8:528d:0:b0:3a5:1eb:d8ab with SMTP id s13-20020ac8528d000000b003a501ebd8abmr51370110qtn.443.1669723439921;
        Tue, 29 Nov 2022 04:03:59 -0800 (PST)
Received: from gerbillo.redhat.com (146-241-120-203.dyn.eolo.it. [146.241.120.203])
        by smtp.gmail.com with ESMTPSA id x5-20020ac84a05000000b0039cc7ebf46bsm8455425qtq.93.2022.11.29.04.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 04:03:59 -0800 (PST)
Message-ID: <a3c723c5a27a75924f9d2f4ecabe26c04add08f3.camel@redhat.com>
Subject: Re: [PATCH net 2/2] octeontx2-pf: Fix a potential double free in
 otx2_sq_free_sqbs()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Ziyang Xuan <william.xuanziyang@huawei.com>, sgoutham@marvell.com,
        gakula@marvell.com, sbhatta@marvell.com, hkelam@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Date:   Tue, 29 Nov 2022 13:03:56 +0100
In-Reply-To: <047b210eb3b3a2e26703d8b0570a0a017789c169.1669361183.git.william.xuanziyang@huawei.com>
References: <cover.1669361183.git.william.xuanziyang@huawei.com>
         <047b210eb3b3a2e26703d8b0570a0a017789c169.1669361183.git.william.xuanziyang@huawei.com>
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

On Fri, 2022-11-25 at 15:45 +0800, Ziyang Xuan wrote:
> otx2_sq_free_sqbs() will be called twice when goto "err_free_nix_queues"
> label in otx2_init_hw_resources(). The first calling is within
> otx2_free_sq_res() at "err_free_nix_queues" label, and the second calling
> is at later "err_free_sq_ptrs" label.
> 
> In otx2_sq_free_sqbs(), If sq->sqb_ptrs[i] is not 0, the memory page it
> points to will be freed, and sq->sqb_ptrs[i] do not be assigned 0 after
> memory page be freed. If otx2_sq_free_sqbs() is called twice, the memory
> page pointed by sq->sqb_ptrs[i] will be freeed twice. To fix the bug,
> assign 0 to sq->sqb_ptrs[i] after memory page be freed.
> 
> Fixes: caa2da34fd25 ("octeontx2-pf: Initialize and config queues")
> Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
> ---
>  drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index 9e10e7471b88..5a25fe51d102 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -1146,6 +1146,7 @@ void otx2_sq_free_sqbs(struct otx2_nic *pfvf)
>  					     DMA_FROM_DEVICE,
>  					     DMA_ATTR_SKIP_CPU_SYNC);
>  			put_page(virt_to_page(phys_to_virt(pa)));
> +			sq->sqb_ptrs[sqb] = 0;

The above looks not needed...
>  		}
>  		sq->sqb_count = 0;

... as this will prevent the next invocation of otx2_sq_free_sqbs()
from traversing and freeing any sq->sqb_ptrs[] element.

Cheers,

Paolo
>  	}


