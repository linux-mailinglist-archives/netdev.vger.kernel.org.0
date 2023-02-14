Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3FF069591B
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 07:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbjBNGWO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 01:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjBNGWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 01:22:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 177DB118
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 22:22:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A68C861356
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:22:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5025C433D2;
        Tue, 14 Feb 2023 06:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676355732;
        bh=zJFTbC31SvG6fKUlsT+HKR2gbUdAoCg4NcA1R67o+wU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ehuTmrXrAAvFtaMZzAleceg1icF6ambKbheZx4EO3g+QRN6U9b0NQS+H4OWtFVbSY
         Iz709yoRi4Q/KTs5OcTLte0t4NEDlkgCE4RR6Gu+g8AdVSIqArF3IN9ZMfXzF91x+0
         7unCvLhwlyylUi5f1vHV+AWHEhPN3gGsHZTtKiFIcUqXDiphEYDfgxzPX+sEEHVqv1
         0zBrkxVbe18PLm6qmcqJQ5qQHwKnLApb69TMwm4KydVGjXPjpsm8VQ9aaTU9puNRUn
         H9kziWCRjwffEL5vBW4680EDNOMJxx0JgPxF9F6+aG6op6XO4ffssT4nw2uJciLjoS
         OKwq/5tGQqN9w==
Date:   Mon, 13 Feb 2023 22:22:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 04/10] devlink: health: Don't try to add trace
 with NULL msg
Message-ID: <20230213222210.4f027963@kernel.org>
In-Reply-To: <1676294058-136786-5-git-send-email-moshe@nvidia.com>
References: <1676294058-136786-1-git-send-email-moshe@nvidia.com>
        <1676294058-136786-5-git-send-email-moshe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 Feb 2023 15:14:12 +0200 Moshe Shemesh wrote:
> In case devlink_health_report() msg argument is NULL a warning is
> triggered, but then continue and try to print a trace with NULL pointer.
> 
> Fix it to skip trace call if msg pointer is NULL.

The trace macros take NULLs, can you double check?
Same story with adding a note why this is harmless as patch 2
