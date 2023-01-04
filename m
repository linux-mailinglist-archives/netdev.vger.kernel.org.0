Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 069E865CC14
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 04:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjADDN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 22:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjADDNy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 22:13:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A97C217064;
        Tue,  3 Jan 2023 19:13:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 563E5B81100;
        Wed,  4 Jan 2023 03:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F294C433EF;
        Wed,  4 Jan 2023 03:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672802031;
        bh=PR2TZrwaf2NKv5zEeBkBBot+WbIHKd39Vkjy0nxO4l4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TbQRIu+0kVEZWEp9QbbF4cZRlAFfHpBiYQaFZ3VuKObuxGbZQE+WmAfmndCZS4K4K
         p5zJOzeYoR3beGkBw3xq54ByNXj9VnGdzPkJObtEAnnVSlgey6+qsdzscz7Dji1apj
         b9kkdTnWJqjTHWf7+xBv9S/BTVrxCRrBim2qXw33ECrrFPA62TMkTg31MpF2d+ydrM
         PwRBHvw81hPC+y88Azw9k8nZYKa+Bsi/fpP83q23N7ePYegz1vFzfptmKKzQ/KM70V
         +1y+/HUSjN0jJWka7p2IeZRBsNxR1YB9S2+l8lEQJNQc+OXbtxvhQK9bKMLFekVCbi
         +ZCMSXhL/ES3g==
Date:   Tue, 3 Jan 2023 19:13:49 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Geetha sowjanya <gakula@marvell.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pabeni@redhat.com,
        davem@davemloft.net, edumazet@google.com, sbhatta@marvell.com,
        hkelam@marvell.com, sgoutham@marvell.com
Subject: Re: [PATCH net] octeontx2-af: Fix QMEM struct memory allocation
Message-ID: <20230103191349.30098394@kernel.org>
In-Reply-To: <Y7P9/7nlpH9TXcld@unreal>
References: <20230103040917.16151-1-gakula@marvell.com>
        <Y7P9/7nlpH9TXcld@unreal>
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

On Tue, 3 Jan 2023 12:05:51 +0200 Leon Romanovsky wrote:
> No, GFP_ATOMIC is for memory allocations in atomic context and not for
> separation between reserved and unreserved memory.

Indeed, using ATOMIC to avoid CMA seems like an odd hack.
I haven't encountered this before.
