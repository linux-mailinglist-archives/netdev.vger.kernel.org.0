Return-Path: <netdev+bounces-1598-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2368E6FE799
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 00:54:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C468F281550
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:54:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2087B1D2DB;
	Wed, 10 May 2023 22:54:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1225121CF5
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 22:54:19 +0000 (UTC)
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A7A3A8E
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:54:17 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-55cc8aadc97so118984267b3.3
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 15:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683759257; x=1686351257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKUnf2xvbFbD3L+pTeY8JmWEJ2y2fD3xP520UtWlszE=;
        b=FALsQbV8mcVe9jyErfl2fAs3hjUjOITv800v6avRoZKi4sM88z0Za+7vUSDEDegASy
         mT1LuSTPeIl05h9gn1hbtES5Fwvu3nrQslAwyvMqF36XJk5Ll61ftFso0lKo//r4ETob
         c9N9aEmX1kR4EhwQ9XqEb57dlwwTIjdJbv5b8rVPucFZVlTwQbfqpoCCLs/OIQEf1tOk
         M5o/8mSIZS786nROatOoeoiEQTGFHCD9D+0XA+34MLct0fOrDnB8TKtqC2/VZdL4XSt7
         vaX8taQ0KTofMSv33EvoYv7yjVd9dAl0gqvASh2OqvZP+CKiZZObNwo8Fn0QhjJRyEpG
         7RwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683759257; x=1686351257;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vKUnf2xvbFbD3L+pTeY8JmWEJ2y2fD3xP520UtWlszE=;
        b=d6n2LnmL0LZfiauYPTPMDKeAipZIC/AVtpAMasc91b7i+iIvI2IefNB6uCWb6YGp8k
         h0ldDP0kjACA4aA/o7z5evE4LEYnE2765WKeZ2WBaMNS1uKb0Dp+SvE7EC7IlgdtG59q
         lu0KXnsHRmd3EdbqxrapwTm3ISfyxhIXonPEsdaEG+wnYULsZvOEo+lT0n/Zfg3a/QGC
         M/2qA698NctDipeKgLcL5oGMShS+DIXXxce+2rZDKNDvTH8qxyAil1AAOcjXocljCBf0
         k1dl20gQbGWFRh+QEad9wxTk+NVtJaaQkrytyI9fMC8fcLR7chRPmSnVb1F7zPpVtXs7
         ZkVg==
X-Gm-Message-State: AC+VfDzGwAyBg945b+la5KPA+R/nbiWGC4e76xanCa2ke46p06ccA8Sa
	D52pmfRuXfP69Aw6ZNaZB89uaSIOyNy885SNme0=
X-Google-Smtp-Source: ACHHUZ7ZBDftp4eTRyOxbwVQmP8ufiN+8yLfJIBxbB+vkgkbivEA/u6z7P77G5URMh8Q5BPO/tZUzGzEhQGiPLk65MM=
X-Received: by 2002:a25:d185:0:b0:b9d:7887:4423 with SMTP id
 i127-20020a25d185000000b00b9d78874423mr22007294ybg.16.1683759256757; Wed, 10
 May 2023 15:54:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9e1c30a987e77f97ac2b8524252f8cabbfd38848.1683758402.git.marcelo.leitner@gmail.com>
In-Reply-To: <9e1c30a987e77f97ac2b8524252f8cabbfd38848.1683758402.git.marcelo.leitner@gmail.com>
From: Xin Long <lucien.xin@gmail.com>
Date: Wed, 10 May 2023 18:53:52 -0400
Message-ID: <CADvbK_dR4dw--ERGwX3GChFh6G2rJaH9v7exv3+tvmkBf17=4A@mail.gmail.com>
Subject: Re: [PATCH net] MAINTAINERS: sctp: move Neil to CREDITS
To: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc: netdev@vger.kernel.org, Neil Horman <nhorman@tuxdriver.com>, davem@davemloft.net, 
	pabeni@redhat.com, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 6:42=E2=80=AFPM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> Neil moved away from SCTP related duties.
> Move him to CREDITS then and while at it, update SCTP
> project website.
>
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
> ---
> I'm not sure about other subsystems, but he hasn't been answering for a
> while.
>
>  CREDITS     | 4 ++++
>  MAINTAINERS | 3 +--
>  2 files changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/CREDITS b/CREDITS
> index 2d9da9a7defa666cbfcd2aab7fcca821f2027066..de7e4dbbc5991194ce9bcaeb9=
4a368e79d79832a 100644
> --- a/CREDITS
> +++ b/CREDITS
> @@ -1706,6 +1706,10 @@ S: Panoramastrasse 18
>  S: D-69126 Heidelberg
>  S: Germany
>
> +N: Neil Horman
> +M: nhorman@tuxdriver.com
> +D: SCTP protocol maintainer.
> +
>  N: Simon Horman
>  M: horms@verge.net.au
>  D: Renesas ARM/ARM64 SoC maintainer
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7e0b87d5aa2e571d8a54ea4df45fc27897afeff5..2237dc2bb94585d8615a496e1=
a55fdf8755c83b8 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -18835,12 +18835,11 @@ F:    drivers/target/
>  F:     include/target/
>
>  SCTP PROTOCOL
> -M:     Neil Horman <nhorman@tuxdriver.com>
>  M:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
>  M:     Xin Long <lucien.xin@gmail.com>
>  L:     linux-sctp@vger.kernel.org
>  S:     Maintained
> -W:     http://lksctp.sourceforge.net
> +W:     https://github.com/sctp/lksctp-tools/wiki
>  F:     Documentation/networking/sctp.rst
>  F:     include/linux/sctp.h
>  F:     include/net/sctp/
> --
> 2.40.1
>
Acked-by: Xin Long <lucien.xin@gmail.com>

