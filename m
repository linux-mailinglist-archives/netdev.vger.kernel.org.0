Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DD172CC8FD
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 22:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387947AbgLBVdg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 16:33:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387821AbgLBVdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 16:33:36 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B86C0613D6
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 13:32:55 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id l5so5578053edq.11
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 13:32:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=daez4vAizbC4hQl5r0kAqfih/BXhmh9GDGQgEEjoTy0=;
        b=Iu/xN/FBT/Z8pxA5JBjd2Nlxj/x1gvJXLBJn9y5vbw/46aiBHqntSRyhGjy3cceX56
         TBrXP4L342X2NYSkO9MDumH4eBp0HCV6VQwdP7N7yIwQHOhn9o8QETOgpgudhEUJ6UrF
         6BXlU1pHjvBu5C1eXDH5Hq4SpDw0Qi6e9dFcTqZkqkjD1q5VSDkKEzp/nbgqvvY8QQKt
         ScHeZ/0JqNLWOYSpyY07rOiA1OX8Lrsw9cLqSjMGtgUwflTn9ozfu5GX1rbJoxhyibTO
         6eQPRnvDOLM+j+F+qYvmbA5uqRViuyhAGOXArzEe/vowpoJUyluSdgyWNdl72rtnFRBy
         dycA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=daez4vAizbC4hQl5r0kAqfih/BXhmh9GDGQgEEjoTy0=;
        b=BV89NR9jSjC5xztvhRt10quOJ+TpbRMCzkzcCd8vK+Nq3wBYDZ3fVC+gbnOIdhsHz7
         l39WxTp8/CIt+wXcHicLtqov8yHw+bItuGjTkoCXPgg+7imYeV2B5YmhajT2PLcGVT4M
         VGuV6amlUBzwwpD2SzSsVMOjpUcrgnMd44NYHZigLwFf12g9zYZJCv+dnhRRarzjSU0b
         d4Ko1UoZ3qxFymKVS6YxnbJMNl+ElSWEsJa078nB77Z5m1icTbcAfsKWNpUpMN1ODNdl
         HU6+mGAej3LocB+GFh+Jtm0qP36ylkwridFf1RvMDhl6NwOUOKbyOYAAn+Qm7Mee+Xas
         4dtA==
X-Gm-Message-State: AOAM532NnlisvXRN8EXcNDDdGBBwJHI7SAAcekY/P2w7/WkqVlKneWKd
        OAMTiFa++4ybA0YVpCXXX6w=
X-Google-Smtp-Source: ABdhPJyHWEvpHlnPbhkNh1dmweoCNQRy0h+yj4DW5IEy3Lf5Qg1Qm/4w/sRRJ8Ux71z9Jeydyo47Tg==
X-Received: by 2002:a05:6402:1692:: with SMTP id a18mr601edv.321.1606944774334;
        Wed, 02 Dec 2020 13:32:54 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id k23sm671086ejs.100.2020.12.02.13.32.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 13:32:53 -0800 (PST)
Date:   Wed, 2 Dec 2020 23:32:52 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201202213252.57yx5slwk6ru3npz@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201202105820.4de653a2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <87k0tz7v7h.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0tz7v7h.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 02, 2020 at 10:29:38PM +0100, Tobias Waldekranz wrote:
> Sorry about this. I missed an rtnl_dereference in the refactor between
> v2->v3. I have now integrated sparse into my workflow so at least this
> should not happen again.

Please do not resend right away. Give me one more day or so with the
current series to really digest it.
