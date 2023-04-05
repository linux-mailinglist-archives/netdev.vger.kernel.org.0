Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3970A6D71AB
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 02:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236750AbjDEAqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 20:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236779AbjDEAqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 20:46:03 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 192C059C9
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 17:45:41 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 334KopQg023515;
        Wed, 5 Apr 2023 00:45:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=itfzN0PCrrFdrUB9lK//g87EsnIR5w01Q3XV0FB4WbI=;
 b=DvCuMAmO4BEQWr4KHjMRSDw/E7HIprYdJzK/8JcQjz65J8mB9yAYjNGSFwdN7IZ6e0xI
 s2dksTneygsPMmNMfrx2NN8Nk6RFo9PIXcXbnJsA4vl3cO2Mcywz2itJIspk26FeK1WD
 OBGX/DWhqDsuxZe9uzHSVOeqLBS0NFJeWSxg+AsQ23bfp/fXxl6kjSn0IJrkyjU459WS
 30ZJRzE+gJ31NvGCo/tcFy7/GKj1KlKZgVbJaKo43qbl315PJC9v+Ac4iTDjFO3Fychi
 mgtrZYN46sigSqP3/mqDgBsK17NgJv+BzCaQG/DBTdv24rMOc020oNXEZyLrG2ZOdwT1 xg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppb1dq64x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 00:45:30 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 334MNKMZ028928;
        Wed, 5 Apr 2023 00:45:29 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptuqmjwg-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 05 Apr 2023 00:45:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=afMRT2hrKMn1FEf/xE9RzoEJ1wPV/jH6zLYhqItxfO3C1Fs5+1pPBkKZqvBRRl1WICwKuqH1m/DqiNtx2oU1OTvRR3jUSB7kQgx+oDf6k4JCS5lffEtU9SFwd7ITlF6ZUUUlKQw7Gp66o3HrrM3sEgPetOSKLQPj2T0RUc4hrqZQiCKafmpA8bGyl9DS2sqUbe4v4GLYBwWg9kJzFtXbozGQN2N0EkLUoSEf6CBO4LD+jdDqK8UHuy0qht4oHum8JegRo1CtGqToc5igaOYxsscBw2/h3fxyzaOTQsBrjuA6Mm7tJf9s6hj6dYqOCEn1hTb9rcMyKoNH9vQ6WA3xTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=itfzN0PCrrFdrUB9lK//g87EsnIR5w01Q3XV0FB4WbI=;
 b=NXDqkmEv6x9rTfEpIYa0/fxb1dTlx1/Jb0xMJfQNqDgwkfsJFnUIl8Qugw97BQ8Eytnjq65Dw/ZN8/jVHNwEHdy2ws4Qx8tz+UDoTZxR8RbxrcwqnlO35EzjBLrT1UK060qNgeY0uIpgBf3IT+aq/NgfU0yPXMhnMDcHhiZ05ynwcBe7T+YnQKhzD3feQ4SLS82ZlFe3achTjoH/QOc7uQ5u0LEKjUoNc68B0k8U4cCMjxIp9Pi1jEgPbwzwL+j1p1yVpJKGOWxMPEMqy4LmSY2Ll5YqobfMqxfgs6fQutNkdqHXEI+1FpIBpHeSng7kHP2SnupjRxthOozg5AlrRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=itfzN0PCrrFdrUB9lK//g87EsnIR5w01Q3XV0FB4WbI=;
 b=qA7+dOV81Y4kC1IcsxH/iwBRER4WFudtwZFS2Z+mvI+5iUZEZ1bduS8krWLRhVuX8fXyt+RoC/DfvvVALfzY+bBAl2Ee0CfY87ZEZPy344X5lLeySJdqP7r2tKnjzLFmkFWyzs+2TSgOzkh+BQeEHfpp3EWVV/J8vzpx4suIGSk=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by PH0PR10MB4567.namprd10.prod.outlook.com (2603:10b6:510:33::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Wed, 5 Apr
 2023 00:45:26 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%7]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 00:45:26 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Chuck Lever <cel@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v8 3/4] net/handshake: Add Kunit tests for the handshake
 consumer API
