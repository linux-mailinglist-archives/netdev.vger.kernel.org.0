Return-Path: <netdev+bounces-8957-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F8EE726676
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 18:53:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD2711C20A2D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 16:52:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A76341ACD4;
	Wed,  7 Jun 2023 16:52:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C13C174CB
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 16:52:58 +0000 (UTC)
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E287BA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 09:52:57 -0700 (PDT)
Received: by mail-ot1-x335.google.com with SMTP id 46e09a7af769-6af8b25fc72so5646350a34.3
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 09:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1686156777; x=1688748777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=15OvLU4bZZp/QMnLQsShIQCCNaBoSVvMpM7tsFhmiSY=;
        b=fYCu5JzQLHFqZubZDWbroyyNv5zyT/+nxCDUrNXOuJjtL6jHNN7J9zG9SRzF4mgsU1
         TS6DotmMHIjpH2GFsDFYJAvnjHRT8sIp/caRQokrduuzF7yPUOA5LGeveZlfUJ/UO8Z5
         cKxeOwtUfsSdd0gCoPrPHDeZakQ+XbhpefJjn9b/Covtxz3QeJ4m4cEJG+/MGY0UgFeV
         BgMIsHNTRDDOVWSonUJ0ToNG7eAnIe2l7/D3qDOMFrt8D8xLGPS/xoIucmGjoeaD3lgz
         8gNUf5ymj7Ikdg8Z7kK906Hpg1egCK3NrCjo94FQ4Xyylk5RUv50p0Fvw5Ldn8NAyRu/
         JxJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686156777; x=1688748777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=15OvLU4bZZp/QMnLQsShIQCCNaBoSVvMpM7tsFhmiSY=;
        b=liWWtyvUR5XJSbIxqW0mMcHxnga9n/B3UTczsqwnvDisqENP5bTJIJmbvZpzeNyYpY
         h8rC3ZHP5De8bAK2hlY3y17VdifYy4NdmhMQjZL6LdB4V6X4fQaeQkrp3/i3wr6ZZ/X2
         1wO7NKLAG2UW6LrxqunycM+PjdHkM++5YvQdcyQk0Kp7ciBDpay98JhP//HdAKDrJhs/
         jHPHLhoWnmALpY+j7v9F7TS+TIb34yxV0ZzhDcZB1OIv2/YeL9bSK/kTAAPu5rL6zDhj
         XuxqCIMiVNT1uGxPJPKcZcNSE3l63in5NhQDWmw0i42k0+s3aopj9dpL5yCfaifdoyk8
         2uNw==
X-Gm-Message-State: AC+VfDzGOptKl6GVieKASnkCi1gYkWdTkPNhWtLlDTyLkNsli/c5V9Zy
	yAgKJy8ce6qjPlWKSFZy9buqXA==
X-Google-Smtp-Source: ACHHUZ55sDwDShzh5tnLLDl6xwKbNF3bN+Mcf88+fJp+qFjG2Z1KSSlQiEm2nAxaq4s9ZHPPx6oWTA==
X-Received: by 2002:a05:6830:150e:b0:6b0:c632:ff59 with SMTP id k14-20020a056830150e00b006b0c632ff59mr5686629otp.19.1686156776800;
        Wed, 07 Jun 2023 09:52:56 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id lk8-20020a17090b33c800b0024de5227d1fsm1594786pjb.40.2023.06.07.09.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 09:52:56 -0700 (PDT)
Date: Wed, 7 Jun 2023 09:52:54 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Gal Pressman <gal@nvidia.com>, Edwin Peer <espeer@gmail.com>, David
 Ahern <dsahern@gmail.com>, netdev <netdev@vger.kernel.org>, Andrew
 Gospodarek <andrew.gospodarek@broadcom.com>, Michael Chan
 <michael.chan@broadcom.com>, Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next 1/4] netlink: truncate overlength attribute
 list in nla_nest_end()
Message-ID: <20230607095254.20a3394c@hermes.local>
In-Reply-To: <20230607093324.2b7712d9@kernel.org>
References: <20210123045321.2797360-1-edwin.peer@broadcom.com>
	<20210123045321.2797360-2-edwin.peer@broadcom.com>
	<1dc163b0-d4b0-8f6c-d047-7eae6dc918c4@gmail.com>
	<CAKOOJTwKK5AgTf+g5LS4MMwR_HwbdFS6U7SFH0jZe8FuJMgNgA@mail.gmail.com>
	<CAKOOJTzwdSdwBF=H-h5qJzXaFDiMoX=vjrMi_vKfZoLrkt4=Lg@mail.gmail.com>
	<62a12b2c-c94e-8d89-0e75-f01dc6abbe92@gmail.com>
	<CAKOOJTwBcRJah=tngJH3EaHCCXb6T_ptAV+GMvqX_sZONeKe9w@mail.gmail.com>
	<cdbd5105-973a-2fa0-279b-0d81a1a637b9@nvidia.com>
	<20230605115849.0368b8a7@kernel.org>
	<CAOpCrH4-KgqcmfXdMjpp2PrDtSA4v3q+TCe3C9E5D3Lu-9YQKg@mail.gmail.com>
	<0c04665f-545a-7552-a4c2-c7b9b2ee4e6b@nvidia.com>
	<20230606091706.47d2544d@kernel.org>
	<f2a02c4f-a9c0-a586-1bde-ff2779933270@nvidia.com>
	<20230607093324.2b7712d9@kernel.org>
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
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, 7 Jun 2023 09:33:24 -0700
Jakub Kicinski <kuba@kernel.org> wrote:

> > > 
> > > The problem is basically that attributes can only be 64kB and 
> > > the legacy SR-IOV API wraps all the link info in an attribute.    
> > 
> > Isn't that a second order issue? The skb itself is limited to 32kB AFAICT.  
> 
> Hm, you're right. But allocation larger than 32kB are costly.
> We can't make every link dump allocate 64kB, it will cause
> regressions on systems under memory pressure (== real world).
> 
> You'd need to come up with some careful scheme of using larger
> buffers.

Why does it all have to be a single message?
Things like 3 million routes are dumped fine, as multiple messages.

