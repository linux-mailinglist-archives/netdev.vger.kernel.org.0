Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2F2558774
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 20:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbiFWS0v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 14:26:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiFWS0X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 14:26:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 298F4C6150;
        Thu, 23 Jun 2022 10:27:27 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 25NErYBs027251;
        Thu, 23 Jun 2022 17:27:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=2Ne2j27Hb9rgnIc8dTPHPv9bz8PuCNdTRy21YZQLrEM=;
 b=UFp1zMjStIREvKmynT2W1LNDmXiQCMwC7/w5lmCwDuJUFXQQVvfjwNQ78/LAhNpIN4vu
 QSDfCmnSOF4mUIbnD/FdcdVCziE4sRYAphSXB7A/b27vB0dpkm+I5PYN4L4CS1s+rZVG
 59GSGX0r6b6hu5LNgWnNJh1yM/R0SuYjiVR44KRUpYpUFfJkXTvRBEYm92WkQBQpQMF9
 Gzg6BfUn3T9MO6DM1E/arnsZJSNiyi4QX5Q9Weeu2Def6J8tgcCDsvbWlzYx7gOKAPqQ
 ev+BYMtrolP6n7O6BcOhvi6ACsoo34rK9N5CvIkRP/CbAxNUeWQeD1i/i/SAm6KVR25Q yQ== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gs6kfbja8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 17:27:23 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 25NHEllp035312;
        Thu, 23 Jun 2022 17:27:22 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gtg5wprbk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Jun 2022 17:27:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dx5pWXy41WolYof7ISeyhRMt0Ks6t8vzAWNH00zNNgOS6fPTlQEfZL7CofaxFB+48hALk2z5hzc8LXNqKoDv/KbCCqXhIZEK0mdf3kmq6MSYIMRaf7u8m9LRGWxi8uGTDhOJXRYltsid7jeZfs4qNByz0GmdHE58Z8AXYeVxpaAn2tZ/VC+L+JTEYrkHyuLxtb1tM1OP4UYcjttTGCQyMmzyzrdD0GI/qMVomS7s5H2HXtHEpFb4v7iYlCjZ+j3llYXR91PgotkJrCGXXai0HBLtBZYoL3C3EgnW/wJRTSjQ/CLWlIhuFOysq4x/ZCkudDuQNdmaUg2+FprpDsKbNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Ne2j27Hb9rgnIc8dTPHPv9bz8PuCNdTRy21YZQLrEM=;
 b=h+mktItEzj4aX7IRrWs4v4tVLWox/Nmt89deZCov6eGZcuHRquFheBoqxUxclwuRqc8V3r22GWK42T+DIlrU7pk3A3FUX+cwpMWnKaiqHxf+gQvDBJGdiiPGz7cWIcWgDzpXE2ILBy/nrnQSh4s69XQeZ36LxWBMyT4DwhHqmk2WsfSLaIrLCYYTgGRam48s88x3vJajQJHJRoD1Mgyo8GqG6MFgAX/ROWb8W5+N2G5fRLQR6y8RwOSTf6bf1/5JbTrm9ujBP2RFcVN6ydYGS5I/kQuZOpRQWKsczVFBIZXoMUrKeJuNWhq5a75w1fLM6buLSnuv00KP9vidZ5XJAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Ne2j27Hb9rgnIc8dTPHPv9bz8PuCNdTRy21YZQLrEM=;
 b=HIOpBWp9BRTapFIWZ/ybLAGzKEAQNrsbRLKvoU+w5KjbfYhABvR2N22vpoDLl824i2NcbmWWLe7/99WlQ+tiEHqfKw9cbj/756VaAxq8yxv2J9KL/hUoqR0EX0geolO/fLfOVUc/gWWk+kcehRnvuDTxuzmIHhDewc13F6v0q2Y=
