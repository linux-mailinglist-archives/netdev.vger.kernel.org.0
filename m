Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AFD692BCC
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:11:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjBKAL5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:11:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjBKALz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:11:55 -0500
Received: from nautica.notk.org (ipv6.notk.org [IPv6:2001:41d0:1:7a93::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86381043E;
        Fri, 10 Feb 2023 16:11:52 -0800 (PST)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 7E3A0C009; Sat, 11 Feb 2023 01:12:12 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1676074332; bh=3EJFrpGxIuEHBMCx0npPppHhZZJ6DpJG62GSSPqpbEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VCqYscMcnrVHY8wYyeFNVJ+rD/Pbez+zCH0ZjwvVkbnPWsk3TBDR4C2vFj9iQYe76
         hGu38vxpd+B/3kTpD63FFPrPhAg86XzTa4D0qMM9PSe8QRo8++akfIw7h0t7t3ynqn
         l9D0XZwvOyEft0ER0dRircJu148jZkEngOxk0z4EBhLh00dr1s1YifdBeYYEd/BD9M
         PeTjwwY9AOnJpP01FV4+Wi7sPrpDja8Zp8mBWKJLXS0pGC6N8KLoKPmKI/6ZcYzjEu
         YnOoZwkd6afkMLNJKsaK27Wt35Hd3NYQbGWx1uaBct4gVHNp4D54hnMyPhrTIjQQW/
         BqX6mSwumazfQ==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 28F22C009;
        Sat, 11 Feb 2023 01:12:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1676074331; bh=3EJFrpGxIuEHBMCx0npPppHhZZJ6DpJG62GSSPqpbEw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1/KBbjO7L22L7kRw+OQSRpx/J47Qtrc/0Bq8co0Aw/fAjseO0khb1g+DfDo9Y425s
         bswygOvv1mR26b65unK17ejqXnS2AYCSrbkyLPvW0DezyQ5TUDF/CXRQATdxYrRBU6
         4I2xps/v+r7O8ZB6OA3j/Kp2YfMQBSeTGgNcNLW3aXBvMJXCC6mZj/59RLKx5IJqws
         2jWUVZDjVm+iNCMwr3o7UPtBpZFwUUbq301yvr6+ii7MxDPOaQ4IaX1VLUMUfxBRMQ
         0DCdLpk8nGvX+35dXDWntQmq9/kMV5D3eUsiyEBJkwZVsocPELV7ZPt4ywrxP6qnsn
         1al1lBjDDocEw==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id 34ae1f8d;
        Sat, 11 Feb 2023 00:11:42 +0000 (UTC)
Date:   Sat, 11 Feb 2023 09:11:27 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Juergen Gross <jgross@suse.com>
Cc:     Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 1/2] 9p/xen: fix version parsing
Message-ID: <Y+bdL74W+qTzRRn7@codewreck.org>
References: <20230130113036.7087-1-jgross@suse.com>
 <20230130113036.7087-2-jgross@suse.com>
 <Y9liesGIeKFkf+tI@corigine.com>
 <bf452f47-8874-09a9-2d74-6a2ad5bea215@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bf452f47-8874-09a9-2d74-6a2ad5bea215@suse.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Juergen Gross wrote on Wed, Feb 01, 2023 at 07:37:04AM +0100:
> > It's unclear if this series is targeted at 'net' or 'net-next'.
> > FWIIW, I feel I feel it would be more appropriate for the latter
> > as these do not feel like bug fixes: feel free to differ on that.
> 
> I'm fine with net-next.

It doesn't look like it got picked up in net-next, so I'm queueing it up in the
9p tree.

Thanks for the patches and the review!
-- 
Dominique
