Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B538E17F14B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 08:53:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbgCJHxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 03:53:34 -0400
Received: from mail-db8eur05on2076.outbound.protection.outlook.com ([40.107.20.76]:6051
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726202AbgCJHxe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 03:53:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gNq4SrdFwWAPPNjOmJo3f0+48EXRh1nCJnNZ5mXctbq5ZGcgsVuHLw7Bw16bgtHr0/YvIoU7mrqIIrwoO2RTxb8JdZnqTAyBzafDumzZ+STLZxDhosH0P9kCm0IjyCfbrCkhexFBo48DSmrie55fWRR9oHnvvaUYIaV9ETnfSao/Uiv7InsZuoMVyGhCbMo2jHv7ANi7wexQ91mkSUhAaokY2qpR/zN0LHWBWOEevzN9c9psAjzaUhvvPBcgeA/Fw8FzFv9x2rFUbHqYYzj8hwguswOEasCupm2VEsfHOXTPiz2qwl1v+1FEqjPdfrcQSbfdzVH4l9sE2fCVsUFYOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpkVblPI23fDtf+bWVMXpyWzJiJztsR6Qw/y/uUN7ao=;
 b=Cq53/zOZqPW8IcnwiNrRHpRUno4W5ys7IVRk3KPT7avqBoHci911nFpmEwFysXrhmawqRfxkFNrrsmCwBd3GDX+3qUAkypeWDOyr4rne+k/9/oq6EAY7Xv+615bB8wlItPxib0FA/9v5CS0CsvLdpUcSh55TKnQLaWkF4D32rBqi4mjDqkCeYJNDf9zvrbQ8jVF40yDvLuKEb6IR2tdBoLguV/2GvPAvbi9W/QIhBkAxfc3rVCFlaLCe3TiHJYQmZGQfK+OuQuZsm+TFiQ7ENl4myEKaywYiXSXKsM53LtNSC/7J4NAmGDQtx/JAwuBztmqb6FGiO2jSdNy/2ajMKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rpkVblPI23fDtf+bWVMXpyWzJiJztsR6Qw/y/uUN7ao=;
 b=ii1u4PR+BuS96vcjHi7mjnEUAXBv+rO37pIc4hFoo9fqOKTTFQnPyE8LN7yIXX7qPuKbaDTUKbFj2qUYaDD0htNWLV/7Sx3QhbM+SsylZhS3DTThua7+fuSLYzYPvo8n3JG0cXlrR5W73+fjYwQsdPUi7VTjo2CkYDBrQK0UCJQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB4984.eurprd05.prod.outlook.com (20.177.33.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.17; Tue, 10 Mar 2020 07:53:31 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Tue, 10 Mar 2020
 07:53:31 +0000
Subject: Re: [PATCH net-next ct-offload v2 05/13] net/sched: act_ct: Enable
 hardware offload of flow table entires
To:     Edward Cree <ecree@solarflare.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>
References: <1583676662-15180-1-git-send-email-paulb@mellanox.com>
 <1583676662-15180-6-git-send-email-paulb@mellanox.com>
 <62d6cfde-5749-b2d6-ee04-d0a49b566d1a@solarflare.com>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <b3bd1da2-5c13-5ebb-195e-426364cf420d@mellanox.com>
Date:   Tue, 10 Mar 2020 09:53:28 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
In-Reply-To: <62d6cfde-5749-b2d6-ee04-d0a49b566d1a@solarflare.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR05CA0017.eurprd05.prod.outlook.com (2603:10a6:205::30)
 To AM6PR05MB5096.eurprd05.prod.outlook.com (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.223.6.3] (193.47.165.251) by AM4PR05CA0017.eurprd05.prod.outlook.com (2603:10a6:205::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 07:53:30 +0000
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1c25a981-b334-476c-a5b6-08d7c4c82019
X-MS-TrafficTypeDiagnostic: AM6PR05MB4984:|AM6PR05MB4984:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB498496B0CC6C42755A742A42CFFF0@AM6PR05MB4984.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(136003)(396003)(376002)(346002)(39850400004)(189003)(199004)(16526019)(6636002)(2616005)(81156014)(31686004)(52116002)(8676002)(186003)(81166006)(86362001)(6486002)(31696002)(956004)(26005)(66946007)(8936002)(53546011)(16576012)(316002)(110136005)(36756003)(5660300002)(66476007)(2906002)(478600001)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4984;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dDepVpOsWfl+MfPrcB6AyCiMrN8qVnUQg8ZsGmLg359cfQUHuO1X90IqgGRfbKibl/UQz9c4Ewd11kR+U5pyvnQgDtKfOo8WdCopx1WJ/u00/Pril0D84hpoAoQmhshkQIzn5gGTwhqj4nHE3nIc0Mm+6TodVwtArzswn0BjdA1/5ct3lkOkqFDp2iMI9RsL0SK78XW5CzSZlb3y1LPE8PZQpqqSuv1nuBZiimnqQ3CxzT/hd5WXAvh3F95CASWbxVw3Cy6HsnBqccUMJ47JLZlasMs7UbH/0/1MXOu0KBwmV9mVF+ILE6qLUU+KWRBocyPeUrSK39rFu2CVG+TdJN6aAdwBG+mEWfqunxufMjSOYdNRQ4qaKm4M24Xn1AKA68EICwBzQIRbFS+kqVGYRpPJoKNTGYNvwtmmCCThcR33RnHy6+d0l7uV0c8LY2Sh
X-MS-Exchange-AntiSpam-MessageData: NEbW6rF9iEhnWjBO9Gm+XC9gBBi/yAm9vi+BuPdA5AxughTa65bADqjaJAsmFdcvZ9E9RVo3ncjRr8mHQg9Zc7FdvTvgk+nQzVB3xt0ba1zclwfxT8nAA5blE8D3EdAWjsucgKlLOc7qWvb8oWYXEw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c25a981-b334-476c-a5b6-08d7c4c82019
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 07:53:30.9288
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BcLcVfPiBQjqyWT2o4I39SyspsJBbh/nBNYDcnsKJCT+daVjQ8GcnF/3ec0fVtaTptcg0db9ooXqSWIiE0awiQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4984
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/9/2020 11:25 PM, Edward Cree wrote:
> On 08/03/2020 14:10, Paul Blakey wrote:
>> Pass the zone's flow table instance on the flow action to the drivers.
>> Thus, allowing drivers to register FT add/del/stats callbacks.
>>
>> Finally, enable hardware offload on the flow table instance.
>>
>> Signed-off-by: Paul Blakey <paulb@mellanox.com>
>> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
>> ---
>> <snip>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index 84d5abf..d52185d 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -292,6 +292,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>>  		goto err_insert;
>>  
>>  	ct_ft->nf_ft.type = &flowtable_ct;
>> +	ct_ft->nf_ft.flags |= NF_FLOWTABLE_HW_OFFLOAD;
>>  	err = nf_flow_table_init(&ct_ft->nf_ft);
>>  	if (err)
>>  		goto err_init;
>> @@ -299,6 +300,7 @@ static int tcf_ct_flow_table_get(struct tcf_ct_params *params)
>>  	__module_get(THIS_MODULE);
>>  take_ref:
>>  	params->ct_ft = ct_ft;
>> +	params->nf_ft = &ct_ft->nf_ft;
>>  	ct_ft->ref++;
>>  	spin_unlock_bh(&zones_lock);
> This doesn't seem to apply to net-next (34a568a244be); the label after
>  the __module_get() is 'out_unlock', not 'take_ref'.  Is there a missing
>  prerequisite patch?  Or am I just failing to drive 'git am' correctly?
It's was rebased only on top of saeeds ct-offload, will rebase it on net next as well.
>
> -ed
