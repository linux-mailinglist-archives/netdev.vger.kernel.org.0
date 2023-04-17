Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7F5C6E505E
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 20:43:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbjDQSm7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 14:42:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjDQSm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 14:42:58 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2089.outbound.protection.outlook.com [40.107.220.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DAE26B8;
        Mon, 17 Apr 2023 11:42:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fDSY5mj/3U6/uiBLBlx4gcsWb28Dc2J8K2fP6r69A7LHQ+/JaXLOz1UoBi5cfvSjrbgqOop8wlNbUwdoCeGwc+hK772x9dzSaofrKMtlWSCKUi4KCTvbITKEcuLJUf6PN5HZWpvBuRgcr5gcR3u0aPJuGdHW8ettSJx429UZmKsEFJ3/rnZhTwFQYN+mBhMJmia2gX9JYi/AVu2C8ZpoYAAcGXIMpRw91jZ2/QPOrSJ+iy4ub1O79HurWMd/n0WmIDZg0o6z0XukqJRf2y/RXok1r0vUYNlTHeGKo1kGQ2hvHmAU5+n/gSV9AGnu4QqqJSeuR47z6xOwHEevDSe3Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UvmohGLVv14LEzwEcRbDSK5XAR80PYYPyLdcPbSJlx0=;
 b=WXKAg+hlAXKnL+KovmdhPFJB9F1VwnNCiBkZ0f6CGaX8wTc0nm96ZzK934aIQyXzWvjj+hl4VRBHWWP068BDfCvPH+NzCk8VfUgFwpAbdkODgVZGKcWe+hCFNirUpZ407DCHE4Dar6JLkjtns9r5Neg2HdxVMYZYJwL21bKC357IzmS9SFwW0PKPzc5pk5vQy9b2N6TlR8AQ/9TgrrYbBjI1cd94PL1MtwupSMwfZdqak3m8zU/4wbZruOtPD2692+GVnY+zsaHN8tLBG8M1P3LSXJ60GEsHJGg1QiN0EH4LdBG0WVS0inytNBWsxZEPUEY+JU/RnrSZTZ5ZomLW4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UvmohGLVv14LEzwEcRbDSK5XAR80PYYPyLdcPbSJlx0=;
 b=czMOafbz07ZPv90ogNOL54VBaiHekRf8u7yfs/Ow92CC4gVUXCMpHisHlqjZ3zIb1bXyTPOzjFxREV6DJ7gHzFuDUFBfb7RCW5G9KLv5ZPGZJGDSADhW3mKt4po05o8oGAfM/hvuNUpLvtfzDiHl4xRNedYqocxhTzWoGuVIWPQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DS0PR12MB6583.namprd12.prod.outlook.com (2603:10b6:8:d1::12) by
 CH0PR12MB5060.namprd12.prod.outlook.com (2603:10b6:610:e3::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6298.45; Mon, 17 Apr 2023 18:42:54 +0000
Received: from DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86]) by DS0PR12MB6583.namprd12.prod.outlook.com
 ([fe80::e786:9262:56b5:ca86%6]) with mapi id 15.20.6298.045; Mon, 17 Apr 2023
 18:42:53 +0000
Message-ID: <36a04310-0ec0-58fb-ef09-5495d3495d5e@amd.com>
Date:   Mon, 17 Apr 2023 11:42:50 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH v8 vfio 3/7] vfio/pds: register with the pds_core PF
Content-Language: en-US
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Brett Creeley <brett.creeley@amd.com>
Cc:     kvm@vger.kernel.org, netdev@vger.kernel.org,
        alex.williamson@redhat.com, yishaih@nvidia.com,
        shameerali.kolothum.thodi@huawei.com, kevin.tian@intel.com,
        drivers@pensando.io, simon.horman@corigine.com
References: <20230404190141.57762-1-brett.creeley@amd.com>
 <20230404190141.57762-4-brett.creeley@amd.com> <ZDlKj/AvVxwkt4sb@nvidia.com>
