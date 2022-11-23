Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7407063619F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 15:25:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbiKWOZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 09:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237469AbiKWOZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 09:25:26 -0500
Received: from mail-oa1-x2a.google.com (mail-oa1-x2a.google.com [IPv6:2001:4860:4864:20::2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAA98CFEB
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:24:18 -0800 (PST)
Received: by mail-oa1-x2a.google.com with SMTP id 586e51a60fabf-12c8312131fso20972107fac.4
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 06:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fwCO2uKjdZLr+dO0oXLssXn0gU+gYyM+H5Ar9EdR+9c=;
        b=OlJxFwfbzUzX5dQr++IGmlkW2xFP0zkUd58GP4VJGJI9txWLTnScS4seSHotIMISfv
         LG9eTZezz94cK/4Wa+jnEtJ0WJU6GnyTal44vfZZvwrGpfXYXb3JdkEK532ZM9l+hI0r
         4OoNlkE7aLyC6UzM9QEgx1Xspb0Y3035lkdIjUmYcTZpfFL6R163fvQuyposkbbO6+pB
         VPUDYiXDSEHSwG5I4LbZ0znQgQVu23BYu0v+VfP+8XfGU1WeFY7xdMHjZsHkcR8GelbW
         VMx3lqkWI1ofXKbJwdTAsYMUJcc0ZAoA6L/H1ya9ICpKpqJHRXNNhN6CuZ9jBSLT0RCk
         Cc8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fwCO2uKjdZLr+dO0oXLssXn0gU+gYyM+H5Ar9EdR+9c=;
        b=4g3I4wYBkcoR2rlA6OWq4gpINJrVJ457IRMJfrmmmaPFXFZsq6KVY99845psS4A4L7
         B/y+C6TdOdTh9rt8l8KPiwoKKey3WN2bE7n986eUWPaQ7dlpkp3fP0BTk3BCOueQx3Yk
         AexCgEzXIG26A/nKTP3yTWLwjgR/xGGeajg4HYMl432phV0BIfeSyHcbf69iROHMzpA4
         gL1aPCnSVebSCRbH2MrEFUtD5JvKJGwb8lsgSLCYN9Qjd/Nt3rdrG+4klTHalUkbBapz
         +iol6nYJcaiHjRRGB2PuTHY49QyGAR94RjTmYeSPTcdwtcoIMjhYZY+LVZDy4bljqJDk
         JewA==
X-Gm-Message-State: ANoB5pkjdQlidtf1FP0aS+Df4gwgz6ZOErfOioIaoap3E9aoEuogCZJ1
        brcmXVwClWGWVgUbhheIvbY=
X-Google-Smtp-Source: AA0mqf7m8CFilmZ5MCCZQXBry1Q+k43bVwYj+OYlDoHAZPyuYIne6RtXeGL6asFtNpLbSZsGE3PH0w==
X-Received: by 2002:a05:6870:a104:b0:140:a448:b7bb with SMTP id m4-20020a056870a10400b00140a448b7bbmr7863545oae.213.1669213441188;
        Wed, 23 Nov 2022 06:24:01 -0800 (PST)
Received: from t14s.localdomain ([2001:1284:f016:5412:fa8e:2d33:bd7c:54c7])
        by smtp.gmail.com with ESMTPSA id n24-20020a4ae1d8000000b0049fd73ccf72sm4446469oot.42.2022.11.23.06.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 06:24:00 -0800 (PST)
Received: by t14s.localdomain (Postfix, from userid 1000)
        id ADBEE459C9D; Wed, 23 Nov 2022 11:23:58 -0300 (-03)
Date:   Wed, 23 Nov 2022 11:23:58 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        ovs-dev@openvswitch.org, davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCHv2 net-next 3/5] net: sched: return NF_ACCEPT when fails
 to add nat ext in tcf_ct_act_nat
Message-ID: <Y34s/iGaTfj0DwRg@t14s.localdomain>
References: <cover.1669138256.git.lucien.xin@gmail.com>
 <439676c5242282638057f92dc51314df7bcd0a73.1669138256.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <439676c5242282638057f92dc51314df7bcd0a73.1669138256.git.lucien.xin@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 12:32:19PM -0500, Xin Long wrote:
> This patch changes to return NF_ACCEPT when fails to add nat
> ext before doing NAT in tcf_ct_act_nat(), to keep consistent
> with OVS' processing in ovs_ct_nat().
> 
> Reviewed-by: Saeed Mahameed <saeed@kernel.org>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  net/sched/act_ct.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
> index da0b7f665277..8869b3ef6642 100644
> --- a/net/sched/act_ct.c
> +++ b/net/sched/act_ct.c
> @@ -994,7 +994,7 @@ static int tcf_ct_act_nat(struct sk_buff *skb,
>  
>  	/* Add NAT extension if not confirmed yet. */
>  	if (!nf_ct_is_confirmed(ct) && !nf_ct_nat_ext_add(ct))
> -		return NF_DROP;   /* Can't NAT. */
> +		return NF_ACCEPT;   /* Can't NAT. */

I'm wondering if the fix should actually be in OVS, to make it drop
the packet? Aaron, Eelco?

If the user asked for NAT, and it can't NAT, it doesn't seem right to
forward the packet while not performing the asked action.

If we follow the code here, it may even commit the entry without the
NAT extension, rendering the connection useless/broken per the first
if condition above. It just won't try again.

>  
>  	if (ctinfo != IP_CT_NEW && (ct->status & IPS_NAT_MASK) &&
>  	    (ctinfo != IP_CT_RELATED || commit)) {
> -- 
> 2.31.1
> 
