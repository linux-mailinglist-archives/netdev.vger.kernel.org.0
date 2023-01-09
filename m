Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D365A662EE5
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:24:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237172AbjAISYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237594AbjAISXX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:23:23 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AE5C74B
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:22:24 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id y5so6814323pfe.2
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qxbeiZFgELN7gMzS/vrU3V/EU9TFLbTxrex7BL3X+Iw=;
        b=NE7e4jk5FBzhgvraSsRC/XY6hS70w2wXFjn+1GlMA6gdRuiDnfx5cUymZGEh/tYOqA
         /IHui3I2F1i6OF2LfmXxCwj/LOXOziqvEZsHe8V0yABO5IfF4ZtYR8ssFMlq1LiflwBf
         qT0WB1W8bthSSIQKdcNXCyzkBaX8dOXALOdauYSDy9Aza+fSZCAQi+P22hYni10v/Sm1
         OnTHTLxhka0FHdAXxwlaihOlo08g4Cfnw1csGLHMmM5kTc6S7fo2l3NHbrA2PthsCB9z
         BRnp8qOmyplljQmIHIAp/kpLBRWDVfbwkdGCPi71asW0jtcI5k7d7P/Vuyy4lybVI/gR
         GIqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qxbeiZFgELN7gMzS/vrU3V/EU9TFLbTxrex7BL3X+Iw=;
        b=W07peCw9CDmxzNeGP8h2l7dnmLNeL+MAEDsGEamYUraKAdcDoq2q/0lLbCfZ+/s0lK
         ybAeunR03Gq+KGy96c5AaM/Tda+tcNOJ08yMoRO1HhMP3VWGwFnYjRkWLprpSXx48tqF
         eKLlALgNr9lxka1KDpXUUA+FizkHSo1V9lj3U6hDhgtpGuiw9SKo+V41C/iaH39zwnWX
         9gnR+yCJNd/c6BDrJWqrONtQsiXyCJ2GyhrPJuKnrjnatANEn7AkuQOqsFJUzIqO/1Kj
         k1Xh30dEQNwdfM9kpWG1NZI/8veD3Nbp6s1mKst9LFiYzNceWb+yDYdo40CSbCWX371b
         IHLw==
X-Gm-Message-State: AFqh2kpNk0aqP6wVcY7hJ14LpoWwlSpbn+3TLj1VMPRwvOO+rzPWmdiK
        PfOLG0irkO7RJvhTyFcPqVgWnvphWZ4=
X-Google-Smtp-Source: AMrXdXuEO8Y3nF4mJkj5it9C1Kh43xBUeKz8ggzpCHopILax+hPckXie3+Ub1ody3NuJdm2tqNNqSg==
X-Received: by 2002:a62:ee0e:0:b0:578:f6f:efab with SMTP id e14-20020a62ee0e000000b005780f6fefabmr71116606pfi.11.1673288543572;
        Mon, 09 Jan 2023 10:22:23 -0800 (PST)
Received: from [192.168.0.128] ([98.97.43.196])
        by smtp.googlemail.com with ESMTPSA id y12-20020a62640c000000b005819313269csm6340524pfb.124.2023.01.09.10.22.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Jan 2023 10:22:23 -0800 (PST)
Message-ID: <9b68abc5e8613e02207e9c0c3619b1b07bc5bb8c.camel@gmail.com>
Subject: Re: [PATCH 1/1] ice: WiP support for BIG TCP packets
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Pawel Chmielewski <pawel.chmielewski@intel.com>,
        netdev@vger.kernel.org
Cc:     intel-wired-lan@osuosl.org
Date:   Mon, 09 Jan 2023 10:22:22 -0800
In-Reply-To: <20230109161833.223510-1-pawel.chmielewski@intel.com>
References: <20230109161833.223510-1-pawel.chmielewski@intel.com>
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

