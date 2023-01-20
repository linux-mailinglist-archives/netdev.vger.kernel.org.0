Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E644675057
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbjATJM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:12:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjATJMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:12:25 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39EB48B749;
        Fri, 20 Jan 2023 01:11:49 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id iv8-20020a05600c548800b003db04a0a46bso790796wmb.0;
        Fri, 20 Jan 2023 01:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=W/9HYZJv5LKapOcMACURG3HHx3Aj77kiqHirfoKY1tQ=;
        b=H8BpBACFih31vDUTJOXQz2V3tXzvi+Fj9WHWF92Q4dAYazRUovAKMk77//92Lipw3n
         QWroRwl/Iqsyqtd0JXY4zR0m+4R9bF//845mJ0uluiBn8GL8Ql+MIK8WHuocf6KD1Aan
         kNjKOC69QkzL4Ud64hRh517upqCxb8gq1hwpT4Coud/eIW+7IBFa+RZioXGtXJNEAcVw
         SGW/gkyZ2KKn8uq0ulkZWsmX+BBpuq4ttr+fQGk9ccI9mZtsnvG9lRkFu/OSMhfXOA1/
         dzk5QaqSEK9UweD0jkm2aghhSVuni28klaJSR8sQPSEGBsTUFVadzoZcVd/6IRZKgohg
         8+Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W/9HYZJv5LKapOcMACURG3HHx3Aj77kiqHirfoKY1tQ=;
        b=t0qo5uHMuQlwmnVxtYHnmwk7BOex8Fp7b9DupMvzTVQ4EXgXPJh0XlcRQZRct3/DYp
         CCOaGFIUfVkcgzjQjMd/ggbDuDWtz7UJgXzDSr1Q6aUIcKW0In1KZvyWfnj3fHyDEWCq
         Icn+jotM9a9sjsqv3Q7KM+N88B0WvL9/UyEQQxp+oGiLNuxp8H6Fn7HCfl3NmNL6Bi4r
         wADivtCsq0jsEV0A7F68cVcU/SKB5EzdEqlxeXhJ6InUxBrau6XS0Fd+9q5lxmRECVRc
         9AT3da74hBoEhtfPY0D5cJwo5jvz8ZgTjpsCcuuLlpu4TIVBqnikfKSSwyvIK/ptbZbZ
         2x+w==
X-Gm-Message-State: AFqh2kryGKpp+ggehUevoid0MURfmYsNQdrkRYs9er7/1P5LA+ajrbqj
        nYgTB5CkZIe/rmsB2Q8FWbk=
X-Google-Smtp-Source: AMrXdXv/kcdR2C2yGPspYuFWdJY4W96/xbaMPLOri/IXx4P1YPTbKHKSLi5m0BSKHMTKyAqss7DbRQ==
X-Received: by 2002:a05:600c:5d1:b0:3d0:761b:f86 with SMTP id p17-20020a05600c05d100b003d0761b0f86mr13436702wmd.28.1674205893227;
        Fri, 20 Jan 2023 01:11:33 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id z2-20020a05600c220200b003db305bece4sm1264548wml.45.2023.01.20.01.11.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 01:11:32 -0800 (PST)
Date:   Fri, 20 Jan 2023 12:11:29 +0300
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
Subject: Re: [PATCH net-next 3/8] net: microchip: sparx5: Add actionset type
 id information to rule
Message-ID: <Y8pawZOGjsfStC6n@kadam>
References: <20230120090831.20032-1-steen.hegelund@microchip.com>
 <20230120090831.20032-4-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230120090831.20032-4-steen.hegelund@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 20, 2023 at 10:08:26AM +0100, Steen Hegelund wrote:
> +/* Add the actionset typefield to the list of rule actionfields */
> +static int vcap_add_type_actionfield(struct vcap_rule *rule)
> +{
> +	enum vcap_actionfield_set actionset = rule->actionset;
> +	struct vcap_rule_internal *ri = to_intrule(rule);
> +	enum vcap_type vt = ri->admin->vtype;
> +	const struct vcap_field *fields;
> +	const struct vcap_set *aset;
> +	int ret = -EINVAL;
> +
> +	aset = vcap_actionfieldset(ri->vctrl, vt, actionset);
> +	if (!aset)
> +		return ret;
> +	if (aset->type_id == (u8)-1)  /* No type field is needed */
> +		return 0;
> +
> +	fields = vcap_actionfields(ri->vctrl, vt, actionset);
> +	if (!fields)
> +		return -EINVAL;
> +	if (fields[VCAP_AF_TYPE].width > 1) {
> +		ret = vcap_rule_add_action_u32(rule, VCAP_AF_TYPE,
> +					       aset->type_id);
> +	} else {
> +		if (aset->type_id)
> +			ret = vcap_rule_add_action_bit(rule, VCAP_AF_TYPE,
> +						       VCAP_BIT_1);
> +		else
> +			ret = vcap_rule_add_action_bit(rule, VCAP_AF_TYPE,
> +						       VCAP_BIT_0);
> +	}
> +	return 0;

return ret; ?

> +}

regards,
dan carpenter

