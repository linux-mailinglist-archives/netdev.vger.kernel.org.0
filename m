Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3972D6D2661
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 19:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbjCaRBS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 13:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbjCaRBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 13:01:16 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8077CA39;
        Fri, 31 Mar 2023 10:01:12 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32VFOAku009672;
        Fri, 31 Mar 2023 17:00:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Lgx5C5eBCpp19H4dr3kzO+HxlZm76GrUO4g0HlZ6hjM=;
 b=DZsfZHUiTCDQwrXoyo4cX81140Mi0CyY/hhl9whBH9gYJxBPtU0kcuYXgKgko9LoKD2v
 Rxg1C1QXVogsnTFcSkp3uBOlPsfSxsbEun60bODNF9/tIZHJItaY0ElTxnpL70cufQX2
 D24u6KIs6ZPzU3bwRJKkvN1zVOdyaSQMfVZYjp1vgBoRD40T/R8m7Pmt+aiqiqkKn/f1
 9LtpVHQnMZ2z1xMAVpZwvnwUAxZ7cbiJ6eXiwTH5tzWqiygAlafZc5XKG6n/umMzt52S
 5klFUdeiwv8gvy/U8kGvgQhgBzgz/e9FulY6PFEYbs9HKSJQUDGRxn81z06qAgcx2hs0 Mw== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pmqeapd70-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 17:00:31 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32VG1RqN023398;
        Fri, 31 Mar 2023 17:00:30 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3phqdk6574-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Mar 2023 17:00:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ch03py0m9CeqHM7pwoH6eU5QXx+v2TYiaP6wcy0M2e61gqKB8EA3V1TIhYx8Z8iOi4mClCbFE1k6e87zeuqKvYBKM6oIdiptWiL7F/NYovR/CKW8dVfz2L83SQohRylpbD5jJwtIauU02BWO5rzntrKu4l5F+Ao6c356O6x/3ZmbulX7v3JOPfz6qtp56y2+f2edq+h3cLSoZZXBwufGBmWpdm7/T67g/DblKdeNb3wjBDD79FlY9cieMRhhkQgSHvv7bzeGXQLIwdUmgfRPouqZAs9iOFteqo+xiSP78PtFMn3EWvtSDuSI0bVhy3icEme8hKgRqLa93ckcqCY2LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lgx5C5eBCpp19H4dr3kzO+HxlZm76GrUO4g0HlZ6hjM=;
 b=Lcftjo700+KaiC/nHeNy0qx7xBnm1zMNwGYSZH+4mz8lxO8WnvnTdPLq5HAiMUR0lQ8lL5OSg9zx9S7E7FAQzi4OBvGhcCvXLqXg4Fh8iMwcNI40nwwfhDYG7LhWvr1POLpLm8lO3E9KM6vvqf+v905xHTN9AAWeVXBrR7xvz0ntay2I/gqQFY1Wdp3stbaoW7gvNQdkbO0HZXlg/M/7uI+ArtaGNaU7lAeqYLmNXAlY014bWNjXZTSaqwtCLmpYn4gxGJp3H8tLnskQar1bS1qO/akpvo9ynV0Ro0PwvWcO0dBD+P9W8lcTB7J0BUvNH9C23Ax85GOqRMaj6L7AAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lgx5C5eBCpp19H4dr3kzO+HxlZm76GrUO4g0HlZ6hjM=;
 b=0EnT3BjdrP8XzhJKOlDWVUzgjdcrwlqrbkG6FAmnj+J8Tipiw+QbQ29HbVvhv/iMQ45gViApBEA4DRUCgRs9cdTe06Vw1OKky0TT04sDJmt9a9TFB+oxZ+D6uuV3PCRhdQOLK0G/IGV79XwHrBkBluoREZ6S34r48JVkmJFlEiQ=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by PH0PR10MB5643.namprd10.prod.outlook.com (2603:10b6:510:fa::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Fri, 31 Mar
 2023 17:00:27 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6254.023; Fri, 31 Mar 2023
 17:00:27 +0000
From:   Anjali Kulkarni <anjali.k.kulkarni@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "zbr@ioremap.net" <zbr@ioremap.net>,
        "brauner@kernel.org" <brauner@kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "socketcan@hartkopp.net" <socketcan@hartkopp.net>,
        "petrm@nvidia.com" <petrm@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] netlink: Add multicast group level permissions
