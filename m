Return-Path: <netdev+bounces-626-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 48D736F89EB
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:58:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EE4132810AA
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 19:58:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB77D2E1;
	Fri,  5 May 2023 19:58:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37F5C12D
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 19:58:54 +0000 (UTC)
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E351B4
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 12:58:53 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id d75a77b69052e-3ef32014101so23127281cf.3
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 12:58:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1683316732; x=1685908732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D8/0Mz1i3TrsK5EuHofqZpbzmHEgycZi6NeOkBStzxc=;
        b=PibVkdMtrGXG4nJCsSpO+dyX40H7jVmFM5a/TLyr7glOsgpls3oaUCXmR2tz1P9ZQS
         aIq11OVfIkafWXqXLBrCAFAgg0Y6Uif246c/M7XoxGTk1/YmL+2TeAkyQxc6R/ur97Jd
         560EkduqhNdBTHgYaJxzY6GKNBfDvZsCwGX9UabPP64GQQsIpsjxWgkSzQnstnioQBbB
         zrJ8fqnPhTpZ3eUY+phtcjta6ibdPYrH0Ywr6ylLKVGmvwmJ3bNo7C6hHj4haE+y1KXf
         h15FLI8dSGBt01m+IYnKWScqocAfpryZ41pbX20JqaysMzXYOuUkXh+0Mgl0yz70nuQ+
         eEAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683316732; x=1685908732;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8/0Mz1i3TrsK5EuHofqZpbzmHEgycZi6NeOkBStzxc=;
        b=Xw/D8BEVQmkLfRlTCbesnu1eJlhOqKVtDeIFPUPM0vYEaJ4aXv+dIelcdPLfOl0Scx
         tEsuKGSYH+oyjf5EFPZgkPP6lzTyl1szPaB/53mMqRO+dZzNJs6lX9bcooocnm/p4UQt
         +UzXKc764cFtZLzFq5P5R0mFOldVROnviL58V6VGeZ3BWj1t0wlexUa0c6SH0SR7JI3n
         YSeM/NFncPwwQG+wijQWrQvrqQSJBFumZoyMLcOdQnRnDUB5P7RnL2RInLVT1eBDFtdC
         AbP9shlUOGx0/sy00HLSOVr3x8d2USwHohByPEToVtdnFWbjZaR6ulkFFr3iuWO5VBsC
         WZ9g==
X-Gm-Message-State: AC+VfDybYExVm0nBUBndFWKIezH0NZA/xinuIlVH6SCkI7Rj1MF45dWS
	mrXVR0allgnFbuMHJa6XD0vwnA==
X-Google-Smtp-Source: ACHHUZ41Fdv176OLWVq9lKASou3V2H+AkTzBXpY6k9951af/PZTdY11T+LpjtJxw5VEsQnvjkhVp8Q==
X-Received: by 2002:a05:622a:1a21:b0:3ef:36d0:c06e with SMTP id f33-20020a05622a1a2100b003ef36d0c06emr4858856qtb.33.1683316732523;
        Fri, 05 May 2023 12:58:52 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id n10-20020ac8674a000000b003df7d7bbc8csm853125qtp.75.2023.05.05.12.58.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 12:58:51 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1pv1Zr-007zWe-A9;
	Fri, 05 May 2023 16:58:51 -0300
Date: Fri, 5 May 2023 16:58:51 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Chuck Lever <cel@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com,
	tom@talpey.com
Subject: Re: [PATCH RFC 3/3] RDMA/siw: Require non-zero 6-byte MACs for soft
 iWARP
Message-ID: <ZFVf+wzF6Px8nlVR@ziepe.ca>
References: <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
 <168330138101.5953.12575990094340826016.stgit@oracle-102.nfsv4bat.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168330138101.5953.12575990094340826016.stgit@oracle-102.nfsv4bat.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 05, 2023 at 11:43:11AM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> In the past, LOOPBACK and NONE (tunnel) devices had all-zero MAC
> addresses. siw_device_create() would fall back to copying the
> device's name in those cases, because an all-zero MAC address breaks
> the RDMA core IP-to-device lookup mechanism.

Why not just make up a dummy address in SIW? It shouldn't need to leak
out of it.. It is just some artifact of how the iWarp stuff has been
designed

Jason

