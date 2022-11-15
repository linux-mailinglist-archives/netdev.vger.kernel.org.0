Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4247629EE1
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 17:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbiKOQVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 11:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230463AbiKOQVu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 11:21:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FCC10C3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 08:21:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C90E618E8
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 16:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC595C433D6;
        Tue, 15 Nov 2022 16:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668529308;
        bh=ZtkzmUQwsM2BGpRbgNNgxmb0C0zEu1yHUadmrXroM7E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CuuiemPBEMHuajqsIa/A4QKdHQi17wvmEtUwg3Y0ORqYQ67AzjGFGh6CcPtyIk13D
         b/A5cqPRer1Yq1PNgn33od3+xrNAlQvowvshnKjcMD/xp/cwvY3+jm47LajzMLf0a4
         gyHwWK/taZC512/XxC2HvSvoNtiQPV6B8+lOXJJosnV4mdmnAC9k1IQF4jbq2BOqJs
         ki7oNHMP//uv4JZUSrngsGAUSyiVIzwSyqDZF4ksqP7hKib+DkDAwjUDm6qnA2Wr2j
         OpRQsx35SpTbSGDIb/tv/rZx5NdIy4BWFqXa+BCFq9lWtr5i3qJi1UbJwxmH58roRN
         1Gzri5kE8ciOQ==
Date:   Tue, 15 Nov 2022 08:21:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Daniele Palmas <dnlplm@gmail.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] ethtool: add tx aggregation parameters
Message-ID: <20221115082147.1456a39b@kernel.org>
In-Reply-To: <6d41e6da-aaa4-6569-d027-896e25711c86@nvidia.com>
References: <20221109180249.4721-1-dnlplm@gmail.com>
        <20221109180249.4721-2-dnlplm@gmail.com>
        <20221111090720.278326d1@kernel.org>
        <8b0aba42-627a-f5f5-a9ec-237b69b3b03f@nvidia.com>
        <CAGRyCJF49NMTt9aqPhF_Yp5T3cof_GtL7+v8PeowsBQWG0bkJQ@mail.gmail.com>
        <20221114164238.209f3a9d@kernel.org>
        <6d41e6da-aaa4-6569-d027-896e25711c86@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Nov 2022 12:59:47 +0200 Gal Pressman wrote:
> Thanks for the explanation.
> How would this apply to a pci netdev driver?

I don't think it would. I've only seen it on USB devices.
We should add a note to this effect to the documentation.
Perhaps other funny buses may use it but PCIe remains efficient 
for packet sizes below standard MTUs so unlikely we'd need this
sort of aggregation.