Thread-Topic: [PATCH v8 3/4] net/handshake: Add Kunit tests for the handshake
 consumer API
Thread-Index: AQHZZlyXNrnKlwid5EStcZWT1gQ9i68b3SEAgAAF64A=
Date:   Wed, 5 Apr 2023 00:45:25 +0000
Message-ID: <C349D344-E024-4580-BB13-BA927D0797E1@oracle.com>
References: <168054723583.2138.14337249041719295106.stgit@klimt.1015granger.net>
 <168054757552.2138.13089316455964656033.stgit@klimt.1015granger.net>
 <20230404172404.335cac5c@kernel.org>
In-Reply-To: <20230404172404.335cac5c@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.500.231)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|PH0PR10MB4567:EE_
x-ms-office365-filtering-correlation-id: d06eb147-8fa5-4fe9-d192-08db356f0bdc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9he7rb61MqvJOoW0mRMwsZ1NRwp2vJ/7FgCxsjs38mTFql5Y1VYhfSRt8nuRT/hy3LXr/rbTNygUoTFvalo6ortlMRsk2qku0anlcmIFA6zHE/bjxLFTd7wtm0mKe1vV9OuqUmTtFL7lMxW07PWlauPapd7OSANgJjqc/mkdvFE1gQNNlTwm87Qz22He8rHt4Rp1hMYeQLcfPc5uuohTisnJOse4+DisGN6hbqDJL0Wiz7mxoh+W0Fee6X9o/h5ctuDSvCMFKO/QY/czvR3ln4GWbdCuDwYB4wXtTW5sd9NeAej+jVQysFLF4dqVbPK+6CCniem7pySkZZ82elZ6Ixd6Ft5/p2KvyhM15SiW0ZinYwAw7fdGFvoFY+fRhV7oFolyuDL+kw97iZ//qBapbDjvMJHjDbDiaEhr1Sdbhh+zNogOiBk+HWuaFy9u67Yg2ZssT+JNjCjO2mqQCZ9mIsyuLFQt38hPrm6SnHnS+X+oNDQ4yMG3kNVWyXYMSw5T3uWYkjarlQ3yx3joMtGmTHzXLPwUg0EI77mnVUwgLZx8mA6quPxt+I33sXcZMmxEyqRbKcMH8KPd0PqJG94QH7D295hq9ZeGHxTvsj1xpTJVezXO83HlDw7m3ybv5dluxDYjq3AztVqr9Cqd5gjVdg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199021)(186003)(53546011)(6506007)(26005)(6512007)(91956017)(66946007)(38100700002)(107886003)(122000001)(41300700001)(6486002)(71200400001)(83380400001)(2616005)(54906003)(478600001)(316002)(86362001)(4744005)(2906002)(76116006)(66556008)(64756008)(8676002)(66446008)(66476007)(4326008)(6916009)(33656002)(5660300002)(38070700005)(36756003)(8936002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?efAK4lCqfXNscr9DNzGN/JibEp3A3wxZEGDd9QG6CQLyBaDwwcqzdEgLvDbp?=
 =?us-ascii?Q?ygx6u2N4ODKkerRyImTDtDoTD09ssJtjToutMOZlpcXejmPemtsJ1h0Bgti8?=
 =?us-ascii?Q?Thr36+iEjXnWSsmX4LzaIOMTePFQx+Gtvro+bCBML+1+DuCcUIeMY4NuD6aO?=
 =?us-ascii?Q?ogpWoBIsisIBxUB55BpiWpVJP3RvnNFnmLUpdL+Th++/Ga0SZ01OVncxVqBR?=
 =?us-ascii?Q?bwgtvMvTKuSEJIc0Qvw/Z3b2LG9/HkbLrwWSWVDyuhfAuN4lkoQdLZiAgwHf?=
 =?us-ascii?Q?gm8qtuJrjYHua2jF4f2bKCudjO+tQy4tZ3qfgvTILhswLccy6WmERdVAWxrL?=
 =?us-ascii?Q?/Drka4iqDOGZix5+cW5WEq2/cV46d39QQWJh6tr5ufSaDYWjoVHJTykh0gjn?=
 =?us-ascii?Q?rqEe+JdMvFqCD1HBM+LcCnHHXMHJhusmG4fzsmRGmeadd81K9D3dyEwA+B77?=
 =?us-ascii?Q?6hdewPy5cSpReLtnoz2gujUNCVtr1+Q57ebqyJztoCkcTzNqGgwn2Fu5DNdU?=
 =?us-ascii?Q?dOsT9RmImsQDtyxEFxLxyZOePr9K0WaPaBe8YCnZAJERN9YZ3vqBSPXqMNue?=
 =?us-ascii?Q?DIEQMyjXa2tLAUnkIWbpu/mwmuXMP56QZG7BmGHt32Cb1u0yjD8rFQs01otq?=
 =?us-ascii?Q?59phoyTR4tftelMuQPlSZBRVFL7fr31ivArAimVytOt2Ef2otsbQeCjINEN3?=
 =?us-ascii?Q?JndeIx4pXZNOHOfq12S2xjdsWV2RlOq0kKrLotjsta/MNvLlv094s24a2ky2?=
 =?us-ascii?Q?U36WFUcOOISO3tqCYHaLgeKYk5N0hU0woSUB/jKk/gHORbH9pYUzChlSspBS?=
 =?us-ascii?Q?eJyw+14FUpRZqWUmHWdy8z2vjzpqdjt3iIsUrgTRXUQG0su8k//W6Nz6alOe?=
 =?us-ascii?Q?CwntxuvFcxSfRI/0D3bNbnb9YTFiJxBc2sAUiWeI0wQaxmGSPG1Xim7hCsvH?=
 =?us-ascii?Q?6ieqCVWzX7wLnN2h/QsFet9Zv0NPrWWk7U18l74LC6JnQxOWT2TFf1QNg2QN?=
 =?us-ascii?Q?gZV6b12Tqn4symKNSxaR0HCoI5qZ+wakNCcvsSWe0Jg+dsy+jtp7LCMpmGji?=
 =?us-ascii?Q?dzBcvnvDhfp6RYMASV7tww2WBkwTyK11LXpXnqV+p8hlsHi7RlNjCYw1UGVn?=
 =?us-ascii?Q?DnvI0ODReJnCXviZjDWB1pyNiNIDJ3hYkFp1ju42O7Amggd1BKx/T2r09i2n?=
 =?us-ascii?Q?tsAU0l0mR5u6OSbh6jnEVs5CZlbo/SevcIYd5WcRJaThfGsNoL6t8vfTCNup?=
 =?us-ascii?Q?IGdE9daNbEuN14G67hZr7TDK0eQS4VOfnhBEctonCt0mwFgK7d1Rpw8XUJJ7?=
 =?us-ascii?Q?cKwuTZ0CBu8aQYiEAIY6mGWJ8u6eKSEAVPA5vbRahPg/Ko18ZhgkfkPyXW+s?=
 =?us-ascii?Q?SDkPmLrTwIPC85gwl+KRHQXth2oafvtx/ODU9WLezpZ38ru0yB/JU0H6LX6/?=
 =?us-ascii?Q?u3bMn6OcdNmT0e9fNZxkg/ei3jt5v9pVgVFoRaxzUjEnz0fFEGk87n691qyw?=
 =?us-ascii?Q?dW6akbVZ3oDk4Gqd0dFm0Jud2+Q07BYlEGRd9BCu/YiM0cl8WmimcuT7bpm6?=
 =?us-ascii?Q?mIb4dEOHPy9eUEjQ27YzJewOvPk/B6NMvRwO9kHB/vu9dYlSkzrh6ENIfCWe?=
 =?us-ascii?Q?Dw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2E5E4C70E829E74EAD4A92724D30056D@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: UllcdD19C3th7OJyxRNDXrF2PANzhc6+E6cdKRD678W2ITkn5QsIYh3UKy52hedrONitpsqg/X8hqa9NacJqaAIgkxuj+9XaWLAin0+yKwaiYYMAHZnv4zyDrneTR4+s+0TGeIbsGM6r2RjQK02CLjeIu3OGxiawfgf5KKkT9QpfAnz03AT/pG1RZbs05A5wKsKcarOPJPdQ9KC8J0MhHbZYV8aAIYy00e8Ka0HgzdHZ4HvUcBAZUzG44al9gD/NodLQCQeQvb2gJ18d5w99+3NjQRJTpTT6rznIPP/uH+Pxl+nCY+z0SaHAbDvziUJFZqteYKE4MbAo1fqnCGgDvyrE3vxWWhugT/t2w8VLpa8SE9rqxmkRMeMQ3l6FMOFDSS3iXutbTLFAlz37Qn03Xc5mqj6mU6014GX0mnLFZlN+uSZAZPc0rzIZH4FPkJ7Vg4xQQzgo+uvHse7EuRw9UuMNwtzIPpHSqxGVyXZVEvpPSa6CMIu4d7y6/y2elm2JQHv+dBt/qyG7wthMbW9F/IKBpO8ZIl00wk67rHPOHSO7v0uInq6qxa5D/zpWnlsm+ZQfhmRzXrE6xf9uLs7qaHZ9k0QCESqYBHPATaPAdMX81U3+jxKXfBabaPY8YJcmdnIdZl2Pm8Oi/5vbOeC1m7LPB/pU6i+YgtklYnuoI1GbNK+gKF+r44F37H+4qD6M48DEUOrElzXfn/oKbL3ZnX7zefjNMeVsaOG2q3kwTaNjcrM6AvsCcw7CmgJRvZqDZI5CFBF+Jmp/upVtgTocvoSQxNcxYcWLwFfHaWz1lrJefma8hlyvyjXaa2/lAbXHkcRdIGJt7ccuGH2XG9NzL9Z1bHTyiZFptexMQL7Nl35+PlnMIG0U/RvIvCPirLSEgj0IUhiAg9Cq90LiMgz16mHGzOx0irpnRUaXG1aDPq8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d06eb147-8fa5-4fe9-d192-08db356f0bdc
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Apr 2023 00:45:25.9479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0noVuE2HWRDTcU3Tw2wOPDAGS7xN3YeDhNok2T0VWD3HguFVR3loZYsghc5h/J73QgnjjIV1y2X2xO0CGHgdCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4567
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-04_14,2023-04-04_05,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 malwarescore=0
 mlxlogscore=772 adultscore=0 phishscore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304050004
X-Proofpoint-GUID: 6JgOoKdhyGFSObvgm85MdhgX5VEV0nhH
X-Proofpoint-ORIG-GUID: 6JgOoKdhyGFSObvgm85MdhgX5VEV0nhH
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Apr 4, 2023, at 8:24 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Mon, 03 Apr 2023 14:46:15 -0400 Chuck Lever wrote:
>> From: Chuck Lever <chuck.lever@oracle.com>
>>=20
>> These verify the API contracts and help exercise lifetime rules for
>> consumer sockets and handshake_req structures.
>=20
> Does it build with allmodconfig for you?
>=20
> error: the following would cause module name conflict:
>  lib/kunit/kunit-test.ko
>  net/handshake/kunit-test.ko

It doesn't. This was pointed out to me earlier, along with
another related build issue. I've fixed these in my private
tree for v9.


--
Chuck Lever


