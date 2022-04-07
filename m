Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D76924F86BA
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:57:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346665AbiDGR7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239172AbiDGR7u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:59:50 -0400
Received: from mx0b-00273201.pphosted.com (mx0b-00273201.pphosted.com [67.231.152.164])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DF4F22EBFE
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 10:57:49 -0700 (PDT)
Received: from pps.filterd (m0108163.ppops.net [127.0.0.1])
        by mx0b-00273201.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 237FQqr0003730;
        Thu, 7 Apr 2022 10:57:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net; h=from : to : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS1017; bh=fg726NemHVFAd0FZhKYUnlMdqJWUwV21O8e+F9+YRDo=;
 b=j3Ygj7s5Z9bYDcJv2GToLAeqs29njrsi8XhBrVGJNDRSSQeRxoNE+EVMqFFMDQu33rdV
 Gj3OBF6nALrEhlEcKUbCPAEnJ5v511iSFyFMrUe4HJ0yG9vhCzp760aylFnzWuaRJ+k+
 whz2Pivfzmv4hQ1P0LZevEQCSJxbR/OeK1og28Ow7Iw7Hz4mLrRfguCNFeRbj+i7JFmQ
 A98kZhgr3/91m4S8v29fabwK945wwMHKl+kmxhysTpjzLP8ha8b/P4M5p+kArUVmSLQY
 ImvOYOStcJDTRE9SW176+wtY68Oj5SaB1Db2RJZtZGgSk2kEVhha2pdGpZVnXHi1+pQ9 Lw== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by mx0b-00273201.pphosted.com (PPS) with ESMTPS id 3fa2kw8e7s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 07 Apr 2022 10:57:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gORP/0zTcpjrh9D/eVjihkucgS2kPwyvsFJg1pY9buvmOCVqh98KqUJU55EJE4/ltPcN4Luz/Y0VrKzWX4l1LJS0qGrAy9/KCw0g/T4JvUuKFaq1+/T9ba1avM3xIgqesjpYDubH9SgBCV9O962FQIZVHNaOGFHjd6kiKsERwsjAKVtgj4xs/eHVvbnU/aqdNZUWfTdgqgrKFvy1YiQde8ZgEYxOZIZF6w0d5OF+rwfZcohE6nghY3EzPS17eANAz0qtozPjEDLhsfGSrnFYV7V+gQ1zHUFC6JTzF1yMeoDbXoTsw1u3wZkhIOFEg4/COXX9pQO2SC/lS0U7ydNb/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fg726NemHVFAd0FZhKYUnlMdqJWUwV21O8e+F9+YRDo=;
 b=LfItGQT2GNDWEy3lRt2o6s3CZ6B0cDk9HfDKo6BJ9B323oir1MkzeOWtpyU5RP4GKoCDHTQeawbL4RTl6Qk9H04m8slFefFxO535yissOCR0XiFu09hGGdE2imZH+QoAhimWCObPOWCb+hdpFyU1/mweCqWdc68jOqf7XOskXGlwm1+K9Wb9fYLVWqJ2HN4UviF+RYU7jiGSjsFqKsE1Zx++at7c6PxRBa85WYYJrI5VK/BTvePESUyy4LD/GIbENf5wDERTHC4xuHV8vYpikaqKzmvhKBQ1s5upmmVad7BAH7H2df1wFom4b4n5Wq2VfDJXKXvqRE+IYLGeC7T8Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=juniper.net; dmarc=pass action=none header.from=juniper.net;
 dkim=pass header.d=juniper.net; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=juniper.net;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fg726NemHVFAd0FZhKYUnlMdqJWUwV21O8e+F9+YRDo=;
 b=S90nDjdNn5cKh0VK6ngVB2nVGMqlfrzMbj3p8er/jtpvLsiLn7JJWKmVMXM9tfBhBoHwRLuRr88GPLXcjIheNAkFaVcyR2kMtsAfmMljPr9V5TMlCkoNjnMoygAHEz5md0eqebOrvOt3vXjjOm5u2Kl2NYRI08sVE1hJujUdmg8=
