Return-Path: <netdev+bounces-8960-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 27C05726685
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:54:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 854F61C209E8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FEA935B21;
	Wed,  7 Jun 2023 16:54:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4540263B5
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:54:12 +0000 (UTC)
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61011FE9;
	Wed,  7 Jun 2023 09:54:03 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-53fbb3a013dso6950723a12.1;
        Wed, 07 Jun 2023 09:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686156843; x=1688748843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=54+qi/h0dgjEiscE3jr8CCpbJikBz1EP/4AV4WdE4uA=;
        b=Y0KoLQYaVs/x/uZp6sPOZL1DtjPxKsuHogteQgI7gi4ksgnssk/h5AP4Xqi7YXS4Du
         X0YYdyTW49qXUruen2a9EoNULB27nBj2CcCR7X2DZ3H1RaRpAEsqaCL23H3fIEMWm8Da
         GGB2+I4XzJxZFY94NjuHz2XMfuHYaXGAwAbgPD+1zRw33J4YOWC1EntopGcp/Mlnesld
         Y2OuAu5rjgEvMwcf9jgvfO02siSdQhKJlfMKczIykXGR32n8P2nQTFiTs2VAvNdJkrkn
         hhKWCcdNOkJVT/TVfR0uRpyW9d6UfOdxhzo1yeaoAYXj/6X5BA+TtuGdFNmKpSMOM+9f
         MebA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686156843; x=1688748843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=54+qi/h0dgjEiscE3jr8CCpbJikBz1EP/4AV4WdE4uA=;
        b=LrH2h9EJu00IkdiFlxkZkZbH5rFJOgqXqPXN5oD0pkPml35LhuuLGh++fm081N95cx
         CVPdhor9vXdgdHgQjxLPunDjN6UQwn7rjJQj03Nufc3Wx32Vd/sFe8/o9ZaMRhDhl2Km
         vFWnDkm+4UYM6txrHop4D8N5Ds2MFrO0zXahujy1IdZ7Z07qNUwv72sHVPHIUYd6IFv7
         kGiZZ5Zw7qvXJQtPZnV4zmxouOv8DlgunG0UQzYGfLS9IV6lY2EZoHTpm+mOFWa8Z+15
         nnbolBEFErJoXx7D+A/EgzGhYK1BNue5nfTFyecLv3CiIEi4TF1dCR1zFZoAZ1/U/0vG
         e2iQ==
X-Gm-Message-State: AC+VfDzbfkAqjUUyg+U4HbLFAiOQ0KfeTNOGgMfmBqwc4EDwcsN1Amju
	ht1WnqtPMOTsCHqyiK1+xls=
X-Google-Smtp-Source: ACHHUZ5Q6QKhrwvqRGpZjrJLLYXFFObmXo+JbPl75BNIiN9vCn525+V+0eOVVMY/7ACsH9rbz6VtZg==
X-Received: by 2002:a17:903:41c6:b0:1b1:ac87:b47a with SMTP id u6-20020a17090341c600b001b1ac87b47amr6806648ple.65.1686156843148;
        Wed, 07 Jun 2023 09:54:03 -0700 (PDT)
Received: from localhost (ec2-52-8-182-0.us-west-1.compute.amazonaws.com. [52.8.182.0])
        by smtp.gmail.com with ESMTPSA id ik8-20020a170902ab0800b001ae0152d280sm10792502plb.193.2023.06.07.09.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 09:54:02 -0700 (PDT)
Date: Thu, 1 Jun 2023 07:54:07 +0000
From: Bobby Eshleman <bobbyeshleman@gmail.com>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Simon Horman <simon.horman@corigine.com>,
	Bobby Eshleman <bobby.eshleman@bytedance.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Bryan Tan <bryantan@vmware.com>, Vishnu Dasa <vdasa@vmware.com>,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-hyperv@vger.kernel.org
Subject: Re: [PATCH RFC net-next v3 6/8] virtio/vsock: support dgrams
Message-ID: <ZHhOn7QKdByqc3m+@bullseye>
References: <20230413-b4-vsock-dgram-v3-0-c2414413ef6a@bytedance.com>
 <20230413-b4-vsock-dgram-v3-6-c2414413ef6a@bytedance.com>
 <ZHdxJxjXDkkO03L4@corigine.com>
 <d2e9c45f-bcbd-4e6a-98c1-c98283450626@kadam.mountain>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d2e9c45f-bcbd-4e6a-98c1-c98283450626@kadam.mountain>
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 09:13:04PM +0300, Dan Carpenter wrote:
> On Wed, May 31, 2023 at 06:09:11PM +0200, Simon Horman wrote:
> > > @@ -102,6 +144,7 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
> > 
> > Smatch that err may not be initialised in the out label below.
> > 
> > Just above this context the following appears:
> > 
> > 	if (info->vsk && !skb_set_owner_sk_safe(skb, sk_vsock(info->vsk))) {
> > 		WARN_ONCE(1, "failed to allocate skb on vsock socket with sk_refcnt == 0\n");
> > 		goto out;
> > 	}
> > 
> > So I wonder if in that case err may not be initialised.
> > 
> 
> Yep, exactly right.  I commented out the goto and it silenced the
> warning.  I also initialized err to zero at the start hoping that it
> would trigger a different warning but it didn't.  :(
> 
> regards,
> dan carpenter
> 

Thanks for checking that Dan. Fixed in the next rev.

Best,
Bobby

