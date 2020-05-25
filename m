Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B981E1468
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 20:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389714AbgEYSgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 14:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389505AbgEYSgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 14:36:49 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9A2C08C5C0
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 11:36:49 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id p12so14328421qtn.13
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 11:36:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dBNNLrsZGlwM47DpepdKHSQV4KNpjYEcR6uFWidIK+c=;
        b=BazwyORd4omrvh5DADt7N8mqLMzi+RYjBVK2kPihaadkNXr9Is/rLQDfJO5Q/VeMGZ
         XlvEE4bOuXysXlPGwIcRVecP4SnpQyeKRev18Y4ZkAs6lst+NPCglYJURCEfUqTCMD4v
         d4FIdKZ9pAdL4B9FUtyw2jBTjuhBqzHCChe8o3MkkhMvwBxi9Um4/ZVdmu0ggKu2vawk
         PNx/yPYZhnASgcRI+PifWTVuxkkGWBN4MejekhhBeeMm1LXgAmbElmSsr+OAJUwgROb1
         rBGLGAXggDbJcugNER9HW64w4P98g/cNUgxhKT2JupBZ8W1di28pdRIs+MTO7ToMN7BC
         cJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dBNNLrsZGlwM47DpepdKHSQV4KNpjYEcR6uFWidIK+c=;
        b=cFsu/PfVTymHicXzG4iPU59d37r2KCBA9RP36mACNB6Y+639ixdrY/CkdBloAIF4lR
         QBKwGUlrpLxowCOkUvQo50pxDmEsuhRKTHxMmUs1XpYa0LLXBvfJyt+MLY6oYEB7pq3h
         EntgpzCFUMxguUBhlxqn1IhcSIBH2GcT/ABP3CkxFT4+X9BBQZsHrdGRHYXgNOXSngoh
         obm3oYst5pG8IpjwiITek1+zc9RO9yK7TugvWrHMwa4+7qV8CB/3HwvVEai1nnsxFeP8
         NpmNTIF8E2cIRv/m0w54qONNRiM5m/LiP91H+fSuYHdbP25+uYKUjseCrLRmucmjU+KT
         GymA==
X-Gm-Message-State: AOAM533mIQ+zDSkyWVy8GRvGftubkTH55y3+Q0Jb/sgbNvpNeWdBO04T
        B4JXhGJ4q01hE8viD7RaJpb8RQ==
X-Google-Smtp-Source: ABdhPJyVBT1RicyN2xE8hyRL3aL4JQsSy+eeZY75U2lWdtzDSnJF2GO8I+QXxg6GJjkQa3bQjLScCA==
X-Received: by 2002:ac8:46d5:: with SMTP id h21mr28223881qto.91.1590431808437;
        Mon, 25 May 2020 11:36:48 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-156-34-48-30.dhcp-dynamic.fibreop.ns.bellaliant.net. [156.34.48.30])
        by smtp.gmail.com with ESMTPSA id z14sm14322945qki.83.2020.05.25.11.36.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 May 2020 11:36:47 -0700 (PDT)
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)
        (envelope-from <jgg@ziepe.ca>)
        id 1jdHxv-0007Xl-9V; Mon, 25 May 2020 15:36:47 -0300
Date:   Mon, 25 May 2020 15:36:47 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        target-devel@vger.kernel.org
Subject: Re: [PATCH rdma-next v2 7/7] RDMA/cma: Provide ECE reject reason
Message-ID: <20200525183647.GI744@ziepe.ca>
References: <20200413141538.935574-1-leon@kernel.org>
 <20200413141538.935574-8-leon@kernel.org>
 <20200525181417.GC24366@ziepe.ca>
 <20200525182242.GK10591@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525182242.GK10591@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 25, 2020 at 09:22:42PM +0300, Leon Romanovsky wrote:
