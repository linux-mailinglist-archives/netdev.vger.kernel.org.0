Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DF26A3F16
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 11:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229760AbjB0KGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 05:06:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbjB0KGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 05:06:06 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367EF1D900;
        Mon, 27 Feb 2023 02:06:05 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id a3so10208543vsi.0;
        Mon, 27 Feb 2023 02:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ysEyAXQpei8iW7Vd296eL75+Ws0ZY2kgID4wiDvkbwI=;
        b=KviBkJMDBICmCLO7t8ZFhp7rB6+DKGaCz6qFXlTkrfraVPfRBU9V0jiTm+QkpvMY3C
         MOjSAbjZGUsUHFtNTnckmHDCRYbrbY2ogiq3XBAVf18JK72XfPi6Zhd+YLQWeSnS62Ke
         SCee/dCxH7p6tm/b2fwc40+QAVNoBeoSivEmCTYfPSl9xz79/Xj93sK2mgJIV18YVpIL
         4YCS58JOeVbcA4takQ26EgzlKHg4caeMQv0xV1Mxg1fOXKvbXYH9t1d+4n0jQqYTh57J
         k9sJ7EXxruGlOrfCrCMXQ2YK4OBbRqYAdCoKEvEyO0vQ4f7MKc8deLiA2xg7MeO7j9wL
         cG5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ysEyAXQpei8iW7Vd296eL75+Ws0ZY2kgID4wiDvkbwI=;
        b=LP0BE9nXgQaHQvxH9gJx1ucVqmjhExTC3YyfnENJNL5mjZYIW5MYj5Z5dPeI7sHZUu
         izryn3rvDw3kgt5OrMsXHYpqVqbePAsIKkIXcojDG70Q+P5XMROzn2Y+XyTPbhn0viD/
         4GfKxq93trduwB7Uv5njXlyvl/lHhdDOlkJMiAHbw4eSkYqysAbzho6MHeIWggARRAia
         XfnV1ipCi7APC+Tvi8bdmxweVl/to2JFx4CBfDyMR7aI8VeQmTlQKnPm4zV/aPquVeGp
         PdFy33ofaZhdAlokmpSJADkTDz/rmaU2jZeNMGatVfZlxXwqy1pvNZIs1Q+9X3BBUvpy
         bEnw==
X-Gm-Message-State: AO0yUKUYPiCYzLGjdDoTbWRAPiG3SCzz+xkG2kRaKMvK7yXk3w2injih
        PcoaG0QXnKfNRESc4dEUhw0YriAKkctDwlFEE1Y=
X-Google-Smtp-Source: AK7set8LVuHd1GqAaqkiA6TzNRPvdd9ETv0m0QcJFvuTU2W4fifoxCa/1CZO7VHr2SeEC3udsu2mYPvYjyede5Bjo84=
X-Received: by 2002:ac5:cdd5:0:b0:401:42e5:6d2e with SMTP id
 u21-20020ac5cdd5000000b0040142e56d2emr7414717vkn.1.1677492364189; Mon, 27 Feb
 2023 02:06:04 -0800 (PST)
MIME-Version: 1.0
References: <20230227074104.42153-1-josef@miegl.cz> <CAHsH6GtArNCyA3UAJbSYYD86fb2QxskbSoNQo2RVHQzKC643zg@mail.gmail.com>
 <79dee14b9b96d5916a8652456b78c7a5@miegl.cz>
In-Reply-To: <79dee14b9b96d5916a8652456b78c7a5@miegl.cz>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Mon, 27 Feb 2023 12:05:51 +0200
Message-ID: <CAHsH6GuHiRDgY+_Epu=ejTAWONuXgzHk326SUuAeRp6pGaTEpA@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] net: geneve: accept every ethertype
To:     Josef Miegl <josef@miegl.cz>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 11:57=E2=80=AFAM Josef Miegl <josef@miegl.cz> wrote=
:
>
> February 27, 2023 10:30 AM, "Eyal Birger" <eyal.birger@gmail.com> wrote:
>
> > Hi,
> >
> > On Mon, Feb 27, 2023 at 10:19 AM Josef Miegl <josef@miegl.cz> wrote:
> >
> >> The Geneve encapsulation, as defined in RFC 8926, has a Protocol Type
> >> field, which states the Ethertype of the payload appearing after the
> >> Geneve header.
> >>
> >> Commit 435fe1c0c1f7 ("net: geneve: support IPv4/IPv6 as inner protocol=
")
> >> introduced a new IFLA_GENEVE_INNER_PROTO_INHERIT flag that allowed the
> >> use of other Ethertypes than Ethernet. However, for a reason not known
> >> to me, it imposed a restriction that prohibits receiving payloads othe=
r
> >> than IPv4, IPv6 and Ethernet.
> >
> > FWIW I added support for IPv4/IPv6 because these are the use cases I ha=
d
> > and could validate. I don't know what problems could arise from support=
ing
> > all possible ethertypes and can't test that.
>
> Yeah, I am hoping someone knowledgeable will tell whether this is a good
> or bad idea. However I think that if any problem could arise, this is not
> the place to artificially restrict payload types and potentional safeguar=
ding
> should be done somewhere down the packet chain.
>
> I can't imagine adding a payload Ethertype every time someone needs a
> specific use-case would be a good idea.

I guess it's just a matter of practicality - which decision imposes more
burden on future maintenance.

>
> >> This patch removes this restriction, making it possible to receive any
> >> Ethertype as a payload, if the IFLA_GENEVE_INNER_PROTO_INHERIT flag is
> >> set.
> >
> > This seems like an addition not a bugfix so personally seems like it sh=
ould
> > be targeting net-next (which is currently closed afaik).
>
> One could say the receive function should have behaved like that, the
> transmit function already encapsulates every possible Ethertype and
> IFLA_GENEVE_INNER_PROTO_INHERIT doesn't sound like it should be limited t=
o
> IPv4 and IPv6.

Indeed the flag is intentionally generic to allow for future extensions
without having to rename. But both in the commit message, and in the iprout=
e2
man page I noted support for IPv4/IPv6.

>
> If no further modifications down the packet chain are required, I'd say i=
t's
> 50/50. However I haven't contributed to the Linux kernel ever before, so =
I
> really have no clue as to how things go.
>
> > Eyal.
> >
> >> This is especially useful if one wants to encapsulate MPLS, because wi=
th
> >> this patch the control-plane traffic (IP, LLC) and the data-plane
> >> traffic (MPLS) can be encapsulated without an Ethernet frame, making
> >> lightweight overlay networks a possibility.
> >>
> >> Changes in v2:
> >> - added a cover letter
> >> - lines no longer exceed 80 columns
> >>
> >> Josef Miegl (1):
> >> net: geneve: accept every ethertype
> >>
> >> drivers/net/geneve.c | 15 ++++-----------
> >> 1 file changed, 4 insertions(+), 11 deletions(-)
> >>
> >> --
> >> 2.37.1
