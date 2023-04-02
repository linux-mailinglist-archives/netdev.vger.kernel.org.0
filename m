Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CBBF6D3544
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 04:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjDBCco (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 22:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjDBCcn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 22:32:43 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B512EFF03;
        Sat,  1 Apr 2023 19:32:42 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3322TTfC022478;
        Sun, 2 Apr 2023 02:32:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=pnjSCyvZgP/srAG8csJoe3EgO3dgSE2hqwLWkppwOsI=;
 b=RU+rFn1p26ywRC1SdHzzotkxtfZP1iIO9kaDnqBpCbCj4syuUvNjj39TO8c1BDvdKszv
 4Rg7/k87Il0lxDtww6ni1kIEJmg1EedH4DDv32gRKJ2vZE5vmINzkkXbFiys3/s1cuPR
 wHnfyGBNnSAJnyhPe4gxErXY9GRC7uunfwlII3wlzY3wptcLG0ITyDhXiE/FzRdxZKO6
 7GRfjs3sHyWSZV5blggxVKUcCUrmunneeW3odRQxfIp6x4yOA8WZceAvymw3a3E/2INg
 sQJ4UEWvSGldzwDXWvxXmhHpnj0++HLoyp5A315u7iaBz5Itlv6vRGH4f3yIDF8pxIt3 NQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ppbd3s1y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 02 Apr 2023 02:32:23 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33216ASh017881;
        Sun, 2 Apr 2023 02:32:22 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pptp3hgch-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 02 Apr 2023 02:32:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=h0vwOj5+Y7BwD4SFYDPGhdmVa/1sIxAG+VNWXHAXcQZV8bPi7ZApofqayGb1w3Nk1iNq4+LR0Nwmt6Ri2vTGSlgt6Zd7KO5BkLII+0yfGoHiNchyz2VmDONI+q+OWIfcumV9L/ggiSIHXtrZGHKHaT3K8SV5R+3yTc0tZd1HGhV5OJfIhIgOprgXO0nwMGQYlNsXlagmgKbidQnL8MHYqEzBxcR1/lcW03D+YLahS6DJU2QjTnOkwvUMzHMomAfTyHeZ8InMuVrfxsUEN8bnZd7x65wWFuGLT3HF5d+VYw8qgfXDxXuqYGZHcd5uG9HDZSS0RtJBdmRqVzQFVZz6Cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pnjSCyvZgP/srAG8csJoe3EgO3dgSE2hqwLWkppwOsI=;
 b=VCeUlrIKDTZelFelpnO+04GIZn07sbKaZ+njHnJJagBms/qX0/hmR45UCsBtjvtTrRMSXqvwsMWMfvIl3PbJJ9/yS1cQb+D65E+RqHXLBesCSGOGbWXpk5kos8AKDnxS/kPHwXSABRbPj6GHYyQghNakew+UDUVpgtevz678ABjwScQ1DeiYmB+j+2Pagsi4pVTp2K1ZD8YprFYGKgrqTTwGRM2dW6/KsY0pasYs6EP1XIPl9gdz5EZ1ygFKeDuS+9DW/KTlhJ1Wv244ES2mYIcm+sqg4csMJb1ahX6CjkFOkHmMJe6kUy1J+czJ8Iv0tzStIRZnmYfV1A6VF8H5Vw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pnjSCyvZgP/srAG8csJoe3EgO3dgSE2hqwLWkppwOsI=;
 b=C7EKnGR09wOI4GDSOW/Pj2PFhw4GqtHpIjxuOGkjKP8wOPOzd/xcc2qBG/CVGPYqCbjcFRKzHQ44wqpxcW+TUQcM5kiRKPkueVyMr85wQwQmpTsfvI5bjfAhTi8WigYAH+pAdv/qdLuxG6hI8+w8BqvovrWJzBi6T6H1bXyyG3I=
Received: from BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21)
 by SJ2PR10MB7016.namprd10.prod.outlook.com (2603:10b6:a03:4cf::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.26; Sun, 2 Apr
 2023 02:32:20 +0000
Received: from BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7]) by BY5PR10MB4129.namprd10.prod.outlook.com
 ([fe80::311:f22:99b6:7db7%3]) with mapi id 15.20.6254.028; Sun, 2 Apr 2023
 02:32:20 +0000
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
Subject: Re: [PATCH v4 1/6] netlink: Reverse the patch which removed filtering
Thread-Topic: [PATCH v4 1/6] netlink: Reverse the patch which removed
 filtering
