Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34138280963
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 23:25:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732836AbgJAVZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 17:25:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726626AbgJAVZq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 17:25:46 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6ACEC0613D0
        for <netdev@vger.kernel.org>; Thu,  1 Oct 2020 14:25:46 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id i3so47682pjz.4
        for <netdev@vger.kernel.org>; Thu, 01 Oct 2020 14:25:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cQBYhjCFO9RMoYSUCsYvbpJht7oVwjHoDy5V5qwzfMA=;
        b=r2qCyTxiCloY2P6yVgJyVcAMjYUm4z/B/Kp2t2ISskkg1ecTziJJ0JWE23i1KFAocv
         6+ONQCl9cCKQtFwSttWsgXkPRWtIjP4R+zhvVuKBUZk1WGJ43B7gW9tBz7xY3VODIS2e
         KU6Mj3hZzDbCXDPeks6YTgh5tm3T8N8ygyJ7fr2QzrE4+eSJJ13LQBVwyGnoRB3ssgf6
         LX8Oh4/lH1ggA5F0/Im53RrqZ7sqiAcwVfOsGdjTrQ/fnaoVALZZV2g/eqRIhAp0Yk4c
         dibvTB9b1hIjpHJdsX//GTpjJEuL7Ds5Wl+t/waCHF/KuT2GG0Iaw0wj6q65hUjIDp/P
         Hsaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cQBYhjCFO9RMoYSUCsYvbpJht7oVwjHoDy5V5qwzfMA=;
        b=HhME+LQu9UhIE++7xO61VedprPywO+Up+4HgbvlJpioIciJhKagUGx66DvazK5rlWn
         4rctpuwFqCPXjDnA9f3VTZ3K+U9qzQk59BBaWnlMk8sIwW5hj9u5+bQOXBZYqDW41gLH
         SgVVIbFznAghva35Vejn7Pqp56PKpabzHN/ijLdDvvVUaGdB6y8p0GHO24NdUaFMwgDf
         xI2qqSfREnWb8IAn1o1LPRZWhlMkJ3hd0NHBVFgcZH2JU52vvTA6SVBylOCKf3cFKjgx
         8EkOheiUfQqskZ07xrjo5S8kK+p5ziU+cQQJbrn9bzKwLfJtFye9kUvOvz23fPXrO8n9
         Ci/A==
X-Gm-Message-State: AOAM5329Rxog2MF4I6nkoxT0BZGBfwEmtM8LBsMpkfkV+udK0x0Ldiqn
        9I/wc/l2Ix6ARNm4SzP8VvSjXQ==
X-Google-Smtp-Source: ABdhPJz0cU3AoiiPJf8EI9/hexRoeRORSA/B4+N6i7S/vFAvf+LEpUqmkh38VpO4BoDN1pv3hHrhCQ==
X-Received: by 2002:a17:90a:c381:: with SMTP id h1mr1869610pjt.225.1601587546377;
        Thu, 01 Oct 2020 14:25:46 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z4sm7144647pfr.197.2020.10.01.14.25.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 14:25:45 -0700 (PDT)
Date:   Thu, 1 Oct 2020 14:25:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>,
        Antonio Quartulli <a@unstable.cc>,
        Sven Eckelmann <sven@narfation.org>,
        b.a.t.m.a.n@lists.open-mesh.org, Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>
Subject: Re: [PATCH net 00/12] net: iflink and link-netnsid fixes
Message-ID: <20201001142538.03f28397@hermes.local>
In-Reply-To: <cover.1600770261.git.sd@queasysnail.net>
References: <cover.1600770261.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 09:59:24 +0200
Sabrina Dubroca <sd@queasysnail.net> wrote:

> In a lot of places, we use this kind of comparison to detect if a
> device has a lower link:
> 
>   dev->ifindex != dev_get_iflink(dev)


Since this is a common operation, it would be good to add a new
helper function in netdevice.h

In your patch set, you are copying the same code snippet which
seems to indicate that it should be a helper.

Something like:

static inline bool netdev_has_link(const struct net_device *dev)
{
	const struct net_device_ops *ops = dev->netdev_ops;

	return ops && ops->ndo_get_iflink;
}
