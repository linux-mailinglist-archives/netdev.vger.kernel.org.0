Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDFE14F1BC
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 18:59:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbgAaR7e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 12:59:34 -0500
Received: from mga04.intel.com ([192.55.52.120]:63654 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726712AbgAaR7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jan 2020 12:59:34 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 31 Jan 2020 09:59:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,386,1574150400"; 
   d="scan'208";a="430440825"
Received: from vcostago-desk1.jf.intel.com (HELO vcostago-desk1) ([10.54.70.26])
  by fmsmga006.fm.intel.com with ESMTP; 31 Jan 2020 09:59:33 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, vladimir.oltean@nxp.com,
        po.liu@nxp.com
Subject: Re: [PATCH net v3 1/2] taprio: Fix enabling offload with wrong number of traffic classes
In-Reply-To: <20200131072453.454930eb@cakuba.hsd1.ca.comcast.net>
References: <20200130013721.33812-1-vinicius.gomes@intel.com> <20200130013721.33812-2-vinicius.gomes@intel.com> <20200131072453.454930eb@cakuba.hsd1.ca.comcast.net>
Date:   Fri, 31 Jan 2020 10:00:54 -0800
Message-ID: <87pnezbj55.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Wed, 29 Jan 2020 17:37:20 -0800, Vinicius Costa Gomes wrote:
>> If the driver implementing taprio offloading depends on the value of
>> the network device number of traffic classes (dev->num_tc) for
>> whatever reason, it was going to receive the value zero. The value was
>> only set after the offloading function is called.
>> 
>> So, moving setting the number of traffic classes to before the
>> offloading function is called fixes this issue. This is safe because
>> this only happens when taprio is instantiated (we don't allow this
>> configuration to be changed without first removing taprio).
>> 
>> Fixes: 9c66d1564676 ("taprio: Add support for hardware offloading")
>> Reported-by: Po Liu <po.liu@nxp.com>
>> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
>> Acked-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> What about Dave's question about resetting the tc state with
> netdev_reset_tc()?

I missed that question.
