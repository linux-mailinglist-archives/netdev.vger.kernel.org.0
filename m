Return-Path: <netdev+bounces-496-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A61A6F7CD1
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:12:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB5B21C216CC
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 06:12:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A91C1C08;
	Fri,  5 May 2023 06:12:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D959156E6;
	Fri,  5 May 2023 06:12:34 +0000 (UTC)
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F1114349;
	Thu,  4 May 2023 23:12:33 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-55a79671a4dso20390967b3.2;
        Thu, 04 May 2023 23:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683267152; x=1685859152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X3bbYzd3BnqgM8hST7H7cUDpFnFAzr2wDGBbnjPYfiY=;
        b=bJnkINg0DfxWNd7uyH8eoEdvYF3nWeP0iyTrAelDtxBdbCC+yE5B3QlIoJ3Gs+r4sm
         pPIQku91iXNkvHvQbmy5S2hjavlVznbfOzyvXLtqUTyq1ojFEC3TZ4ytJJMW6gh9HdYa
         qxXTFb8lhTJ3f/8oDmtspPflSp50S6Bidbo4C2meVdapUV1GS+RccDF2CUJtgofcLfSQ
         SVyo3lRyE2SSBNkaI4zfYCXkdee18NoOd4G1HEiDOi8cP7XrGEiqnF/Sv5gu8IRHHgqj
         xKQ2w3pdhOqs9klfA9XGDHr5TRCwyOCHY1EhOKqJYm0xKbd0CziLN2ze5vSb6utsnw5X
         Erjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683267152; x=1685859152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X3bbYzd3BnqgM8hST7H7cUDpFnFAzr2wDGBbnjPYfiY=;
        b=QKlkm3V1oPi3zURZ0XIJoND47KeQXlMSDCVD3nm5i2kpoHnWRH0+O4Y2Tyj+X+inr4
         xzRfkN53cCS1o3PELb18dXwEtT02xi8JKCatMPpKSYSXNEWgHUp/TealZ7rlF84YMquN
         dZqe5MBcVsJO2/bNLBDhpLfwlpYDu+0wgA8lVGvcRIZMsTOj/g39TC4zXiS/us1/WKHh
         CobAuYSTrHQIVnbTAsters+Wy2a2DKlmVI8xFVS54XF5ppirrWMPk0+pZs/PxOeVwS40
         IVkUCLC4sIrXLh/Qbo9zzzhSMIyQ5zWczTbUg48uWBTw2T0rXa47X7jk023AkSExVOR8
         0RVg==
X-Gm-Message-State: AC+VfDzYsRbkXgOdago7vqSrmPSGcOt1XUiW+auEc18HiNqgc1+F2n5+
	CW7Vjt0aeS1uqGLomnht0AB1RGQvn+yC0tOX/g==
X-Google-Smtp-Source: ACHHUZ6pjXUyTcodRYvFHF9izQ/Q7ppXoUqelAnhrnT0zY/C6u88aOOxphFMwnqUx63NS2GMuHaRYdIoNamnt0gASA8=
X-Received: by 2002:a0d:ef03:0:b0:55a:592d:9ec0 with SMTP id
 y3-20020a0def03000000b0055a592d9ec0mr505403ywe.20.1683267152361; Thu, 04 May
 2023 23:12:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <5969591cfc2336e45de08e1d272bdcee30942fb7.1683191281.git.lorenzo@kernel.org>
In-Reply-To: <5969591cfc2336e45de08e1d272bdcee30942fb7.1683191281.git.lorenzo@kernel.org>
From: Jussi Maki <joamaki@gmail.com>
Date: Fri, 5 May 2023 09:11:56 +0300
Message-ID: <CAHn8xcnDCXZXRpQtf5TQS_YmhFm+LP-Jyqz-LKa+nr8cHt2pLg@mail.gmail.com>
Subject: Re: [PATCH v3 net] bonding: add xdp_features support
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netdev@vger.kernel.org, lorenzo.bianconi@redhat.com, j.vosburgh@gmail.com, 
	andy@greyhouse.net, davem@davemloft.net, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, bpf@vger.kernel.org, andrii@kernel.org, mykolal@fb.com, 
	ast@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev, alardam@gmail.com, 
	memxor@gmail.com, sdf@google.com, brouer@redhat.com, toke@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 4, 2023 at 12:52=E2=80=AFPM Lorenzo Bianconi <lorenzo@kernel.or=
g> wrote:
>
> Introduce xdp_features support for bonding driver according to the slave
> devices attached to the master one. xdp_features is required whenever we
> want to xdp_redirect traffic into a bond device and then into selected
> slaves attached to it.
>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Reviewed-by: Jussi Maki <joamaki@gmail.com>
Tested-by: Jussi Maki <joamaki@gmail.com>

> +void bond_xdp_set_features(struct net_device *bond_dev)
> +{
> +       struct bonding *bond =3D netdev_priv(bond_dev);

Minor nit: could we instead take "struct bonding *" as an argument here?

