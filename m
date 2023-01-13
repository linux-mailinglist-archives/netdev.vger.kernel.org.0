Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484BA668EF9
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 08:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240722AbjAMHUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 02:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240731AbjAMHTm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 02:19:42 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DB1271FEB;
        Thu, 12 Jan 2023 23:04:52 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v2so9172072wrw.10;
        Thu, 12 Jan 2023 23:04:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j2qn42yyMZbo6TrbPBAsI283zrpFQp4cNY9d6GcZLKw=;
        b=QXyktMd/lr18PfK1hb1/U4RSGMQooojDNQc+LM4xgDXElkKq7ViRbTcvFJf2WzZ78x
         Pf08q2pxyvRVuyZef0hpk3oluzFsICr1X1tmd/ZqScQoHoZ+sJt0MvzdrghHN7ee2oy9
         o/CF9iGcu2V5WbsLtTsP6s6DNpkstAHBdL+d4H+8vv3WHTyTyoqSLn4LiEMXWTD9TIoC
         Dgw1AVkErFSe1uNvB7SIx9a1l0XUViDuiRJlwvLPw3eyaeBfLqBo1MEydYCQNOf/5qwn
         gR69xjrpdoKmWSlGb+ONNmU+oJJEKvHU1fnwgpevtlXvQ+LNgJsvsxP9idXKKAax/lkn
         f8JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j2qn42yyMZbo6TrbPBAsI283zrpFQp4cNY9d6GcZLKw=;
        b=ZfBQGyM2GKtU5zf29ZPYlIQaLRQM1xOZIueTxsKDxPauD6ZweEO8NP030tu6rmrK0B
         FvRJADM9CPoqAG9DYFL+Yam/1C+bXrIh9D+tqPJ1uSojInNiw1aAdlP6RgsVyQiiaM/U
         VALzqmWnhSXVfjzpTlqSHm/46jm0L7UEG8NravWQ1qC+plDGh2wnOtXHAuxsCowo+mEC
         8NFD2Y5E4SHTr/beiG+XCpA5kD3wBg1OwhAeFig4qlgFMuq4nOnEpMppmgjaal+phYLB
         AbsrLwbpcLMnmCPBLfET8PoeG2b8WKq+oFB/TbeJQNlqxMNJRIQm0Wvnf69D3FSQVeyF
         HCtA==
X-Gm-Message-State: AFqh2kp5ALVo3Ys7MD0FkLUG3NWL2nQYMLW6C46Q1xLRZM1d1J2PzsBK
        dXCnvkT0mDuHRMp2In0UThI=
X-Google-Smtp-Source: AMrXdXtWAQCQRjcANCUXbI+FBSURPUxW7KfOAQf0/PpNSd8emifmBvT7oAxVJfTDYi7Wvnp3liT9BQ==
X-Received: by 2002:a05:6000:408b:b0:242:8404:6b66 with SMTP id da11-20020a056000408b00b0024284046b66mr57175857wrb.1.1673593490619;
        Thu, 12 Jan 2023 23:04:50 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id w5-20020adfcd05000000b002bdc914a139sm5623348wrm.108.2023.01.12.23.04.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 23:04:50 -0800 (PST)
Date:   Fri, 13 Jan 2023 10:04:38 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Daniel Machon <daniel.machon@microchip.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, lars.povlsen@microchip.com,
        Steen.Hegelund@microchip.com, UNGLinuxDriver@microchip.com,
        joe@perches.com, horatiu.vultur@microchip.com,
        Julia.Lawall@inria.fr, petrm@nvidia.com, vladimir.oltean@nxp.com,
        maxime.chevallier@bootlin.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] net: dcb: add new rewrite table
Message-ID: <Y8EChkENXkUjfUQf@kadam>
References: <20230112201554.752144-1-daniel.machon@microchip.com>
 <20230112201554.752144-4-daniel.machon@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230112201554.752144-4-daniel.machon@microchip.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 12, 2023 at 09:15:51PM +0100, Daniel Machon wrote:
> +/* Get protocol value from rewrite entry. */
> +u16 dcb_getrewr(struct net_device *dev, struct dcb_app *app)
   ^^^

> +{
> +	struct dcb_app_type *itr;
> +	u8 proto = 0;

Should "proto" be a u16 to match itr->app.protocol and the return type?

> +
> +	spin_lock_bh(&dcb_lock);
> +	itr = dcb_rewr_lookup(app, dev->ifindex, -1);
> +	if (itr)
> +		proto = itr->app.protocol;
> +	spin_unlock_bh(&dcb_lock);
> +
> +	return proto;
> +}
> +EXPORT_SYMBOL(dcb_getrewr);
> +
> + /* Add rewrite entry to the rewrite list. */
> +int dcb_setrewr(struct net_device *dev, struct dcb_app *new)
> +{
> +	int err = 0;

No need to initialize this.  It only disables static checkers and
triggers a false positive about dead stores.

> +
> +	spin_lock_bh(&dcb_lock);
> +	/* Search for existing match and abort if found. */
> +	if (dcb_rewr_lookup(new, dev->ifindex, new->protocol)) {
> +		err = -EEXIST;
> +		goto out;
> +	}
> +
> +	err = dcb_app_add(&dcb_rewr_list, new, dev->ifindex);
> +out:
> +	spin_unlock_bh(&dcb_lock);
> +
> +	return err;
> +}

regards,
dan carpenter
