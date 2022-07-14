Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E096C575347
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 18:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240487AbiGNQqu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 12:46:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240388AbiGNQqc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 12:46:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54E46A9E1;
        Thu, 14 Jul 2022 09:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 884BC6202B;
        Thu, 14 Jul 2022 16:44:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61802C34114;
        Thu, 14 Jul 2022 16:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657817087;
        bh=8DzjZ8Pj1BFtFMk4g4SFC/yQwR97X9txfSiLvi2MmfI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fydiakQwD0XRBJza3O5Fq46aBDUSHohbSZ3dk4fnf0PDvrAA6Q19+5Ktjp69bfAaG
         Qe+lOFqYkXOvdHXZkGyaBi2fx3DSfH5qPVz3gSz2c3ZJTopfJRWp6QZzOicdGP01Ma
         /TOXi/87lQsioSTRzEPKmxL0iSSmd14K3Jy1O3zcddG63JSznRvlzoj721UrzEiyXq
         H/TBKteIsSUdFe2WOyhRUCXSfQldQ2EduiQQi55vgBiGxCBaK6ZjT4/mJEI9lQjB7a
         OmbTmbyAa13DguFHze88dY7hnMLv5ogTK70+1EHsY/TlIBAbLHZBknNmLww4AwZneH
         zZNjNwJGxz10A==
Date:   Thu, 14 Jul 2022 09:44:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jie2x Zhou <jie2x.zhou@intel.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        shuah@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, llvm@lists.linux.dev,
        Philip Li <philip.li@intel.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] tools/testing/selftests/net/bpf/Makefile: fix fatal
 error: 'bpf/bpf_helpers.h' file not found
Message-ID: <20220714094447.6e66fd0e@kernel.org>
In-Reply-To: <20220714065003.8388-1-jie2x.zhou@intel.com>
References: <20220714065003.8388-1-jie2x.zhou@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Jul 2022 14:50:03 +0800 Jie2x Zhou wrote:
> In tools/testing/selftests run:
> make -C bpf
> make -C net
> fatal error: 'bpf/bpf_helpers.h' file not found
> 
> Add bpf/bpf_helpers.h include path in net/bpf/Makefile.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Jie2x Zhou <jie2x.zhou@intel.com>
> ---
>  tools/testing/selftests/net/bpf/Makefile | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
> index 8ccaf8732eb2..07d56d446358 100644
> --- a/tools/testing/selftests/net/bpf/Makefile
> +++ b/tools/testing/selftests/net/bpf/Makefile
> @@ -1,6 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0
>  
>  CLANG ?= clang
> +CCINCLUDE += -I../bpf/tools/include
>  CCINCLUDE += -I../../bpf
>  CCINCLUDE += -I../../../../lib
>  CCINCLUDE += -I../../../../../usr/include/

Can we switch to relative paths here, somehow?
We keep adding those include paths, see 7b92aa9e6135 ("selftests net:
fix kselftest net fatal error") for example.
