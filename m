Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5ED25ED9A
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 13:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbgIFK7d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Sep 2020 06:59:33 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:24242 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbgIFKsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Sep 2020 06:48:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1599389299; x=1630925299;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version:content-transfer-encoding;
  bh=p7Llj1tNYov0fPxCyXta6FGckTyFz1eI7uriiaHBr58=;
  b=l5H9XezmkJcki5AB05OrX+28lNMsJaRJTSuxHqDp+Ctp9dx/sv+kl/pS
   6U6xrLoJh5LeaGKvQSMEemcarCc4TwuqO/NWu12jEzHSSWxgJhbOp483M
   Fm+4L5uj9EwBtVvBi8psJczPv+mbbmFeWBPg9Df7PvirwcYTQuVp1uGr8
   U=;
X-IronPort-AV: E=Sophos;i="5.76,397,1592870400"; 
   d="scan'208";a="52337112"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 06 Sep 2020 10:47:39 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id 09D51A20AD;
        Sun,  6 Sep 2020 10:47:37 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.160.183) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 6 Sep 2020 10:47:28 +0000
References: <20200819134349.22129-1-sameehj@amazon.com> <20200819134349.22129-2-sameehj@amazon.com> <20200819141716.GE2403519@lunn.ch> <91c86d46b724411d9f788396816be30d@EX13D11EUB002.ant.amazon.com> <20200826153635.GA51212@ranger.igk.intel.com>
User-agent: mu4e 1.4.12; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
CC:     "Jubran, Samih" <sameehj@amazon.com>, Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>
Subject: Re: [PATCH V2 net-next 1/4] net: ena: ethtool: use unsigned long for pointer arithmetics
In-Reply-To: <20200826153635.GA51212@ranger.igk.intel.com>
Date:   Sun, 6 Sep 2020 13:47:13 +0300
Message-ID: <pj41zlv9grp4ge.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.43.160.183]
X-ClientProxiedBy: EX13D08UWB001.ant.amazon.com (10.43.161.104) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Maciej Fijalkowski <maciej.fijalkowski@intel.com> writes:

> On Thu, Aug 20, 2020 at 12:13:15PM +0000, Jubran, Samih wrote:
>>=20
>> > ...
>> >=20
>> > On Wed, Aug 19, 2020 at 01:43:46PM +0000, sameehj@amazon.com=20
>> > wrote:
>> > > From: Sameeh Jubran <sameehj@amazon.com>
>> > >
>> > > unsigned long is the type for doing maths on pointers.
>> >=20
>> > Maths on pointers is perfectly valid. The real issue here is=20
>> > you have all your
>> > types mixed up.
>>=20
>> The stat_offset field has the bytes from the start of the=20
>> struct, the math is perfectly valid IMO=C2=B8
>> I have also went for the extra step and tested it using prints.
>>=20
>> >=20
>> > > -                     ptr =3D (u64=20
>> > > *)((uintptr_t)&ring->tx_stats +
>> > > -=20
>> > > (uintptr_t)ena_stats->stat_offset);
>> > > +                     ptr =3D (u64 *)((unsigned=20
>> > > long)&ring->tx_stats +
>> > > +                             ena_stats->stat_offset);
>> >=20
>> > struct ena_ring {
>> > ...
>> >         union {
>> >                 struct ena_stats_tx tx_stats;
>> >                 struct ena_stats_rx rx_stats;
>> >         };
>> >=20
>> > struct ena_stats_tx {
>> >         u64 cnt;
>> >         u64 bytes;
>> >         u64 queue_stop;
>> >         u64 prepare_ctx_err;
>> >         u64 queue_wakeup;
>> >         ...
>> > }
>> >=20
>> > &ring->tx_stats will give you a struct=20
>> > *ena_stats_tx. Arithmetic on that,
>> > adding 1 for example, takes you forward a full ena_stats_tx=20
>> > structure. Not
>> > what you want.
>> >=20
>> > &ring->tx_stats.cnt however, will give you a u64 *. Adding 1=20
>> > to that will give
>> > you bytes, etc.
>>=20
>>=20
>> If I understand you well, the alternative approach you are=20
>> suggesting is:
>>=20
>> ptr =3D &ring->tx_stats.cnt + ena_stats->stat_offset;
>
> I don't want to stir up the pot, but do you really need the=20
> offsetof() of
> each member in the stats struct? Couldn't you piggyback on=20
> assumption that
> these stats need to be u64 and just walk the struct with=20
> pointer?
>
> 	struct ena_ring *ring;
> 	int offset;
> 	int i, j;
> 	u8 *ptr;
>
> 	for (i =3D 0; i < adapter->num_io_queues; i++) {
> 		/* Tx stats */
> 		ring =3D &adapter->tx_ring[i];
> 		ptr =3D (u8 *)&ring->tx_stats;
>
> 		for (j =3D 0; j < ENA_STATS_ARRAY_TX; j++) {
> 			ena_safe_update_stat((u64 *)ptr,=20
> (*data)++, &ring->syncp);
> 			ptr +=3D sizeof(u64);
> 		}
> 	}
>
> I find this as a simpler and lighter solution. There might be=20
> issues with
> code typed in email client, but you get the idea.
>
>>=20
>> of course we need to convert the stat_offset field to be in 8=20
>> bytes resolution instead.
>>=20
>> This approach has a potential bug hidden in it. If in the=20
>> future
>> someone decides to expand the "ena_stats_tx" struct and add a=20
>> field preceding cnt,
>> cnt will no longer be the beginning of the struct, which will=20
>> cause a bug."
>>=20
>> Therefore, if you have another way to do this, please share=20
>> it. Otherwise I'd
>> rather leave this code as it is for the sake of robustness.
>>=20
>> >=20
>> >      Andrew

Hi all,

We tried to implement your suggestion, and found that removing the=20
stat_offset
field causes problems that are challenging to solve.
Removing stat_offset introduces a requirement that the statistics=20
in a stat
strings array (check [1] for example) and stat variables struct=20
(check [2] for
example) must be in the same order.
This requirement is prone to future bugs that might be challenging=20
to locate.
We also tried to unify the array and struct creation by
using X macros. At the moment this change requires more time and=20
effort by us
and our customers need this code merged asap.

[1] https://elixir.bootlin.com/linux/v5.9-
rc3/source/drivers/net/ethernet/amazon/ena/ena_ethtool.c#L71
[2] https://elixir.bootlin.com/linux/v5.9-
rc3/source/drivers/net/ethernet/amazon/ena/ena_netdev.h#L232

(This message was sent before but didn't seem to get into the=20
mailing list. Apologies if you got it twice)
