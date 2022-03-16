Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4F44DBA03
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 22:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352738AbiCPVQa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 17:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245345AbiCPVQ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 17:16:27 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE8631DD9
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 14:15:12 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22GAVjo4001499;
        Wed, 16 Mar 2022 17:14:57 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2059.outbound.protection.outlook.com [104.47.60.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3et64ksyja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 16 Mar 2022 17:14:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SlDQZ7VzP28pHunqVNzQNfqJwefKSoQ/1hb3leywAv5eoe2Wdr52lNj5B3HyHrNF1gF/ZZrATcq2nQ7gaGWBwHFCc0svoYQZTk2ERRRS18NRFawcnicfJBt8M7qVP8nCDwtqS8sOG+K10HSvmxw7M8QFfiF/yC3mjs2c/OG2OJiKMbzgnBzF0bTy5a8w0WCECmdJHkeEbYAEfJv0JAWPIkBNvAyuvx+wQFk2nXHwYZQrpcvSyDxaqhk9QWmTPw8vat33T55929pJOYluogEduOWtSgP6L/Nplp7QjtEMRgtlgBJJsbWzEqiEwHjB/NPZjj0sD/CHEPF3XnR5CYNnVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lo/c3mkxDtQeXfuABgP2xJzzDnuUdyV/JVpM6CLPIoU=;
 b=K+09fLd1qfokyTWI1kDDNH0jVfw0dCog9JgbL/1Zn+d+pPI6urOf0jebYKoB9jJCqP6x3ldpzmT6ZAJHiZxXz92Qs+/JQslV2p0BUYGNjCm36HhH1/Q7AK8FECK9JWrc94a+lxWOy6asd+U78jeUPHfxwM2VuosFZL4AoVj95NO+0IVC04Jf6JtuarDWpWlujJ4273jqe459NtjGIfavRYPgekk0tjHfrjdBNdwcJQVBFcGYtYOW94crZ7XoR/igWQCxgOMnkpPIZlxxHrK5R/pSAJ2RrArqakKSnkliFevRemDzvVYVDEpe2tm1dPPRWM+g7F6lOixKygoFSLSCzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lo/c3mkxDtQeXfuABgP2xJzzDnuUdyV/JVpM6CLPIoU=;
 b=heWTRMOzUnR35IlDVLsW2y9DnKLRET7PlIqNxkE0ltqoTgZ5KsHRYrw6doGuRZlHuVyNS/8ozflDhuVA+xH50WvDE2KrM54p5Vnd3wUCmTVyTV9YtH90MaJBfLPtjU1Ynr2iJmeksHc3RfgKPQBKAhmetgzpQ5YYMxilroYP8ow=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB4479.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.14; Wed, 16 Mar
 2022 21:14:55 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5061.024; Wed, 16 Mar 2022
 21:14:55 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "andy.chiu@sifive.com" <andy.chiu@sifive.com>
CC:     "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "greentime.hu@sifive.com" <greentime.hu@sifive.com>
Subject: Re: [PATCH] net: axiemac: use a phandle to reference pcs_phy
Thread-Topic: [PATCH] net: axiemac: use a phandle to reference pcs_phy
Thread-Index: AQHYOXrhhmIwdkWDGU278q9LMOpIgg==
Date:   Wed, 16 Mar 2022 21:14:55 +0000
Message-ID: <fc427c42d37489935c5f71acf02860904f6150dc.camel@calian.com>
In-Reply-To: <20220316075953.61398-1-andy.chiu@sifive.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd99c72e-3ea5-448d-8a29-08da079204cf
x-ms-traffictypediagnostic: YT2PR01MB4479:EE_
x-microsoft-antispam-prvs: <YT2PR01MB447992A5F06F5F6A2152C548EC119@YT2PR01MB4479.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q3JO2fn96BMmDQuidKHBmGdK9ImAnyi4lQRChkhvUBWxDdC/lT0BVXbajSASADDSM4e67PUKvUljqgEYEuiBBqG62/zEXadcTpCrO9JOQt/Awt7K32dDzqaM4p2RECc92khBpItsf5XVQggSgcaBLl3c/27EU+61bBNm7pu/d/ExFMfTKwXTpZRaDiqn+TrGtc4xD5A6ywZJJRkFycwayLn3+vJBLq4O17+sM40oxwm7LB0jetHoDG4KOMgZieYaTXh6cbb6nmBpR2ykCU9234TA8keQ10CD10ImlMGSwaQwXP99Ur4rB7A5gVLzEnNvaHYfW4tMCY98G+Lk5ex9gemtByxImx4CIn0wHx4p5xF41Fww7vK6RFVJ7tfoVqq5uPgBqjAJGZcP2UelytbB9aDEbUuK6TnGP81/luPLDQ7syXzv/HzYocmnZkPcnNykOLzHXpDuaWkNgfw2t7rBgkxogYxvPkQa40oBVFl3GQk9CgV2FTp6rUBWf/9Rs1+x1gCz/f6/SQQAQG8c3+yK/2Sn/CUoQbUM/HFji4xdjuDl+o5pn0Js6RVwkqQelsnbCGbxTCecOTQYapNHxll7ux8Bise7Zncr755lFRaicC4EdbD8DjT05xRpHuomR1851ZJxETIH2u8pPqCHghYcJHkMdp0UHm+UJH5X+CNJBM3nMmToBj/RF9PWIUxiwE/yDlGyJUDhxVFALlKPKgVmLOEgrtcg9SOZMlI5jz/MmJb3KVRJ6OBWwoppE+Ws1mOH+qfGngQDVJBdzNihXzB3R03QuQr9S1hlsR8w2BqLbls8ABy+sJ0MXAs6FQKDoAekfOJV/2sENL61UCB7Kc91cg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(38100700002)(86362001)(38070700005)(122000001)(6916009)(316002)(6506007)(6512007)(26005)(2616005)(186003)(6486002)(508600001)(966005)(4326008)(54906003)(71200400001)(44832011)(8676002)(5660300002)(64756008)(8936002)(66476007)(91956017)(76116006)(66556008)(66946007)(66446008)(83380400001)(15974865002)(36756003)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cmN6Nkp0YTlTR0hSenJVSjBxQ2prYTBlNDU2MnBKVjhVcWNMa0c1ZjdLK1Bo?=
 =?utf-8?B?RVR3VGI0WnAzYnliYWxaRXpQSlF1QVMwNS9Id3dBTWpKNHpKUndHR2d0RkxW?=
 =?utf-8?B?am1KUG9aNEVFNU5kMkdSbGFuZ0VlTGhMbHBxMkR2VlVNZFN6cmlxdVBacC9E?=
 =?utf-8?B?OTdsWlJZcThjVmxRdFc0OGhxbE10NnQ0WjZtUGlrMWhhdkhIdVBRUUVBaXFG?=
 =?utf-8?B?RHVrRkl1Ni9NcC9weUpRVE9sb1FFRy9pSVA1Z1l0QTcwUXFlN1pUR3hxUCs0?=
 =?utf-8?B?WmFlMk05S1NPV2tNS2wweSt5VWVsdk0wLzkrSWYyZm5jWEtKYUgzb1VDM0lu?=
 =?utf-8?B?ckVxWElPUDBtUWZ4byttc0gvTHZKamhaUnpMa2MyeFJ2WUFrOUorYkMwK3Rv?=
 =?utf-8?B?NkNmTkNaY1BuTTEzU2pQajJqSWJpS0VYb0h2MGZpSzgrNG5sZTFpRXdLaENS?=
 =?utf-8?B?bE5MZEZIYyswTG0zbGZzZFB2d3dZbW9GZW5KV2NSek5ncnlqbENZSm1EY0M4?=
 =?utf-8?B?N0N6UXZsZUtlVzdVRnVrcFVrVHBtREJLa3MvQmZwRENSOEJwK2xWWkxQOXM0?=
 =?utf-8?B?emVCOFFZVjZsQm1kRFRLOHFRVmVmYXl0U0JveTlHdGZiaGlrU2pGNzF6bXlI?=
 =?utf-8?B?ZFZHMTlGbU1CTjcxRll5MnBrZ3M2VTJhNDNHMEUzOURSZVZTUE5kV3lZWEJV?=
 =?utf-8?B?YWZ4TEo2dlNkenN4RnZvSk5JNnVqdGs5QzQ4NlVGakZZaUovbUJEaXljRkEx?=
 =?utf-8?B?U056R2Q4UWJUSzJQbStHQ2NDUFptQ21LT2k3R09oNkRiZVVnT25laDNWR3V4?=
 =?utf-8?B?Tkl2K0RBb20ydVZHVEx1U1FocmlBa0JMRnBBbVlraWxSOWdRT08weTJiL1pl?=
 =?utf-8?B?cUpISUpVV1hodkVvUldDWTlIcWpva2c4Q2NHVVZTaHVyeFY2QzBMRDh2alpM?=
 =?utf-8?B?ZFkxTWdZRzBCbzdMaURLV0doTmxBRExXOXYxT3BpUU56dWNRTkU4YTI5Q1dk?=
 =?utf-8?B?TDR5amdVakdmbFR1YmowVlRmZCtjcCtxZ3lKMGpDUFNFWTkwOUJJNjh5Z1lB?=
 =?utf-8?B?VFhGVWRXSUxnb3M4eG9kVmNvK1dYYkxUY3d0ZVFJTWhIYUMyV05Odkkvbmhn?=
 =?utf-8?B?UXVjN1Y5WkhNenV3UExpSFlGeitoWmRTMVZsVmJ6aXBGSVlCdzZtaG8yMXcx?=
 =?utf-8?B?NVFzdTE5MGZPcEo0Y25oVlNRSCtGbFVUK3hEa0x5OGV5Q3pmUmNZYWsyMkZZ?=
 =?utf-8?B?UHJ3Q2pSYk96SS9ybGx5cnhXTE1EMlhFQWdNaDhYdjdFQ1B2Z1BXay94QmRS?=
 =?utf-8?B?YVE1MEN0RHpEOTNpK3hvWVJHN1RZVzVjb09vYkFSb3NFcUlvT1hPWjdmbktu?=
 =?utf-8?B?bDVzTUlEejZxYzBlTUc0M3NVZzRwaExldzVaSjlxbEJjeHdraDM5Wng1Zmpj?=
 =?utf-8?B?OWJMMkd0LzZNV3ZjaTRncEVXWW5UZTBiaHgwUWJmUlh2bXFhRG9tSm5OSVZt?=
 =?utf-8?B?R2dhN3BaNkxUMnFPMFFMTVZGM3htSS9VRUVKMTNTZTIvaGlKVVh2em94clpY?=
 =?utf-8?B?cXBuUFg0andPdVBKMGp6eVFsSENId1UxUW1SQjd1YnF1bEpuWUg2TjI4Tlo3?=
 =?utf-8?B?aW5JQ1RLRnp5MWlpbTRKb3BXNjRlK1pmc04wdWFuSTg4cXBROUFyZkNrakQ0?=
 =?utf-8?B?cy9OckdzUDk4bFlsbkh6Y0dzWXlZY0hoMHFRNkNxMEg1bDNtbGlva3dFVUts?=
 =?utf-8?B?STNXUHczZlVha05pMGFKaUJTQUNnd2N6RG84T2MzSW1TT3U3Wk55RnByMTBM?=
 =?utf-8?B?K0VySXFhYnhnTFJwSE1PTnJ2S1FQcFJHWFRVZEFVTG9iVDNIeHBZd3B1SzdC?=
 =?utf-8?B?TVlmdStVNDd1OE9kcS9Bd2d1R0xreml3K0czakZTQWxqbDVjYzdOdkM1dHRi?=
 =?utf-8?B?dzVGVHd6UTNtdGp6aGx6QkpKakRvdFVsWkZIeUdwMy9ReHRnZFQwTjRzOXBi?=
 =?utf-8?Q?8VSQ71A/UlvtINFPUPkyQQL47TfhJA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A392FAF759020341B2F08C558D7CB703@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: bd99c72e-3ea5-448d-8a29-08da079204cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2022 21:14:55.3207
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Htkw0GK6jQtyugWxo94sewvlPQN7Ezj8vZXzFhEi857lhmiHwhPQLut7YuIzk8j+/9xr0FEqaxkEGw+bOTItZWONBQ02VMkAcz8AqyP4MRs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB4479
X-Proofpoint-GUID: 4kMv74mF9W4Rqbjln3KTNEBcClb7muiu
X-Proofpoint-ORIG-GUID: 4kMv74mF9W4Rqbjln3KTNEBcClb7muiu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-16_09,2022-03-15_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 phishscore=0
 priorityscore=1501 spamscore=0 adultscore=0 bulkscore=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 mlxlogscore=948 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203160128
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UmU6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC8yMDIyMDMxNjA3NTk1My42MTM5OC0xLWFu
ZHkuY2hpdUBzaWZpdmUuY29tLw0KKGxvb2tzIGxpa2UgSSB3YXMgQ0NlZCB3aXRoIHRoZSB3cm9u
ZyBlbWFpbCk6DQoNCkkgdGhpbmsgd2UgbGlrZWx5IG5lZWQgc29tZXRoaW5nIHNpbWlsYXIgdG8g
dGhpcyBmb3IgdGhlIHVzZSBjYXNlIChJIGFzc3VtZSkNCnlvdSBoYXZlLCB3aGVyZSB0aGVyZSdz
IGFuIGV4dGVybmFsIFNHTUlJIFBIWSBhcyB3ZWxsIGFzIHRoZSBpbnRlcm5hbCBQQ1MvUE1BDQpQ
SFkgd2hpY2ggYm90aCBuZWVkIHRvIGJlIGNvbmZpZ3VyZWQuIEhvd2V2ZXIsIHdlIChhbmQgcG9z
c2libHkgb3RoZXJzKSBhbHJlYWR5DQpoYXZlIHNvbWUgY2FzZXMgd2hlcmUgdGhlIGNvcmUgaXMg
Y29ubmVjdGVkIHRvIGFuIFNGUCBjYWdlLCBwaHktaGFuZGxlIHBvaW50cw0KdG8gdGhlIGludGVy
bmFsIFBDUy9QTUEgUEhZLCBhbmQgdGhlIGV4dGVybmFsIFBIWSAtIGlmIG9uZSBleGlzdHMgYXQg
YWxsIC0gaXMNCm5vdCBpbiB0aGUgZGV2aWNlIHRyZWUgYmVjYXVzZSBpdCB3b3VsZCBiZSBvbiBh
biBTRlAgbW9kdWxlLg0KDQpBbHNvLCBhcyBKYWt1YiBtZW50aW9uZWQsIGl0IGxvb2tzIGxpa2Ug
b3RoZXIgZHJpdmVycyBsaWtlIGRwYWEyIHVzZSBwY3MtaGFuZGxlIA0KZm9yIHRoaXMuDQoNClBv
c3NpYmx5IHNvbWV0aGluZyBsaWtlOiBpbiB0aGUgMTAwMEJhc2UtWCBvciBTR01JSSBtb2Rlcywg
aWYgcGNzLWhhbmRsZSBpcw0Kc2V0LCB0aGVuIHVzZSB0aGF0IGFzIHRoZSBQQ1Mgbm9kZSwgb3Ro
ZXJ3aXNlIGZhbGwgYmFjayB0byBhc3N1bWluZyBwaHktaGFuZGxlDQpwb2ludHMgdG8gdGhlIFBD
Uy4gSXQgc2hvdWxkIG5vdCByZXF1aXJlIHRoYXQgYm90aCBhcmUgcHJlc2VudCwgc2luY2UgZXZl
biBpbg0KdGhlIHB1cmUgU0dNSUkgY2FzZSwgdGhlIFBIWSBjb3VsZCBzdGlsbCBiZSBzdXBwbGll
ZCBieSBhbiBTRlAgbW9kdWxlDQpkb3duc3RyZWFtLg0KDQotLSANClJvYmVydCBIYW5jb2NrDQpT
ZW5pb3IgSGFyZHdhcmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3
dy5jYWxpYW4uY29tDQo=
