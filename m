Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E1434BEEAB
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237958AbiBVA7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 19:59:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237945AbiBVA7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 19:59:16 -0500
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCABCEBD;
        Mon, 21 Feb 2022 16:58:50 -0800 (PST)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nMJVS-0003BR-FT; Tue, 22 Feb 2022 11:58:19 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 22 Feb 2022 11:58:18 +1100
Date:   Tue, 22 Feb 2022 11:58:18 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Dumazet <edumazet@google.com>
Cc:     Ziyang Xuan <william.xuanziyang@huawei.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Vasily Averin <vvs@virtuozzo.com>,
        Kees Cook <keescook@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: vlan: allow vlan device MTU change follow real
 device from smaller to bigger
Message-ID: <YhQ1KrtpEr3TgCwA@gondor.apana.org.au>
References: <20220221124644.1146105-1-william.xuanziyang@huawei.com>
 <CANn89iKyWWCbAdv8W26HwGpM9q5+6rrk9E-Lbd2aujFkD3GMaQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANn89iKyWWCbAdv8W26HwGpM9q5+6rrk9E-Lbd2aujFkD3GMaQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 21, 2022 at 07:43:18AM -0800, Eric Dumazet wrote:
>
> Herbert, do you recall why only a decrease was taken into consideration ?

Because we shouldn't override administrative settings of the MTU
on the vlan device, unless we have to because of an MTU reduction
on the underlying device.

Yes this is not perfect if the admin never set an MTU to start with
but as we don't have a way of telling whether the admin has or has
not changed the MTU setting, the safest course of action is to do
nothing in that case.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
