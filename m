Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7DB5591CD
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 05:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfF1DB2 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Jun 2019 23:01:28 -0400
Received: from mga02.intel.com ([134.134.136.20]:1252 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726542AbfF1DB2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 23:01:28 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Jun 2019 20:01:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,426,1557212400"; 
   d="scan'208";a="153246529"
Received: from orsmsx102.amr.corp.intel.com ([10.22.225.129])
  by orsmga007.jf.intel.com with ESMTP; 27 Jun 2019 20:01:27 -0700
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX102.amr.corp.intel.com (10.22.225.129) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 27 Jun 2019 20:01:27 -0700
Received: from orsmsx103.amr.corp.intel.com ([169.254.5.135]) by
 ORSMSX123.amr.corp.intel.com ([169.254.1.46]) with mapi id 14.03.0439.000;
 Thu, 27 Jun 2019 20:01:27 -0700
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     "Patel, Vedang" <vedang.patel@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "sergei.shtylyov@cogentembedded.com" 
        <sergei.shtylyov@cogentembedded.com>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>
Subject: RE: [PATCH net-next v6 1/8] igb: clear out skb->tstamp after
 reading the txtime
Thread-Topic: [PATCH net-next v6 1/8] igb: clear out skb->tstamp after
 reading the txtime
Thread-Index: AQHVK6JhORymmhQOqEeRp0Ppbqf7zaawZCXw
Date:   Fri, 28 Jun 2019 03:01:26 +0000
Message-ID: <309B89C4C689E141A5FF6A0C5FB2118B970B546C@ORSMSX103.amr.corp.intel.com>
References: <1561500439-30276-1-git-send-email-vedang.patel@intel.com>
 <1561500439-30276-2-git-send-email-vedang.patel@intel.com>
In-Reply-To: <1561500439-30276-2-git-send-email-vedang.patel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzgwYjFjZDEtNjU5ZS00NTc4LTk5OWEtN2Q1YjBkYWUzMDNmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoieGlrZ1VzVlNcLytLUWhNVkE0cHI5dFpENGNMWUVXUVBqTTlmUHFmam54QkhIaCszb01FRmw1RHJ6NTlRcmdYTm4ifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Patel, Vedang
> Sent: Tuesday, June 25, 2019 3:07 PM
> To: netdev@vger.kernel.org
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> jhs@mojatatu.com; xiyou.wangcong@gmail.com; jiri@resnulli.us; intel-wired-
> lan@lists.osuosl.org; Gomes, Vinicius <vinicius.gomes@intel.com>;
> l@dorileo.org; jakub.kicinski@netronome.com; m-karicheri2@ti.com;
> sergei.shtylyov@cogentembedded.com; eric.dumazet@gmail.com; Brown,
> Aaron F <aaron.f.brown@intel.com>; Patel, Vedang <vedang.patel@intel.com>
> Subject: [PATCH net-next v6 1/8] igb: clear out skb->tstamp after reading the
> txtime
> 
> If a packet which is utilizing the launchtime feature (via SO_TXTIME socket
> option) also requests the hardware transmit timestamp, the hardware
> timestamp is not delivered to the userspace. This is because the value in
> skb->tstamp is mistaken as the software timestamp.
> 
> Applications, like ptp4l, request a hardware timestamp by setting the
> SOF_TIMESTAMPING_TX_HARDWARE socket option. Whenever a new
> timestamp is
> detected by the driver (this work is done in igb_ptp_tx_work() which calls
> igb_ptp_tx_hwtstamps() in igb_ptp.c[1]), it will queue the timestamp in the
> ERR_QUEUE for the userspace to read. When the userspace is ready, it will
> issue a recvmsg() call to collect this timestamp.  The problem is in this
> recvmsg() call. If the skb->tstamp is not cleared out, it will be
> interpreted as a software timestamp and the hardware tx timestamp will not
> be successfully sent to the userspace. Look at skb_is_swtx_tstamp() and the
> callee function __sock_recv_timestamp() in net/socket.c for more details.
> 
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 1 +
>  1 file changed, 1 insertion(+)
> 
Tested-by: Aaron Brown <aaron.f.brown@intel.com>

