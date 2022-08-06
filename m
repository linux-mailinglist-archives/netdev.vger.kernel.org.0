Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD9158B4E9
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 12:02:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241803AbiHFKCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 06:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiHFKCG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 06:02:06 -0400
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BACEFE0DB;
        Sat,  6 Aug 2022 03:02:04 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a7so8851343ejp.2;
        Sat, 06 Aug 2022 03:02:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=n/qDKA5/CHeu0nTihrTcHwo5/QWOSP2MWBgB7e2iqCA=;
        b=M2InmV+ayoTcArh0JK89nVLh1rVh7IAEHlZex/o8h7U1DllZbklukcxEsg3S22Up1A
         FWx4/QoyZ7wZl/bNMwJ/WHMjyUsFT4+p8wp7GvOHTA1CKLxGIxTtnU5M3q4uN1AEMWNH
         jM1sSjefsHVny9h8o4YvpfSQ5fx1xvtKrdiqVIhkRIgMmpvICymH87hVglIrAcgIVqqn
         SwHRfL+AzhD3nxVLtxq6qJq4XS/wQ+7pq+0eIf0kFxXuaJ1SsBKo+fifVgWPxq8tg+DX
         7vtzErOPIujB4uG8+kSm3jQgAQWFStF1xVSLSgvKQLG8me56WwkjukaOP4wadAW7AdmU
         LHBA==
X-Gm-Message-State: ACgBeo3Bbl6FBLuqVsi7XyBRj+oG4N40ngiuWnpWxq7oG9mg0IDuc6LB
        gqQ+/RHPwTLDZz25RCrKFiQ=
X-Google-Smtp-Source: AA6agR4s+LO9WNeVLxvUgJyrkXOBpTNfqKLLjINzBD0HYVBEvw7wJuUROU1auL+mR6XiR9jp+17NZQ==
X-Received: by 2002:a17:907:1b03:b0:6ff:78d4:c140 with SMTP id mp3-20020a1709071b0300b006ff78d4c140mr7870833ejc.554.1659780123202;
        Sat, 06 Aug 2022 03:02:03 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id e3-20020a170906504300b007307e7df83bsm2542776ejk.21.2022.08.06.03.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Aug 2022 03:02:02 -0700 (PDT)
Message-ID: <ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org>
Date:   Sat, 6 Aug 2022 12:02:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net v2] Revert "tcp: change pingpong threshold to 3"
Content-Language: en-US
To:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        LemmyHuang <hlm3280@163.com>,
        Neal Cardwell <ncardwell@google.com>,
        stable <stable@vger.kernel.org>
References: <20220721204404.388396-1-weiwan@google.com>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220721204404.388396-1-weiwan@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21. 07. 22, 22:44, Wei Wang wrote:
> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> 
> This to-be-reverted commit was meant to apply a stricter rule for the
> stack to enter pingpong mode. However, the condition used to check for
> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> jiffy based and might be too coarse, which delays the stack entering
> pingpong mode.
> We revert this patch so that we no longer use the above condition to
> determine interactive session, and also reduce pingpong threshold to 1.
> 
> Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
> Reported-by: LemmyHuang <hlm3280@163.com>
> Suggested-by: Neal Cardwell <ncardwell@google.com>
> Signed-off-by: Wei Wang <weiwan@google.com>


This breaks python-eventlet [1] (and was backported to stable trees):
________________ TestHttpd.test_018b_http_10_keepalive_framing 
_________________

self = <tests.wsgi_test.TestHttpd 
testMethod=test_018b_http_10_keepalive_framing>

     def test_018b_http_10_keepalive_framing(self):
         # verify that if an http/1.0 client sends connection: keep-alive
         # that we don't mangle the request framing if the app doesn't 
