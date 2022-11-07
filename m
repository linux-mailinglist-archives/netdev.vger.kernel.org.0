Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE3561FFE0
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 21:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbiKGU4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 15:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiKGU4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 15:56:02 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38081098;
        Mon,  7 Nov 2022 12:56:01 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id a13so19597921edj.0;
        Mon, 07 Nov 2022 12:56:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aZz5lIxuDB7I0z1jD8r02lw8MXfBIpXPRDPu83kXprE=;
        b=lcXa8yD0SgTUPQeGlv227tDRMrB5NnfEInO0NrD4HykU0N5ueMLTDPxXEpe4pJTJY5
         +wK/aRIZRTyxwXuzqNVBd8eKLBMBlIyI/JgcV3eN5CfMcZaVcgbh1cmGfJ4qY6CMN1pS
         y/WPX1gnhv8dezjEePLyT+6MI5cREwiKs0FzVshIW0A2tUUuBECTwEfygyBjw0EIzIL7
         bfOsiCsZuwm/C0dTUElfowYYH8InVD+HVNS3XC3piOewEAbrSbFNpOExugQl+Ah8DPmh
         pGple9hGCOZkPNH3sAjqfQjV9Zgi8FmSPGJWBpDRSz8UD13WzNVlwGZoXX9OoGjyNQ0W
         ldww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aZz5lIxuDB7I0z1jD8r02lw8MXfBIpXPRDPu83kXprE=;
        b=tqrH1ILb3YYK/CddF403I/7JhZRp7qR99lwwxmryHEUgflOD5Oj3qA21WfphVLCxnS
         9ZBYx84fxa5hCfy6SCvM+AZjGk8nVnUe7CczTV/kcz2a3n7QYI+6jqMXEhcH5tA7jDkc
         LFT+ghUNwMCkpcsQdcCEbgE5zvS/q4FYLCdmDzHL5KXKyrnK0mCV0V2k1/5uAGytvHy6
         4wLNPDCHlY0SZDegw/bPWfuLwdvxbcG/zkHE4XSkkh5gTyXfTCxPKNIrB2vN3brxa2oI
         OT6TPH530/2A8gZYvn3O0AFevqZOmu3mlp1eyq13ZGrrw8QBGe6CJ24TaAcQ/KUlr7Qx
         bMMg==
X-Gm-Message-State: ACrzQf22NhMLBkkDcqkzmlMlIG8utC9fuFst6DpojgcXUJT5XU+1QYdV
        ClLf2Zu5gRZSTVZLKvcLhIE=
X-Google-Smtp-Source: AMsMyM6ioc0P0uojdmQ1u0VY0uZvTZqZ5dbDJ15EFDJgrrKmfO6nqvWye/xti1qfyvHjVNe1PfWaDA==
X-Received: by 2002:a50:ef06:0:b0:463:2605:d24d with SMTP id m6-20020a50ef06000000b004632605d24dmr47036181eds.43.1667854560277;
        Mon, 07 Nov 2022 12:56:00 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id g18-20020a17090604d200b0073dc5bb7c32sm3882261eja.64.2022.11.07.12.55.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 12:55:59 -0800 (PST)
Date:   Mon, 7 Nov 2022 22:55:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/14] net: ethernet: mtk_eth_soc: account for vlan in rx
 header length
Message-ID: <20221107205553.cnydzeh3tmilqblx@skbuf>
References: <20221107185452.90711-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107185452.90711-1-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 07:54:39PM +0100, Felix Fietkau wrote:
> This may be needed for correct MTU settings on devices using DSA
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.h b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> index 589f27ddc401..dcf2a0d5da33 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.h
> @@ -29,7 +29,7 @@
>  #define MTK_TX_DMA_BUF_LEN_V2	0xffff
>  #define MTK_DMA_SIZE		512
>  #define MTK_MAC_COUNT		2
> -#define MTK_RX_ETH_HLEN		(ETH_HLEN + ETH_FCS_LEN)
> +#define MTK_RX_ETH_HLEN		(VLAN_ETH_HLEN + ETH_HLEN + ETH_FCS_LEN)

Commit title says account for VLAN (VLAN_HLEN, 4 bytes), code says add
VLAN_ETH_HLEN (18) more bytes.

Also, why is DSA mentioned in the commit message? Is accounting for VLAN
hlen not needed if DSA is not used? Why?

>  #define MTK_RX_HLEN		(NET_SKB_PAD + MTK_RX_ETH_HLEN + NET_IP_ALIGN)
>  #define MTK_DMA_DUMMY_DESC	0xffffffff
>  #define MTK_DEFAULT_MSG_ENABLE	(NETIF_MSG_DRV | \
> -- 
> 2.38.1
> 
