Return-Path: <netdev+bounces-2966-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B6A82704BC3
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A3CF22811FF
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:06:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E507634CDD;
	Tue, 16 May 2023 11:06:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92BE34CC0
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:06:15 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE295FCF
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:05:41 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-50bcae898b2so24583746a12.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684235072; x=1686827072;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kGCJ/W5iGEq3jH2YQIO8Cak7WirO4MEH/2Ql3CIQFcs=;
        b=ua9GQGF5QP7jIELA0XMiXvgx3sZt6AzmsV8XrnPk36Ych0TKFyhT6BSS05R9m+0spS
         Q6wrZXSCagxCV5Zl+36GPGtJjuPlERhLECmbnzYLB6SwV2EvJQG0VM9LJ66ZvOFJOCXt
         1qVTHkio0XWSyvmPSdOwUyJF2gQCbG65vcq1MNLx8VIB41WKwlCHuPj08JEqiDlvRB7U
         PB7bEuMiUUtiBkpFGVLPuntP8q4Zi+WLaqEhxP56bMhIKRZL8z3Xxc70foBYCuDoRimW
         XaJnTp7yDaXIs8Be8XA4oBCCGxgGbirIQpPczctPUQQWVOTceF4E1r6/7mNHiZAz/RE2
         814g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684235072; x=1686827072;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kGCJ/W5iGEq3jH2YQIO8Cak7WirO4MEH/2Ql3CIQFcs=;
        b=RbkkeJEV+4OqtiWS7UNKE1IwKpO31/x3Xp7P8cgCmIbWZG+naxDpcZbLYDx1kOCsOd
         +Y7hGiTKTIcHJMRcHFpxOQpA0KmH21vArg2s/trhtD+KqUno4svhA3a1FpqWfzjto5rL
         CGlBH/OxBjXzYnDIZrtq3rNT+Wf0bw6KS3WYYv51B+dnMI2GjpnlhpNuiQsEaDD1X/5P
         6gA9EiGgpkb6PKTjg00M14FkUlBUoU9Ic4Ac7N0yv+JRFnB2fh17/erHYZUCGI057ePe
         nORrtIdlX1CXZM7zTLJ54GLLfC042Hgg0CxNd5KiNBoSKKSKmV24i8A/Arj1vwaMvcjj
         sH0g==
X-Gm-Message-State: AC+VfDxqHF7cwgOP775qVC0lwDAnU6deYHNUwRX3lZfI27bn+piHTpWH
	8HF+q7/R4xWb1fULLuV6zxjRIw==
X-Google-Smtp-Source: ACHHUZ7lz7AUa6dtlYx3x1UwxBS09jKh2soqnTSrqNwx45qHEa8BXb+sBngmbxQ97qTQBMH8RT4N5A==
X-Received: by 2002:a05:6402:b03:b0:50b:c4a1:c6c0 with SMTP id bm3-20020a0564020b0300b0050bc4a1c6c0mr29927619edb.16.1684235072183;
        Tue, 16 May 2023 04:04:32 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id z24-20020aa7d418000000b0050bfa1905f6sm8429055edq.30.2023.05.16.04.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 04:04:31 -0700 (PDT)
Message-ID: <6a688292-a7a0-20c9-03b9-cad11a61144f@blackwall.org>
Date: Tue, 16 May 2023 14:04:30 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 1/2] bridge: Add a limit on FDB entries
Content-Language: en-US
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>,
 Oleksij Rempel <linux@rempel-privat.de>,
 Johannes Nixdorf <jnixdorf-oss@avm.de>, netdev@vger.kernel.org,
 bridge@lists.linux-foundation.org, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Roopa Prabhu <roopa@nvidia.com>,
 Ido Schimmel <idosch@nvidia.com>
References: <20230515085046.4457-1-jnixdorf-oss@avm.de>
 <a1d13117-a0c5-d06e-86b7-eacf4811102f@blackwall.org>
 <ZGNEk3F8mcT7nNdB@u-jnixdorf.ads.avm.de>
 <f899f032-b726-7b6d-953d-c7f3f98744ca@blackwall.org>
 <20230516102141.w75yh6pdo53ufjur@skbuf>
 <ce3835d9-c093-cfcb-3687-3a375236cb8f@blackwall.org>
 <20230516104428.i5ou4ogx7gt2x6gq@skbuf>
 <c05b5623-c096-162f-3a2d-db19ca760098@blackwall.org>
 <20230516105509.xaalfs77vrlr663u@skbuf>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230516105509.xaalfs77vrlr663u@skbuf>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16/05/2023 13:55, Vladimir Oltean wrote:
> On Tue, May 16, 2023 at 01:47:47PM +0300, Nikolay Aleksandrov wrote:
>> Having the current count is just a helper, if you have a high limit dumping the table
>> and counting might take awhile. Thanks for the feedback, then we'll polish and move
>> on with the set for a global limit.
> 
> Ok, but to be useful, the current count will have to be directly
> comparable to the limit, I guess. So the current count will also be for
> dynamically learned entries? Or is the plan to enforce the global limit
> for any kind of FDB entries?

That was one of the questions actually. More that I'm thinking about this, the more
I want to break it apart by type because we discussed being able to specify a flag
mask for the limit (all, dynamic, dynamic+static etc). If we embed these stats into a
bridge fdb count attribute, it can be easily extended later if anything new comes along.
If switchdev doesn't support some of these global limit configs, we can pass the option
and it can deny setting it later. I think this should be more than enough as a first step.

