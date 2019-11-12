Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2502CF95DA
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 17:42:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbfKLQmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 11:42:46 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:49456 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726008AbfKLQmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 11:42:46 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 50BB558006B;
        Tue, 12 Nov 2019 16:42:44 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 12 Nov
 2019 16:42:36 +0000
Subject: Re: [PATCH v2 net-next] sfc: trace_xdp_exception on XDP failure
To:     Arthur Fabre <afabre@cloudflare.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        Charles McLachlan <cmclachlan@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <kernel-team@cloudflare.com>
References: <20191112153601.5849-1-afabre@cloudflare.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <29aea663-e252-4c4f-1d29-d575395206ea@solarflare.com>
Date:   Tue, 12 Nov 2019 16:42:33 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191112153601.5849-1-afabre@cloudflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25038.003
X-TM-AS-Result: No-0.331100-8.000000-10
X-TMASE-MatchedRID: 5+1rHnqhWUTmLzc6AOD8DfHkpkyUphL9SWg+u4ir2NNpsnGGIgWMmSUL
        izGxgJgi+H4tK0sV2EtUAnueMw/a9b0GYUxZsfvIM71h0SMVl8L5awEvkHdlMZsoi2XrUn/JyeM
        tMD9QOgCY/fxzcM2LJMce5dMCYKFd3QfwsVk0UbuZ/dgf3Hl0lT+/NOhE1QTyNb6FP0RjU60Bh4
        4+iA8Q+EXpQkE665TKmeZpUFZo7zcM5cYZIqzaRV4Fqk6hA49GvElm7Yg+db5YSpSC0RmOAKKAQ
        fLsnhLrKWSt4DmvbhpicKLmK2TeKmsPn5C6nWpTiTSgm8kJVKRDDKa3G4nrLQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-0.331100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25038.003
X-MDID: 1573576965-aCx6MmK-vyYX
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/11/2019 15:36, Arthur Fabre wrote:
> The sfc driver can drop packets processed with XDP, notably when running
> out of buffer space on XDP_TX, or returning an unknown XDP action.
> This increments the rx_xdp_bad_drops ethtool counter.
>
> Call trace_xdp_exception everywhere rx_xdp_bad_drops is incremented,
> except for fragmented RX packets as the XDP program hasn't run yet.
> This allows it to easily be monitored from userspace.
>
> This mirrors the behavior of other drivers.
>
> Signed-off-by: Arthur Fabre <afabre@cloudflare.com>
Acked-by: Edward Cree <ecree@solarflare.com>
