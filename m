Return-Path: <netdev+bounces-289-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5698E6F6EC8
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 17:21:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3DA1F1C21159
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 15:21:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4B5779EA;
	Thu,  4 May 2023 15:21:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9240179E1
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 15:21:55 +0000 (UTC)
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C18940F6
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 08:21:54 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1ab01bf474aso4427405ad.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 08:21:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683213714; x=1685805714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vWlz6k8NpBALFj93oK6uML7xI9V8IylpTh04d+AO5A4=;
        b=VOnLct++1GrAVKxnGEoVMEteCE1Ht7NYapEojk163yrFnqQaqJnCyzW6KgzkNcyA+F
         UmMldarLmzRqb+VhFkwY5u5b8GeRYhwEduUAWnEpdt6mGIxG9RCUsXfTdSh5pX7t1CKi
         YMWXB16Nnnh5G7CZaKlv7CvBjXljI0aL89V8lKe8gLLl9vD3Qeg0nB+J98HDqwiZDboi
         8QMybfMUYFo7JpG8Cxe+zn1k8XbwZJl/J3FL7k8eslOfBI3kbjf4NKoNfsCbk7kuWNAt
         kIWn1b0uSku/rC1iacf6VdA6rBC/rPfeK/Xf47B65dxjjp7K2DLnwambaveETeqmmSQy
         iZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683213714; x=1685805714;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vWlz6k8NpBALFj93oK6uML7xI9V8IylpTh04d+AO5A4=;
        b=U8qgCT/1SxXkDpW5XwfiWcVNb4w7qnrOEtUx4y4zHFOxKWlPiAjE0gzPp6riCIXN+C
         93Ynxm6PEot8E8e/sncPFOImD9QeIoIvsedSmSlwdk8hL1AAu+8pkAZWug4apUpyNgKQ
         GhnE0/VwoNdGXyQsB+OynY2xWqO41IVbhQ9yOoRE9e4FInsiOK65Iv0ZBq2OvNuyBYQi
         yDBMKImgTSr2rAgmepavUI8Tr+8E4HUh3a0P5/9aqo1UA0PZ86xtzSwdh4/X2gvo4zcD
         30aJmrIMtXFexdD9okBMZpgOtoNh3UWVpuC+C5iF677M2w5QM4wYNecQ7Sg1KtQOmWns
         xPwA==
X-Gm-Message-State: AC+VfDxBa+CJon3S7B7eoyFUEtiDkVQ35dmnJ9Z9DR/5TOddaLriHDYE
	+T9r0WcdzBBhDNH+djHBDeanZCgVMzCAJxcqaRY=
X-Google-Smtp-Source: ACHHUZ6wN2kxko1T+INvsviPR7UXDYKS+PfowTiS0vRqXBYmdOEJHgNz7DAND4E4r+Tboj6S5Lj1KMsTrgxBFgcqWJY=
X-Received: by 2002:a17:903:1252:b0:1ab:7c4:eb24 with SMTP id
 u18-20020a170903125200b001ab07c4eb24mr5117380plh.22.1683213713719; Thu, 04
 May 2023 08:21:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230502043150.17097-1-glipus@gmail.com> <20230502043150.17097-3-glipus@gmail.com>
 <20230503200545.2ff5d9d2@kernel.org>
In-Reply-To: <20230503200545.2ff5d9d2@kernel.org>
From: Max Georgiev <glipus@gmail.com>
Date: Thu, 4 May 2023 09:21:42 -0600
Message-ID: <CAP5jrPGEjx-BvVDx5YSmrGSobPJJ9Uxk8N2wDG--+LGxHP7KCA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v6 2/5] net: Add ifreq pointer field to
 kernel_hwtstamp_config structure
To: Jakub Kicinski <kuba@kernel.org>
Cc: kory.maincent@bootlin.com, netdev@vger.kernel.org, 
	maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com, 
	vadim.fedorenko@linux.dev, richardcochran@gmail.com, 
	gerhard@engleder-embedded.com, liuhangbin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 3, 2023 at 9:05=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wro=
te:
>
> On Mon,  1 May 2023 22:31:47 -0600 Maxim Georgiev wrote:
> > +     err =3D dev_eth_ioctl(dev, &ifrr, SIOCSHWTSTAMP);
> > +     if (!err) {
> > +             kernel_cfg->ifr->ifr_ifru =3D ifrr.ifr_ifru;
> > +             kernel_cfg->kernel_flags |=3D KERNEL_HWTSTAMP_FLAG_IFR_RE=
SULT;
> > +     }
> > +     return err;
>
> nit: I think we should stick to the normal flow even if it costs
> a few extra lines:
>
>         err =3D dev_eth_ioctl(..
>         if (err)
>                 return err;
>
>         kernel_cfg->ifr->ifr_ifru =3D ifrr.ifr_ifru;
>         kernel_cfg->kernel_flags |=3D KERNEL_HWTSTAMP_FLAG_IFR_RESULT;
>
>         return 0;
>
>
> Other than that patches LGTM :)

Got it, wil update both generic_hwtstamp_get_lower() and
generic_hwtstamp_set_lower().

What would be the best practice with updating a single patch in a
stack (or a couple of
patches in a stack)? Should I resend only the updated patch(es), or
should I increment the
patch stack revision and resend all the parches?

