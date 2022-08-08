Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890AE58C454
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 09:44:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbiHHHn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 03:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiHHHnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 03:43:55 -0400
Received: from mx0b-00128a01.pphosted.com (mx0b-00128a01.pphosted.com [148.163.139.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B24A1A2;
        Mon,  8 Aug 2022 00:43:53 -0700 (PDT)
Received: from pps.filterd (m0167091.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 27873J2D006343;
        Mon, 8 Aug 2022 03:43:28 -0400
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by mx0b-00128a01.pphosted.com (PPS) with ESMTPS id 3hsj2bu6s2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 08 Aug 2022 03:43:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jI/ecCXbDY6LWwH9tmgyzHUFeKIV9osAKYIqc8p/O3jPj4nB+ET16B5npyqaC3S8DHcpTKuOJuKiJxOokf+2bkpzY9qy/T/0OdlrbMwyw0f2Fh3I6/qEFoCqh1aMX3DGxNw1XJF2qJCRqO87wUoAZMhOF99Q9SSVNyXq/3MqD3P5NfgqlAcaKqc92Blqv0VFz+gORXajZ6/dmJzaV7TBxaldCbplOXTTt3LkGvVs6gUTqXwbFO5EspjTRZmhkONaw7KlP4PK7j4EKnwTAN8kbxzLxDesLtD1Zaslw+sETmwmr/0Qgc46rRnK6rkOtxEKM6v7H1mLQ8xIEgF4XoU2wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g2KMJiCFQ0EDMGtKFW/N7V+72nB3jEvr6E2aC2yG5b8=;
 b=I8E1laWEFevzFo/tuY95SU68ys90DtJ2JKDQYq5NcsilbLTM++YWx/2Z03DF3a9uyWGpkSzinxdoe9rsHx9447ObCOdn40at7SdI5dOTPoroPTUNLUSRoretkWs1EDeNC91ZdRVFbC6DnsfYwkPWkq4Pt7OBZeDz/A/6WisnBOh3dppF3u1IdaUFFaG/3P8rywcAoy3mpY/q8Ocux2fOnqa8A4OMuJq9QMeJYvCNKNip8GSmLZ1Xh+PwWbPBa9Il3pvgKRvZ1/GOax2vRWlHmLG/2elIHZVa4x8Iz/GbndHH9ttce7Y2oTx2t9z5baVavyxzRnoF7XLgs9CrYtM4dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g2KMJiCFQ0EDMGtKFW/N7V+72nB3jEvr6E2aC2yG5b8=;
 b=Un7YMjDAKa9Gzmhz5wdfkrJW6n2gdFBfOYf2fTaGzF71YfLRf/OR/SwFSp+kO1/YiM0J7Pg7GQShdB4AOc2Uay0eDSCKf+eiGjEU6w7+SHpAxAqjtD8OUJ9YuBWBAa8ChKcBkKos1zwOyYLlsbMAk5JMVuY8MxMYc/0xVq/dsM0=
Received: from SJ0PR03MB6253.namprd03.prod.outlook.com (2603:10b6:a03:3b8::19)
 by PH0PR03MB6654.namprd03.prod.outlook.com (2603:10b6:510:b5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Mon, 8 Aug
 2022 07:43:26 +0000
Received: from SJ0PR03MB6253.namprd03.prod.outlook.com
 ([fe80::6175:a08d:5a98:10ed]) by SJ0PR03MB6253.namprd03.prod.outlook.com
 ([fe80::6175:a08d:5a98:10ed%3]) with mapi id 15.20.5504.020; Mon, 8 Aug 2022
 07:43:26 +0000
From:   "Hennerich, Michael" <Michael.Hennerich@analog.com>
To:     Lin Ma <linma@zju.edu.cn>,
        "alex.aring@gmail.com" <alex.aring@gmail.com>,
        "stefan@datenfreihafen.org" <stefan@datenfreihafen.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-wpan@vger.kernel.org" <linux-wpan@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v0] ieee802154/adf7242: defer destroy_workqueue call
Thread-Topic: [PATCH v0] ieee802154/adf7242: defer destroy_workqueue call
Thread-Index: AQHYqtjtehnCbQil0kmsaItephsbl62kn0IA
Date:   Mon, 8 Aug 2022 07:43:26 +0000
Message-ID: <SJ0PR03MB6253908F6D8D881062B780428E639@SJ0PR03MB6253.namprd03.prod.outlook.com>
References: <20220808034224.12642-1-linma@zju.edu.cn>
In-Reply-To: <20220808034224.12642-1-linma@zju.edu.cn>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: =?us-ascii?Q?PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNcbWhlbm5lcmlc?=
 =?us-ascii?Q?YXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRi?=
 =?us-ascii?Q?YTI5ZTM1Ylxtc2dzXG1zZy1jN2Q5ZjY5NC0xNmVkLTExZWQtYjZiMC1iY2Yx?=
 =?us-ascii?Q?NzFjNDc2MTlcYW1lLXRlc3RcYzdkOWY2OTYtMTZlZC0xMWVkLWI2YjAtYmNm?=
 =?us-ascii?Q?MTcxYzQ3NjE5Ym9keS50eHQiIHN6PSIyNDAxIiB0PSIxMzMwNDQxODIwNDQ1?=
 =?us-ascii?Q?NTU0MzIiIGg9ImthTVdmbUhZdTlYL0ZjbCsxcjZJNzlBUjN5ND0iIGlkPSIi?=
 =?us-ascii?Q?IGJsPSIwIiBibz0iMSIgY2k9ImNBQUFBRVJIVTFSU1JVRk5DZ1VBQUVvQ0FB?=
 =?us-ascii?Q?Q291REtLK3FyWUFlNDZ2Z01qNGxucDdqcStBeVBpV2VrREFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFIQUFBQURhQVFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFFQUFRQUJBQUFBWDVsMkt3QUFBQUFBQUFBQUFBQUFBSjRBQUFCaEFHUUFh?=
 =?us-ascii?Q?UUJmQUhNQVpRQmpBSFVBY2dCbEFGOEFjQUJ5QUc4QWFnQmxBR01BZEFCekFG?=
 =?us-ascii?Q?OEFaZ0JoQUd3QWN3QmxBRjhBWmdCdkFITUFhUUIwQUdrQWRnQmxBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUVBQUFBQUFBQUFBZ0FBQUFBQW5nQUFBR0VBWkFCcEFGOEFjd0JsQUdNQWRR?=
 =?us-ascii?Q?QnlBR1VBWHdCd0FISUFid0JxQUdVQVl3QjBBSE1BWHdCMEFHa0FaUUJ5QURF?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFRQUFBQUFBQUFBQ0FB?=
 =?us-ascii?Q?QUFBQUNlQUFBQVlRQmtBR2tBWHdCekFHVUFZd0IxQUhJQVpRQmZBSEFBY2dC?=
 =?us-ascii?Q?dkFHb0FaUUJqQUhRQWN3QmZBSFFBYVFCbEFISUFNZ0FBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFBQUFB?=
 =?us-ascii?Q?QUFBQUFBQUFBQUFBQUFBQUFCQUFBQUFBQUFBQUlBQUFBQUFBPT0iLz48L21l?=
 =?us-ascii?Q?dGE+?=
x-dg-rorf: true
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c3f7277b-ed09-44fd-ef5e-08da7911adf8
x-ms-traffictypediagnostic: PH0PR03MB6654:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KooCpqi14QPLaQIbIYDN1fsdvdkbpir27E05IjnqtT25netEqvufRRTRm1MQClKAD5NL4Bm1H9ZDjMMEvSjVZhCykXvkplV+Qooh5dbWUggpnbPuPqNTLlHN4q28Tmu2hxqSZ2uEnBZ0U3YbNC3KL5biA+iZqvY/c+nZ999ccc2bq5FqSXlTDU+aOCmredKBTZkJTpHKdSJyT0mO/W9lqzEo1Zy+n7L76jzoe/3w4haprzDtloEiM/u5y39QWzIbY4Z3/Ih9VUC1Ev6HrrOTNpUb+zvZD+AR5cKGLzyzGogIMI0U5Gz2F71R4hVe6eaC4WEFxQF9usVeAUAVf3kDn0QUbZqsyyCJWPAzdzg7/hhwA7yokAV7U3ynJ4i5ZCQg0IvjcYcSLjPhrpgjIAGBtuChj9urRcBXsG5ypRzh6oVE3ZqdiBwtVCSe+bMTX86dz1HsqhM4ERRW1HMFzZ7tLCeNL1W/71Ix4tOfAgDpNT5crBQPDMdFVi2y2H7d2df32Q2m401tSk2B4lw8ZH9iV4bGqAIXkzMgiO1j+X9KWOii3xHWYA+dfj8zNzFC0H1/lbDV1uzr1kveGYyWr+xM4plDI9+tWXOM13yhx9Z2SC8OeYTE73hB2qZYg+x2Yq72HWHd8SfGwi0qYY54iqk1ReAajj8ioIZQtDx7ZEg4IcSp0y9mMYTDU0sCXveshOnbAqM637zF0IwNIXbYKrVG0td3QPy3eTalRq01Q5mQAKoKINwKtfdlRy7kJ6Pk1/MgOPZyshdjTy10iGS5+KYnlXlXZ5LIGVT/MxWwTFkYyyA9LCX73Yb7u6fjltRQ6uv1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6253.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(376002)(366004)(136003)(396003)(346002)(122000001)(2906002)(478600001)(9686003)(26005)(8676002)(33656002)(186003)(83380400001)(41300700001)(7696005)(6506007)(53546011)(55016003)(66946007)(66556008)(66476007)(66446008)(76116006)(38070700005)(110136005)(316002)(71200400001)(86362001)(7416002)(5660300002)(52536014)(64756008)(921005)(8936002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3UIs7LiUSgsRJt19hBko5Z/FQC1FGvuqNh5EIc7G3CP3qgkQJq4gXfj+9qdG?=
 =?us-ascii?Q?cYB/ilVNJrp21vJCjhdogyI2VDzQX0gyUOVOlsLha6d+m+ysAIe0q9+IVnAR?=
 =?us-ascii?Q?jbSR33Yp0RVUqeSXe1Dbsot8mu0Ayb+T2OYIUaVDhVhpgWLC/1AjUaHeA4xP?=
 =?us-ascii?Q?xyXSeu/wpwQP4xDrPtjbNuPz9Zxehs5AZjWLA8XiZL5+VNLhi/pfh3OQObdB?=
 =?us-ascii?Q?ubp86mT+AB9+D/gdKtTavxpiakzv/RK5L9w58hRdnCtizkBSg2lmbVz9VHaj?=
 =?us-ascii?Q?TfQyk5rCxkCw1HsUd8cdwrA6kpE8w9x2Y9uR5b5QrG+GquhNVu7XccbLl2ql?=
 =?us-ascii?Q?Ybrh6+MYK1x0L8FxaBCztIi/c5e3VjbxDqpd/WlW8CpnRq+Z2oP+zFd/w5fs?=
 =?us-ascii?Q?0WMF0c9BsNfr7CyLrZq7VeU3UGpHMmst8VuNzj7HxNrnvVE66DTj0XXyB/L2?=
 =?us-ascii?Q?jlwm1yh+wr+p5V7Pcq4q3gnv50gED+0CaQEW8Yjh4xuRmFH86YL997VT2O3w?=
 =?us-ascii?Q?bqMF+phtPJQaUEHYM2kESN3S1MBvQtpKs2fvwOGytmbAglb00OqRnWW2bV2l?=
 =?us-ascii?Q?z70vx5wI0mYBK6F+3YTsoe4FWeX7Yp/+P2EdC8SRl9qElu2WBIn33LuoJPMz?=
 =?us-ascii?Q?nMCS4bSFSqa7pyj58MJ33UB2399l153zt4Q4cU3IKI0TUvrZu3TglqPgugSX?=
 =?us-ascii?Q?JIoMmxU98ImN8awivSBIVI7lMmrTUHgDRkvgqZDUAV+PIT/umA/zNw+xEdqO?=
 =?us-ascii?Q?zSNUSjRNixFP7lmLxMGWnQ79LrdBim8kBj50Kopa7Cwu/v3rWo20fBTRkHJY?=
 =?us-ascii?Q?c9h3zMYvyzyjC+OahpH6wiMlwa21F5GEvngWnUZ5ZZ0DPD6jRxpUpPzATxhS?=
 =?us-ascii?Q?g7ZTHelZ3hP8+/Pukxkiu0ataImQOB0dD8CC7xf3ikRP1Bcgs7DPxRQo93qc?=
 =?us-ascii?Q?cDlgjZD3G0euPxnahP8g1n/IZUVFSh12o09I7VkSe3b8oBrJIcqzN7HKL/Lm?=
 =?us-ascii?Q?vTstZyvHOqdNIvoej1Wqj7jOoyK9IAreKUFSvaGXhGUPmU/4VsvjHLex3R/Q?=
 =?us-ascii?Q?AyeJ2r/KKrXI6x5ooc30EqAvonHAcXWGQGNuAa3o9Ik9rHWLnSDcjUTv9oUy?=
 =?us-ascii?Q?VgX2NGP0jV4oLowYCOabVCGHw4+vzECHL5hvANT8bXFZHtaiqGSCzvRgsVzH?=
 =?us-ascii?Q?8hP0zD/xRODbWZcgLIasTQRx426dGsugXCBtY+v7gr98R7uk5tug6SMp5p7k?=
 =?us-ascii?Q?6aCEUvUOav3Iadk8uaXlG6fyUjn68lVJwcnJAZO/Y9NYvpc8nXJ9pcB/voSU?=
 =?us-ascii?Q?X4xo4VmC92cddbrIByZVh6uy3ZXmkLcTDZHj16AACeZSUVjYxqqcGKqk/Il1?=
 =?us-ascii?Q?/n3XGN8eJZe6D7cr74RV2Et+2UqUt77pA0pYR/hdQuFWCy+sKu6sq65Bc6ZE?=
 =?us-ascii?Q?1iXPrmygTct9+Z8pRwN7Bz/Qq3V2T0LUxcSJSVq9F7XjS5kayR6ZQmf8FInH?=
 =?us-ascii?Q?+X/bQazPC9DBk2FkKlo4prdBPLOrymtZ1maTcxVfLVOtfYO3O3Eze+02y14U?=
 =?us-ascii?Q?rCW68Hp/xz/PBWJ0/Z5zZnVQb83RhB0hzmAATMSnJxLNzoqIBRlf6s/l0Olp?=
 =?us-ascii?Q?nw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6253.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c3f7277b-ed09-44fd-ef5e-08da7911adf8
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Aug 2022 07:43:26.6054
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ln0lPdU7NTxKxZCoM9JuuDrk0arPfYhzlc3rj1pMNDG6gNbUhSEGspxkbTAmJ/hk0bSyzdHnKDLPpc7IObtlIF5G3Yg4ex6cqqDaWDU1GM8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB6654
X-Proofpoint-ORIG-GUID: xrUy7D62B6QPsWjjKMxy1ZeR_LHEJxQN
X-Proofpoint-GUID: xrUy7D62B6QPsWjjKMxy1ZeR_LHEJxQN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-08_05,2022-08-05_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 spamscore=0
 mlxscore=0 adultscore=0 priorityscore=1501 clxscore=1011 malwarescore=0
 lowpriorityscore=0 impostorscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2206140000 definitions=main-2208080039
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Lin Ma <linma@zju.edu.cn>
> Sent: Montag, 8. August 2022 05:42
> To: Hennerich, Michael <Michael.Hennerich@analog.com>;
> alex.aring@gmail.com; stefan@datenfreihafen.org; davem@davemloft.net;
> edumazet@google.com; kuba@kernel.org; pabeni@redhat.com; linux-
> wpan@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Cc: Lin Ma <linma@zju.edu.cn>
> Subject: [PATCH v0] ieee802154/adf7242: defer destroy_workqueue call
>=20
>=20
> There is a possible race condition (use-after-free) like below
>=20
>   (FREE)                     |  (USE)
>   adf7242_remove             |  adf7242_channel
>    cancel_delayed_work_sync  |
>     destroy_workqueue (1)    |   adf7242_cmd_rx
>                              |    mod_delayed_work (2)
>                              |
>=20
> The root cause for this race is that the upper layer (ieee802154) is unaw=
are of
> this detaching event and the function adf7242_channel can be called witho=
ut
> any checks.
>=20
> To fix this, we can add a flag write at the beginning of adf7242_remove a=
nd
> add flag check in adf7242_channel. Or we can just defer the destructive
> operation like other commit 3e0588c291d6 ("hamradio: defer
> ax25 kfree after unregister_netdev") which let the
> ieee802154_unregister_hw() to handle the synchronization. This patch take=
s
> the second option.
>=20
> Fixes: 58e9683d1475 ("net: ieee802154: adf7242: Fix OCL calibration
> runs")
> Signed-off-by: Lin Ma <linma@zju.edu.cn>

Acked-by: Michael Hennerich <michael.hennerich@analog.com>

> ---
>  drivers/net/ieee802154/adf7242.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/ieee802154/adf7242.c
> b/drivers/net/ieee802154/adf7242.c
> index 6afdf1622944..efcc45aef508 100644
> --- a/drivers/net/ieee802154/adf7242.c
> +++ b/drivers/net/ieee802154/adf7242.c
> @@ -1310,10 +1310,11 @@ static void adf7242_remove(struct spi_device
> *spi)
>=20
>  	debugfs_remove_recursive(lp->debugfs_root);
>=20
> +	ieee802154_unregister_hw(lp->hw);
> +
>  	cancel_delayed_work_sync(&lp->work);
>  	destroy_workqueue(lp->wqueue);
> -
> -	ieee802154_unregister_hw(lp->hw);
> +
>  	mutex_destroy(&lp->bmux);
>  	ieee802154_free_hw(lp->hw);
>  }
> --
> 2.36.1

