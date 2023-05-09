Return-Path: <netdev+bounces-1084-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B44AC6FC1FC
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:51:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87F392811B4
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 08:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD3C353BF;
	Tue,  9 May 2023 08:51:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A07AC17C2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 08:51:19 +0000 (UTC)
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6449C13D
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 01:51:18 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-3f396606ab0so124031cf.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 01:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683622277; x=1686214277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IraX+oUBLwvjqiInA0j8uPl6x32yOtC/TKYx6LHl7NM=;
        b=BLgnfB+PuGcbYmgEOPPmpjUx2YJHLULGn7h+bbr4+wdFwvgdYKdJkIZnX/xWFvmk4+
         acrXlWH6YS3jtuWkMhYWrOpI+JTot/uZ8ywxUXtxGnfzvMYlscQzw3ZjN5yxpMdOHpJF
         4t1Q/s6kedVAlxQPil8ZnhgWDWB6z1k0HuFpisZLHj+7c2u17bkb64u6UOimgJ5lqpd4
         9KCJrtHdxVY6ggT2DVru491nXjhjH2+zvUuKCN+3ezyImS/FPrnDqqg0NkNcbCISFIJw
         Iu1frp3INjfXlgCX1stSwSActYiO4ZiPmx6m1NrglJKAdNm3YYUpAzQ0MxXft4fviDcZ
         vXsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683622277; x=1686214277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IraX+oUBLwvjqiInA0j8uPl6x32yOtC/TKYx6LHl7NM=;
        b=ltReSYVWgt7cmL0HTO9atjID7rXnM+k6v2UsJ20WD+Jfpv+PCljC9CJKIIUdGXTkSe
         7AUbMRg9V22OoE+LPXbXrlRxPgWIVPSqU9zZgY5d08XEgYq5fuOqQGc8QHb5PfXquY/m
         FqRIznDFd1V2rXiJs+kupuYAp0OyafMKLHEXu7nUFKNt+CThSnpbDWfV8gJ2WwkPcZx6
         Ew98h5VQc/yHlkUZpIR/sqk7i3nO6mtNQ/bXMLv+867iOAsGN9jQP0wOj1+UA6BsNi6D
         yH+utQBaSiiOn+KhHjCluxWvEAvZ8SXX1U6eGX83JbWODeJzx0NxHN3Mg7FsEPL1UFyW
         rMHg==
X-Gm-Message-State: AC+VfDyN5CTvUyahSB8jKnaRizquAA1YnQxWTU7VaEhobFeRiukNWa5A
	B1bv2Nf/Pk/y8hRtTYaG5nnPnx1N85L+uOI2MWobAg==
X-Google-Smtp-Source: ACHHUZ7YU4f2zXcAlzkXjAsKg134MNWnY7UvWFVpebS39DMB6pR42HByDVKqHv4THJgichhxGBfyoI1EdjHW6lRd3Yo=
X-Received: by 2002:a05:622a:130e:b0:3ed:86f6:6eab with SMTP id
 v14-20020a05622a130e00b003ed86f66eabmr338833qtk.14.1683622277300; Tue, 09 May
 2023 01:51:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230509071207.28942-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20230509071207.28942-1-lukas.bulwahn@gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 10:51:06 +0200
Message-ID: <CANn89iKEqUFMNKb6axZpkLEJbhZB285-Vpiq_ybBB6LO9ny4SQ@mail.gmail.com>
Subject: Re: [PATCH] net: skbuff: remove special handling for SLOB
To: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Vlastimil Babka <vbabka@suse.cz>, netdev@vger.kernel.org, 
	kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 9, 2023 at 9:12=E2=80=AFAM Lukas Bulwahn <lukas.bulwahn@gmail.c=
om> wrote:
>
> Commit c9929f0e344a ("mm/slob: remove CONFIG_SLOB") removes CONFIG_SLOB.
> Now, we can also remove special handling for socket buffers with the SLOB
> allocator. The code with HAVE_SKB_SMALL_HEAD_CACHE=3D1 is now the default
> behavior for all allocators.
>
> Remove an unnecessary distinction between SLOB and SLAB/SLUB allocator
> after the SLOB allocator is gone.
>
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

