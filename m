Return-Path: <netdev+bounces-8322-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31D3A723A07
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:43:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6B8561C20D85
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:43:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7552122627;
	Tue,  6 Jun 2023 07:43:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B902611C
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:43:51 +0000 (UTC)
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E93A2133
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 00:43:15 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-3f7359a3b78so50185e9.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 00:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686037392; x=1688629392;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YJBUgJzMxmaKZc/DYKCAnxSXkWETIyFkdIdcIwxmtdg=;
        b=67bIEnAVYA2ECeBtkkfC5hPwlwQRZC0wYd++NsqA/3dV8C4Rn6lWn6sUOZisLB1K1Q
         BN/Jol6J8qQOpfKEbYceL8mBqHcL1jt/faXuZ8ELo7iD+Uv63/3IxWdSC0akrRkZHgSg
         daHdnEu5V+Aa9u1FKaTYXhStSFB9b78air8YRK7Vu+oJ2IyuW/NwrxQTcIBFTta7Svkl
         /6xXGxMnRo69rvSGwW7aOK4C3UyyJf78225fHxCzPXunnfRQc4JEiWG4euN+977EIO4B
         vGY7hEVcKuyVIbVlKSsGnYSjTIBq+26TcKRjD0yJjySO06ODSqXt8eIdeM2lgWM33psW
         AWkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686037392; x=1688629392;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YJBUgJzMxmaKZc/DYKCAnxSXkWETIyFkdIdcIwxmtdg=;
        b=hLzAPDEzQM0FDzYEIAIOYVAB+g2bqk557UBNodUlvXZywn4063VXi9j3yKXdgsVlde
         VMYA62+wFi+mwuohyJCPX9slttjXIkQe2L78EfAGzqhCFW4pVVRUWIZ4U2ZLJDBhM3bs
         lS1kZNBB045iNTNuVSwdVaMPzdAqP/qOaBGgG0OtgN+LIu4kweTSlxEYqpAfaQH6DwbW
         NK3Ob1nLpK2QZ5579rVJ1NxSPpUkmZm5Fwfmcf2v5tka5uwny3PiychedpYaEM6zyqX0
         L34dQdxmJXZYbSES/96rtgFDlfv2NQV+aUZQyj0kuAhTFBIu7OvK0Tne0T5l+ns6gCIc
         snaw==
X-Gm-Message-State: AC+VfDz5L+BCD378JVwVs1DkRMOUuo59fUhe5hNQ99+kE0Mk121BV+oG
	eBClIBlziVXXjjFxXveEIWfNPMvvwL60Pk4uz9p2WrqexfL01XbnnEDJvg==
X-Google-Smtp-Source: ACHHUZ6PrdQC/kp4WyLpHsgueD8Uv55Y26nEKEqkPGSKwcyCZyzIaBzhMSY2vJOnsLlVx2Q9s6hLOHPq4DOFlC3Vl7k=
X-Received: by 2002:a05:600c:8088:b0:3f7:e463:a0d6 with SMTP id
 ew8-20020a05600c808800b003f7e463a0d6mr149833wmb.0.1686037392464; Tue, 06 Jun
 2023 00:43:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230602163141.2115187-1-edumazet@google.com> <20230602163141.2115187-2-edumazet@google.com>
 <20230605155253.1cedfdb0@kernel.org> <CANn89iKhSv981L-WHn=479U2XniQXU0qNX=yoAaWBA1LdY4B4g@mail.gmail.com>
In-Reply-To: <CANn89iKhSv981L-WHn=479U2XniQXU0qNX=yoAaWBA1LdY4B4g@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 6 Jun 2023 09:43:00 +0200
Message-ID: <CANn89iLcaNO8K14vC7o6WGTSSOtNpDgopWz0pT2r0LBpUSDFFQ@mail.gmail.com>
Subject: Re: [PATCH net 1/2] rfs: annotate lockless accesses to sk->sk_rxhash
To: Jakub Kicinski <kuba@kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org, 
	eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023 at 9:30=E2=80=AFAM Eric Dumazet <edumazet@google.com> w=
rote:
>
> On Tue, Jun 6, 2023 at 12:52=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> =
wrote:
> >
> > On Fri,  2 Jun 2023 16:31:40 +0000 Eric Dumazet wrote:
> > > +             if (sk->sk_state =3D=3D TCP_ESTABLISHED) {
> > > +                     /* This READ_ONCE() is paired with the WRITE_ON=
CE()
> > > +                      * from sock_rps_save_rxhash() and sock_rps_res=
et_rxhash().
> > > +                      */
> > > +                     sock_rps_record_flow_hash(READ_ONCE(sk->sk_rxha=
sh));
> > > +                     }
> >
> > Hi Eric, the series got "changes requested", a bit unclear why,
> > I'm guessing it's because it lacks Fixes tags.
> >
> > I also noticed that the closing bracket above looks misaligned.
>
> Right I think Simon gave this feedback.

Oops, that was Kuniyuki

Kuniyuki, do you mind adding your Reviewed-by: tag that I forgot to add ?

>
> >
> > Would you mind reposting? If you prefer not to add Fixes tag
> > a mention that it's intentional in the cover letter is enough.
>
> Yes, I do not think a Fixes: tag is necessary.

I added them, because why not ;)

