Return-Path: <netdev+bounces-5091-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5DC5770FA45
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 17:35:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 244F81C20E66
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:35:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01AAC19BA7;
	Wed, 24 May 2023 15:34:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA01A19BA0
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 15:34:22 +0000 (UTC)
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFE4219D
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:33:54 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id 71dfb90a1353d-457201c47f6so414147e0c.1
        for <netdev@vger.kernel.org>; Wed, 24 May 2023 08:33:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684942431; x=1687534431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FpurOHV7oeQhldeavKospxkqzWYZtVkv9zcnQob8kDw=;
        b=dveUQJyyiWWwr7dm5X6iq7guR4ZKuciesprJD7kFcuEYCYn+Uqj+MVLJrMj9Gce2Bs
         jpF05ZCSuTJjfd5zr8FJiKXwKEwLZCyYIiPJcZxqL+cuaGMUm/Hr7fpXH3mOJpPk7aWx
         wf6EEMA3wy1eXou0OvE6Jez7LqXFkGxCeELPs6Pwivl+qwl3t2a8mC53oIs6O2lkaJj8
         Dm4VUuLmV/jCbqT8InKMftnQfkusBlRQclqeatC3E2atZZRAny3HQjvX7XsPC1WEA0Jp
         /ZxnTHDwasbo21HAukZ+y7WycgTRRkl5xXVECEMXRdJnau0lA6t6/4Blbw5cw7pxnmLJ
         wz2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684942431; x=1687534431;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FpurOHV7oeQhldeavKospxkqzWYZtVkv9zcnQob8kDw=;
        b=SgHjPzipkeDZw0tfo87E4W9LoA7nyo3b9Qe0RyRo0pYaqF3VBbUYDsCrsEhK1eejKl
         Z5jt87Lyl2k8ezgnkdiG+Mc7v1APrflRRKn3OV+G/an5xgwVE4tnfhfVCTXciXsCO+FY
         yXMTtAplbPKuIpHZQfyGwEZhuFjvrbQ9eCM0cHe7JkUq4Vtx1+vRqXcrNYu9mq4MQ8On
         Um6waYzYo2328xmZ/pSAZiiAHhK8RBw6xjYqbQVwAXDTb7TFKghW5baoEVHdRsg56zDk
         J6CIIfqvuPPYmGIHozFbAMkfudpglmAXlOPv4572tEkD71zcPB4+mcSFNl+DHQGD6+AK
         tTCA==
X-Gm-Message-State: AC+VfDxQIfqhGtLWlIuamzOwM2ls4zQxKqHjDJJBb3VD0gDXsVPy89D1
	vpo5PZxJ0crl+0iKqKYiUXBRBi4Gra0yPlotp2A=
X-Google-Smtp-Source: ACHHUZ6s//nJDkfKpoNLXz3kKpEAq0noO8BBq+fWg79OjPi/ZnllcrAACK60/844CqBsM0fIVCJe05A1la1cLW6bAdw=
X-Received: by 2002:a1f:4944:0:b0:443:de44:6118 with SMTP id
 w65-20020a1f4944000000b00443de446118mr5468854vka.14.1684942431434; Wed, 24
 May 2023 08:33:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230522141335.22536-1-louis.peens@corigine.com>
 <beea9ce517bf597fb7af13a39a53bb1f47e646d4.camel@redhat.com>
 <20230523142005.3c5cc655@kernel.org> <ZG31Plb6/UF3XKd3@corigine.com> <20230524082216.1e1fed93@kernel.org>
In-Reply-To: <20230524082216.1e1fed93@kernel.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 24 May 2023 11:33:15 -0400
Message-ID: <CAF=yD-JH2NHTXCg-Z=cUw-JK0g9Y9pb-pcyboq5AkES+ohShkg@mail.gmail.com>
Subject: Re: [PATCH net-next] nfp: add L4 RSS hashing on UDP traffic
To: Jakub Kicinski <kuba@kernel.org>
Cc: Simon Horman <simon.horman@corigine.com>, Paolo Abeni <pabeni@redhat.com>, 
	Louis Peens <louis.peens@corigine.com>, David Miller <davem@davemloft.net>, netdev@vger.kernel.org, 
	oss-drivers@corigine.com, Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 11:22=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> w=
rote:
>
> On Wed, 24 May 2023 13:30:06 +0200 Simon Horman wrote:
> > On Tue, May 23, 2023 at 02:20:05PM -0700, Jakub Kicinski wrote:
> > > Yup, that's the exact reason it was disabled by default, FWIW.
> > >
> > > The Microsoft spec is not crystal clear on how to handles this:
> > > https://learn.microsoft.com/en-us/windows-hardware/drivers/network/rs=
s-hashing-types#ndis_hash_ipv4
> > > There is a note saying:
> > >
> > >   If a NIC receives a packet that has both IP and TCP headers,
> > >   NDIS_HASH_TCP_IPV4 should not always be used. In the case of a
> > >   fragmented IP packet, NDIS_HASH_IPV4 must be used. This includes
> > >   the first fragment which contains both IP and TCP headers.
> > >
> > > While NDIS_HASH_UDP_IPV4 makes no such distinction and talks only abo=
ut
> > > "presence" of the header.
> > >
> > > Maybe we should document that device is expected not to use the UDP
> > > header if MF is set?
> >
> > Yes, maybe.
> >
> > Could you suggest where such documentation should go?
>
> That's the hardest question, perhaps :)
>
> Documentation/networking/scaling.rst and/or OCP NIC spec:
>
> https://ocp-all.groups.io/g/OCP-Networking/topic/nic_software_core_offloa=
ds/98930671?p=3D,,,20,0,0,0::recentpostdate/sticky,,,20,2,0,98930671,previd=
%3D1684255676674808204,nextid%3D1676673801962532335&previd=3D16842556766748=
08204&nextid=3D1676673801962532335

The OCP draft spec already has this wording, which covers UDP:

"RSS defines two rules to derive queue selection input in a
flow-affine manner from packet headers. Selected fields of the headers
are extracted and concatenated into a byte array. If the packet is
IPv4 or IPv6, not fragmented, and followed by a transport layer
protocol with ports, such as TCP and UDP, then extract the
concatenated 4-field byte array { source address, destination address,
source port, destination port }. Else, if the packet is IPv4 or IPv6,
extract 2-field byte array { source address, destination address }.
IPv4 packets are considered fragmented if the more fragments bit is
set or the fragment offset field is non-zero."

Non google docs version:
https://www.opencompute.org/w/index.php?title=3DCore_Offloads

