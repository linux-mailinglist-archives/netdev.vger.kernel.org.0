Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55AF68F21E
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 16:38:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231705AbjBHPiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 10:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjBHPiB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 10:38:01 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A41E4615D;
        Wed,  8 Feb 2023 07:38:00 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u9so15409736plf.3;
        Wed, 08 Feb 2023 07:38:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=tyxdKLDP3Ib74eY/+3PsD15L+kFnw+sZW1uY0BYmLFo=;
        b=UwPts0bydIcjI4PQvSnevkrShWRtqAh7GAbHA8MBtf4d5eEo848fnZ5h9drEghgKhb
         yTVtd0ikOxiwzYZJQ733RLz8U1NXTfq2RHZCtIM/f4qJwN0LiVRHoGkJ3q2/azGy/YF+
         zhpWxP+SKGFyUrxkb7W41xu7+Akqe76IlJIALJR4A9jbC7sqnbsSpOpUSwno5l9y3R/f
         CdSy44Yw5s2kmCpNPAB2GUF5dvdclu9hEArtx8fKSTgL4w1aEwXkJe5uxSfjQLN/EDLg
         GxE1gsRo67/xxjawfpm98E8t7f/815lFm0vsI6SFMQkioqSbLmgZ3xFFWCrrggx83/yk
         BeUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tyxdKLDP3Ib74eY/+3PsD15L+kFnw+sZW1uY0BYmLFo=;
        b=X2sPLlal2xQvwpipYcThbfyp+J//13AxsudS+/EOu6rqoF0vSRToPtaIwmCr/dccfO
         Kqz080yhJ1NyPQijuW57z7KY3C439qNcO8YzXDBhazdLb6tjNuwddS9IURBPIC4K6UT7
         sAFaxfPsK/Kbm8QpUa192473qVSf81Ox3XCH/FiCCSiMcBsByxmo9ppB66ggtLeOBxRQ
         OsLEMreQMJ1bLR9vf+oJsKJzO41pd/EJeiaePvxSafJiz1MfLkjSvpNtzgMvfGMLmBcy
         PhOmaVFO1sgIKhpnIWYxOoosarMDQ8a92Se3gArzosgeLBwcymBtbtp65vTzT8eLNXM8
         mmMQ==
X-Gm-Message-State: AO0yUKVYR4/3me138l8zvuQBAjD31470exX8WjDC4hiGPP3+IpYEooRk
        9CQw8diepxlaEBClop14lh4=
X-Google-Smtp-Source: AK7set/mWJITw8aZBIw2ou01vX1mq7jpo5YZRgEOXmx+HEFQT/fF1HqAaBw1KqjJ1Pq3anuRaFnT+Q==
X-Received: by 2002:a17:902:e751:b0:198:e8f3:6a48 with SMTP id p17-20020a170902e75100b00198e8f36a48mr9611072plf.9.1675870679597;
        Wed, 08 Feb 2023 07:37:59 -0800 (PST)
Received: from [192.168.0.128] ([98.97.119.54])
        by smtp.googlemail.com with ESMTPSA id jl13-20020a170903134d00b00198fde9178csm8036684plb.197.2023.02.08.07.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 07:37:58 -0800 (PST)
Message-ID: <2bfcd7d92a6971416f58d9aac6e74840d5ae240a.camel@gmail.com>
Subject: Re: [PATCH net v4 1/3] ixgbe: allow to increase MTU to 3K with XDP
 enabled
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Jason Xing <kerneljasonxing@gmail.com>, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        richardcochran@gmail.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Date:   Wed, 08 Feb 2023 07:37:57 -0800
In-Reply-To: <20230208024333.10465-1-kerneljasonxing@gmail.com>
References: <20230208024333.10465-1-kerneljasonxing@gmail.com>
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

