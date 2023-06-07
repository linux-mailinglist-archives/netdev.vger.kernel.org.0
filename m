Return-Path: <netdev+bounces-8870-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BADEE726269
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:10:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 76B1E2812F4
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 14:10:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ED038370C2;
	Wed,  7 Jun 2023 14:10:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E260F34448
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 14:10:52 +0000 (UTC)
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413231BE6
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 07:10:45 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1b01d912a76so33681375ad.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 07:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1686147044; x=1688739044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UA4hO4Sg2XutErgapC8W1zkxrTNWaXjtaVy5iI3CNaw=;
        b=gQrGNBCN6wg3gDSkzHUPCLOTgDfaTcWrZTB0MLWuAr16iUZyxRyQVaoV/HlulE6Ke7
         vOiBehRR3EKFzUy/z/uOVwK9d0qLc6axSRyi5BSwc5VLE+AWORAIx1ji14Qy0uPW/eHD
         Xg1PX6HvaZijyrrUvxZQSBNwEkYNHyT+1tckU2H+bZ4YqVAv3xHt3veT16xsmld6FoOf
         6vyJnqqpz8poqsyESJ4nGlCMuouGE9KnjAwESQ6ESKmHiu4JXxhkoUHVhez92Lpmd/oo
         DiR/b4tWZK8yODvRb4eH8rPZCopGKs/c0wchrTL2wbJLtqiTKMV6AqGeMBTx92rmms5W
         Bbgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686147044; x=1688739044;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UA4hO4Sg2XutErgapC8W1zkxrTNWaXjtaVy5iI3CNaw=;
        b=G3bKw0dgcrkZOHiM3grIRflVNJSBhq0F20Tb3XA4GddDXHnPsM/2BEG8DSbs68wzvp
         k1ExVIDrm0VoBpgqKUylXo9cz0uylHyga1HQBwmd6j5mI0lNvBKIfa3Mytc9JUZoO2qC
         E6u6D3u0uISMnS74ovM3DwZ6jyFV73Zw8+a4Vlm3wpBOWkstXeDhb1zAA0pdAeFmq6Z4
         Sr11r6prl4DVZ35Kd7YqTnRJcyIYw1q/g3UQJNf8muRL1PGnQYP0Kg5u0B2N36P20HeB
         6MUVzcNlPfLQQe46SdUMVR7Nn7KyYpsEwFUZNmLaiG+6KXXwiO+fc2KoV/P/BmNxkinv
         aD4g==
X-Gm-Message-State: AC+VfDybLs9US9AXpJtvtaMBMVwMae0x42DodBUpzFTgoYJMdHtmOAKq
	E7dVF3AzD06VY6NA83Ot/7a7Pg==
X-Google-Smtp-Source: ACHHUZ5a5P5mqNb85Pd/vXMXSm7nE4E7+voSPGauH9t/Ggi2PDbGp1xcEDYRTN/Lmu7n3ZvVuqakoQ==
X-Received: by 2002:a17:902:f54f:b0:1b2:24e4:8889 with SMTP id h15-20020a170902f54f00b001b224e48889mr2373341plf.14.1686147044665;
        Wed, 07 Jun 2023 07:10:44 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id t9-20020a170902bc4900b001b0772fe3fdsm10516761plz.265.2023.06.07.07.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 07:10:44 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1q6ts2-0039y5-6X;
	Wed, 07 Jun 2023 11:10:42 -0300
Date: Wed, 7 Jun 2023 11:10:42 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Saeed Mahameed <saeed@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>,
	Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>, linux-rdma@vger.kernel.org,
	Jiri Pirko <jiri@nvidia.com>
Subject: Re: [net-next 13/15] net/mlx5: Skip inline mode check after
 mlx5_eswitch_enable_locked() failure
Message-ID: <ZICP4kWm5moYRKm1@ziepe.ca>
References: <20230606071219.483255-1-saeed@kernel.org>
 <20230606071219.483255-14-saeed@kernel.org>
 <20230606220117.0696be3e@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606220117.0696be3e@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 10:01:17PM -0700, Jakub Kicinski wrote:
> On Tue,  6 Jun 2023 00:12:17 -0700 Saeed Mahameed wrote:
> > Fixes: bffaa916588e ("net/mlx5: E-Switch, Add control for inline mode")
> > Fixes: 8c98ee77d911 ("net/mlx5e: E-Switch, Add extack messages to devlink callbacks")
> 
> The combination of net-next and Fixes is always odd.
> Why? 
> Either it's important enough to be a fix or its not important 
> and can go to net-next...

Generally I tell people to mark things as Fixes if it is a fix,
regardless of how small, minor or unimportant.

It helps backporters because they can suck in the original patch and
all the touchups then test that result. If people try to predict if it
is "important" or not they get it wrong quite often.

Fixes is not supposed to mean "this is important" or "send this to
-rc" or "apply it to -stable"

If it is really important add a 'cc: stable'.

If it is sort of important then send it to the -rc tree.

Otherwise dump it in the merge window.

But mark it with Fixes regardless

Jason

