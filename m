Return-Path: <netdev+bounces-1886-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA2FC6FF677
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 17:50:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 85D7E2818BB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 15:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153F0206B5;
	Thu, 11 May 2023 15:50:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 095F1650
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 15:50:14 +0000 (UTC)
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334F85FE9
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:50:12 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d9443c01a7336-1aaebed5bd6so63067335ad.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 08:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1683820211; x=1686412211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MmRSAygRmrdv/t+rz+NeF5UgVaNeeXyJ/jEbZtjBpdY=;
        b=JSH8dgP84eb6YvwBOLf+IPXtwPPDGndjab2t+rXp+uvckxxi66QM4SknwJhqwQX2Xe
         3QhyVRJr1acgJyacI03rBBl/n0yZYdf87fwVoXeAp/aGUDECxuczJH2x4jHcI2HiY4AW
         2Qchu79hkqEMFQZWtw4Q9QbuOMA6u4CXSMDey7cxWHtwLqEIpF5ye3p9u93eoNzwSd9P
         j1NR7QYy3kqbhSxyNRONaUF0dGd18qnha2Kk8doB9j38/xGE3jp0qTAa3D+yu87vOhpZ
         EFAkl+dphmGldFoROt0SCK8Sa+3DWaT0fSVUgte+iDoNzouALkByvYVELDMxSJUrnjoO
         cBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683820211; x=1686412211;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MmRSAygRmrdv/t+rz+NeF5UgVaNeeXyJ/jEbZtjBpdY=;
        b=Ue5HiwNHSvTJxlFX5FJzNeVP3yaf6uFBrLvUpnXsy5vCP1X0FkarpZGtF9lbWpw8X7
         sBJjYcfoSwdwjy9SB+sjLzdnUbYnXL1+RS0PPaTtUlTfmWBx4c2V8fKHfDutTTeTGhUw
         GL6j/aJbgIe/AYuFZ9f7xGKcElSMQ7H4PF9wSqk/C6Fct523MQAum3bEuzKEguqU19IB
         2+vUV/Wkgizy9TKqaGsJI5Sb+rjddt9mwKE94gWZnqXOIMsiRNptekBL6v/YeT0T1xR8
         iczndlHTVRjZtsIj53Glv8eGGgo0Jm8+BPG2NEaNHXyM5wE2t12r1elvHt6CjBqMTaWZ
         DiQw==
X-Gm-Message-State: AC+VfDyYfy2spx4TkJFYmWhT/r+Pk7v5BpldDYse5LLfB15VYjZGxQDk
	o30Jd/5k6VhDUlosjVhMHKTjSA==
X-Google-Smtp-Source: ACHHUZ7TMaprmQw66XLP25ACswn88ZDRUIinCtpjeLGNbxFUGHivqz3DskE6KPraVcUv55W12vZVPQ==
X-Received: by 2002:a17:902:da85:b0:1ac:a887:d344 with SMTP id j5-20020a170902da8500b001aca887d344mr11555124plx.19.1683820211658;
        Thu, 11 May 2023 08:50:11 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id iw1-20020a170903044100b001ac7af58b66sm6062495plb.224.2023.05.11.08.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 08:50:11 -0700 (PDT)
Date: Thu, 11 May 2023 08:50:09 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Simon Horman <simon.horman@corigine.com>
Cc: Bilal Khan <bilalkhanrecovered@gmail.com>, majordomo@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH] Fix grammar in ip-rule(8) man page
Message-ID: <20230511085009.72b9da9e@hermes.local>
In-Reply-To: <ZFyyK4Cvcn//yZdV@corigine.com>
References: <CA++M5eLYdY=UO2QBz17YLLw8OyG6cDYHm1dvs=mc8zQ7nPvYVA@mail.gmail.com>
	<ZFyyK4Cvcn//yZdV@corigine.com>
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

On Thu, 11 May 2023 11:15:23 +0200
Simon Horman <simon.horman@corigine.com> wrote:

> On Mon, May 08, 2023 at 01:05:02PM +0500, Bilal Khan wrote:
> > Hey there,
> > 
> > I have identified a small grammatical error in the ip-rule(8) man
> > page, and have created a patch to fix it. The current first line of
> > the DESCRIPTION section reads:
> >   
> > > ip rule manipulates rules in the routing policy database control the route selection algorithm.  
> > 
> > This sentence contains a grammatical error, as "control" should either
> > be changed to "that controls" (to apply to "database") or "to control"
> > (to apply to "manipulates"). I have updated the sentence to read:
> >   
> > > ip rule manipulates rules in the routing policy database that controls the route selection algorithm.  
> > 
> > This change improves the readability and clarity of the ip-rule(8) man
> > page and makes it easier for users to understand how to use the IP
> > rule command.
> > 
> > I have attached the patch file by the name
> > "0001-fixed-the-grammar-in-ip-rule-8-man-page.patch" to this email and
> > would appreciate any feedback or suggestions for improvement.
> > 
> > Thank you!  
> 
> FWIIW, I'm not sure that an attachment is the right way to submit patches.
> It's more usual to use something like git send-email or b4 to send
> basically what is in your attachment.
> 
> I'm sure Stephen will provide guidance if he'd like things done a different
> way.

Applied and did small fixups. Novices get more leeway in initial patch submissions.
The main requirements are that it correct, applies clean, and has required DCO.

