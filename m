Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EA744B22AD
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 11:02:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240856AbiBKKB7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 05:01:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236306AbiBKKB6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 05:01:58 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2121.outbound.protection.outlook.com [40.107.237.121])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D197A133
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 02:01:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XGjrvVmZE+XQTUKmbZQ2Se9MOMtpaLvbrzsJ8CsgqLN3wxP8EWzc8+5bxnx7wgf6Ocw/vf5fBmdSo+dX9I/CIyGmHP4RjBtXbTjG8SFBsh7Hvva1tfZy2e7YpubAM5VuDq9ukfech2yNkHSid5kp0NoC19/vFJ6mK6YrEt/HEKjn7QIH/rCIi6FksA06pjFzzbjy0u/jGyr7vpmPrvBmaeR38TLHremMhXXQ6c/oSZ7K82h7XdGEBCHfyYh7nozQcjc2jUL5SKmx4CIJ+WPbc84HMEl5vrvkLV6s5y5CG8krnJ2clq1Yhvxrh1R/6xsyzqui1YEURt0WDxWkypU8kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HkzhqxHr2b3pllPr0GGqkJj9FVrlxnPGBsoATZKrZwU=;
 b=gtp9JEvyC2fdU57OcQr/uVbKpp9k7focRsQu42J4JxFwNrW5n9aC0z9qah55Ex75i2jNjgYieTdnkXGyPmheMPM2Rndj8iRkRkBrPeopRnuQM9hHTvvJ+0VEDFv8zzsJJ/v2Wpn2DzpvyfoPb0qXWoi15KvK4+NA2sztZZJfKnlQ7KLp6YsZdiDHXofpxIfash2GSB1DSCXofRuXD1ZwcbnYcttHdu3onWHLeOJQ9PHPbV5uzscOwPWtcBBnUwPGN6ux6g3iai8V+I2Qk4TmXxs3t4zKOS37btaWJMWo7sRG1gMT0i8BcwzygP/YTvGRJcWsDnXWUvcvDpj27DmM9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HkzhqxHr2b3pllPr0GGqkJj9FVrlxnPGBsoATZKrZwU=;
 b=d5/5l5JQu1BXC45uwHt1GYovGoMWd/970Yt42mzhUPasfa7N11N/Lip9dq1/1tmJep20jYs4Qj699OM8FzCcQ0QZ5yDQL+fYiEYf3xSMiXE6v+aeuOppAWN2s7AYleQUw0+4povc5Zidrma4WJRCiYP4S/W7zTWKXYFKjoUbStw=
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com (2603:10b6:4:2d::21)
 by DM8PR13MB5078.namprd13.prod.outlook.com (2603:10b6:8:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.8; Fri, 11 Feb
 2022 10:01:54 +0000
Received: from DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::8c81:def2:4bf8:3995]) by DM5PR1301MB2172.namprd13.prod.outlook.com
 ([fe80::8c81:def2:4bf8:3995%5]) with mapi id 15.20.4975.011; Fri, 11 Feb 2022
 10:01:54 +0000
From:   Baowen Zheng <baowen.zheng@corigine.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>, Roi Dayan <roid@nvidia.com>,
        Victor Nogueira <victor@mojatatu.com>
CC:     David Ahern <dsahern@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        oss-drivers <oss-drivers@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: RE: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Thread-Topic: [PATCH iproute2-next v2] tc: add skip_hw and skip_sw to control
 action offload
