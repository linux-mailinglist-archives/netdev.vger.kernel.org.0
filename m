Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81166E2C72
	for <lists+netdev@lfdr.de>; Sat, 15 Apr 2023 00:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229752AbjDNW1s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 18:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbjDNW1r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 18:27:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1367349F7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 15:27:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0181648B4
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 22:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FF39C433D2;
        Fri, 14 Apr 2023 22:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681511266;
        bh=bGa2hBLfqw75ceVdCVwZOl8+9M581nl0Ppk5w8lKJFE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RytCMLPpyW82XTHk6uJbE9bhzfL2vefnGXjIbDi6g/kL4pLfwVxnO+Z7E0LdMj00E
         3uaRf8bkxYiIKUGl7Bng26rt/bDJY/d9YMP9hWs1P3G8/bzs0wYTlFaUACmQer5Jos
         Zn/JckqlyYc6+E0QJCLDJ+gxUGjCfidYQl6ryH5k6kO9RM1NAt6sreqxNmTqTzBZvk
         zmoqMa6ZzlzYIqCGu0eul4lZvnE0e3yNYhwuehBBrtFLgZqlt7jzY3N+k+QyglqUVC
         n3M4HnixKdUKHA7NnoZm81D/Pc+W3ZHsiDHc8Ln2k5KvLHHRhVAdkABQr3ziNc9oyV
         IOwg/8S/s9I+g==
Date:   Fri, 14 Apr 2023 15:27:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Pavan Kumar Linga <pavan.kumar.linga@intel.com>,
        willemb@google.com, decot@google.com, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, edumazet@google.com,
        intel-wired-lan@lists.osuosl.org, anthony.l.nguyen@intel.com,
        pabeni@redhat.com, davem@davemloft.net
Subject: Re: [Intel-wired-lan] [PATCH net-next v2 00/15] Introduce Intel
 IDPF driver
Message-ID: <20230414152744.4fd219f9@kernel.org>
In-Reply-To: <ZDnNRs6sWb45e4F6@sashalap>
References: <20230411011354.2619359-1-pavan.kumar.linga@intel.com>
        <ZDb3rBo8iOlTzKRd@sashalap>
        <643703892094_69bfb294a3@willemb.c.googlers.com.notmuch>
        <d2585839-fcec-4a68-cc7a-d147ce7deb04@intel.com>
        <20230412192434.53d55c20@kernel.org>
        <ZDnNRs6sWb45e4F6@sashalap>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Apr 2023 18:01:42 -0400 Sasha Levin wrote:
>> As I said previously in [0] until there is a compatible, widely
>> available implementation from a second vendor - this is an Intel
>> driver and nothing more. It's not moving anywhere.  
> 
> My concern isn't around the OASIS legal stuff, it's about the users who
> end up using this and will end up getting confused when we have two (or
> more) in-kernel "IDPF" drivers.
> 
> I don't think that moving is an option - it'll brake distros and upset
> users: we can't rename drivers as we go because it has a good chance of
> breaking users.

Minor pain for backports but I don't think we need to rename anything,
just move.

Or we can just leave it be under intel/, since there are not other
participant now. Unless perhaps under google/ is a better option?

Drivers are organized by the vendor for better or worse. We have a
number of drivers under the "wrong directly" already. Companies merge /
buy each others product lines, there's also some confusion about common
IP drivers. It's all fine, whatever. 

Users are very, very unlikely to care.

>> I think that's a reasonable position which should allow Intel to ship
>> your code and me to remain professional.  
> 
> No concerns about OASIS or the current code, I just don't want to make
> this a mess for the users.

It's not a standard until someone else actually adopts it. What stops
all the other vendors from declaring that their driver interface is a
standard now, too?

We have a long standing rule in netdev against using marketing language.
