Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C4D1608F08
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 20:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiJVSow (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 14:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbiJVSor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 14:44:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7474248D1;
        Sat, 22 Oct 2022 11:44:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B6986068B;
        Sat, 22 Oct 2022 18:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F6AC433D7;
        Sat, 22 Oct 2022 18:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666464281;
        bh=rOUU30Ns40RaPB0p9BJDk4013bR8TLp0a0aP/lu3CGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QH1i6VZDzmLtoKIfZRdZlY5d0nnl5DOOq4/LqxYE5FlmXq1e/ayVWYrKNPQTQfyTm
         lDWgFVezS94kXpPQqLVZatcxNDhidctINkWrhuWdQswTmu6mz+CfseCYZ+3W8aNf/D
         BNkZScXW3d2V3kASY+/66HDGLtFJ5ipyIa5e8xIAsg2O2gipHt0u3nXAKd6fgttKgZ
         NC4qpNwwmaHrG3GXHMyiFE9RiFlknggaV/ZCAfsoGqw84Y8dfHy2yZiRWd2Z5DPiV2
         OT+zRHLzLLt4Xmw92V6rNOqAbn6uKoF3nU46vq2IUtHpqclZiRhC/zWn5A1+rqtQtz
         yzpn0LslOhDww==
From:   SeongJae Park <sj@kernel.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     linux-kernel@vger.kernel.org, "Kees Cook" <keescook@chromium.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Russell King" <linux@armlinux.org.uk>,
        "Catalin Marinas" <catalin.marinas@arm.com>,
        "Thomas Bogendoerfer" <tsbogend@alpha.franken.de>,
        "Heiko Carstens" <hca@linux.ibm.com>,
        "Herbert Xu" <herbert@gondor.apana.org.au>,
        =?UTF-8?q?Christoph=20B=C3=B6hmwalder?= 
        <christoph.boehmwalder@linbit.com>,
        "Jani Nikula" <jani.nikula@linux.intel.com>,
        "Jason Gunthorpe" <jgg@nvidia.com>,
        "Sakari Ailus" <sakari.ailus@linux.intel.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Andreas Dilger" <adilger.kernel@dilger.ca>,
        "Jaegeuk Kim" <jaegeuk@kernel.org>,
        "Richard Weinberger" <richard@nod.at>,
        "Darrick J . Wong" <djwong@kernel.org>,
        "SeongJae Park" <sj@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Michael Ellerman" <mpe@ellerman.id.au>,
        "Helge Deller" <deller@gmx.de>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-media@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
        linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-mmc@vger.kernel.org, linux-parisc@vger.kernel.org,
        damon@lists.linux.dev, linux-mm@kvack.org
Subject: Re: [PATCH v1 1/5] treewide: use get_random_u32_below() instead of deprecated function
Date:   Sat, 22 Oct 2022 18:44:36 +0000
Message-Id: <20221022184436.33750-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221022014403.3881893-2-Jason@zx2c4.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

Cc-ing damon@lists.linux.dev and linux-mm@kvack.org.

On Fri, 21 Oct 2022 21:43:59 -0400 "Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> This is a simple mechanical transformation done by:
> 
> @@
> expression E;
> @@
> - prandom_u32_max(E)
> + get_random_u32_below(E)
> 
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
[...]
>  include/linux/damon.h                         |  2 +-

For the damon.h part,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ
