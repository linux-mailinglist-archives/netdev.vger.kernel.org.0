Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1DD3DEC00
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728316AbfJUMTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:19:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:36766 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728017AbfJUMTy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 08:19:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571660392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=v0UIIW1MaBRlD43/qxMhkPsYTJD10RwKMZftmhm37s0=;
        b=Oo0DZ+XhnLoN6Uk3PFXl+PBa64W+OyY9t7Cjkj1DDqxqvNUfoEW45FQtY2DoOeqnD0+kEz
        J9zvDDUr09wkaVgjKMFN89VSBfb0hBzWk8Ihln8jnqPgpzaTha3PFz2aUnGDjRNEkHZCgP
        VK3zvPJejakbdzOnNA0FIPaauUBzi0Y=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-188-Gt2M8TwNMTm91nljDck4ug-1; Mon, 21 Oct 2019 08:19:49 -0400
Received: by mail-lf1-f69.google.com with SMTP id x20so2638651lfe.14
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 05:19:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=1PbZsDrBxtL2gC3etWHjxcXmwp6QN4cc3/3zITojwpU=;
        b=Zvbb8W3BIi1ZFTtiz7iiYqYbvf7Il+tz5upjb7BVDt8fnviS6yZs1d+t8SLKDnFhGE
         w3hQF6O/qd3IWn8ADMHR0ISqc+J5LaC2fueyfcSCaSeIkRPFoGwdOINMf4pvzCwtfhJ1
         VQLAJ2y/kHHAgtM2OoJ6WMAAvzm//Xh7Ppn6fzqa8deu4Yk3u9e2HETPSTZL64wgLbBL
         f8QQgEcNm2avgz0F/0NYflOANf78fZvLtxg1lLbjRhNUHgbkMkhf17MTTaKHtwQWVzW4
         Mpub/PnCpLjjZ1WqOGnCxui5u9nTQHfY5TbIBphZn8BwnEX63SnwZTq+u0B/NZSX9vif
         jw3Q==
X-Gm-Message-State: APjAAAWC9DOHG50NWs8bvWF98cu1zS8lHRXYx4OlsGUPNgCCqPXTJ5aM
        jpEvYRbzxwrsD5wET0gE+6U92hzyfFaxdSuT5iIRxqOdsUBfmbKKPuce8yaQlHpm2MKhSIDa8b5
        R0rkEnYUcmQSV/5Ke
X-Received: by 2002:a05:6512:4c1:: with SMTP id w1mr14866282lfq.96.1571660387689;
        Mon, 21 Oct 2019 05:19:47 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyB9tbzmrafnv1mzCenMsEiJ5ozRY7e9vtNMnA9yLmLQYN9yR0CeSKybmhjFcX3eyba7EWzjA==
X-Received: by 2002:a05:6512:4c1:: with SMTP id w1mr14866265lfq.96.1571660387492;
        Mon, 21 Oct 2019 05:19:47 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id y189sm8080842lfc.9.2019.10.21.05.19.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 05:19:46 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id E8B031800E9; Mon, 21 Oct 2019 14:19:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson\, Magnus" <magnus.karlsson@intel.com>,
        "Samudrala\, Sridhar" <sridhar.samudrala@intel.com>
Subject: Re: [PATCH bpf-next v2] libbpf: use implicit XSKMAP lookup from AF_XDP XDP program
In-Reply-To: <CAJ+HfNiNwTbER1NfaKamx0p1VcBHjHSXb4_66+2eBff95pmNFg@mail.gmail.com>
References: <20191021105938.11820-1-bjorn.topel@gmail.com> <87h842qpvi.fsf@toke.dk> <CAJ+HfNiNwTbER1NfaKamx0p1VcBHjHSXb4_66+2eBff95pmNFg@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 21 Oct 2019 14:19:45 +0200
Message-ID: <87bluaqoim.fsf@toke.dk>
MIME-Version: 1.0
X-MC-Unique: Gt2M8TwNMTm91nljDck4ug-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> On Mon, 21 Oct 2019 at 13:50, Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>>
>> Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:
>>
>> > From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>> >
>> > In commit 43e74c0267a3 ("bpf_xdp_redirect_map: Perform map lookup in
>> > eBPF helper") the bpf_redirect_map() helper learned to do map lookup,
>> > which means that the explicit lookup in the XDP program for AF_XDP is
>> > not needed for post-5.3 kernels.
>> >
>> > This commit adds the implicit map lookup with default action, which
>> > improves the performance for the "rx_drop" [1] scenario with ~4%.
>> >
>> > For pre-5.3 kernels, the bpf_redirect_map() returns XDP_ABORTED, and a
>> > fallback path for backward compatibility is entered, where explicit
>> > lookup is still performed. This means a slight regression for older
>> > kernels (an additional bpf_redirect_map() call), but I consider that a
>> > fair punishment for users not upgrading their kernels. ;-)
>> >
>> > v1->v2: Backward compatibility (Toke) [2]
>> >
>> > [1] # xdpsock -i eth0 -z -r
>> > [2] https://lore.kernel.org/bpf/87pnirb3dc.fsf@toke.dk/
>> >
>> > Suggested-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>> > ---
>> >  tools/lib/bpf/xsk.c | 45 +++++++++++++++++++++++++++++++++++---------=
-
>> >  1 file changed, 35 insertions(+), 10 deletions(-)
>> >
>> > diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
>> > index b0f532544c91..391a126b3fd8 100644
>> > --- a/tools/lib/bpf/xsk.c
>> > +++ b/tools/lib/bpf/xsk.c
>> > @@ -274,33 +274,58 @@ static int xsk_load_xdp_prog(struct xsk_socket *=
xsk)
>> >       /* This is the C-program:
>> >        * SEC("xdp_sock") int xdp_sock_prog(struct xdp_md *ctx)
>> >        * {
>> > -      *     int index =3D ctx->rx_queue_index;
>> > +      *     int ret, index =3D ctx->rx_queue_index;
>> >        *
>> >        *     // A set entry here means that the correspnding queue_id
>> >        *     // has an active AF_XDP socket bound to it.
>> > +      *     ret =3D bpf_redirect_map(&xsks_map, index, XDP_PASS);
>> > +      *     ret &=3D XDP_PASS | XDP_REDIRECT;
>>
>> Why the masking? Looks a bit weird (XDP return codes are not defined as
>> bitmask values), and it's not really needed, is it?
>>
>
> bpf_redirect_map() returns a 32-bit signed int, so the upper 32-bit
> will need to be cleared. Having an explicit AND is one instruction
> less than two shifts. So, it's an optimization (every instruction is
> sacred).

OIC. Well, a comment explaining that might be nice (since you're doing
per-instruction comments anyway)? :)

-Toke

