Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830B24FEA9B
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiDLX0y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiDLX0Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:26:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900C9C9B49;
        Tue, 12 Apr 2022 15:12:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4DC3261C54;
        Tue, 12 Apr 2022 21:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41B9CC385A5;
        Tue, 12 Apr 2022 21:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649798949;
        bh=kpS0EcU/RLQzTaKo85ZEC/dgBcrpXX2fe+n6wE10HoY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GaLCgYlHxpFu6dokBt6GCrmgjotR4ofYQfGcSFBOLeVJbLpcwYNstaIrRFFIghgom
         d4/BYVT4yedX7dhBWKTquSxLJru2kufnM1pSd6adoQdHT5dspvAHMXGF+D7LBSbyGy
         uqwHRxFNdMWVDYxR0VfF+2gKqAXrxjAQgzuLbxkHXicMZ4BZiA4YlOWRDTjH9tpsz+
         lFMd8q2AcF3LrzmBQ/fhVQi3g0E+SpAYkcw2R0hXBqNrKSdDI4R0a0zA/04HGUFz7K
         uaJaecV/iiyppRN+sMAt+0yP/ErIwQTkaBGZvf6wgKDX4lLyfLcopor9Ly3uCGIfYU
         NpNRnUyxLeliQ==
Date:   Tue, 12 Apr 2022 14:29:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        UNGLinuxDriver@microchip.com, Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Casper Andersson <casper.casan@gmail.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Michael Walle <michael@walle.cc>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Colin Ian King <colin.king@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Dumazet <edumazet@google.com>,
        Di Zhu <zhudi21@huawei.com>, Xu Wang <vulab@iscas.ac.cn>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, bpf@vger.kernel.org,
        Mike Rapoport <rppt@kernel.org>,
        "Brian Johannesmeyer" <bjohannesmeyer@gmail.com>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        "Bos, H.J." <h.j.bos@vu.nl>
Subject: Re: [PATCH net-next v3 14/18] sfc: Remove usage of list iterator
 for list_add() after the loop body
Message-ID: <20220412142905.54489567@kernel.org>
In-Reply-To: <20220412121557.3553555-15-jakobkoschel@gmail.com>
References: <20220412121557.3553555-1-jakobkoschel@gmail.com>
        <20220412121557.3553555-15-jakobkoschel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Apr 2022 14:15:53 +0200 Jakob Koschel wrote:
> -	struct list_head *head = &efx->rss_context.list;
> +	struct list_head *head = *pos = &efx->rss_context.list;

ENOTBUILT, please wait with the reposting. Since you posted two
versions today I guess that's 2x 24h? :)
