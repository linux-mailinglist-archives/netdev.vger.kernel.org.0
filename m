Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75F9D6B226F
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 12:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbjCILP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 06:15:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231522AbjCILOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 06:14:49 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DA0EBD97
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 03:10:29 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id bg16-20020a05600c3c9000b003eb34e21bdfso3322230wmb.0
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 03:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678360228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wZWfzNlrXqj97NuGHjIVPszDWgFYnLnludm2DSyLLoY=;
        b=5/rJtuET1MvW8Zc7VnQOaPky2OLZjWr/UBPGisMwGX2r1z1Z3XslwXn11uV8tGyhTE
         sZwvKsXys79B/vB7dn8nnThWQwxyHYsmrhCEA0fLR9YdcQ/k9X5+m91jmrNqWYFagM66
         wEqjL92yQ1NHKaxhtJY3Eke0FWxZ1GGyNLvRWH3ExWfPLygJAVThnGQYPhqhU71OY0Yz
         lBCdyHosvgstWlIu5FQVVurGlJ7XA/9/ABpiMHpyHYCuZpl5D9yZr4jbRlLkWTOvdJFc
         ZIivKDSqGT/R49DtmAyO9xONV4aUtfRtM0ft3K2gn/zFV0No5xaCFOfNlSxpkcKaQ8av
         Mhcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678360228;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wZWfzNlrXqj97NuGHjIVPszDWgFYnLnludm2DSyLLoY=;
        b=UKlYDMHVaonfPkX8fggPYFImk8sMW5qWDFRSaRNCZ+FqWlygoFhF26oH1hfwd+aIBu
         32YY15wjOYgVvBLEE76p1drERIVvm3PGVVzZmlgnIIzYuOak228fXBEDhBx3a4wqBSM5
         HXmXHpQmg43aoeHfSMezC0IEsBLLExn7JRYT8d330qN3LRE6UwPHFNfdimGEDVmgs9Ss
         9SZ8tYSeBCbgJKtiVqUWYiHhU0dteiqKfsrZYoraJKqpl1hl1J8d/Gi8BYhmuQFMOBKW
         eUmBS04pcjXJcQ1YpYZVV3pcPO8UoJTt/NLyYUGX3z2Tda0vetY/twYxrXvCr1f0YKm9
         D6qw==
X-Gm-Message-State: AO0yUKVevB1jUNiC0tpdlNbqY0975qVcOnnirnKqLisnxSdYBwTgMYL0
        Ko8OYPGzsa12zeiKaPVoVak2Yg==
X-Google-Smtp-Source: AK7set+pQp/Y9xFJ1sX0c5ly9x8Lmy8x/AFOdRC3eWXnLmZ3uaaby4Xe8NB8/Yg31rfY+PUXn60PJQ==
X-Received: by 2002:a05:600c:a48:b0:3eb:3912:5ae9 with SMTP id c8-20020a05600c0a4800b003eb39125ae9mr19459954wmq.24.1678360228118;
        Thu, 09 Mar 2023 03:10:28 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l26-20020a1ced1a000000b003b47b80cec3sm2273319wmh.42.2023.03.09.03.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 03:10:27 -0800 (PST)
Date:   Thu, 9 Mar 2023 12:10:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jianguo Wu <wujianguo106@163.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "edumazet@google.com >> Eric Dumazet" <edumazet@google.com>,
        davem@davemloft.net, daniel@iogearbox.net,
        Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next] ipvlan: Make skb->skb_iif track skb->dev for
 l3s mode
Message-ID: <ZAm+ovPoEFfESOQI@nanopsycho>
References: <29865b1f-6db7-c07a-de89-949d3721ea30@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29865b1f-6db7-c07a-de89-949d3721ea30@163.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Mar 09, 2023 at 03:03:36AM CET, wujianguo106@163.com wrote:
>From: Jianguo Wu <wujianguo@chinatelecom.cn>
>
>For l3s mode, skb->dev is set to ipvlan interface in ipvlan_nf_input():
>  skb->dev = addr->master->dev
>but, skb->skb_iif remain unchanged, this will cause socket lookup failed
>if a target socket is bound to a interface, like the following example:
>
>  ip link add ipvlan0 link eth0 type ipvlan mode l3s
>  ip addr add dev ipvlan0 192.168.124.111/24
>  ip link set ipvlan0 up
>
>  ping -c 1 -I ipvlan0 8.8.8.8
>  100% packet loss
>
>This is because there is no match sk in __raw_v4_lookup() as sk->sk_bound_dev_if != dif(skb->skb_iif).
>Fix this by make skb->skb_iif track skb->dev in ipvlan_nf_input().
>
>Fixes: c675e06a98a4 ("ipvlan: decouple l3s mode dependencies from other modes").
>
>Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>
>---
> drivers/net/ipvlan/ipvlan_l3s.c | 1 +
> 1 file changed, 1 insertion(+)
>
>diff --git a/drivers/net/ipvlan/ipvlan_l3s.c b/drivers/net/ipvlan/ipvlan_l3s.c
>index 943d26cbf39f..71712ea25403 100644
>--- a/drivers/net/ipvlan/ipvlan_l3s.c
>+++ b/drivers/net/ipvlan/ipvlan_l3s.c
>@@ -101,6 +101,7 @@ static unsigned int ipvlan_nf_input(void *priv, struct sk_buff *skb,
> 		goto out;
>
> 	skb->dev = addr->master->dev;
>+	skb->skb_iif = skb->dev->ifindex;

I think we should have a macro to replace skb->dev which would handle
this too. It's on multiple places.

Anyway, this patch looks fine to me.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>



> 	len = skb->len + ETH_HLEN;
> 	ipvlan_count_rx(addr->master, len, true, false);
> out:
>-- 
>1.8.3.1
>
