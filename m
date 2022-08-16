Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AAC259656C
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 00:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238015AbiHPWUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 18:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238157AbiHPWUH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 18:20:07 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5552E844EF
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:20:01 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id w18so4239382qki.8
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 15:20:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=GX10KIK3PClAuk0BJNvxigweJcKxCwewxZxDKlVkbCc=;
        b=VNCe2lLOkjUZvihcF4q0MNx/ZdkDJ/7Om14E6xhv2A7uEvq5Ymw0hhtZmkPFMNvHjj
         uUd/stUfkKJh0JJSEL1uDCqctG7Szgd/4k8xX36dhBeHM1sm+kXnvRJQ+0eEdznibwW8
         CioX2XWepIvMwiKmE8Km3DzWc91cfJ5k4FVympNg038bBCC9oIvOV3knu2vN7rsnYef2
         lSYgyDqysQoLW4mhgGP+JsPNjZaGmgk+SEy1aHKXvHqK122179evmsIpf1JN0hKhuidj
         NigDegdjvRpMrnxqMKPSs3jxQXZJ0j99a/RqXGiY5mg79czPAcmk7SjLpAsqKt5RsZSa
         2ZYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=GX10KIK3PClAuk0BJNvxigweJcKxCwewxZxDKlVkbCc=;
        b=Y0lbQ8uRNWS2A0QOkVvyy7IwKEvBy0FbFjGNFJyl0xniiuQEuqmR+pdB61L1h2qzDa
         KDnpElPrSvW2fugaaGm9tIocUxF7YoT42y9ayDyAaDhBJMmWQRNDrClfBBfYV/yPAsBC
         zcuUrTHSOFLxXRIaOR9qw8SGX6MLQ5QapaFbeQH8Dmy9wLZEhIgbfan+vi5Z1lXOKYFc
         ilcsL5zfCcF6BkuW7+pa+HgMfXGzoHSHSKBG+TXMauKDXUSG0iG+NI//5BmzbdS1c9sX
         bvesJ/4J9xK+sP1i6sgALrVTNBgUwA9Vk7slK0s3GQk8ynwbTqGeiPciZ3GRciEiLdHc
         xbrQ==
X-Gm-Message-State: ACgBeo2zB/W0IV9lEJR4+K11B2eQ4WTDAIhD3J3ZHyDq+lkKGeIcUZNz
        j8Qap1eD58LzQSsv5nJ9A/GVlv1ry8jOU8PheEEE9udanC5gNurxPqbyB7t//kNDgp/i28QyYFz
        XWf+aEnY7fFRFYya9bSsp6rZdAZzFvVQ=
X-Google-Smtp-Source: AA6agR6pwNBNlLbpnbC6ysP6mKVkm8i+GAFt/E0Cc7eDlGdUDXxQRopmWsbcWFX+7c6Sb5Ng1h2bxFV9xvhJm9mzHoQ=
X-Received: by 2002:a37:63cf:0:b0:6bb:4b92:e19c with SMTP id
 x198-20020a3763cf000000b006bb4b92e19cmr6358911qkb.358.1660688399976; Tue, 16
 Aug 2022 15:19:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220721204404.388396-1-weiwan@google.com> <ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org>
 <CADVnQymVXMamTRP-eSKhwq1M612zx0ZoNd=rs4MtipJNGm5Wcw@mail.gmail.com>
 <e318ba59-d58a-5826-82c9-6cfc2409cbd4@kernel.org> <f3301080-78c6-a65a-d8b1-59b759a077a4@kernel.org>
 <CADVnQykRMcumBjxND9E4nSxqA-s3exR3AzJ6+Nf0g+s5H6dqeQ@mail.gmail.com> <21869cb9-d1af-066a-ba73-b01af60d9d3a@kernel.org>
