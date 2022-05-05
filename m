Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979A051C592
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 19:00:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381869AbiEERC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 13:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382364AbiEERBh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 13:01:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92585D1A1
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 09:57:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6AE9FB82DF5
        for <netdev@vger.kernel.org>; Thu,  5 May 2022 16:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA420C385A4;
        Thu,  5 May 2022 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651769875;
        bh=cothteBCRbCP0FMIgyEObX18UXLKQ30+E65mfHfjXG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cv6v/Rau/83j+7ensqu4sgcKVR32sSLVejC5Mm3Gd81BitglTAJqTARSPB2pLv4OD
         ABzMMTmhsCQVcSwZOl/nrWe39vTOhhB/dkqtQJf2jcovaj7KXM8ha43xgAB85JA6RM
         OitfoDTewqm+1uuBv6YP4rWqmsk9ahKSDY/p1+XoC7/idsuSNQXTCR0bJd+4bhYNWm
         1fz0EIIOpo70wtO+OJawoSspX1bn6OQy4AtgJPvmgAPyTr1N4PvJv0DeoarfelK96Y
         pTnH/pMGcFL+5FS0Q2PNztLHsjMzRkG3MZ+fWmorHngqs6skCGDadbMnUGpdWlFiKv
         kOuaOGZ1cMO2Q==
Date:   Thu, 5 May 2022 09:57:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net] netlink: do not reset transport header in
 netlink_recvmsg()
Message-ID: <20220505095753.614ddf1b@kernel.org>
In-Reply-To: <20220505161946.2867638-1-eric.dumazet@gmail.com>
References: <20220505161946.2867638-1-eric.dumazet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 May 2022 09:19:46 -0700 Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> netlink_recvmsg() does not need to change transport header.
> 
> If transport header was needed, it should have been reset
> by the producer (netlink_dump()), not the consumer(s).

Should I insert a reference to commit 99c07327ae11 ("netlink: reset
network and mac headers in netlink_dump()") when applying to give 
backporters an extra hint?
