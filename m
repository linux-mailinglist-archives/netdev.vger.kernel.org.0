Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB7304D37E9
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 18:45:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234093AbiCIRjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 12:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237484AbiCIRie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 12:38:34 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6FE11B5E5
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 09:37:34 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 229CWtHq011697;
        Wed, 9 Mar 2022 12:37:24 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2052.outbound.protection.outlook.com [104.47.60.52])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3em5n7t0w6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 09 Mar 2022 12:37:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OBEyP9z6+/06KihQntoHKV+2GrB7N+/7jzyUmsC0uUXBB5D19rI5ZKiAVVJp8nYVxuPHM8PPWE0bwKQXj5NvMvgGLmBI8/GalqRJn6QCoWrY05ceLvyIjjIg00FJSrhD+NnvYpT5jPNsS2nGKYST2gdVtob6mJFs01KVKF95I8I0e/5EXhJxbom3l2n9MMUsvG2EdTSg6bQ0UJqjL4SYFZcGlWTfDPzs0fIoE3x1GDl2qRn4UebOTOFrfLC2PMmvgt/RspAwZ/I3BGNTUV8hLI3aziC6wuPcbd8vpNPZ/EymFcpJIUbT9e4dw1725R5Jbhqi/PeXPGp+fhL96Kjyjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SCecddBjRcR9nDYBM6ZzE4trCOoFgRSATSazhGkoEo=;
 b=QnEVhFT4+CoTxox3VAQyS4KD25ppcS4A9kB+R9U+d2ab3a4Dfx8WDkKCDhsngLrbHLRP/rb7WQTYBr+h+MOK2L6AF3P0P9cUvtnX460tLH/OrynwayQc3OAeAh6MYQHbR4GMNjWyqQjFzigzdeaG9BzttHDBm7sVdFxToYOx5oZ+C8XjvSs3+dsVPpwalPqhsrQSEdOH9jkiisTLkgyCJL5l7GLPohZQQNxNHybdowkH1LI5AZjU3mQkzhKndV+ptwVIHMVghOGtfGrEehI7rJWFVUoQ9FcMhyaVD8/blQzYjZi0e4qA+KxPzF07qIySvR+dTEWpPAHZqPAcyTPYLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SCecddBjRcR9nDYBM6ZzE4trCOoFgRSATSazhGkoEo=;
 b=SKlZL7gDn3WaNA900lbLi7CAzdU/9p1zKeseHKB8M4AlzVuOlCyVSBxfKp8lJLKdu1yi7BamAhMZFvpiBIFASBPvWYlcIhAj+cf0BXphJLFtyTQjRFbwMoiGPxX/66NXJMzw4wOQTdE/qbxZIjoXo2ImRsXB+fbYgTm7o9ydyo4=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB8827.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:ca::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Wed, 9 Mar
 2022 17:37:22 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 17:37:22 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "radheys@xilinx.com" <radheys@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "jwiedmann.dev@gmail.com" <jwiedmann.dev@gmail.com>
Subject: Re: [PATCH net-next] net: axienet: Use napi_alloc_skb when refilling
 RX ring
Thread-Topic: [PATCH net-next] net: axienet: Use napi_alloc_skb when refilling
 RX ring
Thread-Index: AQHYMzEaShWxf4rLg0qqvuxhb3qcNay2tbcAgACckAA=
Date:   Wed, 9 Mar 2022 17:37:22 +0000
Message-ID: <f1e750184d0a7f1561224eeb4f307120929a9502.camel@calian.com>
References: <20220308211013.1530955-1-robert.hancock@calian.com>
         <SA1PR02MB85605D085CA75C0022C99E38C70A9@SA1PR02MB8560.namprd02.prod.outlook.com>
