Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45CB1108BB7
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 11:31:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbfKYKb3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 05:31:29 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:42192 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727316AbfKYKb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 05:31:29 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 17D9AB8005A;
        Mon, 25 Nov 2019 10:31:27 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 25 Nov
 2019 10:31:16 +0000
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
To:     Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>,
        "Alexander Lobakin" <alobakin@dlink.ru>
CC:     David Miller <davem@davemloft.net>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "petrm@mellanox.com" <petrm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jaswinder.singh@linaro.org" <jaswinder.singh@linaro.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johannes.berg@intel.com" <johannes.berg@intel.com>,
        "emmanuel.grumbach@intel.com" <emmanuel.grumbach@intel.com>,
        "luciano.coelho@intel.com" <luciano.coelho@intel.com>,
        "linuxwifi@intel.com" <linuxwifi@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <20191014080033.12407-1-alobakin@dlink.ru>
 <20191015.181649.949805234862708186.davem@davemloft.net>
 <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
 <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <c762f5eee08a8f2d0d6cb927d7fa3848@dlink.ru>
 <746f768684f266e5a5db1faf8314cd77@dlink.ru>
 <PSXP216MB0438267E8191486435445DA6804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <cc08834c-ccb3-263a-2967-f72a9d72535a@solarflare.com>
Date:   Mon, 25 Nov 2019 10:31:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <PSXP216MB0438267E8191486435445DA6804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25064.003
X-TM-AS-Result: No-1.151000-8.000000-10
X-TMASE-MatchedRID: UuaOI1zLN1j4ECMHJTM/ufZvT2zYoYOwC/ExpXrHizy8YDH/UBNnm3z4
        lkFFZozya26WJASrL3w0+NJuUFRWY2j8oZRXwTGoxcDvxm0Uv+AGchEhVwJY35KK7cYRdL7/Vsm
        drKQylyhpaitsZvBsZIHdbZCx6yrRdsj49V16pSkNwUVhIF6pVkqAhuLHn5fEjiLABC6i+1idW2
        C/Ex2sg7Ooz1ouKUE5VNP1aViTJ070aUnP7vi4bKiUivh0j2PvFfK1en1S7ASk+oW3oLzmHhrlf
        Onvg2DrfeTxrBFoEvNRw+drvbtM+VI3mP8aC0PBA9lly13c/gH4qCLIu0mtIGOMyb1Ixq8VOI1Z
        1dPBhuC1qON8SzJ0P5soi2XrUn/JIq95DjCZh0wfRoCwBzgRYsK21zBg2KlfStBGwEBjie75G5W
        ryQ6GyOk4Bm1wCfA4CvSKnd9MgcyDtEH2wvxTnhjdkxo5gR4SnVm6UUeKDSIBwP3ZU9+WVuv1VZ
        5IK4cftLvi6hXUM9JR029mOM6P0LrcE8xytxC5d5hZXZFoB8PxWx93BSYyye53VB1DJl7uftwZ3
        X11IV0=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.151000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25064.003
X-MDID: 1574677888-6w8_0MOmzWTL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/11/2019 09:09, Nicholas Johnson wrote:
> The default value of /proc/sys/net/core/gro_normal_batch was 8.
> Setting it to 1 allowed it to connect to Wi-Fi network.
>
> Setting it back to 8 did not kill the connection.
>
> But when I disconnected and tried to reconnect, it did not re-connect.
>
> Hence, it appears that the problem only affects the initial handshake 
> when associating with a network, and not normal packet flow.
That sounds like the GRO batch isn't getting flushed at the endof the
 NAPI — maybe the driver isn't calling napi_complete_done() at the
 appropriate time?
Indeed, from digging through the layers of iwlwifi I eventually get to
 iwl_pcie_rx_handle() which doesn't really have a NAPI poll (the
 napi->poll function is iwl_pcie_dummy_napi_poll() { WARN_ON(1);
 return 0; }) and instead calls napi_gro_flush() at the end of its RX
 handling.  Unfortunately, napi_gro_flush() is no longer enough,
 because it doesn't call gro_normal_list() so the packets on the
 GRO_NORMAL list just sit there indefinitely.

It was seeing drivers calling napi_gro_flush() directly that had me
 worried in the first place about whether listifying napi_gro_receive()
 was safe and where the gro_normal_list() should go.
I wondered if other drivers that show up in [1] needed fixing with a
 gro_normal_list() next to their napi_gro_flush() call.  From a cursory
 check:
brocade/bna: has a real poller, calls napi_complete_done() so is OK.
cortina/gemini: calls napi_complete_done() straight after
 napi_gro_flush(), so is OK.
hisilicon/hns3: calls napi_complete(), so is _probably_ OK.
But it's far from clear to me why *any* of those drivers are calling
 napi_gro_flush() themselves...

-Ed

[1]: https://elixir.bootlin.com/linux/latest/ident/napi_gro_flush
