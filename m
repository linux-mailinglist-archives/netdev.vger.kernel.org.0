Return-Path: <netdev+bounces-4380-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D4D9E70C447
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 19:31:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 78EB2280F7E
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 17:31:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 749E116424;
	Mon, 22 May 2023 17:31:39 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AB716416
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 17:31:39 +0000 (UTC)
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DF06F4
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:31:37 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-5144a9c11c7so5697087a12.2
        for <netdev@vger.kernel.org>; Mon, 22 May 2023 10:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20221208.gappssmtp.com; s=20221208; t=1684776697; x=1687368697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30owlBxwrjfqfEUGWrZMQOac8Y/vBcQ0VcrcgEbylyE=;
        b=zMkDkmBMZ0n32ba4ySKviROvrLlWYbZeWk0NsPnzc8cz87YDM7UBAZMA6H05exvpLH
         f4cBF/uQauJzqQWDrKuyAqeOvS9llvVYGORyJ+T3Ghj0H1Qh5j6U5m6GlePjo4YKZoaZ
         /TsF43vucCuHXpnzgQGKrlBLk9Vk6UvkBYXMvdSgxoyZIBlcXnzoWrWKM90wSTC+hzXG
         cSl01T2mbUh5RnwTYCS7t21qdAncpmRHI7vTCCYw9N1b4KexjRRS+kHcy5L7M2lUUZlP
         tKJJ0As2HJ/QKS6fUJDAhX/f3ZeS+UAPOFcBIVCxia+y45lQsED54v6Lt7zDqih6DdnI
         abYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684776697; x=1687368697;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=30owlBxwrjfqfEUGWrZMQOac8Y/vBcQ0VcrcgEbylyE=;
        b=LFBGJsuZaiRLW1825C6+7kaKivtm837PK/GFSzjQhvmfAgjsYRATJ9l9VWxBJk6xcF
         EwTiEvoOAsTs8UBb8KSwPGA6L7BgSX4OpV3J7cqiF2+Q2AgN0qFbXMCUj2R1hLgy82vt
         cMDKwl2z7AysTwyj6waqUXjGKOMVxSJx2s2bqRFwqwESlloyQM+oJAGDcRonQlhhWw+p
         FzJKCHSTy9Z5ef5IV3ZyR+QHj9JZ7AUxbekxNRM/c/pkdp8qYI154LecdpiDVZzlTjsF
         gP6sCuDrO0V8SnYvqWgh0/4Q7S1qBRm5037fnk0bEOZ1k5KFXwHv0SsjuDPi/V899mNh
         hszA==
X-Gm-Message-State: AC+VfDzbV97GkXRyl3MY4NMru3KuaKn7ARvnOZFsyWZbX+m1kivOp7AO
	6azxT0lFwA3/H1XBOMw5/s8EAXyWFg/WrLesIKYyIA==
X-Google-Smtp-Source: ACHHUZ4k2/6XNJbYah9BqB21/4OP8N2Fiz+a0xGzqkKKJ7XEqRmJpElqZNuaS9mBHHCTplCiQV0aLw==
X-Received: by 2002:a17:902:b781:b0:1ae:622c:e745 with SMTP id e1-20020a170902b78100b001ae622ce745mr11219443pls.1.1684776697160;
        Mon, 22 May 2023 10:31:37 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id f10-20020a170902ce8a00b001a64011899asm5140267plg.25.2023.05.22.10.31.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 10:31:36 -0700 (PDT)
Date: Mon, 22 May 2023 10:31:34 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: netdev@vger.kernel.org, Michal Kubecek <mkubecek@suse.cz>, Sudheer
 Mogilappagari <sudheer.mogilappagari@intel.com>
Subject: Re: [PATCH ethtool 1/1] netlink/rss: move variable declaration out
 of the for loop
Message-ID: <20230522103134.1df8c238@hermes.local>
In-Reply-To: <20230522161710.1223759-1-dario.binacchi@amarulasolutions.com>
References: <20230522161710.1223759-1-dario.binacchi@amarulasolutions.com>
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

On Mon, 22 May 2023 18:17:10 +0200
Dario Binacchi <dario.binacchi@amarulasolutions.com> wrote:

> The patch fixes this compilation error:
> 
> netlink/rss.c: In function 'rss_reply_cb':
> netlink/rss.c:166:3: error: 'for' loop initial declarations are only allowed in C99 mode
>    for (unsigned int i = 0; i < get_count(hash_funcs); i++) {
>    ^
> netlink/rss.c:166:3: note: use option -std=c99 or -std=gnu99 to compile your code
> 
> The project doesn't really need a C99 compiler, so let's move the variable
> declaration outside the for loop.
> 
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

But you changed the type which will now cause signed/unsigned warnings.