read the request
         def app(environ, start_response):
             resp_body = {
                 '/1': b'first response',
                 '/2': b'second response',
                 '/3': b'third response',
             }.get(environ['PATH_INFO'])
             if resp_body is None:
                 resp_body = 'Unexpected path: ' + environ['PATH_INFO']
                 if six.PY3:
                     resp_body = resp_body.encode('latin1')
             # Never look at wsgi.input!
             start_response('200 OK', [('Content-type', 'text/plain')])
             return [resp_body]

         self.site.application = app
         sock = eventlet.connect(self.server_addr)
         req_body = b'GET /tricksy HTTP/1.1\r\n'
         body_len = str(len(req_body)).encode('ascii')

         sock.sendall(b'PUT /1 HTTP/1.0\r\nHost: 
localhost\r\nConnection: keep-alive\r\n'
                      b'Content-Length: ' + body_len + b'\r\n\r\n' + 
req_body)
         result1 = read_http(sock)
         self.assertEqual(b'first response', result1.body)
         self.assertEqual(result1.headers_original.get('Connection'), 
'keep-alive')

         sock.sendall(b'PUT /2 HTTP/1.0\r\nHost: 
localhost\r\nConnection: keep-alive\r\n'
                      b'Content-Length: ' + body_len + b'\r\nExpect: 
100-continue\r\n\r\n')
         # Client may have a short timeout waiting on that 100 Continue
         # and basically immediately send its body
         sock.sendall(req_body)
         result2 = read_http(sock)
         self.assertEqual(b'second response', result2.body)
         self.assertEqual(result2.headers_original.get('Connection'), 
'close')

 >       sock.sendall(b'PUT /3 HTTP/1.0\r\nHost: 
localhost\r\nConnection: close\r\n\r\n')

tests/wsgi_test.py:648:
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
_ _ _ _
eventlet/greenio/base.py:407: in sendall
     tail = self.send(data, flags)
eventlet/greenio/base.py:401: in send
     return self._send_loop(self.fd.send, data, flags)
_ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ 
_ _ _ _

self = <eventlet.greenio.base.GreenSocket object at 0x7f5f2f73c9a0>
send_method = <built-in method send of socket object at 0x7f5f2f73d520>
data = b'PUT /3 HTTP/1.0\r\nHost: localhost\r\nConnection: close\r\n\r\n'
args = (0,), _timeout_exc = timeout('timed out'), eno = 32

     def _send_loop(self, send_method, data, *args):
         if self.act_non_blocking:
             return send_method(data, *args)

         _timeout_exc = socket_timeout('timed out')
         while True:
             try:
 >               return send_method(data, *args)
E               BrokenPipeError: [Errno 32] Broken pipe

eventlet/greenio/base.py:388: BrokenPipeError
====================

Reverting this revert on the top of 5.19 solves the issue.

Any ideas?

[1] https://github.com/eventlet/eventlet

> ---
> v2: added Fixes tag
> 
> ---
>   include/net/inet_connection_sock.h | 10 +---------
>   net/ipv4/tcp_output.c              | 15 ++++++---------
>   2 files changed, 7 insertions(+), 18 deletions(-)
> 
> diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
> index 85cd695e7fd1..ee88f0f1350f 100644
> --- a/include/net/inet_connection_sock.h
> +++ b/include/net/inet_connection_sock.h
> @@ -321,7 +321,7 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
>   
>   struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
>   
> -#define TCP_PINGPONG_THRESH	3
> +#define TCP_PINGPONG_THRESH	1
>   
>   static inline void inet_csk_enter_pingpong_mode(struct sock *sk)
>   {
> @@ -338,14 +338,6 @@ static inline bool inet_csk_in_pingpong_mode(struct sock *sk)
>   	return inet_csk(sk)->icsk_ack.pingpong >= TCP_PINGPONG_THRESH;
>   }
>   
> -static inline void inet_csk_inc_pingpong_cnt(struct sock *sk)
> -{
> -	struct inet_connection_sock *icsk = inet_csk(sk);
> -
> -	if (icsk->icsk_ack.pingpong < U8_MAX)
> -		icsk->icsk_ack.pingpong++;
> -}
> -
>   static inline bool inet_csk_has_ulp(struct sock *sk)
>   {
>   	return inet_sk(sk)->is_icsk && !!inet_csk(sk)->icsk_ulp_ops;
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index c38e07b50639..d06e72e141ac 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -167,16 +167,13 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
>   	if (tcp_packets_in_flight(tp) == 0)
>   		tcp_ca_event(sk, CA_EVENT_TX_START);
>   
> -	/* If this is the first data packet sent in response to the
> -	 * previous received data,
> -	 * and it is a reply for ato after last received packet,
> -	 * increase pingpong count.
> -	 */
> -	if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> -	    (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> -		inet_csk_inc_pingpong_cnt(sk);
> -
>   	tp->lsndtime = now;
> +
> +	/* If it is a reply for ato after last received
> +	 * packet, enter pingpong mode.
> +	 */
> +	if ((u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> +		inet_csk_enter_pingpong_mode(sk);
>   }
>   
>   /* Account for an ACK we sent. */

thanks,
-- 
js
suse labs
