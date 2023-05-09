Return-Path: <netdev+bounces-1099-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CE1476FC2C9
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 11:30:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9550D28118D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 09:30:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CD5FAD36;
	Tue,  9 May 2023 09:30:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E09B20F9
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 09:30:26 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25938DD88
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 02:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683624621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WWUbYFjjx+ICPyEkXBm8kY/O+ZEJSV1Cd7/THSNoG6A=;
	b=OzzOzD9R/nsWp7BgfqcXoRKZjk2cWbldBVlEeoiYjhfQRKsEMfqoIBKc4XX/fVFzBvlZ1i
	Jd/3uTc3ncNtt/Kj8HD2jWmeudXg5tJnAYJ0zqrRMDfuN/AD2wI6py84eEHBlp9V+dvuj7
	K++FLOq8jcxrYN9L+cneZFPSY295Fd8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-584-Ck9UjG9qPlqIVnlCNwSs_Q-1; Tue, 09 May 2023 05:30:20 -0400
X-MC-Unique: Ck9UjG9qPlqIVnlCNwSs_Q-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-74e23e33f80so30334885a.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 02:30:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683624620; x=1686216620;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WWUbYFjjx+ICPyEkXBm8kY/O+ZEJSV1Cd7/THSNoG6A=;
        b=Swijdx21WYARZg4biDqrwsTfVhWPV4fCXZJM7vJt2r+w1YcnYAUUBkQlD4wRxJ403U
         CIvwusy3hkSeC+XRqO6xQcs7IIAEhFzTpGIWR6QTTbDVz6Bc7lf+ZEaUCUaq3trK3qTV
         MIsfZjwDODDKF3yeL1HgNGdmhfp7C8mu1l/DcOVp5ThJEvi5aBAYJVUg3IhTUkYP11Mc
         CnvFQoEMW/Oq6njPI9WdzWDtmJ8m3rwo8KxosZltg7bn3cgb7DOwhUSXltzD5F53HhFu
         VwGYpwu9tYUG8KAgQDfHKYANaC9yK3tAJ5enbwHsWi0eoidjvFpJZM6Zs8a7qYclvZ2J
         ddKA==
X-Gm-Message-State: AC+VfDyNR5FKG8GM66dlGrGpFVlUT6ExW/L+ggmmO/MDC6EzQ8gd3HUM
	sYikUJ5NoaGp4AJZNVicSCpXg+6Lyb2uQsRZtSeSTJ+pBoCnGHD6HqFiRa3CKjRoa51NXGD0bDj
	fsK83NJIHoxIpiV8B
X-Received: by 2002:a05:622a:1896:b0:3ef:4839:2632 with SMTP id v22-20020a05622a189600b003ef48392632mr19423896qtc.0.1683624619834;
        Tue, 09 May 2023 02:30:19 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7IdngGu4W6HDlzDwmPcGS8eug7c+TlJ/S1IhOJKt48LSsfRPPnQ/xdS5LfvIaZhGdLosuPSw==
X-Received: by 2002:a05:622a:1896:b0:3ef:4839:2632 with SMTP id v22-20020a05622a189600b003ef48392632mr19423868qtc.0.1683624619516;
        Tue, 09 May 2023 02:30:19 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-255-65.dyn.eolo.it. [146.241.255.65])
        by smtp.gmail.com with ESMTPSA id c18-20020a05620a11b200b0074fafbea974sm3159641qkk.2.2023.05.09.02.30.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 02:30:19 -0700 (PDT)
Message-ID: <c77b8989fa4a1424a159fdd4450109a239babaa1.camel@redhat.com>
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: log clock enable errors
From: Paolo Abeni <pabeni@redhat.com>
To: Lorenz Brun <lorenz@brun.one>, Felix Fietkau <nbd@nbd.name>, John
 Crispin <john@phrozen.org>, Sean Wang <sean.wang@mediatek.com>, Mark Lee
 <Mark-MC.Lee@mediatek.com>, Lorenzo Bianconi <lorenzo@kernel.org>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>,  Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
Date: Tue, 09 May 2023 11:30:15 +0200
In-Reply-To: <20230507214035.3266438-1-lorenz@brun.one>
References: <20230507214035.3266438-1-lorenz@brun.one>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, 2023-05-07 at 23:40 +0200, Lorenz Brun wrote:
> Currently errors in clk_prepare_enable are silently swallowed.
> Add a log stating which clock failed to be enabled and what the error
> code was.
>=20
> Signed-off-by: Lorenz Brun <lorenz@brun.one>
> ---
>  drivers/net/ethernet/mediatek/mtk_eth_soc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/et=
hernet/mediatek/mtk_eth_soc.c
> index e14050e17862..ca66a573cfcb 100644
> --- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> +++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
> @@ -3445,8 +3445,10 @@ static int mtk_clk_enable(struct mtk_eth *eth)
> =20
>  	for (clk =3D 0; clk < MTK_CLK_MAX ; clk++) {
>  		ret =3D clk_prepare_enable(eth->clks[clk]);
> -		if (ret)
> +		if (ret) {
> +			dev_err(eth->dev, "enabling clock %s failed with error %d\n", mtk_clk=
s_source_name[clk], ret);

I'm sorry for nit-picking, but this lines really exceed any reasonable
max len. Please reformat the above as:

			dev_err(eth->dev, "enabling clock %s failed with error %d\n",
				mtk_clks_source_name[clk], ret);

Thanks!

Paolo


