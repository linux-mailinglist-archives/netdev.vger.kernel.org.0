Return-Path: <netdev+bounces-306-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C617E6F6FA8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:13:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23FE2280D9A
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 16:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30DDFA940;
	Thu,  4 May 2023 16:13:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249753C0A
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 16:13:38 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901B959DB
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 09:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683216809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FCERTes3cUqeH2NVPYErrzXP04o1ceM5Rm63oz0hrwA=;
	b=T0NuVRqB3i+D2acfpbAuysJIjFR2JjMP9v0+kmnSJLAeNHhFawks18kKL2uUTXQIAIkRse
	11XbFFhopDe52xGsiORtT4Tkl0kEt/40y999hkFh2Z9lsmQTIgvxfoCsq5KLhSct9Bk3po
	Yb+e4UbnSuyUQHdsqVeQg/6dgsUWlAI=
Received: from mail-vk1-f198.google.com (mail-vk1-f198.google.com
 [209.85.221.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-187-bFEsOm49NCOBl49haEj2cQ-1; Thu, 04 May 2023 12:13:28 -0400
X-MC-Unique: bFEsOm49NCOBl49haEj2cQ-1
Received: by mail-vk1-f198.google.com with SMTP id 71dfb90a1353d-44fe5556165so16461e0c.0
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 09:13:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683216808; x=1685808808;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FCERTes3cUqeH2NVPYErrzXP04o1ceM5Rm63oz0hrwA=;
        b=kfONXTZZCvYnzk5CmXQzRmUVk5nXxTCK3lQgUxHs90mUJzwzsMFH0I8OdC/4nakSDx
         MLYCeQvoWFSIp/gYbrp7Bo4v/eGdZ3nfpvFQ6UoPzDRacAveWorhJLT6WTRwzeFlF7zE
         l2pHFwo5sHherLSaZBnbVavtjJYykHh4OiadSSAfaOElqRQKSrciRgYXIWS0yJBZyF2H
         8SXw2rlJRI60IKSWXCtWh3atU7Z08pSrX01P1dcFZsQvj6ssdZJPr+WaEBs6HrH+i2Ws
         DA/pirxCTogZ94zjWG7RA1KgohsFoM7tA7bgqU9ttU3Kyvu9EMN5wWwkVAsZndsV8o8w
         GQbA==
X-Gm-Message-State: AC+VfDyzLbm3DRqCYTYQsUOQ998fTrvQsv2hMQ1VRU/u9H9o+9ebBezJ
	Su2iRV62q0Q8W7I2RLgJGt7nKewVIBSTFdM8pjwp2i0xz+UMGrFrzWyB81lfo4CYm9N+xuiFoIU
	vgotD3lfiGv/YkAWw
X-Received: by 2002:a1f:b646:0:b0:448:1241:47ae with SMTP id g67-20020a1fb646000000b00448124147aemr3069410vkf.1.1683216807870;
        Thu, 04 May 2023 09:13:27 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6pUnL9fUfiStXzh1jo+rajlFzURLwzhhKGNCKNVHx6d9nP0QKmPVmXXzyvOtLVq7RYWk28Ew==
X-Received: by 2002:a1f:b646:0:b0:448:1241:47ae with SMTP id g67-20020a1fb646000000b00448124147aemr3069388vkf.1.1683216807461;
        Thu, 04 May 2023 09:13:27 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-79.dyn.eolo.it. [146.241.244.79])
        by smtp.gmail.com with ESMTPSA id 75-20020a370b4e000000b0074df3f7e14esm11694249qkl.67.2023.05.04.09.13.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 09:13:27 -0700 (PDT)
Message-ID: <11201df515ec41db88ad915fd1e425e62c4f81e5.camel@redhat.com>
Subject: Re: [PATCH LSM v2 0/2] security: SELinux/LSM label with MPTCP and
 accept
From: Paolo Abeni <pabeni@redhat.com>
To: Ondrej Mosnacek <omosnace@redhat.com>, Matthieu Baerts
	 <matthieu.baerts@tessares.net>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Stephen Smalley
 <stephen.smalley.work@gmail.com>, Eric Paris <eparis@parisplace.org>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 mptcp@lists.linux.dev,  linux-kernel@vger.kernel.org,
 netdev@vger.kernel.org,  linux-security-module@vger.kernel.org,
 selinux@vger.kernel.org
Date: Thu, 04 May 2023 18:13:23 +0200
In-Reply-To: <CAFqZXNt16B5A2o6fZeN5b1coNCW2m6kp7JToJFDorvPajhFyxA@mail.gmail.com>
References: 
	<20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-v2-0-e7a3c8c15676@tessares.net>
	 <CAFqZXNt16B5A2o6fZeN5b1coNCW2m6kp7JToJFDorvPajhFyxA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-05-04 at 16:14 +0200, Ondrej Mosnacek wrote:
> On Thu, Apr 20, 2023 at 7:17=E2=80=AFPM Matthieu Baerts
> <matthieu.baerts@tessares.net> wrote:
> >=20
> > In [1], Ondrej Mosnacek explained they discovered the (userspace-facing=
)
> > sockets returned by accept(2) when using MPTCP always end up with the
> > label representing the kernel (typically system_u:system_r:kernel_t:s0)=
,
> > while it would make more sense to inherit the context from the parent
> > socket (the one that is passed to accept(2)). Thanks to the
> > participation of Paul Moore in the discussions, modifications on MPTCP
> > side have started and the result is available here.
> >=20
> > Paolo Abeni worked hard to refactor the initialisation of the first
> > subflow of a listen socket. The first subflow allocation is no longer
> > done at the initialisation of the socket but later, when the connection
> > request is received or when requested by the userspace. This was a
> > prerequisite to proper support of SELinux/LSM labels with MPTCP and
> > accept. The last batch containing the commit ddb1a072f858 ("mptcp: move
> > first subflow allocation at mpc access time") [2] has been recently
> > accepted and applied in netdev/net-next repo [3].
> >=20
> > This series of 2 patches is based on top of the lsm/next branch. Despit=
e
> > the fact they depend on commits that are in netdev/net-next repo to
> > support the new feature, they can be applied in lsm/next without
> > creating conflicts with net-next or causing build issues. These two
> > patches on top of lsm/next still passes all the MPTCP-specific tests.
> > The only thing is that the new feature only works properly with the
> > patches that are on netdev/net-next. The tests with the new labels have
> > been done on top of them.
> >=20
> > Regarding the two patches, the first one introduces a new LSM hook
> > called from MPTCP side when creating a new subflow socket. This hook
> > allows the security module to relabel the subflow according to the owin=
g
> > process. The second one implements this new hook on the SELinux side.
> >=20
> > Link: https://lore.kernel.org/netdev/CAFqZXNs2LF-OoQBUiiSEyranJUXkPLcCf=
BkMkwFeM6qEwMKCTw@mail.gmail.com/ [1]
> > Link: https://git.kernel.org/netdev/net-next/c/ddb1a072f858 [2]
> > Link: https://lore.kernel.org/netdev/20230414-upstream-net-next-2023041=
4-mptcp-refactor-first-subflow-init-v1-0-04d177057eb9@tessares.net/ [3]
> > Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>
> > ---
> > Changes in v2:
> > - Address Paul's comments, see the notes on each patch
> > - Link to v1: https://lore.kernel.org/r/20230419-upstream-lsm-next-2023=
0419-mptcp-sublows-user-ctx-v1-0-9d4064cb0075@tessares.net
> >=20
> > ---
> > Paolo Abeni (2):
> >       security, lsm: Introduce security_mptcp_add_subflow()
> >       selinux: Implement mptcp_add_subflow hook
> >=20
> >  include/linux/lsm_hook_defs.h |  1 +
> >  include/linux/security.h      |  6 ++++++
> >  net/mptcp/subflow.c           |  6 ++++++
> >  security/security.c           | 17 +++++++++++++++++
> >  security/selinux/hooks.c      | 16 ++++++++++++++++
> >  security/selinux/netlabel.c   |  8 ++++++--
> >  6 files changed, 52 insertions(+), 2 deletions(-)
> > ---
> > base-commit: d82dcd9e21b77d338dc4875f3d4111f0db314a7c
> > change-id: 20230419-upstream-lsm-next-20230419-mptcp-sublows-user-ctx-e=
ee658fafcba
> >=20
> > Best regards,
> > --
> > Matthieu Baerts <matthieu.baerts@tessares.net>
> >=20
>=20
> I haven't yet looked closer at the code in this series, but I can at
> least confirm that with the series (applied on top of net-next) the
> selinux-testsuite now passes when run under mptcpize, with one caveat:
>=20
> The "client" test prog in the inet_socket subtest sets the SO_SNDTIMEO
> socket option on the client socket, but the subtest takes
> significantly longer to complete than when run without mptcpize. That
> suggests to me that there is possibly some (pre-existing) issue with
> MPTCP where the send/receive timeouts are not being passed to the
> subflow socket(s), leading to a longer wait (I guess the default is
> higher?)=C2=A0

Indeed the behavior you describe is due to some mptcp bug in handling
the SO_{SND,RCV}TIMEO socket tions, and it's really unrelated to the
initially reported selinux issue.

If you could file an issue on our tracker, that would help ;)

Thanks!

Paolo


