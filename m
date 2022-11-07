Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4466200FE
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 22:22:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233281AbiKGVWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 16:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233299AbiKGVWT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 16:22:19 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D1AD2F7;
        Mon,  7 Nov 2022 13:22:17 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id v17so19639944edc.8;
        Mon, 07 Nov 2022 13:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ddfhd8XwpJplivFsJcCTYCRWaroeD5Sk1QzcIWWbS0c=;
        b=Vy+4wxJA858HcqoCK36dhDhINBXnhv2nNfAeudikvcqnMjt4BeCjjPNOutf2MHEISB
         rKnZa/bY+ndMJsOY+D9hqnnFJj7SVekwqfY7YUzgvyZnC2WFkL749Fqcvw2Ua7yddi58
         J6VIqP+D9q0qWbMsDy6/Szyr+JjA8lByTCbKEbR/SbeWxHVT1ATRe//GcFKGfKLGNwCk
         WtS5mG9Y+Uq4IA2KxpKxFDZNNNaB2m9+1qDhGs3TuBKJlW75KGc5Zi4EAuBUoxdpzFMy
         qW7IInIrO9+7KZCObQPN7q0BRVaj6cf6HDk3e2Pb1jF5aW4VwTPxS6Xu8Dybb2d4v7CN
         LIKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ddfhd8XwpJplivFsJcCTYCRWaroeD5Sk1QzcIWWbS0c=;
        b=CeVBJp/efL1y0RCOtdHIyU49T5hxl226DwWayhPIicP5rn26q94CxFGMHXvRNgUoTa
         Jipq4cV03lBe1LtvueegYI0fNL9G/j6tvMUkemSVXzs4arhcgJZEG7z6LtJ1WnuOj+Oc
         OEufQ2GbQ57PEQFZ1ITA6hhJvq4SbE4WiewuVrajP1Kmhjg1fuFeqKrAn57/L3zBb8ne
         t3Zg8avn5PUuOTxpbyuQ8jpSc4u8LWTHn4e1cz7NMKtdmojN9SOHquDWCLt0lAZbz1xw
         uMchYHgt2LTIiZ2p8vQNu/4bTRlgEl8P1T0UwOf535d3Kl/M/bQcQKxQ1tVlb1CnZLvS
         LUUA==
X-Gm-Message-State: ACrzQf2i2SoslPIhhKpW/Ms6KaZOzLqnWmw9ASJEX0LniJiyC9GxdRKR
        jm0OH4X8IcCOaI2cISsAgII=
X-Google-Smtp-Source: AMsMyM547z9exzJ4wJkpKqv+MqMTl8XFdxtr/iBjb4PZ9RziUaFERL6bJernT2uTQc2z4uSNEne6xg==
X-Received: by 2002:aa7:d5c1:0:b0:459:2515:b27b with SMTP id d1-20020aa7d5c1000000b004592515b27bmr843867eds.338.1667856135756;
        Mon, 07 Nov 2022 13:22:15 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id m19-20020a056402051300b00459cd13fd34sm4615155edv.85.2022.11.07.13.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 13:22:15 -0800 (PST)
Date:   Mon, 7 Nov 2022 23:22:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/14] net: dsa: tag_mtk: assign per-port queues
Message-ID: <20221107212209.4pmoctkze4m2ggbv@skbuf>
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-5-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107185452.90711-5-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 07:54:43PM +0100, Felix Fietkau wrote:
> Keeps traffic sent to the switch within link speed limits
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  net/dsa/tag_mtk.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/dsa/tag_mtk.c b/net/dsa/tag_mtk.c
> index 415d8ece242a..445d6113227f 100644
> --- a/net/dsa/tag_mtk.c
> +++ b/net/dsa/tag_mtk.c
> @@ -25,6 +25,9 @@ static struct sk_buff *mtk_tag_xmit(struct sk_buff *skb,
>  	u8 xmit_tpid;
>  	u8 *mtk_tag;
>  
> +	/* Reserve the first three queues for packets not passed through DSA */
> +	skb_set_queue_mapping(skb, 3 + dp->index);
> +

Should DSA have to care about this detail, or could you rework your
mtk_select_queue() procedure to adjust the queue mapping as needed?

>  	/* Build the special tag after the MAC Source Address. If VLAN header
>  	 * is present, it's required that VLAN header and special tag is
>  	 * being combined. Only in this way we can allow the switch can parse
> -- 
> 2.38.1
> 
