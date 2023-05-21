Return-Path: <netdev+bounces-4115-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F74C70AF1A
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 19:05:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31DE9280DEB
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 17:05:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AD0963D0;
	Sun, 21 May 2023 17:05:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECCAE10E8
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 17:05:50 +0000 (UTC)
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7007E58
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 10:05:48 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id 5b1f17b1804b1-3f601283b36so10435e9.0
        for <netdev@vger.kernel.org>; Sun, 21 May 2023 10:05:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684688747; x=1687280747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KKX3ZQWaEj9Uv3BB4WZP8A7jJdsXoyLgkgZA40uLXVI=;
        b=c+vcvumyHo+iBlo09eCn18E8pP8xZm0WeryPARecWSkt34pnGZur9xZz0oVZoqZ6j7
         z/RmGJxVgahvmI+feoMtgk6GIT2A/eVeW0RYG5Dg6GjhIA2Vz5P2Y+HBtU+CoNOoDSFb
         OVl9QmQ/tvCcctShesMM3Ha6HOuer4ODZwy9Gzg7TmGZhH/3h75xwYVBDPCb6uwCZyLE
         COzwoZJvoMti89sZGxaWpZIotZIbHYlLIc7S06V2Rq+a3+AxxfTKCAeSvWnz0wPC+haR
         fK/MdZAhC87J2uPY2FvbnV+0bUSqukvQCLn/uefApvyZoMHVKQTm1vtdl8MC61jpMi4B
         /6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684688747; x=1687280747;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KKX3ZQWaEj9Uv3BB4WZP8A7jJdsXoyLgkgZA40uLXVI=;
        b=CEZnVZ1hz5gBK7E85RJ3ikn2qOur65fDgR6ovpvh8A2VbjC1xgHgUyhWr6MNXB91yr
         ZMjGQqmuhKwdhcBYzcksjwb//D2QPd0JKOVVB/z081avGOHbo0hThz5hpz7n2Nc1jfml
         QGzkaml937KJUZyeqnCoXKtTQFUEfGvpBPO8DJhZ+CFbICPINU5bVVHkUSB2Ja86zudm
         DIdnE3c6nqIEZ7YEIzC6PQeQLtnl0WprBPubgblZFeswSieFW4yQmphsz6mbVJjNvW+G
         njdcVAgRpyIai9DUXJMF21Bu0kMD/gb+k11z9Li2KgkdJvQGoW5f7zBPNeefAtKn58kp
         3Pmw==
X-Gm-Message-State: AC+VfDz1n2PgqYqyPiO6/BVrwkEvdrquWTt5WPJoKr/1vNS8Y92gw0g5
	9qfZlq6neXy4eu4iagmrFH96e4Om8XHwQsNEN93epg==
X-Google-Smtp-Source: ACHHUZ4WDSC6tChHcPUA3b1thlZLRQuOQAXPzXcDE9lA+gQ1hEq0B/iy5GP+bNr315BdLgXOYyKoXsuQEuoeuqG26xM=
X-Received: by 2002:a05:600c:3d97:b0:3f4:fe69:2dca with SMTP id
 bi23-20020a05600c3d9700b003f4fe692dcamr508682wmb.7.1684688747026; Sun, 21 May
 2023 10:05:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517213118.3389898-1-edumazet@google.com> <CAK-6q+g+Uzt5YYYGSPzDmjeg_gWJpqmEpnhqZdjyFvABkBB9fA@mail.gmail.com>
In-Reply-To: <CAK-6q+g+Uzt5YYYGSPzDmjeg_gWJpqmEpnhqZdjyFvABkBB9fA@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Sun, 21 May 2023 19:05:35 +0200
Message-ID: <CANn89iJB0k7+QSqgLwLuKqxBObLdzXfS14UNvi_jSNo_a5nQLg@mail.gmail.com>
Subject: Re: [PATCH net 0/3] ipv6: exthdrs: fix three SRH issues
To: Alexander Aring <aahringo@redhat.com>
Cc: "David S . Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Alexander Aring <alex.aring@gmail.com>, 
	David Lebrun <david.lebrun@uclouvain.be>, netdev@vger.kernel.org, eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 3:53=E2=80=AFAM Alexander Aring <aahringo@redhat.co=
m> wrote:
>
> Hi,
>
> On Wed, May 17, 2023 at 5:31=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > While looking at a related CVE, I found three problems worth fixing
> > in ipv6_rpl_srh_rcv() and ipv6_srh_rcv().
>
> thanks, for looking into it. I got some reproducers for the CVE (I
> hope we are talking about the same one), I believe it has something to
> do with what Jakub already pointed out. It's about
> IPV6_RPL_SRH_WORST_SWAP_SIZE [0] is not correct, if the last address
> in the segment address array is completely different than all other
> segment addresses the source header will grow a lot, about (number of
> segment addresses * sizeof(struct in6_addr)). Maybe there can be more
> intelligent ways to find the right number here... however I tried to
> change it without success to fix the problem. :-/

Hmmm... this patch series fixes other generic issues.

I have not claimed to solve this CVE yet.

