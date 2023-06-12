Return-Path: <netdev+bounces-10003-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1BF72B9C2
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 10:06:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8CB0B281093
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 08:06:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD515F9EB;
	Mon, 12 Jun 2023 08:06:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D00B6FBFC
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 08:06:21 +0000 (UTC)
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C873310CC
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 01:06:04 -0700 (PDT)
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-30faf6de08eso462214f8f.0
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 01:06:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686557163; x=1689149163;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=S0yJoRP6QTNodw9NgvPTORMIHXXDhSuyUHZbLw7DZcieHbN509T1Vw4i0ZXVGnZHN+
         95OZBxVxN3pIXvSPZc8OcUh7MRgnGiry/yVHpbjC0ScC4WqisP88X5lNNPBkT46U9wiY
         0LyYnRhAA/Uigs7OAXkAl/D3uqh3uSlIWggTCJEppOYFVb45DX4r/cdbwxF7iS1/n20m
         e2lE1SSHRE3DVz12QMNB5huSi1KszTZg5+q7GI0cVt0+XEnLpx6oFhbBu6Zq0NSJlfsW
         mQfsxhBBYYpaQ8U6gBd6p4RKqKqBjhf/V3rPfsd1RbLs4aZ07aPzLlIXSH/StA/lNeV8
         4oOQ==
X-Gm-Message-State: AC+VfDwSm+k4D83FwjMRN0cXqRVZslmiIrpJXxF/pRPfp2gMiJdsktbL
	QzJrUDJnLFMMIdDfufaPZv8=
X-Google-Smtp-Source: ACHHUZ74PIgz0bU1yqdToQao+KusVSR3+j6EbSCEZgu/y9NAPONrArrpM7dUqHeUVUK9s35XAFAmWQ==
X-Received: by 2002:a05:6000:503:b0:2f8:15d8:e627 with SMTP id a3-20020a056000050300b002f815d8e627mr5706986wrf.7.1686557163235;
        Mon, 12 Jun 2023 01:06:03 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id p5-20020a5d6385000000b0030fba9ef241sm4329668wru.30.2023.06.12.01.06.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 01:06:03 -0700 (PDT)
Message-ID: <c4a00e2b-d391-f1c5-323f-28dba1440b24@grimberg.me>
Date: Mon, 12 Jun 2023 11:06:01 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 4/4] selftests/net/tls: add test for MSG_EOR
Content-Language: en-US
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@kernel.org>, linux-nvme@lists.infradead.org,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20230609125153.3919-1-hare@suse.de>
 <20230609125153.3919-5-hare@suse.de>
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230609125153.3919-5-hare@suse.de>
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

