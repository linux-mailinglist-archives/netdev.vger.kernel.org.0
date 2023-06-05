Return-Path: <netdev+bounces-8130-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E306722DB7
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:35:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 93CF61C20A74
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:35:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 197C519E7F;
	Mon,  5 Jun 2023 17:35:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035B2DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 17:35:42 +0000 (UTC)
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5DF8F
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 10:35:41 -0700 (PDT)
Received: by mail-lj1-x22e.google.com with SMTP id 38308e7fff4ca-2b1af9ef7a9so44050451fa.1
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 10:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685986539; x=1688578539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rfTYVLwLrUMOBYHXIwWSY6SECar3cpIRtROatCrII1w=;
        b=mNPLa3YMJdPpk1XZX2t+jd0pvQPuUZrtAhYWxrRxOc6B9KpB6fEJ86qnhU4yCk419d
         64uzJVonWUqZg9+aJzd2CnBTgSsfsGPJHYEzzLnqcpx1smN323zCYO/CU2Su2DwIFkLr
         diLiVv9xbrLF87Mi8L/lKl1Q93bV1/2msNt6WqUXSo2hvyqUtFiUFXW16HS5zXACMZMU
         8V1VL/o4sMCRkHaeLyvWymDPsuDR1rfzP/2EuC17021YkorTUXxT3+xzyDvO4JLayXtf
         C7J6Ali+XfUfnLLr53TeDoltx17UJRHiwLgdlNyNEFT+fQDD7VWuKDFQSEXbRYMurLa1
         tveg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685986539; x=1688578539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rfTYVLwLrUMOBYHXIwWSY6SECar3cpIRtROatCrII1w=;
        b=WBvwpIbVYuNJ1+hbsMTfWM6EWaVmeV+1Jvfy+MdgIPug1EM61wV0w68AwnVVeMxnd2
         6GAi8XYPlZxHsNX0juYp2Qy3La5+FhguzFmUgi54cYw7rikQOBnvdQMYF+xeAAjcjlka
         YoSOxKfzIKfkuqIa/Z+4LVVY41bsNi36iiBbqXAROvuLl1+09nPYSRKzFaYgNUGacPBI
         Fo3PEeHnEj2GasHgq8Kg7slOr1lMSEw7p+sbE5n5rwiZgoJYvukpoXOiaBdGYEc8se0T
         Gtpb/3/c6rNGh6v+0LfsuhHX8m+Cj7Eu4vFOqzm4xcz/hHdPmY8xcNaI8pogSu8wnfMC
         VutQ==
X-Gm-Message-State: AC+VfDzX2vpxkTFuIzjJ9fIka7gErZiOon3KXsVaGl3HIMpZW/ArIiPz
	YeZmkat2nbbiVtwiIWuow8oiLccQHKDp04uMNmw=
X-Google-Smtp-Source: ACHHUZ4fG0Bn4dYTgMTquS1k00etK4Cof2NWlY0DZaA0H5/zLN9e5+ctg2J4JbtB3vOuaxVjvRizzAskA/mzSm6eWSA=
X-Received: by 2002:a2e:3502:0:b0:2b1:eb62:ffc8 with SMTP id
 z2-20020a2e3502000000b002b1eb62ffc8mr1016693ljz.6.1685986539233; Mon, 05 Jun
 2023 10:35:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <TY2PR02MB3615EB80E1F26563CB1ED92D8C4DA@TY2PR02MB3615.apcprd02.prod.outlook.com>
In-Reply-To: <TY2PR02MB3615EB80E1F26563CB1ED92D8C4DA@TY2PR02MB3615.apcprd02.prod.outlook.com>
Reply-To: bjorn@helgaas.com
From: Bjorn Helgaas <bjorn.helgaas@gmail.com>
Date: Mon, 5 Jun 2023 12:35:27 -0500
Message-ID: <CABhMZUXyY6-cnxPcU5MFy2-RoVuCx65PUVwMKsM5gqhgtdNy2Q@mail.gmail.com>
Subject: Re: [v5,net-next]net: wwan: t7xx : V5 ptach upstream work
To: "Jinjian Song(Jack)" <Jinjian.Song@fibocom.com>
Cc: "helgaas@kernel.org" <helgaas@kernel.org>, "Minlin He(Reid)" <Reid.he@fibocom.com>, 
	"Chongzhen Wang(Rafael)" <rafael.wang@fibocom.com>, 
	"Puttagangaiah, Somashekhar" <somashekhar.puttagangaiah@intel.com>, 
	"haijun.liu@mediatek.com" <haijun.liu@mediatek.com>, "kuba@kernel.org" <kuba@kernel.org>, 
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 5, 2023 at 7:43=E2=80=AFAM Jinjian Song(Jack)
<Jinjian.Song@fibocom.com> wrote:

> I come from Fibocom and we were previously working on the joint developme=
nt of the t7xx module with our colleagues form Intel and MTK.
>
> Now Fibocom will continue the work for V5 path upstream as bellow links:
>
> https://patchwork.kernel.org/project/netdevbpf/list/?series=3D714379&stat=
e=3D*

1) Linux development works on mailing lists that only accept
plain-text email; see http://vger.kernel.org/majordomo-info.html

2) I gave some fairly detailed feedback at
https://lore.kernel.org/all/20230127133034.GA1364550@bhelgaas/, but
the conversation stalled then.  I'm happy to answer more questions
about that if needed.

Bjorn

