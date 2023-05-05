Return-Path: <netdev+bounces-520-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 75D5C6F7E5A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A98DC1C2173E
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D90BA4C92;
	Fri,  5 May 2023 08:06:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81BE185F
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 08:06:24 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 420C417FEE
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 01:06:23 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-50bceaf07b8so2755867a12.3
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 01:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683273982; x=1685865982;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OQO9GYfoHR6v1wHD1SYJTb+uKa+0Nagnqvl5fRP9gAI=;
        b=B4/XH9pNgJf799/Y3A3ZQrs8OS694RPV08fNlPYBylNm3ZZSRYWvwUVXaurUycjA98
         qBSDdwNE+s2roQmRredqGRfCiumzPSjJMAw3Rc9s8Xk4bZYszWRg7scsxw54rHn43GnG
         Y4XUWwiZ61jqBCJ59Reg4WaY9/P6eboTP78SzYHs5pW5yohxVUvST1ZajwfFrDS7gO6D
         1VssYkaClHB/tFpgW5Qqppr9L0NfPkJrRVc+obNDcebUhfnL3PXTF4m1bZ3mM7urVb7G
         FznlW0cNf24Q1e7UKsyQt+Z5NsogQdxKkq3mJ6f1FVKZINd2fqevhb1QACnQAUzMeMyd
         Rdng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683273982; x=1685865982;
        h=in-reply-to:content-disposition:mime-version:references
         :mail-followup-to:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OQO9GYfoHR6v1wHD1SYJTb+uKa+0Nagnqvl5fRP9gAI=;
        b=M1Y+ek/UsdqTtHiihxfvQ3rq8q6A2YFsq2YWpyp6O5X4++cL4Y8DcrX0jcHfifYP+Y
         n/K3NK8AgDS1W5ATWB7uz2PYS5xIzd3FCSkryGKEUhGGfpAl2Sfv+cCt3SsKa+nqaTk2
         DVTeqFMcAIZoxFaaO0zO9FUFleBgaFTCQwYqFqKsNZWL5n14zD9eYYwDGSZex+yVwm9U
         OASI0o9zaaO1Wj3pjkUvwOCPvCSBQG7CYyOsNQCSUwCUZKi/9R7mjvM5Ifo0yIg1qBcY
         RnLdZGasWX2hlteXoRIbjZjGh4jQDp+H/2iuVRUjqgJ1KyWAImE9JJbRM8QjOfsuohfC
         joFA==
X-Gm-Message-State: AC+VfDz83lyWQfmIqCBls1FTXADAFViRjwwo0ou0y+ICEJaMF5ACuarg
	bxL2EgH+SKVkd5rzItLXgns=
X-Google-Smtp-Source: ACHHUZ7sYz5EISJlOIo3r2jQ6+gqM6fCr4Of5HxKSunmjDpBLIn1hcrE5PYoRJ19hxHcLjh4NtfdcA==
X-Received: by 2002:aa7:cf92:0:b0:50b:c3a3:be7c with SMTP id z18-20020aa7cf92000000b0050bc3a3be7cmr588573edx.30.1683273981659;
        Fri, 05 May 2023 01:06:21 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id h21-20020a170906719500b0095952f1b1b7sm603406ejk.201.2023.05.05.01.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 01:06:21 -0700 (PDT)
Date: Fri, 5 May 2023 09:06:18 +0100
From: Martin Habets <habetsm.xilinx@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org, ecree.xilinx@gmail.com,
	linux-net-drivers@amd.com
Subject: Re: [PATCH net] sfc: Add back mailing list
Message-ID: <ZFS4+g1GzU+d7/ZS@gmail.com>
Mail-Followup-To: Leon Romanovsky <leon@kernel.org>, davem@davemloft.net,
	kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
	netdev@vger.kernel.org, ecree.xilinx@gmail.com,
	linux-net-drivers@amd.com
References: <168318528134.31137.11625787711228662726.stgit@palantir17.mph.net>
 <20230504081049.GU525452@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230504081049.GU525452@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 11:10:49AM +0300, Leon Romanovsky wrote:
> On Thu, May 04, 2023 at 08:28:01AM +0100, Martin Habets wrote:
> > We used to have a mailing list in the MAINTAINERS file, but removed this
> > when we became part of Xilinx as it stopped working.
> > Now inside AMD we have the list again. Add it back so patches will be seen
> > by all sfc developers.
> 
> They are invited to join netdev community and read mailing list directly.

We're not all using lore and lei yet. Until we are this list helps us
respond quicker to emails.

> 
> > 
> > Signed-off-by: Martin Habets <habetsm.xilinx@gmail.com>
> > ---
> >  MAINTAINERS |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index ebd26b3ca90e..dcab6b41ad8d 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -18987,6 +18987,7 @@ SFC NETWORK DRIVER
> >  M:	Edward Cree <ecree.xilinx@gmail.com>
> >  M:	Martin Habets <habetsm.xilinx@gmail.com>
> >  L:	netdev@vger.kernel.org
> > +L:	linux-net-drivers@amd.com
> 
> Is this open list or we will get bounce messages every time we send to it?

We've been using this and other open lists we have for several months now
and have not noticed any bounces. This list is as open as the old one we've
had since 2009.

> 
> Thanks
> 
> >  S:	Supported
> >  F:	Documentation/networking/devlink/sfc.rst
> >  F:	drivers/net/ethernet/sfc/
> > 
> > 
> > 

