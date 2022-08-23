Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E301359CE4E
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 04:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239513AbiHWCFd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 22:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbiHWCFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 22:05:24 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92228EE0C;
        Mon, 22 Aug 2022 19:05:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E3529CE18BD;
        Tue, 23 Aug 2022 02:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F330FC433C1;
        Tue, 23 Aug 2022 02:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661220319;
        bh=kVz4/InvVmPv9aWoWcfmHxMeNwvCrj4CtbBICo0yzzU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o675e59m35rPVm1/jQYPfx0tfYrKjj+369hZ33Pxg91LXfzaBs+zUD39MjmOC7rRT
         MdLSqo7lXztFZhE8gVheF8rpqYWqvrRDSOVCZCq/2xzxceWA0eLozZkfgp8ZK4Dhd7
         ig2Dy5+keI+3l/GgM8asbY+JgLZwQdeHmz1/woAmtFPx3IfsompBZ3R3otxJWwnuU2
         ofxo6lgaom4BHb2HXv/PxVxMmM9cpEZl/p3D+eHEqbBUHTaxCiH2DVLi5mvTkvQulJ
         wX0uGOsI8a5TObKAdUyeKpzQ/ROnT36CqiySSeu8BcitI2mDZIWj+67g3/RNzYdqP/
         SA3jTYNkBm+fg==
Date:   Mon, 22 Aug 2022 19:05:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn
Subject: Re: [PATCH 0/3] Namespaceify two sysctls related with route
Message-ID: <20220822190518.67459ae3@kernel.org>
In-Reply-To: <20220822045310.203649-1-xu.xin16@zte.com.cn>
References: <20220822045310.203649-1-xu.xin16@zte.com.cn>
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

On Mon, 22 Aug 2022 04:53:10 +0000 cgel.zte@gmail.com wrote:
> With the rise of cloud native, more and more container applications are
> deployed. The network namespace is one of the foundations of the container.
> The sysctls of error_cost and error_burst are important knobs to control
> the sending frequency of ICMP_DEST_UNREACH packet for ipv4. When different
> containers has requirements on the tuning of error_cost and error_burst,
> for host's security, the sysctls should exist per network namespace.
> 
> Different netns has different requirements on the setting of error_cost
> and error_burst, which are related with limiting the frequency of sending
> ICMP_DEST_UNREACH packets. Enable them to be configured per netns.

I'm not familiar with the IPv6 implementation either, but someone needs
to explain to me why the knob is important in v4 while entirely absent
in v6. On the surface this makes no sense. There may be a good reason,
it just needs to be stated.

Also from the patches:

Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>

Bots / teams can't sign off patches, I've been over this with your
colleagues. Please put your team's name in your signoff, e.g.

Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>

Thanks!
