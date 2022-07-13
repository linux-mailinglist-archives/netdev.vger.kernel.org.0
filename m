Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB26C57327C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 11:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235235AbiGMJaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 05:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbiGMJaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 05:30:22 -0400
Received: from nautica.notk.org (nautica.notk.org [91.121.71.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE8DEA14B;
        Wed, 13 Jul 2022 02:30:20 -0700 (PDT)
Received: by nautica.notk.org (Postfix, from userid 108)
        id 630BAC01E; Wed, 13 Jul 2022 11:30:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657704619; bh=XyyU3O64rDkO8/f2a3m3jX9KEixUXahN8Gy8KrqClvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ywjF/D7wS9OjyHt7BVsHv8plzVxUgPhiLUbbuDrVr+l86vFhwsSdmzRN/n3MdDngr
         Vs9r39e8bUveHcJQX4iZtN55K3A1EsjrBEJ3nDXTcZ2BibWxxDOdzhbqu3UODbw4tg
         /xz0pHcBLid8jOx4xR9VyOG0hmUpkVsnKUL/pL59MXfYMGfosHxgeYZ9p3rg4KEscS
         NmJqUkmYNVcOcOpbom8yF2GQYNeBwrudIVzmwWH/evM9enn9urkzvnbgmgVSAfQ6eh
         F3Kun4ICWzmlDkQoQUZz1/d/NHyJ8PIkPBpPUleYgZkMFTPRSDzvflwF8XMT9ReyZF
         EDMzPrt+SFtpA==
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
Received: from odin.codewreck.org (localhost [127.0.0.1])
        by nautica.notk.org (Postfix) with ESMTPS id 95E8CC009;
        Wed, 13 Jul 2022 11:30:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org; s=2;
        t=1657704618; bh=XyyU3O64rDkO8/f2a3m3jX9KEixUXahN8Gy8KrqClvI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rYO8C5GjfkKJ+X/feO2QzbNu6ngje6EbwAFN1jEj21OCsmiZTu17br7qeEX2K8rSr
         dcRZHU98JNDdp9rvwdMWHv7XSNd904sxppru0+k32zTMNCuV5fl2U9OT0gAIMAt1jo
         XuczTc0MJNI+/IRRaaqEOSGmrhfPJsDiwscIWWMf6m+dvCA3VLsfigqdrsAlps+bHd
         5cHU4p01321IodbGxBQO77L1yexoCKPU3YddWbWZxTFlNuBsEnTEq8udfTjXhmjOKy
         yvxpDSl7fFoJZbL8xu//YxzMMYdMOH11W5BJ5oRmb+sXAo3bGwuEDM+N9EsgOLJ+q5
         ZeXYvPbZFKyrQ==
Received: from localhost (odin.codewreck.org [local])
        by odin.codewreck.org (OpenSMTPD) with ESMTPA id dd90f3c2;
        Wed, 13 Jul 2022 09:30:12 +0000 (UTC)
Date:   Wed, 13 Jul 2022 18:29:57 +0900
From:   Dominique Martinet <asmadeus@codewreck.org>
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     Latchesar Ionkov <lucho@ionkov.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        Nikolay Kichukov <nikolay@oldum.net>
Subject: Re: [V9fs-developer] [PATCH v5 11/11] net/9p: allocate appropriate
 reduced message buffers
Message-ID: <Ys6QlcShhji2sx9V@codewreck.org>
References: <cover.1657636554.git.linux_oss@crudebyte.com>
 <Ys3Mj+SgWLzhQGWK@codewreck.org>
 <Ys3jjg52EIyITPua@codewreck.org>
 <4284956.GYXQZuIPEp@silver>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4284956.GYXQZuIPEp@silver>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christian Schoenebeck wrote on Wed, Jul 13, 2022 at 11:19:48AM +0200:
> > - for this particular patch, we can still allocate smaller short buffers
> > for requests, so we should probably keep tsize to 0.
> > rsize there really isn't much we can do without a protocol change
> > though...
> 
> Good to know! I don't have any RDMA setup here to test, so I rely on what you 
> say and adjust this in v6 accordingly, along with the strcmp -> flag change of 
> course.

Yeah... I've got a connect-x 3 (mlx4, got a cheap old one) card laying
around, I need to find somewhere to plug it in and actually run some
validation again at some point.
Haven't used 9p/RDMA since I left my previous work in 2020...

I'll try to find time for that before the merge


> As this flag is going to be very RDMA-transport specific, I'm still scratching 
> my head for a good name though.

The actual limitation is that receive buffers are pooled, so something
to like pooled_rcv_buffers or shared_rcv_buffers or anything along that
line?

--
Dominique
