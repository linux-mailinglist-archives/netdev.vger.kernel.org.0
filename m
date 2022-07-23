Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242EB57F068
	for <lists+netdev@lfdr.de>; Sat, 23 Jul 2022 18:16:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233661AbiGWQQJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jul 2022 12:16:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiGWQQI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jul 2022 12:16:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CC4D26C0;
        Sat, 23 Jul 2022 09:16:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA14CB80D11;
        Sat, 23 Jul 2022 16:16:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AEBC341C0;
        Sat, 23 Jul 2022 16:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658592962;
        bh=5MOxEYpXVUBFaJ0FpfgHvTDZGmLFTcWpraTlxekql4k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=frsc0R1pS19ocHwvrxmsJeY4nl3B956wc+jcCj7pRc/ivbynk/22F68FxBP2jcx0q
         gNHaQs4kF28x9rRebcrZnawx/BwJ6yQNAOqoNMrtl5NluUFytfGWnO3YEZl1V1FYEp
         O9894eFoeAK7AkjjlmqG7NQFitNaIr7YtWVjxopn7hslSkfwM3CxxEfGf3nlCPcUIB
         +8ulNT2/WU9tqKBp1bTlFd1SXnqCZcOeX9dUIg5MPh4ACt4J4N+WLNOqQTXjehbMWL
         wygJnB7Vet8gNtssjy/G1zNSu0RdJWgsnH/HNwG7g7tRDWlvnpYdZ6Efim9dCFLWOi
         9t3KNrEBdOC8A==
Date:   Sat, 23 Jul 2022 09:16:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        dsahern@kernel.org, stephen@networkplumber.org,
        edumazet@google.com, pabeni@redhat.com, ast@kernel.org,
        leon@kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
Subject: Re: [PATCH net-next v6 1/2] devlink: introduce framework for
 selftests
Message-ID: <20220723091600.1277e903@kernel.org>
In-Reply-To: <20220723042206.8104-2-vikas.gupta@broadcom.com>
References: <20220723042206.8104-1-vikas.gupta@broadcom.com>
        <20220723042206.8104-2-vikas.gupta@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,UPPERCASE_50_75 autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Jul 2022 09:52:05 +0530 Vikas Gupta wrote:
> +enum devlink_attr_selftest_test_id {
> +	DEVLINK_ATTR_SELFTEST_TEST_ID_UNSPEC,
> +	DEVLINK_ATTR_SELFTEST_TEST_ID_FLASH,	/* flag */
> +
> +	__DEVLINK_ATTR_SELFTEST_TEST_ID_MAX,
> +	DEVLINK_ATTR_SELFTEST_TEST_ID_MAX = __DEVLINK_ATTR_SELFTEST_TEST_ID_MAX - 1
> +};
> +
> +enum devlink_selftest_test_status {
> +	DEVLINK_SELFTEST_TEST_STATUS_SKIP,
> +	DEVLINK_SELFTEST_TEST_STATUS_PASS,
> +	DEVLINK_SELFTEST_TEST_STATUS_FAIL
> +};
> +
> +enum devlink_attr_selftest_result {
> +	DEVLINK_ATTR_SELFTEST_RESULT_UNSPEC,
> +	DEVLINK_ATTR_SELFTEST_RESULT,			/* nested */
> +	DEVLINK_ATTR_SELFTEST_RESULT_TEST_ID,		/* u32,
> +							 * enum devlink_attr_selftest_test_id
> +							 */
> +	DEVLINK_ATTR_SELFTEST_RESULT_TEST_STATUS,	/* u8,
> +							 * enum devlink_selftest_test_status
> +							 */
> +
> +	__DEVLINK_ATTR_SELFTEST_RESULT_MAX,
> +	DEVLINK_ATTR_SELFTEST_RESULT_MAX = __DEVLINK_ATTR_SELFTEST_RESULT_MAX - 1

Any thoughts on running:

	sed -i '/_SELFTEST/ {s/_TEST_/_/g}' $patch

on this patch? For example DEVLINK_ATTR_SELFTEST_RESULT_TEST_STATUS
is 40 characters long, ain't nobody typing that, and _TEST is repeated..

Otherwise LGTM!
