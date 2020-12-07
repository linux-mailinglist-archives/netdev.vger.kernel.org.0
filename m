Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A54AE2D1A68
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 21:20:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725979AbgLGUUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 15:20:14 -0500
Received: from smtp-fw-9103.amazon.com ([207.171.188.200]:3499 "EHLO
        smtp-fw-9103.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725774AbgLGUUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 15:20:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607372413; x=1638908413;
  h=references:from:to:cc:subject:in-reply-to:date:
   message-id:mime-version;
  bh=tvGqvodwo33ukNx7OfSaEW3Yo6hWkO8eC61dPb+Cvr8=;
  b=r0zTfndQsBZl5IJwgBtgGOEfemePj0mUMCGUmyTVGsgO6ifYadPXmVa9
   /NZbZyUUbrhMdZ0wE7h601hM+nIlE59IOD+jozWreNDX2EyM/qAvGt5bo
   rXDrcWwFodJsQxFzkLm4HdOJjmJHSVIOCmJQRs2I9obRhaUAQWzTxvIjd
   U=;
X-IronPort-AV: E=Sophos;i="5.78,400,1599523200"; 
   d="scan'208";a="901229499"
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-1a-821c648d.us-east-1.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9103.sea19.amazon.com with ESMTP; 07 Dec 2020 20:19:25 +0000
Received: from EX13D28EUC001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-1a-821c648d.us-east-1.amazon.com (Postfix) with ESMTPS id 0E36BA19AB;
        Mon,  7 Dec 2020 20:19:23 +0000 (UTC)
Received: from u68c7b5b1d2d758.ant.amazon.com.amazon.com (10.43.161.214) by
 EX13D28EUC001.ant.amazon.com (10.43.164.4) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 7 Dec 2020 20:19:15 +0000
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
Date:   Mon, 7 Dec 2020 22:19:02 +0200
Message-ID: <pj41zlv9ddxtc9.fsf@u68c7b5b1d2d758.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.214]
X-ClientProxiedBy: EX13D14UWC004.ant.amazon.com (10.43.162.99) To
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
>>  drivers/net/ethernet/amazon/ena/ena_com.c | 10 +++++-----
>>  1 file changed, 5 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/amazon/ena/ena_com.c 
>> b/drivers/net/ethernet/amazon/ena/ena_com.c
>> index e168edf3c930..7910d8e68a99 100644
>> --- a/drivers/net/ethernet/amazon/ena/ena_com.c
>> +++ b/drivers/net/ethernet/amazon/ena/ena_com.c
>> @@ -1369,7 +1369,7 @@ int ena_com_execute_admin_command(struct 
>> ena_com_admin_queue *admin_queue,
>>                                    "Failed to submit command 
>>                                    [%ld]\n",
>>                                    PTR_ERR(comp_ctx));
>>
>> -               return PTR_ERR(comp_ctx);
>> +               return (int)PTR_ERR(comp_ctx);
>>         }
>>
>>         ret = ena_com_wait_and_process_admin_cq(comp_ctx, 
>>         admin_queue);
>
> I'm not a big fan of resolving it this way as we are going to 
> end up
> with the pattern throughout the kernel if this is really 
> needed. It
> might make more sense to either come up with a new define that 
> returns
> int instead of long, or to tweak the existing PTR_ERR define so 
> that
> it returns an int instead of a long.
>
> An alternative here would be to just pass PTR_ERR into ret and 
> then
> process it that way within this if block. As it stands the 
> comparison
> to ERR_PTR(-ENODEV) doesn't read very well anyway.
>

Hi, thanks for reviewing the code. Looking at it I agree it looks 
rather ugly. I'll try to rework it to something less hideous.

Regarding the idea to make it more generic (kernel wide change), 
our static checkers test the ena_com code on various platforms and 
the 'implicit cast' warning might not repeat for other drivers

>> @@ -1595,7 +1595,7 @@ int ena_com_set_aenq_config(struct 
>> ena_com_dev *ena_dev, u32 groups_flag)
>>  int ena_com_get_dma_width(struct ena_com_dev *ena_dev)
>>  {
>>         u32 caps = ena_com_reg_bar_read32(ena_dev, 
>>         ENA_REGS_CAPS_OFF);
>> -       int width;
>> +       u32 width;
>>
>>         if (unlikely(caps == ENA_MMIO_READ_TIMEOUT)) {
>>                 netdev_err(ena_dev->net_device, "Reg read 
>>                 timeout occurred\n");
>> @@ -2266,7 +2266,7 @@ int ena_com_set_dev_mtu(struct 
>> ena_com_dev *ena_dev, int mtu)
>>         cmd.aq_common_descriptor.opcode = 
>>         ENA_ADMIN_SET_FEATURE;
>>         cmd.aq_common_descriptor.flags = 0;
>>         cmd.feat_common.feature_id = ENA_ADMIN_MTU;
>> -       cmd.u.mtu.mtu = mtu;
>> +       cmd.u.mtu.mtu = (u32)mtu;
>>
>>         ret = ena_com_execute_admin_command(admin_queue,
>>                                             (struct 
>>                                             ena_admin_aq_entry 
>>                                             *)&cmd,
>
> Wouldn't it make more sense to define mtu as a u32 in the first 
> place
> and address this in the function that calls this rather than 
> doing the
> cast at the last minute?
>

It would make the code prettier at the very least. I'll try to 
tweak this a little

>> @@ -2689,7 +2689,7 @@ int ena_com_indirect_table_set(struct 
>> ena_com_dev *ena_dev)
>>                 return ret;
>>         }
>>
>> -       cmd.control_buffer.length = (1ULL << rss->tbl_log_size) 
>> *
>> +       cmd.control_buffer.length = (u32)(1ULL << 
>> rss->tbl_log_size) *
>>                 sizeof(struct ena_admin_rss_ind_table_entry);
>>
>>         ret = ena_com_execute_admin_command(admin_queue,
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

This sounds correct, I'll give it a try. Thanks
