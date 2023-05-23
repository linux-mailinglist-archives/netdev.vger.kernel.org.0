Return-Path: <netdev+bounces-4578-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E778A70D48C
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 09:09:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 970F6281049
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 07:09:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FE31C77D;
	Tue, 23 May 2023 07:09:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B951B8F2
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 07:09:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DFF1A7
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 00:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684825727;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LOz9tVG9x8wjs/mkyWBOZ9NlyDU6uZrwJP+l+b0a7Mw=;
	b=EDHWgy3XK6ptZHihQlrZJA6Fi8BiD00aKc8aQFByf7nkV/9NpMvnM2sP3CLL4IQ+qG1EUz
	qu1jAuuzfywPrmrZBnYiJ3sceIS12h6fsHrNzxypEONFULgGEbOWHwVlSbwmh5A/HZcWuI
	sGSgpgh2lQwRNBN77s7harw3KAtevsw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-9reYSzrFNS-kBf_PnAPQAA-1; Tue, 23 May 2023 03:08:46 -0400
X-MC-Unique: 9reYSzrFNS-kBf_PnAPQAA-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-51392d645d5so665700a12.1
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 00:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684825725; x=1687417725;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LOz9tVG9x8wjs/mkyWBOZ9NlyDU6uZrwJP+l+b0a7Mw=;
        b=M0UgVFllE0+T89eWPJmU4PWPrO6E0+JUAJlmdz+4kuqBZqyaT/HPF6iteMUrpdF0rw
         KvDEJT1Kz+6mWpfwBOtj6sVeyYd19Gt/jctfJn65//p6h23jdhuB/Lzr0JWauI8owaYW
         u0YYTBlLP25WcEBNS04OKvmLXOldknnTJ+EQ6AExfrWScRvQYZyRluGw9TaSKKMb2H3y
         UH6uOfhsIr9I6OkLoUSUKrZ7hFiVHdszuEGyEchlCSRBkHbIepjrYl3s/yzRx/3nZj9o
         h7HNDukPBFvtoU8LF7P6Gg/4I84i1vNCFvwUNBe94jJ6ugc55BEdNByL2qRTMF7qdHFO
         U3Gg==
X-Gm-Message-State: AC+VfDwbM4oLV8OGutDwskFP8AoZFrdHv8G+GscO7jgA5ZZk6m3MFXFN
	OKjPVWXotTRnlQEEOaDf5PnZQYrzLzdsylFf7v119v6zZBGieA+FOeOPRLAycE2mUeKov8QAwrv
	kfOBj+ieKFx9J9ctj
X-Received: by 2002:a50:ee1a:0:b0:50b:c6c9:2146 with SMTP id g26-20020a50ee1a000000b0050bc6c92146mr9723036eds.24.1684825725403;
        Tue, 23 May 2023 00:08:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7r0KyZvF1P8bIJjcAyAEYuwFSDbk1QeSc8w7+b44a2OSQmNXDLpyl4LSdCVvXDn7j7nE3cTQ==
X-Received: by 2002:a50:ee1a:0:b0:50b:c6c9:2146 with SMTP id g26-20020a50ee1a000000b0050bc6c92146mr9723018eds.24.1684825725091;
        Tue, 23 May 2023 00:08:45 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id by28-20020a0564021b1c00b00508804f3b1dsm3783199edb.57.2023.05.23.00.08.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 May 2023 00:08:44 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <c6c44d10-d283-7a26-8597-6be6e29bc832@redhat.com>
Date: Tue, 23 May 2023 09:08:42 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Jesper Dangaard Brouer <hawk@kernel.org>, Eric Dumazet
 <edumazet@google.com>, Lorenzo Bianconi <lorenzo@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH net] page_pool: fix inconsistency for
 page_pool_ring_[un]lock()
Content-Language: en-US
To: Yunsheng Lin <linyunsheng@huawei.com>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20230522031714.5089-1-linyunsheng@huawei.com>
 <1fc46094-a72a-f7e4-ef18-15edb0d56233@redhat.com>
 <CAC_iWjJaNuDFZuv1Rv4Yr5Kaj1Wq69txAoLGepvnJT=pY1gaRw@mail.gmail.com>
 <cc64a349-aaf4-9d80-3653-75eeb3032baf@huawei.com>
In-Reply-To: <cc64a349-aaf4-9d80-3653-75eeb3032baf@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 23/05/2023 04.13, Yunsheng Lin wrote:
> Do you still working on optimizing the page_pool destroy
> process? If not, do you mind if I carry it on based on
> that?

I'm still working on improving the page_pool destroy process.
I prefer to do the implementation myself.

I've not submitted another version, because I'm currently using the
workqueue to detect/track a memory leak in mlx5.

The mlx5 driver combined with XDP redirect is leaking memory, and will
eventually lead to OOM.  The workqueue warning doesn't point to the
actual problem, but it makes is easier to notice that there is a problem.

--Jesper


