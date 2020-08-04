Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F39823B284
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 03:58:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgHDB57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 21:57:59 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:50100 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725840AbgHDB57 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Aug 2020 21:57:59 -0400
Received: from dggeme758-chm.china.huawei.com (unknown [172.30.72.55])
        by Forcepoint Email with ESMTP id 6E24E292DF19CD1F3122;
        Tue,  4 Aug 2020 09:57:57 +0800 (CST)
Received: from [10.174.61.242] (10.174.61.242) by
 dggeme758-chm.china.huawei.com (10.3.19.104) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Tue, 4 Aug 2020 09:57:56 +0800
Subject: Re: [PATCH net-next v3 1/2] hinic: add generating mailbox random
 index support
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <luoxianjun@huawei.com>,
        <yin.yinshi@huawei.com>, <cloud.wangxiaoyun@huawei.com>,
        <chiqijun@huawei.com>
References: <20200801024935.20819-1-luobin9@huawei.com>
 <20200801024935.20819-2-luobin9@huawei.com>
 <20200803150544.57dbe802@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   "luobin (L)" <luobin9@huawei.com>
Message-ID: <5f8a2fd5-292b-db53-3cbd-def7c1f22725@huawei.com>
Date:   Tue, 4 Aug 2020 09:57:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20200803150544.57dbe802@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.61.242]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggeme758-chm.china.huawei.com (10.3.19.104)
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020/8/4 6:05, Jakub Kicinski wrote:
> On Sat, 1 Aug 2020 10:49:34 +0800 Luo bin wrote:
>> add support to generate mailbox random id of VF to ensure that
>> mailbox messages PF received are from the correct VF.
>>
>> Signed-off-by: Luo bin <luobin9@huawei.com>
>> ---
>> V2~V3 fix review opinions pointed out by Jakub
> 
> In the future please specify what was changed, e.g.:
> 
>  - use get_random_u32()
>  - remove unnecessary parenthesis
> 
> etc.
> 
Okay, I'll pay attention to that next time.
>> +int hinic_vf_mbox_random_id_init(struct hinic_hwdev *hwdev)
>> +{
>> +	u8 vf_in_pf;
>> +	int err = 0;
>> +
>> +	if (HINIC_IS_VF(hwdev->hwif))
>> +		return 0;
>> +
>> +	for (vf_in_pf = 1; vf_in_pf <= hwdev->nic_cap.max_vf; vf_in_pf++) {
>> +		err = set_vf_mbox_random_id(hwdev, hinic_glb_pf_vf_offset
>> +					    (hwdev->hwif) + vf_in_pf);
> 
> I'm sorry but you must put the call to hinic_glb_pf_vf_offset() on a
> separate line. Perhaps take this call out of the for loop entirely?
> 
> The way it's written with the parenthesis on the next line is hard to
> read.
Will fix. Thanks. Taking it out of the loop is a better way to avoid a long line length.
> 
>> +		if (err)
>> +			break;
>> +	}
> .
> 
