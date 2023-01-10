Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E5B166477C
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:34:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233353AbjAJReE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232148AbjAJReC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:34:02 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC68F48831
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:34:01 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so14259882pjj.4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 09:34:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=OiDMVqb3enV9q82h61lht5tvkjaUCp5ySOI9XxY14q0=;
        b=QhD0zGXWAMHaR0uHiCJVUy7FgGc21rSztmKexliIAipgdKkUPvLN32uDTu1QOV741f
         Y8CIlyY7yf05O5Sai2bhbSAWNVNE94/+pFY+/DzAB1McujtT3YG9Y1X69sxMds8ygBNj
         br/pf14j8L6/RJpYAw7ghEf5fsg56XKUxsAnYZ6rqBi0yYjT5Fer8VpLjDn6en1XEcZW
         88Im75NLgj2wRHsAFV2phOhMhyr6fOFVC6OT/L+kkXC+TOnUkyC79nxsQOyHDhmSTLzn
         sZE+GEojxWbpJz6nb9TTqnbZ3vPXzjFll4wTG3HfY6muqvv3dDZR7M6/WeKqrHpWnkrh
         hXlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OiDMVqb3enV9q82h61lht5tvkjaUCp5ySOI9XxY14q0=;
        b=7TRiX7oUvFDzWXFhFieWRLNFLo5nMtoxIlmdcazd2VlsS1JSjM7UUftzJHBVSKksPg
         AbUfuwNOv2pdbdXxX/M1MHK0fbCd/XZ7tT/MVsjCln8yUXqWB89A909s1IiI7ALOz2jw
         DMQuPnf+kCio6Ep1y8DnNi22ukJlzMKmO56HpffbyI+7qY9mzdq0GgiNLWpelRJ4qhAp
         WhT/KWvUhdZ2OAHDOfCuzHCR9F0Qe3smJCKwiPgJ582ylSWJjhsyCEzY/2b+woiMyHKu
         N7UBXe7fmY9zpx+Kxjh2rJOG2A9x0XKrGf4UP10J1rf6NxG/LEwcH1mkgtQdvHMBpa3J
         YW3Q==
X-Gm-Message-State: AFqh2kpLxyPF5ldhjN+XXIjyX3vSdO3oDGafjURWPUg1Vlm7pQNJxVV0
        dznlRjPE7P1Xqrna6ecxZbU=
X-Google-Smtp-Source: AMrXdXtDn9GSfAG6wQvEHRAFzu2q8GL0OG5OvJseZtiafh0ondgF1K6zQGSSi0L2T5wFXwKRpoZ4RQ==
X-Received: by 2002:a17:902:cf08:b0:192:5283:3096 with SMTP id i8-20020a170902cf0800b0019252833096mr75856838plg.56.1673372041358;
        Tue, 10 Jan 2023 09:34:01 -0800 (PST)
Received: from [192.168.0.128] ([98.97.37.136])
        by smtp.googlemail.com with ESMTPSA id o6-20020a170902d4c600b0019280bac7a6sm8328020plg.152.2023.01.10.09.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 09:34:01 -0800 (PST)
Message-ID: <336b9f28bca980813310dd3007c862e9f738279e.camel@gmail.com>
Subject: Re: [PATCH net-next v4 10/10] tsnep: Support XDP BPF program setup
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Date:   Tue, 10 Jan 2023 09:33:59 -0800
In-Reply-To: <20230109191523.12070-11-gerhard@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
         <20230109191523.12070-11-gerhard@engleder-embedded.com>
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

