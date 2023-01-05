Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4B765E764
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 10:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbjAEJKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 04:10:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232107AbjAEJKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 04:10:17 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9306A33D64;
        Thu,  5 Jan 2023 01:10:16 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id z16so18974779wrw.1;
        Thu, 05 Jan 2023 01:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hJHxOQO4N1hVQlNWLaYS7uiORL25B97K1+y7ilH6tPU=;
        b=n9S9mo7pTHK6PFhYNyqFdfYI/hxcvdrzmCyv2sR4gGv/AnFmiMJss9H3ptXwDDgyDB
         Zncv6CusCIlB5ujjFfPsxHRp/fKZlGt2ek6DUED2fEIgvJGvJuaZcq9B5QigGYruQ3eq
         gGqqd3yY9IkQugrAr0QvNdg/kg286thMXHOIx80mTxA89EqgpsIOHnmqkKGzqdmUZveI
         s9rA1FnBCNQM+kPUpui7AEXKnQCkbtv7BgIL974Z66cHg64jzv7xOqhMj15QB/7han48
         W84qR9jZOWjenZvhWS2Xiaw5BIWXgJrIcab3r8z7M0Ylp04xDmdUihs8TPthSKntx80T
         xarg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hJHxOQO4N1hVQlNWLaYS7uiORL25B97K1+y7ilH6tPU=;
        b=EcDpjosry5GXNFFmnPxlVnafsxeE79Ws6uFOcciDtii4wQ+7qktSNVfzKRe99z+QGD
         iYV5X/334Vm4ZxfX35yiuL3JJq1PZMLY6gfeEa93x4gmqpijyA3hW5eoWHl4jDdlQYMU
         E5Twqm7uz6bQYB7j7nlpTZ0qzL20Qab146Cxm3xXMSC7wlkBk6I6fdeK2aE9DoNpfPL3
         C8wmtjZIhq09MlOnIM7ZRvQnGP0ulw575jaod42qH+/aL9VZxm7rDdUZOsMo28PmPGU9
         LTq1Y6rzTgHymyOP1vekF4lBQ3Xrr85gIteU0oBoKt8sXUP4j36wM120ch2SvPe5QBP0
         XvEA==
X-Gm-Message-State: AFqh2koU33ZiJTcbKPW1KFBCqbU9zQ9wR2c0rClaHIFFycFmpDQEN7+v
        Fizll2nzXTiIgK4qcWvwL54=
X-Google-Smtp-Source: AMrXdXtoohBaSHmotbz3uUa0FhQA5zbqAVQQxrdH/tcyN1e8HeYQ6144fHvEno7hcOoG0xG80IaglQ==
X-Received: by 2002:a5d:45d2:0:b0:27a:d81:112e with SMTP id b18-20020a5d45d2000000b0027a0d81112emr24370123wrs.15.1672909815083;
        Thu, 05 Jan 2023 01:10:15 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id i13-20020a5d438d000000b0029e1aa67fd2sm7373174wrq.115.2023.01.05.01.10.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 01:10:14 -0800 (PST)
Date:   Thu, 5 Jan 2023 12:10:11 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Daniel Machon <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Subject: Re: [PATCH net-next 2/8] net: microchip: sparx5: Reset VCAP counter
 for new rules
Message-ID: <Y7aT8xGOCfvC/U0a@kadam>
References: <20230105081335.1261636-1-steen.hegelund@microchip.com>
 <20230105081335.1261636-3-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105081335.1261636-3-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:13:29AM +0100, Steen Hegelund wrote:
> When a rule counter is external to the VCAP such as the Sparx5 IS2 counters
> are, then this counter must be reset when a new rule is created.
> 
> Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> ---
>  drivers/net/ethernet/microchip/vcap/vcap_api.c       | 3 +++
>  drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c | 4 ++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> index b9b6432f4094..67e0a3d9103a 100644
> --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> @@ -1808,6 +1808,7 @@ int vcap_add_rule(struct vcap_rule *rule)
>  {
>  	struct vcap_rule_internal *ri = to_intrule(rule);
>  	struct vcap_rule_move move = {0};
> +	struct vcap_counter ctr = {0};
>  	int ret;
>  
>  	ret = vcap_api_check(ri->vctrl);
> @@ -1833,6 +1834,8 @@ int vcap_add_rule(struct vcap_rule *rule)
>  	ret = vcap_write_rule(ri);
>  	if (ret)
>  		pr_err("%s:%d: rule write error: %d\n", __func__, __LINE__, ret);
> +	/* Set the counter to zero */
> +	ret = vcap_write_counter(ri, &ctr);
>  out:
>  	mutex_unlock(&ri->admin->lock);
>  	return ret;

I feel like you intended to send a v2 series but accidentally resent
the v1 series.  Otherwise I guess I have the same question as before.

regards,
dan carpenter

