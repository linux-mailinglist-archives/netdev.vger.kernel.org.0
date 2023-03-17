Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45B286BF199
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 20:20:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbjCQTUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 15:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbjCQTUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 15:20:47 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CB2F1CBE8;
        Fri, 17 Mar 2023 12:20:44 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id cy23so24233969edb.12;
        Fri, 17 Mar 2023 12:20:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679080842;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ipteKbyLRilvrFKtkN552HGn3csqgfJvLO2UFDLogH8=;
        b=T85EszIagCy3FQoMmIi3feGmH9uDu+x+vQBdKaGuG6qHAKIAkdxGsrHVyQTzD4Icm3
         3Wnq+sWC1+Z2UVFKHsbIHcQYnTJrCdc8g0qNYFD9pPduns+JpW2+cjoUZ4ZNQtOap/Qa
         W4ba/zFjWP7nglx1+KMsHyruLGLjt3kBzZUvbmv6yD2YSbTEDd4AWi3bdCQr+W0I3iih
         HaHfQHa+WpsBD264wdVrRJ2/cwCRSQ7O5AHOz6/ycTGvjX88VeDhGeA9kkSGkPwTT5Co
         aVMzLaIYOaTNkhjy5nxvHUPhrZiBw9e2wdAcj1S9Qn8tXtswLvFsD8jDfGAHIf/UDmfd
         Z9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679080842;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ipteKbyLRilvrFKtkN552HGn3csqgfJvLO2UFDLogH8=;
        b=W7jPKY1Uhbj+jovXeyqjcUzPQPoCc3wh6ydyPPBm6cUYu3aCnGIBtUgXkIi1IlSqYo
         ljSzcAXzeQgDGry/gQzyF05WVDe951QH6HLYzWvkMkYmB6CCkWRflsZ0fUYNGXrQyjRw
         u6r5whaEDnfjUbp67xE8XAfips6BR6jBSSbyiFR+5DeyWhqY3jSmdsuJu3tHq9LC8J/0
         6U1J2gVEVvert52y79i3fpV1W74jWJJJ2H+5gtZaZG0xIQMlOSwgm2SSu4udw4TyC6+Y
         v+KDCvozuAylz/4QQWZH7piDbYtNrZstc1zQ0i+ieBg+GLXJEzDrf5cXCkDUhoMFjVH9
         cfXg==
X-Gm-Message-State: AO0yUKWyoflVYiU01qKbW0vMAmKRFExDhVYbGG4wnrfo2xJ7pj5wOUFY
        z6jriIWJz9SV7Q2qeO2drMI=
X-Google-Smtp-Source: AK7set+BxqA20CFXrX4V7MY7Z9SiOFmNVC/HiodqrFYFKzxh3CwX85AfRREnrLxGdVkvjOLS35qZiQ==
X-Received: by 2002:a17:906:3fcf:b0:92d:6078:3878 with SMTP id k15-20020a1709063fcf00b0092d60783878mr480494ejj.33.1679080842438;
        Fri, 17 Mar 2023 12:20:42 -0700 (PDT)
Received: from shift (p5b0d7c06.dip0.t-ipconnect.de. [91.13.124.6])
        by smtp.gmail.com with ESMTPSA id ec21-20020a0564020d5500b004fc01b0aa55sm1451581edb.4.2023.03.17.12.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 12:20:42 -0700 (PDT)
Received: from localhost ([127.0.0.1])
        by shift with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1pdFcE-0005Af-0A;
        Fri, 17 Mar 2023 20:20:41 +0100
Message-ID: <5dfdb3c9-59e2-0147-b29d-276511e81ec6@gmail.com>
Date:   Fri, 17 Mar 2023 20:20:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH][next] carl9170: Fix multiple -Warray-bounds warnings
Content-Language: de-DE
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <ZBSjx236+BTiRByf@work>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <ZBSjx236+BTiRByf@work>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/23 18:30, Gustavo A. R. Silva wrote:
> GCC (and Clang)[1] does not like having a partially allocated object,
> since it cannot reason about it for bounds checking. Instead, fully
> allocate struct carl9170_cmd.
> 
> Fix the following warnings Seen under GCC 13:
> drivers/net/wireless/ath/carl9170/cmd.c:125:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[4]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:126:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[4]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:125:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:126:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:161:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:162:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:163:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:164:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[20]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:125:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[8]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:126:30: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[8]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/cmd.c:220:12: warning: array subscript ‘struct carl9170_cmd[0]’ is partly outside array bounds of ‘unsigned char[8]’ [-Warray-bounds=]
> 
> Link: https://github.com/KSPP/linux/issues/268
> Link: godbolt.org/z/KP97sxh3T [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Acked-by: Christian Lamparter <chunkeey@gmail.com>

> ---
>   drivers/net/wireless/ath/carl9170/cmd.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/cmd.c b/drivers/net/wireless/ath/carl9170/cmd.c
> index f2b4f537e4c1..b8ed193c0195 100644
> --- a/drivers/net/wireless/ath/carl9170/cmd.c
> +++ b/drivers/net/wireless/ath/carl9170/cmd.c
> @@ -120,7 +120,7 @@ struct carl9170_cmd *carl9170_cmd_buf(struct ar9170 *ar,
>   {
>   	struct carl9170_cmd *tmp;
>   
> -	tmp = kzalloc(sizeof(struct carl9170_cmd_head) + len, GFP_ATOMIC);
> +	tmp = kzalloc(sizeof(*tmp), GFP_ATOMIC);


This might throw-off people here. The reason this works is because carl9170_cmd struct
looks like this:
|
|struct carl9170_cmd {
|        struct carl9170_cmd_head hdr; <-- 4 bytes
|        union {
|                struct carl9170_set_key_cmd     setkey;
| [...]
|                struct carl9170_rx_filter_cmd   rx_filter;
|                u8 data[CARL9170_MAX_CMD_PAYLOAD_LEN]; <---- that's 60 bytes
|        } __packed __aligned(4);
|} __packed __aligned(4);

All commands have to fit into the command endpoint max size which is 64 bytes.