Thread-Index: AQHZZCxJt7hHR9OT2UmzMPODBe2VMK8V1x8AgADu1gCAAA1sAIAAevWA
Date:   Sun, 2 Apr 2023 02:32:19 +0000
Message-ID: <4E631493-D61F-4778-A392-3399DF400A9D@oracle.com>
References: <20230331235528.1106675-1-anjali.k.kulkarni@oracle.com>
 <20230331235528.1106675-2-anjali.k.kulkarni@oracle.com>
 <20230331210920.399e3483@kernel.org>
 <88FD5EFE-6946-42C4-881B-329C3FE01D26@oracle.com>
 <20230401121212.454abf11@kernel.org>
In-Reply-To: <20230401121212.454abf11@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BY5PR10MB4129:EE_|SJ2PR10MB7016:EE_
x-ms-office365-filtering-correlation-id: 5474c945-31e2-43f3-bbf0-08db33227b9c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iCCS1XP5fnXeE9vB0z24BfKQt50MKeWmp4rgGfW7LTfn00u1y/DrUKdeVSk5QSDQkh2OQkagWLlVgLxzhwgodwElIMF9NBH1yy7wAYT/hw+rstf62O3qNBdzlxayjly8eZtjjbwGND4RKty2pvwBTVo5HgXa4NBnnXhvjbvQzf5G9y3dePt9fLgDniClmhTN5NArRfDFvETS0N++aVcwbsSrLoPk8XdzAPxtoSLC5r7OPjFsceK2H7Qopd1bvFxm4C6D8DXfWYbipDHDtFod0PTp3BlnxSbdNh6v0OYuc54HjGXw+qtauuo6BesCOWPsAjCcdbcGI7FzJ/5dXocfAz2WW471ENzhXivoXFo4nx7/K07IGFmI1UvPSqq7pw2qxguCTM3MGOhCUvOeits98UbW15LMQd8r6D7AMB4CxJVbFvp2gVvH4jmAktNlKHhFPVHNyDZ/bvxcwfxHbNO/Lhhw89CWcvt+BFF0VGJyfRO2Y/t3Z41Xym57BLUOSYarX9dZQtDwXEQHNSbmUZ8I+7BCbdhO6UT6jWGE+h2pAlpuQm40+y49JVmxpUWTceISD+o/isC3pPv5VQdTSlj1VzeyTuO/cgwyb6aEGr7IwaTtxhRE8216l2dwzVgUKsELOcg9ph15FN5AF2fTS3ffSw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB4129.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(346002)(396003)(376002)(136003)(366004)(451199021)(558084003)(33656002)(86362001)(36756003)(54906003)(478600001)(6486002)(71200400001)(41300700001)(122000001)(8936002)(66946007)(64756008)(66556008)(66446008)(66476007)(76116006)(8676002)(4326008)(6916009)(186003)(83380400001)(2616005)(316002)(6512007)(6506007)(38100700002)(5660300002)(7416002)(2906002)(38070700005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9REC8VqGKCMUYSFbofnSmZRDG+QON4Ho70ddGVL8yvda9fCONSAk9T+G78BQ?=
 =?us-ascii?Q?d3ebitJv9WMOxb5xOYUlFeS9ax1p7sAqb9AwzCCm4e4ul39wxCD2dRcihzDZ?=
 =?us-ascii?Q?nGCVtG+qhB/aIP+qOvkXnm0SwVeA65cMLqNVHWV3LQS8L/hgEwPtyooJWUbw?=
 =?us-ascii?Q?6CpY8TSdxxCSL4N+5ROQpZPgKnkh/gAEkb8zi5itRTB5HYSj12lm8P3h5pBJ?=
 =?us-ascii?Q?GDrZHm9s5BNmSeISz1uaASXxTVEFBCP4qhkNCXEr0WNleNvdu3JI1X6Yl16P?=
 =?us-ascii?Q?9NYz6eyYQtKeS0kjKRtdWtBPbqBhABQ8sX4KKd3BXWZ4r8S01dalVAU6+bem?=
 =?us-ascii?Q?DYd5DOJGhVcU42Otu0DpfXv17JwU8pj/q/O7efGExpWF0g9ZGeghuhfKamL9?=
 =?us-ascii?Q?xq7o3gv6pmPfyC7OIG+ITa0TfNzCPFYVWL8Noxw1bprnrhInN2LvkKvFPEy5?=
 =?us-ascii?Q?5GxMQ5rDPCUMRHryT9mXb+UrewKe2CUuGQS43h5Jyx1cRONAU8TGCt9UefuX?=
 =?us-ascii?Q?CVj5hGdagAqMZB5NSZILtGVQxFWdYxOPE2Bijsr+hvDOXfyZDoM2WZHiLrHi?=
 =?us-ascii?Q?bDnM2x2z4wnotSRkmVF2dOgPDRQs2pnhwdmcIdfj14mhXhi8H9hbyclwkn40?=
 =?us-ascii?Q?nKirrMSmpIi8ztyz42ZlTHyw2Y2OMR0+/fERJ9GfbwXvZ9aomXPmpOhjA0GO?=
 =?us-ascii?Q?hgC8bcTuxoCh7HVE4z8/hRibdhUvXdo4+ux0Xu1cSdfvUqhn4qJsQrHne9gd?=
 =?us-ascii?Q?CbkILo5q9SqST5ZfFG3H35P5wkmbJGDSbmvReHrHC+qC++AMBoVe2vPfJda3?=
 =?us-ascii?Q?lvNdgbOMrkSBOp7aziTfy2hS1VaDjBqTM2Sg3mbSirEHa757VWOlC0pPz7YF?=
 =?us-ascii?Q?7YSlEdOVmTDwZd7ynnv+EFLHqsT1x3hHtiF2JPXkSOPSRMu4eeYFgOfGMEm9?=
 =?us-ascii?Q?/kRloCaNA3Yefjj7etgqYgx9tyRC6gCk0/+QqXALvZ4l+dmUuOWJ5kv9KkaZ?=
 =?us-ascii?Q?F4Xtr6sCWI7tPZPX/1YUxuFPrRdL2PV+OBrXDymUSL0csPOTeaR6xFolb4ED?=
 =?us-ascii?Q?Jeq/nqwfXXzIKLER/ncEgaHqqEGD+Y1KC8f0jOf5TagkLA4uWND+GRpaWRvI?=
 =?us-ascii?Q?9RJNqRK7rxscAkbGjTmcTckFSbr60wJnuWGvywxbgYe2xDSQFMTby1rELMR3?=
 =?us-ascii?Q?COIsvsM3i7sCeHpT7RpyFZK+w14h8Ej3lHmdqCwwDxpT3K1BJ1SASfY4pNSW?=
 =?us-ascii?Q?Keg2FmiIMoaHVlg7beqCaaAG/4JLNiHaI7r5i+Of0OXK+17/Hq/g+imHZd9K?=
 =?us-ascii?Q?DOJbKOTUcBvfsGWGca4URS66iTNpAifqUPuuwqbtSfQxHG7Pru/S3bVbp5D/?=
 =?us-ascii?Q?iiMicg/MoKTZJCPrzIRHu+u2Vu3thpaO7vObWoeorUeE10/bdbChW43U4MWI?=
 =?us-ascii?Q?x0eEFJ3trRF5np5UMvOLQWZmPqqMluWJ1ZH3ER9ye66mvv92k2CfdVodSpVl?=
 =?us-ascii?Q?GJc63WJqQsjeKJHmpS11UmYX9MuJGdLQ6ujEzAO71K8an80FptzcT4vqIY9F?=
 =?us-ascii?Q?PpfBHTb/hX+nJYjvfP/9NRIPd7jcQkp+CorY61ykRlDrxLy6dp+LCSUf4wVZ?=
 =?us-ascii?Q?puCarMaxnFDZp+1rG2ht+pzVmoOmQvplVsNUc5cLRBk++IhSUtboNVe9xFf5?=
 =?us-ascii?Q?i2HXjCZZ/3vvX338cLZNqv9hTSc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6921ECDC4EBE984E8457BCCD5C63E50B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?us-ascii?Q?uzI6lomkGNP95GCL/VPHxDSSD2k3I1M8zgEhEpK0Gci7tSHUrXt12mMyNS8z?=
 =?us-ascii?Q?VEq7uZCSmXbD4I1ISZFITYGcozAR7d3JhfqaxI6IppFK0LtWdGjTenx+raXO?=
 =?us-ascii?Q?2rH+t8M0wc2HA0iKfOCawj/42N2hOky01QyHwSHWbBSMdJ6izTX8G3yQPhoG?=
 =?us-ascii?Q?bo4ZDkPCsCeonps408J0uSCEZZYAlQGOxqghHHcHeJV78bBc12A7tnfYPF+d?=
 =?us-ascii?Q?wSVbs7R1JmQhw5WXUpUcgIcOfkGGnIq3eBX8nj/x1S47d5jIHWofQ53lbg0A?=
 =?us-ascii?Q?gcy/dfXHmgecqT8XYe23Mh6hLQRFo8p2UEHt4jFNlGt4uWmgPZwhps7Llhyd?=
 =?us-ascii?Q?JugMVJWBun6OOZKRS0POAsj8wp+utFE9m1Xw3OID+t4wYCsUlfurt0Pl6u98?=
 =?us-ascii?Q?/ei78zocjwhcFYCcj7Qi7CKvxJ3xih6aBlRn34aDilKBUlEclORN+Kv3SF17?=
 =?us-ascii?Q?Lx4s8k/wujP6Nfnnw0qkPTELnSMk2sDE4+rORkDRCfcT2Cz9YNK8YTVO5hfR?=
 =?us-ascii?Q?rV1SEIQ28S1FwHrHuPN6jQRHmulNHtmSmwcoZDqCGwmXgyR+7mxPzZ1PN+4X?=
 =?us-ascii?Q?wg9BMf2MTWjPVcx3+d6xcS7at9goaY3FWgTa1SHlEA/6Vf/JOZXxNa2p43X3?=
 =?us-ascii?Q?UIf/8TZkRhpS4KTvFiX4wqR5qMSoiwqv/GNivU9+T0NddAvVJFs9jwT0PTj0?=
 =?us-ascii?Q?bWQGQDCoXbLQ80DDzTBuDuYT+qmrMLHZGKkQwfLuxiPBIlIWkzt0W5Wgm0Dx?=
 =?us-ascii?Q?ITYoI3N+aJKZEaU9Of+NukPRiCvmDPH94zsyvpD9sCTo8iti/hafDMipeRCH?=
 =?us-ascii?Q?G77+zBTe/HPeEUiKQRYDLRVGL7QxJ4XYjK3E/pXYGy0uO+oapE9iQUVV3d5x?=
 =?us-ascii?Q?2cogWr69+0n4aQO9RxoLrixPzsxGie5GJMT79b6Op0EFap83qeTYabW/i/ap?=
 =?us-ascii?Q?lA3/NGjVzx2UtEZrXP9qw6fLEuVeC+lin6wVBzwHl75+vmm43kXt8Ibrm9V/?=
 =?us-ascii?Q?14WL2gvWKATHZioVhYxeXEpNMovlaZpthoN5KZV4JV0LGFv1tYrqXaqMTr2T?=
 =?us-ascii?Q?kOF6N9x0d6ILjnbWQTekGM6LjpFkFA=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB4129.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5474c945-31e2-43f3-bbf0-08db33227b9c
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2023 02:32:19.8752
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4wHEaDk1NtX6FX5y3lKBcjoAaeKFMc4A1EtrmTlvpXdbJNTlFl3tU0nQGMh/O7yEy65pBmRNLE1mEuEZKOLxkvMoLUnQdunkxM4bbNaT6Pw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7016
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-31_07,2023-03-31_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 mlxlogscore=836 bulkscore=0 malwarescore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304020021
X-Proofpoint-ORIG-GUID: EOYnUgj53eBhHZAhY-UIUEo4xQbxt1nq
X-Proofpoint-GUID: EOYnUgj53eBhHZAhY-UIUEo4xQbxt1nq
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>=20
> Who are you hoping will merge this?
Could I request you to look into merging the patches which seem ok to you, =
since you are listed as the maintainer for these? I can make any more chang=
es for the connector patches if you see the need..

Anjali

