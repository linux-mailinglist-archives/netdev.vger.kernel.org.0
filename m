Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34DE96EA20D
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 04:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbjDUC62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 22:58:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231590AbjDUC61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 22:58:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DEA44210;
        Thu, 20 Apr 2023 19:57:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72FF164D53;
        Fri, 21 Apr 2023 02:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A1BCC433D2;
        Fri, 21 Apr 2023 02:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682045816;
        bh=bimPx7thQ2VkhGHYmgwVjsR/nA45Fhq6St9JatsrN48=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Vh3mzxw1m72VU2aJbLAS1Yck5k2f2qlR89dL1i5jdSnLDD3NPe1u28JKWbFw9xaCo
         7kOikul6d+mSiyfJKareNta5gFtzXOyn7fwZJpQ/WAXylyIz+gbRE68X14VWPiadoK
         0Fiy4+CVF9zmKancTxzSEFB+9WknMR7NqiKL/O73XFmZp+E70wHoA1VhJC7T+WDSJN
         TnNjOTsawxPnAPdIw/A654wDYnt406yGGKd4RSDE5XVz9YJNE8bMH6w2yBdJXHzwQk
         4I5tenVXnCJigqt8IJK0AJYEHgMJTZtdKOuVvIT7kTkNHXsIcpuglgh/QeMEsf8Ydf
         LaSEzmsSRDlHg==
Date:   Thu, 20 Apr 2023 19:56:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Yuval Mintz <Yuval.Mintz@qlogic.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] qed/qed_sriov: propagate errors from qed_init_run
 in enable_vf_access
Message-ID: <20230420195655.24433b80@kernel.org>
In-Reply-To: <20230420082016.335314-1-d-tatianin@yandex-team.ru>
References: <20230420082016.335314-1-d-tatianin@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Apr 2023 11:20:16 +0300 Daniil Tatianin wrote:
> The return value was silently ignored, and not propagated to the caller.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> Fixes: 1408cc1fa48c ("qed: Introduce VFs")
> Signed-off-by: Daniil Tatianin <d-tatianin@yandex-team.ru>
> ---
> I'm not familiar enough with the code to know if there's anything we
> have to undo here in case qed_init_run returns an error. Any additional
> comments are appreciated.

This patch does not inspire confidence. This is a pretty old driver, 
you need to provide some reasoning why checking the return value is
important, and correct.
-- 
pw-bot: cr
