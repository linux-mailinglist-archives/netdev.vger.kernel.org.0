Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4571CD3FE
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 10:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728705AbgEKIcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 04:32:43 -0400
Received: from mail-eopbgr30085.outbound.protection.outlook.com ([40.107.3.85]:15489
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728104AbgEKIcn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 04:32:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YbdxLDhJKa6pgTCBUzYnZFx+H22ad8q4CpkSvxvT5GKHsxl2//UJPTQtl6+IOI1rMwcZkYz/qvxi5QIsNf0cwvFG/eeQXO0OqTqE8T7zi3ULvcGrCk69+jJH8t7PviRGVP+iCzNDx61/ZZ/xBTeDnRoI6Vo3Sa+DhSP1Gm6X6GzfaVYYEDwUA3HKeeMPu69LDz78URzd3IQI5K8ug8QSf4IpqNUkphP3KE8/7IOqUgQBKoFe1de6D5omHaE6JGzuCqwAEnQxLvZkVS9wUO0V39bBAeWc5KvbhYieZnpHWW9N9oTJVCstJoMmSMUK7PZTylqMPQi0/8wwrcEzkd5z5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUfAqUK230AQDJIMdjSMEGXpLR/HiG7WfMKRbJXeeoo=;
 b=Hesme4hxFBUE5utQsoGZCi9idNI+QiivOZcDTfTrdtZra4nbuKuQpXQoahb2ECSfMWTwVvBFGk1LpQ6FHuOxHt0Qa3Hajn1pMzBWea3gh26Yx9kjNbCBeqKjuZg8uzb4YUpBnv7Wb+XHZ2HdDYc9d9PHn/F8vMRh+uj8INv4V/qNjNKB9oxvfYIamo1Vx/k6qpbdLXnVEjTZU/H9Eb9T2XmJ2NRDvvaqtV2ug24RpMEocpLSToSssCRQX4jZLH/ZBPXFXRZQ0GkTEHFC/IMBCEDmp8kFI5+Kpaa6QfFOx+yBT1kJuPeAjeLx1T4h+dwIhR/TU+rIt8elbctboK4Cxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZUfAqUK230AQDJIMdjSMEGXpLR/HiG7WfMKRbJXeeoo=;
 b=F0ptgFXzz9Y+sgVF5HfriNDSKYHhoGt2s0onr/kphsnkGlTS1O/1eW28sQwvQY8mRIAKtOoUBu93jrE66ngpLNEvo6RcUj7ONBEXKiiAOH/USSnhJbJLbw18PiIL9BgXXiN5MVinfy7lqK2cDnWKP1Hsxr092SYOnSijxrpfjKM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (2603:10a6:20b:11::14)
 by AM6PR05MB5768.eurprd05.prod.outlook.com (2603:10a6:20b:97::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Mon, 11 May
 2020 08:32:39 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::f5bd:86c3:6c50:6718]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::f5bd:86c3:6c50:6718%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 08:32:39 +0000
Subject: Re: [PATCH net] netfilter: flowtable: Add pending bit for offload
 work
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
References: <1588764279-12166-1-git-send-email-paulb@mellanox.com>
 <20200510221434.GA11226@salvia>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <9dff92fe-15cd-348d-ff1c-7a102ea9263c@mellanox.com>
Date:   Mon, 11 May 2020 11:32:36 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
In-Reply-To: <20200510221434.GA11226@salvia>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: FRYP281CA0014.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::24)
 To AM6PR05MB5096.eurprd05.prod.outlook.com (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.62] (5.29.240.93) by FRYP281CA0014.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.31 via Frontend Transport; Mon, 11 May 2020 08:32:38 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c5a4b455-aace-4e87-0748-08d7f585dd93
