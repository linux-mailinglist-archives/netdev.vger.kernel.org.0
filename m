Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8173C4AC27D
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 16:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390980AbiBGPFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 10:05:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236399AbiBGOnI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 09:43:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45FFC0401C1;
        Mon,  7 Feb 2022 06:43:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8A0E6B80B44;
        Mon,  7 Feb 2022 14:43:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57271C004E1;
        Mon,  7 Feb 2022 14:43:03 +0000 (UTC)
Date:   Mon, 7 Feb 2022 09:43:01 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     menglong8.dong@gmail.com
Cc:     kuba@kernel.org, dsahern@kernel.org, idosch@idosch.org,
        nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Subject: Re: [PATCH v6 net-next] net: drop_monitor: support drop reason
Message-ID: <20220207094301.5c061d23@gandalf.local.home>
In-Reply-To: <20220205081738.565394-1-imagedong@tencent.com>
References: <20220205081738.565394-1-imagedong@tencent.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  5 Feb 2022 16:17:38 +0800
menglong8.dong@gmail.com wrote:

> --- a/net/core/drop_monitor.c
> +++ b/net/core/drop_monitor.c
> @@ -48,6 +48,16 @@
>  static int trace_state = TRACE_OFF;
>  static bool monitor_hw;
>  
> +#undef EM
> +#undef EMe
> +
> +#define EM(a, b)	[a] = #b,
> +#define EMe(a, b)	[a] = #b
> +
> +static const char *drop_reasons[SKB_DROP_REASON_MAX + 1] = {

Do you need to define the size above? Can't the compiler do it for you?

static const char *drop_reasons[] = {

-- Steve

> +	TRACE_SKB_DROP_REASON
> +};
> +
>  /* net_dm_mutex
>   *
