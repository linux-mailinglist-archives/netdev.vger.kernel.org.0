Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 426531D4081
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 00:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgENWH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 18:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726046AbgENWHz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 18:07:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BBEC061A0C
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 15:07:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3387A13B48C52;
        Thu, 14 May 2020 15:07:53 -0700 (PDT)
Date:   Thu, 14 May 2020 15:07:50 -0700 (PDT)
Message-Id: <20200514.150750.17841471129931986.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     jeffrey.t.kirsher@intel.com, vitaly.lifshits@intel.com,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        lkp@intel.com, dan.carpenter@oracle.com, aaron.f.brown@intel.com
Subject: Re: [net-next v2 3/9] igc: add support to eeprom, registers and
 link self-tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514145219.58484d4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200514213117.4099065-1-jeffrey.t.kirsher@intel.com>
        <20200514213117.4099065-4-jeffrey.t.kirsher@intel.com>
        <20200514145219.58484d4b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 15:07:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 14 May 2020 14:52:19 -0700

> On Thu, 14 May 2020 14:31:11 -0700 Jeff Kirsher wrote:
>> diff --git a/drivers/net/ethernet/intel/igc/igc_diag.c b/drivers/net/ethernet/intel/igc/igc_diag.c
>> new file mode 100644
>> index 000000000000..1c4536105e56
>> --- /dev/null
>> +++ b/drivers/net/ethernet/intel/igc/igc_diag.c
>> @@ -0,0 +1,186 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c)  2020 Intel Corporation */
>> +
>> +#include "igc.h"
>> +#include "igc_diag.h"
>> +
>> +struct igc_reg_test reg_test[] = {
>> +	{ IGC_FCAL,	1,	PATTERN_TEST,	0xFFFFFFFF,	0xFFFFFFFF },
>> +	{ IGC_FCAH,	1,	PATTERN_TEST,	0x0000FFFF,	0xFFFFFFFF },
>> +	{ IGC_FCT,	1,	PATTERN_TEST,	0x0000FFFF,	0xFFFFFFFF },
>> +	{ IGC_RDBAH(0), 4,	PATTERN_TEST,	0xFFFFFFFF,	0xFFFFFFFF },
> 
> drivers/net/ethernet/intel/igc/igc_diag.c:7:21: warning: symbol 'reg_test' was not declared. Should it be static?

Jeff, you might want to start checking this kind of stuff internally
since Jakub is going to catch it within minutes of you posting your
changes :-)))
