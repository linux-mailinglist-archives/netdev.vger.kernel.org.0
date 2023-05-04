Return-Path: <netdev+bounces-260-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ED8E76F67A2
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 10:39:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB8101C20AD5
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 08:39:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8243D1868;
	Thu,  4 May 2023 08:39:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D10AA2C
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 08:39:22 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D31CBE7A
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 01:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683189560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=INYaaqVV+iPSrw1NQ/6kl5OwX7QcM6hN4CveZ5dBJV4=;
	b=Lc1wt4ue5bIrM472FSAVaFMPAsBIVj5LfpjPZLg+25kQHTgTceLkyoKVdc8NR2TyrKzIJI
	bQ688hHefibPW/GJRbwNW+ZJ8JEeoicv39Z+oYft8rin2xl+3wOrW4k9a+i71B10OC/ACU
	zRSq5cL+QJSJCcBZ9rXaEu6ay/TTX9Q=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-PTyCxpZrOoSGyBmQjYi2lQ-1; Thu, 04 May 2023 04:39:19 -0400
X-MC-Unique: PTyCxpZrOoSGyBmQjYi2lQ-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f40015b0cdso274745e9.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 01:39:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683189557; x=1685781557;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=INYaaqVV+iPSrw1NQ/6kl5OwX7QcM6hN4CveZ5dBJV4=;
        b=TIeYV6KYbiUmoF6CMTD0cuyU1zhKvuiKx+WP7DOJOCNzL3gNUM7waoPjUd/blwu7dD
         4zQAUxZlsRI06F+f1ZJZmBSJ0jO2TgCy2SHtzlkylkYVS7HFoZap8Xtshdan+Xgx2dNZ
         /Y4QU7hV8WBChgW1zkQMj2RqIu2fIpxe/eHWkjbQhXbg8pWHOSJN7rigENKr071wBXOB
         XtT8+uAzod+OZz50EIEJYyrTeWVrcHqOqwFmiUbzc6uzWsdyYynZEfXRxQHBmEC7kR83
         QEzosx6uAn/UozXbKp6Va0+vJ0PM6tCad6tQLT3Bt9wujazsYxtWoXDw/nBH52qg+6z9
         a8oA==
X-Gm-Message-State: AC+VfDzl5hvILeS8ZQOR55bpW7VTrYbbx73+iu/l4mLSfkNbv4nHLDqC
	mqVsiwnqfaV1ebzobbYNl73y4bL5Lo1osBSiuwlvOjNyaiW/8XEIN7joAwYl9nnvccguaCtP3mD
	zuE9mAY6roQeZUVLKyS5pbqGJ
X-Received: by 2002:a05:600c:1d1d:b0:3f1:960d:68ce with SMTP id l29-20020a05600c1d1d00b003f1960d68cemr6382728wms.3.1683189557745;
        Thu, 04 May 2023 01:39:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5VRVn8F0Qf6Zzh4enTR3Wsl53smspYdxk9NDQ9ZGUE0+4YJQtATz33QmgBHplD7Dnbl4KbPA==
X-Received: by 2002:a05:600c:1d1d:b0:3f1:960d:68ce with SMTP id l29-20020a05600c1d1d00b003f1960d68cemr6382713wms.3.1683189557397;
        Thu, 04 May 2023 01:39:17 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-244-79.dyn.eolo.it. [146.241.244.79])
        by smtp.gmail.com with ESMTPSA id k12-20020a7bc40c000000b003f175b360e5sm4192854wmi.0.2023.05.04.01.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 01:39:16 -0700 (PDT)
Message-ID: <2ef3a60fc3ec47993801bdaf7486fba615072c44.camel@redhat.com>
Subject: Re: [PATCH v2] net: ipconfig: Allow DNS to be overwritten by DHCPACK
From: Paolo Abeni <pabeni@redhat.com>
To: Martin Wetterwald <martin@wetterwald.eu>, Jakub Kicinski
 <kuba@kernel.org>
Cc: davem@davemloft.net, dsahern@kernel.org, netdev@vger.kernel.org
Date: Thu, 04 May 2023 10:39:15 +0200
In-Reply-To: <CAFERDQ3hgA490w2zWmiDQu-HfA-DLWWkL4s8z4iZAPwPZvw=LA@mail.gmail.com>
References: 
	<CAFERDQ1yq=jBGu8e2qJeoNFYmKt4jeB835efsYMxGLbLf4cfbQ@mail.gmail.com>
	 <20230503195112.23adbe7b@kernel.org>
	 <CAFERDQ3hgA490w2zWmiDQu-HfA-DLWWkL4s8z4iZAPwPZvw=LA@mail.gmail.com>
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
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, 2023-05-04 at 10:00 +0200, Martin Wetterwald wrote:
> Some DHCP server implementations only send the important requested DHCP
> options in the final BOOTP reply (DHCPACK).
> One example is systemd-networkd.
> However, RFC2131, in section 4.3.1 states:
>=20
> > The server MUST return to the client:
> > [...]
> > o Parameters requested by the client, according to the following
> >   rules:
> >=20
> >      -- IF the server has been explicitly configured with a default
> >         value for the parameter, the server MUST include that value
> >         in an appropriate option in the 'option' field, ELSE
>=20
> I've reported the issue here:
> https://github.com/systemd/systemd/issues/27471
>=20
> Linux PNP DHCP client implementation only takes into account the DNS
> servers received in the first BOOTP reply (DHCPOFFER).
> This usually isn't an issue as servers are required to put the same
> values in the DHCPOFFER and DHCPACK.
> However, RFC2131, in section 4.3.2 states:
>=20
> > Any configuration parameters in the DHCPACK message SHOULD NOT
> > conflict with those in the earlier DHCPOFFER message to which the
> > client is responding.  The client SHOULD use the parameters in the
> > DHCPACK message for configuration.
>=20
> When making Linux PNP DHCP client (cmdline ip=3Ddhcp) interact with
> systemd-networkd DHCP server, an interesting "protocol misunderstanding"
> happens:
> Because DNS servers were only specified in the DHCPACK and not in the
> DHCPOFFER, Linux will not catch the correct DNS servers: in the first
> BOOTP reply (DHCPOFFER), it sees that there is no DNS, and sets as
> fallback the IP of the DHCP server itself. When the second BOOTP reply
> comes (DHCPACK), it's already too late: the kernel will not overwrite
> the fallback setting it has set previously.
>=20
> This patch makes the kernel overwrite its fallback DNS by DNS servers
> specified in the DHCPACK if any.

As strictly speaking this looks like a change of behavior more than a
fix, I think it should land on net-next so it needs to wait for net-
next to open, see below.

There are a few issues to be addresses. The patch is mangled - context
lines are truncated to 80 bytes, corrupting the patch itself. Please
double check your setup to solve such issue.

Please specify the target tree inside the patch subj.

Please do not reply with new version of this patch inside the same
thread.
=09
## Form letter - net-next-closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after May 8th.

RFC patches sent for review only are obviously welcome at any time.

See:
https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#develop=
ment-cycle

Cheers,

Paolo