In-Reply-To: <SA1PR02MB85605D085CA75C0022C99E38C70A9@SA1PR02MB8560.namprd02.prod.outlook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5e017cc8-c0dc-4439-5698-08da01f377ed
x-ms-traffictypediagnostic: YT1PR01MB8827:EE_
x-microsoft-antispam-prvs: <YT1PR01MB8827F758D474BF1E10877543EC0A9@YT1PR01MB8827.CANPRD01.PROD.OUTLOOK.COM>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gZ0rilILpaTt7Auq0TtW1C6UcdYyjGDgPRwcekU9ABRpeOZ/8LQ6+XuXaYxBjOeHpwQqGvRmBaWMHwfNekYtiYid4hg4B8n5sjP0VGPqP27nTQNocnyvLaCRdt35TyrCcEV4z23cCm5ZhiaEcZITDIMsZnfh0rPOa3ATmiVJ9hkuZdJ6WoVD0ynIUbCKozSyXd9YBMVfetMZenSCTcw7zgT6kvjil3BcBRuZLm9rQHw5zaS0b7+WfFO8K0uOcQcRAYV17LqlAKhUbbT1HZK6jsicq/ZKsRP4L5cBYe6k8EG5if9XJYUA5VizEtvFtzI/bKz/Xghd503A4+0aiL66UUf4jFPHiE181mS1TxOoQggUu50Uoz30OC+5qzMKF4tycwg909Q3DjHNFxaaB4Dk+kVKEyI9tHdMtHVhD1yhCC7VSqBkWHmdCJMAXelwftvkGoxCB6a7OyoSfoHIWvpQaiE6t8WHIQ5bMKl6CuiPEqQZpD1CKnbUEX9FIGtigWE4+MknTm0eKDDhJG7GXy+Igx0nDEmrJ5Nln/BEqdlhes/fh15dtRVcujjuNF9doKzpnpyz+rUuT2rQpg58S1dr1klogUsLW3Y6ivr9HsUZ35+udmdZeld5OXyPdfj02Zdk8VyqwxVmUVyAHsT6H4eVXBv504lFN6zUHEYlTyVdaYKO+vaQ7bfJRz6Ey8HBI8jPfBHMs9IqZRB+Ml05d6ODEoGeINp78y2YwKJ3KqYGuA/Pbb9KYKyymZ4LaQI7nZ8MM752PF1LRpYaVdEJeC+1ATeGw0xlpUAOoSSg3jFJrP/mNKUn6tfJv5hrXEQ7sQMDdm6rXBdvPbqg2x+VV8IvybTmeUQXlqu3uT3P7suN5+I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(6512007)(508600001)(53546011)(71200400001)(91956017)(6506007)(186003)(83380400001)(38070700005)(26005)(66476007)(86362001)(122000001)(8936002)(5660300002)(4326008)(8676002)(66556008)(66946007)(66446008)(64756008)(76116006)(15974865002)(2616005)(36756003)(44832011)(2906002)(110136005)(316002)(38100700002)(54906003)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?d3hpRERna3l3YVBTMnFPOTlxWjRRajYwMDU3RkpyTjI3bkpuRVN2OVZvaW9y?=
 =?utf-8?B?RjFTVGp2R0pMV3Bjb2N2czM0YjRkVG8yUUMwYXpXenBQNFA0OStkbUhxa1lY?=
 =?utf-8?B?dFZaV3ZvVFNzUDFYVmxMOWVzS2FGNWZMd1VBWkxRRFB4YjFlVmpjQnpndjF4?=
 =?utf-8?B?Ymxwb1ZkT0xZaFFQeTlPd1VxRDZBeFloUHdRWk1BWlhMSWFQWHVKZHYrSWo4?=
 =?utf-8?B?SFROTmtHQkZpVWJyY0Y4c2VLZmgvdGloWWRsUUlOY2w3YW8xZk9kS1VqeDRW?=
 =?utf-8?B?d3FTUFp5Y2hmVWVXRGc4MXVheUF4WVQ0M3N5ejRPZlkzQlpxb2Zicy8zNmtq?=
 =?utf-8?B?QXVBeEhYK01zMmZsKzNjcVhOY3BRdkFaUGdXTkI4aTlkNmgrcDFkK1h1ZTVR?=
 =?utf-8?B?cFNhTFdSckJGVWVCalJnT3hLV3Y4c2Z2bEkzSFlXY0t0cUNJMzVsSkxjYmNW?=
 =?utf-8?B?OWJzbUJxTFI5eGh3QU9qaEdLY3Nod3JXcUEraWxENWxucVozUjdWaVJxZ25v?=
 =?utf-8?B?VzVpV2kxYUY1NHpubWszM3Y3SnNlWS9nR1kvb3BPSzVrV2hVR011NVdvd1Zu?=
 =?utf-8?B?QWIweS9ockJsUmFKVVJlMVczOUFPV2pOZE1qUG1Xdm5iNkpkVTZ4c2Mxa1Ni?=
 =?utf-8?B?NEw1Nks0UmVvVjVaVzYvdVpjdm5KdHNENGV0VlZyaExGNStkTWdYQVFzcENv?=
 =?utf-8?B?Z0dpNjV6QS9xaThtdnk0eTV3UTdFaEZUZk5iVlJpa3hYa3Jta1lZQVBVcnp2?=
 =?utf-8?B?eUtSb0krNzJ5aHhFYktwczhjUGhPTm82d1NuRDFudDNMV2dUS3N6eDR2K2ov?=
 =?utf-8?B?RzBRQTlYOGt0Y09RQjdOWHVySXR0dFdpdVpmTDNBODE3U3hReVoyMmNTSzQx?=
 =?utf-8?B?WnlGWEUxS0hrNEdmaXUwTXhJaXRVanFsNG51VHV1SlliM1RTU3hKVEZDdm1Q?=
 =?utf-8?B?bGt2Sjl5WGxSM0g1am5EMlJxcFRIS0V2RTZISmVSSzhvMzBubmhWOVBhTU1q?=
 =?utf-8?B?Uzk2WDcvb29wWFE3czM2QytvWlhtVUJ4VFF4ZjR3WVZ5enRPZjVDTjk2V3gv?=
 =?utf-8?B?U0IwL3JhRG9oTUdIZlh6bzU2YlJ4U1JSV3RsOHhsTloxbTNwVEQ5OEUzODZl?=
 =?utf-8?B?UXRWaWR2SnVlTVdiZEt5UUVHWnlZc3c5cUcrNUtyMEVXMk11K0FKeXA2bzBM?=
 =?utf-8?B?M1IzQkcxeWhHNEJWcDBsbWRzdVgrODEvdjVmNjd5WXpLc1dFSXlwM2JjaDQ4?=
 =?utf-8?B?bmxQaDJvUE00V09ZV2R0enYzc3diWncxYjhacVFDSjR5RDVtMjErdTZpRFpK?=
 =?utf-8?B?bVRuVm8xbVoyU3lBVE1kSElWVEkwYkp4MHNCdzlOQkNTV0p3bkZjZmhjbDMx?=
 =?utf-8?B?YUxjL1NkUWNXWUxuSGZHRzl3RW9JOG1CQUdobURySExweVlmT2VaVjR0VzJ4?=
 =?utf-8?B?YzJROFZLeTRaQ2crTVRkTitJejZwZlRMRU5vTEMrVVVqZUZGSVJnK1hWaWE5?=
 =?utf-8?B?aG42Ly9kZjBVNFVXbmFPcXh6ZUplc29tcVo2VWVYaUJ4ZXdWb25TRzJFZDdm?=
 =?utf-8?B?OEoza1NmQUZ6cVhXRXY0MHRaZEMxRnNHNXo5MDlXSVAzdGU5Szl5ZnJhNnZN?=
 =?utf-8?B?WnR3c3h2WkQrRklyS1NMWVRocXdxNzVOZUQ4NGg3M3o4M2lNYXVILzBLQklP?=
 =?utf-8?B?Nm5FM1IySEpvMm1FbXA0Y0xuTDlUaE5CUDUzRndxSlk3TkpRcHUxWjZkN05Y?=
 =?utf-8?B?RnVSTjlIYkhPN1pmdUsveFF4ZEVlb2lwUm9ZcEVHOG5GL0FwaUhtbXBjUW9W?=
 =?utf-8?B?dk1EU3hoSFJKL2tWZDBra0hBaGxJNWE5TTJDOXZBMkMxUHZPbE9wWlFjWHpm?=
 =?utf-8?B?ckhqWUVwV2R2MVJhMWEzblU4djNDWCtTZjVXWFRtai9IeE55RDVKY3FHeEp3?=
 =?utf-8?B?bmZ5M3ZJUFdidE5FUnhoZVQ2cDZOSTZ4eUYxcTBBSzJIVmttWkJSVWVsRHlx?=
 =?utf-8?B?YlJoTzR3ZGVhZUJNRGRJSncwNXM0N2pzUm9FbG13ZWRjQnYxUkZ3RTNwZFFq?=
 =?utf-8?B?cWo2a2c0dWE5NnY2dzJYbFYvZm52MHV1Zlhra29PSEdQOTRSOHlRRkpjZ2ZP?=
 =?utf-8?B?U3pzZ2pMVmZxbmQyZVNPMFRNYjNrMzBYNlNiQnlLaXo4ZHBBdTdrcVp6WFNx?=
 =?utf-8?B?REtGRlZkeFdwS0VzK05ramxiRWI5bVBUcndyMmRJSlExZWdrTHdCVDd3TC9K?=
 =?utf-8?Q?dc86NP4qQkEACBvXOiWs17bPiq7AwQd+SsBj3s72vE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEBF09E2BF411F44866FF99CC608C65A@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e017cc8-c0dc-4439-5698-08da01f377ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 17:37:22.6601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pwtmuelpLMSKrT/VHhEOKFLZAH8wCkaZsDvnaJ2cPmAB9cBOJ3fSOL7FSA0ePT3HK3BQNQt51GVQc/ITh2NDoaXY5AJ061ISLGX2yMNwiBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8827
