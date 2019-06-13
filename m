Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFC144DED
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729530AbfFMU6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:58:15 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38472 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbfFMU6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 16:58:15 -0400
Received: by mail-pl1-f196.google.com with SMTP id f97so44548plb.5
        for <netdev@vger.kernel.org>; Thu, 13 Jun 2019 13:58:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appneta.com; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Uw4gPkVgJllSzx767XK/xtHkOAEmZEgc8ltVqf+5naI=;
        b=qIc9JfqL1OlpF/5A1MHk3TQAt1BnrS0bzZgNzdd0vTADLriDUD0LykWyp3zwCa71YE
         dcdCSNpAWYrejaAV0SXKRY26N0JVd0Wz10bpPD3QXSgVpPgDXeVdkBBYnLoPuJR/7wQ+
         twTEGOpfR2XdlOGZjHlGKNl0wIKWyBCs8J+kk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Uw4gPkVgJllSzx767XK/xtHkOAEmZEgc8ltVqf+5naI=;
        b=fV+w+Ks3THdgk0c0LgzcEd11FBO2NV0vD8JoO6SnxCrHKXqchdZqVhHBbUpBrSgUgn
         WE762z2XxyFpRNVfoXkiNyWfaByhTny7j/QTViID3j4h2aEUO+KFXqd+m40WeF7NER+9
         iHqlbMdiSnBdmEKSKmLRoRqWXVm67XE0hSti5GHSPhSraDOUDcDFYRVg4RV+iuHMu/aJ
         d11LKo5biXGNHxaA38IkvNg0ftn3ZQYD16AfkrdSUmmL3uHdE+pLuBuhndpJfrgYQunu
         1g2BdWdN2Vi2f3vv6xbkPGNj5CK3X3ocaSIBH0Q35kq9Gqcvyn0OWapzxU6xueTqvYmx
         9xKQ==
X-Gm-Message-State: APjAAAU8BEOtSND2aHfrblbtqYAigmH6AF+0S0/5C1ljtR0UwqteznbB
        HUXcXMTvM0YVVOIgbEAU42mkRM30Sn4=
X-Google-Smtp-Source: APXvYqyN7A8O2/1AUcw8DbgBEyyCXmvFRwz+w/oVetSKbfWvIrya1oydsy2EiS+lotWAJYa5swLijw==
X-Received: by 2002:a17:902:e105:: with SMTP id cc5mr70016021plb.320.1560459494529;
        Thu, 13 Jun 2019 13:58:14 -0700 (PDT)
Received: from jltm109.jaalam.net ([209.139.228.33])
        by smtp.gmail.com with ESMTPSA id r7sm574815pfl.134.2019.06.13.13.58.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 13:58:13 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [PATCH net v2 1/1] net/udp_gso: Allow TX timestamp with UDP GSO
From:   Fred Klassen <fklassen@appneta.com>
In-Reply-To: <CAF=yD-KyJC0ErdyNRtiw5VPhQY+i__sDG5oh0LzWJ4RMYe1zCQ@mail.gmail.com>
Date:   Thu, 13 Jun 2019 13:58:12 -0700
Cc:     "David S. Miller" <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <D40775C9-AED4-4634-B3AF-78B2771516C7@appneta.com>
References: <20190526153357.82293-1-fklassen@appneta.com>
 <20190526153357.82293-2-fklassen@appneta.com>
 <CAF=yD-KyJC0ErdyNRtiw5VPhQY+i__sDG5oh0LzWJ4RMYe1zCQ@mail.gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> It also appears that other TX CMSG types cause similar issues, for
>> example trying to set SOL_IP/IP_TOS.
>=20
> If correct we need to find the root cause. Without that, this is not
> very informative. And likely the fix is not related, as that does not
> involve tx_flags or tskey.
>=20
> What exact behavior do you observe: tx timestamp notifications go
> missing when enabling IP_TOS?

The IP_TOS observation was a false positive, so removing this comment =
for v3.

>>=20
>> This patch preserves tx_flags for the first UDP GSO segment. This
>> mirrors the stack's behaviour for IPv4 fragments.
>=20
> But deviates from the established behavior of other transport protocol =
TCP.

Ack. Removing comment for v3. The noted IPv4 fragment behavior is from =
at patch
that is not been accepted yet.

> I think it's a bit premature to resubmit as is while still discussing
> the original patch.
>=20

Understood. Will wait for acceptance before submitting v3.

>> --- a/net/ipv4/udp_offload.c
>> +++ b/net/ipv4/udp_offload.c
>> @@ -228,6 +228,10 @@ struct sk_buff *__udp_gso_segment(struct sk_buff =
*gso_skb,
>>        seg =3D segs;
>>        uh =3D udp_hdr(seg);
>>=20
>> +       /* preserve TX timestamp and zero-copy info for first segment =
*/
>=20
> As pointed out in v1, zerocopy flags are handled by protocol
> independent skb_segment. It calls skb_zerocopy_clone.
>=20

Correcting in v3 to read =E2=80=A6
"preserve TX timestamp flags and TS key for first segment=E2=80=9D.

