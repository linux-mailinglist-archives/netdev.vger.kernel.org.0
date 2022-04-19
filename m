Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA0C507C36
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 23:56:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbiDSV66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 17:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236666AbiDSV65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 17:58:57 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DD4D40A1D;
        Tue, 19 Apr 2022 14:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=XuyDMDgfjUWSnDEO3vbp5OM+VTMtqR7vlgj7konRGyw=; b=uQjWdcrQ3uLD3BETEeGb4ybGza
        lXqbcnNfSlHFtaKFS2aFTgySntHyvI/rcWPXxSSFpUwSeFKIlgtlu5+wRhUVBf5trEJ5j+Ad+yt6V
        4IQNtlXvmSGBGfGLPq2ZnYrqm15JqZWepORtampGy4l0tpTG1YgNmgRb3+6GMl1MgC+M=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ngvpA-00GZuO-Io; Tue, 19 Apr 2022 23:55:52 +0200
Date:   Tue, 19 Apr 2022 23:55:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     cgel.zte@gmail.com
Cc:     nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, matthias.bgg@gmail.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Lv Ruyi <lv.ruyi@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net: ethernet: mtk_eth_soc: fix error check return value
 of debugfs_create_dir()
Message-ID: <Yl8v6OcArfqmVYj/@lunn.ch>
References: <20220419015832.2562366-1-lv.ruyi@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220419015832.2562366-1-lv.ruyi@zte.com.cn>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 19, 2022 at 01:58:32AM +0000, cgel.zte@gmail.com wrote:
> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> If an error occurs, debugfs_create_file() will return ERR_PTR(-ERROR),
> so use IS_ERR() to check it.

Please take a look at for example:

https://lkml.iu.edu/hypermail/linux/kernel/1901.2/06005.html
https://lkml.iu.edu/hypermail/linux/kernel/1901.2/06006.html
https://lkml.iu.edu/hypermail/linux/kernel/1901.2/05993.html

This is the author of debugfs remove exactly the sort of code you are
adding.

Please teach the Zeal Bot that such code is wrong, and you should be
submitting patches to actually remove testing the return values for
anything which starts with debugfs_

	Andrew
