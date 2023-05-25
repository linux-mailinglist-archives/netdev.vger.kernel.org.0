Return-Path: <netdev+bounces-5423-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F0DE711392
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 20:19:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDF702815DF
	for <lists+netdev@lfdr.de>; Thu, 25 May 2023 18:19:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520F121CD6;
	Thu, 25 May 2023 18:19:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46B54101DA
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 18:19:38 +0000 (UTC)
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BE87E2
	for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:19:37 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id 2adb3069b0e04-4f4b384c09fso2933165e87.3
        for <netdev@vger.kernel.org>; Thu, 25 May 2023 11:19:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1685038775; x=1687630775;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Eyp0v1JgQyCuZ+Exsevv8Sw+EcABs0zuWzeDebjKBmw=;
        b=r0flw4QnTiz04A0n4LN0sXOyBnPbGSV2c6qo4tsycTeFrdBWdS5R7JWPzMv3ztAHWx
         ApFEwKyAvCrlUEcwu52jkWwZBI1uoIHeDlXtnyfyT0AvrKL2VCjj2ajtit0WwuvDpuGQ
         Kol2B7YFry54crsTHC5IVEc4FIsq0DxuG4qMMLMUJ6r4VI02vH3l/pgisrQlRoGOxrzT
         3bETRSQdAxEv6q/bgY/o6N/bkkwsLliBi15i9b/FEY3kAa+jho0tfXC5Mz406AowLN2p
         nMCiN433nEFu8O+H+cLdNFTSvZENkrSXJiUwKbLRCJ1heYHyiwtpkH51aPF90RZWbj4p
         SSSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685038775; x=1687630775;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eyp0v1JgQyCuZ+Exsevv8Sw+EcABs0zuWzeDebjKBmw=;
        b=GkhYmnKlTvhgiRH+YBZPgoowABlBhNEinmsQxQ5zAAAZwKs0xU//2sPrIBWMOUStd3
         JNBrbKs1VoFAaEQx2WNq0Zb8IPyyGJLkRCtir4E3D550iQoczG2lyH4QxHEP7SEpj07g
         wUjJuBBZQ/MgbOKxSzZRneuOjeaYpGeCKGipdKruxnTKdbcEdiDRoLQ9Qc6S+qUeVc+z
         wQVSRhdczbhFkv70RUShEr1JKWYvAP/T7kg4/aoFTgsb0qfWZaUcVPqf3rJKniSNWz7w
         HcL0lSRBIkjX4uJcW+KxXJ95qiMe3VDkwKsdVYjtarr7SzhDzgJDhzNhSw+7kUIWLJuQ
         aYpg==
X-Gm-Message-State: AC+VfDxdbzhVtLuRB0I22F3Iv1FIx2hwnEeRWLxswDr+fRdYQ/unrVvm
	vMNFHo2GxDxY+EkDlsawQSrwew==
X-Google-Smtp-Source: ACHHUZ4H4IUTvPMIl8KiFYEvdV32/a+qqNPZPsiQnmW0jRes3Yt2KP8fYi+hES0JuxHenxy5HlpH3g==
X-Received: by 2002:ac2:5d66:0:b0:4f0:1076:2682 with SMTP id h6-20020ac25d66000000b004f010762682mr5694599lft.42.1685038775297;
        Thu, 25 May 2023 11:19:35 -0700 (PDT)
Received: from builder (c188-149-203-37.bredband.tele2.se. [188.149.203.37])
        by smtp.gmail.com with ESMTPSA id j22-20020ac253b6000000b004f3aee3aae2sm296081lfh.140.2023.05.25.11.19.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 May 2023 11:19:34 -0700 (PDT)
Date: Thu, 25 May 2023 20:19:32 +0200
From: =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>
To: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, horatiu.vultur@microchip.com,
	Woojung.Huh@microchip.com, Nicolas.Ferre@microchip.com,
	Thorsten.Kummermehr@microchip.com
Subject: Re: [PATCH net-next v3 3/6] net: phy: microchip_t1s: update LAN867x
 PHY supported revision number
Message-ID: <ZG+mtFWGqTncZmcn@builder>
References: <20230524144539.62618-1-Parthiban.Veerasooran@microchip.com>
 <20230524144539.62618-4-Parthiban.Veerasooran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230524144539.62618-4-Parthiban.Veerasooran@microchip.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
	T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 08:15:36PM +0530, Parthiban Veerasooran wrote:
> As per AN1699, the initial configuration in the driver applies to LAN867x
> Rev.B1 hardware revision. 0x0007C160 (Rev.A0) and 0x0007C161 (Rev.B0)
> never released to production and hence they don't need to be supported.
> 
> Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.com>
> ---

Reviewed-by: Ramón Nordin Rodriguez <ramon.nordin.rodriguez@ferroamp.se>

