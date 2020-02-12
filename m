Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65EA215A1FB
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 08:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728295AbgBLH2Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 02:28:24 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:38494 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728186AbgBLH2Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 02:28:24 -0500
Received: by mail-wm1-f67.google.com with SMTP id a9so904290wmj.3
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 23:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HTrgQ3P1cf4ZUZVFCW3Bahhnw7i7qBXr8oj5GqEJ20U=;
        b=LJldhTv2toHFv878dcTq6+0KnFf1DQNrCNn+F2Y+JURW3Ayb+fsPKNCtLXHroLuA7S
         K8eDTmBHh6w5v1wsfMRy5eS965TXaOG+SpT9ihu+8ewqTRX58yHx6/JE/Kg6/DlWDyes
         oJnNbRHHYG/LZ0ShbYFavj+TwvdTxAWL2ZuJC1YVqcn/UXqPlBF9vjJCnZ8XGp/zbv0g
         crB1NCqC6fFqBBdqzTl2aBllsY0eluazdwRst6eOZ4qMAPpEgbUOXmEXqrQDC4z8iyMK
         x2pav0yJHkil3XcKZtGrGDM6SUHHKcPtBjZ99bvrrF4MNp0ZbQKNZdhkQ5nkqf7fTRNu
         cKGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HTrgQ3P1cf4ZUZVFCW3Bahhnw7i7qBXr8oj5GqEJ20U=;
        b=REQz6Et/csQHez4+CxeQkBbv9sGUALmbOghhXgwJxPRbqanmp+PPuIB17rZltQ1xrt
         LtCYPofUFvXYCUAN/OXPCtPJn9zMiRippIc0XbW5Cy/nKTY/cGituyuDLrBooTKDxXLH
         iFXZfzV9SkBnf01NYq22fZKM3xp3dXZ2UQxjB6+6u3kNmPVZprTChZ6qaCg4HVbEGFCF
         Ljh55WeC5sRMilNzxkxr0MOf/Nt0Ug34kXlErIjTgduJ/HPCH3zZJrD6ZN3daq6OX9VM
         CgJFkTQT79B+PLZdvnKLvfat1tCcAOoeG3nAOqR/bMywvMsBXEcQiZ96EgAHgDEL7sh2
         m9vw==
X-Gm-Message-State: APjAAAW/D404TXWbkRpMPIYKfSXcIYTMFPw6EA2eAx6RD2/zxpJAhqr9
        94NxuJlVBgNCapZ1yCBjV/ixaQ==
X-Google-Smtp-Source: APXvYqzeZF96f/pHRZp5hQYdZ1jplaYuNeEouwvecNC2oSv6Xu1ycQF4iSxTpmTxUxQP6qepHczGVg==
X-Received: by 2002:a1c:9646:: with SMTP id y67mr10787269wmd.42.1581492502678;
        Tue, 11 Feb 2020 23:28:22 -0800 (PST)
Received: from localhost (ip-89-177-128-209.net.upcbroadband.cz. [89.177.128.209])
        by smtp.gmail.com with ESMTPSA id w19sm6830723wmc.22.2020.02.11.23.28.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 23:28:22 -0800 (PST)
Date:   Wed, 12 Feb 2020 08:28:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     Amir Vadai <amir@vadai.me>, Yotam Gigi <yotamg@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net/sched: matchall: add missing validation of
 TCA_MATCHALL_FLAGS
Message-ID: <20200212072821.GB22610@nanopsycho>
References: <cover.1581444848.git.dcaratti@redhat.com>
 <7e829916e02af56770745c30cac8cb3fc9dfdc5c.1581444848.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7e829916e02af56770745c30cac8cb3fc9dfdc5c.1581444848.git.dcaratti@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Feb 11, 2020 at 07:33:39PM CET, dcaratti@redhat.com wrote:
>unlike other classifiers that can be offloaded (i.e. users can set flags
>like 'skip_hw' and 'skip_sw'), 'cls_matchall' doesn't validate the size
>of netlink attribute 'TCA_MATCHALL_FLAGS' provided by user: add a proper
>entry to mall_policy.
>
>Fixes: b87f7936a932 ("net/sched: Add match-all classifier hw offloading.")
>Signed-off-by: Davide Caratti <dcaratti@redhat.com>

I was actually about to send these :)
Thanks

Acked-by: Jiri Pirko <jiri@mellanox.com>
