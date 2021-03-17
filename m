Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FC3E33F25D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 15:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231686AbhCQOOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 10:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231278AbhCQOON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 10:14:13 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9638AC06174A;
        Wed, 17 Mar 2021 07:14:12 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ox4so2826044ejb.11;
        Wed, 17 Mar 2021 07:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CUwDi4a79Hhe5kmDZ9gxq2DQopexhr9dA5acVFYVd9Q=;
        b=VggIyPWusAvbRMcgUzPjf+9KSrkCeQWSvj7+fXB1AmWFm+lIkbuGQIYTXevdj3pcxn
         mG/AatyjJUlPT34rmSz7nckdWKJRmxPUEBLMcI4xIlocOix1uh/JtpcYrZIcpAj2Cn//
         +OvQ7RJn+Nr4X0YSvaWC+QH3wy8PziXh/lloj5bafLiw9vE2ZBki30A/min/ygXZa4Y7
         7ovNLu6e8s7E8Luorn7zE7cJAlq2eMwmoqeeqetEuxGsGLbZ5K8ZE1AHoK13CeuIje2q
         UR15x46Q0wbnjHO2KDg2qnAdIGbzEvYFTLUCbtfoYD7UM1vQufw/dcPe4FsyHbcmLLQs
         kFjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CUwDi4a79Hhe5kmDZ9gxq2DQopexhr9dA5acVFYVd9Q=;
        b=covJ2vArVEE3+OLknZunS8TZGPPYCDLbgoewRg9bLD8EJA74G4SibFANkSz+jAQRUH
         v9rXZuLt/6QE6D9h5hajjeUh34XvYiu134Xfm0miI35P6EpoyZP0yQ0RqE9We1FVMDLA
         Z+ngOMmKlP+KPPVAVALX+Wckvk7+SEv9Ln4VytuA5THb18ySshjN0euzYtOt6VOczzRO
         XMySgkEanZMfH4R4RLnCcQI1SIOramG+/LxBccDkxDcG+DG8zFTn/x1nHHA/kJDbE+mc
         PEyZm5Jcc20cmDtOpe1zS5Am4kRL1bDppDtFfFWxItb4tyPyzgni3Wemv+t4d51NQWw3
         yTGA==
X-Gm-Message-State: AOAM530KK4l7DbaJu3Te3VvdqnI+8m19aaNN9eCNkN7tWY4J7ktG9S+B
        B/2+TW8nbKpDbvVLQagOSRM=
X-Google-Smtp-Source: ABdhPJwFk+sGdQiqAoNwxt4Xx8R1bZrWGJez3qiNg7mJsFb4kpWgzHZPXo+IaJmGUAZu0azZBBpZUA==
X-Received: by 2002:a17:907:110c:: with SMTP id qu12mr35884377ejb.442.1615990451047;
        Wed, 17 Mar 2021 07:14:11 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id g25sm12685740edp.95.2021.03.17.07.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 07:14:10 -0700 (PDT)
Date:   Wed, 17 Mar 2021 16:14:09 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, gregkh@linuxfoundation.org,
        sashal@kernel.org
Subject: Re: [PATCH stable 0/6] net: dsa: b53: Correct learning for
 standalone ports
Message-ID: <20210317141409.wphejdjznrfyebmq@skbuf>
References: <20210317003549.3964522-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210317003549.3964522-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 05:35:43PM -0700, Florian Fainelli wrote:
> Hi Greg, Sasha, Jaakub and David,
> 
> This patch series contains backports for a change that recently made it
> upstream as f9b3827ee66cfcf297d0acd6ecf33653a5f297ef ("net: dsa: b53:
> Support setting learning on port") however that commit depends on
> infrastructure that landed in v5.12-rc1.
> 
> The way this was fixed in the netdev group's net tree is slightly
> different from how it should be backported to stable trees which is why
> you will find a patch for each branch in the thread started by this
> cover letter. The commit used as a Fixes: base dates back from when the
> driver was first introduced into the tree since this should have been
> fixed from day one ideally.
> 
> Let me know if this does not apply for some reason. The changes from 4.9
> through 4.19 are nearly identical and then from 5.4 through 5.11 are
> about the same.
> 
> Thank you very much!

Florian, same comment I just sent to Tobias applies to you as well:
could you please call b53_br_fast_age when disabling address learning?
