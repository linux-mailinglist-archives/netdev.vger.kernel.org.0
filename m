Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C06C1523B49
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 19:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345382AbiEKRRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 13:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345375AbiEKRR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 13:17:29 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0746C30F71
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 10:17:24 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24BAnOt7017372;
        Wed, 11 May 2022 13:16:58 -0400
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2059.outbound.protection.outlook.com [104.47.60.59])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3g02p2rjwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 11 May 2022 13:16:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ecRM3ROv5gEb28Gt2ZDXdKDpn2zoY2W8K9fjDQeiZLbIvBHL3i6n0ywUNLN+8twee3nxDLy2evZjE6buSDkxzg4Riul4PvFwa1RVn4sK6ahH1gFh5J7WcD7276Y1pQcMyMhxxW3VPNBXraGH0gwtaagZi/eZxmklpGpO6MvXdwGrv5u9eQCVZur5VkStLRUkhXKO6QhCie0QVxIcZgZRgCbALjm+4b5LavqCBDU5MESKRqtcQiLLHJP1ZoPFd9jFOj0zErtvsijvdJS8lG6bzu7FmpNdqL4YroPELspeUr5io0XN94IU4C/J+u9AiigcgdK7ZOY8c/gZqv8wiLICmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G4JSMuSZBzwl7U8eyW9hQ0sY1wIdO3J9MHnLjY78sBg=;
 b=X3REUSVXuWEVHfde8uYxFdhUs6AjVwXU0dJZq6RNm8wEwUkyCYgzYWp04i3cT3CF1UL5oo7pUmtwoOYLaPLY+1MSIPI64VhESkvGS9WCYDE6SgyvDP2qB/PMfAtxbPgxdSaSJGnTXaYKEa8o+g2HQUU4KE6Tf7ZUVmZPtOsUNvLGdSjlcrcU68upqHB0RA37GPTKAQPT4OQPk9gl4Jm3Tc2DiBr/3A1daeQl8z7daV2RtUE+Q2z+/EVUXNzu8qt5H02NxFrmbNC5pBOswFkFNqvVbiETcGE15PbyAP0Lxz0AHidMX7LUp5N2LL1JiP/MWoLRTv+6xYHXGA7QrshSKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G4JSMuSZBzwl7U8eyW9hQ0sY1wIdO3J9MHnLjY78sBg=;
 b=T/rI0OtjRJR3ZAhDVySOItKz8FtRUEbhmJtEFKRo6uT7GfvOuYBA364XkI1mchs5IrG7qtbY+oe2tt5Mua2B78vGHEq3defU1qXSVPb34ZezDNPHtXLlRe90XugLNtWw8KcIBeUbRF3BmOIKxnuBZ9CvyG/W+QaMTuaqIzaKvF0=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YQBPR0101MB6457.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:48::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.13; Wed, 11 May
 2022 17:16:56 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::29ae:d7fe:b717:1fc4%6]) with mapi id 15.20.5227.023; Wed, 11 May 2022
 17:16:56 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v5] net: axienet: Use NAPI for TX completion path
Thread-Topic: [PATCH net-next v5] net: axienet: Use NAPI for TX completion
 path
Thread-Index: AQHYY8qJ43tH/5ZA6kC6YAy6Igrg/a0Y7R+AgAEBH4A=
Date:   Wed, 11 May 2022 17:16:55 +0000
Message-ID: <f3868a5f9abe263f4ebebd21382cd022afa6a029.camel@calian.com>
References: <20220509173039.263172-1-robert.hancock@calian.com>
         <20220510185639.1c6d6c8a@kernel.org>
