Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6534ED691
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 11:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbiCaJPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 05:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbiCaJPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 05:15:16 -0400
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A95B17AB8;
        Thu, 31 Mar 2022 02:13:27 -0700 (PDT)
Received: from pps.filterd (m0250811.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 22V8bCg1007107;
        Thu, 31 Mar 2022 09:13:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=PPS06212021;
 bh=jYcju9bQeVg9YliNfxB44C7IK7Z7HBrD2DNXrh2uA0E=;
 b=dwEVOquoofWWgsNoo0+adWNa08uplIT9rwEKb0sjf6/5NjBRQefxTVXRUEPUaP10ndpT
 rEu1RaxbbvHj/DzRXxoxHzVXx6IuE9M3Y9vrGqQPSXCc6y0uDetU4Y0GLFtzoAF4ZFRU
 H3n2jMaBrmS0iFAQyUTWZf17J9AeKZ+kaDExBa+eZh8LCnaIEtcSL3vLONAbXctC9a6a
 s9tkcWZxEdPTtgrtWpM2rc/4KsVXQ+wJbG5Rf5ytvXygjV1P09KSRkbhKtMLy1Hb/jzv
 e65heJLoBML6tRDd9YRcoCUieqKS22f18dDbcL9sWhFKzYuisYH3zbMLtZ5LjCCJN/5a vQ== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3f1r2149qy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 31 Mar 2022 09:13:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d5a1PYJZFMH8tofAmzME1QCC5+wGwDU5uT/MVcEe7e3E0L5ePIVkCbPYlfwiVJAYof6Phxsfp7emNGAuYr8gM57fjMcC+HeGQMfkWtAOMAGYo29safLyNhcPYp2X7lmtZ0+Wec3HSPJ8EQ4emaZBKteBSkQLiuYwOq+Osz9R+gL+3aWQmxtcLAaPY1vGPqFsdAViibMLqkwYNeQfpT1/1vbGnHfz8aen+qNOhOAQq9geAHymV46vVfN+ClW8GDlr2hDGPAXc5ux4KtwcMHqbwnKTCiiYL35RcVgOlmAgle4qyh66alTOf6YumFXh+4przoKO6C+fri8b5THFY+j6aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jYcju9bQeVg9YliNfxB44C7IK7Z7HBrD2DNXrh2uA0E=;
 b=VzfM/WzXA9+GjMR7DRwlYqE+Ux3/3p8Mjg/G1356lNrEwasrcKdQdv5N8R2gQAZEdDQrvKUyE6GQbGEgScRO0/mFYK9OV4OqCXYiaeEmqn5yXX8At2fzPAcqDl1ETz1hIx6Q+z6rj9EA90ouc9KGJ0ROcqFivivOuZe0L2Lnd2oB4FtjCUVjYgJeECarSVmj5XtNNgAo4dzNMze9HcOzX8aa2ZXCObNnZ3ONHDRZH1q4MxrQD+Uou8ewj2Y+OLMkrSXYj5QHRpaKx9RZPOiQ/qh2hIwShheua6c2yS4oPUeSKjAE2tqM6QjukkNiYrdHjwhnQMG5eBT3EYi1KUTNJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB5096.namprd11.prod.outlook.com (2603:10b6:510:3c::5)
 by MN2PR11MB3677.namprd11.prod.outlook.com (2603:10b6:208:f6::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.17; Thu, 31 Mar
 2022 09:13:11 +0000
Received: from PH0PR11MB5096.namprd11.prod.outlook.com
 ([fe80::c44e:483a:3d6e:d1cd]) by PH0PR11MB5096.namprd11.prod.outlook.com
 ([fe80::c44e:483a:3d6e:d1cd%6]) with mapi id 15.20.5123.021; Thu, 31 Mar 2022
 09:13:10 +0000
From:   "Pudak, Filip" <Filip.Pudak@windriver.com>
To:     David Ahern <dsahern@kernel.org>,
        "Xiao, Jiguang" <Jiguang.Xiao@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: This counter "ip6InNoRoutes" does not follow the RFC4293
 specification implementation
Thread-Topic: This counter "ip6InNoRoutes" does not follow the RFC4293
 specification implementation
Thread-Index: AdgjHkb8kp0sEn6JQ1icxeGMRY2HXQAAIjdwAABijTAAACgXIAAiXNUAAWtW3lACgJFT0AAFxP2ABFsX6OA=
Date:   Thu, 31 Mar 2022 09:13:10 +0000
Message-ID: <PH0PR11MB5096F84F64CF00C996F219DAE4E19@PH0PR11MB5096.namprd11.prod.outlook.com>
References: <SJ0PR11MB51207CBDB5145A89B8A0A15393359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51202FA2365341740048A64593359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51209200786235187572EE0D93359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB5120426D474963E08936DD2493359@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <bcc98227-b99f-5b2f-1745-922c13fe6089@kernel.org>
 <SJ0PR11MB5120EBCF140B940C8FF712B9933D9@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <SJ0PR11MB51209DA3F7CAAB45A609633A930A9@SJ0PR11MB5120.namprd11.prod.outlook.com>
 <3f6540b8-aeab-02f8-27bc-d78c9eba588c@kernel.org>
In-Reply-To: <3f6540b8-aeab-02f8-27bc-d78c9eba588c@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86e74ac9-e624-4990-d8e8-08da12f6ad6d
x-ms-traffictypediagnostic: MN2PR11MB3677:EE_
x-microsoft-antispam-prvs: <MN2PR11MB3677FC57F905EF268B9D2D59E4E19@MN2PR11MB3677.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hqG2bg2lssi9ibN9zqnHx54IruIDSdvfyiv1T8z+NuCaGo3m78B5sbcHU7/UznuW6tyaBHoJfnQWl9Kd5MK/v7Iy+h3go6Ad4JfysfJ5WlVv3UcihhwIqmVGsiCzTYsgN0pRKrOxH2hXlTubKx1D4Ga4FsZHimvFgJWcSGcaHb8RtDvdNjs13MA/vc8njzQ5C7HwzyUGuBvpckg5yR+N3Dt2TMH5MK3jUBUt2dv5J1aRSd3O0LgRKtYAOLa54gFvSixDJaF4yHtnY1ssqSgAA8f2MgnqSfxWkgZI7b6DR0gbOhsSH7X4vBNNn9zWg9ADDQiisus4R3nPa9cNhWNsmrXUc+bVI+JAcmGi9gaU8WuhIQhvFvi5Fm2M/LEj3o6fuf1N2IJT5r2BkNpRCe6GmLWsIQmni7mAdkIp4wUZ4vaks+f8xyvUytkvwUPaSuKCdy+67pgt13dWE38FR/kpqUXi2ZHbf8FmChCb3Go+k2+wuNZhcFf/h+XHIek4xCV09Pe1GlIcMxNO/IY/UBoijh2m9pEaP4w15RPEnlsmYetIJeylz5M/fvWRFk1T2Aostg97tUXIVciJqtmw1yPPk0h5/2xDxtdAm6zJit9XieUZuCjX5dvQR7LhvKFMPyGUKs/4tQR7V/t/B+HBs/WxKqWyKKLiTM53rijaNKhX3dOENzBwDPcbqN0Hp6qByBq3E5gECTsRDERtSSDnlH5Hrg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5096.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(6029001)(4636009)(366004)(122000001)(8676002)(66446008)(38070700005)(66556008)(76116006)(2906002)(66946007)(66476007)(110136005)(8936002)(86362001)(316002)(52536014)(64756008)(33656002)(55236004)(26005)(7696005)(55016003)(6506007)(9686003)(38100700002)(5660300002)(53546011)(508600001)(83380400001)(186003)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?V1p0WGx1V01tMGRqQzVKRWhPczdSSXc3cWVydFVqWnBQM0ZHSHM3Qm44N0tM?=
 =?utf-8?B?TnhGdFhmZWFZVGRIVjFLOW5vaTkzRjV5TFVzaURHbm1tZXArV0RyVnU3dDlu?=
 =?utf-8?B?K21OOHlsajBjU3Zub2V6WXdXaHJ5dVp1eml4OU4rNXl5OEo0WEZtdkt0U0hU?=
 =?utf-8?B?T3A2dG54YWV0cGpxbkZjYVArbjE5TEJqUUUyYWhGaldKWEo4RjNnNHYrMWg2?=
 =?utf-8?B?eVJnc2dLanV4dU9FMTgyT3BYMFlwUk1iVERXV3FickdTU2lLYkdkWCtSV01D?=
 =?utf-8?B?SHJob3Y3L2svdE9TVGFQdG5OMGUxcDhlQm8rSHBwd05ZUEd6OTF5c2ZtU25D?=
 =?utf-8?B?WTZQYjBtcXZmRk1LbUpadndraTg0TVZ0Q3h5UW9hNXlTTVI2M1Y3QzVUSmFr?=
 =?utf-8?B?UlhFeitVclkrUVhTUCtwcElQMElHd1RsTDVPSk1UKzlqdmd4ejREYmxzbUFW?=
 =?utf-8?B?RHptQnhJOVl6b2R1MVdoS1VuNU10V1NCb2FBSDliZDZVZDFRZ3loYThaaG5T?=
 =?utf-8?B?blFsTFJzdWMzRDRXemRrOWhoTWYrV2V3OHJhYVBYS0pHU0VTc1NvTjlLbmZP?=
 =?utf-8?B?ckZRVXlWUGd5TnhoenliZ2g2ZGhpZE9Sb0djbWVCQXFyZlhjMjdGMEhFSXJj?=
 =?utf-8?B?dmRMcU9JRmduVERSUjJ1OVcwUWtBc0ZVZlBMYVBDYnVsejlLM3pQZnVqaTd1?=
 =?utf-8?B?RU5BUWE2cUtseHlOQlFWWis0VjVOcHYyUGttbDJjMC9oNHBSd1ZCUW90RWw2?=
 =?utf-8?B?WGFrV1YyVHUxVXBqR3FkR2lwTGFrYW45L2NNSWI4NXlJcWI1ZUI0NUsvd2Ns?=
 =?utf-8?B?R3hrQm56b0lrRzNySUxndmI2U3ozZDZDTTVzR1FYUUxtN21kNlk1RXFockdo?=
 =?utf-8?B?anBoWXFoZXlLU3ZnSGI5cXVubDUxa0Q0YWxreDcwNy9SZk9qMlZodDd0MCts?=
 =?utf-8?B?dG0rSDRabHIrREh0S0pUOUZkOGcvR09neTg0cWZZWFI2ZjZQQXFkYkQ1Wjhk?=
 =?utf-8?B?bzM0UHFXSFRhQVhPYldUc0tUVmRJQldNSlNhYldGdFJHdGdhK2IzVGwxUjdY?=
 =?utf-8?B?SzViTUp5YnBrSDhBNHA5NFRJYVY3bkFONldWeDB6bXFPZ0liYzczU29YR21j?=
 =?utf-8?B?QndZSzhTOXRzK1cra0hpMitJemJDWE9ybytZdk9WRktBSXVKdndUWnYyMGg5?=
 =?utf-8?B?YVJUeHBwOFhEb3U3eTJLN2hmN3YvYWxpZFhuMnlvOTErUVpBYUNibFN6QUJl?=
 =?utf-8?B?bGpyMkpnU2ZRa09CVGVtQzhvODk3eUR4VTV5ejdmSmgraEZGUWZDUkdOUFZK?=
 =?utf-8?B?MklDcFFkS3VhOWZjY3crZjVyQk1GREt3ZjdQbGtkTGxHVDBhMUswcXVjZTRx?=
 =?utf-8?B?VUhGcXJqbEZ4QnhCaUV4OERJbWxuWVFIUFZpem5nWGJxekFvYnpRUGRvVnA0?=
 =?utf-8?B?ZkM0b2pDanpZWml2WlZseGFHNU11cCs0RmorSllKdFBGUTlMbHpjZ0hPdngx?=
 =?utf-8?B?OU9oYlZrWEQ0Q2ZZTmUyS3FWeGpwaHQ1SjNxd2ROMmx5ZDhYa0JoQnJ6TjNL?=
 =?utf-8?B?bktpclRvdWxKVXdERDRDMFlqdzN4VWIrRnRIai9KYm1iVTRJU2ZUM01XNzFu?=
 =?utf-8?B?OFExNnhyaTJDUE9qRjJRWk1hSDFTdkx4S09VVGZPcVAwREkvSXU4QzhuVnNP?=
 =?utf-8?B?QW44VFdOL2JkNWFIZDFSNm1ERXp5aUVhMWZBZnZVNEcrWHA1M05lcXFFemg5?=
 =?utf-8?B?Z1daaVA2dnNWR2FuTzVrR2hWdXVUNHExNDZHV2VISTV2b1BXSE95bUt2MC85?=
 =?utf-8?B?NmVBNFlUVncwOUhmaE1BWWxvZ0VEK1ZENDFRZEtCWm9XYXBiSFZ2c0hwVDBq?=
 =?utf-8?B?MjVZRzZpMnp2L0JsWmFHR3ZQNldxVzdEcE83bUE0eFQwdHplMXRtNzlpeG9s?=
 =?utf-8?B?emJybGVPaGFqK3JDbVdhVjlKbm5VdjJjWjVRK2xvK1dKQjY0bXZXanlXUjZq?=
 =?utf-8?B?Z2RyU1h1LzU1R3hrQkt4MzVxQVpWc3ZWZVg3SmRLQ0JtbFRNcGVOMzNBYitM?=
 =?utf-8?B?NWxlR0taTHd5c05ZRFhqYld4a1Y1dzVWOFlDazQva3pSN1V2UGJPVG1TRTl2?=
 =?utf-8?B?RGdhdDRsUFp2RW04YXY4UlJNTWZZQmhYY0VwdWFFZzhTSlJLdGlVNm5IRXF1?=
 =?utf-8?B?ejV6RkswbDVBSEJScmo4UUJrdFZzVmUzaDdZSkF1ampWU2h0YVp3YWJMTzcy?=
 =?utf-8?B?ckJvYzdUbjZwRVg5MHhsNGxGKzZYRHRJNWhOYUgwT1RsaFBISXp3KzFvM1NW?=
 =?utf-8?B?OW0xWnBTSHJQbEZyU1ZoeFRlTndvbUUyVm9Sa0Q2akJKUTl6Snl5R3M3L2xK?=
 =?utf-8?Q?P3JXp3MYYcjJIUjQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5096.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86e74ac9-e624-4990-d8e8-08da12f6ad6d
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 09:13:10.4902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nfWluyQtRHD5kFqDkhwAQyg4zKWLGppC9vblujvGEZwazm8RUpGB3AWoVxUsIK6jH5CQo8NkoGcEVeHYdzeCTUtdi9maYXIhPd9xxId82DI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3677
X-Proofpoint-ORIG-GUID: D6hCTwNCroX1t7GSH_lmNTrBddWFhrPc
X-Proofpoint-GUID: D6hCTwNCroX1t7GSH_lmNTrBddWFhrPc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.850,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-31_03,2022-03-30_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 lowpriorityscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203310051
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2aWQsDQoNClNvIHdlIGVuZCB1cCBpbiBpcDZfcGt0X2Rpc2NhcmQgLT4gaXA2X3BrdF9k
cm9wIDoNCg0KLS0tDQppZiAobmV0aWZfaXNfbDNfbWFzdGVyKHNrYi0+ZGV2KSAmJg0KCSAgICBk
c3QtPmRldiA9PSBuZXQtPmxvb3BiYWNrX2RldikNCgkJaWRldiA9IF9faW42X2Rldl9nZXRfc2Fm
ZWx5KGRldl9nZXRfYnlfaW5kZXhfcmN1KG5ldCwgSVA2Q0Ioc2tiKS0+aWlmKSk7DQoJZWxzZQ0K
CQlpZGV2ID0gaXA2X2RzdF9pZGV2KGRzdCk7DQoNCglzd2l0Y2ggKGlwc3RhdHNfbWliX25vcm91
dGVzKSB7DQoJY2FzZSBJUFNUQVRTX01JQl9JTk5PUk9VVEVTOg0KCQl0eXBlID0gaXB2Nl9hZGRy
X3R5cGUoJmlwdjZfaGRyKHNrYiktPmRhZGRyKTsNCgkJaWYgKHR5cGUgPT0gSVBWNl9BRERSX0FO
WSkgew0KCQkJSVA2X0lOQ19TVEFUUyhuZXQsIGlkZXYsIElQU1RBVFNfTUlCX0lOQUREUkVSUk9S
Uyk7DQoJCQlicmVhazsNCgkJfQ0KCQlmYWxsdGhyb3VnaDsNCgljYXNlIElQU1RBVFNfTUlCX09V
VE5PUk9VVEVTOg0KCQlJUDZfSU5DX1NUQVRTKG5ldCwgaWRldiwgaXBzdGF0c19taWJfbm9yb3V0
ZXMpOw0KCQlicmVhazsNCgl9DQoNCi0tLQ0KV2hhdCBoYXBwZW5zIGluIHRoZSBjYXNlIHdoZXJl
IHRoZSBsM21kZXYgaXMgbm90IHVzZWQsIGlzIHRoYXQgd2UgZ28gaW50byB0aGUgZWxzZSBicmFu
Y2goaWRldiA9IGlwNl9kc3RfaWRldihkc3QpOykgYW5kIHRoZW4gd2UgY2FuIHNlZSB0aGF0IHRo
ZSBjb3VudGVyIGlzIGluY3JlbWVudGVkIG9uIHRoZSBsb29wYmFjayBJRi4NCg0KU28gaXMgdGhl
IG9ubHkgb3B0aW9uIHRoYXQgbDNtZGV2IHNob3VsZCBiZSB1c2VkIG9yIGlzIGl0IHN0cmFuZ2Ug
dG8gZXhwZWN0IHRoYXQgdGhlIGlkZXYgd2hlcmUgdGhlIElOTk9ST1VURVMgc2hvdWxkIGluY3Jl
bWVudCBpcyB0aGUgaW5ncmVzcyBkZXZpY2UgYnkgZGVmYXVsdCBpbiB0aGlzIGNhc2U/DQoNCkJl
c3QgUmVnYXJkcywNCkZpbGlwIFB1ZGFrDQoNCi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQpG
cm9tOiBEYXZpZCBBaGVybiA8ZHNhaGVybkBrZXJuZWwub3JnPiANClNlbnQ6IFdlZG5lc2RheSwg
OSBNYXJjaCAyMDIyIDA1OjUwDQpUbzogWGlhbywgSmlndWFuZyA8SmlndWFuZy5YaWFvQHdpbmRy
aXZlci5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0OyB5b3NoZnVqaUBsaW51eC1pcHY2Lm9yZzsg
a3ViYUBrZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdl
ci5rZXJuZWwub3JnDQpDYzogUHVkYWssIEZpbGlwIDxGaWxpcC5QdWRha0B3aW5kcml2ZXIuY29t
Pg0KU3ViamVjdDogUmU6IFRoaXMgY291bnRlciAiaXA2SW5Ob1JvdXRlcyIgZG9lcyBub3QgZm9s
bG93IHRoZSBSRkM0MjkzIHNwZWNpZmljYXRpb24gaW1wbGVtZW50YXRpb24NCg0KT24gMy84LzIy
IDc6MTYgUE0sIFhpYW8sIEppZ3Vhbmcgd3JvdGU6DQo+IEhpIERhdmlkDQo+IA0KPiBUbyBjb25m
aXJtIHdoZXRoZXIgbXkgdGVzdCBtZXRob2QgaXMgY29ycmVjdCwgY291bGQgeW91IHBsZWFzZSBi
cmllZmx5IGRlc2NyaWJlIHlvdXIgdGVzdCBwcm9jZWR1cmU/IA0KPiANCj4gDQo+IA0KDQpubyBm
b3JtYWwgdGVzdC4gQ29kZSBhbmFseXNpcyAoaXA2X3BrdF9kaXNjYXJkeyxfb3V0fSAtPiBpcDZf
cGt0X2Ryb3ApIHNob3dzIHRoZSBjb3VudGVycyB0aGF0IHNob3VsZCBiZSBpbmNyZW1lbnRpbmcg
YW5kIHRoZW4gbG9va2luZyBhdCB0aGUgY291bnRlcnMgb24gYSBsb2NhbCBzZXJ2ZXIuDQoNCkZJ
QiBMb29rdXAgZmFpbHVyZXMgc2hvdWxkIGdlbmVyYXRlIGEgZHN0IHdpdGggb25lIG9mIHRoZXNl
IGhhbmRsZXJzOg0KDQpzdGF0aWMgdm9pZCBpcDZfcnRfaW5pdF9kc3RfcmVqZWN0KHN0cnVjdCBy
dDZfaW5mbyAqcnQsIHU4IGZpYjZfdHlwZSkgew0KICAgICAgICBydC0+ZHN0LmVycm9yID0gaXA2
X3J0X3R5cGVfdG9fZXJyb3IoZmliNl90eXBlKTsNCg0KICAgICAgICBzd2l0Y2ggKGZpYjZfdHlw
ZSkgew0KICAgICAgICBjYXNlIFJUTl9CTEFDS0hPTEU6DQogICAgICAgICAgICAgICAgcnQtPmRz
dC5vdXRwdXQgPSBkc3RfZGlzY2FyZF9vdXQ7DQogICAgICAgICAgICAgICAgcnQtPmRzdC5pbnB1
dCA9IGRzdF9kaXNjYXJkOw0KICAgICAgICAgICAgICAgIGJyZWFrOw0KICAgICAgICBjYXNlIFJU
Tl9QUk9ISUJJVDoNCiAgICAgICAgICAgICAgICBydC0+ZHN0Lm91dHB1dCA9IGlwNl9wa3RfcHJv
aGliaXRfb3V0Ow0KICAgICAgICAgICAgICAgIHJ0LT5kc3QuaW5wdXQgPSBpcDZfcGt0X3Byb2hp
Yml0Ow0KICAgICAgICAgICAgICAgIGJyZWFrOw0KICAgICAgICBjYXNlIFJUTl9USFJPVzoNCiAg
ICAgICAgY2FzZSBSVE5fVU5SRUFDSEFCTEU6DQogICAgICAgIGRlZmF1bHQ6DQogICAgICAgICAg
ICAgICAgcnQtPmRzdC5vdXRwdXQgPSBpcDZfcGt0X2Rpc2NhcmRfb3V0Ow0KICAgICAgICAgICAg
ICAgIHJ0LT5kc3QuaW5wdXQgPSBpcDZfcGt0X2Rpc2NhcmQ7DQogICAgICAgICAgICAgICAgYnJl
YWs7DQogICAgICAgIH0NCn0NCg0KVGhleSBhbGwgZHJvcCB0aGUgcGFja2V0IHdpdGggYSBnaXZl
biBjb3VudGVyIGJ1bXBlZC4NCg==
