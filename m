Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFB5959E760
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244960AbiHWQeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244638AbiHWQde (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:33:34 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD00EE58B5;
        Tue, 23 Aug 2022 07:50:47 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w10so6229926edc.3;
        Tue, 23 Aug 2022 07:50:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=9FkbKWfrE7syTvjgVRfTfp1QVZS5uNWK2l9/kYxbDIo=;
        b=VqXQUoqNkfeNZyklgLrRt9wOSiknNhjeL9iSJXyh8uVPqmoM5JVXSZG7SfNasI+hwu
         49/sW/PGdPuNWBLvLI/o5KGRWsw+vcWBIXbx0P7VHyKNERqOBBmUtWfGJUYUPwFImMX0
         g9a7uAnzZVlSJc+n20RQ79RB56freCTS9pTrgQFwomdMcdjx/QDf4WAlPQBBemRqFXSZ
         JbMX3xpc4C9HY9eu/RS6u0obRvUC0NjoeZjJ1nGt51Ytm9CV9UX8ZD8kXM8URhhWmEpL
         2XAZm0uu0wRAjRr/DaNu+GzyK60zS2BUtxNodeoW2dHBsvASAI6QEkHmN3E7Qxq1ifF0
         yApg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=9FkbKWfrE7syTvjgVRfTfp1QVZS5uNWK2l9/kYxbDIo=;
        b=7FGz/EpxzdKPq2/NOtpPvCF2lRBSmsiT/z4SKOpes5Vviu1HZt4chcvf6IyWEjCCjs
         TD3w2jnfvYU+YjzT8FBbHZS4SnHNu3MGIQvZKJ+Mryd6mnSGERCOpBkyBucqchOYdui/
         qGtpIxtpDXLsNtFJKtbXZmq67rtQmOCGxZOIa/U0vQYngyvQnpgqTvJJaYQyLPPOTiNt
         bKddA57IOcVOGq6qeE9T0wOCtzLn8RZ3JxbNzNKumldmKeKV5KEB5LCQcYjOi3gwymR9
         PnfjdZuOSssmr9LeSdRUGFhF01OW2MNI3uO7dsqDDNcJT9OxxV2t1GFvdo+7ZhlZt9Z8
         CLoA==
X-Gm-Message-State: ACgBeo0Jj9TXqnv/gZDN+TNZ1lL7sjB3S6Y3PlDwrZdckeu16CCYuSUc
        3ckKFZYxjPGg8qYj7xsJBMM=
X-Google-Smtp-Source: AA6agR4fZaRj2PGPD9O/XDdU/NGZNcNJidhVlJtmFWx0E3P96etNLFWDppzqcmKdWMvosJjO67UJWg==
X-Received: by 2002:aa7:ce0f:0:b0:445:f488:51ca with SMTP id d15-20020aa7ce0f000000b00445f48851camr408017edv.6.1661266246401;
        Tue, 23 Aug 2022 07:50:46 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:f5c4:cca0:9b39:e8aa? ([2a04:241e:502:a09c:f5c4:cca0:9b39:e8aa])
        by smtp.gmail.com with ESMTPSA id w21-20020a1709061f1500b0072eddcc807fsm7589047ejj.155.2022.08.23.07.50.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 07:50:45 -0700 (PDT)
Message-ID: <01f8616c-2904-42f1-1e59-ca4c71f7a9bd@gmail.com>
Date:   Tue, 23 Aug 2022 17:50:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 19/31] net/tcp: Add TCP-AO SNE support
Content-Language: en-US
To:     Dmitry Safonov <dima@arista.com>
Cc:     Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
References: <20220818170005.747015-1-dima@arista.com>
 <20220818170005.747015-20-dima@arista.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <20220818170005.747015-20-dima@arista.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/22 19:59, Dmitry Safonov wrote:
> Add Sequence Number Extension (SNE) extension for TCP-AO.
> This is needed to protect long-living TCP-AO connections from replaying
> attacks after sequence number roll-over, see RFC5925 (6.2).

> +#ifdef CONFIG_TCP_AO
> +	ao = rcu_dereference_protected(tp->ao_info,
> +				       lockdep_sock_is_held((struct sock *)tp));
> +	if (ao) {
> +		if (ack < ao->snd_sne_seq)
> +			ao->snd_sne++;
> +		ao->snd_sne_seq = ack;
> +	}
> +#endif
>   	tp->snd_una = ack;
>   }

... snip ...

> +#ifdef CONFIG_TCP_AO
> +	ao = rcu_dereference_protected(tp->ao_info,
> +				       lockdep_sock_is_held((struct sock *)tp));
> +	if (ao) {
> +		if (seq < ao->rcv_sne_seq)
> +			ao->rcv_sne++;
> +		ao->rcv_sne_seq = seq;
> +	}
> +#endif
>   	WRITE_ONCE(tp->rcv_nxt, seq);

It should always be the case that (rcv_nxt == rcv_sne_seq) and (snd_una 
== snd_sne_seq) so the _sne_seq fields are redundant. It's possible to 
avoid those extra fields.

However 8 bytes per TCP-AO socket is inconsequential.

--
Regards,
Leonard
