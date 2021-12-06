Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9102F46A4D9
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347322AbhLFSrv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:47:51 -0500
Received: from mga14.intel.com ([192.55.52.115]:36114 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346257AbhLFSru (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 13:47:50 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10190"; a="237605152"
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="237605152"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 10:44:21 -0800
X-IronPort-AV: E=Sophos;i="5.87,292,1631602800"; 
   d="scan'208";a="515086341"
Received: from jperiasx-mobl.amr.corp.intel.com (HELO mjmartin-desk2) ([10.251.18.10])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2021 10:44:21 -0800
Date:   Mon, 6 Dec 2021 10:44:16 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     Florian Westphal <fw@strlen.de>, mptcp@lists.linux.dev,
        syzkaller-bugs@googlegroups.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+1fd9b69cde42967d1add@syzkaller.appspotmail.com
Subject: Re: [PATCH mptcp] mptcp: remove tcp ulp setsockopt support
In-Reply-To: <20211206075515.3cf5b0df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <2297cabb-be69-98ef-f4fc-d9472c7820cc@linux.intel.com>
References: <00000000000040972505d24e88e3@google.com> <20211205192700.25396-1-fw@strlen.de> <20211206075326.700f2078@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <20211206075515.3cf5b0df@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 6 Dec 2021, Jakub Kicinski wrote:

> On Mon, 6 Dec 2021 07:53:26 -0800 Jakub Kicinski wrote:
>> On Sun,  5 Dec 2021 20:27:00 +0100 Florian Westphal wrote:
>>> TCP_ULP setsockopt cannot be used for mptcp because its already
>>> used internally to plumb subflow (tcp) sockets to the mptcp layer.
>>>
>>> syzbot managed to trigger a crash for mptcp connections that are
>>> in fallback mode:
>>
>> Fallback mode meaning ops are NULL? I'm slightly confused by this
>> report.
>
> Ah, it's the socket not the ops.
>
>>> KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
>>> CPU: 1 PID: 1083 Comm: syz-executor.3 Not tainted 5.16.0-rc2-syzkaller #0
>>> RIP: 0010:tls_build_proto net/tls/tls_main.c:776 [inline]
>>> [..]
>>>  __tcp_set_ulp net/ipv4/tcp_ulp.c:139 [inline]
>>>  tcp_set_ulp+0x428/0x4c0 net/ipv4/tcp_ulp.c:160
>>>  do_tcp_setsockopt+0x455/0x37c0 net/ipv4/tcp.c:3391
>>>  mptcp_setsockopt+0x1b47/0x2400 net/mptcp/sockopt.c:638
>>>
>>> Remove support for TCP_ULP setsockopt.
>>>
>>> Reported-by: syzbot+1fd9b69cde42967d1add@syzkaller.appspotmail.com
>>> Signed-off-by: Florian Westphal <fw@strlen.de>

Jakub -

If you could mark this as "Not Applicable" in netdevbpf patchwork, we'll 
apply it to the mptcp tree and resubmit to netdev with some related 
patches.

Thanks,

--
Mat Martineau
Intel
