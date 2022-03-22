Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABB994E3B46
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 09:55:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbiCVI4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 04:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiCVI4f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 04:56:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550E3F1
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 01:55:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B379461646
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 08:55:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19818C340F2
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 08:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647939307;
        bh=7gD/CF3+DINfj3pu9jiHI44C/OKCFrwOx47e7QWUJfo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=eJkP8FXSxipFCxJNktP79fIPaz0/3z+z9nWXUqyzjb0oJBYs+dnVaro4MlrwvZpJi
         99+QToKJ4xF5RN7u1m8d5FBKV0sI3Fj3gjKq3TahAzUeIij5Ajidhbl+NdgguzxDnu
         RbBTNbBg7KYzAzmqDZfPTgWVuUvlAn8J6FVGM3XT9wsnlmNI3RbuRJWRcIe070qdML
         AEKuMVm4AJF2ToIbwHLIOVH1tG5mjE1yXtLwe30hMZpquTCAOadGApyd6DBvAJ1coG
         cl/g0adf+5pyWXQWhYyuUcatD3axkhUdPhzpxz60bgVP/r0Gj4onB2OKJdzITw660a
         6+bGFWPV9VT2Q==
Received: by mail-wr1-f49.google.com with SMTP id r13so8870492wrr.9
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 01:55:07 -0700 (PDT)
X-Gm-Message-State: AOAM532jPJDaqCD5hHX2pgG0kzfSV2vpOmEzRMPOVMIxXVWkzZyqjwjO
        X8Nfwsum0vKZAhOGvKKftABeOkq60Y3Vr+PAnfM=
X-Google-Smtp-Source: ABdhPJz1tWmtPtxZ+OI0CxhJT0nNCAhtKU/wXqyQq3qsn1P5V1TESPtY6YEpZikLo1lK6qsLynhWTqtGdH0eLRFKMEo=
X-Received: by 2002:adf:f04b:0:b0:203:f0bf:1d83 with SMTP id
 t11-20020adff04b000000b00203f0bf1d83mr17539124wro.317.1647939305284; Tue, 22
 Mar 2022 01:55:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220321144013.440d7fc0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <m37d8mieun.fsf@t19.piap.pl>
In-Reply-To: <m37d8mieun.fsf@t19.piap.pl>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Tue, 22 Mar 2022 09:54:49 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3x47zHZU54XhW2juoP3sBxdKH8XknLTOL-EFZc0=9TJA@mail.gmail.com>
Message-ID: <CAK8P3a3x47zHZU54XhW2juoP3sBxdKH8XknLTOL-EFZc0=9TJA@mail.gmail.com>
Subject: Re: Is drivers/net/wan/lmc dead?
To:     =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Stanley-Jones <asj@cban.com>,
        Rob Braun <bbraun@vix.com>, Michael Graff <explorer@vix.com>,
        Matt Thomas <matt@3am-software.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Zhao Qiang <qiang.zhao@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 22, 2022 at 9:14 AM Krzysztof Ha=C5=82asa <khalasa@piap.pl> wro=
te:
> QUICC isn't exactly new :-) but it seems to be referenced by arm64 and
> PPC DTS files (so this isn't the original ~68020 QUICC).

Zhao Qiang from NXP added the fsl,ucc-hdlc node to arm64 ls1043a,
so I assume they actually support that device. The chip was introduced
in 2015, with a 15+ year product longevity cycle. The older arm32 based
ls1021 and the ls1088 also mention the quicc engine in the marketing
material but not the kernel sources, and I found no evidence of them
on any of the later layerscape chips.

       Arnd
