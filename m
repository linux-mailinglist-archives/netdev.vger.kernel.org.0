Return-Path: <netdev+bounces-11021-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7A557311C5
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:08:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 050291C20D2E
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA1305254;
	Thu, 15 Jun 2023 08:08:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41C84431
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:08:44 +0000 (UTC)
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5EF11BE5
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 01:08:42 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-970056276acso218525066b.2
        for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 01:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686816521; x=1689408521;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Cpdkr/wPvRE/vs87z1EtmaYpr+lNnrwXKY/A12YJZ7g=;
        b=oNavpz680u+0HkNZsU2CVlgEufmbtO1dW/KfjnHB2OHtvf4nPeL6/v7Tj/c1mwXo6G
         q2LkFHx8jd9eazHP5PrHBsT8Cwp9DEnirPUG6ISVjrJOg6MpCLSSBKV1kJVfUdrfv8iB
         RjuFrazxhXyeVyBEzyJg4LNBTIQgR5No668OIUSUfzCPxiA/20Mt41bEw9XWCoOcRylW
         nYzyNjxbnaqaGsk4L9Se2DyFnZ8/gsl0zGhBEM25+yNRXIbG/xHxUsKfLtvjqztwdmUJ
         BadaG1SIU9BR32tlSaEp2C/p/7uB/cci2ToFssQ6mEdZECt07QOaNITpe39yCPFtUBnm
         LSRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686816521; x=1689408521;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:mail-followup-to:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Cpdkr/wPvRE/vs87z1EtmaYpr+lNnrwXKY/A12YJZ7g=;
        b=GgwghCWterI499PJbU9INzRKYbz2bbn6ivKYX7nGZgA8RW3/GH7vNom6nRYFaGxQ32
         dWDuuyE1Zcp1X5Sv5X//9UpmWywp8t324TQ/NnMfmDtlfzWjeFIIjTtT97cAEJ6V5EPJ
         kSN0LiX7UZOEz847OOraCJRLm1rmUWqRRwTERxZiAxNZ6IfWDVMNaJgKJijIlInQkXE2
         C1j6GAtEOJ9mElp9v9PFrw/JnUCg3iMOyOICbk8JtKSC0VywwbKx1FJq7I0iQki/i9FL
         i1PrYz6tPAaACYC2OP+iH8Ub1MEYTRc0KykhcjzfxYKp1nSdGUyuMr8hq5GLvoZSZfdA
         t7Yw==
X-Gm-Message-State: AC+VfDyby9CnL3jywk4INHPKWj8/kMSFxq8/YvWM96mSsq7tNQhYAYJH
	aIBvfnv9H1vkqevcPe89Eus=
X-Google-Smtp-Source: ACHHUZ7OabQJdLw7Td4tglGKkpB4Dbx1BVPkzGFNSzRsW2kla0id3IPoGrR/QOYhWkdBuJ07NpIJzQ==
X-Received: by 2002:a17:907:948a:b0:982:a536:a275 with SMTP id dm10-20020a170907948a00b00982a536a275mr763376ejc.7.1686816520880;
        Thu, 15 Jun 2023 01:08:40 -0700 (PDT)
Received: from gmail.com ([81.168.73.77])
        by smtp.gmail.com with ESMTPSA id lw4-20020a170906bcc400b009787209732esm9109126ejb.143.2023.06.15.01.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jun 2023 01:08:40 -0700 (PDT)
Date: Thu, 15 Jun 2023 09:08:37 +0100
From: Martin Habets <habetsm.xilinx@gmail.com>
To: Jakub Kicinski <kuba@kernel.org>,
	=?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-net-drivers@amd.com, Fei Liu <feliu@redhat.com>
Subject: Re: [PATCH net] sfc: use budget for TX completions
Message-ID: <ZIrHBZ3amADde4zE@gmail.com>
Mail-Followup-To: Jakub Kicinski <kuba@kernel.org>,
	=?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	ecree.xilinx@gmail.com, davem@davemloft.net, edumazet@google.com,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-net-drivers@amd.com, Fei Liu <feliu@redhat.com>
