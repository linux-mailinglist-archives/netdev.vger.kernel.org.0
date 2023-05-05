Return-Path: <netdev+bounces-603-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 585B46F872C
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 18:59:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E74D4281075
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 16:59:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C38C2EE;
	Fri,  5 May 2023 16:59:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56628BF1
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 16:59:36 +0000 (UTC)
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858E8191FE
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 09:59:35 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-643a1656b79so716557b3a.3
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 09:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683305975; x=1685897975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TAdX7eg2ryjY56yRTcHERosjHmSEk4LPOkzOv4IolK4=;
        b=bMx0T2PEF73qajo+15koX2YRbehw38va851NXwnFtJ+mx7MFBGachyQS2rCSICBrJD
         nKl3fDRQ6PZZDEISPPiQZSRzx4rCQzf/9u6ObKtD99AUSrcE4OU8Vj3SvaXrc1Zpi59B
         UV63xHiILreJPwcB+0X2kpT7RwwK9XRo7b5AkpqRuRy3XspTbIVhbzCLZgFvamWVn2fL
         H+BHrFUyixTE6Zdvitgjhunz5DILR+NuAYE7b4iXO+wUA/9SVOhZ406miG+13lhozflK
         69B6dLb2TbWAICKHUngAXvDN+oZP9xOvotR9ROA2y7V/IGbBS1i7UNa/z2iTCPVGWiea
         529A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683305975; x=1685897975;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TAdX7eg2ryjY56yRTcHERosjHmSEk4LPOkzOv4IolK4=;
        b=ZILHQp4+VU9FZ16c0og4K/kbQIG05K+wegUwFcW+WdNlYhlk/XY7lYSwh0k4l20bvh
         R49FWbI9F7ucATehlUkW4rU1ISzlnBSVFCNMd+y/ImzX9bXDD6BjDLzxf/pM5e0qXlPl
         GRrVP/a7w+Lwdhlp4j/aURJuz5H+YPTF5FMmCoPtnCbfAWSBAqCEpKkU8Z31evzWCE3a
         tJxkcYavf+taN1ILByOwiFwiNg9RBPxvX3GwoBJ/u60gx/ZCxMZKQuKS40/aTmK+rAv8
         8XAps3zmsEB5ba7Jb08To6kbnp0eEH00x9PL2YHfHpNSe3WgfzrnHlI0H29XniaiEGvU
         UTAg==
X-Gm-Message-State: AC+VfDyMsQ2ZhhDOQNti71SZTDYpilkbXu6Za2dIjpp/AnFsvyrU+Lk7
	cxP7r4CSxtfI42PRTjTM8TAahA==
X-Google-Smtp-Source: ACHHUZ6FUzTYBCIMDTxJQxEa7xuKlQSBcvVlbcrDNPig9DMVntIYVrpgeqpY9QAuZ9kNhIc+Tjh/BQ==
X-Received: by 2002:a05:6a20:4305:b0:f0:219e:f11c with SMTP id h5-20020a056a20430500b000f0219ef11cmr2887725pzk.31.1683305975026;
        Fri, 05 May 2023 09:59:35 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id c25-20020aa78819000000b0064394d63458sm1871685pfo.78.2023.05.05.09.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 09:59:34 -0700 (PDT)
Date: Fri, 5 May 2023 09:59:32 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Chuck Lever <cel@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com,
 tom@talpey.com
Subject: Re: [PATCH RFC 1/3] net/tun: Ensure tun devices have a MAC address
Message-ID: <20230505095932.4025d469@hermes.local>
In-Reply-To: <168330132769.5953.7109360341846745035.stgit@oracle-102.nfsv4bat.org>
References: <168330051600.5953.11366152375575299483.stgit@oracle-102.nfsv4bat.org>
	<168330132769.5953.7109360341846745035.stgit@oracle-102.nfsv4bat.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 05 May 2023 11:42:17 -0400
Chuck Lever <cel@kernel.org> wrote:

> From: Chuck Lever <chuck.lever@oracle.com>
> 
> A non-zero MAC address enables a network device to be assigned as
> the underlying device for a virtual RDMA device. Without a non-
> zero MAC address, cma_acquire_dev_by_src_ip() is unable to find the
> underlying egress device that corresponds to a source IP address,
> and rdma_resolve_address() fails.
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  drivers/net/tun.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index d4d0a41a905a..da85abfcd254 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1384,7 +1384,7 @@ static void tun_net_initialize(struct net_device *dev)
>  
>  		/* Point-to-Point TUN Device */
>  		dev->hard_header_len = 0;
> -		dev->addr_len = 0;
> +		dev->addr_len = ETH_ALEN;
>  		dev->mtu = 1500;
>  
>  		/* Zero header length */

This is a bad idea.
TUN devices are L3 devices without any MAC address.
This patch will change the semantics and break users.

If you want an L2 address, you need to use TAP, not TUN device.

