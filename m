Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB53636342
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 16:21:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238153AbiKWPVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 10:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238772AbiKWPVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 10:21:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A98C920AB;
        Wed, 23 Nov 2022 07:21:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 84969B820DD;
        Wed, 23 Nov 2022 15:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6CACC433C1;
        Wed, 23 Nov 2022 15:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669216867;
        bh=XQZ/g+Sw4U+xIS3JiKRjNmg5QYe4GG7CLFMNcWE+7dg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Xp+Pc2frUVEZdshdbKf7x6iMGbOpkBFfpY28RhPayp1ot+dsTqVpETaB/8g7/9X0M
         1iSwoJBLwa8h/vIhH2Zb9YfpoeNF1QjyT8xs6fdfPeH2s2LxcGl8CUuiO9li8x7ce2
         FcA/1M+uHvUp820PhCldzR4cOjtaRks1R+EW6aRscTIajm9EBwDFTK71YvBescokKt
         +9WYLWtiTlBCsXUfWq/sNqf4dKjr0LyB8yVaqeZ2gND1Dh4pwJes9qIct1t0a8VRX1
         66bMDwWlnBBlVKorhQyIdHUTPy0sowjK1lQXKve+7+KXqmY1hJ8Q1e8Awz1x53w0Sd
         iJljBQ6lqT2jg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        =?utf-8?Q?=C5=81ukasz?= Stelmach <l.stelmach@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org,
        Ilja Van Sprundel <ivansprundel@ioactive.com>,
        Joseph Tartaro <joseph.tartaro@ioactive.com>
Subject: Re: [PATCH] USB: disable all RNDIS protocol drivers
References: <20221123124620.1387499-1-gregkh@linuxfoundation.org>
Date:   Wed, 23 Nov 2022 17:21:01 +0200
In-Reply-To: <20221123124620.1387499-1-gregkh@linuxfoundation.org> (Greg
        Kroah-Hartman's message of "Wed, 23 Nov 2022 13:46:20 +0100")
Message-ID: <87o7sxofxe.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> The Microsoft RNDIS protocol is, as designed, insecure and vulnerable on
> any system that uses it with untrusted hosts or devices.  Because the
> protocol is impossible to make secure, just disable all rndis drivers to
> prevent anyone from using them again.
>
> Windows only needed this for XP and newer systems, Windows systems older
> than that can use the normal USB class protocols instead, which do not
> have these problems.
>
> Android has had this disabled for many years so there should not be any
> real systems that still need this.
>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Paolo Abeni <pabeni@redhat.com>
> Cc: Kalle Valo <kvalo@kernel.org>
> Cc: Oleksij Rempel <linux@rempel-privat.de>
> Cc: "Maciej =C5=BBenczykowski" <maze@google.com>
> Cc: Neil Armstrong <neil.armstrong@linaro.org>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Andrzej Pietrasiewicz <andrzejtp2010@gmail.com>
> Cc: Jacopo Mondi <jacopo@jmondi.org>
> Cc: "=C5=81ukasz Stelmach" <l.stelmach@samsung.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: linux-usb@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: linux-wireless@vger.kernel.org
> Reported-by: Ilja Van Sprundel <ivansprundel@ioactive.com>
> Reported-by: Joseph Tartaro <joseph.tartaro@ioactive.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
> Note, I'll submit patches removing the individual drivers for later, but
> that is more complex as unwinding the interaction between the CDC
> networking and RNDIS drivers is tricky.  For now, let's just disable all
> of this code as it is not secure.
>
> I can take this through the USB tree if the networking maintainers have
> no objection.  I thought I had done this months ago, when the last round
> of "there are bugs in the protocol!" reports happened at the end of
> 2021, but forgot to do so, my fault.
>
>  drivers/net/usb/Kconfig           | 1 +
>  drivers/net/wireless/Kconfig      | 1 +

For wireless:

Acked-by: Kalle Valo <kvalo@kernel.org>

Feel free to take this via your tree.

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
