Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 229ED4669A0
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 19:11:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376571AbhLBSPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 13:15:08 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:8540 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376574AbhLBSO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 13:14:56 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1B2E1su2022386
        for <netdev@vger.kernel.org>; Thu, 2 Dec 2021 10:11:33 -0800
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2100.outbound.protection.outlook.com [104.47.70.100])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3cpr522wmt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 10:11:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IrsffBsjHTQw3GsrC04Q2jf22w9g3YO59mIU0C4Y11xeaiwZp8s/XS/9GNIPijzaYGmqsfKUkRNcntIGtyvow2WtgxBTuGHQCruCCtxPBWCMJqSwU6Z2BQXXb/tMFJZ05BDi4p3BlPIGVMmWNMDBjUIOjLXAPfERokr0O9Hiei/W6XNQskgplr6h0OPB94mW/jmfKZVrbgonFj2IQL9oXAm6SjY2LvMxdrFeYjFF/Uxcpjjs1Rxta9s7TIrsqXs4Y/9/UU8Pz91ULnHYEfJPROxgwU1Kpj+mXvpyZypIa7+mir4ANM13HgXTm3CXFnL89IMotBphY1xLvHEetHjLlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=56SjoKmAHZY6k2/2CfZFkcB0ylipV0heuTc7afhTExc=;
 b=Kh4r8UQnEESZ2UPobaPFo0tcV2PUIYQCjRSgr0mcMNNLQTJiba2TZQ/spc9PPjW53VjAXCCirXIwQW5iFRqF7+c0z0uLt7EKrTn3NNsyxN8z81sUiXwOpi6K0qaLMtzPmr8cqVvjcFGbmHrQnpTA8p7pt3J3i8t/M+Y7JPmwESBiKysPDhWYpTX7qQx5b4z02zZeMS7eH3iqcJ7gDY050t+sAFMM+6zlWkMdGZrJJnYIZWrGoYu3Kxz5X1PQtCzJETrdoTJe5hVBhvFFBhrOiirre9odmWKxxlh5s0LEkrY3ustdfiYD7fgJFk0Um+Z1cb2TZEO7VAzSqrBtDXtJeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=56SjoKmAHZY6k2/2CfZFkcB0ylipV0heuTc7afhTExc=;
 b=r8PhQr62KsPLs1nfmpBYsMQrHVouBOyDCmGjDuUx3eElOeNQkUC4AaVnzIBc1CAynTiJGXs9esTH029oLlUl+NdCIz7tnMLNDI7717AidodyWXSbybrUMDnb6SHzJHXoeNHC/URp2RK94Bm+Zr+oHsgz8IaU3Wq51tsLDcJXJGo=
