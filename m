Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A26C3DA183
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 12:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236457AbhG2Ksr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 06:48:47 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:48378
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236399AbhG2Ksn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 06:48:43 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPS id 204563F22A
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 10:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1627555720;
        bh=hgYfV6PUzr4ibh1B07XnMBlFCdNWiJgFxyAVIqgM0RM=;
        h=Subject:To:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:Content-Type;
        b=P+bHRcDPdMNqqYv7KQVwd+q0feovUno3c78e7u8Q1g3f9P5Wl6oF/MA43dti5ZMNb
         uXMETM/UbIQ3lj8B76nrqda6yEVGSl5P3PBYBBmi7pjm2ADpW/yEoDD1zzO3qZgl3G
         7A6fB3IiXOfreEWOTXWY7prWt2Fq+LT5rZp60+aiCpHw/hL1gn5yijbZThofCU3Iut
         y2FDRarrA/jnBChef/xFAnkOOe4GwNqtXW4KnrJPhMPsuZ1vr6Vw2er0NDsQGtWUzb
         RhOAQT/oylWo3HvCc4Wf+F3du0hdHTTFV4peHRk/667fNL99VS0VkCGGWgoougbBBw
         sQ9nAQ7ttX6YQ==
Received: by mail-ed1-f70.google.com with SMTP id k14-20020a05640212ceb02903bc50d32c17so2765293edx.12
        for <netdev@vger.kernel.org>; Thu, 29 Jul 2021 03:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hgYfV6PUzr4ibh1B07XnMBlFCdNWiJgFxyAVIqgM0RM=;
        b=PI8LFzzoozhh67VoxjIW2wHwVivzm17JulaeTdHQHB04vtUdfGStjVDMlBuuZ2lnxc
         ttvP8j0VDKX7WGtCupW8LQF/hlmYi8fhJzIxtsL4zDdIkDfTQoK1mwLPXo9qRqEC6G+p
         OceFKdtbSVwifoytJx/5onShqB/AbZAvWuOn8Mxqqnq96eO/aM5mDG5RveQrY8qISSb0
         BFQsiV92S/yaOCeRUjiMZKuz6/dtGVsPV2ityyvuGuIGKxHwMmdfSAzOsk22Jal4YBWh
         k1Rf+jGS+1sIQUnlQtgPmxIWL6TjsA2tGdre+BFI25J/3m6wf15lFakGzE5SfkprLNk7
         7ItQ==
X-Gm-Message-State: AOAM532s1tgfkF3wfNWUgcvJKbwSFhp/oqj7hI/D6XFutyc6F9g9pZgY
        9iQ6GUfAfJiphyfRtmcaOlX76s2CqfVJ/OahSTdBDYSBY1Nd0L4Xd8VE5x+ymr3Dydj+gs3b4+A
        bpxrndPEhXMGu7KDu31ZMvXoHdXRRsEZMhA==
X-Received: by 2002:a05:6402:1546:: with SMTP id p6mr5320734edx.206.1627555718204;
        Thu, 29 Jul 2021 03:48:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwY4QAn1JOv7y3Pw7jEkKTFfdNWaTLg8KUKIcj9ag9xPZRr+U6cjAwxcWvt9Mt8ejiQhrR1PQ==
X-Received: by 2002:a05:6402:1546:: with SMTP id p6mr5320717edx.206.1627555718025;
        Thu, 29 Jul 2021 03:48:38 -0700 (PDT)
Received: from [192.168.8.102] ([86.32.47.9])
        by smtp.gmail.com with ESMTPSA id a35sm1053304edf.80.2021.07.29.03.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 03:48:37 -0700 (PDT)
Subject: Re: [PATCH 11/12] nfc: mrvl: constify several pointers
To:     Mark Greer <mgreer@animalcreek.com>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
References: <20210729104022.47761-1-krzysztof.kozlowski@canonical.com>
 <20210729104022.47761-12-krzysztof.kozlowski@canonical.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <fc52cc72-b9e2-4b30-5dcb-ec50b828f957@canonical.com>
