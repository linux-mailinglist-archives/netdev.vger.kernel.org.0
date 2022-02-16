Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E48414B847B
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 10:36:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232236AbiBPJcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 04:32:01 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:48694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiBPJcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 04:32:00 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2063.outbound.protection.outlook.com [40.107.220.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D90A99BBA8;
        Wed, 16 Feb 2022 01:31:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cQ8tESIno4sRb+slPRgox6DNu7AAitjssrpPrgkZnk2T2vNFQMVPjJpXp/pGjGzWs9nlnuAM7dIjU7WTAwAkruFRPU27K8NXjKSlFQNXEMaF0pFlbOvaAVErx36GQuHf/v8oLZmwNwcLGZN0Lp4HNDq5dm0r/4SRLfqrvPacAstMbJYwQEcgRKPiZSNgS3AbTLpyjYDymgDHDkFqun+CMPZY1OUAnTLba95UyvDdC5D42nGIsyQfcmPl1MT9HtZN798/2yr3s46f14ow8K6qKZbLCVbpXxjZ9C00D8m3eLNwgYwHTCMvcyvUvFsgxQ5Enjtdu2c73PesP5Sjz0WrJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xRCA3U6Ua12nOTQssWBMoRlP8K+xRAycI8s6yEI5zJ0=;
 b=OOYxKzksCoz+juH5CCcn8GsgpC5594BLwpwZPqPcggTR94IXx0p4KLjF7AfhPAn/9yTxv8ufyn/0KS4D8kGtLL3aaWjfLI42ADrgzR885H4xxeF4PnrZpUpjGp8W9/aCeqQRPVauVIJVPDI8+hEdndKxxjykog7q+FjVXRvwl8BvC9CZcTXLjFi9z+yUEPnbdvBaYETqlV+D7/qtHYDsBqOyDoZqWs6v0mKmR12AzlXPC+YnUq6RaGEHzVqrkATdObtICM5UVA4e6LUfrMedGhkc4Dvu7hPwcB7ySDp60yyPIh0CuoicclkNO/BPMa9AJNHNdxQgJuud7IECzeAHWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xRCA3U6Ua12nOTQssWBMoRlP8K+xRAycI8s6yEI5zJ0=;
 b=eQwUzBuvS05z4jQaPRlfEIwIghyR64YvJtGEwP8eQXb8Fn4Cq43Qrj2KZRfn9BVJf5blcFEbecj8D+J+tRR6QH/RbLn7NgXvJ3WUjB5xe4/1ZxnTi1y+Rk3MikRtuKcoaT2gRQBriHF5m3f23FrLT3BeXUps1ga0emTsPAEbhnQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5143.namprd11.prod.outlook.com (2603:10b6:510:3f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.15; Wed, 16 Feb
 2022 09:31:43 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::1b3:e483:7396:1f98%3]) with mapi id 15.20.4975.019; Wed, 16 Feb 2022
 09:31:43 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-mmc@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 0/2] staging: wfx: apply SDIO suggestions
