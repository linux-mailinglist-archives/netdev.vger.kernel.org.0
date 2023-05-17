Return-Path: <netdev+bounces-3373-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C24B5706B87
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 16:47:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0744A2813DD
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:47:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 024F428FC;
	Wed, 17 May 2023 14:47:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09991C26
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 14:47:51 +0000 (UTC)
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D94840C0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:47:50 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id d75a77b69052e-3f38a9918d1so151381cf.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 07:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684334869; x=1686926869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OjzkiJuPebppL5PHKEHl+YDr/Ar5GjBFc+tmVMn+Lxo=;
        b=E3MoMucUDhkzy7jFyOAvi1v7WnFXxqJfkjaffx8CLeDmKk+IU/CcmjSY3LKgjcX1WR
         4pctTT6ijfEJyG3RfIE/qHMseddKPlnSkSpyLLulm321uf78TSVodY+W6mgCvx/XBVyO
         Cz9QgpayJ71hTca9LBOfJRuihTI6WmccbfgCPQRcywudYebkPBK0L5zIxnCkxWq+s/Ka
         dm9YP/Y4EKR/lOJck1jCtac9siHq7bnDXERKp3ZFKYiJ1z8wZbJaoPQonRAJc72dcDap
         XZaZd2XsyyZ7lcT5NA9s0JMWOZV7OkvZ016HqoRUDqXVXRTjNhq//ldDYMO7Go8GrpkQ
         aMtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684334869; x=1686926869;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OjzkiJuPebppL5PHKEHl+YDr/Ar5GjBFc+tmVMn+Lxo=;
        b=byYaLCgl8SbcNqnhvDxnxa2c5tpcRwbsnfrTqXi5BcCU5RHzCrKKmXOukPsDTrj6QP
         cAWngtXZQRv27KzKf7ym9F7soh0C2kUu5w+yOGvp4rCtyI7HLrTWaqs6Dgixen/O7SUe
         kQAfZnVD2+hduwyLjc367T4DdbLgQwCUkxNs14N6A9gMyV5LFjWHWmstatNjVU2I6UZR
         y4WAyqLHsvt9nAyfYbxR3GKfdG8TH0gNUspEbJi2d5XA/fzkOqxzVfjuPUSpv2X8q1Xs
         QrD5laCVLjnq+9cEw6Vo8rrpNOFgqfy4FYx3cXxyTgCFTrHCLC+W0EuZCDLes6YsZ1GH
         7eDA==
X-Gm-Message-State: AC+VfDz5sm1Fh2K7eT1pAQpbDKIPPxibOySM7Y9ISiPZQH3pX3hgwLOt
	b3hsqE/EuA4QWgluG3cd+d5x0ge6tYZajfpkNfO5OA==
X-Google-Smtp-Source: ACHHUZ5nyLlmmBGkBSbb7f5BECxhRdBK/M+c+pSjlHRLb9R/Z2HILDZpRoJAwVabaSWO1dA6lrzH3b9qdQZ+84TFa68=
X-Received: by 2002:ac8:5c8c:0:b0:3e0:c2dd:fd29 with SMTP id
 r12-20020ac85c8c000000b003e0c2ddfd29mr435931qta.4.1684334869020; Wed, 17 May
 2023 07:47:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230517124201.441634-1-imagedong@tencent.com> <20230517124201.441634-4-imagedong@tencent.com>
In-Reply-To: <20230517124201.441634-4-imagedong@tencent.com>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 17 May 2023 16:47:38 +0200
Message-ID: <CANn89iKLf=V664AsUYC52h_q-xjEq9xC3KqTq8q+t262T91qVQ@mail.gmail.com>
Subject: Re: [PATCH net-next 3/3] net: tcp: handle window shrink properly
To: menglong8.dong@gmail.com
Cc: kuba@kernel.org, davem@davemloft.net, pabeni@redhat.com, 
	dsahern@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Menglong Dong <imagedong@tencent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 17, 2023 at 2:42=E2=80=AFPM <menglong8.dong@gmail.com> wrote:
>
> From: Menglong Dong <imagedong@tencent.com>
>
> Window shrink is not allowed and also not handled for now, but it's
> needed in some case.
>
> In the origin logic, 0 probe is triggered only when there is no any
> data in the retrans queue and the receive window can't hold the data
> of the 1th packet in the send queue.
>
> Now, let's change it and trigger the 0 probe in such cases:
>
> - if the retrans queue has data and the 1th packet in it is not within
> the receive window
> - no data in the retrans queue and the 1th packet in the send queue is
> out of the end of the receive window

Sorry, I do not understand.

Please provide packetdrill tests for new behavior like that.

Also, such fundamental change would need IETF discussion first.
We do not want linux to cause network collapses just because billions
of devices send more zero probes.

