Return-Path: <netdev+bounces-8160-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 357FF722EF3
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 20:52:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 512D21C20B96
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 18:52:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92681F938;
	Mon,  5 Jun 2023 18:52:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE43FBE49
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 18:52:19 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E76D9E
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 11:52:18 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f7024e66adso12135e9.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 11:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685991136; x=1688583136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hKQQIkxn115lIDi69wH/ZBwff+JTaqK4+GV0rQoXIbA=;
        b=dtJ4qv+uyVAb7f9vlG+EA/kRF2uBTbpxefnOxniDaYZAP9vyQHLIOrIB5i+POUMppF
         +UlhCNiTS2oJYVs1MXx+nOgfw5Nzxwc/b2lTEmLT/2FIU0LBNNFsBs7WWH82OuH/DAAZ
         eizl9SfwaYLiq58rDNd5xD9a7N8OlyY2pgh8Z8TQmB60KvdBYGaA3UQd8u/PcPcv2xHI
         cYy/bgx4yg8QPgSMEFM3GccX7bJRUgEpyx3QzRyp2M4HKwlEWXNrblE2DFC5XwwVVNZ/
         75Bb43gt79uZFjHOsUJTkSKf4B+63+0QGd0lCZ/zhd77dPKBlLvFiCy5TNDIUuqjKn2F
         BFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685991136; x=1688583136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hKQQIkxn115lIDi69wH/ZBwff+JTaqK4+GV0rQoXIbA=;
        b=WU2PCYhlBw9eAdfz7KQR3uOTOV1CkAlwUgZ8PkmBhlLSc/VgBjNdvM0Q6c1/OZD27B
         GUzOKCcmcc3titsv3C6Fz2LSvncXBs29pB7uuueGby+GPyHKqiYr4QytHmZzTVUtuhHx
         yeEQSHrhtUjGqQzuEn7Ms46iKESDmI9ROZ5+B2U9qDV+wzsXHZvoqBHjxsHYDJsCT2TX
         vshzocBxHxMgcDBXz8RM4W5qHdB2p9i93mUhKKQ129buTZANmA6kDBhDzrwxJsw9XlYk
         Jjf+I1VixdNjkbkEd/aFFkZ71wLm6HXpN9zrzWSLhUyxjS6pLVb7nb1bGGrjUU72aylv
         Vr9Q==
X-Gm-Message-State: AC+VfDzzCEVBPAbjnb2Ib1SWm5KfFJEC0DIFx/D/Pu+KBv9EyXzdinqN
	OuOLhNoTHvzizsoo6YbmBzwlmF79iW5to+YPOGlbMw==
X-Google-Smtp-Source: ACHHUZ6FT/km2LB/To4RivrFzrVCNaa8pUCLnA3+G+Kirk/uJF+GSHVEmJ2uUoE/ie8gqOaFnnUXqcsDAcCKtqjeP0w=
X-Received: by 2002:a05:600c:3b90:b0:3f7:ba55:d038 with SMTP id
 n16-20020a05600c3b9000b003f7ba55d038mr25471wms.6.1685991136394; Mon, 05 Jun
 2023 11:52:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605180617.67284-1-kuniyu@amazon.com>
In-Reply-To: <20230605180617.67284-1-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Mon, 5 Jun 2023 20:52:04 +0200
Message-ID: <CANn89iKLiF7MLM5x4-M9CT+AFUUyx8vArUr9uwfLoUHk7GMp_A@mail.gmail.com>
Subject: Re: [PATCH v2 net] ipv6: rpl: Fix Route of Death.
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, David Ahern <dsahern@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 8:06=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> A remote DoS vulnerability of RPL Source Routing is assigned CVE-2023-215=
6.
>
> The Source Routing Header (SRH) has the following format:
>
>   0                   1                   2                   3
>   0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
>   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>   |  Next Header  |  Hdr Ext Len  | Routing Type  | Segments Left |
>   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>   | CmprI | CmprE |  Pad  |               Reserved                |
>   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>   |                                                               |
>   .                                                               .
>   .                        Addresses[1..n]                        .
>   .                                                               .
>   |                                                               |
>   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
>
> The originator of an SRH places the first hop's IPv6 address in the IPv6
> header's IPv6 Destination Address and the second hop's IPv6 address as
> the first address in Addresses[1..n].
>
> The CmprI and CmprE fields indicate the number of prefix octets that are
> shared with the IPv6 Destination Address.  When CmprI or CmprE is not 0,
> Addresses[1..n] are compressed as follows:
>
>   1..n-1 : (16 - CmprI) bytes
>        n : (16 - CmprE) bytes
>
> Segments Left indicates the number of route segments remaining.  When the
> value is not zero, the SRH is forwarded to the next hop.  Its address
> is extracted from Addresses[n - Segment Left + 1] and swapped with IPv6
> Destination Address.
>
> When Segment Left is greater than or equal to 2, the size of SRH is not
> changed because Addresses[1..n-1] are decompressed and recompressed with
> CmprI.
>
> OTOH, when Segment Left changes from 1 to 0, the new SRH could have a
> different size because Addresses[1..n-1] are decompressed with CmprI and
> recompressed with CmprE.
>
> Let's say CmprI is 15 and CmprE is 0.  When we receive SRH with Segment
> Left >=3D 2, Addresses[1..n-1] have 1 byte for each, and Addresses[n] has
> 16 bytes.  When Segment Left is 1, Addresses[1..n-1] is decompressed to
> 16 bytes and not recompressed.  Finally, the new SRH will need more room
> in the header, and the size is (16 - 1) * (n - 1) bytes.
>
> Here the max value of n is 255 as Segment Left is u8, so in the worst cas=
e,
> we have to allocate 3825 bytes in the skb headroom.  However, now we only
> allocate a small fixed buffer that is IPV6_RPL_SRH_WORST_SWAP_SIZE (16 + =
7
> bytes).  If the decompressed size overflows the room, skb_push() hits BUG=
()
> below [0].
>
> Instead of allocating the fixed buffer for every packet, let's allocate
> enough headroom only when we receive SRH with Segment Left 1.
>
> [0]:
>
> Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
> Reported-by: Max VA
> Closes: https://www.interruptlabs.co.uk/articles/linux-ipv6-route-of-deat=
h
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---
> To maintainers:
> Please complement the Reported-by address from the security@ mailing list
> if possible, which checkpatch will complain about.
>
> v2:
>   * Reload oldhdr@ after pskb_expand_head() (Eric Dumazet)
>

Reviewed-by: Eric Dumazet <edumazet@google.com>

