Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 186275385EB
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 18:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239016AbiE3QKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 12:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238069AbiE3QKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 12:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D54B26AA71;
        Mon, 30 May 2022 09:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 878FAB80E6E;
        Mon, 30 May 2022 16:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D13C3411A;
        Mon, 30 May 2022 16:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653927013;
        bh=Fu8PEGmmAgNvUtQ2vk2fyGSkOt84LcOIIIBlymDZiDk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=K3bsexlepQsActRXfHfakH/7d3Fjt7DapgHXTiCdoJuM3UtU1J+9m/BuWHCfS38JH
         NszG+VgtNbhvsFVAx0F0+p3jJ5mLBRrwIYD1AfPQrOmW+2ZpxYtRIQw7pELLv9BHDU
         Vg6yfTZkuLUO/bYWxPrbnR66P6bBu3VCi/CKFdR3FDPWQO5+nXkIcAz6kbP4Ocqwyg
         DariOnqsZCLUyBadWHHFGPrz8qONEcyPfN3Jloe4SjMSo5Ynx9BO/Arv9Xae8808G7
         a8sZip3bZxv4OF2DSBZLq4y94kEvaZ5XzAhfzxU2+m616HN4U0L78ologCGNZNrepd
         OlfCmICyOHLlA==
Message-ID: <928aa148-e666-783b-dbd4-9ea3172efafb@kernel.org>
Date:   Mon, 30 May 2022 10:10:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
Subject: Re: [PATCH v2] net: ipv4: Avoid bounds check warning
Content-Language: en-US
To:     zhanggenjian <zhanggenjian123@gmail.com>, pabeni@redhat.com,
        edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        huhai@kylinos.cn
References: <20220526101213.2392980-1-zhanggenjian@kylinos.cn>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220526101213.2392980-1-zhanggenjian@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/26/22 4:12 AM, zhanggenjian wrote:
> From: huhai <huhai@kylinos.cn>
> 
> Fix the following build warning when CONFIG_IPV6 is not set:
> 
> In function ‘fortify_memcpy_chk’,
>     inlined from ‘tcp_md5_do_add’ at net/ipv4/tcp_ipv4.c:1210:2:
> ./include/linux/fortify-string.h:328:4: error: call to ‘__write_overflow_field’ declared with attribute warning: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Werror=attribute-warning]
>   328 |    __write_overflow_field(p_size_field, size);
>       |    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Suggested-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: huhai <huhai@kylinos.cn>
> ---
>  net/ipv4/tcp_ipv4.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

