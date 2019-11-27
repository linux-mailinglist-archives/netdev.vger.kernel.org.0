Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 827C110B2EA
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 17:05:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727138AbfK0QFg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 11:05:36 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:55650 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726603AbfK0QFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 11:05:36 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us4.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id DC4ED140091;
        Wed, 27 Nov 2019 16:05:33 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Wed, 27 Nov
 2019 16:05:22 +0000
Subject: Re: [PATCH net] net: wireless: intel: iwlwifi: fix GRO_NORMAL packet
 stalling
To:     Alexander Lobakin <alobakin@dlink.ru>,
        "David S. Miller" <davem@davemloft.net>
CC:     Jiri Pirko <jiri@mellanox.com>, Eric Dumazet <edumazet@google.com>,
        "Ido Schimmel" <idosch@mellanox.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Petr Machata <petrm@mellanox.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        "Manish Chopra" <manishc@marvell.com>,
        <GR-Linux-NIC-Dev@marvell.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        "Kenneth R. Crudup" <kenny@panix.com>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20191127094123.18161-1-alobakin@dlink.ru>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <20a018a6-827a-de47-a0e4-45ff8c02087b@solarflare.com>
Date:   Wed, 27 Nov 2019 16:05:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191127094123.18161-1-alobakin@dlink.ru>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25068.003
X-TM-AS-Result: No-2.916000-8.000000-10
X-TMASE-MatchedRID: 1GZI+iG+MtfmLzc6AOD8DfHkpkyUphL9B7lMZ4YsZk/RLEyE6G4DRFDT
        Kayi2ZF6QOaAfcvrs35HBaYvF0hxKFQcsas26nLQLyz9QvAyHjo0AJe3B5qfBgQsw9A3PIlLfeR
        HqXTAYgbUqkiO26feqA2FRXLSS+vrmKa4M58UVVYBnSWdyp4eoXFa/hQHt1A1wubD3SFbWzv3h2
        jybQkTkqdL8KI7XN648dZ5VcPdHTpyPzMTUSO1JP5/gVn+bUDMNV9S7O+u3KYZwGrh4y4izH1a0
        2rGxHiJ31rPPTNFvISK2jE700vQHbp4BGlNqtR8LbjXqdzdtCXrixWWWJYrH01+zyfzlN7ygxsf
        zkNRlfKx5amWK2anSPoLR4+zsDTt+GYUedkXNWqMK5Qm/U0G90/h8PPR9Wyqvd+6IqaLHYtW8qO
        kPe265is7C65Y7GDJDGmw3Q+A1RzSS97R9sl6CenrP6nUgUSzU7PqY3kOZ2mHzGTHoCwyHhlNKS
        p2rPkW5wiX7RWZGYs2CWDRVNNHuzflzkGcoK72
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.916000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25068.003
X-MDID: 1574870734-9g_yLSIuo-Lh
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/11/2019 09:41, Alexander Lobakin wrote:
> Commit 6570bc79c0df ("net: core: use listified Rx for GRO_NORMAL in
> napi_gro_receive()") has applied batched GRO_NORMAL packets processing
> to all napi_gro_receive() users, including mac80211-based drivers.
>
> However, this change has led to a regression in iwlwifi driver [1][2] as
> it is required for NAPI users to call napi_complete_done() or
> napi_complete() and the end of every polling iteration, whilst iwlwifi
> doesn't use NAPI scheduling at all and just calls napi_gro_flush().
> In that particular case, packets which have not been already flushed
> from napi->rx_list stall in it until at least next Rx cycle.
>
> Fix this by adding a manual flushing of the list to iwlwifi driver right
> before napi_gro_flush() call to mimic napi_complete() logics.
>
> I prefer to open-code gro_normal_list() rather than exporting it for 2
> reasons:
> * to prevent from using it and napi_gro_flush() in any new drivers,
>   as it is the *really* bad way to use NAPI that should be avoided;
> * to keep gro_normal_list() static and don't lose any CC optimizations.
>
> I also don't add the "Fixes:" tag as the mentioned commit was only a
> trigger that only exposed an improper usage of NAPI in this particular
> driver.
>
> [1] https://lore.kernel.org/netdev/PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
> [2] https://bugzilla.kernel.org/show_bug.cgi?id=205647
>
> Signed-off-by: Alexander Lobakin <alobakin@dlink.ru>
Reviewed-by: Edward Cree <ecree@solarflare.com>
