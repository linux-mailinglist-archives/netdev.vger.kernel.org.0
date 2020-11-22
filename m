Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641242BC45C
	for <lists+netdev@lfdr.de>; Sun, 22 Nov 2020 08:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbgKVHTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Nov 2020 02:19:52 -0500
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:59964 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgKVHTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Nov 2020 02:19:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1606029592; x=1637565592;
  h=references:from:to:cc:subject:in-reply-to:message-id:
   date:mime-version;
  bh=WjTlBhskBZG4JfwjJO+/8ucnw9N3Aom4XCDuYsL5LEo=;
  b=jTDq1Ws1PjHelXnEYZua40vyZsFQxfUj13Inxg9QbFRDjSpc1u/U/3tx
   M8C8M1N9ZBnbMa38Y78Wkir/IhJhESX460HBE0Xfud6wgpLxGv50cBxxi
   eS5wpy8/225xxeEn7DNmTyM17p8+BPQNpVWqd1dElUHtWBEUSf19NtQ+P
   E=;
X-IronPort-AV: E=Sophos;i="5.78,360,1599523200"; 
   d="scan'208";a="89628420"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 22 Nov 2020 07:19:46 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id 15EEFC05FC;
        Sun, 22 Nov 2020 07:19:45 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.162.231) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 22 Nov 2020 07:19:37 +0000
References: <20201119202851.28077-1-shayagr@amazon.com>
 <20201119202851.28077-5-shayagr@amazon.com>
 <20201121155304.1751d0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <dwmw@amazon.com>, <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <akiyano@amazon.com>, <sameehj@amazon.com>, <ndagan@amazon.com>
Subject: Re: [PATCH V2 net 4/4] net: ena: return error code from
 ena_xdp_xmit_buff
In-Reply-To: <20201121155304.1751d0c6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Message-ID: <pj41zl7dqddfkm.fsf@u68c7b5b1d2d758.ant.amazon.com>
Date:   Sun, 22 Nov 2020 09:19:05 +0200
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.231]
X-ClientProxiedBy: EX13D10UWA002.ant.amazon.com (10.43.160.228) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> On Thu, 19 Nov 2020 22:28:51 +0200 Shay Agroskin wrote:
>> The function mistakenly returns NETDEV_TX_OK regardless of the
>> transmission success. This patch fixes this behavior by 
>> returning the
>> error code from the function.
>> 
>> Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>
> Doesn't seem like a legitimate bug fix, since the only caller of 
> this
> function ignores its return value.

Hi,
I plan to use the return value from this function in future patch 
(next-net series), do you think we better send this fix with
this future patch?

Shay
