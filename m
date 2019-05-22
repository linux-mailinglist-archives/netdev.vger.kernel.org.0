Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2EF268F2
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:15:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbfEVRPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:15:31 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:36153 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728638AbfEVRPb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:15:31 -0400
Received: by mail-qt1-f193.google.com with SMTP id a17so3302277qth.3
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 10:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mtLrTvKLtyIH87Z35BeVR4rLask8PhbsT3FWaUVImUQ=;
        b=foOaqQ6GQ4lBWEKS2XjlpG/wYhyYtRFA9FoqjTcdUCkKfCNNDYZUJZ2iYPELerllTO
         prdWodJnC9VJkHrkVORBffZodRwUknY38YXMyucfrUd+2cHk9b5WPqDTQhkHNGpYPrOu
         W2i+D8+Y8iLEtn9YNczEoxs8IYjdRTYKcQIlbqQKBodxQPQOg35a9Vl0WGprr8MlaWSj
         9tgk+JTIEFmiI68LOnm/JJqHC3yxx0njQwvXgmpJXnc49geOSn6mC7DxN/TTrldN6zA8
         ikVuoTdiwa//gpKviWG4n0yXYrbDUsmzaX1URcWsPVofI2evTXOAxF7mUdDpPsIWd7kG
         I4iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mtLrTvKLtyIH87Z35BeVR4rLask8PhbsT3FWaUVImUQ=;
        b=alO9j/NEIJErdmiQBUGxs7fqa4QxuFFYVf/9zFPYEVC7i0jfymLawJLVlPl0UymxlN
         ZEsdRpaO+DzTsI/1xTHzPTVdpcvFJCux9k40tni2JPIAizbVhslysOurqwW8eOWtvoPK
         tRWRTg1A9vUVR3VlcnS0Dq0gnzOqgOHpPOtLseDjBnYqqHUub1he/VIIv2aEhEidqoTp
         GUkbx0W8NC/t1sIwX4fZoLzdNcH/RpsOImfrIJbl+zZqp/AXAgyMyULzW5s46PcjNIZO
         Y44Ck7o8eL2riFeu8u4OcqC7XetK/2R54uyHfNMkddQLUNz+omdHarHpZ6pw4p1AkqKD
         001Q==
X-Gm-Message-State: APjAAAWDFd+IOJwNeR8JrkfBSt+cpcTuf4RENTHUK5IedL5PWT2y3YyJ
        6mA9qow3VJWXG7WE+8ZBD+S1GTmKw3I=
X-Google-Smtp-Source: APXvYqws7CXOqSdeK+lbybAIxEJLSWubLP1GR3bdf+NFTe+BFHBAwnhIP+Qlaass2qKpfOsGf2JbBA==
X-Received: by 2002:a0c:96b9:: with SMTP id a54mr27957008qvd.135.1558545330387;
        Wed, 22 May 2019 10:15:30 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id h16sm13602017qtk.1.2019.05.22.10.15.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 10:15:29 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hTUpt-0003zl-IP; Wed, 22 May 2019 14:15:29 -0300
Date:   Wed, 22 May 2019 14:15:29 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Majd Dibbiny <majd@mellanox.com>,
        Mark Zhang <markz@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH rdma-next v2 06/17] RDMA/counter: Add "auto"
 configuration mode support
Message-ID: <20190522171529.GC15023@ziepe.ca>
References: <20190429083453.16654-1-leon@kernel.org>
 <20190429083453.16654-7-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190429083453.16654-7-leon@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 11:34:42AM +0300, Leon Romanovsky wrote:

> +/**
> + * rdma_counter_unbind_qp - Unbind a qp from a counter
> + * @force:
> + *   true - Decrease the counter ref-count anyway (e.g., qp destroy)
> + */
> +int rdma_counter_unbind_qp(struct ib_qp *qp, bool force)
> +{
> +	struct rdma_counter *counter = qp->counter;
> +	int ret;
> +
> +	if (!counter)
> +		return -EINVAL;
> +
> +	ret = __rdma_counter_unbind_qp(qp, force);
> +	if (ret && !force)
> +		return ret;
> +
> +	rdma_restrack_put(&counter->res);
> +	if (atomic_dec_and_test(&counter->usecnt))
> +		rdma_counter_dealloc(counter);

An atomic that does kfree when it reaches zero should be implemented
with a kref.

Jason
