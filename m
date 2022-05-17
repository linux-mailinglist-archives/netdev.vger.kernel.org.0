Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DBE652AC31
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 21:45:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbiEQTpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 15:45:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiEQTpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 15:45:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9C327B07;
        Tue, 17 May 2022 12:45:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AD2DA61693;
        Tue, 17 May 2022 19:45:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67D8C34100;
        Tue, 17 May 2022 19:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652816719;
        bh=c1beyBekg5NzKpRS9WeSk2ceWZaUGUXSIyjIHLaVIo0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XqGXXVQWfnT2fPRc8+2qxE902Atqm5mk0KFCqrSahCuQpM7DCoRhEsl6tnIf/mIOK
         pOMqPWKRv8Tz/7FCpoxk2llVhXECCxDkTAxE56KgOaR1y8OV6g7kD9+zHl1b5Td4D3
         wD1PAqe2co074cWNt/JsFeh8DkSVZc+z9pvQWXPbPseSrxjPyj/TSrPL/6KJfQfEPr
         rUynEGel55G5Dy+SzmkhlZFEJA4W11ea3h/EQ4KacvHNwlaL+eoNigZ/ucIah4tLKz
         KQCa1V/8viXR2dmdvOhdHN2nW5Qnl6cSDWvTTN1r1BX/KCw2tw8rXZ3tQ9S85nibPC
         bH+rkEc0ntZHw==
Date:   Tue, 17 May 2022 12:45:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 0/2] selftests: net: add missing tests to Makefile
Message-ID: <20220517124517.363445f4@kernel.org>
In-Reply-To: <YoM/Wr6FaTzgokx3@Laptop-X1>
References: <20220428044511.227416-1-liuhangbin@gmail.com>
        <20220429175604.249bb2fb@kernel.org>
        <YoM/Wr6FaTzgokx3@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 May 2022 14:23:22 +0800 Hangbin Liu wrote:
> On Fri, Apr 29, 2022 at 05:56:04PM -0700, Jakub Kicinski wrote:
> > On Thu, 28 Apr 2022 12:45:09 +0800 Hangbin Liu wrote:  
> > > I think there need a way to notify the developer when they created a new
> > > file in selftests folder. Maybe a bot like bluez.test.bot or kernel
> > > test robot could help do that?  
> > 
> > Our netdev patch checks are here:
> > 
> > https://github.com/kuba-moo/nipa/tree/master/tests/patch
> > 
> > in case you're willing to code it up and post a PR.  
> 
> Hi Jakub,
> 
> I checked the tools and write a draft patch. But I have a question before post
> the PR.

First off - thanks a log for doing this!

> AFAIK, This bot is only used for checking patches and adding status in
> patchwork. But it doesn't support sending a reply to developer, right?
> 
> For the selftest reminder, I think it would be good to let developer know
> via email if the file is missing in Makefile. What do you think?

Yes, we don't have the auto-reply. There's too much noise in some of
the tests, but mostly it's because we don't want to encourage people
posting patches just to build them. If it's a machine replying rather
than a human some may think that it's okay. We already have
jaw-droppingly expensive VM instance to keep up with the build volume.
And the list is very busy. So we can't afford "post to run the CI"
development model.

> Here is the draft patch:
> 
> diff --git a/tests/patch/check_selftest/check_selftest.sh b/tests/patch/check_selftest/check_selftest.sh
> new file mode 100755
> index 0000000..ad7c608
> --- /dev/null
> +++ b/tests/patch/check_selftest/check_selftest.sh
> @@ -0,0 +1,28 @@
> +#!/bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +
> +rt=0
> +if ! git show --name-status --oneline | \
> +	grep -P '^A\ttools/testing/selftests/net/' | \
> +	grep '\.sh$'; then
> +	echo "No new net selftests script" >&$DESC_FD
> +	exit 0
> +fi
> +
> +files=$(git show --name-status --oneline | grep -P '^A\ttools/testing/selftests/net/' | grep '\.sh$' | sed 's@A\ttools/testing/selftests/net/@@')
> +for file in $files; do
> +	if echo $file | grep forwarding; then
> +		file=$(echo $file | sed 's/forwarding\///')
> +		if ! grep -P "[\t| ]$file" tools/testing/selftests/net/forwarding/Makefile;then
> +			echo "new test $file not in selftests/net/forwarding/Makefile" >&$DESC_FD
> +			rc=1
> +		fi
> +	else
> +		if ! grep -P "[\t| ]$file" tools/testing/selftests/net/Makefile;then
> +			echo "new test $file not in selftests/net/Makefile" >&$DESC_FD
> +			rc=1
> +		fi

Does it matter which exact selftest makefile the changes are?
Maybe as a first stab we should just check if there are changes 
to anything in tools/testing/selftests/.*/Makefile?

We can see if there are false-negatives.

> +	fi
> +done
> +
> +exit $rc
> diff --git a/tests/patch/check_selftest/info.json b/tests/patch/check_selftest/info.json
> new file mode 100644
> index 0000000..615779f
> --- /dev/null
> +++ b/tests/patch/check_selftest/info.json
> @@ -0,0 +1,3 @@
> +{
> +  "run": ["check_selftest.sh"]
> +}

