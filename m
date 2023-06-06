Return-Path: <netdev+bounces-8425-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C7290723FF9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:47:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37F241C2094D
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:47:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0737D13AE4;
	Tue,  6 Jun 2023 10:47:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E24107BE
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:47:18 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A509A10DF
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 03:47:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686048436;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zU3kCZ4s2v4bypCAx92Zf4r5jHX/badqn2e9gTWWewU=;
	b=H4EIrh4Cmbick0sgE3jhAyPNcc9KvyZkXm3HT98/3LrJ5YnfS4h6Lea6g0TXRBK58El2F2
	Zd6qK7f08u1g36ptWdvsJfbJv3FJQ+ZCg0XkEHXNhkpJiALodIXzPb3gbCKw0P9c4zVdN5
	dzH1+ADtD0pqolE7HQ9HkPgoWtG/Gqs=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-02vtpocTPt2A2e6dB0lHJw-1; Tue, 06 Jun 2023 06:47:13 -0400
X-MC-Unique: 02vtpocTPt2A2e6dB0lHJw-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f7ba550b12so4255295e9.0
        for <netdev@vger.kernel.org>; Tue, 06 Jun 2023 03:47:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686048432; x=1688640432;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zU3kCZ4s2v4bypCAx92Zf4r5jHX/badqn2e9gTWWewU=;
        b=cHa8z3lKUvuX9XnFMYa69gS/bUZUk7Mgni9WT8cSjR7l2uAnWtbi4n26lHhk/9skRL
         g690qzTzfNrheD5wOPXc68/SmqBb8YiMVwUOZwUeLJp7djnDYQPSMjlXWL3hWSeiu2eX
         egVVoQoUSofHpm9YwupFTLEhDwt2OUMurjbv6qgc5LAiNcqTIsvrFy8s//fFTpHmjB63
         7BnljcxAFxs1CtsEQ0/ZvTDpfkZ5WdYrXqzbiOlCoaIbjJw3ETSDqa3jZ+T1OA31k7AT
         DIRpQTzoEIn5scYxpeSwA2enkmHz86AbCc1BtfoDY//aI7RqDp6KHgVffdOl76Zkz/Ic
         gq3Q==
X-Gm-Message-State: AC+VfDzv6exBoo2Y5vf/PwBc4RG3eIunzg1eyu9SS7S8cmQUddm4psJB
	Ff8JSEm9OvWwJ8rhKOLGmdsazaNEw0ifhegiqnbMlt5yt+ZsK/jhdmNr4P0dPK5m5oSk64p/508
	7AkC790QV3UXty3/X
X-Received: by 2002:a05:600c:c19:b0:3f5:927:2b35 with SMTP id fm25-20020a05600c0c1900b003f509272b35mr2048423wmb.1.1686048432106;
        Tue, 06 Jun 2023 03:47:12 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5OrBV0vEqmFOst+dmyByPz2bZFTt8Hzaou8qbkdT3YPO9CE/5fG25bRl4O7w+pwUWgzeAnZQ==
X-Received: by 2002:a05:600c:c19:b0:3f5:927:2b35 with SMTP id fm25-20020a05600c0c1900b003f509272b35mr2048410wmb.1.1686048431841;
        Tue, 06 Jun 2023 03:47:11 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-114-89.dyn.eolo.it. [146.241.114.89])
        by smtp.gmail.com with ESMTPSA id f12-20020a1c6a0c000000b003f7e75b053dsm3989812wmc.34.2023.06.06.03.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jun 2023 03:47:11 -0700 (PDT)
Message-ID: <9df69dcc0554a3818689e30b06601d33fe37457c.camel@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] mlxbf_gige: Fix kernel panic at shutdown
From: Paolo Abeni <pabeni@redhat.com>
To: Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
 edumazet@google.com,  kuba@kernel.org
Cc: netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl, 
	chenhao288@hisilicon.com, huangguangbin2@huawei.com, David Thompson
	 <davthompson@nvidia.com>
Date: Tue, 06 Jun 2023 12:47:09 +0200
In-Reply-To: <20230602182443.25514-1-asmaa@nvidia.com>
References: <20230602182443.25514-1-asmaa@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, 2023-06-02 at 14:24 -0400, Asmaa Mnebhi wrote:
> There is a race condition happening during shutdown due to pending napi t=
ransactions.
> Since mlxbf_gige_poll is still running, it tries to access a NULL pointer=
 and as a
> result causes a kernel panic.
> To fix this during shutdown, invoke mlxbf_gige_remove to disable and dequ=
eue napi.
>=20
> Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
> Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
> ---
>  drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b=
/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> index 694de9513b9f..7017f14595db 100644
> --- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> +++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
> @@ -485,10 +485,7 @@ static int mlxbf_gige_remove(struct platform_device =
*pdev)
> =20
>  static void mlxbf_gige_shutdown(struct platform_device *pdev)
>  {
> -	struct mlxbf_gige *priv =3D platform_get_drvdata(pdev);
> -
> -	writeq(0, priv->base + MLXBF_GIGE_INT_EN);
> -	mlxbf_gige_clean_port(priv);
> +	mlxbf_gige_remove(pdev);
>  }
> =20
>  static const struct acpi_device_id __maybe_unused mlxbf_gige_acpi_match[=
] =3D {

if the device goes through both shutdown() and remove(), the netdevice
will go through unregister_netdevice() 2 times, which is wrong. Am I
missing something relevant?

Thanks!

Paolo


