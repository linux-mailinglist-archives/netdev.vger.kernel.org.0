Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59FD663FDF6
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 03:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231889AbiLBCHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 21:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231922AbiLBCHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 21:07:11 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54268D4ADE;
        Thu,  1 Dec 2022 18:07:03 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id o5-20020a17090a678500b00218cd5a21c9so3856712pjj.4;
        Thu, 01 Dec 2022 18:07:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rKl/t3hakOg+uRmQvx0wOeBxtqYoX08A3/EM6NJoH6U=;
        b=EFE5vwNPwJekGuDpnV9qPgENSxGIZ0xMQZJYWD2X9lqjw00nv0bKpGpVbc9i/C+vAO
         FS3OzKthapYfTee+ocZGBWFFRydWBVjB72PxqFTiK69fIMTm0qOQUAAolxO6dq4vYTwX
         y2ZtwKO34SgtOhsdEGPvER4PEsMGAlqLk4KKqlM7h5unshA1mnG0AAT+bO4v9j3UXNV3
         sbkKlsN4EHNIaOlvTzZdTZUilNslXxfF9HDQzf0fCDAoOgPJWowsCcMMT7e0qwVaJ4Kl
         e4oH3czN560omo3uMNsAxkYFea3EU0iT34pOwCLhN+/SrYxJ1NUtuuu4kLSYZN3mVtSy
         zu4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rKl/t3hakOg+uRmQvx0wOeBxtqYoX08A3/EM6NJoH6U=;
        b=TXUbhOm0Th4oI+VuRz+Jr6zTQCiRmr6ZsqC44/x7MTM7mWjLX5iz/BLrqdH3Xc5r4h
         ZnauZy4YrTg/fRmshLskNvjJrYLT2+mBeXv3OAeTnWwhAEQy8TX5Bh94rh39p4R3Bc5v
         Ya2bPN/X1kU2IBL+YLejZehT6t8e49+8nQrYFMBijvvoUXnMuPMkfcQdsjJMJuXOoHze
         Xj9GVJNsns9hRZvbD7L9Uz0biJaEBXuf2McnZDOO1UHJIn9D4/Xop2mJDPx3/EDQA9ce
         MP9xGAHZMFbnNseRJlJFHwhpax9pPGcMLdTEWveA9/AodmLoswm+gu5eXcXYyrx/FVyt
         Ul2w==
X-Gm-Message-State: ANoB5plMKOUwOn+DBD8DiydyTIKkWXUP2Zjpn3gvmY8EEmQaZRSqDr8g
        gwO+FE0mlMIj9GA9eNisZ+E=
X-Google-Smtp-Source: AA0mqf7ph5WIS2+a6zuk0OwSfZ90aWqAvpGvluLfBYXrVEgmbmyQ4c/e3uBHIWtgPOor6woPAI6sAg==
X-Received: by 2002:a17:90a:7e8b:b0:213:df24:ed80 with SMTP id j11-20020a17090a7e8b00b00213df24ed80mr78244079pjl.186.1669946822739;
        Thu, 01 Dec 2022 18:07:02 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x27-20020aa7957b000000b0057534fcd895sm3882532pfq.108.2022.12.01.18.06.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 18:07:01 -0800 (PST)
Date:   Fri, 2 Dec 2022 10:06:56 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, shannon.nelson@oracle.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net] selftests: rtnetlink: correct xfrm policy rule in
 kci_test_ipsec_offload
Message-ID: <Y4ldwIQlcXyZek1A@Laptop-X1>
References: <20221201082246.14131-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201082246.14131-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 01, 2022 at 04:22:46PM +0800, Zhengchao Shao wrote:
> When testing in kci_test_ipsec_offload, srcip is configured as $dstip,
> it should add xfrm policy rule in instead of out.
> The test result of this patch is as follows:
> PASS: ipsec_offload
> 
> Fixes: 2766a11161cc ("selftests: rtnetlink: add ipsec offload API test")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  tools/testing/selftests/net/rtnetlink.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/rtnetlink.sh b/tools/testing/selftests/net/rtnetlink.sh
> index 0900c5438fbb..275491be3da2 100755
> --- a/tools/testing/selftests/net/rtnetlink.sh
> +++ b/tools/testing/selftests/net/rtnetlink.sh
> @@ -782,7 +782,7 @@ kci_test_ipsec_offload()
>  	    tmpl proto esp src $srcip dst $dstip spi 9 \
>  	    mode transport reqid 42
>  	check_err $?
> -	ip x p add dir out src $dstip/24 dst $srcip/24 \
> +	ip x p add dir in src $dstip/24 dst $srcip/24 \
>  	    tmpl proto esp src $dstip dst $srcip spi 9 \
>  	    mode transport reqid 42
>  	check_err $?
> -- 
> 2.34.1
>

Acked-by: Hangbin Liu <liuhangbin@gmail.com>
