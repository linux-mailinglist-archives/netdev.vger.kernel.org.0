Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C385E593D58
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 22:40:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345865AbiHOUEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 16:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345870AbiHOUEb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 16:04:31 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E0F7E32F
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 11:54:26 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id s129so8013702vsb.11
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 11:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=7mBW1VnRnQg+wVoMzmV0bRs6QAsod4KqNv+BOcboNnM=;
        b=evf7VbO4zMgQVi+u7Dqkf/8t3hE3jcXAqDwpusmjhGv+lr8ZBL9eP+5e1CJ2iKMQAg
         W/whYLnfF8MYuH3RcR/QgX1sPYS67xf5ST4HHfNJdTRTgdfSeoAxfrCOc9ckEzjo4M/p
         XIt6yHiwgpPGY6R7cXaLq3NK7otrGNb+eTJt9eV3lIDIbIrtl5eSlFPoNow1YuBxHlXb
         1N9WWLlCB3zNHcuYMvbr/UiJ2hsknyDg849kbKJr0M5OYGywO1p0kC7O7N0J7z8z4NEN
         874OZacXLO4ufS5IVhQbymf1wVcSKnhrbJRhLpyVC2C7cIoD4613EveIZ7YHenAEN+mm
         mDMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=7mBW1VnRnQg+wVoMzmV0bRs6QAsod4KqNv+BOcboNnM=;
        b=hSoPvCNKmxAhVrw2HJM/eC3ZVKUybknfdN0Z1O8nyDqmj7SXPx+UmzipVHQXBi6FMA
         ZC8c3u10eGS/dLB+XLJD8uy64efAQaMLX/qNg2zoAfmJnzN/bpOA7B57ZjJPgBBy094g
         K1/yi3gtrQKmLSYdSdCWGEZfEox8bsJDWbg2p+7aN/cyYR082LkQgbAAlvAB2x6D+pJR
         evN1HlXmlveB2HTGKSewh3iKJHZuuGbOnBGONYtuWr+XtozbEIuF57/GGKgSQgvEWq9y
         /MjRC2AlQyOaSOjftUc5qQ9+MXmMmMYNIIFbgH/0n+bynEc/sC2rKl2soHCymaSQTtDv
         DxWQ==
X-Gm-Message-State: ACgBeo0T3Pp/MJW6qGY34eGROjMDSha269alkFQhiwYa7Zpelv2uAHIO
        bRO7+VsoekjDEDyVvSL/YXhnYx17pZv0w1Nyq0Licg==
X-Google-Smtp-Source: AA6agR46Fqfr6h29E2wz0At0Pp830Mkv1DSDIDLp4YEgMk2MRAjCGRoNOWf+nWj6Wz1WY+ccfJlNQDob9rEdYiDk0hQ=
X-Received: by 2002:a67:d21b:0:b0:388:4e12:eff9 with SMTP id
 y27-20020a67d21b000000b003884e12eff9mr6762116vsi.35.1660589663797; Mon, 15
 Aug 2022 11:54:23 -0700 (PDT)
MIME-Version: 1.0
References: <20220721204404.388396-1-weiwan@google.com> <ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org>
 <CADVnQymVXMamTRP-eSKhwq1M612zx0ZoNd=rs4MtipJNGm5Wcw@mail.gmail.com>
 <e318ba59-d58a-5826-82c9-6cfc2409cbd4@kernel.org> <f3301080-78c6-a65a-d8b1-59b759a077a4@kernel.org>
 <CADVnQykRMcumBjxND9E4nSxqA-s3exR3AzJ6+Nf0g+s5H6dqeQ@mail.gmail.com>
In-Reply-To: <CADVnQykRMcumBjxND9E4nSxqA-s3exR3AzJ6+Nf0g+s5H6dqeQ@mail.gmail.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 15 Aug 2022 11:54:13 -0700
Message-ID: <CAEA6p_Aujf5Q=sG56-VfoOvOjPcvwa-Ajw4519hHV+L2hYGrRg@mail.gmail.com>
Subject: Re: [PATCH net v2] Revert "tcp: change pingpong threshold to 3"
To:     Neal Cardwell <ncardwell@google.com>
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