From:   Shannon Nelson <shannon.nelson@amd.com>
In-Reply-To: <ZDlKj/AvVxwkt4sb@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0073.namprd13.prod.outlook.com
 (2603:10b6:a03:2c4::18) To DS0PR12MB6583.namprd12.prod.outlook.com
 (2603:10b6:8:d1::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS0PR12MB6583:EE_|CH0PR12MB5060:EE_
X-MS-Office365-Filtering-Correlation-Id: b86b50e7-8cc3-4647-8230-08db3f738dd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6v1So7yDXk+BNEQcaimMzNC0V2h/svAwOUV73woTggp7p1EAdR47noe1H6yCRQQU7J6xKajbPAxtA5K/9YxXVazsoe3YICZLaOovfYFhwBX+h1ahmfYtabOlcyADO8TQKvJJCah5rK2Hjz1Mb0RcDSlFOaOEj9HA+tve5MHFvnS6UXr4qN6CwQ/IgzqH5m9N64Pv+98yP4jF0mPTjfZZHRNOc/ggOuJkPQmm4zrK1a0A3AYTTix61Dg/RgCbPAoq6QKsW8glmN6BDMe9q7ylEj5anQFKYL0y71SnLEPPilQ7KOFargqn/WCRHvSAkgKHpGFf5HW3nDSO/kmDScMDwCtLLN1J0GCBPRIsbFpS0JTOMGa1ZueDYeiQM+xoMDc3zemqFuB5Omy/looSUpn/IDrFod2ViPK2X9RqDfBfVtCpLvusA6QI9tS9mrlUSuIBjjCokT9VscwIwp6GsZCm5T73Qt8w1E2BCxJlVd5BqtuMy51ZFJ7gi2iBiZhextddXH4hWNgrhe4F9ddhlkgBEh5JIRI7tkP8fzbvpxY1pOkD68mfE+75KgzIoiO4v8Jl10UxpHRBdHKsZvfRVSG77qTCI/H8MtRzBcgO/dDu3LytQN+bfbLHxwtwRSYAeyvjOIqIlMZBuJIwSOgQprXBEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS0PR12MB6583.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(451199021)(38100700002)(8676002)(8936002)(44832011)(5660300002)(2906002)(4744005)(36756003)(86362001)(31696002)(478600001)(6486002)(6636002)(110136005)(31686004)(186003)(2616005)(6512007)(6506007)(53546011)(66476007)(66946007)(26005)(41300700001)(316002)(4326008)(66556008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YmNmUUNEdm1VWEtDOW8wSXJjY2FpdTN1MllEVXBuMjhuSThuV0JWY1RITHdC?=
 =?utf-8?B?ZGlVTEE2bDJQSUJhczNRN0x3dTRqaFVuQzZmRXBRT01hcG9PR3ZvSG8ySFlq?=
 =?utf-8?B?c1pHdXBTdlJHTDB5ZW5TVzkwcmhsbHhFWEg0QnBTOVl5K3NmdG8yYVpMS0Ja?=
 =?utf-8?B?TmMvOWJDUnphRXFXV25LNU9yVXhJSDAxeXdwYjIrOVBDMjlGOWx6UTQva0VK?=
 =?utf-8?B?RjFML1AyVis4RnNaZ2s5ci9HZzlkZkNMTUY4ZHE5dmplRmlNWE1Sak9VbXZM?=
 =?utf-8?B?R3Y0cFhjKytnOG1pRW9meXF6NXVudngzUEwwcEs3UXhVMXdGYXRTK2RZVnlT?=
 =?utf-8?B?U2JnZDVWcVhFUXk5OVJUZjZRVnJhVHpLbzVoNTZXVnNCYXV4OWh0UHc1MGpj?=
 =?utf-8?B?Y3loeUI1OXZjYnNhaDVBZ1VqeFdGd295NUpjbkQ3Z3MxbUppYVZPdGFSemhP?=
 =?utf-8?B?K25SaEdXeGQwTWNMYnlDcEZTY0g1QmJkNG1jaXhkS0dYTkQzUzlqZ1lVbHRN?=
 =?utf-8?B?MHZkQ3V4U21veFdCS0djMjh0UHl5K2NmdGpGVU02YlBEbmtVMGZjcEVYZFo3?=
 =?utf-8?B?S1NoUjhYQzM0bVZWbUlxSDQwTjNYZnBlM25BbGRKV1NnbHoxaEg5R1FtMkRC?=
 =?utf-8?B?UHFFMmpEbEo0ZHUzTXVPWGppYnVBL0thdExraDRnbldRK3l3ZHlsSTAzQWZF?=
 =?utf-8?B?aUZyOW10QzFEVFM3RG5xd1FmSnJsM2VTY09FVFBLWmJIU1dRUVJiYmRSTU9Z?=
 =?utf-8?B?OFpLVW1UMXR5cSt3SHUrazFaK3JkV2tJcUV3L3VmOUNXTWNkalJ4M3I0amoz?=
 =?utf-8?B?NlhEaERUK0diRTRWTE8yazcwNlRWczdENVIrNWtmdi8zZ3ZNeTloNExSSjYx?=
 =?utf-8?B?OEFMczhSUHh4VW9qZE1SeWZEUG95R1pRZjZXU3ZNd0hCNm9jeS9jTkxwczZl?=
 =?utf-8?B?czNNTGJJVFVMTHhEdG43V29hRENpbVppeDNEV2Zsek1RUmlkekVyaHhjZjZM?=
 =?utf-8?B?V3B0ZTAxOU03c1BqUnQ2aDRlWCtDVkRwQW5BbjRIT1g3WFNRY1FaR2hFNHR3?=
 =?utf-8?B?bFE0QXZYekFTUjVnSG1aT2VFaWNaMlBFcHAzODh3UzNOYmdKNm4yTVZnbjZ3?=
 =?utf-8?B?bUk5QzEyaC9BR3hOS0l5QVMyd1BuQ0VaNWpqZkc3WWVtVklzdGpWVHN5dHpu?=
 =?utf-8?B?VndNL1ZzZ3pxcHJ3UmhzZjRKZW1BL3ZCRXdFSDFwMmJ5cmMyR1BtS0VEaFRD?=
 =?utf-8?B?MXM1NEVIK1o1VmpVcjRYaVEvQklpSnhGSWpXOUlZNEk1c1dpVlRyWVpqWVB2?=
 =?utf-8?B?YXlqazlBMnN6ekVJSktYNExnVEpqZXlVek11MU1pMGh5V2lrUlpnK29KWXZH?=
 =?utf-8?B?U0VwMHNMUTROT09kY0VGazZwQWdIeVkvMGtEL1NGc25lU2FvQW1Xdyt5LzVn?=
 =?utf-8?B?NnJFRFFBUG5DWVZhRExTaHV5aGVoZTFWVkZ1TXJaVHpNbWtzRmRQaEJ3ZGVw?=
 =?utf-8?B?K2pwZnEzQUZHWkJuMDhZQUY2SkIzbGZOVmU3TWttb3JYdmIzWlhNWENvMmgv?=
 =?utf-8?B?Yzc1MitnUGppTzk2MjRHazJiWFhLa2cwWkZaUHg2WFV4cHUzWU1Tc01FRVpt?=
 =?utf-8?B?d2c3UENCcFhFOVBpSWFkY2JqUzhEQ2tjL2ZsaXhGRHJITytKdkdoRWJKQkRT?=
 =?utf-8?B?NDFKb2IyMmhtdElZOGF0b2xCTEZDbkFuZlgzMloxVXNlMTh1NUJxdWN3Tlor?=
 =?utf-8?B?c0V3Ym1FTE9zcklMcHFSOHpRK05weGFaZTAzc1lSZHlxaDV4S056UWNwZE4y?=
 =?utf-8?B?dVZVMjBSM0pEMEtxMmxFaEY2b3R1WEREMXR5WEpjUGhLZWlPRnprMW5QZzJT?=
 =?utf-8?B?UVBFeEtmQ1NxenRONHVpRXJzaHJDQlZxeHAvcVF1VzZ1eFVTZW9kaXM4VUlI?=
 =?utf-8?B?RUw0WU5BcDJQTGRjS2pTRXp5dTFza1oyU2lFRGpHOGs1aUorM0U3Q1lVOEZ2?=
 =?utf-8?B?OHYrdlo1SEdXTUZXT0ZlN1NEaUF6aFl6THEyVkgvUjFxV0pwemFHMjgraXp3?=
 =?utf-8?B?WmVOQUcxUFpYOFB2bnhQN1I0ejhaR245Z2pPcVQ3WmR2VHBTT0JBVWZlcjBv?=
 =?utf-8?Q?ZmKZIyf5heW5n/5Bb10vBmUey?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b86b50e7-8cc3-4647-8230-08db3f738dd7
X-MS-Exchange-CrossTenant-AuthSource: DS0PR12MB6583.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2023 18:42:53.8485
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NF//oEY+K0dEEknjaMOXpxQaIUxtdzQlIY7hNZT1o50IJtnE/Woa5ZcfXvQe6ji8fZGK/ai1O2C4xaFhmzT7KA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5060
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/23 5:43 AM, Jason Gunthorpe wrote:
> 
> On Tue, Apr 04, 2023 at 12:01:37PM -0700, Brett Creeley wrote:
>> @@ -30,13 +34,23 @@ pds_vfio_pci_probe(struct pci_dev *pdev,
>>
>>        dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
>>        pds_vfio->pdev = pdev;
>> +     pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
> 
> This should not be a void *, it has a type, looks like it is 'struct
> pdsc *' - comment applies to all the places in both series that
> dropped the type here.

Thanks, Jason.  I'll fix this up with a proper type in the pds_core 
patchset so that the pds_vfio can follow.

sln
