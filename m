Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA8F5BBEAC
	for <lists+netdev@lfdr.de>; Sun, 18 Sep 2022 17:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229786AbiIRPbZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Sep 2022 11:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiIRPbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Sep 2022 11:31:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B255B1ADAC
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 08:31:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71166B81028
        for <netdev@vger.kernel.org>; Sun, 18 Sep 2022 15:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DE1C433C1;
        Sun, 18 Sep 2022 15:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663515080;
        bh=Lugz0mVdyUtdJwa75ejyyxkc/6ETCGMGTghzCkKV7y8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ohmMGFST1csKPkshShepCaMG9EHpgtW89XE6Ymg5OOorx6+rWGRNDFLxYJPEYxPrS
         8rzBOFhMV1LTzw1XXElZqYE+JzseYcCWaprEthmOIKnVn6B4EpUjNLBERkiri0uLDa
         t5ULmMe+9GcnxukJStAvdWESGHfcbu1kEThsJCqpz93g0v8am8gck7suQC4EInJJ2b
         2l/EVCgGU2Qk8+l3ybDRVW+Ilq1cO4x41lLJQlhb+Na5R6YASJyohYoB1s7m5ugQos
         7RtZMVGWDcDm4RVNJh1K1gZ6EEMf+dxH5+K3ooa6+XsjptfQ9VIPFNegKsr1Be5aVA
         li32De9YZeI9g==
Message-ID: <63adabd9-83b6-0bc0-33aa-3afc54ae6836@kernel.org>
Date:   Sun, 18 Sep 2022 09:31:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH net] ipv6: Fix crash when IPv6 is administratively
 disabled
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yoshfuji@linux-ipv6.org, rroberto2r@gmail.com,
        mlxsw@nvidia.com
References: <20220916084821.229287-1-idosch@nvidia.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220916084821.229287-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/22 2:48 AM, Ido Schimmel wrote:
> The global 'raw_v6_hashinfo' variable can be accessed even when IPv6 is
> administratively disabled via the 'ipv6.disable=1' kernel command line
> option, leading to a crash [1].
> 
> Fix by restoring the original behavior and always initializing the
> variable, regardless of IPv6 support being administratively disabled or
> not.
> 

...

> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Fixes: 0daf07e52709 ("raw: convert raw sockets to RCU")
> Reported-by: Roberto Ricci <rroberto2r@gmail.com>
> Tested-by: Roberto Ricci <rroberto2r@gmail.com>
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/ipv6/af_inet6.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>

