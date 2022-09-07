Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996F15B09F7
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiIGQTQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:19:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiIGQTL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:19:11 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4735A3D1E;
        Wed,  7 Sep 2022 09:19:05 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b16so20520229edd.4;
        Wed, 07 Sep 2022 09:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=hQ9th6n5lq83vAo1UjW41EiQHnnZngjeZzxW+Zvqg/o=;
        b=lOFrVGRN6hHWcfmqLPAWd10+9jgWInlDzjGvPwt/sUpt/HepcEOMsaFdXsILE9OXIN
         +UQlSJuCNc6HDjnWHhH1PbpnAF4cCs5xxM+HsRoSLKlQhEstEbAgwkFye7z/R+bdp0Hg
         4PJ8hFSSEFVVpuvrFzKTaYhhQprBf1CZNkKsr3tS4srGrAdBEOAaZFthBbPTsAY9mTbI
         bGfrfdwtMpKE1gjzQvWPLlNP5arKF3RqkGu565p4i9ZAs2XSyQCYa2B4Z5FAsUHPAnKq
         t0W691Y16jVevXElPy4MXVgZDOAJUk88GOJJ5xbqillb8ykkoMKYgmiOvJUIg5Q9HhNv
         ViUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hQ9th6n5lq83vAo1UjW41EiQHnnZngjeZzxW+Zvqg/o=;
        b=lofdGBAwLi4q2uIdcfD5rnrym4KghRMFlKHzG7CUgk+kQF2tXCQ7edBnuvDEHhKnm2
         tSXNAPOtojTBLc41RSC/W38cXkZv9GkAxUvoUVCeRJMp5ju1s7qOm+ZGfRUUHdfNiORi
         jcUPXB4CYgZVuEtVRg05sMI8dztBH3IhpDKqrlwCejJzAoKwB06mvLy3KZ344hFLzRS0
         DVH2fMtIeLN/QpWGXwOQ2kbg9gpxpGiVWoc4MZevYA6Xzt2zDp/JcOsVREvMxFBZVYcv
         b4fxevVDag1G5iadtVgEITRJ3sdZPM3e1L4QXKSHQWX275M6/dihhMPH3YBt/vipn2l7
         N+sA==
X-Gm-Message-State: ACgBeo2LvquUGTEhDRgOHoElLClqhYCcCjWuvwms3iVZU2oZ+GEBctuz
        kriJ9OvaNfHR7U8dpeQL2NE=
X-Google-Smtp-Source: AA6agR7JpUzIepk/dw+bCY0I5AOVf7pDgVVPlHrmFMnGg0awKBNETT2LrCH7R54WapWd4v+lKJNiFQ==
X-Received: by 2002:aa7:da4f:0:b0:44e:864b:7a3e with SMTP id w15-20020aa7da4f000000b0044e864b7a3emr3816915eds.378.1662567543518;
        Wed, 07 Sep 2022 09:19:03 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:3df:1c49:9ca5:8ba3? ([2a04:241e:502:a09c:3df:1c49:9ca5:8ba3])
        by smtp.gmail.com with ESMTPSA id b23-20020a170906039700b00715a02874acsm8631877eja.35.2022.09.07.09.19.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Sep 2022 09:19:02 -0700 (PDT)
Message-ID: <4a47b4ea-750c-a569-5754-4aa0cd5218fc@gmail.com>
Date:   Wed, 7 Sep 2022 19:19:00 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v8 01/26] tcp: authopt: Initial support and key management
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
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
        Priyaranjan Jha <priyarjha@google.com>,
        netdev <netdev@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <cover.1662361354.git.cdleonard@gmail.com>
 <0e4c0a98509b907e33c2f80b95cc6cfe713ac2b2.1662361354.git.cdleonard@gmail.com>
 <CANn89i+a0mMUMhUhTPoshifNzzuR_gfThPKptB8cuBiw6Bs5jw@mail.gmail.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <CANn89i+a0mMUMhUhTPoshifNzzuR_gfThPKptB8cuBiw6Bs5jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/22 01:57, Eric Dumazet wrote:
> On Mon, Sep 5, 2022 at 12:06 AM Leonard Crestez <cdleonard@gmail.com> wrote:
>>
>> This commit adds support to add and remove keys but does not use them
>> further.
>>
>> Similar to tcp md5 a single pointer to a struct tcp_authopt_info* struct
>> is added to struct tcp_sock, this avoids increasing memory usage. The
>> data structures related to tcp_authopt are initialized on setsockopt and
>> only freed on socket close.
>>
> 
> Thanks Leonard.
> 
> Small points from my side, please find them attached.

...

