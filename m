Return-Path: <netdev+bounces-8522-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D5F72472E
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:04:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F02E11C20A17
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:04:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE6DC2109A;
	Tue,  6 Jun 2023 15:04:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E7A37B97
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 15:04:03 +0000 (UTC)
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3237EB0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 08:04:02 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f70fc4682aso54137355e9.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 08:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686063840; x=1688655840;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dHvIdPwB/BrRaOe4zEURclmNORaYsg2Ls6xxuspe6oE=;
        b=VB4K6hcoa2Q3fjB++LmauxTbURUq5ITRbQGEAYf3AT8fRymDOKsqv7M04tapOZVKrh
         7Sb6ikfoPOQy0XMSY9bylPKl2an6FldJixCAQvW8fbsDcuUAGYGkWXipDTrMaCaqSvbJ
         pUO1ltwHlpJjV7x0DprFoMER0prQAmxbeGmg7kYk5aem0yiuICM1O23NNQ+ETEEibtGe
         pBV7yQUKQOHja31GptT/bMD5J9ViD+pShcRkwaQTnyRfM9LbAJw3bZUElcHuLFk0YvXS
         qhfISLF1eGUqhWDP5BYXkXhx15CArSEyxHkreOAyaIBzJJMGDdt9QAkV4kYTPcq+UI0j
         GaWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686063840; x=1688655840;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dHvIdPwB/BrRaOe4zEURclmNORaYsg2Ls6xxuspe6oE=;
        b=IOhNLAfijrl493C4yhTGstNJydIPZF92NBxkr/7KKInfqnDcUR6j0jli32HqIuUr7g
         kKQljXeKGRKjI2VeEq4jOlH74rLQlWhdRxB/PRlcvjO9wbA3HpQuqky2J/nCW0+G+kYi
         72YDuxVjljdPt5b5/F1T4wxLF88nRjccW09vgNK2TfMIyVxExmlmLlcytqmevsrl+J3I
         4VHSJLkqt67eVzm6PUCQm96NEMr6l4vupzwOcTipx7HetINQlip1vAJQJz9C3N9vunDY
         +jHEVdzpuc17AWxVCSA7DE/c8IyzGyweGp2lBD9NRXh8UAzLgwXnOAecMNTpeXZBioxT
         4lZw==
X-Gm-Message-State: AC+VfDyCB3t55iJgoy7TzTp4XaoCxz7s/18PxOj6jhuEaSa97vRdkX7v
	vTeedErMJJ6/fZJxKYCVZIM=
X-Google-Smtp-Source: ACHHUZ4y0+A+ZaS7iBd3zBt0zOShp+1uI6QNEjoXeyqnJAqrcHysKXPbQ6M37d6ei32S+YJvUjE3Gg==
X-Received: by 2002:a7b:ca58:0:b0:3f1:70a2:ceb5 with SMTP id m24-20020a7bca58000000b003f170a2ceb5mr2372728wml.13.1686063840500;
        Tue, 06 Jun 2023 08:04:00 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id c18-20020adfed92000000b0030ae499da59sm12861282wro.111.2023.06.06.08.03.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jun 2023 08:04:00 -0700 (PDT)
Subject: Re: [PATCH net-next 6/6] sfc: generate encap headers for TC offload
To: Hao Lan <lanhao@huawei.com>, edward.cree@amd.com,
 linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com
Cc: netdev@vger.kernel.org, habetsm.xilinx@gmail.com
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
 <672e66e6a4cf0f54917eddbca7c27a6f0d2823bf.1685992503.git.ecree.xilinx@gmail.com>
 <dd491618-6a36-ee7a-0581-c533fa245ce9@huawei.com>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <5a26664a-56a4-5424-f2a9-a429633607c3@gmail.com>
Date: Tue, 6 Jun 2023 16:03:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <dd491618-6a36-ee7a-0581-c533fa245ce9@huawei.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 06/06/2023 04:52, Hao Lan wrote:
> Why do you need to refactor the efx_gen_encap_header function in the same series?
> I saw that patch 5 defined this function, and patch 6 refactored it,
> instead of writing it all at once?

Patch 5 introduces it only as a stub, because the calling code needs
 it to exist.  Patch 6 then provides the implementation; this is not
 a refactoring.
They're in separate patches to split things up logically for review
 and to assist future bisection.  Patch 5 is already big and complex
 without this part.

(Also, please trim your quotes when replying to patches: you only
 need to quote the part you're commenting on.)

-ed

