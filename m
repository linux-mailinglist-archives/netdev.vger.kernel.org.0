Return-Path: <netdev+bounces-8030-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8448E722792
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:35:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F10891C20943
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 13:35:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8FBED1C77C;
	Mon,  5 Jun 2023 13:35:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 829EC6FC3
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 13:35:24 +0000 (UTC)
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CB381BB
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:35:12 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-543a6cc5f15so1128609a12.2
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 06:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1685972112; x=1688564112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PQ9YEyXdfxIriIIMHnODtjK+/Crk0/ld21e+qZyv40A=;
        b=VE6r3tEprgGUx8SgCYBffVRP6JbbmmcR1q4fZ1wh65I1j670EdBOJuyO8FMOOBPKzD
         cS/hXdmzEeapUS8lJ4FKhXMfehxhGTyrs0DvNC21eiN/nmHmdt7l1BnkND1tZ/KvrAND
         VDoFSCYdS93O05omPwPnnKXB79tI3L14iFurQmVEvrSkPtX2mjkqNlVCF7IBB+Y2a7qN
         DCaUe2rg7iJG/aomwW5JKLznTwG7VPGl9ddzas+jt0/K7RvgT9DtHL08jtHy6mAE9ZQa
         OBPf2db661cjg0p8hzt/PHtU5HfeJrfW44SaxDwfMMU0JKGZ1ajJMM2DToOk1CqwMjy1
         DKSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685972112; x=1688564112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQ9YEyXdfxIriIIMHnODtjK+/Crk0/ld21e+qZyv40A=;
        b=kUSXHtyceg02zeaWIEcSimWjXu/cFlnxzGAON/mSg/h9lcdUOJ9EpSH1mofBdoU5fs
         lh0922w65zUt8IceDqmTzKnLRCcxxxSyNirb088Mdgosb3i0dH2HJi2quPwE2a4C2Oct
         zJ0O8Hf3foI2ECFxx2jCSwoGy5K3PGwPFawCLo/fsdKIGSm4hxq/QJY48wqL+VFz/e98
         PMQRybTZ37x1XLohNxdFwGVaY2FHNxJXPR4SBQh2TzSwTwp0RaTVul04mplL6RzX6U3X
         HBelSrGoPcqQXxmqGwAcpfoI/XhBLdxwiTy2N+6D1PdOYZ3TStfIU0DLkiLF+ORdvkfC
         AWug==
X-Gm-Message-State: AC+VfDzhHipwkdw9TrLsYvXyKD0Qd7gnfB2JDvjx1D7HFhcFn4wJemJz
	N1fLpFauTmpVa/anTDBBQiSt3w==
X-Google-Smtp-Source: ACHHUZ7lcwTCBonG3pbLMxNGCQHIgpAzINF4LZqWdbfmP30nhlcE4dHT0tzD3NPMXEHIGqvx92Uqng==
X-Received: by 2002:a17:902:f7cc:b0:1af:beae:c0b with SMTP id h12-20020a170902f7cc00b001afbeae0c0bmr6415399plw.22.1685972111898;
        Mon, 05 Jun 2023 06:35:11 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id p5-20020a170902eac500b001b03a1a3151sm6643287pld.70.2023.06.05.06.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jun 2023 06:35:11 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1q6AMX-002mN1-DO;
	Mon, 05 Jun 2023 10:35:09 -0300
Date: Mon, 5 Jun 2023 10:35:09 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Simon Horman <simon.horman@corigine.com>
Cc: Wei Hu <weh@microsoft.com>, netdev@vger.kernel.org,
	linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org,
	longli@microsoft.com, sharmaajay@microsoft.com, leon@kernel.org,
	kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, vkuznets@redhat.com,
	ssengar@linux.microsoft.com, shradhagupta@linux.microsoft.com
Subject: Re: [PATCH 1/1] RDMA/mana_ib: Add EQ interrupt support to mana ib
 driver.
Message-ID: <ZH3kjU7a2L7EkEQ2@ziepe.ca>
References: <20230605114313.1640883-1-weh@microsoft.com>
 <ZH3f2abyRU1l/dq6@corigine.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZH3f2abyRU1l/dq6@corigine.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 03:15:05PM +0200, Simon Horman wrote:
> On Mon, Jun 05, 2023 at 11:43:13AM +0000, Wei Hu wrote:
> > Add EQ interrupt support for mana ib driver. Allocate EQs per ucontext
> > to receive interrupt. Attach EQ when CQ is created. Call CQ interrupt
> > handler when completion interrupt happens. EQs are destroyed when
> > ucontext is deallocated.
> > 
> > The change calls some public APIs in mana ethernet driver to
> > allocate EQs and other resources. Ehe EQ process routine is also shared
> > by mana ethernet and mana ib drivers.
> > 
> > Co-developed-by: Ajay Sharma <sharmaajay@microsoft.com>
> > Signed-off-by: Ajay Sharma <sharmaajay@microsoft.com>
> > Signed-off-by: Wei Hu <weh@microsoft.com>
> 
> ...
> 
> > @@ -368,6 +420,24 @@ static int mana_ib_create_qp_raw(struct ib_qp *ibqp, struct ib_pd *ibpd,
> >  	qp->sq_id = wq_spec.queue_index;
> >  	send_cq->id = cq_spec.queue_index;
> >  
> > +	if (gd->gdma_context->cq_table[send_cq->id] == NULL) {
> > +
> > +		gdma_cq = kzalloc(sizeof(*gdma_cq), GFP_KERNEL);
> > +		if (!gdma_cq) {
> > +			pr_err("failed to allocate gdma_cq\n");
> 
> Hi wei Hu,
> 
> I think 'err = -ENOMEM' is needed here.

And no prints like that in drivers.

Jason

