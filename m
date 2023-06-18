Return-Path: <netdev+bounces-11819-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D87B734931
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 00:52:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE32A280F9D
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 22:52:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EE8BBA4B;
	Sun, 18 Jun 2023 22:52:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E678480
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 22:52:39 +0000 (UTC)
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4486C1BB
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 15:52:38 -0700 (PDT)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-570808d8ddeso27149487b3.0
        for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 15:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687128757; x=1689720757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QIEG8GOA507fs9MNiQMm3/fimoMx14sqMBBQu0RmZs0=;
        b=fFovYuJ2zVnO105E5MI3L+ZRAJEVNQuTAdl4sZoxwc2OAOQ/89vUg4uN2oZHhaDycs
         ybTKPVgGEHxulB7/w2UEIReph8XISNDraYrsJXE3Y5PCRJN0A9mX5pN6f3G8aciuqMnH
         oqYJ8msV4dqv1YH4MbgaqtprLOiw4myQpYWRHE3SLy1LcYQmSOA32Ib9EImQGyBru6ld
         xS4XmlupQwEvVLDBDhElGIyn2NHMhbnKE1ZgV5ncpBiDLZQUSLv2dIUU91dWg3JlhtZO
         o4cw/AsNZUzCRif7MxqR7Md8Z7GWoFiLeSseW5B6j1Ve5/uE3FwS0yjThOkIX5NWLVQZ
         UYEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687128757; x=1689720757;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QIEG8GOA507fs9MNiQMm3/fimoMx14sqMBBQu0RmZs0=;
        b=IGh+Lc9ZrrTrFkpFJ6tPyog3MtWm+WQZXMoKCKXJu/rhM4lkuVD5Ip2Cr9WEG5JAun
         K0AXug7rsXljyrDy47lqbF1+Eui1eYnDxproQZRJhd/MmSwXVdpBtI/l1/lwCO3unFZD
         4Thh+E4eMLKSYdFKASKdDZFedMz2huIrMfmNQlSGL6iFfK5Z0g0DujFUs3gJbux5DQMy
         J5OKUhPECsZ4YZtPw7NTUli23FdyixKfjoM5PW2MvUDsCQJbAe6KavQ6yGrHJMNZo06z
         cauvVQwfWqiTTcY6OEwuA5uotJGc83a9f9FX2XKLBR7gZsR8Fn14b/HAumksRGyQT35r
         eRHw==
X-Gm-Message-State: AC+VfDxSjVZZuQLP/tyeszWWCgqbInG2KcmTua1fiPzOPgQ5UP1rlSGa
	o6ipZ5YyK6Z9Smgdk40x8MkYYLOoiHA=
X-Google-Smtp-Source: ACHHUZ7RfzL7qMEJu6geNs1svFcvKOljc5E2l9JhKSykkdiMdui/Jtv0a3/46k9vfwb23NJ/cFY/KQ==
X-Received: by 2002:a81:a0d3:0:b0:56c:ff9d:8cd9 with SMTP id x202-20020a81a0d3000000b0056cff9d8cd9mr9316785ywg.7.1687128757427;
        Sun, 18 Jun 2023 15:52:37 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:b348:50b3:4f6e:fba9])
        by smtp.gmail.com with ESMTPSA id d68-20020a814f47000000b00559f1cb8444sm2891464ywb.70.2023.06.18.15.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jun 2023 15:52:36 -0700 (PDT)
Date: Sun, 18 Jun 2023 15:52:35 -0700
From: Cong Wang <xiyou.wangcong@gmail.com>
To: Ignacy Gawedzki <ignacy.gawedzki@green-communications.fr>
Cc: netdev@vger.kernel.org
Subject: Re: Is EDT now expected to work with any qdisc?
Message-ID: <ZI+Ks1imeX3VvuTv@pop-os.localdomain>
References: <20230616173138.dcbdenbpvba7cf3k@zenon.in.qult.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616173138.dcbdenbpvba7cf3k@zenon.in.qult.net>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 07:31:38PM +0200, Ignacy Gawedzki wrote:
> Hi,
> 
> I've been lately playing around with setting tstamp in BPF in clsact,
> in order to pace some traffic, both locally generated and forwarded.
> 
> All the code examples I could find suggest that this mangling of tstamp
> will only work if the fq qdisc is set on the network interface.  But
> my experiments seem to indicate that regardless of the actual qdisc,
> be it fq, fq_codel, pfifo_fast, or even noqueue, the delivery time set
> in tstamp is always honored, both in sending (output) and forwarding,
> with any actual network interface driver I tried.

Scheduling packets in an order is the responsibility of Qdisc, it is
generic, does not define any specific order. So whether ordering packets
by tstamp is Qdisc-specific.

> 
> I tried very hard to find a confirmation of my hypothesis in the
> kernel sources, but after three days of continuous searching for
> answers, I'm starting to feel I'm missing something here.
> 
> So is it so that this requested delivery time is honored before the
> packet is handed over to the qdisc or the driver?  Or maybe nowadays
> pretty much every driver (including veth) honors that delivery time
> itself?

It depends. Some NIC (and its driver) can schedule packets based on
tstamp too, otherwise we have to rely on the software layer (Qdisc
layer) to do so.

Different Qdisc's have different logics to schedule packets, not all
of them use tstamp to order and schedule packets. This is why you have
to pick a particular one, like fq, to get the logic you expect.

Thanks.

