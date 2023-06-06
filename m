Return-Path: <netdev+bounces-8456-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A86C2724264
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 14:40:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55E892816B2
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:40:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD03D37B67;
	Tue,  6 Jun 2023 12:40:34 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C327E37B63
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 12:40:34 +0000 (UTC)
Received: from mail-vk1-xa33.google.com (mail-vk1-xa33.google.com [IPv6:2607:f8b0:4864:20::a33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E50010C6
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 05:40:33 -0700 (PDT)
Received: by mail-vk1-xa33.google.com with SMTP id 71dfb90a1353d-461da1198afso974841e0c.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 05:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686055232; x=1688647232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X1uKbLdl8a2GUyy5DBTUcbxqi2kHmGqfJTHbnveVIiU=;
        b=YIRt/5w7l8187LIxk1xKLP66bzlx2a5BV7T1gV1b+DAgjT1qRLrDktjT7LBInIdy6a
         dyO/bXKUaI9w0fPQdv0GwzSsh1DaJF+hj3IRmmz5anIDyVxZ5wFSWF8QfJH4ay7P400i
         RmbWZnjgknlYdjuvE0o0ySKCIliBu59HG/D6WllOruk3EiwBTdVq5gPHPdiUoudvhepr
         Xjt1Ohn3HYJruU09Km3ikcEVwG9y88+C251uOVDODfojkmPNGG0Gd88cKtw13DboYtUf
         vrleLJhv8eYFh3+4AS9OdCa7LK5YDCHN1bsEqb2zphd4skATdPtE7xVHr51q9CWe82fR
         +aZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686055232; x=1688647232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X1uKbLdl8a2GUyy5DBTUcbxqi2kHmGqfJTHbnveVIiU=;
        b=KYSfDCwD/zfAO02lwth7UgqSXcU5NHN1LDnRYuWdMofK2OgfvTKs0S80BwHdY9kJH7
         NpYDnrct9PzY1qA9T2Ofqc3a5giD9VBr3cZOThkeMNpoNdRd0osxG9seuxqsS8JJeBOZ
         29K2BFi1PqtgV3hotJerw+uMQA/be1xx12SqacSXnp1A5NWpN3smHkd41kTL+HEVMvow
         /17FvVuuxTPx634waolWnPETTmcb4LqOSN04YW6XifTSRYLqHUOEECfoKf5Swm+xnkB+
         L9DwipV7B/rpc3FR6O+iG8TBhZMedpSbnHeF37CyKAD1rZcmtXfzlWZ7gtgvm+A00jp8
         XHJA==
X-Gm-Message-State: AC+VfDwztVa8fopj6iF2tESUPofD+RubxbxtJboUTHSy4vgdf97D70L1
	2zLhFBUhJpfdX5hqizZbSzvlhD7ykfhqt7aM7lIghdg2qMbV7g==
X-Google-Smtp-Source: ACHHUZ6aGa0B40KHrYinqFqiuGv5JpLLsKTK9Ppc9Sdjwrc2NbxgqHFlCxQOocVcGKt0UU+5r0XPis4wYz9RRgCgFzA=
X-Received: by 2002:a1f:4558:0:b0:463:c3f7:a154 with SMTP id
 s85-20020a1f4558000000b00463c3f7a154mr684312vka.3.1686055232656; Tue, 06 Jun
 2023 05:40:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230605190108.809439-1-kuba@kernel.org> <20230605190108.809439-4-kuba@kernel.org>
In-Reply-To: <20230605190108.809439-4-kuba@kernel.org>
From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Tue, 6 Jun 2023 14:39:55 +0200
Message-ID: <CAF=yD-+E6f+v_NKwgDvQLBNcbEMZ9LSJPwWuUqdO_A6cMkuYDA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 3/4] tools: ynl: support fou and netdev in C
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com, 
	pabeni@redhat.com, simon.horman@corigine.com, sdf@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 9:01=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> Generate the code for netdev and fou families. They are simple
> and already supported by the code gen.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Willem de Bruijn <willemb@google.com>

