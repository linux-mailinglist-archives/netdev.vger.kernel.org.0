Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94F97686D9C
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 19:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjBASFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 13:05:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231946AbjBASFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 13:05:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F0B7CC96
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 10:04:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78C1D618F9
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 18:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D723C433EF;
        Wed,  1 Feb 2023 18:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675274695;
        bh=a2CFpdH4rsCMNWh04L+MTq34Wn7rU9CRZf8PYynZFnY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XrF5E8de+mtKiLqUSY0CL4qGjXlPWhuhN6bvGkqHGnu8LT6VrpWUqN4YZhCsWKHhK
         vaTIjPWvHlDxZ+jblUDevWFumKmY1jQneHoGBLPF1B9OMILXHZCep5RIq5jWi15xBe
         Fas3rNoW7mETpmUkU1f8usQO/t920QUq/qG4AA3IUMmPqn7c895h/Umhr0a37K7bBi
         TjPs2iYNOOSxmJX6KsNhD+jdMSb7iUF1XOhf8QaLmyrQtt09cowdU5/Jnuwjz4OSJO
         DHwal6EaKliCOCDON61jzgDh6pFB8J3Ed3BxucCo4UXLgO960hHnFbRcwEa2oinSOe
         RRX7tattRXJ6Q==
Date:   Wed, 1 Feb 2023 10:04:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        pabeni@redhat.com, edumazet@google.com, Tom Rix <trix@redhat.com>,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        vinicius.gomes@intel.com, Simon Horman <simon.horman@corigine.com>,
        Sasha Neftin <sasha.neftin@intel.com>,
        Naama Meir <naamax.meir@linux.intel.com>
Subject: Re: [PATCH net 1/1] igc: return an error if the mac type is unknown
 in igc_ptp_systim_to_hwtstamp()
Message-ID: <20230201100454.61f32747@kernel.org>
In-Reply-To: <Y9os+zttPvt5mlFM@nanopsycho>
References: <20230131215437.1528994-1-anthony.l.nguyen@intel.com>
        <Y9os+zttPvt5mlFM@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 1 Feb 2023 10:12:27 +0100 Jiri Pirko wrote:
> >@@ -652,7 +655,8 @@ static void igc_ptp_tx_hwtstamp(struct igc_adapter *=
adapter)
> >=20
> > 	regval =3D rd32(IGC_TXSTMPL);
> > 	regval |=3D (u64)rd32(IGC_TXSTMPH) << 32;
> >-	igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval);
> >+	if (igc_ptp_systim_to_hwtstamp(adapter, &shhwtstamps, regval)) =20
>=20
> Use variable to store the return value.

Is that a rule.. IDK.. there's probably worse code in this driver =F0=9F=A4=
=B7=EF=B8=8F
The return value can't be propagated further anyway, since this is=20
a work.
