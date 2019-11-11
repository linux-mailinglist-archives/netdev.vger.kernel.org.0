Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2985FF7A6E
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 19:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfKKSBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 13:01:44 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:38292 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726910AbfKKSBo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:01:44 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 79175580051;
        Mon, 11 Nov 2019 18:01:41 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Mon, 11 Nov
 2019 18:01:33 +0000
Subject: Re: [PATCH net-next] sfc: trace_xdp_exception on XDP failure
To:     Arthur Fabre <afabre@cloudflare.com>
CC:     Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "Charles McLachlan" <cmclachlan@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        David Miller <davem@davemloft.net>,
        "Alexei Starovoitov" <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
References: <20191111105100.2992-1-afabre@cloudflare.com>
 <f58a73a8-631c-a9a1-25e9-a5f0050df13c@solarflare.com>
 <CAOn4ftvqib3y+Gfhq+dS4cUeWQVyGDM+rNeLnoVoYz9O_VLYLA@mail.gmail.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <6a3705cc-809d-0c7a-d39f-97d61c4ce58c@solarflare.com>
Date:   Mon, 11 Nov 2019 18:01:30 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAOn4ftvqib3y+Gfhq+dS4cUeWQVyGDM+rNeLnoVoYz9O_VLYLA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25036.003
X-TM-AS-Result: No-6.224200-8.000000-10
X-TMASE-MatchedRID: QW5G6BKkLTrmLzc6AOD8DfHkpkyUphL9SeIjeghh/zNcpms3pMhT0ciT
        Wug2C4DNl1M7KT9/aqDCGaYSzXQ4OcxAixoJws1YA9lly13c/gHYuVu0X/rOkPa7agslQWYYS8X
        QUmo7QNjtxcbrBYMsBPI1z1fnOPlxeW+Dbewdu5u84C/3iwAgxBfbPFE2GHrVX30pMm+iz0jD1l
        mWT+88Nu0ooccEm+Y0l57hPGdoWxvti3IwtSm+K5qvoi7RQmPSBnIRIVcCWN9Z+M9E/Hx6KHs6g
        pw5sMWK4vM1YF6AJbZFi+KwZZttL7ew1twePJJB3QfwsVk0UbsIoUKaF27lxbFqR/fS2lRWQI+Z
        YiTJvTP3JJ+Vk6CDGYP9zRn7y7SSAPJbQtdK6V5drZQZg8ilGyo0N27D4SnfxH+VL6lfYyS5tBV
        HNvTD6aKAQfLsnhLrKWSt4DmvbhpicKLmK2TeKmsPn5C6nWpTnqg/VrSZEiM=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.224200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25036.003
X-MDID: 1573495303-L0Xg_U-n0USA
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/2019 17:38, Arthur Fabre wrote:
> On Mon, Nov 11, 2019 at 5:27 PM Edward Cree <ecree@solarflare.com> wrote:
>>
>> On 11/11/2019 10:51, Arthur Fabre wrote:
>>> diff --git a/drivers/net/ethernet/sfc/rx.c b/drivers/net/ethernet/sfc/rx.c
>>> index a7d9841105d8..5bfe1f6112a1 100644
>>> --- a/drivers/net/ethernet/sfc/rx.c
>>> +++ b/drivers/net/ethernet/sfc/rx.c
>>> @@ -678,6 +678,7 @@ static bool efx_do_xdp(struct efx_nic *efx, struct efx_channel *channel,
>>>                                 "XDP is not possible with multiple receive fragments (%d)\n",
>>>                                 channel->rx_pkt_n_frags);
>>>               channel->n_rx_xdp_bad_drops++;
>>> +             trace_xdp_exception(efx->net_dev, xdp_prog, xdp_act);
>>>               return false;
>>>       }
>> AIUI trace_xdp_exception() is improper here as we have not run
>>  the XDP program (and xdp_act is thus uninitialised).
>>
>> The other three, below, appear to be correct.
>> -Ed
>>
> 
> Good point. Do you know under what conditions we'd end up with
> "fragmented" packets? As far as I can tell this isn't IP
> fragmentation?

Fragments in this case means that the packet data are spread across
 multiple RX buffers (~= memory pages).  This should only happen if
 the RX packet is too big to fit in a single buffer, and when
 enabling XDP we ensure that the MTU is small enough to prevent
 that.  So in theory this can't happen if the NIC is functioning
 correctly.

-Ed