On Wed, 2023-02-08 at 10:43 +0800, Jason Xing wrote:
> From: Jason Xing <kernelxing@tencent.com>
>=20
> Recently I encountered one case where I cannot increase the MTU size
> directly from 1500 to a much bigger value with XDP enabled if the
> server is equipped with IXGBE card, which happened on thousands of
> servers in production environment. After appling the current patch,
> we can set the maximum MTU size to 3K.
>=20
> This patch follows the behavior of changing MTU as i40e/ice does.
>=20
> Referrences:
> [1] commit 23b44513c3e6 ("ice: allow 3k MTU for XDP")
> [2] commit 0c8493d90b6b ("i40e: add XDP support for pass and drop actions=
")
>=20
> Fixes: fabf1bce103a ("ixgbe: Prevent unsupported configurations with XDP"=
)
> Signed-off-by: Jason Xing <kernelxing@tencent.com>

This is based on the broken premise that w/ XDP we are using a 4K page.
The ixgbe driver isn't using page pool and is therefore running on
different limitations. The ixgbe driver is only using 2K slices of the
4K page. In addition that is reduced to 1.5K to allow for headroom and
the shared info in the buffer.

Currently the only way a 3K buffer would work is if FCoE is enabled and
in that case the driver is using order 1 pages and still using the
split buffer approach.

Changing the MTU to more than 1.5K will allow multi-buffer frames which
would break things when you try to use XDP_REDIRECT or XDP_TX on frames
over 1.5K in size. For things like XDP_PASS, XDP_DROP, and XDP_ABORT it
should still work as long as you don't attempt to reach beyond the 1.5K
boundary.

Until this driver supports XDP multi-buffer I don't think you can
increase the MTU past 1.5K. If you are wanting a larger MTU you should
look at enabling XDP multi-buffer and then just drop the XDP
limitations entirely.

> ---
> v4:
> 1) use ':' instead of '-' for kdoc
>=20
> v3:
> 1) modify the titile and body message.
>=20
> v2:
> 1) change the commit message.
> 2) modify the logic when changing MTU size suggested by Maciej and Alexan=
der.
> ---
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 25 ++++++++++++-------
>  1 file changed, 16 insertions(+), 9 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/=
ethernet/intel/ixgbe/ixgbe_main.c
> index ab8370c413f3..25ca329f7d3c 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -6777,6 +6777,18 @@ static void ixgbe_free_all_rx_resources(struct ixg=
be_adapter *adapter)
>  			ixgbe_free_rx_resources(adapter->rx_ring[i]);
>  }
> =20
> +/**
> + * ixgbe_max_xdp_frame_size - returns the maximum allowed frame size for=
 XDP
> + * @adapter: device handle, pointer to adapter
> + */
> +static int ixgbe_max_xdp_frame_size(struct ixgbe_adapter *adapter)
> +{
> +	if (PAGE_SIZE >=3D 8192 || adapter->flags2 & IXGBE_FLAG2_RX_LEGACY)
> +		return IXGBE_RXBUFFER_2K;
> +	else
> +		return IXGBE_RXBUFFER_3K;
> +}
> +

There is no difference in the buffer allocation approach for LEGACY vs
non-legacy. The difference is if we are building the frame around the
buffer using build_skb or we are adding it as a frag and then copying
out the header.

>  /**
>   * ixgbe_change_mtu - Change the Maximum Transfer Unit
>   * @netdev: network interface device structure
> @@ -6788,18 +6800,13 @@ static int ixgbe_change_mtu(struct net_device *ne=
tdev, int new_mtu)
>  {
>  	struct ixgbe_adapter *adapter =3D netdev_priv(netdev);
> =20
> -	if (adapter->xdp_prog) {
> +	if (ixgbe_enabled_xdp_adapter(adapter)) {
>  		int new_frame_size =3D new_mtu + ETH_HLEN + ETH_FCS_LEN +
>  				     VLAN_HLEN;
> -		int i;
> -
> -		for (i =3D 0; i < adapter->num_rx_queues; i++) {
> -			struct ixgbe_ring *ring =3D adapter->rx_ring[i];
> =20
> -			if (new_frame_size > ixgbe_rx_bufsz(ring)) {
> -				e_warn(probe, "Requested MTU size is not supported with XDP\n");
> -				return -EINVAL;
> -			}
> +		if (new_frame_size > ixgbe_max_xdp_frame_size(adapter)) {
> +			e_warn(probe, "Requested MTU size is not supported with XDP\n");
> +			return -EINVAL;
>  		}
>  	}
> =20

