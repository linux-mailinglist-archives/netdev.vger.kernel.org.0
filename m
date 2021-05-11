Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF9B37AC45
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 18:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231774AbhEKQrb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 12:47:31 -0400
Received: from mail-vi1eur05on2070.outbound.protection.outlook.com ([40.107.21.70]:53344
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231769AbhEKQra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 12:47:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lpflBCX3GsVZNaVt1ev6yULJkyoDpQTKAhTm6hkG3JiNGg/OV+egqNxZ02B7YF7tej7a4e0aDzJsVEvFHcxYE7/JsKJ2mfDnTCPYfcpmVjg65r3ySe02eOhbh8U05AQ9ew/lM+nJd6zmKEmfkfl5KQtbPFKb99s+bWIt5G4WOHyY09vTS4UnWeJaWfekzPNqpDhRseSEx1GkalH3MrdTGIssHRleOErZIBWCcT+i6YEQmiJGP9gIUa0gC89d4mQE2nqUjYkFaekp8bQTaTPbpXPKmKnZXBk/ZeYujizdFMuP30kv+M5eiZ37jR3XHJXSVkHF0dk25asPseuofwIelA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yEf/R/anKjWwf8Otm7B+8FsnUW3KAWZPt8CdcrxA/hg=;
 b=AxgaujfIATIR6iTupL/AlVQ/eaXK/OFXqxCiB+j2+h9lVpy5zH+bEp6e5dCAGjC9T0mQuee3+Z6niK8VHBDgsqIimAWu0JgKle3PvLFLmQ9T9+qJrasWNUpb6xYav7OJfgGhvY6oH63F3jcerNDWQjjvRZHTC2TCuZ7J5FMEyXNFfbqmNroNaHAzCjSaffPuE6yfv8wIyq63ve64drOTJ8sBkKPLKtA8FEaF2AXC7O/8zE6snbtP7TelzFf2IsfdfAawoYxk0IQJw/ylquxZZU10fseCUgxarOBZRKnxRAG17cRz41DwSiYwrZQk0/jnnWQNDHgtvqbFBEwLGmW1zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yEf/R/anKjWwf8Otm7B+8FsnUW3KAWZPt8CdcrxA/hg=;
 b=goqoyYZmkhxPEeIbZKrmS5jmxAGstYKUeZ4617Aj1i1iJSVm7RViccu4qCO8L7P/U0Fdg0GqKWly1cWBRiTIl158phd0nt3CNy2Jd+3N+s+q4A7+gK5+WsLygmeiMv/relEqEU/pUgR/78HGNAQjg6bD4GSBvWwASkID4+TrOpU=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by DU2PR04MB8904.eurprd04.prod.outlook.com (2603:10a6:10:2e3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 16:46:20 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::88ab:35ac:f0f5:2387%6]) with mapi id 15.20.4129.025; Tue, 11 May 2021
 16:46:18 +0000
Subject: Re: [RFC PATCH net-next v1 0/2] Threaded NAPI configurability
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>, netdev@vger.kernel.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>
References: <20210506172021.7327-1-yannick.vignon@oss.nxp.com>
 <20210506151837.27373dc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
