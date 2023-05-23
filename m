Return-Path: <netdev+bounces-4678-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CD7870DD6A
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:26:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0F414281321
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:26:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B48BF1E506;
	Tue, 23 May 2023 13:26:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A415C1DDFB
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:26:40 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B999118
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:26:34 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f41d087a84so34749105e9.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684848392; x=1687440392;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wa8882brqQgfaqBSNJBl6uslG94ncgU4uoIf58nOBLw=;
        b=hdIPaBpjmBbqcN3z/LBvM13heonTzENrjLNOAmN61bjlkA4i2DYkpHXbtD2cq1teuY
         A7PxoQtJy5yrhpf3Q77PNeWeu8EER5SPmAbDb+SOKSxLIN+HJnjmhyh3MafFe9Y1Jqdj
         c6Mh8cGB1o9lzktYb454ARyJ+GBdGFUyeyvm8AsSfNagUEGymxFf/hDqVSWxEqCCR2E+
         xP0AQZm52mA73lAFywKWwJTz/NHFcfpg3GLoysZw4z5dWc0LGQFwXoqj9sT2q2fSYRjP
         RIzrJTJlZX+byxxlCp+CBLXrz8pEDaD8lOAe/18VotOXjQAUBusvvqf4MiPcQFQqw1nO
         apkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684848392; x=1687440392;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wa8882brqQgfaqBSNJBl6uslG94ncgU4uoIf58nOBLw=;
        b=ZrShSOGZFyUeAxT6UXl8H+yAdGyf1JVqSO92wvd/BMYB9fzilQBaKWb6acKzJUPstf
         lJZYdPONXPmW+x4YC8CykCUdjRZB+JMKP6TUGlCWnMWWNMC/R7fgliQBUEO4153fkh0t
         15dCpVnW1tc3lpla2OYSbbuV3O9kPqABtoWxwFlTyhscm7vPo9eWHyIPnsRdKvnXONhw
         kYGkYJsswuGA5FOxcYtrFwZ+K1eejViSk9uXGcPFYrXV5kOFr7ilnasCl3uD4alnNo5o
         vDHvNUaqIXqzUfED2peXVdarQhVA4LY8ES2yH5pY5V0geDOLSH+cdyCCsv4lGtMV6+l1
         J/Dw==
X-Gm-Message-State: AC+VfDz0kQuOk8ZFpTVAkjLcRMtDZTSdDLdN9PkQOZcXQyecacmyTQQi
	5OdmdIo1cB99WXqPGqUcYlmXVQ==
X-Google-Smtp-Source: ACHHUZ4e5cRbt4cxwX5emt+5fpWZHlvYcRSNhQa3SR8qnr5dS6GXOwY9LQ3zqH5O4WVGbRWW2wDCSw==
X-Received: by 2002:a7b:c8d9:0:b0:3f4:1ce0:a606 with SMTP id f25-20020a7bc8d9000000b003f41ce0a606mr10206652wml.1.1684848392523;
        Tue, 23 May 2023 06:26:32 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m25-20020a7bcb99000000b003f195d540d9sm15044720wmi.14.2023.05.23.06.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 06:26:31 -0700 (PDT)
Date: Tue, 23 May 2023 15:26:30 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Cc: "David S. Miller" <davem@davemloft.net>,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vlad Yasevich <vyasevic@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH net] ipv6: Fix out-of-bounds access in ipv6_find_tlv()
Message-ID: <ZGy/BrpnnxALpjqF@nanopsycho>
References: <20230523082903.117626-1-Ilia.Gavrilov@infotecs.ru>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230523082903.117626-1-Ilia.Gavrilov@infotecs.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 23, 2023 at 10:29:44AM CEST, Ilia.Gavrilov@infotecs.ru wrote:
>optlen is fetched without checking whether there is more than one byte to parse.
>It can lead to out-of-bounds access.
>
>Found by InfoTeCS on behalf of Linux Verification Center
>(linuxtesting.org) with SVACE.
>
>Fixes: 3c73a0368e99 ("ipv6: Update ipv6 static library with newly needed functions")
>Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

