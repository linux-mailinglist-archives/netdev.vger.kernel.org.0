Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ABCB33A839
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 22:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234132AbhCNVbU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 17:31:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234204AbhCNVbJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 17:31:09 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569F6C061574;
        Sun, 14 Mar 2021 14:31:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id E1E154CBDE068;
        Sun, 14 Mar 2021 14:31:01 -0700 (PDT)
Date:   Sun, 14 Mar 2021 14:31:01 -0700 (PDT)
Message-Id: <20210314.143101.1456394019713348728.davem@davemloft.net>
To:     vladimir.oltean@nxp.com
Cc:     jakub@cloudflare.com, alobakin@pm.me, kuba@kernel.org,
        ast@kernel.org, andriin@fb.com, dcaratti@redhat.com,
        gnault@redhat.com, wenxu@ucloud.cn, eranbe@nvidia.com,
        mcroce@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] flow_dissector: fix byteorder of dissected ICMP ID
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210314204449.6ogfogeiqfwwqfso@skbuf>
References: <20210312200834.370667-1-alobakin@pm.me>
        <87wnu932qz.fsf@cloudflare.com>
        <20210314204449.6ogfogeiqfwwqfso@skbuf>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Sun, 14 Mar 2021 14:31:02 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>
Date: Sun, 14 Mar 2021 20:44:49 +0000

> On Sun, Mar 14, 2021 at 09:21:40PM +0100, Jakub Sitnicki wrote:
>> On Fri, Mar 12, 2021 at 09:08 PM CET, Alexander Lobakin wrote:
>> 
>> Smells like a breaking change for existing consumers of this value.
>> 
>> How about we change the type of flow_dissector_key_icmp{}.id to __be16
>> instead to make sparse happy?
> 
> The struct flow_dissector_key_icmp::id only appears to be used in
> bond_xmit_hash, and there, the exact value doesn't seem to matter.
> 
> This appears to be a real bug and not just to appease sparse:
> ih->un.echo.id has one endianness and "1" has another. Both cannot
> be correct.

Agreed, so I will apply this, thanks.
