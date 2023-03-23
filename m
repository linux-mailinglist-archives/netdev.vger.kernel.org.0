Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2406C6500
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 11:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjCWK3E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 06:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbjCWK23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 06:28:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 549A83646B
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 03:26:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BA44625AC
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 10:26:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E166C433D2;
        Thu, 23 Mar 2023 10:26:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679567191;
        bh=loTUJIRqyBSg5MLP5NgMTvYsYcq70UlbA30NB5BIEUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qCqx/lopzt80ob92enIsU8NyplHvGx49OXvNmeIIQE27nmUna2UmJuJqKBMFC9nRL
         wTsu0XtZDfrA/omZkV8SWWpHnNJddYDS1phXQK/fzK/PJAuYUtUKJrjaTEYg0o/UeH
         rb8rtJ6ZXxBhaQDgmOTAZY/i7rwXy8sQIsyWpgLZ/zltH+uHBslO68zV1n4C7UdlAq
         U3iQicfqUsO/IoO5L5o/JXds4pTLGhAE3nC0PobFwS7zSXT+CobqKZy/ND4PR7x4Wr
         MHL0eiIMoPmUzFaDTFmpZatVxFG9C0rsDJGZfVCUZ5q/3M/G3FTzM6GENf13LSdHy0
         hLEF5+nwx8aag==
Date:   Thu, 23 Mar 2023 12:26:27 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
Subject: Re: [PATCH net] net: wangxun: Fix vector length of interrupt cause
Message-ID: <20230323102627.GB36557@unreal>
References: <20230322103632.132011-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230322103632.132011-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 06:36:32PM +0800, Jiawen Wu wrote:
> There is 64-bit interrupt cause register for txgbe. Fix to clear upper
> 32 bits.
> 
> Fixes: 3f703186113f ("net: libwx: Add irq flow functions")

It is worth to add two Fixes lines, as in this commit you added WX_PX_IC,
but actual bug started to be when you used it in commit:
5d3ac705c281 ("net: txgbe: Add interrupt support")

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
