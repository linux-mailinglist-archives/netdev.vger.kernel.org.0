Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F047258B53D
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 13:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230308AbiHFLYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 07:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbiHFLYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 07:24:53 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 477D31054F
        for <netdev@vger.kernel.org>; Sat,  6 Aug 2022 04:24:52 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id o1so3510497qkg.9
        for <netdev@vger.kernel.org>; Sat, 06 Aug 2022 04:24:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=HzJh0YLghezA+W7ONhtFdDOIja3bIw6J8jHQmyCuUaY=;
        b=M/guQFUESEYAjGGCGqLBSq++8M6Rg/0xNlAw+g9Dm9OWnrMO3ykQnOBx96rh51AflR
         yJeJ1avg1dxwHvjOvZl3FTx7x6sjwokJ0qmDUNu8xcLuR2TWv1W2RP55kcBjpmYpTs0c
         XjcubtuJHZB7VosOb56Gr1WfDw+kALqZYgNSbL2XL9/Hei0himq1eNUjBEXgn9A6GE3m
         C8MtueZhY9uJNMFs6gjAgE5OxATmPMEReRD0en7O4i7LQeTj5CJ/g4/nq1/Jy9b06zZM
         u5bxBpGJHSibLjH8/4HC3sYGY+nZdulA9SA+h3Ii0AGLJocDv2Al8kyKiVGIOPY+okxe
         CxGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=HzJh0YLghezA+W7ONhtFdDOIja3bIw6J8jHQmyCuUaY=;
        b=Njszz79bQavHHi6xit9lWK3rcJ6Jrr0Mgz1dmygR4k7E2bT52AfEXHSzqHbpRnRT7N
         SX0wzPQLqrQQH18N58oYwDJ/Qu36OE0bCMGELqfD9zZ0kDizE7IWaTlfCXF9jI5ogtEB
         hG/F9RCdLamtpzd+OGmDOuOu01e94mtbCkvmgl34LYm8Y/sfBI8gC8YKE4bV1XJ28Us+
         dxVzvt8YN99eDk3L4+Rp5LBeL/KVHCMFZT/Jc1OHotEsq6FiUO9DbIENdKoROlLNtSdZ
         mJcf8D5+cBh4HS3chazGb7nF288n7MnHJAM3mKKV7POyT0YJdRfNcWXG96hhqJFiYFp+
         iU5Q==
X-Gm-Message-State: ACgBeo2wHC8QA2EG38hUmnY9puZ7Uy0RE+gIe386ICDCGXXSLjW6KofV
        sK64hQOfjZtAh3x5O/QXem3bdsW0nT/WgeXQuBeH0A==
X-Google-Smtp-Source: AA6agR4MS7Nb2kKGJLxBQuuGlLphpuIHnY2QPIRKDdbjq2m5UDUvJAr4xpbisWG5VWSe1uMkpN3bC2hlvIiW+/bR+BQ=
X-Received: by 2002:a05:620a:4454:b0:6b5:d7b9:4839 with SMTP id
 w20-20020a05620a445400b006b5d7b94839mr8250346qkp.434.1659785091260; Sat, 06
 Aug 2022 04:24:51 -0700 (PDT)
