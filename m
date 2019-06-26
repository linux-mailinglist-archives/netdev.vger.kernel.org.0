Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70886571F7
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 21:44:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbfFZToa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 15:44:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:64886 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726465AbfFZToa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 15:44:30 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jun 2019 12:44:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,421,1557212400"; 
   d="asc'?scan'208";a="245538021"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by orsmga001.jf.intel.com with ESMTP; 26 Jun 2019 12:44:29 -0700
Message-ID: <4f0681155a6057bf40e281bfc251aba60c296201.camel@intel.com>
Subject: Re: [PATCH net-next v6 1/8] igb: clear out skb->tstamp after
 reading the txtime
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To:     Vedang Patel <vedang.patel@intel.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, intel-wired-lan@lists.osuosl.org,
        vinicius.gomes@intel.com, l@dorileo.org,
        jakub.kicinski@netronome.com, m-karicheri2@ti.com,
        sergei.shtylyov@cogentembedded.com, eric.dumazet@gmail.com,
        aaron.f.brown@intel.com
Date:   Wed, 26 Jun 2019 12:44:59 -0700
In-Reply-To: <1561500439-30276-2-git-send-email-vedang.patel@intel.com>
References: <1561500439-30276-1-git-send-email-vedang.patel@intel.com>
         <1561500439-30276-2-git-send-email-vedang.patel@intel.com>
Organization: Intel
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-azZSYmfVbNnCAR9yg4Im"
User-Agent: Evolution 3.32.3 (3.32.3-1.fc30) 
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-azZSYmfVbNnCAR9yg4Im
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2019-06-25 at 15:07 -0700, Vedang Patel wrote:
> If a packet which is utilizing the launchtime feature (via SO_TXTIME
> socket
> option) also requests the hardware transmit timestamp, the hardware
> timestamp is not delivered to the userspace. This is because the
> value in
> skb->tstamp is mistaken as the software timestamp.
>=20
> Applications, like ptp4l, request a hardware timestamp by setting the
> SOF_TIMESTAMPING_TX_HARDWARE socket option. Whenever a new timestamp
> is
> detected by the driver (this work is done in igb_ptp_tx_work() which
> calls
> igb_ptp_tx_hwtstamps() in igb_ptp.c[1]), it will queue the timestamp
> in the
> ERR_QUEUE for the userspace to read. When the userspace is ready, it
> will
> issue a recvmsg() call to collect this timestamp.  The problem is in
> this
> recvmsg() call. If the skb->tstamp is not cleared out, it will be
> interpreted as a software timestamp and the hardware tx timestamp
> will not
> be successfully sent to the userspace. Look at skb_is_swtx_tstamp()
> and the
> callee function __sock_recv_timestamp() in net/socket.c for more
> details.
>=20
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 1 +
>  1 file changed, 1 insertion(+)

Since this fix is really not needed for the rest of the patch series,
if you have to do another version of the series, can you drop this
patch from any future version?  I don't want to keep spinning my
validation team on a updated version of this patch, that is not really
being updated.

I plan to take this version of the patch and will hold onto it for my
next 1GbE updates to Dave.

--=-azZSYmfVbNnCAR9yg4Im
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiTyZWz+nnTrOJ1LZ5W/vlVpL7c4FAl0TyzsACgkQ5W/vlVpL
7c5J2hAAifwAwmTbjWs8qvmait61oc1eR8LKSgjOnkQRejuOXV39ziObqJIDnY2D
Ml2Q7K7qHiHkPvRj3asC/XdUAnjJn0n/se2vdU6XhRx8ZyvpG+/xVk4fvNkSnCA6
0vUFSekauyuWN15+CN98U7Fcdwqhb4fdsKKr4CFtjexHrio+0uptGV7OUvmziF5R
b/0kitLOrnnMEzjDYbDQnTrafwLcFcEkcnV9fPCToZD0Sq0cSD3YYt2E/CypYQy8
Ik9D8aJc/eGWk3jxWNd2l80O7+tZ2sWEeccC8kRw9oPnw1JP7hJl815vY9nesHv5
Wv4hm++nqa+lbma33u8eoCjnOemy4lqcyLtAO1ejBegTtYZ/SPnOxduXfbWaIyJr
HbBKdFRTv3BgEokImjsur8IYGXjAzcHiaRHCZCSVigwfQiGQHsMWs9qdXqh4HUVB
Anoq1jUQulRP5W6dPkWd/O1cwzwP7HjsvGL4r/LEkYrvXNcCJHyw9nQbsWdBLm/y
sLYNlR/yYhznK9GI5S4PKqTu5uBwCizKgljsaIL/eq5ggWAflBty2+w7Q5O7W/mF
32OQf7xQJSBC+hJYxQ/u0XOsfqnqXzxRKX/qUrKyjnA1cpQmiq9rN8C+Hd1D67pk
QalevgsLEZzBnAOhOTr2xj4REdUFloG1QgQ/SnrDwuEJaz1FiuI=
=pMYP
-----END PGP SIGNATURE-----

--=-azZSYmfVbNnCAR9yg4Im--

