Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C510E4C4982
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:48:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242310AbiBYPsp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242318AbiBYPso (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:48:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEDE5CEA28
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 07:48:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B85E619AB
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 15:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E3DC340E7;
        Fri, 25 Feb 2022 15:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645804090;
        bh=a6O33d9siEkHzgjzObleVWRetcsPoyZbZTHEjxJX5Wk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LQyXLr4+AxPuIr5hgHHx+LKoUK/VG7uhCEUnAU+yZvQshvEKqLcyIf41QhACupo5t
         Yewrr7vpxcbOzMxln93ODu5OuHW1pWChLcGXKTom7pM4TfVM9WTZ2P6bwANhhC1Rwz
         J/1s4iP4LQqhASJVKIHKHGyjS8lsquwRIGkCPEfW1gqH9NUPdX95tu1hozNMXbUAcl
         v3LRMkGd99Za9KI35r30avPpXdljP55WQtZQQmmxELj7d09TCMDzctqwuRP7i7LdAS
         vdcOfuOVGBqWGScd5EXozQPEQauJlFoyuHCpb7Wueb+18iy/ni42kk3abeZggMjtvF
         TnCHXmmy8CwiQ==
Date:   Fri, 25 Feb 2022 07:48:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Yinjun Zhang <yinjun.zhang@corigine.com>,
        Louis Peens <louis.peens@corigine.com>
Subject: Re: [PATCH net-next] nfp: make RSS can be switched on/off by
 ethtool
Message-ID: <20220225074809.1302cc60@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220225085929.269568-1-simon.horman@corigine.com>
References: <20220225085929.269568-1-simon.horman@corigine.com>
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

On Fri, 25 Feb 2022 09:59:29 +0100 Simon Horman wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> RSS is default on in nfp net device, and cannot be switched off
> by `ethtool -K <int> receive-hashing off`. Implement it now.

Does rxhash mean RSS or reporting of the flow hash?
User can "disable RSS" by changing the indirection table to all-0.
Currently rxhash controls copying the rxhash to the skb for the nfp.
