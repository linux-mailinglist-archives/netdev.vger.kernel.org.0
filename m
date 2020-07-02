Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23A80211D91
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 09:56:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgGBH4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 03:56:08 -0400
Received: from mail-eopbgr60062.outbound.protection.outlook.com ([40.107.6.62]:39218
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725287AbgGBH4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 03:56:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jhPrHGGKyaep/v2PdJ1lvaQfmS2WfLy3bfVFn49lO9f+oPqbcu3XAh+7SQ+SsyMW5dbBsEXk1IE0UXKwM7C4pIfkrXd/zioNKp4KrDCY7PKnwIdzIiow35Fr90rsMNsMFJJQ5pyMHjaNtDZZagSMq+ulI1aXrQOwk0ox6p988GiaMyNeQiXQGbGgRfyCawlV/1DClEQqDc63vqzzylnQS6xGBTsEpBE8qiYvfvMBpwZ/doHMyKNS0AjxyFWQhvPbxbxK9/h0/55UX80VT79MTeEvTFBAHhy9V0NckmLKDzPB1FTBQamppFUtztNTfHvhEIsculJAh0QrFnJaS1aLfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCOmnCHgp/e5ECAh6pt0bKQC/skuaBrE9SjjS/guLqY=;
 b=S21t+36YDSM783AbeCJ4T0Z2ELriEp3gDB6HjhiHyi/CammwZxMsRytJ7COTK2hFHddkn/Fmt5QbsAhw8trARNwyz2cTlz9vDsFnWknP3SIYx2yKerXCN0KPV4Vu73pPJWmAY+NA6/O/W8o844JCHzHT2UF8zGQzeEZOwaSiBQtivcGJL2Cd13OL/3ZjNsTMoVsxO0xbV/rM4XCNS2MYOUnw4UUNkS6f6g3ZATAAlwbuPQGrQnsbQvCJ9I0kubORITkQhAEdkZLTVw0m6L6Cy5KTcnYzX/RcliGBtEFulKYVDBfRMywozGhhMhJOCfVEBU6BjDikDNtFTjqCfHMc2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WCOmnCHgp/e5ECAh6pt0bKQC/skuaBrE9SjjS/guLqY=;
 b=JDnlP1xkvojE5bwBceeos5moksKknDkbVNvbj3AN5sRV5x8eVuINrXf/R3HSsvyqqTZw8L0G8LWgQC0QCqxa7Mbi/soCToXZcVepmeJagqNDpdlodopMouq7Ck9+ULVmXDLwyfwFay5Kla1YoYfc0IusAUnPmNAMYmOYOqpVA/Y=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM0PR05MB5266.eurprd05.prod.outlook.com (2603:10a6:208:eb::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.21; Thu, 2 Jul
 2020 07:56:03 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::ccb:c612:f276:a182%6]) with mapi id 15.20.3153.020; Thu, 2 Jul 2020
 07:56:03 +0000
Subject: Re: [PATCH net-next v2 3/9] devlink: Replace devlink_port_attrs_set
 parameters with a struct
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, jiri@mellanox.com,
        snelson@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
References: <20200701143251.456693-1-idosch@idosch.org>
 <20200701143251.456693-4-idosch@idosch.org>
 <20200701115126.4ba0915a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Danielle Ratson <danieller@mellanox.com>
