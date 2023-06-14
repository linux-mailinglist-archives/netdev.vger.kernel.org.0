Return-Path: <netdev+bounces-10604-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 35C2272F51D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:45:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFB98281328
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 06:45:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FBC5A20;
	Wed, 14 Jun 2023 06:45:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12EE47F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 06:45:43 +0000 (UTC)
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C481A3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:45:42 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id ffacd0b85a97d-30adc51b65cso5929710f8f.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 23:45:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686725140; x=1689317140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1lfDvPUG1HGmVrnIjGIO4jjRv0+fBzXaClOHkCNskUs=;
        b=LCgI1DfnigANtGLRfWnBEpO2Lr4T328f8G202AHZmy8wbM+vZGL7gwrD78SsfhjWgY
         PErdRquiUaEkd7ZbsZVEKysxPqik6ZHwB9hAQEuF8EgPAWlQpVfzQTe4KTxGAnv4eDEP
         XOGLzIqfNvLEsuCXkC9sDhdQkoqLUA3fczTUEYUDGBsLggcRG5SJYSR0eQlwE4xpoEJ2
         OMQ7AmeN4ze0lIt4NSI/uyRTcJzSDka2hcIthWJ8YdQN1mRmolYDNx8IHJMtH0Srz2pa
         wxRY3mxLzlV30h1OkY9mddW1oVQkiRzmPgfl/nSlDo3Sat1l0wcIOaRXbqi8RNOD/zjR
         1Bpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686725140; x=1689317140;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1lfDvPUG1HGmVrnIjGIO4jjRv0+fBzXaClOHkCNskUs=;
        b=B+sR8IrXJtZfvcY/cb3xWh5G7zjN6ya2auzi0xhw2Orn/Bh8gc22RyYlLlUzLMIEN/
         MulQ2awx3tm99Gj2w4fhZmW7PZ5qAjF2IsuAtVqUwXgWznhQ+USvmgGXi3NnGSZpaYnE
         1kT2KrFceOQoypNVHP+iTCXfY5H6WYpn6RjLm1HlZQtsvbcYPkOU2l4TfTLJmKY5Qbas
         AwS1GQ+/4iUH2GaKzwajPUiJ4+KvykdYqaqk1RvzGX9AOWfYTPgX8kUxrvbSZ2x5vcdJ
         oYKHfad/kYXaEQl4NVKEg9e2z+Q93k/Egke+l9NuqU809EU5Bt/I38dfv7bGoiiLr7oI
         SN3w==
X-Gm-Message-State: AC+VfDx9t1QXnL4zMzUl1dnrj//ZpFfZpVnOikkCpOuZfWd71zCCjvED
	WPf3IUBHcCYTZgQCo8qw6itbiA==
X-Google-Smtp-Source: ACHHUZ4qHR3JqF2bnGdLqUXi9q675N2orXuLyu6Exs7MBCEJIgNs3IpVU3S3lsQHQKlsDAr3O4YXDA==
X-Received: by 2002:a5d:4c4f:0:b0:306:2e62:8d2e with SMTP id n15-20020a5d4c4f000000b003062e628d2emr9645446wrt.1.1686725140565;
        Tue, 13 Jun 2023 23:45:40 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id b14-20020a056000054e00b0030c2e3c7fb3sm17060054wrf.101.2023.06.13.23.45.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 23:45:38 -0700 (PDT)
Date: Wed, 14 Jun 2023 09:45:34 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Christian Marangi <ansuelsmth@gmail.com>, Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>, "David S. Miller" <davem@davemloft.net>,
	linux-leds@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v2 led] leds: trigger: netdev: uninitialized variable in
 netdev_trig_activate()
Message-ID: <40653e66-4cca-4c6f-9d0f-e70b3824389e@kadam.mountain>
References: <6fbb3819-a348-4cc3-a1d0-951ca1c380d6@moroto.mountain>
 <83344fe7-6d95-44d8-8ce7-13409c7a8d87@lunn.ch>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <83344fe7-6d95-44d8-8ce7-13409c7a8d87@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 14, 2023 at 02:51:59AM +0200, Andrew Lunn wrote:
> I think his actually needs to be merged via netdev.  e0256648c831
> ("net: dsa: qca8k: implement hw_control ops") is in net-next/main.  I
> don't see it in leds/master, leds/for-leds-next. Also, git blame shows
> mode was added by 0316cc5629d1 ("leds: trigger: netdev: init mode if
> hw control already active") which also appears only to be in
> net-next/main.
> 
> A lot of these LED patches were merged via netdev because they are
> cross subsystem.

Ok.  Thanks, Andrew.

In that case, let me resend.  I just used get_maintainer.pl and it
didn't add the necessary CC list.  Plus the netdev scripts won't run if
you don't have the correct subject...

regards,
dan carpenter


