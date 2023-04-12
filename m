Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D93676DFEC7
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 21:37:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjDLThW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 15:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjDLThV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 15:37:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA8E62136;
        Wed, 12 Apr 2023 12:37:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61EFB62C91;
        Wed, 12 Apr 2023 19:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BF7C433EF;
        Wed, 12 Apr 2023 19:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681328239;
        bh=YdA6xgVDMTsi6jbxImRni18coXjbrnh0VRM9FC3CJx4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Pi1onOod7InvwJqqgwwAKKZgJBiNDRm4johlj/xBBOXnxKqrXyYFdGP7ejq1cA+h7
         hUkrZCn/PtOcwDGFNbcWKLAxGJf24d3BH63jPUIG9EDWLn9J4piTeZEXbe5V2EoI4a
         vv4qDBVOR1GhvqA5rA0SI6Ooh4Gd0K8lgckdi39g5xKZWL7cDkrGfqTj6IwtxA/mYx
         e7w/YamddrbpJzOpECn2e8nUVKBHYspjWKZDdZw1RMTTUDZQQ1D5UtL8l5d1d2gZuM
         QnStOpq4LHuK8GPPeXkwaiWeTfq9ErdzEHMXBUuX00vZNW5rsmpNGzNd6qSU0f3eZE
         Do1F8dNutgSiw==
Date:   Wed, 12 Apr 2023 12:37:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com,
        mathew.j.martineau@linux.intel.com, mptcp@lists.linux.dev
Subject: Re: [PATCH net,v2] uapi: linux: restore IPPROTO_MAX to 256 and add
 IPPROTO_UAPI_MAX
Message-ID: <20230412123718.7e6c0b55@kernel.org>
In-Reply-To: <7405c14e-1fbe-c820-c470-36b0a50b4cae@tessares.net>
References: <20230406092558.459491-1-pablo@netfilter.org>
        <ca12e402-96f1-b1d2-70ad-30e532f9026c@tessares.net>
        <20230412072104.61910016@kernel.org>
        <405a8fa2-4a71-71c8-7715-10d3d2301dac@tessares.net>
        <ZDbWi4dgysRbf+vb@calendula>
        <7405c14e-1fbe-c820-c470-36b0a50b4cae@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Apr 2023 18:35:40 +0200 Matthieu Baerts wrote:
> > Is this theoretical, or you think any library might be doing this
> > already? I lack of sufficient knowledge of the MPTCP ecosystem to
> > evaluate myself.  
> 
> This is theoretical.
> 
> But using it with socket's protocol parameter is the only good usage of
> IPPROTO_MAX for me :-D

Perhaps. No strong preference from me. That said I think I can come up
with a good name for the SO use: SO_IPPROTO_MAX (which IMHO it's better
than IPPROTO_UAPI_MAX if Pablo doesn't mind sed'ing?)

The name for a max in proto sense... I'm not sure what that would be.
IPPROTO_MAX_IPPROTO ? IP_IPROTO_MAX ? IP_PROTO_MAX ? Dunno..

> More seriously, I don't see such things when looking at:
> 
> 
> https://codesearch.debian.net/search?q=%5CbIPPROTO_MAX%5Cb&literal=0&perpkg=1
> 
> IPPROTO_MAX is (re)defined in different libs but not used in many
> programs, mainly in Netfilter related programs in fact.
> 
> 
> Even if it is linked to MPTCP, I cannot judge if it can be an issue or
> not because it depends on how the different libC or other libs/apps are
> interpreting this IPPROTO_MAX and if they are using it before creating a
> socket.
