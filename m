Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CFA02101A9
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 03:53:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726155AbgGABxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 21:53:42 -0400
Received: from mail.efficios.com ([167.114.26.124]:48614 "EHLO
        mail.efficios.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbgGABxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 21:53:42 -0400
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id 314002C9491;
        Tue, 30 Jun 2020 21:53:41 -0400 (EDT)
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id QL88lQyBuVQy; Tue, 30 Jun 2020 21:53:40 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.efficios.com (Postfix) with ESMTP id D709D2C9490;
        Tue, 30 Jun 2020 21:53:40 -0400 (EDT)
DKIM-Filter: OpenDKIM Filter v2.10.3 mail.efficios.com D709D2C9490
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
        s=default; t=1593568420;
        bh=kKtLxAKcMdpuvU+NHR+2J7R0xy72FxtwVWbCjPoaSMo=;
        h=Date:From:To:Message-ID:MIME-Version;
        b=MZ3wBiy9dVQTj5vwd3IGWioJ4DBCdGtOqkKQBzJRCLF8aIGqjUTvvDL65DBBVJqaD
         qdih11ifB6Uu26COY/eyYtFlPw3Kkzt7GTu4qqkidVcguSXiWXwWyXHKnPXtpbEAbX
         gyiQCOi3gduaq92iuh5hAMwdV26lNt4DoRGCjGudJ6uAuWba+6Zd6TlpxCRxDcqS3U
         axBWc/aKzNEP5sMnz4fnaqfjXe+sellICY0oRU/gc9NV9C8HwK0UlzkBfyqTsUwZSj
         Q//h88LspLAwaq9lOVJ5kqp0C0SttA/eCvdeFmYy82wcg0JxXUKRbrqHraCFueBBBo
         cyRujbwE3d+JQ==
X-Virus-Scanned: amavisd-new at efficios.com
Received: from mail.efficios.com ([127.0.0.1])
        by localhost (mail03.efficios.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 4p48m_a1Ze3O; Tue, 30 Jun 2020 21:53:40 -0400 (EDT)
Received: from mail03.efficios.com (mail03.efficios.com [167.114.26.124])
        by mail.efficios.com (Postfix) with ESMTP id CAC3F2C958A;
        Tue, 30 Jun 2020 21:53:40 -0400 (EDT)
Date:   Tue, 30 Jun 2020 21:53:40 -0400 (EDT)
From:   Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Message-ID: <873522637.18316.1593568420718.JavaMail.zimbra@efficios.com>
In-Reply-To: <CANn89i+_hjeqTyOzQjqPzGVMJRjgYRnQ1bZ6Qyh=gbE6TgRAMg@mail.gmail.com>
References: <20200630234101.3259179-1-edumazet@google.com> <CAPA1RqChMXe-o_eqc3VN3vT7wtY3Bz-SKzp6ZU2PQ3SykACgXA@mail.gmail.com> <CANn89i+_hjeqTyOzQjqPzGVMJRjgYRnQ1bZ6Qyh=gbE6TgRAMg@mail.gmail.com>
Subject: Re: [PATCH net] tcp: md5: add missing memory barriers in
 tcp_md5_do_add()/tcp_md5_hash_key()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [167.114.26.124]
X-Mailer: Zimbra 8.8.15_GA_3945 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3928)
Thread-Topic: md5: add missing memory barriers in tcp_md5_do_add()/tcp_md5_hash_key()
Thread-Index: NbJBppXmzbuP+VNEiRy+FFHg7lrRFg==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

----- On Jun 30, 2020, at 8:55 PM, Eric Dumazet edumazet@google.com wrote:

> On Tue, Jun 30, 2020 at 5:53 PM Hideaki Yoshifuji
> <hideaki.yoshifuji@miraclelinux.com> wrote:
>>
>> Hi,
>>
>> 2020=E5=B9=B47=E6=9C=881=E6=97=A5(=E6=B0=B4) 8:41 Eric Dumazet <edumazet=
@google.com>:
>> :
>> > We only want to make sure that in the case key->keylen
>> > is changed, cpus in tcp_md5_hash_key() wont try to use
>> > uninitialized data, or crash because key->keylen was
>> > read twice to feed sg_init_one() and ahash_request_set_crypt()
>> >
>> > Fixes: 9ea88a153001 ("tcp: md5: check md5 signature without socket loc=
k")
>> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>> > Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> > ---
>> >  net/ipv4/tcp.c      | 7 +++++--
>> >  net/ipv4/tcp_ipv4.c | 3 +++
>> >  2 files changed, 8 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/net/ipv4/tcp.c b/net/ipv4/tcp.c
>> > index
>> > 810cc164f795f8e1e8ca747ed5df51bb20fec8a2..f111660453241692a17c881dd6dc=
2910a1236263
>> > 100644
>> > --- a/net/ipv4/tcp.c
>> > +++ b/net/ipv4/tcp.c
>> > @@ -4033,10 +4033,13 @@ EXPORT_SYMBOL(tcp_md5_hash_skb_data);
>> >
>> >  int tcp_md5_hash_key(struct tcp_md5sig_pool *hp, const struct tcp_md5=
sig_key
>> >  *key)
>> >  {
>> > +       u8 keylen =3D key->keylen;
>> >         struct scatterlist sg;
>>
>> ACCESS_ONCE here, no?
>=20
> Not needed, the smp_rmb() barrier is stronger.

ACCESS_ONCE() is now deprecated in favor of READ_ONCE()/WRITE_ONCE(),
which are needed here. smp_rmb()/smp_wmb() are needed in addition, but
have a different purpose. smp_rmb() only guarantees ordering, but does
nothing to prevent the compiler from turning the load into something
unexpected. Likewise for WRITE_ONCE. See linux/compiler.h READ_ONCE and
WRITE_ONCE comment:

"2) Ensuring that the compiler does not fold, spindle, or otherwise
mutilate accesses that either do not require ordering or that interact
with an explicit memory barrier or atomic instruction that provides the
required ordering."

Thanks,

Mathieu


--=20
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
