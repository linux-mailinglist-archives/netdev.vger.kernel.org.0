Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B754BEFEA
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 04:16:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233030AbiBVDDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:03:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230357AbiBVDDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:03:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E574125E82;
        Mon, 21 Feb 2022 19:02:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B70961508;
        Tue, 22 Feb 2022 03:02:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC4FC340E9;
        Tue, 22 Feb 2022 03:02:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645498956;
        bh=i2JV150Bxh2CDePbvSFpRNI2nyIamIuh4TPThhKNDmE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ONDKZguDyvUS6Ba+JucYYfxZx4RZ9ps9BEFXdykSkENakEiKWXZArov/4HbVlixmD
         ibKENzo1Ku97jTfG37/v1druN4vUya3Kg/MzM0MOgdnN6Ycsucnm9v4ZWtWKOgW1bC
         2L/UE+EooG7R0Uw6xi78i+d4YWqbe4tZlAgsYnQdHFef49nCkrOc7Q3/FQ5qITn5q3
         bSThToYVt1qP3Y9TeLtJVwkIeKwbFhd6y6NL3H8mPSdT0CAGjAIqotyKWnxLOFSpvc
         DCjrGvLhESqTXEZSU25T1t0S4ZchEI3NKqLhHRN381OiqoEA6Rtx6cwtGvCP5AXaou
         WuBMWe24YSMpw==
Message-ID: <bd7f34a6-4974-c3db-0d41-497168fcd944@kernel.org>
Date:   Mon, 21 Feb 2022 20:02:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH] ipv6: prevent a possible race condition with lifetimes
Content-Language: en-US
To:     Niels Dossche <niels.dossche@ugent.be>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <5599cc3b-8925-4cfd-f035-ae3b87e821a3@ugent.be>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <5599cc3b-8925-4cfd-f035-ae3b87e821a3@ugent.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/20/22 10:54 AM, Niels Dossche wrote:
> valid_lft, prefered_lft and tstamp are always accessed under the lock
> "lock" in other places. Reading these without taking the lock may result
> in inconsistencies regarding the calculation of the valid and preferred
> variables since decisions are taken on these fields for those variables.
> 
> Signed-off-by: Niels Dossche <niels.dossche@ugent.be>
> ---
>  net/ipv6/addrconf.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


