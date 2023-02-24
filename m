Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE146A145A
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 01:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229515AbjBXAfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 19:35:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjBXAfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 19:35:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85A514DE16
        for <netdev@vger.kernel.org>; Thu, 23 Feb 2023 16:35:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2949C617C6
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 00:35:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26590C433D2;
        Fri, 24 Feb 2023 00:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677198952;
        bh=VH5WnAqwFJ6fnAtDVQ4nUE78IfwPpBJEPl1rs6ieE/4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RQuIzjJrJnABBpAJUT5QlLhZmg1C0s/ptLnZVtQC7C2JTL0r6nfK+7DtL3ZiOf9S8
         qq3Xkx63eP5gY/xtkCD3EbmgmxGe21Sv5967GTQ+aASQtLO20G/mfEJgaBLrjRx2Fd
         mxXFBkbPCkYa2kL6lpolMLw1opyuVSWHtjzKTP0j+tzQ/VswnSsU9PbucqWIDaIjCn
         h35RET7C6155w3tZuxKQffy9Jle0fpWdPYZSUphY/TLanidYv1Zc0JB8i/CdnYEONA
         ZI++ga5RtTw9YtV+68zpGWPzpOkl6ingjFzyBXFH99yFDOU4Wy948P6BeBfyfaoL6w
         sk4oZHZdc6FKw==
Date:   Thu, 23 Feb 2023 16:35:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Maxim Mikityanskiy <maxtram95@gmail.com>
Subject: Re: [net 04/10] net/mlx5e: xsk: Set napi_id to support busy polling
 on XSK RQ
Message-ID: <20230223163550.6eca5e9c@kernel.org>
In-Reply-To: <20230223225247.586552-5-saeed@kernel.org>
References: <20230223225247.586552-1-saeed@kernel.org>
        <20230223225247.586552-5-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Feb 2023 14:52:41 -0800 Saeed Mahameed wrote:
> From: Maxim Mikityanskiy <maxtram95@gmail.com>
> 
> The cited commit missed setting napi_id on XSK RQs, it only affected
> regular RQs. Add the missing part to support socket busy polling on XSK
> RQs.

Again, looks like an omission, not a bug or regression.
