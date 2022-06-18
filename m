Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 451845501C7
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 03:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383654AbiFRB5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 21:57:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiFRB5t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 21:57:49 -0400
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB07613CC6;
        Fri, 17 Jun 2022 18:57:48 -0700 (PDT)
Received: by mail-io1-xd32.google.com with SMTP id i16so6170824ioa.6;
        Fri, 17 Jun 2022 18:57:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=nlqa2mUyUcAPbTEqCfHYZQStz06i6M5KWDDFUmI8TDU=;
        b=OgZ5NOzQW0KReIX332vrXR7LT6BMvhSrLGWwdgFz0zXQSw01Q5iNjKfx+ZbwXHtRHz
         XKt2yv3DAB4sQp/p1jZjqTsJW7ezXNohUNbqtFJaejLKP+eCKo8Y1zVfeOrHD5K7flGA
         VzZVX9AQflddtNgUxqvv7zOlCuN6oVTG1KpL6E326hgx344d4UpnEwFlt/nCFZWYe79F
         f+ZRBaYlodN2S53hytjTnKJR+URvSZroqqBSY5PDHP4mcnYMeCOurq7FFwLbnRB0pVlf
         lE/y6J3LwD+l9/ZK37YInCPj65omjyVUNT5RLji8640M/UXI/VdJJkcfCIBM4PWd/ti9
         L54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=nlqa2mUyUcAPbTEqCfHYZQStz06i6M5KWDDFUmI8TDU=;
        b=Aqdp/O1KX6gAU8fyPn8/JvDzIJY8PWXYX0Z4iblUpR1dcqir87L7OxL4yXnFk1IQ/s
         d5tj5tY6qnIiEsTPjCv6qd8Tf0pWjYnLkSj6ynR+hry3rr8rHvLKe1S7VyHp7Xst3pRE
         rena6MM9sqr1fgJjsk3Y3MitEkLT+5NENJaiRrHWzAQU5PQTJABKOoysbQcPgerrJ+xj
         t0hmLTlL2tFfpABiNNOQqpGkwcRq3TU9svW6eJvZNDt1ccN6aCL70fK0G4u86FydzQE8
         xjG/dGnpA/LWvthGHgd12eza+C4P9WsAPJ1AF4lS/VQDPy7rDrZTY4GO1XHUpt5k55vI
         yR+w==
X-Gm-Message-State: AJIora8FQNZg8uTvuZJgSCb5MabNBm3oNh0IBEKi2q0Jz2WbSjiq2xQO
        pPBngCkOMBbf6gflWB8OPmA=
X-Google-Smtp-Source: AGRyM1sAB01pFjFQOTRjz0lUbJkkT+bF6gCDtUNd+vjPSno46lAHOGA4+q84I+zuZDsyccK/uVZ9eA==
X-Received: by 2002:a02:6619:0:b0:32e:25b7:d9ed with SMTP id k25-20020a026619000000b0032e25b7d9edmr6935194jac.30.1655517468166;
        Fri, 17 Jun 2022 18:57:48 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id w9-20020a02cf89000000b003313005be01sm2901511jar.141.2022.06.17.18.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 18:57:47 -0700 (PDT)
Date:   Fri, 17 Jun 2022 18:57:41 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Alexandr Lobakin <alexandr.lobakin@intel.com>
Message-ID: <62ad3115619b0_24b342084c@john.notmuch>
In-Reply-To: <20220616180609.905015-3-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-3-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH v4 bpf-next 02/10] ice: allow toggling loopback mode via
 ndo_set_features callback
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Maciej Fijalkowski wrote:
> Add support for NETIF_F_LOOPBACK. This feature can be set via:
> $ ethtool -K eth0 loopback <on|off>
> 
> Feature can be useful for local data path tests.
> 
> CC: Alexandr Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---

Patch looks fine one question about that ice_set_features() function
though.

Acked-by: John Fastabend <john.fastabend@gmail.com>

[...]

> +/**
> + * ice_set_loopback - turn on/off loopback mode on underlying PF
> + * @vsi: ptr to VSI
> + * @ena: flag to indicate the on/off setting
> + */
> +static int
> +ice_set_loopback(struct ice_vsi *vsi, bool ena)
> +{
> +	bool if_running = netif_running(vsi->netdev);
> +	int ret;
> +
> +	if (if_running && !test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
> +		ret = ice_down(vsi);
> +		if (ret) {
> +			netdev_err(vsi->netdev, "Preparing device to toggle loopback failed\n");
> +			return ret;
> +		}
> +	}
> +	ret = ice_aq_set_mac_loopback(&vsi->back->hw, ena, NULL);
> +	if (ret)
> +		netdev_err(vsi->netdev, "Failed to toggle loopback state\n");
> +	if (if_running)
> +		ret = ice_up(vsi);
> +
> +	return ret;
> +}
> +
>  /**
>   * ice_set_features - set the netdev feature flags
>   * @netdev: ptr to the netdev being adjusted
> @@ -5960,7 +5988,10 @@ ice_set_features(struct net_device *netdev, netdev_features_t features)
>  		      clear_bit(ICE_FLAG_CLS_FLOWER, pf->flags);
>  	}
>  
> -	return 0;
> +	if (changed & NETIF_F_LOOPBACK)
> +		ret = ice_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK));
> +
> +	return ret;

Unrelated to your patch, but because you are messing with 'ret' here a bit,
how come you return 0 when ice_is_safe_mode() shouldn't you push that
error up so the user who is doing the setting knows it didn't actually
work?

>  }
>  
>  /**
> -- 
> 2.27.0
> 


