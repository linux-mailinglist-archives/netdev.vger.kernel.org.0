Return-Path: <netdev+bounces-6465-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A20F4716636
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 17:08:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 428161C20C88
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFAAD23C9F;
	Tue, 30 May 2023 15:08:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14FD17AD4
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 15:08:00 +0000 (UTC)
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BDB1A8
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:07:20 -0700 (PDT)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-19f8af9aa34so823180fac.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 08:07:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685459193; x=1688051193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+X3IIaYBVJ1dKxoXnwhc3sBH0g3Lhf5JcdDSRWmgXw=;
        b=DOyRpfgynGVQv2vYMjmcQoln2KhJaALKbE1Un4OFubLmlrR63Q7U/Yq+d5r/Ok0crG
         4b+mnuBNGkaozK2mMOGgb3tbrfLPlZLzFS6K8G49jc9cDV4DlhNFdPoKh9Qn30YJJT5x
         6OwsGPrTbKQHmuQIXDXKunkXCiTTHe75fXeHQYBIW4aX0+ljkIFrqxw/uTHhIIskIP4s
         687iCEe8TiQS1PWAjN/NDxMRLQ16iiKhiuR/fYF8rIxE54aeSllU2FVhH9mF/2udmAvI
         Lw96UoSBI32iq72vzKFX5ElyGJsYWJWc2IkGoIl4v8DylYKq2eRaHGY7QMj+BJOZc0fA
         Q6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685459193; x=1688051193;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p+X3IIaYBVJ1dKxoXnwhc3sBH0g3Lhf5JcdDSRWmgXw=;
        b=bRgJkDDpn4PAh+KAGt1S7+Wbrs2Cl7m/fztQPpp0E2TTsGTIuiLwPV6iPdqtEiKoP9
         qi4ICu5Kf58QrXodSSN07WD6RD676y1cICHmF3TxbQMHBATn4ZG0qeFFOnSoF30hUQn6
         4DLJCh3LexTI2z/vYK8EJTkw9Nf7mNqJe7QS6cMmlDcIgTdUeSs3EmStJPtIxa5OpPY9
         WVbHIb4dhCV/z00V4e2LMuWqH+DL5dRFJWznBbNfgeePuFU+IVMYOErw0iljS/2Rdpka
         otMQluOJQeVX9sqJmjILG2oYB9Gz9yFtKSNqPD2a0mhk916CVYU8WxAVxUTTHzk15gyP
         eMBw==
X-Gm-Message-State: AC+VfDwmGzU/blcyFcD9tEUf9Uts+nJR0nZhznYNm/2cjk1vooAfU8Ex
	0r8iy3sMCz7QZIOzwrts1yGKslEAE3Z7HJMhhbpQxIT0JcXAxA==
X-Google-Smtp-Source: ACHHUZ7xuqBK3bQG/FrjXd7EFoQC/m24+yMUbZ7ZYAxY6jtcGKlg83sP8Mn1grnUDo8hjTubIJScJKBT2rns3pDgsWg=
X-Received: by 2002:a4a:378a:0:b0:555:722e:3ca with SMTP id
 r132-20020a4a378a000000b00555722e03camr1330839oor.5.1685459193697; Tue, 30
 May 2023 08:06:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230530141935.GA21936@didi-ThinkCentre-M920t-N000>
 <CANn89i+HK5vny8qo89_+4PqZj9rBcGi6sVfSgN4HSpqqoUr6fw@mail.gmail.com>
 <CAL+tcoCW7o-RcQ40NdZKwfcoqn5V9K4kjKpYpiT0E38k7yyc2Q@mail.gmail.com> <CANn89iKopAb_TGWtqHZB40Gs9VW=UfLj+h2za1=Pr8c6+Lcn=Q@mail.gmail.com>
In-Reply-To: <CANn89iKopAb_TGWtqHZB40Gs9VW=UfLj+h2za1=Pr8c6+Lcn=Q@mail.gmail.com>
From: Jason Xing <kerneljasonxing@gmail.com>
Date: Tue, 30 May 2023 23:05:57 +0800
Message-ID: <CAL+tcoBvHLxqhwefCws-yXF9qu0dJj4ESt+c=k4nt+ybKJcyuA@mail.gmail.com>
Subject: Re: [PATCH net v2] tcp: fix mishandling when the sack compression is deferred
To: Eric Dumazet <edumazet@google.com>
Cc: fuyuanli <fuyuanli@didiglobal.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Neal Cardwell <ncardwell@google.com>, ycheng <ycheng@google.com>, toke <toke@toke.dk>, 
	netdev@vger.kernel.org, Weiping Zhang <zhangweiping@didiglobal.com>, 
	Tio Zhang <tiozhang@didiglobal.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 10:51=E2=80=AFPM Eric Dumazet <edumazet@google.com>=
 wrote:
>
> On Tue, May 30, 2023 at 4:32=E2=80=AFPM Jason Xing <kerneljasonxing@gmail=
.com> wrote:
> >
> > I'm confused. You said in the previous email:
> > "As a bonus, no need to send one patch for net, and another in net-next=
,
> > trying to 'fix' issues that should have been fixed cleanly in a single =
patch."
> >
> > So we added "introducing ICSK_ACK_TIMER flag for sack compression" to
> > fix them on top of the patch you suggested.
> >
> > I can remove the Suggested-by label. For now, I do care about your
> > opinion on the current patch.
> >
> > Well...should I give up introducing that flag and then leave that
> > 'issue' behind? :S
>
> Please let the fix go alone.

Roger that. So I can add back your suggested-by right?! :)

>
> Then I will look at your patch, but honestly I fail to see the _reason_ f=
or it.
>
> In case you missed it, tcp_event_ack_sent() calls
> inet_csk_clear_xmit_timer(sk, ICSK_TIME_DACK);

Thanks, I will take a deep look at this tomorrow since it's too late.

Thanks again,
Jason

