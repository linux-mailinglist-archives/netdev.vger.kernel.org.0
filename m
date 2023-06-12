Return-Path: <netdev+bounces-10002-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 6BF6B72B9BE
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:06:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7AFB31C208F4
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:06:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243B1F9EB;
	Mon, 12 Jun 2023 08:06:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168EB2567
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:06:16 +0000 (UTC)
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D34D71BCD
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 01:05:57 -0700 (PDT)
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-30e528eef6dso345276f8f.1
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 01:05:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686557151; x=1689149151;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=dpSgMx7qHxSyDIgNqNr4H5BpObkoTT9COvlsjGzqNV4/gbgHfVRDPxYmUC/0XWQIkA
         U9t75HrUb/TBtTnYgzpt4UDBxx+yJDgcwFJyxjULDGqWIeVt8n2WpaKEJGaLz0Hb557R
         oHLmDKkSKHiCQoqIlPZFTBEBTcANov0jE2JMMVFJiLE4VrKsOOWJhNzCLyczOR86+2Jl
         T9v6ml/NmxPp/lg14qDnCwu9pOP50wTc/IXGe2WbwrVt24sTG9CLeCpfQxxghKCG5BBL
         oyz4/WybCUzeLt028Qun5ctlOD7WTT559Y8RsDsoVAKXqzseh/8t4f6vHNBeBGEFo/jB
         ldcQ==
X-Gm-Message-State: AC+VfDxy9Oe0P2lBPaXx7kk8r61r/Nt/PXt0AcG7VAZ2SC+et/2DKIBY
	8X+YyZe2EmYag29t5wwTl98=
X-Google-Smtp-Source: ACHHUZ4wjm9FjPeTJpQG1i/GtNveCrILsDXAQuVj4C5FEnWlCtxLHZjk35Qpm9fvQDs7ysmim3ppEw==
X-Received: by 2002:adf:f881:0:b0:30f:bca7:9f4e with SMTP id u1-20020adff881000000b0030fbca79f4emr2319250wrp.6.1686557151258;
        Mon, 12 Jun 2023 01:05:51 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id e13-20020adfef0d000000b0030aeb3731d0sm11658301wro.98.2023.06.12.01.05.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 01:05:50 -0700 (PDT)
Message-ID: <54787ac6-7e30-d5f8-2ee3-f52df8123c0b@grimberg.me>
Date: Mon, 12 Jun 2023 11:05:49 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 3/4] net/tls: implement ->read_sock()
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Boris Pismenny <boris.pismenny@gmail.com>
References: <20230609125153.3919-1-hare@suse.de>
 <20230609125153.3919-4-hare@suse.de>
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230609125153.3919-4-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>

