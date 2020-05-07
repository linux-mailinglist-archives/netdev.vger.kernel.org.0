Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1ED71C9985
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 20:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728097AbgEGSoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 14:44:24 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5956 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgEGSoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 14:44:24 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eb456c00000>; Thu, 07 May 2020 11:43:12 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Thu, 07 May 2020 11:44:23 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Thu, 07 May 2020 11:44:23 -0700
Received: from [10.2.55.176] (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 7 May
 2020 18:44:23 +0000
Subject: Re: [RFC] mm/gup.c: Updated return value of
 {get|pin}_user_pages_fast()
To:     Souptick Joarder <jrdr.linux@gmail.com>, Jan Kara <jack@suse.cz>
CC:     Tony Luck <tony.luck@intel.com>, <fenghua.yu@intel.com>,
        Rob Springer <rspringer@google.com>,
        Todd Poynor <toddpoynor@google.com>, <benchan@chromium.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <santosh.shilimkar@oracle.com>,
        "David S. Miller" <davem@davemloft.net>, <kuba@kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        <inux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        <tee-dev@lists.linaro.org>, Linux-MM <linux-mm@kvack.org>,
        <netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
        <rds-devel@oss.oracle.com>
References: <1588706059-4208-1-git-send-email-jrdr.linux@gmail.com>
 <0bfe4a8a-0d91-ef9b-066f-2ea7c68571b3@nvidia.com>
 <CAFqt6zZMsQkOdjAb2k1EjwX=DtZ8gKfbRzwvreHOX-0vJLngNg@mail.gmail.com>
 <20200506100649.GI17863@quack2.suse.cz>
 <CAFqt6zYaNkJ4AfVzutXS=JsN4fE41ZAvnw03vHWpdyiRHY1m_w@mail.gmail.com>
 <20200506125930.GJ17863@quack2.suse.cz>
 <CAFqt6zZztn_AiaGAhV+_uwrnVdKY-xLsxOwYBt-zGmLaat+OhQ@mail.gmail.com>
 <20200507101322.GB30922@quack2.suse.cz>
 <CAFqt6zZ2pj_6q=5kf9dxOsSkHc7vJEHgCjuRmSELQF9KnoKCxA@mail.gmail.com>
From:   John Hubbard <jhubbard@nvidia.com>
X-Nvconfidentiality: public
Message-ID: <03bbc0f3-8edc-6110-6391-e540f773954c@nvidia.com>
Date:   Thu, 7 May 2020 11:44:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <CAFqt6zZ2pj_6q=5kf9dxOsSkHc7vJEHgCjuRmSELQF9KnoKCxA@mail.gmail.com>
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1588876992; bh=s0GB/xjC+YXiEqpbpZ38ACIIfPDrfZoEl489zOuwW70=;
        h=X-PGP-Universal:Subject:To:CC:References:From:X-Nvconfidentiality:
         Message-ID:Date:User-Agent:MIME-Version:In-Reply-To:
         X-Originating-IP:X-ClientProxiedBy:Content-Type:Content-Language:
         Content-Transfer-Encoding;
        b=FkNbon+/lZBBjz9hvkzpf8XLqnxFhTzELzTdyEKvRurk0aqMSHwD85ZQ4E7KrBaQR
         yvRSZEof1rMLcBARCOie6dDXHCRtJ6bX5o0M/30EtLT8wkidpsRgm1sAq5o8X1AYEf
         ig/myAgWJBZambQrAm4QfpVWNRzk5lA/cuF17BMOs/H00NIHnt/EiCv2Mi0MJgUaW8
         h/Tgfv4rUsuFQMKZC8/Z5izGkLhmkLb136CD93D+e6sy5bQZdnUnwN6nDSEOWnLbny
         Lxw9pZdGOYtcDe5ymjtNUpKpBQUA87UMJMZ88DSlXVfnnIQYcIsGYSNMo4qeVJRrUS
         szSLg14PEX/NQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-05-07 03:32, Souptick Joarder wrote:
...
>> OK, so no real problem with any of these callers. I still don't see a
>> justification for the churn you suggest... Auditting all those code sites
>> is going to be pretty tedious.
> 
> I try to audit all 42 callers of {get|pin}_user_pages_fast() and
> figure out these 5 callers
> which need to be updated and I think, other callers of
> {get|pin}_user_pages_fast() will not be
> effected.
> 
> But I didn't go through other variants of gup/pup except
> {get|pin}_user_pages_fast().


I feel the need to apologize for suggesting that a change to -EINVAL
would help. :)

If you change what the return value means, but only apply it the
gup/pup _fast() variants of this API set, that would make
the API significantly *worse*.

Also, no one has been able to come up with a scenario in which the call
sites actually have a problem handling return values of zero. In fact,
on the contrary: there are call site where returning 0 after being
requested to pin zero pages, helps simplify the code. For example, if
they're just doing math such as "if(nr_expected != nr_pages_pinned) ...".


This looks like a complete dead end, sorry.

thanks,
-- 
John Hubbard
NVIDIA
