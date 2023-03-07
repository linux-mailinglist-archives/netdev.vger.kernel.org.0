Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932C26AD743
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 07:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbjCGGW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 01:22:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjCGGWx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 01:22:53 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2045.outbound.protection.outlook.com [40.107.104.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AABB6A9C9;
        Mon,  6 Mar 2023 22:22:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mKAKsYd8y//5LQbC6UP16rOsKYQ73biFTILwYQ3yhyY2xxOturnUIuG4RhBRRQRfVqFzUnuddsCrZq1mt4F6EFMdkmlTd6GBRgr3E+e9Hy+yyguev5YLHxELZoQ9BkIZaRf2MccG3xHFstZ/0o2HW1FIm75SCaHwKWP8cUkdr3uKejQ5KPNiGf9k+nND4VYA67idALhVNs05KTKGRPH0ggHNWs81HhCJDX9gb8fRO0MZbueaD0u5o/YTIUD9VyaGo+G0EqSOSRudUeQyYN36OxYXQKRkppN3SQnfBt7KB5d5sl393MJmk0Si8cY/PeS9ram9RJsHmnHACI9xzuym0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vfHKupRSCYX22GI9e01YhaZr3u+XrolJOj536K2CKRo=;
 b=aVGMr+uYGjcUwD3aAMlDnhnB0GUDyehE4BhTg7HEOwNYVk9rqxcGnD1VES7DELH3WS4sJNcrvrNujFMp1t0+rg+wd7DzidxKZ4YU4m/3gX9UiqOjNrvr1P7+4JtyunJD0ed4VSvviDTbZzA6p9NuDKdmLeuVm/poGcOFA0MsoqgycHrVysh4TUDXr+nU7eymLlxBU8GFgWFS05tV9yY61hAfnlcMon6lXWCgXbG2BdJ/S6XcVY3x6KSRrI/xQEDPsDsu7O1GIQRnx37O2dv12/n9DOGSQ3VnsFOGC4tAGazEjJ9Q9dIlgy+yo7StAuMEbPUNZJpmruErCufijZB1vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vfHKupRSCYX22GI9e01YhaZr3u+XrolJOj536K2CKRo=;
 b=i9dntkV6tPYUdf0SIFoBij6xo8VBT++GM4nU6/ZcE+CJj+4eISwH2XTm4at+tD+v0Dx39GqTMDz0yHLeiUGXoxpqoQ91Zo4eBQ/byS6kOMnGMmE31zImFIMnAAlqJnHkuMyNd89d3er5rO4QclTJFpoGb9xk7jR/YI9QeDg9438=
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com (2603:10a6:10:30c::10)
 by DUZPR04MB9782.eurprd04.prod.outlook.com (2603:10a6:10:4b1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 06:22:40 +0000
Received: from DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d]) by DB9PR04MB9648.eurprd04.prod.outlook.com
 ([fe80::c1c1:4646:4635:547d%6]) with mapi id 15.20.6156.025; Tue, 7 Mar 2023
 06:22:40 +0000
From:   Madhu Koriginja <madhu.koriginja@nxp.com>
To:     Paolo Abeni <pabeni@redhat.com>,
        "gerrit@erg.abdn.ac.uk" <gerrit@erg.abdn.ac.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Vani Namala <vani.namala@nxp.com>
Subject: RE: [EXT] Re: [PATCH] [net:netfilter]: Keep conntrack reference until
 IPsecv6 policy checks are done
Thread-Topic: [EXT] Re: [PATCH] [net:netfilter]: Keep conntrack reference
 until IPsecv6 policy checks are done
Thread-Index: AQHZTPlwZ/TDa2CkN0WefPEV2O4Tu67njFKAgAFD41CABg+1cA==
Date:   Tue, 7 Mar 2023 06:22:40 +0000
Message-ID: <DB9PR04MB9648C24BB1F7F9CECC810776FCB79@DB9PR04MB9648.eurprd04.prod.outlook.com>
References: <20230302112324.906365-1-madhu.koriginja@nxp.com>
 <3dc0b4652c04c508b21f2028a20b7f81387c7fd4.camel@redhat.com>
 <DB9PR04MB964835E3C87393525F85096FFCB39@DB9PR04MB9648.eurprd04.prod.outlook.com>