References: <20230612144254.21039-1-ihuguet@redhat.com>
 <ZIdCFbjr0nEiS6+m@boxer>
 <CACT4oucSRrddFYaNDBsuvK_4imDZUvy9r2pvHp8Ji_E=oP6ecg@mail.gmail.com>
 <ZIl2Dw9Ve0b30WmV@gmail.com>
 <CACT4oufPV6FbQ7xOU8uPOS2SsA6R-F+D5H80SnrH3BEOe+WoMA@mail.gmail.com>
 <20230614103131.50a9abf1@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230614103131.50a9abf1@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FSL_HELO_FAKE,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 10:31:31AM -0700, Jakub Kicinski wrote:
> On Wed, 14 Jun 2023 12:13:11 +0200 Íñigo Huguet wrote:
> > On Wed, Jun 14, 2023 at 10:03 AM Martin Habets <habetsm.xilinx@gmail.com> wrote:
> > > On Mon, Jun 12, 2023 at 04:42:54PM +0200, Íñigo Huguet wrote:  
> > > > Documentations says "drivers can process completions for any number of Tx
> > > > packets but should only process up to budget number of Rx packets".
> > > > However, many drivers do limit the amount of TX completions that they
> > > > process in a single NAPI poll.  
> > >
> > > I think your work and what other drivers do shows that the documentation is
> > > no longer correct. I haven't checked when that was written, but maybe it
> > > was years ago when link speeds were lower.
> > > Clearly for drivers that support higher link speeds this is an issue, so we
> > > should update the documentation. Not sure what constitutes a high link speed,
> > > with current CPUs for me it's anything >= 50G.  
> > 
> > I reproduced with a 10G link (with debug kernel, though)
> 
> Ah.

Hmm, we usually don't optimise the driver for debug kernels. The delays
introduced can make it impossible for CPUs to keep up with high bandwidths.
Having said that I did not expect this to fail at only 10G.

> 
> > > > +#define EFX_NAPI_MAX_TX 512  
> > >
> > > How did you determine this value? Is it what other driver use?  
> > 
> > A bit of trial and error. I wanted to find a value high enough to not
> > decrease performance but low enough to solve the issue.
> > 
> > Other drivers use lower values too, from 128. However, I decided to go
> > to the high values in sfc because otherwise it can affect too much to
> > RX. The most common case I saw in other drivers was: First process TX
> > completions up to the established limit, then process RX completions
> > up to the NAPI budget. But sfc processes TX and RX events serially,
> > intermixed. We need to put a limit to TX events, but if it was too
> > low, very few RX events would be processed with high TX traffic.
> > 
> > > > I would better like to hear the opinion from the sfc maintainers, but
> > > > I don't mind changing it because I'm neither happy with the chosen
> > > > location.  
> > >
> > > I think we should add it in include/linux/netdevice.h, close to
> > > NAPI_POLL_WEIGHT. That way all drivers can use it.
> > > Do we need to add this TX poll weight to struct napi_struct and
> > > extend netif_napi_add_weight()?
> > > That way all drivers could use the value from napi_struct instead of using
> > > a hard-coded define. And at some point we can adjust it.  
> > 
> > That's what I thought too, but then we'd need to determine what's the
> > exact meaning for that TX budget (as you see, it doesn't mean exactly
> > the same for sfc than for other drivers, and between the other drivers
> > there were small differences too).
> > 
> > We would also need to decide what the default value for the TX budget
> > is, so it is used in netif_napi_add. Right now, each driver is using
> > different values.
> > 
> > If something is done in that direction, it can take some time. May I
> > suggest including this fix until then?
> 
> Agreed. Still needs a fixes tag, tho.

Fine for me. From your other response it seems trying to generalise this
is not the longer term solution.

Martin

