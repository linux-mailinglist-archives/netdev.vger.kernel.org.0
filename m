Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505494DA8F4
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 04:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345854AbiCPDde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 23:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236095AbiCPDdd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 23:33:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF11D5DE74
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 20:32:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6C505615F3
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 03:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F553C340E8;
        Wed, 16 Mar 2022 03:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647401539;
        bh=xh3prfxvdb+2PgzSPjsYYhbnkW6abFJkncqcJ8JA/Z0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LUP4pkQ4navijnKdQnqJFKUkIdW7pIz3FzubYa+jIjGBMJ2/07/M/QzoOcHwyZFJc
         +g0rNI9bfeNLq1rtfHtlT61YdbXYD/dQCEBb31lJgggsZpcn26YJF2nY83OP8lyM2D
         n7WkZiGYLNjBLjLqo5ipXOF1G/seGllNDemS8pIjitN+ibTy4oz5vgYgoY7zjtVJSn
         8n93LoQ6SyKthq5FIpH288SJ2lGVPGe2GsyT2g6lvCBkJHhuR8rdPHjJ9S2TMOO1ub
         mj3azMfjRkqKD1OdCV8YhZ8fBqnZQApi/f4rAgS/OSOMrWi/uzJMSJSp1pPqJwJrCV
         6Tnf4/fIMJCvA==
Date:   Tue, 15 Mar 2022 20:32:18 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, pabeni@redhat.com,
        Sudheer Mogilappagari <sudheer.mogilappagari@intel.com>,
        netdev@vger.kernel.org,
        Bharathi Sreenivas <bharathi.sreenivas@intel.com>
Subject: Re: [PATCH net 2/3] ice: destroy flow director filter mutex after
 releasing VSIs
Message-ID: <20220315203218.607f612b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220315211225.2923496-3-anthony.l.nguyen@intel.com>
References: <20220315211225.2923496-1-anthony.l.nguyen@intel.com>
        <20220315211225.2923496-3-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 15 Mar 2022 14:12:24 -0700 Tony Nguyen wrote:
> +	mutex_destroy(&(&pf->hw)->fdir_fltr_lock);

nit: maybe uncrazify this line while moving it?