On Mon, 2023-01-09 at 17:18 +0100, Pawel Chmielewski wrote:
> This patch is a proof of concept for testing BIG TCP feature in ice drive=
r.
> Please see letter below.
>=20
> Signed-off-by: Pawel Chmielewski <pawel.chmielewski@intel.com>
> ---
> Hi All
> I'm writing on the list, as you may be able to provide me some feedback.
> I want to enable BIG TCP feature in intel ice drive, but I think I'm=20
> missing something.
> In the code itself, I've set 128k as a maximum tso size for the netif,
> and added stripping the HBH option from the header.
> For testing purposes, gso_max_size & gro_max_size were set to 128k and=
=20
> mtu to 9000.
> I've assumed that the ice tso offload will do the rest of the job.
> However- while running netperf TCP_RR and TCP_STREAM tests,
> I saw that only up to ~20% of the transmitted test packets have=20
> the specified size.=20
> Other packets to be transmitted, appear from the stack as splitted.
>=20
> I've been running the following testcases:
> netperf -t TCP_RR -H 2001:db8:0:f101::1  -- -r80000,80000 -O MIN_LATENCY,=
P90_LATENCY,P99_LATENCY,THROUGHPUT
> netperf -l-1 -t TCP_STREAM -H 2001:db8:0:f101::1  -- -m 128K -O MIN_LATEN=
CY,P90_LATENCY,P99_LATENCY,THROUGHPUT
> I suspected a shrinking tcp window size, but sniffing with tcpdump showed=
 rather big scaling factor (usually 128x).
> Apart from using netperf, I also tried a simple IPv6 user space applicati=
on
> (with SO_SNDBUF option set to 192k and TCP_WINDOW_CLAMP to 96k) - similar=
 results.
>=20
> I'd be very grateful for any feedback/suggestions
>=20
> Pawel
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 4 ++++
>  drivers/net/ethernet/intel/ice/ice_txrx.c | 9 +++++++++
>  2 files changed, 13 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethe=
rnet/intel/ice/ice_main.c
> index 2b23b4714a26..4e657820e55d 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -48,6 +48,8 @@ static DEFINE_IDA(ice_aux_ida);
>  DEFINE_STATIC_KEY_FALSE(ice_xdp_locking_key);
>  EXPORT_SYMBOL(ice_xdp_locking_key);
> =20
> +#define ICE_MAX_TSO_SIZE 131072
> +
>  /**
>   * ice_hw_to_dev - Get device pointer from the hardware structure
>   * @hw: pointer to the device HW structure
> @@ -3422,6 +3424,8 @@ static void ice_set_netdev_features(struct net_devi=
ce *netdev)
>  	 * be changed at runtime
>  	 */
>  	netdev->hw_features |=3D NETIF_F_RXFCS;
> +
> +	netif_set_tso_max_size(netdev, ICE_MAX_TSO_SIZE);
>  }
> =20
>  /**
> diff --git a/drivers/net/ethernet/intel/ice/ice_txrx.c b/drivers/net/ethe=
rnet/intel/ice/ice_txrx.c
> index 086f0b3ab68d..7e0ac483cad9 100644
> --- a/drivers/net/ethernet/intel/ice/ice_txrx.c
> +++ b/drivers/net/ethernet/intel/ice/ice_txrx.c
> @@ -23,6 +23,9 @@
>  #define FDIR_DESC_RXDID 0x40
>  #define ICE_FDIR_CLEAN_DELAY 10
> =20
> +#define HBH_HDR_SIZE sizeof(struct hop_jumbo_hdr)
> +#define HBH_OFFSET ETH_HLEN + sizeof(struct ipv6hdr)
> +
>  /**
>   * ice_prgm_fdir_fltr - Program a Flow Director filter
>   * @vsi: VSI to send dummy packet
> @@ -2300,6 +2303,12 @@ ice_xmit_frame_ring(struct sk_buff *skb, struct ic=
e_tx_ring *tx_ring)
> =20
>  	ice_trace(xmit_frame_ring, tx_ring, skb);
> =20
> +	if (ipv6_has_hopopt_jumbo(skb)) {
> +		memmove(skb->data + HBH_HDR_SIZE, skb->data, HBH_OFFSET);
> +		__skb_pull(skb, HBH_HDR_SIZE);
> +		skb_reset_mac_header(skb);
> +	}
> +
>  	count =3D ice_xmit_desc_count(skb);
>  	if (ice_chk_linearize(skb, count)) {
>  		if (__skb_linearize(skb))

Your removal code here is forgetting to handle the network header. As a
result your frames will be pointer mangled in terms of header location.

You might be better off using ipv6_hopopt_jumbo_remove() rather than
just coding your own bit to remove it.
