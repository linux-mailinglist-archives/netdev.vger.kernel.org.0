Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D83B63E9F6
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 07:43:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiLAGnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 01:43:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiLAGng (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 01:43:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4177A4D5DF
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 22:43:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED089B81DA5
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 06:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F72C433D6;
        Thu,  1 Dec 2022 06:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669877012;
        bh=J6uv1cJor5p/4bsj8dWeI8pk2koOeoBMbp7ykGHmLqo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FUxwe6JXtIkJHEZgFbDLrg2oxit+lGWsLBppa81tjrBzt8aMsoizi8nOIjahF4SA6
         cOyCOOr0GI2nUVt6EYlwu1aZm/j0fJC/dYO24GeAYMhCxOY0/BAAWEy9nWh0/CyoCU
         ZT8THtuqP5MrJul+xn6IKS39glct92A9PTyK+iAnvJ7wVCvs/2bNKeimtUIJQuCXTH
         mw+4j/cwkkfUU9f4FSYGatGsbup1mjJIMMIk8R20HJwQxtNgWU/G/BIgd22aCrZMU/
         8+e4Xrvt/Dul22dKZnHsh5K1iIoalQfEp9ErYJ2ynw9YnusaHTvs8kHzjqLY0/InwJ
         2dHqii+agmmBg==
Message-ID: <0642f8ab-63be-7db2-bd7c-16f19a3bdddc@kernel.org>
Date:   Wed, 30 Nov 2022 23:43:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH iproute2-next v2 1/2] dcb: add new pcp-prio parameter to
 dcb app
Content-Language: en-US
To:     Daniel Machon <daniel.machon@microchip.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, petrm@nvidia.com,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        UNGLinuxDriver@microchip.com
References: <20221128123817.2031745-1-daniel.machon@microchip.com>
 <20221128123817.2031745-2-daniel.machon@microchip.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221128123817.2031745-2-daniel.machon@microchip.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/28/22 5:38 AM, Daniel Machon wrote:
> @@ -344,6 +420,17 @@ static int dcb_app_print_key_dscp(__u16 protocol)
>  	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
>  }
>  
> +static int dcb_app_print_key_pcp(__u16 protocol)
> +{
> +	/* Print in numerical form, if protocol value is out-of-range */
> +	if (protocol > 15) {

15 is used in a number of places in this patch. What's the significance
and can you give it a name that identifies the meaning? i.e., protocol
is a u16 why the 15 limit? (and update all places accordingly)