> On Mon, May 25, 2020 at 03:14:17PM -0300, Jason Gunthorpe wrote:
> > On Mon, Apr 13, 2020 at 05:15:38PM +0300, Leon Romanovsky wrote:
> > > @@ -4223,7 +4223,7 @@ int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event)
> > >  EXPORT_SYMBOL(rdma_notify);
> > >
> > >  int rdma_reject(struct rdma_cm_id *id, const void *private_data,
> > > -		u8 private_data_len)
> > > +		u8 private_data_len, enum rdma_ucm_reject_reason reason)
> > >  {
> > >  	struct rdma_id_private *id_priv;
> > >  	int ret;
> > > @@ -4237,10 +4237,12 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
> > >  			ret = cma_send_sidr_rep(id_priv, IB_SIDR_REJECT, 0,
> > >  						private_data, private_data_len);
> > >  		} else {
> > > +			enum ib_cm_rej_reason r =
> > > +				(reason) ?: IB_CM_REJ_CONSUMER_DEFINED;
> > > +
> > >  			trace_cm_send_rej(id_priv);
> > > -			ret = ib_send_cm_rej(id_priv->cm_id.ib,
> > > -					     IB_CM_REJ_CONSUMER_DEFINED, NULL,
> > > -					     0, private_data, private_data_len);
> > > +			ret = ib_send_cm_rej(id_priv->cm_id.ib, r, NULL, 0,
> > > +					     private_data, private_data_len);
> > >  		}
> > >  	} else if (rdma_cap_iw_cm(id->device, id->port_num)) {
> > >  		ret = iw_cm_reject(id_priv->cm_id.iw,
> > > diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> > > index d41598954cc4..99482dc5934b 100644
> > > +++ b/drivers/infiniband/core/ucma.c
> > > @@ -1178,12 +1178,17 @@ static ssize_t ucma_reject(struct ucma_file *file, const char __user *inbuf,
> > >  	if (copy_from_user(&cmd, inbuf, sizeof(cmd)))
> > >  		return -EFAULT;
> > >
> > > +	if (cmd.reason &&
> > > +	    cmd.reason != RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED)
> > > +		return -EINVAL;
> >
> > It would be clearer to set cmd.reason to IB_CM_REJ_CONSUMER_DEFINED at
> > this point..
> >
> > if (!cmd.reason)
> >    cmd.reason = IB_CM_REJ_CONSUMER_DEFINED
> >
> > if (cmd.reason != IB_CM_REJ_CONSUMER_DEFINED && cmd.reason !=
> >     RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED)
> >    return -EINVAL
> >
> > Esaier to follow and no reason userspace shouldn't be able to
> > explicitly specifiy the reason's that it is allowed to use.
> >
> >
> > > index 8d961d8b7cdb..f8781b132f62 100644
> > > +++ b/include/rdma/rdma_cm.h
> > > @@ -324,11 +324,12 @@ int __rdma_accept_ece(struct rdma_cm_id *id, struct rdma_conn_param *conn_param,
> > >   */
> > >  int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event);
> > >
> > > +
> > >  /**
> >
> > Extra hunk?
> >
> > >   * rdma_reject - Called to reject a connection request or response.
> > >   */
> > >  int rdma_reject(struct rdma_cm_id *id, const void *private_data,
> > > -		u8 private_data_len);
> > > +		u8 private_data_len, enum rdma_ucm_reject_reason reason);
> > >
> > >  /**
> > >   * rdma_disconnect - This function disconnects the associated QP and
> > > diff --git a/include/uapi/rdma/rdma_user_cm.h b/include/uapi/rdma/rdma_user_cm.h
> > > index c4ca1412bcf9..e545f2de1e13 100644
> > > +++ b/include/uapi/rdma/rdma_user_cm.h
> > > @@ -78,6 +78,10 @@ enum rdma_ucm_port_space {
> > >  	RDMA_PS_UDP   = 0x0111,
> > >  };
> > >
> > > +enum rdma_ucm_reject_reason {
> > > +	RDMA_USER_CM_REJ_VENDOR_OPTION_NOT_SUPPORTED = 35
> > > +};
> >
> > not sure we need ABI defines for IBTA constants?
> 
> Do you want to give an option to write any number?
> Right now, I'm enforcing only allowed by IBTA reason
> and which is used in user space.

no, just the allowed numbers, just wondering if we need constants for
fixed IBTA values .. 

Jason
