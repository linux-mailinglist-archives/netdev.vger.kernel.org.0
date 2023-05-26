Return-Path: <netdev+bounces-5740-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E7D187129BC
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 17:38:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 41BAB28189F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 15:38:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52EBF271EF;
	Fri, 26 May 2023 15:38:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45948848B
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 15:38:43 +0000 (UTC)
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A67D19D
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:38:26 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f603d4bc5bso10003315e9.3
        for <netdev@vger.kernel.org>; Fri, 26 May 2023 08:38:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685115505; x=1687707505;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kx94SLqWiKL7HCEgoQNQfpo2slujNMBcBCXIEI2EqSA=;
        b=H7pVc1IRWsqaTAZ6N5rk+1h6lqTMQNWwrvXvx3LGMKkRUA6YCJdaPxBdfqvmWtrxpd
         AC8/9i1KwfK+s1IOfM2KDBp9mv3b/p/SGFKJ6BBSXnxlcbeqG8mg8RZ/lHXWQbTx8kCc
         wNdDAdBfmdKpEHYq8JC2A3ai6zoamCq+hTa6+pB+Ho/UP5Bq7UJ4QIYkPDXKNFEwkQON
         ZG+3YssqE3P9TU75kh/DHvwgyHFDEoMJ1oovK+m1taxETVUXB/pY/r17T00YTXpXwN6q
         ZxqOGMnO3XTfX9fCZO4XzJr87Yqbtf/21WKQrpKwIhrANiRnc7buSbB2wr3NPgCVsetQ
         lKXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685115505; x=1687707505;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kx94SLqWiKL7HCEgoQNQfpo2slujNMBcBCXIEI2EqSA=;
        b=O/kP35vSCqn/NbIuMmag3Tpa2RWxmohTH7izhBHH5R6Ik2WTO651gQ1/9PstO0xWaa
         eA0ij3DIVivFfepdxwSe953vW0mdL+GolH0uTztxfE/oLNzNpodj3b4gzGeqYFkYaxOI
         v6xR0p0NN9HZuPLuHETkmzqiObKtnX61phBNPygOGdfZWICzdHo2y5NyoXZDCx/8u5B3
         /CfLUaBauO6IOw/saH0HhU0ur/POMa/nOPQ5jNNyHTz6pmdDaIOBdRj8soQyyMjTowl5
         +hJzXI7Bc/qAXSOjUgvnRxnq0sgx37bvYerDVw58gF5ZioPyngOu7TyznzUl+moTLec3
         +DdA==
X-Gm-Message-State: AC+VfDxUc7/iwExeYqQ/NlfDM05I9B2tSqP7YysuDA6kP/xzlxT8jyOY
	bj7iLRPDtjFVB4TwpkhN/S9R1g==
X-Google-Smtp-Source: ACHHUZ7O7M+kBofR7M2Gjcd8PKeowfz/D+lG65qan/Vto9ai5W034a791khi/JkUzatsmhtzP83P3g==
X-Received: by 2002:a05:600c:2209:b0:3f6:15f:e401 with SMTP id z9-20020a05600c220900b003f6015fe401mr1816142wml.37.1685115504795;
        Fri, 26 May 2023 08:38:24 -0700 (PDT)
Received: from hera (ppp089210114029.access.hol.gr. [89.210.114.29])
        by smtp.gmail.com with ESMTPSA id 24-20020a05600c22d800b003f4e47c6504sm9253226wmg.21.2023.05.26.08.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 May 2023 08:38:24 -0700 (PDT)
Date: Fri, 26 May 2023 18:38:22 +0300
From: Ilias Apalodimas <ilias.apalodimas@linaro.org>
To: Yunsheng Lin <linyunsheng@huawei.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Alexander Duyck <alexander.duyck@gmail.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net-next 1/2] page_pool: unify frag page and non-frag
 page handling
Message-ID: <ZHDSblXIPvJhuZV5@hera>
References: <20230526092616.40355-1-linyunsheng@huawei.com>
 <20230526092616.40355-2-linyunsheng@huawei.com>
 <ZHCgJxTnm37qu3aY@hera>
 <5640bab0-d2f9-50ee-f3e2-eb0f86b144dc@huawei.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5640bab0-d2f9-50ee-f3e2-eb0f86b144dc@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 26, 2023 at 08:35:24PM +0800, Yunsheng Lin wrote:
> On 2023/5/26 20:03, Ilias Apalodimas wrote:
> > Hi Yunsheng
> >
> > Apologies for not replying to the RFC,  I was pretty busy with internal
> > stuff
> >
> > On Fri, May 26, 2023 at 05:26:14PM +0800, Yunsheng Lin wrote:
> >> Currently page_pool_dev_alloc_pages() can not be called
> >> when PP_FLAG_PAGE_FRAG is set, because it does not use
> >> the frag reference counting.
> >>
> >> As we are already doing a optimization by not updating
> >> page->pp_frag_count in page_pool_defrag_page() for the
> >> last frag user, and non-frag page only have one user,
> >> so we utilize that to unify frag page and non-frag page
> >> handling, so that page_pool_dev_alloc_pages() can also
> >> be called with PP_FLAG_PAGE_FRAG set.
> >
> > What happens here is clear.  But why do we need this?  Do you have a
> > specific use case in mind where a driver will call
> > page_pool_dev_alloc_pages() and the PP_FLAG_PAGE_FRAG will be set?
>
> Actually it is about calling page_pool_alloc_pages() in
> page_pool_alloc_frag() in patch 2, the use case is the
> veth using page frag support. see:
>
> https://patchwork.kernel.org/project/netdevbpf/patch/d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org/

Ok I missed that patch.

>
> > If that's the case isn't it a better idea to unify the functions entirely?
>
> As about, page_pool_alloc_frag() does seems to be a superset of
> page_pool_alloc_pages() after this patchset as my understanding.
> If the page_pool_alloc_frag() API turns out to be a good API for
> the driver, maybe we can phase out *page_pool_alloc_pages() as
> time goes by?

Looking at patch 2/2 it seems a bit wasteful.  At the moment only hns3 uses
fragments and the length of the allocation seems static.  But if someone
else chooses to allocate a > 2048 packet why should it allocate a page?

I just think it's a bit confusing since we have a flag on the pool for page
fragments, but then we violate it when it suits us.

Thanks
/Ilias