Received: from DS7PR10MB5134.namprd10.prod.outlook.com (2603:10b6:5:3a1::23)
 by MN2PR10MB3374.namprd10.prod.outlook.com (2603:10b6:208:12b::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.16; Thu, 23 Jun
 2022 17:27:20 +0000
Received: from DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::c952:6550:162d:4aa]) by DS7PR10MB5134.namprd10.prod.outlook.com
 ([fe80::c952:6550:162d:4aa%5]) with mapi id 15.20.5373.015; Thu, 23 Jun 2022
 17:27:20 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, "tgraf@suug.ch" <tgraf@suug.ch>,
        Dave Chinner <david@fromorbit.com>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH RFC 29/30] NFSD: Convert the filecache to use rhashtable
Thread-Topic: [PATCH RFC 29/30] NFSD: Convert the filecache to use rhashtable
Thread-Index: AQHYhkLHlIdZc73yTECQuJnTH2oZX61cJo8AgAAFjwCAARRXgA==
Date:   Thu, 23 Jun 2022 17:27:20 +0000
Message-ID: <2F100B0A-04F2-496D-B59F-A90493D20439@oracle.com>
References: <165590626293.75778.9843437418112335153.stgit@manet.1015granger.net>
 <165590735674.75778.2489188434203366753.stgit@manet.1015granger.net>
 <20220623003822.GF1098723@dread.disaster.area>
 <1BB6647C-799E-463F-BF63-55B48450FF29@oracle.com>
