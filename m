Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D33014970D1
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 10:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbiAWJyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 04:54:07 -0500
Received: from mail-mw2nam12on2065.outbound.protection.outlook.com ([40.107.244.65]:19905
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232476AbiAWJyG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Jan 2022 04:54:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TMC/FyXtej2AL8zT2ElzleWvmyMliCYmagwSd1I3XhR++iK/7QWsGEOkp/rimKLCOjTTJ5xURlZ3jBH+fFSFuViSrr3HUGZbNgFA8qTQ503S3Fg6sWC0Dtqfj8S6k4LJ+E1ksyU3bc/NY7YttcLw9io8DzbPd+LBev7Nxfll/FTDWGacYbBxeYSO31IbTOYqOhKcA7dCoeQZp4vF6ycgAlKSugocyC65u1EYiahPV06RWDvMFKPMd/3ady3u0cJpVRwE+cSTzvb3Q187yhc8nLTdVzm6R1OrwxNWA33smIMVgf9H8fM67N8ez5yvhjnK1rVCF8I5pXp4b9Ysi68rjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0l6tX23KKncu0Qhsypi+zCcZNmoPkBNJcE1ENyVwpi4=;
 b=Q9/OpDCUEEtVSUCRVq/uB3J5UG1/7eXml7RDlH5BriciihKMK8w3veGSbtjatgX/GS+A8uPRihG1vIwS4oUrRHEk/IGIs6aFBBTW/xbczosBDsQAu5548RJp20RFkjJw1tDKyf5mtBD+ZUOoQV/vGREb32RfN2nz/gUfZdjiztkmYHFZRMlAGLwDAYwt6dYK/2jYoIhpQw9uU3839W4EVfdMZItc3xdZbmgOF4I5iq9IrGV9q1T89uxZ/M0yleDO5Kgx8tMPFNzrwtQ3e2MmFXYqt+s1LW/UcghNKCdR4ZSGeX5qlTLcq3iVstRlXfxYWh0glp7Om62Xf6++a1qepw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0l6tX23KKncu0Qhsypi+zCcZNmoPkBNJcE1ENyVwpi4=;
 b=Rumz3XKpXqMxMoGg7tWLPVY/rJ/NHaY6o9kNxeCvH1XJ7Yc9nzbXgxd3nQDyLDO+drTXDwHvPfO8vm05Dwd8p1xCEFI/PJVVnk4VIq8Zmy13kjEomiLP1uSkxeTtgzGB62jOFjGpxk/e60K8B+vi9TQmG1GC2bH/SVSKQT83zix+XaOOAgeL1y1FXlK8BLdGzjHDadwSVC1CE2jGnL6n525hWS69k8MIG1qwm3xSNQ6iw1mInRDLOVMsngREQ5/nNdi/65y1CtrzcK4B46pJb6ggDBBsdZyYM/+yDp84ULoQty+X8uxjnqUfnUNHAExVtU4xU6r8zIL7iXqIyLLqRQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BY5PR12MB4227.namprd12.prod.outlook.com (2603:10b6:a03:206::21)
 by BN6PR12MB1265.namprd12.prod.outlook.com (2603:10b6:404:1d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.7; Sun, 23 Jan
 2022 09:54:03 +0000
Received: from BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::84ac:492:8d54:da88]) by BY5PR12MB4227.namprd12.prod.outlook.com
 ([fe80::84ac:492:8d54:da88%5]) with mapi id 15.20.4909.017; Sun, 23 Jan 2022
 09:54:03 +0000
