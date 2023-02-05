Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB16C68AFE9
	for <lists+netdev@lfdr.de>; Sun,  5 Feb 2023 14:18:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjBENSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Feb 2023 08:18:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjBENSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Feb 2023 08:18:46 -0500
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 522D311E97
        for <netdev@vger.kernel.org>; Sun,  5 Feb 2023 05:18:45 -0800 (PST)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-16a10138faeso5912194fac.11
        for <netdev@vger.kernel.org>; Sun, 05 Feb 2023 05:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=h16mJ+aO8lr2ielP5RpRXxKcR46VAZs2FWT7LlTMtpc=;
        b=dYJowsvHwOLrIclI6l2MSF0Q1WwGPZKqxISvHsgenprhQq6S1FOjy9sTerHy7Jtf0u
         XUKpsqyx4tqe7PIxSqXuM0pk0x+RA8pZ9CepIdZ9ImEC40Paa3MWRn7lI0p8/jtACKFz
         KCvsqr7RxDpddrK9v4rVjjf9AoM3FQVYWl4vTHyc2ScFmiivipJhikxr2OILk5ANZXHl
         wBL63bvqvH/1TWy3xxnM0eAwIDPJKgd8QeRq45lIl5YyZF9M/5oiyput3OW2W2G9+95q
         udMtpHi/q4dxOxvbhpvkfva3k4GLE7LoUP980iQ2J18hDnCYfJ1W2udx/OaFqD8+pQC0
         XJvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=h16mJ+aO8lr2ielP5RpRXxKcR46VAZs2FWT7LlTMtpc=;
        b=6kqOyldoCbgwE6wRudqZWity08qCjpFnSCDGJRfvlZa9gk/aM1zOq4UU1ti1xqOm0R
         zIKBqkVK0zlOw/EOFzRa7KBs6l12QtariAtURvYpv8x3OENuIuNnY/7mRPp6fMbUHFv2
         VFOslM98mxNAj8ouQ7A2RkI5+WAOMJ8urDMO3rSBzaB7SacOJQwsdeJz1Mgmva1T64cb
         GPIFzxtLqXf40Jp8k8mnzHpeC8l8bKfUfRLt1oAKhiEz9/MQ59RfZwt3Ik8V6cg78X+C
         drosiNfuJGOwJD6jj3VU1I3uwxzcaXVlFaBj8Ud5RtYAWZG9TQ6H17IPZYzBOt75BI2r
         w11w==
X-Gm-Message-State: AO0yUKWjL32hOyaHDpxOE65jJ8MHXS4yRlhkeafhE8n75iKi7EOjWcNL
        TDwS/eALiTToU+CjHOOqmpv+bBeBo/+X0hD9j9b23Q==
X-Google-Smtp-Source: AK7set8fyzikb9w/tfLmg85NZNZ97HLh/d73kei5xCwzmXPjRHGaVo+XJFv+Sm+v8W1kbUv43TfIS+C2lQh7PqSIYuY=
X-Received: by 2002:a05:6870:649e:b0:15f:1ad9:6c2c with SMTP id
 cz30-20020a056870649e00b0015f1ad96c2cmr1407757oab.184.1675603124525; Sun, 05
 Feb 2023 05:18:44 -0800 (PST)
MIME-Version: 1.0
References: <7d8ab7fee45222cdbaf80c507525f2d3941587c1.1675371372.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <7d8ab7fee45222cdbaf80c507525f2d3941587c1.1675371372.git.christophe.jaillet@wanadoo.fr>
From:   Loic Poulain <loic.poulain@linaro.org>
Date:   Sun, 5 Feb 2023 14:18:07 +0100
Message-ID: <CAMZdPi-hUyorX6N-3koxOZ+gSxovdQc7iKxx7wuN+qJek_cvCA@mail.gmail.com>
Subject: Re: [PATCH net-next] wifi: wcn36xx: Slightly optimize PREPARE_HAL_BUF()
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Feb 2023 at 21:58, Christophe JAILLET
<christophe.jaillet@wanadoo.fr> wrote:
>
> In most (likely all) cases, INIT_HAL_MSG() is called before
> PREPARE_HAL_BUF().
> In such cases calling memset() is useless because:
>    msg_body.header.len = sizeof(msg_body)
>
> So, instead of writing twice the memory, we just have a sanity check to
> make sure that some potential trailing memory is zeroed.
> It even gives the opportunity to see that by itself and optimize it away.
>
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Loic Poulain <loic.poulain@linaro.org>



> ---
>  drivers/net/wireless/ath/wcn36xx/smd.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
> index 566f0b9c1584..17e1919d1cd8 100644
> --- a/drivers/net/wireless/ath/wcn36xx/smd.c
> +++ b/drivers/net/wireless/ath/wcn36xx/smd.c
> @@ -475,8 +475,8 @@ static int wcn36xx_smd_send_and_wait(struct wcn36xx *wcn, size_t len)
>
>  #define PREPARE_HAL_BUF(send_buf, msg_body) \
>         do {                                                    \
> -               memset(send_buf, 0, msg_body.header.len);       \
> -               memcpy(send_buf, &msg_body, sizeof(msg_body));  \
> +               memcpy_and_pad(send_buf, msg_body.header.len,   \
> +                              &msg_body, sizeof(msg_body), 0); \
>         } while (0)                                             \
>
>  #define PREPARE_HAL_PTT_MSG_BUF(send_buf, p_msg_body) \
> --
> 2.34.1
>
