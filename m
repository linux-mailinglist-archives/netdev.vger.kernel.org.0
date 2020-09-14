Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50219268AE2
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 14:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgINM1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 08:27:30 -0400
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:63877 "EHLO
        smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgINMZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 08:25:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1600086338; x=1631622338;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=Bfmy9qWsipgjIuooGwPm4z+AG58W29oJz2Ncbc3OLWQ=;
  b=jcsySGLHK/aFXMFgWAsA08WBNyUbIRfVhda8+7m3F0zgEwZdj2nomP79
   QGvR5knq8YyGI4Rzyr0NeEHsjubI93Qzf+iqTuDyyQ7q0U0m2On0nhQN8
   AreKI7XYuUBIy1irakhDrm8HF8jqxyWO5G7slqQ0tXGlAhd9C/1FeBPY/
   U=;
X-IronPort-AV: E=Sophos;i="5.76,426,1592870400"; 
   d="scan'208";a="75969921"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-69849ee2.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9102.sea19.amazon.com with ESMTP; 14 Sep 2020 12:23:26 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-69849ee2.us-west-2.amazon.com (Postfix) with ESMTPS id 91BF2A18BA;
        Mon, 14 Sep 2020 12:23:25 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.160.229) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 14 Sep 2020 12:23:16 +0000
References: <20200913081640.19560-1-shayagr@amazon.com> <20200913081640.19560-3-shayagr@amazon.com> <20200913.143022.1949357995189636518.davem@davemloft.net>
User-agent: mu4e 1.4.12; emacs 26.3
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <dwmw@amazon.com>, <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <akiyano@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>,
        <amitbern@amazon.com>
Subject: Re: [PATCH V1 net-next 2/8] net: ena: Add device distinct log prefix to files
In-Reply-To: <20200913.143022.1949357995189636518.davem@davemloft.net>
Date:   Mon, 14 Sep 2020 15:23:04 +0300
Message-ID: <pj41zlmu1seedz.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.229]
X-ClientProxiedBy: EX13D18UWA004.ant.amazon.com (10.43.160.45) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Miller <davem@davemloft.net> writes:

> From: Shay Agroskin <shayagr@amazon.com>
> Date: Sun, 13 Sep 2020 11:16:34 +0300
>
>> ENA logs are adjusted to display the full ENA representation to
>> distinct each ENA device in case of multiple interfaces.
>> Using dev_err/warn/info function family for logging provides 
>> uniform
>> printing with clear distinction of the driver and device.
>> 
>> This patch changes all printing in ena_com files to use dev_* 
>> logging
>> messages. It also adds some log messages to make driver 
>> debugging
>> easier.
>> 
>> Signed-off-by: Amit Bernstein <amitbern@amazon.com>
>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>
> This device prefix is so much less useful than printing the 
> actual
> networking adapter that the ena_com operations are for.
>
> So if you are going to do this, go all the way and pass the 
> ena_adapter
> or the netdev down into these ena_com routines so that you can 
> use
> the netdev_*() message helpers.
>
> Thank you.

Thanks you for reviewing it. Some of the ena_com functions are 
called
with dev* routines because the netdev struct isn't created when 
they
are executed.

We'll go over the other ena com routines (which are called when an
interface exists) and change them to netdev_* routines 
instead. I'll send a new version of the patchset once done.
