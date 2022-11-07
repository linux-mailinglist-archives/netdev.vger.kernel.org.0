Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A2D62018F
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 22:58:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232425AbiKGV57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 16:57:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232466AbiKGV5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 16:57:51 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2484527DFE;
        Mon,  7 Nov 2022 13:57:49 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id kt23so33777496ejc.7;
        Mon, 07 Nov 2022 13:57:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qzbCcZYE6abK4rogfyukQwAr8W5SRhqjPAbe07SnfK4=;
        b=AH5scc9yi7+5o536WSTKYMvVpfeqBwGiXXDCA8kS5x7p1015s03VLXrukS8TN3TPEF
         oXadRf+avcBM3n5o1+aL5mwC0U1VpAkXN8JXF471Llguv30Ciu8Md6uVQbNYk/C352Kx
         2rUA8yGyH47bHL6F2gWYVlcqKN28tVHNTvoOXGyNQiV0iYIWA7scYkxpVjT6Bn4+RK8r
         6A2j6hX2qcUARdx7rU/nkwwH83aWkLFALID+3AfZgalFQsPso4ewDbxMDQji/iPc6EzZ
         O+L9552u4bu0p9P1QK2dccUG9LN8QpEu0uR5gPULyLX7aPlIZsZFmBHR/Tf3l4MCvmam
         nQMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qzbCcZYE6abK4rogfyukQwAr8W5SRhqjPAbe07SnfK4=;
        b=EgL6h9ChZz3pvq3nR6MxBg81Rpr7EzExP497gON8NqK7RdV6uGUz0oTEn23HrQjzL/
         iDNjrkqSlcHKhaYamjLr+qIkgw8ofWTg06QM5RYoehdHwATnSiadRIMs+4HW4OyJ2LfW
         7/+7fW19tDqkfmNLF4RJq5wDqsvvfbAk07h6QigRWt58cD3zKLMKf14qeasw7r8YwUPd
         UbxgKTPqXtmm3NiIvRmaVHp7+mTRKszNnZS9d9D53gIyGRg4dPDgp7KouQ3utghVtasl
         QED9FcvoxgIgdM5MvNsOgdm9fLcGTFnLZyovBGX9g5P5gSPSahoAecfLaOid2uStCq+7
         pSHQ==
X-Gm-Message-State: ACrzQf17TF/qGl4e7BpwETD6eNaRWEeEjTJE3q7eghVlWnxj+3CSxKJj
        aMY9hf31gwHszysR7bXyg9E=
X-Google-Smtp-Source: AMsMyM57myIzJoJtU6vjzhxGb7lvUtTdBLALmv5Y2jB8Y1CvSXtdn1s+lhKS12v3EgedfJ/h1au0TA==
X-Received: by 2002:a17:907:3188:b0:741:4bf7:ec1a with SMTP id xe8-20020a170907318800b007414bf7ec1amr51202426ejb.448.1667858267490;
        Mon, 07 Nov 2022 13:57:47 -0800 (PST)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id a16-20020a170906369000b0078d9c2c8250sm3877123ejc.84.2022.11.07.13.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 13:57:47 -0800 (PST)
Date:   Mon, 7 Nov 2022 23:57:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
Message-ID: <20221107215745.ascdvnxqrbw4meuv@skbuf>
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-8-nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107185452.90711-8-nbd@nbd.name>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 07:54:46PM +0100, Felix Fietkau wrote:
> On MTK SoC ethernet, using NETIF_F_HW_VLAN_CTAG_RX in combination with hardware
> special tag parsing can pass the special tag port metadata as VLAN protocol ID.
> When the results is added as a skb hwaccel VLAN tag, it triggers a warning from
> vlan_do_receive before calling the DSA tag receive function.
> Remove this warning in order to properly pass the tag to the DSA receive function,
> which will parse and clear it.
> 
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> ---
>  net/8021q/vlan.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/8021q/vlan.h b/net/8021q/vlan.h
> index 5eaf38875554..3f9c0406b266 100644
> --- a/net/8021q/vlan.h
> +++ b/net/8021q/vlan.h
> @@ -44,7 +44,6 @@ static inline int vlan_proto_idx(__be16 proto)
>  	case htons(ETH_P_8021AD):
>  		return VLAN_PROTO_8021AD;
>  	default:
> -		WARN(1, "invalid VLAN protocol: 0x%04x\n", ntohs(proto));

Why would you ever want to remove a warning that's telling you you're
doing something wrong?

Aren't you calling __vlan_hwaccel_put_tag() with the wrong thing (i.e.
htons(RX_DMA_VPID()) as opposed to VPID translated to something
digestible by the rest of the network stack.. ETH_P_8021Q, ETH_P_8021AD
etc)?

>  		return -EINVAL;
>  	}
>  }
> -- 
> 2.38.1
> 
