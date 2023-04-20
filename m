Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D776E9B27
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 19:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbjDTR6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 13:58:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbjDTR6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 13:58:05 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE0D219A1
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 10:58:03 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33KDwptD016598;
        Thu, 20 Apr 2023 17:57:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=cD8toByTNBjiTuP55cwfM6jzXLQa8aDvybKkdgk8vb8=;
 b=IBwTtVUppfIQPahr9U81Osh9tOf2T7Y1RuPrjJsJ64FGnBuOvVC81fZ748FvZT2EGqLe
 gq8aKq4dVqmlm3NVxNYSeOyKwGB0wWjmkc0GPx0LMBy2kZ6/Z2OspeimLFAsYCC3JwG8
 aIPpRjdWhIiD2oWeRcYZ+VBDt5D84KaORO/b2rxjpQhiUZ7WS0W7QDS4X+9An3gJyph5
 bkJuZibDYrw0zhJffd6gpAfrsdHxugiousF0VGo3MtnSPIzUusblGN6lDbIKw+0/GW3f
 WF5zEhmS2lqtkVgC41T8lyfSOk/Z4G9OTzEaYCoyt3d3YBS2PlCsziCERwAGJ2z+9smJ bw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pyjq4bmxf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 17:57:47 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33KHE5fe026392;
        Thu, 20 Apr 2023 17:57:47 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcew2a7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 20 Apr 2023 17:57:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnLK/Qby4x9YLDyj3TK0qACfBZ8aEoS+s3UkKUNy3zglIkKAe5hWH5wcRTJbhZkiSF1jedM/RiGDYSH6f3GyKLm29/wvOVx3nkhkqorzq5Cy8dPpI2d99m1k8AX1iZPskY6QrETl15T3g0K9d/eoBvtDFIR9AXcVqOmJ3wan0n2tHvT74KirCbCdbfXj6TYDpRFnUhNQ3MgIzGy8Rhk0OE4iH9PgYq7EwzIeSQskq7l8ptQNkLH8381qGvEeeS5O4bQhPJRJht3kEmQO+KrDmY+HC5z5dwSWd+2Hsv0CdXWuXMOiSGGiVaYMRTw3pmR3Lk9RGWDtx3pY2rcAQIBXlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cD8toByTNBjiTuP55cwfM6jzXLQa8aDvybKkdgk8vb8=;
 b=I64PjsZg2NQ9v5tC+PAyEqltR5TG11g5YGeiZaP8kn53U9jH2u0utz38oLKzyOsYdRQPGh8X0f3fkVEV7ldqj1WzPfwwJmvePUCQyGpZ6SIBtXetfHqMfGpDUMNhUg59jvhBVCId4gaR6FIbsDHr230JKa9p3QKf6smYWmdBQa2gPWXC58h8+0JjBInXPxF43OAcF0t0pH9Njj6cTVv3XMcPxXvZEaMdlQgQs4bXOqp8lmQz9IiBR3QORHS8+d++rIFQPUSe2aDB1wzVWNzZzV9wvpGzm+GyHUriabD6R6dCytpwlZbj2fZ7o/Mz0HkR7YHhDdtS5eYXVHsx25qARA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cD8toByTNBjiTuP55cwfM6jzXLQa8aDvybKkdgk8vb8=;
 b=nGm845FdUa7uHAVLSzSGu31zTKZ4C4hYbciZnRX8+7SQ+/bLzjwLcoXwqmDgteZJ0/yvGAuYF3QMN+gcoV32ZTwE5dLXGznIMZCFmrwxdT+U0m9xgn9Eo2B8ESFZHridm8ZCrC7HVjbgSDHi+bizIaMJTplNu8j9wO2JHeYRTuE=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by DM4PR10MB7391.namprd10.prod.outlook.com (2603:10b6:8:10d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Thu, 20 Apr
 2023 17:57:44 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%6]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 17:57:44 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Nathan Chancellor <nathan@kernel.org>
CC:     Chuck Lever <cel@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>
Subject: Re: [PATCH v10 2/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v10 2/4] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZcTl1HGlRagHcZkiQRmSOqsWDmq80gHUAgAAAQoA=
Date:   Thu, 20 Apr 2023 17:57:44 +0000
Message-ID: <7AF72C2D-32CC-4A5E-89BD-07704A6A19D3@oracle.com>
References: <168174169259.9520.1911007910797225963.stgit@91.116.238.104.host.secureserver.net>
 <168174194627.9520.9141674093687429487.stgit@91.116.238.104.host.secureserver.net>
 <20230420175638.GA2835317@dev-arch.thelio-3990X>