Thread-Topic: [PATCH v3 6/7] netlink: Add multicast group level permissions
Thread-Index: AQHZYmvoV1sxO7snm0CxH2QmxW6asK8UckyAgACtcAA=
Date:   Fri, 31 Mar 2023 17:00:27 +0000
Message-ID: <830EC978-8B94-42D6-B70F-782724CEC82D@oracle.com>
References: <20230329182543.1161480-1-anjali.k.kulkarni@oracle.com>
 <20230329182543.1161480-7-anjali.k.kulkarni@oracle.com>
 <20230330233941.70c98715@kernel.org>
In-Reply-To: <20230330233941.70c98715@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|PH0PR10MB5643:EE_
x-ms-office365-filtering-correlation-id: cffcdefa-b989-4b6b-cfa5-08db32096d85
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: U4uV+JyQwC67dl1FT8zuzQzR4ayyNMchn1B4rlVL0q39KHzly5e9q6Y2B132wQJUCTr7/9tz633Qvw+wGAOE9Zed2Bk+7AU081yEXhRCdTRgqNVuP88TfmKeBwnfxwjPaIbRVWTSPr+43xPIsvHkG4+Hs7yjfqsSL/r7swrscAzhEQ9NFMYfu3f5iqQoPLn3c1tYNEvTohz/JQWmL+wN0zm809qrxmYWd82TSVfP5yhA8vvF2nLvVHWvHFD6pWSyf+TtiGqpnSRwDnFhy8W1SRPr/bzA5lxdkwSgUUZPwjFnnP986OAnV8cd+P0s7AcsEZHEM5UPLluAYTzr/+XkzGVqwlvBJpBFhLnkVsr6GQ5eOrn1zPcSrULQZyLkPdWTy2E0NsSSdJbnPn6CnGubxBt2dfaJFunU67TDbjwAkMchLgSJS9w81xJXH30R2vYRXo32hsfbIQRowCYVS51SQFLbFkLU57aUy3ZkG+/LXi6QNcpBnHN6qcOn7VGByenhiPZ1lVA8vspkbVywSXMC1Jqt3S0U26kJzf0aZj4tyDtxdAAVmfuQZwi5jH6/cGvFZrSSp4Tnxqb1ZZLH95hD6x/Xz4RHmtDm4J6Av7YG89lRRHkamLnbtMzoajhUieXcc5JYfW6azoKtI8M8L2u9Pg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(376002)(396003)(39860400002)(451199021)(38070700005)(2906002)(8936002)(38100700002)(41300700001)(122000001)(5660300002)(7416002)(4744005)(33656002)(36756003)(86362001)(71200400001)(6486002)(6506007)(6512007)(54906003)(478600001)(2616005)(83380400001)(53546011)(186003)(66446008)(6916009)(4326008)(64756008)(66476007)(8676002)(66556008)(91956017)(76116006)(66946007)(316002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nHCspz4O836pc0QtXFEXGmbiR/0R3/NMJ1MNNo51wF4zJyaXX+H2BGw6J0u1?=
 =?us-ascii?Q?g//6CeFbcFk2F2r4KMYy9p5yr2QQNgTmrzHGj3DqgxkYWyrTxNZuBBbIEvqy?=
 =?us-ascii?Q?v1Ry56VHVGdGQ0/ihdGChtjkAbBwQ17TgUkfw8XgroAL5YR+3eCFKATkjDIg?=
 =?us-ascii?Q?W/6cK3HKbIVClZ5sWUkAzO3B61j+CYUPUq/uY6JCYgp5lYv6uzQPbcx2yMNF?=
 =?us-ascii?Q?TsGeEw88YIxfI0o1uYZoRCjcSIhmBeoBcsEuDNH31uyhvqqzCs7PzCfkcoEo?=
 =?us-ascii?Q?2NWo3qciBBCUflEHUnBCwSBzHeyb51rsqmJJnnI2HhWqoA2574cNYLYtLTJt?=
 =?us-ascii?Q?9q4weMXa6fJOTDbtAep1E2HtvQcewJQHZWMhXkxSs1leS+vC3Oa4hH8gGGVh?=
 =?us-ascii?Q?5fgNTE3nuFIgLbRCdldcZglmoeQ5k5SBxLldVkOT5NEoHFSBIMWTFfF92txC?=
 =?us-ascii?Q?qkxf9nTxWYillLpf6bMxdMCGWZgrqLZIlolZK/d9+buw0j5z+bwSOI7Pcbjm?=
 =?us-ascii?Q?Flj7T9dzf960j0VFiybInkIGOodorTWmqkF09fdZKxX2ryzBL9K+Ed2syclH?=
 =?us-ascii?Q?MxQ9T5Ot0mUeHDyC3me4HPqIqWhIijJ34DpRI5APfiE5Vun8oEMF28Y5+ELq?=
 =?us-ascii?Q?XWUAmjivru5y3DXg0lz8Oz8eftsi9XA1zLhwsLsNvVwYcFAM5yUtWDlPTUG8?=
 =?us-ascii?Q?gEfzSUYq4zC8GPKzVzw8S37l+qLLiAO5yTo22n6oxhPeRlx66zLDA0OmQbzb?=
 =?us-ascii?Q?HkqLjAnF7pMfCRnQygO6f7mGalK4Q8OKtfhsIOh9a0N87y7Wd5J5efVTKPU3?=
 =?us-ascii?Q?rwl4vFGDhstBVdVUGBkxwXacYc4iOI/mEScNKTvBfHGIOmJUeATfdee3lWBv?=
 =?us-ascii?Q?dr9m8OZsZyQCkMuZkbjVRr3Y1XYluEKq58ymMB/I69j+lmdTOsDpDruy7GIf?=
 =?us-ascii?Q?aeZ27uhk/rqgAQXfSsjx7pKul++oxo9FhvROJtCRI54YOWTF11VvnCGl0xH+?=
 =?us-ascii?Q?GR+1Th+DdgGSKZv4vLkYIH1opOIxI1O25/AOHi9qzaKZgZ3ND+tCQmuJpG87?=
 =?us-ascii?Q?FDMHfAS+TVZdvNstvc2OIpyHZOAQgLcFW4gsRZKEmWYE3A+7j1+xHuJMHUEf?=
 =?us-ascii?Q?IWWQ5as6C+/cd7DowvXqPQLp9w0PZgMtE18YvuRsqqM7YgqQsnnLqilpAv5B?=
 =?us-ascii?Q?SK1oGFrhB84ajL3bfuP3yaxsdzzS8tM3wq8p6+TaKyTGl1oz8bz8RPvi1Ikp?=
 =?us-ascii?Q?akcZpr6KsWy0UOk1madOzi6jTGuqLbgrrU8nRZh8A0i2x33PFrrYPRXI7Hsn?=
 =?us-ascii?Q?Neey4Em5TAyVC+WaTdMwySs0sDVhhpIxqILSXe0CkswJZ8mgQASIs243Bfxh?=
 =?us-ascii?Q?76H9MfmuSKX/Zvy/3BJ804DZ9cozLdmcVcltn4MS9602nnVKwDCSvhylRM5P?=
 =?us-ascii?Q?mnstBtAGfVSvbw/wlGPGcRKNaEcDpkBq+9eq7B+7s4JKIFPrmxduMwJkqWPV?=
 =?us-ascii?Q?N+OKpLyuM4iImX+99cwQjgdFNnwDO3wST/k3HRt7/OlLfofJkksoxXA14CDf?=
 =?us-ascii?Q?xeRhJQUCY9y9adoPXjROYnaep7K9bScGA6/30dg7osMQfdrA/GbTTPFX5ke0?=
 =?us-ascii?Q?jntOeOqwoB62vYSibW3peWu331WM82Q5mH/ZXODpyd3q?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <E8E0DCBC308B8C4FB39AB7F2BA45759F@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?Z3TNmWvQVV0Pq8+eU7owZQAssa8pLK5NRhSfl2JxEMzVGHlDmgqQNeOhrjQH?=
 =?us-ascii?Q?EaMyVjYiKVeBYEIMeJGKZBeGZzUSoZxSTSh9dIwlKhVMab5Ml8hanSJ/Z0v0?=
 =?us-ascii?Q?h29/qT0uzJ33QJCi7y/LHG7d6nlWDKKXqSiAWFb7JmhiEppKyEE/7NH71NCQ?=
 =?us-ascii?Q?RiUfhG5ykshqQmCZ9cITCSMx7kW3D0Oo4GO5MVHSM/iIZIOnt9DNZtt7CF5U?=
 =?us-ascii?Q?pldgID5YTQSJYjSr09pfVOB5HknWjQrMYAgxiLthhjGWzIHqj8UetOSunmbD?=
 =?us-ascii?Q?kZ7hajtT9jAy/UIiv6JZYGksCokXiqdwzzcGPxcptsEWZoP9qcapH8j8exN/?=
 =?us-ascii?Q?lKJX7L1piY7O+HFyjct+SlcE20Pn1p81iU5mUOIVAQfQ+yVBednuAZMIbCJZ?=
 =?us-ascii?Q?6CmjrwPMi7He25MAIYdB8zHA/nsQQC66cxBgVR5s3rn0wzo4YKz+0Rqto/VQ?=
 =?us-ascii?Q?6hU2gSgIpwHxoQxLSzkbPg/fXn9jZ+ARqjiclfyXTUOdh6P+kt4EHOaqKc84?=
 =?us-ascii?Q?TctOesatWmXmoMTGGtzR9Cpbvyhi8YtfdWYqfKO826l9ZpkLj8fyUbholYFm?=
 =?us-ascii?Q?d9OD1qs20iWJOfK4rRPGSKLPuTY34wlqk0u32v3pMymzVi902owejrJt9y1A?=
 =?us-ascii?Q?vVeQNkBR5Iu7RYv4iPz4Tan7V3AsNzJyKnadMOj53jjuw+L8HuuVIo/B1e45?=
 =?us-ascii?Q?bvemEytJvlE55BQjZNs/0EMPGtN7QqIpuckY1uZ34o7FHaZ9e0kiIF68FE5l?=
 =?us-ascii?Q?brXxrav075zLuVlTmBzFl5qx/x5AKgGo+/lgVR7bUjvOuFhaVLCl5pGR74Vb?=
 =?us-ascii?Q?X9bLgUp/APA034fB2/iXgiHpvhs+NTwu0hEUgcNchMefM4KnsV7Yu7yQ0XlM?=
 =?us-ascii?Q?aSa4/V+X/5kZ86Xck1b/s7/LmlWjX6/gjoitK/1b7kyM6eMH/gpDgqxg3n73?=
 =?us-ascii?Q?pxFjs6f9lHEvQvj4jCf+PEAAkgUHSfDtoh/SWc0LkkAJMx0k2lQNXsQI6woQ?=
 =?us-ascii?Q?vYuB7wge1tCoG8G3DucShZ3qAgT2zMXaSkSy2wCbcSnvwmoqVE+A9rtofbj7?=
 =?us-ascii?Q?+1EumZRn9/zpTpF8XrmKAbGDrcCEWA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cffcdefa-b989-4b6b-cfa5-08db32096d85
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 17:00:27.6407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nyi1lxdyut/sa1Il/WbHPhRQTOcCtVwJ44RV7y48kKPEHPqPkrZMU5JG79Qgva9ViCi5+oXudlFwiNTYo/Yb4ri+c5/iRs6aeN8RzigyhKc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5643
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 spamscore=0
 phishscore=0 mlxscore=0 mlxlogscore=924 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2303310136
X-Proofpoint-GUID: cPi_Zkv0W0Iz5Cmn7FUvZK5L-orpqWhO
X-Proofpoint-ORIG-GUID: cPi_Zkv0W0Iz5Cmn7FUvZK5L-orpqWhO
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 30, 2023, at 11:39 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Wed, 29 Mar 2023 11:25:42 -0700 Anjali Kulkarni wrote:
>> A new field perm_groups is added in netlink_sock to store the protocol's
>> multicast group access permissions. This is to allow for a more fine
>> grained access control than just at the protocol level. These
>> permissions can be supplied by the protocol via the netlink_kernel_cfg.
>> A new function netlink_multicast_allowed() is added, which checks if
>> the protocol's multicast group has non-root access before allowing bind.
>=20
> Is there a reason this is better than implementing .bind
> in the connector family and filtering there?

Are you suggesting adding something like a new struct proto_ops for the con=
nector family? I have not looked into that, though that would seem like a l=
ot of work, and also I have not seen any infra structure to call into proto=
col specific bind from netlink bind?

