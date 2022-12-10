Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55153648EEE
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 14:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLJNnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 08:43:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbiLJNnH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 08:43:07 -0500
Received: from mail-vk1-xa35.google.com (mail-vk1-xa35.google.com [IPv6:2607:f8b0:4864:20::a35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E3513D1E
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 05:43:06 -0800 (PST)
Received: by mail-vk1-xa35.google.com with SMTP id z23so3450685vkb.12
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 05:43:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJVlzrNzd/3zdP+2Sd2fTWkcgXHeQfr6iCBrZHbzQJM=;
        b=VZAaImRRR7PkeIGU6DPAt3xmK0AZh7FyMTwzuPwvTO+Puj54SjBW8Z5I9ZzMG5Br5s
         5zAIi86WkjDyTs5vWWxirxMoErDYcjRIeL9mau6lY8JzKvCl/L11HwMx7f0bpzDSRb3y
         CUPl8Bmqu3VzzFST2JVySIRV3boeD0BNFBnxw48B5B9whPXHik5nf63pVeQakF+Tx9Dm
         NUuF+1UKGV/7R+FJg3eY5M8IWtjpkHG+Qr64nkxMYpltHakXY8MTVIwpO45JD6yj3hQE
         W0sN/umLMSgdtUAWJ6es6YiZszWkagN9jS38lEee7zBUFGvaTjF/oEOs49LdAtbAAT9G
         1w6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JJVlzrNzd/3zdP+2Sd2fTWkcgXHeQfr6iCBrZHbzQJM=;
        b=rFR2r/ciSm9liq/jB4RsiFoTj9cA2cSn4az1ZZ1VJJyOkttSSMxoUayX0GjfFyU/dS
         kSmEv10bhUTb6QNegbRz0ix/S55ISIFPxuqM9uwGIZreQ6tw9TSz9+jh2LVvszw7iIzX
         fd9py1RuCp3QZMdBXmbwnd919SUKe+dOpNmwxqoR9lQK8LdZtAQhINzX8Oxxm28JTsWZ
         ZlmCv1fecZq9BfOcKzQXimX1CibLLax0+bv9Zm6six5Xpl5p0mJpLcancyQbj0llwpoE
         uwX0vg/H4R9ZJlCIbmGzVWTx4i+gmUchqsw3ymK/3nrNno7w8NsZYIB8LuIxUZ3qx6Th
         jrdQ==
X-Gm-Message-State: ANoB5pnSIu+c4w+kQNLYb5/OhZWz7Xk6ufMR5ErxBZY77hpZpW4d+f8H
        9fE+lySNfYIa+0+e9UJGF+luaHmti8RcaDczIETnBQL39YM=
X-Google-Smtp-Source: AA0mqf5TSr/VvCV0YwCPrs0GippbxwvqvQktZCOApKjTJq/tEpIAPeyLsnGjBeL9LDcWw+C18mcJ1a94RZNwe9hIow4=
X-Received: by 2002:a67:f882:0:b0:3b1:49aa:34f2 with SMTP id
 h2-20020a67f882000000b003b149aa34f2mr9941247vso.34.1670679315025; Sat, 10 Dec
 2022 05:35:15 -0800 (PST)
MIME-Version: 1.0
References: <Y44xdN3zH4f+BZCD@zwp-5820-Tower> <CADVnQykvAWHFOec_=DyU9GMLppK6mpeK-GqUVbktJffj1XA5rQ@mail.gmail.com>
 <87mt805181.fsf@cloudflare.com>
In-Reply-To: <87mt805181.fsf@cloudflare.com>
From:   Weiping Zhang <zwp10758@gmail.com>
Date:   Sat, 10 Dec 2022 21:35:03 +0800
Message-ID: <CAA70yB6LKf_xC-zH-9d1WT5eduz0Yv5PUSyZs=Wmh8oMBxmkUQ@mail.gmail.com>
Subject: Re: [RFC PATCH] tcp: correct srtt and mdev_us calculation
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        Weiping Zhang <zhangweiping@didiglobal.com>,
        edumazet@google.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry to reply to late caused by bad cold,


On Tue, Dec 6, 2022 at 5:29 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Mon, Dec 05, 2022 at 02:15 PM -05, Neal Cardwell wrote:
> > On Mon, Dec 5, 2022 at 1:02 PM Weiping Zhang
> > <zhangweiping@didiglobal.com> wrote:
> >>
> >> From the comments we can see that, rtt =3D 7/8 rtt + 1/8 new,
> >> but there is an mistake,
> >>
> >> m -=3D (srtt >> 3);
> >> srtt +=3D m;
> >>
> >> explain:
> >> m -=3D (srtt >> 3); //use t stands for new m
> >> t =3D m - srtt/8;
> >>
> >> srtt =3D srtt + t
> >> =3D srtt + m - srtt/8
> >> =3D srtt 7/8 + m
> >>
> >> Test code:
> >>
> >>  #include<stdio.h>
> >>
> >>  #define u32 unsigned int
> >>
> >> static void test_old(u32 srtt, long mrtt_us)
> >> {
> >>         long m =3D mrtt_us;
> >>         u32 old =3D srtt;
> >>
> >>         m -=3D (srtt >> 3);
> >>         srtt +=3D m;
> >>
> >>         printf("%s old_srtt: %u mrtt_us: %ld new_srtt: %u\n", __func__=
,  old, mrtt_us, srtt);
> >> }
> >>
> >> static void test_new(u32 srtt, long mrtt_us)
> >> {
> >>         long m =3D mrtt_us;
> >>         u32 old =3D srtt;
> >>
> >>         m =3D ((m - srtt) >> 3);
> >>         srtt +=3D m;
> >>
> >>         printf("%s old_srtt: %u mrtt_us: %ld new_srtt: %u\n", __func__=
,  old, mrtt_us, srtt);
> >> }
> >>
> >> int main(int argc, char **argv)
> >> {
> >>         u32 srtt =3D 100;
> >>         long mrtt_us =3D 90;
> >>
> >>         test_old(srtt, mrtt_us);
> >>         test_new(srtt, mrtt_us);
> >>
> >>         return 0;
> >> }
> >>
> >> ./a.out
> >> test_old old_srtt: 100 mrtt_us: 90 new_srtt: 178
> >> test_new old_srtt: 100 mrtt_us: 90 new_srtt: 98
> >>
> >> Signed-off-by: Weiping Zhang <zhangweiping@didiglobal.com>
> >
> > Please note that this analysis and this test program do not take
> > account of the fact that srtt in the Linux kernel is maintained in a
> > form where it is shifted left by 3 bits, to maintain a 3-bit
> > fractional part. That is why at first glance it would seem there is a
> > missing multiplication of the new sample by 1/8. By not shifting the
> > new sample when it is added to srtt, the new sample is *implicitly*
> > multiplied by 1/8.
>
> Nifty. And it's documented.
>
> struct tcp_sock {
>         =E2=80=A6
>         u32     srtt_us;        /* smoothed round trip time << 3 in usecs=
 */
>
> Thanks for the hint.
>
> >>  net/ipv4/tcp_input.c | 4 ++--
> >>  1 file changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> >> index 0640453fce54..0242bb31e1ce 100644
> >> --- a/net/ipv4/tcp_input.c
> >> +++ b/net/ipv4/tcp_input.c
> >> @@ -848,7 +848,7 @@ static void tcp_rtt_estimator(struct sock *sk, lon=
g mrtt_us)
As comments by Neal, srtt use lowest 3bits for fraction part, the
@mrtt_us does not include fraction part,
so m - srtt is not suitable, since m -=3D (srtt >> 3) will get the delta
which exclude fraction part, and m will also be
used to calculate mdev_us.
if we calculate srtt by: srtt =3D srtt *7/8 + (mrtt_us << 3)* 1 / 8,
it's more readable, append 3bits 0 for fraction part.
srtt =3D srtt *7/8 + (mrtt_us << 3)* 1 / 8
srtt *7/8 =3D> srtt - srtt >> 3
(mrtt_us << 3)* 1 / 8 =3D> mrtt_us
then
srtt =3D srtt - srtt >> 3 + mrtt_us;
srtt =3D srtt + mrtt_us - srtt >> 3
it's same as current code^_^
my previous patch does not consider the fraction part, it generates a
wrong result.

I write a new test code to decode the fraction part:

test_old old_srtt:         100 =3D>       12.4 mrtt_us:       90
new_srtt:         178 =3D>       22.2
test_new old_srtt:         100 =3D>       12.4 mrtt_us:       90
new_srtt:          98 =3D>       12.2

#include<stdio.h>
#include<stdlib.h>

#define u32 unsigned int

static void test_old(u32 srtt, long mrtt_us)
{
long m =3D mrtt_us;
u32 old =3D srtt;

m -=3D (srtt >> 3);
srtt +=3D m;

printf("%s old_srtt:    %8u =3D> %8u.%u mrtt_us: %8ld new_srtt:    %8u
=3D> %8u.%u\n", __func__,  old, old >> 3, old & 7, mrtt_us, srtt,
srtt>>3, srtt & 7);
//printf("%s old_srtt>>3: %8u mrtt_us: %8ld new_srtt>>3: %u\n",
__func__,  old>>3, mrtt_us, srtt>>3);
}

static void test_new(u32 srtt, long mrtt_us)
{
long m =3D mrtt_us;
u32 old =3D srtt;

m =3D ((m - srtt) >> 3);
srtt +=3D m;

printf("%s old_srtt:    %8u =3D> %8u.%u mrtt_us: %8ld new_srtt:    %8u
=3D> %8u.%u\n", __func__,  old, old >> 3, old & 7, mrtt_us, srtt,
srtt>>3, srtt & 7);
//printf("%s old_srtt>>3: %8u mrtt_us: %8ld new_srtt>>3: %u\n",
__func__,  old>>3, mrtt_us, srtt>>3);
}

int main(int argc, char **argv)
{
u32 srtt =3D atoi(argv[1]);
long mrtt_us =3D atoi(argv[2]);

test_old(srtt, mrtt_us);
test_new(srtt, mrtt_us);

return 0;
}

 > >>          * that VJ failed to avoid. 8)
