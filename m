Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA6186058DE
	for <lists+netdev@lfdr.de>; Thu, 20 Oct 2022 09:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230519AbiJTHmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 03:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiJTHmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 03:42:03 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A786BDCADF;
        Thu, 20 Oct 2022 00:41:33 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id b4so32885743wrs.1;
        Thu, 20 Oct 2022 00:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=o3c3tgj6YU8jOhwmT3k1jbsOKTdSciZj9+jY8nlizX8=;
        b=TkEbz0vzHhsxl9Qq4QlCXr0MTB/G10131WGqp06yOx4xsx9Os8itwFSjToDVbcmWYf
         lFgVeEeD6J5dOpOB9joKSs57h24iRmrT3pKTML95Vu7zijcZv4xf+8WxkKVZrqSHUUYL
         OoPDjeeacFwKo2fcq4iYXxbHxgDB5IJ/rt8O9tGiqO//J5NgkR/gswWylXaF/McwFTul
         guVTqHzHW9kgyQoLOjvCg4XpPmj04FkkuEJU2wfVxn1uZeuEkhLEoQYB+u174k2/G41a
         E7QuaceIT9ttJzjb56TKGuerqoHHC5b2zP++CMD1FXbrElMxmr6aCQBueNs1wxTUPP6j
         eAHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references
         :organization:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o3c3tgj6YU8jOhwmT3k1jbsOKTdSciZj9+jY8nlizX8=;
        b=Ueae2AzaX9k3QY+tS8ZP4USVvfhrp1E5jqO2FAniFyePRlslPGLkEJn1BbhmcACisf
         Fai7QegCiN4IjAeJapc2OBxdkVnCsbuU36OzOnYflbCleTed4B7rdH0Ni5yyBQhbyGud
         ow+lNCFsXEjBMG9wyW3FQKsec2MHZxZmELV81ENb7TYYcgSA+cs7tnJye9ntx6kClnMi
         ie19Jt5CKHYIbxrFLSvu27MuBm/M5vepvERpZuTgtsN6dHSDGN3e0alDlsb+3uiTVJ0l
         W6JZrD8apKi7ZYOm/m6mEiPp1OAUwYnAZtLGnkmLMF+GCxvYyLi+ihIh2v93rAgoZmgf
         zUjQ==
X-Gm-Message-State: ACrzQf2JESkJ8fOYg7w5aH3zPYrAPrRkZD88tzPHlBe0j47oJm9s1i0w
        0VilfOq4kkseVIczsSFOvqQ=
X-Google-Smtp-Source: AMsMyM7iZLZ9gdsJyxQw8mPwRFAftKRx37Ts6dIplF3mmkJMH+HyE1MZImhi3FAfYW1x0PZ67A6rGA==
X-Received: by 2002:a05:6000:1106:b0:22e:3dee:9a5a with SMTP id z6-20020a056000110600b0022e3dee9a5amr7510873wrw.191.1666251666205;
        Thu, 20 Oct 2022 00:41:06 -0700 (PDT)
Received: from wse-c0155 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id e14-20020a5d65ce000000b0022abcc1e3cesm15571334wrw.116.2022.10.20.00.41.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 00:41:05 -0700 (PDT)
Date:   Thu, 20 Oct 2022 09:41:04 +0200
From:   Casper Andersson <casper.casan@gmail.com>
To:     Steen Hegelund <steen.hegelund@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, UNGLinuxDriver@microchip.com,
        Randy Dunlap <rdunlap@infradead.org>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        Nathan Huckleberry <nhuck@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v2 6/9] net: microchip: sparx5: Adding basic
 rule management in VCAP API
Message-ID: <20221020074104.qmow2fc66v4is2rk@wse-c0155>
Organization: Westermo Network Technologies AB
References: <20221019114215.620969-1-steen.hegelund@microchip.com>
 <20221019114215.620969-7-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019114215.620969-7-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-10-19 13:42, Steen Hegelund wrote:
