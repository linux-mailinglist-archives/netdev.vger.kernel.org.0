Return-Path: <netdev+bounces-1125-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEDAE6FC498
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:08:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A22012811FD
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFDEA1097B;
	Tue,  9 May 2023 11:08:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FD03205
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 11:08:41 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE34610E69
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 04:08:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683630505;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WiLEMWrQ2Sw8o8UvhnNKSRqVYJmR4Ag+rT30VsTyDQI=;
	b=AeHxjq+lM9a8QdzQfRcFPwdlmOk/dQZjARY8JWYa0lQ3tJxGn9a8P0vLblitYQMPG+BIHS
	G+fwCeTloGfVimhv6oujOIohE7MgkCfIS8+6uoW/gUbNMjxLQx+6PqQFlOxCTOLRQcR/oG
	ghX0cljMZq6Hk8mxw1Gs9S2NTV+1vlY=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-493-fqAg1zayNfWKqzhE-DC5FA-1; Tue, 09 May 2023 07:08:18 -0400
X-MC-Unique: fqAg1zayNfWKqzhE-DC5FA-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9662ead7bf8so292439366b.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 04:08:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683630497; x=1686222497;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WiLEMWrQ2Sw8o8UvhnNKSRqVYJmR4Ag+rT30VsTyDQI=;
        b=GlTAWi3Qe9D5aqBWVVB2+qn8DGdsqGNWG1H2FZ5maPgYvWpJpvNNvQSmXXlP6WIum7
         Bv4FDhscVYUA+w74ydPyCW6tL2Fi+BGWEX8eUN+p7r+i+bEmuIzsd3Bc8CXYd6NMAwNH
         ltWS6A+Q6uh4uBt+OFFZRgvaz67BDZ8dWAegrnfY6ThfKZwp4btYLLGVfxycg1IKFOQs
         U8GwbVXcl3yNp1ySYHP7SCxyTz3u6rwleISKWzVZwoSLrBX3qKMpcLCwQgz9tqVMzFR3
         ymbNY+G11zb3T0RXGNqm9gPY4TFpHA9yVErsREKCugMv4bFzKwMYSYtexBLxIOW64ijE
         dOeA==
X-Gm-Message-State: AC+VfDxAYfbd+I4in4KPq8R5vCby79HfFLqNhczNf72RPEyf9CYHjtrq
	6dH/OGqIsIY8f30QYtG1LK26vdA8wzRvUkmyagomSFBCpVXY6MsEAAzFLVaYYLttMOYkC+ZzBTL
	2Zwuyj6WL/Yd+EeZJ
X-Received: by 2002:a17:907:7251:b0:96a:1ab:b4a2 with SMTP id ds17-20020a170907725100b0096a01abb4a2mr627860ejc.25.1683630497141;
        Tue, 09 May 2023 04:08:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7Rqtps4W7ATroxkIb+DAOn2d1Y5cEKiP0JHhb9szPyQiP87+bf4v1Ev0OlhRHAto+/rQJCQQ==
X-Received: by 2002:a17:907:7251:b0:96a:1ab:b4a2 with SMTP id ds17-20020a170907725100b0096a01abb4a2mr627830ejc.25.1683630496743;
        Tue, 09 May 2023 04:08:16 -0700 (PDT)
Received: from [192.168.42.222] (cgn-cgn9-185-107-14-3.static.kviknet.net. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id md1-20020a170906ae8100b0094b5ce9d43dsm1183727ejb.85.2023.05.09.04.08.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 04:08:16 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <d65ed4e7-75ed-acd6-2524-2a48a82deb72@redhat.com>
Date: Tue, 9 May 2023 13:08:14 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Cc: brouer@redhat.com, lorenzo.bianconi@redhat.com, bpf@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, hawk@kernel.org, john.fastabend@gmail.com,
 linyunsheng@huawei.com, ast@kernel.org, daniel@iogearbox.net,
 jbenc@redhat.com
Subject: Re: [PATCH net-next] net: veth: make PAGE_POOL_STATS optional
Content-Language: en-US
To: Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
References: <c9e132c3f08c456ad0462342bb0a104f0f8c0b24.1683622992.git.lorenzo@kernel.org>
In-Reply-To: <c9e132c3f08c456ad0462342bb0a104f0f8c0b24.1683622992.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 09/05/2023 11.05, Lorenzo Bianconi wrote:
> Since veth is very likely to be enabled and there are some drivers
> (e.g. mlx5) where CONFIG_PAGE_POOL_STATS is optional, make
> CONFIG_PAGE_POOL_STATS optional for veth too in order to keep it
> optional when required.
> 
> Suggested-by: Jiri Benc <jbenc@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   drivers/net/Kconfig |  1 -
>   drivers/net/veth.c  | 24 +++++++++++++++++-------
>   2 files changed, 17 insertions(+), 8 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


