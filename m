Return-Path: <netdev+bounces-10402-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C968272E588
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 16:18:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0145A1C20C77
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 14:18:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37C5438CCA;
	Tue, 13 Jun 2023 14:18:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217EA35B39
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 14:18:52 +0000 (UTC)
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA734B7;
	Tue, 13 Jun 2023 07:18:51 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35DDOOtF022966;
	Tue, 13 Jun 2023 14:18:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=YKOzs8fk894zKw1UB5aTd4RrTsR5bIJa+DOryMhWWxs=;
 b=3vsydy4C9PoG2cEAalULYEgWp3X3gnF073e/mJWbKhOQNEqd3KO6HodjHkNTN6GpDAbH
 HPn4JMqn/79yN3NBs+WGELpr7qkCxaiaP3mkkzqVIlMwlscFBaYgQNltW8hdBZhBQ7uR
 kdR2Qbr998aC+C5uWDvzyDw83OomeWPeJQzb+TIjc5yic1WV2fTTiqbSITrYyHa/5uA8
 +N1C7RKIC0/wkn/ufaQkatFTJO5bpyWEa2tNhmUMvMnBkc79pAk6ttPgE4KngUtDN4gf
 wWCqEcISvGQ4v3RrCuOzOw22fqEJzwd/RmQmtmRXqQT5mHgtPiqmjPWodpAUHj8g9tks 1Q== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4g3bndmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jun 2023 14:18:35 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35DD4vn8017795;
	Tue, 13 Jun 2023 14:18:34 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2176.outbound.protection.outlook.com [104.47.56.176])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm3y8gu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Jun 2023 14:18:34 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SY2Dwhd09pNzNHIjn2EBNgXH111IaSKV2EldFylGoLaCRMjsCQlrptrS6Dr+9Yruj0IoZ184DdkpMoSu2LUIxpdvnG6MAB7K3JKPfmNnHyeUqcip+XTQjzHxNMnw9q25OwFCoX3ke/ENqy2gn6aC67bDmU2JEWnGPfNwo3CLmBs2lGUeVGAABngeiDysM0zfBidAzCfcGa9yuvj7X12J5PEGcCOeS0SNoxKgNbO+YYpf98v98WGhxW7JGU1LA7A5SknoSwHaa6/OMVaQ5kLP60wndceAiA6C/CsdJjvtzPW54FT6/nPV8GjXhZCNoUsWUeJrJbuh91dBhjgtA4DWnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YKOzs8fk894zKw1UB5aTd4RrTsR5bIJa+DOryMhWWxs=;
 b=ki8b1/1IPnkBurTjVPlMqRxARp8RDHu7GW8swRGFbnlW/xUGYdnKuLpvcmh9k11el3Ujysg/3ah33wTrDGHaWu3ORkKVgXUbxj62DzwWa53Dmn8l/FCLUIgXdn8CwFPXC8FJNlswPFj9iSMtiSCbMre4e/lqbzV39Nv3JDhXIfjZR42QpK/75NqQdzZhntEHGum6JaeHpQjo0lzm23LWgZpR6zUVGKRAanQLse9qZkUNrrAlUFZ/c7s5OhnFT+ihkr2S0D/MYOzQKd98Ct917YK79X1hEjtgrXoG3PrsV7S/Aqgpe6OF8ITdb6S9fZhuM2y4pcNFjGuJ01a4MPcBmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YKOzs8fk894zKw1UB5aTd4RrTsR5bIJa+DOryMhWWxs=;
 b=OJ8CNdsJupuoZZv1fWgannkVgw7oLerdjCpKs874oopcZw103xNAQVPOUEjNaH3vWIhzkEqATYxZnHiJfjwfgEnMCl54QIW2w1vufGBgbrEK41G2ziFojIJ72Kk3twcf5R/2v5Ht7CLtkWRK9Bz9mK5Cb57738LagyDTiqA5/5c=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by SJ0PR10MB5648.namprd10.prod.outlook.com (2603:10b6:a03:3e0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 14:18:06 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::ecbd:fc46:2528:36db%5]) with mapi id 15.20.6455.043; Tue, 13 Jun 2023
 14:18:06 +0000
From: Chuck Lever III <chuck.lever@oracle.com>
To: Azeem Shaikh <azeemshaikh38@gmail.com>
CC: Jeff Layton <jlayton@kernel.org>,
        "linux-hardening@vger.kernel.org"
	<linux-hardening@vger.kernel.org>,
        Neil Brown <neilb@suse.de>, Olga
 Kornievskaia <kolga@netapp.com>,
        Dai Ngo <dai.ngo@oracle.com>, Tom Talpey
	<tom@talpey.com>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        open
 list <linux-kernel@vger.kernel.org>,
        Trond Myklebust
	<trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        "David
 S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] SUNRPC: Replace strlcpy with strscpy
