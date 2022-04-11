Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31DB64FC58E
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 22:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244842AbiDKUJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 16:09:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244615AbiDKUJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 16:09:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8F8275C9
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 13:07:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A21B3615B4
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 20:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85B69C385A3;
        Mon, 11 Apr 2022 20:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649707637;
        bh=akUKc2qMPdmvIzLjRs9PUc2/arBas9GZBjis6mpFz7Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mOBMDviR8AXtuzyyWnn/ZEZ1ozwruiGE0WmlmDKTzEEygB873DSrDhcqGwU8S0S+e
         kJjoGpLD8leXsSgASmZLBLTplwHzuMl8BK2w8QxYR83M47omOJLTQL8CzSnRgYK7zI
         HXgSE95ihDME8HKY0rUEb8rZEDHODI8XDZx0qq/RSlJS+fic7cjzLODjQFsft5G9RS
         nBbTbutiIJ6bK07WDBfZLab3Ih/RVO8OCGwfy4ciqKP9x0GnY9iJr6e2MNKoaHMAxT
         RVNS5ns9fcmpRaWDOGmhGsnvZh5lDBMGK9TZHNi7c0YH/OUrnC3as2j9+qQIM0tcLB
         PaiSuX3POf0Aw==
Date:   Mon, 11 Apr 2022 13:07:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Josua Mayer <josua@solid-run.com>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        netdev@vger.kernel.org, alvaro.karsz@solid-run.com,
        Michael Hennerich <michael.hennerich@analog.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Alexandru Ardelean <alexandru.ardelean@analog.com>
Subject: Re: [PATCH 1/3] dt: adin: document clk-out property
Message-ID: <20220411130715.516fc5cc@kernel.org>
In-Reply-To: <b519690c-a487-e64c-86e1-bd37e38dc7a7@solid-run.com>
References: <20220410104626.11517-1-josua@solid-run.com>
        <20220410104626.11517-2-josua@solid-run.com>
        <d83be897-55ee-25d2-4048-586646cd7151@linaro.org>
        <bc0e507b-338b-8a86-1a7b-8055e2cf9a3a@solid-run.com>
        <e0511d39-7915-3ce1-60c7-9d7739f1b253@linaro.org>
        <b519690c-a487-e64c-86e1-bd37e38dc7a7@solid-run.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Apr 2022 10:42:18 +0300 Josua Mayer wrote:
> > The binding should describe the hardware, not implementation in Linux,
> > therefore you should actually list all possible choices. The driver then
> > can just return EINVAL on unsupported choices (or map them back to only
> > one supported). =20
>=20
> I have prepared a draft for the entries that should exist, it covers=20
> five of the 6 available bits. Maybe you can comment if this is=20
> understandable?
>=20
>  =C2=A0 adi,phy-output-clock:
>  =C2=A0=C2=A0=C2=A0 description: Select clock output on GP_CLK pin. Three=
 clocks are=20
> available:
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 A 25MHz reference, a free-running 125MHz =
and a recovered 125MHz.
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 The phy can also automatically switch bet=
ween the reference and the
>  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 respective 125MHz clocks based on its int=
ernal state.
>  =C2=A0=C2=A0=C2=A0 $ref: /schemas/types.yaml#/definitions/string
>  =C2=A0=C2=A0=C2=A0 enum:
>  =C2=A0=C2=A0=C2=A0 - 25mhz-reference
>  =C2=A0=C2=A0=C2=A0 - 125mhz-free-running
>  =C2=A0=C2=A0=C2=A0 - 125mhz-recovered
>  =C2=A0=C2=A0=C2=A0 - adaptive-free-running
>  =C2=A0=C2=A0=C2=A0 - adaptive-recovered
>=20
> Bit no. 3 (GE_REF_CLK_EN) is special in that it can be enabled=20
> independently from the 5 choices above,
> and it controls a different pin. Therefore it deserves its own property,=
=20
> perhaps a flag or boolean adi,phy-output-ref-clock.
> Any opinion if this should be added, or we can omit it completely?

Noob question - can you explain how this property describes HW?
I thought we had a framework for clock config, and did not require
vendor specific properties of this sort.

The recovered vs free running makes the entire thing sound like
a SyncE related knob, irrelevant to normal HW operation.
