Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69F2F664F87
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 00:00:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjAJXAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 18:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233973AbjAJXAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 18:00:45 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F99B6332
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 15:00:44 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id h7-20020a17090aa88700b00225f3e4c992so18117013pjq.1
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 15:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=QU89/JGZJyaCYlVZ271CEmB67eqyUq7j7cVtJKJxXqU=;
        b=BfIjl7hhTJJ5vCsAXyF/+jhL5DnjDWMHCf+NIc8bb7QVEt3UdjtR7fVEKx8QTAnSxi
         qN946iW94LTgI0SzbtlZQerObZovErBOV6wlJYR//XqFkaZUJG2K9TpnQt7MWkUx1b7Y
         DDNQzUFEVOKx/FgQABWFs400Vcudr3sI/QbJDIa73ZaMZRYDJVJaKa/mMkcdg1F2Br++
         weVeWJszh62e0lhFfwKUgKqvbEBopyghDBDa6cU1SRMBivozDBuOwue+aGzqLTdW0zo4
         flNGDRP9qt1osWLcNrMNizNBtlpgit81yUfSdbvV+7zCdaGbC1RFt6DC71ITtGw/mSGd
         8udg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QU89/JGZJyaCYlVZ271CEmB67eqyUq7j7cVtJKJxXqU=;
        b=akvB8SykkDNXGjogHjVqigcoKMBzo7ZDQsN86IwnLFA301flIBnYE5eBa3RZxE508h
         lhZ7fRAxRYOpsbpeNGqt+W426c3m7FeZ89C2AcSZqoWhTR4HJ9jUzKFAwv1deNFvVqAf
         WATY9W61nvhIsWgdqI59UD9qMR78K6l7Cn9fHn3vZ8g/b8JmoM3TL0G2yU5JQi/Lyaf6
         Wp1RXPxRcngpOBMVkv+wXXCjvIroSHvqJHs82JNajp+7hkJR2+g9ViEfvsWUL7Q2gOcn
         YVoJb8RxQsMTUbA1GApavJAhK9jNNscG87rdaxiFQaIeHXcgJZ/IT6aeKZ/x/Nz6kK/o
         rlWQ==
X-Gm-Message-State: AFqh2krnc5WmqrmIhhoSCdg0WyWm6rdTwD1vxFTN+t9d51bPmLtNrbtz
        7nMeO5AZpn3aNONLC6Coqj8=
X-Google-Smtp-Source: AMrXdXsolzVagVe0KHX5y6IpH5Lf4PBDnAisOw8NxKxq5IpNHW/hVHV4vGIzk8rQChyDmf/4KFK/Ew==
X-Received: by 2002:a17:902:f813:b0:193:39c4:cf55 with SMTP id ix19-20020a170902f81300b0019339c4cf55mr539576plb.17.1673391643963;
        Tue, 10 Jan 2023 15:00:43 -0800 (PST)
Received: from [192.168.0.128] ([98.97.37.136])
        by smtp.googlemail.com with ESMTPSA id k11-20020a170902c40b00b001894198d0ebsm8686011plk.24.2023.01.10.15.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 15:00:43 -0800 (PST)
Message-ID: <cb2057cf002611c58ee109d9f250bf43f0b15b01.camel@gmail.com>
Subject: Re: [PATCH net-next v4 10/10] tsnep: Support XDP BPF program setup
From:   Alexander H Duyck <alexander.duyck@gmail.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com
Date:   Tue, 10 Jan 2023 15:00:42 -0800
In-Reply-To: <3d0bc2ad-2c4a-527a-be09-b9746c87b2a8@engleder-embedded.com>
References: <20230109191523.12070-1-gerhard@engleder-embedded.com>
         <20230109191523.12070-11-gerhard@engleder-embedded.com>
         <336b9f28bca980813310dd3007c862e9f738279e.camel@gmail.com>
         <3d0bc2ad-2c4a-527a-be09-b9746c87b2a8@engleder-embedded.com>
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

On Tue, 2023-01-10 at 22:38 +0100, Gerhard Engleder wrote:
> On 10.01.23 18:33, Alexander H Duyck wrote:
> > On Mon, 2023-01-09 at 20:15 +0100, Gerhard Engleder wrote:
> > > Implement setup of BPF programs for XDP RX path with command
> > > XDP_SETUP_PROG of ndo_bpf(). This is the final step for XDP RX path
> > > support.
> > >=20
> > > tsnep_netdev_close() is called directly during BPF program setup. Add
> > > netif_carrier_off() and netif_tx_stop_all_queues() calls to signal to
> > > network stack that device is down. Otherwise network stack would
> > > continue transmitting pakets.
> > >=20
> > > Return value of tsnep_netdev_open() is not checked during BPF program
> > > setup like in other drivers. Forwarding the return value would result=
 in
