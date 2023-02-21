Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD0DB69E47A
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 17:25:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233951AbjBUQZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 11:25:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbjBUQZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 11:25:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9D624482
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 08:25:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45272B80E8E
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 16:25:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944A4C433D2;
        Tue, 21 Feb 2023 16:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676996752;
        bh=YGNIZMX0w5fsC2wzXYJDMTgW7jnokS+aOiAJo13HWt4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=slvsVygaLxAIo677IKSPsLvxtoLoNLI00RCCSuWCXwHplAP+0iUEdHx3NWGKzqZ+3
         moa3Uf45ZI2FZOZd0fOPajh/AZHS9GUTBD3sHMnK3faa9GtRPeMg5/cBh1A2yx8gjG
         H+EHxP9UnnbeClEMqVs4mxR9kMeUey7IBSGIEnH1k+LM9MK3yN1a+nUH132y3vxZPN
         jeellG9O1hmcvbJk1z9RM6QAKabyPw7nBZ/IknsCteVuJgRiUM8wGWjc10RnIwXEkk
         I5Rwt3Pw4Q3F5yfeSqmLmiz8i2tWDtls9Rs2R02VrIP3xpgnR0ihQJvMW3hwYpvQ+i
         nuFkoqeAcnIrg==
Date:   Tue, 21 Feb 2023 08:25:50 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?w43DsWlnbw==?= Huguet <ihuguet@redhat.com>
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        richardcochran@gmail.com, netdev@vger.kernel.org,
        Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net-next v4 0/4] sfc: support unicast PTP
Message-ID: <20230221082550.5f694cce@kernel.org>
In-Reply-To: <20230221125217.20775-1-ihuguet@redhat.com>
References: <20230221125217.20775-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Feb 2023 13:52:13 +0100 =C3=8D=C3=B1igo Huguet wrote:
> Unicast PTP was not working with sfc NICs.
>=20
> The reason was that these NICs don't timestamp all incoming packets,
> but instead they only timestamp packets of the queues that are selected
> for that. Currently, only one RX queue is configured for timestamp: the
> RX queue of the PTP channel. The packets that are put in the PTP RX
> queue are selected according to firmware filters configured from the
> driver.
>=20
> Multicast PTP was already working because the needed filters are known
> in advance, so they're inserted when PTP is enabled. This patches
> add the ability to dynamically add filters for unicast addresses,
> extracted from the TX PTP-event packets.
>=20
> Since we don't know in advance how many filters we'll need, some info
> about the filters need to be saved. This will allow to check if a filter
> already exists or if a filter is too old and should be removed.
>=20
> Note that the previous point is unnecessary for multicast filters, but
> I've opted to change how they're handled to match the new unicast's
> filters to avoid having duplicate insert/remove_filters functions,
> once for each type of filter.
>=20
> Tested: With ptp4l, all combinations of IPv4/IPv6, master/slave and
> unicast/multicast


# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.
