Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7026B982C
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbjCNOmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:42:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjCNOmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:42:04 -0400
Received: from mo4-p01-ob.smtp.rzone.de (mo4-p01-ob.smtp.rzone.de [85.215.255.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2381AA8C65;
        Tue, 14 Mar 2023 07:41:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1678804705; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=ttrxZjGFUYdB2ma/CRbwcMUssRV/XQ5lZoCGndMBs1mfZlWej768t/jSVEzMVT9eIF
    ffDjbTvyFsi+6yjzyYhFbbF5INXAiCMFsEZzwTdSPkxCIxLvg0dxS5V/9St6nOJn/K8f
    Ol4gzmRPLzQrRKAWYQ+MW/4nfrPJkR98GMBcmrEFXEIxJ1r5Tg9lU/LZm/N881LWsWN1
    m6S7uXe7FkJ1ikAbC+QHOIAq1qcY5BRHrU3WQ+TfHnVbtFQYRFD10wejgTbXpqaGuzlZ
    PA3nyZi61KwFssx7Bwq3iypMNa5Xwp5Ri7qWXSSDmJwWTDOHrJHshu+a1HVz8mqcRyAA
    OAaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1678804705;
    s=strato-dkim-0002; d=strato.com;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=yQaN/eP123ftd27BU/LoXLFK4aqVuDZYUDcnnwWlRwY=;
    b=c6WrQmKpLKx355Ja2ds6cahMlx9m/JZETk4jmVGhUrdEDpBZZEvUehnAtTX1DAST03
    SGyP4VHyn3GTJef0mMtNoICo8+lAA7XUC7Z6/ITKNml2gnHVqLGWW28FD3YwRN5AVOZH
    SxUb7zysfTcWAJB/AtSzRHGAyN0G4KfjJEJJT3+lqQg2aVBAIvnpsyu5LSpOXNyMyu4Y
    mkMtKS39jXRpxmDWiFfWvg9MQVTFCFWE6z8sXFijB+buiKEj0pXbxmgMbGSyFvttFQMO
    wXCGNZnal9tPQKcC+CuBaxgzvSDz7Lry+NNDoqIuCFEzz0cAmzoJ12PvjbZGZ2RSL4Iz
    7NVQ==
ARC-Authentication-Results: i=1; strato.com;
    arc=none;
    dkim=none
X-RZG-CLASS-ID: mo01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1678804705;
    s=strato-dkim-0002; d=hartkopp.net;
    h=In-Reply-To:From:References:Cc:To:Subject:Date:Message-ID:Cc:Date:
    From:Subject:Sender;
    bh=yQaN/eP123ftd27BU/LoXLFK4aqVuDZYUDcnnwWlRwY=;
    b=l71DjzZZuqM4J3dOB83YKXuHSz/7ocgy1UTZ43VrzhXMFa5xYjiMHv91gepotTkm03
    vs+/7MnIiqHlLaBqtcNSlAb93l7mXEi/3nsr2Dn1dA2anPJOndnBAETvJNg/RiLMiqjR
    ld/tvZZGV1qb4Nd5CLsPLO6X4Ie9tteLHFxH+KveiCpdvD0FCF8tyDyl2U6xGBoBVOIh
    3uCdTtn70SHxzdAXVVLbsflhCk6p/1I3oYHw+siD//iQzF7CSQZa6NYuNkh5QBtNTkPY
    h5INyM2Ec5EHYa8pu2vkGZERuEp3TwQEbd4y0G1+hycFVa/8e+B0pj3GbxP3j/L1Z657
    4W9w==
X-RZG-AUTH: ":P2MHfkW8eP4Mre39l357AZT/I7AY/7nT2yrDxb8mjG14FZxedJy6qgO1qCHSa1GLptZHusl129OHEdFq0USEbDUQnQ=="
Received: from [IPV6:2a00:6020:4a8e:5000::923]
    by smtp.strato.de (RZmta 49.3.0 AUTH)
    with ESMTPSA id c675b3z2EEcPefQ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Tue, 14 Mar 2023 15:38:25 +0100 (CET)
Message-ID: <0e7090c4-ca9b-156f-5922-fd7ddb55fee4@hartkopp.net>
Date:   Tue, 14 Mar 2023 15:38:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] FS, NET: Fix KMSAN uninit-value in vfs_write
To:     Ivan Orlov <ivan.orlov0322@gmail.com>, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, himadrispandya@gmail.com,
        skhan@linuxfoundation.org,
        syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
References: <20230314120445.12407-1-ivan.orlov0322@gmail.com>
Content-Language: en-US
From:   Oliver Hartkopp <socketcan@hartkopp.net>
In-Reply-To: <20230314120445.12407-1-ivan.orlov0322@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Ivan,

besides the fact that we would read some uninitialized value the outcome 
of the original implementation would have been an error and a 
termination of the copy process too. Maybe throwing a different error 
number.

But it is really interesting to see what KMSAN is able to detect these 
days! Many thanks for the finding and your effort to contribute this fix!

Best regards,
Oliver


On 14.03.23 13:04, Ivan Orlov wrote:
> Syzkaller reported the following issue:

(..)

> 
> Reported-by: syzbot+c9bfd85eca611ebf5db1@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?id=47f897f8ad958bbde5790ebf389b5e7e0a345089
> Signed-off-by: Ivan Orlov <ivan.orlov0322@gmail.com>

Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>


> ---
>   net/can/bcm.c | 16 ++++++++++------
>   1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/net/can/bcm.c b/net/can/bcm.c
> index 27706f6ace34..a962ec2b8ba5 100644
> --- a/net/can/bcm.c
> +++ b/net/can/bcm.c
> @@ -941,6 +941,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
>   
>   			cf = op->frames + op->cfsiz * i;
>   			err = memcpy_from_msg((u8 *)cf, msg, op->cfsiz);
> +			if (err < 0)
> +				goto free_op;
>   
>   			if (op->flags & CAN_FD_FRAME) {
>   				if (cf->len > 64)
> @@ -950,12 +952,8 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
>   					err = -EINVAL;
>   			}
>   
> -			if (err < 0) {
> -				if (op->frames != &op->sframe)
> -					kfree(op->frames);
> -				kfree(op);
> -				return err;
> -			}
> +			if (err < 0)
> +				goto free_op;
>   
>   			if (msg_head->flags & TX_CP_CAN_ID) {
>   				/* copy can_id into frame */
> @@ -1026,6 +1024,12 @@ static int bcm_tx_setup(struct bcm_msg_head *msg_head, struct msghdr *msg,
>   		bcm_tx_start_timer(op);
>   
>   	return msg_head->nframes * op->cfsiz + MHSIZ;
> +
> +free_op:
> +	if (op->frames != &op->sframe)
> +		kfree(op->frames);
> +	kfree(op);
> +	return err;
>   }
>   
>   /*
