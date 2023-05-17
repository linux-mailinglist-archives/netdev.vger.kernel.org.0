Return-Path: <netdev+bounces-3388-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CBAC706D59
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:53:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAA322816B3
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CF01111A2;
	Wed, 17 May 2023 15:52:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2029D567C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:52:57 +0000 (UTC)
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A5FAD847
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:52:19 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id 4fb4d7f45d1cf-510d8b0169fso905594a12.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684338733; x=1686930733;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jsU1VAHR+IXD6gZ/mAemmtxRbcXW+NWwxeAzIw2BqSo=;
        b=m/LI/8Y+hB8isgqZuZBpgU2V17KLre4UXIc0rppTJ/mX483YfDSBhogapV89vrgw+K
         6WTC2lZOORjoiAPGF7bWsF48SD5PlmoSEEB7vWcLs0CKtqgMpQN+2TfOo5GSLpN6Lr0k
         0bL3o4t/33fQkAgCC4NDcD3WGA7iIA2MmsvH2x1VJi+iRj8n0OQtbwRXmOUnFjb/LB4J
         9rE9Tm2UD3J07JVN3zAFYBM0ilc8GFgZtRvXFARKBOQMV1FAMspykX2n/Qm5HLnvsAmR
         4+Np6mqpeMHZkRxfflwtpCsxWqkdUoz/zdgawlZsGmBSYPKu0JfRvSA/2JdMGBGhLkDy
         loJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684338733; x=1686930733;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jsU1VAHR+IXD6gZ/mAemmtxRbcXW+NWwxeAzIw2BqSo=;
        b=FAZG1aCKvJkQHYdzfHdqyI6l5D2sijKln8LB28KflapVX8ZijTWyLAiJz1dYCz5ybn
         HYgoUVbMzi1GwyNMp/axxLgB3uJIGgeMePaB6rF93vBngUBs/VqnX3a4yRuC43KxLoT8
         WdHwAIMgu+RqFj+D9LvuEW98HUEZtCZLMg0xYLQvVxAJ8GBk34Tu6BUNR7k1/Q0UFc5t
         0eYnoYPXDzL9YwRNDk6R8RIcqqfEeZC4C4anGmg+qEnOID0cQ+USXLFsjw/bbUJP5YTL
         Fyo8fOSyOFDv9l/RwIQIM9Z7JgTJKKiYAg+PrYPTiA3R//Qc/1Bn7Oh49erwALzWoYr+
         k+cw==
X-Gm-Message-State: AC+VfDw/fNaKlYIK3+NoFUGRCq/azWOGVaxaNj5yE7A0xgrvzAPOdbeE
	ZBoh0miHC4GT/0vvsubpAVc=
X-Google-Smtp-Source: ACHHUZ7guQdMWx+dM68JbvWrRSTzVGH8MzX8YOdLu0F2HAATygHAcRmq+S2ndtFBXDCQ0Okc83lpDg==
X-Received: by 2002:a17:906:5d16:b0:960:f1a6:69df with SMTP id g22-20020a1709065d1600b00960f1a669dfmr46957531ejt.36.1684338731649;
        Wed, 17 May 2023 08:52:11 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id f25-20020a170906739900b0096b3f72b1a0sm4108538ejl.107.2023.05.17.08.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 08:52:11 -0700 (PDT)
Date: Wed, 17 May 2023 18:52:09 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc: Daniel Golle <daniel@makrotopia.org>, DENG Qingfang <dqfext@gmail.com>,
	Greg Ungerer <gerg@kernel.org>,
	Richard van Schagen <richard@routerhints.com>,
	Richard van Schagen <vschagen@cs.com>,
	Frank Wunderlich <frank-w@public-files.de>, mithat.guner@xeront.com,
	erkin.bozoglu@xeront.com, bartel.eerdekens@constell8.be,
	netdev <netdev@vger.kernel.org>
Subject: Re: MT7530 bug, forward broadcast and unknown frames to the correct
 CPU port
Message-ID: <20230517155209.d2twidli4ygj2mhp@skbuf>
References: <20230429173522.tqd7izelbhr4rvqz@skbuf>
 <680eea9a-e719-bbb1-0c7c-1b843ed2afcd@arinc9.com>
 <20230429185657.jrpcxoqwr5tcyt54@skbuf>
 <d3a73d34-efd7-2f37-1362-9a2fe5a21592@arinc9.com>
 <20230501100930.eemwoxmwh7oenhvb@skbuf>
 <ZE-VEuhiPygZYGPe@makrotopia.org>
 <839003bf-477e-9c91-3a98-08f8ca869276@arinc9.com>
 <21ce3015-b379-056c-e5ca-8763c58c6553@arinc9.com>
 <20230510140258.44oobynufb3auzw2@skbuf>
 <6c83136a-8303-7e3b-9f3f-e214e2bfc66f@arinc9.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6c83136a-8303-7e3b-9f3f-e214e2bfc66f@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 11:01:02PM +0300, Arınç ÜNAL wrote:
> Without preferring port 6:
> 
> [ ID][Role] Interval           Transfer     Bitrate         Retr
> [  5][TX-C]   0.00-20.00  sec   374 MBytes   157 Mbits/sec  734    sender
> [  5][TX-C]   0.00-20.00  sec   373 MBytes   156 Mbits/sec    receiver
> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   778 Mbits/sec    0    sender
> [  7][RX-C]   0.00-20.00  sec  1.81 GBytes   777 Mbits/sec    receiver
> 
> With preferring port 6:
> 
> [ ID][Role] Interval           Transfer     Bitrate         Retr
> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   856 Mbits/sec  273    sender
> [  5][TX-C]   0.00-20.00  sec  1.99 GBytes   855 Mbits/sec    receiver
> [  7][RX-C]   0.00-20.00  sec  1.72 GBytes   737 Mbits/sec   15    sender
> [  7][RX-C]   0.00-20.00  sec  1.71 GBytes   736 Mbits/sec    receiver
> 
> This scenario is quite popular as you would see a lot of people using one
> port for WAN and the other ports for LAN.
> 
> Therefore, the "prefer local CPU port" operation would be useful. If you can
> introduce the operation to the DSA subsystem, I will make a patch to start
> using it on the MT7530 DSA subdriver.

Patches adding infrastructure will not be accepted without one user of
that infra, so if you could pick up my patch from the ML, keep my author
and signed-off-by tag, add yours afterwards, give it a compelling commit
message backed up by data such as this, and submit it along your mt7530
user, that would probably be good.

