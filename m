Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5854A7F1F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 06:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbiBCFbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 00:31:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41382 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiBCFbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 00:31:38 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B882616EA
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 05:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D8C6C340E8;
        Thu,  3 Feb 2022 05:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643866297;
        bh=OK6HOr2wznl0TLGlEwe0ZWI6hjUohAs6dKZiCK7BRvE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Q4flXFeaFv/1owGsRioEC5qwRI8tR1qakZAI3eJqy2iqYznsmiJEFWv7MqEozVmCv
         f7guO54CK0p0kUx5Bb4Yhj6B2DNbirwSykUm5oBwZERid84rkFMSnPv4hrCJvgFfd6
         aAztBTWKACYIox9pWlyijVcsA0Y4hLmwwLGhIwtEtQJ28oQY+AbWhhAD+lT/6kKjYD
         NaqKBWGr+wRcPXFztXo0brCn9KAUim8j8w51tcs6t3OYNO5OJ1VtjuG7XyJpiUTssK
         H1d1051d1t9QlKXxI0K0ULxS0JqcsJ3DZ8nkdtAQe5KBhRrrP+BjCV84AP0iBb6R78
         dKfKbDVOEGqsQ==
Date:   Wed, 2 Feb 2022 21:31:36 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     kernel test robot <lkp@intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, kbuild-all@lists.01.org,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
Message-ID: <20220202213136.2890d767@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iJAkBXdmnU4FTO3MU2T+PxqkhFxKUpvp-q2uODurT6Wxw@mail.gmail.com>
References: <20220203015140.3022854-10-eric.dumazet@gmail.com>
        <202202031206.1nNLT568-lkp@intel.com>
        <CANn89iJAkBXdmnU4FTO3MU2T+PxqkhFxKUpvp-q2uODurT6Wxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2 Feb 2022 21:20:32 -0800 Eric Dumazet wrote:
> Not clear why we have this assertion. Do we use a bitmap in an
> "unsigned long" in skmsg ?
> 
> We could still use the old 17 limit for 32bit arches/builds.

git blame points at me but I just adjusted it. Looks like its
struct sk_msg_sg::copy that's the reason. On a quick look we 
can make it an array of unsigned longs without a problem.
