Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35732592FEC
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 15:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232116AbiHONbF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 09:31:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241337AbiHONa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 09:30:28 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C254DF78
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 06:30:26 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id i24so5463982qkg.13
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 06:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=lM1x63cXtRqyiiLyOzbpK/bo/CGl14dfFlrL0sDct7M=;
        b=bR9ZvjIBGlsDdZzHbqJBiigEHCMuNFfCioFOvZwJG0GdpyGd7pG/WJeoU0y+eVvbrf
         mhoTM4RhUM1zmC9KPYa/zIwUQCGQJINL7dY/ExLlnJM6MfEdemffOTOwsI0ImRnDZZcr
         mFir+CfVjsvIGzJZR53wtLjMASAbzdoXR0J/IKGbeS9t/KTYSJO0JP+sIvKmkFXzrFhB
         PuT202pS4Mah5G8gmORnEpwCvnPu3MzElxxHPneroBOL0+E1ySm7NgpsdEF/SI/q1p+l
         q07hdCZdPjPR7pOuxnUtwK5Qw/eMIrbzZ14QvlrBbTs8VlcCBEB2ZRDdKWIoGFv2kALi
         OPvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=lM1x63cXtRqyiiLyOzbpK/bo/CGl14dfFlrL0sDct7M=;
        b=gya8/uem30hWb3vT91Sfsz+MGLInt6VOf62/pv1h1H8YecOdHpF+19aeM7cWOS0v3L
         a4cFcpwbHPwgsAOGlwZm+KKQ9l9kY0qcRmYLtpr6aVacjMMAIMTdM/3j7+C+oTjrgPPy
         bsjOsif9XUBSO2af3eSuj7gF1EydFzrId3j20gJrdaW5VNNNhG6rhBnjY8D7zU7Uae39
         WcIeHY/ReqFO+yAVzAYpKyy7FvFZ10kPv9SO46Wd8MIbGVJ2dBMHZdT7qwjK4wHwY08v
         wV7jlehqXYEAsSwuX5K8QH3czuy6vw+wIAyeQSQ7BVPKIOwIU8ey37tpujDEiD2Dq03O
         RUKQ==
X-Gm-Message-State: ACgBeo25FL8pkzbCC2cv4vG4Jlve0HhY9AI9FUpf9dR4P7HVdZU8Slol
        tX4TVHtcKsZCXAG7freM15CL3k4NB/UdPZRF0IPZBw==
X-Google-Smtp-Source: AA6agR6bOh+tuAi+2+WncPL3MDp1qLpcS9dP8l9IJYzhkztBVagLuJFnB4eetg8LP5EVcHpBN94r+wObRA/g02rIyWM=
X-Received: by 2002:a05:620a:1a25:b0:6b6:47:aaf4 with SMTP id
 bk37-20020a05620a1a2500b006b60047aaf4mr11134781qkb.296.1660570225503; Mon, 15
 Aug 2022 06:30:25 -0700 (PDT)
MIME-Version: 1.0
References: <20220721204404.388396-1-weiwan@google.com> <ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org>
 <CADVnQymVXMamTRP-eSKhwq1M612zx0ZoNd=rs4MtipJNGm5Wcw@mail.gmail.com>
 <e318ba59-d58a-5826-82c9-6cfc2409cbd4@kernel.org> <f3301080-78c6-a65a-d8b1-59b759a077a4@kernel.org>
