Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C99622B21
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 13:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbiKIMKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 07:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKIMK3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 07:10:29 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C479210FF9
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 04:10:28 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id o30so10671853wms.2
        for <netdev@vger.kernel.org>; Wed, 09 Nov 2022 04:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q9GOCVhOLB+3rc02ByE/WqFu2iPOZzk7sAE/w5l2008=;
        b=IKK0pEDTNWu4FCoRE5GhJ+4V2K5Ft9/sAOC5iN5RKXnY6ilYlKXgAA1WeAQmfAbxzR
         IUbRfPbJA+5yUQF3nHZYOXU1BCU87j/m3+7vNhE4POQ2kOpztCIqVJF8Xf4qQ1rvNU0b
         7aazToMi5rSADP8+BhjEpy4I6ZSxqM9UWlmfOpRzRlz0/KTn9GYyV8GnRszBaO5EmUTT
         hUzkS2bej3CqQWCod7kydA5Wqdo99nYwJuSFaqVxIU4KW6zGPQIsEl9xmxXJ3VycU6QV
         Vlom8O3KVpISujHAn4C9EF2xnXiM+RFCgxSwR7MRGpz47TUs19t2C+O+lzXn7Qx0D1q1
         KYAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q9GOCVhOLB+3rc02ByE/WqFu2iPOZzk7sAE/w5l2008=;
        b=EUVMWtCVo9TEB/p1iUoiSjckjYmqyLgFMaOoUKxhOmMH/l3H8LBRuulI21FpsuAQRV
         y+WMyCq4cjJj4fIToY8V2Pl0vcCHfIQaemdjZvl1a6pjE7/KfWzpRIU9tczwL/2oRBTW
         LInNBH+UrsH71wFvu8F+ZhO+JN/JtFGV057+mOI257YCWHltO4QbJyUQ5qfvMJ6UPLqs
         4GZSTbTB4JgffGwzUG+vHsAY7dxT0T5k7heBLinX2wqcoXoKJeUQ4z0Tlm4iAggnAKff
         MH5q3c7RMuEjOQ/6VgZp+HnmNmWAvXLFR38+ZVqtz/S6CFCxOqg1ND7zAZBtEaFnN+1J
         0oSQ==
X-Gm-Message-State: ACrzQf2gtqX81TlpiEG/nHvQMg6FaRg0zLSZDNNUndhGImlAEuSzdwlD
        V7dA3fQAVluNW9ytBT/GStLE0ksbYi9GNR8s
X-Google-Smtp-Source: AMsMyM7IfHAzRbuXkbn9vzS2naN+R1j66WvcRbyj31HndJBXvVdi78KvFyYE2r6+3hVG0vq35O48sw==
X-Received: by 2002:a7b:c8c5:0:b0:3cf:634f:53a9 with SMTP id f5-20020a7bc8c5000000b003cf634f53a9mr40920995wml.82.1667995827369;
        Wed, 09 Nov 2022 04:10:27 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id s13-20020a5d69cd000000b0023659925b2asm12851937wrw.51.2022.11.09.04.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Nov 2022 04:10:26 -0800 (PST)
Date:   Wed, 9 Nov 2022 13:10:25 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     dsahern@gmail.com, kuba@kernel.org, moshe@nvidia.com,
        saeedm@nvidia.com
Subject: Re: [patch iproute2-next 2/2] devlink: get devlink port for ifname
 using RTNL get link command
Message-ID: <Y2uYsdwTf9NgzEfD@nanopsycho>
References: <20221107165348.916092-1-jiri@resnulli.us>
 <20221107165348.916092-3-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107165348.916092-3-jiri@resnulli.us>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 07, 2022 at 05:53:48PM CET, jiri@resnulli.us wrote:
>@@ -838,11 +915,18 @@ static void ifname_map_init(struct dl *dl)
> 	INIT_LIST_HEAD(&dl->ifname_map_list);
> }
> 
>-static int ifname_map_load(struct dl *dl)
>+static int ifname_map_load(struct dl *dl, const char *ifname)
> {
> 	struct nlmsghdr *nlh;
> 	int err;
> 
>+	err = ifname_map_rtnl_init(dl, ifname);

Ah, I found a bug and the fix for it conflicts with this hunk. Please
drop this, I will send the bugfix first and then will send this again,
rebased.

Sorry for the mess!
