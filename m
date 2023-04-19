Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E01936E7B5A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 15:55:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbjDSNzr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 09:55:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232194AbjDSNzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 09:55:42 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E863A9E;
        Wed, 19 Apr 2023 06:55:40 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id fw30so29109466ejc.5;
        Wed, 19 Apr 2023 06:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681912539; x=1684504539;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sNkd61Jch2QdGt57ZqBHFz9kf7vJ1lgTXgWLb5q6qjI=;
        b=M4ipdorvZv48rwKg1svNan0KGA0aU//PLTRXYS3hsFPhTHs3/AGgJLEKMhkpujgFYK
         0rAoWPEQ2DMeeIrTVtAm8OjnwUjbqydVxcgvgC4UsuXOOwHe3EAKZApi/GZWBVtq2I67
         thuQELSkh5Xo4sbgylc6LXHYE8PJzAikdcmMBXDAnRY4JVh0BSUz2qc0zxHc+r17mUB0
         OdWX+w4IHNqIn9YWuqovxOl0m2jPQDUt5L8mS1v+rWmwYkAP42RjG+nEuEWWESmLov80
         cxwWCTUnZKYqVMw/QzPlqU/WkTe5tZKonlm2/snFVUjw7LS7942aiordtNG88dTT1kKB
         tOCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681912539; x=1684504539;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sNkd61Jch2QdGt57ZqBHFz9kf7vJ1lgTXgWLb5q6qjI=;
        b=PjwU6Icv+kG2sm7EL8vb6dys16FfLVhGSlvTmOBZJwyqMOhBPSlkRaYLp2rKgfzwhq
         X6/+0B0fbtTyiRGdqRDIaz1oU5LWoElVa2F2ljSul/IVW61QdwCAJsiMenWIEQlJzuQ5
         QCeKKp/4iSni7ghPbb1A3ARemSeLVGIAuJKtCQso8vP75jNOqOu7Qx4KH38ZAMYsFXrf
         C8NdHexHpWbp6AbWNGd+GutJkkfTw5Offta17D/ukX7KM62nXslUlgsuJfkXXO26n0Ho
         4+Qbp40lkMcx3j17zVJg5uy8vS+PrmDsPbDxHdn9TKRbwFkHTKDgfVGmXXtzKcL9vAXT
         p1Zg==
X-Gm-Message-State: AAQBX9ceYSYXXO55TJLUwE+gwhff6NmUufjn+McT/qcxAtwTnp0/Q1lf
        ZdyYLL33Y+YSJr+6v6bwR4Ojxo1zQcbhBQ==
X-Google-Smtp-Source: AKy350aet4Ub3+KzdoH0hx9NL27/A/0rBAxlhJXyprkJBeaQUfBT8VQnf5AawZiwqZIw4OGc5bqvdg==
X-Received: by 2002:a17:906:6bcd:b0:94e:eb42:2a7c with SMTP id t13-20020a1709066bcd00b0094eeb422a7cmr14775236ejs.25.1681912538655;
        Wed, 19 Apr 2023 06:55:38 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id e23-20020a170906315700b0094b87711c9fsm9395743eje.99.2023.04.19.06.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 06:55:38 -0700 (PDT)
Date:   Wed, 19 Apr 2023 16:55:36 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, linux@armlinux.org.uk,
        linux-i2c@vger.kernel.org, linux-gpio@vger.kernel.org,
        mengyuanlou@net-swift.com
Subject: Re: [PATCH net-next v3 4/8] net: txgbe: Add SFP module identify
Message-ID: <20230419135536.gnteyh4pu6p53epr@skbuf>
References: <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-1-jiawenwu@trustnetic.com>
 <20230419082739.295180-5-jiawenwu@trustnetic.com>
 <20230419082739.295180-5-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230419082739.295180-5-jiawenwu@trustnetic.com>
 <20230419082739.295180-5-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 04:27:35PM +0800, Jiawen Wu wrote:
> +	ret = txgbe_sfp_register(txgbe);
> +	if (ret) {
> +		wx_err(txgbe->wx, "failed to register sfp\n");
> +		goto err;
> +	}

The usual error handling pattern is to jump to specific labels within
the error unwind code path (which duplicates the normal teardown path
except for the first operation), rather than calling the single cleanup
function - here txgbe_remove_phy() - and filling that with "if" conditions.
Normally (at least in the networking layer except for Qdiscs, that's all
I know), one would expect that if txgbe_init_phy() fails, txgbe_remove_phy()
is never called. So, given that expectation, txgbe->sfp_dev would never
be NULL.

> +
>  	return 0;
>  
>  err:
> @@ -131,6 +156,8 @@ int txgbe_init_phy(struct txgbe *txgbe)
>  
>  void txgbe_remove_phy(struct txgbe *txgbe)
>  {
> +	if (txgbe->sfp_dev)
> +		platform_device_unregister(txgbe->sfp_dev);
>  	if (txgbe->i2c_dev)
>  		platform_device_unregister(txgbe->i2c_dev);
>  
> diff --git a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> index 771aefbc7c80..aa94c4fce311 100644
> --- a/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> +++ b/drivers/net/ethernet/wangxun/txgbe/txgbe_type.h
> @@ -149,6 +149,7 @@ struct txgbe_nodes {
>  struct txgbe {
>  	struct wx *wx;
>  	struct txgbe_nodes nodes;
> +	struct platform_device *sfp_dev;
>  	struct platform_device *i2c_dev;
>  };
>  
> -- 
> 2.27.0
> 

