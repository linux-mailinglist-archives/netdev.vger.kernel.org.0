Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C0D628E96
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 01:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiKOAn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 19:43:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiKOAn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 19:43:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90391704B
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 16:43:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73E52B810A0
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 00:43:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC976C433D6;
        Tue, 15 Nov 2022 00:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668473033;
        bh=mmvSFYUkaAqPI0HV9MfjCC1iViIR0ag7KOgEuRk3IiY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mghwUDdlyMMZ92q9l2lxvYPtDBXu8dfO0Uw4m7pl8FjpF1nS23AR2yU/QBK+WN7oA
         vTRg8S1ZszxkpVAOce3riwjSHHdVugfelNPBwl8/Rhw5ZOFajI18xK6nSQLCoAgoHR
         3Iuob7ZzQ32eEl8FxEfe6pZ6JwLI1fL7+GKdO4mLS5afi3OIHoKXsz4NxV2YxOX0VZ
         rQBJ+hh+uDG+WWXPCyfJ6XiX59poWk3Qj5BWcSiKhTM6iCDDTdJZxdfSftptlApKRG
         UdoqHIZgYNS4cKfz6TX58jl6NnNl9ou5xlznmTPziEM60RN+XLwXX5h6/TxWZWEbt3
         lPtsTogiXtlTg==
Date:   Mon, 14 Nov 2022 16:43:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/3] net: qualcomm: rmnet: add tx packets
 aggregation
Message-ID: <20221114164352.7dbb575f@kernel.org>
In-Reply-To: <87tu31hlyb.fsf@miraculix.mork.no>
References: <20221109180249.4721-1-dnlplm@gmail.com>
        <20221109180249.4721-3-dnlplm@gmail.com>
        <20221111091440.51f9c09e@kernel.org>
        <CAGRyCJEtXx4scuFYbpjpe+-UB=XWQX26uhC+yPJPKCoYCWMM2g@mail.gmail.com>
        <87tu31hlyb.fsf@miraculix.mork.no>
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

On Mon, 14 Nov 2022 11:25:32 +0100 Bj=C3=B8rn Mork wrote:
> It looks like an attempt to "cheat" latency measurements.  I don't think
> we should do that.  Aggregation may be necessary to achieve maximum
> throughput in a radio network, but has its obvious bufferbloat downside.
> Let's not hide that fact.  Users deserve to know, and tune their systems
> accordingly.  Things like this will only make that more difficult

=F0=9F=91=8D
