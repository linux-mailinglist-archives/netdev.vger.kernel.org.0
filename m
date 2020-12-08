Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CF122D31D5
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:13:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730950AbgLHSNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:13:06 -0500
Received: from smtp-fw-33001.amazon.com ([207.171.190.10]:57770 "EHLO
        smtp-fw-33001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730495AbgLHSNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 13:13:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607451186; x=1638987186;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=lf6tIG+2aIHtjchUyB+fNa66qONUrJLPze/Gy++itO8=;
  b=N1H1xsVQfQu4juYN5zhdpxE8oBIKUQOuprE5XwtcnvrL6ZbEMvwD2uVB
   HaN7kyGS63qm2aWeH7Lp9aQYiLTboEx1aDihgpfF5gZ6R+dnj65z6aGf1
   Lq+gbViUTkCDLZb870+VWv8Hi+oNkRAepDXutT9ZpKZya4JtnUE7KSG0B
   U=;
X-IronPort-AV: E=Sophos;i="5.78,403,1599523200"; 
   d="scan'208";a="101395414"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2a-119b4f96.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-33001.sea14.amazon.com with ESMTP; 08 Dec 2020 18:12:26 +0000
Received: from EX13D28EUC001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2a-119b4f96.us-west-2.amazon.com (Postfix) with ESMTPS id C40AB1A0462;
        Tue,  8 Dec 2020 18:12:24 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.160.21) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Tue, 8 Dec 2020 18:12:13 +0000
References: <1607083875-32134-1-git-send-email-akiyano@amazon.com>
 <1607083875-32134-4-git-send-email-akiyano@amazon.com>
 <CAKgT0Ueaa-63KGuvhDMT+emk4UoXPUW4SFB8GbxhNj4N5SDwYg@mail.gmail.com>
User-agent: mu4e 1.4.12; emacs 27.1
From:   Shay Agroskin <shayagr@amazon.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
CC:     <akiyano@amazon.com>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <ndagan@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>, Ido Segev <idose@amazon.com>,
        Igor Chauskin <igorch@amazon.com>
Subject: Re: [PATCH V4 net-next 3/9] net: ena: add explicit casting to
 variables
In-Reply-To: <CAKgT0Ueaa-63KGuvhDMT+emk4UoXPUW4SFB8GbxhNj4N5SDwYg@mail.gmail.com>
Date:   Tue, 8 Dec 2020 20:11:42 +0200
Message-ID: <pj41zlsg8gxj4x.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.21]
X-ClientProxiedBy: EX13D20UWC002.ant.amazon.com (10.43.162.163) To
 EX13D28EUC001.ant.amazon.com (10.43.164.4)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Alexander Duyck <alexander.duyck@gmail.com> writes:

> On Fri, Dec 4, 2020 at 4:15 AM <akiyano@amazon.com> wrote:
>>
>> From: Arthur Kiyanovski <akiyano@amazon.com>
>>
>> This patch adds explicit casting to some implicit conversions 
>> in the ena
>> driver. The implicit conversions fail some of our static 
>> checkers that
>> search for accidental conversions in our driver.
>> Adding this cast won't affect the end results, and would sooth 
>> the
>> checkers.
>>
>> Signed-off-by: Ido Segev <idose@amazon.com>
>> Signed-off-by: Igor Chauskin <igorch@amazon.com>
>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>> Signed-off-by: Arthur Kiyanovski <akiyano@amazon.com>
>> ---
>> ...
>> @@ -2712,7 +2712,7 @@ int ena_com_indirect_table_get(struct 
>> ena_com_dev *ena_dev, u32 *ind_tbl)
>>         u32 tbl_size;
>>         int i, rc;
>>
>> -       tbl_size = (1ULL << rss->tbl_log_size) *
>> +       tbl_size = (u32)(1ULL << rss->tbl_log_size) *
>>                 sizeof(struct ena_admin_rss_ind_table_entry);
>>
>>         rc = ena_com_get_feature_ex(ena_dev, &get_resp,
>
> For these last two why not make it 1u instead of 1ull for the 
> bit
> being shifted? At least that way you are not implying possible
> truncation in the conversion.

We decided to remove this conversion from the patch altogether. We 
might do something different in the future to achieve the same 
result. Thanks for your comment
