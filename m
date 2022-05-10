Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AAD521595
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 14:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241899AbiEJMl1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 08:41:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241881AbiEJMl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 08:41:26 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A941E123B;
        Tue, 10 May 2022 05:37:28 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id n10so32656659ejk.5;
        Tue, 10 May 2022 05:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cosidqETohHtF0bI5X8WaN3KLjN3jNK+X2ZAPFOKt/o=;
        b=q4WK37dxm2Rg4AHUGk7Wi4kVtwYOHay21u/XuI4XfzNMEyT71Bvff7CmdlnIImsooi
         L9KZIsHxZVuWcbld60k2dRE1nqPdvX9iUDQ/esPVHs7fcjwcgF7tkxvdGJpoR7XYudXS
         muSWsZuXTbqKGCFiSWFmdAHNrCg+ULsFjyrHjBA46B/e3zy9cUsu67O3uGCKSvgG133o
         4hrnYv3h1uEIGEvcaT4O2aifRc6c/kxWAjp3TYhEdZLe/7JVVeLFsV+lyb3uIBNdTlUH
         0kc5vhNXi72hrStZ8d+wUYkAQooUtteY91qjzO6B48GYNOdakRtplEzhT6qK2XZcu76a
         nlLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cosidqETohHtF0bI5X8WaN3KLjN3jNK+X2ZAPFOKt/o=;
        b=On5feP6X8k8BvKNcBy6Ld9fFhkOG1BGTamqu1S1w0MRPKGfgP1yjvT+Kv9Mj+9t0Nu
         SU5JffuxOUpNFkzYwOocx7Do91bHsiKG0DmsEL4RBuwgK5EkIvORpdUCgbWCP7Pty/b5
         g22tTm/5stQAS7I5QV1TF9wsVROfnuwj4QXOgvlPagNm6Blpy4uJAekOvv1CykIddDcB
         nTLfCP0Q1Oqau81tdJVUeAOgH9Dir0eQF6E5vgrYKor5vc63wCIMs8qWJwxh3OLzY44f
         XW6F5hbCEJb7ouD4LP5t7n940Y9OdOQlHg95eY1F6G8YcdR5DTg0AmTyrT+GBlunV/XV
         2ANw==
X-Gm-Message-State: AOAM531/WgVpUGAzAm1Qydmhk5uT3jhsTFTXnu71zlXNsfSNT58yZPQl
        LlOOlj42uaj+OEOjUfNsc/8=
X-Google-Smtp-Source: ABdhPJyvR8it5vxFmmtJtLeJIPRxLec58Z+2m8Tzbxt3mXDU6pHSDFlsyogmrno+6KSTWUzIH/zjyA==
X-Received: by 2002:a17:906:3ce9:b0:6ef:a8aa:ab46 with SMTP id d9-20020a1709063ce900b006efa8aaab46mr19291235ejh.579.1652186247272;
        Tue, 10 May 2022 05:37:27 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id e15-20020a50e44f000000b0042617ba63c7sm7576578edm.81.2022.05.10.05.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 05:37:26 -0700 (PDT)
Date:   Tue, 10 May 2022 15:37:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: dsa: tag_mtk: add padding for tx packets
Message-ID: <20220510123724.i2xqepc56z4eouh2@skbuf>
References: <20220510094014.68440-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510094014.68440-1-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 11:40:13AM +0200, Felix Fietkau wrote:
> Padding for transmitted packets needs to account for the special tag.
> With not enough padding, garbage bytes are inserted by the switch at the
> end of small packets.

I don't think padding bytes are guaranteed to be zeroes. Aren't they
discarded? What is the issue?

> 
> Fixes: 5cd8985a1909 ("net-next: dsa: add Mediatek tag RX/TX handler")
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  net/dsa/tag_mtk.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
> index 415d8ece242a..1d1f9dbd9e93 100644
> --- a/net/dsa/tag_mtk.c
> +++ b/net/dsa/tag_mtk.c
> @@ -25,6 +25,14 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
>  	u8 xmit_tpid;
>  	u8 *mtk_tag;
>  
> +	/* The Ethernet switch we are interfaced with needs packets to be at
> +	 * least 64 bytes (including FCS) otherwise their padding might be
> +	 * corrupted. With tags enabled, we need to make sure that packets are
> +	 * at least 68 bytes (including FCS and tag).
> +	 */
> +	if (__skb_put_padto(skb, ETH_ZLEN + MTK_HDR_LEN, false))
> +		return NULL;
> +
>  	/* Build the special tag after the MAC Source Address. If VLAN header
>  	 * is present, it's required that VLAN header and special tag is
>  	 * being combined. Only in this way we can allow the switch can parse
> -- 
> 2.36.1
> 