Thread-Topic: [PATCH] SUNRPC: Replace strlcpy with strscpy
Thread-Index: AQHZnY+8OIo5sIDtZ0mcVtupqKlOma+IyJIA
Date: Tue, 13 Jun 2023 14:18:06 +0000
Message-ID: <01E2FCED-7EB6-4D06-8BB0-FB0D141B546E@oracle.com>
References: <20230613004054.3539554-1-azeemshaikh38@gmail.com>
In-Reply-To: <20230613004054.3539554-1-azeemshaikh38@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3731.600.7)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|SJ0PR10MB5648:EE_
x-ms-office365-filtering-correlation-id: 623ef3ce-2bc5-421d-499f-08db6c19020a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 obX7bmRUPu1+5OIh+3GCgeLK8sjVs5zaSH/xNFDDzevHOE8XgV08sX+RIkmwXOsYLQWI3ANII12XurDdBdXNIIk39iwbBHMujzvkpZbAoU14GvzxzoVUlEuxV84hW1P67WUquOal/JvbHZPGhlMw8NUtB/lv2f14FHLPQhaladnB8QYFd2h/1f0qPzjXVBCq5Tegc4/lilN7PsMFBBqwBgTm0uktH2kDEYP9UWzMpDKsbGdVcjlVhwUJrsPlQZPjkJyBvtTS4XPrjWV9fvypowDjN8VFDRnZwaN2qyK3hJheIEc7+flfWfWi1u3+9mBY0K9lX2XEZqZ7pgVfMlZhwB6MOt+KZDzbn4ve7LaDjnF0CFdOu/QCGhhyMB7vxNndsa+AZvK4iODfdAT9DNkPbz/R5n6smSXznzfA6De4YKDC+mzloQXAf5PN4A+Vjmb4MgJtVGY7WbQBk8BmjsAn990uY/jWoEg7TG+pkf+9tpg8e5mQiM0dUNeOV0nqHsENUwehBIhHZocVxmLsbP6Ci7XHJR92xDBhK9iW18ShfbfJDqCqzSWdhavEAzWbKF7DZuhVkcXo892t4ulichIeCpg8ODUXS1hDTpqLVflvLV8ivz93gXwnNf7wnqg4O02UFJ5eCbhdUCZEHTNxZaXu/LqQrB7inpecxynRSbwPYaiEp33gJMCnEx7EIHBUT2Eh
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(39860400002)(346002)(376002)(396003)(451199021)(83380400001)(2616005)(478600001)(33656002)(122000001)(38070700005)(86362001)(38100700002)(36756003)(54906003)(71200400001)(4326008)(6486002)(966005)(8676002)(2906002)(8936002)(5660300002)(7416002)(66476007)(91956017)(64756008)(66446008)(66556008)(66946007)(76116006)(6916009)(41300700001)(316002)(53546011)(186003)(6506007)(6512007)(26005)(156123004)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?us-ascii?Q?UfmfmnkVQCoCNyif9Ylw6WUlyZWqA/Ynjw6kfGdHaDEj9kxhDaPufujsTd89?=
 =?us-ascii?Q?wtYGDmAQZE5BKQIHDX9ZILtgggp8/fU1psG9rQjTkHQBJtEXSY/vUobDBABF?=
 =?us-ascii?Q?s6F59DujlAq1rNkGKG/WG8ndg8OuXPbBxKUabDh3J+yTc7+/NPSYx2BpIGhr?=
 =?us-ascii?Q?ckRrqnkwKoyI606J9ZOTh36VIR2YPlfouVE2VCnnd7XXsywxyqb2eAi8mWUW?=
 =?us-ascii?Q?07hS09JczXdN0pgx5Z7+kIXTh812v6EeQgiXIb/o1EES61BPx8BgSneWhtzf?=
 =?us-ascii?Q?hP7vjLxR2yYmSaQOm61UhCL8Mi3SXEPuiSapbgG2b/XHivwwB3awAMHLKxVK?=
 =?us-ascii?Q?8Wag2lB7pH5yhwtpKgHrMvIqYirlRkTd7zcnF2m+v60qhJ9XX1tpGcTpUYDL?=
 =?us-ascii?Q?g5F9CrsbjSmxQNHoNI3T7RBfXdOm1z/DAuNXiWqMz9lEY1cAqTKRC9YsE+v4?=
 =?us-ascii?Q?wNaAaau/rJ50m/jZ6YUpr7rx0B3qWT9iYmPjimH+/z0xlZvrAnCtXlfQ5mzm?=
 =?us-ascii?Q?E+4Ta/EMxnp5dRy0/dgJG8xQNUA9ZEktQAXlE2iiyPPzIkjQ8yHenMuAGyzk?=
 =?us-ascii?Q?eU6gJc8AProG+8gXEkiy8obkCQJkiTxBFUDwtU3M5a8YJfGZf3VR5xWZp/rj?=
 =?us-ascii?Q?tNw+p1780H4+SQzwUhAWUDKBbxIrjaw3AxdZjpAlhTAiny9krV+/4PpUUUH3?=
 =?us-ascii?Q?146tL3QBgHJLL5HZ7BLd5uMTGYFUngByVuee9I9Hk/1CiGqYn4nijxPieLTx?=
 =?us-ascii?Q?K3wD4Pq8AeR7GeI9U3nj/rofVkg5u4QMSw57tXcIo01IKXdAZsnFnKjfP5iN?=
 =?us-ascii?Q?liRuAnZnzLflUBDAlK37YHYMXMnIE6JiMGjAhXB1jIQslf3kSbiog/bSa6Fw?=
 =?us-ascii?Q?FNK9ian+WvBDv+93FIm0Rlr27Vgm6X+z0Q6xmMLjW1eZ5eJq1eFoymrIVSTn?=
 =?us-ascii?Q?HhqAKdUtR2UW2udVDj6Zvb20xRPKaGEwfHOr7NKrkOgFJx9TmAo2KjC1AveU?=
 =?us-ascii?Q?fKJrBN4Adp17dDbClD9CEF/rPp+HyJ6PkwI2xOWujH3tGcr43ncLBFkNXTob?=
 =?us-ascii?Q?qDMFhmH3rwo12ydDicHKbE79YgC5CGO10hBYIlDyzlnyjyWFjpcwHwTx+2ai?=
 =?us-ascii?Q?uL2nbG7P+SI5JrMaxFqSkQS9aeIzj5CwuGJuB/tA+gJmF4v53XhAxItGdOKP?=
 =?us-ascii?Q?Rt180MZ8SBGTaS34c1mAupqkeiMLr4FANxujIp+OxS/GpyNHELmDxnsla4R7?=
 =?us-ascii?Q?DCseUIpG9z7UX1dN5PTRb3rUsUbt7Wsqfo61Iyxd89W7Rv6g15lnZq4awOUt?=
 =?us-ascii?Q?VLGG5vAjXnZ+W5qxU1YoEkd3vkfXJONfI8WnK8OVSSfkP2kg5AIiUlWAAhFW?=
 =?us-ascii?Q?gtGmxnw0SGgcodkimq/B850YQKp0MqUJOaoghrRn7qi1IXCiQX1ZEs+D3SuL?=
 =?us-ascii?Q?fq99SE2nyfTcOY0dhI5cRahjgzshBv6YHm9mT9lAiZAMvHiE/XeaD9KdYJau?=
 =?us-ascii?Q?6dovqQjdK+0UUhMfPboT8KIQNdl0YAzJTnKJdnucoJyItQTvc+w9xzWaLoLi?=
 =?us-ascii?Q?wuV2O8nO0y2imO7rvRvtaTqK+VxsYrTzQ/1Jpya//aTEZmHx7eZ2RBMQKFPW?=
 =?us-ascii?Q?Qw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <B798B6E3AD4F7F428073BFCB361065F7@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?us-ascii?Q?hcUjxnht/JgLWRDP7vrlyZ+XD6xYDjcJsiADXGx4YjE4gfSlEEmQNIyo2fee?=
 =?us-ascii?Q?M+ZtkDSGlTLBNXXzLqazpiWiSt30ONskq5C9Ungo5o+LTAsT0N9SqkZiHQOJ?=
 =?us-ascii?Q?V52nSP0Vq7xVs9+RmtZMcw/PK8UTcPEHZrXDcDbPRXYU0wRfjPN96vRmW02N?=
 =?us-ascii?Q?jie2GYCNRQkAU2cUxOr+MjgX83xVKiwlcS1T8h7C5JRrY+AWj84R+GI+sJof?=
 =?us-ascii?Q?cGTmdU145vnXUaPa1E57UolrRr8p3pNUCTBCnKxzzlp7gtfkgfkpMo24Xm7/?=
 =?us-ascii?Q?ceqd26+WjFDxu7FY9h2xaGpj94nmMTY9chq3P+EfQwXUXhmk2uUYWMf2HPB4?=
 =?us-ascii?Q?Latme/RJA9bkCu6SdheC1lLL1kEzlQdUCpG15iWlmosNrEbWM10oIwwqFMx5?=
 =?us-ascii?Q?GX52X/uB1qZM0Cuy6rpWmh4FneqmDIgI1D6jxgRPBbCOqq3sd7gLX6fa5Qd3?=
 =?us-ascii?Q?zuFvBvwo36r6W7F57g0LDtv89s3TgA7aXVq433mDJVKF4wLyG6tRANJPNdN9?=
 =?us-ascii?Q?nA4oJ0gBwY8As5NjY7zOUsUYaktZeVjqiG51i7a2FiFwUx1o67KP9wfVu+1X?=
 =?us-ascii?Q?ND6Yv8FedtB0tCq+Jsv1lZ11fsjllCf9MjnmqgA7r3NX1OstyrfiMn5r1EP+?=
 =?us-ascii?Q?3gKBnL7/r4J9ANhfcn71X7tyZc4g++GnNofsIu1/hMBl9L5hNwY0LRAuEQcp?=
 =?us-ascii?Q?aSvjuti0Me5rQkmdYkHTVjQR0P5Hra3l98a6sDH8iMpTFzIMoj028unpZ1CK?=
 =?us-ascii?Q?y6pK5hJzhSUDkmJkXxgI+FvcklquxgDbHgNUIbZ7SHo921jU2jABULSRKW65?=
 =?us-ascii?Q?IRnG7c9CB7tcRPLwHR2yVl/iZkpagVagVehl1GLoowSUHaG7UwL0qab3DAZg?=
 =?us-ascii?Q?i57U09vUngkbkwOy++mZJ5HFzMSZAYG798KkPmOpBMUklIyXf0krByajWVkf?=
 =?us-ascii?Q?NBRS8h8br5r/+wThoUMAu9l+CCVepBmhXkSi/Z1HUsKh5/lkKl2ssAQ77QRG?=
 =?us-ascii?Q?Pe6yiUmQnvZZdMVgmX3XJ0Pl55CPr8oRgQmvFQPDdz8JGUc=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 623ef3ce-2bc5-421d-499f-08db6c19020a
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 14:18:06.7050
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2svvyhEJ532PJuqm4AODuhrnMLtntHKvQko7RIxyqEL5zREMBcN3UmG7RPn2+vaK6MrlRQUx9JR3WBowIFJDwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5648
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-13_16,2023-06-12_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 mlxlogscore=999 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306130126
X-Proofpoint-ORIG-GUID: NJKdNEoMK7z0MN4rktM32Yw2R1e4rTKa
X-Proofpoint-GUID: NJKdNEoMK7z0MN4rktM32Yw2R1e4rTKa
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> On Jun 12, 2023, at 8:40 PM, Azeem Shaikh <azeemshaikh38@gmail.com> wrote=
:
>=20
> strlcpy() reads the entire source buffer first.
> This read may exceed the destination size limit.
> This is both inefficient and can lead to linear read
> overflows if a source string is not NUL-terminated [1].
> In an effort to remove strlcpy() completely [2], replace
> strlcpy() here with strscpy().

