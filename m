Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB4096D1793
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:39:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbjCaGjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:39:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbjCaGjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:39:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66CE61CB95;
        Thu, 30 Mar 2023 23:39:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2AF86239F;
        Fri, 31 Mar 2023 06:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66F6C4339B;
        Fri, 31 Mar 2023 06:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680244783;
        bh=3X6WrxtEcRBB/WMuB3pzk9APL3q7bHhWzy7j8gGTtDE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cn6NhV+xrbNoxG2n+kQ/ZLoeXAc87WfwyhpEqMwFAOo5idq/HvrXXc7wf+5kwB+HX
         k5aVcTou7QDWTchOrPIgkYpABb/udz0taFfmgbjehDDXww63gsPdgzJbJw1IZ+4a4w
         uzYKHaQCc4LpuiSTrQ+O5qh6IOzgainTEj9IrUz84lsig79tNb7ROs/vuWcF2nHIGx
         vrSNA+HAa6eO8G83hPFEYkvFUP60zMzsjgH9cOcAX9VoFx2MV7H2/hSgLXhkbxZh5y
         X9ukkwAKhyBrsjRsxSvAPxwXqVWvsgzNFBNxT4ETI1u6di2psCHUDep7YXgvfekSJd
         CkAR9zEKWV11g==
Date:   Thu, 30 Mar 2023 23:39:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        zbr@ioremap.net, brauner@kernel.org, johannes@sipsolutions.net,
        ecree.xilinx@gmail.com, leon@kernel.org, keescook@chromium.org,
        socketcan@hartkopp.net, petrm@nvidia.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3 6/7] netlink: Add multicast group level permissions
Message-ID: <20230330233941.70c98715@kernel.org>
In-Reply-To: <20230329182543.1161480-7-anjali.k.kulkarni@oracle.com>
References: <20230329182543.1161480-1-anjali.k.kulkarni@oracle.com>
        <20230329182543.1161480-7-anjali.k.kulkarni@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Mar 2023 11:25:42 -0700 Anjali Kulkarni wrote:
> A new field perm_groups is added in netlink_sock to store the protocol's
> multicast group access permissions. This is to allow for a more fine
> grained access control than just at the protocol level. These
> permissions can be supplied by the protocol via the netlink_kernel_cfg.
> A new function netlink_multicast_allowed() is added, which checks if
> the protocol's multicast group has non-root access before allowing bind.

Is there a reason this is better than implementing .bind
in the connector family and filtering there?
