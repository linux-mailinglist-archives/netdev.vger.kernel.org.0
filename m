Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEAFA4D8DDD
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 21:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbiCNUJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 16:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiCNUJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 16:09:40 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E3D12610
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 13:08:30 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id t5so15893599pfg.4
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 13:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZfM/ShDuHFahKd1TMYL+g26NCZ1P3CYuyCVYj8j4umk=;
        b=BewI5Z5/5HBeeFiJtAE7bzyh7Uru+orfUCWAueTsdyXHFKhsr1hidNBctmDNNRcQtD
         XF2RFa/+a9FmBiXhgLNGif01rAd8lqFenqzI4kBCKihAjblAGphJ82p+DulZf6Ax+Qww
         snxnhJSe2M1eThYga5GOfdk1Vy2c8dbFUhvR8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZfM/ShDuHFahKd1TMYL+g26NCZ1P3CYuyCVYj8j4umk=;
        b=UDvbR+5amW+ArruYfLAcKCddRQJVYTsrAG6kc4wF2mXyjRuTW2VG0rgfc3U1eeuuGl
         w+7YrTpXyVReAkNS91vz3x2Uplo0jQ9c9W5540rK41nTss/T/E4/eJR2BjIEmmuovim/
         1mtQps7P53Wc1dVTYOewGkwSPkiOU85SmBDLEFIlxeL4AkY+7ldR/0dqNrize9IwWHKz
         8+7Iit7z2HFVCXHzu9R/xPHmfRGCDGa1oDKbWNADXhOsA3p0sNkpXarW+JfItrIYUJk4
         0Do97VCHQhR+o9p6lyXtSZyhi1g+yQfIWAeQkPfUQHo5/8zC241PRdj1UsgJUiPr96/n
         WjrA==
X-Gm-Message-State: AOAM5325hBastRiEEnmTZejhzMw1VV+fGi5iJBqSga/pSPnHNABr0B9T
        xKj9JTtnrg2/b1iZsxhwrmn1yg==
X-Google-Smtp-Source: ABdhPJydBcsqQZokhgVGzVxs6oLw3laHl61H1FuYj1OJ7PIsHEQhXXwWI3+PGDbjpjwrE7191XpkBQ==
X-Received: by 2002:a05:6a00:2314:b0:4f7:a347:cf68 with SMTP id h20-20020a056a00231400b004f7a347cf68mr14025642pfh.63.1647288509496;
        Mon, 14 Mar 2022 13:08:29 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id o5-20020a655bc5000000b00372f7ecfcecsm17317271pgr.37.2022.03.14.13.08.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Mar 2022 13:08:29 -0700 (PDT)
Date:   Mon, 14 Mar 2022 13:08:26 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net-next] net/mlx5e: Fix use-after-free in
 mlx5e_stats_grp_sw_update_stats
Message-ID: <20220314200825.GA28535@fastly.com>
References: <20220312005353.786255-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312005353.786255-1-saeed@kernel.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 11, 2022 at 04:53:53PM -0800, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> We need to sync page pool stats only for active channels. Reading ethtool
> stats on a down netdev or a netdev with modified number of channels will
> result in a user-after-free, trying to access page pools that are freed
> already.
> 
> BUG: KASAN: use-after-free in mlx5e_stats_grp_sw_update_stats+0x465/0xf80
> Read of size 8 at addr ffff888004835e40 by task ethtool/720
> 
> Fixes: cc10e84b2ec3 ("mlx5: add support for page_pool_get_stats")
> Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> Reported-by: Jakub Kicinski <kuba@kernel.org>

Err, sorry about that folks - my bad. Thanks for catching that Jakub and
sorry for the trouble Saeed.

LGTM.

Acked-by: Joe Damato <jdamato@fastly.com>
