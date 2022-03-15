Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E02C4DA491
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 22:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbiCOV0n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 17:26:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235170AbiCOV0n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 17:26:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70855B3F8;
        Tue, 15 Mar 2022 14:25:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4946A6111A;
        Tue, 15 Mar 2022 21:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799B6C340E8;
        Tue, 15 Mar 2022 21:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647379522;
        bh=wJSra2VgQ0+cYa66UqORpnXWJgLKVU5fREpOu7qw/B0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P2ACkHzL7/4DV+zFq2f+EsN/LmO4b9ExkuXWHaPga+/W/0I596IgrLhiNa1Fu0nJE
         WeWOW/Ldc+7w4h98jgMUUzTIGrjCPoHY51W4O/+DCmiVdRTa22v2Hqd2F+o22Aa5q3
         i6MUNsrrGnnnsrxyVnkNYVCc3DUzlDyZch9lHTk0ZV12I2JwNg+ffANtdtJM/5iwo/
         lB7O1PTjIfHQyGNPiPEd+yEz74hT+gUnAmeQSSGXyFsTV/n6I01hopcwKAEALxFXXD
         lzqctSG0aLRlN+LWl7Bka1oWCVudL3tZgRRNzbq9pSPocwIu+ft5NbPZp8hFmRy9HA
         sxK8gLQl24MkA==
Date:   Tue, 15 Mar 2022 14:25:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Phil Sutter <phil@nwl.cc>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH nf-next 2/6] netfilter: nf_tables: Reject tables of
 unsupported family
Message-ID: <20220315142521.38aebb28@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <YjDyuU44RhSDCHy7@salvia>
References: <20220315091513.66544-1-pablo@netfilter.org>
        <20220315091513.66544-3-pablo@netfilter.org>
        <20220315115644.66fab74b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YjDxoXbCfnPVrxT2@orbyte.nwl.cc>
        <YjDyuU44RhSDCHy7@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 21:10:33 +0100 Pablo Neira Ayuso wrote:
> > > 	return (IS_ENABLED(CONFIG_NF_TABLES_INET) && family == NFPROTO_INET)) ||
> > > 	       (IS_ENABLED(CONFIG_NF_TABLES_IPV4) && family == NFPROTO_IPV4)) ||
> > > 		...
> > > 
> > > would have also been an option, for future reference.  
> > 
> > Yes, that is indeed much cleaner. I wasn't aware of this possibility
> > using IS_ENABLED. What do you think, worth a follow-up?  
> 
> CONFIG_NF_TABLES_INET and CONFIG_NF_TABLES_IPV4 are never modules, I
> think IS_ENABLED is misleading there to the reader.

It's not about being a module, IS_ENABLED() is usable in C code, 
no need to use the pre-processor. But your call, obviously.
