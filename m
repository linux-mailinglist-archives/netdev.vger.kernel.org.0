Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A856A4582
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 16:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbjB0PCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 10:02:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbjB0PCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 10:02:30 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 686F45262
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 07:02:27 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31RCWRV2029774;
        Mon, 27 Feb 2023 15:02:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=bg0Gmi7ufo6PzzTMF/T0eES/BUPAgJrzfteOvqW67gM=;
 b=eKaur6KtN2cxL8jl5HH46FCSciCiwtXqjh18ndP07iPOw+gkvtbcWdZ5JfyV3b8JcTgc
 3aONC/pmnL/xB4wMUOAPAK/HpPiHq8V89LYaBNzmwOSFKcYC8XJCltSA4r0j9AbX+YuW
 KPKzKt5b082fPGhm0fhTDV5+z+Iw7UuvvxlXpbOkg7Ja3gNMaqWsEiLyT8JP2w0aQgrm
 +FMINnNyuUgzhAz1j13dM2qwOvZDqQomClREqEVOc8SY4E1cr3rtoQEIPkMXBboKJdW8
 PM9BWe0z1Gem8U6fGtqXCTcJ3wFQO0E1ht3DIruZSraUamW2jZmktNPsymxuVQismiDb Jw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nybakkstw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 15:02:00 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31REMZbM028679;
        Mon, 27 Feb 2023 15:01:59 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8sbdwv1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 27 Feb 2023 15:01:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nLE0IHGFwI7MD1+LYk/4LWorpNNYVohvx4YJIS18I3Bk9POhydAMWm+sWyNZXH6rnw3Sa0g/csKhaCd/8Rh/TafBONjRVAtgYgQnLKPMZ/8yOcjrdgKsIwfmYqyXctA50JCBwWmiPXLIaOJWOUje1kYy4NoL5ogYIy9gfLQUlCpnB3EJ+VUiuJT3w5nvS/i/+8Z2AvQOCvasguq9pw+8IAxhfehzPjgvvzIZhbCr93/mnG+d2IHulD3pTNIL0iq1NdlxsWIzqOQs6fZMQu0UD5sQarVE6elsZ6Kn/QQPWS3B3NUQqdBstrUuA9vR2j352+X2myqyJIjh2o3M2ZQ+og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bg0Gmi7ufo6PzzTMF/T0eES/BUPAgJrzfteOvqW67gM=;
 b=kcITUY24K/KXASjsAZH2VT+Kp/qLpuPQkv6RYCSO+9xjRWgyxsLpxAWXAyG94C+5l0gceaJzMF2KLDxL7IKzpBcCJmoZqm41oCUzu5/baz3HNtmovKUzybr5/bn/nSIDyFpU7N1nj3MK0pJD1IJ/hSV0TXRijjHf9PA6OCFr81tU5N+UO6mZvvIYvWvpZZge59fVAkrZ9K8Lc3wysUyLLTTQpXhOdixHxzs6Ey2d9rMcamd4NTEPhz+cmfMzYmP2NSMNCmS2QIFU6wxoNJICDHMI7aMHo+oEwc26Ug+MiTbw9YI52xn8r+k47+DqbKIPsOyMel53xwnkuRHs4l6qsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bg0Gmi7ufo6PzzTMF/T0eES/BUPAgJrzfteOvqW67gM=;
 b=l5hfCPk1Ds1nXKuv+ssGFpWy3fiqb/MIHUKYnJSXmmSTNrG9j3oOB05xZLB8pab1Yz15hOn24xre7fCov3F7xaI2t9K0juAU05LXAQIa61aT093hHDdOFaK0PvhwKigMB3/45PvAgWQ68MHYUENx93XLnQ/Yyay+VS1hjpglLlM=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by IA0PR10MB6867.namprd10.prod.outlook.com (2603:10b6:208:433::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.16; Mon, 27 Feb
 2023 15:01:56 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%7]) with mapi id 15.20.6156.016; Mon, 27 Feb 2023
 15:01:56 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
CC:     Chuck Lever <cel@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "kernel-tls-handshake@lists.linux.dev" 
        <kernel-tls-handshake@lists.linux.dev>
Subject: Re: [PATCH v5 2/2] net/tls: Add kernel APIs for requesting a TLSv1.3
 handshake
Thread-Topic: [PATCH v5 2/2] net/tls: Add kernel APIs for requesting a TLSv1.3
 handshake
Thread-Index: AQHZSITtHhPhPxm1gkerYFCVAJmwo67ijOIAgABa8IA=
Date:   Mon, 27 Feb 2023 15:01:56 +0000
Message-ID: <8BF1087A-3977-40FA-B71C-AF4BFE5E5148@oracle.com>
References: <167726551328.5428.13732817493891677975.stgit@91.116.238.104.host.secureserver.net>
 <167726636603.5428.10993498628206909067.stgit@91.116.238.104.host.secureserver.net>
 <5da8ae8e-f381-7ec7-0334-e76408b73f58@suse.de>
