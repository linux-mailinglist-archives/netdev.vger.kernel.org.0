Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0A336DC383
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 08:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjDJGYK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 02:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbjDJGYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 02:24:08 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2043.outbound.protection.outlook.com [40.107.96.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDF940D5;
        Sun,  9 Apr 2023 23:24:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ij1bUkt9kMxYyk0fr1DQueC5uitELa8gRKs1kx3GXxiz0odJySoYgS7ru/QZqC+RO3A0jYpI6j0ZMiAQMV5PhZJvy8smv8WdUotdmE9f6JHdvtt/DkTerbDs9/twgyGMDu+lqbzAKBpAFzGqA66+5kvhg9HK9QGVY2ousIVLtGct7oie8QF4FrUva5uVZxPRwEOG77TE6Gk4W4Vtq4Q83q/WB/f7f3k2z+RCulOI2eEJWoD8Itpkh6SmeyNaQti2hpF23uthQOP2eTY9qHoFOvNmklFhO6a+6QCbbn9dYpgQoYz4+RBL+JndyWneMGmYxnCeT2Q7KDN8H85XBFxlUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n4BvcHTF+5Le6gfnyKquAMCBd6gLnoZAz33tpCsTRUU=;
 b=dV0c6nFVOX3xF+wxYqpusVYpJ8yiqj1VmCwBSQooBDs4eMGFEfnjHPj0efpB46o7Oe/7Tb3YOEzuUL3lYGbN0hgCrXaWwxH7/IbJ5Of+hOAIUe4rTqHw6z2VdNLFWCz99Urx11DzWNiWV8BXh/p/mDxCaqjFNbWrvQquNqy3AmafOeB7pQgg2QsAhjsDVQWPqgyX4QLgYtVi2vt5AzqNuM953yDr6ufKVMfndD6es5U/5X1VaQcOoVtNcplHva0GpwtSbuRffIJb8SC2y/HKdrrVE4ELzNldUA+DL2mhtLbNCMs6ZoVa1aW4lueAWeib1ZG++MVQ1KGNO5vowEEckA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n4BvcHTF+5Le6gfnyKquAMCBd6gLnoZAz33tpCsTRUU=;
 b=Cdl4IK07JBa3ySdqjRWEQQevY7UtyeuB4R3zsbCP/Y1oXdzNbwP6ImZJLp2wBEISkS3rorAB8VTNO/jyvOsWojzPSjoYzunNDv9FkqT16hTSMX/iXHkuxKO7OmSUy0slJ+N4pEFSS3/hKUuOIL2r1yP8zcfVGW7JnO9ZC9FU+T8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5825.namprd12.prod.outlook.com (2603:10b6:208:394::20)
 by LV2PR12MB5774.namprd12.prod.outlook.com (2603:10b6:408:17a::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.34; Mon, 10 Apr
 2023 06:24:04 +0000
Received: from BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::6fc1:fb89:be1e:b12e]) by BL1PR12MB5825.namprd12.prod.outlook.com
 ([fe80::6fc1:fb89:be1e:b12e%6]) with mapi id 15.20.6277.038; Mon, 10 Apr 2023
 06:24:03 +0000
Message-ID: <7bcec218-ff52-bb55-2253-24541c44b6d6@amd.com>
Date:   Mon, 10 Apr 2023 11:53:48 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v4 09/14] sfc: implement device status related
 vdpa config operations
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Gautam Dawar <gautam.dawar@amd.com>
Cc:     linux-net-drivers@amd.com, jasowang@redhat.com,
        Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        eperezma@redhat.com, harpreet.anand@amd.com, tanuj.kamde@amd.com,
        koushik.dutta@amd.com
References: <20230407081021.30952-1-gautam.dawar@amd.com>
 <20230407081021.30952-10-gautam.dawar@amd.com>
 <20230407202056.366ad15c@kernel.org>