Message-ID: <07b30fd5-1d43-063b-0f5d-abba1806b492@nvidia.com>
Date:   Sun, 23 Jan 2022 11:53:54 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net 2/2] net: Flush deferred skb free on socket destroy
Content-Language: en-US
To:     Heiko Carstens <hca@linux.ibm.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
References: <20220117092733.6627-1-gal@nvidia.com>
 <20220117092733.6627-3-gal@nvidia.com> <Ye0k+Z9nD4JY0OMd@osiris>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <Ye0k+Z9nD4JY0OMd@osiris>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS8PR04CA0126.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::11) To BY5PR12MB4227.namprd12.prod.outlook.com
 (2603:10b6:a03:206::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 09fd2fb4-fd30-49d3-59b3-08d9de56494b
X-MS-TrafficTypeDiagnostic: BN6PR12MB1265:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB1265EC0EC2CD352DD920CF96C25D9@BN6PR12MB1265.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /HLlKi60ch01lUosCfQmYAvUbXkR2vBL2vSmlgfVk6Ihvn9LnF7q4q/HQr4gWqw0mSfle5FzVG/8eVxSvB83i8kWxgRvavWS7wWL0QamslNEPu6xdCPfoDMSy5iYrtuhwzxt3cpqQAraF3TbvCNp9Psh79QYMY8BwG3/bivh9kUchbsLqlk/TDSNnjafRnRi8UaNqgk77fB1pHKUvP6y9ytUB6lv4buGYLi6JusDRUfqw+s50Qa11cSixkGVv9Zf+adFBYagr1HkEaY1XkJRtkzDTCULa4bkJmOAijNCXhWlQ/K4DsRUuk5xcinQ8ERuS4h8jWFrnRAy1laGRgD7IDR0P8J8IpgAbfiS1bRJbGFN5wACCYa2o/f2f5WWkKW+J9W82UT6zc+tYRWhtwSO2nBuKVxJqXvwSoX5l9znb7q44SrtwngtXtyF5f8IiEAaGjwia70v3ykHyJLDHjENkulkBS0Ia9zndDH1Bc56dxMiyspfXlvaTCBGeJ3P8yc/kRP6rMt2xLC5DeLk6xHDMHZkqgFlY/hUA6XR/IkVdZAgJhszNNs/ZDcnKlIf6+LiWusq+6krRyfkC2IkzJHt1/c8PXLh11ntQiS+el4WujXe1E9/hk8k2dd7j+7WTHsmP+4A+Eo4Wp7PpEsF8ZBCF+npoa82Ty8raZ/nBU4p/mK4bKJCZvpb4Snre8bvKhXe5C5CStPXEBg72u5+VJMPjTXXuWaVBd/EqeAWyzp/vlmKURpVFZYCcnm7/9KG4oq6gJ5FI05Hcn06poY19FnbutasAxiFjzHt9Vc+g//rEynuxou4iaPCsZzBkTIb6CHC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4227.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(316002)(66476007)(508600001)(4326008)(38100700002)(2616005)(66556008)(2906002)(6916009)(54906003)(6666004)(31686004)(83380400001)(8676002)(966005)(8936002)(5660300002)(186003)(66946007)(6486002)(86362001)(26005)(31696002)(107886003)(6506007)(53546011)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bjQ1ZXI1RXk0MFRRaGIrQjBIQlVxVHNjQ3QwV1ZPeW4rUlpSUFQzS0dMVlFk?=
 =?utf-8?B?SFJvbjBPWWdTcnBvMHNyUG4zM3Y3NmVFV1Erb0NJTm5WazZBNGFDQTNQbzVr?=
 =?utf-8?B?Z2t3WjV0aXVndHh5NTRaWnpBYkFtODRWUWJoWk5KUXM3Sm5OYUFJK1hxWjg3?=
 =?utf-8?B?Wm5mR25rRGpTQmVKcXZBVENXNHFBcFFyS3RVUVF5c095RDUwQTBpQWxSRVd4?=
 =?utf-8?B?U2FXcHJqY0FOWVNzL1RzRGNudnNzSnNxRVB4YThZNzB3Qk9FaGRmWlhETVdK?=
 =?utf-8?B?UzdrNEcyKytrRzcyTEcwdlZsSzhBRk5oSVkva1ZJZWtTZitUcUhoUTkxd0R3?=
 =?utf-8?B?cm5ZVm5FRmhsdmphSmI0aDlGSzlaaGJDSmdua1F1MjFmVi9jcHZ6dUxsMk1Z?=
 =?utf-8?B?WWRlV0lQM2xnR25taUVHbEQ0WFRFQWsvRTBkSDlYZTBhTzMxallBVWpNY09O?=
 =?utf-8?B?Vncyb0dkSUkwWGVlM211MlMzVC9kL252cm4ydE03dCt6c2R5OTIvRlJpcEtu?=
 =?utf-8?B?U0NKejBRQU5keE9PdkRBaWFqK2Z3ZnplRDd0b042MHVXdnhaN3lQZXhrdmha?=
 =?utf-8?B?MUdGY3h0NXZ5WklOZXhZRnJoQStYOVYyOThVMC9NSU9yZTc0Nk52Q004V0Nh?=
 =?utf-8?B?OFBkNnNhb2k1eW5ZeFo2YTB6QWlzeElUb1h4WnA5dk1uTUlQb1VJLzlnamIw?=
 =?utf-8?B?SjJmWFZ4eS9nMWlwZnlGbDZhWkpKOEdxWjBOZVJnY09HbUV3UzFHNjJYRW9M?=
 =?utf-8?B?ek1nZEFBdTJpNEdQeWtrS1hWUkdEby9PT2F4Q1ZBb0x2N28rSlAyRWtZSkFH?=
 =?utf-8?B?V0pNK0RWcTdobUp6ODNQcC9tNGVGQmJCRW05My91ejNTZklkVDV4L3U3amRI?=
 =?utf-8?B?VnY5SHR6SUtqeGU2TnNWcmYyeHgxeHMrVGhtQmJsZUVOQTlUbjhJbWlRTmxW?=
 =?utf-8?B?WmFPa21ndmhDU2xEeVlUVWdNeS9LcGg1ayswS2l2clpjQ2JRamRZcDVCL1FI?=
 =?utf-8?B?aU05RmxyTUJhYVYvZzduTU43MFpGazhNaUxVenFoWmg2U3d0bUYydC9KNUt5?=
 =?utf-8?B?SjZwNlk3SlRrSWhVRHY1UTVrdXo4UWl1RnBMRUs4RlBIckJlcGl5VnRERk5M?=
 =?utf-8?B?S2tjbER1Q04rNTN1YVpPc0phdUtURkFMMDB5WFJyK3Y0ejNRUkhXOWVrMERQ?=
 =?utf-8?B?R3EwRmYyQ3RKelBpdG1ycUQ5VkRtcWFBYmZLbkRzdG9Wbm80NHFRc05SVnhY?=
 =?utf-8?B?MGxsSHlmV0Z1YlAzd1VlSU5YVUQreWhIdVp3eDRmdjdROUpKVEt6M25KSDg4?=
 =?utf-8?B?VVNTMzVsK00yRlAzTTFmVGUwendNem1WcmdubzByVzdoVEtsMkpqeDZEeTI5?=
 =?utf-8?B?cjgrTkVaV0lETDJPbFVzSGtaQWxtMldSTDN6Z29SVWxkUEpzcHdSWlBhakdU?=
 =?utf-8?B?dUkrWThaU0hqNU1jek5MT3I2ZHVEcGg4U0tyT2R1SmRaNzZFWFhFSmxIUkZh?=
 =?utf-8?B?ek02S2psN3RteGhUSnBocm5VaEU4R1VwQnlSYm5HbkU2MTAwOEZuN3VtcStt?=
 =?utf-8?B?QWF3SVlaVHZHbWpDckhEQjRTMi9ESTQrbENVS2Q2Ni9XMUdiV3dtdTM1ODVS?=
 =?utf-8?B?MHl0b1J0VEs3QzVRWXg5dTlZK3pkNlg4ODdodC83ZytabUlYNHJDOHpMbXA4?=
 =?utf-8?B?YUtsaFBiMGlETmhzVEpqZGZyeUhQbUxpMTNCMEphc1ZIMmdtVldnT2c1OHAz?=
 =?utf-8?B?MWRmcEFHOEVnNXpoTDFkS0psd1RRKzZiUXJ0ckpOdmIrK1ErZ1NoS3cwaTZw?=
 =?utf-8?B?a3dSRFdvbHZ4Z1g3T3ZlQXFiWmZEOUdhbC9JMUpjbnlxTXZrcUVOY2hFRFFN?=
 =?utf-8?B?TzhBYVViY0lFdDJOeFFad0ZZWSsvYzhXVitBdE52MDFVWmVqaHVaaklhbmdO?=
 =?utf-8?B?Q3V4eVA4eTFqbmVnTVFwM2tzUlA2M2loZUZSeHdPd2FQVTZSU1AvcHZBTDZp?=
 =?utf-8?B?clJxcXRDem1qeFozQ1lCVnBhS0ovTjdXYmpaL0lJNndyeWR3cTJvTkF5ald6?=
 =?utf-8?B?dFB1TDFuaFdhV1pFSWFNTGlUR2VLK1lvYUJIVlRWVE5raVc5T0pjbnVHOWZo?=
 =?utf-8?Q?mazM=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 09fd2fb4-fd30-49d3-59b3-08d9de56494b
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4227.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2022 09:54:03.0676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ru3/mYL7sDwA9/MpPcLp6NDPhS303O7QkXpcFXv1U5e8E14vG+Sa/YHkUP3A5wFB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1265
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/01/2022 11:50, Heiko Carstens wrote:
> On Mon, Jan 17, 2022 at 11:27:33AM +0200, Gal Pressman wrote:
>> The cited Fixes patch moved to a deferred skb approach where the skbs
>> are not freed immediately under the socket lock.  Add a WARN_ON_ONCE()
>> to verify the deferred list is empty on socket destroy, and empty it to
>> prevent potential memory leaks.
>>
>> Fixes: f35f821935d8 ("tcp: defer skb freeing after socket lock is released")
>> Signed-off-by: Gal Pressman <gal@nvidia.com>
>> ---
>>  net/core/sock.c | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/net/core/sock.c b/net/core/sock.c
>> index f32ec08a0c37..4ff806d71921 100644
>> --- a/net/core/sock.c
>> +++ b/net/core/sock.c
>> @@ -2049,6 +2049,9 @@ void sk_destruct(struct sock *sk)
>>  {
>>  	bool use_call_rcu = sock_flag(sk, SOCK_RCU_FREE);
>>  
>> +	WARN_ON_ONCE(!llist_empty(&sk->defer_list));
>> +	sk_defer_free_flush(sk);
>> +
> This leads to a link error if CONFIG_INET is not set:
>
> s390x-11.2.0-ld: net/core/sock.o: in function `sk_defer_free_flush':
> linux/./include/net/tcp.h:1378: undefined reference to `__sk_defer_free_flush'
> make: *** [Makefile:1155: vmlinux] Error 1

Thanks, it is fixed in:

https://lore.kernel.org/netdev/20220120123440.9088-1-gal@nvidia.com/

