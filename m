Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF6556BB7E
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 16:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbiGHOFs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 10:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237856AbiGHOFr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 10:05:47 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E68FC3057E;
        Fri,  8 Jul 2022 07:05:45 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id o25so37916229ejm.3;
        Fri, 08 Jul 2022 07:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cZ1JcOk+cUjBFM0UwNYjGC+6gUqeLmPdNAn2VtbItVs=;
        b=C9j9Jy5kzmcXgNLE/fU11cTma6Idiv4NJsWSRkixHHFIEWnpJIeb1yiiSVW77jpu9h
         hHMji7RRFAPDYKup2J+ulh5R6T6PHcjrIuAj1grORvTjoQXfBxeRPQCJWIAMBKIO/znV
         d3yaeQ6rSUPkLd+k3Cpf94gvuLG46Y3IRys3ux5jHFnx+W1Dr8cpivPi2t8G8VLVciOj
         NIIpxKKDnFRxyK8K8zlkB5ePXZza/1qtywUpNEt2U0hGc8VJQi51rBMC0vOYx3JmPFGj
         CxRKTgEzkxAXr4zTDP0c3jkwRSNm9R6s+pYAKbfr2Z83SMPs7YiilwBszAa6dswIbeLi
         s0Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cZ1JcOk+cUjBFM0UwNYjGC+6gUqeLmPdNAn2VtbItVs=;
        b=ns7vV7BKT+YoVh4vEAR19ZuAPcpLBCWhzKURCz8jFuyfpxTYzTeE+0YxK6XEtFj4sO
         mdee3wQt+xFOaKxMJwB+NYYK26xcO3NYipcuiaXOBVB5jNMVF6c9Hw0XVFxgrc8lZqEA
         hfGyeXj4pSk8j3tX8uI7JHrUlwiqWjGPFcDAvrvzBgUPRcfd/cI/K+C2bdQV76PVvhn0
         DhvP+bS/UnT6ZirxRUVbkgbkIesenNMzaclK46J9IWxg/fDVWLwzjQU5BPB8WRFRmpoo
         0RzAFL2ZfCkt45y4RKgD8SI8c6ukRxxRXBfNDUPRIKPnacVZHENf/4QPlQxK1YAITcgT
         us3w==
X-Gm-Message-State: AJIora+qYJmaRAxemoFhPVk2k8H258/4Q3BVZzsIuH3+3WNd1MLr7bSn
        lokCL9gol5fd1VhYBL8QpTM=
X-Google-Smtp-Source: AGRyM1vBuNxa9hPEoGCyoVYwPo5Hyon2tNuoSUO6lwL0Et0s7AQ72pbHGPRbmfCHOUK/Nfzeao4YuQ==
X-Received: by 2002:a17:907:8a25:b0:726:c9f2:2f5e with SMTP id sc37-20020a1709078a2500b00726c9f22f5emr3792005ejc.286.1657289144375;
        Fri, 08 Jul 2022 07:05:44 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::2eef? ([2620:10d:c092:600::2:676a])
        by smtp.gmail.com with ESMTPSA id l10-20020a1709060cca00b0072b16ea4795sm1845081ejh.48.2022.07.08.07.05.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 07:05:43 -0700 (PDT)
Message-ID: <45cd36ee-ef99-fb67-df8d-218603facfd7@gmail.com>
Date:   Fri, 8 Jul 2022 15:03:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v4 11/27] tcp: support externally provided ubufs
Content-Language: en-US
To:     David Ahern <dsahern@kernel.org>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jens Axboe <axboe@kernel.dk>, kernel-team@fb.com
References: <cover.1657194434.git.asml.silence@gmail.com>
 <7ee05f644e3b3626b693973738364bcb23cf905d.1657194434.git.asml.silence@gmail.com>
 <62e1daba-fb20-bf20-5c4d-c31770e5420e@kernel.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <62e1daba-fb20-bf20-5c4d-c31770e5420e@kernel.org>
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

