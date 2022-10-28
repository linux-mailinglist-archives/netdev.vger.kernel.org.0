Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93054610B80
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 09:46:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbiJ1HqO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 03:46:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbiJ1HqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 03:46:12 -0400
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30199BEAED
        for <netdev@vger.kernel.org>; Fri, 28 Oct 2022 00:46:08 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id 070FA1883F32;
        Fri, 28 Oct 2022 07:45:53 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id 02E752500015;
        Fri, 28 Oct 2022 07:45:53 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id EAC609EC0007; Fri, 28 Oct 2022 07:45:52 +0000 (UTC)
X-Screener-Id: 413d8c6ce5bf6eab4824d0abaab02863e8e3f662
MIME-Version: 1.0
Date:   Fri, 28 Oct 2022 09:45:52 +0200
From:   netdev@kapio-technology.com
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        jiri@nvidia.com, petrm@nvidia.com, ivecera@redhat.com,
        roopa@nvidia.com, razor@blackwall.org, mlxsw@nvidia.com
Subject: Re: [RFC PATCH net-next 01/16] bridge: Add MAC Authentication Bypass
 (MAB) support
In-Reply-To: <20221027225832.2yg4ljivjymuj353@skbuf>
References: <20221025100024.1287157-1-idosch@nvidia.com>
 <20221025100024.1287157-2-idosch@nvidia.com>
 <20221027225832.2yg4ljivjymuj353@skbuf>
User-Agent: Gigahost Webmail
Message-ID: <1a66212fdb43fb8d03fc1e4c7612ad1b@kapio-technology.com>
X-Sender: netdev@kapio-technology.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-10-28 00:58, Vladimir Oltean wrote:

> I was going to ask if we should bother to add code to prohibit packets
> from being forwarded to an FDB entry that was learned as LOCKED, since
> that FDB entry is more of a "ghost" and not something fully committed?

I think that it is a security flaw if there is any forwarding to 
BR_FDB_LOCKED
entries. I can imagine a host behind a locked port with no credentials,
that gets a BR_FDB_LOCKED entry and has a friend on another non-locked 
port
who can now communicate uni-directional to the host with the 
BR_FDB_LOCKED
entry. It should not be too hard to create a scheme using UDP packets or
other for that.
