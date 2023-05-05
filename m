Return-Path: <netdev+bounces-607-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 59DD76F87C9
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 19:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FA091C21950
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 17:40:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC97EC8C4;
	Fri,  5 May 2023 17:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB870BE62
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 17:40:21 +0000 (UTC)
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B0BDF1
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 10:40:20 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id 4fb4d7f45d1cf-50bc3a2d333so3164124a12.0
        for <netdev@vger.kernel.org>; Fri, 05 May 2023 10:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google; t=1683308419; x=1685900419;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=0oBOSqhhaoBmXD0LBMvyZMXJBBJNYX+Topc5ijdmXI8=;
        b=t+u++Aw45D89f3fDxhqYIuNL8DNXF0phQeQntUmFwzTjyVuKdDsljwnD+nJFyI6PQp
         HBFDQ257+QXFf2vyMzIVognMHU4XXYaBwAcXvJ+JBnq63f7VNbQopXutLbB9BfjiehPh
         WlyQ3bDMknzcs5jx8/0wxvVPBnn5icGG+E5cw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683308419; x=1685900419;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0oBOSqhhaoBmXD0LBMvyZMXJBBJNYX+Topc5ijdmXI8=;
        b=cy7Hy0gIseMwA8wgjqoRQRdt6CupwFLShy9E6ncyHRisRyFFz91eVMmDM8DF/LKSNN
         z8ElV4smBum+vxr1H/o3ujo4On7IoBj/B/e6WSy2siAU5m6lSNjYnYZ/PmdWSb9aQehj
         plE30yfeQPuGfZsVHuIQYHjVceUSaP2bVLxSXOHSOm5JrtcYnLdtoX10+dxH/6q7B7v2
         ev+K6atGfWADKJY1Os+2D2SjMushboTzZAwU/1mNqCGDuUv+oFDTZIcAz+AMTqO6MvrE
         FSwiGF9ILAWx2YoBvaJFeqPmzJtzM1jG0dFKZkyxD5HKxkF+QsJj8OjwzrKEDrXpBP6T
         nBvg==
X-Gm-Message-State: AC+VfDxqAUt1iU0SleOTyTYYtMeDpi15lPo2SUsjVfpzjGw1QiUuPzwn
	jVhgtjJuFC/YHx/jfGpBtNNycg==
X-Google-Smtp-Source: ACHHUZ4uAi6poDBxDSeHyV00tlVBo8UvFfODxaZvspI2szvZgexJN5L3yv4gf/UJrcEqxjzLtKw8BQ==
X-Received: by 2002:a17:907:ea9:b0:958:5474:a84a with SMTP id ho41-20020a1709070ea900b009585474a84amr2352212ejc.38.1683308418957;
        Fri, 05 May 2023 10:40:18 -0700 (PDT)
Received: from cloudflare.com (79.184.132.119.ipv4.supernova.orange.pl. [79.184.132.119])
        by smtp.gmail.com with ESMTPSA id o18-20020a170906359200b009534603453dsm1180377ejb.131.2023.05.05.10.40.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 10:40:18 -0700 (PDT)
References: <20230502155159.305437-1-john.fastabend@gmail.com>
 <20230502155159.305437-11-john.fastabend@gmail.com>
User-agent: mu4e 1.6.10; emacs 28.2
From: Jakub Sitnicki <jakub@cloudflare.com>
To: John Fastabend <john.fastabend@gmail.com>
Cc: daniel@iogearbox.net, lmb@isovalent.com, edumazet@google.com,
 bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
 andrii@kernel.org, will@isovalent.com
Subject: Re: [PATCH bpf v7 10/13] bpf: sockmap, build helper to create
 connected socket pair
Date: Fri, 05 May 2023 19:39:58 +0200
In-reply-to: <20230502155159.305437-11-john.fastabend@gmail.com>
Message-ID: <87bkiyn0ce.fsf@cloudflare.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 02, 2023 at 08:51 AM -07, John Fastabend wrote:
> A common operation for testing is to spin up a pair of sockets that are
> connected. Then we can use these to run specific tests that need to
> send data, check BPF programs and so on.
>
> The sockmap_listen programs already have this logic lets move it into
> the new sockmap_helpers header file for general use.
>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>
> ---

Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>

