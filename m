Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8196E6E7FC5
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 18:40:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbjDSQj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 12:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233726AbjDSQjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 12:39:54 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 699FF524B
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 09:39:51 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id dm2so83487335ejc.8
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 09:39:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20221208; t=1681922390; x=1684514390;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9ZxCCiYUortrBPkS8K+ay9w2Dz5EgHqGu/fU9eXq2bs=;
        b=hn3PyPDjXeW74Ohnax9U7gTCwIzmtYBbs6XhfJGdH25atEqx60GIm50Y4L+0XzCr5h
         +k7hGc7GuOL/aJ5ty5B5heIxeHEnZ/UWM4rQ2Zr8YSGHcwVfP3B8gD3ZbVuNxxo+Uv6u
         ubLYiHMOaPZSQEL3v+xp1j7b9If4vkjbsm2EuWNYpXsdoYzlAsM76ajnwUd7UgvUD9MC
         Om37AWwz6kmtIjBKYKPbwMb62hXRslYYr/eDs0AkiuA0dSE0INwk3Of67ZMmj5H5vLaE
         jphKiUkggIAJCoT5bkYgkzqwEtrznV0nbrAIK4X9R9Kw0R/tE+S0+E17WSGYlkgcK9bF
         hBqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681922390; x=1684514390;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ZxCCiYUortrBPkS8K+ay9w2Dz5EgHqGu/fU9eXq2bs=;
        b=YXORjE1EkKpNus+ZNOsxLf3xERJG+3IIh9zaDkqnoV8timXS/1e3mCdBlvPdXCQWnd
         4ddgCtf7spQTnoQT1jjbrqIoQb6pJM0S4SefXghC1JSjEhH8+2ir4EJVRpYBgNMK6t6G
         ew0klL4TlsmO+1kgVICLin8e9EKOVa4T9/ZSUgcLs/3toWXQ9FhUVfcVsutuoM38zPbK
         7o8cI9GB4NjKDZjUh+gjpdQd9khlbZ96kP/E+CEifEsb0S9sMzTa11wJilTlEokAfKaO
         GOoUbN5YPrnTzYnCH8sBiXKpIFSFXNGRdTTl7ccmn1Qps38GY04CBEkYzcDO4tiOuthq
         hDhw==
X-Gm-Message-State: AAQBX9c7GXPEE9oW1trLSNlcdLJYHJxtWBvti93DE2E3cMK6BAQ9E4l2
        oIA4kxifyu0CvKO1VccfLt8=
X-Google-Smtp-Source: AKy350azDmYSm5q2h6Xi2t4ku8jRJp4gs6G5xhBLK6OE62DNj6/IWcS2dw0knznw72819hSRbaMeag==
X-Received: by 2002:a17:906:e12:b0:94a:74c9:3611 with SMTP id l18-20020a1709060e1200b0094a74c93611mr17777493eji.35.1681922389783;
        Wed, 19 Apr 2023 09:39:49 -0700 (PDT)
Received: from tycho (p200300c1c74c0400ba8584fffebf2b17.dip0.t-ipconnect.de. [2003:c1:c74c:400:ba85:84ff:febf:2b17])
        by smtp.gmail.com with ESMTPSA id m24-20020a1709060d9800b0094eeab34ad5sm7683499eji.124.2023.04.19.09.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:39:49 -0700 (PDT)
Sender: Zahari Doychev <zahari.doychev@googlemail.com>
Date:   Wed, 19 Apr 2023 18:39:47 +0200
From:   Zahari Doychev <zahari.doychev@linux.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, hmehrtens@maxlinear.com,
        aleksander.lobakin@intel.com, simon.horman@corigine.com,
        Zahari Doychev <zdoychev@maxlinear.com>
Subject: Re: [PATCH net-next v3 2/3] net: flower: add support for matching
 cfm fields
Message-ID: <qgobhbt3abx5o5js6czejn2hiol7lfkyfyhptghexpkm2f2me7@xzzjtzpipy6p>
References: <20230417213233.525380-1-zahari.doychev@linux.com>
 <20230417213233.525380-3-zahari.doychev@linux.com>
 <ZEAG2aW78qbGHj//@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEAG2aW78qbGHj//@shredder>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 19, 2023 at 06:20:57PM +0300, Ido Schimmel wrote:
> On Mon, Apr 17, 2023 at 11:32:32PM +0200, Zahari Doychev wrote:
> > +static const struct nla_policy cfm_opt_policy[TCA_FLOWER_KEY_CFM_OPT_MAX] = {
> > +	[TCA_FLOWER_KEY_CFM_MD_LEVEL]		= { .type = NLA_U8 },
> > +	[TCA_FLOWER_KEY_CFM_OPCODE]		= { .type = NLA_U8 },
> > +};
> 
> [...]
> 
> > +static int fl_set_key_cfm_md_level(struct nlattr **tb,
> > +				   struct fl_flow_key *key,
> > +				   struct fl_flow_key *mask,
> > +				   struct netlink_ext_ack *extack)
> > +{
> > +	u8 level;
> > +
> > +	if (!tb[TCA_FLOWER_KEY_CFM_MD_LEVEL])
> > +		return 0;
> > +
> > +	level = nla_get_u8(tb[TCA_FLOWER_KEY_CFM_MD_LEVEL]);
> > +	if (level & ~FIELD_MAX(FLOW_DIS_CFM_MDL_MASK)) {
> > +		NL_SET_ERR_MSG_ATTR(extack, tb[TCA_FLOWER_KEY_CFM_MD_LEVEL],
> > +				    "cfm md level must be in [0, 7]");
> > +		return -EINVAL;
> > +	}
> 
> You should be able to replace this with NLA_POLICY_MAX()

ok, I will change it in the next version.

thanks
Zahari

> 
> > +
> > +	key->cfm.mdl_ver = FIELD_PREP(FLOW_DIS_CFM_MDL_MASK, level);
> > +	mask->cfm.mdl_ver = FLOW_DIS_CFM_MDL_MASK;
> > +
> > +	return 0;
> > +}
