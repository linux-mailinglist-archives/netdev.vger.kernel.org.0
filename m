Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A6E152580C
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 01:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359336AbiELXA3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 19:00:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356737AbiELXA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 19:00:26 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB4A27EB8A
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 16:00:24 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24CI8BZg022432;
        Thu, 12 May 2022 19:00:04 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2176.outbound.protection.outlook.com [104.47.75.176])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3g02sg1dph-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 12 May 2022 19:00:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SbaJlt53h18kE0UYr5Os0NUOtbC4ckKXbyyWsYL+w7PR6lsUVdYetLNh62BnrLdpxbEYN6XVQ+FSSSW2Ze5OP2njN/C09bp62Qjucu5zDcrOwRG+1q2RyskZeEbxAFZ6tKJ8GJUpXeOnhwGPolhiP5D+QAFzC/fuJcHGmNH2RFsyLdIRQgn1kG0nXuPM43LdKmtU0SuAAJN92sxl2kBTOR0zGSzMLLDnz1/wfuzkrZtZ8U/gYjQt9QVQF/aQcDMANcXMlxS/stqSJrNg9ebVG3UbEyHbwUhkN8mkukDVxr+pHi6m6iswp63aHpXoA9+09gQx1z4ef0X8HyZvzrtzcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2d+LvPRpDpUcfLupG9fuqlFHNYTC/oKL9Th+47gjTp8=;
 b=AKKLJsb+fDyXROfWzvFbiLm+lgratkJHtRZwoI+4y+FpKg7pnojs3tAkqZR+N0cYZaimOjOXzhgVMJVV3gZCEvQ4eIIsmsyNvL8u6gVWOaX3Lq1IwAEVtw3bIPEKRjhZGapU8oD2NiLzPzzx3JP2I8vBWvqafzDBQDFUOYu3C+oSsJBl2yuVCh6PQLVisJrAKnDDEKWhEPpy/31BT/UBChJ7llh4OIoZdT10qdAnCzA6bqyRQpFYC5TsJs4qSv/ZKozJd0q29bjGITggSYNQm2CbIGiK+wNrNFgFM2H97CMbn5YnOV8oWJBOF8YJwPPzgdETbM2tZyb1AuYiLJbSBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2d+LvPRpDpUcfLupG9fuqlFHNYTC/oKL9Th+47gjTp8=;
 b=LaiXdR/it9Eb1NmG1wHfze2UcpXtIb0d4uAIZyweVQO8NzgIQllhc+Azt7UJr7nrO2GqHvxvACVQG2J4uiRRkhxc0pmUkY7qk95y/Ezxuii+USKj/hsx42gVSxOoX4IFWizuUcRwRk1SaeUeDQYRDjxjsRbok486rASHteEFmBM=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT1PR01MB8329.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:c0::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Thu, 12 May
 2022 23:00:03 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4%5]) with mapi id 15.20.5250.014; Thu, 12 May 2022
 23:00:03 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "pabeni@redhat.com" <pabeni@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v7 0/2] axienet NAPI improvements
