Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86F3667B8C1
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 18:40:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235330AbjAYRkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 12:40:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235770AbjAYRkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 12:40:55 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFD732E44
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 09:40:52 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id mg12so49692340ejc.5
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 09:40:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pdVruo7IIvbP8PpvibgbDKpFvjLVIXU0r1szkEaElIg=;
        b=vNnuIPeMqS//lF8crqvYSOI84j6hDftvNKvF9OEHExj8R8F9r5WrUDXqNVsjpFaG6M
         POeb89J5MCHk83wGeSH1+ELjEgZ4rUw5xldQ1ZfuENUlspssrlP0FseUcp8/h61DsQI2
         kDvLAPhcmMdkQOu7mP5U0wDTRQ5r8XfU/B53dslA5LPx9Zt73sJlnl1/hPoQcKQM3tU/
         FFmKBoB1mo3Jyg+wAbedd+5957x3fbjXu0015WgwLfDGmVM6fd4z6MVghDnoB1m+F1Ky
         omvYL5Cn0/Ivu2uZTGqSTWxLYdjmymbjnvFPAs1KFgA8JRLEL+xgnkgno6tbW++kqLuB
         zrTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pdVruo7IIvbP8PpvibgbDKpFvjLVIXU0r1szkEaElIg=;
        b=kLIw8tzrN2aH5JLU5Mzpn7Mio/fj/nj7K47sgvM/9UcqB97JKAldnGGBkcteZgwtC8
         ZLhUDuQYJhThWo5TppdNaMKVa2m56rqWlRsDi0SDcbpR88LEeQ5SB8T9ecuXdO+9aIxM
         Bg95R2mE3n0gd8buaiLuBBHwgKLJBaACbq3n6Wk1YlGbRu4+e3EIZmZOtWkVyucWXlIh
         Y3bcfiBid56vxz9jIGJqXY3OIfB4iVd0nLKZs0d62LltgSvvMUAAjilXemzuehMGhm7y
         CYoj3cta5/uLs024bqJSDMeCsIngZetl6ge+4YNWgQMzu6Ji+3BKx+gmF+smEzZnkwo8
         t6wg==
X-Gm-Message-State: AO0yUKXrGVAPtZzik63S5YUrojr9T7hRmY7iQF7Ir3FyUpNt2qa7HzPL
        oIl6LbHjt0F/E3KguKHd62alz5iaHjWV9FszM5rxGg==
X-Google-Smtp-Source: AK7set/iuWjky8LxRU6VhsMOe8FfLaVgcc5kvcRVkHEbTAskkI4WbBytp85ZT1eJdOCKjCSibSW+LQ==
X-Received: by 2002:a17:906:fb09:b0:878:4bda:200e with SMTP id lz9-20020a170906fb0900b008784bda200emr901263ejb.4.1674668451445;
        Wed, 25 Jan 2023 09:40:51 -0800 (PST)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id my7-20020a1709065a4700b0084d242d07ffsm2660247ejc.8.2023.01.25.09.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jan 2023 09:40:50 -0800 (PST)
Date:   Wed, 25 Jan 2023 18:40:49 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, michael.chan@broadcom.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        idosch@nvidia.com, petrm@nvidia.com, simon.horman@corigine.com,
        aelior@marvell.com, manishc@marvell.com, jacob.e.keller@intel.com,
        gal@nvidia.com, yinjun.zhang@corigine.com, fei.qin@corigine.com,
        Niklas.Cassel@wdc.com
Subject: Re: [patch net-next 12/12] net/mlx5: Move eswitch port metadata
 devlink param to flow eswitch code
Message-ID: <Y9FpoXAvh+/WfmYp@nanopsycho>
References: <20230125141412.1592256-1-jiri@resnulli.us>
 <20230125141412.1592256-13-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230125141412.1592256-13-jiri@resnulli.us>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jan 25, 2023 at 03:14:12PM CET, jiri@resnulli.us wrote:
>From: Jiri Pirko <jiri@nvidia.com>

[..]

>+static int esw_port_metadata_set(struct devlink *devlink, u32 id,
>+				 struct devlink_param_gset_ctx *ctx)
>+{
>+	struct mlx5_core_dev *dev = devlink_priv(devlink);
>+	struct mlx5_eswitch *esw = dev->priv.eswitch;
>+	int err;

CI reported uninitializer var here, will fix in v2.