Date:   Thu, 29 Jul 2021 12:48:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210729104022.47761-12-krzysztof.kozlowski@canonical.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/07/2021 12:40, Krzysztof Kozlowski wrote:
> Several functions do not modify pointed data so arguments and local
> variables can be const for correctness and safety.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  drivers/nfc/nfcmrvl/fw_dnld.c | 16 +++++++++-------
>  drivers/nfc/nfcmrvl/i2c.c     |  2 +-
>  drivers/nfc/nfcmrvl/main.c    |  2 +-
>  drivers/nfc/nfcmrvl/nfcmrvl.h |  2 +-
>  drivers/nfc/nfcmrvl/spi.c     |  4 ++--
>  drivers/nfc/nfcmrvl/uart.c    |  2 +-
>  6 files changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
> index aaccb8b76b3e..edac56b01fd1 100644
> --- a/drivers/nfc/nfcmrvl/fw_dnld.c
> +++ b/drivers/nfc/nfcmrvl/fw_dnld.c
> @@ -129,7 +129,7 @@ static void fw_dnld_timeout(struct timer_list *t)
>  }
>  
>  static int process_state_reset(struct nfcmrvl_private *priv,
> -			       struct sk_buff *skb)
> +			       const struct sk_buff *skb)
>  {
>  	if (sizeof(nci_pattern_core_reset_ntf) != skb->len ||
>  	    memcmp(skb->data, nci_pattern_core_reset_ntf,
> @@ -145,7 +145,8 @@ static int process_state_reset(struct nfcmrvl_private *priv,
>  	return 0;
>  }
>  
> -static int process_state_init(struct nfcmrvl_private *priv, struct sk_buff *skb)
> +static int process_state_init(struct nfcmrvl_private *priv,
> +			      const struct sk_buff *skb)
>  {
>  	struct nci_core_set_config_cmd cmd;
>  
> @@ -175,7 +176,7 @@ static void create_lc(struct nfcmrvl_private *priv)
>  }
>  
>  static int process_state_set_ref_clock(struct nfcmrvl_private *priv,
> -				       struct sk_buff *skb)
> +				       const struct sk_buff *skb)
>  {
>  	struct nci_core_set_config_cmd cmd;
>  
> @@ -221,7 +222,7 @@ static int process_state_set_ref_clock(struct nfcmrvl_private *priv,
>  }
>  
>  static int process_state_set_hi_config(struct nfcmrvl_private *priv,
> -				       struct sk_buff *skb)
> +				       const struct sk_buff *skb)
>  {
>  	if (sizeof(nci_pattern_core_set_config_rsp) != skb->len ||
>  	    memcmp(skb->data, nci_pattern_core_set_config_rsp, skb->len))
> @@ -232,7 +233,7 @@ static int process_state_set_hi_config(struct nfcmrvl_private *priv,
>  }
>  
>  static int process_state_open_lc(struct nfcmrvl_private *priv,
> -				 struct sk_buff *skb)
> +				 const struct sk_buff *skb)
>  {
>  	if (sizeof(nci_pattern_core_conn_create_rsp) >= skb->len ||
>  	    memcmp(skb->data, nci_pattern_core_conn_create_rsp,
> @@ -347,7 +348,7 @@ static int process_state_fw_dnld(struct nfcmrvl_private *priv,
>  }
>  
>  static int process_state_close_lc(struct nfcmrvl_private *priv,
> -				  struct sk_buff *skb)
> +				  const struct sk_buff *skb)
>  {
>  	if (sizeof(nci_pattern_core_conn_close_rsp) != skb->len ||
>  	    memcmp(skb->data, nci_pattern_core_conn_close_rsp, skb->len))
> @@ -358,7 +359,8 @@ static int process_state_close_lc(struct nfcmrvl_private *priv,
>  	return 0;
>  }
>  
> -static int process_state_boot(struct nfcmrvl_private *priv, struct sk_buff *skb)
> +static int process_state_boot(struct nfcmrvl_private *priv,
> +			      const struct sk_buff *skb)
>  {
>  	if (sizeof(nci_pattern_proprietary_boot_rsp) != skb->len ||
>  	    memcmp(skb->data, nci_pattern_proprietary_boot_rsp, skb->len))
> diff --git a/drivers/nfc/nfcmrvl/i2c.c b/drivers/nfc/nfcmrvl/i2c.c
> index 59a529e72d96..6e659e77c8a2 100644
> --- a/drivers/nfc/nfcmrvl/i2c.c
> +++ b/drivers/nfc/nfcmrvl/i2c.c
> @@ -182,8 +182,8 @@ static int nfcmrvl_i2c_parse_dt(struct device_node *node,
>  static int nfcmrvl_i2c_probe(struct i2c_client *client,
>  			     const struct i2c_device_id *id)
>  {
> +	const struct nfcmrvl_platform_data *pdata;
>  	struct nfcmrvl_i2c_drv_data *drv_data;
> -	struct nfcmrvl_platform_data *pdata;
>  	struct nfcmrvl_platform_data config;
>  	int ret;
>  
> diff --git a/drivers/nfc/nfcmrvl/main.c b/drivers/nfc/nfcmrvl/main.c
> index 6e9e7ce8792c..d8e48bdaf652 100644
> --- a/drivers/nfc/nfcmrvl/main.c
> +++ b/drivers/nfc/nfcmrvl/main.c
> @@ -93,7 +93,7 @@ struct nfcmrvl_private *nfcmrvl_nci_register_dev(enum nfcmrvl_phy phy,
>  				void *drv_data,
>  				struct nfcmrvl_if_ops *ops,
>  				struct device *dev,
> -				struct nfcmrvl_platform_data *pdata)
> +				const struct nfcmrvl_platform_data *pdata)
>  {
>  	struct nfcmrvl_private *priv;
>  	int rc;
> diff --git a/drivers/nfc/nfcmrvl/nfcmrvl.h b/drivers/nfc/nfcmrvl/nfcmrvl.h
> index a715543bc9bf..84fafa95965e 100644
> --- a/drivers/nfc/nfcmrvl/nfcmrvl.h
> +++ b/drivers/nfc/nfcmrvl/nfcmrvl.h
> @@ -94,7 +94,7 @@ struct nfcmrvl_private *nfcmrvl_nci_register_dev(enum nfcmrvl_phy phy,
>  				void *drv_data,
>  				struct nfcmrvl_if_ops *ops,
>  				struct device *dev,
> -				struct nfcmrvl_platform_data *pdata);
> +				const struct nfcmrvl_platform_data *pdata);
>  
>  
>  void nfcmrvl_chip_reset(struct nfcmrvl_private *priv);
> diff --git a/drivers/nfc/nfcmrvl/spi.c b/drivers/nfc/nfcmrvl/spi.c
> index 66696321c645..7b015bb33fc9 100644
> --- a/drivers/nfc/nfcmrvl/spi.c
> +++ b/drivers/nfc/nfcmrvl/spi.c
> @@ -106,7 +106,7 @@ static struct nfcmrvl_if_ops spi_ops = {
>  	.nci_update_config = nfcmrvl_spi_nci_update_config,
>  };
>  
> -static int nfcmrvl_spi_parse_dt(struct device_node *node,
> +static int nfcmrvl_spi_parse_dt(const struct device_node *node,
>  				struct nfcmrvl_platform_data *pdata)

This one is not correct (yet) as it depends on changes in OF/IRQ. I just
found compile configuration which triggers here warning.

Please skip this one patch.


Best regards,
Krzysztof
