Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B026943C5
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 12:04:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjBMLEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 06:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjBMLEN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 06:04:13 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EC584691;
        Mon, 13 Feb 2023 03:04:04 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id bg5-20020a05600c3c8500b003e00c739ce4so8684735wmb.5;
        Mon, 13 Feb 2023 03:04:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kir9kI70OwVh4537TiH5wl8iuSbkpWMjHOA2BO/ND5k=;
        b=b7IPcyYuYihUv3j2jJk9iFsuIZcvMW9nCCzI+rgUsDMrWTM8jgRydKNB0qLWsHcqI2
         bWAVVoSWAyM+n7AT91/odFePzvKFkkm2t0PccwIZ/8nYisVhhBUcsniTIkkJScc+o3w5
         qO9FfQF+sgkj6wrZfJkGxekqC+e1L695nyJPv/sk2+RWXa5196g+DlNTR/UJSBAbSf2Z
         n3q3i3n69bnqXLxdWbyzTr/3EE15BA0crpA5GMqKZsA16wsppMsFE4RtxSh30TSF04Ys
         UEE8TZuPlQukpqD7o0sgAysQ65mXCet2HwxzyRF7RPmmtZzXoF6zC2vWaf11Lo3Ya8bJ
         Fs2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kir9kI70OwVh4537TiH5wl8iuSbkpWMjHOA2BO/ND5k=;
        b=xheKH+vyDCz0u6J2qEDoTgQmknWB8wQ4CBlFZncPSZJaddCUmtEIC+FWlNUREZLGxf
         +Iir4DDHYAShkbRIpKKsMXHggQAIhEIzmYTHa4E350SbgTyUx93kLdY7/ljiwUzpMlEr
         ior1KTSSTuSLKRUwJEO4kI5kUZHWqkcomjkOFTHpknWmQY0n0ueC6tRAV09kIAqBdETE
         X0qBpXp6S9e3FUPKu2uKXeVG2q5Ck329mKpk4cc+dqj0nogIum5K1oFSy65671fX2irt
         wNKmTgCHcx2HGk68lIVUK33n+vCPZIavpih8By9MctV3PbDX184X7JOD6L7VcsuRpKIh
         sENQ==
X-Gm-Message-State: AO0yUKVI/TrzOaJ+Z2ErFJdOP5aw/V7HMceVzb5/a0DSZDQEheIDhze8
        eAGglcOZ7xTIDcDiP0TbLKU=
X-Google-Smtp-Source: AK7set+XpckXC5WQLDxtS4BgGrLb+Xs0kyQsFLAQqOt3QndF8NQLy5QwJTjIZvnxmTae4uUBm4Lf5w==
X-Received: by 2002:a05:600c:16d4:b0:3e0:fad:675a with SMTP id l20-20020a05600c16d400b003e00fad675amr17847944wmn.38.1676286242856;
        Mon, 13 Feb 2023 03:04:02 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id i20-20020a1c5414000000b003dc53217e07sm13895822wmb.16.2023.02.13.03.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 03:04:02 -0800 (PST)
Date:   Mon, 13 Feb 2023 14:03:58 +0300
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
        Lars Povlsen <lars.povlsen@microchip.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH net-next 10/10] net: microchip: sparx5: Add TC vlan
 action support for the ES0 VCAP
Message-ID: <Y+oZHpMpW6ODQQpY@kadam>
References: <20230213092426.1331379-1-steen.hegelund@microchip.com>
 <20230213092426.1331379-11-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230213092426.1331379-11-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 13, 2023 at 10:24:26AM +0100, Steen Hegelund wrote:
> +static int sparx5_tc_action_vlan_modify(struct vcap_admin *admin,
> +					struct vcap_rule *vrule,
> +					struct flow_cls_offload *fco,
> +					struct flow_action_entry *act,
> +					u16 tpid)
> +{
> +	int err = 0;
> +
> +	switch (admin->vtype) {
> +	case VCAP_TYPE_ES0:
> +		err = vcap_rule_add_action_u32(vrule,
> +					       VCAP_AF_PUSH_OUTER_TAG,
> +					       SPX5_OTAG_TAG_A);

This err assignment is never used.

> +		break;
> +	default:
> +		NL_SET_ERR_MSG_MOD(fco->common.extack,
> +				   "VLAN modify action not supported in this VCAP");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	switch (tpid) {
> +	case ETH_P_8021Q:
> +		err = vcap_rule_add_action_u32(vrule,
> +					       VCAP_AF_TAG_A_TPID_SEL,
> +					       SPX5_TPID_A_8100);
> +		break;
> +	case ETH_P_8021AD:
> +		err = vcap_rule_add_action_u32(vrule,
> +					       VCAP_AF_TAG_A_TPID_SEL,
> +					       SPX5_TPID_A_88A8);
> +		break;
> +	default:
> +		NL_SET_ERR_MSG_MOD(fco->common.extack,
> +				   "Invalid vlan proto");
> +		err = -EINVAL;
> +	}
> +	if (err)
> +		return err;
> +
> +	err = vcap_rule_add_action_u32(vrule,
> +				       VCAP_AF_TAG_A_VID_SEL,
> +				       SPX5_VID_A_VAL);
> +	if (err)
> +		return err;

regards,
dan carpenter