X-MS-TrafficTypeDiagnostic: AM6PR05MB5768:|AM6PR05MB5768:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB57682FAC3B2979F23FA5A0C2CFA10@AM6PR05MB5768.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3IEaDzTKHdzmvAFDJh1bc3uAG850VkAPETlXLxVfhif9sTyxX7Upp82u/bmUnFwN1LhaERhk0p++naugLjizVNGIvIttYQ/GEqeN5O1Y2tqwmkn84kXE6kSC168ZvG3/Kb+Taa1kQMF+nbSEbwdoLltAaqWBJFGiwEbpyYkvfrWsvTbg9cC/vWNGQmdj3u29ozZ5XuVrxzj8FT/T7RrpvxWIHNlzakuRoYFdcu4h8j12VwmP+iIANkGKS32IXBhR2cU9lGUtIQN06UoEilXAzRvZsr2nUzmcchvqvAAPB0BSQ4yvajzQNoGqBSyCSva3/zpcqokVGnsZ0CD3w0AlV+qimMlbafVGX8BhJyOcbMVrGLUed9jVfzQ0jhlydC2kqEgsAd4dbrIrGUV1xpDVxhSqqWAE2OB2Ovc0DrYw859So4MwPjitNW+/uXjT+8DXZgRP8wd4OWakER+9+E0jV2QSp1ctIRdo0/jzF6CVejpoeaLhXGdi69QW/Q8AmcA9ul6BNKd0/FQFo/JiukLZ4taIG/GHLI/b1+oWmBvXqRqGhfAHmsQ1ATBtZcx/FhQR
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5096.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(366004)(376002)(396003)(136003)(346002)(33430700001)(26005)(53546011)(2616005)(956004)(4326008)(31696002)(16576012)(6916009)(54906003)(316002)(478600001)(66556008)(31686004)(66476007)(8676002)(186003)(33440700001)(52116002)(66946007)(86362001)(36756003)(6486002)(2906002)(5660300002)(16526019)(8936002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: QTIh/GD48k5G0SnzDrVlMCeLqtL9uSHyUDKlmYXIEBpBnhph/nbzu8UVOeRy9jjmWotcJN3zogeBzMi2grSJbTzQZAsRUSbuZqWkVudo3UtniRqvcnJb4qYakKrk9nZFuA/cFNwhm+5OK9N4VPZfv2D5ugTgUBeVxfC1Y/6U+AhT3VsVo/I3+kx50Jlg546m2hjyN0pLztSNSGSk3e+UepWqd1bXs0iJlZ9aoPgtA5vGNad4FJVu8/5jK6WsvzWRVzlovpvigWjDsRLt6CZ0Pg/0XOlH8zKbqHnogyFerFDgGnPuKFeQWEufSL3M8ud5Usx4VB2rzMAgmCV8FnhaobB2g/fQGT3NYBxWSqVqd/K79d2Dm7svaRaLqJqwv5ghIHb7JwctDWHRCZT80hFo4RAiryHmWyf21Xk2s0RFdId8n/ZonZQvDG8lVtX/Vjnh1meG1sHKrUTNfdZWrmPN7VYs1J7n7QufQnwCvrrbLws=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a4b455-aace-4e87-0748-08d7f585dd93
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 08:32:39.4809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fyb2WjBQrreAhj5otRYuxMZ+m2ARrvgJ6Sh7X4zD+OqxwWuzHyrN3E6DWGSH60ANqVC5/a6gv44X3bxm8VMJkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5768
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 1:14 AM, Pablo Neira Ayuso wrote:
> Hi,
>
> On Wed, May 06, 2020 at 02:24:39PM +0300, Paul Blakey wrote:
>> Gc step can queue offloaded flow del work or stats work.
>> Those work items can race each other and a flow could be freed
>> before the stats work is executed and querying it.
>> To avoid that, add a pending bit that if a work exists for a flow
>> don't queue another work for it.
>> This will also avoid adding multiple stats works in case stats work
>> didn't complete but gc step started again.
> This is happening since the mutex has been removed, right?
>
> Another question below.
it's from the using a new workqueue and one work per item, allowing parallelization
between a flow work items.


>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> Reviewed-by: Roi Dayan <roid@mellanox.com>
>> ---
>>  include/net/netfilter/nf_flow_table.h | 1 +
>>  net/netfilter/nf_flow_table_offload.c | 8 +++++++-
>>  2 files changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
>> index 6bf6965..c54a7f7 100644
>> --- a/include/net/netfilter/nf_flow_table.h
>> +++ b/include/net/netfilter/nf_flow_table.h
>> @@ -127,6 +127,7 @@ enum nf_flow_flags {
>>  	NF_FLOW_HW_DYING,
>>  	NF_FLOW_HW_DEAD,
>>  	NF_FLOW_HW_REFRESH,
>> +	NF_FLOW_HW_PENDING,
>>  };
>>  
>>  enum flow_offload_type {
>> diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
>> index b9d5ecc..731d738 100644
>> --- a/net/netfilter/nf_flow_table_offload.c
>> +++ b/net/netfilter/nf_flow_table_offload.c
>> @@ -817,6 +817,7 @@ static void flow_offload_work_handler(struct work_struct *work)
>>  			WARN_ON_ONCE(1);
>>  	}
>>  
>> +	clear_bit(NF_FLOW_HW_PENDING, &offload->flow->flags);
>>  	kfree(offload);
>>  }
>>  
>> @@ -831,9 +832,14 @@ static void flow_offload_queue_work(struct flow_offload_work *offload)
>>  {
>>  	struct flow_offload_work *offload;
>>  
>> +	if (test_and_set_bit(NF_FLOW_HW_PENDING, &flow->flags))
>> +		return NULL;
> In case of stats, it's fine to lose work.
>
> But how does this work for the deletion case? Does this falls back to
> the timeout deletion?

We get to nf_flow_table_offload_del (delete) in these cases:

>-------if (nf_flow_has_expired(flow) || nf_ct_is_dying(flow->ct) ||
>-------    test_bit(NF_FLOW_TEARDOWN, &flow->flags) {
>------->-------   ....
>------->-------    nf_flow_offload_del(flow_table, flow);

Which are all persistent once set but the nf_flow_has_expired(flow). So we will
try the delete
again and again till pending flag is unset or the flow is 'saved' by the already
queued stats updating the timeout.
A pending stats update can't save the flow once it's marked for teardown or
(flow->ct is dying), only delay it.

We didn't mention flush, like in table free. I guess we need to flush the
hardware workqueue
of any pending stats work, then queue the deletion, and flush again:

Adding nf_flow_table_offload_flush(flow_table), after
cancel_delayed_work_sync(&flow_table->gc_work);



>
> Thanks.