Thread-Topic: [PATCH net-next v7 0/2] axienet NAPI improvements
Thread-Index: AQHYZiRxw9X988dUd0a/NujqhIynda0b27wA
Date:   Thu, 12 May 2022 23:00:02 +0000
Message-ID: <6f1c104d118c55b6903a0557ddba223d3e2843b1.camel@calian.com>
References: <20220512171853.4100193-1-robert.hancock@calian.com>
In-Reply-To: <20220512171853.4100193-1-robert.hancock@calian.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cd98a365-e5ce-4f46-c122-08da346b2602
x-ms-traffictypediagnostic: YT1PR01MB8329:EE_
x-microsoft-antispam-prvs: <YT1PR01MB8329581F1924F55A617590EBECCB9@YT1PR01MB8329.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n4P8/F6Z5aoWtNvGpsxAxxrL6AHHM99jZcPZyEUL+71DSSUGOnSyF4MNARGT3IrN1i46MIg8IG7Ri+HjM4JB5b9PBVC0PT9YfvFpIDCCUudlWLO+tZzEf88xOE0djXdr/RVhgJRfp4dXJrkZP2LDCVIrLP9ViZxUV42WY1JaB9KLk4qc5kQaLq7Sc7SxTTjqTCA78m/VFh0iJROeRdtIf1aHzbBl4gosIDzp5uMFzrM6/H8Uab8pQld14K7ldajZGAAkTisMCoQ1h8NxBsI3EsjwAFRLuMpvV0h1gLbvTblYw/44NphxWu1D9yz2u4bJnXS2D4IzG66ba6oqXpo1y3XBF0ockgxrpzgi2Fdb91bOEEkNTnlnSkFRKANrASbluC2PzH02Mps4DoLgzFC6Gg2Edz/vtF6F7tZP/8Go8ex1GRZs6weSJcmbnCetTgNXZXU+4lDp+De8+F+x2K+L9pYQ9HFqzqa2Fp90JcPPry5X4BKnJaC/c0rmCKGBR/i+Gm/blYh7ejlAyUlr3yA1ZKZVcsci/YNcJRBZ8tVZDpu3K90APx9n76oGO8pS1dHzIuw5hHNAL80tAiz7hAvxbvT0vWi0u2I+orlxywXTivrWAxetQ71lGeYf3CQcp92ubXWqmrDnQwQw1Z/wDCEf2dbaTlZK+CFoZjhVVtVMiTRKOmVdQZDZt44lMAB450OIsFxo0yCohWqej6eoo7n4w3IzrU7Qq1/7pNozLpr3kzmlInwoxmNoVDu+3zStkgmOB/JV2rXa1RXDYl9sVomByOr3u3iFSz7n1wljTiWaZDSTfx4OAt6RU4psoJ8uR6d9KPXSixha1KC7I3fUkWDBRQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(5660300002)(122000001)(38100700002)(38070700005)(6506007)(66556008)(86362001)(15974865002)(71200400001)(6916009)(6486002)(54906003)(8676002)(4326008)(66476007)(66946007)(316002)(76116006)(66446008)(64756008)(508600001)(36756003)(83380400001)(2906002)(2616005)(186003)(44832011)(6512007)(26005)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWVrVmx2REl0NWpsY2xmNlVjdGVhMmN6eUl5WWtxOG9pVjdWeE5CWXpuc1l1?=
 =?utf-8?B?dElFVDdIRjROeWhMTitLeXVua2VoTWhzaWlCNTNpL0hWclE0YVVqNHZWYXhE?=
 =?utf-8?B?ZmNmUnc0NTlKMFdJWXUrdHVvT01Cd1BVcmxidmdWWk1PaWE2TFUvdE9obFV3?=
 =?utf-8?B?OUVyMHhQd3VEdURwU0dHZ053a2pYYS9vdU9MbUdjK0xkL1JaM0ZqRFRHU2lu?=
 =?utf-8?B?NWNoa3k4Y0IxVVR6UHlmYzc0dnN3SjZNaVVxT3hCdk9WRHhXNzdRS25GU3l1?=
 =?utf-8?B?ZmYxd0d2Y0R6OWFIQ1oySGVTVXhJbXdTU0xuRW9KMnlqbTFiSHVKeU9id2Zz?=
 =?utf-8?B?dFBFZE9jZHlrdVNJalIwNkpvSG9zdDFMdXRPS2IvWjkrYVhjZURCNVBpNVAx?=
 =?utf-8?B?SFBRdDJSdkhHODh4VlJaQ1BvSXI4Z1J6UHBPQnViLzZaUGpPY0cyM3FXU3JQ?=
 =?utf-8?B?VGtwRFlBTmRibGZzencrR0VOZTgvRjcvdDA5bEtBbnhrU01DM0kydDZOajY5?=
 =?utf-8?B?aWkrdmI5YTRobThZVXhsRzQzNjhmMkZOWXdaZTdRMjNwODRuSVpacVhPc1ht?=
 =?utf-8?B?UlBlRGZlV2x6ZEIyKzdYOEVRVjk0Q1R6V0RQWTg1REp0UW9RTDR5Z2poTVdN?=
 =?utf-8?B?eEtNNXJvQmppRTZyYTY5THhlazhBc1pDc2RhRlhVSUNCY0NLRElYS1BxMlZl?=
 =?utf-8?B?Z2NRTjUzYnBUeng2Z05YZkdOdHBEdUNWMFNsaHpHelQ2VGViaEQvMGRnaThE?=
 =?utf-8?B?anRiaFVWUlNhVWw3UC9qTU0rTGJjWm9rSVVleXd2SVk2SlNnNkdUMTdjZi9u?=
 =?utf-8?B?NnBGd0VwTmRYMGY5eDVwMHFZNUZsV0FOcFNpM0JBaGJQSXdWdWdWazRhZjdu?=
 =?utf-8?B?SEVFWTNoYjFCUVdoelk1ejVRbXB4aEthSDNZZkg1MEU1ZGljMnI0TVVsa3Bi?=
 =?utf-8?B?YnlURE84dE93VDc3SVhHRzBhenBPR1lCekF2dDV3KzkyOHY4UUNmM1gwcU9s?=
 =?utf-8?B?QVFITDFFNGVFNk9NajllRmYwNFdYVjFUM05vN3lPck43eHp6N0UwT3IxWXl6?=
 =?utf-8?B?clhrMWFNbGMxUytnb08wZEM5cENBZUhPdU81Ymg5a1M1M3FTaHIrMFJTN2hM?=
 =?utf-8?B?VjMvOHdFK1M2ckM4SDQ1ZDNwdW0zbEgybmc1TVgyajVpZWpvVWZ0YjRGYTFU?=
 =?utf-8?B?UDNIWDdBVmRnN295S29GVWQvZXpBMWZMSHBGaUVqNU9yOUQ2dWNaNERMMHhS?=
 =?utf-8?B?NnpYSE4xWTBUSk5nQzRxSU1DZ1Byb285a3ZyWEVucUkyYlpkdVZ5TGdyQ2J0?=
 =?utf-8?B?Q1B1UHI1N2RoUDZtOFBKQ3FJa3ZQWVVtT3ZrdFRTQkxlL3g0SmtWdlFJMC9r?=
 =?utf-8?B?bE5pdWIwdjJKMHhkZVIxci9FQ09tVXo5czNXRkxWQldmY1MzV1RLUFJEVUlu?=
 =?utf-8?B?aTYvM3VsVk0vNytTeFFzcXZRMHpGWWtKTjAydjBiUlJmWlhLR0JDOWlkaStO?=
 =?utf-8?B?elBjRDZnczZYVEdQOS9tTE5OMkJTOHR6WXVVeXdPazA0ZXJGTGY5SzE4dEMw?=
 =?utf-8?B?MUNzaXpPQTZWMVVpM1VTZ3dLbWtzNFYxK0VXaU9MWExpU3lRUGdPaEN2dGNw?=
 =?utf-8?B?OTBIVWlpZFRPTmt3M2psbkxzcnhjd2VCRnFLUC9oVmZvNVoyZ3RIKzc1cWVM?=
 =?utf-8?B?L0NPZHprZnUva2J1SGlOdmxrUWV6SWRML2diekUrWTRvcjI5RXFNeUkvY1pE?=
 =?utf-8?B?bkNITjV4cy9LVThQL2JqNU1kK1dHM1I2Q0NUWjd1SDYzczk5c090RmhzZGh4?=
 =?utf-8?B?UHhQL2lFNHl2dHRmTDFBVExtdmZ4OW5WT2hSTEgybFFWQjR4Z1pXTFVlaGFW?=
 =?utf-8?B?a3Roa3lsa0pRSzNZMG5OaGRuQWx4U3hpTXp5WE1DZm1hdG9ReWpmZExiMlc1?=
 =?utf-8?B?RDNoclZDRmtNUGR6TmRMdmhiZTBhSCtXSDJlUDZDOG1EcjMwZGhrLzFCSjg4?=
 =?utf-8?B?RXRzNXQ4bUFMT2JuWjJFNm1JbEV4T2RIS25iR1F6Q21PanNVMVU0QnF6RTlT?=
 =?utf-8?B?ZTdDOGZPS0pJblgvc2s4WkFKekNOcGdCV2g0MjMxQVF2US94N2ZGR2c1VmVP?=
 =?utf-8?B?cklhQ09VS01YMEdMTlVpZ1hqdjhoQ0xTRjM2RXo1SWR6SStadW1ZRnNLeTRS?=
 =?utf-8?B?Q2hIRTlQU0pjSW9zTGo3VHRLWlU1b01icVZlSjB1YWdidy9Eck8xTm1HOFZ2?=
 =?utf-8?B?S0NKNGg0ODZSUTVkZU1kWFZoOGVWbE1WUmJHOG9JWHZlK3JkZXYrdVNlM1dS?=
 =?utf-8?B?ZFRMOFNjUkNjeHNleTgrQ3ZtOGdJWStmcXhRazF4YjFXeG1RSWE4VDFlMGxi?=
 =?utf-8?Q?a9/q3aIqOA8pfipAJAiTQqdF6R1x1ATQprjpE?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A4B507906EC5D49BFD869906C2E7ABF@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: cd98a365-e5ce-4f46-c122-08da346b2602
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2022 23:00:03.0050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7rICVP7G6Ni79QWPgqVJp5H0Pj7vOOrjPjJhO8qpIuCoVS4cy7zozcPmR2vssle8vargTGXCILFZUJ2MNIGuahtOHQ0bUdvxJkJ9paHNZKE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8329
X-Proofpoint-GUID: 1E_N2c581im5gabBJDySv-nx45mG_KrW
X-Proofpoint-ORIG-GUID: 1E_N2c581im5gabBJDySv-nx45mG_KrW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-12_19,2022-05-12_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1 malwarescore=0 spamscore=1
 clxscore=1015 impostorscore=0 mlxscore=1 bulkscore=0 mlxlogscore=185
 lowpriorityscore=0 priorityscore=1501 adultscore=0 suspectscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205120097
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA1LTEyIGF0IDExOjE4IC0wNjAwLCBSb2JlcnQgSGFuY29jayB3cm90ZToN
Cj4gQ2hhbmdlcyB0byBzdXBwb3J0IFRYIE5BUEkgaW4gdGhlIGF4aWVuZXQgZHJpdmVyLCBhcyB3
ZWxsIGFzIGZpeGluZw0KPiBhIHBvdGVudGlhbCBjb25jdXJyZW5jeSBpc3N1ZSBpbiB0aGUgVFgg
cmluZyBwb2ludGVyIGhhbmRsaW5nLg0KPiANCj4gU3VwZXJzZWRlcyB2NSBvZiB0aGUgaW5kaXZp
ZHVhbCBwYXRjaA0KPiAibmV0OiBheGllbmV0OiBVc2UgTkFQSSBmb3IgVFggY29tcGxldGlvbiBw
YXRoIi4NCj4gDQo+IENoYW5nZWQgc2luY2UgdjY6IFVzZSBSRUFEX09OQ0Ugd2hlcmUgdGhlIHZh
bHVlIGFjdHVhbGx5IGRvZXMgbmVlZCB0bw0KPiBiZSByZWFkIG9uY2UsIGluIGF4aWVuZXRfY2hl
Y2tfdHhfYmRfc3BhY2UsIG5vdCBpbiBheGllbmV0X3N0YXJ0X3htaXQNCj4gd2hlcmUgaXQgZG9l
c24ndC4NCj4gDQo+IENoYW5nZWQgc2luY2UgdjU6IFJlcGxhY2VkIHNwaW5sb2NrIHdpdGggZml4
ZXMgdG8gdGhlIHdheSB0aGUgVFggcmluZw0KPiB0YWlsIHBvaW50ZXIgaXMgdXBkYXRlZCwgYW5k
IGJyb2tlIHRob3NlIGNoYW5nZXMgaW50byBhIHNlcGFyYXRlIHBhdGNoLg0KPiANCj4gQ2hhbmdl
ZCBzaW5jZSB2NDogQWRkZWQgbG9ja2luZyB0byBwcm90ZWN0IFRYIHJpbmcgdGFpbCBwb2ludGVy
IGFnYWluc3QNCj4gY29uY3VycmVudCBhY2Nlc3MgYnkgVFggdHJhbnNtaXQgYW5kIFRYIHBvbGwg
cGF0aHMuDQo+IA0KPiBDaGFuZ2VkIHNpbmNlIHYzOiBGaXhlZCByZWZlcmVuY2VzIHRvIHJlbmFt
ZWQgZnVuY3Rpb24gaW4gY29tbWVudHMNCj4gDQo+IENoYW5nZWQgc2luY2UgdjI6IFVzZSBzZXBh
cmF0ZSBUWCBhbmQgUlggTkFQSSBwb2xsIGhhbmRsZXJzIHRvIGtlZXANCj4gY29tcGxldGlvbiBo
YW5kbGluZyBvbiBzYW1lIENQVSBhcyBUWC9SWCBJUlEuIEFkZGVkIGhhcmQvc29mdCBJUlENCj4g
YmVuY2htYXJrIGluZm9ybWF0aW9uIHRvIGNvbW1pdCBtZXNzYWdlLg0KPiANCj4gQ2hhbmdlZCBz
aW5jZSB2MTogQWRkZWQgYmVuY2htYXJrIGluZm9ybWF0aW9uIHRvIGNvbW1pdCBtZXNzYWdlLCBu
bw0KPiBjb2RlIGNoYW5nZXMuDQo+IA0KPiBSb2JlcnQgSGFuY29jayAoMik6DQo+ICAgbmV0OiBh
eGllbmV0OiBCZSBtb3JlIGNhcmVmdWwgYWJvdXQgdXBkYXRpbmcgdHhfYmRfdGFpbA0KPiAgIG5l
dDogYXhpZW5ldDogVXNlIE5BUEkgZm9yIFRYIGNvbXBsZXRpb24gcGF0aA0KPiANCj4gIGRyaXZl
cnMvbmV0L2V0aGVybmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldC5oICB8ICA1NCArKystLS0NCj4g
IC4uLi9uZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYyB8IDE2OCArKysr
KysrKysrLS0tLS0tLS0NCj4gIDIgZmlsZXMgY2hhbmdlZCwgMTI2IGluc2VydGlvbnMoKyksIDk2
IGRlbGV0aW9ucygtKQ0KPiANCg0KTG9va2luZyBhdCBQYXRjaHdvcmsgYW5kIExvcmUsIHNlZW1z
IGxpa2UgdGhpcyBjb3ZlciBsZXR0ZXIgbWF5IG5vdCBoYXZlIG1hZGUNCml0IHRvIHRoZSBsaXN0
LCB0aG91Z2ggdGhlIHR3byBwYXRjaGVzIGRpZD8gQ2FuIHJlc2VuZCBpZiBpdCBkb2Vzbid0IGV2
ZW50dWFsbHkNCnNob3cgdXAuLg0KDQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFyZHdh
cmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4uY29t
DQo=
