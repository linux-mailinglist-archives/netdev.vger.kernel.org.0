Return-Path: <netdev+bounces-9060-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 38436726EA3
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 22:51:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6E84E28152E
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 20:51:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897403735B;
	Wed,  7 Jun 2023 20:51:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE4234CDF
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 20:51:46 +0000 (UTC)
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331D41FE2
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:51:39 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id ffacd0b85a97d-3063433fa66so6573013f8f.3
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 13:51:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686171097; x=1688763097;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FzVxK6O2XzfesxoKxVm58vvbWinbBRoaZcsIkaJcbBk=;
        b=o12mismIfflwUwAg7HjKtpI4xBkfxMN2cZqw7G9Bg6H5YByhPYmsWH6Y9q13gmtQqZ
         5mO3nTMvDa+3Te992WMPFB+uGzBUB/zZjNLtaS9VrgCv+dKYkLu9LaPCoFqHeXzFzrGV
         SemX4F1vqRyZriIUmkM6KHq13xnVoSlY7Q0lyUUcOv9wEw8FggMA3Gnwluc/ukBwXmGX
         NegDwizSpT0i8we5FXjOrSmceT9YASBU3vQ/uE0r2MfRRYryfWSsaocnpTyHFsAefbfm
         o+PaTFW7TrGcKKw9v/P4gUo/x7TTIqQLQPkB7IBvuD75+HqXdKyZ+kWfNvJkD+XrJs54
         FFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686171097; x=1688763097;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FzVxK6O2XzfesxoKxVm58vvbWinbBRoaZcsIkaJcbBk=;
        b=NAzCvmILZ6HJOPx8BwCZ8JrXnUZJeJ+f2/GxYED0orAzHVt/7S8yPR8rIB92Sr1DLv
         fzSQFw4H08PiSICm6YNd01xrd6z3WYSVIXmr4D1f/CQSsOUv50Qg1r4GffeXUJrBDwdt
         N1PPZdipoT0Xosbyh1o+RwviGL+F+LN+0d+CB3yPfg4ReMk2bfCGYgR/UajAvUHzz9Bu
         FYZw4pvBsTEEK2PXVvkD7d6DL+AMYL1e6uuzzB9gUxROf8RvkZVUSdwwlek1Xk/wG2PN
         xL/wMkwHNFMyfcyE92+lSpLtYkbTFQSyvE4qxI3EoTOE3/YeDfDpgtldeTwqHneAMJ+o
         eelA==
X-Gm-Message-State: AC+VfDxhXt1hYkYXiZjkgFNacurH9YroxHwi3JSd971s3NLaeNaLYEta
	i5fAxHhtVAUf6oWj38ZgBFU=
X-Google-Smtp-Source: ACHHUZ4X9oVOi5He4VlfmZX6CZSenK4CK4GD4JHAHczHpvmqP9PLZ/1nCIaOcH3rLjuFLqUVDSzSpw==
X-Received: by 2002:a5d:400e:0:b0:30a:e892:e2d0 with SMTP id n14-20020a5d400e000000b0030ae892e2d0mr5417774wrp.46.1686171097428;
        Wed, 07 Jun 2023 13:51:37 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id v10-20020a05600c214a00b003f602e2b653sm3159191wml.28.2023.06.07.13.51.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 13:51:37 -0700 (PDT)
Subject: Re: [PATCH net-next 5/6] sfc: neighbour lookup for TC encap action
 offload
To: Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, habetsm.xilinx@gmail.com
References: <cover.1685992503.git.ecree.xilinx@gmail.com>
 <286b3685eabf6cdd98021215b9b00020b442a42b.1685992503.git.ecree.xilinx@gmail.com>
 <20230606215658.3192feec@kernel.org>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <9f05ef7a-479c-05a6-e38b-f792034c7afd@gmail.com>
Date: Wed, 7 Jun 2023 21:51:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230606215658.3192feec@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 07/06/2023 05:56, Jakub Kicinski wrote:
> On Mon, 5 Jun 2023 20:17:38 +0100 edward.cree@amd.com wrote:
>> +			dev_hold(neigh->egdev = dst->dev);
> 
> Please use the ref-tracker enabled helpers in new code.

Fair point.  Guessing that applies to the netns reference as well?
(Though looking back I honestly can't remember why we need to hold
 the neigh->net reference for the life of efx_neigh_binder; but I
 presumably had some reason for it at the time and I'm leery of
 removing it now in case it's load-bearing.
 Chesterton's Fence and all that.)

> And the assignment on a separate line, please.

Will do.

-ed