In-Reply-To: <1BB6647C-799E-463F-BF63-55B48450FF29@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f421d7aa-1c5b-4dbb-dad0-08da553da092
x-ms-traffictypediagnostic: MN2PR10MB3374:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zxxg1H5KqM5SlcbYsnhMXKw6Vw6lbt5xFdIAiFdq6y0+Y+dxdMteNVzxA8LOSmgG5NSFmWK1e+TFFEEePNXLwvZ53TsQbJDYtJNg/2KC5S2aaUUIUoBOqTNqevWSEiIeJDjgVl9YgAkhoN3l+vzoYtaE1JLLVZiLT1Urxy1ex6v76wBhzz/xClLP9oxXT6S6/B8vRN/KUl/YUnuvTTlPbUAYjCFJnG4kjqQ/tOAxY/CiPz21ZK1PA6tenyResUw2V8jdLBdHXPgI8EHQYIw92JfVopD69NU+gitAK8Px74UxHd1y0E1HYtoYwhF2zJPTMTpPFa7RFyQUa5Hd4M/IleKcTrz1m/fDLD7nuBt14cgoWBWGvGYLpzxewGNIskmVaz3UH9ndwcY3sLLMOrCpTinr9y3XvUfkvPh/PHTKh67enGTrhxVv8XzVJVRqiGWs6hbWPMnUsubXe4Bo8EV4c+iCLfhU/IrtmRQi87ZiUi+SxHytbfkwuywGiM72k82uV2AaxwSajbDr9cPA0DrN9rut8r5CZ75OVousP5pt3Ft8Mt+4kH8UNZAcANeBTTTNx5Ny6z4lwO1gKq3od1zcYQ3dedX95Imqq4byTVav+EzCAJ9cT2m0I6IJnw1U4r7Es+qPyJYXGjQtlzPjexgV8d2s7R85WR4pj5YaSaObFgOlMnJ4fU/Rfb+0jDm5zkb67kOkfo7GrI8ShK05X4d0YVo3AZ+IPm6fGiC+XZMCVhjN8yjdhQuv/HAS5niB5hjh16C/QJitmsB6TrlmFKNnJTae2E6y/oboJW9zvZYUevU9+hXvZTPYbxayS+hYFSpqKeOehEuCOA4grYBYg1tpYnq+SAtFkwUVd0Dk5bYSJwU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5134.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(346002)(396003)(39860400002)(136003)(36756003)(33656002)(5660300002)(2906002)(6486002)(91956017)(64756008)(8676002)(66446008)(66556008)(66476007)(66946007)(478600001)(76116006)(8936002)(316002)(110136005)(966005)(53546011)(2616005)(41300700001)(71200400001)(26005)(6512007)(186003)(6506007)(38070700005)(86362001)(38100700002)(122000001)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TFNYNU1mNVB5VjFOZjFLYXI2K2dTbHYxc2N6SzdPVm5BbzBjUXV0ZHJCaFJq?=
 =?utf-8?B?ZmlrZlg0b25pSG5FU0tQMWU3VHp3MWkveG9Ka0lPNUpzbCs5UVl6N0xoUXlJ?=
 =?utf-8?B?Mk9VVUNDc2hvYUNEUkJ4MVN2bWNBWUhjU3RiSVBmSmF1cEdONUtHc0k2S21B?=
 =?utf-8?B?Mi9lejZBV05kUE1tSmdCNktMOU85WUpjT1NzNnpTakJ6V0JpT0E5SVArYUls?=
 =?utf-8?B?emZOY3hvZmZ2NEh0aVJ2V1laeDNEUnZiYm1NWDFlYWkxNURXNXgvUUJ2MDd5?=
 =?utf-8?B?dWdjbnplRUhBRTZtZmc1YVphamJ1alNZQWppSjczRkVoaGY0ODVYOHh5Vzdw?=
 =?utf-8?B?K0xYc0xoTjQwcnRDRG9LTlJ4Z1RHZnVRS1FZSmFnVWdielZraEVTbFAzWFFT?=
 =?utf-8?B?b1Y2cFQrL2h1Z3lxcFZXR2hGWHhzZjQ1YlY5bU1IdnBWOHh2TVVqdm0zam4v?=
 =?utf-8?B?RFYrV1oyVXJxNjExeXFBcTIrK0NxUnlwanhpTEUzSW9xMEU5U3lqdUhpdlpH?=
 =?utf-8?B?eUJsZDErY2NydVZ4eWl4YTlnM0dQanlVNEdhR0ZrL3hBSTR6THBLbzR5WEhl?=
 =?utf-8?B?WVpjT21pT3FtNWllRmtuWFkxVWRlMlBJeWM0YXIxckZLS0FOa3Zqa2xaWXVO?=
 =?utf-8?B?Vnc5Y1lkZWVNcEJ4L3pKc0UrWnk0MlEzYjJrSU5tblRLa3l3WkNvRnJFTStW?=
 =?utf-8?B?OURPcDIvSmRCd1l5M09rOGVyNENJV3g1ekxiQ1J4NENYVmlHdFFYVGhXb1Q4?=
 =?utf-8?B?blBQbjhubWFNSnZ5MFNFdGFoS3l2VkdoY1NWUTRzZE82bXVNWDBTRGtRU0N0?=
 =?utf-8?B?ZTBOZnNEa0UwL2VnWC85U0xBUGZBVU8yTzU3RXA3Y2ljcE5zTDhMOWgyWnpJ?=
 =?utf-8?B?cFZYbkUxRWJKQVVYdDEwUGkxYktZUlA1eGF2dllVRzRhdnpWWTJFdWc0c0Vt?=
 =?utf-8?B?WTB3SFdnQUFTcGovMm8wY2g0NHlYVm4rUXZ3T3Blb0Mwa3JtcnozaFMvRDZI?=
 =?utf-8?B?TU5VbVUrb0pZZHpXTWFjVy91alVyN3ZiOFVXZDczTmc0Z1VCWi9ZUUdDcW8z?=
 =?utf-8?B?NlBCSFNyeVM3YnNWdzBnd0NzOGFtaWdFR1hDK1pwMElReWhaRTVjR3BwSmFN?=
 =?utf-8?B?MWRHTGlFNTlWOUJRV2FLY2xGL1pTcHJZKy9kYm0vaHplajZHWXVJZmN6cnZQ?=
 =?utf-8?B?L1Q4UUhyMTlRb2ZRQXpxK3BpT0FFOVZaVmdIYjFDK3JaWWNDOEh0VWthaXQx?=
 =?utf-8?B?M1AzY3NhZGUzQVFQZ0hLMnlvalVmYklnL2lyeDRWTkwvVnpJdGR4allraTR3?=
 =?utf-8?B?V2FMaWlKTFdDdzhZSnR1eFFWMTQ5V0xZdE81ZU5NblBpd1g5L3VrS1dHUWp0?=
 =?utf-8?B?R0hYbHNyREJoeC8zVTVZNEZyOGVVMHl2cUYrdWw4YlFCajNwOEJWNUJMTmwx?=
 =?utf-8?B?aEZZZkhWUjhMdzRidlRWeW1EVHZyV0JMbDFxVys3MHhGSXlBWVd1MUFkb3Nk?=
 =?utf-8?B?aU1OSHRXbGlKcURwamZ5ZEVhd2U1OW5ibzhKN29BQzc2QXZ0a0pJVUlOa0xx?=
 =?utf-8?B?ZzFwQUhaWXdqSVZLUVJJd00xWEZsQmZTVVk0c0YwYVNRb2VtMWVWTytudVNV?=
 =?utf-8?B?U1Q5TDRHTWJYWUcwVTJRV1E3QkRYUFpRWFRoQzBmSU1PSVBlamU4VEMzMTc4?=
 =?utf-8?B?MUVxRStBQnVsTVkxWUpxWGR3MjY5ZS9aekxaemF6ZnFGUjJERGRSaTJUNUxW?=
 =?utf-8?B?ZWErQ1RrbUV0QWRFbUllc1JJWnpYK25XYjlZRTdqZi80Q2ZmaGdUdmYrTUg0?=
 =?utf-8?B?cW5ZVDg1QytqOUlRcHdQR2JUaSt4eGVGbm5TdGE5ZmROV2dKZ3RISWdOcVN6?=
 =?utf-8?B?b3hqRFU5UXJHSzQxaVVOa205aU5IUkpxdk93QUFsdlBGQlBhN0kyc2NyZ0dO?=
 =?utf-8?B?MGR4RzNPdDFWTTZOcCtFK1ZtU3d3cHNiK2ROL2JmQzY5U1BicmR5MkczaWtS?=
 =?utf-8?B?NFIxOTVFc0E3K0c2V0g5Y3dTOVlFUDFLK3hQeHBUSFdZNm9XMm9MZzdGT29v?=
 =?utf-8?B?bFBvYVIyTW5IWHp1TGw1eDNWb0pTdU0rT3gzTFh6bHR3blUyY2pydnRKSjJy?=
 =?utf-8?B?VTBvWm1pN0hhbjZQVmtzOVVxdXNQQnZaZjgySEZhSDJ6SkplSTVvK1BTTnhp?=
 =?utf-8?B?MUJ3WDcxL0I3clJiZEFINjArNjZPOGhIMlpXbjhxdWhBUUUvU0dpNHAzWjRF?=
 =?utf-8?B?VWZBVWgyK2hNajArSGcwcXVNVkFha1gvSW4yRnM0VWpaSUJBU01lY3VNNDd6?=
 =?utf-8?B?V3N6QkZHNEJuUllvMkdHeE05NUlsZFIvUXNXaCs4QzUyVDhRSis0aHRHVWZR?=
 =?utf-8?Q?swgynArqed6OU0FU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A0A171F918C8464BA317822FAE5B9071@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5134.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f421d7aa-1c5b-4dbb-dad0-08da553da092
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 17:27:20.1066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Mgl0cE68NBBzwTBjDKtQHa7ELcnb52+JFhlz2r2MXUtNQer/YiSucrZGSIL0xSGGmo7fwaGDKfMvN648XLoW5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3374
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-06-23_07:2022-06-23,2022-06-23 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206230068
X-Proofpoint-ORIG-GUID: Zw_8sufIipdkIddDQ_Co3OxmG2t4e0ET
X-Proofpoint-GUID: Zw_8sufIipdkIddDQ_Co3OxmG2t4e0ET
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IE9uIEp1biAyMiwgMjAyMiwgYXQgODo1OCBQTSwgQ2h1Y2sgTGV2ZXIgSUlJIDxjaHVjay5s
ZXZlckBvcmFjbGUuY29tPiB3cm90ZToNCj4gDQo+PiBPbiBKdW4gMjIsIDIwMjIsIGF0IDg6Mzgg
UE0sIERhdmUgQ2hpbm5lciA8ZGF2aWRAZnJvbW9yYml0LmNvbT4gd3JvdGU6DQo+PiANCj4+IE9u
IFdlZCwgSnVuIDIyLCAyMDIyIGF0IDEwOjE1OjU2QU0gLTA0MDAsIENodWNrIExldmVyIHdyb3Rl
Og0KPiANCj4+PiArDQo+Pj4gKy8qDQo+Pj4gKyAqIEF0b21pY2FsbHkgaW5zZXJ0IGEgbmV3IG5m
c2RfZmlsZSBpdGVtIGludG8gbmZzZF9maWxlX3JoYXNoX3RibC4NCj4+PiArICoNCj4+PiArICog
UmV0dXJuIHZhbHVlczoNCj4+PiArICogICAlTlVMTDogQG5ldyB3YXMgaW5zZXJ0ZWQgc3VjY2Vz
c2Z1bGx5DQo+Pj4gKyAqICAgJUEgdmFsaWQgcG9pbnRlcjogQG5ldyB3YXMgbm90IGluc2VydGVk
LCBhIG1hdGNoaW5nIGl0ZW0gaXMgcmV0dXJuZWQNCj4+PiArICogICAlRVJSX1BUUjogYW4gdW5l
eHBlY3RlZCBlcnJvciBvY2N1cnJlZCBkdXJpbmcgaW5zZXJ0aW9uDQo+Pj4gKyAqLw0KPj4+ICtz
dGF0aWMgc3RydWN0IG5mc2RfZmlsZSAqbmZzZF9maWxlX2luc2VydChzdHJ1Y3QgbmZzZF9maWxl
ICpuZXcpDQo+Pj4gK3sNCj4+PiArCXN0cnVjdCBuZnNkX2ZpbGVfbG9va3VwX2tleSBrZXkgPSB7
DQo+Pj4gKwkJLnR5cGUJPSBORlNEX0ZJTEVfS0VZX0ZVTEwsDQo+Pj4gKwkJLmlub2RlCT0gbmV3
LT5uZl9pbm9kZSwNCj4+PiArCQkubmVlZAk9IG5ldy0+bmZfZmxhZ3MsDQo+Pj4gKwkJLm5ldAk9
IG5ldy0+bmZfbmV0LA0KPj4+ICsJCS5jcmVkCT0gY3VycmVudF9jcmVkKCksDQo+Pj4gKwl9Ow0K
Pj4+ICsJc3RydWN0IG5mc2RfZmlsZSAqbmY7DQo+Pj4gKw0KPj4+ICsJbmYgPSByaGFzaHRhYmxl
X2xvb2t1cF9nZXRfaW5zZXJ0X2tleSgmbmZzZF9maWxlX3JoYXNoX3RibCwNCj4+PiArCQkJCQkg
ICAgICAma2V5LCAmbmV3LT5uZl9yaGFzaCwNCj4+PiArCQkJCQkgICAgICBuZnNkX2ZpbGVfcmhh
c2hfcGFyYW1zKTsNCj4+PiArCWlmICghbmYpDQo+Pj4gKwkJcmV0dXJuIG5mOw0KPj4gDQo+PiBU
aGUgaW5zZXJ0IGNhbiByZXR1cm4gYW4gZXJyb3IgKGUuZy4gLUVOT01FTSkgc28gbmVlZCB0byBj
aGVjaw0KPj4gSVNfRVJSKG5mKSBoZXJlIGFzIHdlbGwuDQo+IA0KPiBUaGF0IGlzIGxpa2VseSB0
aGUgY2F1c2Ugb2YgdGhlIEJVRyB0aGF0IFdhbmcganVzdCByZXBvcnRlZCwgYXMNCj4gdGhhdCB3
aWxsIHNlbmQgYSBFUlJfUFRSIHRvIG5mc2RfZmlsZV9nZXQoKSwgd2hpY2ggYmxvd3MgdXAgd2hl
bg0KPiBpdCB0cmllcyB0byBkZWZlcmVyZW5jZSBpdC4NCg0KWWVwLCB0aGF0IHdhcyBpdC4gSSd2
ZSBmaXhlZCBpdCwgYnV0IHNvbWUgb3RoZXIgZG91YnRzIGhhdmUgc3VyZmFjZWQNCmluIHRoZSBt
ZWFudGltZS4NCg0KUmVtb3ZpbmcgdGhlIC5tYXhfc2l6ZSBjYXAgYWxzbyBoZWxwcywgYW5kIGlu
IHRoZSBsb25nIHJ1biwgSSBub3cNCmZlZWwgdGhhdCBjYXAgc2hvdWxkIGJlIGxlZnQgb2ZmLiBC
dXQgSSB3b3VsZCBsaWtlIHRvIGJlIGNlcnRhaW4gdGhhdA0KbmZzZF9maWxlX2FjcXVpcmUncyBs
b2dpYyB3b3JrcyB3aGVuIGhhcmQgZXJyb3JzIG9jY3VyLCBzbyBJIGxlZnQgdGhlIGNhcA0KaW4g
cGxhY2UgZm9yIG5vdy4gSSBmb3VuZCB0aGF0IHRoZSAiZmFpbGVkIHRvIG9wZW4gbmV3bHkgY3Jl
YXRlZCBmaWxlISINCndhcm5pbmcgZmlyZXMgd2hlbiBpbnNlcnRpb24gZmFpbHMuIEkgbmVlZCB0
byB3b3JrIG9uIGFkZHJlc3NpbmcgdGhhdA0KY2FzZSBzaWxlbnRseS4NCg0KQWxzbyBJIGp1c3Qg
Zm91bmQgTmVpbCdzIG5pY2Ugcmhhc2h0YWJsZSBleHBsYWluZXI6DQoNCiAgIGh0dHBzOi8vbHdu
Lm5ldC9BcnRpY2xlcy83NTEzNzQvDQoNCldoZXJlIGhlIHdyaXRlcyB0aGF0Og0KDQo+IFNvbWV0
aW1lcyB5b3UgbWlnaHQgd2FudCBhIGhhc2ggdGFibGUgdG8gcG90ZW50aWFsbHkgY29udGFpbiBt
dWx0aXBsZSBvYmplY3RzIGZvciBhbnkgZ2l2ZW4ga2V5LiBJbiB0aGF0IGNhc2UgeW91IGNhbiB1
c2UgInJobHRhYmxlcyIg4oCUIHJoYXNodGFibGVzIHdpdGggbGlzdHMgb2Ygb2JqZWN0cy4NCg0K
DQpJIGJlbGlldmUgdGhhdCBpcyB0aGUgY2FzZSBmb3IgdGhlIGZpbGVjYWNoZS4gVGhlIGhhc2gg
dmFsdWUgaXMNCmNvbXB1dGVkIGJhc2VkIG9uIHRoZSBpbm9kZSBwb2ludGVyLCBhbmQgdGhlcmVm
b3JlIHRoZXJlIGNhbiBiZSBtb3JlDQp0aGFuIG9uZSBuZnNkX2ZpbGUgb2JqZWN0IGZvciBhIHBh
cnRpY3VsYXIgaW5vZGUgKGRlcGVuZGluZyBvbiB3aG8NCmlzIG9wZW5pbmcgYW5kIGZvciB3aGF0
IGFjY2VzcykuIFNvIEkgdGhpbmsgZmlsZWNhY2hlIG5lZWRzIHRvIHVzZQ0KcmhsdGFibGUsIG5v
dCByaGFzaHRhYmxlLiBBbnkgdGhvdWdodHMgZnJvbSByaGFzaHRhYmxlIGV4cGVydHM/DQoNCg0K
LS0NCkNodWNrIExldmVyDQoNCg0KDQo=
