Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C76786B2F36
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 22:04:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjCIVEf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 16:04:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbjCIVEd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 16:04:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85ED4F6C6B;
        Thu,  9 Mar 2023 13:04:31 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 329Kx4tG000888;
        Thu, 9 Mar 2023 21:04:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ovuwomaxN2SiiB2rQhTwATJCXWnstpWZFMj2/1PQI2s=;
 b=Wq79K5Kh21GcnpFUBEwhBiHqme3J3aH7DSBJSoonIuL/uqQbCGTRCRaYA3WXVm9K6Eve
 LPBtM/mbTL4gWYoL4mVf1T8oXewkyntjoOvWOp5Q2dYo90/HLdsK4ZjrgrmtP2c2hnQH
 6dxzGYprzSHurlI0qZiA2IGWAWJsAtTY9leFuArOQ0U3qKBA5ROXnNopfIpFZqGPp15w
 9N/nhBtEU+5HIjjkmPTs1MasTmaaom5dEEObYEAkkwFxqm6njd0gEa5EHQNAC+kwU8Sk
 2iA8j/yxke2T6yufJ9ggchL0L7zQNHKi6FQ0PCGlO9/uyOHytvfouyae7smC1VIQaFFj NQ== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4168utd2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 21:04:13 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 329JAQ6f015450;
        Thu, 9 Mar 2023 21:04:12 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p6fepb59k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 09 Mar 2023 21:04:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=babDzItJb7PbmVGMLUiXgpmXPgUekbZqM8qt0uPwPkPKREzYKzF7/9l28jvcoLG66e1Ztr5nO+2f6tFJSozM9safm9LU3OWQNgkf+SqrnKRMv2Pel+T90hrljgHQSvC/UpCdcjzvB0LKkKwxV5Dm13NP0nArDd6dURwwF1IXRDyfc+SzyWpi64sQKWrrbvrHlGwXkZKtPEghIrjPhsiZYjRJfeuvKfLS+hS3keREPFA0ft37PDwb/TiaXpgoDMhNAJDhpENFiVxprC0ndnau+5vteoW2AyfmwbEPqkeJ+omKCQ+NfZqw8szQdi08l8y9dPCcmQq4hihduhXBCwsseQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ovuwomaxN2SiiB2rQhTwATJCXWnstpWZFMj2/1PQI2s=;
 b=O+qbYdb8cfncsutYD+znqhibL7+wxzrU3S+7E85cRmA57m8crLmIAJZZfzsCzajeZoDSzwI2CIWjYjoYUzjjDcnKhLLYamXISPkFv19fk18jTBNbd4tmQrULNy0b2LsEBN4PmDaTWsVs/HZpLQhK1DaTn6C1a5G46zal/sH4+zHBz1SJO33rTRn/nCb17P2fkok6WA29I6ng+9WeLPlgiRzBhgCjyxzUd7nxdV4yJtVsp8ZkdwbeB467LDx3azkQyd7cm9E486gD2KMxT1hlMaHCbpm9tGbdoEJa09ggAG9JQPki8+/f9ptVKICCSClsKHNlw3sGBtODRcaTpjrC8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ovuwomaxN2SiiB2rQhTwATJCXWnstpWZFMj2/1PQI2s=;
 b=JvCCRWl8KHQdj+l+VXIfWqwjxItrHcvnV9hCcsiS5154nZTso4NuGXuNJmnjhAQgH/18o9e0/qQBFmoRNr9IMt3h0yX8i4D40S40A/OwAGy6My4a2hyDAvMce0Q2Q/M+0cdLhaCdYsM8sEDvHu0+gvWQMHZdbveMw82dTeGFr9s=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by IA1PR10MB6900.namprd10.prod.outlook.com (2603:10b6:208:420::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Thu, 9 Mar
 2023 21:04:09 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6178.019; Thu, 9 Mar 2023
 21:04:09 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Christian Brauner <brauner@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
Subject: Re: [PATCH 0/5] Process connector bug fixes & enhancements
Thread-Topic: [PATCH 0/5] Process connector bug fixes & enhancements
Thread-Index: AQHZUjYHc9ErLLj6ckaePlWNDP+fU67yrjuAgABCQTE=
Date:   Thu, 9 Mar 2023 21:04:09 +0000
Message-ID: <BY5PR10MB41290FD4B53418C2BAEF9B12C4B59@BY5PR10MB4129.namprd10.prod.outlook.com>
References: <20230309031953.2350213-1-anjali.k.kulkarni@oracle.com>
 <20230309170519.rufxekqqybbhvbis@wittgenstein>
In-Reply-To: <20230309170519.rufxekqqybbhvbis@wittgenstein>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|IA1PR10MB6900:EE_
x-ms-office365-filtering-correlation-id: cac48cf9-d021-4c99-5aee-08db20e1d399
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sWarVuMy6Qt5OGLY/r807xC9qFkGxcEaXOJ0WwxM760+NZMjcbWe/Rjl1uW8KY55TfyTS7BEYsQ8Y1r27zoYR1yRuDIIpDl+6GLMPIZpeHjKVlHPtKGX0+v9rbTDTdOTBWBLH1Ev7QA75XBPfqYz7UICFDH3migOF8jDoaNQKdurPlsqOr8cJTHrDf11fWgDRY2op1ioZbMfhe58AQcj4lIoTU+3OOpWxMhN31cfTpJnYnWHuSw5R21XQqmWzc4sthK0Q8/niVTYjsbjT3ckJdHpul//Nsn96NsetlfRSWEB927EuIyzrCjgidXB/VSE/0bA4Np+Z9EUZiCgiMCucDj8i0pfYfjObVEOk0MRvJl1fUTsy7mNFXZ18eqWCmYVUGX/bSFcOxeQzHoHhJTAg4CEMIIhlmGPcE+F4oYqDP26gLAptr6zYCQFhYrAhYOdNOvrLGeqVnSuGyq6FIWEQm0/edCJUPdmtfQtG1fXm6G9M3YB2ckf99DhRksWiJPpYdZ9g7AZ4UVwt3NFQA1VmLoo8HWIEqCCUxe6WZ8Suz1VI4cdsiRsGS3pZGotYnjg+Lh8tBjzy2BbjLTiYk9xdx5fJV4ZsOmppIP4874q5wExdlnlIvShl4f2tshPVst3MSktTdoh17AW79GQlyzRj1fWmx7Njmzrz0CtXkywf0M55mzWArRFFxx+QAt62kKhP36odPjDyORcQufHaTWlEJVV0zI59iP3fSNXSYg29h4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199018)(107886003)(6506007)(53546011)(186003)(9686003)(478600001)(38070700005)(7696005)(71200400001)(38100700002)(54906003)(86362001)(83380400001)(8936002)(52536014)(122000001)(55016003)(4326008)(64756008)(33656002)(6916009)(316002)(2906002)(76116006)(66446008)(41300700001)(66476007)(5660300002)(7416002)(8676002)(66556008)(66946007)(586874003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?Windows-1252?Q?WyYavZAmz/BprANHJBrZwgqbwzLsFspB+K3BnsbOMZXDQvJOWRv8jGS+?=
 =?Windows-1252?Q?0fcNNkWFnZJlyjol4luHRVDKwS+rja7OiCy1KiYY0OFMbMqwhm0Ll8e8?=
 =?Windows-1252?Q?rTos2Rjn3eXbGZc8rW3kZW5f3MuD2wBzEil9VEQkXmL+XEXUDseX2okO?=
 =?Windows-1252?Q?MLqoUvMdS5F6/zX1hCzfdwMtoWi98QkOJ7TAL+fZWZbiQ4O3xqQo7IP4?=
 =?Windows-1252?Q?NQ2ziJoZ/naznO68Ki1R4K+w+4eucVDlJJPMbprLui7smkvfPhaaIulx?=
 =?Windows-1252?Q?4cEXHOJbIiD9hD7hVW2HipdEXSbclU5yLrtFTNlIF1/IrNTdLLOXSzUi?=
 =?Windows-1252?Q?z0soM3bDo+yZkOegV2W+Y1a+AeZPRpnpsirEgXy19YjeNpqtjsx9jBQj?=
 =?Windows-1252?Q?FfuyZFV2nAGZThha1y0yhNbPVFii5OlQHYoyxg3zdPYU2jJhonmYvqo2?=
 =?Windows-1252?Q?aXuL/4fZUl0lsdDCzQjIkV9IIE1HqCeyyt6OmNQx/gnoV1yu7f72wC89?=
 =?Windows-1252?Q?IhlFMa2NcJK30ljxRL+gq+UEpIkyBHRHy1V8YoJhegX/WWF7R8gRblEz?=
 =?Windows-1252?Q?tyIeEIW2goEsgDI/XPW8DOsUI04t04hO6agK3pIGFR1/iqDu3rR25SmL?=
 =?Windows-1252?Q?9rPB6iOkmhh22+RCZ6dBEMHMHw872Y4bPAoHIEGZ3BeFHNc/WCVf0/6u?=
 =?Windows-1252?Q?teF+NxGIOwXZlxC9MYeBuOi3FadNSzkITrJZmtABpnr9BrsEHMlEPYcX?=
 =?Windows-1252?Q?7auujQ2ja0hYMf8Oeo/I7SnCj17FQUqzTYFS1/NyEIbC3La1qX1+RFMt?=
 =?Windows-1252?Q?/RkKXiazFJPBCTwQ8eSUCMLuN62uYWWy5ezcxqWhqwdaH7rg/6GfhBhh?=
 =?Windows-1252?Q?YKfmiQ5Z5lS4Rz6CNb36qvxsbIAhIlebwWrx1uxVUwzJfeZvGOPQQox3?=
 =?Windows-1252?Q?TPHwtBgOI5HQo0SA5J2EMSL7Zizzqcsp0UDWl/aAMQj21fz6hLusWNVf?=
 =?Windows-1252?Q?gqHRbRbdju1SivV71ebUMq22b0dvF6D1Kj5+RfGQFsSl2G5WWJB71NPX?=
 =?Windows-1252?Q?Uxwj40JGVXJGOCWiSaCEuR4IY28I0Tj8DUPfrGkhxcHgrpu2aceIOcd8?=
 =?Windows-1252?Q?rwTMTOWoY6t20B65jHnnZuNm5YmoUXRZ/K5oisKeDmRvnJsd9YYMvJCQ?=
 =?Windows-1252?Q?BOlylA6QOsWaDa6DjELFJE56JRCd+ZDOQp+XOFYPyddPGrCsbzLvpDRN?=
 =?Windows-1252?Q?XsPnv/v4gUQX38cA/TtTpnxsz3tMjPgcvPiFMQ3k/1nGOW6+A/FF/jTE?=
 =?Windows-1252?Q?E5coAoMDICHu9WcyfAE22AjTUtFJNjl4HEjBcG/h2I0N2n+Ox7O8Tnu0?=
 =?Windows-1252?Q?Ml7+Ek1cFR5JfSkJVNeEezLZFvzbXlgz6nvqhT6kz2Rp6HOsbrvskGTq?=
 =?Windows-1252?Q?f+8nrnD+0BW7F9cr2OnV3NXqEsrV/ZFQqszBXwYSOlFsIRYX4Qugeago?=
 =?Windows-1252?Q?shMTJMbyVsZD/SFEoLycom35YnnjnOFIYliBBiZXy5MDDkE09EGWL5Y6?=
 =?Windows-1252?Q?V2TOywHzINVpWuq3mX/BWBR8J5UD3zUMES+XV9pEwW6q5xxQywpRZeFf?=
 =?Windows-1252?Q?RmUkbOzVWTErAc9PkBtKH/2v/63w+Ok4i6T3yxGhJCl+1GaGtA04iN+S?=
 =?Windows-1252?Q?IIrcSkyNQ0f7si0OLXQzT6RPom3DTZmKpjOZJl76RCSKzTEFWhZzB0KA?=
 =?Windows-1252?Q?2023O+hujuzANKtjL54=3D?=
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?Windows-1252?Q?a1GGJYrJ8LvYVzAY5DFiqKfL//NHjDUh95hkzZIJXtamzEFpI62UmV87?=
 =?Windows-1252?Q?+A6bFwGjySltAKVdciF7A33B32uNUqBr1PDcPAJITVE73kgaLIOosRsF?=
 =?Windows-1252?Q?zB1Lw/ArPrXL8HDO9dDa6GkKnhctYhJxdO/iNXU2PXC/z+t8OR2G+jOC?=
 =?Windows-1252?Q?cc6cB6VcAD7jiyNHPtVF2EDPqLXw40IHu6rDFqISkuSrQRUlGliPOxsz?=
 =?Windows-1252?Q?BTGl31Q8yQBVHsGxVwKPBQZ7QMXZWH/HKc3zV+xN/xA4pGZMymshlgTU?=
 =?Windows-1252?Q?+R98W6ZIlwlfNwHrnxmCxnpjnVLKgC+h2buyGS3y++XXoGewTz0k+bHF?=
 =?Windows-1252?Q?gx/GWOcGwwopRcSIxEP7ECt2tnrRrkYXEgdNFpeji8YoGyjlUAEEGS+7?=
 =?Windows-1252?Q?a6ESyNedNclrYbNZWfKPnsK7SRyaeqMY3122ynbOkcXvSISPCECVBx/q?=
 =?Windows-1252?Q?UdvpEF2mO1m5uUKPmr3nhgyquhygnKVnb8H/3CSJIl0a3te29OzcEIvj?=
 =?Windows-1252?Q?jBcKTne1rV4SgpU3sckF3qg1YAxgefI6W0h9YjwIiY8jxhf+vzns/mw6?=
 =?Windows-1252?Q?ciJrVNfm3P/kd6PTYQ2KVTezwbUdOoQ94M2iGMfrKVdCc9spdnrM/MqL?=
 =?Windows-1252?Q?G2CouNXa2Rknibab1D3Emoum1mYCPCruWGpqWJWW67gmCzebjXajpuZp?=
 =?Windows-1252?Q?ZmEsAjbopAWjw9Fk+7sVVMe5YX/yfLL+Dcr/DGgQ//yD8MXwSZA6hztS?=
 =?Windows-1252?Q?mbzDz7QFBko3Sf/vN0ns+hrJwgj4rEXS8CSB3BCJHzg1OjAvf11Zjjuw?=
 =?Windows-1252?Q?bAiLjMDcHMM0vngdAueffMbSye1RrHmbnhng3jXj4LgANcZj5JkkcB4H?=
 =?Windows-1252?Q?HCOZ3CT+r3QQ14wcxkYIIEpLPN0Sw5toC4NAsxxCB0feKLFbIbsMiQ8w?=
 =?Windows-1252?Q?LYynqdBIv5UD8SrghgosglwRkvNFazT/pZeSJWHo2h0rtybQC5QGG17D?=
 =?Windows-1252?Q?TbiIfMeTkzy8aXYnTHaf/Sd4HmwoDK0oFzJmAQ0IoX80Rn47UQ2LskwJ?=
 =?Windows-1252?Q?FdFnCdewIvcmvpXRnbS9Rzme0lTF6EHsamB1EI9plW0aIzgwR+6vh2Sj?=
 =?Windows-1252?Q?o8DLoXgytIhmt84BQIlXU0eOGBO9JKMLyWCz2raBtT5rPg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac48cf9-d021-4c99-5aee-08db20e1d399
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 21:04:09.2674
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: amygoXQtm6B4wq4t3DZvt5bhYZVg+OlW317lQU9u5mfMKkwJ9pfNOrtKxRfBKtooeSjNU4L2BUsLjDn5bfw0lwqhxY+1OVWkToGQrspdCIk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6900
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-09_12,2023-03-09_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0 bulkscore=0
 mlxlogscore=956 suspectscore=0 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303090171
X-Proofpoint-GUID: k1YoXpmpO-gwlaZBqrwbcHOjs6keTosx
X-Proofpoint-ORIG-GUID: k1YoXpmpO-gwlaZBqrwbcHOjs6keTosx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

=0A=
=0A=
________________________________________=0A=
From: Christian Brauner <brauner@kernel.org>=0A=
Sent: Thursday, March 9, 2023 9:05 AM=0A=
To: Anjali Kulkarni=0A=
Cc: davem@davemloft.net; edumazet@google.com; kuba@kernel.org; pabeni@redha=
t.com; zbr@ioremap.net; johannes@sipsolutions.net; ecree.xilinx@gmail.com; =
leon@kernel.org; keescook@chromium.org; socketcan@hartkopp.net; petrm@nvidi=
a.com; linux-kernel@vger.kernel.org; netdev@vger.kernel.org=0A=
Subject: Re: [PATCH 0/5] Process connector bug fixes & enhancements=0A=
=0A=
On Wed, Mar 08, 2023 at 07:19:48PM -0800, Anjali Kulkarni wrote:=0A=
> From: Anjali Kulkarni <anjali.k.kulkarni@oracle.com>=0A=
>=0A=
> In this series, we add back filtering to the proc connector module. This=
=0A=
> is required to fix some bugs and also will enable the addition of event=
=0A=
> based filtering, which will improve performance for anyone interested=0A=
> in a subset of process events, as compared to the current approach,=0A=
> which is to send all event notifications.=0A=
>=0A=
> Thus, a client can register to listen for only exit or fork or a mix or=
=0A=
> all of the events. This greatly enhances performance - currently, we=0A=
> need to listen to all events, and there are 9 different types of events.=
=0A=
> For eg. handling 3 types of events - 8K-forks + 8K-exits + 8K-execs takes=
=0A=
> 200ms, whereas handling 2 types - 8K-forks + 8K-exits takes about 150ms,=
=0A=
> and handling just one type - 8K exits takes about 70ms.=0A=
>=0A=
> Reason why we need the above changes and also a new event type=0A=
> PROC_EVENT_NONZERO_EXIT, which is only sent by kernel to a listening=0A=
> application when any process exiting has a non-zero exit status is:=0A=
>=0A=
> Oracle DB runs on a large scale with 100000s of short lived processes,=0A=
> starting up and exiting quickly. A process monitoring DB daemon which=0A=
> tracks and cleans up after processes that have died without a proper exit=
=0A=
> needs notifications only when a process died with a non-zero exit code=0A=
> (which should be rare).=0A=
>=0A=
> This change will give Oracle DB substantial performance savings - it take=
s=0A=
> 50ms to scan about 8K PIDs in /proc, about 500ms for 100K PIDs. DB does=
=0A=
> this check every 3 secs, so over an hour we save 10secs for 100K PIDs.=0A=
>=0A=
> Measuring the time using pidfds for monitoring 8K process exits took 4=0A=
> times longer - 200ms, as compared to 70ms using only exit notifications=
=0A=
> of proc connector. Hence, we cannot use pidfd for our use case.=0A=
=0A=
Just out of curiosity, what's the reason this took so much longer?=0A=
=0A=
ANJALI> I have not looked in it in detail, but it seems this may be due to =
the number of system calls involved. The monitored process needs to send it=
=92s pidfd to the monitoring process, which adds the pidfd in an epoll inte=
rface and removes it on process exit. (I did not include time required from=
 monitored process=92s side, to open the pidfd and send it, in this). For o=
ur case, we cannot have our monitoring process know about every exit (or re=
ceive new process=92s fd) that happens due to the large no. of exits happen=
ing.=0A=
=0A=
>=0A=
> This kind of a new event could also be useful to other applications like=
=0A=
> Google's lmkd daemon, which needs a killed process's exit notification.=
=0A=
=0A=
Fwiw - independent of this thing here - I think we might need to also=0A=
think about making the exit status of a process readable from a pidfd.=0A=
Even after the process has been exited + reaped... I have a _rough_ idea=0A=
how I thought this could work:=0A=
=0A=
* introduce struct pidfd_info=0A=
* allocate one struct pidfd_info per struct pid _lazily_when the first a pi=
dfd is created=0A=
* stash struct pidfd_info in pidfd_file->private_data=0A=
* add .exit_status field to struct pidfd_info=0A=
* when process exits statsh exit status in struct pidfd_info=0A=
* add either new system call or ioctl() to pidfd which returns EAGAIN or=0A=
  sm until process has exited and then becomes readable=0A=
=0A=
Thought needs to be put into finding struct pidfd_info based on struct pid.=
..=0A=
=0A=
ANJALI> This seems like a useful feature to have.=0A=
