Return-Path: <netdev+bounces-6895-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C5C471897D
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 20:41:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45AF0281505
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:41:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81276174DA;
	Wed, 31 May 2023 18:41:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7648D16435
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 18:41:47 +0000 (UTC)
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC65110F
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:41:45 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id 5b1f17b1804b1-3f7024e66adso11205e9.1
        for <netdev@vger.kernel.org>; Wed, 31 May 2023 11:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685558504; x=1688150504;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GF8VCrAhn66qLdsXW4ERcJHTpMGUMtRWJ1DJabZuEyQ=;
        b=HAE9WEczf7c2MeIZ4h/RbK3Cjb5fN73gTSQSxUlfticM8Wm5+3KYNdCCUJkAMmb50S
         6pYNN9JmiEHfp+puF6Ifg9QugBI77MhyZoDxYOh+QZyFuYfk0nVngkBqh1z+AlThZu7/
         OaeQzy1P2JG30p6ok0sTys8algaPOd773TzibgbHDutaAN9cuIVnG8LlfoaH4u+raKA1
         FH2cBJ9YzyYNDPnMLGEOazoBI1SCAc+cxtZ1DYqwLhsj0ee0rbYaj72Wa+ui8scxdq1f
         XVfOTY7btHIFXAa0XWYdLsGaEn9goEFmfqWQfVdpKVwD5OqyB3FskfFPjBZs3OH+xcbu
         fI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685558504; x=1688150504;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GF8VCrAhn66qLdsXW4ERcJHTpMGUMtRWJ1DJabZuEyQ=;
        b=Tk29AyWw4OV4xoywbcVgaxD8d7pHSF4GbQ+9UpaB67zwez74dETnqaXS/66Sbsq5nA
         OeCvGJfMHdx0QJE6glkBL3GTMmz/zKtfPN7I+lY6Yhnd/tG8pOn9MJXkXWfvIDhb31O0
         QrY9EzStKfZoU1ZSIeM7wbzmR0Q9lTdxNAM7CWk0n/IdNhR87NntijuO36ky1ABQLBfm
         eDWRAieqlDzTxkJtQUOiWUABIyrpgUstA/OrobTp6d33kWL+opGdSy2RLKYaYkxYeXTU
         M62ybpvrup48IrB3GjYB2g6Qn0o8vCgM4JQrdMCxaNY83e0Q1rggDpb0WHqBCz5z3w+r
         Jv2A==
X-Gm-Message-State: AC+VfDzflgMbhD6mldQcaiIoP2csSTUn2hb0iTJ3EwVdpgXPrAnPckHN
	8sdNtmpE7bKKKRK0KNxiEgE9tkk/ZjRqp4wUxG57zg==
X-Google-Smtp-Source: ACHHUZ51wMBQEWCMC+5c+LGx8B/+gMlo8rk89yJlWD7BM/pwexrhob4l54bbfh0y6WLs45h7XR/TLt7eUJsSOGyXR/I=
X-Received: by 2002:a05:600c:19d3:b0:3f1:70d1:21a6 with SMTP id
 u19-20020a05600c19d300b003f170d121a6mr23664wmq.0.1685558504053; Wed, 31 May
 2023 11:41:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230531104233.50645-1-dqfext@gmail.com> <20230531111602.7ecf401b@kernel.org>
In-Reply-To: <20230531111602.7ecf401b@kernel.org>
From: Eric Dumazet <edumazet@google.com>
Date: Wed, 31 May 2023 20:41:32 +0200
Message-ID: <CANn89iKRX2QTgS44Ky6Jua-+UNrFY3E7RCT_7OfG=GnFvAzdFQ@mail.gmail.com>
Subject: Re: [PATCH net] neighbour: fix unaligned access to pneigh_entry
To: Jakub Kicinski <kuba@kernel.org>
Cc: Qingfang DENG <dqfext@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	Paolo Abeni <pabeni@redhat.com>, YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>, 
	Ville Nuorvala <vnuorval@tcs.hut.fi>, Masahide NAKAMURA <nakam@linux-ipv6.org>, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Qingfang DENG <qingfang.deng@siflower.com.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 8:16=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Wed, 31 May 2023 18:42:33 +0800 Qingfang DENG wrote:
> > +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> >       u8                      key[];
> > +#else
> > +     u8                      key[] __aligned(4);
> > +#endif
>
> I'd appreciate a second opinion, but to me it's very unlikely we'd save
> any memory even with efficient aligned access here. No reasonably key
> will fit into 3 bytes, right? So we can as well avoid the ifdef and
> make the key[] always aligned. Or preferably, if it doesn't cause
> compilation issues, make the type of the key u32?

Same feeling, we could avoid the CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS ifd=
ef.

