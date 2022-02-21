Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B184BE781
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 19:03:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242951AbiBUK5F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 05:57:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351033AbiBUKzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 05:55:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6B852BB23;
        Mon, 21 Feb 2022 02:23:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FFFCB80DA4;
        Mon, 21 Feb 2022 10:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0449DC340E9;
        Mon, 21 Feb 2022 10:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645438983;
        bh=tHe3JwBIdJi3QL5KPklA2JTFVmcZqzfdgzVj2VoOjjw=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AKMLirWg96eouuBDF+un4SrJMR1H101vE7r6RQqjdNPFZgx1nhLRA+PqY5d6VMn++
         ykG95FbSPHw4rKjx2BfKpciFy/9pc+idoaGNGBrMmv8YuhPGSX3y8Hz+jrFUU/oTcD
         mAa60rpbYE0tNnsXrYXyB6FBQvtXtDDxvf8DmwzBhdHReB3nwyplB+qcBc/hT8Iiv8
         0Vy/vLXvG1JoN42byRSNciejxrGdv/dTaInhgKS04y3BLtjNqjYqKXxWFv5gr2b66S
         HW3QeGrBJIRA2KxADQtr1u20gPtuM1Tn9Vio07HsgBLaZAHtHr1sZv+nxy87vUYI+W
         u+4DbZW9pr3Vw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] ath9k: use hw_random API instead of directly dumping
 into
 random.c
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220216113323.53332-1-Jason@zx2c4.com>
References: <20220216113323.53332-1-Jason@zx2c4.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     miaoqing@codeaurora.org, Rui Salvaterra <rsalvaterra@gmail.com>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "Sepehrdad, Pouyan" <pouyans@qti.qualcomm.com>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164543897830.26423.13654986323403498456.kvalo@kernel.org>
Date:   Mon, 21 Feb 2022 10:22:59 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Jason A. Donenfeld" <Jason@zx2c4.com> wrote:

> Hardware random number generators are supposed to use the hw_random
> framework. This commit turns ath9k's kthread-based design into a proper
> hw_random driver.
> 
> Cc: Toke Høiland-Jørgensen <toke@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Rui Salvaterra <rsalvaterra@gmail.com>
> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Tested-by: Rui Salvaterra <rsalvaterra@gmail.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

fcd09c90c3c5 ath9k: use hw_random API instead of directly dumping into random.c

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220216113323.53332-1-Jason@zx2c4.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

