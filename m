Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 321C75EF7F4
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 16:46:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235052AbiI2OqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 10:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbiI2OqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 10:46:16 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2077.outbound.protection.outlook.com [40.107.244.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9ED1121114
        for <netdev@vger.kernel.org>; Thu, 29 Sep 2022 07:46:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6bEOXeiGS1WZZ0FxkC3AZrHTLgddQdDI3QcpdH9UEowV6jJWkms18yUIZAH9UJGrbjxZcnGTWCNUAIsj6O6GabH27at52SPbYlYxacCqzGvdMk45nf4TFpatZwlQzTJY0a+vtnZKXlgW6NQrxqek9ZlHNUs0WoGfoRyM2g19rKFdQdRZ0ZWFsQ2U0/Wud6djzcJQ3vP+gw1paEH/NZ8FenAjExV64QRFkEpZG+W7d/nA/5ADG6uNJnShVgN887NoBgF2e4p/q2VTKZ9LjkYGoKCZuh4M3tw7vbGx0pxxoNsnsWMVKKSPHaBklZVHHduw69Hc5bPG0T4gsqb0WkBxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TyUNql+Mut2Zr5aGmYJUUKsuqshhdqU7ZrPQ/wFr67g=;
 b=S2DLgw8xEktH0KDf6JCnHbMjE0So3hZ5397U8mHHWXz+yGUT0L/nbo9O8mgvTov4yDenzbjwM0l9YrBcta83MT9qXCrO7iLvWhcLqNDKycd1lAgVUqUXouxhWV+ZBCbBXV6zo5zy3hkRGEjxqaCnUPzo2MGID4aj3kaj8b0/QLZzcWP4/a8WbGcEujQeqy+U0f0MlJJlPz/s8DNOs7hCCBynvlCek0AhSLcJflaJpm9efY/FY5Qn5RLgm2JZisoIaSHPsFYrgF/j+5Qif7wHJi1yxAc2JqzpK39Ppl8ES1fYW1QYQKREr4hfUEGodLu/pQyRKTy1XQngkJwi1RNjpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TyUNql+Mut2Zr5aGmYJUUKsuqshhdqU7ZrPQ/wFr67g=;
 b=dFLvsTg1lKrCGibBXtvlgzPztzLTA/tdXo57a6Fq6C4bLN8qEyHx59iDv6JaGH1rJ30wQZn2/GrQAPOYxg+ydR5htfxCmOf/oAgkG1yhIypg9mR/q6u0ZhBVHsrjp4J7APcwspORh8YIuIyzOubvkvbqS/Kmv3RccJUT3rJDP0tCszNvvpiesB7Z/2HfVQ5cE7hZzpTdNWG6aelpt2z1Q27cB8ih/4so+7Rw6s7n2TaE4WhsE/9k1eCPYp+G5MOu28MgTYpbLV2ceqYxKPFkbbicD+7sCdnuYdbySzPnM3RGJlQ5VaynxTMtVYCqHEskhM5wQcOSUBjPprK7khFhhw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 IA1PR12MB6330.namprd12.prod.outlook.com (2603:10b6:208:3e4::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Thu, 29 Sep
 2022 14:46:12 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c45:abca:a9fc:6fd7]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::c45:abca:a9fc:6fd7%5]) with mapi id 15.20.5676.020; Thu, 29 Sep 2022
 14:46:12 +0000
Message-ID: <6f6f4487-1c5d-de4e-0c79-452128deae0c@nvidia.com>
Date:   Thu, 29 Sep 2022 17:46:04 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH v1 0/4] Add support for DMA timestamp for non-PTP packets
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>
Cc:     "intel-wired-lan@osuosl.org" <intel-wired-lan@osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
        "Ahmad Tarmizi, Noor Azura" <noor.azura.ahmad.tarmizi@intel.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>
References: <20220927130656.32567-1-muhammad.husaini.zulkifli@intel.com>
 <20220927170919.3a1dbcc3@kernel.org>
 <SJ1PR11MB6180CAE122C465AB7CB58B1BB8579@SJ1PR11MB6180.namprd11.prod.outlook.com>
 <20220929065615.0a717655@kernel.org>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <20220929065615.0a717655@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO6P123CA0016.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:313::6) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR12MB6288:EE_|IA1PR12MB6330:EE_
