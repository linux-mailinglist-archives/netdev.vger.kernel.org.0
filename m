Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7BF1DC303
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 01:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728068AbgETXjT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 19:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726697AbgETXjS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 19:39:18 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B934C061A0E;
        Wed, 20 May 2020 16:39:17 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id m44so4094210qtm.8;
        Wed, 20 May 2020 16:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=usgVE9wGsTmR3Ul4KmzuJXmMmNEoxcCV+K4pKCDDnEw=;
        b=FsipvN1GuGM9UbR7VsW4XkubLiUqC8Dqtu7L937s2qadx/bxbgPsMl9fWYiJlizujH
         c9qxkVWOxpVMlAT7nNkHzdOL6XRXbCOpar1C4DQC47Sws3swXaaqI9YAuQyLubSZ0OK0
         rRko/wzRAKCkIy15w/nWQBRVBLwMvtGjJCE2gisIPTfPY2zdgnpj1FMzVNCnVI10QH79
         YBAX7tezDRj2K0TOr70GJg9yP9kYgu14VxvOjzih8uvep1FVSB5EojcU0QtKwd0T+IdB
         hjRKTNxmgJ9liw0vUGr1peJpzaW/R/f+lsktCjxXTndLxOoBi3/frCJqvNi3QaPXR6GX
         kpaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=usgVE9wGsTmR3Ul4KmzuJXmMmNEoxcCV+K4pKCDDnEw=;
        b=NX+9uVe/yO0GL9KKvOXOHz5GefBwZRpFfy0UuHRq/9fs+d7Q54crmTq+eztKuFh4KV
         mrzbWrwiEF2044382M3G9Q8ipjtasHXxaTgrRfrg1RYxTHCm7fS2H2ArcoYXKnToO3dE
         Om5GFMxY/+u7KqgCb9kq2W2sZVymiitDmKy4DA3wEseC06UIt+1E1DK+wY4U3jydrwmv
         LXqXEbW0BXFdo6Bm0kQ6Ryvi6DPK/2qKTmhxkiPfs4/05L4icxx3gP9RTEARQkq0U2pn
         RQMMLV+aRGJoxOYKx6cq2unZSbgeV9mINAar97dF/XXoKCwgN0KU5W5FXpfdXXnNWSQd
         Y8fw==
X-Gm-Message-State: AOAM530kitqhp7j8IZQRRpzIFXJBDZpaIJprNSrFUZrdCEHBVWeplmTB
        C59Pm4gBUHx/XTUg8i+HSa8=
X-Google-Smtp-Source: ABdhPJzb0RQavdlFPdZ2esbonBQnAnxuJh+Wdn80ZrxdL0NcIMXKvb5xhinFWySzKcTGVqX7yVkgxA==
X-Received: by 2002:ac8:1af3:: with SMTP id h48mr7625941qtk.371.1590017956516;
        Wed, 20 May 2020 16:39:16 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.225])
        by smtp.gmail.com with ESMTPSA id z10sm3685208qtu.22.2020.05.20.16.39.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 16:39:15 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 43E1FC0DAC; Wed, 20 May 2020 20:39:13 -0300 (-03)
Date:   Wed, 20 May 2020 20:39:13 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     David Miller <davem@davemloft.net>
Cc:     hch@lst.de, kuba@kernel.org, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com, jmaloy@redhat.com, ying.xue@windriver.com,
        drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-nvme@lists.infradead.org,
        target-devel@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-cifs@vger.kernel.org, cluster-devel@redhat.com,
        ocfs2-devel@oss.oracle.com, netdev@vger.kernel.org,
        linux-sctp@vger.kernel.org, ceph-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-nfs@vger.kernel.org
Subject: Re: [PATCH 31/33] sctp: add sctp_sock_set_nodelay
Message-ID: <20200520233913.GV2491@localhost.localdomain>
References: <20200520195509.2215098-1-hch@lst.de>
 <20200520195509.2215098-32-hch@lst.de>
 <20200520231001.GU2491@localhost.localdomain>
 <20200520.162355.2212209708127373208.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520.162355.2212209708127373208.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 04:23:55PM -0700, David Miller wrote:
> From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> Date: Wed, 20 May 2020 20:10:01 -0300
> 
> > The duplication with sctp_setsockopt_nodelay() is quite silly/bad.
> > Also, why have the 'true' hardcoded? It's what dlm uses, yes, but the
> > API could be a bit more complete than that.
> 
> The APIs are being designed based upon what in-tree users actually
> make use of.  We can expand things later if necessary.

Sometimes expanding things later can be though, thus why the worry.
But ok, I get it. Thanks.

The comment still applies, though. (re the duplication)