On 7/8/22 05:06, David Ahern wrote:
> On 7/7/22 5:49 AM, Pavel Begunkov wrote:
>> Teach ipv4/udp how to use external ubuf_info provided in msghdr and
> 
> ipv4/tcp?

Ehh, just tcp. Thanks, I updated the branches


>> also prepare it for managed frags by sprinkling
>> skb_zcopy_downgrade_managed() when it could mix managed and not managed
>> frags.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>   net/ipv4/tcp.c | 32 ++++++++++++++++++++------------
>>   1 file changed, 20 insertions(+), 12 deletions(-)
>>
>> diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> index 390eb3dc53bd..a81f694af5e9 100644
>> --- a/net/ipv4/tcp.c
>> +++ b/net/ipv4/tcp.c
>> @@ -1223,17 +1223,23 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>   
>>   	flags = msg->msg_flags;
>>   
>> -	if (flags & MSG_ZEROCOPY && size && sock_flag(sk, SOCK_ZEROCOPY)) {
>> +	if ((flags & MSG_ZEROCOPY) && size) {
>>   		skb = tcp_write_queue_tail(sk);
>> -		uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
>> -		if (!uarg) {
>> -			err = -ENOBUFS;
>> -			goto out_err;
>> -		}
>>   
>> -		zc = sk->sk_route_caps & NETIF_F_SG;
>> -		if (!zc)
>> -			uarg->zerocopy = 0;
>> +		if (msg->msg_ubuf) {
>> +			uarg = msg->msg_ubuf;
>> +			net_zcopy_get(uarg);
>> +			zc = sk->sk_route_caps & NETIF_F_SG;
>> +		} else if (sock_flag(sk, SOCK_ZEROCOPY)) {
>> +			uarg = msg_zerocopy_realloc(sk, size, skb_zcopy(skb));
>> +			if (!uarg) {
>> +				err = -ENOBUFS;
>> +				goto out_err;
>> +			}
>> +			zc = sk->sk_route_caps & NETIF_F_SG;
>> +			if (!zc)
>> +				uarg->zerocopy = 0;
>> +		}
>>   	}
>>   
>>   	if (unlikely(flags & MSG_FASTOPEN || inet_sk(sk)->defer_connect) &&
>> @@ -1356,9 +1362,11 @@ int tcp_sendmsg_locked(struct sock *sk, struct msghdr *msg, size_t size)
>>   
>>   			copy = min_t(int, copy, pfrag->size - pfrag->offset);
>>   
>> -			if (tcp_downgrade_zcopy_pure(sk, skb))
>> -				goto wait_for_space;
>> -
>> +			if (unlikely(skb_zcopy_pure(skb) || skb_zcopy_managed(skb))) {
>> +				if (tcp_downgrade_zcopy_pure(sk, skb))
>> +					goto wait_for_space;
>> +				skb_zcopy_downgrade_managed(skb);
>> +			}
>>   			copy = tcp_wmem_schedule(sk, copy);
>>   			if (!copy)
>>   				goto wait_for_space;
> 
> You dropped the msg->msg_ubuf checks on jump labels. Removing the one
> you had at 'out_nopush' I agree with based on my tests (i.e, it is not
> needed).

It was an optimisation, which I dropped for simplicity. Will be sending it
and couple more afterwards.


> The one at 'out_err' seems like it is needed - but it has been a few
> weeks since I debugged that case. I believe the error path I was hitting
> was sk_stream_wait_memory with MSG_DONTWAIT flag set meaning timeout is
> 0 and it jumps there with EPIPE.

Currently, it's consistent with MSG_ZEROCOPY ubuf_info, we grab a ubuf_info
reference at the beginning (msg_zerocopy_realloc() for MSG_ZEROCOPY and
net_zcopy_get() for msg_ubuf), and then release it at the end
with net_zcopy_put() or net_zcopy_put_abort().

All users, e.g. skb_zerocopy_iter_stream(), have to grab a new reference,
skb_zcopy_set() -> net_zcopy_get().

Not sure I see any issue, and if there is it sounds that it should also
be affecting MSG_ZEROCOPY.


-- 
Pavel Begunkov
