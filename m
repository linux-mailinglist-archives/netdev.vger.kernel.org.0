Return-Path: <netdev+bounces-6681-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 015947176D1
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:28:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A7FD928134B
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:28:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFA9A63D7;
	Wed, 31 May 2023 06:28:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAEB20F3
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:28:13 +0000 (UTC)
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83CFE99
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:28:11 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-510f525e06cso9026397a12.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685514490; x=1688106490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QewyL27flyNpLPvt6+h/RLi64grCFg+W6Fvm1097mHc=;
        b=HAHcf94Om2q7gDqTFwUw8NtvgC5bN0dIfdp3Q9sLqT8eebBcXIW+gffmJGQ/mEnX8f
         Y5xBIPOyRXp6YZXGsvM899FRzK5txtvK//I2qrcMuDAa1fxGUUSe+hnokIFLVLW05as9
         UFIxiCnoAFv5OnywcCEr+FZbl1x7y6HMD3WHXrFWbiIDI/TFz6W5wxKvELpXmCBxP9zC
         udQ1CGDtjAm4uexE3Srd5e5Arofdh8QsBwdBpfKoDrSoZM9FWaTQUqW6Upsc33wFk6aL
         8m85ddu8AuX/WtAzlr9OVnYq8eFKFfOxKQ9/V9kWU/KYKDpvPG6oYEyq6fd2WfFFb8WG
         V4aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685514490; x=1688106490;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QewyL27flyNpLPvt6+h/RLi64grCFg+W6Fvm1097mHc=;
        b=ffDMaUpnhyUGrXOFrhvkhM6Bf3ZWUouFYpeplGSxxXEeiJbSUPXfYquEk8hNuova2T
         fKLhv0NGb7eqhZhMkh4sY4h8AF83DXkgKYeAInmwRRIfiLPNUEO2EKdOYTiaWTkkc8oo
         rASYqLjkQe/bIVtDObbjMzSC9KS1m2D/Z533oUHdDJyXyyHm1D8x3a0XK1RiHqDv9YAt
         ac1wd7lDtU6ZixlL3LCoXXWdLeIRL2dFyUh2Wd3QLK5itRHuy8CDh6gFswwxdP45G3M0
         70/dOLWf4/cZehtV6GJFfH3I7YbEvbbkXbi7LZ0IxULUpuuzpyhMMCQUbgLyWmxZL11e
         skLQ==
X-Gm-Message-State: AC+VfDzda28FDy7pTi+YEzrUmKKpv3BCZeVFZs82i6mjEMgEHa7zpEWu
	1uPRXVrIPvAwrCxaBgRzwsvTHg==
X-Google-Smtp-Source: ACHHUZ5OUYRAJm5fMAFU+qOoPd23fUeCOunQJq1c7PMrnIugoKAuMgcnLleoZzSIu7Srn62COEpHWQ==
X-Received: by 2002:a17:907:988:b0:94f:2a13:4e01 with SMTP id bf8-20020a170907098800b0094f2a134e01mr3723628ejc.74.1685514489928;
        Tue, 30 May 2023 23:28:09 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id t24-20020a170906179800b00968db60e070sm8380104eje.67.2023.05.30.23.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 23:28:09 -0700 (PDT)
Date: Wed, 31 May 2023 08:28:07 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com
Subject: Re: [PATCH net-next] devlink: make health report on unregistered
 instance warn just once
Message-ID: <ZHbo95hVv5Fimlna@nanopsycho>
References: <20230531015523.48961-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531015523.48961-1-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 31, 2023 at 03:55:23AM CEST, kuba@kernel.org wrote:
>Devlink health is involved in error recovery. Machines in bad
>state tend to be fairly unreliable, and occasionally get stuck
>in error loops. Even with a reasonable grace period devlink health
>may get a thousand reports in an hour.
>
>In case of reporting on an unregistered devlink instance
>the subsequent reports don't add much value. Switch to
>WARN_ON_ONCE() to avoid flooding dmesg and fleet monitoring
>dashboards.
>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Thanks!

