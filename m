Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D90D7687CC6
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbjBBL6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbjBBL6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:58:14 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04E281B1C
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 03:58:12 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id lu11so5289188ejb.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 03:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XHd03EaZP6DjW/8NNdgr4Jpr+0g1ZBXkZZQEezfnDiM=;
        b=FHI0qLU2H0Nh4ZnYbAXdqsjfqdk/ZMXdKOzf9f4Mvy1f3Q1soCbf6HNJAtgRuR3GWQ
         0Q+EgSyeiyfK+MOpLv7ePcP979MjyOiBGxUSIjId91h0MGVfApnlIALqipSmwMt1E21S
         uM0bDZCE4klYeDCekkPn1imCWtrqL7XGSGGHXDOT9RIh4sBhkXhzGm1v76gQwGYewMtP
         43EiiWkcx8yavTOatq9LCSRKM/BCJnhFBI4JfE3n3nLcyGe9pJSbvGCydlKqAbVtpmvf
         ThQgw21p7kFcep9STa5LMgbvrsVCiXXr80ml/0JAga3NBchV4W8UaF2eN4a29icvUFNQ
         eY8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XHd03EaZP6DjW/8NNdgr4Jpr+0g1ZBXkZZQEezfnDiM=;
        b=MziTKWlyUx49C4TrhoMyiRG6r1oqXr57VHdCrWqIrBhys5SJAi36A/Lqos3r2RuXCV
         9no/G7v7Bf/r+e+ELP7761Q3ov1/Vu4ZHzvz1a0eh/vGGiOOU4FA1LyCV5+lhSsjwiok
         2J10P+s7ln0t2Gb/2Uz5KNleYjls9bQsue0HJEk3t2oxrk6yhMrdxB2RaGPXDcd0v0dH
         wNxK+QPMyNyVtOxv8AQAX/Irel+OiNFxEcVFBgcJ33LbkgQjIocNCMS/OaYTY0SbEPYp
         cQ0fn1O6er9Y1uZTxvOx5xjUS/vE/PmQYl6izTZKczmh8oKOD8moauxdhh/IW0wiOr9B
         8jIw==
X-Gm-Message-State: AO0yUKWiijIgtfqdZSfmxjMnca7ilzXgLUf2T20s4RSz6g8H3/MfP9zH
        cb0V7fUASSlh7SZ+kvt61DK5Zg==
X-Google-Smtp-Source: AK7set+xYDvbozCI3Jbj6PipoF6DflbvjVUURUAT2U4ROXGrbWbvMXaUlZ8fiI8/aQwWtHNP6+MxIw==
X-Received: by 2002:a17:907:d87:b0:888:db6b:5fa9 with SMTP id go7-20020a1709070d8700b00888db6b5fa9mr7127075ejc.67.1675339091235;
        Thu, 02 Feb 2023 03:58:11 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id g9-20020a170906394900b00872a726783dsm11449071eje.217.2023.02.02.03.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Feb 2023 03:58:10 -0800 (PST)
Date:   Thu, 2 Feb 2023 12:58:09 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     alejandro.lucero-palau@amd.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
Subject: Re: [PATCH v5 net-next 2/8] sfc: add devlink info support for ef100
Message-ID: <Y9ulUQyScL3xUDKZ@nanopsycho>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202111423.56831-3-alejandro.lucero-palau@amd.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Feb 02, 2023 at 12:14:17PM CET, alejandro.lucero-palau@amd.com wrote:
>From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
>
>Support for devlink info command.

You are quite brief for couple hundred line patch. Care to shed some
more details for the reader? Also, use imperative mood (applies to the
rest of the pathes)

[...]


>+static int efx_devlink_info_get(struct devlink *devlink,
>+				struct devlink_info_req *req,
>+				struct netlink_ext_ack *extack)
>+{
>+	struct efx_devlink *devlink_private = devlink_priv(devlink);
>+	struct efx_nic *efx = devlink_private->efx;
>+	char msg[NETLINK_MAX_FMTMSG_LEN];
>+	int errors_reported = 0;
>+	int rc;
>+
>+	/* Several different MCDI commands are used. We report first error
>+	 * through extack along with total number of errors. Specific error
>+	 * information via system messages.
>+	 */
>+	rc = efx_devlink_info_board_cfg(efx, req);
>+	if (rc) {
>+		sprintf(msg, "Getting board info failed");
>+		errors_reported++;
>+	}
>+	rc = efx_devlink_info_stored_versions(efx, req);
>+	if (rc) {
>+		if (!errors_reported)
>+			sprintf(msg, "Getting stored versions failed");
>+		errors_reported += rc;
>+	}
>+	rc = efx_devlink_info_running_versions(efx, req);
>+	if (rc) {
>+		if (!errors_reported)
>+			sprintf(msg, "Getting board info failed");
>+		errors_reported++;


Under which circumstances any of the errors above happen? Is it a common
thing? Or is it result of some fatal event?

You treat it like it is quite common, which seems very odd to me.
If they are rare, just return error right away to the caller.



>+	}
>+
>+	if (errors_reported)
>+		NL_SET_ERR_MSG_FMT(extack,
>+				   "%s. %d total errors. Check system messages",
>+				   msg, errors_reported);
>+	return 0;
>+}
>+
> static const struct devlink_ops sfc_devlink_ops = {
>+	.info_get			= efx_devlink_info_get,
> };

[...]
