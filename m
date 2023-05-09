Return-Path: <netdev+bounces-1091-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FED36FC25B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:07:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4663A1C20B2C
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:07:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6FA535673;
	Tue,  9 May 2023 09:07:32 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF3E17C2
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:07:32 +0000 (UTC)
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB6919B1
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:07:28 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id d75a77b69052e-3f38824a025so129781cf.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 02:07:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683623248; x=1686215248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BX6E486nXG7oIYqC/FUJxpFAdB//bHmfcVOzjErHH7U=;
        b=P3Hfp5axnXGl13mGa8GxpJRmKS8PCLIGhw7mgC19VDm14U/9myCM0YgHrNc7w2a/q1
         z7TWZeFASo5UI8LI+VMqTubINGP5DzEmakMg7jGBwXYOB90Eq1thrwT23v6sUQ0zHPJu
         MHEqcDoodraMnxlogtL1wN46uTbTbnJFvYkC2L6jPDA1vTNGB2DE4Wf+4TuH9/IA4obP
         xas2FhJG/Fe81iVTj42WRdIWk5jBskTODEIqgDxlHC/sIE37YjBGB1vm6ruCSp4a0C9D
         L797X47TkeCPstCl7p1DMHCAFEd0yXFIBTlwtcXrAW2CKDBNz9oznSNrHhru9qDMIpws
         P9Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683623248; x=1686215248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BX6E486nXG7oIYqC/FUJxpFAdB//bHmfcVOzjErHH7U=;
        b=AePo67+N8gF8M3ifFc1ZpRKgGftuWNG/aQfh3z7944uMhJgbte1ys/iWFmqxOpWv21
         G9O5vFo1YEIhB2UwIBVGqDdVR/ii49WUreeOWWF+ug6n8cmiMm4QxZGfNBT76TjvfAHj
         eQAR/WAU/opEw2Wk2Ue/ApSbVAnm35JyaakL6iI9MCW55AFVrdBLmm+Ag/LD0Qvon9dv
         CCH110YYF0RmuKPNGEzJml7/hpKX0Et4KMT6FpEG0GsIVwYt55BxQYV/1fXrUeOlxes9
         HfTeshF+Z0pOdn4E/lA1YCg3WOSdcCzvEFXrIBfP65IYxUV9HQGfxNdxZkqhrczLHMHN
         sSwA==
X-Gm-Message-State: AC+VfDxzb9pq5/ueP7tm7XvZ/+GcEtFndinP2fr32nT5ImCFCY/ubzVj
	Lcdr2/0vUkdO+/0SfFvE8ReL5TfSOmwpfJwtXFqIYg==
X-Google-Smtp-Source: ACHHUZ4azWC/BvUibkvgpNa3lCBgVpx7lN3uvSqh1JJdqq2jq8pW63YT3WiqNMYGAE9xr/S71Ox3Mv2y7Yh6BQaM1LY=
X-Received: by 2002:a05:622a:201:b0:3ef:19fe:230d with SMTP id
 b1-20020a05622a020100b003ef19fe230dmr158491qtx.17.1683623247652; Tue, 09 May
 2023 02:07:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508175543.55756-1-kuniyu@amazon.com>
In-Reply-To: <20230508175543.55756-1-kuniyu@amazon.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 11:07:16 +0200
Message-ID: <CANn89iJeghZDYPKbaUcDmbX6wz6NCkwpPfg9WPyvGRq5LSpknw@mail.gmail.com>
Subject: Re: [PATCH v3 net] net: Fix load-tearing on sk->sk_stamp in sock_recv_cmsgs().
To: Kuniyuki Iwashima <kuniyu@amazon.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 8, 2023 at 7:56=E2=80=AFPM Kuniyuki Iwashima <kuniyu@amazon.com=
> wrote:
>
> KCSAN found a data race in sock_recv_cmsgs() where the read access
> to sk->sk_stamp needs READ_ONCE().
>
>
> Fixes: 6c7c98bad488 ("sock: avoid dirtying sk_stamp, if possible")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
> ---

Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.

