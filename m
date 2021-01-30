Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01549309876
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 22:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbhA3VYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 16:24:24 -0500
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:2160 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230517AbhA3VYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 16:24:23 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6015ce5e0002>; Sat, 30 Jan 2021 13:23:42 -0800
Received: from [10.2.62.101] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 30 Jan
 2021 21:23:30 +0000
Subject: Re: [PATCH v2 net-next 3/4] net: introduce common
 dev_page_is_reserved()
To:     Alexander Lobakin <alobakin@pm.me>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        David Rientjes <rientjes@google.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <intel-wired-lan@lists.osuosl.org>,
        <linux-rdma@vger.kernel.org>, <linux-mm@kvack.org>
References: <20210127201031.98544-1-alobakin@pm.me>
 <20210127201031.98544-4-alobakin@pm.me>
 <20210129183907.2ae5ca3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130154149.8107-1-alobakin@pm.me>
 <20210130110707.3122a360@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210130194459.37837-1-alobakin@pm.me>
From:   John Hubbard <jhubbard@nvidia.com>
Message-ID: <752a57a6-3f45-8b9b-e8b1-939bc9450947@nvidia.com>
Date:   Sat, 30 Jan 2021 13:23:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <20210130194459.37837-1-alobakin@pm.me>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612041822; bh=XdEBWDGTZuiWQxyc+j9VORWv1cft7WIfWK/EqPUa+p4=;
        h=Subject:To:CC:References:From:Message-ID:Date:User-Agent:
         MIME-Version:In-Reply-To:Content-Type:Content-Language:
         Content-Transfer-Encoding:X-Originating-IP:X-ClientProxiedBy;
        b=CgBuB8hJYU+MIBPQME3YhhtMFWXo3UeYILMxnQGrIaEN3YYevfyNPOUu/2Ox8YS1E
         ghXmFo3e/yaJuPpXKJXPz+UU5J8mMJpKradqvcIim2gTRnC40Psz8zdWwgxsjsNqLY
         zagJMVx3lia+GGBPt+o5cF5+iuquSwS72PmYYkY+b0n1WmELYe90cn1qMFDrFW8XH8
         TSUtIL3EY9vQtb/yfp/1KhVceVxez4JYu8mq/s+XtXkbcA5DMqU34O7/cjmj2AdGge
         vfGCrA6OmrQksCFUrXOAb9FpY3Pok/3MTu6v9rBgvK4GuxVmA4oIgaS4QVYPO4Vf9A
         VM7OcNZQarHeQ==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/30/21 11:45 AM, Alexander Lobakin wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> Date: Sat, 30 Jan 2021 11:07:07 -0800
> 
>> On Sat, 30 Jan 2021 15:42:29 +0000 Alexander Lobakin wrote:
>>>> On Wed, 27 Jan 2021 20:11:23 +0000 Alexander Lobakin wrote:
>>>>> + * dev_page_is_reserved - check whether a page can be reused for network Rx
>>>>> + * @page: the page to test
>>>>> + *
>>>>> + * A page shouldn't be considered for reusing/recycling if it was allocated
>>>>> + * under memory pressure or at a distant memory node.
>>>>> + *
>>>>> + * Returns true if this page should be returned to page allocator, false
>>>>> + * otherwise.
>>>>> + */
>>>>> +static inline bool dev_page_is_reserved(const struct page *page)
>>>>
>>>> Am I the only one who feels like "reusable" is a better term than
>>>> "reserved".
>>>
>>> I thought about it, but this will need to inverse the conditions in
>>> most of the drivers. I decided to keep it as it is.
>>> I can redo if "reusable" is preferred.
>>
>> Naming is hard. As long as the condition is not a double negative it
>> reads fine to me, but that's probably personal preference.
>> The thing that doesn't sit well is the fact that there is nothing
>> "reserved" about a page from another NUMA node.. But again, if nobody
>> +1s this it's whatever...
> 
> Agree on NUMA and naming. I'm a bit surprised that 95% of drivers
> have this helper called "reserved" (one of the reasons why I finished
> with this variant).
> Let's say, if anybody else will vote for "reusable", I'll pick it for
> v3.

Definitely "reusable" seems better to me, and especially anything *other*
than "reserved" is a good idea, IMHO.


thanks,
-- 
John Hubbard
NVIDIA