In-Reply-To: <f3301080-78c6-a65a-d8b1-59b759a077a4@kernel.org>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 15 Aug 2022 09:30:09 -0400
Message-ID: <CADVnQykRMcumBjxND9E4nSxqA-s3exR3AzJ6+Nf0g+s5H6dqeQ@mail.gmail.com>
Subject: Re: [PATCH net v2] Revert "tcp: change pingpong threshold to 3"
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        LemmyHuang <hlm3280@163.com>, stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 3:48 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> On 06. 08. 22, 16:41, Jiri Slaby wrote:
> > On 06. 08. 22, 13:24, Neal Cardwell wrote:
> >> On Sat, Aug 6, 2022 at 6:02 AM Jiri Slaby <jirislaby@kernel.org> wrote:
> >>>
> >>> On 21. 07. 22, 22:44, Wei Wang wrote:
> >>>> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> >>>>
> >>>> This to-be-reverted commit was meant to apply a stricter rule for the
> >>>> stack to enter pingpong mode. However, the condition used to check for
> >>>> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> >>>> jiffy based and might be too coarse, which delays the stack entering
> >>>> pingpong mode.
> >>>> We revert this patch so that we no longer use the above condition to
> >>>> determine interactive session, and also reduce pingpong threshold to 1.
> >>>>
> >>>> Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
> >>>> Reported-by: LemmyHuang <hlm3280@163.com>
> >>>> Suggested-by: Neal Cardwell <ncardwell@google.com>
> >>>> Signed-off-by: Wei Wang <weiwan@google.com>
> >>>
> >>>
> >>> This breaks python-eventlet [1] (and was backported to stable trees):
> >>> ________________ TestHttpd.test_018b_http_10_keepalive_framing
> >>> _________________
> >>>
> >>> self = <tests.wsgi_test.TestHttpd
> >>> testMethod=test_018b_http_10_keepalive_framing>
> >>>
> >>>       def test_018b_http_10_keepalive_framing(self):
> >>>           # verify that if an http/1.0 client sends connection:
> >>> keep-alive
> >>>           # that we don't mangle the request framing if the app doesn't
> >>> read the request
> >>>           def app(environ, start_response):
> >>>               resp_body = {
> >>>                   '/1': b'first response',
> >>>                   '/2': b'second response',
> >>>                   '/3': b'third response',
> >>>               }.get(environ['PATH_INFO'])
> >>>               if resp_body is None:
> >>>                   resp_body = 'Unexpected path: ' + environ['PATH_INFO']
> >>>                   if six.PY3:
> >>>                       resp_body = resp_body.encode('latin1')
> >>>               # Never look at wsgi.input!
> >>>               start_response('200 OK', [('Content-type', 'text/plain')])
> >>>               return [resp_body]
> >>>
> >>>           self.site.application = app
> >>>           sock = eventlet.connect(self.server_addr)
> >>>           req_body = b'GET /tricksy HTTP/1.1\r\n'
> >>>           body_len = str(len(req_body)).encode('ascii')
> >>>
> >>>           sock.sendall(b'PUT /1 HTTP/1.0\r\nHost:
> >>> localhost\r\nConnection: keep-alive\r\n'
> >>>                        b'Content-Length: ' + body_len + b'\r\n\r\n' +
> >>> req_body)
> >>>           result1 = read_http(sock)
> >>>           self.assertEqual(b'first response', result1.body)
> >>>           self.assertEqual(result1.headers_original.get('Connection'),
> >>> 'keep-alive')
> >>>
> >>>           sock.sendall(b'PUT /2 HTTP/1.0\r\nHost:
> >>> localhost\r\nConnection: keep-alive\r\n'
> >>>                        b'Content-Length: ' + body_len + b'\r\nExpect:
> >>> 100-continue\r\n\r\n')
> >>>           # Client may have a short timeout waiting on that 100 Continue
> >>>           # and basically immediately send its body
> >>>           sock.sendall(req_body)
> >>>           result2 = read_http(sock)
> >>>           self.assertEqual(b'second response', result2.body)
> >>>           self.assertEqual(result2.headers_original.get('Connection'),
> >>> 'close')
> >>>
> >>>   >       sock.sendall(b'PUT /3 HTTP/1.0\r\nHost:
> >>> localhost\r\nConnection: close\r\n\r\n')
> >>>
> >>> tests/wsgi_test.py:648:
> >>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
> >>> _ _ _ _
> >>> eventlet/greenio/base.py:407: in sendall
> >>>       tail = self.send(data, flags)
> >>> eventlet/greenio/base.py:401: in send
> >>>       return self._send_loop(self.fd.send, data, flags)
> >>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
> >>> _ _ _ _
> >>>
> >>> self = <eventlet.greenio.base.GreenSocket object at 0x7f5f2f73c9a0>
> >>> send_method = <built-in method send of socket object at 0x7f5f2f73d520>
> >>> data = b'PUT /3 HTTP/1.0\r\nHost: localhost\r\nConnection:
> >>> close\r\n\r\n'
> >>> args = (0,), _timeout_exc = timeout('timed out'), eno = 32
> >>>
> >>>       def _send_loop(self, send_method, data, *args):
> >>>           if self.act_non_blocking:
> >>>               return send_method(data, *args)
> >>>
> >>>           _timeout_exc = socket_timeout('timed out')
> >>>           while True:
> >>>               try:
> >>>   >               return send_method(data, *args)
> >>> E               BrokenPipeError: [Errno 32] Broken pipe
> >>>
> >>> eventlet/greenio/base.py:388: BrokenPipeError
> >>> ====================
> >>>
> >>> Reverting this revert on the top of 5.19 solves the issue.
> >>>
> >>> Any ideas?
> >>
> >> Interesting. This revert should return the kernel back to the delayed
> >> ACK behavior it had for many years before May 2019 and Linux 5.1,
> >> which contains the commit it is reverting:
> >>
> >>    4a41f453bedfd tcp: change pingpong threshold to 3
> >>
> >> It sounds like perhaps this test you mention has an implicit
> >> dependence on the timing of delayed ACKs.
> >>
> >> A few questions:
> >
> > Dunno. I am only an openSUSE kernel maintainer and this popped out at
> > me. Feel free to dig to eventlet's sources on your own :P.
>
> Any updates on this or should I send a revert directly?
>
> The "before() &&" part of the patch makes the difference. That is this diff:
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -172,9 +172,17 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
>           * and it is a reply for ato after last received packet,
>           * increase pingpong count.
>           */
> -       if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> -           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> +       pr_info("%s: sk=%p (%llx:%x) now=%u lsndtime=%u lrcvtime=%u
> ping=%u\n",
> +                       __func__, sk, sk->sk_addrpair, sk->sk_portpair, now,
> +                       tp->lsndtime, icsk->icsk_ack.lrcvtime,
> +                       inet_csk(sk)->icsk_ack.pingpong);
> +       if (//before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> +           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato) {
>                  inet_csk_inc_pingpong_cnt(sk);
> +               pr_info("\tINC ping=%u before=%u\n",
> +                               inet_csk(sk)->icsk_ack.pingpong,
> +                               before(tp->lsndtime,
> icsk->icsk_ack.lrcvtime));
> +       }
>
>          tp->lsndtime = now;
>   }
>
> makes it work again, and outputs this:
>
>  > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> (100007f0100007f:e858b18b) now=4294902140 lsndtime=4294902140
> lrcvtime=4294902140 ping=0
>  > TCP: tcp_event_data_sent: sk=00000000a4becf82
> (100007f0100007f:8bb158e8) now=4294902143 lsndtime=4294902140
> lrcvtime=4294902142 ping=0
>  > TCP:     INC ping=1 before=1
>  > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> (100007f0100007f:e858b18b) now=4294902145 lsndtime=4294902140
> lrcvtime=4294902144 ping=0
>  > TCP:     INC ping=1 before=1
>  > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> (100007f0100007f:e858b18b) now=4294902147 lsndtime=4294902145
> lrcvtime=4294902144 ping=1
>  > TCP:     INC ping=2 before=0
>
> IMO, this "before=0" is the "source" of the problem. But I have no idea
> what this means at all...
>
>  > TCP: tcp_event_data_sent: sk=00000000a4becf82
> (100007f0100007f:8bb158e8) now=4294902149 lsndtime=4294902143
> lrcvtime=4294902148 ping=1
>  > TCP:     INC ping=2 before=1
>  > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> (100007f0100007f:e858b18b) now=4294902151 lsndtime=4294902147
> lrcvtime=4294902150 ping=3
>  > TCP:     INC ping=4 before=1
>  > TCP: tcp_event_data_sent: sk=00000000c7a417e9
> (100007f0100007f:e85ab18b) now=4294902153 lsndtime=4294902153
> lrcvtime=4294902153 ping=0
>  > TCP: tcp_event_data_sent: sk=000000008681183e
> (100007f0100007f:8bb15ae8) now=4294902155 lsndtime=4294902153
> lrcvtime=4294902154 ping=0
>  > TCP:     INC ping=1 before=1

It sounds like this test has a very specific dependence on the buggy
delayed ACK timing behavior from the buggy commit
4a41f453bedfd5e9cd040bad509d9da49feb3e2c.

IMHO I don't think we can revert a kernel bug fix based on a test that
decided to depend on the exact timing of delayed ACKs during a time
when that delayed ACK behavior was buggy. :-)

best regards,
neal
