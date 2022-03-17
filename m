Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BF1E4DBE25
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 06:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229654AbiCQFW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 01:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiCQFWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 01:22:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B01612895A5;
        Wed, 16 Mar 2022 22:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36624B81DB3;
        Thu, 17 Mar 2022 03:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4B4C340E9;
        Thu, 17 Mar 2022 03:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647488149;
        bh=paWihGFxhBOaMt0VHs3SQWTSWY2AWfDsf6Gl2cAcNZo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=f7hrjNVghhi7pksepcE3OBmuuXEm0FqXXG40l6Kgsxg7Hgr5eJ+qPw6Ob93UgcQzI
         Db8CihnqZOn2uVam/6thFgWTqWM4xw4U9a1MJnDWNA8j/A+fY/pp/0tEQh3dyAxy7Q
         PYwEoNf5Ia16QOQvAy3XgMQCiNPXz5qbaCe+9kaE4K2luLCQliWzdJY29md4viXeF5
         byTlpWJYWIfrO+n/+FvCB+kY7DKgy2f8ZqhHvuelVK5uF08VWlml/d6w8pfUoGu/Js
         4pmSgoGWJ9Lop7o1BaoISknVZYJTSE831ZSfcoXFAlGkoTzkxXLQ2P7z/lFXwZDz/A
         vArm0urldSIKw==
Message-ID: <4315b50e-9077-cc4b-010b-b38a2fbb7168@kernel.org>
Date:   Wed, 16 Mar 2022 21:35:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next v3 3/3] net: icmp: add reasons of the skb drops
 to icmp protocol
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, menglong8.dong@gmail.com
Cc:     pabeni@redhat.com, rostedt@goodmis.org, mingo@redhat.com,
        xeb@mail.ru, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        imagedong@tencent.com, edumazet@google.com, kafai@fb.com,
        talalahmad@google.com, keescook@chromium.org, alobakin@pm.me,
        flyingpeng@tencent.com, mengensun@tencent.com,
        dongli.zhang@oracle.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, benbjiang@tencent.com
References: <20220316063148.700769-1-imagedong@tencent.com>
 <20220316063148.700769-4-imagedong@tencent.com>
 <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220316201853.0734280f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/16/22 9:18 PM, Jakub Kicinski wrote:
> 
> I guess this set raises the follow up question to Dave if adding 
> drop reasons to places with MIB exception stats means improving 
> the granularity or one MIB stat == one reason?
> 

There are a few examples where multiple MIB stats are bumped on a drop,
but the reason code should always be set based on first failure. Did you
mean something else with your question?