Using sprintf() seems cleaner to me: it would get rid of
the undocumented naked integer. Would that work for you?


> Direct replacement is safe here since the getter in kernel_params_ops
> handles -errorno return [3].

s/errorno/errno/


> [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcp=
y
> [2] https://github.com/KSPP/linux/issues/89
> [3] https://elixir.bootlin.com/linux/v6.4-rc6/source/include/linux/module=
param.h#L52
>=20
> Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
> ---
> net/sunrpc/svc.c |    8 ++++----
> 1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
> index e6d4cec61e47..e5f379c4fdb3 100644
> --- a/net/sunrpc/svc.c
> +++ b/net/sunrpc/svc.c
> @@ -109,13 +109,13 @@ param_get_pool_mode(char *buf, const struct kernel_=
param *kp)
> switch (*ip)
> {
> case SVC_POOL_AUTO:
> - return strlcpy(buf, "auto\n", 20);
> + return strscpy(buf, "auto\n", 20);
> case SVC_POOL_GLOBAL:
> - return strlcpy(buf, "global\n", 20);
> + return strscpy(buf, "global\n", 20);
> case SVC_POOL_PERCPU:
> - return strlcpy(buf, "percpu\n", 20);
> + return strscpy(buf, "percpu\n", 20);
> case SVC_POOL_PERNODE:
> - return strlcpy(buf, "pernode\n", 20);
> + return strscpy(buf, "pernode\n", 20);
> default:
> return sprintf(buf, "%d\n", *ip);
> }
> --=20
> 2.41.0.162.gfafddb0af9-goog
>=20
>=20

--
Chuck Lever



