Return-Path: <netdev+bounces-10532-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 205F372EE30
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 23:41:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57823281077
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:41:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40BDA3D3BE;
	Tue, 13 Jun 2023 21:41:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 312103D385
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 21:41:52 +0000 (UTC)
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A2911B
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:41:51 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-1a693718ffbso2376534fac.0
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686692511; x=1689284511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LlKEMybERhd9wYHREEdkadIOD8IIANcJ3v2Hrx+wix4=;
        b=FoTwUkXSLWYHGUL9iue8lYi9jm/BWQlr7GtedKL4IQZeonJiROaV9E4wSjimkjQQ23
         uWDWPUX7FCi3z+v1EeASf0FIzGwWfNLZ4wS/DmaVXaCRtzLNOPP1H15QlMWFpzVLj9iP
         /Ir7qLHnb4YiMrWdiGR1XC5b7AtxztOJutgprTnIp25gkGCINjVvlimBfaiPBUMxqlmb
         pdASuh3tn2WuyqzkqGvewhrlP8JrCOa9ejUXizoFknhkoa7s41/er7D20DcznF1H9URo
         FhWUALuXlGkNDungI0kzmEQeHwU9cWP7JYxnQXJAJKyjl+pbpPGak3RKv6sr/fyf4buY
         jiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686692511; x=1689284511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LlKEMybERhd9wYHREEdkadIOD8IIANcJ3v2Hrx+wix4=;
        b=B4khut0Orqh8bjSf0ZubAcN4/Xb9SAaCi6DaVa38/SoIT6Ca9vyQY/oi+vBzNwwNda
         lSOrzfhnnlbcMl2C8MwHT2TuHm07VMUmDPlg38ux7numbty9I11UUAiCiNfdjdtXEig8
         q3ab+ChodLAwX0yI+suzyBNSE3FQZTyqixiKwF5hsnmJgZBXTrFx+kuh+W7tSWiQjZpx
         864qtEplc5uGQoG8KuaWAo4NJfyUee5Kd1uXbOL8hHfIw8MHXtMw6vpbxTdqXo0D5feI
         j6OmODVxGKnKV9pxQgHrodzS6HV5U41Lulz6d23ZIeWksmm55WZ9hfGZQMtuTeSLEQe3
         w+hw==
X-Gm-Message-State: AC+VfDxVAeSygLHwPzm14VWkmb96A9ewvR+2LzAML7iKgI/wgEX7ey/J
	FnJy3hJnC9bnZqVz27KljGhfUhLwLIU=
X-Google-Smtp-Source: ACHHUZ4deFyN37keqSzh5i5RBrzomH3idI7MtUYBB8En+kn4U07gZmhU1AuNgLETbx+WhANoQJIo1w==
X-Received: by 2002:a05:6870:341:b0:1a3:1962:9123 with SMTP id n1-20020a056870034100b001a319629123mr10244130oaf.31.1686692510945;
        Tue, 13 Jun 2023 14:41:50 -0700 (PDT)
Received: from espresso.lan.box ([179.219.237.97])
        by smtp.gmail.com with ESMTPSA id s13-20020a056870610d00b001a2f7ca6183sm7879742oae.38.2023.06.13.14.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 14:41:49 -0700 (PDT)
Date: Tue, 13 Jun 2023 18:41:46 -0300
From: Ricardo Nabinger Sanchez <rnsanchez@gmail.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, Willem de Bruijn
 <willemdebruijn.kernel@gmail.com>, netdev@vger.kernel.org
Subject: Re: panic in udp_init() when using FORCE_NR_CPUS
Message-ID: <20230613184146.66d89282@espresso.lan.box>
In-Reply-To: <CANn89iKzZsyT-C-Ge6nPzC9Oo0f+gf5HZXbmXnePvSi+v4vuUg@mail.gmail.com>
References: <20230613165654.3e75eda8@espresso.lan.box>
	<CANn89i+5DoHFh-2MvLy740ikLdV-sE8pEEM+R=i0i77Pyc1ADQ@mail.gmail.com>
	<CANn89iKzZsyT-C-Ge6nPzC9Oo0f+gf5HZXbmXnePvSi+v4vuUg@mail.gmail.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-slackware-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, 13 Jun 2023 23:05:34 +0200
Eric Dumazet <edumazet@google.com> wrote:

> I suspect you run with LOCKDEP enabled (CONFIG_PROVE_LOCKING=3Dy)
> and a very big NR_CPUS ?
>=20
> LOCKDEP makes spinlock_t 16 times bigger :/
>=20
> If so, please try the following fix.

CONFIG_LOCKDEP_SUPPORT=3Dy

Now I'm using only 12 CPUs, per my other message where I disabled MAXSMP
and really set NR_CPUS, resulting in a successful boot.

It may be true that earlier it was architectures's max (8192).  Maybe
that was the real issue, then?

Best regards,

--=20
Ricardo Nabinger Sanchez

    Dedique-se a melhorar seus esfor=E7os.
    Todas as suas conquistas evolutivas n=E3o foram resultado dos
    deuses, das outras consci=EAncias, ou do acaso, mas unicamente
    da sua transpira=E7=E3o. ---Waldo Vieira, L=E9xico de Ortopensatas

