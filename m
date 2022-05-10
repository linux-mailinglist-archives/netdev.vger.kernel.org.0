Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C62C65210C2
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 11:23:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238598AbiEJJ1Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 05:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbiEJJ1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 05:27:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9F1FF21E9DE
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 02:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652174597;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EgetNWjoL1fnphckQHzuM65/y5GAKFQcIyLTYZ24SMo=;
        b=MIB9njLvVXQYRVdJd/Q3zRd6w7MBj3nj48uxxBB+zmCoGuD1UazWur7FZKoKtDKuWD4v1X
        BsMCXL1G7M9es9hYfwploy0VhBu8N3k7vM1M4ocGxDcd6r9GBq7fcAT9pb5Ai55C4LJki3
        TzC1NOguPlQqyk9KQtHmsKe3/wJL3L8=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-16-cj4rWG59PK6qsOjdYj03uQ-1; Tue, 10 May 2022 05:23:16 -0400
X-MC-Unique: cj4rWG59PK6qsOjdYj03uQ-1
Received: by mail-qv1-f69.google.com with SMTP id j1-20020a0cf9c1000000b0045abd139f01so13219293qvo.23
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 02:23:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=EgetNWjoL1fnphckQHzuM65/y5GAKFQcIyLTYZ24SMo=;
        b=r4PCFTiJM4r+n3qyGxlr6KMGLos5MsCzMf5vtn2ef7u9KmJ+/0fDCj37OEuN9Ql6AE
         mwUPGVqDBgLJAkFpA9lxa0HqN8KKLwbRflbPtvTftlH8vaCPsQsxVjnTie7LkiGl65mM
         AQ7bRlYg0JAOLv+02xBM4y+dhe/iYv+Jm6PtGJTF6ojn4hkajWwaehsSaz278fYKzTyT
         0I2TuGKtS5a11MaF0fXsOtpME3jPOa0jMRQI810Nz6wHju7PyCiE1fIy7edds6IKArDb
         CjTpSpZoJbq7YsGImo86TrP2wNwAQniTuxpa6XXuAi5+RSyuR89LFWCr4SOCV01Aq1+1
         hBAw==
X-Gm-Message-State: AOAM532sah46MHZ1VrjKzIcutiVWh1LCsuZLtpjWaDxNA30MwlxuoL5M
        UkSOwm8gOjG3FWNeZX6oxQGWO5oHGMVbb7BNU2PQSCUNPqShbuy9ceQmUKXMbZd05OQLiAWRlT9
        lKu2VhrUfgGDzPaH2
X-Received: by 2002:a05:620a:294c:b0:6a0:4cc8:4bd7 with SMTP id n12-20020a05620a294c00b006a04cc84bd7mr12765995qkp.289.1652174596044;
        Tue, 10 May 2022 02:23:16 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyl9vCI6kg80E4T+ZKFzMjOEXlLfMq9+CryMoQZaTCrxnAlcRin2KGmMkXUn4odY6tZhYo99w==
X-Received: by 2002:a05:620a:294c:b0:6a0:4cc8:4bd7 with SMTP id n12-20020a05620a294c00b006a04cc84bd7mr12765976qkp.289.1652174595746;
        Tue, 10 May 2022 02:23:15 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-89.dyn.eolo.it. [146.241.113.89])
        by smtp.gmail.com with ESMTPSA id de27-20020a05620a371b00b0069fe1fc72e7sm8374243qkb.90.2022.05.10.02.23.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 02:23:15 -0700 (PDT)
Message-ID: <63c9efe216f6c4195f53b3c43b202eda2f0821d0.camel@redhat.com>
Subject: Re: [PATCH net-next v1 01/03] net/macsec: Add MACsec skb extension
 Tx Data path support
From:   Paolo Abeni <pabeni@redhat.com>
To:     Lior Nahmanson <liorna@nvidia.com>, edumazet@google.com,
        kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Raed Salem <raeds@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Ben Ben-Ishay <benishay@nvidia.com>
Date:   Tue, 10 May 2022 11:23:11 +0200
In-Reply-To: <20220508090954.10864-2-liorna@nvidia.com>
References: <20220508090954.10864-1-liorna@nvidia.com>
         <20220508090954.10864-2-liorna@nvidia.com>
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

On Sun, 2022-05-08 at 12:09 +0300, Lior Nahmanson wrote:
> In the current MACsec offload implementation, MACsec interfaces are
> sharing the same MAC address of their parent interface by default.
> Therefore, HW can't distinguish if a packet was sent from MACsec
> interface and need to be offloaded or not.
> Also, it can't distinguish from which MACsec interface it was sent in
> case there are multiple MACsec interface with the same MAC address.
> 
> Used SKB extension, so SW can mark if a packet is needed to be offloaded
> and use the SCI, which is unique value for each MACsec interface,
> to notify the HW from which MACsec interface the packet is sent.
> 
> Signed-off-by: Lior Nahmanson <liorna@nvidia.com>
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> Reviewed-by: Ben Ben-Ishay <benishay@nvidia.com>
> ---
>  drivers/net/Kconfig    | 1 +
>  drivers/net/macsec.c   | 5 +++++
>  include/linux/skbuff.h | 3 +++
>  include/net/macsec.h   | 6 ++++++
>  net/core/skbuff.c      | 7 +++++++
>  5 files changed, 22 insertions(+)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index b2a4f998c180..6c9a950b7010 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -313,6 +313,7 @@ config MACSEC
>  	select CRYPTO_AES
>  	select CRYPTO_GCM
>  	select GRO_CELLS
> +	select SKB_EXTENSIONS
>  	help
>  	   MACsec is an encryption standard for Ethernet.
>  
> diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
> index 832f09ac075e..0960339e2442 100644
> --- a/drivers/net/macsec.c
> +++ b/drivers/net/macsec.c
> @@ -3377,6 +3377,11 @@ static netdev_tx_t macsec_start_xmit(struct sk_buff *skb,
>  	int ret, len;
>  
>  	if (macsec_is_offloaded(netdev_priv(dev))) {
> +		struct macsec_ext *secext = skb_ext_add(skb, SKB_EXT_MACSEC);
> +
> +		secext->sci = secy->sci;
> +		secext->offloaded = true;
> +
>  		skb->dev = macsec->real_dev;
>  		return dev_queue_xmit(skb);
>  	}
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 84d78df60453..4ee71c7848bf 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -4552,6 +4552,9 @@ enum skb_ext_id {
>  #endif
>  #if IS_ENABLED(CONFIG_MCTP_FLOWS)
>  	SKB_EXT_MCTP,
> +#endif
> +#if IS_ENABLED(CONFIG_MACSEC)
> +	SKB_EXT_MACSEC,
>  #endif
>  	SKB_EXT_NUM, /* must be last */
>  };
> diff --git a/include/net/macsec.h b/include/net/macsec.h
> index d6fa6b97f6ef..fcbca963c04d 100644
> --- a/include/net/macsec.h
> +++ b/include/net/macsec.h
> @@ -20,6 +20,12 @@
>  typedef u64 __bitwise sci_t;
>  typedef u32 __bitwise ssci_t;
>  
> +/* MACsec sk_buff extension data */
> +struct macsec_ext {
> +	sci_t sci;
> +	bool offloaded;

It looks like the bool is not used/it's always true when the extension
is attached? If so it's better to drop it and use the extension
presence as the flag.

BTW have you considered other options other then the skb extensions?
e.g. could you use skb_metadata() here?

Otherwise I think you need explicitly to take care of this extension at
the GRO layer, see commit 8550ff8d8c75

Thanks!

Paolo

