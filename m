Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B157355CF82
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231356AbiF0K1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 06:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiF0K1A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 06:27:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4440D5FEF;
        Mon, 27 Jun 2022 03:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D03BE612C3;
        Mon, 27 Jun 2022 10:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F80C3411D;
        Mon, 27 Jun 2022 10:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656325619;
        bh=vjTgWiHh+robp6L83MZ74F5DMaJm4hX3GEkyX/9p/ss=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=ZwSP23aHPP1I3leRTLNvLo1GAOJZqOl1HOcixTm7IAeczV1M8txQaKNuf1cpTwfEy
         pU95hRPpxaOFsMjvaBeQa7JsYUJKSSJslYDfZGIJ1E7fz0IrA5lZSxzgIpyyFFbVfN
         aLOtpAcaAI4f7x7R4hoEIM3XO47OCOYhGdy7N5lBvqOZhtbvHN5bXyCs2lK2udCb12
         /rBSUfw8JVEH8hDyOdxM3b0UGCDtbDJFWzIaP0oFSVXSTOtcuiU8hL18FKjSsPiRV5
         f+b6bJ1oOflDlSF4ttcRODc8KaHTcpcD9fI1fIrhMHc25ri4RQBXHdOdpQVhaYJnd8
         kti9DU8aPeLyA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Robert Marko <robimarko@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: wireless: ath11k: add new DT entry for board ID
In-Reply-To: <20220621135339.1269409-1-robimarko@gmail.com> (Robert Marko's
        message of "Tue, 21 Jun 2022 15:53:38 +0200")
References: <20220621135339.1269409-1-robimarko@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Mon, 27 Jun 2022 13:26:51 +0300
Message-ID: <87o7yeo104.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Robert Marko <robimarko@gmail.com> writes:

> bus + qmi-chip-id + qmi-board-id and optionally the variant are currently
> used for identifying the correct board data file.
>
> This however is sometimes not enough as all of the IPQ8074 boards that I
> have access to dont have the qmi-board-id properly fused and simply return
> the default value of 0xFF.
>
> So, to provide the correct qmi-board-id add a new DT property that allows
> the qmi-board-id to be overridden from DTS in cases where its not set.
> This is what vendors have been doing in the stock firmwares that were
> shipped on boards I have.

What's wrong with using 0xff? Ie. something like this:

bus=ahb,qmi-chip-id=0,qmi-board-id=255,variant=foo

Or maybe even just skip qmi-board-id entirely if it's not supported? So
that the board file string would be something like:

bus=ahb,qmi-chip-id=0,variant=foo

I really would like to avoid adding more DT properties unless it's
absolutely critical.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
