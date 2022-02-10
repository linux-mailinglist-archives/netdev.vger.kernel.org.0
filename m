Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4794B12A3
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244153AbiBJQZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:25:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239459AbiBJQZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:25:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DA8C24;
        Thu, 10 Feb 2022 08:25:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 239E961D45;
        Thu, 10 Feb 2022 16:25:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC470C004E1;
        Thu, 10 Feb 2022 16:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644510312;
        bh=IFxBT2jDyEPai4ZZFQxaTM2IF26+Q3DtIrCvz2/aIaw=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WFoy6ph4jj2asioFVCnfptkcZoeZVEwREMIetSpPnnSfxQms6+XAU+MlkkjsXrp0l
         WcJsNoBb0gkyheSV+LzkR7PNqzugiaQMQ/B/UQvp+LbAczFTcurXEuXrCWiCXdj5QK
         8Yhit0lsF9bgbhv0EYlbhkYgWid+j1mCFiHAw81qSa7R0Vyxi13jdIPn1maIPfLbNm
         Em+t58PD0ZONwlnPdJHsARd5uvmip3lgo3NWLj8mVi+ammO3kvTVlFytFGflRrqImT
         Jx/3tg2fopGf34Dt6UPyVNfD42/G4eGYzzdbLvMrd00BIZA6QTwK2LzJzEw/uPB3Xp
         TNk/Xnneg3ZoA==
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
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com>
        <4055223.VTxhiZFAix@pc-42> <87ee4a3hd4.fsf@kernel.org>
        <39159625.OdyKsPGY69@pc-42>
Date:   Thu, 10 Feb 2022 18:25:05 +0200
In-Reply-To: <39159625.OdyKsPGY69@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Thu,
        10 Feb 2022 16:13:16 +0100")
Message-ID: <87a6ey3d0e.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
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

> On Thursday 10 February 2022 15:51:03 CET Kalle Valo wrote:
>> J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:
>> > On Thursday 10 February 2022 15:20:56 CET Kalle Valo wrote:
>> >> J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:
>> >>
>> >> > Kalle, is this function what you expected? If it is right for you, =
I am
>> >> > going to send it to the staging tree.
>> >>
>> >> Looks better, but I don't get why '{' and '}' are still needed. Ah, d=
oes
>> >> the firmware require to have them?
>> >
>> > Indeed. If '{' and '}' are not present, I guarantee the firmware will =
return
>> > an error (or assert). However, I am more confident in the driver than =
in the
>> > firmware to report errors to the user.
>>=20
>> Agreed.
>>=20
>> > If there is no other comment, I am going to:
>> >   - submit this change to the staging tree
>>=20
>> Good, it's important that you get all your changes to the staging tree
>> before the next merge window.
>>=20
>> >   - publish the tool that generate this new format
>> >   - submit the PDS files referenced in bus_{sdio,spi}.c to linux-firmw=
are
>> >   - send the v10 of this PR
>>=20
>> I'm not sure if there's a need to send a full patchset anymore? We are
>> so close now anyway and the full driver is available from the staging
>> tree, at least that's what I will use from now on when reviewing wfx.
>>=20
>> What about the Device Tree bindings? That needs to be acked by the DT
>> maintainers, so that's good to submit as a separate patch for review.
>
> There is also the patch 01/24 about the SDIO IDs.
>
> I think the v10 could contain only 3 patches:
>
>     1. mmc: sdio: add SDIO IDs for Silabs WF200 chip
>     2. dt-bindings: introduce silabs,wfx.yaml
>     3. [all the patches 3 to 24 squashed]
>
> Would it be right for you?

TBH I don't see the point of patch 3 at this moment, we have had so many
iterations with the full driver already. If people want to look at the
driver, they can check it from the staging tree. So in the next round I
recommend submitting only patches 1 and 2 and focus on getting all the
pending patches to staging tree.

And the chances are that a big patch like that would be filtered by the
mailing lists anyway.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
