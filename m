Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36AFB7567D
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 20:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727514AbfGYSBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 14:01:08 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42694 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726470AbfGYSBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jul 2019 14:01:08 -0400
Received: by mail-qk1-f194.google.com with SMTP id 201so37095002qkm.9
        for <netdev@vger.kernel.org>; Thu, 25 Jul 2019 11:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=vGYuXI1XhQzrhccrE6fnYndnEfe1cgcdZTRoyRWon30=;
        b=LHdVw5NEneoQU4CzpyjCo2O6jKS9/4skxsfSQe65lEsjoHdOi4FjYZOyBWnjtzB72p
         8MS4tA1f4pHi+4urPkCv5VU5WQvY63RUvn8zwCWm4ChBay9nnJNsoEdqJMDAlcRM+JjW
         KYq1xPi/iXyXzrTz4zfpXS19LbJZMYH/7rqjvcw6+ZH03KdWiesA35NjBJRMuIY/8caD
         XVmkV7X+/DjZ+0Ja2n7Lhc7ILKm1FnrhSBETcGPjSrUT+1Xc3lZ2GfMcJ6IG6K90W1/7
         uHtzUegbYMPK6T/bITnxTc3jlOipiVS8RNTTHOYeUQxZ1dvAkHzpjebl1RJIgmj/QDQH
         F3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=vGYuXI1XhQzrhccrE6fnYndnEfe1cgcdZTRoyRWon30=;
        b=dhxSEAeX0PrAlh9HzB6nxcYchYplkFwOWv+NYna1Uc9WZ2eR+ZOcsnNnx/bvEpZrdP
         yUCA3+LwsNg+f8U7XPn+EA3t1VakzuJewQaZZI8Tx2FJM9Y9/n27HKIN51yCy+tf2oh5
         E470QcJEy73LZpJkDfwFWL3F0YCALvXtOPY61VN9wCOIM6YIOFH8ckzGW+ZnS7f8vaYR
         Nl6m0F4SHBfbzEHXDtQsYH/Y+jl1XkPu+1QM+RkV62/XIezD289nAcZ/BvrY33soZo+1
         wbCwzkG3Elpt1xiOuV2P2s3y1mjInXKIg7W38tLuLFJ5F6VIMy8LHMQVciDRYo3Io1pl
         zUxg==
X-Gm-Message-State: APjAAAWm3MV8jmqXAGonviy6F1iwx9XjvbuTNmLAKCajiLkwhna8DuwC
        wjz3rDrV1upA7wN3oaaZkzdPww==
X-Google-Smtp-Source: APXvYqxiH02uzXiIn1a4se6WASIURL2fzM/LI+8BZjKOH4JTjphY57ljifj40dYUTxiOSLcleqKUOQ==
X-Received: by 2002:a37:ad0:: with SMTP id 199mr59758664qkk.90.1564077667380;
        Thu, 25 Jul 2019 11:01:07 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-55-100.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.55.100])
        by smtp.gmail.com with ESMTPSA id o17sm20223983qkm.6.2019.07.25.11.01.06
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 25 Jul 2019 11:01:07 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hqi38-0005Gz-Ht; Thu, 25 Jul 2019 15:01:06 -0300
Date:   Thu, 25 Jul 2019 15:01:06 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     ariel.elior@marvell.com, dledford@redhat.com, galpress@amazon.com,
        linux-rdma@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v6 rdma-next 5/6] RDMA/qedr: Add doorbell overflow
 recovery support
Message-ID: <20190725180106.GB18757@ziepe.ca>
References: <20190709141735.19193-1-michal.kalderon@marvell.com>
 <20190709141735.19193-6-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190709141735.19193-6-michal.kalderon@marvell.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 05:17:34PM +0300, Michal Kalderon wrote:

> +static int qedr_init_user_db_rec(struct ib_udata *udata,
> +				 struct qedr_dev *dev, struct qedr_userq *q,
> +				 bool requires_db_rec)
> +{
> +	struct qedr_ucontext *uctx =
> +		rdma_udata_to_drv_context(udata, struct qedr_ucontext,
> +					  ibucontext);
> +
> +	/* Aborting for non doorbell userqueue (SRQ) or non-supporting lib */
> +	if (requires_db_rec == 0 || !uctx->db_rec)
> +		return 0;
> +
> +	/* Allocate a page for doorbell recovery, add to mmap ) */
> +	q->db_rec_data = (void *)get_zeroed_page(GFP_KERNEL);

I now think this needs to be GFP_USER and our other drivers have a bug
here as well..

Jason
