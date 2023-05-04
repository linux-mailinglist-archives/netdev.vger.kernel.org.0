Return-Path: <netdev+bounces-479-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E20D06F79C2
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 01:38:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E55111C2163B
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 23:38:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4D5E547;
	Thu,  4 May 2023 23:38:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71446156C1
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 23:38:23 +0000 (UTC)
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED8AD12096
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 16:38:21 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id af79cd13be357-74df41e2e61so59126585a.3
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 16:38:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1683243501; x=1685835501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/gY9M2acR+3B99eJKlwcbq+RpQy8KwY2Igz1huywzWE=;
        b=JyA0TP+u0mMW2vF/60NL6mFNPKLg9sWn/tFvYi/QJWrcoMlG1YkAsZ1X20PMUmoHBC
         ZZA0q0zC/mD1lVBjl4io7sNWViCxhUVv8WFRROQYCUjqtHua+Ueb2w7QgkSDC/8O7vMR
         SLHn8f6fwiPisHuQaux7DJi7v7QOTaNIiBSoNBW39F9TTKAo1t0RDOQ5wdirRmCxYIPP
         QX8pzm9G+6xKn/ODWyVK1V4Md1sVFMkeSPKWOD4meZkQ3qTo6YlIG5zixR9XvcdZtwez
         UOfXYXzWXCIljZxiQdIIuQN6CLcLn+Ki24mrqSpvpBCm8l9NmdB9FQkc+iOe+OPvd2Yv
         HrNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683243501; x=1685835501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/gY9M2acR+3B99eJKlwcbq+RpQy8KwY2Igz1huywzWE=;
        b=TV0xAJd3KXbx8Rybl1N8HNsjsEtr1sINDA18KxIG/wMCn5D44WLFv+ot8w+0NQmSh5
         pPA7ChyNgP6EtbRNdEyr0Gwf2KK0Pqvc2XOVikza7z7fEfwy1cEwBsDu+acQ3lE8q22l
         0jci5yD9BLvv94SI1JbpC+L+k17cj1gRTA8tPL2QxjPV7KVEgJmV+29R28vLWmi4wJzc
         G8v6bFfFL4HjnXoxpLMCbNM5sqcvvz2ywNqnStfTs66Ah5YMPoRtAr7kvs9hyvTttEPG
         FEXIENJthviavsFoozOa8Ze72K1V/H6vHq1lj8t1u52J+ftzQCGEOMkQiAEEY/o2Eb8K
         mlGg==
X-Gm-Message-State: AC+VfDz5RCDzd2F2DlHprsxI2EM4uFWXugAUqPJPccCqPdeklg4FN0Rm
	RElmxnT30t0VOWYWwVvvDWlricEOBXH1IRKtWZ0=
X-Google-Smtp-Source: ACHHUZ6il3y3jDyNzcEsRrGhcU8Lm4PUG80720FMJjXDvsBU1bYgpSLHGU+pWZPADpl/29depSqZug==
X-Received: by 2002:ac8:5746:0:b0:3ef:469a:7f8c with SMTP id 6-20020ac85746000000b003ef469a7f8cmr8635553qtx.67.1683243501115;
        Thu, 04 May 2023 16:38:21 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-68-25-194.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.68.25.194])
        by smtp.gmail.com with ESMTPSA id c6-20020a05620a134600b0074cf009f443sm164113qkl.85.2023.05.04.16.38.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 16:38:20 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.95)
	(envelope-from <jgg@ziepe.ca>)
	id 1puiWh-007jip-RK;
	Thu, 04 May 2023 20:38:19 -0300
Date: Thu, 4 May 2023 20:38:19 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Leon Romanovsky <leon@kernel.org>, Eli Cohen <elic@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	linux-rdma <linux-rdma@vger.kernel.org>,
	"open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
Subject: Re: system hang on start-up (mlx5?)
Message-ID: <ZFRB6zydIoADEMLz@ziepe.ca>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
 <91176545-61D2-44BF-B736-513B78728DC7@oracle.com>
 <20230504072953.GP525452@unreal>
 <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46EB453C-3CEB-43E8-BEE5-CD788162A3C9@oracle.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 07:02:48PM +0000, Chuck Lever III wrote:
> 
> 
> > On May 4, 2023, at 3:29 AM, Leon Romanovsky <leon@kernel.org> wrote:
> > 
> > On Wed, May 03, 2023 at 02:02:33PM +0000, Chuck Lever III wrote:
> >> 
> >> 
> >>> On May 3, 2023, at 2:34 AM, Eli Cohen <elic@nvidia.com> wrote:
> >>> 
> >>> Hi Chuck,
> >>> 
> >>> Just verifying, could you make sure your server and card firmware are up to date?
> >> 
> >> Device firmware updated to 16.35.2000; no change.
> >> 
> >> System firmware is dated September 2016. I'll see if I can get
> >> something more recent installed.
> > 
> > We are trying to reproduce this issue internally.
> 
> More information. I captured the serial console during boot.
> Here are the last messages:

Oh I wonder if this is connected to Thomas's recent interrupt and MSI
rework? Might need to bisection search around those big series

Jason

