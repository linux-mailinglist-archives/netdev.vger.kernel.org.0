Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240CB538BAF
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 09:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242615AbiEaHAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 03:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiEaHAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 03:00:39 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7BD9418D
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 00:00:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VCQZk35cyBpVdW/x+KS549LFuxT5mlln2gh1tgHdKqOzGgcL+pEM7w6syT9uEX5Sxd28t6I52fUkvAzB3P+G4UIZ325VLe5sDKrvtZC+OwRIfEk0eO2mmwraAIwDoPoXUfB4mOnBLwfE7H4xxpm2ajFgQSRRL27rUWJryJ0jv1pbTkzLq99HJfAnXeuenGftJVewhpn+oZWFiFlWVgeGAJ/yPtVPV7XaBMqfpk6EajVzGqC0ijpXpQo6Kc10857mO+CgsTMVt5HB+TIbrU8eM1tcSbh7ah2vcs2x7LIGQBDWjdXwcq5yszIrXyrJxkfHmfzYnCpsk8aFqUyBJnpAnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TMvjfEzLr+ChShvbl/k47vg+vrlDJS+ulM58EKkQ9EM=;
 b=dyo068SWs70zFPKw6lAt9pIMrVBeSNP60GTlPKZqV2dkWcpX/fwV1ggocZQ8ab1rG+MBPtS2gAWirDUNneFEkdBc7eF5O29kciX/QfhSvr7WS7P5VjZTIl9OdoXLmIyXJELV9b3zFO6zoq5pfodOcScJCXcpypRmZ28e/sJ9c8S87hlgpGutuKU3cdQyrH7TByctjl9JIe6v9jZMHOvSbntfB3hZQBNBVH1JytyxIAuODJtxeArZrToaW17iBAI2gCKwPhUgYZS3wGe4R3C9C8pEF+AvKAQz3ck1wGo5qoiU6cECVibBBx0ymKSY9M0QOp7vp3O0VQEpE8s+EiP6Aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TMvjfEzLr+ChShvbl/k47vg+vrlDJS+ulM58EKkQ9EM=;
 b=JdRWnI9SC5vKoTSYloThqobUfNgfgnc3YbVGcGM0otZNNQBq25XlQxP87d+gUtYaT8eqZtK9uNPfdVgDR/65UMZUm9rD2o2oR5KndSqZq7BgykuGLczkRFepZNkDSzRupW0Aro2cKVvmNKkkTyHXk1OxvhV0LvymBkYZKvC8CkR0ubAoAWaqZ4pDGMo5v9/RcyMUoPWnpuHROnSfJYO7HeWsHU/SnrLxmm+a2p9QFAXwzlHTGg/TKurC6o13t/kxaWcvV0XCXl7mDdg7fQ7DnArJAU1nlCnxHAWN66116DslhTG9WaZL0a1MIoLg50YX2qeTBz3lHc9lnePCVoD2fA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN6PR1201MB0194.namprd12.prod.outlook.com (2603:10b6:405:59::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.13; Tue, 31 May
 2022 07:00:35 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::b133:1c18:871e:23eb%6]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 07:00:35 +0000