> +/* Write VCAP cache content to the VCAP HW instance */
> +static int vcap_write_rule(struct vcap_rule_internal *ri)
> +{
> +	struct vcap_admin *admin = ri->admin;
> +	int sw_idx, ent_idx = 0, act_idx = 0;
> +	u32 addr = ri->addr;
> +
> +	if (!ri->size || !ri->keyset_sw_regs || !ri->actionset_sw_regs) {
> +		pr_err("%s:%d: rule is empty\n", __func__, __LINE__);
> +		return -EINVAL;
> +	}
> +	/* Use the values in the streams to write the VCAP cache */
> +	for (sw_idx = 0; sw_idx < ri->size; sw_idx++, addr++) {
> +		ri->vctrl->ops->cache_write(ri->ndev, admin,
> +					VCAP_SEL_ENTRY, ent_idx,
> +					ri->keyset_sw_regs);
> +		ri->vctrl->ops->cache_write(ri->ndev, admin,
> +					VCAP_SEL_ACTION, act_idx,
> +					ri->actionset_sw_regs);
> +		ri->vctrl->ops->update(ri->ndev, admin, VCAP_CMD_WRITE,
> +				   VCAP_SEL_ALL, addr);

Arguments not aligned with opening parenthesis.

>  /* Validate a rule with respect to available port keys */
>  int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
>  {
>  	struct vcap_rule_internal *ri = to_intrule(rule);
> +	enum vcap_keyfield_set keysets[10];
> +	struct vcap_keyset_list kslist;
> +	int ret;
>  
>  	/* This validation will be much expanded later */
> +	ret = vcap_api_check(ri->vctrl);
> +	if (ret)
> +		return ret;
>  	if (!ri->admin) {
>  		ri->data.exterr = VCAP_ERR_NO_ADMIN;
>  		return -EINVAL;
> @@ -113,14 +304,41 @@ int vcap_val_rule(struct vcap_rule *rule, u16 l3_proto)
>  		ri->data.exterr = VCAP_ERR_NO_KEYSET_MATCH;
>  		return -EINVAL;
>  	}
> +	/* prepare for keyset validation */
> +	keysets[0] = ri->data.keyset;
> +	kslist.keysets = keysets;
> +	kslist.cnt = 1;
> +	/* Pick a keyset that is supported in the port lookups */
> +	ret = ri->vctrl->ops->validate_keyset(ri->ndev, ri->admin, rule, &kslist,
> +					      l3_proto);
> +	if (ret < 0) {
> +		pr_err("%s:%d: keyset validation failed: %d\n",
> +		       __func__, __LINE__, ret);
> +		ri->data.exterr = VCAP_ERR_NO_PORT_KEYSET_MATCH;
> +		return ret;
> +	}
>  	if (ri->data.actionset == VCAP_AFS_NO_VALUE) {
>  		ri->data.exterr = VCAP_ERR_NO_ACTIONSET_MATCH;
>  		return -EINVAL;
>  	}
> -	return 0;
> +	vcap_add_type_keyfield(rule);
> +	/* Add default fields to this rule */
> +	ri->vctrl->ops->add_default_fields(ri->ndev, ri->admin, rule);
> +
> +	/* Rule size is the maximum of the entry and action subword count */
> +	ri->size = max(ri->keyset_sw, ri->actionset_sw);
> +
> +	/* Finally check if there is room for the rule in the VCAP */
> +	return vcap_rule_space(ri->admin, ri->size);
>  }
>  EXPORT_SYMBOL_GPL(vcap_val_rule);

Validating a rule also modifies it. I think validation and modification
should generally be kept apart. But it looks like it might be hard with
the current design since you need to add the fields to then check the
space it takes, and the rule sizes can depend on the hardware.

Tested on Microchip PCB135 switch.

Tested-by: Casper Andersson <casper.casan@gmail.com>
Reviewed-by: Casper Andersson <casper.casan@gmail.com>

