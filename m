Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D37C66079B4
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 16:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJUOga (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 10:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJUOg2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 10:36:28 -0400
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3042F24E3A1;
        Fri, 21 Oct 2022 07:36:27 -0700 (PDT)
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29LEXhZ9005569;
        Fri, 21 Oct 2022 14:36:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : date :
 message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version : subject; s=pp1;
 bh=Xk1nPk+7wbcO4p+dzs4R/Nq3R4EWXss/ihXlkb2tB3k=;
 b=D+zN1oB76QlhbUN8YfWk3BPGpRjbTaFj/szut3Er2JT2SxjHRdjoJiiSYllptSarbX1V
 ty3zUVN5L9iJKRYlP8NIR0aWsdprXRb4+rT5uszqUSLBJOAp/JzcsfI5mgJL851FkI05
 Q9dEb2MdnJTahv8xWkJt+Vsfu7aaea/Uu3hIetSuXgxSn0d2czuEovQeo5LUDl8YNI3p
 KCHuWsfghSxNKPJN8D7usTNlQ9HAwVZCUeaaENvanx9JDz5tfXuR2Z+gapzdvMoWl1mo
 Fh4s3qsUWqRtsgznGneH2V55UvJdV7TCsy61mjE9A2dRUCh/3WP9sutxJ5iUETCKyOq1 5g== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbw9y034c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 14:36:07 +0000
Received: from m0098421.ppops.net (m0098421.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 29LEYhL2008538;
        Fri, 21 Oct 2022 14:36:06 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3kbw9y032y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Oct 2022 14:36:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lOV4lVT79sH/2P4DVNVB86PkqpeGT+FoFN4C+SyRbTg79tZbNVULfcPJB4us9ivFYTzN4yJQk3j3Ig9lKiI7u/el3/Vm32X817i3dd/eW1ynYU/eMAVXjOsT5WBH80PFlMCHDqu6JXH7O3K6lPZWLmMGwP2JCu9Q0SHBzCYqmVoQm+DuhKMJCVOay8IzQYcQlFfrR1SniVFlxdlGGDpsE8g2mSSC9OqPrJDgR60Y33+jmil/oEeHUf8rFvwTUZff7KX5HphTRhchaDTDzTzUXIvGhgijrZTUh70oQsgLtwGPtQ7KmPlrUR2H4O9FKradKMelQdI44ibpa9anSMwQfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xk1nPk+7wbcO4p+dzs4R/Nq3R4EWXss/ihXlkb2tB3k=;
 b=ODDtW7Q4sAYEmHL0z9ppHL+70/fJ/iP0caIK5irZdS51+wTVx43m88QTU0Dmr4oCXJLT/S46B9JHz/wmJew5pm/amIGZ5QCWLKHxruLJKFJCQeAf6skE7aeQeUxdYtd6mfyigDTbIg1Bsx/tgDwMrG1fNGYeMCH/fdJ7BkcNDBD+Ny83bCw/FcGWSuN2fkJReB70/Vxb0GBwLXQN7KPn8Q2EquwRab0qDLB40wv1zMshKPilcxxSlahYSrI4SHzLWJt0E+sUyiDKlJlTOJX7JegRKD5u5CM5jejjUkQNX4SmATtFwC9vf7AuT851aHUpEQUGWgmxo6+0DI97bSj5tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zurich.ibm.com; dmarc=pass action=none
 header.from=zurich.ibm.com; dkim=pass header.d=zurich.ibm.com; arc=none
Received: from SA0PR15MB3919.namprd15.prod.outlook.com (2603:10b6:806:91::20)
 by PH0PR15MB4720.namprd15.prod.outlook.com (2603:10b6:510:9a::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30; Fri, 21 Oct
 2022 14:36:04 +0000
Received: from SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::199f:5743:f34e:9bd3]) by SA0PR15MB3919.namprd15.prod.outlook.com
 ([fe80::199f:5743:f34e:9bd3%8]) with mapi id 15.20.5723.035; Fri, 21 Oct 2022
 14:36:04 +0000
From:   Bernard Metzler <BMT@zurich.ibm.com>
To:     Tom Talpey <tom@talpey.com>, Long Li <longli@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        Ajay Sharma <sharmaajay@microsoft.com>
CC:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Thread-Topic: [EXTERNAL] Re: [Patch v8 12/12] RDMA/mana_ib: Add a driver for
 Microsoft Azure Network Adapter
Thread-Index: AQHY5HKR+s6HwQcRfUGdJCoWTD4cha4Xv/4AgAErWwCAAABDUA==
Date:   Fri, 21 Oct 2022 14:36:04 +0000
Message-ID: <SA0PR15MB3919DE8DE2C407D8E8A07E1F992D9@SA0PR15MB3919.namprd15.prod.outlook.com>
References: <1666218252-32191-1-git-send-email-longli@linuxonhyperv.com>
 <1666218252-32191-13-git-send-email-longli@linuxonhyperv.com>
 <SA0PR15MB39198F9538CBDC8A88D63DF0992A9@SA0PR15MB3919.namprd15.prod.outlook.com>
 <PH7PR21MB3263D4CFF3B0AAB0C4FAE5D5CE2A9@PH7PR21MB3263.namprd21.prod.outlook.com>
 <9af99f89-8f1d-b83f-6e77-4e411223f412@talpey.com>
In-Reply-To: <9af99f89-8f1d-b83f-6e77-4e411223f412@talpey.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA0PR15MB3919:EE_|PH0PR15MB4720:EE_
x-ms-office365-filtering-correlation-id: 91dff4bf-371c-4aaf-0c97-08dab371954b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7fMdoNP9bpp/blHgb97igLhdcS8sOhfPBB/KUgF+q0GqKeSCif1C3Myv9YeN8uTOq1j8tmPuMHTv/yQz41ZP5R1AwmmB8+yuaUN+Xqfjd4/f5Y5DUODaqJjY/EnrpuhJ4921Dj5dMSflvO9VhoU8sy8qOmgWR2hJdxvq95lu8WvxihpFqZf8riFdCXp5QENAs00IX5UzBX7c5ScQ5iN/b4c6SCmcqUj55lOtGDoy3yeeef6wZGmNz9XhTFGAK+c+djMPthmOfHaQLcOw6qQQYmFMGiHeRZqjPPM+bmFUlfHp8Frmd6U7wrHYbgYoEUgfoF6VIX16SJYKFQ9IMc6f0+BWpC9hlG7JizT47n7MgRpR01MbCs7iI4l2MaTJrZ1ywFbFVewsL2QqarjsId4xFUnZ2xruaa8GmaKpdHj10Anmbv1QAjzeZuZa1kcaw3F819sGtC1gS0Y8BkZde/aWEUY93mT8ctSeac0Rx7DYAX6mCaNUSoKNnDYK2+cSUWN6dGnFkaxy3kzDkUVQAaBu3f1KUlb9paaPblS8r2kLOhOJ1GOqtgfHgaTT2uDL50OjkWWbfbfCDQZrV+SAroHYYfrmpyGGWf6zgIufjO7e6MpzmFlXlWMxLNktce/9nBOCOzviUakmTemAhM01pGlOZ+a6pobmcpSC1Dn0dkwYLJ7LxttvWj3PT7Pj+u/rczYog/aAPU3du716YlN0oUF5lGu48STSZneNUff1Y7PUU9fgESl1hVZ6MtbsvutRz4/1CIv+nzRiqCZ5szY8DUkuhkcpevuLVpOViV9ZQaf5XMA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA0PR15MB3919.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(136003)(39860400002)(396003)(376002)(47530400004)(451199015)(54906003)(33656002)(122000001)(7696005)(52230400001)(86362001)(2906002)(38100700002)(921005)(38070700005)(83380400001)(6506007)(186003)(8936002)(8676002)(478600001)(71200400001)(53546011)(9686003)(110136005)(45080400002)(4326008)(7416002)(64756008)(76116006)(316002)(66476007)(66556008)(66946007)(66446008)(52536014)(5660300002)(41300700001)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bndmZWVLdTBqbThoWFFMcGRwMUtrMUdkNGVWQUNnb09IYU1lSTZEcHpQVDRp?=
 =?utf-8?B?Tk1LTWd4MUkvS1J0YTVEaTgybmMvQnZ1K2pkQXZTN1VKT000Z1pBNXdZbmNE?=
 =?utf-8?B?RUVRc3RVTHcxYWJQOXBhcitZWUVhK1J5MVNINThlQXVscDc4VU1WMDZNTzNL?=
 =?utf-8?B?a2tzQktoSVlseWhyQ0RsWUFrbDlVeFlFcFkyQTVKN0VTZUV1MEU2T1lRTjdJ?=
 =?utf-8?B?S1NMd0JvVk1rRFJLNGtUdEpuNGUyQldzbE9obnNWZnJKc3psQzV6b3YrNFd5?=
 =?utf-8?B?Vmp5aEZMaGJqbVBqMGxqL3RuSHRDRVU3SnNQbUdPcXBGWDBpK0M5bkFMelNh?=
 =?utf-8?B?b0dscEd6OWViTzdVWnB2c3ZhL1BuNUVyd0tTMU5zZ2JQaTUxWUwvMW5TSExh?=
 =?utf-8?B?ZUdyRklLVXBKT1hQY0w3bDErdXQ0bUpXUWxET1pGZk9xaUZhNnpkMGFtaDVG?=
 =?utf-8?B?bzBwcHEwQ1g4UUIvM2RlZ3Y3K2NwMFVMMEh0WHNiWTlIUldJRVBQNXUvbGpV?=
 =?utf-8?B?UmV0NXpBOVJzS3JBWE1xRnE1MTBKdDRQM1RmOEpIR3d4enBSNTJXZW5OamVH?=
 =?utf-8?B?Y1NGNlF3Q3Y2dFFRZGltaStta0R1UzJKTlp5YzZpc2l1NDUwUjhzMENuRHNy?=
 =?utf-8?B?RUlCQzhRTVVhbzRobHdONVhhd0tTd29qam1aQmJWKzhXaUZraDliYTU0ZWI4?=
 =?utf-8?B?RlREcEdnQW1HQnRBaFhDMDVLbmJFUTBJQVVhUERsMERQMlBNbkt3Q3gvNmpP?=
 =?utf-8?B?YnJtLzJ1cUhDTXhKcnN2bU1CRG53bE5hVVNOWTlFMUppYWZ0RFBId3crWWpR?=
 =?utf-8?B?VXpXL1FPR3o4SVFWMkppNktUcjVGalFsWEh3QlVndXJlLzM0cldCQ1diaTRy?=
 =?utf-8?B?Ykc0TE90TERFU2VXMFhyQlhzV1pvS0pqOHpqQk4xVWF0aDNFd2dtTENWUnd6?=
 =?utf-8?B?Y3NMcWxraElmY0RBS21tTjErbTlQWWVNRlkzUERnbVFsTHFldXFvcXFJbmVq?=
 =?utf-8?B?bE1aMU8xMGw2cFdncTRtTE90dnU1ZmJ0YUo4MW1WS1E4akhMcnRBMWxOWE1s?=
 =?utf-8?B?WUp3bDQ2eTZiTnh1bGF3M21QLzU0dFUwYVU1bmJ6ZGM5a3JSNzJqQTJ6Nkt5?=
 =?utf-8?B?bHFNSVpNL084YWZmeWJDMWFuZkI0WUFMN2JocHMwQlRGNFI5WGVlL1Voc3F1?=
 =?utf-8?B?YUFsUE1nT0o3RHJWRkZJSDdTTGpnQmlBN0QxVk9HajBud2VKZ0g4RzBsNm1z?=
 =?utf-8?B?VFVjWTRlNC9DRGNudjVjdHRwRnUvWmoxRmxBR0lsd1JRMEx1S1NxbTUzL25Z?=
 =?utf-8?B?c2IvUStER2NyaVRlV1Y3NDE4NjNIZ1lkZjh4N1lsUGoyYzFhQUpqdXUzMlg1?=
 =?utf-8?B?aWNOQ09BZTN0emRWbTlIdC9sTERSS2kvaUV5RXNHRUkyWWkrNTZtR1ZXd3NF?=
 =?utf-8?B?bjc2RjQrbjNlTm16NlRKc3hEam5PbHY0TVVQWTRrWG5TMU9ORWlBaVp6L1R0?=
 =?utf-8?B?L0l1SXU4TFpCWjE1dnRTSnlXeEpad2hKU2xSOWI0QytmcUFNeHpRczZwaGZa?=
 =?utf-8?B?QWtMVXJteXNtUTZ1M1FBakxBSGFIR3dIWTA4Rmp6SHNBekRaSmtyaGpsWEhQ?=
 =?utf-8?B?UUQyVFBNNzVxUTlvemNxU1lFTU9MN3M5OUhuSEg2cGxHanFwWklpenptNUEw?=
 =?utf-8?B?eUJHdGdnWENSVzk2c1FWSWNRbDB2eVpNeVp3eVRCcG44a29JWk1nNVhvNHRI?=
 =?utf-8?B?RVY0NVhwUzhHc0dYUkJGNXJXV3FGUnFTNEV2am5WYUpwd2ovdUtnYU92UlBF?=
 =?utf-8?B?MURsRy9JQ0kveTY5c1l4d0pWQzQ2UU9aNlFEUnRDTXBOSTY0TXQyNmFBMjFj?=
 =?utf-8?B?VWJoaWZRNG1tNHVIVWhMb0tsS1NMVlZ4OUNOT0h1SVFwNlZsaUNoenhxSGx6?=
 =?utf-8?B?eHRXcHluY3ZnbGtiOG1seU1welpxSHlhQVJUcU5zc2VXVG5jUXN0eDR1VlBP?=
 =?utf-8?B?eEZaQ0Z1clV3cTh2cVRqa0s4ZGswREtwdWp4aEJJb2laQlZrU0lUOGZSRUsv?=
 =?utf-8?B?LzFOdTNJZHdWL2hxKzNsTURZMWpDVXVOZmZud3RzYVBGUzIrcUhML3h2WXZU?=
 =?utf-8?B?NDRxQTQ2dlJSVVBWNFJtK1ZzQUtWK2hKQzlYeTA5cURCdUZEUTJsbGdWUDVO?=
 =?utf-8?Q?FaGQAPSjdLRwZeVIeDb6rUbciCHTgAyIGtovatCRw7fT?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Zurich.ibm.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA0PR15MB3919.namprd15.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91dff4bf-371c-4aaf-0c97-08dab371954b
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2022 14:36:04.3121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: fcf67057-50c9-4ad4-98f3-ffca64add9e9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7AbeyfBSpn1PJPSpcPm/jwM+gBdEivjekqxpg1eBYtpYJLVrFAKQ8EpVaPqHqwtyBXv/M6Y5LDyGmufuP2BOtg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR15MB4720
X-Proofpoint-GUID: U7MB-pl_cA4IPAJRaLS1dkrYpvX3PvCI
X-Proofpoint-ORIG-GUID: CHInqeOtvtdNdpSEyEnB6hotwDu_pVcS
Subject: RE: [Patch v8 12/12] RDMA/mana_ib: Add a driver for Microsoft Azure Network
 Adapter
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-21_04,2022-10-21_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 phishscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 priorityscore=1501 impostorscore=0 clxscore=1015 bulkscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210210088
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogVG9tIFRhbHBleSA8dG9t
QHRhbHBleS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgMjEgT2N0b2JlciAyMDIyIDE2OjM0DQo+IFRv
OiBMb25nIExpIDxsb25nbGlAbWljcm9zb2Z0LmNvbT47IEJlcm5hcmQgTWV0emxlciA8Qk1UQHp1
cmljaC5pYm0uY29tPjsNCj4gS1kgU3Jpbml2YXNhbiA8a3lzQG1pY3Jvc29mdC5jb20+OyBIYWl5
YW5nIFpoYW5nIDxoYWl5YW5nekBtaWNyb3NvZnQuY29tPjsNCj4gU3RlcGhlbiBIZW1taW5nZXIg
PHN0aGVtbWluQG1pY3Jvc29mdC5jb20+OyBXZWkgTGl1IDx3ZWkubGl1QGtlcm5lbC5vcmc+Ow0K
PiBEZXh1YW4gQ3VpIDxkZWN1aUBtaWNyb3NvZnQuY29tPjsgRGF2aWQgUy4gTWlsbGVyIDxkYXZl
bUBkYXZlbWxvZnQubmV0PjsNCj4gSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47IFBh
b2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IEphc29uDQo+IEd1bnRob3JwZSA8amdnQHpp
ZXBlLmNhPjsgTGVvbiBSb21hbm92c2t5IDxsZW9uQGtlcm5lbC5vcmc+Ow0KPiBlZHVtYXpldEBn
b29nbGUuY29tOyBzaGlyYXouc2FsZWVtQGludGVsLmNvbTsgQWpheSBTaGFybWENCj4gPHNoYXJt
YWFqYXlAbWljcm9zb2Z0LmNvbT4NCj4gQ2M6IGxpbnV4LWh5cGVydkB2Z2VyLmtlcm5lbC5vcmc7
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3Jn
OyBsaW51eC1yZG1hQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbRVhURVJOQUxdIFJlOiBb
UGF0Y2ggdjggMTIvMTJdIFJETUEvbWFuYV9pYjogQWRkIGEgZHJpdmVyIGZvcg0KPiBNaWNyb3Nv
ZnQgQXp1cmUgTmV0d29yayBBZGFwdGVyDQo+IA0KPiBPbiAxMC8yMC8yMDIyIDQ6NDIgUE0sIExv
bmcgTGkgd3JvdGU6DQo+ID4+IFtCZXJuYXJkIHdyb3RlLi4uXQ0KPiANCj4gPj4+ICsJcHJvcHMt
Pm1heF9xcF93ciA9IE1BWF9TRU5EX0JVRkZFUlNfUEVSX1FVRVVFOw0KPiA+Pj4gKw0KPiA+Pj4g
KwkvKg0KPiA+Pj4gKwkgKiBtYXhfY3FlIGNvdWxkIGJlIHBvdGVudGlhbGx5IG11Y2ggYmlnZ2Vy
Lg0KPiA+Pj4gKwkgKiBBcyB0aGlzIHZlcnNpb24gb2YgZHJpdmVyIG9ubHkgc3VwcG9ydCBSQVcg
UVAsIHNldCBpdCB0byB0aGUgc2FtZQ0KPiA+Pj4gKwkgKiB2YWx1ZSBhcyBtYXhfcXBfd3INCj4g
Pj4+ICsJICovDQo+ID4+PiArCXByb3BzLT5tYXhfY3FlID0gTUFYX1NFTkRfQlVGRkVSU19QRVJf
UVVFVUU7DQo+ID4+PiArDQo+ID4+PiArCXByb3BzLT5tYXhfbXJfc2l6ZSA9IE1BTkFfSUJfTUFY
X01SX1NJWkU7DQo+ID4+PiArCXByb3BzLT5tYXhfbXIgPSBJTlRfTUFYOw0KPiA+Pg0KPiA+PiBI
b3cgdGhlIDI0IGJpdCB3aWRlIE1SIGtleXMgY2FuIGhhbmRsZSBJTlRfTUFYIHVuaXF1ZQ0KPiA+
PiBNUidzPw0KPiA+DQo+ID4gTm90IHN1cmUgaWYgSSB1bmRlcnN0YW5kIHRoaXMgY29ycmVjdGx5
LCBsa2V5IGFuZCBya2V5IGFyZSB1MzIgaW4gaWJfbXIuDQo+IA0KPiBUaGUgdXBwZXIgOCBiaXRz
IG9mIGFuIGliX21yIHJlbW90ZSB0b2tlbiBhcmUgcmVzZXJ2ZWQgZm9yIHVzZSBhcyBhDQo+IHJv
dGF0aW5nIGtleSwgdGhpcyBhbGxvd3MgYSBjb25zdW1lciB0byBtb3JlIHNhZmVseSByZXVzZSBh
biBpYl9tcg0KPiB3aXRob3V0IGhhdmluZyB0byBvdmVyYWxsb2NhdGUgbGFyZ2UgcmVnaW9uIHBv
b2xzLg0KPiANCj4gVG9tLg0KDQpSaWdodCwgbXkgcG9pbnQgd2FzIHRoYXQgb25lIGNhbm5vdCBl
bmNvZGUgSU5UX01BWCBkaWZmZXJlbnQgTVIgDQppZGVudGlmaWVycyBpbnRvIDMyIC0gOCA9IDI0
IGJpdHMuDQoNCkJlc3QsDQpCZXJuYXJkLg0K
