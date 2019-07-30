Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12D697A4CA
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731849AbfG3Jkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 05:40:36 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:16555 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726505AbfG3Jkg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 05:40:36 -0400
X-IronPort-AV: E=Sophos;i="5.64,326,1559491200"; 
   d="scan'208";a="72517729"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 30 Jul 2019 17:40:34 +0800
Received: from G08CNEXCHPEKD03.g08.fujitsu.local (unknown [10.167.33.85])
        by cn.fujitsu.com (Postfix) with ESMTP id C22224CDE65E;
        Tue, 30 Jul 2019 17:40:36 +0800 (CST)
Received: from [10.167.226.33] (10.167.226.33) by
 G08CNEXCHPEKD03.g08.fujitsu.local (10.167.33.89) with Microsoft SMTP Server
 (TLS) id 14.3.439.0; Tue, 30 Jul 2019 17:40:38 +0800
Subject: Re: net: ipv6: Fix a bug in ndisc_send_ns when netdev only has a
 global address
To:     Mark Smith <markzzzsmith@gmail.com>, <netdev@vger.kernel.org>
References: <CAO42Z2yN=FfueKAjb0KjY8-CdiKuvkJDr2iJdJR4XdKM90HJRg@mail.gmail.com>
From:   Su Yanjun <suyj.fnst@cn.fujitsu.com>
Message-ID: <93c401b9-bf8b-4d49-9c3b-72d09073444e@cn.fujitsu.com>
Date:   Tue, 30 Jul 2019 17:39:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <CAO42Z2yN=FfueKAjb0KjY8-CdiKuvkJDr2iJdJR4XdKM90HJRg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.167.226.33]
X-yoursite-MailScanner-ID: C22224CDE65E.AC4C3
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: suyj.fnst@cn.fujitsu.com
X-Spam-Status: No
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2019/7/30 16:15, Mark Smith 写道:
> Hi,
>
> I'm not subscribed to the Linux netdev mailing list, so I can't
> directly reply to the patch email.
>
> This patch is not the correct solution to this issue.
>
> Per RFC 4291 "IP Version 6 Addressing Architecture", all IPv6
> interfaces are required to have Link-Local addresses, so therefore
> there should always be a link-local address available to use as the
> source address for an ND NS.

In linux implementation, one interface may have no link local address if 
kernel config

*addr_gen_mode* is set to IN6_ADDR_GEN_MODE_NONE. My patch is to fix 
this problem.

And what you say is related to the lo interface.  I'm not sure whether 
the lo interface needs a ll adreess.

IMO the ll address is used to get l2 address by sending ND ns. The lo is 
very special.

Thanks

Su

>
> "2.1. Addressing Model"
>
> ...
>
> "All interfaces are required to have at least one Link-Local unicast
>     address (see Section 2.8 for additional required addresses)."
>
> I have submitted a more specific bug regarding no Link-Local
> address/prefix on the Linux kernel loopback interface through RedHat
> bugzilla as I use Fedora 30, however it doesn't seem to have been
> looked at yet.
>
> "Loopback network interface does not have a Link Local address,
> contrary to RFC 4291"
> https://bugzilla.redhat.com/show_bug.cgi?id=1706709
>
>
> Thanks very much,
> Mark.
>
>


