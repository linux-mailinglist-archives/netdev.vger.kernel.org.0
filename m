Return-Path: <netdev+bounces-6312-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DA9D715A9E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 11:49:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C3FC2280FDA
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:49:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C44DF156C1;
	Tue, 30 May 2023 09:49:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B721312B9C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 09:49:25 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8E5FA
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685440162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B2gmQ/a+oAFA19ljaGNIngxILT41zCscP4KKC+5R6wc=;
	b=JPvnSv4qZHn0UnkCFhCR/rWiK/ou82ah9ZpIg73OZn+fwmxGW1qS1iNC7xWWGnqkHBzKeG
	onT7AEqOpnK5U+XNF2QAPyexwc9IGiUFdB2bB+BHjS5P767z6DbGKzycFuhd7QIJqv6FZP
	EBQHw9uuxSnV3yo++SLHbnak3JzbzWs=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-455-ZLkYgvxzNAOKsxupk3ez1g-1; Tue, 30 May 2023 05:49:21 -0400
X-MC-Unique: ZLkYgvxzNAOKsxupk3ez1g-1
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-62607e62fa8so5037936d6.1
        for <netdev@vger.kernel.org>; Tue, 30 May 2023 02:49:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685440161; x=1688032161;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B2gmQ/a+oAFA19ljaGNIngxILT41zCscP4KKC+5R6wc=;
        b=aVy00LcJf55DX7i6AJKEmYMZp70DE5k303eOtIaGB4YzRkqRDGjo33T6+zdR9jmAvA
         cP1x4Bvg4Ov/CmG3ZZOjq/kkLl+fXranNGV2EI5BMvrdqxZJ4Q1c4k/d7hB9pwtlfJ/f
         mOPdWkko9XNIwHCVtcsu1rm0InKZQV+2/4t9N3E6AE40FpfgduzTe3GsZmkpJXjTCdmO
         JYkIFtm8apVR5YrN2Bmy3/0hm60uYaAQGen0/ggo3651xHWFBdeVt6EwghEqAEYqLgUf
         /+wE6WIX7oD54QRX6XElSlLnCRcGSb/EI//+vCwcvWF4TCN9jjSgS2DYKr7sNBBVsUoy
         +oWg==
X-Gm-Message-State: AC+VfDyCdBfzuatksc0SOL402WNp3kGDP/H/9CDX/ANOtK7e6UD1FVX/
	oQfklTE/JaQjGsgdxVRxfNBaCxtAGbxhLy2MoEBZVtgrex1FoXT/BCF/rVvVe1NCY9K1HHgczx1
	KA5U92zcP1IjsFL6x
X-Received: by 2002:a05:622a:1883:b0:3f7:fab0:6308 with SMTP id v3-20020a05622a188300b003f7fab06308mr1340946qtc.6.1685440160949;
        Tue, 30 May 2023 02:49:20 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7w88awc4basn85TiY7eWn8aDcCDQdVwwZSYAOezEQ1vOtXU0iBSdWaMjHX4FEB7CRfaaqqig==
X-Received: by 2002:a05:622a:1883:b0:3f7:fab0:6308 with SMTP id v3-20020a05622a188300b003f7fab06308mr1340932qtc.6.1685440160704;
        Tue, 30 May 2023 02:49:20 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-248-97.dyn.eolo.it. [146.241.248.97])
        by smtp.gmail.com with ESMTPSA id gd22-20020a05622a5c1600b003f0af201a2dsm4572151qtb.81.2023.05.30.02.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 May 2023 02:49:20 -0700 (PDT)
Message-ID: <0939d69afbf1173f4b62758d1d448c85217abcf1.camel@redhat.com>
Subject: Re: [PATCH net-next v4 6/6] net: phy: microchip_t1s: add support
 for Microchip LAN865x Rev.B0 PHYs
From: Paolo Abeni <pabeni@redhat.com>
To: =?ISO-8859-1?Q?Ram=F3n?= Nordin Rodriguez
	 <ramon.nordin.rodriguez@ferroamp.se>, Parthiban Veerasooran
	 <Parthiban.Veerasooran@microchip.com>
Cc: andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk, 
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 netdev@vger.kernel.org,  linux-kernel@vger.kernel.org,
 horatiu.vultur@microchip.com,  Woojung.Huh@microchip.com,
 Nicolas.Ferre@microchip.com,  Thorsten.Kummermehr@microchip.com
Date: Tue, 30 May 2023 11:49:16 +0200
In-Reply-To: <ZHRPRBwJ5jHs6vLz@debian>
References: <20230526152348.70781-1-Parthiban.Veerasooran@microchip.com>
	 <20230526152348.70781-7-Parthiban.Veerasooran@microchip.com>
	 <ZHRPRBwJ5jHs6vLz@debian>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 2023-05-29 at 09:07 +0200, Ram=C3=B3n Nordin Rodriguez wrote:
> On Fri, May 26, 2023 at 08:53:48PM +0530, Parthiban Veerasooran wrote:
> > Add support for the Microchip LAN865x Rev.B0 10BASE-T1S Internal PHYs
> > (LAN8650/1). The LAN865x combines a Media Access Controller (MAC) and a=
n
> > internal 10BASE-T1S Ethernet PHY to access 10BASE=E2=80=91T1S networks.=
 As
> > LAN867X and LAN865X are using the same function for the read_status,
> > rename the function as lan86xx_read_status.
> >=20
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > Signed-off-by: Parthiban Veerasooran <Parthiban.Veerasooran@microchip.c=
om>
> > ---
>=20
> I accidentally sent both reviewed-by and tested by, should only have
> been reviewed-by.

N.P. I'll strip your tested-by tag from this patch when I'll apply it.

Cheers,

Paolo


