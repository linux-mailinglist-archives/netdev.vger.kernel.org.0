Return-Path: <netdev+bounces-6707-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FB25717803
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:24:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DA8AC1C20DB5
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:24:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C73A0A944;
	Wed, 31 May 2023 07:24:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAEA946F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 07:24:17 +0000 (UTC)
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01C661B6
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:24:13 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-96f7377c86aso948787966b.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 00:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1685517852; x=1688109852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i1XWrbkgBxKSw6BOoVfi1FHVqdY3ZMXZ/XY8CRr7pGA=;
        b=d7dJsikA9PJZl1/5KPAx70R4iDfXH+yGKtlV+lfkIhcWfBxQr3RBDsZKSVueHS7HrK
         Q6gcjeuOYECRAXpu9jkquA4/7YlUAN+wgeFW9SoFpkGeFB9vBg0tMlKNkt7DYKVcWFxi
         bVyw1R6t+KQSCAuouRU043IMwW25jiUqbr3iRLG5McTyPjOUp15bfumAUUx+C4ksgcv8
         I9T9K6n4bVEBGvztWVvgLdgXORNdoqPS3CkE/oFC75lsriY2Ze/k3opMuvTpYAFHo1t+
         pgyBjGk2iB9LoWOxu1aHJMgjbMnIjc/rnweujlJrVvzXjoSSNqG6X216LYo9QU/7ghxX
         MSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685517852; x=1688109852;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i1XWrbkgBxKSw6BOoVfi1FHVqdY3ZMXZ/XY8CRr7pGA=;
        b=irM77/kNICzmBOIjXjjiKYZWxytwZW+35lWNcBWCjofPlbTYMA9E7mY+YyaDlxIxXg
         yrbmYgGsu9a80AiHCclbjfYymAz3BkvVe/bXWwAZzIw6L9FfrCEux8CYGmI5r+HiSsWA
         XjwWH6UBtTScZLdfllNftTfr5Nj8Bo/f+QAoSA8s8SkWCnBmohncQVSNB01zf6Tx1f0M
         jS0py+0oaNjV2r4JXftDk59jx269cLftm3DGOTBQlu1FeLEFHFBSwug0jmxK+qVhEQ82
         NJRsdw9h6nHm4GAIyo8rCkXstd33BcKVepDBm3MMOxK09M9CXbVGGOhfZ8L+FG4ysvtb
         sh7A==
X-Gm-Message-State: AC+VfDxOvfeFcTcWWPfKt63lcYS7JIYTiykVYJulVBPad3bUGxiNA+mp
	BPAqjfKxRNv0FksktiJxvhTo4g==
X-Google-Smtp-Source: ACHHUZ4sTEqaAjCrgR/OmB1OT9dLyc2YuhFNxXspO7mFZvg0l7ivMAVKTKqgMoU0PyxVK6qWLzXt8A==
X-Received: by 2002:a17:907:7206:b0:974:1eeb:1ab7 with SMTP id dr6-20020a170907720600b009741eeb1ab7mr3547929ejc.24.1685517852555;
        Wed, 31 May 2023 00:24:12 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id bq13-20020a170906d0cd00b00965c6c63ea3sm8476862ejb.35.2023.05.31.00.24.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 May 2023 00:24:11 -0700 (PDT)
Date: Wed, 31 May 2023 09:24:10 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, saeedm@nvidia.com, moshe@nvidia.com,
	simon.horman@corigine.com, leon@kernel.org
Subject: Re: [patch net-next] devlink: bring port new reply back
Message-ID: <ZHb2GkallaC/4wyO@nanopsycho>
References: <20230530063829.2493909-1-jiri@resnulli.us>
 <20230530095435.70a733fc@kernel.org>
 <20230530151444.09a5d7c1@kernel.org>
 <ZHbq6aH+S69heG44@nanopsycho>
 <20230530235339.13f82dbe@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530235339.13f82dbe@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 31, 2023 at 08:53:39AM CEST, kuba@kernel.org wrote:
>On Wed, 31 May 2023 08:36:25 +0200 Jiri Pirko wrote:
>> >> FWIW it should be fairly trivial to write tests for notifications and
>> >> replies now that YNL exists and describes devlink..  
>> >
>> >Actually, I'm not 100% sure notifications work for devlink, with its
>> >rtnl-inspired command ID sharing.  
>> 
>> Could you elaborate more where could be a problem?
>
>right here
>
>https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/tools/net/ynl/lib/ynl.py#n518
>
>;)  If we treat Netlink as more of an RPC than.. state replication(?)
>mechanism having responses and notifications with the same ID is a bit
>awkward. I felt like I had to make a recommendation in YNL either to
>ask users not to enable notifications and issue commands on the same
>socket, or for family authors to use different IDs. I went with the
>latter. And made YNL be a bit conservative as to what it will consider
>to be a notification.

I see. I don't think we can change this devlink kernel behaviour though.
Anyway, as the command issuer does not enable notifications, he should
be okay.

