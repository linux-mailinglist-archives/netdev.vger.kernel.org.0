Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB68854B885
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 20:25:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350923AbiFNSYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 14:24:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239336AbiFNSYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 14:24:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0BD1CFE3;
        Tue, 14 Jun 2022 11:24:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB7736179F;
        Tue, 14 Jun 2022 18:24:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E480C3411D;
        Tue, 14 Jun 2022 18:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655231054;
        bh=hIwXgtz4Rm2256K1QLIkUm8SPR9n9OIyUpIFq2qxaWk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h+/t0LqxPpYsGNJyLqIDL/T0fPIAfNMiSZAtEuc7E3xhyRRc4t42cvlRG5V0ejxUk
         EYdcljJb/VoQCi/o6XreWfo0YiyLlmuX0lm4weH3qNYhDvOUFdI78UDm75rwa5wD2v
         ynWRG+1oVLTQoPH1fmDQWnR/91prvj8oEw+yDpeCTDpAshw/mORci3la3IWxxCzFYe
         GIChOT8UJUSTOqUezNG5gtoOLpLDaEra31FKsDRN03eWBBDxNLXFned7n9Yv5KvDgk
         +qe/Cix80mzUDcg7RYglljLbZbIRFTRH2nsNWxruX4jrua9RCVA1FNff0BsTU3FmXZ
         Zr6eyDUiTCWQg==
Date:   Tue, 14 Jun 2022 11:24:13 -0700
From:   Saeed Mahameed <saeed@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Erez Shitrit <erezsh@mellanox.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Yevgeny Kliteynik <kliteyn@nvidia.com>
Subject: Re: [PATCH mlx5-next 0/3] Add ICM header-modify-pattern RDMA API
Message-ID: <20220614182413.egpqoo2g3dveeudo@sx1>
References: <cover.1654605768.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cover.1654605768.git.leonro@nvidia.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07 Jun 15:47, Leon Romanovsky wrote:
>From: Leon Romanovsky <leonro@nvidia.com>
>
>SW steering manipulates packet's header using "modifying header" actions.
>Many of these actions do the same operation, but use different data each time.
>Currently we create and keep every one of these actions, which use expensive
>and limited resources.
>

Series applied to mlx5-next

>Now we introduce a new mechanism - pattern and argument, which splits
>a modifying action into two parts:
>1. action pattern: contains the operations to be applied on packet's header,
>mainly set/add/copy of fields in the packet
>2. action data/argument: contains the data to be used by each operation
>in the pattern.
>
>This way we reuse same patterns with different arguments to create new
>modifying actions, and since many actions share the same operations, we end
>up creating a small number of patterns that we keep in a dedicated cache.
>
>These modify header patterns are implemented as new type of ICM memory,
>so the following kernel patch series add the support for this new ICM type.
>
>Thanks
>

