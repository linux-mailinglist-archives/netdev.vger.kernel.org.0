Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3DA59E792
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 18:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245157AbiHWQi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 12:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245062AbiHWQhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 12:37:36 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7B16F278;
        Tue, 23 Aug 2022 07:45:38 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bj12so10857663ejb.13;
        Tue, 23 Aug 2022 07:45:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Xp12azsz2mcA1D+pCwTb7QzHx7vJCfU7QBtBOPIfqGI=;
        b=nYTnfGoHuLEgzto2xQCl3xyYxG6a1ZP8vCa5qEWFIkagaBsgJJfPQ+CE85EPKLZa9x
         meL+FfNyVT/CnRp5o7ucX+w8gdn0oX+Xgr0zDHJbxc/l9/uI27v+3JCErx06mmSTIinJ
         9WP4G93cG//IJwewck7V2s0NVVL4QhAmbjg5HZdAbBIxe+PxPBo5EGkwcIRqqFJsxsrA
         EfTcCOmB2HqD7Xf+Cfe2K0pVGVhSBN+rMPe7Q9QXUWsPGAo4kWFTSAaTaNZhVzT5m1z8
         /YlQ/FhSMKM6fiTKnqEKnj9jsucEbg496z3l2Hnzy7k06ehpjlIkRNMMp0QBAZLLGzVv
         hinQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Xp12azsz2mcA1D+pCwTb7QzHx7vJCfU7QBtBOPIfqGI=;
        b=s24C14R2mxm8PYpdvGbSrDpkgXbkgcSF9zslNXcADF2eu1OJsuRYqN41nI7od6D/+s
         l7NC9xd3F0RkRb8lfIWwtYiiGob8E688pRo73FzBnr4h4Imz8etpmyvxhnoM7isFQUPA
         YkuWEpub386jhnnECu208+JCTjZLh4Xl3f4WMTaeUUJhkx2KO9bxfuPIlgGubKtWImTy
         2nQKy8mrQwB2NSLKSjPIuJtfau5VnKXeWaJauGTjUksD9kURNSeO5n77OsXvLIt1CA4r
         BeWt/q6SpSoKxt0U0wQSeMTlg6oImlfVWfd8tqTVhewMvf8g8tFtNApA1NgcY9UFDa94
         fuCA==
X-Gm-Message-State: ACgBeo3hAhJrQwewf8rFnbk0DpAMBCPh216AALNFI5NS+zyhsb5IRJaH
        8p5WrM86+7feqbuh3/vBsrw=
X-Google-Smtp-Source: AA6agR5/uo2cN0jwt/fJtgv224c+BctP2Eh/UT482g31amCpKeS9r5eJePXY3Y0xHmQk+/Li73zllA==
X-Received: by 2002:a17:906:6a0a:b0:73d:6c6a:1b8f with SMTP id qw10-20020a1709066a0a00b0073d6c6a1b8fmr9527542ejc.240.1661265937066;
        Tue, 23 Aug 2022 07:45:37 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:f5c4:cca0:9b39:e8aa? ([2a04:241e:502:a09c:f5c4:cca0:9b39:e8aa])
        by smtp.gmail.com with ESMTPSA id dx9-20020a170906a84900b0073d8891b78dsm2244720ejb.90.2022.08.23.07.45.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Aug 2022 07:45:36 -0700 (PDT)
Message-ID: <162ae93b-5589-fbde-c63b-749f21051784@gmail.com>
Date:   Tue, 23 Aug 2022 17:45:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 08/31] net/tcp: Introduce TCP_AO setsockopt()s
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
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <20220818170005.747015-1-dima@arista.com>
 <20220818170005.747015-9-dima@arista.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <20220818170005.747015-9-dima@arista.com>
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
> Add 3 setsockopt()s:
> 1. to add a new Master Key Tuple (MKT) on a socket
> 2. to delete present MKT from a socket
> 3. to change flags of an MKT
> 
> Userspace has to introduce keys on every socket it wants to use TCP-AO
> option on, similarly to TCP_MD5SIG/TCP_MD5SIG_EXT.
> RFC5925 prohibits definition of MKTs that would match the same peer,
> so do sanity checks on the data provided by userspace. Be as
> conservative as possible, including refusal of defining MKT on
> an established connection with no AO, removing the key in-use and etc.
> 
> (1) and (2) are to be used by userspace key manager to add/remove keys.
> (3) main purpose is to set rnext_key, which (as prescribed by RFC5925)
> is the key id that will be requested in TCP-AO header from the peer to
> sign their segments with.
> 
> At this moment the life of ao_info ends in tcp_v4_destroy_sock().


