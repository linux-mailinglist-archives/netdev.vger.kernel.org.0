Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADD414CE1FD
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 02:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbiCEB5m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 20:57:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiCEB5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 20:57:42 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CAAC1C2D8E
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 17:56:50 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id bx5so8715211pjb.3
        for <netdev@vger.kernel.org>; Fri, 04 Mar 2022 17:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=E7CbjszNV8xvdjojbAjc2s4n8piTXsYL5eMlqz9+AJY=;
        b=26WgoLpH5HgZlmgT7xWdajahtUj3WcDy8vHxQNBLjEejDTyolyg0tFMy878ljhdiN5
         betzlDE0nX/Q5BpLnZlNPqjfrgju4eDqywMZZYX7Sd5LCYl4q2+H5Ke/QlfjXwU/Gds+
         0ZBoP0MEl0e1cmf+q3h7z/IAtIA7CWpekd7poAJIG/FFDn3hZw1TOqCe6VehHTYGp46k
         N27oFf+NNnCQHpulEaYr1P2V7ApW+g0f/UIafsGAqf3ZmJF2T/y6FLvmRe/cmQ7DIEhp
         UWXDIaQQ5KDGRBrqsGswM0tef2hjjBwPtQGiP2oWN8koRFpWFTUNo5EFGfwwzz80/RIA
         J6qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=E7CbjszNV8xvdjojbAjc2s4n8piTXsYL5eMlqz9+AJY=;
        b=CrSNp7N+pg1GKAnh0Sz5F4Awy72ZSCwI/KOlp4vfjK5PdJjSUEjEsBpu+HhblmfBYQ
         TM6VxfZiGyaYFNm9TLYbbHnoS1AiKwWfWlLqG6swEUC0ISvkaKpDSBjNYuOBPgSXMh3j
         8CI0S+xm7kb896rEZE1dg0a2e+Mv4n0QcJ9mRWUxyS9B/Hf45vsZZzl71wDc1B0vTAjX
         VG3zZnNrFeNXaz2vwFpfeSZQvksN/AydCY8EdT7nV52ouIFRqQyvgefjAlTM/Khw9neS
         Zfl/0P0QDI5ASncn+RayLwFeC4Q/NGc4Kz7qhGbxZpuFMXKtZ7Me8edqXo2NYEnaEDtQ
         9I0w==
X-Gm-Message-State: AOAM533K+nn2bNBVhmexZ0TPhPLgYHdPgyopPlpgA+YyG+sIn9MiPqnq
        0fpEKvuZbsVTc7xk/s+PCXsRhA==
X-Google-Smtp-Source: ABdhPJy2n8lf2SX86LvCJVCmxRXhhJtAjM+TQE9E71PF1jWjVP/6lgBn8EaC1r6Yv89OSDPz2QoX0w==
X-Received: by 2002:a17:90b:17ce:b0:1bd:3384:eab7 with SMTP id me14-20020a17090b17ce00b001bd3384eab7mr13674361pjb.184.1646445409803;
        Fri, 04 Mar 2022 17:56:49 -0800 (PST)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id nn10-20020a17090b38ca00b001bc3a60b324sm5603985pjb.46.2022.03.04.17.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 17:56:49 -0800 (PST)
Date:   Fri, 4 Mar 2022 17:56:46 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Dimitrios Bouras <dimitrios.bouras@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: Transparently receive IP over LLC/SNAP
Message-ID: <20220304175646.11ab96fc@hermes.local>
In-Reply-To: <010ede54-eb81-73ed-53a4-2f8e762984b1@gmail.com>
References: <010ede54-eb81-73ed-53a4-2f8e762984b1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Mar 2022 15:11:21 -0800
Dimitrios Bouras <dimitrios.bouras@gmail.com> wrote:

> diff --git a/net/ethernet/eth.c b/net/ethernet/eth.c
> index ebcc812735a4..1df5446af922 100644
> --- a/net/ethernet/eth.c
> +++ b/net/ethernet/eth.c
> @@ -15,23 +15,24 @@
>   *		Alan Cox, <gw4pts@gw4pts.ampr.org>
>   *
>   * Fixes:
> - *		Mr Linux	: Arp problems
> - *		Alan Cox	: Generic queue tidyup (very tiny here)
> - *		Alan Cox	: eth_header ntohs should be htons
> - *		Alan Cox	: eth_rebuild_header missing an htons and
> - *				  minor other things.
> - *		Tegge		: Arp bug fixes.
> - *		Florian		: Removed many unnecessary functions, code cleanup
> - *				  and changes for new arp and skbuff.
> - *		Alan Cox	: Redid header building to reflect new format.
> - *		Alan Cox	: ARP only when compiled with CONFIG_INET
> - *		Greg Page	: 802.2 and SNAP stuff.
> - *		Alan Cox	: MAC layer pointers/new format.
> - *		Paul Gortmaker	: eth_copy_and_sum shouldn't csum padding.
> - *		Alan Cox	: Protect against forwarding explosions with
> - *				  older network drivers and IFF_ALLMULTI.
> - *	Christer Weinigel	: Better rebuild header message.
> - *             Andrew Morton    : 26Feb01: kill ether_setup() - use netdev_boot_setup().
> + *		Mr Linux		: Arp problems
> + *		Alan Cox		: Generic queue tidyup (very tiny here)
> + *		Alan Cox		: eth_header ntohs should be htons
> + *		Alan Cox		: eth_rebuild_header missing an htons and
> + *					  minor other things.
> + *		Tegge			: Arp bug fixes.
> + *		Florian			: Removed many unnecessary functions, code cleanup
> + *					  and changes for new arp and skbuff.
> + *		Alan Cox		: Redid header building to reflect new format.
> + *		Alan Cox		: ARP only when compiled with CONFIG_INET
> + *		Greg Page		: 802.2 and SNAP stuff.
> + *		Alan Cox		: MAC layer pointers/new format.
> + *		Paul Gortmaker		: eth_copy_and_sum shouldn't csum padding.
> + *		Alan Cox		: Protect against forwarding explosions with
> + *					  older network drivers and IFF_ALLMULTI.
> + *		Christer Weinigel	: Better rebuild header message.
> + *		Andrew Morton		: 26Feb01: kill ether_setup() - use netdev_boot_setup().
> + *		Dimitrios Bouras	: May 2021: transparently receive Ethernet over LLC/SNAP.
>   */

The credits are dead do not touch them