Received: from CO6PR18MB4465.namprd18.prod.outlook.com (2603:10b6:303:13b::10)
 by CO1PR18MB4810.namprd18.prod.outlook.com (2603:10b6:303:ed::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.16; Thu, 2 Dec
 2021 18:11:31 +0000
Received: from CO6PR18MB4465.namprd18.prod.outlook.com
 ([fe80::c9db:92b7:a285:d0d2]) by CO6PR18MB4465.namprd18.prod.outlook.com
 ([fe80::c9db:92b7:a285:d0d2%5]) with mapi id 15.20.4755.016; Thu, 2 Dec 2021
 18:11:31 +0000
From:   Arijit De <arijitde@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: How to avoid getting ndo_open() immediately after probe
Thread-Topic: How to avoid getting ndo_open() immediately after probe
Thread-Index: Adfnp2Kk/EIWcMA+SEe6g4pRQpEDXA==
Date:   Thu, 2 Dec 2021 18:11:30 +0000
Message-ID: <CO6PR18MB4465B4170C7A3B8F6DEFB369D4699@CO6PR18MB4465.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4710d17-b1d4-46e6-673a-08d9b5bf2ad0
x-ms-traffictypediagnostic: CO1PR18MB4810:
x-microsoft-antispam-prvs: <CO1PR18MB4810F35326E86CB5B0173022D4699@CO1PR18MB4810.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h1rIBQJkM10zgCaq+PMt7QvOgewtt8F72n4Y6lTCyiPTYGPe3r6a4JueC7PR2tpQWGV2ac79A7c8JLFRHkU4DpMG4lHubeQXjgTJu1taQN4dgBiDzKd+SHye/w7PSMaeR6ChYWWFFX1H09sjHOHABvrk0NEPGBV5U69n7McGUcYZDFKJNbbxC5JvQGbaVahsN6IJEXJVhPT6btFR6zyre4cZqpZkIOcL5cqtq1kl61kJT58rM1jpDJvVJD9fR8hsaKsszZ1+flpUjTrtTWF4WTzPRQQaAI7/toBER1abHUoIYh9x497sRhB+sEIcJqUUl8ui5hODHFmARWodfjBnnIKMPa3rqgQxAtFF0taRmg6AougwBYvFXT0uwW60EQ4Gbt6loms0b4CNUHi3bB/by2eS3AzfiR0+hYcYVSBaO7KK8OlLLJjDaTItnzEb7Zsi7JY/6PrnIfEZE9be7MWtFriFrZzbRb7bUUMoc/Zib2CKvifYtZpt63hX0nP+yZvuo7Vc8WbBYfTH1FnGOxDdSMtEVUXu6HZ7dj1BDjCvCgDjonYagq05RLqxSCYM4vchtFqgbIAxC62r59e6OEMzbJ8pgcIPYReOQJj6T66bwUUylgPu1+Q+VYdB+0nkypnbcnZeTs0INl8Nea2UOXd78EEMpQslJti1d7CA5+TO/RXRivZd+sGy52HcSeaOzn6vfjfaLqEE1jnqez4FTWpY+mUhr3Jumh2lTzm9TSpKkzQmac/Od1+5DG7JmSzQosZ7jpRs2MNmaClLnFtUhuEniI7lwdSjdSknF7iMG4DODK8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB4465.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(316002)(6506007)(6916009)(33656002)(71200400001)(86362001)(9686003)(55236004)(2906002)(5660300002)(122000001)(508600001)(38100700002)(52536014)(55016003)(83380400001)(76116006)(8936002)(4744005)(66476007)(66556008)(66946007)(64756008)(66446008)(8676002)(26005)(7696005)(186003)(38070700005)(14773001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1bp4uZCN/UqE1710JGhjlVfSujv6dOVz38kcB3O4N0YrZKTdcp/i59MhN5DD?=
 =?us-ascii?Q?vn2Z8hzAA9bqaY+NcLyKxAa0ZnOPl0xyJtUkWzh4bN6qxATyp9DVk17GLDZQ?=
 =?us-ascii?Q?b3G7ey1KtkfPBYsSnrjUIyATZBOmoS5hooZLhz9X3MDWY74PhgCsV7Ndp2hi?=
 =?us-ascii?Q?4NITcEcvOtmoI2GgiDK4bTp0wa66IZsCnxfWtRQYH/wfbX7jx4Ao6dQENv19?=
 =?us-ascii?Q?oN+PoEiHJwj42CmadJbIqq0oNlw3RQU2z2BpyLk4Y9eJWHDqkKOZxcZhsIa3?=
 =?us-ascii?Q?861EH9TVCBf4Jh3FIGiV9lJATVLtE+HVWvZWYPRv4+LFtJVWgeviyWFRCuNE?=
 =?us-ascii?Q?ULJBmCQUJXTpc4GbJTVfXZlhNTsOW0tzRaedrtiO+6Br9dFbALUrrkon9KW5?=
 =?us-ascii?Q?Z63fviBKZgzPCYfcTDUJsDf4oH6zUtlVio1QOshisvc0OBon14zpQXShsr/F?=
 =?us-ascii?Q?D7r5YplN94wdUobqRcCcXxdimOglSAgfBXwMhuWnHVBUIrVjILOfZVC6DxyV?=
 =?us-ascii?Q?PnEfgERJ6U1dLwHVKudihAkrV5DKw+mzTc8V8e6aatT+Cwu+IHGlJWtx8A7F?=
 =?us-ascii?Q?OpP9sWnU/M8YRvo8KVjhmkzYFAu7B8W+2ROQwaNxjS1pOWUvQG7qmvt6NdFA?=
 =?us-ascii?Q?Vvf4PRfYvMKwQhIe+9jKgNMFe2hWVkPRtZ4WltHNEAUnXdn7DUkYddAC7NYl?=
 =?us-ascii?Q?wyZ6gR94/f5IahYaiE71h/m+4NOzB7khiCTWZ2DAfAk+s6rAnY6mhQf0knqV?=
 =?us-ascii?Q?g5YxpB0rd8cyrnulbLvru2xMqPv4+9C6s4jr9ULvi4D5Y4++xR/lYe+ezClh?=
 =?us-ascii?Q?H5VccPWVVz7HsSzsX4+ln71bUJtgfC/dzq9e+nykgcMUp++De/Yc9HRBRzaC?=
 =?us-ascii?Q?xNhPgVrJVj1F2bGdmqf+996bgcXUmKtE0L+E6dfyGL9540lKroY0mI4NnE6n?=
 =?us-ascii?Q?34DGx3RqH5eMVotAxP8WsFHtBWKVFU3brtW5ySG6qG0C3i/ZOopEl36rUFuR?=
 =?us-ascii?Q?9H9RJfBWQZmB7QBJljw3Th9iQmzENg6/sAr+AzVFu8fn818+NM/GX1dX/LfB?=
 =?us-ascii?Q?5gy4H2ZWdk210//GEKlcNITDrA7DN2+N5oX/NDPPWEFFq7v9OmLaCweawfqP?=
 =?us-ascii?Q?yL+5gLHptJ4jLVSLuF5SuDzsUmLBdqJlzK17vXJYc3W2NTPeHWkjRgAJSYmL?=
 =?us-ascii?Q?9dWSpFZMxHrd9q0NamwIb5PhyaXEeqpD2kG/rGw2i2+ics9sTIhJohcEqBpI?=
 =?us-ascii?Q?CwkgIPOtB7Cw6X5nnju0opWqC1igd/py4dMANzIS1xX599O+yJuZR3AzWNfE?=
 =?us-ascii?Q?u8Vv9Vgf1JviiU5w4xBhVVY1UwHXgmdeVv1OXxaR6bxu2E+u7uh2MacI65G/?=
 =?us-ascii?Q?gsUyT51hcJalTsTPO2TJVzA6WQ3WQs0Kdlmej6HnWsOjnwUUnKbM1ppB68g5?=
 =?us-ascii?Q?tjzamvwpnNhJD2urpNxI+6NJ1yqVxcrDfx98XvbxEr8dkZWTyo7G99h/yTN2?=
 =?us-ascii?Q?sEcQCWV420Q/8v/SV+04fAwzgY6XAKH1sykTW160nk20+tDzgjqADLzoekkC?=
 =?us-ascii?Q?ISeCaVkJY0rJIJd5XNmuJikTTi7jsQjr74hHMKEc+pXI8FO40L4qvVAdGWXL?=
 =?us-ascii?Q?YQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB4465.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4710d17-b1d4-46e6-673a-08d9b5bf2ad0
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 18:11:30.9854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ygkZHjVLz8ebAkG90mjXOv5HDwT6l6Hgq2rSqtNlwGVtwFPEGerRhz8e6wJQ6p8FjKPpDMy6fCvs794n5xBPMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR18MB4810
X-Proofpoint-GUID: RFIm2yCg7RbHi--ZXuwgAe6A7JjLhRmf
X-Proofpoint-ORIG-GUID: RFIm2yCg7RbHi--ZXuwgAe6A7JjLhRmf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2021-12-02_12,2021-12-02_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I have handled the probe() and registered the netdev structure using regist=
er_netdev().
I have observed in other opensource driver(i.e. Intel e1000e driver) that n=
do_open() gets called only when we try to bring up the interface (i.e. ifco=
nfig <ip> ifconfig eth0 <ip-addr> netmask <net-mask> up).
But in my network driver I am getting ndo_open() call immediately after I h=
andle the probe(). It's a wrong behavior, also my network interface is gett=
ing to UP/RUNNING state(as shown below) even without any valid ip address.

enp1s0: flags=3D4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 00:22:55:33:22:28  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 252  bytes 43066 (43.0 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions

What is the change required in the driver such that my network interface(en=
p1s0) should be in down state(BROADCAST & MULTICAST only) after probe()
and ndo_open() call should happen only when device gets configured?

Thanks
Arijit