Message-ID: <f549f350-5d29-88af-f551-08aab261ec38@nvidia.com>
Date:   Tue, 31 May 2022 10:00:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH iproute2-next] ss: Show zerocopy sendfile status of TLS
 sockets
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Tariq Toukan <tariqt@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
References: <20220530141438.2245089-1-maximmi@nvidia.com>
 <20220530092445.5e2e79d6@hermes.local>
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
In-Reply-To: <20220530092445.5e2e79d6@hermes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0032.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:151::19) To DM4PR12MB5150.namprd12.prod.outlook.com
 (2603:10b6:5:391::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e979bbc8-bfb0-43cb-be06-08da42d34288
X-MS-TrafficTypeDiagnostic: BN6PR1201MB0194:EE_
X-Microsoft-Antispam-PRVS: <BN6PR1201MB019428E4890BDB16AC2F7BA8DCDC9@BN6PR1201MB0194.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y7wg414/+WPimqKEnd7N2Ws9tj5Sqa4s6FCIt8teSZS+S3r1CioDBZT9QNRpVmeIXymMsZHc+vOouEGy5QoESP64+Jfb7hwWcuBulf4ZcHLbqN+WApgG4VW72hNfoGFo7Rz+AGHL1zMPb/0qdaZMJHqE9okCtAfwPptUcpDuDTfQuccCSpT40dvr868FznxpS1OdPYsOI6/SbgCpsQqxJyVIXkq8KJJ0xfpXFPLu1h4s6ZlD5Hu+GZG1FnqJNIommXYFIKvJFo+7A0ip3mAv/XOFl7prBFtkhK0HtZC4yujR4IhfzXatDP8z7u5LBDrfaFNT4NzG1n0LXDKLqtgN74pUDKxGVv2eP+I9zA/9WOTHwygDVnMlVqaQTOr8H6L5g2pycff/1W22z2o4dP72haJokuu8CFyTclv57WJrGOLte2UD7AcgZz/Cxo6SGI1kycJQgyh6kcpM9iAKerYm0UQq6Ja1kOUr0xAs1dTMhNhdcTyI4540aQmv1mqGfcx2D7CLad+TNlxPRlywWmWbaLv8XQ9ZycrxxbfTqt+qIX4cJJmHvtPzme9D9/8X4ZeOA/COOcvSVTQKew+dKJYWcuSnVuK0Kf9iKOT9AD0ZvqvpxzTxQnS5cguhfSHVDb+wfHuI4Ly5oBzxmZIeK9PdCempCd+r5iXWaufH2KVXrl4AZ5/5B9cQRKcJGh4VOQ5gJer9H6yT5294OM/Xz2eHtfU3OJo5RDvavIKQZl3XlZ30pJx934GQ70/wCvwnYcH1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(66946007)(66476007)(66556008)(54906003)(8676002)(110136005)(86362001)(2616005)(8936002)(4326008)(31696002)(26005)(4744005)(316002)(6506007)(6512007)(31686004)(83380400001)(36756003)(2906002)(53546011)(5660300002)(6486002)(508600001)(6666004)(38100700002)(186003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eG5YM1NxK0l2OHJibFF2VzN6VHpQT3RZMW5LV0V0QnN5NDRYWElaU2k1Nkha?=
 =?utf-8?B?ajh4ZGo3UEdUdmw1a2hnT0tybUQxUnE4eHJJQVRFV2J4Q2Z4bzNsNWNVTmJh?=
 =?utf-8?B?Y3dUM0xjd0RPYU5BYisrTlcxRmcvendTU3lVbWM3ekxaQVdEdXkwSzNOdnVs?=
 =?utf-8?B?czFWTi9BYnM2czgxNWp4cEtQVVk2ZXo3b3lhOFErNDl4ZjJBRkN1WUpKeGEw?=
 =?utf-8?B?TThmeHJQWjdtc2w4T2JQVWVwL1BPRU52cjlsakZoaXBLM2N5eGg3MWlWMlZu?=
 =?utf-8?B?L0RndFV4S1RpQVIrd2JGRXVoeTBhZEpybVFOWnJ1b2wrVTZMQ09SbXFDRUhR?=
 =?utf-8?B?SU5tQXlMMXZ2ZmRwUjJVUVFmMFlHSEIvRGVzN0hBVEExaThLbnIzcDAxdWtm?=
 =?utf-8?B?NGVEbkxDMTFOa2xQRzVPUjFuZFJWZE5UTkdXMElyd0swK1JJaGY4NlljQmlw?=
 =?utf-8?B?TVhVQlNRSEpFelB1QXVKRW9iVktkczk0ZWpDU1pxdWdsWTQvSWlkUmN4RU1x?=
 =?utf-8?B?M2VhL2k1NzI3c2dnNEdlSGN5NEhvTXptTm0zNmhET0tUMHUrY2EzUWNUaXdC?=
 =?utf-8?B?eXZBUllOZ0RTUE5UczdsYVArTnFIbFduRVpMVUZPVEl3UEpsVzNwcGpBVHow?=
 =?utf-8?B?ejNaTlJXdGowY2F3MlgzK3c3emFkQ0srNmJ2ZXRhZFJiV0hBelpsWTRMRWln?=
 =?utf-8?B?aGlNNjhrSnVJQkN3RnlxWUtSNlBWa01JVVRiWkU1ZzdVVGExeklQb2FNcWxG?=
 =?utf-8?B?U3ExNDRpOXVoZUF3bEx4VkxPU0g2SW9jMlhYWjNlbzJpaHNXdEsxRE9xNUd0?=
 =?utf-8?B?eGFueXQrMEUzS1dYL2M2OXc5bjl6UDlpZ3RleFY1LytPV2R1Y1Z6aFBtVStz?=
 =?utf-8?B?NDNDekpvaHhBRUIyY0svdytSQ3FnR3JxR0lEb0FBUE81Qkt1RnF2VDNOZXVo?=
 =?utf-8?B?RUduMXNXd25kWXlzUDRYbEFnYm9jWjQ3R3NGOFFYelY5ODA4NmVUWkRmZDZ5?=
 =?utf-8?B?b3Z2eFVxZkJlWVJyZVlvK0QxeXBOcXVTcElPMGY5SXhRYmNpM1JEcmtTK012?=
 =?utf-8?B?WUg1aEtYdEp4cEpSLzE3UU5PbGR6Y3pJOCtEQnhYZnJXeXRHMGF4Q0R5UGtG?=
 =?utf-8?B?dXkzcmg4MGZ1ZGFjeDVHTU5WYVFFSFIyWmVTbVZxUG5RWktHR1NzV29LT2lD?=
 =?utf-8?B?SEkzUm9ld0cwbUl5REhML2lUaXJRSUU5Um5ZSUl1dVZPM1Y0aHAzbTc3bHpi?=
 =?utf-8?B?Qk8zY3pCUGlzMVBQSzdSSmlvMXd4djZXbk1FVVhzSUdFTXhDcC9VWWJOYktM?=
 =?utf-8?B?WDJ5QW5JWlFUT1k5QTdaVy84czZTU3JhR3ZjRGRSeWYxZlgyTDE3Z3RqaVcz?=
 =?utf-8?B?OEh1d3lCTWQ4TTJTeWpOUHY5VUNVRk5nbi9wMXgzYkZxRGkxOG5HSjE4NWcr?=
 =?utf-8?B?cGxiWjg4WG1yOTRjQmUwcHRWRCtFRjlSRW9zRzgxVG84OFk1dHdONTJCQ1NK?=
 =?utf-8?B?cFJwWGh3bVZCc3Q0VWFXOWZSNnZ4c3BSakpQSXordVJzRGc0eFhrT2I2a3I3?=
 =?utf-8?B?L1pxcXBVWnExZk1YbHhucEttOFA4RGRBdzd5WU5TOHBXWWUyRnMxcnpldmdV?=
 =?utf-8?B?YXlhWWIveXRmUGo3UThVTjJtQVN5WTRtMXgzczBkUVBUbmhJUGNxVC95SmFM?=
 =?utf-8?B?QWhWM2dsTEs0RmtnMmorS2F0TlEzN0ZkbWJ2b2xMK1krZ2dwQ2V1aUdjNDRh?=
 =?utf-8?B?UEdTR0RBaUNPMGN2WGJtaEZ0RmpWMXhHa1hEdFBrWlk3bXJiL2c5TWthQllO?=
 =?utf-8?B?WUk2WEdabTVuelVUeFNFaWVybmxPc2U3SzYwbFJoUGFqb2JwMUZ5dzFNakVl?=
 =?utf-8?B?Ym5DZ3hCeEM3STB6VHNWdWxvQktHZjRUS2VKTVNEekV1dnlJWEdRSFp6K0lZ?=
 =?utf-8?B?V21kY2Q4dFAyL1REMEdBdUtMUXpmQ0VONzlmcENuNFlkL0ZNc2h4alVtVXAx?=
 =?utf-8?B?bmIyOENSa2VDVW93UmJqQW1JQ1dyb2FEa282Z0RybGRBZEhuanVMRzZsS1RQ?=
 =?utf-8?B?VVlwOHR2UGJ6NXJDRDRjVmkrRGYxUm1MRVNlanlzRFZBN0JiTGh4RDBIS1JP?=
 =?utf-8?B?Q2tSMUpmbUhPTmYzRmwwSG44cmlyanYrRjFyQ0cvRkMrS2Z2K0xvNjlCTnpB?=
 =?utf-8?B?aDBKWXh2UjZ1RlBmTFBOU1hNWXVWV0QzM3gwOGh3N3NPYWR6RmpXb3FpYlV5?=
 =?utf-8?B?SVJLbS9WaCtvOS9QbnhONjNsQksyZGJKc0FhZlJEM25VdVllUEcrL0IrSzNL?=
 =?utf-8?B?ei9tYVlhSkgxeXljaDk4ZHNNOWdFZ0VrUE1JcFdiWmkyU2YrZGcxdz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e979bbc8-bfb0-43cb-be06-08da42d34288
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 07:00:35.0948
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JCksQcJPW2gxFBBmcUG06lsumHP56epcS9C34s/9onF4u4KZ7w04ZWIv437FeIsJBrejgeHoZSKi+q7LzIY9tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0194
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-05-30 19:24, Stephen Hemminger wrote:
> On Mon, 30 May 2022 17:14:38 +0300
> Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> 
>> +static void tcp_tls_zc_sendfile(struct rtattr *attr)
>> +{
>> +	out(" zerocopy_sendfile: %s", attr ? "active" : "inactive");
>> +}
> 
> I would prefer a shorter output just adding "zc_sendfile" if present and nothing
> if not present. That is how other optns like ecn, ecnseen, etc work.

I see David merged the patch as is to net-next, despite the comments. 
Should I still make the requested change? If yes, should I submit it as 
a v2 or as a next patch on top of this one?

> At some point ss needs conversion to json but that will take days of work.