In-Reply-To: <20230420175638.GA2835317@dev-arch.thelio-3990X>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|DM4PR10MB7391:EE_
x-ms-office365-filtering-correlation-id: 639721ea-ff23-44f7-6838-08db41c8be2b
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4GYWYgyOMEIiubC5kW7Hymid6uIYt6IAo7h6k2IGrCPcMaU0Uh04L/9rXr2Hw1Mv5w70f0ebA2hv9Kfbc2POlvW/vkUHt7yAduOB/riRMpHv4DSmackE+79sI21NNO2NgX6vjOfyuA5TgwdhqxrNZ/0KwMUY/7SAg6ENcwXf15DGbC+VLEu7gw+BhYZ+4vKU2ttsEVeWPnCt86Qgx5p9xK2NWrbCPfxMl4nkgMTv/RXgmnV4MRV+Bci8sIo5BOLJTE5Le/3xP7RLc2UaSNq3kwgQyn9nUAz4qVi2+GPk/ri+E4eLFp77IcU6fvl7d9xEhCXs/FsnVR6bHiQTFIOEL02HpmC6PzGyNVhO6qZiY8+utlXRhG1dLSCmLFWZmrDZHm0P5Ok+2/PKRHD9G0hkh5Bbc6cfjiabL7jmd0T56IR6iWYyy52RWfS/DWlm+klqWY7ACBaoZAEN5cLSlbehlPA+DYiW9JlnTVOntsQj+1wqy8NNeyq5lPmwRjxz83a7gQuKu6FvtN36kRYI+/8rcRLUmlez1glCR5fj68G7e9/viZGXyEXgQwgpT3MazYvyTrPrAOj8j7fv8RKYg2wbhLuJT8/H4ULfckTXjBcyGiiefyjlph5y8B1So7F7iKJnB/zD1OnlldUAMmuYVchXVQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(136003)(376002)(366004)(39860400002)(451199021)(38070700005)(2906002)(8936002)(38100700002)(8676002)(5660300002)(36756003)(33656002)(86362001)(6506007)(6486002)(71200400001)(26005)(6512007)(966005)(54906003)(478600001)(2616005)(83380400001)(53546011)(186003)(316002)(4326008)(66556008)(6916009)(66446008)(64756008)(91956017)(76116006)(66476007)(66946007)(122000001)(41300700001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cTai5gXgrCMB2YdyxqVxofuylKGUljUXxR6UxZhOtUiFVT3u4E4boFNPlb3r?=
 =?us-ascii?Q?yrelc8dZ0SFm35yHQO1Pl038DO1PISUKBGDVfqFIalbLIoamRNHBvmAbaDdE?=
 =?us-ascii?Q?wohJdc+jYx3f6ZajuY2syNCGhj175I9cnPz9qL2Tc00pvVJS8MKJH08Z1s6N?=
 =?us-ascii?Q?r5CKeRLssT366+3bf+LK+znJR+qqmYASFFsc4Eg89m7/sDSk8AMaunsCWm3G?=
 =?us-ascii?Q?9d31TlKTRwoUEPSpRIeYiZSXAf2njGHJV2NVO8s55L5Zxvm0G/IZC9I5Op/H?=
 =?us-ascii?Q?CeaHzr6emE80sXDaVK1hLzOfYFR89wd/hxjT+39UraBHenZVrzuN7H91HT+k?=
 =?us-ascii?Q?/iO5ysVKEenSIIZZrIAHDdRkfljnao8BkQbA5M2FcugnA6LFwlIspG1CQuEQ?=
 =?us-ascii?Q?vEeMFXogX8R8ebBMWh8+RgRxFG9aRec/7YeP7pMZLWrazmTZ6qQtC0zjUyM8?=
 =?us-ascii?Q?Pie7BFqKDeWVcWzQLJ1sDCU6jkIdRlcghz45cNgOcpVu/PnQWA0hhFz0qknZ?=
 =?us-ascii?Q?LIYljgSFKlvlHODtkktZij3lw0y4gseSKBCDUKqPqu3ae/jKp7nRyTnl8kNL?=
 =?us-ascii?Q?gxuZcN3T6w1ZN4hnmXq638umekq9uJPPkIKDPc4PMpTZCpPCvHWcxYSjIkGX?=
 =?us-ascii?Q?brLRtIJgYHr+jreiaYa5PzH5SQ20JZruKFWRcx2mF27Pq3b9W1fvK4htBj6N?=
 =?us-ascii?Q?hrMyHXNWgGGruD7M5ABonA9DjPBR94l87gfddUx/Im8Brj4VqvW7/kSfg5vy?=
 =?us-ascii?Q?XfLCIpjIKksJfAr9PQEDEQyWHVCyCtPyF/DMLUUAu7o3dvS5TXqadFDOrPSu?=
 =?us-ascii?Q?ZqA6a90Ip50wMmUZY6ZNMqatQOl94IAWsUgscJI0kEtmBV0GGxB4lliCdRym?=
 =?us-ascii?Q?c8S5NvbrH91JyuzLK4DD17c1TWxcXBe3qcUEPkLPMebddb/mI6eWyhpr9/AV?=
 =?us-ascii?Q?Vn/lUmqvEZkdw2FD2Y7xV/XGmyiEYnsQ1yTEDcK4NYQTkEf8KmG+IzEkNCh3?=
 =?us-ascii?Q?4TpEX1gEw5l22IrkkFWi2Nbw6YX+DEDfm6T3T8jItVuM1qIgQVMJgQCchmC6?=
 =?us-ascii?Q?J5UlVgE4dqoK0vnoCSEiOFR+SNxkV3JrfSkXvAUUafJqDxAj61DmfAYBfHf/?=
 =?us-ascii?Q?N2UNjqsCep27pXdS0jNuGMj430wL4FZhAfHHJqr0bkJY8NJ+KLLgVjOyK2y6?=
 =?us-ascii?Q?3CZw8EyMLO6eV1WQuYLb8S6jIJV0uPf6XQOH+hHBJE5J7gdrtIfGQYD6wwoa?=
 =?us-ascii?Q?M0f+atS4AvQqDos/kXoTt/lM5HDit3cimnj9LqrowqTVt4hyTnXNxsMcO/L1?=
 =?us-ascii?Q?U3HXfDkQ762xM81faHLeGiVwPcgzKo4YlEy+9734F/M6hKBc2Kv5mSc094e5?=
 =?us-ascii?Q?vNqYSkd9KDPIoFocKGHE1URAWatOAtJ7Jy3yQ5cSPHQVPdJh1e/KsFQVYtlj?=
 =?us-ascii?Q?DpIZnwZ9S2Z8ObpafBT2lr9CHlRX0O+XCYHfL9CScCq+p6bl3F/vb5/tt9UI?=
 =?us-ascii?Q?WzWSfXoKtX+Sd1i2MQOkxCx7jrpOc5bmpUq7vxQewhI+eJNNfj3qG2rKRnuC?=
 =?us-ascii?Q?clb4Y6IOj+4HMIfRd8dooGBMdwvbxnw3BNEfyy+L5rdpIDygZNxkLvJ2QUSS?=
 =?us-ascii?Q?LA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F082DF6D3B98424FB51BFFB3B1255653@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: hfPIbSz9mSvcmBTrdmPGfSnQ/OgZfd9p6rXObI50a4Hnd+MHLJCeb9knTHFTdBSNWRzvNa05/Uy7dZf+qcaooQaapm2KfzHmg+tEIF2GNesamVZV0qcqF2XqYdU61fQNSWta3TRGjouPaCm72W7DdV1HYhuSMrgGODycEdKRdofaKHtuQbMExt3buxepPfi0EkarfKM6rRj+LbkggjaI+7p1GJ5vUhihKkDbeqFsvoKOpnuTmxdQNuN65+Kga8ZcfOTVkZIYRxjn0nkpcVX1S4CpfzALoOjJ2o0IsYUukRFHhDwQP8ButKC6eSMU17auB4mCc0OOQCcBe3t0NRFHhsbr2BQ/h6ZQCm38NjT+O9AiQI6NcmWAHXDqS40DXn+9gIYcPHt7XC/dYLHWywawHc8CFJzycQAnrZlK7JKLqjz8SG3ykUwx1x6y9n3XikXHwFq/Em3ZFo4DyKofzOF23ylJIQS8Zb7LcmkvOMKaU5tocX7ijLekbudz0ythSD092eySm77ng0Dtf7uAvwXnWtx5M8PIgeubCc4Uv/WT/gTA+7VlyaUFpVlxPE/zJxYXdlAWItzzpZcuBuMzXp05zU9Fn+9k+ZMzhTKoMGoLu5313Jt7IeEfzHcDr8x8qGb8548x/K1l9dGZsiH/IFR2DTxf6YTDr4V7W6m5xHDbyCQvyHq6ds9V8wYMyw/JfH8qkXD6fH99U7TKeMuuPAvzkVJ+DtI6/xpTI4ark9TUAlnEgxjFDkRhlDSGhfCitiVZsFH1CWZLqNM9lusCZAOXXPHj+S7nZRlZMf/YQPOpJtj/GLW2fAEK7I6ab6/8cNMXjOwBYXlfA3yKNfcB0qJ7+NHQYlJGvn2/5LhXcdxdfOQ0w047PlZ3WXjZnRW7+ciLOToMemomkdqF7EcRGi95bQ==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 639721ea-ff23-44f7-6838-08db41c8be2b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 17:57:44.2291
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0g70/vYgilnDvRegaHYdNidzMRObpRJrMxS8JAnTfOZQINtzg0pAR9e00p4aQDH+4GTPD5ra5RL5pI+yxGFHSA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB7391
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-20_13,2023-04-20_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 adultscore=0 suspectscore=0 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304200150
X-Proofpoint-GUID: yGnwaoE_aGk3KQH0DmpwNdoOuaFtClxr
X-Proofpoint-ORIG-GUID: yGnwaoE_aGk3KQH0DmpwNdoOuaFtClxr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 20, 2023, at 1:56 PM, Nathan Chancellor <nathan@kernel.org> wrote:
>=20
> Hi Chuck,
>=20
> On Mon, Apr 17, 2023 at 10:32:26AM -0400, Chuck Lever wrote:
>> From: Chuck Lever <chuck.lever@oracle.com>
>>=20
>> When a kernel consumer needs a transport layer security session, it
>> first needs a handshake to negotiate and establish a session. This
>> negotiation can be done in user space via one of the several
>> existing library implementations, or it can be done in the kernel.
>>=20
>> No in-kernel handshake implementations yet exist. In their absence,
>> we add a netlink service that can:
>>=20
>> a. Notify a user space daemon that a handshake is needed.
>>=20
>> b. Once notified, the daemon calls the kernel back via this
>>   netlink service to get the handshake parameters, including an
>>   open socket on which to establish the session.
>>=20
>> c. Once the handshake is complete, the daemon reports the
>>   session status and other information via a second netlink
>>   operation. This operation marks that it is safe for the
>>   kernel to use the open socket and the security session
>>   established there.
>>=20
>> The notification service uses a multicast group. Each handshake
>> mechanism (eg, tlshd) adopts its own group number so that the
>> handshake services are completely independent of one another. The
>> kernel can then tell via netlink_has_listeners() whether a handshake
>> service is active and prepared to handle a handshake request.
>>=20
>> A new netlink operation, ACCEPT, acts like accept(2) in that it
>> instantiates a file descriptor in the user space daemon's fd table.
>> If this operation is successful, the reply carries the fd number,
>> which can be treated as an open and ready file descriptor.
>>=20
>> While user space is performing the handshake, the kernel keeps its
>> muddy paws off the open socket. A second new netlink operation,
>> DONE, indicates that the user space daemon is finished with the
>> socket and it is safe for the kernel to use again. The operation
>> also indicates whether a session was established successfully.
>>=20
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ...
>> net/handshake/netlink.c                    |  312 ++++++++++++++++++++++=
++++
> ...
>> +static struct pernet_operations __net_initdata handshake_genl_net_ops =
=3D {
>> + .init =3D handshake_net_init,
>> + .exit =3D handshake_net_exit,
>> + .id =3D &handshake_net_id,
>> + .size =3D sizeof(struct handshake_net),
>> +};
> ...
>> +static void __exit handshake_exit(void)
>> +{
>> + unregister_pernet_subsys(&handshake_genl_net_ops);
>> + handshake_net_id =3D 0;
>> +
>> + handshake_req_hash_destroy();
>> + genl_unregister_family(&handshake_nl_family);
>> +}
>> +
>> +module_init(handshake_init);
>> +module_exit(handshake_exit);
>=20
> I am not sure if this has been reported yet but it appears this
> introduces a section mismatch warning in several configurations
> according to KernelCI:
>=20
> https://lore.kernel.org/6441748e.170a0220.531bd.8013@mx.google.com/
>=20
>  $ make -skj"$(nproc)" ARCH=3Dmips CROSS_COMPILE=3Dmips-linux- O=3Dbuild =
jazz_defconfig all
>  ...
>  WARNING: modpost: vmlinux.o: section mismatch in reference: handshake_ex=
it (section: .exit.text) -> handshake_genl_net_ops (section: .init.data)
>=20
> I guess '__net_initdata' should be dropped from handshake_genl_net_ops?

Thanks, Geert just sent a patch to fix that.


--
Chuck Lever