> > > a bpf_prog_put() call in dev_xdp_install(), which would make removal =
of
> > > BPF program necessary.
> > >=20
> > > If tsnep_netdev_open() fails during BPF program setup, then the netwo=
rk
> > > stack would call tsnep_netdev_close() anyway. Thus, tsnep_netdev_clos=
e()
> > > checks now if device is already down.
> > >=20
> > > Additionally remove $(tsnep-y) from $(tsnep-objs) because it is added
> > > automatically.
> > >=20
> > > Test results with A53 1.2GHz:
> > >=20
> > > XDP_DROP (samples/bpf/xdp1)
> > > proto 17:     883878 pkt/s
> > >=20
> > > XDP_TX (samples/bpf/xdp2)
> > > proto 17:     255693 pkt/s
> > >=20
> > > XDP_REDIRECT (samples/bpf/xdpsock)
> > >   sock0@eth2:0 rxdrop xdp-drv
> > >                     pps            pkts           1.00
> > > rx                 855,582        5,404,523
> > > tx                 0              0
> > >=20
> > > XDP_REDIRECT (samples/bpf/xdp_redirect)
> > > eth2->eth1         613,267 rx/s   0 err,drop/s   613,272 xmit/s
> > >=20
> > > Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> > > ---
> > >   drivers/net/ethernet/engleder/Makefile     |  2 +-
> > >   drivers/net/ethernet/engleder/tsnep.h      |  6 +++++
> > >   drivers/net/ethernet/engleder/tsnep_main.c | 25 ++++++++++++++++---
> > >   drivers/net/ethernet/engleder/tsnep_xdp.c  | 29 +++++++++++++++++++=
+++
> > >   4 files changed, 58 insertions(+), 4 deletions(-)
> > >   create mode 100644 drivers/net/ethernet/engleder/tsnep_xdp.c
> > >=20
> > >=20
> >=20
> > <...>
> >=20
> > > --- a/drivers/net/ethernet/engleder/tsnep_main.c
> > > +++ b/drivers/net/ethernet/engleder/tsnep_main.c
> > > @@ -1373,7 +1373,7 @@ static void tsnep_free_irq(struct tsnep_queue *=
queue, bool first)
> > >   	memset(queue->name, 0, sizeof(queue->name));
> > >   }
> > >  =20
> > > -static int tsnep_netdev_open(struct net_device *netdev)
> > > +int tsnep_netdev_open(struct net_device *netdev)
> > >   {
> > >   	struct tsnep_adapter *adapter =3D netdev_priv(netdev);
> > >   	int tx_queue_index =3D 0;
> > > @@ -1436,6 +1436,8 @@ static int tsnep_netdev_open(struct net_device =
*netdev)
> > >   		tsnep_enable_irq(adapter, adapter->queue[i].irq_mask);
> > >   	}
> > >  =20
> > > +	netif_tx_start_all_queues(adapter->netdev);
> > > +
> > >   	clear_bit(__TSNEP_DOWN, &adapter->state);
> > >  =20
> > >   	return 0;
> > > @@ -1457,12 +1459,16 @@ static int tsnep_netdev_open(struct net_devic=
e *netdev)
> > >   	return retval;
> > >   }
> > >  =20
> > > -static int tsnep_netdev_close(struct net_device *netdev)
> > > +int tsnep_netdev_close(struct net_device *netdev)
> > >   {
> > >   	struct tsnep_adapter *adapter =3D netdev_priv(netdev);
> > >   	int i;
> > >  =20
> > > -	set_bit(__TSNEP_DOWN, &adapter->state);
> > > +	if (test_and_set_bit(__TSNEP_DOWN, &adapter->state))
> > > +		return 0;
> > > +
> > > +	netif_carrier_off(netdev);
> > > +	netif_tx_stop_all_queues(netdev);
> > >  =20
> >=20
> > As I called out earlier the __TSNEP_DOWN is just !IFF_UP so you don't
> > need that bit.
> >=20
> > The fact that netif_carrier_off is here also points out the fact that
> > the code in the Tx path isn't needed regarding __TSNEP_DOWN and you can
> > probably just check netif_carrier_ok if you need the check.
>=20
> tsnep_netdev_close() is called directly during bpf prog setup (see
> tsnep_xdp_setup_prog() in this commit). If the following
> tsnep_netdev_open() call fails, then this flag signals that the device
> is already down and nothing needs to be cleaned up if
> tsnep_netdev_close() is called later (because IFF_UP is still set).

If the call to close was fouled up you should probably be blocking
access to the device via at least a netif_device_detach. I susppose you
could use the __LINK_STATE_PRESENT bit as the inverse of the
__TSNEP_DOWN bit. If your open fails you clean up, detatch the device,
and in the close path you only run through it if the device is present.

Basically what we want to avoid is adding a bunch of extra state as
what we tend to see is that it will start to create a snarl as you add
more and more layers.