On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
> Implement setup of BPF programs for XDP RX path with command
> XDP_SETUP_PROG of ndo_bpf(). This is the final step for XDP RX path
> support.
>=20
> tsnep_netdev_close() is called directly during BPF program setup. Add
> netif_carrier_off() and netif_tx_stop_all_queues() calls to signal to
> network stack that device is down. Otherwise network stack would
> continue transmitting pakets.
>=20
> Return value of tsnep_netdev_open() is not checked during BPF program
> setup like in other drivers. Forwarding the return value would result in
> a bpf_prog_put() call in dev_xdp_install(), which would make removal of
> BPF program necessary.
>=20
> If tsnep_netdev_open() fails during BPF program setup, then the network
> stack would call tsnep_netdev_close() anyway. Thus, tsnep_netdev_close()
> checks now if device is already down.
>=20
> Additionally remove $(tsnep-y) from $(tsnep-objs) because it is added
> automatically.
>=20
> Test results with A53 1.2GHz:
>=20
> XDP_DROP (samples/bpf/xdp1)
> proto 17:     883878 pkt/s
>=20
> XDP_TX (samples/bpf/xdp2)
> proto 17:     255693 pkt/s
>=20
> XDP_REDIRECT (samples/bpf/xdpsock)
>  sock0@eth2:0 rxdrop xdp-drv
>                    pps            pkts           1.00
> rx                 855,582        5,404,523
> tx                 0              0
>=20
> XDP_REDIRECT (samples/bpf/xdp_redirect)
> eth2->eth1         613,267 rx/s   0 err,drop/s   613,272 xmit/s
>=20
> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> ---
>  drivers/net/ethernet/engleder/Makefile     |  2 +-
>  drivers/net/ethernet/engleder/tsnep.h      |  6 +++++
>  drivers/net/ethernet/engleder/tsnep_main.c | 25 ++++++++++++++++---
>  drivers/net/ethernet/engleder/tsnep_xdp.c  | 29 ++++++++++++++++++++++
>  4 files changed, 58 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c
>=20
>=20

<...>

> --- a/drivers/net/ethernet/engleder/tsnep_main.c
> +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> @@ -1373,7 +1373,7 @@ static void tsnep_free_irq(struct tsnep_queue *queu=
e, bool first)
>  	memset(queue->name, 0, sizeof(queue->name));
>  }
> =20
> -static int tsnep_netdev_open(struct net_device *netdev)
> +int tsnep_netdev_open(struct net_device *netdev)
>  {
>  	struct tsnep_adapter *adapter =3D netdev_priv(netdev);
>  	int tx_queue_index =3D 0;
> @@ -1436,6 +1436,8 @@ static int tsnep_netdev_open(struct net_device *net=
dev)
>  		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
>  	}
> =20
> +	netif_tx_start_all_queues(adapter->netdev);
> +
>  	clear_bit(__TSNEP_DOWN, &adapter->state);
> =20
>  	return 0;
> @@ -1457,12 +1459,16 @@ static int tsnep_netdev_open(struct net_device *n=
etdev)
>  	return retval;
>  }
> =20
> -static int tsnep_netdev_close(struct net_device *netdev)
> +int tsnep_netdev_close(struct net_device *netdev)
>  {
>  	struct tsnep_adapter *adapter =3D netdev_priv(netdev);
>  	int i;
> =20
> -	set_bit(__TSNEP_DOWN, &adapter->state);
> +	if (test_and_set_bit(__TSNEP_DOWN, &adapter->state))
> +		return 0;
> +
> +	netif_carrier_off(netdev);
> +	netif_tx_stop_all_queues(netdev);
> =20

As I called out earlier the __TSNEP_DOWN is just !IFF_UP so you don't
need that bit.

The fact that netif_carrier_off is here also points out the fact that
the code in the Tx path isn't needed regarding __TSNEP_DOWN and you can
probably just check netif_carrier_ok if you need the check.

>  	tsnep_disable_irq(adapter, ECM_INT_LINK);
>  	tsnep_phy_close(adapter);
> @@ -1627,6 +1633,18 @@ static ktime_t tsnep_netdev_get_tstamp(struct net_=
device *netdev,
>  	return ns_to_ktime(timestamp);
>  }
> =20
> +static int tsnep_netdev_bpf(struct net_device *dev, struct netdev_bpf *b=
pf)
> +{
> +	struct tsnep_adapter *adapter =3D netdev_priv(dev);
> +
> +	switch (bpf->command) {
> +	case XDP_SETUP_PROG:
> +		return tsnep_xdp_setup_prog(adapter, bpf->prog, bpf->extack);
> +	default:
> +		return -EOPNOTSUPP;
> +	}
> +}
> +
>  static int tsnep_netdev_xdp_xmit(struct net_device *dev, int n,
>  				 struct xdp_frame **xdp, u32 flags)
>  {
> @@ -1677,6 +1695,7 @@ static const struct net_device_ops tsnep_netdev_ops=
 =3D {
>  	.ndo_set_features =3D tsnep_netdev_set_features,
>  	.ndo_get_tstamp =3D tsnep_netdev_get_tstamp,
>  	.ndo_setup_tc =3D tsnep_tc_setup,
> +	.ndo_bpf =3D tsnep_netdev_bpf,
>  	.ndo_xdp_xmit =3D tsnep_netdev_xdp_xmit,
>  };
> =20
>=20
