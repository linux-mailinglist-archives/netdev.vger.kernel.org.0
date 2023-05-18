Return-Path: <netdev+bounces-3480-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 16BF17077B1
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 03:53:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C6D9C281706
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 01:53:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 327FF383;
	Thu, 18 May 2023 01:53:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23ED27E
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 01:53:29 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288C826BC
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 18:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684374804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Levp5Wb7xf8IK+J6W6/w4Rr+TDXGqmJROfqF5Yq3+Lg=;
	b=QCysmk0TU73U0bajHEVK3gFpHtSy8SyxDuJGklZ/ylNooQ9PPQV0S7hhO5yCkmtf9NTouU
	kejwJJbVx/83rXOiIUQwRKdBT6/9RfIB9lGechvhdqFANJ/Vwlmx+S7sIbCnp9e984SqvJ
	wwqGvIW70qx0HIWLwqAhELQIAFJatDc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-4Xb__4y2PHaug34Vqv3dsw-1; Wed, 17 May 2023 21:53:23 -0400
X-MC-Unique: 4Xb__4y2PHaug34Vqv3dsw-1
Received: by mail-ed1-f69.google.com with SMTP id 4fb4d7f45d1cf-506b21104faso1806070a12.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 18:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684374802; x=1686966802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Levp5Wb7xf8IK+J6W6/w4Rr+TDXGqmJROfqF5Yq3+Lg=;
        b=d8fiE0YqKNWbD1FpFch2EGtOixxro/B/5n+BnbuK1c4CU4YNw+C0U8qD7LSY7Byozv
         5vli4IdWf4xlWYlW4ZGYmkIA6uAiR8+7cKBCSdK/xA5651o9kQUTAs2QQGGthjs++GuC
         twE/aEasTyXMHAKj6jyxEzJUDlg8G3PbmDYdfjaIbED+OH0uMgV8LhAynsQJfQbZAx5P
         2kI6FiNrhURq9/6u1PxeC3wcAZhwlRYbgiya/MVrKfCnXoGrlpx73PWEC9vvsGM9HsDj
         /FWuCvLwNiEuM3oGuKDh2wD6vvUX9Qn3R+9TvdqRDsnX/ZyD+B8qZT7L28RJ/CO3n6Zt
         BAOA==
X-Gm-Message-State: AC+VfDxe4HL4aZaoETYZupQDgypNypLTZ3UwoeQq6jBIfMFU1MA6RLZo
	xUAsNYN2UEimQDq4Z75s8+bIeYmbOqD2e6BctzKIBeEV0rRykqpkPVoL0d6KIgJ7PQ1Y7PzZ2F4
	F6DJSCKkUvyWqC7kut5HoSOMIEGs0Gr04
X-Received: by 2002:aa7:df12:0:b0:506:83fc:2dab with SMTP id c18-20020aa7df12000000b0050683fc2dabmr3522179edy.22.1684374801906;
        Wed, 17 May 2023 18:53:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5H0V0s/GZCK+LvT57aZXD3eWvL6yL9sYX40battg6pNVyrZCozTB1FKjTWBoWln2n2OZsqzg95q/rQlzXjyPk=
X-Received: by 2002:aa7:df12:0:b0:506:83fc:2dab with SMTP id
 c18-20020aa7df12000000b0050683fc2dabmr3522166edy.22.1684374801679; Wed, 17
 May 2023 18:53:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517213118.3389898-1-edumazet@google.com>
In-Reply-To: <20230517213118.3389898-1-edumazet@google.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 17 May 2023 21:53:10 -0400
Message-ID: <CAK-6q+g+Uzt5YYYGSPzDmjeg_gWJpqmEpnhqZdjyFvABkBB9fA@mail.gmail.com>
Subject: Re: [PATCH net 0/3] ipv6: exthdrs: fix three SRH issues
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Alexander Aring <alex.aring@gmail.com>, 
	David Lebrun <david.lebrun@uclouvain.be>, netdev@vger.kernel.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

On Wed, May 17, 2023 at 5:31=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> While looking at a related CVE, I found three problems worth fixing
> in ipv6_rpl_srh_rcv() and ipv6_srh_rcv().

thanks, for looking into it. I got some reproducers for the CVE (I
hope we are talking about the same one), I believe it has something to
do with what Jakub already pointed out. It's about
IPV6_RPL_SRH_WORST_SWAP_SIZE [0] is not correct, if the last address
in the segment address array is completely different than all other
segment addresses the source header will grow a lot, about (number of
segment addresses * sizeof(struct in6_addr)). Maybe there can be more
intelligent ways to find the right number here... however I tried to
change it without success to fix the problem. :-/

- Alex

[0] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree=
/net/ipv6/exthdrs.c?h=3Dv6.4-rc2#n572


