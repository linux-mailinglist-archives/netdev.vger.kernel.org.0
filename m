Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58AAA2D194D
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 20:20:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726042AbgLGTTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 14:19:41 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:26366 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbgLGTTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 14:19:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607368780; x=1638904780;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=tNvmdHbVNWsQ/wF0F4elj8BssfT6cUY9gtpilxrNRuE=;
  b=RmKyeikzoiETT5Jrw3dBB12pjXLKywLMltBrTPffk7IuGbyFJ76aaKQD
   aeHxcoouBvm80vX/RyjdbnhjXv3qKiC3u7VvJ0EKgzI/3dOkMSGNHtGox
   OzJOJoEhtrat+q2G2dcIZQlHWr9lft2N/eTHJO9YqelJxtQvsCgi3xqGj
   Y=;
X-IronPort-AV: E=Sophos;i="5.78,400,1599523200"; 
   d="scan'208";a="71078671"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 07 Dec 2020 19:18:44 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id A60FCA0733;
        Mon,  7 Dec 2020 19:18:43 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.162.146) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 19:18:35 +0000
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
 <1607083875-32134-8-git-send-email-akiyano@amazon.com>
 <20201205161559.3c817842@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <akiyano@amazon.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <dwmw@amazon.com>, <zorik@amazon.com>,
        <matua@amazon.com>, <saeedb@amazon.com>, <msw@amazon.com>,
        <aliguori@amazon.com>, <nafea@amazon.com>, <gtzalik@amazon.com>,
        <netanel@amazon.com>, <alisaidi@amazon.com>, <benh@amazon.com>,
        <ndagan@amazon.com>, <sameehj@amazon.com>
Subject: Re: [PATCH V4 net-next 7/9] net: ena: introduce XDP redirect
 implementation
In-Reply-To: <20201205161559.3c817842@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Date:   Mon, 7 Dec 2020 21:18:15 +0200
Message-ID: <pj41zl360hzaq0.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.162.146]
X-ClientProxiedBy: EX13D33UWB004.ant.amazon.com (10.43.161.225) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jakub Kicinski <kuba@kernel.org> writes:

> On Fri, 4 Dec 2020 14:11:13 +0200 akiyano@amazon.com wrote:
>> +	case XDP_REDIRECT:
>> +		xdp_do_redirect(rx_ring->netdev, xdp, xdp_prog);
>> +		xdp_stat = &rx_ring->rx_stats.xdp_redirect;
>> +		break;
>
> Don't you have to check if xdp_do_redirect() returned an error 
> or not?
>
> You should CC XDP maintainers on the XDP patches.

Thanks for reviewing the code (:
I'll add a return value check next patchset and CC XDP 
maintainers.
