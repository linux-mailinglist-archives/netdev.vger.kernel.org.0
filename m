Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB5A6E0FAD
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 16:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbjDMOIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 10:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjDMOIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 10:08:37 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBFC6B448;
        Thu, 13 Apr 2023 07:08:12 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 41DE76732D; Thu, 13 Apr 2023 16:08:10 +0200 (CEST)
Date:   Thu, 13 Apr 2023 16:08:10 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Kevin Brodsky <kevin.brodsky@arm.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v2 1/3] net: Ensure ->msg_control_user is used for user
 buffers
Message-ID: <20230413140810.GC16625@lst.de>
References: <20230413114705.157046-1-kevin.brodsky@arm.com> <20230413114705.157046-2-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230413114705.157046-2-kevin.brodsky@arm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 13, 2023 at 12:47:03PM +0100, Kevin Brodsky wrote:
> Since commit 1f466e1f15cf ("net: cleanly handle kernel vs user
> buffers for ->msg_control"), pointers to user buffers should be
> stored in struct msghdr::msg_control_user, instead of the
> msg_control field.  Most users of msg_control have already been
> converted (where user buffers are involved), but not all of them.
> 
> This patch attempts to address the remaining cases. An exception is
> made for null checks, as it should be safe to use msg_control
> unconditionally for that purpose.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

although I would have expected this at the end of the series.  Given
that the patches don't overlap it shouldn't really matter in the end,
though.
