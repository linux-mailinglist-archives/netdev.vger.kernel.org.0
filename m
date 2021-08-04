Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55BE53E04DA
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 17:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239407AbhHDPvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 11:51:55 -0400
Received: from ale.deltatee.com ([204.191.154.188]:54802 "EHLO
        ale.deltatee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239214AbhHDPvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 11:51:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:MIME-Version:Date:
        Message-ID:From:References:Cc:To:content-disposition;
        bh=VAs5UjRtgSdqMEi8N1UFafwkPftDPX3haJmemJpQxKo=; b=qzwKi3ShxTPZRbFP0IKYI2MLLq
        4grholbmN7sed3zBtdSyb6zZt4gc7djXMu/fvYd5s/fV3FYvpCRZwCGt9nQihB6lQ5+QGlBuEa4lN
        NCxkXiKrdmAstr7R8LwgXK/hWyU89OUdAt72RtgSzXLNXlnngadle8SNbXpD8ENBC5fOcbcdHogEp
        eoavcbFlsIc35KIFQqVKBENHEpJSRU9yUHJwE1f9+zl5JkpAMFTYM/Zk3wSR92rbZrTX8zIhtLunJ
        vJvuqznBqGc3ZLorPoNbcOxgJOkh7hvZrvf9AmmCRumNyXyMklmdCdZQ7YgQ2gK0rYUaBF34BVjyK
        A5w5eWTA==;
Received: from s0106a84e3fe8c3f3.cg.shawcable.net ([24.64.144.200] helo=[192.168.0.10])
        by ale.deltatee.com with esmtpsa (TLS1.3:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.92)
        (envelope-from <logang@deltatee.com>)
        id 1mBJB8-0003B9-M2; Wed, 04 Aug 2021 09:51:35 -0600
To:     Dongdong Liu <liudongdong3@huawei.com>, helgaas@kernel.org,
        hch@infradead.org, kw@linux.com, leon@kernel.org,
        linux-pci@vger.kernel.org, rajur@chelsio.com,
        hverkuil-cisco@xs4all.nl
Cc:     linux-media@vger.kernel.org, netdev@vger.kernel.org
References: <1628084828-119542-1-git-send-email-liudongdong3@huawei.com>
 <1628084828-119542-8-git-send-email-liudongdong3@huawei.com>
From:   Logan Gunthorpe <logang@deltatee.com>
Message-ID: <75243571-3213-6ae2-040f-ae1b1f799e42@deltatee.com>
Date:   Wed, 4 Aug 2021 09:51:29 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628084828-119542-8-git-send-email-liudongdong3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 24.64.144.200
X-SA-Exim-Rcpt-To: netdev@vger.kernel.org, linux-media@vger.kernel.org, hverkuil-cisco@xs4all.nl, rajur@chelsio.com, linux-pci@vger.kernel.org, leon@kernel.org, kw@linux.com, hch@infradead.org, helgaas@kernel.org, liudongdong3@huawei.com
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on ale.deltatee.com
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        MYRULES_OFFER,NICE_REPLY_A autolearn=ham autolearn_force=no
        version=3.4.2
Subject: Re: [PATCH V7 7/9] PCI/sysfs: Add a 10-Bit Tag sysfs file
X-SA-Exim-Version: 4.2.1 (built Wed, 08 May 2019 21:11:16 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org




On 2021-08-04 7:47 a.m., Dongdong Liu wrote:
> PCIe spec 5.0 r1.0 section 2.2.6.2 says that if an Endpoint supports
> sending Requests to other Endpoints (as opposed to host memory), the
> Endpoint must not send 10-Bit Tag Requests to another given Endpoint
> unless an implementation-specific mechanism determines that the Endpoint
> supports 10-Bit Tag Completer capability. Add a 10bit_tag sysfs file,
> write 0 to disable 10-Bit Tag Requester when the driver does not bind
> the device if the peer device does not support the 10-Bit Tag Completer.
> This will make P2P traffic safe. the 10bit_tag file content indicate
> current 10-Bit Tag Requester Enable status.

Can we not have both the sysfs file and the command line parameter? If
the user wants to disable it always for a specific device this sysfs
parameter is fairly awkward. A script at boot to unbind the driver, set
the sysfs file and rebind the driver is not trivial and the command line
parameter offers additional options for users.

Logan