Message-ID: <aab2fda9-b838-e367-75ef-3a0e13d066b3@oss.nxp.com>
Date:   Tue, 11 May 2021 18:46:16 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210506151837.27373dc3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.210.25.135]
X-ClientProxiedBy: AM0PR02CA0020.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::33) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.18.89] (109.210.25.135) by AM0PR02CA0020.eurprd02.prod.outlook.com (2603:10a6:208:3e::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Tue, 11 May 2021 16:46:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce90965a-5030-495d-1555-08d9149c4ce0
X-MS-TrafficTypeDiagnostic: DU2PR04MB8904:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB89047223A1C9F515DAAF49FBD2539@DU2PR04MB8904.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eT7YklUh1bivglFzGTm/XgB5eI1Z55z9P/oQ1MatooRzLn/jVfnAQUyEvmKKnBJacZE/gs1Pqcvvd0X2AFa81SGqShhPScrqPZ4JiLGk94Cm1CVAKxOT/pmtZg4y2A0xBpoULk8J/5LqgswDRxsdCzChKo6l4jAA70R8SfmUrdU14GJwtdUyaL04rTJJ/4oeSLbUaRZagF+0sTMcNW66+JyHzQPS3PAG6oi1UMxdrSRJWfdklXiTQL/LvNW5VkSoIhFs6rm3LrANYeE92wHCbZpHv/4m8WYJR4O3Zpzn2ZGuLD7eT+ycZ7zLgWwJ98l77lOERf1PJm1eV2cqwKlZMrHP53GkWmY02OXvxG2FctmgmYWouwo1ntLRByuDY9tsPcXmWhoSH7Tp0eR5SyJCnok4EqioL7mYU9ohVkVaLR0MQPJhsSrMWLYLK2XkQnfxvfpvIwtIYLmRF298TWT3IB277jzYbyrwRDdKaHbUWpyfwIXD7dW+e4W4WH/AhLD9enWnj1fXRWG+gx1tNmeJMzrdGBHJ86Ebh/FA0CQtexgo18RkjvlBfN4WCIpAO4JC/bLH1xQwSPXwMOlG0vky9UzvtCvaMM/fMqaovhEI7mkGZ8HCWKT0YELTZsHf2mVaZXf4dzK9C/jSf/QLvB71h7X5aNPhWG7Eb2jjTTSk09EzMu6GSwIrSdZoj/NduNPGaqXI9cR7mo63iHLjTrOMU0UuJJS3YWxiElFERhu2Cw8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(396003)(376002)(366004)(66946007)(8936002)(5660300002)(31696002)(66556008)(186003)(52116002)(53546011)(66476007)(2906002)(7416002)(6916009)(4326008)(44832011)(31686004)(54906003)(478600001)(16526019)(26005)(16576012)(956004)(38350700002)(86362001)(8676002)(6486002)(316002)(38100700002)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YUVJQ1pLdnRObVdBSm4rUU9PWTNQU2w2cWl4QzNrMDhOWWN3S1NHdVE4blpt?=
 =?utf-8?B?ODFmS09SdVBFTnNITFZyY1haMGoyekVVNzNtZEN0SnRWWlU1WVg4MXQwS21T?=
 =?utf-8?B?K1loZFBvY3hISyswUTR4M24vem4rZXVVN2M2TkhWTVlPeENvSU9ocWk0ejd6?=
 =?utf-8?B?aUM1MlVCREozamRhb1RDMVJqNTRtYkgrR1VTL3paelhMWmtvbXdiN042SDZ5?=
 =?utf-8?B?V2ZiSVZsMEdlQXFESEMxZjhscjVDbCtvblAzbDkxQUpYUnd5YTJLbUFhTS9n?=
 =?utf-8?B?OVp4dzN6anU2MjhvVWFDVmliSUdkamlvNlZzVGF6eXZaV1JEVURPY0hGajFQ?=
 =?utf-8?B?QldzZU01QXJLNVRTVU5uYnZaQWdzZUp3cTBEdGQwVzR5MTNkbVhHbERSQmNv?=
 =?utf-8?B?ODR1UUQ5WXVVUGVPd2dXWnIvN05FSDBSVWd4UzRKcS96d1E1bjI0V1c0ZlBr?=
 =?utf-8?B?Tjhmbm9Hd0RaR1dQc3BydWJ6Vk9qMlNiMEZuVUNvL1Z0R01RR1hwVEhDY2RQ?=
 =?utf-8?B?MzNYM3J0WE5MTW5OZmVUUXdKOGpMWVVTaHdmWExwL3k2WkcwVW1ad2VTTDVW?=
 =?utf-8?B?RnhCSDRNWkVXbWZkaUpPaW9sS3dKd0RWOXBqK25SeDkrMFJQQUVtTUcrSFZE?=
 =?utf-8?B?bkJHWGdPcmFGQjkyejFvT3U4anlYUjRGMmt4WW0xRzY4ZW9ZQVpaOHo4NW4z?=
 =?utf-8?B?WkY0TStDN0FKUzN2SmowSnEwVlhJT1hTNVJ0REdPbzRFNHkvRGUwbUhHM2FJ?=
 =?utf-8?B?VGMveUZWUVkxNDZMVlNzaDVMODc4U2ZFaERCYWQzakpqWDRYVml3NkUxYjA2?=
 =?utf-8?B?Zy9rN2FCTlhDUlVUWFhrclFaaEU1TXcvVmpvQVlnTjVIYkNGRlRvUlY4QVI1?=
 =?utf-8?B?ck9SSlArREdkT000bk03cHpYb2VwV2t6ejY3TWdHZXorMks1V2d2cnEzeEZ3?=
 =?utf-8?B?Z0thNm1FelBNakJ2cGJQMlFtamNLRnFDRkFhb09lNVVQZkJmL3M1TEtlWkFC?=
 =?utf-8?B?a1JRVkpsNXVJTVJNN2FCUmF2d09uMFVjUlphZjFtQTQ1eHhrRUw5VDRxRlh2?=
 =?utf-8?B?LzFMQnhPZTB4QWQrU0NQbkNDZjlPTXpKZ3N2RnlxUVdhTlowOCtFdHB0L3Rt?=
 =?utf-8?B?ZmFZRGcyM1dPTXNiNlpndDdrNmV0MDJvRDRodzNvZVFNZlhQS3NiVkVDRUQr?=
 =?utf-8?B?a1E0RFZIbkdYbG4yNnBqaERnck9CRGFoU1FMUjhBTW5QMWdLOHA1Z0VyWHdw?=
 =?utf-8?B?MVNYalY0Y2lCc05IczJjUmh2YnlxbTd2UDBGWVlHVUMxN25GUFpDdFo5WHVP?=
 =?utf-8?B?UkczNjNNR0hpN1lKR3hOeGRPM3FuallhV0hyNUpYa0EzdVBwdGRsT3J1bEJt?=
 =?utf-8?B?T1pZSjlYT25YQWlYTWI3ZlNjVUpPTnRDdGpMWHdkbCtiNytQWnBwUEQ1UExJ?=
 =?utf-8?B?ODlubG55UVd4ZU8wb2h1TFlZV3JHY3hzUEtpN0VvOU5Ga2d1VFVOYTNITVdr?=
 =?utf-8?B?L1MxbkMvckF2Z2JGNkR6a1Irbys2dmNGZmt3Mm5KeWRJREtJb2FhbFNVelpw?=
 =?utf-8?B?UUlhZTRuMkxPcy9YR0pQOXduN08wNW0vTFFjelcvNTZIalM0RzBra3l2TXk3?=
 =?utf-8?B?WVM5dFdkRmx6WmpYZ05ycm9TeTdtK0Y4c3AxUVpndFEwR28reGpWVWxSVzVR?=
 =?utf-8?B?cmVxblJscGFqT09EZG0xcWN1WkNpb0N3b3JhT3ZycmRiaHRuMTNKSS9UMHJM?=
 =?utf-8?Q?qHZ+cGlGEftrPFwl+OiLneUCyud1HTI2Hdb0xuH?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce90965a-5030-495d-1555-08d9149c4ce0
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 16:46:18.8406
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tM+rYoG/wsrLdZjDAiOpuza9iL/kTuOSnUEPkMxrpAb322nq6zL1F9/rqKFAWhwJGiADcnRimNgTVsItwSkqJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8904
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/7/2021 12:18 AM, Jakub Kicinski wrote:
> On Thu,  6 May 2021 19:20:19 +0200 Yannick Vignon wrote:
>> The purpose of these 2 patches is to be able to configure the scheduling
>> properties (e.g. affinity, priority...) of the NAPI threads more easily
>> at run-time, based on the hardware queues each thread is handling.
>> The main goal is really to expose which thread does what, as the current
>> naming doesn't exactly make that clear.
>>
>> Posting this as an RFC in case people have different opinions on how to
>> do that.
> 
> WQ <-> CQ <-> irq <-> napi mapping needs an exhaustive netlink
> interface. We've been saying this for a while. Neither hard coded
> naming schemes nor one-off sysfs files are a great idea IMHO.
> 

Could you elaborate on the kind of netlink interface you are thinking about?
We already have standard ways of configuring process priorities and 
affinities, what we need is rather to expose which queue(s) each NAPI 
thread/instance is responsible for (and as I just said, I fear this will 
involve driver changes).
Now, one place were a netlink API could be of use is for statistics: we 
currently do not have any per-queue counters, and that would be useful 
when working on multi-queue setups.
