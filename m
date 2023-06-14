Return-Path: <netdev+bounces-10671-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9665F72FB2D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 59F9C2813B7
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:37:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511D01FD3;
	Wed, 14 Jun 2023 10:37:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418691385
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:37:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDAC1A7
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686739023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pQC01z63CV7svZuA8c39oOmUblhhPFuEcr9YAbKl51k=;
	b=bqJMeJu252VaaUO/dYB3UNKxUrMTfB/hE75E80DOP+VHbt8p5WkN1xEtDNuDUsfS+F2Ujh
	YbtRZEgsn9N8a4erWq9m2yEVjT4X/Pvvz2aYxT/kYcoTLqptk5hTp83t361+w5KRkpGBRP
	K2VAsC5VyAqcIT4EUMry91CbpOohsbQ=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-639--7PUw-HDMlKmCajxFUfN-w-1; Wed, 14 Jun 2023 06:37:02 -0400
X-MC-Unique: -7PUw-HDMlKmCajxFUfN-w-1
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-3f9e7a1caf2so10508671cf.0
        for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:37:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686739022; x=1689331022;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pQC01z63CV7svZuA8c39oOmUblhhPFuEcr9YAbKl51k=;
        b=OF2E3L8giurm41LuKIMaNSqrewrBcA5GV/uj56U8CslehVXEAFMHVdiRPX8RYsOk4n
         EGAUM1vln01idP7UCwjHSfZsJv8/av4EBwXihCwj/aUlU7XZcufN+fwbmoNq281/G5/v
         d8XCUHPTPwfSCUnYgm+Nnoyz3ny/v4ML0XfN0qmIMzApLi1dRU+WXdJDQsSINOLlOZPj
         f+gTbhm1btwWK/pOIjxd0DSWhWXoApOEKacYu0RSIf4CsMEtLzRKNB/UKAW+c9CwKLdv
         kug8xwCCq28DcbVMw6GJOLYur+pTx9/hf7HWrlnWyGEPBv4N0/gjzxZrj9rpjQDdi+YX
         ZmCQ==
X-Gm-Message-State: AC+VfDyb+oOb+2jdQv9/dvjKtPQrtIaRzXjSneKBdQjcPGyaTEZneF+K
	Fax/tThuH3beGnDJZbA05EKIDkkwngCus04apzY4KGTnWgHgHMEtuvELCGN+tHXeLuhRkQE4w5b
	707toj/Wre6FkVXRT
X-Received: by 2002:a05:620a:4542:b0:75d:4db2:6824 with SMTP id u2-20020a05620a454200b0075d4db26824mr17314046qkp.2.1686739022120;
        Wed, 14 Jun 2023 03:37:02 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7CTj/BQEoKKCz9NDPX4BQ3EHhofPNz5WChDRffz8hTJ0YSIF3FWTMG3LyuE3EDphUt/ur9GA==
X-Received: by 2002:a05:620a:4542:b0:75d:4db2:6824 with SMTP id u2-20020a05620a454200b0075d4db26824mr17314029qkp.2.1686739021834;
        Wed, 14 Jun 2023 03:37:01 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-67.dyn.eolo.it. [146.241.244.67])
        by smtp.gmail.com with ESMTPSA id s6-20020ae9f706000000b007620864d547sm210461qkg.120.2023.06.14.03.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jun 2023 03:37:01 -0700 (PDT)
Message-ID: <42dba6ff429f9da6daabadd43f8d05bc5373e47d.camel@redhat.com>
Subject: Re: [PATCH net-next v2 3/4] net: hns3: fix strncpy() not using
 dest-buf length as length issue
From: Paolo Abeni <pabeni@redhat.com>
To: Hao Lan <lanhao@huawei.com>, netdev@vger.kernel.org
Cc: yisen.zhuang@huawei.com, salil.mehta@huawei.com, davem@davemloft.net, 
	edumazet@google.com, kuba@kernel.org, richardcochran@gmail.com, 
	wangpeiyang1@huawei.com, shenjian15@huawei.com, chenhao418@huawei.com, 
	simon.horman@corigine.com, wangjie125@huawei.com, yuanjilin@cdjrlc.com, 
	cai.huoqing@linux.dev, xiujianfeng@huawei.com
Date: Wed, 14 Jun 2023 12:36:57 +0200
In-Reply-To: <20230612122358.10586-4-lanhao@huawei.com>
References: <20230612122358.10586-1-lanhao@huawei.com>
	 <20230612122358.10586-4-lanhao@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-06-12 at 20:23 +0800, Hao Lan wrote:
> From: Hao Chen <chenhao418@huawei.com>
>=20
> Now, strncpy() in hns3_dbg_fill_content() use src-length as copy-length,
> it may result in dest-buf overflow.
>=20
> This patch is to fix intel compile warning for csky-linux-gcc (GCC) 12.1.=
0
> compiler.
>=20
> The warning reports as below:
>=20
> hclge_debugfs.c:92:25: warning: 'strncpy' specified bound depends on
> the length of the source argument [-Wstringop-truncation]
>=20
> strncpy(pos, items[i].name, strlen(items[i].name));
>=20
> hclge_debugfs.c:90:25: warning: 'strncpy' output truncated before
> terminating nul copying as many bytes from a string as its length
> [-Wstringop-truncation]
>=20
> strncpy(pos, result[i], strlen(result[i]));
>=20
> strncpy() use src-length as copy-length, it may result in
> dest-buf overflow.
>=20
> So,this patch add some values check to avoid this issue.
>=20
> ChangeLog:
> v1->v2:
> Use strcpy substitutes for memcpy
> suggested by Simon Horman.

In the next revision, please move the changelog after the '---'
separator below, so that it will no included into the actual commit
message. (Applies to all the patch in the series)

Thanks!

Paolo


