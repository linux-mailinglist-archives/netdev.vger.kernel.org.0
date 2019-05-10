Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3124319D75
	for <lists+netdev@lfdr.de>; Fri, 10 May 2019 14:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727398AbfEJMyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 May 2019 08:54:35 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45498 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727071AbfEJMyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 May 2019 08:54:35 -0400
Received: by mail-qk1-f193.google.com with SMTP id j1so3532791qkk.12
        for <netdev@vger.kernel.org>; Fri, 10 May 2019 05:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=CsoDylf3pTQh/Nq0jX1EOIwPSKj4H85S+fm1M5xcrpM=;
        b=em4bWHQEaXWtIl7A8FKqZompgBW0iH56bxULHWQ2Kl+J4PjQuYbViYME7meoYW2aGb
         eEfH6JryngqUkLqq4NrElsy67/UgofKD8/bsACW4nwJufFaXWenIrlsJK35ibhRLe2ld
         R0/dTO8+mYuQVVfs18M+KyiNaLo8AKiB0DMxUFMAins2b8aBc+ZP5w+B8PomuAkFM25p
         5mlvMvhMSTCaFQQUVSOdr1FxVVrr+P+CwPMcipZYaTi0ieERvdgRNH0ZlQVzEuPwOrkV
         8CdBJKCEmKhoQdZBiDVGiagNrpvbILTF6jDmE4r4QdCJaWZskyMKCtRT0pNmsUmvft+7
         h/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=CsoDylf3pTQh/Nq0jX1EOIwPSKj4H85S+fm1M5xcrpM=;
        b=T2Zf4i1Iqyt8G/+CyVSUK8Jziim6s/u/FPxGLdqEyoXciH5FOs9180OEx8UdvS3cCK
         YcyBbwvifdF46bVSKTLDBSJ8FON7wZ1UYSfCYGXOfqc9J+ci5V7xz28yQrJisnvFxsf/
         wIRn1TFFnPhPGOG9ULO6dpIzKj3LTCEWRfEHjppANXTPkEz1EZoPZ0jAOovFPH+YGtBv
         NDk+YqkOsCXfsZYT+argaBeuA9s0ehZULp59ks53LQRpfkAbc2FkR6VqhLOTmvNabc6h
         9Lv2ykNYRVso4vwMUdlrSVbqqZ4CRg767SqNL6DQERG9TzeD61pXIFsj1hTXmp9b+AvM
         pcFA==
X-Gm-Message-State: APjAAAVicEScrbgokjHY2MT8DG2aIbN4B/UllSt43B/6AQeJ7e2C/IX4
        39tJTA5wfGveRUirP1kPp5pLZg==
X-Google-Smtp-Source: APXvYqxPiuCAz0DmNcpLMUSVlqmtlfg0A+oeE08xVuKAWNSms6AgCe6ywDpnsrpmwVethPQ0iAdqHg==
X-Received: by 2002:a37:3ce:: with SMTP id 197mr8479386qkd.14.1557492873869;
        Fri, 10 May 2019 05:54:33 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-49-251.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.49.251])
        by smtp.gmail.com with ESMTPSA id e131sm2480292qkb.80.2019.05.10.05.54.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 May 2019 05:54:32 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1hP52l-00041w-Dv; Fri, 10 May 2019 09:54:31 -0300
Date:   Fri, 10 May 2019 09:54:31 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [net-next][PATCH v2 1/2] rds: handle unsupported rdma request to
 fs dax memory
Message-ID: <20190510125431.GA15434@ziepe.ca>
References: <1556581040-4812-1-git-send-email-santosh.shilimkar@oracle.com>
 <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1556581040-4812-2-git-send-email-santosh.shilimkar@oracle.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 04:37:19PM -0700, Santosh Shilimkar wrote:
> From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> 
> RDS doesn't support RDMA on memory apertures that require On Demand
> Paging (ODP), such as FS DAX memory. User applications can try to use
> RDS to perform RDMA over such memories and since it doesn't report any
> failure, it can lead to unexpected issues like memory corruption when
> a couple of out of sync file system operations like ftruncate etc. are
> performed.

This comment doesn't make any sense..

> The patch adds a check so that such an attempt to RDMA to/from memory
> apertures requiring ODP will fail.
> 
> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
> Reviewed-tested-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Signed-off-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>  net/rds/rdma.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> index 182ab84..e0a6b72 100644
> +++ b/net/rds/rdma.c
> @@ -158,8 +158,9 @@ static int rds_pin_pages(unsigned long user_addr, unsigned int nr_pages,
>  {
>  	int ret;
>  
> -	ret = get_user_pages_fast(user_addr, nr_pages, write, pages);
> -
> +	/* get_user_pages return -EOPNOTSUPP for fs_dax memory */
> +	ret = get_user_pages_longterm(user_addr, nr_pages,
> +				      write, pages, NULL);

GUP is supposed to fully work on DAX filesystems.

You only need to switch to the long term version if the duration of
the GUP is under control of user space - ie it may last forever.

Short duration pins in the kernel do not need long term. 

At a minimum the commit message needs re-writing to properly explain
the motivation here.

Jason
