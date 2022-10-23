Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA46060927C
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 13:38:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230018AbiJWL2k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 07:28:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbiJWL2j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 07:28:39 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46B3962933
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 04:28:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X982/FdVD64nH/Ed9vTb0sLdhbuiTW9y1rD/zSVCWVur//Sqmc6U9JkGfZ4+I+gGO4WX5SlAEf9is8IRomglSptSDXsb0ogRVHUGOryiu/LA/eo9gF/YddPaV6NwmjcrXmG5BJxeRz4heNsFeVbIURlxlj8pxETZq4OZjV4pVKq4STQO/hWaHUflH8JBdgGOKJ9YnhPU50L1eMVbmk3qKlFVzX+BVizamGnl1RccTuPBV5fsZCG4Q2A73bvWSCGYdxZMBlBpbGenA8Dti4JZA+ONPv0s1Es8XwVZXiRxrb/9kh9Pbp4/i++uUVrroNzChk5lilC3InVlafgznykHnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qY7WTqtYnd3IJdAJ4CWfJ0itvKZDlfO1H2EnaN5vP1o=;
 b=Jue19QU/Iw3yGRHtwzpdLGshAHqcqXvDdJbWOqbTGU/OCJipa3CnEes4QEGY5yRA8Cd3MjbXvUNGKP02BevBOxapaA507pyT/TLsG7+Xn9ZlCE1Dk0eIoXDBNkUVSjJcCZ1goEtdmAHfbZ/uv2Lu0GnBLd/0/iX9m7WE1eh5vItAeZgX/WNx8gOyO0JApuoZ9z9vthZI7cPqP6Wn5q43r+tHBNy1eFwz8bqwxVVDp+DvQfG8463uV9fWuSBldnVJ/IdP95ultR14PAIBbpt0GT1FNDsp4JIEatbTsEtF09B98Grv9+YfUNRSayWFxjUh65MnfRchLcL4zd94wee1dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qY7WTqtYnd3IJdAJ4CWfJ0itvKZDlfO1H2EnaN5vP1o=;
 b=sZUmKt6s8mNSp7SK6yZlDhfJOiYOLwYdKfyzAnQPlHg2g0VXhZmqg26CXNvFa56ZXIIqkVfMI3/WGLLHBa+41+e1FjoVcLNVODaRdlRB6Nuv5CnocJxG52P/DLiw4AlxS/nv/VrXabm6VhhUgIMcs7ZkLMYBzFPdZjoIdDxzou66AZAGtO2oRw+FT3UmwkGwOkxrq7aH+/UaB9BmtpLdj/D28wHnzpREqBXZ5cu953NKbmulV3POF6ds+2/FOvQy+4LE/OQvdyBxOdA+qQlipMh+dpzjzt41qbrbcGcQFaDzfiFijiMZeqQBpQGN3DHUMdnwqWpFnuojSGtGh6s1iw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 MW5PR12MB5650.namprd12.prod.outlook.com (2603:10b6:303:19e::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.29; Sun, 23 Oct
 2022 11:28:33 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::1926:baf5:ba03:cd6]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::1926:baf5:ba03:cd6%3]) with mapi id 15.20.5723.032; Sun, 23 Oct 2022
 11:28:33 +0000
Message-ID: <3c830f86-a814-d564-df7d-670d294b8890@nvidia.com>
Date:   Sun, 23 Oct 2022 14:28:24 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH net-next 2/3] devlink: Add new "max_vf_queue" generic
 device param
Content-Language: en-US
To:     Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Saeed Mahameed <saeed@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Peng Zhang <peng.zhang@corigine.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com
References: <20221019140943.18851-1-simon.horman@corigine.com>
 <20221019140943.18851-3-simon.horman@corigine.com>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20221019140943.18851-3-simon.horman@corigine.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR3P281CA0164.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a2::18) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|MW5PR12MB5650:EE_