X-Proofpoint-GUID: asjQ37X4CwNUibLsrwL6RWsRyHvKIm3m
X-Proofpoint-ORIG-GUID: asjQ37X4CwNUibLsrwL6RWsRyHvKIm3m
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-09_07,2022-03-09_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 adultscore=0 impostorscore=0 mlxscore=0 clxscore=1011 spamscore=0
 mlxlogscore=829 suspectscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2203090098
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTAzLTA5IGF0IDA4OjE3ICswMDAwLCBSYWRoZXkgU2h5YW0gUGFuZGV5IHdy
b3RlOg0KPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogUm9iZXJ0IEhh
bmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+DQo+ID4gU2VudDogV2VkbmVzZGF5LCBN
YXJjaCA5LCAyMDIyIDI6NDAgQU0NCj4gPiBUbzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiA+
IENjOiBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXlzQHhpbGlueC5jb20+OyBkYXZlbUBkYXZl
bWxvZnQubmV0Ow0KPiA+IGt1YmFAa2VybmVsLm9yZzsgTWljaGFsIFNpbWVrIDxtaWNoYWxzQHhp
bGlueC5jb20+OyBsaW51eC1hcm0tDQo+ID4ga2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IGp3
aWVkbWFubi5kZXZAZ21haWwuY29tOyBSb2JlcnQgSGFuY29jaw0KPiA+IDxyb2JlcnQuaGFuY29j
a0BjYWxpYW4uY29tPg0KPiA+IFN1YmplY3Q6IFtQQVRDSCBuZXQtbmV4dF0gbmV0OiBheGllbmV0
OiBVc2UgbmFwaV9hbGxvY19za2Igd2hlbiByZWZpbGxpbmcNCj4gPiBSWA0KPiA+IHJpbmcNCj4g
PiANCj4gPiBVc2UgbmFwaV9hbGxvY19za2IgdG8gYWxsb2NhdGUgbWVtb3J5IHdoZW4gcmVmaWxs
aW5nIHRoZSBSWCByaW5nIGluDQo+ID4gYXhpZW5ldF9wb2xsIGZvciBtb3JlIGVmZmljaWVuY3ku
DQo+IA0KPiBNaW5vciBuaXQgLSBHb29kIHRvIGFkZCBzb21lIGRldGFpbHMgb24gIm1vcmUgZWZm
aWNpZW5jeSIgKGFzc3VtZSBpdCdzIHBlcmY/KQ0KDQpZZXMsIGl0J3MgYXMgZGVzY3JpYmVkIGlu
IHRoZSBjb21tZW50cyBmb3IgbmFwaV9hbGxvY19za2I6DQoNCiAqICAgICAgQWxsb2NhdGUgYSBu
ZXcgc2tfYnVmZiBmb3IgdXNlIGluIE5BUEkgcmVjZWl2ZS4gIFRoaXMgYnVmZmVyIHdpbGwNCiAq
ICAgICAgYXR0ZW1wdCB0byBhbGxvY2F0ZSB0aGUgaGVhZCBmcm9tIGEgc3BlY2lhbCByZXNlcnZl
ZCByZWdpb24gdXNlZA0KICogICAgICBvbmx5IGZvciBOQVBJIFJ4IGFsbG9jYXRpb24uICBCeSBk
b2luZyB0aGlzIHdlIGNhbiBzYXZlIHNldmVyYWwNCiAqICAgICAgQ1BVIGN5Y2xlcyBieSBhdm9p
ZGluZyBoYXZpbmcgdG8gZGlzYWJsZSBhbmQgcmUtZW5hYmxlIElSUXMuDQoNCkkgZ3Vlc3MgdGhp
cyBjb3VsZCBiZSBtZW50aW9uZWQgaW4gdGhlIGNvbW1pdCBkZXNjcmlwdGlvbiBpZiBkZXNpcmVk
Pw0KDQo+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFJvYmVydCBIYW5jb2NrIDxyb2JlcnQuaGFuY29j
a0BjYWxpYW4uY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC94aWxpbngv
eGlsaW54X2F4aWVuZXRfbWFpbi5jIHwgMiArLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNl
cnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYw0KPiA+IGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQveGlsaW54L3hpbGlueF9heGllbmV0X21haW4uYw0KPiA+IGluZGV4IGE1MWE4
MjI4ZTFiNy4uMWRhOTBlYzU1M2M1IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L3hpbGlueC94aWxpbnhfYXhpZW5ldF9tYWluLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jDQo+ID4gQEAgLTk2NSw3ICs5NjUs
NyBAQCBzdGF0aWMgaW50IGF4aWVuZXRfcG9sbChzdHJ1Y3QgbmFwaV9zdHJ1Y3QgKm5hcGksIGlu
dA0KPiA+IGJ1ZGdldCkNCj4gPiAgCQkJcGFja2V0cysrOw0KPiA+ICAJCX0NCj4gPiANCj4gPiAt
CQluZXdfc2tiID0gbmV0ZGV2X2FsbG9jX3NrYl9pcF9hbGlnbihscC0+bmRldiwgbHAtDQo+ID4g
PiBtYXhfZnJtX3NpemUpOw0KPiA+ICsJCW5ld19za2IgPSBuYXBpX2FsbG9jX3NrYihuYXBpLCBs
cC0+bWF4X2ZybV9zaXplKTsNCj4gPiAgCQlpZiAoIW5ld19za2IpDQo+ID4gIAkJCWJyZWFrOw0K
PiA+IA0KPiA+IC0tDQo+ID4gMi4zMS4xDQotLSANClJvYmVydCBIYW5jb2NrDQpTZW5pb3IgSGFy
ZHdhcmUgRGVzaWduZXIsIENhbGlhbiBBZHZhbmNlZCBUZWNobm9sb2dpZXMNCnd3dy5jYWxpYW4u
Y29tDQo=