MIME-Version: 1.0
References: <20220721204404.388396-1-weiwan@google.com> <ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org>
In-Reply-To: <ca408271-8730-eb2b-f12e-3f66df2e643a@kernel.org>
From:   Neal Cardwell <ncardwell@google.com>
Date:   Sat, 6 Aug 2022 07:24:35 -0400
Message-ID: <CADVnQymVXMamTRP-eSKhwq1M612zx0ZoNd=rs4MtipJNGm5Wcw@mail.gmail.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 6, 2022 at 6:02 AM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> On 21. 07. 22, 22:44, Wei Wang wrote:
> > This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.
> >
> > This to-be-reverted commit was meant to apply a stricter rule for the
> > stack to enter pingpong mode. However, the condition used to check for
> > interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
> > jiffy based and might be too coarse, which delays the stack entering
> > pingpong mode.
> > We revert this patch so that we no longer use the above condition to
> > determine interactive session, and also reduce pingpong threshold to 1.
> >
> > Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
> > Reported-by: LemmyHuang <hlm3280@163.com>
> > Suggested-by: Neal Cardwell <ncardwell@google.com>
> > Signed-off-by: Wei Wang <weiwan@google.com>
>
>
> This breaks python-eventlet [1] (and was backported to stable trees):
> ________________ TestHttpd.test_018b_http_10_keepalive_framing
> _________________
>
> self = <tests.wsgi_test.TestHttpd
> testMethod=test_018b_http_10_keepalive_framing>
>
>      def test_018b_http_10_keepalive_framing(self):
>          # verify that if an http/1.0 client sends connection: keep-alive
>          # that we don't mangle the request framing if the app doesn't
> read the request
>          def app(environ, start_response):
>              resp_body = {
>                  '/1': b'first response',
>                  '/2': b'second response',
>                  '/3': b'third response',
>              }.get(environ['PATH_INFO'])
>              if resp_body is None:
>                  resp_body = 'Unexpected path: ' + environ['PATH_INFO']
>                  if six.PY3:
>                      resp_body = resp_body.encode('latin1')
>              # Never look at wsgi.input!
>              start_response('200 OK', [('Content-type', 'text/plain')])
>              return [resp_body]
>
>          self.site.application = app
>          sock = eventlet.connect(self.server_addr)
>          req_body = b'GET /tricksy HTTP/1.1\r\n'
>          body_len = str(len(req_body)).encode('ascii')
>
>          sock.sendall(b'PUT /1 HTTP/1.0\r\nHost:
> localhost\r\nConnection: keep-alive\r\n'
>                       b'Content-Length: ' + body_len + b'\r\n\r\n' +
> req_body)
>          result1 = read_http(sock)
>          self.assertEqual(b'first response', result1.body)
>          self.assertEqual(result1.headers_original.get('Connection'),
> 'keep-alive')
>
>          sock.sendall(b'PUT /2 HTTP/1.0\r\nHost:
> localhost\r\nConnection: keep-alive\r\n'
>                       b'Content-Length: ' + body_len + b'\r\nExpect:
> 100-continue\r\n\r\n')
>          # Client may have a short timeout waiting on that 100 Continue
>          # and basically immediately send its body
>          sock.sendall(req_body)
>          result2 = read_http(sock)
>          self.assertEqual(b'second response', result2.body)
>          self.assertEqual(result2.headers_original.get('Connection'),
> 'close')
>
>  >       sock.sendall(b'PUT /3 HTTP/1.0\r\nHost:
> localhost\r\nConnection: close\r\n\r\n')
>
> tests/wsgi_test.py:648:
> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
> _ _ _ _
> eventlet/greenio/base.py:407: in sendall
>      tail = self.send(data, flags)
> eventlet/greenio/base.py:401: in send
>      return self._send_loop(self.fd.send, data, flags)
> _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _ _
> _ _ _ _
>
> self = <eventlet.greenio.base.GreenSocket object at 0x7f5f2f73c9a0>
> send_method = <built-in method send of socket object at 0x7f5f2f73d520>
> data = b'PUT /3 HTTP/1.0\r\nHost: localhost\r\nConnection: close\r\n\r\n'
> args = (0,), _timeout_exc = timeout('timed out'), eno = 32
>
>      def _send_loop(self, send_method, data, *args):
>          if self.act_non_blocking:
>              return send_method(data, *args)
>
>          _timeout_exc = socket_timeout('timed out')
>          while True:
>              try:
>  >               return send_method(data, *args)
> E               BrokenPipeError: [Errno 32] Broken pipe
>
> eventlet/greenio/base.py:388: BrokenPipeError
> ====================
>
> Reverting this revert on the top of 5.19 solves the issue.
>
> Any ideas?

Interesting. This revert should return the kernel back to the delayed
ACK behavior it had for many years before May 2019 and Linux 5.1,
which contains the commit it is reverting:

  4a41f453bedfd tcp: change pingpong threshold to 3

It sounds like perhaps this test you mention has an implicit
dependence on the timing of delayed ACKs.

A few questions:

(1) What are the timeout values in this test? If there is some
implicit or explicit timeout value less than the typical Linux TCP
40ms delayed ACK timer value then this could be the problem. If you
make sure all timeouts are at least, say, 300ms then this should
remove dependencies on delayed ACK behavior (and make the test more
portable).

(2) Does this test use the TCP_NODELAY socket option to disable
Nagle's algorithm? Presumably it should, given that it's a network app
that cares about latency. Omitting the TCP_NODELAY socket option can
cause request/response traffic to depend on delayed ACK behavior.

(3) If (1) and (2) do not fix the test, would you be able to provide
binary .pcap traces of the behavior with the test (a) passing and (b)
failing? For example:
   sudo tcpdump -i any -w /tmp/trace.pcap -s 100 port 80 &
   # run test
   killall tcpdump

thanks,
neal
