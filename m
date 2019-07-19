Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302586E8A4
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728727AbfGSQVa convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 19 Jul 2019 12:21:30 -0400
Received: from mga12.intel.com ([192.55.52.136]:28121 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728051AbfGSQVa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 12:21:30 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jul 2019 09:21:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,283,1559545200"; 
   d="scan'208";a="320004439"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by orsmga004.jf.intel.com with ESMTP; 19 Jul 2019 09:21:29 -0700
Received: from orsmsx123.amr.corp.intel.com (10.22.240.116) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 19 Jul 2019 09:21:28 -0700
Received: from orsmsx104.amr.corp.intel.com ([169.254.4.232]) by
 ORSMSX123.amr.corp.intel.com ([169.254.1.245]) with mapi id 14.03.0439.000;
 Fri, 19 Jul 2019 09:21:28 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] [PATCH] i40e: reduce stack usage in
 i40e_set_fc
Thread-Topic: [Intel-wired-lan] [PATCH] i40e: reduce stack usage in
 i40e_set_fc
Thread-Index: AQHVOwnVVFCI4V0hdECZPxc3EWAaEKbSJavw
Date:   Fri, 19 Jul 2019 16:21:27 +0000
Message-ID: <26D9FDECA4FBDD4AADA65D8E2FC68A4A1D40C2EB@ORSMSX104.amr.corp.intel.com>
References: <20190715123518.3510791-1-arnd@arndb.de>
In-Reply-To: <20190715123518.3510791-1-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNTljMGYyYzItYTEwYy00MzY5LThiNTctNTk5NTEwOTczOWVmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoia1FMaEpKT3NXbVhlZlY1Q2Z3dFhaaEp4TVV3WnZHNmpcL0hvU255eU9RcXZsQWpwZ2hMS0JDUWp6U2V0WXB1VVMifQ==
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.0.400.15
dlp-reaction: no-action
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan [mailto:intel-wired-lan-bounces@osuosl.org] On
> Behalf Of Arnd Bergmann
> Sent: Monday, July 15, 2019 5:35 AM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; David S. Miller
> <davem@davemloft.net>
> Cc: Catherine Sullivan <catherine.sullivan@intel.com>; Dziggel, Douglas A
> <douglas.a.dziggel@intel.com>; Arnd Bergmann <arnd@arndb.de>;
> netdev@vger.kernel.org; Patryk Ma³ek <patryk.malek@intel.com>; linux-
> kernel@vger.kernel.org; Azarewicz, Piotr <piotr.azarewicz@intel.com>;
> Loktionov, Aleksandr <aleksandr.loktionov@intel.com>; clang-built-
> linux@googlegroups.com; intel-wired-lan@lists.osuosl.org; Marczak, Piotr
> <piotr.marczak@intel.com>
> Subject: [Intel-wired-lan] [PATCH] i40e: reduce stack usage in i40e_set_fc
> 
> The functions i40e_aq_get_phy_abilities_resp() and i40e_set_fc() both have
> giant structure on the stack, which makes each one use stack frames larger
> than 500 bytes.
> 
> As clang decides one function into the other, we get a warning for exceeding
> the frame size limit on 32-bit architectures:
> 
> drivers/net/ethernet/intel/i40e/i40e_common.c:1654:23: error: stack frame
> size of 1116 bytes in function 'i40e_set_fc' [-Werror,-Wframe-larger-than=]
> 
> When building with gcc, the inlining does not happen, but i40e_set_fc() calls
> i40e_aq_get_phy_abilities_resp() anyway, so they add up on the kernel
> stack just as much.
> 
> The parts that actually use large stacks don't overlap, so make sure each one
> is a separate function, and mark them as noinline_for_stack to prevent the
> compilers from combining them again.
> 
> Fixes: 0a862b43acc6 ("i40e/i40evf: Add module_types and
> update_link_info")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_common.c | 91 +++++++++++--------
>  1 file changed, 51 insertions(+), 40 deletions(-)

Tested-by: Andrew Bowers <andrewx.bowers@intel.com>