From:   Gautam Dawar <gdawar@amd.com>
In-Reply-To: <20230407202056.366ad15c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PN2PR01CA0175.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c01:26::30) To BL1PR12MB5825.namprd12.prod.outlook.com
 (2603:10b6:208:394::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL1PR12MB5825:EE_|LV2PR12MB5774:EE_
X-MS-Office365-Filtering-Correlation-Id: 09a64d45-298c-4684-c575-08db398c2dbb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nRipXbDmpFgeUtVbORJEwoaY4dEMNohuRzQ1wFn/uPAhRbYHzRh2gT+Hd/YKTz8fx9aU/Z3T2PL6PgFMM+qtC/6ngGNnJ85dKSLJID+NnGhKdbxaxkzlEKUMxitK87+7KJ52I6WfkkLN4xQ5tAitNw62DBrwdH99uCf+LjWG/6yaXLSNnOHp2d5ayUEZ9imOWkgQXzGiwJQISMZUXGgL2FPR+zAJmZV2L7JtN0FEsh6qglndpXukbLXH1Kj8Ys6M7Pkc7S3c5HsJgmxz8B2/p2a+4mqcwqbGyEgyZ0pPPBNTTfblKgpot18dx85OZL7mQUJCorGdDVxlOypiPITqGBAiLB+kgM3gv6bL381DBEaqLGE6v2q5gwScM1BpalYe1HKKxd0jLHrRIz89t2Ac4i0eckzk8QKtQxVaZIt94I9IXWRxFvDKiRGKvMyL1KU9x7BE5vYFtSA8AgXiv546YmV1bTamnKpNwfM24h//rmo9BTfZEpI6rYEHf2yRdreoy/HXvQbD3Ubk0+0C1bGBun31epEju8328Wc1Xxr+sNDf1JAPK5Mki4d3rWSHjdn5ZUwKEe969dURzNw7b3S9F9Hhi37PO9IySUbzaWgV2WlArK3MnI9yuw0vrNlsuctkyFH2UGw1j6jrJF4dYmhwiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5825.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199021)(186003)(110136005)(316002)(31696002)(6636002)(54906003)(4326008)(66476007)(66556008)(66946007)(8936002)(2616005)(8676002)(41300700001)(5660300002)(36756003)(83380400001)(7416002)(2906002)(4744005)(6666004)(6486002)(38100700002)(6512007)(31686004)(26005)(6506007)(53546011)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Njg5YXN5WXcvWHRXV2ZJeXdkaGhSQzJWMVpkZmhhVGU1WE1GV2dOZnBJajJI?=
 =?utf-8?B?bHdmeVIrZkMva2dxc2dMU3ArUGltTGlSME1KK3ovN2hFamtNejYyTnRyN1I1?=
 =?utf-8?B?ckozMm0reWNTejU1VjJISWVSd2FGTjBmb1BhTjBRUXB5YkE1TC8rbEk5V1hh?=
 =?utf-8?B?ZGgyeDFJcHpSZmNWTGRKMzFqYkRXZkltUllXdmNldDQrWWNaQ202bVNlTDFS?=
 =?utf-8?B?TjBaU3NwOXNrSWxNQW9TOEhlcC9QbUZtV3pWcFR6bVVkc0dBSlJML1lOU0RZ?=
 =?utf-8?B?SFhmeGc0Mm1oZUljU0pEZzFxeFErRG15SjZGcllick51ekVMamhOUkdFLzlB?=
 =?utf-8?B?ZnZVbmtSaFFic01WU1ZZdkpFL3pqSmZ5dDRxRUNRb2pDaVZIdlBlL2xRc2Jy?=
 =?utf-8?B?U25FMkYyb3R6N0IzbSt2VEJBQk1lM0E4VzhpQWg4Zjg1WVAwSHFqRGQrdDJB?=
 =?utf-8?B?UUZ4eDZTb2x1UzVlYmR2RkVZekdKUGFMaVYvVG82UEtDVzE5T1c2N0IrM08w?=
 =?utf-8?B?WHNuY3Ura1VaN2hiMDFKNXR0dy9OSmQySXFxWkVsYmpDSEJvQ0d6MUdQOE4x?=
 =?utf-8?B?czlqdGtDZE1JTG82bHF1ellhRUVVa3lmenNmcDBJSmN2S1ZBV3E3d1VnNVNk?=
 =?utf-8?B?S0NPeVlsdmpuSUNrWU90eDdOR0NOc01VQ3BXMEF3aVJrYis0ZWJ0b2xzRGFI?=
 =?utf-8?B?RzUrQStldDA4T1laQmFoVDB6cWs4U3hKUzJkUk1uaGdqckI4RXA3Qy94WUk2?=
 =?utf-8?B?ZlVhelNjbnNseUx4Z3dCZUJzeFMyYVk1a2tlZlByc0ROVXhmVVhjUXRWUTNo?=
 =?utf-8?B?UkF3ajdJeGZVbTFwVzRLSEo0MHh3QThabXdUVUh5dnFhMmJ5bGl2M2htNElK?=
 =?utf-8?B?WHk5TGZ4eCtHNWhvenEzQVVtMW1wU3BJMmx1MzFuMWpidjFnQ0JZN0VFaGdY?=
 =?utf-8?B?anlOU2VPMmpiak9jVUVKS2Ftbkpnc1RFVEZhbmVvNldEWmtDc2xMY2Z2NklV?=
 =?utf-8?B?SWZRTm1rbllUT05CNTE1ZjZSbStCOFJ1S2prVzB5MDkxM2paSWV2djdqOGlN?=
 =?utf-8?B?TTQvQS8ybjZ2T09rcHR6aFVEOEcyZkQrcjlubEQzZHRPczJaVDY3RFl5MkxD?=
 =?utf-8?B?NEgvb2NmY29WaDFLZDJsWkpzeEZmNnZZenorKytuWGFPcTV4eFcwZ29IOU0v?=
 =?utf-8?B?UFc0UnhoeXZPYUwvREYyV0c4QmtySzBqVTg1T282VGgzVmR1QVpndTNRdGo3?=
 =?utf-8?B?c2pDWjkyK2w3K01EaUlhczRtVUMrK3E5T0VXSUtqU294Sm1hc1h2RGptMkUx?=
 =?utf-8?B?ZytCb1gySFhVb0pUbGhjUEU3R2N5VXkwd0ovbjJNcnQwZGpsSzA1d2l1QUM4?=
 =?utf-8?B?cGIzYnVWZEFGQlV6WGdONi82RVJTc1J0WVBRU2ZYb08weGpWV0hYZXduanpw?=
 =?utf-8?B?UEUvTWloNk9mWUwrNGh6TU1HRlpaV2RETEtiNTZMVTRFSkZGa3NjelFPa1Z0?=
 =?utf-8?B?L0FwcTRUQ0xDdDFZaFgvUng1U1UydFVFTmFUNjZrZ29wbHpZZ2RLTXRRTnZ6?=
 =?utf-8?B?TUczV0M3cVpHREpSUVQ2cmNtdTRaMzA1cEtCZlZNOW91SGY4UFQ5OHBwL2xx?=
 =?utf-8?B?Y0ZzbnBTK1V1R05mTzZZVTgvR1NMZXZkMDV5WDE5Z2NwK2l2bVpIb01ENHJM?=
 =?utf-8?B?Qi91TE96U3Y3eXMva1BZZWlUWTMwSUJlL1IzV2NkYU4zbEczOE9KSFJpWW5F?=
 =?utf-8?B?SVN5S3ZST1hlck1TeEE0eW85Z29EbmF1WDIyOHRndHBMekh5TUNKM3puaUJ4?=
 =?utf-8?B?aXdwSzIxN1hYdUpCdDdtdUtoRnN4U2sxVE9xeGJNRytTYUY0dW8rR1BDNkpJ?=
 =?utf-8?B?RitCYlVaYjF3Z2RhK01WWHRyNkxnMGxaUWtENWxFS3JCcEFiL3pvRm1Hb3ZR?=
 =?utf-8?B?bWtwbjdXTTRadUYwSFBzTHV0ZHgyOG0zdi9vempwZG5xbWdESjgyQlZkNU1F?=
 =?utf-8?B?eGRNc3ZaaDRub3M1RktyQXhWQ3ZNYnlBYkJ1bkgrcUp5dHVzWVVJcGFiUFlO?=
 =?utf-8?B?RmlMbjYrcGhhbnVubWEwUUZGdEpWR1JtbkswbDFnaVoweFVEaHlxakViSS9m?=
 =?utf-8?Q?y7rTdpnbU2BdAEKKtKVmuuVBs?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09a64d45-298c-4684-c575-08db398c2dbb
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5825.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Apr 2023 06:24:03.0241
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /VUuzNZMGEzPvB827CsKlD00Qohcwr+nJfvzq3C3OGk2e37eXZwOqO7xtCwyJdwu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5774
X-Spam-Status: No, score=-3.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/8/23 08:50, Jakub Kicinski wrote:
> Caution: This message originated from an External Source. Use proper caution when opening attachments, clicking links, or responding.
>
>
> On Fri, 7 Apr 2023 13:40:10 +0530 Gautam Dawar wrote:
>> vDPA config opertions to handle get/set device status and device
>> reset have been implemented. Also .suspend config operation is
>> implemented to support Live Migration.
> drivers/net/ethernet/sfc/ef100_vdpa.h:65: warning: Enum value 'EF100_VDPA_STATE_SUSPENDED' not described in enum 'ef100_vdpa_nic_state'

Will fix.

Thanks