Received: from BY3PR05MB8002.namprd05.prod.outlook.com (2603:10b6:a03:364::8)
 by DM5PR05MB3642.namprd05.prod.outlook.com (2603:10b6:4:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.19; Thu, 7 Apr
 2022 17:57:36 +0000
Received: from BY3PR05MB8002.namprd05.prod.outlook.com
 ([fe80::61f9:1a95:d910:a835]) by BY3PR05MB8002.namprd05.prod.outlook.com
 ([fe80::61f9:1a95:d910:a835%6]) with mapi id 15.20.5164.008; Thu, 7 Apr 2022
 17:57:36 +0000
From:   Erin MacNeil <emacneil@juniper.net>
To:     "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: =?Windows-1252?Q?Re:_TCP_stack_gets_into_state_of_continually_advertising?=
 =?Windows-1252?Q?_=93silly_window=94_size_of_1?=
Thread-Topic: =?Windows-1252?Q?TCP_stack_gets_into_state_of_continually_advertising_=93?=
 =?Windows-1252?Q?silly_window=94_size_of_1?=
Thread-Index: AQHYSqeeEFCy0rZU+0moPwJjhoI6IQ==
Date:   Thu, 7 Apr 2022 17:57:36 +0000
Message-ID: <BY3PR05MB8002A408749086AA839466C2D0E69@BY3PR05MB8002.namprd05.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Enabled=True;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SiteId=bea78b3c-4cdb-4130-854a-1d193232e5f4;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_SetDate=2022-04-07T17:57:35.993Z;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Name=Juniper
 Business Use
 Only;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_ContentBits=0;MSIP_Label_0633b888-ae0d-4341-a75f-06e04137d755_Method=Standard;
suggested_attachment_session_id: a124d42a-7c91-1218-7f4c-ff1f9246dd86
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 828f1d04-44e8-411e-5109-08da18c0199b
x-ms-traffictypediagnostic: DM5PR05MB3642:EE_
x-ms-exchange-atpmessageproperties: SA|SL
x-microsoft-antispam-prvs: <DM5PR05MB3642F4908AA9765C2629870CD0E69@DM5PR05MB3642.namprd05.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cZaF64TWuQi9qKIOuTzPhiA4GaAAZEUcJTV3lTRRRRFCNijvtZMDy301nlD4o+ToygekyCFLM0bKgisM4dYdQjll+ugE1WZXOkFwO47btR4LDAXUMEbmqjVpT/lb7BvAQSm/sa9a9r+115MWFHRTccFr3V1Jbnx51gUFGUOjP8QyvcF+ZZDFMneIwXNrfnEhEKVBdVYKxXEK6OWzDbuzLx/5GY63m8ooPb1CuAW1JIv5AI1XVXZQQOd53nFSAixY0fncNoYghC6bQdJdxH73MShUrEOMzVtb50XM90Mg5x3iLqCCs51ZW2zSkrgDVS6WH4To9jtfHlFaZi+sEZTNeRDlCvIq4HataymG4BcA6GhT1PrDDXO3/pMEHfu/rAo+9BK29LAZgeIqyGWdDkF+qD+pGoVBHDaXBRyVynlQrQEhOM49d3MmTNkgZbBeFJrgt0CkSvxMVbrQXCOZS1FRzpUFkDgTf0w9LC8lhpLvDGfexivpLTmTRA7EEYjGhbsqe21kLGuyd0LDEfxy2IAuT3gt/Otbo78L5ZsQ2masdsQdHpqe+gK0nVCwHRk2O9pKT+7h6o89wCP4hOeGvk7XVuU6eV2ETZWjUAaVJIHEomvCpSNU4LY9UNU0X1uwP6bvuOl9MbuOAKhJhAohz9DW+ypfRT+uthvzKhmtqtHr2FIZ4I4XYuY4FLmwQbjXzPiysiyo1w8zSx/CU80miZ1RLQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY3PR05MB8002.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(122000001)(38100700002)(26005)(186003)(38070700005)(5660300002)(8936002)(52536014)(66946007)(66556008)(64756008)(9686003)(33656002)(76116006)(55016003)(2906002)(508600001)(66476007)(6506007)(86362001)(316002)(7696005)(71200400001)(91956017)(66446008)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?j/k3G9H88P39hOoQdEu9eCfvO2/BywDWBt1je1wMcHtu7dld3eNRBOmh?=
 =?Windows-1252?Q?+QleEoPvvm60PacGMQgio+g6Y2hEFZPEBg/MpFti30IcHgcFzFrw/mM1?=
 =?Windows-1252?Q?LGlmf6mQpOQWx/+u8lSYhDkWlrTFw/CdwY3Rk9y017UOCOFlvsFAVgU7?=
 =?Windows-1252?Q?mWwdXTRxncdNCoEXNgxAlBWjWOo+j1XTEVS0omPRGd3CG27t/TmGzUfL?=
 =?Windows-1252?Q?eCle1f9MUms20kowHnfjD9mvYskI9H/zmIyILfO3qgzs9VKtjd0GEzlv?=
 =?Windows-1252?Q?Ld7uiTba051lUBhQhia7K11FlrGi9PO4VK6DyDudAPZ2i5Lmr1rSSUsZ?=
 =?Windows-1252?Q?OaAVQKREJJY3Gy422MfK5q3v/4fvVW0fMlIgVRYzyn32HPwFnbVk2JMK?=
 =?Windows-1252?Q?TISGZWN/6K8hBLqhQxVQhimJFe1vozmQuLb9Nfu/BMLLIYxCSi7uX/E9?=
 =?Windows-1252?Q?kNrVEidtdd115ScVuNuvoSco+aPAoZRh8mIq7H0/8H5SmT6phls+RFqp?=
 =?Windows-1252?Q?lO0xjeDfk3m/qQl6b7bybjTIpF3vIM2PFXdNKyobRv8FqOgn9Bgmv4QP?=
 =?Windows-1252?Q?lqX1X7MDhgjW28+qx/ITuXp2h89fS5CT69PiutcqG3Ensrs2EysyNu7O?=
 =?Windows-1252?Q?EZbWh1Of7pyNAHqEDaNIxpsekQouAG6OEyEY3eiq2fKNUC88TrhOkLVu?=
 =?Windows-1252?Q?p1CDDD+9tp87gmh5AiPic6zXtcMD5ou6A6AlJ+rHm03+k8EofmfYTc9U?=
 =?Windows-1252?Q?T1FCaGCWntnTOinCYgI21yAdMoi1UqPdC+eU7yJGZWB7sO2iNXZhGIOH?=
 =?Windows-1252?Q?N1r4bUWBegyvSF9PNkZDtM22Yz6nyLyNkTevmIQHtKJrr3T0qKdYV+2N?=
 =?Windows-1252?Q?SHlR0F8IG375AZHJ+uNevhlvS0aTH9nRoDKfb795utqz2ad7J+xJOWkJ?=
 =?Windows-1252?Q?pGhNj7CH55fjXH95UNwNFdkZOjmnQXFCzYDBlxvBRZH0MUS3CkyPROBM?=
 =?Windows-1252?Q?1THkykBQh1mhl1wcSb50iK2Vhxb+3p0TgR3BnIF7uRlJFt5+yop/C6zm?=
 =?Windows-1252?Q?9tTD/s7CbWwxiOPtwlA0H6Sts8d6+L8Z4kHVqkzW19wHeG5t8i35VIT6?=
 =?Windows-1252?Q?O8MZGnK+UT2SujXz8JlShWUHMcDpfP4pQsz2Tf4LnrAbmr+NMyBn4sIa?=
 =?Windows-1252?Q?jnM41kmdbCbBK8nUNGFFfbo2DaFUW7/hXwTzpmkyiXNy6GVcA6b82EZB?=
 =?Windows-1252?Q?99gCbZG0c8W52DzqpwPLFM5VSmTb5CYLasvK4cZoKjY/OZLOQgFW6Q23?=
 =?Windows-1252?Q?dxYWIarLir9C5vM9r6gFd0llPSbVDVrx16AQx6Hxl7Mr3N0hsC76JQwu?=
 =?Windows-1252?Q?7CPVCTKHjYohpcA1bkKebPXGPSahV6ogQpAVseMvKagDXRxeioxcolJe?=
 =?Windows-1252?Q?DUMSdZaO6qeDuGp+4ilS+djX/ElDPTmP54JubzHoTOsHTW2SdIVYYA2b?=
 =?Windows-1252?Q?b2W1/+AMjDOtUd1zMNZOXBM9V4CZ0eRRy+2dUThzav5TAV5/P3XG96Lr?=
 =?Windows-1252?Q?ILGr6/YHBvXLWeRGtg08LSQDD9xu4PPPKNKFULokDgxkeOFThijI+NCU?=
 =?Windows-1252?Q?h70d8fbuPgoXUSwFHqKzEhfRaGhgmzEc0WZ205vFn4Y8xs+u6IYkN2FE?=
 =?Windows-1252?Q?T0at85cWG/PdEsKuRV0pbxaQE7ZiY5QpRu4rEUhD2KmiFfsIAnfBtOp+?=
 =?Windows-1252?Q?2LHLaQfIoNMcI8zNl2Cxktg/jrYMtTbK/cQMays17q6AH+jXV437C3Nt?=
 =?Windows-1252?Q?mO3GSPI0m9+shLW0gdGSQJqCRrvIkBD5JvE5rh4b0iqW0yt8jpdpN6Es?=
 =?Windows-1252?Q?t1qEbMV8Spj7qg=3D=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: juniper.net
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY3PR05MB8002.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 828f1d04-44e8-411e-5109-08da18c0199b
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 17:57:36.7493
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: bea78b3c-4cdb-4130-854a-1d193232e5f4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9eC6vKWMrvH0jk3OsAEjIodiISiT7lK0cznJO7k+dxFahmTi2axt3cJdHqC+K6uOhsoSGMS7bjxM2JTptMyddg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR05MB3642
X-Proofpoint-ORIG-GUID: WcsThpgB5fMnOkIIPVCMl1417K6BYzoT
X-Proofpoint-GUID: WcsThpgB5fMnOkIIPVCMl1417K6BYzoT
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-04-07_03,2022-04-07_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_spam_notspam policy=outbound_spam score=0 impostorscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 phishscore=0
 priorityscore=1501 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2202240000 definitions=main-2204070090
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In-Reply-To: <BY3PR05MB80023CD8700DA1B1F203A975D0E79@BY3PR05MB8002.namprd05=
.prod.outlook.com>

>On 4/6/22 10:40, Eric Dumazet wrote:
>>On 4/6/22 07:19, Erin MacNeil wrote:
>> This issue has been observed with the  4.8.28 kernel, I am wondering if =
it may be a known issue with an available fix?
>>
...

>> At frame 4671, some 63 seconds after the connection has been established=
, device A advertises a window size of 1, and the connection never recovers=
 from this; a window size of 1 is continually advertised. The issue seems t=
o be triggered by device B sending a TCP window probe conveying a single by=
te of data (the next byte in its send window) in frame 4668; when this is A=
CKed by device A, device A also re-advertises its receive window as 9060. T=
he next packet from device B, frame 4670, conveys 9060 bytes of data, the f=
irst byte of which is the same byte that it sent in frame 4668 which device=
 A has already ACKed, but which device B may not yet have seen.
>>
>> On device A, the TCP socket was configured with setsockopt() SO_RCVBUF &=
 SO_SNDBUF values of 16k.
...

>Presumably 16k buffers while MTU is 9000 is not correct.
>
>Kernel has some logic to ensure a minimal value, based on standard MTU
>sizes.
>
>
>Have you tried not using setsockopt() SO_RCVBUF & SO_SNDBUF ?

Yes, a temporary workaround for the issue is to increase the value of SO_SN=
DBUF which reduces the likelihood of device A=92s receive window dropping t=
o 0, and hence device B sending problematic TCP window probes.

Juniper Business Use Only
