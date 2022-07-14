Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E501C57552B
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 20:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240107AbiGNSks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 14:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232538AbiGNSkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 14:40:47 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7D357E15;
        Thu, 14 Jul 2022 11:40:47 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 9667F320091E;
        Thu, 14 Jul 2022 14:40:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 14 Jul 2022 14:40:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1657824045; x=1657910445; bh=cfh5Vbt0d0CpHZj8hmg30dluCeWX
        m83Q5tUEhlXXfjA=; b=NIsJT87TzT6dcAX1hLo/v8joJpm9ycU1GQ7wSl/SPX2F
        m5PZVjpsK/l6hwc8KWiD2K5G9lnyau33Q8LGi5WPsrKgzVfz6QdLZQEbtnT9fNmY
        zkE6iIGyWJFIbz7qFOh+znWQ8pamekNw/c30wCISsEuhJMG4BGIL8XpwSCuD6lwj
        lZpQD1+s0QwaWHZJeBWCBiHkCaq/5k8Mt3n8xUfsIPFtxQ1nF8pZBUDsM2S/odt9
        +1PSDSLS9Vz7YCf0e2e+gbMM1dVcPxSez4FnGzysk6Kn/dfll5IV/R7T1mYj5B/a
        VhLzO9jZtlCgt/gZgY/kzAZGmzprpPrGaNb9LE6hVQ==
X-ME-Sender: <xms:LGPQYnLwmdh3CwTzIWMz7YrzmmxORq9JK-_zfOHohZsGgEhkVzUt-Q>
    <xme:LGPQYrLon1Tlyu1Iytp_RKaWCS7S89w64YSin8L_G-6QjNJAYvUhrP0zLpO5PMbuU
    NIGPadJKwzOUiw>
X-ME-Received: <xmr:LGPQYvtXnor8p8zZSnfOvAyZ4mctjlmTKL9OtDrqlybAgAgheIuoilSLujzHJti9bUXUq1aOvBMaLQarkdk2nTLoD3SmLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudejledgudeftdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeehhfdtjedviefffeduuddvffegteeiieeguefgudffvdfftdefheeijedt
    hfejkeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhr
    gh
X-ME-Proxy: <xmx:LGPQYgZkvlKo1CkJw56GB2UUZSSo7Uat0kkx_h-TbeZIP7xoTvEu6w>
    <xmx:LGPQYua-ue4hKZsHYJJGXa_37l72-7ytAb36PbxMnBekTgDWNqY7iQ>
    <xmx:LGPQYkCIh3eJ_LxQ8hweM41AtJIKf2ZJ_Tl7tHR0bJo0fYhtkhZHUA>
    <xmx:LWPQYkM1T6SxUOsnEPAI2o5jnc1fF2dbzZocedGotRbZZaD6yDD6Fg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 14 Jul 2022 14:40:43 -0400 (EDT)
Date:   Thu, 14 Jul 2022 21:40:40 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Leon Romanovsky <leon@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [for-next][PATCH 03/23] tracing: devlink: Use static array for
 string in devlink_trap_report even
Message-ID: <YtBjKLsoB4e+hSB5@shredder>
References: <20220714164256.403842845@goodmis.org>
 <20220714164328.461963902@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220714164328.461963902@goodmis.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 14, 2022 at 12:42:59PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> The trace event devlink_trap_report uses the __dynamic_array() macro to
> determine the size of the input_dev_name field. This is because it needs
> to test the dev field for NULL, and will use "NULL" if it is. But it also
> has the size of the dynamic array as a fixed IFNAMSIZ bytes. This defeats
> the purpose of the dynamic array, as this will reserve that amount of
> bytes on the ring buffer, and to make matters worse, it will even save
> that size in the event as the event expects it to be dynamic (for which it
> is not).
> 
> Since IFNAMSIZ is just 16 bytes, just make it a static array and this will
> remove the meta data from the event that records the size.
> 
> Link: https://lkml.kernel.org/r/20220712185820.002d9fb5@gandalf.local.home
> 
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Jiri Pirko <jiri@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

On the off chance that my tags weren't omitted on purpose:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>

s/even/event/ in subject
