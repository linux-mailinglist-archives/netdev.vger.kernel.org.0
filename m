Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC725A5392
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 19:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiH2RzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 13:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiH2RzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 13:55:21 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A97286D0
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 10:55:17 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id ay39-20020a05600c1e2700b003a5503a80cfso4838731wmb.2
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 10:55:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=W9xLOeQ1DMWnZYzrDwRC4aH4WmIQ6ob1xqAQ9e7Axg0=;
        b=bcN1eiKRGwEvBCEr06wPOJLtNaLCmJqwTHiUX52Dsl4qFuL+YGXnQldOsR34jA55wa
         W/1jLpt2jaOEwvckra6O9rD7seIilIWa0LSc4T5oLIWwb6bAa1v8GVXykItPYzE4ySqR
         vJjhGJZ2vCXE6ZEPXkT7bGLQ30Nm/159nmMWIdm3jox4cPIHDHy3Pi6c4jYnGeJAwlzH
         dgNnWYW2lpqdo64nZPFlwLAlH+mVq0xnd4iBq/Uvwnxy3vjMLgKYEElqZ/RgvnKXJm6X
         NhjbnAwWlAZybe8NeDZ4dOIJxiSo6uxh8FHEvgzNwDv63pvJsxKpe2CTM89vL7VM1D+I
         Z1XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=W9xLOeQ1DMWnZYzrDwRC4aH4WmIQ6ob1xqAQ9e7Axg0=;
        b=43ZGc28ZMaLeCfXoO2IB/wanvINqc9glk3gosUk6TpdfSR2JTyxdJ1rP+9kskHLQ+S
         tiGyhp7p+uC7DIhn+aBJfLHajoroFFgnhqimGRXYnh2s2gGx5EHG1Ap4RYnW63EX/6nc
         lWTmHssImRAfwFkENw62ag55wkdkhrUNJqckCvJltsKCLKk+btBHlIqHkTfQQ5W35G7p
         oTYN3OZEeI1Su5f4LB/eKNu4mEosLg6lpzb3/WCA2Xi8emD7NArE+4hZ9f+fIYdO8bjN
         zdNKp0kEAz1vfsZ/NUDvwAHorONdDzpEbJqZiBIMscyqmpUBKk/ZRokyj9z1ZoD5/Nma
         U6HQ==
X-Gm-Message-State: ACgBeo2m5JBTkeKKDY8MiebI47QlPAG1rRoj6QDz6nLMfCqRFDH22b0a
        Z8fNJf+HOhQF9+NhgCsckIqu5Q==
X-Google-Smtp-Source: AA6agR4mqOpzLksf1UadAbtjGlE/l+Iww+jCBb2rbTduJ9yxyWooiqsuRt8KqwGuagb8JpuIqAaQtw==
X-Received: by 2002:a05:600c:4f48:b0:3a5:e707:bb8c with SMTP id m8-20020a05600c4f4800b003a5e707bb8cmr7681257wmq.198.1661795715955;
        Mon, 29 Aug 2022 10:55:15 -0700 (PDT)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id p9-20020a05600c23c900b003a6125562e1sm9444142wmb.46.2022.08.29.10.55.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 10:55:15 -0700 (PDT)
Message-ID: <fce974f0-cea9-fa92-ecfc-4f7cc4fc95e2@arista.com>
Date:   Mon, 29 Aug 2022 18:55:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [kbuild] Re: [PATCH 11/31] net/tcp: Add TCP-AO sign to outgoing
 packets
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>, kbuild@lists.01.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Cc:     lkp@intel.com, kbuild-all@lists.01.org, netdev@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        David Ahern <dsahern@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Ivan Delalande <colona@arista.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Leonard Crestez <cdleonard@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-crypto@vger.kernel.org
References: <202208221901.Fs6wW5Jd-lkp@intel.com>
From:   Dmitry Safonov <dima@arista.com>
In-Reply-To: <202208221901.Fs6wW5Jd-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

On 8/22/22 13:03, Dan Carpenter wrote:
> Hi Dmitry,
[..]
> ea66758c1795cef Paolo Abeni           2022-05-04  608  static void tcp_options_write(struct tcphdr *th, struct tcp_sock *tp,
[..]
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  622  #ifdef CONFIG_TCP_AO
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  623  	if (unlikely(OPTION_AO & options)) {
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  624  		u8 maclen;
> 33ad798c924b4a1 Adam Langley          2008-07-19  625  
> 85df6b860d509a9 Dmitry Safonov        2022-08-18 @626  		if (tp) {
> 
> Can "tp" really be NULL?  Everything else assumes it can't.

It actually can be NULL, see tcp_make_synack().
At this moment code assumes that *either* (tp == NULL) or (tcprsk == NULL).

> 85df6b860d509a9 Dmitry Safonov        2022-08-18  627  			struct tcp_ao_info *ao_info;
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  628  
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  629  			ao_info = rcu_dereference_check(tp->ao_info,
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  630  				lockdep_sock_is_held(&tp->inet_conn.icsk_inet.sk));
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  631  			if (WARN_ON_ONCE(!ao_key || !ao_info || !ao_info->rnext_key))
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  632  				goto out_ao;
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  633  			maclen = tcp_ao_maclen(ao_key);
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  634  			*ptr++ = htonl((TCPOPT_AO << 24) |
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  635  				       (tcp_ao_len(ao_key) << 16) |
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  636  				       (ao_key->sndid << 8) |
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  637  				       (ao_info->rnext_key->rcvid));
> 85df6b860d509a9 Dmitry Safonov        2022-08-18  638  		}
> 
> "maclen" not initialized on else path.

Patch 15 ("net/tcp: Wire TCP-AO to request sockets") adds
+		if (tcprsk) {
+			u8 aolen = tcprsk->maclen + sizeof(struct tcp_ao_hdr);
+
+			maclen = tcprsk->maclen;
+			*ptr++ = htonl((TCPOPT_AO << 24) | (aolen << 16) |
+				       (tcprsk->ao_keyid << 8) |
+				       (tcprsk->ao_rcv_next));
+		}

Assuming that tp != NULL OR tcprsk != NULL, maclen is always initialized
_after both patches_.
For version 2, I'll make it (break patches) in more bisect-able way for
static analyzers and do WARN_ON(tp == NULL && tcprsk == NULL) with break
off TCP-AO signing to make sure the assumption will be valid with
the code changing later on.

[..]
> ea66758c1795cef Paolo Abeni           2022-05-04  731  	mptcp_options_write(th, ptr, tp, opts);
>                                                                                      ^^
> Not checked here either.

The function has checks inside.

Thanks,
          Dmitry