On Mon, Aug 15, 2022 at 6:30 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Mon, Aug 15, 2022 at 3:48 AM Jiri Slaby <jirislaby@kernel.org> wrote:
> >
> > On 06. 08. 22, 16:41, Jiri Slaby wrote:
> > > On 06. 08. 22, 13:24, Neal Cardwell wrote:
> > >> On Sat, Aug 6, 2022 at 6:02 AM Jiri Slaby <jirislaby@kernel.org> wrote:
> > >>>
> > >>> On 21. 07. 22, 22:44, Wei Wang wrote:
> > >>>> This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> > >>>>
> > >>>> This to-be-reverted commit was meant to apply a stricter rule for the
> > >>>> stack to enter pingpong mode. However, the condition used to check for
> > >>>> interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> > >>>> jiffy based and might be too coarse, which delays the stack entering
> > >>>> pingpong mode.
> > >>>> We revert this patch so that we no longer use the above condition to
> > >>>> determine interactive session, and also reduce pingpong threshold to 1.
> > >>>>
> > >>>> Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
> > >>>> Reported-by: LemmyHuang <hlm3280@163.com>
> > >>>> Suggested-by: Neal Cardwell <ncardwell@google.com>
> > >>>> Signed-off-by: Wei Wang <weiwan@google.com>
> > >>>
> > >>>
> > >>> This breaks python-eventlet [1] (and was backported to stable trees):
> > >>> ________________ TestHttpd.test_018b_http_10_keepalive_framing
> > >>> _________________
> > >>>
> > >>> self = <tests.wsgi_test.TestHttpd
> > >>> testMethod=test_018b_http_10_keepalive_framing>
> > >>>
> > >>>       def test_018b_http_10_keepalive_framing(self):
> > >>>           # verify that if an http/1.0 client sends connection:
> > >>> keep-alive
> > >>>           # that we don't mangle the request framing if the app doesn't
> > >>> read the request
> > >>>           def app(environ, start_response):
> > >>>               resp_body = {
> > >>>                   '/1': b'first response',
> > >>>                   '/2': b'second response',
> > >>>                   '/3': b'third response',
> > >>>               }.get(environ['PATH_INFO'])
> > >>>               if resp_body is None:
> > >>>                   resp_body = 'Unexpected path: ' + environ['PATH_INFO']
> > >>>                   if six.PY3:
> > >>>                       resp_body = resp_body.encode('latin1')
> > >>>               # Never look at wsgi.input!
> > >>>               start_response('200 OK', [('Content-type', 'text/plain')])
> > >>>               return [resp_body]
> > >>>
> > >>>           self.site.application = app
> > >>>           sock = eventlet.connect(self.server_addr)
> > >>>           req_body = b'GET /tricksy HTTP/1.1\r\n'
> > >>>           body_len = str(len(req_body)).encode('ascii')
> > >>>
> > >>>           sock.sendall(b'PUT /1 HTTP/1.0\r\nHost:
> > >>> localhost\r\nConnection: keep-alive\r\n'
> > >>>                        b'Content-Length: ' + body_len + b'\r\n\r\n' +
> > >>> req_body)
> > >>>           result1 = read_http(sock)
> > >>>           self.assertEqual(b'first response', result1.body)
> > >>>           self.assertEqual(result1.headers_original.get('Connection'),
> > >>> 'keep-alive')
> > >>>
> > >>>           sock.sendall(b'PUT /2 HTTP/1.0\r\nHost:
> > >>> localhost\r\nConnection: keep-alive\r\n'
> > >>>                        b'Content-Length: ' + body_len + b'\r\nExpect:
> > >>> 100-continue\r\n\r\n')
> > >>>           # Client may have a short timeout waiting on that 100 Continue
> > >>>           # and basically immediately send its body
> > >>>           sock.sendall(req_body)
> > >>>           result2 = read_http(sock)
> > >>>           self.assertEqual(b'second response', result2.body)
> > >>>           self.assertEqual(result2.headers_original.get('Connection'),
> > >>> 'close')
> > >>>
> > >>>   >       sock.sendall(b'PUT /3 HTTP/1.0\r\nHost:
> > >>> localhost\r\nConnection: close\r\n\r\n')
> > >>>
> > >>> tests/wsgi_test.py:648:
> > >>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
> > >>> _ _ _ _
> > >>> eventlet/greenio/base.py:407: in sendall
> > >>>       tail = self.send(data, flags)
> > >>> eventlet/greenio/base.py:401: in send
> > >>>       return self._send_loop(self.fd.send, data, flags)
> > >>> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
> > >>> _ _ _ _
> > >>>
> > >>> self = <eventlet.greenio.base.GreenSocket object at 0x7f5f2f73c9a0>
> > >>> send_method = <built-in method send of socket object at 0x7f5f2f73d520>
> > >>> data = b'PUT /3 HTTP/1.0\r\nHost: localhost\r\nConnection:
> > >>> close\r\n\r\n'
> > >>> args = (0,), _timeout_exc = timeout('timed out'), eno = 32
> > >>>
> > >>>       def _send_loop(self, send_method, data, *args):
> > >>>           if self.act_non_blocking:
> > >>>               return send_method(data, *args)
> > >>>
> > >>>           _timeout_exc = socket_timeout('timed out')
> > >>>           while True:
> > >>>               try:
> > >>>   >               return send_method(data, *args)
> > >>> E               BrokenPipeError: [Errno 32] Broken pipe
> > >>>
> > >>> eventlet/greenio/base.py:388: BrokenPipeError
> > >>> ====================
> > >>>
> > >>> Reverting this revert on the top of 5.19 solves the issue.
> > >>>
> > >>> Any ideas?
> > >>
> > >> Interesting. This revert should return the kernel back to the delayed
> > >> ACK behavior it had for many years before May 2019 and Linux 5.1,
> > >> which contains the commit it is reverting:
> > >>
> > >>    4a41f453bedfd tcp: change pingpong threshold to 3
> > >>
> > >> It sounds like perhaps this test you mention has an implicit
> > >> dependence on the timing of delayed ACKs.
> > >>
> > >> A few questions:
> > >
> > > Dunno. I am only an openSUSE kernel maintainer and this popped out at
> > > me. Feel free to dig to eventlet's sources on your own :P.
> >
> > Any updates on this or should I send a revert directly?
> >
> > The "before() &&" part of the patch makes the difference. That is this diff:
> > --- a/net/ipv4/tcp_output.c
> > +++ b/net/ipv4/tcp_output.c
> > @@ -172,9 +172,17 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
> >           * and it is a reply for ato after last received packet,
> >           * increase pingpong count.
> >           */
> > -       if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> > -           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
> > +       pr_info("%s: sk=%p (%llx:%x) now=%u lsndtime=%u lrcvtime=%u
> > ping=%u\n",
> > +                       __func__, sk, sk->sk_addrpair, sk->sk_portpair, now,
> > +                       tp->lsndtime, icsk->icsk_ack.lrcvtime,
> > +                       inet_csk(sk)->icsk_ack.pingpong);
> > +       if (//before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
> > +           (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato) {
> >                  inet_csk_inc_pingpong_cnt(sk);
> > +               pr_info("\tINC ping=%u before=%u\n",
> > +                               inet_csk(sk)->icsk_ack.pingpong,
> > +                               before(tp->lsndtime,
> > icsk->icsk_ack.lrcvtime));
> > +       }
> >
> >          tp->lsndtime = now;
> >   }
> >
> > makes it work again, and outputs this:

Is the above patch made on top of my reverted patch? It seems not
according to this part of diff.
Then what is the definition of TCP_PINGPONG_THRESH in the working
case? I think that is the key, regardless of the result of:
    before(tp->lsndtime, icsk->icsk_ack.lrcvtime)

I tried to look into what exactly the test is doing, and can't tell
why it is failing. I don't see any check that is based on the timing
of the reply. :(
I hope someone could explain more about what this test is doing.

> >
> >  > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> > (100007f0100007f:e858b18b) now=4294902140 lsndtime=4294902140
> > lrcvtime=4294902140 ping=0
> >  > TCP: tcp_event_data_sent: sk=00000000a4becf82
> > (100007f0100007f:8bb158e8) now=4294902143 lsndtime=4294902140
> > lrcvtime=4294902142 ping=0
> >  > TCP:     INC ping=1 before=1
> >  > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> > (100007f0100007f:e858b18b) now=4294902145 lsndtime=4294902140
> > lrcvtime=4294902144 ping=0
> >  > TCP:     INC ping=1 before=1
> >  > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> > (100007f0100007f:e858b18b) now=4294902147 lsndtime=4294902145
> > lrcvtime=4294902144 ping=1
> >  > TCP:     INC ping=2 before=0
> >
> > IMO, this "before=0" is the "source" of the problem. But I have no idea
> > what this means at all...
> >
> >  > TCP: tcp_event_data_sent: sk=00000000a4becf82
> > (100007f0100007f:8bb158e8) now=4294902149 lsndtime=4294902143
> > lrcvtime=4294902148 ping=1
> >  > TCP:     INC ping=2 before=1
> >  > TCP: tcp_event_data_sent: sk=00000000fd67cf8d
> > (100007f0100007f:e858b18b) now=4294902151 lsndtime=4294902147
> > lrcvtime=4294902150 ping=3
> >  > TCP:     INC ping=4 before=1
> >  > TCP: tcp_event_data_sent: sk=00000000c7a417e9
> > (100007f0100007f:e85ab18b) now=4294902153 lsndtime=4294902153
> > lrcvtime=4294902153 ping=0
> >  > TCP: tcp_event_data_sent: sk=000000008681183e
> > (100007f0100007f:8bb15ae8) now=4294902155 lsndtime=4294902153
> > lrcvtime=4294902154 ping=0
> >  > TCP:     INC ping=1 before=1
>
> It sounds like this test has a very specific dependence on the buggy
> delayed ACK timing behavior from the buggy commit
> 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
>
> IMHO I don't think we can revert a kernel bug fix based on a test that
> decided to depend on the exact timing of delayed ACKs during a time
> when that delayed ACK behavior was buggy. :-)
>
> best regards,
> neal
