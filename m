Return-Path: <netdev+bounces-9566-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D28A729CE2
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:29:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1FB20281863
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 14:29:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48E72182B5;
	Fri,  9 Jun 2023 14:29:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E6217757
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 14:29:23 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833C4273A
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 07:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686320961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SeFjQ+AIqSoCw9oUu0kheJJ6w4RLgwEZPguDnMov+Ro=;
	b=Jt9wSEpMLIQg3X78KTApvIPitabofva+3/b9CVg6xSBIBkN83TWajt0unsS50iqxdFFle8
	tOgicfBVeNFO2jtqi8iVWBZZjYN54fhEHzvAT1I4wzBV2E2rg650wnWcfwq0BQp5Ei8lzM
	8NNG53uPemeQhFJpVqdZE+wZIt3Q2e4=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-l-2ONb1fNxqxvtwrpzzYqA-1; Fri, 09 Jun 2023 10:29:20 -0400
X-MC-Unique: l-2ONb1fNxqxvtwrpzzYqA-1
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-bacd408046cso2572368276.3
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 07:29:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686320960; x=1688912960;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SeFjQ+AIqSoCw9oUu0kheJJ6w4RLgwEZPguDnMov+Ro=;
        b=eH+WW1EUPqZO6a0IFuY8jTleAhko2yZSd3LK4xXRm6WGj3POYo8wCG0X+qfDS09y9d
         /QCAdGxeDWKpoHR9PLx6je6Pcu9PZZ+yA2U8u0QEX6FVFJeNfSHdtEvtxmJ6aqULZ93e
         1hjvkDKueNjuCc70QxrrwQasLwFSPV05Mv4BlVZk7IK/n6Q4iHeWwJzm60BRWfEYwa9X
         qo76pEGsYKKLWhY0O/QFAkYA9VWw+j8g+7rqvjkhYzxYpQbKM7e05Zv0Qq1/4/XVdrNp
         YC69yvFoQ/RGobUzH9T8JXrSC25vDgq9aKhXm9QGajo2LfevDrYvoE4PSRayVX16h7dh
         /Hpw==
X-Gm-Message-State: AC+VfDz9jcVk+I7MFbdMnAuDSdtYFMsMhe3Z83Svx8VHPdrsCeD0+IHb
	w8i7PAcj0L6EEXwWxaJTYYUzlQxqpYneuTmXJcGX/VGGgQ89KFuwhqin/sUx3KrSTjCAZcz6YaC
	1GQFagc5JtNra9hxW
X-Received: by 2002:a25:f50f:0:b0:ba8:66fb:dd84 with SMTP id a15-20020a25f50f000000b00ba866fbdd84mr1101338ybe.20.1686320960004;
        Fri, 09 Jun 2023 07:29:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4TEL5O7n3UfPsYTiUfzgwgsZext91z/RVtBWG4mbDyI3+V4ZyAbGaL21xcL2PV/gyhI4oc1Q==
X-Received: by 2002:a25:f50f:0:b0:ba8:66fb:dd84 with SMTP id a15-20020a25f50f000000b00ba866fbdd84mr1101326ybe.20.1686320959702;
        Fri, 09 Jun 2023 07:29:19 -0700 (PDT)
