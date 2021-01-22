Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318C12FFDCB
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbhAVIAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbhAVIAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:00:22 -0500
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA66C06174A;
        Thu, 21 Jan 2021 23:59:34 -0800 (PST)
Received: by mail-qk1-x72c.google.com with SMTP id d85so4348456qkg.5;
        Thu, 21 Jan 2021 23:59:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=DIm7NQwEZ3rnfsvD3N/g37yd5G2No6xvpy31Hmlr4H8=;
        b=NInGt31M9KgfwdgpdBCt6bYIzP5ypGhaDiKlNMyGNrHPtifcaAHragfp8pumn7QE+L
         LLBsliHRcE35JdzFfg3mUqDQe23u38VpG332V6eTsTE2dCLPuZ6R0bPiIyOlr6HQ8B9T
         fYhMQvED7Oxl5TKnjLXhNYLDGmu4EgZkCdh3gJwoFSl4quUUUxKcR4ieC57dVairym0T
         lg5oyELO0hpC4mUBZ6ptHEieiHU/DfeS+sAEeyCZb8dBvM1g+Z5rhcdw53BNRllfYH+I
         Ngl/qfBJPiRRnTFCFAmptCXU3y+UK7YCAF7bHZOTBUB1TtUvXpjWwtUaqbY1+qDgKK5E
         aixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=DIm7NQwEZ3rnfsvD3N/g37yd5G2No6xvpy31Hmlr4H8=;
        b=g5zU7AhBexglxk5N8t9+bDbJfwAzwQZs0ofyuGs1xZrdeglis9LI5Q0VkIw2u5nUan
         1FAydaBssdtK9ni5elQVWtIh85seFuZaETAXvB8GZhtkcKEoj34bJLBAKTUOg66fcDCv
         VFmJU5cqD5Nz865J+Who75/WXnPczWCP6a5hhXeenXCx0MjRU3bwZiZE18Tb6vpZOzGk
         boxkYrqxHrWogPpvI+bnimN9Yz0oxMJhYStnyG0NOXv7OaxLY4VIv1I7DXdUqwey9qQs
         t8h3YpxhSCXPXhPvGmfaTBoy4TIVrNsBLzRxrIjnwjcgMrQ4m57uOeCOb1dbejxMlHvf
         ZaHA==
X-Gm-Message-State: AOAM533PC19+vyocaLXt1gPKbKySm0wSI44oMCezTWLLQmO8mV0VOFfT
        GpXeYC6JWlk9GRMF4oC4Y9m1Eyp5n+KLCM4PA+Y=
X-Google-Smtp-Source: ABdhPJzFDCl6+IqNtn2es9MvnCFwOG9YIsDSVokNjEktA72Xy4ckD36SvbcGxtR3/w4tirgELJupig==
X-Received: by 2002:a37:2e87:: with SMTP id u129mr3603479qkh.344.1611302373507;
        Thu, 21 Jan 2021 23:59:33 -0800 (PST)
Received: from [0.0.0.0] ([2001:19f0:5:2661:5400:2ff:fe99:4621])
        by smtp.gmail.com with ESMTPSA id u7sm5542883qke.116.2021.01.21.23.59.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Jan 2021 23:59:32 -0800 (PST)
Subject: Re: [PATCH v1] can: mcp251xfd: use regmap_bulk_write for
 compatibility
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        manivannan.sadhasivam@linaro.org, thomas.kopp@microchip.com,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210122030214.166334-1-suyanjun218@gmail.com>
 <7007275e-a271-8160-729b-67e4d579dfe2@pengutronix.de>
From:   Su <suyanjun218@gmail.com>
Message-ID: <a19c70eb-6478-836a-8b39-be34101bdcae@gmail.com>
Date:   Fri, 22 Jan 2021 15:59:22 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7007275e-a271-8160-729b-67e4d579dfe2@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/1/22 下午3:26, Marc Kleine-Budde 写道:
> On 1/22/21 4:02 AM, Su Yanjun wrote:
>> Recently i use mcp2518fd on 4.x kernel which multiple write is not
>> backported, regmap_raw_write will cause old kernel crash because the
>> tx buffer in driver is smaller then 2K. Use regmap_bulk_write instead
>> for compatibility.
> Hmmm, this patch will never be backported to any 4.x kernel, as the driver is
> not available on these kernels. You have to carry patches for these kernels
> anyway, so I think I'll not take that patch. Sorry. Drop me a note if you are
> interested in updating your kernel to a recent v5.11 kernel.

I got it. I have already port it to 4.x kernel. I just want anyone 
working on old kernels to use the driver more easier.

Thanks.

>
> regards,
> Marc
>
