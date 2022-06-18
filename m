Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B7735501CB
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 03:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383656AbiFRB7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 21:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233172AbiFRB7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 21:59:07 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5080C59966;
        Fri, 17 Jun 2022 18:59:06 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id b138so6163698iof.13;
        Fri, 17 Jun 2022 18:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=A4nVtZ1PXJh3o1o6VYTFvZQgsD5YfJ49NGoBi9krf64=;
        b=Iu4gOt7zLFE8AFWq9Wwhg5PjWZWZtGuoBB+Q4/n5aZcpgC4R3ladQbpXHLtWNViU7t
         6k50cZj/eQEfHSxjjQvn4oj9y9hXgRsk7/tBqnMWcFOuAX07HK+78Vv5+8tQn8GvSNKE
         w134epiOlm9qIJjINNJdDJ9rhD21sOQnzYOtSqfAkFzKqu9EKdNM1E3zWl1oUuFLzUNH
         nvif7HWZsYKrxldXxd71aXdvfaSkXMGonCKD1snm2krU6Wl2TaOc061a30yIafFpFt5x
         i7jV3cDQvW+0RyYWyyDXDoONgUhv9j8BJPQAj47YD2TNZKpiLyQRwABvg/w52ki+OXkN
         86hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=A4nVtZ1PXJh3o1o6VYTFvZQgsD5YfJ49NGoBi9krf64=;
        b=2gXVCCaNy8op9ZUplSIuC0SCiMPIgwhnZslOXMd4LSwVOuVsETWgMr0/9OgFue3cIR
         VM7BMDFyzx4fn5UVRepUiHd71vrErns+GfRH02/yscMe3W2n6muU70PAyv1Vp/droE3h
         Tgu4yncNYkFsVb7OIBrQHBiVHkG8UQKvQ0ZA/CfvNVnMR+FRZbvJAvOzNZZsIMf/kR1r
         085+GzDBl9O0Rdfhg7/AYMIbfDSJbU/FsMTZRYK4Uotkz+7VUyQVGkw9EkyJCGT4WcpF
         YADoBHPR6hWPLz4lZy3ufqjv6V+pvbAlPuRaLqUc5+zgFAA4y0GwLFmIb0iHE+3ksIKL
         Lk7Q==
X-Gm-Message-State: AJIora/3RwnTccpnEj5tLq0GhUT9HOXqNZg1XEUjnFIn1CKg2g3lpc9a
        MIv1v7jFZpCHFu1k98PDwUF51L2vifGmpw==
X-Google-Smtp-Source: AGRyM1vOIkpN3SLZyrKH1EW0XVhXMr/njMpk5DM7Kp8dEBd4PdimAMoCWbmEgI3i+ZtPcKQvJ6WQ6w==
X-Received: by 2002:a05:6638:218c:b0:331:a10e:7702 with SMTP id s12-20020a056638218c00b00331a10e7702mr6953630jaj.147.1655517545731;
        Fri, 17 Jun 2022 18:59:05 -0700 (PDT)
Received: from localhost ([172.243.153.43])
        by smtp.gmail.com with ESMTPSA id j16-20020a02cb10000000b0033214fb0061sm2927268jap.23.2022.06.17.18.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 18:59:05 -0700 (PDT)
Date:   Fri, 17 Jun 2022 18:58:57 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, magnus.karlsson@intel.com,
        bjorn@kernel.org, kuba@kernel.org,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Message-ID: <62ad31611159b_24b3420829@john.notmuch>
In-Reply-To: <20220616180609.905015-4-maciej.fijalkowski@intel.com>
References: <20220616180609.905015-1-maciej.fijalkowski@intel.com>
 <20220616180609.905015-4-maciej.fijalkowski@intel.com>
Subject: RE: [PATCH v4 bpf-next 03/10] ice: check DD bit on Rx descriptor
 rather than (EOP | RS)
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
> Tx side sets EOP and RS bits on descriptors to indicate that a
> particular descriptor is the last one and needs to generate an irq when
> it was sent. These bits should not be checked on completion path
> regardless whether it's the Tx or the Rx. DD bit serves this purpose and
> it indicates that a particular descriptor is either for Rx or was
> successfully Txed.
> 
> Look at DD bit being set in ice_lbtest_receive_frames() instead of EOP
> and RS pair.
> 
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Is this a bugfix? If so it should go to bpf tree.

> ---
>  drivers/net/ethernet/intel/ice/ice_ethtool.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> index 1e71b70f0e52..b6275a29fa0d 100644
> --- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
> +++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
> @@ -658,7 +658,7 @@ static int ice_lbtest_receive_frames(struct ice_rx_ring *rx_ring)
>  		rx_desc = ICE_RX_DESC(rx_ring, i);
>  
>  		if (!(rx_desc->wb.status_error0 &
> -		    cpu_to_le16(ICE_TX_DESC_CMD_EOP | ICE_TX_DESC_CMD_RS)))
> +		    cpu_to_le16(BIT(ICE_RX_FLEX_DESC_STATUS0_DD_S))))
>  			continue;
>  
>  		rx_buf = &rx_ring->rx_buf[i];
> -- 
> 2.27.0
> 


