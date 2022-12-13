Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0863A64B9FA
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 17:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236150AbiLMQlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 11:41:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbiLMQls (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 11:41:48 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F4F12DEB;
        Tue, 13 Dec 2022 08:41:47 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id w37so215748pga.5;
        Tue, 13 Dec 2022 08:41:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=7Madb2oY/BGxy7DIUcJg1YvjUNIeH3mgTbRARrr4pwE=;
        b=KO/pHJkmch3+xoN3a00U6K+fsXxDBa1oKwtuoLj3q8WILHBeSl55JjyzJxHpaxLieY
         XK6VMBVgtGJdIWnP4tueUR+IUhzRGItuOD2NMRDq6ptKFcvAaNcvdtgKRy5NoooMrCUu
         ReKLum10WMQUsfE8FUW8tYGSKAZmc+PhdhmMjPp2cXMHQR7LRcDv7hxQGKVBTnxud4lM
         OT/4DubYE2tc8pf1l7I+DLaXqD6OunesMOSGJvNGsBgJr9dL+OKxRJvdcNXBdWkUC7ps
         BQzS19/yxnz5FG5cnlIC0lyK3aOhXfgnSFH2pCZPBqZbwjF/d3b7OmcMXchdC9LsWEgE
         EG0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7Madb2oY/BGxy7DIUcJg1YvjUNIeH3mgTbRARrr4pwE=;
        b=wYgBivmsLJEslwRei2FsiK/D/hvEuHr27uHPDiUAsGUqA0XItHOoD1LohV9Qmh7qNW
         5b4KlRcOEKDZBDjTACXDAitUVQtig0BX8o1e78KoNoyaeVQKkMp6NYMVGWMkvm4GTyfA
         KbVerhBZCY3/ujQsC6ZcAFT/jKOUsG8mFtZHfjBSxbXYAPfYA4tC/H2NoI9iuBit4+24
         V/WMNZlf3kv/7I+f8/6LEEQrE1WKmtf8LBz3A4Y0TNpCH+ZpUrvJ9VyVIswp7zlkaY9+
         T1uTJwHnpXZ+/gu8fP88kT/ZQvUnGT77cQywHNUYPrKHcj1sQs87okJ5Y9vPjq+LMDop
         qSBw==
X-Gm-Message-State: ANoB5pnyGdkPjtImzGL09EzhYWm8sS64P1VmuE+f/Q39uMJLwnLGlJso
        JpPxuJfmzgZv8OH+BCwVwzU=
X-Google-Smtp-Source: AA0mqf6ytDXJXfSUCXuYKqds0ioLlpj/ckWLvfAkXez+O2KvJfrd6VpZp88miU13ffloAn85d7Azmg==
X-Received: by 2002:a05:6a00:d41:b0:576:daea:fed8 with SMTP id n1-20020a056a000d4100b00576daeafed8mr20247910pfv.29.1670949706391;
        Tue, 13 Dec 2022 08:41:46 -0800 (PST)
Received: from [192.168.0.128] ([98.97.42.38])
        by smtp.googlemail.com with ESMTPSA id z20-20020aa79f94000000b00576c4540b63sm8154874pfr.12.2022.12.13.08.41.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Dec 2022 08:41:45 -0800 (PST)
Message-ID: <ac48b381b11c875cf36a471002658edafe04d9b9.camel@gmail.com>
Subject: Re: [PATCH] net/ncsi: Always use unicast source MAC address
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Peter Delevoryas <peter@pjd.dev>
Cc:     sam@mendozajonas.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Tue, 13 Dec 2022 08:41:44 -0800
In-Reply-To: <20221213004754.2633429-1-peter@pjd.dev>
References: <20221213004754.2633429-1-peter@pjd.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-2.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2022-12-12 at 16:47 -0800, Peter Delevoryas wrote:
> I use QEMU for development, and I noticed that NC-SI packets get dropped =
by
> the Linux software bridge[1] because we use a broadcast source MAC addres=
s
> for the first few NC-SI packets.

Normally NC-SI packets should never be seen by a bridge. Isn't NC-SI
really supposed to just be between the BMC and the NIC firmware?
Depending on your setup it might make more sense to use something like
macvtap or a socket connection to just bypass the need for the bridge
entirely.

> The spec requires that the destination MAC address is FF:FF:FF:FF:FF:FF,
> but it doesn't require anything about the source MAC address as far as I
> know. From testing on a few different NC-SI NIC's (Broadcom 57502, Nvidia
> CX4, CX6) I don't think it matters to the network card. I mean, Meta has
> been using this in mass production with millions of BMC's [2].
>=20
> In general, I think it's probably just a good idea to use a unicast MAC.

I'm not sure I agree there. What is the initial value of the address?
If I am not mistaken the gma_flag is used to indicate that the MAC
address has been acquired isn't it? If using the broadcast is an issue
the maybe an all 0's MAC address might be more appropriate. My main
concern would be that the dev_addr is not initialized for those first
few messages so you may be leaking information.

> This might have the effect of causing the NIC to learn 2 MAC addresses fr=
om
> an NC-SI link if the BMC uses OEM Get MAC Address commands to change its
> initial MAC address, but it shouldn't really matter. Who knows if NIC's
> even have MAC learning enabled from the out-of-band BMC link, lol.
>=20
> [1]: https://tinyurl.com/4933mhaj
> [2]: https://tinyurl.com/mr3tyadb

The thing is the OpenBMC approach initializes the value themselves to
broadcast[3]. As a result the two code bases are essentially doing the
same thing since mac_addr is defaulted to the broadcast address when
the ncsi interface is registered.

[3]: tinyurl.com/mr3cxf3b

>=20
> Signed-off-by: Peter Delevoryas <peter@pjd.dev>
> ---
>  net/ncsi/ncsi-cmd.c | 10 +---------
>  1 file changed, 1 insertion(+), 9 deletions(-)
>=20
> diff --git a/net/ncsi/ncsi-cmd.c b/net/ncsi/ncsi-cmd.c
> index dda8b76b7798..fd090156cf0d 100644
> --- a/net/ncsi/ncsi-cmd.c
> +++ b/net/ncsi/ncsi-cmd.c
> @@ -377,15 +377,7 @@ int ncsi_xmit_cmd(struct ncsi_cmd_arg *nca)
>  	eh =3D skb_push(nr->cmd, sizeof(*eh));
>  	eh->h_proto =3D htons(ETH_P_NCSI);
>  	eth_broadcast_addr(eh->h_dest);
> -
> -	/* If mac address received from device then use it for
> -	 * source address as unicast address else use broadcast
> -	 * address as source address
> -	 */
> -	if (nca->ndp->gma_flag =3D=3D 1)
> -		memcpy(eh->h_source, nca->ndp->ndev.dev->dev_addr, ETH_ALEN);
> -	else
> -		eth_broadcast_addr(eh->h_source);
> +	memcpy(eh->h_source, nca->ndp->ndev.dev->dev_addr, ETH_ALEN);
> =20
>  	/* Start the timer for the request that might not have
>  	 * corresponding response. Given NCSI is an internal

