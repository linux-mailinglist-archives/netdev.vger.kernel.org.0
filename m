Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8AA85576DF
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 11:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230272AbiFWJmx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 05:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbiFWJmu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 05:42:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29DEA49924
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:42:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655977368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GtCRYQelrWKnz3SabeELJkqPRwIFLNLfCWPVojFD6BI=;
        b=eYAyCfd7bupG0OxI28PQMR6039y4sJQV+hbotdJVDnqcre+Qy1fS2fVTVqYV35vUr0Ej9B
        CD1RDKT9YSTZCLsmRnS252vpPJitE1oitDU9Ed2DxmN58mcKbeey2OtNUbQAkhHhzJ76JC
        iF/rxI6REZX6aj98vMdugQ7vS6CMesE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-646-SX3Z049pO2-1Kaidn8C3ww-1; Thu, 23 Jun 2022 05:42:46 -0400
X-MC-Unique: SX3Z049pO2-1Kaidn8C3ww-1
Received: by mail-wm1-f72.google.com with SMTP id be12-20020a05600c1e8c00b0039c506b52a4so1490434wmb.1
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 02:42:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GtCRYQelrWKnz3SabeELJkqPRwIFLNLfCWPVojFD6BI=;
        b=iFyU8pT/FLWNoLLBid1Z3u5WrAdIkzeW++slHzNXUH6JHKvfesErGVVLg7hqP66kVl
         CzQgLtX+tfERlbKOOsJ+N4FnL4Purd2UPfLnXCElhVLvMLkLCsfYTm4Fh5J6W0Ca/DL8
         efK5bgBQHk6dlw7dTTJCNI29XShbuYzSjxtapdCMZVGOX0U0ZvnD6JZVLpN2AB4nlPxU
         FK5WDXihNoKj4DdG6+y73eVOHApqYz+iJYTFfRotKctW6p26UnkJGq3AoEZQit9F9E7+
         XcD61GF9sxQgBhezsLhlOcjZyM7sCouMk4YZlVcbN33Yz6ct9pk9Gpo1e5u5Myjoo9em
         bo/g==
X-Gm-Message-State: AJIora+7gZo0fDDXBm3BSUHkNXSx/sW47IqIk0ZnFPwA+HzoQfCvf5ie
        EZy7Puzbok9HQsiuyveJjWkKjgGvpPgciJSDVDB/F5M/mX9jqSfp4iHT2TXwI1kTnH8f9Dw89DO
        qGiqG07NOf11dAUFs
X-Received: by 2002:a5d:64ca:0:b0:218:5503:d0c3 with SMTP id f10-20020a5d64ca000000b002185503d0c3mr7366174wri.168.1655977365301;
        Thu, 23 Jun 2022 02:42:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1ta/upeL0MWo4wy9b8nuJ+Bd6LqtH80hM/pfDo2zEAWKUxK2lzvqema85h+mKsgXOVFSUYYIQ==
X-Received: by 2002:a5d:64ca:0:b0:218:5503:d0c3 with SMTP id f10-20020a5d64ca000000b002185503d0c3mr7366159wri.168.1655977365033;
        Thu, 23 Jun 2022 02:42:45 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id a17-20020adffad1000000b0021b8749728dsm15873560wrs.73.2022.06.23.02.42.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 02:42:44 -0700 (PDT)
Message-ID: <39279ba0ced207f484b664fe5364fa4ee6271cfb.camel@redhat.com>
Subject: Re: [PATCH] nfc: st21nfca: fix possible double free in
 st21nfca_im_recv_dep_res_cb()
From:   Paolo Abeni <pabeni@redhat.com>
To:     Hangyu Hua <hbh25y@gmail.com>, krzysztof.kozlowski@linaro.org,
        sameo@linux.intel.com, christophe.ricard@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 23 Jun 2022 11:42:43 +0200
In-Reply-To: <20220622065117.23210-1-hbh25y@gmail.com>
References: <20220622065117.23210-1-hbh25y@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-22 at 14:51 +0800, Hangyu Hua wrote:
> nfc_tm_data_received will free skb internally when it fails. There is no
> need to free skb in st21nfca_im_recv_dep_res_cb again.
> 
> Fix this by setting skb to NULL when nfc_tm_data_received fails.
> 
> Fixes: 1892bf844ea0 ("NFC: st21nfca: Adding P2P support to st21nfca in Initiator & Target mode")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
>  drivers/nfc/st21nfca/dep.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/st21nfca/dep.c b/drivers/nfc/st21nfca/dep.c
> index 1ec651e31064..07ac5688011c 100644
> --- a/drivers/nfc/st21nfca/dep.c
> +++ b/drivers/nfc/st21nfca/dep.c
> @@ -594,7 +594,8 @@ static void st21nfca_im_recv_dep_res_cb(void *context, struct sk_buff *skb,
>  			    ST21NFCA_NFC_DEP_PFB_PNI(dep_res->pfb + 1);
>  			size++;
>  			skb_pull(skb, size);
> -			nfc_tm_data_received(info->hdev->ndev, skb);
> +			if (nfc_tm_data_received(info->hdev->ndev, skb))
> +				skb = NULL;

Note that 'skb' not used (nor freed) by this function after this point:
the next 'break' statement refears to the inner switch, and land to the
execution flow to the 'return' statement a few lines below.
kfree_skb(skb) is never reached.

Paolo

