Return-Path: <netdev+bounces-8220-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id ACB6D72325D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 23:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51C152814B8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:38:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F8F27200;
	Mon,  5 Jun 2023 21:38:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A63CBE59
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 21:38:18 +0000 (UTC)
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF7810C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 14:38:16 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id d75a77b69052e-3f6c6320d4eso24421cf.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 14:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686001096; x=1688593096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8pmHAnFs6nRNaiIdWllqx3TmOWiTsKYGRIWFTlc4Tc=;
        b=ct3RBn6bMzjHK2v3Jdl4gsqO+G6uNOdSxat/bYv6Gr0OqXoWziZL7E/sE126WVA+5H
         7dzBgbK1j0G4FTS29plSLoBNAACimYThnBy29PO/WiT5t1EQj01glnc/YxDjoWRBo0L+
         /Q37KVx+YtDWPaH4B9iWnARo8cDtRgopImy642r56TN9+OFiQedATDU4w6fIMak/gYZW
         rmR4sKACPPh8M6QMmgDOXGTmYybXNk7yOPEd2nOOlmrvVLkrzgGQs6R8GskaMKnRVeWx
         SO3RNgZZ7Bt/+CfDewVfyC1GhArwrFtmxsk/cqRSMV+XLiG4uPbvqOw1SLRXC92s73Ca
         +GRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686001096; x=1688593096;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r8pmHAnFs6nRNaiIdWllqx3TmOWiTsKYGRIWFTlc4Tc=;
        b=agGQRZVKsvdbrRdq9bs4nNva0P9cRVjI2vqNw4BJhEC28nwCFvi4q+WRZJBWexCpqS
         VnicgsiwViB+LAcBKtx2haxBX5RJXAgSrYbqUAq7UOH+QzRbxghflL92Cd4YDqB9qY1u
         Ewz+jL+EDzX8qb5aISWT51x/xlZvJIYNgjNU7zlKcIil0NE+IK0/13LeBLhioD74kOI6
         ZC2vTMHLLFjJhFouNzW3YEuT/j5A8cnwwUMd9By49iW5eeuq5JPNBdIzy8PDX2unDsBG
         j7Om7vD4d9hgV89+eeyuIJOtlyUE4Q7nBmirZbntHcSd9BbNivvTm1ZIacRqzoH5iEeg
         kVmw==
X-Gm-Message-State: AC+VfDzi4a05H/kHpu0Ti52bQOnZTzyuAjSagA+bd5QMW30/slKDPdWt
	95TzptYIHhfhxB9CwjjRez8Hcirz8OYztKH1HaDB2AGoRU/S91fRpH9ciE5w
X-Google-Smtp-Source: ACHHUZ5v3l/Hk2q/JN1PXzfRrMtZk7AYEfLnuQ/NzSMu0xLPdG5yrgDIxuiSeDPa48W/7sIIH3yivW/Ju041++ycbug=
X-Received: by 2002:a05:622a:a:b0:3f8:8c06:c53b with SMTP id
 x10-20020a05622a000a00b003f88c06c53bmr66658qtw.0.1686001095748; Mon, 05 Jun
 2023 14:38:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
 <20230605110654.809655-1-maze@google.com> <ZH3cN8IIJ1fhlsUW@corigine.com>
In-Reply-To: <ZH3cN8IIJ1fhlsUW@corigine.com>
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date: Tue, 6 Jun 2023 06:38:04 +0900
Message-ID: <CANP3RGfWATmOzb4=DXb=+K7iij4HPBp0Uq79r0NjxGyvAaKNgA@mail.gmail.com>
Subject: Re: [PATCH v2] xfrm: fix inbound ipv4/udp/esp packets to UDPv6
 dualstack sockets
To: Simon Horman <simon.horman@corigine.com>
Cc: Linux Network Development Mailing List <netdev@vger.kernel.org>, Sabrina Dubroca <sd@queasysnail.net>, 
	Steffen Klassert <steffen.klassert@secunet.com>, Jakub Kicinski <kuba@kernel.org>, 
	Benedict Wong <benedictwong@google.com>, Yan Yan <evitayan@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 9:59=E2=80=AFPM Simon Horman <simon.horman@corigine.=
com> wrote:
> Hi Maciej,
>
> Does the opposite case also need to be handled in xfrm4_udp_encap_rcv()?

I believe the answer is no:
- ipv4 (AF_INET) sockets only ever receive (native) ipv4 traffic.
- ipv6 (AF_INET6) ipv6-only sockets only ever receive (native) ipv6 traffic=
.
- ipv6 (AF_INET6) dualstack (ie. not ipv6-only) sockets can receive
both (native) ipv4 and (native) ipv6 traffic.

Ipv6 dualstack sockets map the ipv4 address space into the IPv6
"IPv4-mapped" range of ::ffff:0.0.0.0/96,
ie. 1.2.3.4 -> ::ffff:1.2.3.4 aka ::ffff:0102:0304

Whether ipv6 sockets default to dualstack or not is controlled by a
sysctl (net.ipv6.bindv6only - not entirely well named, it actually
affects the socket() system call, and bind() only as a later
consequence of that, it thus does also affect whether connect() to
ipv4 mapped addresses works or not), but can also be toggled manually
via IPV6_V6ONLY socket option.

Basically a dualstack ipv6 socket is a more-or-less drop-in
replacement for ipv4 sockets (*entirely* so for TCP/UDP, and likely
SCTP, DCCP & UDPLITE, though I think there might be some edge cases
like ICMP sockets or RAW sockets that do need AF_INET - any such
exceptions should probably be considered kernel bugs / missing
features -> hence this patch).

---

I believe we don't need to test the sk for:
  !ipv6_only_sock(sk), ie. !sk->sk_ipv6only
before we do the dispatch to the v4 code path,
because if the socket is ipv6-only then there should [IMHO/AFAICT] be
no way for ipv4 packets to arrive here in the first place.

---

Note: I can guarantee the currently existing code is wrong,
both because we've experimentally discovered AF_INET6 dualstack
sockets don't work for v4,
and because the code obviously tries to read payload length from the
ipv6 header,
which of course doesn't exist for skb->protocol ETH_P_IP packets.

However, I'm still not entirely sure this patch is 100% bug free...
though it seems straightforward enough...

---

I'll hold off on re-spinning for the ' -> " unless there's other comments.