X-MS-Office365-Filtering-Correlation-Id: 2202e5b2-3881-460b-ec9b-08daa2295a73
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QeEZHaNJxn+ew5WEwEfwtS/NWQ5ghfSU+UeurtfeyYUea4JNzlR7wCHZHozCIgukn5yljkEKXP/vP01xkYMxTx50nvs4c7FTXLClg9FJeZU4C3GNQLHSncQyU5mYjDyMy7v6vBPnEzMbm/1xL86+WL3f09a5UTTESuGRYpOshu4f91tF4jKlTNrygXVJe8q8oshbm5e3vlFw/CoTHJAfbMynYCo20VkPM0Uo13c3+y/dlyTxjj+ZYGgKHOo9tbgWXI6w+lkb+rh6LdLAWe5EaHEw/jhwESqwLWkrbCDPxP/m75EiDNL3tPcZGOgml8+YGTby0hsEbS38IruA+ZB3o6bNTgCAWj0q32FiEbnvz+Zg1xqqroupGeFBvjqdDK/QDZ7jivB5T+RT69sRPlMiXaZT6kJEKxP66MuNuIF934D/dYFsYoltXaMYMAEDJ0QC73nWYDyxjSFSEEPuLDFc+HWI34gbb3hZfFyU4vIaAMAcpWrk2b64/5pYJSFXRvloog3wa9UkcwGmipnO4x3xJ7Q7S0FbC/xMFIe07TpgQXuz4S8HHjIUouUD1Ak1DhNJyyZFXfHvK80JwvHzUQ8w3DlOvqN22lOiu3SvILken9aqnpbvbGnO52pjSgZ1mXpyikLrPbfwZN/IvJGnzkMzohZgQPNWoUnGgvNMronvxWSQWK5C6kzaLNKl5avAwdmrfgp39KxpJYWkGRYkFMV2uRxGKuJ5w0zp7FfufsUx9U73kBE9RGh5ykpT8MloX/tkrdZkzua3ZhM4fwWywvdCt84YYSZDNK8fWqcVPGBZ0A0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199015)(8676002)(2616005)(66476007)(26005)(6512007)(41300700001)(86362001)(4326008)(66946007)(66556008)(36756003)(7416002)(186003)(31696002)(5660300002)(8936002)(2906002)(6666004)(83380400001)(478600001)(38100700002)(6486002)(316002)(53546011)(6506007)(110136005)(31686004)(54906003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NkRaVXRmMXBxci84VFMwQkZSZzBCU00xODJIa3MzM1lsc0F4QU1IajB0Q1RI?=
 =?utf-8?B?SW1ZSzVmZ0ZJelJhWTZnemdEM1Noc2NJOGhjOVQrTzJXS2FJbTRDaDV5d0FH?=
 =?utf-8?B?MUFwZlRWRktGa1lsb2ZPWER0YkNHMU9IVTZHbmZNeFZTRDljalVJa2hiaHdj?=
 =?utf-8?B?QldwT3JONkhBbU9waUttbkRxUGwxemI0Y21iRGNQdWU3VXMwTTBVRWpiZDJU?=
 =?utf-8?B?SDNkWFNXU2VkNU5xL2V0M3JWTUF2UDcxK080ZmRkNW5GeUlLOE5waUQ2MTZj?=
 =?utf-8?B?dW8yUVQ3UjAvTFBZd1RNZFMrbHRGWFdacDNoSjc2VktDRDBIVXVkLzhYK0tx?=
 =?utf-8?B?NmZHQmcwM0VBRnZLai9TbU5Ea2trbE1GZDh3UjFnYnp1R2hVS1REZzI4U0tT?=
 =?utf-8?B?dzNLcFpndW5OcEhqVWR6VE1rQnlYM3gwUWJqcVNUV1NGaEtHZ1VTNDJhbTBB?=
 =?utf-8?B?SnpZdnMrQWd2ZGcrbERFcnpqbHNiNC9yN1F2bkxqeWpyQ2MvbFNZVy9BbjNr?=
 =?utf-8?B?YWdIMk5pZVR4TmQ3ekRMb1VUQm03TGdobUplaFYzOThlS1ZCWHdDdFk0bml6?=
 =?utf-8?B?bDJiNzlkTHhad3REbDJtRlI5TmFOaE9vTDlCWThsNlNqbjlnaGxoZS9GL0Zy?=
 =?utf-8?B?RzhWdkc4Q3MrVk1XRmpUenk4dklRTHgzVGwxbG85clNod0pCU1dweTROSko5?=
 =?utf-8?B?Ti9lTWc3dmE3SzJQcmE1dHZTMEtZRHc0M1I5T0VsalF6eWFqRzB3endTR3BE?=
 =?utf-8?B?MEMzYWNFVjFXMEhnR283b0JLZzd6SEJVajZTRnoxMWVrZXBVNG9jU1lXMnJR?=
 =?utf-8?B?d1JOcUE0dkxaSVJ0eThyRCtieC9mQUZnNDgvUFpncStQZXVGeGUwQWZzVEhv?=
 =?utf-8?B?Zmx2YkdLaHk4TkY1M0xqSDBTOEgzTVYxcGUwYjJTVjFNQ0ZSNmM1cVJQZ0RT?=
 =?utf-8?B?eEFkWDBZZG5JYk84Ky94QXE1SFVKdVNHOWNvSjlSSFBRWnVQUFNpNENvb2Rl?=
 =?utf-8?B?Ny80TGMzdEtjNzA3bk5TTlVLMDNmUU1peEpHaDFCbEZrODAxc1VXcVd5QUFp?=
 =?utf-8?B?cTUwR3l3dWdIcUtQNjB3NDN0QklWQUVRd2VtUExueFZRd3c3Ykc0ZUI1SGlM?=
 =?utf-8?B?a2w5dVEzWHZiUHY1Z0dKT2VQZWtsR0kwVjVqNDVFdDZxQm9ueUpUZ3VEMmpj?=
 =?utf-8?B?RDdmWUZMbXo0LzVxYUErTEJnTWJOeUhYN0lBUEN6eVJITk5jT0FYZExYMFFp?=
 =?utf-8?B?Yno0U1loWHpMYWQ0bzZjRWFDVlE3VUI0Vm1TZ0tKM3h1Y2VyaUJnUFI0L3Q0?=
 =?utf-8?B?bnk1dmU4YjkyNUU5YnMvbnZxbDl1RWoxc0lQNnhENnB0MHJKKzFvVlZsNDJn?=
 =?utf-8?B?alZ0aHc3dHNvbjNIRGVHN2JjV1Y4cTNOS2hCcCtyZ1BMOE9iYUhsN1o3a2Z6?=
 =?utf-8?B?T2NEMTYxcStFdDRLUVJ2UlNXSGJadjlJRmh4cUEvWHMxNXFxdDBMR1p1eHZQ?=
 =?utf-8?B?Z1FZemxEYzhxL0VKNFFtcEJ6ZTZNdWw4aTFnZlZyRjlrcVZkV2JkRjlMVW5t?=
 =?utf-8?B?aUtXMWJEb2VjSkFLYU1Tb0tIdElsTUJ4TXJQZncrekw0V1ZIQTJBL1FqRHZl?=
 =?utf-8?B?MklXUTEzUzkzWmJvY1FMVmpRcU9LdXdiS1M2MytDYnNXNlpwTkJlZzEvSGNR?=
 =?utf-8?B?TmhxelExR1BGK3p0MEI2QU9RUWZNU2xFYkc2UWdnUE9UeUpSWUx0eENEWG1i?=
 =?utf-8?B?UURrMmMwM0RVS255YmQzS0NaUVFtSngwWFVJLzBsbmZiMTV5WllZdmJrMDls?=
 =?utf-8?B?R0s4NzNyT294SUdUdi9TLzVMZzNZRHZOM0ROYkFiMGFGL255bndiQndXOTJi?=
 =?utf-8?B?bnI1NStJK1lFLzVZLzc2Rmt6QVh1b3JHYWFQTEtheFpTaGhSNG4zQUxtRHYy?=
 =?utf-8?B?ODlWSUsyQXVOOC9nSTFsanFrMFFadWNYakRkd0dOa2xZY3lET0l5RFduWUdt?=
 =?utf-8?B?QTJrQkhndDAxVVFkenozR1k0NXZnSFNpVGJPSTZMeVo2MkpjYmEwdXpXY01n?=
 =?utf-8?B?RnI0emNYYXVUZ25ocnhaOTUxYys2V1Z2MjhCTDkrOUtXZHNXQ2piSkxva085?=
 =?utf-8?Q?un9CX2w8b0UfHot1ZW9f4MHLF?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2202e5b2-3881-460b-ec9b-08daa2295a73
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2022 14:46:12.4844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jwaFsoLcvubhj86icES8vPvmBKDMxYH4G36Q7IxSKWcAbxw2brQR6s+94GevMCk5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB6330
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/09/2022 16:56, Jakub Kicinski wrote:
> On Thu, 29 Sep 2022 02:35:29 +0000 Zulkifli, Muhammad Husaini wrote:
>>> High level tho, are we assuming that the existing HW timestamps are always
>>> PTP-quality, i.e. captured when SFD crosses the RS layer, or whatnot? I'm
>>> afraid some NICs already report PCI stamps as the HW ones.  
>> Yes. HW timestamps always can be assume equivalent to PTP quality.
>> Could you provide additional information regarding SFD crosses the RS layer?
> I mean true PTP timestamps, rather than captured somewhere in the NIC
> pipeline or at the DMA engine.
>
>> According to what I observed, The HW Timestamps will be requested if the application side 
>> specifies tx type = HWTSTAMP TX ON and timestamping flags = SOF TIMESTAMPING TX HARDWARE.
>> So it depends on how the application used it.
>>
>>> So the existing HW stamps are conceptually of "any" type, if we want to be
>>> 100% sure NIC actually stamps at the PHY we'd need another tx_type to
>>> express that.  
>> Yes, you're right. Are you suggesting that we add a new tx_type to specify
>> Only MAC/PHY timestamp ? Ex. HWTSTAMP_TX_PHY/MAC_ON.
> Perhaps we can call them HWTSTAMP_TX_PTP_* ? Was the general time
> stamping requirement specified in IEEE 1588 or 802.1 (AS?)? 
>
> Both MAC and PHY can provide the time stamps IIUC, so picking one of
> those will not be entirely fortunate. In fact perhaps embedded folks
> will use this opportunity to disambiguate the two..
>
>> Sorry about the naming here. Just so you know, the DMA timestamp does not
>> quite match the PTP's level timestamping. The DMA timestamp will be capture when
>> DMA request to fetch the data from the memory. 
>>
>>> Same story on the Rx - what do you plan to do there? We'll need to configure
>>> the filters per type, but that's likely to mean two new filters, because the
>>> current one gives no guarantee.  
>> Current I225 HW only allow to retrieve the dma time for TX packets only. 
>> So as of now based on our HW, on RX side we just requesting rx filter to timestamps any incoming packets.
>> We always allocating additional bytes in the packet buffer for the receive packets for timestamp. 
>> It is a 1588 PTP level kind of timestamping accuracy here.
> I see. I think datacenter NICs can provide DMA stamps for Rx as well.
> Intel, Mellanox, Broadcom folks, could you confirm if your NIC can do Rx
> DMA stamps?

What exactly do you mean by DMA stamps?

Our NIC supports two modes of operation (both TX/RX):
- CQE timestamp (I think that's what you call DMA timestamp), where the
timestamp is written when the completion is being written/generated.
- Port timestamp (MAC timestamp), where the timstamp is written when the
packet is being sent to the wire, or received from the wire. This
doesn't account for the time the packet spent inside the NIC pipeline.

So I believe the answer to your question is yes :).
