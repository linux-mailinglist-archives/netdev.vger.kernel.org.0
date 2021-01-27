Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD2930582A
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 11:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235802AbhA0KU1 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 27 Jan 2021 05:20:27 -0500
Received: from mga04.intel.com ([192.55.52.120]:12222 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235772AbhA0KSi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 05:18:38 -0500
IronPort-SDR: k804PLaT+Xs8sK3PXfGOJ+rhEea/ZBkCNhEqXm6VkHqA/4ECIG9Zz/NNTbDQjWeBodfkjsTLEY
 6TwKRCOd2GOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9876"; a="177480621"
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="177480621"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 02:17:53 -0800
IronPort-SDR: O2LzOAxpT6+IT1PQLArFrvo0H5FgmLocP6G21GxLcYZn17wvLuGBxrw0l1oehZmcdrsTh53aU4
 /ITAg/8Rb2cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,378,1602572400"; 
   d="scan'208";a="369429727"
Received: from irsmsx603.ger.corp.intel.com ([163.33.146.9])
  by orsmga002.jf.intel.com with ESMTP; 27 Jan 2021 02:17:52 -0800
Received: from irsmsx604.ger.corp.intel.com (163.33.146.137) by
 irsmsx603.ger.corp.intel.com (163.33.146.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 27 Jan 2021 10:17:51 +0000
Received: from irsmsx604.ger.corp.intel.com ([163.33.146.137]) by
 IRSMSX604.ger.corp.intel.com ([163.33.146.137]) with mapi id 15.01.1713.004;
 Wed, 27 Jan 2021 10:17:51 +0000
From:   "Loftus, Ciara" <ciara.loftus@intel.com>
To:     =?iso-8859-1?Q?Toke_H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Janjua, Weqaar A" <weqaar.a.janjua@intel.com>
CC:     Neil Horman <nhorman@tuxdriver.com>
Subject: RE: [PATCH bpf-next v2 0/6] AF_XDP Packet Drop Tracing
Thread-Topic: [PATCH bpf-next v2 0/6] AF_XDP Packet Drop Tracing
Thread-Index: AQHW87xr48HP1FSuzUeAtK0HFw5tvqo5l6SAgAGruZA=
Date:   Wed, 27 Jan 2021 10:17:51 +0000
Message-ID: <5b5f55cb00f045a2a343625563e86293@intel.com>
References: <20210126075239.25378-1-ciara.loftus@intel.com>
 <87bldccciw.fsf@toke.dk>
In-Reply-To: <87bldccciw.fsf@toke.dk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-originating-ip: [163.33.253.164]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 
> Ciara Loftus <ciara.loftus@intel.com> writes:
> 
> > This series introduces tracing infrastructure for AF_XDP sockets (xsks).
> > A trace event 'xsk_packet_drop' is created which can be enabled by
> toggling
> >
> > /sys/kernel/debug/tracing/events/xsk/xsk_packet_drop/enable
> >
> > When enabled and packets are dropped in the kernel, traces are generated
> > which describe the reason for the packet drop as well as the netdev and
> > qid information of the xsk which encountered the drop.
> >
> > Example traces:
> >
> > 507.588563: xsk_packet_drop: netdev: eth0 qid 0 reason: rxq full
> > 507.588567: xsk_packet_drop: netdev: eth0 qid 0 reason: packet too big
> > 507.588568: xsk_packet_drop: netdev: eth0 qid 0 reason: fq empty
> >
> > The event can also be monitored using perf:
> >
> > perf stat -a -e xsk:xsk_packet_drop
> 
> Would it make sense to also hook this up to drop_monitor?
> 
> -Toke

Thanks for bring that to my attention Toke. I think it makes sense.
I put together a quick prototype and it looks like a good fit.
Neil what do you think?
Perhaps as a follow up patch to the series in question however?

Ciara
