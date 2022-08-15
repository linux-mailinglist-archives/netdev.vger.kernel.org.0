Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD5B259413C
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 23:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242255AbiHOVSl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 17:18:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241935AbiHOVNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 17:13:52 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEACDABB7
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 12:19:51 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id b7so6043917qvq.2
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 12:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=R1uDU/c6zIL3G9hby8nKxESi8ZLmJkpQHtE/bPRNTYo=;
        b=mvs6fLPX6IO6K1a4A5Wic6bKJGW6PNpMa7u5YQhZynyz18/r3c9pbpbdMYoil2Yxys
         44xXKoea6xWrIjKTL7Ny2po0R/eukU+zAoeJCDsDkPqHYxLzDMkBxFQecdlBii4didCv
         pnfoUxcqrXfxmTKon8203VYEBiQ5LPDAWq5YsNId5y6kLz7cP2cQXdNMj7ZWIT48yikS
         1gCrVGQYhPDAXz1sYcdrF1i+qQNwtt7RJoXrIZkfOGN09k3fLnL9nkJVgTD46euaorFl
         muRH/FFBQ/w5KjDTbzyUiwdpbOLgXQ61JcrevTRdTiU2MySU34Jp7lzYqLP8hgzSe/H1
         3NXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=R1uDU/c6zIL3G9hby8nKxESi8ZLmJkpQHtE/bPRNTYo=;
        b=DuHHftXtv0/rSUn1eN4Oy9xbQrh3BuRgkPfIvSSVoIFvnSjjh51vVqEP3twEDDUXk1
         hR2W528/c9Wsq6/V7x3IY+IXhZA+hieL/U3YQlhmP65fa/U183TfW/uAe/toVhmj/Wse
         kVSK2z3erbXbDcoRg9SqU564hhN/v+S9fTZBv93qlNgn9o5T+R/kR6KoyKfzkwRD8QYq
         6WwZizsHpac47cayS3A4Vj7Nf1RydGUZZe5zFBJt699T4NejOkrbfCzT2Djw5injqoXN
         TVBxmA5OC9BgQHRKf2ccHyKxp8ky/JOWpnyKUVh7v7MkZIA/hHK6TOco8ZBsVgyIWtOg
         eGeg==
X-Gm-Message-State: ACgBeo1ngad/sTDLr56G640+QNpBL1byYa/Il3g0+f5+6WAYnKZTak7+
        EKH/Nk+bQqK+GdC/QsQ41lz8FjooSwsBSGKTXyFYFw==
X-Google-Smtp-Source: AA6agR41ehKoW3wvj95YuO3Moq/HiMtjeaJJ0X77qKlKPOJfUJgFITiQmmE3l2BapN+3089YZLWtsXTDJ2jk2+2iLpE=
X-Received: by 2002:a05:6214:27e4:b0:476:be6a:91c1 with SMTP id
 jt4-20020a05621427e400b00476be6a91c1mr14890709qvb.39.1660591190154; Mon, 15
 Aug 2022 12:19:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220721204404.388396-1-weiwan@google.com> <ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org>
 <CADVnQymVXMamTRP-eSKhwq1M612zx0ZoNd=rs4MtipJNGm5Wcw@mail.gmail.com>
 <e318ba59-d58a-5826-82c9-6cfc2409cbd4@kernel.org> <f3301080-78c6-a65a-d8b1-59b759a077a4@kernel.org>
 <CADVnQykRMcumBjxND9E4nSxqA-s3exR3AzJ6+Nf0g+s5H6dqeQ@mail.gmail.com> <CAEA6p_Aujf5Q=sG56-VfoOvOjPcvwa-Ajw4519hHV+L2hYGrRg@mail.gmail.com>
In-Reply-To: <CAEA6p_Aujf5Q=sG56-VfoOvOjPcvwa-Ajw4519hHV+L2hYGrRg@mail.gmail.com>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Mon, 15 Aug 2022 15:19:33 -0400
Message-ID: <CADVnQynTmkJ7j2RBvZba3UA5gkdVAD3gcrOx998BVv3HXt9=Dw@mail.gmail.com>
Subject: Re: [PATCH net v2] Revert "tcp: change pingpong threshold to 3"
To:     Wei Wang <weiwan@google.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>,
        David Miller <davem@davemloft.net>,
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

=