Date:   Wed, 16 Feb 2022 10:31:10 +0100
Message-Id: <20220216093112.92469-1-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR3P189CA0050.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:53::25) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5f33d0e8-c12c-4f94-82ef-08d9f12f247c
X-MS-TrafficTypeDiagnostic: PH0PR11MB5143:EE_
X-Microsoft-Antispam-PRVS: <PH0PR11MB5143C62B71394ADDC2A3CD4893359@PH0PR11MB5143.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y1O+qxcWog1/YX+nQ3hP1S0IqHmP5CEHpDZcFtne4ZWyDUyyXKdkKKQBeCCE9SWa48Wi93zNpQPB+/Q5HjpcXs796OB/BqEtnIovx3B3Y3V+M/bIJuFA87+rbR4+PEIzqkCtTfEcMmg907CCoejmyxIGcWpkFi/dGiVdCUX1pjZUySBHy1QTP2zEpp9rvZCFtLmZrvbVplfxkK2XCLxhnYqIBqTFiDjWMOkMgvcaGtkfzKpk3dP1ri7VHLAX2bXRJHkKne16cx2RwcEoQGsTEvAyvk5F1pL4ZPxUeex1M4/LSDVS/5ZfXBrT0Av+5mVauzXsjg5PbyU7BtBHdFkiJY7O+HzKV1hMVs4RLjLBfYHbsryb5CDDblPgXXiRp+9pc/WE07Ye+t/nDBY7G4VuVoAimkoYSX4khna4BMFwSID3OkIW3r1BAWzuPQLUoIbC20KT/vH133GwzUj6LbEl3sq1eWSRyXYg086GEMgAQ5gjO6OAfOAyc0W7gq+4oy1h/GqgJQAkjhUPOcWt1+50uThxBInLTnqTRQqD55VWzqqtmuuGYJ6Wqjl3LQY/A+3VNJQopdXdNt762eDeszCjkk+C0sMkvuiCBvbWKJvvF0P2aJzVF2rW3/wNEbYxWL9uTmbrP0Lm0IjLYkOr+++rtlTQQinsDTR2nrTvhR26mEn/d4KebR0bERoG3H6EY+wW1qXFQbwGOjtiJmNLkvCefg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(7416002)(4744005)(36756003)(2906002)(26005)(107886003)(83380400001)(2616005)(6666004)(1076003)(186003)(6512007)(6506007)(52116002)(316002)(508600001)(6486002)(66946007)(54906003)(38350700002)(5660300002)(8936002)(8676002)(6916009)(66476007)(4326008)(66556008)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WUt6cHFKOTNhVW5GREJJdzU4M2g2ZXM3VHF1U3FORytYTlA3aGYxSXZYdnRu?=
 =?utf-8?B?MDRkL2d4RTFPTzdrN3ZrMkZqbWcvc3RjL09VREYwUkVlMWkyZWpjUFdNNkhp?=
 =?utf-8?B?UEY4bkx3Z21yZmNDeHpDZzhIRUQrSWZOWE5SNkFBU3VKaDNNcEtkV0xQMFhr?=
 =?utf-8?B?ampqdnpMMEpXeU5IQkRYRlprQi9XN3ZNWmM1blBVZUxJYkkwSW05cWd2Z1Zs?=
 =?utf-8?B?TTE3S28wMENWNzFsc0dpU1pmbXNKUlRib1pVVisvZEpoMEswOTJ5SmpMN2hI?=
 =?utf-8?B?c2t6b0c1U05Uc21scDZudjcrZlBGWk5XVXNTK2lCM2NIRGU4MHpZNk5EZzZU?=
 =?utf-8?B?cXA3Qnp0cTJ0SXNJUVQrQ1hvVmtsZ1BhdEpkQ2EwVjNndFFsTzVTUWtTa2tq?=
 =?utf-8?B?M0xRMUhHbS9jZDR0eHBhRTZnRXI1NTlRMlpPcGswZWQrcDgzWTV3K21URFUr?=
 =?utf-8?B?UGJ3SEFuNStUKzNsajd4T2x6elVjSHlJbzZaM0VJeEp3eUc2M0VHTmZIVFJL?=
 =?utf-8?B?NmhVTzFRTUdycFdobFVtUHlkOTRPRFpabVVPZytoTUpHeXZUM2cxRWI5WlUv?=
 =?utf-8?B?amNSN0RGaUsyaVcwRWpIQStWWEZ0dGN5NEtDbGlCdWFGOUFtdDBVUXNSUXpR?=
 =?utf-8?B?emdLeHdtekVPUDRBVUNZbnM3T3NTMk1pVktKRm1WekxxYlhvUXovWmRJZXlB?=
 =?utf-8?B?VGhiQkJZdEZVOVBxT2o0aFMxZ2lzbWpsOC9TdldGV25pSkRGcll3cHMxVzNp?=
 =?utf-8?B?VUNyQmhKakdjdW9FYS9qRGZMRXpyTXRKeWlRVWdhNllWeVg3TG1qMTBsTUVl?=
 =?utf-8?B?QjZTdEt0aXJpQ3o5RXF0Nk9tYUtLQmFwQ1AwczU4djJLTDhRSTlGOU1WU0Z3?=
 =?utf-8?B?R1R3TnprTjcwTTdCZGxZekxWVEppZ0hSSzgya2RvVFpDd24rSjBoQitmVTA5?=
 =?utf-8?B?KytScWVucDByVjd1ZlJhT0k5WVY4REQyTnJwMEljUXlOc3NFRWlWbmtoODVL?=
 =?utf-8?B?dnVpYkpMSkZEWTUwTXozT0RJdzN0a1JydVVGZjZlOVBIalFGZkZ4QkR0ZzQr?=
 =?utf-8?B?dkhrRlB5dU1YUWVzUEc3UzQ1dU9IbmpyZm90WnpwR1lxWnBtb0FndHpGdDkz?=
 =?utf-8?B?NjE3Z01LNmd2RmRsQXF0RWVzSnpwbEJnZGU4YUxQZGJHTjV3KzI3My9kU3hj?=
 =?utf-8?B?UzBsR1BQV1daNlVsc2JZWGNzbVZNT1B4cjRoVWp4T2p5Z3E4a095T3E4RzZZ?=
 =?utf-8?B?L1JyR1htMWFleEdhbjdIRGRkcm1XNk1ybUk5bXNsVUVLYkRGQVZLa1FpcE1B?=
 =?utf-8?B?YW04TzBUOENldjExbmlJelVnWDVKQnB0UFB1dEEvRmpSa0hjNTdCOCtlQ0xw?=
 =?utf-8?B?d2plWFU0OGhMaVJlN1Jub1BvejBlSnBNZFhGWkZEN2RQTHFVSnFRVXRoMlZ3?=
 =?utf-8?B?NWsyYVpuRWw4eG5rei83OXAxbFltdEhtV01RMkd5TzROMHFoY2dVQXd2djhT?=
 =?utf-8?B?RzFMcnRNamtoei9EVGdpRXo3TlJXaG9HT3FHOVd5WjRMY2pCMDhqWU5wK0wv?=
 =?utf-8?B?dlJvWUFuc2JrRU1vaUdobURtalNqR21yZCtoTWt2VE5zMG51cG4rM1NpcURW?=
 =?utf-8?B?RjQ2REdsVDNHOTBnblgzT1NVdEhEZ05TL3FzNGl6VHkxaHVEbVhTYnAzRmdx?=
 =?utf-8?B?T29SQ2I1NS9nblgzdlliUnIwMXlzQ1l5aWFFZGJkYUljZVpCc0RLZUd6YnNi?=
 =?utf-8?B?cm5FQktZZEk3ZnpxOHdDSUYzY1B4Qml4M1BiMmZoc1VTeHRMdXI4cG1LM05y?=
 =?utf-8?B?RGk0SGRSdE1LYURCVXNEbGRsVXVCWjl4VnRqUEQweURsWjZCVDZjMEM0K2NY?=
 =?utf-8?B?VnFoT0pQMU9ZQTdHcDlqRmxPWms4K3ArM055MysrZTM1eFcvUGVBS3poNERQ?=
 =?utf-8?B?MHc5bTY5bS9kUEJYcmRFaW0zbUJVd212WjlZdFlHeUpaZDM0S0NqS08reTRx?=
 =?utf-8?B?YUw1emZhMHVMbE95bTBhbzRqdU8zSGRUbmxrN0xsZGY5MkFIQ0czMlFTRFZk?=
 =?utf-8?B?SGphQU1MRUNGdVhpb2hJSmxON3dCUC9pbHVueGVtR3dFSHJXcE5lS0NmUFI5?=
 =?utf-8?B?Z2xSSlQvV213UU1kOEtGV2Ria0l5VGlhci9EZnQ0c2RzVGpLVXBrSzJiRUpM?=
 =?utf-8?Q?b6zDg6QGL/PmkaDu+vVJQ8c=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f33d0e8-c12c-4f94-82ef-08d9f12f247c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2022 09:31:43.1438
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5SL30KNx45UUE7dUGfJO3IoAPlR2DT7cWvs/QZbeX7X/p4Dw2Nfza6RfHNDfFah8yOulMBEgSYnYeE69oA3yTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5143
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSGkg
VWxmLCBHcmVnLAoKVGhlIHNlY29uZCBwYXRjaCBvZiB0aGlzIHNlcmllcyB0b3VjaCB0byB0aGUg
c3RhZ2luZyB0cmVlIGFuZCB0byB0aGUgTU1DCmZyYW1ld29yay4gSSBkb24ndCBrbm93IHdoYXQg
aXMgdGhlIHJ1bGUgZm9yIHRoZXNlIGNhc2VzLCBidXQgSSB0aGluayBpdAptYWtlcyBtb3JlIHNl
bnNlIHRvIGNhcnJ5IHRoaXMgcGF0Y2ggd2l0aCB0aGUgc3RhZ2luZyB0cmVlLgoKCkrDqXLDtG1l
IFBvdWlsbGVyICgyKToKICBzdGFnaW5nOiB3Zng6IFdGMjAwIGhhcyBubyBvZmZpY2lhbCBTRElP
IElEcwogIHN0YWdpbmc6IHdmeDogYXBwbHkgdGhlIG5lY2Vzc2FyeSBTRElPIHF1aXJrcyBmb3Ig
dGhlIFNpbGFicyBXRjIwMAoKIGRyaXZlcnMvbW1jL2NvcmUvcXVpcmtzLmggICAgICB8IDUgKysr
KysKIGRyaXZlcnMvc3RhZ2luZy93ZngvYnVzX3NkaW8uYyB8IDggKystLS0tLS0KIDIgZmlsZXMg
Y2hhbmdlZCwgNyBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQoKLS0gCjIuMzQuMQoK
