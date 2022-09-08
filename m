Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA005B1A6B
	for <lists+netdev@lfdr.de>; Thu,  8 Sep 2022 12:47:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiIHKrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Sep 2022 06:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiIHKra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Sep 2022 06:47:30 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 182C0E1266;
        Thu,  8 Sep 2022 03:47:28 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id b16so23728916edd.4;
        Thu, 08 Sep 2022 03:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=ISvvLkSqOKbyvExALYhZ+2yg+DlHE71/BrfNnMgsDQ0=;
        b=obrVgx6IGfSDAIbq0CmdOu4JsL8KwGLpOi1wDs3YKoBajKDlAsmfQSph4Gl6OCea7u
         XL0GGblNdYWjdLhJ/XgqUtH/kcw2eqs9k3bbRMhwrmMO4fEH+e1/lZCqZkRc55fKE2RL
         g45SPmQGZm/8cax+3jPhF/pKKeLx/T3J283YLfoa1WLmv3J9zV579nCLa4TU4WTf3nsB
         156y3H+K7FMcU7X/6hY+QpdxYg/YOk0f6wpuZfSPwHsn3+YfPEazv6dhc7JfsltLVj9S
         woC9SsTUl8v4DH0rOdxZP9TnmDeFyq+V5iNIRLAEH6W5jIdRtumKvbdkirr1eFzH7Q0J
         haJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ISvvLkSqOKbyvExALYhZ+2yg+DlHE71/BrfNnMgsDQ0=;
        b=XniiFUj+MDMH2mKnv8dGBui0rYq/96+Y+9S4l9/6hjSybd8i7SA0OFVnPtEHfx1nqC
         yISyRhVdJi+y5W2Plo/RWFcmpwLL9UwFB0N7eHwtClUv2J0cwD6ZJ2sdLdrkqZENOfkk
         IByi77Y/qNKbvwS93EfEdZecYm0mbimiRZundo24S7MRZf34f8baO1funHlGkL+1MI3g
         +CnONtX68y1pZJhIYqDsd0UgjWNurgXc+0JK0kGistX2hSowxrhZ8EaVXliKa+3K/hck
         LvvfSvTtb4YlD6n2dMzFue6MNGf5VTAjtegE32gXc+0Df7zi70rqG/1tJuy2+Ggr//mw
         Yniw==
X-Gm-Message-State: ACgBeo1s6kGPC5NYwLbQar0MMmKLFLK6ooX4//aOQgQ1EgnqNdmt3tol
        GWstLmOko05/+2AOr0YU6m8=
X-Google-Smtp-Source: AA6agR5Wl9jn+6GV9pqJrgyy4CAGDj0l8bcPPVwd8mSl8Z2PUTTq6gA8DkBjmPIUjuLboB36ibviwQ==
X-Received: by 2002:a05:6402:43c4:b0:43b:c5eb:c9dd with SMTP id p4-20020a05640243c400b0043bc5ebc9ddmr6558864edc.402.1662634046526;
        Thu, 08 Sep 2022 03:47:26 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:356c:c343:d4c9:ada? ([2a04:241e:502:a09c:356c:c343:d4c9:ada])
        by smtp.gmail.com with ESMTPSA id f8-20020a17090631c800b0073923a68974sm1058602ejf.206.2022.09.08.03.47.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Sep 2022 03:47:25 -0700 (PDT)
Message-ID: <589e17df-e321-c8ad-5360-e286c10cb1a3@gmail.com>
Date:   Thu, 8 Sep 2022 13:47:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 01/26] tcp: authopt: Initial support and key management
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     Francesco Ruggeri <fruggeri@arista.com>,
        Salam Noureddine <noureddine@arista.com>,
        Philip Paeps <philip@trouble.is>,
        Shuah Khan <shuah@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Caowangbao <caowangbao@huawei.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Safonov <0x7f454c46@gmail.com>
References: <cover.1662361354.git.cdleonard@gmail.com>
 <0e4c0a98509b907e33c2f80b95cc6cfe713ac2b2.1662361354.git.cdleonard@gmail.com>
 <9bb98d13313d2ebeb5804d67285e8e6320ce4e74.camel@redhat.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <9bb98d13313d2ebeb5804d67285e8e6320ce4e74.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/22 09:35, Paolo Abeni wrote:
> On Mon, 2022-09-05 at 10:05 +0300, Leonard Crestez wrote:
> [...]
>> diff --git a/net/ipv4/tcp_authopt.c b/net/ipv4/tcp_authopt.c
>> new file mode 100644
>> index 000000000000..d38e9c89c89d
>> --- /dev/null
>> +++ b/net/ipv4/tcp_authopt.c
>> @@ -0,0 +1,317 @@
>> +// SPDX-License-Identifier: GPL-2.0-or-later
>> +
>> +#include <net/tcp_authopt.h>
>> +#include <net/ipv6.h>
>> +#include <net/tcp.h>
>> +#include <linux/kref.h>
>> +
>> +/* This is enabled when first struct tcp_authopt_info is allocated and never released */
>> +DEFINE_STATIC_KEY_FALSE(tcp_authopt_needed_key);
>> +EXPORT_SYMBOL(tcp_authopt_needed_key);
>> +
>> +static inline struct netns_tcp_authopt *sock_net_tcp_authopt(const struct sock *sk)
>> +{
>> +	return &sock_net(sk)->tcp_authopt;
>> +}
> 
> Please have a look at PW report for this series, there are a bunch of
> issues to be addressed, e.g. above 'static inline' should be just
> 'static'

What is a "PW report"? I can't find any info about this.

>> +static void tcp_authopt_key_release_kref(struct kref *ref)
>> +{
>> +	struct tcp_authopt_key_info *key = container_of(ref, struct tcp_authopt_key_info, ref);
>> +
>> +	kfree_rcu(key, rcu);
>> +}
>> +
>> +static void tcp_authopt_key_put(struct tcp_authopt_key_info *key)
>> +{
>> +	if (key)
>> +		kref_put(&key->ref, tcp_authopt_key_release_kref);
>> +}
>> +
>> +static void tcp_authopt_key_del(struct netns_tcp_authopt *net,
>> +				struct tcp_authopt_key_info *key)
>> +{
>> +	lockdep_assert_held(&net->mutex);
>> +	hlist_del_rcu(&key->node);
>> +	key->flags |= TCP_AUTHOPT_KEY_DEL;
>> +	kref_put(&key->ref, tcp_authopt_key_release_kref);
>> +}
>> +
>> +/* Free info and keys.
>> + * Don't touch tp->authopt_info, it might not even be assigned yes.
>> + */
>> +void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info)
> 
> this need to be 'static'.

Tried this and it's later called from tcp_twsk_destructor.

> I'm sorry to bring the next topic this late (If already discussed, I
> missed that point), is possible to split this series in smaller chunks?

It's already 26 patches and 3675 added lines, less that 150 lines per 
patch seems reasonable?

The split is already somewhat artificial, for example there are patches 
that "add crypto" without actually using it because then it would be too 
large.

Some features could be dropped for later in order to make this smaller, 
for example TCP_REPAIR doesn't have many usecases. Features like 
prefixlen, vrf binding and ipv4-mapped-ipv6 were explicitly requested by 
maintainers so I included them as separate patches in the main series.

--
Regards,
Leonard
