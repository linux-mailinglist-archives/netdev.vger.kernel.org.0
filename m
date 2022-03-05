Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F904CE61D
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 17:55:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiCEQ4R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 11:56:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiCEQ4Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 11:56:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6746340936
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 08:55:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 010ED61462
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 16:55:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C889FC004E1;
        Sat,  5 Mar 2022 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646499325;
        bh=tWrVCP9Oy9WYlSYBgpx9fXn6PAv38eI85FanfWmB5Gc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=biKWxsCSFrLyu61d//qShm5dZzpkBN3OJX6lLzUQanCUeaTBk62f9lm8UxYGNicga
         MoQkvaHifQztgnh4bHERStSMTRy/QxV2qM7JQ9/izwpW+wVbAZlB7OiRUPtCLOekId
         q7W74hzzcFCTdMrBFbnG5AQ75yC/NO0cppxecK6OHKZuC2wPiwdzy8lKTeMproWfif
         xsZikPRg4fypa2T7rOXDxke/lzVDCQVGGZRoL2ctHA8lYMpN5kIPdagPj5RRunFJv8
         /Pr5k6YvREHvc2F4dBLPlo0Jb/hXOOreJuSzCnYo2kTmCM9G1NHYYdA5n5f3az02BN
         5ijngN3YvXOXQ==
Message-ID: <b8d4a502-5e44-2710-79cb-5a7677d86a76@kernel.org>
Date:   Sat, 5 Mar 2022 09:55:23 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2 net-next 08/14] ipv6: Add hop-by-hop header to
 jumbograms in ip6_output
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Coco Li <lixiaoyan@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>
References: <20220303181607.1094358-1-eric.dumazet@gmail.com>
 <20220303181607.1094358-9-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220303181607.1094358-9-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/3/22 11:16 AM, Eric Dumazet wrote:
> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> index 16870f86c74d3d1f5dfb7edac1e7db85f1ef6755..93b273db1c9926aba4199f486ce90778311916f5 100644
> --- a/include/linux/ipv6.h
> +++ b/include/linux/ipv6.h
> @@ -144,6 +144,7 @@ struct inet6_skb_parm {
>  #define IP6SKB_L3SLAVE         64
>  #define IP6SKB_JUMBOGRAM      128
>  #define IP6SKB_SEG6	      256
> +#define IP6SKB_FAKEJUMBO      512
>  };
>  

Why is this considered a FAKEJUMBO? The proper header is getting added
correct?

