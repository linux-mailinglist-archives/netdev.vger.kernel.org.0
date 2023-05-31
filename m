Return-Path: <netdev+bounces-6754-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C6DB6717CEE
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 12:13:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7E78228144B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 10:13:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB4513AD6;
	Wed, 31 May 2023 10:13:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A65D813AD2
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 10:13:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB423113
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 03:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685527986;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=flH0rH/SF1FoEzlc/YufyB8McpFA7HhWs2K5JPH1fS4=;
	b=Ito7KcfkkR3FTgbiF5V1BMNLVAgRyO2DYOrANBeYxdMH3W9Tyl7TndwNdrSVH+C88oJXc3
	fFTqlvuXbYnjQjMrZGZSNqlKzKlD5F/rcWkdCDqCwg/WlANpmigvb8kB6x3VYMg/TRGdK5
	rvtPKIrXxZz4xirTHDzMdv3EZWAwRB0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-196-AVEfNQVMNeaQnlX_-tUgMA-1; Wed, 31 May 2023 06:13:05 -0400
X-MC-Unique: AVEfNQVMNeaQnlX_-tUgMA-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f60481749eso3826895e9.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 03:13:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685527984; x=1688119984;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=flH0rH/SF1FoEzlc/YufyB8McpFA7HhWs2K5JPH1fS4=;
        b=ae2djkVeMOQzyw4T3Qv7CzJtaSOS+9jZmKfOwIV3sM5oCBrk+jQqGuISNSEU6XgfkG
         1Umovbg54Jos8IQzqNunA6YydNoGxg+zGCiMRmsmRWOinszU02Y2j23JRZ1vPoF5n7ZW
         zSk2SOS02D+efYJIpqGUgNqyVfbu0JOtPE/juefRH5mwj68ifD7A9jyATSuc/SCjAR7g
         A7G/3raMGEy1GyztJPKeSpVaUeujWxx7DrlZknMbjsRYOABWWmA4a5r/cOIXKernJCzr
         7LWePcWY32FCRXv4cCDg8TfOxhPhesJOdf2B9c0w2/O+Q+1HpjBAPtA7NjdcugnLJqFY
         5Cdw==
X-Gm-Message-State: AC+VfDwG0y7jG4LCFooh9cYj575k8l4mnbLbNXv2oSJImjnaBieqMoWL
	UzlJTYWsp3ZocUJAuB94kWRbzTrEpl8C8DeAkPo4Z/Fd8sJhDuS3BNEs1fgDfo6fOlq+ZWoZxJ/
	sdiGOq7FvWM82GwsM
X-Received: by 2002:a1c:750c:0:b0:3f4:1ce0:a606 with SMTP id o12-20020a1c750c000000b003f41ce0a606mr4390645wmc.1.1685527983859;
        Wed, 31 May 2023 03:13:03 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5asoLakejsyLLPZdfClKdSf+r3ylegdkw732DxCImL6NAaN0ImN41gGnRgftHPrTCuurn9BA==
X-Received: by 2002:a1c:750c:0:b0:3f4:1ce0:a606 with SMTP id o12-20020a1c750c000000b003f41ce0a606mr4390622wmc.1.1685527983549;
        Wed, 31 May 2023 03:13:03 -0700 (PDT)
Received: from localhost ([37.162.138.181])
        by smtp.gmail.com with ESMTPSA id u4-20020a7bc044000000b003f6f6a6e760sm13710579wmc.32.2023.05.31.03.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 03:13:03 -0700 (PDT)
Date: Wed, 31 May 2023 12:12:58 +0200
From: Andrea Claudi <aclaudi@redhat.com>
To: Ido Schimmel <idosch@idosch.org>
Cc: netdev@vger.kernel.org, stephen@networkplumber.org, dsahern@gmail.com,
	leon@kernel.org
Subject: Re: [PATCH iproute2-next] treewide: fix indentation
Message-ID: <ZHcdqoGUEs+Qcfgs@renaissance-vector>
References: <aa496abb20ac66d45db0dcf6456a0ea23508de09.1685466971.git.aclaudi@redhat.com>
 <ZHbfVC03hq/wsHwG@shredder>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHbfVC03hq/wsHwG@shredder>
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 08:47:00AM +0300, Ido Schimmel wrote:
> On Tue, May 30, 2023 at 07:19:53PM +0200, Andrea Claudi wrote:
> > Replace multiple whitespaces with tab where appropriate.
> > 
> > Signed-off-by: Andrea Claudi <aclaudi@redhat.com>
> > ---
> >  bridge/vni.c   |  2 +-
> >  genl/ctrl.c    |  2 +-
> >  ip/ipaddress.c |  2 +-
> >  ip/ipmacsec.c  |  4 ++--
> >  ip/ipprefix.c  |  2 +-
> >  ip/ipvrf.c     |  2 +-
> >  lib/fs.c       |  2 +-
> >  lib/ll_types.c | 10 +++++-----
> >  rdma/dev.c     | 10 +++++-----
> >  tc/m_ipt.c     |  4 ++--
> >  tc/m_xt_old.c  |  4 ++--
> >  tc/q_fq.c      |  8 ++++----
> >  tc/q_htb.c     |  4 ++--
> >  tc/tc_core.c   |  2 +-
> >  14 files changed, 29 insertions(+), 29 deletions(-)
> 
> Thanks for the patch. Do you mind folding this one as well?
> 
> diff --git a/tc/f_flower.c b/tc/f_flower.c
> index 48cfafdbc3c0..d68c9d2a194b 100644
> --- a/tc/f_flower.c
> +++ b/tc/f_flower.c
> @@ -88,7 +88,7 @@ static void explain(void)
>                 "                       enc_ttl MASKED-IP_TTL |\n"
>                 "                       geneve_opts MASKED-OPTIONS |\n"
>                 "                       vxlan_opts MASKED-OPTIONS |\n"
> -               "                       erspan_opts MASKED-OPTIONS |\n"
> +               "                       erspan_opts MASKED-OPTIONS |\n"
>                 "                       gtp_opts MASKED-OPTIONS |\n"
>                 "                       ip_flags IP-FLAGS |\n"
>                 "                       enc_dst_port [ port_number ] |\n"
> 
> Before:
> 
> $ tc filter add flower help 2>&1 | grep opts
>                         geneve_opts MASKED-OPTIONS |
>                         vxlan_opts MASKED-OPTIONS |
>                        erspan_opts MASKED-OPTIONS |
>                         gtp_opts MASKED-OPTIONS |
> 
> After:
> 
> $ tc filter add flower help 2>&1 | grep opts
>                         geneve_opts MASKED-OPTIONS |
>                         vxlan_opts MASKED-OPTIONS |
>                         erspan_opts MASKED-OPTIONS |
>                         gtp_opts MASKED-OPTIONS |
>

Thanks for the review.
I'll include it in v2, and I'll fix another issue in tc flower help.


