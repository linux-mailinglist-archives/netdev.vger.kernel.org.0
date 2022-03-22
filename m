Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7954E38C4
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 07:21:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236885AbiCVGUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 02:20:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236883AbiCVGUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 02:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FE96F24;
        Mon, 21 Mar 2022 23:18:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA0646142A;
        Tue, 22 Mar 2022 06:18:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6EF2C340EC;
        Tue, 22 Mar 2022 06:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647929914;
        bh=E4QiXgUS2gXJ+MZo3C+fEHnauzWfzK2THXjd2mXgGto=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MNAkSF+etXMHwBztM/4fhNzfUV5LGdJ9adoMWSEjsTvXZAOSVe+5OxeMSx7Lrgaym
         EIF0YQaGwE1I0NSmmYXcyVmIIxeVPl3OybUqLGSK3YWRFxv1eb+DF1q1Lsq7xMtlsH
         Odi29Y+P9yvJSDTzh1oEpgPfwJTL93Wl3FJZYdnzE0xVV/Bj5FEq2hmbmW6GuTaRel
         dRzMluIqOSUJIlWl3Glh1SGEtlnCrLlePVuLjE+UGxl0anC8Uia0jkVNVy4ZrWFRx9
         iwu8el1/9/OOcY1Y3YcUoS4iX+ZFCCV0HUHvbwmQY8WrrZqS91xTeVl1XKf2nibnov
         AfHb/B+Rj3JXg==
Date:   Mon, 21 Mar 2022 23:18:33 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <20220322061833.ayp5sb4fb64e6lzo@sx1>
References: <20220321183941.74be2543@canb.auug.org.au>
 <20220321144531.2b0503a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220321144531.2b0503a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21 Mar 14:45, Jakub Kicinski wrote:
>On Mon, 21 Mar 2022 18:39:41 +1100 Stephen Rothwell wrote:
>> Hi all,
>>
>> After merging the net-next tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>>
>> In file included from include/linux/string.h:253,
>>                  from include/linux/bitmap.h:11,
>>                  from include/linux/cpumask.h:12,
>>                  from arch/x86/include/asm/cpumask.h:5,
>>                  from arch/x86/include/asm/msr.h:11,
>>                  from arch/x86/include/asm/processor.h:22,
>>                  from arch/x86/include/asm/timex.h:5,
>>                  from include/linux/timex.h:65,
>>                  from include/linux/time32.h:13,
>>                  from include/linux/time.h:60,
>>                  from include/linux/ktime.h:24,
>>                  from include/linux/timer.h:6,
>>                  from include/linux/netdevice.h:24,
>>                  from include/trace/events/xdp.h:8,
>>                  from include/linux/bpf_trace.h:5,
>>                  from drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:33:
>> In function 'fortify_memset_chk',
>>     inlined from 'mlx5e_xmit_xdp_frame' at drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c:438:3:
>> include/linux/fortify-string.h:242:25: error: call to '__write_overflow_field' declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>>   242 |                         __write_overflow_field(p_size_field, size);
>>       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Caused by commit
>>
>>   9ded70fa1d81 ("net/mlx5e: Don't prefill WQEs in XDP SQ in the multi buffer mode")
>>
>> exposed by the kspp tree.
>>
>> I have applied the following fix patch for today (a better one is
>> probably possible).
>
>Hi Saeed,
>
>thoughts?
>

I forgot about this warning in net :-/ we did a similar patch to net to
avoid it, Stephen's patch is correct, 
I will submit his fixup to net-next in the morning.

