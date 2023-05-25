Return-Path: <netdev+bounces-5488-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BEE87711A13
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 00:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7D75C1C20F72
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 22:14:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF26E261C5;
	Thu, 25 May 2023 22:14:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D425E24EAF
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 22:14:46 +0000 (UTC)
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E34187;
	Thu, 25 May 2023 15:14:43 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64d2b42a8f9so221395b3a.3;
        Thu, 25 May 2023 15:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685052883; x=1687644883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hb3R00Im/ZxBiFAngYSLKpGnrtDkCIgTd/RrIOGifMA=;
        b=TjZ29CLIJHMsmtI1GqGarMtgfTZ2bM37eIRb+IeF8IkjmKvdetZ1ZorIZPDo+aljpF
         +OOzmR425qq8eeendr2EqVZgXCnzuFvNnVuZAPZQiXbZu3EefPDoQEabhRmSKEfXoGKT
         vkPjMCTtw4b+DPV3N3bQ1LHzTi/uGFAfyUKgAkcw4hyyO1NBDHnYGioRh2IjsqmAtSHJ
         vZCFMMzCZDBtiDnrKukJTmLDWIMmkT9tWbKIt7cPNXrR+1MdDbh1wxkBB3jZ6EA37xtr
         hCOo5o5CQVnInYX7ch3D9U/+a4d3xv76dSigQDKsNFdyTnbscIRu4tGIf9WRExfAc9sY
         WrGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685052883; x=1687644883;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hb3R00Im/ZxBiFAngYSLKpGnrtDkCIgTd/RrIOGifMA=;
        b=AZLRZwFmyD0jhbsltEPhz5WKQuTJm5EHETeNVntgvghBtqzmkC1bK1Q9x5HElk+SF6
         4/Kn6+FrV939avPH89f/ah56BRpTkpOFE/kxVllXLVhdmKyVCmngwVJdI9Z5QAGbm/xW
         kD6X04o2ZeyiYX3TkajLnF9WZgFVzyZlNwtqO457MQN3833tFNGIO7KVDMAlVdk7ido3
         w9IJTJM07KJiggGerL+RrZVqAaMPRJoCnZsdg17z6I3kRdfCe8c+BG3oH6O4KQqDsk3j
         07Mwswm/uU9KPQZqV4eSO7sr7N64on6Kp4T2mzdGKGm2aYK1PXS9J9/zTPKuH4hmWY4H
         8+4g==
X-Gm-Message-State: AC+VfDx/R2kk3mMsAK59Fi/N4xEd7xnAJ+jtEkJcUjQK1gmIkUvJ3SiT
	xileH8/f3+xqkUF0jQpMFsg=
X-Google-Smtp-Source: ACHHUZ6RGFBOHkG6p4dO+d2563paxHXxPEoTt9QAYv0UOmbF+VloCUwNGwkyCiHFM3ndNqCgjAKd/A==
X-Received: by 2002:a05:6a21:998b:b0:10e:5c1f:660f with SMTP id ve11-20020a056a21998b00b0010e5c1f660fmr7219965pzb.35.1685052882886;
        Thu, 25 May 2023 15:14:42 -0700 (PDT)
Received: from localhost ([2600:380:b551:e8fe:da52:61ec:2b97:ae7f])
        by smtp.gmail.com with ESMTPSA id j13-20020a65430d000000b004fbd91d9716sm1458938pgq.15.2023.05.25.15.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 15:14:42 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Thu, 25 May 2023 12:14:40 -1000
From: Tejun Heo <tj@kernel.org>
To: jiangshanlai@gmail.com
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-afs@lists.infradead.org, netdev@vger.kernel.org
Subject: Re: [PATCH 10/13] rxrpc: Use alloc_ordered_workqueue() to create
 ordered workqueues
Message-ID: <ZG_d0OzPmnQCAE-1@slm.duckdns.org>
References: <20230509015032.3768622-1-tj@kernel.org>
 <20230509015032.3768622-11-tj@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509015032.3768622-11-tj@kernel.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 08, 2023 at 03:50:29PM -1000, Tejun Heo wrote:
...
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Marc Dionne <marc.dionne@auristor.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: linux-afs@lists.infradead.org
> Cc: netdev@vger.kernel.org

Hey, I'm going to apply this to wq/for-6.5-cleanup-ordered. As it's an
identity conversion, it shouldn't break anything. Please holler if you have
any concerns.

Thanks.

-- 
tejun