>> +/* Free info and keys.
>> + * Don't touch tp->authopt_info, it might not even be assigned yes.
>> + */
>> +void tcp_authopt_free(struct sock *sk, struct tcp_authopt_info *info)
>> +{
>> +       kfree_rcu(info, rcu);
>> +}
>> +
>> +/* Free everything and clear tcp_sock.authopt_info to NULL */
>> +void tcp_authopt_clear(struct sock *sk)
>> +{
>> +       struct tcp_authopt_info *info;
>> +
>> +       info = rcu_dereference_protected(tcp_sk(sk)->authopt_info, lockdep_sock_is_held(sk));
>> +       if (info) {
>> +               tcp_authopt_free(sk, info);
>> +               tcp_sk(sk)->authopt_info = NULL;
> 
> RCU rules at deletion mandate that the pointer must be cleared before
> the call_rcu()/kfree_rcu() call.
> 
> It is possible that current MD5 code has an issue here, let's not copy/paste it.

OK. Is there a need for some special form of assignment or is current 
plain form enough?

> 
>> +       }
>> +}
>> +
>> +/* checks that ipv4 or ipv6 addr matches. */
>> +static bool ipvx_addr_match(struct sockaddr_storage *a1,
>> +                           struct sockaddr_storage *a2)
>> +{
>> +       if (a1->ss_family != a2->ss_family)
>> +               return false;
>> +       if (a1->ss_family == AF_INET &&
>> +           (((struct sockaddr_in *)a1)->sin_addr.s_addr !=
>> +            ((struct sockaddr_in *)a2)->sin_addr.s_addr))
>> +               return false;
>> +       if (a1->ss_family == AF_INET6 &&
>> +           !ipv6_addr_equal(&((struct sockaddr_in6 *)a1)->sin6_addr,
>> +                            &((struct sockaddr_in6 *)a2)->sin6_addr))
>> +               return false;
>> +       return true;
>> +}
> 
> Always surprising to see this kind of generic helper being added in a patch.

I remember looking for an equivalent and not finding it. Many places 
have distinct code paths for ipv4 and ipv6 and my use of 
"sockaddr_storage" as ipv4/ipv6 union is uncommon.

It also wastes some memory.

>> +int tcp_get_authopt_val(struct sock *sk, struct tcp_authopt *opt)
>> +{
>> +       struct tcp_sock *tp = tcp_sk(sk);
>> +       struct tcp_authopt_info *info;
>> +
>> +       memset(opt, 0, sizeof(*opt));
>> +       sock_owned_by_me(sk);
>> +
>> +       info = rcu_dereference_check(tp->authopt_info, lockdep_sock_is_held(sk));
> 
> Probably not a big deal, but it seems the prior sock_owned_by_me()
> might be redundant.

The sock_owned_by_me call checks checks lockdep_sock_is_held

The rcu_dereference_check call checks lockdep_sock_is_held || 
rcu_read_lock_held()

This is a getsockopt so caller ensures socket locking but 
rcu_read_lock_held() == 0.

The sock_owned_by_me is indeed redundant because it seems very unlikely 
the sockopt calling conditions will be changes. It was mostly there to 
clarify for myself because I had probably at one time with locking 
warnings. I guess they can be removed.

>> +int tcp_set_authopt_key(struct sock *sk, sockptr_t optval, unsigned int optlen)
>> +{
>> +       struct tcp_authopt_key opt;
>> +       struct tcp_authopt_info *info;
>> +       struct tcp_authopt_key_info *key_info, *old_key_info;
>> +       struct netns_tcp_authopt *net = sock_net_tcp_authopt(sk);
>> +       int err;
>> +
>> +       sock_owned_by_me(sk);
>> +       if (!ns_capable(sock_net(sk)->user_ns, CAP_NET_ADMIN))
>> +               return -EPERM;
>> +
>> +       err = _copy_from_sockptr_tolerant((u8 *)&opt, sizeof(opt), optval, optlen);
>> +       if (err)
>> +               return err;
>> +
>> +       if (opt.flags & ~TCP_AUTHOPT_KEY_KNOWN_FLAGS)
>> +               return -EINVAL;
>> +
>> +       if (opt.keylen > TCP_AUTHOPT_MAXKEYLEN)
>> +               return -EINVAL;
>> +
>> +       /* Delete is a special case: */
>> +       if (opt.flags & TCP_AUTHOPT_KEY_DEL) {
>> +               mutex_lock(&net->mutex);
>> +               key_info = tcp_authopt_key_lookup_exact(sk, net, &opt);
>> +               if (key_info) {
>> +                       tcp_authopt_key_del(net, key_info);
>> +                       err = 0;
>> +               } else {
>> +                       err = -ENOENT;
>> +               }
>> +               mutex_unlock(&net->mutex);
>> +               return err;
>> +       }
>> +
>> +       /* check key family */
>> +       if (opt.flags & TCP_AUTHOPT_KEY_ADDR_BIND) {
>> +               if (sk->sk_family != opt.addr.ss_family)
>> +                       return -EINVAL;
>> +       }
>> +
>> +       /* Initialize tcp_authopt_info if not already set */
>> +       info = __tcp_authopt_info_get_or_create(sk);
>> +       if (IS_ERR(info))
>> +               return PTR_ERR(info);
>> +
>> +       key_info = kmalloc(sizeof(*key_info), GFP_KERNEL | __GFP_ZERO);
> 
> kzalloc() ?

Yes

>> +static int tcp_authopt_init_net(struct net *full_net)
> 
> Hmmm... our convention is to use "struct net *net"
> 
>> +{
>> +       struct netns_tcp_authopt *net = &full_net->tcp_authopt;
> 
> Here, you should use a different name ...

OK, will replace with net_ao

>> @@ -2267,10 +2268,11 @@ void tcp_v4_destroy_sock(struct sock *sk)
>>                  tcp_clear_md5_list(sk);
>>                  kfree_rcu(rcu_dereference_protected(tp->md5sig_info, 1), rcu);
>>                  tp->md5sig_info = NULL;
>>          }
>>   #endif
>> +       tcp_authopt_clear(sk);
> 
> Do we really own the socket lock at this point ?

Not sure how I would tell but there is a lockdep_sock_is_held check 
inside tcp_authopt_clear. I also added sock_owned_by_me and there were 
no warnings.
