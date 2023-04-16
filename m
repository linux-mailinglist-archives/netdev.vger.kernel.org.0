Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3076F6E3A2E
	for <lists+netdev@lfdr.de>; Sun, 16 Apr 2023 18:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229513AbjDPQMK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Apr 2023 12:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbjDPQMH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Apr 2023 12:12:07 -0400
Received: from smtp-190d.mail.infomaniak.ch (smtp-190d.mail.infomaniak.ch [IPv6:2001:1600:3:17::190d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EB9235A3
        for <netdev@vger.kernel.org>; Sun, 16 Apr 2023 09:12:02 -0700 (PDT)
Received: from smtp-2-0000.mail.infomaniak.ch (unknown [10.5.36.107])
        by smtp-2-3000.mail.infomaniak.ch (Postfix) with ESMTPS id 4PzwDc6bQkzMqNQP;
        Sun, 16 Apr 2023 18:12:00 +0200 (CEST)
Received: from unknown by smtp-2-0000.mail.infomaniak.ch (Postfix) with ESMTPA id 4PzwDb66WHzMppDT;
        Sun, 16 Apr 2023 18:11:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=digikod.net;
        s=20191114; t=1681661520;
        bh=CC0o3DZrFpl6BVTSUHyefJ3ZDtH3vpSeXumoayqNF9M=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=y63O+neAHNzgfF2Pd1S87WNtM+2856koK83tvvvG2pCmR9euhB58lRPxpPrG1i+yc
         lpUlFclnBs/tAIn8iUSPyik+4zdRn2CA8dwjqd8LjPYiGIWs0t76zHIayND49dSrHu
         aDoBuW06wD7FkdMoJyGJLbFIeJrP8CXlmA3Ie/hY=
Message-ID: <a95dabd6-4c69-d915-a8a8-162c68c6e143@digikod.net>
Date:   Sun, 16 Apr 2023 18:12:06 +0200
MIME-Version: 1.0
User-Agent: 
Subject: Re: [PATCH v10 10/13] selftests/landlock: Share enforce_ruleset()
Content-Language: en-US
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     willemdebruijn.kernel@gmail.com, gnoack3000@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
References: <20230323085226.1432550-1-konstantin.meskhidze@huawei.com>
 <20230323085226.1432550-11-konstantin.meskhidze@huawei.com>
From:   =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
In-Reply-To: <20230323085226.1432550-11-konstantin.meskhidze@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Infomaniak-Routing: alpha
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 23/03/2023 09:52, Konstantin Meskhidze wrote:
> This commit moves enforce_ruleset() helper function to common.h so that
> to be used both by filesystem tests and network ones.

"so that it can be used"


> 
> Signed-off-by: Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
> ---
> 
> Changes since v9:
> * None.
> 
> Changes since v8:
> * Adds __maybe_unused attribute for enforce_ruleset() helper.
> 
> Changes since v7:
> * Refactors commit message.
> 
> Changes since v6:
> * None.
> 
> Changes since v5:
> * Splits commit.
> * Moves enforce_ruleset helper into common.h
> * Formats code with clang-format-14.
> 
> ---
>   tools/testing/selftests/landlock/common.h  | 10 ++++++++++
>   tools/testing/selftests/landlock/fs_test.c | 10 ----------
>   2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/testing/selftests/landlock/common.h b/tools/testing/selftests/landlock/common.h
> index d7987ae8d7fc..0fd6c4cf5e6f 100644
> --- a/tools/testing/selftests/landlock/common.h
> +++ b/tools/testing/selftests/landlock/common.h
> @@ -256,3 +256,13 @@ static int __maybe_unused send_fd(int usock, int fd_tx)
>   		return -errno;
>   	return 0;
>   }
> +
> +static void __maybe_unused
> +enforce_ruleset(struct __test_metadata *const _metadata, const int ruleset_fd)
> +{
> +	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
> +	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
> +	{
> +		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
> +	}
> +}
> diff --git a/tools/testing/selftests/landlock/fs_test.c b/tools/testing/selftests/landlock/fs_test.c
> index b6c4be3faf7a..b762b5419a89 100644
> --- a/tools/testing/selftests/landlock/fs_test.c
> +++ b/tools/testing/selftests/landlock/fs_test.c
> @@ -598,16 +598,6 @@ static int create_ruleset(struct __test_metadata *const _metadata,
>   	return ruleset_fd;
>   }
> 
> -static void enforce_ruleset(struct __test_metadata *const _metadata,
> -			    const int ruleset_fd)
> -{
> -	ASSERT_EQ(0, prctl(PR_SET_NO_NEW_PRIVS, 1, 0, 0, 0));
> -	ASSERT_EQ(0, landlock_restrict_self(ruleset_fd, 0))
> -	{
> -		TH_LOG("Failed to enforce ruleset: %s", strerror(errno));
> -	}
> -}
> -
>   TEST_F_FORK(layout1, proc_nsfs)
>   {
>   	const struct rule rules[] = {
> --
> 2.25.1
> 
