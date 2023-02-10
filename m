Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE565692509
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 19:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbjBJSJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 13:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbjBJSJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 13:09:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855725EA37
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 10:09:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E73CB61E7A
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 18:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABE1C433EF;
        Fri, 10 Feb 2023 18:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676052557;
        bh=33amu1zTy/Xf6aKy06r6+OgrO3XjIQD+q1WIa/wm2CY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fdyvCuzsT/YeXeUyubpqr9mnejNkPyRsck/Kf55LcnCEQC1HncupwWEuTjhxZaqVM
         YsMTvV1LL75uqYQV6cMp/vBH9apvQ9+InWb3GENdPkR72XC9i5lfIYREB050FgtXgj
         Nx/rEjIMBWIl17emj99931Xw4xMaDkQ08E4WsBtryfRVgP/nbevulaTms1DetmTC3u
         8JWQExzY+id2YdBjLV7YFy7DD8ZzKoiksJjdOTihYeb/RJtVOaeFEG+RqXrCla9RXv
         grhBmESGpZzcAU8KfnjunM8aJBipcVbbWZRiYABoLxJpk4TUH6CPrSWWVHR1fTn8be
         IQRdoiBxsRf4A==
Date:   Fri, 10 Feb 2023 10:09:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chuck Lever III <chuck.lever@oracle.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Message-ID: <20230210100915.3fde31dd@kernel.org>
In-Reply-To: <EB241BE0-8829-4719-99EC-2C3E74384FA9@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
        <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
        <20230208220025.0c3e6591@kernel.org>
        <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
        <20230209180727.0ec328dd@kernel.org>
        <EB241BE0-8829-4719-99EC-2C3E74384FA9@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Feb 2023 14:17:28 +0000 Chuck Lever III wrote:
> >> I don't think it does, necessarily. But neither does it seem
> >> to add any value (for this use case). <shrug>  
> > 
> > Our default is to go for generic netlink, it's where we invest most time
> > in terms of infrastructure.  
> 
> v2 of the series used generic netlink for the downcall piece.
> I can convert back to using generic netlink for v4 of the
> series.

Would you be able to write the spec for it? I'm happy to help with that
as I mentioned. Perhaps you have the user space already hand-written
here but in case the mechanism/family gets reused it'd be sad if people
had to hand write bindings for other programming languages.