In-Reply-To: <21869cb9-d1af-066a-ba73-b01af60d9d3a@kernel.org>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Tue, 16 Aug 2022 18:19:43 -0400
Message-ID: <CADVnQy=AnJY9NZ3w_xNghEG80-DhsXL0r_vEtkr=dmz0ugcoVw@mail.gmail.com>
Subject: Re: python-eventlet test broken in 5.19 [was: Revert "tcp: change
 pingpong threshold to 3"]
To:     Jiri Slaby <jirislaby@kernel.org>
Cc:     Wei Wang <weiwan@google.com>, David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        LemmyHuang <hlm3280@163.com>, stable <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        temotor@gmail.com, jakub@stasiak.at
Content-Type: text/plain; charset="UTF-8"
X-ccpol: medium
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 16, 2022 at 1:48 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> Cc eventlet guys + Linus.
>
> On 15. 08. 22, 15:30, Neal Cardwell wrote:
> > On Mon, Aug 15, 2022 at 3:48 AM Jiri Slaby <jirislaby@kernel.org> wrote:
> >>
> >> On 06. 08. 22, 16:41, Jiri Slaby wrote:
> >>> On 06. 08. 22, 13:24, Neal Cardwell wrote:
> >>>> On Sat, Aug 6, 2022 at 6:02 AM Jiri Slaby <jirislaby@kernel.org> wrote:
> >>>>>
> >>>>> On 21. 07. 22, 22:44, Wei Wang wrote:
> >>>>>> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> >>>>>>
> >>>>>> This to-be-reverted commit was meant to apply a stricter rule for the
> >>>>>> stack to enter pingpong mode. However, the condition used to check for
> >>>>>> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> >>>>>> jiffy based and might be too coarse, which delays the stack entering
> >>>>>> pingpong mode.
> >>>>>> We revert this patch so that we no longer use the above condition to
> >>>>>> determine interactive session, and also reduce pingpong threshold to 1.
> >>>>>>
> >>>>>> Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
> >>>>>> Reported-by: LemmyHuang <hlm3280@163.com>
> >>>>>> Suggested-by: Neal Cardwell <ncardwell@google.com>
> >>>>>> Signed-off-by: Wei Wang <weiwan@google.com>
> >>>>>
> >>>>>
> >>>>> This breaks python-eventlet [1] (and was backported to stable trees):
> >>>>> ________________ TestHttpd.test_018b_http_10_keepalive_framing
> >>>>> _________________
> >>>>>
> >>>>> self = <tests.wsgi_test.TestHttpd
> >>>>> testMethod=test_018b_http_10_keepalive_framing>
> >>>>>
> >>>>>        def test_018b_http_10_keepalive_framing(self):
> >>>>>            # verify that if an http/1.0 client sends connection:
> >>>>> keep-alive
> >>>>>            # that we don't mangle the request framing if the app doesn't
> >>>>> read the request
> >>>>>            def app(environ, start_response):
> >>>>>                resp_body = {
> >>>>>                    '/1': b'first response',
> >>>>>                    '/2': b'second response',
> >>>>>                    '/3': b'third response',
> >>>>>                }.get(environ['PATH_INFO'])
> >>>>>                if resp_body is None:
> >>>>>                    resp_body = 'Unexpected path: ' + environ['PATH_INFO']
> >>>>>                    if six.PY3:
> >>>>>                        resp_body = resp_body.encode('latin1')
> >>>>>                # Never look at wsgi.input!
> >>>>>                start_response('200 OK', [('Content-type', 'text/plain')])
> >>>>>                return [resp_body]
> >>>>>
> >>>>>            self.site.application = app
> >>>>>            sock = eventlet.connect(self.server_addr)
> >>>>>            req_body = b'GET /tricksy HTTP/1.1\r\n'
> >>>>>            body_len = str(len(req_body)).encode('ascii')
> >>>>>
> >>>>>            sock.sendall(b'PUT /1 HTTP/1.0\r\nHost:
> >>>>> localhost\r\nConnection: keep-alive\r\n'
> >>>>>                         b'Content-Length: ' + body_len + b'\r\n\r\n' +
> >>>>> req_body)
> >>>>>            result1 = read_http(sock)
> >>>>>            self.assertEqual(b'first response', result1.body)
> >>>>>            self.assertEqual(result1.headers_original.get('Connection'),
> >>>>> 'keep-alive')
> >>>>>
> >>>>>            sock.sendall(b'PUT /2 HTTP/1.0\r\nHost:
> >>>>> localhost\r\nConnection: keep-alive\r\n'
> >>>>>                         b'Content-Length: ' + body_len + b'\r\nExpect:
> >>>>> 100-continue\r\n\r\n')
> >>>>>            # Client may have a short timeout waiting on that 100 Continue
> >>>>>            # and basically immediately send its body
> >>>>>            sock.sendall(req_body)
> >>>>>            result2 = read_http(sock)
> >>>>>            self.assertEqual(b'second response', result2.body)
> >>>>>            self.assertEqual(result2.headers_original.get('Connection'),
> >>>>> 'close')
> >>>>>
> >>>>>    >       sock.sendall(b'PUT /3 HTTP/1.0\r\nHost:
> >>>>> localhost\r\nConnection: close\r\n\r\n')
> >>>>>
> >>>>> tests/wsgi_test.py:648:
> >>>>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
> >>>>> _ _ _ _
> >>>>> eventlet/greenio/base.py:407: in sendall
> >>>>>        tail = self.send(data, flags)
> >>>>> eventlet/greenio/base.py:401: in send
> >>>>>        return self._send_loop(self.fd.send, data, flags)
> >>>>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
> >>>>> _ _ _ _
> >>>>>
> >>>>> self = <eventlet.greenio.base.GreenSocket object at 0x7f5f2f73c9a0>
> >>>>> send_method = <built-in method send of socket object at 0x7f5f2f73d520>
> >>>>> data = b'PUT /3 HTTP/1.0\r\nHost: localhost\r\nConnection:
> >>>>> close\r\n\r\n'
> >>>>> args = (0,), _timeout_exc = timeout('timed out'), eno = 32
> >>>>>
> >>>>>        def _send_loop(self, send_method, data, *args):
> >>>>>            if self.act_non_blocking:
> >>>>>                return send_method(data, *args)
> >>>>>
> >>>>>            _timeout_exc = socket_timeout('timed out')
> >>>>>            while True:
> >>>>>                try:
> >>>>>    >               return send_method(data, *args)
> >>>>> E               BrokenPipeError: [Errno 32] Broken pipe
> >>>>>
> >>>>> eventlet/greenio/base.py:388: BrokenPipeError
> >>>>> ====================
> >>>>>
> >>>>> Reverting this revert on the top of 5.19 solves the issue.
> >>>>>
> >>>>> Any ideas?
> >>>>
> >>>> Interesting. This revert should return the kernel back to the delayed
> >>>> ACK behavior it had for many years before May 2019 and Linux 5.1,
> >>>> which contains the commit it is reverting:
> >>>>
> >>>>     4a41f453bedfd tcp: change pingpong threshold to 3
> >>>>
> >>>> It sounds like perhaps this test you mention has an implicit
> >>>> dependence on the timing of delayed ACKs.
> >>>>
> >>>> A few questions:
> >>>
> >>> Dunno. I am only an openSUSE kernel maintainer and this popped out at
> >>> me. Feel free to dig to eventlet's sources on your own :P.
> >>
> >> Any updates on this or should I send a revert directly?
> >>
> >> The "before() &&" part of the patch makes the difference. That is this diff:
> >> --- a/net/ipv4/tcp_output.c
> >> +++ b/net/ipv4/tcp_output.c
> >> @@ -172,9 +172,17 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
> >>            * and it is a reply for ato after last received packet,
> >>            * increase pingpong count.
> >>            */
> >> -       if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> >> -           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> >> +       pr_info("%s: sk=%p (%llx:%x) now=%u lsndtime=%u lrcvtime=%u
> >> ping=%u\n",
> >> +                       __func__, sk, sk->sk_addrpair, sk->sk_portpair, now,
> >> +                       tp->lsndtime, icsk->icsk_ack.lrcvtime,
> >> +                       inet_csk(sk)->icsk_ack.pingpong);
> >> +       if (//before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> >> +           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato) {
> >>                   inet_csk_inc_pingpong_cnt(sk);
> >> +               pr_info("\tINC ping=%u before=%u\n",
> >> +                               inet_csk(sk)->icsk_ack.pingpong,
> >> +                               before(tp->lsndtime,
> >> icsk->icsk_ack.lrcvtime));
> >> +       }
> >>
> >>           tp->lsndtime = now;
> >>    }
> >>
> >> makes it work again, and outputs this:
> >>
> >>   > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> >> (100007f0100007f:e858b18b) now=4294902140 lsndtime=4294902140
> >> lrcvtime=4294902140 ping=0
> >>   > TCP: tcp_event_data_sent: sk=00000000a4becf82
> >> (100007f0100007f:8bb158e8) now=4294902143 lsndtime=4294902140
> >> lrcvtime=4294902142 ping=0
> >>   > TCP:     INC ping=1 before=1
> >>   > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> >> (100007f0100007f:e858b18b) now=4294902145 lsndtime=4294902140
> >> lrcvtime=4294902144 ping=0
> >>   > TCP:     INC ping=1 before=1
> >>   > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> >> (100007f0100007f:e858b18b) now=4294902147 lsndtime=4294902145
> >> lrcvtime=4294902144 ping=1
> >>   > TCP:     INC ping=2 before=0
> >>
> >> IMO, this "before=0" is the "source" of the problem. But I have no idea
> >> what this means at all...
> >>
> >>   > TCP: tcp_event_data_sent: sk=00000000a4becf82
> >> (100007f0100007f:8bb158e8) now=4294902149 lsndtime=4294902143
> >> lrcvtime=4294902148 ping=1
> >>   > TCP:     INC ping=2 before=1
> >>   > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> >> (100007f0100007f:e858b18b) now=4294902151 lsndtime=4294902147
> >> lrcvtime=4294902150 ping=3
> >>   > TCP:     INC ping=4 before=1
> >>   > TCP: tcp_event_data_sent: sk=00000000c7a417e9
> >> (100007f0100007f:e85ab18b) now=4294902153 lsndtime=4294902153
> >> lrcvtime=4294902153 ping=0
> >>   > TCP: tcp_event_data_sent: sk=000000008681183e
> >> (100007f0100007f:8bb15ae8) now=4294902155 lsndtime=4294902153
> >> lrcvtime=4294902154 ping=0
> >>   > TCP:     INC ping=1 before=1
> >
> > It sounds like this test has a very specific dependence on the buggy
> > delayed ACK timing behavior from the buggy commit
> > 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> >
> > IMHO I don't think we can revert a kernel bug fix based on a test that
> > decided to depend on the exact timing of delayed ACKs during a time
> > when that delayed ACK behavior was buggy. :-)
>
> Unfortunately despite the test is likely bogus (I am unable to say it is
> or not), it does happen and the patch (the revert -- 4d8f24eeedc) breaks
> userspace. I'd say this is exactly the case where we apply "we do not
> break userspace". But I might be wrong as we might not care about silly
> tests.
>
> In anyway, openSUSE has to have the patch (the revert) reverted, so that
> the distro actually builds/works. (Until this is fixed on the eventlet
> side at least. And more importantly _until_ it propagates to distros or
> is fixed otherwise (like disabling the test).) And I suppose other
> distros would have to do the same. That is quite unfortunate :/.
>
> thanks,
> --
> js
> suse labs

Thanks, Jiri.

Here are some notes from an analysis of this test and its interaction
with the kernel, along with a suggested next step:

A summary:
-------------------

The python test:

  https://github.com/eventlet/eventlet/blob/890f320bbb56f915f128e5ed914be5e2a34b26d9/tests/wsgi_test.py

is a test of a python networking library:

  https://github.com/eventlet/eventlet

This user-space test has a race, and the change in the timing of TCP
ACK packets in v5.19 has uncovered this race and caused the test to
fail. But the change in the timing of the ACK is valid, and restores
ACK behavior that was in the kernel for a long time: at least between
the beginning of kernel git history in 2005 and 4d8f24eeedc5 (Revert
"tcp: change pingpong threshold to 3") in v5.1 in May 2019.

Slightly more details: The race in the test causes the pass/fail
outcome of the test to depend on the exact timing of TCP ACKs. The ACK
of the PUT /2 being delayed several hundred microseconds (delayed ACK
behavior for kernel v5.19 and kernels up through v5.0), in combination
with the client's Nagle behavior, delays the sending of the client PUT
/2 payload data, causing the payload data to be unread in the socket
when the server closes the connection in this test case, causing the
server to send a RST sooner than the client code is expecting (after
the PUT /2 payload data rather than after the PUT /3 request). This
causes the test to receive an unexpected "BrokenPipeError: [Errno 32]
Broken pipe" exception here, in line 648:

https://github.com/eventlet/eventlet/blob/890f320bbb56f915f128e5ed914be5e2a34b26d9/tests/wsgi_test.py#L648

IMHO the best solution here is to tweak the test code so that it does
not race and depend on the exact timing of TCP ACKs. One possible way
to achieve this would be to have the client TCP connection use
setsockopt(TCP_NODELAY) so that the body for the PUT /2 request is
transmitted immediately, whether or not the server delays the ACK of
the PUT /2 headers.

Detailed analysis:
-------------------

The client has apparently left the default Nagle algorithm behavior
enabled (did not use setsockopt(TCP_NODELAY), and so allows at most
one sub-MSS packet outstanding/un-ACKed, and so is sensitive to
delayed ACK behavior.

(1) With the behavior from 4a41f453bedf ("tcp: change pingpong
threshold to 3") in kernel 5.1 to 5.18 (passing test):

- The ACK of 'PUT /2' is immediate, so the "GET /tricksy" (HTTP
  content payload for the PUT /2") goes out quickly.

- Because the 'GET /tricksy' goes out quickly, the server probably
  reads it out of its receive buffer while reading the PUT itself.

- So when the server process closes the socket there is no data in the
  receive buffer, so the server socket does not sent a RST

- By the time the client test code has called sock.sendall(b'PUT
  /3...)  the client socket has received the FIN, and no RST has
  arrived yet, so the client gets the expected ConnectionClosed
  exception

(2) With the 4d8f24eeedc5 (Revert "tcp: change pingpong threshold to
  3") commit and the behavior from kernels up through v5.0 and now
  also 5.19 (failing test):

- ACKs are delayed, so the server's response to the PUT carries the
  ACK that triggers the client to sent the GET /tricksy.

- The server app code triggers the server to close the socket when the
  'GET /tricksy' is still in the server's receive buffer, so when the
  server closes the socket the server connection generates a RST.

- By the time the client test code has called sock.sendall(b'PUT /3')
  the client socket has received the server's FIN *and* the RST, so
  the client gets an unexpected:
         BrokenPipeError: [Errno 32] Broken pipe

tcpdump traces:
---------------

(1) passing test (kernel based on v5.10.31):

19:38:11.443592 IP 127.0.0.1.49786 > 127.0.0.1.39751: Flags [P.], seq
104:206, ack 141, win 512, options [nop,nop,TS val 981850760 ecr
981850760], length 102
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 009a 69c1 4000 4006 d29a 7f00 0001  E...i.@.@.......
        0x0020:  7f00 0001 c27a 9b47 142a 4bcf 389c f6cf  .....z.G.*K.8...
        0x0030:  8018 0200 fe8e 0000 0101 080a 3a85 da88  ............:...
        0x0040:  3a85 da88 5055 5420 2f32 2048 5454 502f  :...PUT./2.HTTP/
        0x0050:  312e 300d 0a48 6f73 743a 206c 6f63 616c  1.0..Host:.local
        0x0060:  686f 7374 0d0a 436f 6e6e 6563 7469 6f6e  host..Connection
        0x0070:  3a20 6b65 6570 2d61 6c69 7665 0d0a 436f  :.keep-alive..Co
        0x0080:  6e74 656e 742d 4c65 6e67 7468 3a20 3233  ntent-Length:.23
        0x0090:  0d0a 4578 7065 6374 3a20 3130 302d 636f  ..Expect:.100-co
        0x00a0:  6e74 696e 7565 0d0a 0d0a                 ntinue....
19:38:11.443597 IP 127.0.0.1.39751 > 127.0.0.1.49786: Flags [.], ack
206, win 512, options [nop,nop,TS val 981850760 ecr 981850760], length
0
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 0034 050f 4000 4006 37b3 7f00 0001  E..4..@.@.7.....
        0x0020:  7f00 0001 9b47 c27a 389c f6cf 142a 4c35  .....G.z8....*L5
        0x0030:  8010 0200 fe28 0000 0101 080a 3a85 da88  .....(......:...
        0x0040:  3a85 da88                                :...
19:38:11.443610 IP 127.0.0.1.49786 > 127.0.0.1.39751: Flags [P.], seq
206:229, ack 141, win 512, options [nop,nop,TS val 981850760 ecr
981850760], length 23
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 004b 69c2 4000 4006 d2e8 7f00 0001  E..Ki.@.@.......
        0x0020:  7f00 0001 c27a 9b47 142a 4c35 389c f6cf  .....z.G.*L58...
        0x0030:  8018 0200 fe3f 0000 0101 080a 3a85 da88  .....?......:...
        0x0040:  3a85 da88 4745 5420 2f74 7269 636b 7379  :...GET./tricksy
        0x0050:  2048 5454 502f 312e 310d 0a              .HTTP/1.1..
19:38:11.443613 IP 127.0.0.1.39751 > 127.0.0.1.49786: Flags [.], ack
229, win 512, options [nop,nop,TS val 981850760 ecr 981850760], length
0
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 0034 0510 4000 4006 37b2 7f00 0001  E..4..@.@.7.....
        0x0020:  7f00 0001 9b47 c27a 389c f6cf 142a 4c4c  .....G.z8....*LL
        0x0030:  8010 0200 fe28 0000 0101 080a 3a85 da88  .....(......:...
        0x0040:  3a85 da88                                :...
19:38:11.443921 IP 127.0.0.1.39751 > 127.0.0.1.49786: Flags [P.], seq
141:277, ack 229, win 512, options [nop,nop,TS val 981850760 ecr
981850760], length 136
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 00bc 0511 4000 4006 3729 7f00 0001  E.....@.@.7)....
        0x0020:  7f00 0001 9b47 c27a 389c f6cf 142a 4c4c  .....G.z8....*LL
        0x0030:  8018 0200 feb0 0000 0101 080a 3a85 da88  ............:...
        0x0040:  3a85 da88 4854 5450 2f31 2e31 2032 3030  :...HTTP/1.1.200
        0x0050:  204f 4b0d 0a43 6f6e 7465 6e74 2d54 7970  .OK..Content-Typ
        0x0060:  653a 2074 6578 742f 706c 6169 6e0d 0a43  e:.text/plain..C
        0x0070:  6f6e 7465 6e74 2d4c 656e 6774 683a 2031  ontent-Length:.1
        0x0080:  350d 0a44 6174 653a 2054 7565 2c20 3136  5..Date:.Tue,.16
        0x0090:  2041 7567 2032 3032 3220 3139 3a33 383a  .Aug.2022.19:38:
        0x00a0:  3131 2047 4d54 0d0a 436f 6e6e 6563 7469  11.GMT..Connecti
        0x00b0:  6f6e 3a20 636c 6f73 650d 0a0d 0a73 6563  on:.close....sec
        0x00c0:  6f6e 6420 7265 7370 6f6e 7365            ond.response
19:38:11.443926 IP 127.0.0.1.49786 > 127.0.0.1.39751: Flags [.], ack
277, win 511, options [nop,nop,TS val 981850760 ecr 981850760], length
0
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 0034 69c3 4000 4006 d2fe 7f00 0001  E..4i.@.@.......
        0x0020:  7f00 0001 c27a 9b47 142a 4c4c 389c f757  .....z.G.*LL8..W
        0x0030:  8010 01ff fe28 0000 0101 080a 3a85 da88  .....(......:...
        0x0040:  3a85 da88                                :...
19:38:11.443990 IP 127.0.0.1.39751 > 127.0.0.1.49786: Flags [F.], seq
277, ack 229, win 512, options [nop,nop,TS val 981850760 ecr
981850760], length 0
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 0034 0512 4000 4006 37b0 7f00 0001  E..4..@.@.7.....
        0x0020:  7f00 0001 9b47 c27a 389c f757 142a 4c4c  .....G.z8..W.*LL
        0x0030:  8011 0200 fe28 0000 0101 080a 3a85 da88  .....(......:...
19:38:11.444132 IP 127.0.0.1.49786 > 127.0.0.1.39751: Flags [P.], seq
229:284, ack 278, win 512, options [nop,nop,TS val 981850760 ecr
981850760], length 55
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 006b 69c4 4000 4006 d2c6 7f00 0001  E..ki.@.@.......
        0x0020:  7f00 0001 c27a 9b47 142a 4c4c 389c f758  .....z.G.*LL8..X
        0x0030:  8018 0200 fe5f 0000 0101 080a 3a85 da88  ....._......:...
        0x0040:  3a85 da88 5055 5420 2f33 2048 5454 502f  :...PUT./3.HTTP/
        0x0050:  312e 300d 0a48 6f73 743a 206c 6f63 616c  1.0..Host:.local
        0x0060:  686f 7374 0d0a 436f 6e6e 6563 7469 6f6e  host..Connection
        0x0070:  3a20 636c 6f73 650d 0a0d 0a              :.close....
19:38:11.444144 IP 127.0.0.1.39751 > 127.0.0.1.49786: Flags [R], seq
949811032, win 0, length 0
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 0028 0000 4000 4006 3cce 7f00 0001  E..(..@.@.<.....
        0x0020:  7f00 0001 9b47 c27a 389c f758 0000 0000  .....G.z8..X....
        0x0030:  5004 0000 2427 0000                      P...$'..


(2) failing test (kernel based on v5.10.31 with a cherry-pick of 4d8f24eeedc5
(Revert "tcp: change pingpong threshold to 3"):

19:13:26.543081 IP 127.0.0.1.33382 > 127.0.0.1.45645: Flags [P.], seq
104:206, ack 141, win 512, options [nop,nop,TS val 1506020510 ecr
1506020510], length 102
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 009a 5f26 4000 4006 dd35 7f00 0001  E..._&@.@..5....
        0x0020:  7f00 0001 8266 b24d 1931 9034 880c 382e  .....f.M.1.4..8.
        0x0030:  8018 0200 fe8e 0000 0101 080a 59c4 0c9e  ............Y...
        0x0040:  59c4 0c9e 5055 5420 2f32 2048 5454 502f  Y...PUT./2.HTTP/
        0x0050:  312e 300d 0a48 6f73 743a 206c 6f63 616c  1.0..Host:.local
        0x0060:  686f 7374 0d0a 436f 6e6e 6563 7469 6f6e  host..Connection
        0x0070:  3a20 6b65 6570 2d61 6c69 7665 0d0a 436f  :.keep-alive..Co
        0x0080:  6e74 656e 742d 4c65 6e67 7468 3a20 3233  ntent-Length:.23
        0x0090:  0d0a 4578 7065 6374 3a20 3130 302d 636f  ..Expect:.100-co
        0x00a0:  6e74 696e 7565 0d0a 0d0a                 ntinue....
19:13:26.543361 IP 127.0.0.1.45645 > 127.0.0.1.33382: Flags [P.], seq
141:277, ack 206, win 512, options [nop,nop,TS val 1506020510 ecr
1506020510], length 136
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 00bc cbe9 4000 4006 7050 7f00 0001  E.....@.@.pP....
        0x0020:  7f00 0001 b24d 8266 880c 382e 1931 909a  .....M.f..8..1..
        0x0030:  8018 0200 feb0 0000 0101 080a 59c4 0c9e  ............Y...
        0x0040:  59c4 0c9e 4854 5450 2f31 2e31 2032 3030  Y...HTTP/1.1.200
        0x0050:  204f 4b0d 0a43 6f6e 7465 6e74 2d54 7970  .OK..Content-Typ
        0x0060:  653a 2074 6578 742f 706c 6169 6e0d 0a43  e:.text/plain..C
        0x0070:  6f6e 7465 6e74 2d4c 656e 6774 683a 2031  ontent-Length:.1
        0x0080:  350d 0a44 6174 653a 2054 7565 2c20 3136  5..Date:.Tue,.16
        0x0090:  2041 7567 2032 3032 3220 3139 3a31 333a  .Aug.2022.19:13:
        0x00a0:  3236 2047 4d54 0d0a 436f 6e6e 6563 7469  26.GMT..Connecti
        0x00b0:  6f6e 3a20 636c 6f73 650d 0a0d 0a73 6563  on:.close....sec
        0x00c0:  6f6e 6420 7265 7370 6f6e 7365            ond.response
19:13:26.543368 IP 127.0.0.1.33382 > 127.0.0.1.45645: Flags [P.], seq
206:229, ack 277, win 511, options [nop,nop,TS val 1506020510 ecr
1506020510], length 23
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 004b 5f27 4000 4006 dd83 7f00 0001  E..K_'@.@.......
        0x0020:  7f00 0001 8266 b24d 1931 909a 880c 38b6  .....f.M.1....8.
        0x0030:  8018 01ff fe3f 0000 0101 080a 59c4 0c9e  .....?......Y...
        0x0040:  59c4 0c9e 4745 5420 2f74 7269 636b 7379  Y...GET./tricksy
        0x0050:  2048 5454 502f 312e 310d 0a              .HTTP/1.1..
19:13:26.543418 IP 127.0.0.1.45645 > 127.0.0.1.33382: Flags [F.], seq
277, ack 229, win 512, options [nop,nop,TS val 1506020510 ecr
1506020510], length 0
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 0034 cbea 4000 4006 70d7 7f00 0001  E..4..@.@.p.....
        0x0020:  7f00 0001 b24d 8266 880c 38b6 1931 90b1  .....M.f..8..1..
        0x0030:  8011 0200 fe28 0000 0101 080a 59c4 0c9e  .....(......Y...
        0x0040:  59c4 0c9e                                Y...
19:13:26.543459 IP 127.0.0.1.45645 > 127.0.0.1.33382: Flags [R.], seq
278, ack 229, win 512, options [nop,nop,TS val 1506020510 ecr
1506020510], length 0
        0x0000:  0000 0304 0006 0000 0000 0000 0000 0800  ................
        0x0010:  4500 0034 cbeb 4000 4006 70d6 7f00 0001  E..4..@.@.p.....
        0x0020:  7f00 0001 b24d 8266 880c 38b7 1931 90b1  .....M.f..8..1..
        0x0030:  8014 0200 fe28 0000 0101 080a 59c4 0c9e  .....(......Y...
        0x0040:  59c4 0c9e                                Y...

best regards,
neal