On Mon, Aug 15, 2022 at 2:54 PM Wei Wang <weiwan@google.com> wrote:
>
> On Mon, Aug 15, 2022 at 6:30 AM Neal Cardwell <ncardwell@google.com> wrote:
> >
> > On Mon, Aug 15, 2022 at 3:48 AM Jiri Slaby <jirislaby@kernel.org> wrote:
> > >
> > > On 06. 08. 22, 16:41, Jiri Slaby wrote:
> > > > On 06. 08. 22, 13:24, Neal Cardwell wrote:
> > > >> On Sat, Aug 6, 2022 at 6:02 AM Jiri Slaby <jirislaby@kernel.org> wrote:
> > > >>>
> > > >>> On 21. 07. 22, 22:44, Wei Wang wrote:
> > > >>>> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> > > >>>>
> > > >>>> This to-be-reverted commit was meant to apply a stricter rule for the
> > > >>>> stack to enter pingpong mode. However, the condition used to check for
> > > >>>> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> > > >>>> jiffy based and might be too coarse, which delays the stack entering
> > > >>>> pingpong mode.
> > > >>>> We revert this patch so that we no longer use the above condition to
> > > >>>> determine interactive session, and also reduce pingpong threshold to 1.
> > > >>>>
> > > >>>> Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
> > > >>>> Reported-by: LemmyHuang <hlm3280@163.com>
> > > >>>> Suggested-by: Neal Cardwell <ncardwell@google.com>
> > > >>>> Signed-off-by: Wei Wang <weiwan@google.com>
> > > >>>
> > > >>>
> > > >>> This breaks python-eventlet [1] (and was backported to stable trees):
> > > >>> ________________ TestHttpd.test_018b_http_10_keepalive_framing
> > > >>> _________________
> > > >>>
> > > >>> self = <tests.wsgi_test.TestHttpd
> > > >>> testMethod=test_018b_http_10_keepalive_framing>
> > > >>>
> > > >>>       def test_018b_http_10_keepalive_framing(self):
> > > >>>           # verify that if an http/1.0 client sends connection:
> > > >>> keep-alive
> > > >>>           # that we don't mangle the request framing if the app doesn't
> > > >>> read the request
> > > >>>           def app(environ, start_response):
> > > >>>               resp_body = {
> > > >>>                   '/1': b'first response',
> > > >>>                   '/2': b'second response',
> > > >>>                   '/3': b'third response',
> > > >>>               }.get(environ['PATH_INFO'])
> > > >>>               if resp_body is None:
> > > >>>                   resp_body = 'Unexpected path: ' + environ['PATH_INFO']
> > > >>>                   if six.PY3:
> > > >>>                       resp_body = resp_body.encode('latin1')
> > > >>>               # Never look at wsgi.input!
> > > >>>               start_response('200 OK', [('Content-type', 'text/plain')])
> > > >>>               return [resp_body]
> > > >>>
> > > >>>           self.site.application = app
> > > >>>           sock = eventlet.connect(self.server_addr)
> > > >>>           req_body = b'GET /tricksy HTTP/1.1\r\n'
> > > >>>           body_len = str(len(req_body)).encode('ascii')
> > > >>>
> > > >>>           sock.sendall(b'PUT /1 HTTP/1.0\r\nHost:
> > > >>> localhost\r\nConnection: keep-alive\r\n'
> > > >>>                        b'Content-Length: ' + body_len + b'\r\n\r\n' +
> > > >>> req_body)
> > > >>>           result1 = read_http(sock)
> > > >>>           self.assertEqual(b'first response', result1.body)
> > > >>>           self.assertEqual(result1.headers_original.get('Connection'),
> > > >>> 'keep-alive')
> > > >>>
> > > >>>           sock.sendall(b'PUT /2 HTTP/1.0\r\nHost:
> > > >>> localhost\r\nConnection: keep-alive\r\n'
> > > >>>                        b'Content-Length: ' + body_len + b'\r\nExpect:
> > > >>> 100-continue\r\n\r\n')
> > > >>>           # Client may have a short timeout waiting on that 100 Continue
> > > >>>           # and basically immediately send its body
> > > >>>           sock.sendall(req_body)
> > > >>>           result2 = read_http(sock)
> > > >>>           self.assertEqual(b'second response', result2.body)
> > > >>>           self.assertEqual(result2.headers_original.get('Connection'),
> > > >>> 'close')
> > > >>>
> > > >>>   >       sock.sendall(b'PUT /3 HTTP/1.0\r\nHost:
> > > >>> localhost\r\nConnection: close\r\n\r\n')
> > > >>>
> > > >>> tests/wsgi_test.py:648:
> > > >>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
> > > >>> _ _ _ _
> > > >>> eventlet/greenio/base.py:407: in sendall
> > > >>>       tail = self.send(data, flags)
> > > >>> eventlet/greenio/base.py:401: in send
> > > >>>       return self._send_loop(self.fd.send, data, flags)
> > > >>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
> > > >>> _ _ _ _
> > > >>>
> > > >>> self = <eventlet.greenio.base.GreenSocket object at 0x7f5f2f73c9a0>
> > > >>> send_method = <built-in method send of socket object at 0x7f5f2f73d520>
> > > >>> data = b'PUT /3 HTTP/1.0\r\nHost: localhost\r\nConnection:
> > > >>> close\r\n\r\n'
> > > >>> args = (0,), _timeout_exc = timeout('timed out'), eno = 32
> > > >>>
> > > >>>       def _send_loop(self, send_method, data, *args):
> > > >>>           if self.act_non_blocking:
> > > >>>               return send_method(data, *args)
> > > >>>
> > > >>>           _timeout_exc = socket_timeout('timed out')
> > > >>>           while True:
> > > >>>               try:
> > > >>>   >               return send_method(data, *args)
> > > >>> E               BrokenPipeError: [Errno 32] Broken pipe
> > > >>>
> > > >>> eventlet/greenio/base.py:388: BrokenPipeError
> > > >>> ====================
> > > >>>
> > > >>> Reverting this revert on the top of 5.19 solves the issue.
> > > >>>
> > > >>> Any ideas?
> > > >>
> > > >> Interesting. This revert should return the kernel back to the delayed
> > > >> ACK behavior it had for many years before May 2019 and Linux 5.1,
> > > >> which contains the commit it is reverting:
> > > >>
> > > >>    4a41f453bedfd tcp: change pingpong threshold to 3
> > > >>
> > > >> It sounds like perhaps this test you mention has an implicit
> > > >> dependence on the timing of delayed ACKs.
> > > >>
> > > >> A few questions:
> > > >
> > > > Dunno. I am only an openSUSE kernel maintainer and this popped out at
> > > > me. Feel free to dig to eventlet's sources on your own :P.
> > >
> > > Any updates on this or should I send a revert directly?
> > >
> > > The "before() &&" part of the patch makes the difference. That is this diff:
> > > --- a/net/ipv4/tcp_output.c
> > > +++ b/net/ipv4/tcp_output.c
> > > @@ -172,9 +172,17 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
> > >           * and it is a reply for ato after last received packet,
> > >           * increase pingpong count.
> > >           */
> > > -       if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> > > -           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> > > +       pr_info("%s: sk=%p (%llx:%x) now=%u lsndtime=%u lrcvtime=%u
> > > ping=%u\n",
> > > +                       __func__, sk, sk->sk_addrpair, sk->sk_portpair, now,
> > > +                       tp->lsndtime, icsk->icsk_ack.lrcvtime,
> > > +                       inet_csk(sk)->icsk_ack.pingpong);
> > > +       if (//before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> > > +           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato) {
> > >                  inet_csk_inc_pingpong_cnt(sk);
> > > +               pr_info("\tINC ping=%u before=%u\n",
> > > +                               inet_csk(sk)->icsk_ack.pingpong,
> > > +                               before(tp->lsndtime,
> > > icsk->icsk_ack.lrcvtime));
> > > +       }
> > >
> > >          tp->lsndtime = now;
> > >   }
> > >
> > > makes it work again, and outputs this:
>
> Is the above patch made on top of my reverted patch? It seems not
> according to this part of diff.
> Then what is the definition of TCP_PINGPONG_THRESH in the working
> case? I think that is the key, regardless of the result of:
>     before(tp->lsndtime, icsk->icsk_ack.lrcvtime)
>
> I tried to look into what exactly the test is doing, and can't tell
> why it is failing. I don't see any check that is based on the timing
> of the reply. :(
> I hope someone could explain more about what this test is doing.

Yes, the test case is a bit hard to read.

I have a conjecture about what might be going wrong: the eventlet
client code connect() method in
https://github.com/eventlet/eventlet/blob/master/eventlet/green/http/client.py
uses:
          self.sock.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
to disable Nagle's algorithm.

However, I don't see anything on the server side in
https://github.com/eventlet/eventlet/blob/master/eventlet/green/http/server.py
disabling Nagle's algorithm.

AFAICT the server code is using TCPServer, so from skimming
  https://github.com/python/cpython/blob/3.10/Lib/socketserver.py
...it seems that the code should probably be setting
disable_nagle_algorithm to True to disable Nagle's algorithm
(disable_nagle_algorithm defaults to False).

If the server code is indeed leaving Nagle's algorithm enabled (the
TCP default), as I suspect here, that's a classic
userspace/application bug, which  means the server performance can be
stalled by waiting for delayed ACKs from the remote side, which means
changes in delayed ACK timing behavior (such as from this kernel
patch) can cause the test to fail.

The appropriate fix is probably to have the eventlet server code use
disable_nagle_algorithm=True.

Just a conjecture. :-)

cheers,
neal
