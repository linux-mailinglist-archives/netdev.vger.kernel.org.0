Return-Path: <netdev+bounces-6320-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 058BA715AFC
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:04:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 515A41C20B9A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 10:04:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9766B171A9;
	Tue, 30 May 2023 10:04:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88E5116418
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 10:04:47 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B844F9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:04:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685441085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0rOfxpMKudv/OZPqUJd3UZe63NtZeJsmKL7503HrnT0=;
	b=DWIrU2K7bP+0UaEbOvykLRxX147JMujQcZOudxPG8cwg69yt0IB3kncdYt+BETgDBydUBh
	BN7mgLNF1W27ji5s/Ug5v1Cbp33QD7rlZ4zPKZNBAb86YAUmy7YAY1UqavHeXbSljxN9px
	vKjzLH5jmFoL1voQcmabKy96d98yyEw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-SecmE-M-MSKySDJMYJQ-yg-1; Tue, 30 May 2023 06:04:43 -0400
X-MC-Unique: SecmE-M-MSKySDJMYJQ-yg-1
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-3f8283a3a66so2946421cf.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 03:04:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685441083; x=1688033083;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0rOfxpMKudv/OZPqUJd3UZe63NtZeJsmKL7503HrnT0=;
        b=RJ+ILGTgbYaS/Un+8dRmgDD74YT4glkHpH+hU7LxLVIPhYPylHCB7mCE6bAko/adrg
         nkoCEI964463z4Feukjv0rwApBczMhrjnxBnYrlzr7vjPMjB1K/bWk05y6aE8hhyZBsf
         YY7LxUoZAP1Z0mWmC7ZTy09KDrS5ejZJMxDVju5jWHR05K3PUYLxCr33MRr+XM50YQe9
         9xFm0Zgbo2Q/9Yy2NUJEHJpiJSZ9PVBbAL1K88YW6M8lshslC6d+4coB9B2MZUXgKB7X
         fIjcj+ZPVa1zF0SEtOlI/ep79QHJivIR9qqMYDdcgkKOEWv+JGc2hcj9F/8vy+d0y4ci
         GCMQ==
X-Gm-Message-State: AC+VfDz7AXwOir57prJQljXBo+aZg03lTWec4/4i9zy7iSKcCq3yJPfv
	My2Bewrn5ff8+Ha2KEOh/eZ3ZKDe7N2ixD7CJIe8MopU2U1+dPfGOTe2ZH3pX2oRVgbFPwb/80R
	60dKlgP15PmiE9PLN
X-Received: by 2002:a05:6214:e4e:b0:625:ba46:27cf with SMTP id o14-20020a0562140e4e00b00625ba4627cfmr1585922qvc.2.1685441083444;
        Tue, 30 May 2023 03:04:43 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5j41B9i33Ri3qPI7OwceeU9fboi2Hka3a7gfcqLbtL58UfmrI1UFEAQjj5eGkBTrIw2TKIJA==
X-Received: by 2002:a05:6214:e4e:b0:625:ba46:27cf with SMTP id o14-20020a0562140e4e00b00625ba4627cfmr1585888qvc.2.1685441083197;
        Tue, 30 May 2023 03:04:43 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-248-97.dyn.eolo.it. [146.241.248.97])
        by smtp.gmail.com with ESMTPSA id q20-20020ad44354000000b0062596d5b6a0sm4482088qvs.54.2023.05.30.03.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 03:04:42 -0700 (PDT)
Message-ID: <5a432a0c18719adcfe4768e1c541010a8c22ea11.camel@redhat.com>
Subject: Re: [PATCH V3,net] net: mana: Fix perf regression: remove rx_cqes,
 tx_cqes counters
From: Paolo Abeni <pabeni@redhat.com>
To: Haiyang Zhang <haiyangz@microsoft.com>, linux-hyperv@vger.kernel.org, 
	netdev@vger.kernel.org
Cc: decui@microsoft.com, kys@microsoft.com, paulros@microsoft.com,
 olaf@aepfle.de,  vkuznets@redhat.com, davem@davemloft.net,
 wei.liu@kernel.org, edumazet@google.com,  kuba@kernel.org, leon@kernel.org,
 longli@microsoft.com,  ssengar@linux.microsoft.com,
 linux-rdma@vger.kernel.org, daniel@iogearbox.net, 
 john.fastabend@gmail.com, bpf@vger.kernel.org, ast@kernel.org, 
 sharmaajay@microsoft.com, hawk@kernel.org, tglx@linutronix.de, 
 shradhagupta@linux.microsoft.com, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
Date: Tue, 30 May 2023 12:04:36 +0200
In-Reply-To: <1685115537-31675-1-git-send-email-haiyangz@microsoft.com>
References: <1685115537-31675-1-git-send-email-haiyangz@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2023-05-26 at 08:38 -0700, Haiyang Zhang wrote:
> The apc->eth_stats.rx_cqes is one per NIC (vport), and it's on the
> frequent and parallel code path of all queues. So, r/w into this
> single shared variable by many threads on different CPUs creates a
> lot caching and memory overhead, hence perf regression. And, it's
> not accurate due to the high volume concurrent r/w.
>=20
> For example, a workload is iperf with 128 threads, and with RPS
> enabled. We saw perf regression of 25% with the previous patch
> adding the counters. And this patch eliminates the regression.
>=20
> Since the error path of mana_poll_rx_cq() already has warnings, so
> keeping the counter and convert it to a per-queue variable is not
> necessary. So, just remove this counter from this high frequency
> code path.
>=20
> Also, remove the tx_cqes counter for the same reason. We have
> warnings & other counters for errors on that path, and don't need
> to count every normal cqe processing.

FTR, if in future you will need the above counters again, you could re-
add them using per-cpu variables to avoid re-introducing the regression
addressed here.

Cheers,

Paolo


