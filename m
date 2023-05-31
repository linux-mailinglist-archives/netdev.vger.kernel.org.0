Return-Path: <netdev+bounces-6695-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 30F6E717740
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:54:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94EDD281340
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE4DF8F4F;
	Wed, 31 May 2023 06:54:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98ED379DD
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:54:55 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72768186
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:54:29 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-970056276acso830149566b.2
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 23:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685516041; x=1688108041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8ExLgX84ryMdBoFWHkJoM3ftZS4GUewGEDiXBLN4cLI=;
        b=lBpkqnpjAAGfmCzN9wFGzwDAlbnOdx4Rwz3I7NZOkcz8f3e0gwLPmLVb/l5ZgQxUR0
         08Nf5ZLqxXD2T/RoGEtsYq3mXAR7dqhpNFjy0XqusNKd0YEYpFp+3FvASSmAPwka7lBn
         va1tmvzTJatl6V4XmqCsk0MDxDgmlUmUtOjzLmX+w/ZFPUO9l1iW/0uPQBweFGL9oEeS
         pSHYNhKoG0dj6gaY11rVquaj9Cq9QgsoEiE98aXDr8FTMkDht6kq2seLHG8z64m/QScS
         dMmVZowJ8AVDALu276PKhueJuV9tr2J/sXlgWLwBufaTKElMf6su0jFz2PHLVML5qbmk
         4KXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685516041; x=1688108041;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ExLgX84ryMdBoFWHkJoM3ftZS4GUewGEDiXBLN4cLI=;
        b=Lz5qZQv+NKP8+eg+EcxOYE91bvvzzBW99SQs9SFuVraHTluwUDi8zOMO7RiqvzUMGP
         yOqbaTDBRpdMu8v04/LBf1dV//Yn59RDNl27V9IAt+54khUVZAlRWAqcgt+SGMMnD66Z
         TK3bxq84gfq8xH0m7QCTkD3tI3o02SX9puVbEQlBb5OyQ+AZk0DuFp8bF1eaZjLmOOOu
         ejsrdyr45mPHsNnskn9jW45xkhk4RQ78ENpbmZP87Z+TB7Cznnw8w/gpoxtUVSb8sraK
         5zzSxhJZjdvc9eUjf54Zh6Btx8+5wy5fML4zrGKwYnlUVtWnLZm8dfogjSfGs1hqcwve
         7GLQ==
X-Gm-Message-State: AC+VfDy2bltMC34MiDu1A12Nfy8GZThkyJ9WzG/NDknVY0jLiWiS4kTj
	pDatplFsMgbKCMuJJOaulQIumdH/QiU1WKLAWlY=
X-Google-Smtp-Source: ACHHUZ4p4tNo/AZi4+lv9BcIRLKckvPuHaX17KfQOUyUlmN9yXYYiVr3Zf8InCqv2/19VDYONpkSCw==
X-Received: by 2002:a17:907:1b12:b0:967:2abb:2cec with SMTP id mp18-20020a1709071b1200b009672abb2cecmr4121417ejc.64.1685516041719;
        Tue, 30 May 2023 23:54:01 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id qn10-20020a170907210a00b0096f8509f06dsm8428142ejb.158.2023.05.30.23.54.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 23:54:00 -0700 (PDT)
Date: Wed, 31 May 2023 08:53:59 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: netdev@vger.kernel.org
Cc: kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, saeedm@nvidia.com, moshe@nvidia.com,
	simon.horman@corigine.com, leon@kernel.org
Subject: Re: [patch net-next] devlink: bring port new reply back
Message-ID: <ZHbvB72oigKvuKWf@nanopsycho>
References: <20230530063829.2493909-1-jiri@resnulli.us>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530063829.2493909-1-jiri@resnulli.us>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Tue, May 30, 2023 at 08:38:29AM CEST, jiri@resnulli.us wrote:
>From: Jiri Pirko <jiri@nvidia.com>
>
>In the offending fixes commit I mistakenly removed the reply message of
>the port new command. I was under impression it is a new port
>notification, partly due to the "notify" in the name of the helper
>function. Bring the code sending reply with new port message back, this
>time putting it directly to devlink_nl_cmd_port_new_doit()
>
>Fixes: c496daeb8630 ("devlink: remove duplicate port notification")
>Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Will send v2 rebased on top of the port_ops patchset. Please drop this.

