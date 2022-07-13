Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936BC572E35
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 08:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233744AbiGMGeT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 02:34:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbiGMGeS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 02:34:18 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C47AD88F14;
        Tue, 12 Jul 2022 23:34:16 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id EF0615C00AE;
        Wed, 13 Jul 2022 02:34:13 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 13 Jul 2022 02:34:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1657694053; x=1657780453; bh=edLOb4Wr+qoejHKWqJQsSuBKuAII
        JA4woz+ajV4n8eM=; b=Bei3h0FEFXmn+HvqhOFlqfEx3yHwcsKqzRLdE6b0gXR2
        V/sVXsRITn92miR3vMH0OZPUoyzToqazMy9IX2pxKE06qXuEwCF2TwwTs3LuE4/2
        mk8EtiEhr7dS+y/NTSXc2MsvX4dJGc+iIISk0VcDF/qrJ+0bD8vk0MfBKHrLo9iq
        WuQse7NCoyuB0+KNxlugZkJv3cw+A6q04RZ1fyDGj6pwk3RLAyKbkMCTAVDuM5sC
        J1XZOlUBaf7b7vaRf7sTUsFowjVJEia6hYuJvRAJySFunwSwlO8PBUg3hyL4xTTn
        YbDfowrJDNZR+wpNGqACck5xGHhJqHuhXaFCGCpPXw==
X-ME-Sender: <xms:ZWfOYhhFYxC7BZSW38KDT2x0bG86NvvwWmv89Od6Hz4ZxAQGnkoTlg>
    <xme:ZWfOYmAXbvRvnB7e2XwFBxKGRDossqWaeV4U2eXdapkqaJzB1eR3N_IUUjBZbuDr0
    Uylm9qYQV1Fy6E>
X-ME-Received: <xmr:ZWfOYhGMwL9JzhNsBPsxlVk5Ioeo1SC6ryVsWAX8CpFBuunfQVJDiytUqc9RcLqnFwUhIzCTMpyZEoBuoFF29lDrpHg-aA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudejiedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:ZWfOYmRVYsXN4JrsUswsrcxWCimGpdmbyVxcpiBizVPv3SJrhAYDmQ>
    <xmx:ZWfOYuz3CRCW_7B03RTGF_rGDfW-tCrmRnW6EQFyGlNh_SS-_a12FA>
    <xmx:ZWfOYs4zc3-_36HMg9ecV6r-EThG3kM0ap9WswjCsxSTitRpeWXbTw>
    <xmx:ZWfOYloJqzQBBe8ZtMS3McomUPDmfPoTpAmKBkGT2SC_7EayHfmxjA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 13 Jul 2022 02:34:12 -0400 (EDT)
Date:   Wed, 13 Jul 2022 09:34:09 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2] tracing: devlink: Use static array for string in
 devlink_trap_report even
Message-ID: <Ys5nYctVGd6WD70M@shredder>
References: <20220712185820.002d9fb5@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712185820.002d9fb5@gandalf.local.home>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 06:58:20PM -0400, Steven Rostedt wrote:
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
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Jiri Pirko <jiri@nvidia.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Tested-by: Ido Schimmel <idosch@nvidia.com>
