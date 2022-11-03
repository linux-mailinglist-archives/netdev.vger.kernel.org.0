Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8123618B17
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 23:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbiKCWE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 18:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKCWE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 18:04:26 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B03BE3C;
        Thu,  3 Nov 2022 15:04:26 -0700 (PDT)
Received: from [10.7.7.5] (unknown [182.253.183.90])
        by gnuweeb.org (Postfix) with ESMTPSA id 82B3881441;
        Thu,  3 Nov 2022 22:04:23 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1667513065;
        bh=VfzmpAbAcBU3OdTyJA75CAnErDaaFDHFlzkEa8sfAq8=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=NGHbK6DzFoS/08cefO0sLUXVL0DDBWO/HlQ6X00Rn0tBl5/pcM187Gv6WB5NI8DZ4
         nSF4eZmyOmQP1RDRGOA7wm2FmuXQYmql7SBB18Lk96GBHb+m1/nyenY0Cobcp6P6GP
         Znq1jEOCE1sZKfWRECrhwlST81co5ZUaWgIW9QtCAB6UnQ8N/K/Ew+SMFfP6j/bQWk
         pu2Cg+3Gbbr17IKiCF95kW7AaXKNh73oYqlKZGkpTPr7r0CyEH7JTf+Lo+QbHOVd8M
         E9Tr1ovd4429VqYPBcvutwEHY8ma3kBcNnizyRffT9OfQ4tcOxAtRti3XjXGhf7duA
         2SR1q5BxukFeA==
Message-ID: <d9761f0b-0a31-1ec9-66b8-371cb22250f9@gnuweeb.org>
Date:   Fri, 4 Nov 2022 05:04:16 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Stefan Roesch <shr@devkernel.io>,
        Facebook Kernel Team <kernel-team@fb.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Olivier Langlois <olivier@trillion01.com>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev Mailing List <netdev@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <20221103204017.670757-1-shr@devkernel.io>
 <20221103204017.670757-4-shr@devkernel.io>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [RFC PATCH v1 3/3] liburing: add test programs for napi busy poll
In-Reply-To: <20221103204017.670757-4-shr@devkernel.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/4/22 3:40 AM, Stefan Roesch wrote:
> +struct option longopts[] =
> +{
> +        {"address"  , 1, NULL, 'a'},
> +        {"busy"     , 0, NULL, 'b'},
> +        {"help"     , 0, NULL, 'h'},
> +        {"num_pings", 1, NULL, 'n'},
> +        {"port"     , 1, NULL, 'p'},
> +        {"sqpoll"   , 0, NULL, 's'},
> +	{"timeout"  , 1, NULL, 't'},

Inconsistent indentation.

> +	if (strlen(opt.addr) == 0) {
> +		fprintf(stderr, "address option is mandatory\n");
> +		printUsage(argv[0]);
> +		exit(-1);
> +	}
Don't use integer literal like 0 or -1 as the exit code in tests, use the
exit code protocol:

   T_EXIT_PASS
   T_EXIT_FAIL
   T_EXIT_SKIP

They are defined in test/helpers.h.

-- 
Ammar Faizi