> >>          */
> >>         if (srtt !=3D 0) {
> >> -               m -=3D (srtt >> 3);       /* m is now error in rtt est=
 */
> >> +               m =3D (m - srtt >> 3);    /* m is now error in rtt est=
 */
> >>                 srtt +=3D m;              /* rtt =3D 7/8 rtt + 1/8 new=
 */
> >>                 if (m < 0) {
> >>                         m =3D -m;         /* m is now abs(error) */
> >> @@ -864,7 +864,7 @@ static void tcp_rtt_estimator(struct sock *sk, lon=
g mrtt_us)
> >>                         if (m > 0)
> >>                                 m >>=3D 3;
> >>                 } else {
> >> -                       m -=3D (tp->mdev_us >> 2);   /* similar update=
 on mdev */
> >> +                       m =3D (m - tp->mdev_us >> 2);   /* similar upd=
ate on mdev */
> >>                 }
> >>                 tp->mdev_us +=3D m;               /* mdev =3D 3/4 mdev=
 + 1/4 new */
> >>                 if (tp->mdev_us > tp->mdev_max_us) {
> >> --
> >> 2.34.1
> >
> > AFAICT this proposed patch does not change the behavior of the code
> > but merely expresses the same operations with slightly different
> > syntax. Am I missing something?  :-)
>
> I've been wondering about that too. There's a change hiding behind
> operator precedence. Would be better expressed with explicitly placed
> parenthesis:
>
>         m =3D (m - srtt) >> 3;    /* m is now error in rtt est */
