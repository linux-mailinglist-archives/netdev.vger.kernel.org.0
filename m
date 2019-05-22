Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FC6268E7
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 19:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730332AbfEVRLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 13:11:51 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:45636 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729851AbfEVRLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 13:11:50 -0400
Received: by mail-qt1-f194.google.com with SMTP id t1so3253139qtc.12
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 10:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7HjILda8I7Tovib4RdZQOyzSOVM+T0fg4HHgog52QHo=;
        b=F/jTx+lta/x0dovZSyIDy65o7wqqbwFIwP8IoypA/1nyAjzedYlgz5v4HJjRMeqTAB
         nF5xQmi1x3IF1KudHElBcK1AyfYW+9Ds3DnPIkFt6zJC9D1HOdRSTUxl4fuRTgs312Pt
         bsA1rfJLMkcJUJ8Ah+oizHHWiyKXMlAMA8ApoMNQ3NvVQPK7777DRezKCT/YrSk9ntMA
         Kt8sk5wxAX5ZPued4cXPhuyNVh6nxu7218H6T1ojnqs1sS1OpDe1p/dCCnZiUHYh5naf
         j6ExPiIK8hfhdBRRSTZKmSS1upJ18VfYo1lySfXyCi6OOMKIzK04dnk9xafsIHJ4/M0v
         jE7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=7HjILda8I7Tovib4RdZQOyzSOVM+T0fg4HHgog52QHo=;
        b=OuuQ9KT0zmZlkpPFsqoi2GVyEZM54vVt2ptFNUwIznse2w3YNH4+s67gyTYYuQGyrf
         y02ci2CS32VrmLYWZx1qyIQtgezyxJQvO8lBYU0h5IwxsXyv7AwBFD747p+LGiJZc5LO
         MKnrWx/ew1jf0O4gtBDobaZ5d4qXxbGQX4iyhRUBnYicOS0delV0zQcz/ZCoEjnKaT8D
         pmiHPoTCwY/lJAEZHlhHLM/meVfPAjG9rmLP4wYGkbh4uohDTEcSKLAbkr4MjGVwH+QB
         l6FrTygkRo9BH6EdZlHjfQdlhigrpW59zzkty72usdCy+RguOPS5BcaZ2T4nD+jb+egk
         ZiLQ==
X-Gm-Message-State: APjAAAXdEE2dQrsT+kzWqBz8j/rwc9aKWNJ44VlX9AzyrLBibFpKn8zP
        BJu4+Kvj8rqKjxUStmPSLSCjoA==
X-Google-Smtp-Source: APXvYqy9sxRYtMr+VlR5FYrcN/0TISPnf5XZjUfHGlF8p2rWbFz6zusV1Ig5v4sVW/69GkJ+5ZRecw==
X-Received: by 2002:a0c:9649:: with SMTP id 9mr61546648qvy.43.1558545109797;
        Wed, 22 May 2019 10:11:49 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id c32sm17034755qte.2.2019.05.22.10.11.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 10:11:49 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hTUmK-0003xR-Su; Wed, 22 May 2019 14:11:48 -0300
Date:   Wed, 22 May 2019 14:11:48 -0300
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
Message-ID: <20190522171148.GB15023@ziepe.ca>
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

>  void rdma_counter_init(struct ib_device *dev)
>  {
>  	struct rdma_port_counter *port_counter;
> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
> index 9204b4251fc8..dfaa57de871f 100644
> +++ b/drivers/infiniband/core/device.c
> @@ -2349,6 +2349,8 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
>  	SET_DEVICE_OP(dev_ops, set_vf_guid);
>  	SET_DEVICE_OP(dev_ops, set_vf_link_state);
>  	SET_DEVICE_OP(dev_ops, unmap_fmr);
> +	SET_DEVICE_OP(dev_ops, counter_bind_qp);
> +	SET_DEVICE_OP(dev_ops, counter_unbind_qp);

Keep sorted

Jason
