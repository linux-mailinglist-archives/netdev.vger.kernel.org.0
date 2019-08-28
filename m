Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D99FA00E7
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 13:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfH1LnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 07:43:23 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44026 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725991AbfH1LnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 07:43:23 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1i2wMD-0002Jo-PT; Wed, 28 Aug 2019 13:43:21 +0200
Date:   Wed, 28 Aug 2019 13:43:21 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org
Subject: multipath tcp MIB counter placement - share with tcp or extra?
Message-ID: <20190828114321.GG20113@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric,

The out-of-tree multipath TCP stack adds a few MIB counters to track
(and debug) MTPCP behaviour.  Examples:

        SNMP_MIB_ITEM("MPCapableSYNRX", MPTCP_MIB_MPCAPABLEPASSIVE),
        SNMP_MIB_ITEM("MPCapableSYNTX", MPTCP_MIB_MPCAPABLEACTIVE),
[..]
        SNMP_MIB_ITEM("MPTCPRetrans", MPTCP_MIB_RETRANSSEGS),
        SNMP_MIB_ITEM("MPFailRX", MPTCP_MIB_MPFAILRX),
        SNMP_MIB_ITEM("MPCsumFail", MPTCP_MIB_CSUMFAIL),

and so on.

I think that such MIB counters would be good to have in the 'upstreaming'
attempt as well.

The out-of-tree code keeps them separate from the tcp mib counters and also
exposes them in a different /proc file (/proc/net/mptcp_net/snmp).

Would you be ok with mptcp-upstreaming adding its MIB counters to the
existing TCP MIB instead?

This would make 'nstat' and other tools pick them up automatically.
It would also help TCP highlevel debugging to see if MPTCP is involved
in any way.

Let me know -- I can go with a separate MIB, its no problem, I just want
to avoid going down the wrong path.

Thanks,
Florian
