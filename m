Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3534578140
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 13:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234565AbiGRLva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 07:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233740AbiGRLv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 07:51:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5385D21E1A;
        Mon, 18 Jul 2022 04:51:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D50A5613EF;
        Mon, 18 Jul 2022 11:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A7EEC341C0;
        Mon, 18 Jul 2022 11:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658145087;
        bh=4peZeccaMY4buj1NfRubWz/kj288jrOowXgp/5FpdAU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Eb1Kz3aQ5KvS9rBQgafr069Y+8mU0zhtwVJh7mQ0shGm0Q1XK7pIOAjUi1nPA0aN2
         wFmKnTrsnxsvs/J/guKJacl/aFUjLA6qrU5dtsSOsbIS59MZM9I5MeE6sfzXL+ywqd
         NLxn17Qn7OwhdDgNi17tVo14djv71O9O15B7PTUQf8eCsgLoBfGKHVtfT0WxP+jn7R
         1pFcQvOWFEPQFGC5oz9qF0oIDTJ9adeXeggxByJosbx6TvQhR3p5rmYYKqkS3DqLBS
         8GaWXmQZyArMhzyHZPWpm8KwKRuHKLVMuUv3UUn+40O2SbSsswJxD2CygVl91oKLbm
         /6QiywjcIEwoA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v2] wifi: p54: Fix an error handling path in p54spi_probe()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
References: <297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Christian Lamparter <chunkeey@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Christian Lamparter <chunkeey@web.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814507884.17539.1869457653160342905.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 11:51:24 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> If an error occurs after a successful call to p54spi_request_firmware(), it
> must be undone by a corresponding release_firmware() as already done in
> the error handling path of p54spi_request_firmware() and in the .remove()
> function.
> 
> Add the missing call in the error handling path and remove it from
> p54spi_request_firmware() now that it is the responsibility of the caller
> to release the firmware
> 
> Fixes: cd8d3d321285 ("p54spi: p54spi driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>

Patch applied to wireless-next.git, thanks.

83781f0162d0 wifi: p54: Fix an error handling path in p54spi_probe()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/297d2547ff2ee627731662abceeab9dbdaf23231.1655068321.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

