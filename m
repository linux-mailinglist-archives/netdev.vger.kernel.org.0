Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278EC6B5747
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 02:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229770AbjCKBNE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 20:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjCKBNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 20:13:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D77D13D54
        for <netdev@vger.kernel.org>; Fri, 10 Mar 2023 17:13:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8433061D98
        for <netdev@vger.kernel.org>; Sat, 11 Mar 2023 01:12:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8151AC433EF;
        Sat, 11 Mar 2023 01:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678497178;
        bh=zMATmf0SHnFWoUlLo2Duy7kzf4PheKK/a7Ljm1Jx6d8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jyOZ9urMlTIWvquUvq/3d7/YNQzqZKDed/lbBYeFEwR8P02MkyA6iUJBOGaO2twRd
         HXY+mnKuYFgU4tY8/pPUuPp21J+eImtL4ZtS5eEMkFvqMWutPWIqmlG03HtL+9NaNT
         nJxuRScL3+vD6DUDRwtzeJzXOBKnFaNYj5uM8GE+5AY4pqGmEe4oiWOfXHdutlsMIs
         rcj3bLY8oqvJUVZXiX8Ke10s3em3EqbvgxRVSjVz2BiTZa21Zp4LaNiQLTm2wavh0L
         O29z3oUKvS6TlI8ingrzfEiM/LaD81nb3PSqiB2+teUNWN02xUJ4p/R50D+3n3Bqsi
         Q/PrQByNDtpew==
Date:   Fri, 10 Mar 2023 17:12:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Petr Machata <petrm@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        "Ido Schimmel" <idosch@nvidia.com>, <mlxsw@nvidia.com>
Subject: Re: [PATCH net-next 0/5] net: Extend address label support
Message-ID: <20230310171257.0127e74c@kernel.org>
In-Reply-To: <cover.1678448186.git.petrm@nvidia.com>
References: <cover.1678448186.git.petrm@nvidia.com>
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

On Fri, 10 Mar 2023 12:44:53 +0100 Petr Machata wrote:
> IPv4 addresses can be tagged with label strings. Unlike IPv6 addrlabels,
> which are used for prioritization of IPv6 addresses, these "ip address
> labels" are simply tags that the userspace can assign to IP addresses
> arbitrarily.
> 
> IPv4 has had support for these tags since before Linux was tracked in GIT.
> However it has never been possible to change the label after it is once
> defined. This limits usefulness of this feature. A userspace that wants to
> change a label might drop and recreate the address, but that disrupts
> routing and is just impractical.
> 
> IPv6 addresses lack support for address labels (in the sense of address
> tags) altogether.
> 
> In this patchset, extend IPv4 to allow changing the label defined at an
> address (in patch #1). Then, in patches #2 and #3, extend IPv6 with a suite
> of address label operations fully analogous with those defined for IPv4.
> Then in patches #4 and #5 add selftest coverage for the feature.

Feels a bit like we're missing motivation for this change.
I thought address labels were legacy cruft.
Also the usual concern about allowing to change things is that some
user space will assume it's immutable. The label could until this 
set be used as part of a stable key, right?
