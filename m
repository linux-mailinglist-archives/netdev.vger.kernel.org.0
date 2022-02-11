Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C93A4B1F00
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347578AbiBKHIM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:08:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245460AbiBKHIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:08:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BF3CEF;
        Thu, 10 Feb 2022 23:08:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E896B827DE;
        Fri, 11 Feb 2022 07:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25784C340E9;
        Fri, 11 Feb 2022 07:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644563288;
        bh=bNbucoU4hGhTLdhp/tSDciDNIXbgrdpLrXZPPdv1RXQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=BAQVHmydGY+fQk7uPEzxU3BxASE8nYb458eyGnJm3hkpchxrPYJPZrpqHfd0tVIO0
         slDuz3Nh4bipEjlwZR70IGX8Jao04OKIMmNdtDoG1DwK+SRr4V899bmHY2obn5g+7w
         QkMN3FFN26FXW+fxgbmA73/zrnEkur2tr8pySXoKBffc9Cj+tfubfg9pOHno2laCwQ
         9mTdMxu+fIS6ZsD9CrtNYhshRWB+fEn1kwb6AwNO9vEHqikeb4US2OxmqGMVCsjo3T
         4xOsZCC1tEF3+k38Js65b9KOxmwaDbVI//y4p73oQyI0RrB8bS5A397Dl/ml+TosnX
         Ufx0dorEjWvfQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?utf-8?Q?Roh?= =?utf-8?Q?=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v9 05/24] wfx: add main.c/main.h
In-Reply-To: <2534738.AP0T11PbZZ@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Thu,
        10 Feb 2022 17:37:51 +0100")
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
        <39159625.OdyKsPGY69@pc-42> <87a6ey3d0e.fsf@kernel.org>
        <2534738.AP0T11PbZZ@pc-42>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Fri, 11 Feb 2022 09:08:01 +0200
Message-ID: <874k553mpa.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
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

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

>> > There is also the patch 01/24 about the SDIO IDs.
>> >
>> > I think the v10 could contain only 3 patches:
>> >
>> >     1. mmc: sdio: add SDIO IDs for Silabs WF200 chip
>> >     2. dt-bindings: introduce silabs,wfx.yaml
>> >     3. [all the patches 3 to 24 squashed]
>> >
>> > Would it be right for you?
>>=20
>> TBH I don't see the point of patch 3 at this moment, we have had so many
>> iterations with the full driver already. If people want to look at the
>> driver, they can check it from the staging tree. So in the next round I
>> recommend submitting only patches 1 and 2 and focus on getting all the
>> pending patches to staging tree.
>
> Ok.
>
>> And the chances are that a big patch like that would be filtered by the
>> mailing lists anyway.
>
> I believe that with -M, the patch would be very small.

Ah, you mean patch 3 would be about moving wfx from drivers/staging to
drivers/net/wireless? Yeah, with -M that would be a good idea.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
