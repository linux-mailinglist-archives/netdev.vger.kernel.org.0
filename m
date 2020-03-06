Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0903017BE2E
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 14:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgCFNXH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 08:23:07 -0500
Received: from mail-eopbgr60042.outbound.protection.outlook.com ([40.107.6.42]:58791
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726167AbgCFNXH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 08:23:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P3kvj7hLTZwef3zoX2WW+xHPPQ64l5XoDjB8eRGNnhMHQ/qYw9qjqD4lguQhEUQcglch+P4o14/yQP38TBXrUMr2hQrjIFKb/LVfP2oh3gJdQP41E4Gc7SpkOf7TsXzhEvZSV/jq6kRv/nmfGpla78fvecRsgKIhGcHUyL+WNFJNF9QS7k707JL/wDUnN3VCcKzta4ZT+iVCUsVxx/9NT2ze1Ome2/au07Y7eXlx/TNYKgARw5WjzSfBqseZBif2Y7csLjzDtspJqBMO9Oc59a1NSXSPs7239t6KFbzYgImYqa6956g9QKsjlY/kUt76Hrl6xLnmV3jsYd7/gTXW1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odp19GMFjoBAbU6/YJ4M+oT618cn9bh8VdCX6Yh5vNQ=;
 b=a7uWbj62piGcwPGmZq/i0g10jWF/LwHF1KyBynt/Aks1EAFcnodELETa47DzJtrtUEEQ8El//N9DpViUrCjzSulHHMJAnFO2WIYYCWUFEMd6Z/6wLujZx0yDH6A/+wTiypfDcjsU1yr6FNazm4aiLVgJJ1hvkhh4DhcCufIB3L0xBMS4b3fCkuArElZdp5m6qEcF7SldFcwgbwiK1jkkSE88SyVaFncwHXnTg4tBhPLRItEy1kovJlrLe95+BLl06E/q+7HIgtKdKozAteHgEfyz2a6ShdArAbHrYMlGnNk+4/rfNOoZwf1L0Msfkz1SoljTpOiusboixWUR+71wDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=odp19GMFjoBAbU6/YJ4M+oT618cn9bh8VdCX6Yh5vNQ=;
 b=PqNRoyM1a+1y966WXPsCkFJNC6WXKPFdYyQqRSs9ENM3xMjti5OOSQidjRqXTi6MJ5xhZmUF3vG43UvA4+SUJJh+zTkVNgOiNhvSVAbBe72whQsmlNBJNpBzF7nVBfXgpJotvFdEZkMIGO7cwTep9VLFQ7FQEQmpv7rhW06Yz8M=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=paulb@mellanox.com; 
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com (20.177.36.78) by
 AM6PR05MB6278.eurprd05.prod.outlook.com (20.179.4.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Fri, 6 Mar 2020 13:23:03 +0000
Received: from AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4]) by AM6PR05MB5096.eurprd05.prod.outlook.com
 ([fe80::41cb:73bc:b2d3:79b4%7]) with mapi id 15.20.2772.019; Fri, 6 Mar 2020
 13:23:03 +0000
Subject: Re: [PATCH net-next ct-offload 02/13] net/sched: act_ct: Instantiate
 flow table entry actions
To:     David Miller <davem@davemloft.net>
Cc:     saeedm@mellanox.com, ozsh@mellanox.com,
        jakub.kicinski@netronome.com, vladbu@mellanox.com,
        netdev@vger.kernel.org, jiri@mellanox.com, roid@mellanox.com
References: <1583422468-8456-1-git-send-email-paulb@mellanox.com>
 <1583422468-8456-3-git-send-email-paulb@mellanox.com>
 <20200305.151116.1903646395885882747.davem@davemloft.net>
From:   Paul Blakey <paulb@mellanox.com>
Message-ID: <9c32462b-c400-6701-f9e3-2211157e30d3@mellanox.com>
Date:   Fri, 6 Mar 2020 15:23:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200305.151116.1903646395885882747.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-ClientProxiedBy: PR2P264CA0006.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::18)
 To AM6PR05MB5096.eurprd05.prod.outlook.com (2603:10a6:20b:11::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.50.105] (5.29.240.93) by PR2P264CA0006.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Fri, 6 Mar 2020 13:23:02 +0000
X-Originating-IP: [5.29.240.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7c859c5f-ea4e-4b3b-e50f-08d7c1d17fd6
X-MS-TrafficTypeDiagnostic: AM6PR05MB6278:|AM6PR05MB6278:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB6278C96FD90D30AD7FAEDCEECFE30@AM6PR05MB6278.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0334223192
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(199004)(189003)(16526019)(186003)(86362001)(26005)(31696002)(4326008)(956004)(2616005)(53546011)(6916009)(52116002)(316002)(16576012)(31686004)(8936002)(8676002)(81156014)(81166006)(2906002)(107886003)(5660300002)(478600001)(66946007)(66476007)(4744005)(36756003)(6486002)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6278;H:AM6PR05MB5096.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SU5146/Nn0HO8Zzoi2y8qoHDtUfuPS++tvPgeRCEq95Ii1K4xQDf2CsTamiG6EzzpKXtgSpWSD14h1DhC4G7TE/oQeZs4eg85FHLarQOLRPojStshJueOh6m9XLFLBRZSPZ+Rg+xkQy6ifkV/JfoTCxxPqPbg1ekL9/rqlamLOzDUBh8sMfYyVWASeflZzMArqpGZnk38MJdybPyHXBuUp2jY5wORif3SlH3ILvABtT0IZp34bD8ScjHUCrnHobhR+LEvh/qUd0NZi/afvJKQkbD6JfpHZ3ld5F95AYHzayqSoHrx7HjCCcfmGwHZ4UB5S2Zx+SamxgyRzTlaedLw6pLcAF55XV+ZdDhOPHwV2XrUjysmrQmvcDlDnUlfPt1KvkUx1aj3SEbkLjEGsT3aZ1BhZrOpShp5Bk6Ap7feV2GBPkCWqzSo5UhubyopIFt
X-MS-Exchange-AntiSpam-MessageData: EOxMV3/GXBdkqIiDCntSc5lJHthgduRHLO/fLbDxlgIKRD7Topi65BcRKWkCjeJ6nHQw7vV96envLQ6GI6+qj13Ogp6N6Fk7MBqLV6teQtBMEKlH1HLKPAU8d4qFe/QV96+blqAe8J6E1RpK2qj2Ew==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c859c5f-ea4e-4b3b-e50f-08d7c1d17fd6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2020 13:23:03.5318
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9ldc3r+1VS57aGmdxcJ+ORjF9xbzJyDViSlzUMJIGd2u6r8qJ2Zx/rzCQzkWGvHs6nVHOnG0sQPqJa9krPenzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6278
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 06/03/2020 1:11, David Miller wrote:
> From: Paul Blakey <paulb@mellanox.com>
> Date: Thu,  5 Mar 2020 17:34:17 +0200
>
>> diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
>> index 23eba61..0773456 100644
>> --- a/net/sched/act_ct.c
>> +++ b/net/sched/act_ct.c
>> @@ -55,7 +55,199 @@ struct tcf_ct_flow_table {
>>  	.automatic_shrinking = true,
>>  };
>>  
>> +static inline struct flow_action_entry *
>> +tcf_ct_flow_table_flow_action_get_next(struct flow_action *flow_action)
> Please don't use inline in foo.c files.
>
> Thank you.
will remove thanks.