In-Reply-To: <20220510185639.1c6d6c8a@kernel.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b5ca120f-363f-4c85-f7f8-08da33720cce
x-ms-traffictypediagnostic: YQBPR0101MB6457:EE_
x-microsoft-antispam-prvs: <YQBPR0101MB645771ABFA57CDAA66774087ECC89@YQBPR0101MB6457.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o7WUj/o1Hf+fVLwgE1LsGcU4la4z4C5ZZ1H4NsqFo78ovAe0LF1Anrae7Uj7mdQov4+d9UFOFbOly4EQ8y1SNjRUKXvSwATFKjx4RA2dqfXjXZQCalzaHMGg3L4VAwC+m9cJK4jhAjQqY9iWFl8s+FtYg3j8d6h8VQ9PZJerd2nJvcQep3Q/3ltly/e3sMBNF6Jmgsu34TIKOIGxEXAlXnHQQqacIP3nkHO04IabhouCLdZ57qyFaVFYQWEx/jjX53PqWLY4sEP9sD32Dwq9My1pfZ5H4KwkPEDMIBC39t/p0zaiEHS1BtSl169bXkucNePUN8uT5xSrDhOj0mb8aoF8bUtG1z5/+6PycCDTWdzH5TLAg5tAylxUfTDCR5Tl/ViOs7Lm2z7KX3Gs11daCC1rWQg9ziHZ4NrwvvILFv9v4YOUwvDGT73aW19Gypq+je9gcxpgCDTri+RpzZHhsLNmWKjDlQFXO77nOQrXMqwdr8eoX10BZwdWJEHCcofFKY+zBHaAdkt9XXTfUhutzNKDLfw2Cmm8L7nSTLEL7JWux4XNuBWQvZkpyrkmqRRphe0s5iczK8tk8nRtQtDXQ739txWmJ50ddrtwJjbmsa4vSMHNehN/cc3ps9JHbe04OuRDglM7Fj1kdjawAA41fjvPNiviM5LjzmCMmSALxXoH2gW7xK8dCfj4OUiFcH9x1kMdF25CP4+fQkEBsVtrLl3o45OZ4y9OiTR0gtg+SMLoKI4rPFLsxP/mCMIQJboF8pL+mbdBAlX5TThRTO27DBauwk+tgegpLAgLQsB8fTQSSAvqWwUhDCkRPQw1/Lbkrezp0HpEIuAMNhrLN/6bP/huN1COhZ8BikSQ/S4OQcc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(83380400001)(38100700002)(6506007)(122000001)(6916009)(54906003)(186003)(2616005)(8936002)(26005)(5660300002)(6512007)(66556008)(66946007)(76116006)(66476007)(2906002)(66446008)(64756008)(316002)(4326008)(8676002)(44832011)(6486002)(36756003)(15974865002)(86362001)(508600001)(71200400001)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFVMRkpDYVB2NnhGMVBSbTdCWlFzOGR5eDNiTVdJcXdSZm9mMmY4RFJZbTJW?=
 =?utf-8?B?eDZwL29uWkNDL21ndXh3bzNFVjZyOWdad2ZQd05tQzRSWVhSSWdibWtKZUZu?=
 =?utf-8?B?QjRBTnNqME5FeHNWZ1BDOTJ5RGh5ekFqRTg0aTF3anlPb0xkVWgrem0reDh3?=
 =?utf-8?B?NWJ4MzJKNTlGMGVGcEtid0E0RFpjVFYxcjVPOWJXZEFVQzRFQkdhWWZXbTFI?=
 =?utf-8?B?VUMvdXZONGhiNGphaFNQUjBJTXlNQXFuUjliQngxVDY3MllCcDN4QVhidlJ5?=
 =?utf-8?B?dVhSU253Z1pyNk5hOVNXQkgwd2d0bmxEYWtpbkxCYWtLRkxCTkFUOXhlZFA0?=
 =?utf-8?B?Vm93YUdZZDA5LzBGYkQxRUhMQWszTWQ5aWpVeGVwOHJrZTZxWVU2ZWFFSXVi?=
 =?utf-8?B?V3BvZFMyd2c5Q2tQejlwbWR1R3dDbUV0M1BCWlRnRkwyYnhOZ2trTDU4aW1V?=
 =?utf-8?B?U3hRN0dtSmh2MkxwSzQ4SVZLcm1PckJqV0Y1aHV6RHN6NjhpemtjWURLUUpp?=
 =?utf-8?B?RHQ3MnBKcmdlK21waEpWVWUvTmx5MTltYmxsWDNhdDZuYURrWUpLbVowTXc4?=
 =?utf-8?B?TEhNSFpLTGw2SEJIYVE1U1Fmd2NWZWJYcmFIZzVVQXY4djljWDFoTkdrYkdq?=
 =?utf-8?B?eE1iNDhsMDhyZ2VybXo5dFdVKzR0WWtscStMeG1EbUJOZE9nYm8xUVhlZGxO?=
 =?utf-8?B?bEhwM2FGQ0xZS1pTQWJ1OENGeG92NlNZa0ZUaHl5N0lLOE0yVTVzMS9CZ2xL?=
 =?utf-8?B?YUdET0ZxN01aOHZHY0pXbGgyNThGaTMxblFDaVpWR1BFSnE4MEJMM1E3NExG?=
 =?utf-8?B?ajBpd0NqSndyRzhPdW5TNnVLNklPcGRnTDcxUmx6QTFwVTVkVWF0NXQwTmV3?=
 =?utf-8?B?c0VTcHEyVHBPb0EyeFlEK2t6UWxZSVNrdjZ3RE5QbldveU1NQWplckxFUFZH?=
 =?utf-8?B?NzMvWVhvZUNSK3ozSHNkNGNuT1ZBVHY1RDNra1JvWHpKenNSWVJ6VDd3NmpP?=
 =?utf-8?B?Y2R0TGg5M21Kb1c5SVhBZk1mSzlvRlN1MnkrbXdkMUpxaW0xY0NwN0xzc21F?=
 =?utf-8?B?YW56QXdnSjBoL3JRWkhua0tWMXZUR3pYRUVmbW5kSEtqd2VHWEdDa3R5OURY?=
 =?utf-8?B?Q2lsNjlHM0VjR2JJT0hYcGZnTTZvMU1TTVRIVGgyZkRPRmJxcTBncE1OM04x?=
 =?utf-8?B?bUVZOElQejByYkdzcy9VMWFTbU4yUVc0M0Flam44dnpGRWt3SnpNOXh6MUpm?=
 =?utf-8?B?YVUrRWFVYnJNZ214M3BOaC93eElDTTU4a2doaS9wSW13dTFGRjNQVXU1MjUr?=
 =?utf-8?B?ZTVFU0NpU0UwZkZEVEw3RGVyVmZ1SkpTSkFqeVRmZTBRcFFqdzZYL1FMZmd1?=
 =?utf-8?B?K0szN0kxN3hqaXhYOHU2NWZRL3BBK2ZJMzRrbXhxMkxyN0FsSnVyOWRENjNu?=
 =?utf-8?B?WnFCSjR2VDh5cVkvVzdrazdZR25CQlJkY3NYWVZiSWdvYUtQSzE4RVdrd2pD?=
 =?utf-8?B?VVhnQ3BJNThmZFlhM0QxNi9vYW9MU2dieTErMHphRitORkR6QnlMTmZRc29k?=
 =?utf-8?B?UkJ3ZTlCQzBJUEQyR0VDWEZlR0JOZjNiTkFsZkt3WFgrVUpqeVp0eC9GMC9k?=
 =?utf-8?B?V0F3bWMyTmM2enJXY3lldkUwMFFscXdaSjVKRGtVVmtDVDJVQnNuOHJ2ek9q?=
 =?utf-8?B?S1pyR3RBU0RFWDRMRnVGczJUdUF5YlVpT3Y0SE1PRDNwOCtQbnBxbVVnaGhE?=
 =?utf-8?B?T2FFc3ZUTXl6OFNQamd1ZlB4R0k3MjJ0N2RqRXByZnd5NjM4ZnlQYmVyOHgz?=
 =?utf-8?B?Qzk2dklra2lQdlVEM1NJbjl0Y0VBand0TGIwQXYzTXp4U1B5N1czcDYzNG5O?=
 =?utf-8?B?dmdWaEFTbGRFWDFseXlCWWowUS9zaWdrU29DdnJvd1hVZGlSNi91NlV6cmtZ?=
 =?utf-8?B?YVVQRDNMZDBEelk5UXBLQk9CcGFXakdlMVJXNWtES1c0ekR1M2dUdkt4Ym1M?=
 =?utf-8?B?amdGaFlMWUcyR0tKMUxlZjBoVUttck5qaDRkZ2x1bHVyNzQrT0RwRmNUa1ZK?=
 =?utf-8?B?N2tKeUJNdzg2OXdmbDdsc2o4Qk9LUG9lV1U2WWZ0bVRhRG9UVmtYR2RaMU1G?=
 =?utf-8?B?ZDVtSFpySTQvRmZtZjZOOU5lclFyVUZPMENXUlc5ekVRMXhWRE84SFhrajV5?=
 =?utf-8?B?ZjNrY01leG1HamlOV0QxREZMaFN0N200RlNlK1FLUlJFMFJXaW1YczFsQnk4?=
 =?utf-8?B?ZlVGMTNZQVBPcTFGZWJpdjczRUdXK3dxajJRc3orQzZCMzk1QlJCN3JGSFJx?=
 =?utf-8?B?U2FlZHVDN3BZVktqZE1LRW0vSlZ6Q2N2TExYMHdQcEhnQjNrQ3RRMU5LVDNi?=
 =?utf-8?Q?dHRNWsWV5MMd/RQ0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D5B71C4DB66C7344A519CFD14024CE6C@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: b5ca120f-363f-4c85-f7f8-08da33720cce
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2022 17:16:55.9900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: g8fajYdmMY4v6aCVfhEhbTSto/DSza7ba2EfsuTKYoF8ux/o98ybPZOKkrEZkbIZoiyPCU0iUB4ijjZotB/JZji2Q2nx5pRIhXvyNfIUcBY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6457
X-Proofpoint-ORIG-GUID: E6rpzgch0Gicwnm5gF5X2FpN1sI1D2Ni
X-Proofpoint-GUID: E6rpzgch0Gicwnm5gF5X2FpN1sI1D2Ni
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-11_07,2022-05-11_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=6 mlxlogscore=117
 impostorscore=0 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0
 malwarescore=0 mlxscore=6 spamscore=6 lowpriorityscore=0 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205110078
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA1LTEwIGF0IDE4OjU2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAgOSBNYXkgMjAyMiAxMTozMDozOSAtMDYwMCBSb2JlcnQgSGFuY29jayB3cm90
ZToNCj4gPiBUaGlzIGRyaXZlciB3YXMgdXNpbmcgdGhlIFRYIElSUSBoYW5kbGVyIHRvIHBlcmZv
cm0gYWxsIFRYIGNvbXBsZXRpb24NCj4gPiB0YXNrcy4gVW5kZXIgaGVhdnkgVFggbmV0d29yayBs
b2FkLCB0aGlzIGNhbiBjYXVzZSBzaWduaWZpY2FudCBpcnFzLW9mZg0KPiA+IGxhdGVuY2llcyAo
Zm91bmQgdG8gYmUgaW4gdGhlIGh1bmRyZWRzIG9mIG1pY3Jvc2Vjb25kcyB1c2luZyBmdHJhY2Up
Lg0KPiA+IFRoaXMgY2FuIGNhdXNlIG90aGVyIGlzc3Vlcywgc3VjaCBhcyBvdmVycnVubmluZyBz
ZXJpYWwgVUFSVCBGSUZPcyB3aGVuDQo+ID4gdXNpbmcgaGlnaCBiYXVkIHJhdGVzIHdpdGggbGlt
aXRlZCBVQVJUIEZJRk8gc2l6ZXMuDQo+ID4gDQo+ID4gU3dpdGNoIHRvIHVzaW5nIGEgTkFQSSBw
b2xsIGhhbmRsZXIgdG8gcGVyZm9ybSB0aGUgVFggY29tcGxldGlvbiB3b3JrDQo+ID4gdG8gZ2V0
IHRoaXMgb3V0IG9mIGhhcmQgSVJRIGNvbnRleHQgYW5kIGF2b2lkIHRoZSBJUlEgbGF0ZW5jeSBp
bXBhY3QuDQo+ID4gQSBzZXBhcmF0ZSBwb2xsIGhhbmRsZXIgaXMgdXNlZCBmb3IgVFggYW5kIFJY
IHNpbmNlIHRoZXkgaGF2ZSBzZXBhcmF0ZQ0KPiA+IElSUXMgb24gdGhpcyBjb250cm9sbGVyLCBz
byB0aGF0IHRoZSBjb21wbGV0aW9uIHdvcmsgZm9yIGVhY2ggb2YgdGhlbQ0KPiA+IHN0YXlzIG9u
IHRoZSBzYW1lIENQVSBhcyB0aGUgaW50ZXJydXB0Lg0KPiA+IA0KPiA+IFRlc3Rpbmcgb24gYSBY
aWxpbnggTVBTb0MgWlU5RUcgcGxhdGZvcm0gdXNpbmcgaXBlcmYzIGZyb20gYSBMaW51eCBQQw0K
PiA+IHRocm91Z2ggYSBzd2l0Y2ggYXQgMUcgbGluayBzcGVlZCBzaG93ZWQgbm8gc2lnbmlmaWNh
bnQgY2hhbmdlIGluIFRYIG9yDQo+ID4gUlggdGhyb3VnaHB1dCwgd2l0aCBhcHByb3hpbWF0ZWx5
IDk0MSBNYnBzIGJlZm9yZSBhbmQgYWZ0ZXIuIEhhcmQgSVJRDQo+ID4gdGltZSBpbiB0aGUgVFgg
dGhyb3VnaHB1dCB0ZXN0IHdhcyBzaWduaWZpY2FudGx5IHJlZHVjZWQgZnJvbSAxMiUgdG8NCj4g
PiBiZWxvdyAxJSBvbiB0aGUgQ1BVIGhhbmRsaW5nIFRYIGludGVycnVwdHMsIHdpdGggdG90YWwg
aGFyZCtzb2Z0IElSUSBDUFUNCj4gPiB1c2FnZSBkcm9wcGluZyBmcm9tIGFib3V0IDU2JSBkb3du
IHRvIDQ4JS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnQgSGFuY29jayA8cm9iZXJ0
LmhhbmNvY2tAY2FsaWFuLmNvbT4NCj4gPiAtLS0NCj4gPiANCj4gPiBDaGFuZ2VkIHNpbmNlIHY0
OiBBZGRlZCBsb2NraW5nIHRvIHByb3RlY3QgVFggcmluZyB0YWlsIHBvaW50ZXIgYWdhaW5zdA0K
PiA+IGNvbmN1cnJlbnQgYWNjZXNzIGJ5IFRYIHRyYW5zbWl0IGFuZCBUWCBwb2xsIHBhdGhzLg0K
PiANCj4gSGksIHNvcnJ5IGZvciBhIGxhdGUgcmVwbHkgdGhlcmUncyBqdXN0IHRvbyBtYW55IHBh
dGNoZXMgdG8gbG9vayBhdA0KPiBsYXRlbHkuDQo+IA0KPiBUaGUgbG9jayBpcyBzbGlnaHRseSBj
b25jZXJuaW5nLCB0aGUgZHJpdmVyIGZvbGxvd3MgdGhlIHVzdWFsIHdha2UgdXAgDQo+IHNjaGVt
ZSBiYXNlZCBvbiBtZW1vcnkgYmFycmllcnMuIElmIHdlIGFkZCB0aGUgbG9jayB3ZSBzaG91bGQg
cHJvYmFibHkNCj4gdGFrZSB0aGUgYmFycmllcnMgb3V0Lg0KDQpTbyB0aGVyZSdzIGJhc2ljYWxs
eSB0d28gcGxhY2VzIHdoZXJlIHRoZXJlIGlzIGNvbnRlbnRpb24sIGF4aWVuZXRfc3RhcnRfeG1p
dA0Kd2hlcmUgaXQgaXMgbW92aW5nIHRoZSB0YWlsIHBvaW50ZXIgZG93biBhZnRlciBhZGRpbmcg
bW9yZSBlbnRyaWVzIHRvIHRoZSBUWA0KcmluZywgYW5kIHRoZSBUWCBwb2xsIGZ1bmN0aW9uIGNh
bGxpbmcgYXhpZW5ldF9jaGVja190eF9iZF9zcGFjZSB3aGVyZSBpdCBpcw0KdXNpbmcgdGhlIHRh
aWwgcG9pbnRlciB0byBzZWUgaWYgdGhlcmUgaXMgZW5vdWdoIHNwYWNlIGluIHRoZSBUWCByaW5n
IHRvIHdha2UNCnRoZSBxdWV1ZS4gSSBzdXBwb3NlIGJhcnJpZXJzIGFyZSBsaWtlbHkgc3VmZmlj
aWVudCBpZiB0aGUgY29kZSB1cGRhdGluZyB0aGUNCnJpbmcgcG9pbnRlciBpcyBtb3JlIGNhcmVm
dWwgYWJvdXQgaG93IGl0IGlzIGRvbmUgLSBmb3IgZXhhbXBsZSBpbiB0aGUgc25pcHBldA0KcXVv
dGVkIGJlbG93LCBpdCdzIG1vdmluZyB0aGUgcG9pbnRlciBkb3duIGFuZCB0aGVuIG1vdmluZyBp
dCBiYWNrIHRvIDAgaWYgaXQNCmlzIHBhc3QgdGhlIGVuZCBvZiB0aGUgcmluZzsgdGhpcyB3b3Vs
ZCBuZWVkIHRvIGNoYW5nZSB0byBvbmx5IHVwZGF0ZSB0aGUNCnBvaW50ZXIgb25jZSBhbmQgbm90
IGhhdmUgdGhlIGludGVybWVkaWF0ZSBzdGF0ZSB3aGVyZSBpdCBpcyBhdCBhbiBpbnZhbGlkDQpw
b3NpdGlvbi4NCg0KSSB0aGluayB0aGUgc3RhYmlsaXR5IGlzc3VlIEkgc2F3IGVhcmxpZXIgd2Fz
IG5vdCBhY3R1YWxseSBkdWUgdG8gdGhlc2UgY2hhbmdlcw0KaG93ZXZlciwgYnV0IHRvIHNpbWls
YXIgY2hhbmdlcyBpbiB2MSBvZiB0aGUgIm5ldDogbWFjYjogdXNlIE5BUEkgZm9yIFRYDQpjb21w
bGV0aW9uIHBhdGgiIHBhdGNoLiBJbiB0aGUgY2FzZSBvZiB0aGF0IGRyaXZlciwgaXQgd2FzIHBy
ZXZpb3VzbHkgcmVseWluZw0Kb24gdGhlIFRYIGNvbXBsZXRpb24gcGF0aCBiZWluZyBwcm90ZWN0
ZWQgYnkgYSBzcGlubG9jayBpbiB0aGUgSVJRIGhhbmRsZXIsDQp3aGljaCB3YXMgbG9zdCB3aGVu
IHRoZSBUWCBjb21wbGV0aW9uIHdhcyBtb3ZlZCB0byBhIHBvbGwgZnVuY3Rpb24uDQoNCj4gDQo+
IFdlIGNhbiBhbHNvIHRyeSB0byBhdm9pZCB0aGUgbG9jayBhbmQgZHJpbGwgaW50byB3aGF0IHRo
ZSBpc3N1ZSBpcy4NCj4gQXQgYSBxdWljayBsb29rIGl0IHNlZW1zIGxpa2UgdGhlcmUgaXMgYSBi
YXJyaWVyIG1pc3NpbmcgYmV0d2VlbiBzZXR1cA0KPiBvZiB0aGUgZGVzY3JpcHRvcnMgYW5kIGtp
Y2tpbmcgdGhlIHRyYW5zZmVyIG9mZjoNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9l
dGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYw0KPiBpbmRleCBkNmZjM2Y3YWNkZjAu
LjllMjQ0YjczYTBjYSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQveGlsaW54
L3hpbGlueF9heGllbmV0X21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC94aWxp
bngveGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+IEBAIC04NzgsMTAgKzg3OCwxMSBAQCBheGllbmV0
X3N0YXJ0X3htaXQoc3RydWN0IHNrX2J1ZmYgKnNrYiwgc3RydWN0DQo+IG5ldF9kZXZpY2UgKm5k
ZXYpDQo+ICAJY3VyX3AtPnNrYiA9IHNrYjsNCj4gIA0KPiAgCXRhaWxfcCA9IGxwLT50eF9iZF9w
ICsgc2l6ZW9mKCpscC0+dHhfYmRfdikgKiBscC0+dHhfYmRfdGFpbDsNCj4gLQkvKiBTdGFydCB0
aGUgdHJhbnNmZXIgKi8NCj4gLQlheGllbmV0X2RtYV9vdXRfYWRkcihscCwgWEFYSURNQV9UWF9U
REVTQ19PRkZTRVQsIHRhaWxfcCk7DQo+ICAJaWYgKCsrbHAtPnR4X2JkX3RhaWwgPj0gbHAtPnR4
X2JkX251bSkNCj4gIAkJbHAtPnR4X2JkX3RhaWwgPSAwOw0KPiArCXdtYigpOyAvLyBwb3NzaWJs
eSBkbWFfd21iKCkNCg0KSSB0aGluayB0aGUgTU1JTyB3cml0ZSBpbiBheGllbmV0X2RtYV9vdXRf
YWRkciBpcyBzdXBwb3NlZCB0byBiZSBhbiBpbXBsaWNpdA0KYmFycmllciwgc28gdGhhdCBzaG91
bGRuJ3QgYmUgbmVlZGVkPw0KDQo+ICsJLyogU3RhcnQgdGhlIHRyYW5zZmVyICovDQo+ICsJYXhp
ZW5ldF9kbWFfb3V0X2FkZHIobHAsIFhBWElETUFfVFhfVERFU0NfT0ZGU0VULCB0YWlsX3ApOw0K
PiAgDQo+ICAJLyogU3RvcCBxdWV1ZSBpZiBuZXh0IHRyYW5zbWl0IG1heSBub3QgaGF2ZSBzcGFj
ZSAqLw0KPiAgCWlmIChheGllbmV0X2NoZWNrX3R4X2JkX3NwYWNlKGxwLCBNQVhfU0tCX0ZSQUdT
ICsgMSkpIHsNCi0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNpZ25lciwg
Q2FsaWFuIEFkdmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20NCg==