In-Reply-To: <DB9PR04MB964835E3C87393525F85096FFCB39@DB9PR04MB9648.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB9648:EE_|DUZPR04MB9782:EE_
x-ms-office365-filtering-correlation-id: c429f6c0-bb56-4d47-f914-08db1ed45a77
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7mu/6nXf9YnJfqQX0kBT6f02O7EtWdMo4jgIP9JBnAOrD3lROjtPAreMQ9BMnPvCZiZUCIj3uJKMOZpjveTxoV/JS+2epXA4UAtK5uQa3fcom1sjbHHdf95qMZA8zJbeRuIffQPh7SdbNpP6ZpvpSdq9eLxPd22pR6g9JeY5BlPq+kWqpSmywOgaRKbkMXW7VOE22gWnmlRRB46smnf4NsBXtUsXpirxFGO+Tk/YKkKy56rJdx+OXxUkfMp9A5pNn5WhMS8GUi1mz9W64r5WWKJl5piJ9BLNbA1G0QIYGLI8qyb/+Rj3qSr/6/48nqMv0RdmmaZQ+YP05pqoSW2C87791V5sjX+7eea3k3ulMxQocImEy2umpO/WJqQM4nFlDY+aAcIqysz76WiBMoGN4Bwof4mp/sxMqnN/RQUAB6xT1Q8zCp8w+on2ag8hFsjw38qNrbRfApxbUFyeTLj0KJun8I0xb7ZmsCPjF6+1yHoAv5myynbG5L77LoiXkMsyk6D+jMCBiMo7tKNTFVPkys3DdCBbaHIOgWnFbZQaRl+uuL3tE2UQIBH5VT9A3AMqf/+xRw45ajU1UseL0e65gUGWYXOo5W5fisQ6V1vCZpx9aCUgWo9P42wjL8uwb++IRaM/5WpZrTgyoW0CdnDUujxa2BI3AGFzjdfhBiPxj5byWkCHgnKH22oITlKpwwLV
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9648.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(346002)(366004)(376002)(451199018)(83380400001)(33656002)(478600001)(55016003)(316002)(122000001)(38100700002)(38070700005)(5660300002)(966005)(7696005)(6506007)(41300700001)(53546011)(110136005)(26005)(186003)(9686003)(71200400001)(66476007)(66446008)(44832011)(2906002)(64756008)(8936002)(76116006)(66946007)(52536014)(8676002)(66556008)(86362001)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Nnl5K2FVRDR3Q2l1ZHFDYmdqT1VzbG5JY2VLMEMwSlpwN1RoK242ZWoxYTgr?=
 =?utf-8?B?NjJkVjB6OGwxOVdTekUyZ1dFeTUxOElTNGk2VFdpS3lUMDRXTU9od3hGc3dM?=
 =?utf-8?B?WFl4ciswVGtvN1I5U0pBMVVyN0h2LzJzQlNDOWgvWlI0T2hXYXFjb3hsSTlW?=
 =?utf-8?B?K281Vk9ZcVhrUytVa3lHQkhGNEwzc2xPck1qVGlFbzlrVmtJYnZBckU2YUZT?=
 =?utf-8?B?TDl4cnBnVUNzNWFRSDhNVHlRd3Y2RXNHaEQ2b2taa3VRdFp1VVlmZW5IRWhF?=
 =?utf-8?B?Wkp4SWFEcVMydVZrVy9qYzVEK3lTRUkzOG15NEVtbzFmTjFINncyRnhyd0Yv?=
 =?utf-8?B?alFCamNpL253UGVoZnhTZDV4MzdPTXNGbTVZUnYzWWVTNkVzNVVjMmorVTlD?=
 =?utf-8?B?eWZEMkN2cmZlSE1nbXJVSE5GVjB5emRjVjFTSVN5Q3BOMzNya3Nnc1hENS9Z?=
 =?utf-8?B?Y3laajFJdmpqenRyMEtPejJhNG5tMDhQdCtKVGluY2hpT2FCNDhNYlMrU3cx?=
 =?utf-8?B?MFBxZndSVFcxMExhWGNiRFdWWnZJY00vblhOMWZpcXJzYm5lbDV5NTRHUUpY?=
 =?utf-8?B?blczYTlUNHRMNkVlSDZqaUVvOFV2ZXZ6c3lPTXFUNTlFSkxETlFsUTNHWTdk?=
 =?utf-8?B?L3RtYzRDbUFMdm5pSGJyeWFzMWhMTWp1N2NTTklIb0l0QzIwMEJ6dkdYb1E3?=
 =?utf-8?B?anNzbVNGR2M0ZGxXVVNTR0dqbk1BY01wZTBLSU5pSHhzZGxWWTVOZHVsRnh3?=
 =?utf-8?B?V0xTZlpmbEJodlhsQ1BNaVpHZ1NFWENmdkhWc2FIUWJDblZQWUtVb0syV0Qw?=
 =?utf-8?B?aXEwZ0R6M0FMSmJneVo1T0FtWk5NaC9TbE5ra0FUNWl3YmtxTjZqdkRXZ3By?=
 =?utf-8?B?T0FhdEpsbzdDdWNSa2pRRGY3bWNmMktaVE1QTitaM295MHRVc21ZZzJVaXg2?=
 =?utf-8?B?NFExTllIYndKTE9DcDJBU2tsWG03N0RnTmVLckpzUy9KN2thUTlhZFZNdVZP?=
 =?utf-8?B?QitGMVo2dWowSXc3Mm9Ja1hkSk9RakZmUzdldjQ0NlpxL3RHNGMxTTB1NU8w?=
 =?utf-8?B?bGxHYVV0QkoyRHI0c3l2TkFqb1E3NWxjRDVhQ3pnTVlPS0h6Z09CV2MzS2p6?=
 =?utf-8?B?bUI1TDFqT2JHK29BUFNRZXB2ZlQwK21ER3U5T0VnM3VoaVgrL2NZQVQwd1pu?=
 =?utf-8?B?aUVSb1I5TWRYVjNCV0dPUFd0eEVMQzAvOUhJWThQM1kwOEVvTWt4TkttbXZ1?=
 =?utf-8?B?Ly9ndXNBOVRmYml0TzlEdGdFL0ZkNkFGdUN6OFBXdTdMcmFraFk5Z1Uxd1o1?=
 =?utf-8?B?b0FrSHBlekdJbVNJdkRVS2JVNmJNMGVhTXozR1FzUnJ4c2R5SUhnN2JNYVlx?=
 =?utf-8?B?UURBNms0clQ3aEIxR0dpWktxRUxtb3kyL2tVMDZXUFp1NWF2dyt4ZFk3U1VI?=
 =?utf-8?B?cWtVd3FiWFdEZTNLbFhrZjhMVDFrZ3d3aFh1dHpuT0xuUVQyS3hSNTNTRWY4?=
 =?utf-8?B?djRiMnFkekN2aGZ3WTVMNnlXU2ZqSnZTU2VZQlNqalJTR3JyRUR2ZmkyMHRv?=
 =?utf-8?B?YWpzZC9LU3J1VUx3QzlveGRIMFl0TWgzL0VSV0dxcTBxWnd6K0FYR0pjWDBP?=
 =?utf-8?B?d0lJYm9CNEcxTmEwSHpEMVBjbSswVkZrbUgreGtiNjZhNnhUbVJZWVpNb0VF?=
 =?utf-8?B?NFJpSEY2a3M5NkR6ekptN2FtM0xoTm03SjI4UTJLN2JWNHA1M1hOQ3l5dVU2?=
 =?utf-8?B?MjhiV0VJbHV0cG1LUUcvSUVDb1Q2S1pLbHhINVgraFlJSjl0VXlOSUl0RktC?=
 =?utf-8?B?SGN4MDkybm5uZ1h2d2lscTZVRjQxZnNodGpDTXMra1NSTGgxVElPMVVBR1hJ?=
 =?utf-8?B?VW9QaE92VzBPRWpERU5VU3B5UjBwYmtHQVZmbFYrSmZNOWU0UFNaQ3JUdi9Z?=
 =?utf-8?B?YTFhK0JrazJCVUVZb0Zxa1Q1TlJmRGdSTHR2RHNmME51MFcrQjc1MDdPMmdG?=
 =?utf-8?B?ODBCYXkrUTgwNU5ndmRGZVIxZ0o0MVViaVpXSEVjM2VxZ0lPZHpKYlNJRC9y?=
 =?utf-8?B?NkxnUFptckJWeEJpa3BnZHdkbkRjendXREgyNFZ4WmVCWEp2NytEUnVyMWRH?=
 =?utf-8?Q?njsqoGL0U9Q0bMES63Ke9sC7h?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9648.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c429f6c0-bb56-4d47-f914-08db1ed45a77
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Mar 2023 06:22:40.2456
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nyzjqj0n7YUJAkfgQeSnVBkMM0Z81q2UsJnnXJ53NRnJURmb+45YxXK47Ix3XOBq6vjlglzoPCH1W4/gx86aoA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DUZPR04MB9782
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRmxvcmlhbi9QYW9sbywNCkFzIEZsb3JpYW4gc3VnZ2VzdGVkIEkgY2hhbmdlZCB0aGUgc3Vi
amVjdCB0aXRsZSwgZHVlIHRvIHRoaXMgcGF0Y2ggaXMgcHVzaGVkIGluIGRpZmZlcmVudCBsaW5r
LiBQbGVhc2UgZmluZCB0aGUgbmZfcmVzZXRfY3QgY2hhbmdlcyBwYXRjaCBpbiB0aGUgYmVsb3cg
bGluaw0KaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvbGttbC8yMDIzMDMwMzA5NDIyMS4xNTAxOTYx
LTEtbWFkaHUua29yaWdpbmphQG54cC5jb20vVC8NCg0KUGxlYXNlIGNhbiB5b3UgYWxzbyBzdWdn
ZXN0IG1lIGhvdyB0byBwdXNoIHBhdGNoIG9uIDQuMTkgTFRTIGtlcm5lbC4NCg0KVGhhbmtzICYg
UmVnYXJkcywNCk1hZGh1IEsNCg0KLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IE1h
ZGh1IEtvcmlnaW5qYSANClNlbnQ6IEZyaWRheSwgTWFyY2ggMywgMjAyMyAzOjIzIFBNDQpUbzog
UGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPjsgZ2Vycml0QGVyZy5hYmRuLmFjLnVrOyBk
YXZlbUBkYXZlbWxvZnQubmV0OyBrdXpuZXRAbXMyLmluci5hYy5ydTsgeW9zaGZ1amlAbGludXgt
aXB2Ni5vcmc7IGVkdW1hemV0QGdvb2dsZS5jb207IGRjY3BAdmdlci5rZXJuZWwub3JnOyBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQpDYzogVmFu
aSBOYW1hbGEgPHZhbmkubmFtYWxhQG54cC5jb20+DQpTdWJqZWN0OiBSRTogW0VYVF0gUmU6IFtQ
QVRDSF0gW25ldDpuZXRmaWx0ZXJdOiBLZWVwIGNvbm50cmFjayByZWZlcmVuY2UgdW50aWwgSVBz
ZWN2NiBwb2xpY3kgY2hlY2tzIGFyZSBkb25lDQoNCkhpIFBhb2xvLA0KIEkgdXBkYXRlZCB0aGUg
cGF0Y2ggd2l0aCBuZl9yZXNldF9jdCBjaGFuZ2UgKG5mX3Jlc2V0KCkgcmVwbGFjZWQgd2l0aCBu
Zl9yZXNldF9jdCkgdG8gYWxpZ24gd2l0aCB0aGUgbGF0ZXN0IGtlcm5lbCBjb2RlLiANCg0KSGkg
QWxsLA0KSSBhbHNvIHdhbnQgdG8gcHVzaCB0aGlzIGNoYW5nZSAod2l0aCBuZl9yZXNldCkgaW4g
NC4xOSBMVFMga2VybmVsLCBwbGVhc2UgY2FuIHlvdSB0ZWxsIG1lIGhvdyBjYW4gSSBwdXNoIHRv
IHRoYXQgdmVyc2lvbj8gVGhhbmtzIGluIGFkdmFuY2UuDQoNCiBIaSBGbG9yaWFuLA0KSW4gcGF0
Y2h2MyB1cGRhdGVkIHRoZSBzdWJqZWN0IGxpbmUgYXMgeW91IHN1Z2dlc3RlZC4NCg0KVGhhbmtz
ICYgUmVnYXJkcywNCk1hZGh1IEsgIA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJv
bTogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPg0KU2VudDogVGh1cnNkYXksIE1hcmNo
IDIsIDIwMjMgNzo1OCBQTQ0KVG86IE1hZGh1IEtvcmlnaW5qYSA8bWFkaHUua29yaWdpbmphQG54
cC5jb20+OyBnZXJyaXRAZXJnLmFiZG4uYWMudWs7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1em5l
dEBtczIuaW5yLmFjLnJ1OyB5b3NoZnVqaUBsaW51eC1pcHY2Lm9yZzsgZWR1bWF6ZXRAZ29vZ2xl
LmNvbTsgZGNjcEB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4
LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCkNjOiBWYW5pIE5hbWFsYSA8dmFuaS5uYW1hbGFAbnhw
LmNvbT4NClN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0hdIFtuZXQ6bmV0ZmlsdGVyXTogS2VlcCBj
b25udHJhY2sgcmVmZXJlbmNlIHVudGlsIElQc2VjdjYgcG9saWN5IGNoZWNrcyBhcmUgZG9uZQ0K
DQpDYXV0aW9uOiBFWFQgRW1haWwNCg0KT24gVGh1LCAyMDIzLTAzLTAyIGF0IDE2OjUzICswNTMw
LCBNYWRodSBLb3JpZ2luamEgd3JvdGU6DQo+IEtlZXAgdGhlIGNvbm50cmFjayByZWZlcmVuY2Ug
dW50aWwgcG9saWN5IGNoZWNrcyBoYXZlIGJlZW4gcGVyZm9ybWVkIA0KPiBmb3IgSVBzZWMgVjYg
TkFUIHN1cHBvcnQuIFRoZSByZWZlcmVuY2UgbmVlZHMgdG8gYmUgZHJvcHBlZCBiZWZvcmUgYSAN
Cj4gcGFja2V0IGlzIHF1ZXVlZCB0byBhdm9pZCBoYXZpbmcgdGhlIGNvbm50cmFjayBtb2R1bGUg
dW5sb2FkYWJsZS4NCj4NCj4gU2lnbmVkLW9mZi1ieTogTWFkaHUgS29yaWdpbmphIDxtYWRodS5r
b3JpZ2luamFAbnhwLmNvbT4NCj4gICAgICAgVjEtVjI6IGFkZGVkIG1pc3NpbmcgKCkgaW4gaXA2
X2lucHV0LmMgaW4gYmVsb3cgY29uZGl0aW9uDQo+ICAgICAgIGlmICghKGlwcHJvdC0+ZmxhZ3Mg
JiBJTkVUNl9QUk9UT19OT1BPTElDWSkpDQo+IC0tLQ0KPiAgbmV0L2RjY3AvaXB2Ni5jICAgICAg
fCAgMSArDQo+ICBuZXQvaXB2Ni9pcDZfaW5wdXQuYyB8IDE0ICsrKysrKystLS0tLS0tDQo+ICBu
ZXQvaXB2Ni9yYXcuYyAgICAgICB8ICAyICstDQo+ICBuZXQvaXB2Ni90Y3BfaXB2Ni5jICB8ICAy
ICsrDQo+ICBuZXQvaXB2Ni91ZHAuYyAgICAgICB8ICAyICsrDQo+ICA1IGZpbGVzIGNoYW5nZWQs
IDEzIGluc2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQo+DQo+IGRpZmYgLS1naXQgYS9uZXQv
ZGNjcC9pcHY2LmMgYi9uZXQvZGNjcC9pcHY2LmMgaW5kZXggDQo+IDU4YTQwMWU5Y2YwOS4uZWI1
MDMwOTZkYjZjIDEwMDY0NA0KPiAtLS0gYS9uZXQvZGNjcC9pcHY2LmMNCj4gKysrIGIvbmV0L2Rj
Y3AvaXB2Ni5jDQo+IEBAIC03NzEsNiArNzcxLDcgQEAgc3RhdGljIGludCBkY2NwX3Y2X3Jjdihz
dHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPg0KPiAgICAgICBpZiAoIXhmcm02X3BvbGljeV9jaGVjayhz
aywgWEZSTV9QT0xJQ1lfSU4sIHNrYikpDQo+ICAgICAgICAgICAgICAgZ290byBkaXNjYXJkX2Fu
ZF9yZWxzZTsNCj4gKyAgICAgbmZfcmVzZXQoc2tiKTsNCg0KbmZfcmVzZXQoKSBpcyBnb25lIHNp
bmNlIGNvbW1pdCA4OTViNWM5ZjIwNmUgKCJuZXRmaWx0ZXI6IGRyb3AgYnJpZGdlIG5mIHJlc2V0
IGZyb20gbmZfcmVzZXQiKSwgeW91IHNob3VsZCB1c2UgaW5zdGVhZCBuZl9yZXNldF9jdCgpOiBp
biB0aGUgY3VycmVudCBmb3JtIHRoZSBwYXRjaCBkb2VzIG5vdCBhcHBseSBjbGVhbmx5IChub3Ig
YnVpbGQgYWZ0ZXIgbWFudWFsIGVkaXQpLg0KDQoNCkNoZWVycywNCg0KUGFvbG8NCg0K
