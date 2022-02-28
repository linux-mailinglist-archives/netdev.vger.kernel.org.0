Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1495C4C73F7
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 18:39:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237699AbiB1Rjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 12:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238531AbiB1Rh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 12:37:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D1924CD46
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 09:32:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 845BCB815A6
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 17:32:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE77C340F0;
        Mon, 28 Feb 2022 17:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646069568;
        bh=t50VeW9/hjEm9sVPLTkhUyh2g7dqjweXn2NrKZDALPY=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=HZSxKxi7N9Kb7WcBsgsvKrsUjTNE4pC2WOk1aTtq6PGX+KwH98JPz0gv/90tL7b1C
         vSsQ1/obgH8uKjP97mtUpJU+5wEU1zdPLXJg8rq5IiB6hRLktXAnYUZWRh1efcRZ66
         1vWMncUw+BZBpMnSf2MJ1ogYrLSOZojOaMBNPOPUiBk1Wm/vwh81cuvVr0XoJaUgJL
         Se50Qx/ejX8mQikwMhlXjnZNdMQBhIbXBKHyS0Ngn23ompNRIX9xh1xaZT/0GPDJaT
         6CNX8a71tvIJgBj46zo2e94SwHk5QeeKdOCMWJWvZhJ9ljZ7mX7p5a/g36Gj/bIh3B
         WGQvxvIa/RwgQ==
Message-ID: <f9b70609-bb86-3cb4-c6f7-9de2b18dd3bd@kernel.org>
Date:   Mon, 28 Feb 2022 10:32:46 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH net] ipv4: fix route lookups when handling ICMP redirects
 and PMTU updates
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <cffd245430d10fa2a14c32d1c768eef7cfeb8963.1646068241.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <cffd245430d10fa2a14c32d1c768eef7cfeb8963.1646068241.git.gnault@redhat.com>
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

On 2/28/22 10:16 AM, Guillaume Nault wrote:
> ---
>  net/ipv4/route.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 

also, add test cases to the pmtu script.