In-Reply-To: <5da8ae8e-f381-7ec7-0334-e76408b73f58@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|IA0PR10MB6867:EE_
x-ms-office365-filtering-correlation-id: ab01faf8-d124-48ad-e0ba-08db18d391de
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bpiEcF89+/3NBr4vyn8ZaLTPrYS/EH2MIjdp5DutSdXjwn0O7c+oagtCAMiPcUonCly+hhaQGQQDieOqWF6hqFfHHIWyBVZQpZhFsw/UYvBes8QQ2fZXqKyW4fXmEGwS5lgTnmUq5XFHuzvFcZkG6QI/AujrhfR7FYe6aDt1nPP1p1Vm0snXcwYxZ9XSjJ1nFVqTAhY9cf51Umfw7KbjiInh2gnJy6qSLazcc7/gjHywxzOxRJJ3eeVHjfoPdesa7jf4B04BQhGxyinW3oZNQO3SX+ZKZr09yCLUU8nOeqgzfK8zNCKmh8n4L8Y7Ib4TjT91MsDsepcjJeaPwh9Ac1DTYKVDiR7PUlh+YLvpyESNE5+u37/a1/X8B7vAlN6VeKZSZFXb4B+Ps6lUuZmpwwVNj9iXqbY2dGTWXQqpN/6wnWForAbhT3zfdEBqQIWtTqiScffnCNsK6LVJQHN4CYaZeSenOgtP/U5S5jOhhssDVKetfwYOKTymLN7Nnk9rf8lVWbcE+k3EgU2EgcZRBnbPYxptWIlrAPhppL5wMkrtvywW/7OLRZlJEG9KRM37OJpR9jtZdrCfdv4+PuDU4OclYaAMNguHQdiTZQen5f7G130+YmWzD/xD1nFyxvzKeb1PfSP+ozCSkZKSCzlO+adnVXyqYcSMCm5Df4sNUse7YQmjv8CjZ8e0ldGeJ94t84U+zFMDz2pCFNc4LeUy9ZU5bBlspXmKY/L0ckqCAlQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199018)(33656002)(2616005)(316002)(36756003)(54906003)(86362001)(6486002)(8676002)(186003)(5660300002)(30864003)(66446008)(4326008)(66476007)(76116006)(8936002)(2906002)(66946007)(41300700001)(64756008)(6506007)(53546011)(478600001)(26005)(6916009)(71200400001)(6512007)(66556008)(38100700002)(91956017)(122000001)(83380400001)(38070700005)(45980500001)(579004)(559001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?au8GxAxIZHrgyLPKl5QoHEgddwGNqvkOGE7g3cgAPAr5nt70gg3dT+gbRuag?=
 =?us-ascii?Q?4InX6tWif69lITHPHUOCNgmQyxJF1crlgSijogEioVfePrCKYQwQeC/4/cK5?=
 =?us-ascii?Q?ayHrN42lneOPm0gxqYLtvI7BGaDz/vItVdcC3fa47AUTlYt6ZIshMPc4/xfu?=
 =?us-ascii?Q?RqzNwmq2mMXTZzl2Okvj0nYGQsn3Qog8z/GmJzfq0IJOfkWwIERRRZ7j5TLb?=
 =?us-ascii?Q?hwD7oVoISnan24tR8Rm+ZhNl+7m1lxccmpDlDiwPx5chOVrcvHcmHqR2TRXa?=
 =?us-ascii?Q?ICU1533Mmb/w0mkgetRVfCpR9LU3jkMvehs+jP6Kf7rbDQpgA081j5WZkpMw?=
 =?us-ascii?Q?hdTMYpcckq0od1vrCgWBEJE7foUl2vzOfRf2pKsS5w5dWgw23kkixi6lO/Aa?=
 =?us-ascii?Q?kT2+CdiDzUm44yXRMvK7F2tYl8dYRTYQ1rs/RAw4YiFXtY15EGAj4UBYTeMt?=
 =?us-ascii?Q?is+GLcefNhWF2luXSKjvowVsdb1lNWA5573JI7Z15P02l2kbEiCXU+pm8wkP?=
 =?us-ascii?Q?wJvb6wmgCou/qkIbxwx1YXWR+cc6iW9Uo3nbHM0Hfi+PBtyTU7X2Cb/Hvrk+?=
 =?us-ascii?Q?2uB/NKfO6UyfMXAT1wMpdMP9Dxwft37WHLLJBf1E9xHkGr42audiXiJopQzE?=
 =?us-ascii?Q?V5oQ3QbmC6DzpjAii/4XKuTCf4gxizX1HyJC1TaLjUC6cby0MF7uEyR6aN9i?=
 =?us-ascii?Q?e9/oZLs08yogsTpyhA9I/QSRsRc6+HwVF6LuQV/Er3vk6llTnfhCqeZjD9Wy?=
 =?us-ascii?Q?UGsEGcnGataU7a2PftTB++bGishWXBx69Q5kThbCIHA0OwG3KvY+mDYY1SiX?=
 =?us-ascii?Q?CPwpebeVuFC3ELeyoE+3vvGo9r644Y9TTgEydThLwgF4nVoubrp0p9hfY9Jz?=
 =?us-ascii?Q?6uLwnlA3mlhL9TTDJy45qFledyGhD8O6o7P+XXIa3AzrNRUuz8d6HuXe3/ev?=
 =?us-ascii?Q?0cpB3FKOJ6CURU0CRGi7fhsCiIF0ryyn2FKYo+waMRsj0MZhOqgBuoRVR8AJ?=
 =?us-ascii?Q?6V+Y0ZfRoOIvF3UVF5wLR2T9XmtRlm2rK2uNtHPp4KawBbLyA3Gs0PTXwb3/?=
 =?us-ascii?Q?Rji5FodYTmIKEqinbduBjnJ32kKMy8N78+pVCEE5SqeJVtWMuUNfFC479vLd?=
 =?us-ascii?Q?jUxQNyr5xsb8UB28zZa2b6W7Cczj+LRuSGTSr+zMM+oqtSMhdbWBqAxyZ6Br?=
 =?us-ascii?Q?ee+rWd6x98dtUa17p5LxpMfbstsDHKHJlIGJ/SPtuOWVKgQKAY5Q3Kh037sx?=
 =?us-ascii?Q?b+99mspitXwo0/rVEfYZYZKZdGSDFtR7oyHPwsiKV6KlitTvcb77oW8hdI3e?=
 =?us-ascii?Q?6VAnbziX4tJ0nj3PM2YOdTdPnwQU6/tie8nkn9/dfDyHozcCFdPAfuKTeTQA?=
 =?us-ascii?Q?fjSGUoU4g0UQ/3/71ZtP4GzPs9U7udvpFuZ6kd7zX4NfOUlF1dlENDw0QHU8?=
 =?us-ascii?Q?5wETxQDQzEQlKgiA5dzWPAavsWRUZCiMxtGqFfSfll8VMT2Q9XB8uem1bHCE?=
 =?us-ascii?Q?o+2QaO1w2wIbd5mFeziZwf5wxcDX/It/mDviubMeW9MZLCS08Hjlg9ozXvj5?=
 =?us-ascii?Q?uIp9ejcOAn1bguzbK/HMI2G8sgCL1DNXS6btERHcB3wFEyE7gdKzYp5echp3?=
 =?us-ascii?Q?qw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6202406C1CFC5C4B914C130EC452C765@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jXpV+BsBU0w14eXlVVfhGEAVy9SvgZ2/BJHvpfkESpPMIQFFGIKz/Gpe62ZJQAobUDoB0U1BdoRDr2tKxl5N/mH0E1OBK1HNNT/nt/iQ4TViuLHKjzBZnjUFNz+ZfjjNBZZ4GZdOrZLX6y7e4GPzXnKu8VcxvvJy3gCBkme1TjU579tA8DWc+sie6Bod/kPkCk4VWiTqr3CjxCzAHCkKwtaa/Qv3v8XWx5F8W8NTrL3geIFqd93dg0SH4wKZrDNtbfsQis2wxqc2Os0X+YjmtchJaSaFjCBnIs2FQddsSqLiXPkKC62RFnW6/Vn9Vmi6+VfdUDwsjKPfmDMZdT7Qm9YoFGwkQRKx6jQJ8N84iSp0/dXZX+Bl3I3Mx5Vjp5buhYBIx5TGt4QZ0pXkmCY/KW2NspH1kK2kny2lSboy0LukzdzfDDSnpeL1pJv0LXUSKUCuatlt2pX4yaFrhGDQCQJPfaiHiRFiFauzTjjYPFZIV6wNtKWT1fjSeFVc/duHsRB3qGuPNJWXIAZik/ENVbOkVLUbGsiKfTAwM6DtgjPcrk2Tc/uVMFvGG36w1SPAKVTfgUMzz/9LnE2NVw97KtMdmVwAWr1JDMHG6BXoE2gMoqnfKO/6+qfLUjAK6X+XGIcVw3NNbazk18/thkRcRjKAYumHMvzjvXIuG5rxPPZz9QVSLzMqYYRoq+Ng2ljwDOVg/jc/nHo/hKkRcLxJPxjcQqwa7G1x3hjywlVaJ2TjwA0YmCPMfNKy1eB7LKEB9ypRrQ+lyl5tFtU1x/8nPapWZ/QylDoPx1Wl7EUTUzPv78JnmrHF6av16nR15Mu3a01AnPtiziTOCawKmotEoJXSBqLyz4OrHPe8eE412ksemdVKZSqchjP8GTiLzeo5zHSckois41xC8TAuO+2TBQFFdo9tbVTpRsK2raM1B38=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab01faf8-d124-48ad-e0ba-08db18d391de
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2023 15:01:56.7057
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TKIwE5KGEvzv+pRlvIoSagQI4MG3HJCmRh42nwUL8MusYAQ2nUU8aAYDVcuYl1Fd2BXWjoq+aJhaW22utHv1HQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6867
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-27_10,2023-02-27_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 spamscore=0 adultscore=0 phishscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2302270114
X-Proofpoint-GUID: 8piQuhNTjkzf_PiMRuvYdgXAs2Q68P_n
X-Proofpoint-ORIG-GUID: 8piQuhNTjkzf_PiMRuvYdgXAs2Q68P_n
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 27, 2023, at 4:36 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
> On 2/24/23 20:19, Chuck Lever wrote:
>> From: Chuck Lever <chuck.lever@oracle.com>
>> To enable kernel consumers of TLS to request a TLS handshake, add
>> support to net/tls/ to send a handshake upcall. This patch also
>> acts as a template for adding handshake upcall support to other
>> transport layer security mechanisms.
>> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
>> ---
>>  Documentation/netlink/specs/handshake.yaml |    4
>>  Documentation/networking/index.rst         |    1
>>  Documentation/networking/tls-handshake.rst |  146 ++++++++++
>>  include/net/tls.h                          |   27 ++
>>  include/uapi/linux/handshake.h             |    2
>>  net/handshake/netlink.c                    |    1
>>  net/tls/Makefile                           |    2
>>  net/tls/tls_handshake.c                    |  423 +++++++++++++++++++++=
+++++++
>>  8 files changed, 604 insertions(+), 2 deletions(-)
>>  create mode 100644 Documentation/networking/tls-handshake.rst
>>  create mode 100644 net/tls/tls_handshake.c
>> diff --git a/Documentation/netlink/specs/handshake.yaml b/Documentation/=
netlink/specs/handshake.yaml
>> index 683a8f2df0a7..c2f6bfff2326 100644
>> --- a/Documentation/netlink/specs/handshake.yaml
>> +++ b/Documentation/netlink/specs/handshake.yaml
>> @@ -21,7 +21,7 @@ definitions:
>>      name: handler-class
>>      enum-name:
>>      value-start: 0
>> -    entries: [ none ]
>> +    entries: [ none, tlshd ]
>>    -
>>      type: enum
>>      name: msg-type
>> @@ -132,3 +132,5 @@ mcast-groups:
>>    list:
>>      -
>>        name: none
>> +    -
>> +      name: tlshd
>> diff --git a/Documentation/networking/index.rst b/Documentation/networki=
ng/index.rst
>> index 4ddcae33c336..189517f4ea96 100644
>> --- a/Documentation/networking/index.rst
>> +++ b/Documentation/networking/index.rst
>> @@ -36,6 +36,7 @@ Contents:
>>     scaling
>>     tls
>>     tls-offload
>> +   tls-handshake
>>     nfc
>>     6lowpan
>>     6pack
>> diff --git a/Documentation/networking/tls-handshake.rst b/Documentation/=
networking/tls-handshake.rst
>> new file mode 100644
>> index 000000000000..f09fc6c09580
>> --- /dev/null
>> +++ b/Documentation/networking/tls-handshake.rst
>> @@ -0,0 +1,146 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +In-Kernel TLS Handshake
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +Overview
>> +=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +Transport Layer Security (TLS) is a Upper Layer Protocol (ULP) that run=
s
>> +over TCP. TLS provides end-to-end data integrity and confidentiality,
>> +in addition to peer authentication.
>> +
>> +The kernel's kTLS implementation handles the TLS record subprotocol, bu=
t
>> +does not handle the TLS handshake subprotocol which is used to establis=
h
>> +a TLS session. Kernel consumers can use the API described here to
>> +request TLS session establishment.
>> +
>> +There are several possible ways to provide a handshake service in the
>> +kernel. The API described here is designed to hide the details of those
>> +implementations so that in-kernel TLS consumers do not need to be
>> +aware of how the handshake gets done.
>> +
>> +
>> +User handshake agent
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +As of this writing, there is no TLS handshake implementation in the
>> +Linux kernel. Thus, with the current implementation, a user agent is
>> +started in each network namespace where a kernel consumer might require
>> +a TLS handshake. This agent listens for events sent from the kernel
>> +that request a handshake on an open and connected TCP socket.
>> +
>> +The open socket is passed to user space via a netlink operation, which
>> +creates a socket descriptor in the agent's file descriptor table. If th=
e
>> +handshake completes successfully, the user agent promotes the socket to
>> +use the TLS ULP and sets the session information using the SOL_TLS sock=
et
>> +options. The user agent returns the socket to the kernel via a second
>> +netlink operation.
>> +
>> +
>> +Kernel Handshake API
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +A kernel TLS consumer initiates a client-side TLS handshake on an open
>> +socket by invoking one of the tls_client_hello() functions. For example=
:
>> +
>> +.. code-block:: c
>> +
>> +  ret =3D tls_client_hello_x509(sock, done_func, cookie, priorities,
>> +                              cert, privkey);
>> +
>> +The function returns zero when the handshake request is under way. A
>> +zero return guarantees the callback function @done_func will be invoked
>> +for this socket.
>> +
>> +The function returns a negative errno if the handshake could not be
>> +started. A negative errno guarantees the callback function @done_func
>> +will not be invoked on this socket.
>> +
>> +The @sock argument is an open and connected socket. The caller must hol=
d
>> +a reference on the socket to prevent it from being destroyed while the
>> +handshake is in progress.
>> +
>> +@done_func and @cookie are a callback function that is invoked when the
>> +handshake has completed. The success status of the handshake is returne=
d
>> +via the @status parameter of the callback function. A good practice is
>> +to close and destroy the socket immediately if the handshake has failed=
.
>> +
>> +@priorities is a GnuTLS priorities string that controls the handshake.
>> +The special value TLS_DEFAULT_PRIORITIES causes the handshake to
>> +operate using default TLS priorities. However, the caller can use the
>> +string to (for example) adjust the handshake to use a restricted set
>> +of ciphers (say, if the kernel consumer wishes to mandate only a
>> +limited set of ciphers).
>> +
>> +@cert is the serial number of a key that contains a DER format x.509
>> +certificate that the handshake agent presents to the remote as the loca=
l
>> +peer's identity.
>> +
>> +@privkey is the serial number of a key that contains a DER-format
>> +private key associated with the x.509 certificate.
>> +
>> +
>> +To initiate a client-side TLS handshake with a pre-shared key, use:
>> +
>> +.. code-block:: c
>> +
>> +  ret =3D tls_client_hello_psk(sock, done_func, cookie, priorities,
>> +                             peerid);
>> +
>> +@peerid is the serial number of a key that contains the pre-shared
>> +key to be used for the handshake.
>> +
>> +The other parameters are as above.
>> +
>> +
>> +To initiate an anonymous client-side TLS handshake use:
>> +
>> +.. code-block:: c
>> +
>> +  ret =3D tls_client_hello_anon(sock, done_func, cookie, priorities);
>> +
>> +The parameters are as above.
>> +
>> +The handshake agent presents no peer identity information to the
>> +remote during the handshake. Only server authentication is performed
>> +during the handshake. Thus the established session uses encryption
>> +only.
>> +
>> +
>> +Consumers that are in-kernel servers use:
>> +
>> +.. code-block:: c
>> +
>> +  ret =3D tls_server_hello(sock, done_func, cookie, priorities);
>> +
>> +The parameters for this operation are as above.
>> +
>> +
>> +Lastly, if the consumer needs to cancel the handshake request, say,
>> +due to a ^C or other exigent event, the handshake core provides
>> +this API:
>> +
>> +.. code-block:: c
>> +
>> +  handshake_cancel(sock);
>> +
>> +
>> +Other considerations
>> +--------------------
>> +
>> +While a handshake is under way, the kernel consumer must alter the
>> +socket's sk_data_ready callback function to ignore all incoming data.
>> +Once the handshake completion callback function has been invoked,
>> +normal receive operation can be resumed.
>> +
>> +Once a TLS session is established, the consumer must provide a buffer
>> +for and then examine the control message (CMSG) that is part of every
>> +subsequent sock_recvmsg(). Each control message indicates whether the
>> +received message data is TLS record data or session metadata.
>> +
>> +See tls.rst for details on how a kTLS consumer recognizes incoming
>> +(decrypted) application data, alerts, and handshake packets once the
>> +socket has been promoted to use the TLS ULP.
>> +
>> diff --git a/include/net/tls.h b/include/net/tls.h
>> index 154949c7b0c8..505b23992ef0 100644
>> --- a/include/net/tls.h
>> +++ b/include/net/tls.h
>> @@ -512,4 +512,31 @@ static inline bool tls_is_sk_rx_device_offloaded(st=
ruct sock *sk)
>>  	return tls_get_ctx(sk)->rx_conf =3D=3D TLS_HW;
>>  }
>>  #endif
>> +
>> +#define TLS_DEFAULT_PRIORITIES		(NULL)
>> +
>=20
> Hmm? What is the point in this?
> It's not that we can overwrite it later on ...
>=20
>> +enum {
>> +	TLS_NO_PEERID =3D 0,
>> +	TLS_NO_CERT =3D 0,
>> +	TLS_NO_PRIVKEY =3D 0,
>> +};
>> +
>> +typedef void	(*tls_done_func_t)(void *data, int status,
>> +				   key_serial_t peerid);
>> +
>> +int tls_client_hello_anon(struct socket *sock, tls_done_func_t done,
>> +			  void *data, const char *priorities);
>> +int tls_client_hello_x509(struct socket *sock, tls_done_func_t done,
>> +			  void *data, const char *priorities,
>> +			  key_serial_t cert, key_serial_t privkey);
>> +int tls_client_hello_psk(struct socket *sock, tls_done_func_t done,
>> +			 void *data, const char *priorities,
>> +			 key_serial_t peerid);
>> +int tls_server_hello_x509(struct socket *sock, tls_done_func_t done,
>> +			  void *data, const char *priorities);
>> +int tls_server_hello_psk(struct socket *sock, tls_done_func_t done,
>> +			 void *data, const char *priorities);
>> +
>> +int tls_handshake_cancel(struct socket *sock);
>> +
>>  #endif /* _TLS_OFFLOAD_H */
>> diff --git a/include/uapi/linux/handshake.h b/include/uapi/linux/handsha=
ke.h
>> index 09fd7c37cba4..dad8227939a1 100644
>> --- a/include/uapi/linux/handshake.h
>> +++ b/include/uapi/linux/handshake.h
>> @@ -11,6 +11,7 @@
>>    enum {
>>  	HANDSHAKE_HANDLER_CLASS_NONE,
>> +	HANDSHAKE_HANDLER_CLASS_TLSHD,
>>  };
>>    enum {
>> @@ -59,5 +60,6 @@ enum {
>>  };
>>    #define HANDSHAKE_MCGRP_NONE	"none"
>> +#define HANDSHAKE_MCGRP_TLSHD	"tlshd"
>>    #endif /* _UAPI_LINUX_HANDSHAKE_H */
>> diff --git a/net/handshake/netlink.c b/net/handshake/netlink.c
>> index 581e382236cf..88775f784305 100644
>> --- a/net/handshake/netlink.c
>> +++ b/net/handshake/netlink.c
>> @@ -255,6 +255,7 @@ static const struct genl_split_ops handshake_nl_ops[=
] =3D {
>>    static const struct genl_multicast_group handshake_nl_mcgrps[] =3D {
>>  	[HANDSHAKE_HANDLER_CLASS_NONE] =3D { .name =3D HANDSHAKE_MCGRP_NONE, }=
,
>> +	[HANDSHAKE_HANDLER_CLASS_TLSHD] =3D { .name =3D HANDSHAKE_MCGRP_TLSHD,=
 },
>>  };
>>    static struct genl_family __ro_after_init handshake_genl_family =3D {
>> diff --git a/net/tls/Makefile b/net/tls/Makefile
>> index e41c800489ac..7e56b57f14f6 100644
>> --- a/net/tls/Makefile
>> +++ b/net/tls/Makefile
>> @@ -7,7 +7,7 @@ CFLAGS_trace.o :=3D -I$(src)
>>    obj-$(CONFIG_TLS) +=3D tls.o
>>  -tls-y :=3D tls_main.o tls_sw.o tls_proc.o trace.o tls_strp.o
>> +tls-y :=3D tls_handshake.o tls_main.o tls_sw.o tls_proc.o trace.o tls_s=
trp.o
>> =20
> I'd rather tack the new file at the end, but that might be personal prefe=
rence ...
>=20
>>  tls-$(CONFIG_TLS_TOE) +=3D tls_toe.o
>>  tls-$(CONFIG_TLS_DEVICE) +=3D tls_device.o tls_device_fallback.o
>> diff --git a/net/tls/tls_handshake.c b/net/tls/tls_handshake.c
>> new file mode 100644
>> index 000000000000..74d32a9ca857
>> --- /dev/null
>> +++ b/net/tls/tls_handshake.c
>> @@ -0,0 +1,423 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Establish a TLS session for a kernel socket consumer
>> + *
>> + * Author: Chuck Lever <chuck.lever@oracle.com>
>> + *
>> + * Copyright (c) 2021-2023, Oracle and/or its affiliates.
>> + */
>> +
>> +#include <linux/types.h>
>> +#include <linux/socket.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/slab.h>
>> +
>> +#include <net/sock.h>
>> +#include <net/tls.h>
>> +#include <net/genetlink.h>
>> +#include <net/handshake.h>
>> +
>> +#include <uapi/linux/handshake.h>
>> +
>> +/*
>> + * TLS priorities string passed to the GnuTLS library.
>> + *
>> + * Specifically for kernel TLS consumers: enable only TLS v1.3 and the
>> + * ciphers that are supported by kTLS.
>> + *
>> + * Currently this list is generated by hand from the supported ciphers
>> + * found in include/uapi/linux/tls.h.
>> + */
>> +#define KTLS_DEFAULT_PRIORITIES \
>> +	"SECURE256:+SECURE128:-COMP-ALL" \
>> +	":-VERS-ALL:+VERS-TLS1.3:%NO_TICKETS" \
>> +	":-CIPHER-ALL:+CHACHA20-POLY1305:+AES-256-GCM:+AES-128-GCM:+AES-128-CC=
M"
>> +
>> +struct tls_handshake_req {
>> +	void			(*th_consumer_done)(void *data, int status,
>> +						    key_serial_t peerid);
>> +	void			*th_consumer_data;
>> +
>> +	const char		*th_priorities;
>> +	int			th_type;
>> +	int			th_auth_type;
>> +	key_serial_t		th_peerid;
>> +	key_serial_t		th_certificate;
>> +	key_serial_t		th_privkey;
>> +
>> +};
>> +
>> +static const char *tls_handshake_dup_priorities(const char *priorities,
>> +						gfp_t flags)
>> +{
>> +	const char *tp;
>> +
>> +	if (priorities !=3D TLS_DEFAULT_PRIORITIES && strlen(priorities))
> See above. At TLS_DEFAULT_PRIORITIES is NULL we can leave out the first c=
ondition.

strlen() crashes if it's passed a NULL pointer.

What I'm thinking of instead is to simply remove the "priorities" argument
from tls_{client,server}_hello, and leave it as something that is between
net/tls/tls_handshake.c and tlshd.


>> +		tp =3D priorities;
>> +	else
>> +		tp =3D KTLS_DEFAULT_PRIORITIES;
>> +	return kstrdup(tp, flags);
>> +}
>> +
>> +static struct tls_handshake_req *
>> +tls_handshake_req_init(struct handshake_req *req, tls_done_func_t done,
>> +		       void *data, const char *priorities)
>> +{
>> +	struct tls_handshake_req *treq =3D handshake_req_private(req);
>> +
>> +	treq->th_consumer_done =3D done;
>> +	treq->th_consumer_data =3D data;
>> +	treq->th_priorities =3D priorities;
>> +	treq->th_peerid =3D TLS_NO_PEERID;
>> +	treq->th_certificate =3D TLS_NO_CERT;
>> +	treq->th_privkey =3D TLS_NO_PRIVKEY;
>> +	return treq;
>> +}
>> +
>> +/**
>> + * tls_handshake_destroy - callback to release a handshake request
>> + * @req: handshake parameters to release
>> + *
>> + */
>> +static void tls_handshake_destroy(struct handshake_req *req)
>> +{
>> +	struct tls_handshake_req *treq =3D handshake_req_private(req);
>> +
>> +	kfree(treq->th_priorities);
>> +}
>> +
>> +/**
>> + * tls_handshake_done - callback to handle a CMD_DONE request
>> + * @req: socket on which the handshake was performed
>> + * @status: session status code
>> + * @tb: other results of session establishment
>> + *
>> + * Eventually this will return information about the established
>> + * session: whether it is authenticated, and if so, who the remote
>> + * is.
>> + */
>> +static void tls_handshake_done(struct handshake_req *req, int status,
>> +			       struct nlattr **tb)
>> +{
>> +	struct tls_handshake_req *treq =3D handshake_req_private(req);
>> +	key_serial_t peerid =3D TLS_NO_PEERID;
>> +
>> +	if (tb[HANDSHAKE_A_DONE_REMOTE_PEERID])
>> +		peerid =3D nla_get_u32(tb[HANDSHAKE_A_DONE_REMOTE_PEERID]);
>> +
>> +	treq->th_consumer_done(treq->th_consumer_data, status, peerid);
>> +}
>> +
>> +static int tls_handshake_put_accept_resp(struct sk_buff *msg,
>> +					 struct tls_handshake_req *treq)
>> +{
>> +	int ret;
>> +
>> +	ret =3D nla_put_u32(msg, HANDSHAKE_A_ACCEPT_MESSAGE_TYPE, treq->th_typ=
e);
>> +	if (ret < 0)
>> +		goto out;
>> +	ret =3D nla_put_u32(msg, HANDSHAKE_A_ACCEPT_AUTH, treq->th_auth_type);
>> +	if (ret < 0)
>> +		goto out;
>> +	switch (treq->th_auth_type) {
>> +	case HANDSHAKE_AUTH_X509:
>> +		if (treq->th_certificate !=3D TLS_NO_CERT) {
>> +			ret =3D nla_put_u32(msg, HANDSHAKE_A_ACCEPT_MY_PEERID,
>> +					  treq->th_certificate);
>> +			if (ret < 0)
>> +				goto out;
>> +		}
>> +		if (treq->th_privkey !=3D TLS_NO_PRIVKEY) {
>> +			ret =3D nla_put_u32(msg, HANDSHAKE_A_ACCEPT_MY_PRIVKEY,
>> +					  treq->th_privkey);
>> +			if (ret < 0)
>> +				goto out;
>> +		}
>> +		break;
>> +	case HANDSHAKE_AUTH_PSK:
>> +		if (treq->th_peerid !=3D TLS_NO_PEERID) {
>> +			ret =3D nla_put_u32(msg, HANDSHAKE_A_ACCEPT_MY_PEERID,
>> +					  treq->th_peerid);
>> +			if (ret < 0)
>> +				goto out;
>> +		}
>> +		break;
>> +	}
>> +
>> +	ret =3D nla_put_string(msg, HANDSHAKE_A_ACCEPT_GNUTLS_PRIORITIES,
>> +			     treq->th_priorities);
>> +	if (ret < 0)
>> +		goto out;
>> +
>> +	ret =3D 0;
>> +
>> +out:
>> +	return ret;
>> +}
>> +
>> +/**
>> + * tls_handshake_accept - callback to construct a CMD_ACCEPT response
>> + * @req: handshake parameters to return
>> + * @gi: generic netlink message context
>> + * @fd: file descriptor to be returned
>> + *
>> + * Returns zero on success, or a negative errno on failure.
>> + */
>> +static int tls_handshake_accept(struct handshake_req *req,
>> +				struct genl_info *gi, int fd)
>> +{
>> +	struct tls_handshake_req *treq =3D handshake_req_private(req);
>> +	struct nlmsghdr *hdr;
>> +	struct sk_buff *msg;
>> +	int ret;
>> +
>> +	ret =3D -ENOMEM;
>> +	msg =3D genlmsg_new(GENLMSG_DEFAULT_SIZE, GFP_KERNEL);
>> +	if (!msg)
>> +		goto out;
>> +	hdr =3D handshake_genl_put(msg, gi);
>> +	if (!hdr)
>> +		goto out_cancel;
>> +
>> +	ret =3D -EMSGSIZE;
>> +	ret =3D nla_put_u32(msg, HANDSHAKE_A_ACCEPT_SOCKFD, fd);
>> +	if (ret < 0)
>> +		goto out_cancel;
>> +
>> +	ret =3D tls_handshake_put_accept_resp(msg, treq);
>> +	if (ret < 0)
>> +		goto out_cancel;
>> +
>> +	genlmsg_end(msg, hdr);
>> +	return genlmsg_reply(msg, gi);
>> +
>> +out_cancel:
>> +	genlmsg_cancel(msg, hdr);
>> +out:
>> +	return ret;
>> +}
>> +
>> +static const struct handshake_proto tls_handshake_proto =3D {
>> +	.hp_handler_class	=3D HANDSHAKE_HANDLER_CLASS_TLSHD,
>> +	.hp_privsize		=3D sizeof(struct tls_handshake_req),
>> +
>> +	.hp_accept		=3D tls_handshake_accept,
>> +	.hp_done		=3D tls_handshake_done,
>> +	.hp_destroy		=3D tls_handshake_destroy,
>> +};
>> +
>> +/**
>> + * tls_client_hello_anon - request an anonymous TLS handshake on a sock=
et
>> + * @sock: connected socket on which to perform the handshake
>> + * @done: function to call when the handshake has completed
>> + * @data: token to pass back to @done
>> + * @priorities: GnuTLS TLS priorities string, or NULL
>> + *
>> + * Return values:
>> + *   %0: Handshake request enqueue; ->done will be called when complete
>> + *   %-ENOENT: No user agent is available
>> + *   %-ENOMEM: Memory allocation failed
>> + */
>> +int tls_client_hello_anon(struct socket *sock, tls_done_func_t done,
>> +			  void *data, const char *priorities)
>> +{
>> +	struct tls_handshake_req *treq;
>> +	struct handshake_req *req;
>> +	gfp_t flags =3D GFP_NOWAIT;
>> +	const char *tp;
>> +
>> +	tp =3D tls_handshake_dup_priorities(priorities, flags);
>> +	if (!tp)
>> +		return -ENOMEM;
>> +
>> +	req =3D handshake_req_alloc(sock, &tls_handshake_proto, flags);
>> +	if (!req) {
>> +		kfree(tp);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	treq =3D tls_handshake_req_init(req, done, data, tp);
>> +	treq->th_type =3D HANDSHAKE_MSG_TYPE_CLIENTHELLO;
>> +	treq->th_auth_type =3D HANDSHAKE_AUTH_UNAUTH;
>> +
>> +	return handshake_req_submit(req, flags);
>> +}
>> +EXPORT_SYMBOL(tls_client_hello_anon);
>> +
>> +/**
>> + * tls_client_hello_x509 - request an x.509-based TLS handshake on a so=
cket
>> + * @sock: connected socket on which to perform the handshake
>> + * @done: function to call when the handshake has completed
>> + * @data: token to pass back to @done
>> + * @priorities: GnuTLS TLS priorities string
>> + * @cert: serial number of key containing client's x.509 certificate
>> + * @privkey: serial number of key containing client's private key
>> + *
>> + * Return values:
>> + *   %0: Handshake request enqueue; ->done will be called when complete
>> + *   %-ENOENT: No user agent is available
>> + *   %-ENOMEM: Memory allocation failed
>> + */
>> +int tls_client_hello_x509(struct socket *sock, tls_done_func_t done,
>> +			  void *data, const char *priorities,
>> +			  key_serial_t cert, key_serial_t privkey)
>> +{
>> +	struct tls_handshake_req *treq;
>> +	struct handshake_req *req;
>> +	gfp_t flags =3D GFP_NOWAIT;
>> +	const char *tp;
>> +
>> +	tp =3D tls_handshake_dup_priorities(priorities, flags);
>> +	if (!tp)
>> +		return -ENOMEM;
>> +
>> +	req =3D handshake_req_alloc(sock, &tls_handshake_proto, flags);
>> +	if (!req) {
>> +		kfree(tp);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	treq =3D tls_handshake_req_init(req, done, data, tp);
>> +	treq->th_type =3D HANDSHAKE_MSG_TYPE_CLIENTHELLO;
>> +	treq->th_auth_type =3D HANDSHAKE_AUTH_X509;
>> +	treq->th_certificate =3D cert;
>> +	treq->th_privkey =3D privkey;
>> +
>> +	return handshake_req_submit(req, flags);
>> +}
>> +EXPORT_SYMBOL(tls_client_hello_x509);
>> +
>> +/**
>> + * tls_client_hello_psk - request a PSK-based TLS handshake on a socket
>> + * @sock: connected socket on which to perform the handshake
>> + * @done: function to call when the handshake has completed
>> + * @data: token to pass back to @done
>> + * @priorities: GnuTLS TLS priorities string
>> + * @peerid: serial number of key containing TLS identity
>> + *
>> + * Return values:
>> + *   %0: Handshake request enqueue; ->done will be called when complete
>> + *   %-ENOENT: No user agent is available
>> + *   %-ENOMEM: Memory allocation failed
>> + */
>> +int tls_client_hello_psk(struct socket *sock, tls_done_func_t done,
>> +			 void *data, const char *priorities,
>> +			 key_serial_t peerid)
>> +{
>> +	struct tls_handshake_req *treq;
>> +	struct handshake_req *req;
>> +	gfp_t flags =3D GFP_NOWAIT;
>> +	const char *tp;
>> +
>> +	tp =3D tls_handshake_dup_priorities(priorities, flags);
>> +	if (!tp)
>> +		return -ENOMEM;
>> +
>> +	req =3D handshake_req_alloc(sock, &tls_handshake_proto, flags);
>> +	if (!req) {
>> +		kfree(tp);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	treq =3D tls_handshake_req_init(req, done, data, tp);
>> +	treq->th_type =3D HANDSHAKE_MSG_TYPE_CLIENTHELLO;
>> +	treq->th_auth_type =3D HANDSHAKE_AUTH_PSK;
>> +	treq->th_peerid =3D peerid;
>> +
>> +	return handshake_req_submit(req, flags);
>> +}
>> +EXPORT_SYMBOL(tls_client_hello_psk);
>> +
>> +/**
>> + * tls_server_hello_x509 - request a server TLS handshake on a socket
>> + * @sock: connected socket on which to perform the handshake
>> + * @done: function to call when the handshake has completed
>> + * @data: token to pass back to @done
>> + * @priorities: GnuTLS TLS priorities string
>> + *
>> + * Return values:
>> + *   %0: Handshake request enqueue; ->done will be called when complete
>> + *   %-ENOENT: No user agent is available
>> + *   %-ENOMEM: Memory allocation failed
>> + */
>> +int tls_server_hello_x509(struct socket *sock, tls_done_func_t done,
>> +			  void *data, const char *priorities)
>> +{
>> +	struct tls_handshake_req *treq;
>> +	struct handshake_req *req;
>> +	gfp_t flags =3D GFP_KERNEL;
>> +	const char *tp;
>> +
>> +	tp =3D tls_handshake_dup_priorities(priorities, flags);
>> +	if (!tp)
>> +		return -ENOMEM;
>> +
>> +	req =3D handshake_req_alloc(sock, &tls_handshake_proto, flags);
>> +	if (!req) {
>> +		kfree(tp);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	treq =3D tls_handshake_req_init(req, done, data, tp);
>> +	treq->th_type =3D HANDSHAKE_MSG_TYPE_SERVERHELLO;
>> +	treq->th_auth_type =3D HANDSHAKE_AUTH_X509;
>> +
>> +	return handshake_req_submit(req, flags);
>> +}
>> +EXPORT_SYMBOL(tls_server_hello_x509);
>> +
>> +/**
>> + * tls_server_hello_psk - request a server TLS handshake on a socket
>> + * @sock: connected socket on which to perform the handshake
>> + * @done: function to call when the handshake has completed
>> + * @data: token to pass back to @done
>> + * @priorities: GnuTLS TLS priorities string
>> + *
>> + * Return values:
>> + *   %0: Handshake request enqueue; ->done will be called when complete
>> + *   %-ENOENT: No user agent is available
>> + *   %-ENOMEM: Memory allocation failed
>> + */
>> +int tls_server_hello_psk(struct socket *sock, tls_done_func_t done,
>> +			 void *data, const char *priorities)
>> +{
>> +	struct tls_handshake_req *treq;
>> +	struct handshake_req *req;
>> +	gfp_t flags =3D GFP_KERNEL;
>> +	const char *tp;
>> +
>> +	tp =3D tls_handshake_dup_priorities(priorities, flags);
>> +	if (!tp)
>> +		return -ENOMEM;
>> +
>> +	req =3D handshake_req_alloc(sock, &tls_handshake_proto, flags);
>> +	if (!req) {
>> +		kfree(tp);
>> +		return -ENOMEM;
>> +	}
>> +
>> +	treq =3D tls_handshake_req_init(req, done, data, tp);
>> +	treq->th_type =3D HANDSHAKE_MSG_TYPE_SERVERHELLO;
>> +	treq->th_auth_type =3D HANDSHAKE_AUTH_PSK;
>> +
>> +	return handshake_req_submit(req, flags);
>> +}
>> +EXPORT_SYMBOL(tls_server_hello_psk);
>> +
>> +/**
>> + * tls_handshake_cancel - cancel a pending handshake
>> + * @sock: socket on which there is an ongoing handshake
>> + *
>> + * Request cancellation races with request completion. To determine
>> + * who won, callers examine the return value from this function.
>> + *
>> + * Return values:
>> + *   %0 - Uncompleted handshake request was canceled
>> + *   %-EBUSY - Handshake request already completed
>> + */
>> +int tls_handshake_cancel(struct socket *sock)
>> +{
>> +	return handshake_req_cancel(sock);
>> +}
>> +EXPORT_SYMBOL(tls_handshake_cancel);
>=20
> Cheers,
>=20
> Hannes
>=20
>=20

--
Chuck Lever