Message-ID: <62bdf15c-a95b-84cc-778f-5cf43da17a78@mellanox.com>
Date:   Thu, 2 Jul 2020 10:55:58 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
In-Reply-To: <20200701115126.4ba0915a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR06CA0133.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::38) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.14] (185.175.35.247) by AM0PR06CA0133.eurprd06.prod.outlook.com (2603:10a6:208:ab::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23 via Frontend Transport; Thu, 2 Jul 2020 07:56:01 +0000
X-Originating-IP: [185.175.35.247]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d9c1a94e-fd1c-49d2-3c38-08d81e5d5dcd
X-MS-TrafficTypeDiagnostic: AM0PR05MB5266:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB52660669A60A4A7CE963A701D56D0@AM0PR05MB5266.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1186;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JMPKPgAQqqLozIw+yszMap/uglZszW4YsTS/Dnb0SSCJ/BXDKmBUbVkDzm3ZASVzjTThoTsH+JzOl1tLEnA9M/Hnby68mIsbmq8uStGwmeb0Q5W5t1U0HQqFrKytOKWhIyWDHJixYaJGltIIhfkfC8j08RBrf50Zt0PK0YErxxsQM7M+pQiDA2HHKsu0aRkzkaApZPWG37cPEMh4AvYxvofbfHnZwDkYNVMOeDWP1sWit/71BqJZqVCOU0OluFXrmuFXM1/8d3BFJ9+hjqrV39qn/gw2r6Y/nOV8kqh28d8OH/fSiY3taNtkQDXlKMit85DMF0zkzq+FkakLN7TB9X4876PAdsm7rO/BQOwj1eVqu/q3QF4n6V6+s9cgcbKl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(52116002)(186003)(6486002)(53546011)(31696002)(31686004)(36756003)(66476007)(66556008)(86362001)(5660300002)(110136005)(66946007)(956004)(2616005)(16576012)(316002)(7416002)(26005)(16526019)(8676002)(2906002)(4326008)(6666004)(8936002)(478600001)(107886003)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: YLXjttndlszOVpMHX4OxYatR27ZF7Gqd1qtuG4sqvPYyE3cmjGh90g9nzYptZCpQ2brg8BRZUM4NDYGDAniIPvp8EKXHncO5RFDTCJzcACwnzF0n5yB6CW5sNRyQbpoOFzCQmvNO6P/Wm1/GDdde6IcNGl1E3LLjpew+SOYK730l4vxv/+hk6Cel6B8mVFGV4agR0bwEqKnq5TTLSoAFZteVyrrBWRLXZ+WSZkE9z1ojzE3Cj0zgcp6gIDVCZR5lQayrqdYKhu+uP0dbETb0tpnLmyMJUQdzUworNu6h1KChPe0HvqrbpgHAb0bBlDucYZrT95pKyYZv3PeIAZLZZnjF6PYiJtvkD6RV1QTgDleZg76rxSMaHK/sev1w0Mj6UDJfGRLHIF66tzWqmpDUH3x9MRUnODKGRdDeTAnWxY30DFjF3epS/CE5/GN1PMv2b4r9z8drE7X9XM/Uc5s+aEzEeA1JH8zty0WcfKVgbISpGdqpdMsD7PCL9SYshPds
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9c1a94e-fd1c-49d2-3c38-08d81e5d5dcd
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 07:56:02.8917
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lg5SuJSRN6ZiBDMDXV3fhkg8cXw2GqdbCfB7oo4sY/GWtoPzJ147Tud7/Sc5jBF4AeCl05xSv8k/bF2sHL9bWQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5266
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/1/2020 9:51 PM, Jakub Kicinski wrote:
> On Wed,  1 Jul 2020 17:32:45 +0300 Ido Schimmel wrote:
>> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>> index 2bd610fafc58..3af4e7397263 100644
>> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c
>> @@ -691,6 +691,9 @@ static void bnxt_dl_params_unregister(struct bnxt *bp)
>>  
>>  int bnxt_dl_register(struct bnxt *bp)
>>  {
>> +	struct devlink_port_attrs attrs = {};
>> +	const unsigned char *switch_id;
>> +	unsigned char switch_id_len;
>>  	struct devlink *dl;
>>  	int rc;
>>  
>> @@ -719,9 +722,13 @@ int bnxt_dl_register(struct bnxt *bp)
>>  	if (!BNXT_PF(bp))
>>  		return 0;
>>  
>> -	devlink_port_attrs_set(&bp->dl_port, DEVLINK_PORT_FLAVOUR_PHYSICAL,
>> -			       bp->pf.port_id, false, 0, bp->dsn,
>> -			       sizeof(bp->dsn));
>> +	attrs.flavour = DEVLINK_PORT_FLAVOUR_PHYSICAL;
>> +	attrs.phys.port_number = bp->pf.port_id;
>> +	switch_id = bp->dsn;
>> +	switch_id_len = sizeof(bp->dsn);
> Why do you create those local variables everywhere?


I will change that, thanks.


>
>> +	memcpy(attrs.switch_id.id, switch_id, switch_id_len);
>> +	attrs.switch_id.id_len = switch_id_len;
>> +	devlink_port_attrs_set(&bp->dl_port, &attrs);
>>  	rc = devlink_port_register(dl, &bp->dl_port, bp->pf.port_id);
>>  	if (rc) {
>>  		netdev_err(bp->dev, "devlink_port_register failed\n");