> +#define TCP_AO			38	/* (Add/Set MKT) */
> +#define TCP_AO_DEL		39	/* (Delete MKT) */
> +#define TCP_AO_MOD		40	/* (Modify MKT) */

The TCP_AO_MOD sockopt doesn't actually modify and MKT, it only controls 
per-socket properties. It is equivalent to my TCP_AUTHOPT sockopt while 
TCP_AO is equivalent to TCP_AUTHOPT_KEY. My equivalent of TCP_AO_DEL 
sockopt is a flag inside tcp_authopt_key.

> +struct tcp_ao { /* setsockopt(TCP_AO) */
> +	struct __kernel_sockaddr_storage tcpa_addr;
> +	char	tcpa_alg_name[64];
> +	__u16	tcpa_flags;

This field accept TCP_AO_CMDF_CURR and TCP_AO_CMDF_NEXT which means that 
you are combining key addition with key selection. Not clear it 
shouldn't just always be a separate sockopt?

> +	__u8	tcpa_prefix;
> +	__u8	tcpa_sndid;
> +	__u8	tcpa_rcvid;
> +	__u8	tcpa_maclen;
> +	__u8	tcpa_keyflags;
> +	__u8	tcpa_keylen;
> +	__u8	tcpa_key[TCP_AO_MAXKEYLEN];
> +} __attribute__((aligned(8)));
> +
> +struct tcp_ao_del { /* setsockopt(TCP_AO_DEL) */
> +	struct __kernel_sockaddr_storage tcpa_addr;
> +	__u16	tcpa_flags;
> +	__u8	tcpa_prefix;
> +	__u8	tcpa_sndid;
> +	__u8	tcpa_rcvid;
> +	__u8	tcpa_current;
> +	__u8	tcpa_rnext;
> +} __attribute__((aligned(8)));
> +
> +struct tcp_ao_mod { /* setsockopt(TCP_AO_MOD) */
> +	__u16	tcpa_flags;
> +	__u8	tcpa_current;
> +	__u8	tcpa_rnext;
> +} __attribute__((aligned(8)));

This is quite similar to my "struct tcp_authopt" in the fact that it is 
intented to support controlling the "current keys".

* tcpa_current is equivalent to send_keyid
* tcpa_rnext is equivalent to send_rnextkeyid

I also have two fields called "recv_keyid" and "recv_rnextkeyid" which 
inform userspace about what the remote is sending, I'm not seeing an 
equivalent on your side.

The specification around send_keyid in the RFC is conflicting:
* User must be able to control it
* Implementation must respect rnextkeyid in incoming packet

I solved this apparent conflict by adding a 
"TCP_AUTHOPT_FLAG_LOCK_KEYID" flag so that user can choose if it wants 
to control the sending key or let it be controlled from the other side.

The "send_rnextkeyid" is also optional in my patch, if 
TCP_AUTHOPT_FLAG_LOCK_RNEXTKEYID is not passed then the recv_id of the 
sending key is sent.

Here's a link to my implementation of key selection controls:

https://lore.kernel.org/netdev/2956d99e7fbf9ff2a8cc720c67baaef35bc32343.1660852705.git.cdleonard@gmail.com/

> +static int tcp_ao_parse_crypto(struct tcp_ao *cmd, struct tcp_ao_key *key)
> +{
> +	unsigned int syn_tcp_option_space;
> +	struct crypto_pool_ahash hp;
> +	bool is_kdf_aes_128_cmac = false;
> +	struct crypto_ahash *tfm;
> +	int err, pool_id;
> +
> +	/* Force null-termination of tcpa_alg_name */
> +	cmd->tcpa_alg_name[ARRAY_SIZE(cmd->tcpa_alg_name) - 1] = '\0';
> +
> +	/* RFC5926, 3.1.1.2. KDF_AES_128_CMAC */
> +	if (!strcmp("cmac(aes128)", cmd->tcpa_alg_name)) {
> +		strcpy(cmd->tcpa_alg_name, "cmac(aes)");
> +		is_kdf_aes_128_cmac = (cmd->tcpa_keylen != 16);
> +	}

Only two algorithms are defined in RFC5926 and you have to treat one of 
them as a special case. I remain convinced that generic support for 
arbitrary algorithms is undesirable; it's better for the algorithm to be 
specified as an enum.

--
Regards,
Leonard
