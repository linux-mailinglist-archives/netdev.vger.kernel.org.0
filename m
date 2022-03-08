Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9CC4D1E5C
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 18:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348728AbiCHRSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 12:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348720AbiCHRSr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 12:18:47 -0500
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23D2F17045;
        Tue,  8 Mar 2022 09:17:51 -0800 (PST)
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1nRdSz-0009WI-7E; Tue, 08 Mar 2022 18:17:45 +0100
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1nRdSy-000FXQ-Ux; Tue, 08 Mar 2022 18:17:44 +0100
Subject: Re: [PATCH bpf v2] tools: fix unavoidable GCC call in Clang builds
To:     Adrian Ratiu <adrian.ratiu@collabora.com>, netdev@vger.kernel.org
Cc:     llvm@lists.linux.dev, kernel@collabora.com,
        linux-kernel@vger.kernel.org,
        Nick Desaulniers <ndesaulniers@google.com>,
        Manoj Gupta <manojgupta@chromium.com>,
        Nathan Chancellor <nathan@kernel.org>, bpf@vger.kernel.org
References: <20220308121428.81735-1-adrian.ratiu@collabora.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6e82ffbb-ebc8-30e8-2326-95712578ee07@iogearbox.net>
Date:   Tue, 8 Mar 2022 18:17:44 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20220308121428.81735-1-adrian.ratiu@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.5/26475/Tue Mar  8 10:31:43 2022)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/8/22 1:14 PM, Adrian Ratiu wrote:
> In ChromeOS and Gentoo we catch any unwanted mixed Clang/LLVM
> and GCC/binutils usage via toolchain wrappers which fail builds.
> This has revealed that GCC is called unconditionally in Clang
> configured builds to populate GCC_TOOLCHAIN_DIR.
> 
> Allow the user to override CLANG_CROSS_FLAGS to avoid the GCC
> call - in our case we set the var directly in the ebuild recipe.
> 
> In theory Clang could be able to autodetect these settings so
> this logic could be removed entirely, but in practice as the
> commit cebdb7374577 ("tools: Help cross-building with clang")
> mentions, this does not always work, so giving distributions
> more control to specify their flags & sysroot is beneficial.
> 
> Suggested-by: Manoj Gupta <manojgupta@chromium.com>
> Suggested-by: Nathan Chancellor <nathan@kernel.org>
> Acked-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Adrian Ratiu <adrian.ratiu@collabora.com>
> ---
> Changes in v2:
>    * Replaced variable override GCC_TOOLCHAIN_DIR -> CLANG_CROSS_FLAGS

As I understand it from [0] and given we're late in the cycle, this is
targeted for bpf-next not bpf, right?

Thanks,
Daniel

   [0] https://lore.kernel.org/lkml/87czjk4osi.fsf@ryzen9.i-did-not-set--mail-host-address--so-tickle-me/
