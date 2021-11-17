Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7CFC454DB4
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 20:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240390AbhKQTPO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 14:15:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239360AbhKQTPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 14:15:12 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CECC061570
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:12:14 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id o14so3034448plg.5
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 11:12:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Kj1hPgoy1NujK9T9y4QWmTDZ2y+LhA1E0FDsruIlBro=;
        b=GK3Lfp+icgkhq4mw7yso0WHnFBAc+cWWSvfU93NFIs2O3/KGsAVlf7kgpjYSf5Fu7D
         qKxJSBR0sSPwz8hfGlM/V/qOMYb9IY+us1FDOOA0k/r3ayr8QCtoCNfwlqSOAVMy+yjV
         C4TsWw4yxq8h7XEXOIcnjUViLieRdiV9WtTo6KbpEC3EvamHzJ0FW2O8bvfqcwE7n0ui
         wy9uzCNPzbbIfKHehLxSNj1tkCWPjJHREanUWJeXyFtJaW+9ipNJ9eCfrpGbKTH8D0Vd
         U8cebtzr18PeOawFtL5w6FjL3mp+45l9C+RlIqtpuFn+7jWIZJ2GFPoB1eFSxG0urOaS
         qjlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Kj1hPgoy1NujK9T9y4QWmTDZ2y+LhA1E0FDsruIlBro=;
        b=Mta2J48/fuutplVnReXRhL2bu9RCUFg7WFm1uMo4RMU4HEVuRHNwuwoPbP4YJjn/JD
         /iZ1YxVarJric42tccY0zTqyRI9iasuab7oDoVSmGkOcmG263hGsccH/3eOE2hR3y4Pf
         BN33eFv2YqsEFMSfi0o5AuYsTwfTeAIyc3T9ARTdNDU5RLMw7u1tmYrghKE7vOx/Z5h0
         TVNc+8U41iMsHsTryXP+wAQHfedrsN2FFHhcVWT/zjpjZLm55B2hxeQ+EDtRflrjlv6M
         zAIW8vTGGT59I7xK5ZMcR1SkIZ9DCc7y2kzV13DGGEe7fh9652jQ09aMn/NI0xD8J+nB
         3O6g==
X-Gm-Message-State: AOAM531X5M6GO2K3npRy2J6nG2p4vbH/DomXPkg8VTJRyKVoybe67BgE
        clvQ/O26Jx5NMhl7e6+Mdjxkge28SF/7cw==
X-Google-Smtp-Source: ABdhPJxM4u7m6G5emgQKMgcD877el/2Oh/s56dEFYBQ1cfdfx/CXai25r7Hu4DJSlOryfTdtPASRCg==
X-Received: by 2002:a17:902:e547:b0:141:ddbc:a8d6 with SMTP id n7-20020a170902e54700b00141ddbca8d6mr58101284plf.27.1637176333656;
        Wed, 17 Nov 2021 11:12:13 -0800 (PST)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id d21sm359243pfu.52.2021.11.17.11.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 11:12:13 -0800 (PST)
Date:   Wed, 17 Nov 2021 11:12:10 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Maxim Petrov <mmrmaximuzz@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        gnault@redhat.com
Subject: Re: [PATCH iproute2] tc/m_vlan: fix print_vlan() conditional on
 TCA_VLAN_ACT_PUSH_ETH
Message-ID: <20211117111210.5b5741c9@hermes.local>
In-Reply-To: <091bdc88-9386-288e-25ba-7d369ad9a6b5@gmail.com>
References: <091bdc88-9386-288e-25ba-7d369ad9a6b5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 21:05:33 +0300
Maxim Petrov <mmrmaximuzz@gmail.com> wrote:

> Fix the wild bracket in the if clause leading to the error in the condition.
> 
> Signed-off-by: Maxim Petrov <mmrmaximuzz@gmail.com>
> ---
>  tc/m_vlan.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/tc/m_vlan.c b/tc/m_vlan.c
> index 221083df..1b2b1d51 100644
> --- a/tc/m_vlan.c
> +++ b/tc/m_vlan.c
> @@ -279,8 +279,8 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
>  				    ETH_ALEN, 0, b1, sizeof(b1));
>  			print_string(PRINT_ANY, "dst_mac", " dst_mac %s", b1);
>  		}
> -		if (tb[TCA_VLAN_PUSH_ETH_SRC &&
> -		       RTA_PAYLOAD(tb[TCA_VLAN_PUSH_ETH_SRC]) == ETH_ALEN]) {
> +		if (tb[TCA_VLAN_PUSH_ETH_SRC] &&
> +		       RTA_PAYLOAD(tb[TCA_VLAN_PUSH_ETH_SRC]) == ETH_ALEN) {
>  			ll_addr_n2a(RTA_DATA(tb[TCA_VLAN_PUSH_ETH_SRC]),
>  				    ETH_ALEN, 0, b1, sizeof(b1));
>  			print_string(PRINT_ANY, "src_mac", " src_mac %s", b1);

Fixes: d61167dd88b4 ("m_vlan: add pop_eth and push_eth actions")