Received: from brian-x1 (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id c5-20020a5b0145000000b00bb144da7d68sm905217ybp.13.2023.06.09.07.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jun 2023 07:29:18 -0700 (PDT)
Date: Fri, 9 Jun 2023 10:29:16 -0400
From: Brian Masney <bmasney@redhat.com>
To: Andrew Halaney <ahalaney@redhat.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
	netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
	konrad.dybcio@linaro.org, andersson@kernel.org, agross@kernel.org,
	robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org, richardcochran@gmail.com, echanude@redhat.com
Subject: Re: [PATCH] arm64: dts: qcom: sa8540p-ride: Specify ethernet phy OUI
Message-ID: <ZIM3PPXi+ed3CJ2J@brian-x1>
References: <20230608201513.882950-1-ahalaney@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230608201513.882950-1-ahalaney@redhat.com>
User-Agent: Mutt/2.2.9 (2022-11-12)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 03:15:13PM -0500, Andrew Halaney wrote:
> With wider usage on more boards, there have been reports of the
> following:
> 
>     [  315.016174] qcom-ethqos 20000.ethernet eth0: no phy at addr -1
>     [  315.016179] qcom-ethqos 20000.ethernet eth0: __stmmac_open: Cannot attach to PHY (error: -19)
> 
> which has been fairly random and isolated to specific boards.
> Early reports were written off as a hardware issue, but it has been
> prevalent enough on boards that theory seems unlikely.
> 
> In bring up of a newer piece of hardware, similar was seen, but this
> time _consistently_. Moving the reset to the mdio bus level (which isn't
> exactly a lie, it is the only device on the bus so one could model it as
> such) fixed things on that platform. Analysis on sa8540p-ride shows that
> the phy's reset is not being handled during the OUI scan if the reset
> lives in the phy node:
> 
>     # gpio 752 is the reset, and is active low, first mdio reads are the OUI
>     modprobe-420     [006] .....   154.738544: mdio_access: stmmac-0 read  phy:0x08 reg:0x02 val:0x0141
>     modprobe-420     [007] .....   154.738665: mdio_access: stmmac-0 read  phy:0x08 reg:0x03 val:0x0dd4
>     modprobe-420     [004] .....   154.741357: gpio_value: 752 set 1
>     modprobe-420     [004] .....   154.741358: gpio_direction: 752 out (0)
>     modprobe-420     [004] .....   154.741360: gpio_value: 752 set 0
>     modprobe-420     [006] .....   154.762751: gpio_value: 752 set 1
>     modprobe-420     [007] .....   154.846857: gpio_value: 752 set 1
>     modprobe-420     [004] .....   154.937824: mdio_access: stmmac-0 write phy:0x08 reg:0x0d val:0x0003
>     modprobe-420     [004] .....   154.937932: mdio_access: stmmac-0 write phy:0x08 reg:0x0e val:0x0014
> 
> Moving it to the bus level, or specifying the OUI in the phy's
> compatible ensures the reset is handled before any mdio access
> Here is tracing with the OUI approach (which skips scanning the OUI):
> 
>     modprobe-549     [007] .....    63.860295: gpio_value: 752 set 1
>     modprobe-549     [007] .....    63.860297: gpio_direction: 752 out (0)
>     modprobe-549     [007] .....    63.860299: gpio_value: 752 set 0
>     modprobe-549     [004] .....    63.882599: gpio_value: 752 set 1
>     modprobe-549     [005] .....    63.962132: gpio_value: 752 set 1
>     modprobe-549     [006] .....    64.049379: mdio_access: stmmac-0 write phy:0x08 reg:0x0d val:0x0003
>     modprobe-549     [006] .....    64.049490: mdio_access: stmmac-0 write phy:0x08 reg:0x0e val:0x0014
> 
> The OUI approach is taken given the description matches the situation
> perfectly (taken from ethernet-phy.yaml):
> 
>     - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
>       description:
>         If the PHY reports an incorrect ID (or none at all) then the
>         compatible list may contain an entry with the correct PHY ID
>         in the above form.
>         The first group of digits is the 16 bit Phy Identifier 1
>         register, this is the chip vendor OUI bits 3:18. The
>         second group of digits is the Phy Identifier 2 register,
>         this is the chip vendor OUI bits 19:24, followed by 10
>         bits of a vendor specific ID.
> 
> With this in place the sa8540p-ride's phy is probing consistently, so
> it seems the floating reset during mdio access was the issue. In either
> case, it shouldn't be floating so this improves the situation. The below
> link discusses some of the relationship of mdio, its phys, and points to
> this OUI compatible as a way to opt out of the OUI scan pre-reset
> handling which influenced this decision.
> 
> Link: https://lore.kernel.org/all/dca54c57-a3bd-1147-63b2-4631194963f0@gmail.com/
> Fixes: 57827e87be54 ("arm64: dts: qcom: sa8540p-ride: Add ethernet nodes")
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>

Reviewed-by: Brian Masney <bmasney@redhat.com>