X-MS-Office365-Filtering-Correlation-Id: ea48077b-a852-4264-c228-08dab4e9b7db
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: w6t90k8mNzoefAq0bFs6InwiHIzDUeqRFxcXiihcuaoVZRhEKEs5yQD1VHkVK1iy5tZUmKeqUHwg2EI2hR14HDWqH0JBZQGYA4lBBIPb9IwyK4VUx38Ad/VqZlWLVo6od5p87cWaax1y2nURXfepqGszJtFi/SdIMR0cYeKPcQYQVSD0v9ehFK9n/SoGxgsS1PDrZLAdmSMKFBszcr50ad/o+lrovaAoM5624TMLJDd1cjVJXJ+2Vs4TAHVO9hChFatzvfbD1Fy4c/j9fv8KJve1ffe8C8j28v2CyehaNAkw6jqADpUf16L0aGBvfKDr0Lanwj8Bx9MDQMu5wMNL99iqMelsIWvwst4nS6eVe8Gb0fC7dW2TGgOo21KyBG6PzkjPFQmDv+dEIOplBkxDdguu33PeMe9PqKUxU7DZPbufk5b8Y57ZnppeXMKA/2K6gGDbt0KJGbAFXGFClP3spfGLBXua9OlbU0AwvjC0qP1Ogpd7t1bWKaJIhvFlHio0HGdxlR2DCNr1f4MEsLY5ae9FEMkkihHmZBCtOjEYEawdzdxPeU7JxhV6hO/dwsYTz/9/3cnLApWkzapyLKa1cCRwk42wlxHOKr+q9j+k9dX50kkzfM+W8Gw5KSlJeXI0cO92LoZ0e8lofE663JZrWKfJWr+xTe+42qhI+qNf/SdMAo9J5vgpVgsRjbIItyRJBiTkqpgCtW4DpHmLxtF/6Hp/zhoWmE7PwOc06WFAYcd0TrRtQ5xPMpgZELFiPUil4uyZZTDlQXZE6qyXGj62e3l3OIyyVAxp5vUrO4L5jWfD3tPStk1pGY39aBC2MHhrRl86M16NHz6zTVf+JBvD1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199015)(186003)(31686004)(2906002)(86362001)(66556008)(4326008)(8676002)(36756003)(66946007)(66476007)(478600001)(110136005)(6486002)(54906003)(7416002)(6666004)(5660300002)(8936002)(41300700001)(316002)(31696002)(6506007)(6512007)(53546011)(2616005)(38100700002)(26005)(41533002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjJWdXhGdURMRUptVEo5alZxeGhaZnc3d2F5OGV2M3lIMGpHL1MxUzd5RHRs?=
 =?utf-8?B?NjNYUEMwbVFtVWZkSFNmakJJUzEyMkYwaHgrODZHNVV2d1grTGRNWWQ4RW9q?=
 =?utf-8?B?dGs1VE9JZ2ZoR3VyY3lXVTNScHdMZGZ4UUJLcW0rWTByaFFvQmZVMjFRQTd6?=
 =?utf-8?B?Yk9hY3Q4Y1dlN3JsbS9jbUxsMm1HRTM2eVBpeEozR01DUmxyaHZBdks5WS9v?=
 =?utf-8?B?eVJiNWJRVEZqcGwwY3FGWFBNZno3amZPSFVScUJmMWk1T3NFcmIxZWVCN2o2?=
 =?utf-8?B?N3VCcnk5VG5sNTZuN3BQcklxb2pMSUZXaVI4clhVZDdMeTJ6WHRtUytiR1ox?=
 =?utf-8?B?bTQva2VyNDZmc0xjQWp2eEkxdmVTcUJKakljZmczREU1Wmt6MEY0MkVUQTRO?=
 =?utf-8?B?ZHpRSjg2MFJXVFhrekZuWFZ4QUdEaDZjbFR1eC8yK2Q1NFlCRXZZZUJ1djRB?=
 =?utf-8?B?bGQ5RUtsVE9Jd20wWVQvWGFYcTBSajBEZjZ1Z0h6amF2RzlEZ29CMUVzUFVN?=
 =?utf-8?B?LzA5Q05zWTNseUlGNDNtcFNkQk11TFhkWjdtOU9GR1RmRnVuT2JvRnVNK01S?=
 =?utf-8?B?MzZpaDdKUUpHcDZyMWRBUTUrYXBaQU5DNDhrMzlUM0VIcmRHejJmOFo2Rkl3?=
 =?utf-8?B?NHorMm9lOUlEOE82ZVBSeFh5aiszTnNHMHJLbHpEVUJBOXlmd2ltSlRjNlFO?=
 =?utf-8?B?SUJ1SzQxMXA1Rjg1ZVpHV0FLZFZVVVE2L2NEUVpCc0pJWkZSdi80QTlsVytX?=
 =?utf-8?B?cU1rNS9hYnRmeFpCMVRnODdnSEpOakJFaUlLbzlzTlpFZmp4SU0rWFl4RFl6?=
 =?utf-8?B?UUp4M0doWXRBK2FIa25WVmN1MmUzSUJNeEtjMEhjQkdMZHpyN1BoS3k4Q00z?=
 =?utf-8?B?dDY2Qk1RR09rK1ZMUmlJbjVsY2wzbHlYK1N0QlJxOWpka0ZZTjBFUzVwZEEy?=
 =?utf-8?B?Vmx4djNlSDkvVHE1M2V5TVVNQzMwSDhaRlZEOEVyaGpBOGVaYVFUYTVMRGdh?=
 =?utf-8?B?T0lXc1A1WHFwU0ZxRnZIV2tyN3BYaVdKRUJIU0wvYmJCQnFBUkd5NThOdGhq?=
 =?utf-8?B?Y1cyOWtQOGowNXpXTkMrQ0dVYjk4Yk5rTk1BamxiS0FoY01wK2NodmZIdVZM?=
 =?utf-8?B?WHBvTUN3b0lMQ1dLMUhVQmlSamg2THc1YlZSRVhuWHVBZjVGVElaZVJKRyto?=
 =?utf-8?B?cmVSTWtjaVJKb05nRTdpT3htNERwN0NrVGExd1ZQZE0rTURHdFhYVEJUalNh?=
 =?utf-8?B?QzhLcmZJRDB4Y28zdTRRdVc2T29NWmI5bkFQWVRKVWhUQkNERjFLTXFmWkpv?=
 =?utf-8?B?cG45UmF1bGQvZVdyTmpNaXJmb1pqaDEwdTEzYm9lY0pTMzN1ZG81QURIdk1i?=
 =?utf-8?B?TTV2T2VnRWJzbndoRk1CNDEwT2xCYk9pM3E1Q2pBOEQ1NFZFcHdmNHE0dU5F?=
 =?utf-8?B?cEJua25DV21kOG5FOTVPVFprNHpaVkp5RDBZWERPNllwem5MMVd2SkFiRnZF?=
 =?utf-8?B?Zlgvb1dXZkFLR0NBdlFqYzlZbnEzZk9mMjZ2ZEk2WXZCaFUrYmt3LzNYUmxE?=
 =?utf-8?B?U3VFVVNUYUdzR1BrcUt6cWtmdXlDYlpSYWowa0w1Yk40YUFQakpZR0JmM0JK?=
 =?utf-8?B?TjkvTms3ak5LcXl4MmhCa0czdDhXUmpUd0cra1VKRWxvTmpGSjZDRWFtSitr?=
 =?utf-8?B?WWRDRTFsK3RlL3hENzVpbzRpYmlZSlRKMTVwSkJ5NlU0eUl4SHFETjRnSUI5?=
 =?utf-8?B?NTVBejlMQTg2V0RMRm9YMjFoc25EZU5LMTVMVjhjdmJEZ0wvQVYwQjFLbXIz?=
 =?utf-8?B?dE1IVmhDK0dQclNHNlR5cERBVzNwNk9rYTM2YkNYRUlxSmlDYUU0enduMDR1?=
 =?utf-8?B?WjUyZjZyK2orbkxHT3V5MFlNYzlWcHh3UmNpZXJ4SWl1My9EMnJjVHQwWjgw?=
 =?utf-8?B?Z3Q3YmlzeUVZWHY4VWVUU1RFeVBCakNrL3pDOVBMVjdUblY4YlJ5MmxuV04x?=
 =?utf-8?B?RGpBdW9WMGk4TDdwVFNaZDZnK085NVhLYUdzYVE5em1nK3B4QkJpTVVzb2Nn?=
 =?utf-8?B?cFJYZDR1Mlk3ZGpxTFFHcFJtMzlQZGJqZzRHdUg3Q3RKWFJjeGppc2s5YnVX?=
 =?utf-8?Q?aS/XOGqKgYb8oryred15KCsr7?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea48077b-a852-4264-c228-08dab4e9b7db
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Oct 2022 11:28:33.6982
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oJggtSiSWJwo8faSpiY7BMUaYK3cHf2k+jLS+ZdILg7po2on+Q0/aY1ddeEQlyxc
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5650
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/10/2022 17:09, Simon Horman wrote:
> From: Peng Zhang <peng.zhang@corigine.com>
>
> VF max-queue-number is the MAX num of queues which the VF has.
>
> Add new device generic parameter to configure the max-queue-number
> of the each VF to be generated dynamically.
>
> The string format is decided ad vendor specific. The suggested
> format is ...-V-W-X-Y-Z, the V represents generating V VFs that
> have 16 queues, the W represents generating W VFs that have 8
> queues, and so on, the Z represents generating Z VFs that have
> 1 queue.

Having a vendor specific string contradicts the point of having a
generic parameter, why not do it as a vendor param, or generalize the
string?

>
> For example, to configure
> * 1x VF with 128 queues
> * 1x VF with 64 queues
> * 0x VF with 32 queues
> * 0x VF with 16 queues
> * 12x VF with 8 queues
> * 2x VF with 4 queues
> * 2x VF with 2 queues
> * 0x VF with 1 queue, execute:
>
> $ devlink dev param set pci/0000:01:00.0 \
>                           name max_vf_queue value \
>                           "1-1-0-0-12-2-2-0" cmode runtime
>
> When created VF number is bigger than that is configured by this
> parameter, the extra VFs' max-queue-number is decided as vendor
> specific.
>
> If the config doesn't be set, the VFs' max-queue-number is decided
> as vendor specific.
>
> Signed-off-by: Peng Zhang <peng.zhang@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
>

Does this command have to be run before the VFs are created? What
happens to existing VFs?
