Return-Path: <netdev+bounces-6898-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E87B17189C9
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 21:05:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 882F1281568
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B422119E48;
	Wed, 31 May 2023 19:04:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DA7805
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 19:04:58 +0000 (UTC)
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E6310F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:04:56 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-75affe977abso717040685a.0
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 12:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1685559895; x=1688151895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=55EZdRKawvywEhrbC7BpBXsx5HuuUYXOihAkNZH/MO0=;
        b=pWsxzsmg771TOdEFNtaXdyB2oUh3rVCYyTNw/hfZarQt3YcGoQzykrhCiMD74jqicY
         KX+3j6oTwdq0nnx2QwhUZfhD1vZjumcyv5tJSYOe1TY3jl7LhE/7p7JxrAGlcu7O4BNn
         +1ueT2nygtj5SUFjn1n9J8LIt/9eUSF1jlNps0VyYJfsGggVDpcMzzpE4GgSFD+VuIi/
         GbOZ63V+Sq0JqaLPpaKLELJZUc8mEU5wW692fyWlIteDgwGuiSaBoI8RArc5xUAeIa7r
         5dJYY9ALmSK++p1qTWShWK8+5tNgtUysfNch8cYJP9RjU0CmEk6gDTQdjpKoFUwq371z
         w7qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685559895; x=1688151895;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=55EZdRKawvywEhrbC7BpBXsx5HuuUYXOihAkNZH/MO0=;
        b=g0ZGynHJqgNZhnRPvfZ0phVOGtN8wDNPAi2KYmvjmrpTHeCYf4WRCrEcyz75hPiGMc
         t2ktPlV1GkFo1WUbKL+UNPijF9v42hZcooUBMM9k30WR7XnLXxxCy0294lZuySjIEZbD
         xHCzkum0R3sBz2CZj/Rp0MelWbCV0tL9GcaDAoQSen2cgYrmmc2LXRqTHJu8+NzthmH4
         Sp7558VqXvQmXgGXAwZqDhJB2gmFO2ZYqIYWtZIS3VjsB0kiXiSDbiWrtuCHx2JTYghk
         tOiXu53lXTk33ayOy/fTwpY64D3o4fxNYT93+pB9CMkSoFYqWNdRethOk8MhPWamvkqw
         YS3g==
X-Gm-Message-State: AC+VfDw9CB2cY3NTL0Gwpo5B2KUi3fBEY9hbvkY71hg4LKJjlzGBP2H+
	TAk2ul65AhhKAbtgoALURLzsxw==
X-Google-Smtp-Source: ACHHUZ4yata1LcfSPtHo41ono6PwRoZmU222yNfJWyoG1NlvYfLT2L3YHWy3WFq2BVDg9BMUObGLMA==
X-Received: by 2002:ad4:5b8f:0:b0:621:2ad5:df74 with SMTP id 15-20020ad45b8f000000b006212ad5df74mr7776699qvp.51.1685559895712;
        Wed, 31 May 2023 12:04:55 -0700 (PDT)
Received: from ziepe.ca ([206.223.160.26])
        by smtp.gmail.com with ESMTPSA id v17-20020a0cf911000000b0062618962ec0sm4280792qvn.133.2023.05.31.12.04.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 12:04:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1q4R7t-0017TK-Kw;
	Wed, 31 May 2023 16:04:53 -0300
Date: Wed, 31 May 2023 16:04:53 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Chuck Lever <cel@kernel.org>, Netdev <netdev@vger.kernel.org>,
	linux-rdma <linux-rdma@vger.kernel.org>,
	Bernard Metzler <BMT@zurich.ibm.com>, Tom Talpey <tom@talpey.com>
Subject: Re: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft
 iWARP
Message-ID: <ZHeaVdsMUz8gDjEU@ziepe.ca>
References: <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
 <168330138101.5953.12575990094340826016.stgit@oracle-102.nfsv4bat.org>
 <ZFVf+wzF6Px8nlVR@ziepe.ca>
 <7825F977-3F62-4AFC-92F2-233C5EAE01D3@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7825F977-3F62-4AFC-92F2-233C5EAE01D3@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 23, 2023 at 07:18:18PM +0000, Chuck Lever III wrote:

> The core address resolution code wants to find an L2 address
> for the egress device. The underlying ib_device, where a made-up
> GID might be stored, is not involved with address resolution
> AFAICT.

Where are you hitting this?

Jason