Thread-Index: AQHYEoG1Et1s4gxqYUSe1W65rALAhKx1T7gAgAhAIoCAAmveAIAAAheAgAAHpsCAACrBgIAOAWcA
Date:   Fri, 11 Feb 2022 10:01:53 +0000
Message-ID: <DM5PR1301MB21722969131F70DD7FA350EFE7309@DM5PR1301MB2172.namprd13.prod.outlook.com>
References: <1643180079-17097-1-git-send-email-baowen.zheng@corigine.com>
 <CA+NMeC_RKJXwbpjejTXKViUzUjDi0N-ZKoSa9fun=ySfThV5gA@mail.gmail.com>
 <b24054ae-7267-b5ca-363b-9c219fb05a98@mojatatu.com>
 <1861edc9-7185-42f6-70dc-bfbfdd348462@nvidia.com>
 <caeac129-25f4-6be5-76ce-9e0b20b68e7c@nvidia.com>
 <DM5PR1301MB21726E820BC91768462B8C70E7279@DM5PR1301MB2172.namprd13.prod.outlook.com>
 <8a777b6f-0084-5262-40f6-d9400f7e6b15@mojatatu.com>
In-Reply-To: <8a777b6f-0084-5262-40f6-d9400f7e6b15@mojatatu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 56e50fbe-e279-4664-58c5-08d9ed458814
x-ms-traffictypediagnostic: DM8PR13MB5078:EE_
x-microsoft-antispam-prvs: <DM8PR13MB507810BD2DAB6889B13F5B7DE7309@DM8PR13MB5078.namprd13.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aRokE3U7apWJ6OWSF+IdCUbsvoreMJcim/jBCuddWtZI8zjvmGc+SSsfqn+GCl4HmUsGQ1VrqafFJmxeieRL6ggcaPXTvFPFcR+nsQ8qKJPJ0wO4k7Fg/gNnlBRDB+otPDYXMnhVgRkORRCIDCep22+KwM8UGdO9hQmIViPrf5Y7onAqt+Wjph2N+zCkrFdj5dbkPD+3ChSatTTkUqIaDVszKiL+I5vLv4P71BJdz5njNmZi5xPgtxKMu48QOOlhC1GbMDDwwgIduxgPJcPBo9UXMgIpuYtk/cdzJlNCKosFHxHnwmZWV4o13R24KJIu9OSmx9jPC48hF+h/SkG7xbkYdLtNzBV7bn7mTThAf8BDh+aJnyLIeERNJb+n09B3qB1eJaS7CYP0BIOjSgFMvINpdzCIR14sSyUXOm2JOH3r3HFWHWsb57AiMnSRKEumHSP9NeDimG+thQnhmQZ+sRlVJodqdeDYgAdwyeqlyMrLo9S4X7YivTPPwuREVP6ZNOCAY7xNyyAGY58m1QSdoSYU20khEEuu7stS3t6mwSOXWxG/YA/W0bCejqM+GH3a26kZXKEApVye21wbTlJ2+5vFQWPROqV71hz5HhT/VVOfbE1Py9aY0KOPLb/WXHyCgopWCR59oDIQIshbUp0xFE3ZH1ZGcW7E6eVbHq6wJg7ip/wlKx8FyXXidAb3xUV+dBWzdI42qL5Vvn41h2vm3Wq8CqTRzZ3wR8WUzudXP6yonwKtr2CFw3xNEtUSmTlZTXPKp8FzVLOTAosM/ADjp4gzXbJ1tOyQQuKo3G3yCZc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1301MB2172.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(39840400004)(376002)(136003)(346002)(366004)(396003)(33656002)(44832011)(2906002)(5660300002)(4326008)(8936002)(66946007)(66446008)(66556008)(66476007)(64756008)(8676002)(7696005)(6506007)(9686003)(26005)(71200400001)(53546011)(38070700005)(76116006)(107886003)(186003)(316002)(83380400001)(38100700002)(52536014)(86362001)(508600001)(122000001)(110136005)(55016003)(54906003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L0RBVk9GU1FkTGJqdUhJUmx0UzBmWmNYb3EwT1BuVzIwQTBMcG82cEJYV1dC?=
 =?utf-8?B?YWJQV1pBc1g1U0NOdEE0OEdseGNpN1BlOG8vTVppNVc4S2ZqWlNRRmc2dEMr?=
 =?utf-8?B?V0ZRS1JLb1JNWDFUVU9LT1N4UmI1SmpZcXMyaE5wQjR6QnlwaFZkTi9XY0JO?=
 =?utf-8?B?ZFZXektQYmVRb0wzN0pDYUIyMzhMcGtXQ3F1dnRyVk8wTnlLbkdjN3gyQ3lW?=
 =?utf-8?B?b1NrMFplMDIva3I2Q1Q1ZGlxY2haYlhHZWpFa1hocGloODFNZGhkbHZvWkhz?=
 =?utf-8?B?bnF4VWlhSVh4N2lMdzJzVVIxTUhjVm9ncjNjNzltdlFmakZ0d0hONkRuaFZY?=
 =?utf-8?B?VjRpcitScVQ4S1AxalhqcGNMaXZ5RXlDWGlmSXE5Qm5WcVJmaCt0N0NVMDFZ?=
 =?utf-8?B?cWhwL05QYzBQaWhPU214d2ZhM2V1WnpuVzVSK2tCN1ZrSktkbFNuOFplWlF2?=
 =?utf-8?B?ZC9Ka0ltcWR5R1RTR0RXT3pjU3N5SHV3dXk3VUxwZmdPTjR5cU1XaXRtN28v?=
 =?utf-8?B?QlBKTlcvNXlwcWhZcjFCOVFOYmJiVGpnM1h3TFgvUU5GWkRic3dEOXpRZ0py?=
 =?utf-8?B?aWZFV2UydU9ZeHpXMytWS0VxZEdRSXZGblhCNjkvZVgvMDBjZ3owRGlGcFRM?=
 =?utf-8?B?d1JWSEdtRnhZaUtnQ1pHQ2Y4d2MwL0hXZ0JpVGM0YkF2NXFXMUVyT0NqWUxn?=
 =?utf-8?B?aXhmbk5iYWZ2RzFvZSt2cW54SGtCa2FBakdTVUNocmVkZkZHUm9CWE80SDdh?=
 =?utf-8?B?NGl3QnA2a2pxazJOMFZlQVdHL0RuSDJrTjIyWlBFaXdrRjhEWkVMTFFsYzBK?=
 =?utf-8?B?WVN0emdEazlVdU1pQThYTlprZnhNN0tUbUNONjhtSHlYUmVUdmJ6M2g5aEZQ?=
 =?utf-8?B?MEQvS3N1bzg4ZTFqS2JCWFBHZDNVVGJPV0pSK2N4MUdYWVZhU3NRcnA5SHI3?=
 =?utf-8?B?MVB6WVh6S3NSNS9rSUFGNzRqZk0va1JhZ1hBUXM1T2FIQzZXZkMzbVErdWd5?=
 =?utf-8?B?QnQ4ZWNLUlpJYXF3ZW9iNnlSS0JyTStOV3JOaCs2T01jc1llRDc5RHk4NTVI?=
 =?utf-8?B?aUsvQ2ZIODhteUp0MXZvWlBVWFNhczRlMmZCb2NicGtIVnZPMTJxUGVOUXhz?=
 =?utf-8?B?VVBQNmtnQ0hrQ0pVVlNWZE9OTGhxUGNhUU5DRVJLWjgzWjNjNTdrN0tYZncw?=
 =?utf-8?B?K3dkdS9KNlNoSE9hUXhrWSthM2NYSWlpMVBSVGpFQ2Q4TEYwUW9GaCtNWG02?=
 =?utf-8?B?TWVkMlpuTEhqZ2RyQllyMU1qV0JZdG81WVYvU2xYVW8yNFlyNFNTSFVWNUpt?=
 =?utf-8?B?ZkRyMXBxUkZaUis0bHNOOWNETXk0bUlMMW82TXZBdUJQQmhsekR4ajBGL1cz?=
 =?utf-8?B?SStpSUw1RFZXczZnMmRYT0ZNeDNCVWh5RHpuV3pESHlrSTg1SEdrOTBOcnZl?=
 =?utf-8?B?dk9qTDZrTHJxbXJsdkFFdTZ1QkN0UFZxcnhlMExsWm9kdXowbXNKalNuMUhQ?=
 =?utf-8?B?QS8wSzRVYXdwK3J1MlJPOTF5R3JwZ1ZXVEdBdHZwVXhOalorV0szQXl0aEF1?=
 =?utf-8?B?ZGhuQW8vTTV5SGR6bUFFdUY4WGQ5L051K2lkaVV1Snd4b2htblRwWXBIZEw3?=
 =?utf-8?B?N0JPZXlhZnFUR2lNMUZQUWFjSndid2JzQVE1OFZTbHU3SHV3dTYvczF0enJ1?=
 =?utf-8?B?N1l3S3Q1eUpsTkppNmtuZkZuUE5GaEJyaWYvVHlvTUVqbERTRUFySWdQdUVF?=
 =?utf-8?B?YUkrdTFKSFlkNmpnczFUbXRPUE4rejNmTnpLUmozeVFMSWU0cmV3VkxQSFBL?=
 =?utf-8?B?WWN3ZUpIRGVkUlBtaEptQ2k3bDlpcllSL0xqTDhKc0RDZnNnRzlxOHR5N2lU?=
 =?utf-8?B?VHZGMjN0WnJiOTJKcGNEcFNHQ3E4RkZGNnNNUDl5YXZzaDIyVmVvdC9WcVpW?=
 =?utf-8?B?NVhaNUUrWE85enZJeXpmaDlrR3FxSmZlSVFyNExPaHdsQW0xSTh5NXhmSXMx?=
 =?utf-8?B?SXVKM0tTdFR0U2ZpZ285dEY3eW5CNTdCVU9hWldpclBhSHdHK2hVWHBKNGQx?=
 =?utf-8?B?ZDZtTWZ6b0FnUTNESU9FcDR0WHQ0YmlISXJ5Wm9wZ2drSGhKMXFLa0t6VXlQ?=
 =?utf-8?B?VkxvYll0aXE5SEh3YUcxcHRESWI0d2tPTDB5OFJJcVZjVEdXeEVwNnZORGpI?=
 =?utf-8?B?Z3ArUjlVQnJwYUwxUXRwdGRtbUtrVDRDL3JSZXdYdnhxV0szN3B5T1NXL3Fq?=
 =?utf-8?B?UHFrN21jWW5qMWVaS1NCdis2QlRBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1301MB2172.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56e50fbe-e279-4664-58c5-08d9ed458814
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Feb 2022 10:01:53.9947
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: b6q/ia2rClqQy4h9o2D1tVZiP24jRW0LS9MjmASUm8bZ31HazzbFUtQAaQpbjjcvigVtD56mQ3HjSzwWXmW8qJVhM/d7rZp+/rdCFvjFKnc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5078
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFtYWw6DQpTb3JyeSBmb3IgdGhlIGRlbGF5IG9mIHRoZSByZXBseS4NCg0KT24gRmVicnVh
cnkgMiwgMjAyMiA3OjQ3IFBNLCBKYW1hbCB3cm90ZToNCj5PbiAyMDIyLTAyLTAyIDA0OjM3LCBC
YW93ZW4gWmhlbmcgd3JvdGU6DQo+PiBIaSBSb2k6DQo+PiBUaGFua3MgZm9yIGJyaW5nIHRoaXMg
dG8gdXMsIHBsZWFzZSBzZWUgdGhlIGlubGluZSBjb21tZW50cy4NCj4+DQo+Pj4gT24gMjAyMi0w
Mi0wMiAxMDozOSBBTSwgUm9pIERheWFuIHdyb3RlOg0KPj4+Pg0KPj4+Pg0KPj4+PiBPbiAyMDIy
LTAxLTMxIDk6NDAgUE0sIEphbWFsIEhhZGkgU2FsaW0gd3JvdGU6DQo+Pj4+PiBPbiAyMDIyLTAx
LTI2IDA4OjQxLCBWaWN0b3IgTm9ndWVpcmEgd3JvdGU6DQo+Pj4+Pj4gT24gV2VkLCBKYW4gMjYs
IDIwMjIgYXQgMzo1NSBBTSBCYW93ZW4gWmhlbmcNCj4+Pj4+PiA8YmFvd2VuLnpoZW5nQGNvcmln
aW5lLmNvbT4gd3JvdGU6DQo+Pj4+Pj4+DQo+Pj4+Pj4+IEFkZCBza2lwX2h3IGFuZCBza2lwX3N3
IGZsYWdzIGZvciB1c2VyIHRvIGNvbnRyb2wgd2hldGhlciBvZmZsb2FkDQo+Pj4+Pj4+IGFjdGlv
biB0byBoYXJkd2FyZS4NCj4+Pj4+Pj4NCj4+Pj4+Pj4gQWxzbyB3ZSBhZGQgaHdfY291bnQgdG8g
c2hvdyBob3cgbWFueSBoYXJkd2FyZXMgYWNjZXB0IHRvDQo+b2ZmbG9hZA0KPj4+Pj4+PiB0aGUg
YWN0aW9uLg0KPj4+Pj4+Pg0KPj4+Pj4+PiBDaGFuZ2UgbWFuIHBhZ2UgdG8gZGVzY3JpYmUgdGhl
IHVzYWdlIG9mIHNraXBfc3cgYW5kIHNraXBfaHcgZmxhZy4NCj4+Pj4+Pj4NCj4+Pj4+Pj4gQW4g
ZXhhbXBsZSB0byBhZGQgYW5kIHF1ZXJ5IGFjdGlvbiBhcyBiZWxvdy4NCj4+Pj4+Pj4NCj4+Pj4+
Pj4gJCB0YyBhY3Rpb25zIGFkZCBhY3Rpb24gcG9saWNlIHJhdGUgMW1iaXQgYnVyc3QgMTAwayBp
bmRleCAxMDANCj4+Pj4+Pj4gc2tpcF9zdw0KPj4+Pj4+Pg0KPj4+Pj4+PiAkIHRjIC1zIC1kIGFj
dGlvbnMgbGlzdCBhY3Rpb24gcG9saWNlIHRvdGFsIGFjdHMgMQ0KPj4+Pj4+PiAgwqDCoMKgwqAg
YWN0aW9uIG9yZGVyIDA6wqAgcG9saWNlIDB4NjQgcmF0ZSAxTWJpdCBidXJzdCAxMDBLYiBtdHUg
MktiDQo+Pj4+Pj4+IGFjdGlvbiByZWNsYXNzaWZ5IG92ZXJoZWFkIDBiIGxpbmtsYXllciBldGhl
cm5ldA0KPj4+Pj4+PiAgwqDCoMKgwqAgcmVmIDEgYmluZCAwwqAgaW5zdGFsbGVkIDIgc2VjIHVz
ZWQgMiBzZWMNCj4+Pj4+Pj4gIMKgwqDCoMKgIEFjdGlvbiBzdGF0aXN0aWNzOg0KPj4+Pj4+PiAg
wqDCoMKgwqAgU2VudCAwIGJ5dGVzIDAgcGt0IChkcm9wcGVkIDAsIG92ZXJsaW1pdHMgMCByZXF1
ZXVlcyAwKQ0KPj4+Pj4+PiAgwqDCoMKgwqAgYmFja2xvZyAwYiAwcCByZXF1ZXVlcyAwDQo+Pj4+
Pj4+ICDCoMKgwqDCoCBza2lwX3N3IGluX2h3IGluX2h3X2NvdW50IDENCj4+Pj4+Pj4gIMKgwqDC
oMKgIHVzZWRfaHdfc3RhdHMgZGVsYXllZA0KPj4+Pj4+Pg0KPj4+Pj4+PiBTaWduZWQtb2ZmLWJ5
OiBiYW93ZW4gemhlbmcgPGJhb3dlbi56aGVuZ0Bjb3JpZ2luZS5jb20+DQo+Pj4+Pj4+IFNpZ25l
ZC1vZmYtYnk6IFNpbW9uIEhvcm1hbiA8c2ltb24uaG9ybWFuQGNvcmlnaW5lLmNvbT4NCj4+Pj4+
Pg0KPj4+Pj4+IEkgYXBwbGllZCB0aGlzIHZlcnNpb24sIHRlc3RlZCBpdCBhbmQgY2FuIGNvbmZp
cm0gdGhlIGJyZWFrYWdlIGluDQo+Pj4+Pj4gdGRjIGlzIGdvbmUuDQo+Pj4+Pj4gVGVzdGVkLWJ5
OiBWaWN0b3IgTm9ndWVpcmEgPHZpY3RvckBtb2phdGF0dS5jb20+DQo+Pj4+Pg0KPj4+Pj4gQWNr
ZWQtYnk6IEphbWFsIEhhZGkgU2FsaW0gPGpoc0Btb2phdGF0dS5jb20+DQo+Pj4+Pg0KPj4+Pj4g
Y2hlZXJzLA0KPj4+Pj4gamFtYWwNCj4+Pj4NCj4+Pj4NCj4+Pj4gSGkgU29ycnkgZm9yIG5vdCBj
YXRjaGluZyB0aGlzIGVhcmx5IGVub3VnaCBidXQgSSBzZWUgYW4gaXNzdWUgbm93DQo+Pj4+IHdp
dGggdGhpcyBwYXRjaC4gYWRkaW5nIGFuIG9mZmxvYWQgdGMgcnVsZSBhbmQgZHVtcGluZyBpdCBz
aG93cw0KPj4+PiBhY3Rpb25zIG5vdF9pbl9ody4NCj4+Pj4NCj4+Pj4gZXhhbXBsZSBydWxlIGlu
X2h3IGFuZCBhY3Rpb24gbWFya2VkIGFzIG5vdF9pbl9odw0KPj4+Pg0KPj4+PiBmaWx0ZXIgcGFy
ZW50IGZmZmY6IHByb3RvY29sIGFycCBwcmVmIDggZmxvd2VyIGNoYWluIDAgaGFuZGxlIDB4MQ0K
Pj4+PiBkc3RfbWFjIGU0OjExOjIyOjExOjRhOjUxIHNyY19tYWMgZTQ6MTE6MjI6MTE6NGE6NTAN
Cj4+Pj4gICDCoCBldGhfdHlwZSBhcnANCj4+Pj4gICDCoCBpbl9odyBpbl9od19jb3VudCAxDQo+
Pj4+ICAgwqDCoMKgwqDCoMKgwqAgYWN0aW9uIG9yZGVyIDE6IGdhY3QgYWN0aW9uIGRyb3ANCj4+
Pj4gICDCoMKgwqDCoMKgwqDCoMKgIHJhbmRvbSB0eXBlIG5vbmUgcGFzcyB2YWwgMA0KPj4+PiAg
IMKgwqDCoMKgwqDCoMKgwqAgaW5kZXggMiByZWYgMSBiaW5kIDENCj4+Pj4gICDCoMKgwqDCoMKg
wqDCoCBub3RfaW5faHcNCj4+Pj4gICDCoMKgwqDCoMKgwqDCoCB1c2VkX2h3X3N0YXRzIGRlbGF5
ZWQNCj4+Pj4NCj4+Pj4NCj4+Pj4gc28gdGhlIGFjdGlvbiB3YXMgbm90IGNyZWF0ZWQvb2ZmbG9h
ZGVkIG91dHNpZGUgdGhlIGZpbHRlciBidXQgaXQgaXMNCj4+Pj4gYWN0aW5nIGFzIG9mZmxvYWRl
ZC4NCj4+IEhpIFJvaSwgdGhlIGZsYWcgaW5faHcgYW5kIG5vdF9pbl9odyBpbiBhY3Rpb24gc2Vj
dGlvbiBkZXNjcmliZXMgaWYgdGhlIGFjdGlvbg0KPmlzIG9mZmxvYWRlZCBhcyBhbiBhY3Rpb24g
aW5kZXBlbmRlbnQgb2YgYW55IGZpbHRlci4gU28gdGhlIGFjdGlvbnMgY3JlYXRlZA0KPmFsb25n
IHdpdGggdGhlIGZpbHRlciB3aWxsIGJlIG1hcmtlZCB3aXRoIG5vdF9pbl9ody4NCj4NCj5Qcm9i
YWJseSB0aGUgbGFuZ3VhZ2UgdXNhZ2UgaXMgY2F1c2luZyB0aGUgY29uZnVzaW9uIGFuZCBJIG1p
c3NlZCB0aGlzIGRldGFpbA0KPmluIHRoZSBvdXRwdXQgYXMgd2VsbC4gTGV0IG1lIHNlZSBpZiBp
IGNhbiBicmVhayB0aGlzIGRvd24uDQo+DQo+RWl0aGVyIGJvdGggYWN0aW9uIGFuZCAgZmlsdGVy
IGFyZSBpbiBoL3cgb3IgdGhleSBhcmUgbm90LiBpLmUNCj4NCj5hY3Rpb24gaW4gaC93ICArIGZp
bHRlciBpbiBoL3cgPT0gR09PRA0KPmFjdGlvbiBpbiBoL3cgICsgZmlsdGVyIGluIHMvdyA9PSBC
QUQNCj5hY3Rpb24gaW4gcy93ICArIGZpbHRlciBpbiBoL3cgPT0gQkFEDQo+YWN0aW9uIGluIHMv
dyAgKyBmaWx0ZXIgaW4gcy93ID09IEdPT0QNCj4NCj5UaGUga2VybmVsIHBhdGNoZXMgZGlkIGhh
dmUgdGhvc2UgcnVsZXMgaW4gcGxhY2UgLSBhbmQgQmFvd2VuIGFkZGVkIHRkYyB0ZXN0cw0KPnRv
IGNoZWNrIGZvciB0aGlzLg0KPg0KPk5vdyBvbiB0aGUgd29ya2Zsb3c6DQo+MSkgSWYgeW91IGFk
ZCBhbiBhY3Rpb24gaW5kZXBlbmRlbnRseSB0byBvZmZsb2FkIGJlZm9yZSB5b3UgYWRkIGEgZmls
dGVyIHdoZW4NCj55b3UgZHVtcCBhY3Rpb25zIGl0IHNob3VsZCBzYXkgInNraXBfc3csIHJlZiAx
IGJpbmQgMCINCj5pLmUgaW5mb3JtYXRpb24gaXMgc3VmZmljaWVudCBoZXJlIHRvIGtub3cgdGhh
dCB0aGUgYWN0aW9uIGlzIG9mZmxvYWRlZCBidXQgdGhlcmUNCj5pcyBubyBmaWx0ZXIgYXR0YWNo
ZWQuDQo+DQo+MikgSWYgeW91IGJpbmQgdGhpcyBhY3Rpb24gYWZ0ZXIgdG8gYSBmaWx0ZXIgd2hp
Y2ggX2hhcyB0byBiZSBvZmZsb2FkZWRfDQo+KG90aGVyd2lzZSB0aGUgZmlsdGVyIHdpbGwgYmUg
cmVqZWN0ZWQpIHRoZW4gd2hlbiB5b3UgZHVtcCB0aGUgYWN0aW9ucyB5b3UNCj5zaG91bGQgc2Vl
ICJza2lwX3N3IHJlZiAyIGJpbmQgMSI7IHdoZW4geW91IGR1bXAgdGhlIGZpbHRlciB5b3Ugc2hv
dWxkIHNlZQ0KPnRoZSBzYW1lIG9uIHRoZSBmaWx0ZXIuDQo+DQo+MykgSWYgeW91IGNyZWF0ZSBh
IHNraXBfc3cgZmlsdGVyIHdpdGhvdXQgc3RlcCAjMSB0aGVuIHdoZW4geW91IGR1bXAgeW91DQo+
c2hvdWxkIHNlZSAic2tpcF9zdyByZWYgMSBiaW5kIDEiIGJvdGggd2hlbiBkdW1waW5nIGluIElP
VywgdGhlIG5vdF9pbl9odw0KPmlzIHJlYWxseSB1bm5lY2Vzc2FyeS4NCj4NCj5TbyB3aHkgbm90
IGp1c3Qgc3RpY2sgd2l0aCBza2lwX3N3IGFuZCBub3QgYWRkIHNvbWUgbmV3IGxhbmd1YWdlPw0K
Pg0KSWYgSSBkbyBub3QgbWlzdW5kZXJzdGFuZCwgeW91IG1lYW4gd2UganVzdCBzaG93IHRoZSBz
a2lwX3N3IGZsYWcgYW5kIGRvIG5vdCBzaG93IG90aGVyIGluZm9ybWF0aW9uKGluX2h3LCBub3Rf
aW5faHcgYW5kIGluX2h3X2NvdW50KSwgSSB0aGluayBpdCBpcyByZWFzb25hYmxlIHRvIHNob3cg
dGhlIGFjdGlvbiBpbmZvcm1hdGlvbiBhcyB5b3VyIHN1Z2dlc3Rpb24gaWYgdGhlIGFjdGlvbiBp
cyBkdW1wZWQgYWxvbmcgd2l0aCB0aGUgZmlsdGVycy4gDQoNCkJ1dCBhcyB3ZSBkaXNjdXNzZWQg
cHJldmlvdXNseSwgd2UgYWRkZWQgdGhlIGZsYWdzIG9mIHNraXBfaHcsIHNraXBfc3csIGluX2h3
X2NvdW50IG1haW5seSBmb3IgdGhlIGFjdGlvbiBkdW1wIGNvbW1hbmQodGMgLXMgLWQgYWN0aW9u
cyBsaXN0IGFjdGlvbiB4eHgpLg0KV2Uga25vdyB0aGF0IHRoZSBhY3Rpb24gY2FuIGJlIGNyZWF0
ZWQgd2l0aCB0aHJlZSBmbGFncyBjYXNlOiBza2lwX3N3LCBza2lwX2h3IGFuZCBubyBmbGFnLg0K
VGhlbiB3aGVuIHRoZSBhY3Rpb25zIGFyZSBkdW1wZWQgaW5kZXBlbmRlbnRseSwgdGhlIGluZm9y
bWF0aW9uIG9mIHNraXBfaHcsIHNraXBfc3csIGluX2h3X2NvdW50IHdpbGwgYmVjb21lIGltcG9y
dGFudCBmb3IgdGhlIHVzZXIgdG8gZGlzdGluZ3Vpc2ggaWYgdGhlIGFjdGlvbiBpcyBvZmZsb2Fk
ZWQgb3Igbm90LiANCg0KU28gZG9lcyB0aGF0IG1lYW4gd2UgbmVlZCB0byBzaG93IGRpZmZlcmVu
dCBpdGVtIHdoZW4gdGhlIGFjdGlvbiBpcyBkdW1wZWQgaW5kZXBlbmRlbnQgb3IgYWxvbmcgd2l0
aCB0aGUgZmlsdGVyPyANCg0KPmNoZWVycywNCj5qYW1hbA0K
