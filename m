Return-Path: <netdev+bounces-8432-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA42C7240A4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 13:15:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12F4C1C20E8F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:15:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97F915ACD;
	Tue,  6 Jun 2023 11:15:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E71C12B9F
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 11:15:09 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 361C91A7
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 04:15:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686050106;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6nOtaiNjzF/2l30khHz4vnxWHOiGMg6bW5+m2iJbioI=;
	b=SodU1De44BmTh8R4OoQmxYLF2p0yCGJVkmps04XMUqyj2ZCnWq3C+UFfsIPJyAaJ1yG/KL
	OivtShQXlUvl5hlTMH8yKZP1+KihUuBOndbGiZQJ3Tlz46PZk6qVJYVJhG6YzNwOEoFx+l
	bJDBtbrPwYuwm+VJ6zMmbHWhn9LX2Fc=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-672-pdEHc0ODPoOPWkH6ZMhONA-1; Tue, 06 Jun 2023 07:15:05 -0400
X-MC-Unique: pdEHc0ODPoOPWkH6ZMhONA-1
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-75eb82ada06so50523585a.1
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 04:15:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686050104; x=1688642104;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6nOtaiNjzF/2l30khHz4vnxWHOiGMg6bW5+m2iJbioI=;
        b=HBevyDiAIFp8qs2nMISadJt1ETmngS6+w6DpdvPDzCXclsn1Lb5VWxXJ4RSPr8MXvb
         u5B+vs/gA7Nf8RIbZAvqWQKMWxKNDj5vTVqnX/4VS4IDGcVewhJyWuSsLtlrjkJuCvHK
         B9c5Ib+/Kgyv1wQ4UYGYZwNtdWcRSGgQ4wn6b53BwdQZFGUuBQJ6XPpLnW8q5tisbKO3
         Gmj/6aMuMh0qPZmJuy1Dp1osZtSkV8vlDiJfhVEJ/E0SHqXpBDs8FdH/04LUoqIt8cw/
         NAkSF9MHbiqXXpmh72qY+orgLbpWgkHKqaqqpBXV9vGgGsLSqzXbOtzduOr0DZzVNR76
         kXCw==
X-Gm-Message-State: AC+VfDwmRRDtqlZTXPErSQoq0DVOYzDLx3Ex71lkky7jqyqp921pJe0H
	tmrzTFbpRbhsssyLAEGPRZ9tk67DooPXT11UKziDgicFWbGZdtRijN4kXwKS/GeqC9qNPpSZHgu
	UNtogAc/EdMdLQlMq
X-Received: by 2002:a05:620a:6185:b0:75b:23a1:69e7 with SMTP id or5-20020a05620a618500b0075b23a169e7mr1655419qkn.7.1686050104804;
        Tue, 06 Jun 2023 04:15:04 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6tP19Lhtynb9dSrzqdwWnladOfHbnmEns3mricCewylxpVi4WpSIaM1grItcgS6vd5GoRInw==
X-Received: by 2002:a05:620a:6185:b0:75b:23a1:69e7 with SMTP id or5-20020a05620a618500b0075b23a169e7mr1655392qkn.7.1686050104521;
        Tue, 06 Jun 2023 04:15:04 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-89.dyn.eolo.it. [146.241.114.89])
        by smtp.gmail.com with ESMTPSA id s15-20020a05620a16af00b00746b2ca65edsm4815385qkj.75.2023.06.06.04.15.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 04:15:04 -0700 (PDT)
Message-ID: <c39cfc3f3113ebc30f08ea87781e9a81b0153d94.camel@redhat.com>
Subject: Re: [PATCH] net: liquidio: fix mixed module-builtin object
From: Paolo Abeni <pabeni@redhat.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Jakub Kicinski
 <kuba@kernel.org>,  "David S . Miller" <davem@davemloft.net>,
 netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Derek Chickles <dchickles@marvell.com>, 
 Satanand Burla <sburla@marvell.com>, Felix Manlunas
 <fmanlunas@marvell.com>, Eric Dumazet <edumazet@google.com>,  Nick Terrell
 <terrelln@fb.com>
Date: Tue, 06 Jun 2023 13:15:00 +0200
In-Reply-To: <20230604043213.901341-1-masahiroy@kernel.org>
References: <20230604043213.901341-1-masahiroy@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Sun, 2023-06-04 at 13:32 +0900, Masahiro Yamada wrote:
> With CONFIG_LIQUIDIO=3Dm and CONFIG_LIQUIDIO_VF=3Dy (or vice versa),
> $(common-objs) are linked to a module and also to vmlinux even though
> the expected CFLAGS are different between builtins and modules.
>=20
> This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
> Fixing mixed module-builtin objects").
>=20
> Introduce the new module, liquidio-core, to provide the common functions
> to liquidio and liquidio-vf.
>=20
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

This does not build with allmodconfig:

ERROR: modpost: "lio_get_state_string" [drivers/net/ethernet/cavium/liquidi=
o/liquidio.ko] undefined!
ERROR: modpost: "lio_get_state_string" [drivers/net/ethernet/cavium/liquidi=
o/liquidio_vf.ko] undefined!

Please, when you repost include the 'net-next' tag into the subj.

Thanks!

Paolo


