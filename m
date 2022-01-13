Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A401748D498
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 10:49:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233351AbiAMI66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:58:58 -0500
Received: from mail-dm6nam11on2085.outbound.protection.outlook.com ([40.107.223.85]:34208
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233398AbiAMI6P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:58:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lcL+d4BinX6j/C7ZB33Baaf+QePecu96SxeDaNyTX2QspJN80AxWCncnvwgKi1CEFox/4vynG0MB1Avs2zmdhvQddvSQ6O0yyI+xT5qmm/tHNZphBeocYdWrxsYdyf/W/du3T+nygz+dErCMBuHPIzwZufo1QRoGule9VOi0kp748NfC9C7Bu0jhv/DYFh2KBNNp4OurhiVXjS/1u1Ztb727L6tLZCjGa44j64DdMGTirluYy919Yeq+Erw2BQLhkiCEHvqOkNsPx5cXV3/ma9/w/KcRCcaPhgwvfkeTXROklR7M+tYMHYnml1jZV+cpUh2nEl0nF6nKyAkJd76htQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iD+6WoICOOtFeCiCZJGaZ1TH+EHiLNsyD/IL9E5coZI=;
 b=ZvwiK6sDOme5komHqyhvNO2xZog1FbQUtrWPVoOhqetPuQZaTmu2GTXfjampHh9+hr7l9eDWfO9AR40QMwBLBO3Qv5s9pCdUkAbpCCu5VRMEsC8YDRbzimGYOFJRy5uHfrG5DankuUDiGgMIALanfFnVKAY54wlANEiX14B0Z5A0S9xTAjCaAoiLPlkbsuYuqwUTaVx6e8sp0FPu3wx9kd9TZ4TxWLqLfrERyrShDS0qVoJb3zCwiSxKFTp+PZNniP5vLc9qPXA8Gabwo7ScUVRkr7QnNxOwg5pt/eMtN4hinCZ7Hru8iJY6tDmezT+Ju6cMV7F7ku1VPnPC+q4ttA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iD+6WoICOOtFeCiCZJGaZ1TH+EHiLNsyD/IL9E5coZI=;
 b=gGUsO4b8m3n+TvHBQAqDIgiUM3Lk4Q5wf0rITk2oydDUBKqydl3f7CYjUxoR65kpl4o6yzAACpZs6TQvfB4Vb9OWF2H/10WMkMAb6ICfodub5uAyCGuRA+wmIyBusX3h3BOTDpDzRtUqqO9MdJMaOT2o3gGZFX5/ODiZ9N28GXw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by CY4PR1101MB2071.namprd11.prod.outlook.com (2603:10b6:910:1a::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.9; Thu, 13 Jan
 2022 08:56:38 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:56:38 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 30/31] staging: wfx: rename "config-file" DT attribute
Date:   Thu, 13 Jan 2022 09:55:23 +0100
Message-Id: <20220113085524.1110708-31-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e622acb5-36bc-4858-78fa-08d9d6729c3a
X-MS-TrafficTypeDiagnostic: CY4PR1101MB2071:EE_
X-Microsoft-Antispam-PRVS: <CY4PR1101MB2071CCC28E854107C3D2F38B93539@CY4PR1101MB2071.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AceXUuT92E8M2I4pabXD3yGiG7DTC1DOD2Dy1niUJ9g/mSX46SlSu2bPBzFwh19Ix0asc/WLewYgVQTVTq1YAsY8k8GcenGSlItX4unmAZ5noJIdNKrIDLIYDqC5SizkT+/SzOYCHLgUoPTOE4s29uow9bM6/SNMa/VbO5P6f0wua3YjJ4VcG+5FVvqJBXaCGsJnUbJYW7IQ5D4j+kLwm8exI14Ty5/7bckoqeoC9rt3hQbZi3IbzP9BUKcVd252+A/UsO/D7I1+Wrx3c0F9eIqbAVPaA8tGiWNFmUKRjcTIFemn9c56+eimTi5ZtzN5fyttiZKFul7oCZ6vWViWBVjFj6j2nLEQdGzhjKNwkL3R39UBTlueR8CmwBqNVYhB5yvI3NPtUMu7fo32qVk0xYBPBLCaraLQAegfJjn5oqgI7FzEx3ZAIkaL2FYly3rDzA57VDRm5RWFz5B4o9X6aloSA447+bOh33NsK+/2mhKrw4s5C2kg8KZ/Z/b3DzWwr70s8yJUS5kJuZwGUXvnJQnxnrXtBDDvV9T22HlyYC8ZhDXXWtJKkb8qTF0hMuea9MN2kFD+100elPZ83mINY7IN/4Ewz+K2KPMOyUKJit5g10CB+w8zZlulkeU589PQflPrkGf9bLAKjtr+zc5ZGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(66476007)(52116002)(8676002)(6486002)(4326008)(38100700002)(8936002)(83380400001)(6506007)(107886003)(66556008)(6666004)(36756003)(508600001)(2906002)(5660300002)(6512007)(1076003)(86362001)(186003)(316002)(66946007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UktyOUFmTjFBWXZXZ21RRllwZWJhNFVCbDFLRjN1UkI4dlExcHcyMXgrV1py?=
 =?utf-8?B?UE9jUHNhcC9Ob2dFaURDaUtrRit4MGdwYnMrWFdsRXNSYUYrZHRwUXJtZUMy?=
 =?utf-8?B?MGNSR0tyTEZPZEdneVdDU3E5RC9qbEttQVZFY0Jxc3BEQWswU096K1FKMmtK?=
 =?utf-8?B?VThtTm5nTGx5YVQ2UXd2OXhaZTZ3elFaM1JxL3NpT1psZVBpWkFmb0Z4NXA3?=
 =?utf-8?B?ZGlVRnJZbUZyM01yOEZENEl1MDVHVHRjTEVEejgyanlGanVEb0lkUXY1WmJS?=
 =?utf-8?B?V1hLOXVpUGJ2TUFKMk9iVXNlbElrYlJNaVFrdzBPb0VWQTA2RUJSUlpxdXpS?=
 =?utf-8?B?a2lDcnZlRUVJS0RzN1daNk1URWJuaXpqNU4vcUhFMUhzalpMVHNsQ2xqL3ZS?=
 =?utf-8?B?akZ4QnVxL2xoeFlPYmlaMk9YLzNhMXhYMW1mZG4vempEeFcxcVV4OTZRQjQ3?=
 =?utf-8?B?aXVlcC9QWEIwWkpoNXB5U0JBTVFMTmZGMk5GQWpvOUhOeXJXSnVPQng3WHhE?=
 =?utf-8?B?emg5OEdIa1IzMjlLdDRIdWZnaTFKTU94Sk1xUUdRR3RBbm9KcEplbzRlWi9t?=
 =?utf-8?B?YUFreEY5R1B1dStFT1lWcWFJbmdvOE0rOGVBNDNaa0doVG8wYjkra2F5b2k2?=
 =?utf-8?B?NUFlTU5pWGZiUFY0SDNLdWlRNWFFTWpFd0pjQm5Ea0l3QVdmUGtBVW5QZWVU?=
 =?utf-8?B?SitaaVJPMzFKSkRZRnphbUJPUzRNYnpIYTBQOFE3c2pmdDVIVmFJUWJlU2Vq?=
 =?utf-8?B?V2s5V283RFBlQlNCa21rcW1veE9YWEpSaGc4SkZFditMTnUyK29qcEhIU3Vm?=
 =?utf-8?B?bXhlVU5NWms1SnlTbzlyaTdkK2sxaXpVeDh3dXRpYS82bU9Jb3V6OUZHdktN?=
 =?utf-8?B?Q3BqREhZazNmVVhyMzhwNFBYdXBVci9ndk84M3dWNmE2MnFRY05TdXZFWG1H?=
 =?utf-8?B?OUlodkw0b2NsM0VoN0hML2tTYm5FZGd0d0tKSXZQYXN0SzR0UnhSMFdFbUx6?=
 =?utf-8?B?UVZzUktWbngzNTFLUGNWa0UyZ3pvYkU3b1VVZEVXSFo0WDVPS2hoWUFDZ1RP?=
 =?utf-8?B?ZC9GRmt4aDBIRHpDS2J2MXU5WlRQVWllT1p4eUxkOS9BQ2o2SWJwcU03d0JS?=
 =?utf-8?B?L2VHNnlITXU5d0orWGZubjY3KzhxTjJ6Qkgvb090TzJjelBQOWpqVHJBUkMz?=
 =?utf-8?B?bjlpbFhOdGxFYmcxM0lIaVpKMGxaZW04WndwT01wbnFkZzJ1azZlWXV6MGF2?=
 =?utf-8?B?SzI2Ti96WnRLSmpMdWpWemNJNC9iVXZEVmtnSEVDQTV5cFcyckZKN1FNbTBP?=
 =?utf-8?B?NEJweE91c2dsSi9uOEdjM09BNHJtTEJjMDVPVkdEekkvZmdicm9JbzhDUW9U?=
 =?utf-8?B?WnhIZUNSbnp1eWVTbng1cGpSc0wyUUNGdmxHbVllcDN1SEFjMmhFeVFXUk1o?=
 =?utf-8?B?MEV2VUNHYkZsWWhSSExjZ3prTmwrckthay93S0djMFBESXBQenA5YVV1Ti9i?=
 =?utf-8?B?YW9tQWcwNGlGSmUwV0dBWTljSHQwcFNBR01YTEJ5ekJ6VGRQVkJuT2JyQm9E?=
 =?utf-8?B?UnVub3R5czdlOEFBMjY1L1AzMU5IcVlacis0dEVlY2dEOGo1d1VTUDk5eUNv?=
 =?utf-8?B?bXp0eWdXVkVYc1RkNGpjSGlMNE1Nb2ROWVBUdUYwL3hDSEFZRU1CYi9kdThG?=
 =?utf-8?B?RVJ3dzhuWXk0Q3laVlJsUVRNdzZMYXl6TTRMUnFOVm5rQWNoUkk1VDhmbXdt?=
 =?utf-8?B?dUNIc0t2OFNpbXBMKy9DYzN4ZU10Y3I2VjJNSzVDcXdlZlUxdUZ4aGMwd01N?=
 =?utf-8?B?alp0cjVUSVZ5bjk3N1F2akFnU0xRYWhNRU9wNXFMNFFrUWxacHl0SG5zeVk3?=
 =?utf-8?B?dWx5VHUxREZDbHZoejFwdGF1aUJQeFEwSG1BOFpBb3cwMTZkL3RaaDAwK2th?=
 =?utf-8?B?L3FjQnFNcWtON3JCbkJDWW5udmNaWkZvM1Y3WHVCVWN4dFZDZTN0VloxSWN5?=
 =?utf-8?B?SEI5TG12MHNjZVBBZ1l0RHJPUE02MjBoZ0U1VWFrKzdKMG1UZWtNU3JjVzl0?=
 =?utf-8?B?emUwSllkbTYwOXdoRlRLc05OaVFTeVl1U09CYlpFa1hOZmI0RGh2T054N0hR?=
 =?utf-8?B?WHhmVFh4Y3R0Lzd2dWlBQ3BOR2d6WlVQbnNJSk5uYlJZcUl5bmw4ejAydnc3?=
 =?utf-8?B?YkFaUENBVS9BVXloaVpHYXFXbnR4aVAyMytJQWhsRTZYcHhnRWlxbURLR21G?=
 =?utf-8?Q?CpZ2MbDJdUE2HeruOcNbHVv7WasV9tkYnZjS4+0EjY=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e622acb5-36bc-4858-78fa-08d9d6729c3a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:56:38.7672
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: np+4jPrfbKhN/+WlJg9ySDBUxxOtLfTt4/GuwKYF5+3UhRWKNyQxcwmXMi+70qM/l7NLanaI0mtCVCGhXFA2rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKImNv
bmZpZy1maWxlIiBpcyB0b28gYnJvYWQuIFJlcGxhY2UgaXQgYnkgInNpbGFicyxhbnRlbm5hLWNv
bmZpZy1maWxlIgp3aGljaCBpcyBtb3JlIGV4cGxpY2l0LgoKVGhlIGF0dHJpYnV0ZSAiY29uZmln
LWZpbGUiIGlzIHByb2JhYmx5IG5vdCB3aWRlbHkgdXNlZC4gVGhpcyBwYXRjaApvYnZpb3VzbHkg
YnJlYWtzIHNldHVwcyB0aGF0IHVzZSB0aGlzIGF0dHJpYnV0ZS4KClNpZ25lZC1vZmYtYnk6IErD
qXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiAuLi4vZGV2
aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sICAgICB8IDkgKysr
KystLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L21haW4uYyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICB8IDIgKy0KIDIgZmlsZXMgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCA1IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvRG9jdW1lbnRhdGlvbi9k
ZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMsd2Z4LnlhbWwgYi9kcml2ZXJz
L3N0YWdpbmcvd2Z4L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvd2lyZWxl
c3Mvc2lsYWJzLHdmeC55YW1sCmluZGV4IGMxMmJlMThlYjZhYy4uYzQ5NDk2MzU3MTgwIDEwMDY0
NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9uZXQvd2lyZWxlc3Mvc2lsYWJzLHdmeC55YW1sCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93
ZngvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC93aXJlbGVzcy9zaWxhYnMs
d2Z4LnlhbWwKQEAgLTcyLDEwICs3MiwxMSBAQCBwcm9wZXJ0aWVzOgogICAgIGRlc2NyaXB0aW9u
OiBQaGFuZGxlIG9mIGdwaW8gdGhhdCB3aWxsIGJlIHVzZWQgdG8gd2FrZS11cCBjaGlwLiBXaXRo
b3V0IHRoaXMKICAgICAgIHByb3BlcnR5LCBkcml2ZXIgd2lsbCBkaXNhYmxlIG1vc3Qgb2YgcG93
ZXIgc2F2aW5nIGZlYXR1cmVzLgogICAgIG1heEl0ZW1zOiAxCi0gIGNvbmZpZy1maWxlOgotICAg
IGRlc2NyaXB0aW9uOiBVc2UgYW4gYWx0ZXJuYXRpdmUgZmlsZSBhcyBQRFMuIERlZmF1bHQgaXMg
YHdmMjAwLnBkc2AuIE9ubHkKLSAgICAgIG5lY2Vzc2FyeSBmb3IgZGV2ZWxvcG1lbnQvZGVidWcg
cHVycG9zZS4KLSAgICBtYXhJdGVtczogMQorICBzaWxhYnMsYW50ZW5uYS1jb25maWctZmlsZToK
KyAgICAkcmVmOiAvc2NoZW1hcy90eXBlcy55YW1sIy9kZWZpbml0aW9ucy9zdHJpbmcKKyAgICBk
ZXNjcmlwdGlvbjogVXNlIGFuIGFsdGVybmF0aXZlIGZpbGUgZm9yIGFudGVubmEgY29uZmlndXJh
dGlvbiAoYWthCisgICAgICAiUGxhdGZvcm0gRGF0YSBTZXQiIGluIFNpbGFicyBqYXJnb24pLiBE
ZWZhdWx0IGRlcGVuZHMgb2YgImNvbXBhdGlibGUiCisgICAgICBzdHJpbmcuIEZvciAic2lsYWJz
LHdmMjAwIiwgdGhlIGRlZmF1bHQgaXMgJ3dmMjAwLnBkcycuCiAKIHJlcXVpcmVkOgogICAtIGNv
bXBhdGlibGUKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jIGIvZHJpdmVy
cy9zdGFnaW5nL3dmeC9tYWluLmMKaW5kZXggYTk4YTI2MWY2ZDc2Li44YmU5MTAwODQ3YTcgMTAw
NjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvbWFpbi5jCisrKyBiL2RyaXZlcnMvc3RhZ2lu
Zy93ZngvbWFpbi5jCkBAIC0zMDksNyArMzA5LDcgQEAgc3RydWN0IHdmeF9kZXYgKndmeF9pbml0
X2NvbW1vbihzdHJ1Y3QgZGV2aWNlICpkZXYsIGNvbnN0IHN0cnVjdCB3ZnhfcGxhdGZvcm1fZGEK
IAl3ZGV2LT5od2J1c19vcHMgPSBod2J1c19vcHM7CiAJd2Rldi0+aHdidXNfcHJpdiA9IGh3YnVz
X3ByaXY7CiAJbWVtY3B5KCZ3ZGV2LT5wZGF0YSwgcGRhdGEsIHNpemVvZigqcGRhdGEpKTsKLQlv
Zl9wcm9wZXJ0eV9yZWFkX3N0cmluZyhkZXYtPm9mX25vZGUsICJjb25maWctZmlsZSIsICZ3ZGV2
LT5wZGF0YS5maWxlX3Bkcyk7CisJb2ZfcHJvcGVydHlfcmVhZF9zdHJpbmcoZGV2LT5vZl9ub2Rl
LCAic2lsYWJzLGFudGVubmEtY29uZmlnLWZpbGUiLCAmd2Rldi0+cGRhdGEuZmlsZV9wZHMpOwog
CXdkZXYtPnBkYXRhLmdwaW9fd2FrZXVwID0gZGV2bV9ncGlvZF9nZXRfb3B0aW9uYWwoZGV2LCAi
d2FrZXVwIiwgR1BJT0RfT1VUX0xPVyk7CiAJaWYgKElTX0VSUih3ZGV2LT5wZGF0YS5ncGlvX3dh
a2V1cCkpCiAJCXJldHVybiBOVUxMOwotLSAKMi4zNC4xCgo=
