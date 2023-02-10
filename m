Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9AC869260E
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 20:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233244AbjBJTFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 14:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbjBJTFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 14:05:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF647D8A7
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 11:04:46 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AI0A9t029682;
        Fri, 10 Feb 2023 19:04:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=QFY23bYkB1duRMV+mO3Yz3FInmzA100maCGlw+nxB1k=;
 b=ieBOByZcKJwhdMsoTY80okF41Qe+JbFNAse89fZnrz8EZVgZP92ZQk4nyFSjb+YezhvT
 s6ss+Uk608WZHGWNDwGAUoNXsZ9RuN24ug9D+bvhISAFzS2EHiVV7TCKlTpOIwBZrJb3
 C4TpAszDMlwYJelmc/B+qv152kuYgY6jk4zhUgVnsW7R51HJUe/XANX+CyMlp1dHRiNP
 V3FvPEpF48k7MEUFqypFsoQOv4BywCBnMHvpAdG5hgVdjiQxBkzuD/dAzfgGv/2UEQ+u
 /ugMA7XFboIkYdwT8EgSkr+tFr+gS5OodcD07eHhbmxev1Wnr33P1sNPiqe5RkzfPbVG Tg== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nhdy1e555-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 19:04:38 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AHwuCn036135;
        Fri, 10 Feb 2023 19:04:36 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdtgyva2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 19:04:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/KwpCE7bZmWFbEEyQJsqqDCnrnDHEI0cGW5xRJmPr6ARuxUX2cfH0p9oc4He2VzIf7/4pDa86oarpREs32PwoFc/Hm9I8SoMh/4aTWj+FpEruTAXaD6vQC71q2iaqhU0bpmlxbu0gTu+dd6Y4ZR7N/0Q3JJZozKOS4EQ17zBbl6/lNsXFa5obyA/g7zN0rOW0kFEpS4Zf8YczJZh5Y0XNlBbEIR+6acepfDJA0xQa42GsPQAQ+hzYyuRRIi6+3den14YspUPupLdK4hbJQUimVKpyQGMSl8QhYMmNX2KNa2XUtcm4nyVrlceoqDP81V8MwuDMPkJwj829xlbAFL6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QFY23bYkB1duRMV+mO3Yz3FInmzA100maCGlw+nxB1k=;
 b=f+fRz1ZYWPVG3nKbdcxfOpcpTjefBRgx28KIH3bRc/3g6MaN4IYgj8Bz2yRQJR3UCTJ69tmDBIliLxC4HvXAEixdZQxxkL7ENJlNYcjdlwfaA3F4meYm4Zi2giXBJNu/8Iq/oFs/VZYajMUmdz6C3Fiu2p/uuCY/x0UuxsQOjTr1JDQc6Lt1UP04CClFuCgD5Xeu36W8THuRRCVtiaFEpMD/jE/312XT8aO1YJzARAxn0uPEJT1xzIwOHIIfxir2DzdCVMj/R8xwgL9oyAzYUemZ/YljApMMK4xsVshkzAHkwRcZ4Ejr2h1VYBiGj3BsnFtyjS8Q0efG3QWVN7D0YA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QFY23bYkB1duRMV+mO3Yz3FInmzA100maCGlw+nxB1k=;
 b=p2/n1+Cv6b59Uu8CuDDzG19wH4ICYWfCH67Zi04Bfy2UOreGmsvOaEN8C7j1CiIjobS9U2nbCQZ7eSRo1mndDHMXLjMO7kpBuf4uZDyQgTJtZyWNmnrIuLtRUcb3XB1GmLCD1VzOS8CDsjygtutU+zNDnFFZqDHrRODQy4wggh8=
Received: from BN0PR10MB5128.namprd10.prod.outlook.com (2603:10b6:408:117::24)
 by BN0PR10MB5064.namprd10.prod.outlook.com (2603:10b6:408:114::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 19:04:34 +0000
Received: from BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127]) by BN0PR10MB5128.namprd10.prod.outlook.com
 ([fe80::5c2f:5e81:b6c4:a127%8]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 19:04:34 +0000
From:   Chuck Lever III <chuck.lever@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "hare@suse.com" <hare@suse.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Olga Kornievskaia <kolga@netapp.com>,
        "jmeneghi@redhat.com" <jmeneghi@redhat.com>
Subject: Re: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Topic: [PATCH v3 1/2] net/handshake: Create a NETLINK service for
 handling handshake requests
Thread-Index: AQHZPEvN++FMdi3fdkGdZmQw8wcosK7Gwc0AgACuc4CAAMv2gIAAQMSAgAAPc4A=
Date:   Fri, 10 Feb 2023 19:04:34 +0000
Message-ID: <1B1298B2-C884-48BA-A4E8-BBB95C42786B@oracle.com>
References: <167580444939.5328.5412964147692077675.stgit@91.116.238.104.host.secureserver.net>
 <167580607317.5328.2575913180270613320.stgit@91.116.238.104.host.secureserver.net>
 <20230208220025.0c3e6591@kernel.org>
 <5D62859B-76AD-431C-AC93-C42A32EC2B69@oracle.com>
 <20230209180727.0ec328dd@kernel.org>
 <EB241BE0-8829-4719-99EC-2C3E74384FA9@oracle.com>
 <20230210100915.3fde31dd@kernel.org>
In-Reply-To: <20230210100915.3fde31dd@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.2)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN0PR10MB5128:EE_|BN0PR10MB5064:EE_
x-ms-office365-filtering-correlation-id: 5bfcb6c0-1b94-49a1-8653-08db0b99a5ee
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bjSwV5X6PRrrtvd/kh2x991YKrBGT7eI/lt4YbyzsMJjVEmGZHeN6YD0BbWgIqESYhBXPhY6XEBAeTxC2Hr0ox3ZY6cV/jvjHUXXgmTNlt6FQZAg6hEjFF2THAviMAYEP10wxTyiRJ5szCm6X1fImi323/VV0rKDi6Zz72sSeNcobQUZfxxiF7A5AqRVwRRi5UTn6154+/naOuA01PMRbYheL1JeNGNbpg7XIXLWcB/fpfCIKxcs1UPdwZIpyreX4JJsctHG4xX0Rg2dYfVSHzBmI7+MENBWDXQHa8G0PWq+H71hSJmhgLk9+zegjX8/K93XFFdoJZn+cJezUBfDBs3577/2xhh33Pi3sCaZLziCI7Jgys96PQ64QwufbIzgKXFVNNLQtXKLbMokUndLl2sEpFIz6/z62ddtOcYwlDZEXnSXYq0y8tR539NnmdyJn76n+AXG5mohqFXTzzy74p5r/huXtlo8UQk89HXTlpjXVotq+ycoEI1o1tz62RjZzaZE/rOvjvXHejMSl/AEvHnp+fz2ysQDtJMgF4Irifj76BWkNijcn8bpfwPTsKhsljZ/PV5niUIIeLb455uovs1iA/fwzXtga0nnP8yUhUpzYIcucQOoAzmAn8axSQUSjM1MEHrfn6731EsVTFYHcII1reisLE3B2VglKKdssgg9Zf+Apwwkeq3rDwkzf+t49nCjchK9XD/WqnFkUtMTYHSceb4Pkfkc5/Eg2D+KB1c=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN0PR10MB5128.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199018)(186003)(36756003)(2906002)(83380400001)(38070700005)(38100700002)(91956017)(122000001)(64756008)(54906003)(66556008)(66946007)(66476007)(316002)(66446008)(76116006)(8936002)(33656002)(478600001)(8676002)(41300700001)(6916009)(26005)(71200400001)(53546011)(6512007)(6506007)(5660300002)(6486002)(86362001)(4326008)(2616005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AKkujCLhONEMyhXdgIbQOdhlw9AxuY5tjAsgpaiaIXXeATLS9fJWJtX3kG3l?=
 =?us-ascii?Q?FArnkJbxicjeQYBsy0kmDnw+WZmDXTxlyQCAg/+F8GICfNw7hU5Yxymch6Bs?=
 =?us-ascii?Q?k1WK3q5RUHEiXeRAWTDWOx5/SFuo0UgIsht+kkqOL+9FKBdNYUggEKL6s8ts?=
 =?us-ascii?Q?0uhQWXT2wGrHWXw2rv0c6aCUFnqvQcQZ1SBHgo9YSTB3caGnB/jQw3VQYkEj?=
 =?us-ascii?Q?lCmO9LQ2GWRQEPlk8Su+ysXpiv+zsWwm8wcQnwv4SAKYfADD6FuyWSVGzmK2?=
 =?us-ascii?Q?xCxinpbDXMp6ki2WVv5aWD/EyjMVLJF8Ur9dN97UO+GoIz3lQzMBjsAC1aqL?=
 =?us-ascii?Q?kQn+WwCduO6dzIrqTaOSGeTEHYnUd1M/nv7X225+VIj3nfEp4/YC7B97i639?=
 =?us-ascii?Q?opvbjONSmVvt4RDHeUiaPbWnFZrITdc7LaLqa0LC+wMtRmBcN0Ot6BUERI8G?=
 =?us-ascii?Q?SFNjtmdpbXPxt3F78pKtv3n8xJU2Qfup8FqaYgflv85ITXVTFA3HGW3sougR?=
 =?us-ascii?Q?mWO8tmeEzNUmbIYU8ebh4hi19VjL92+jNbqz3fqbnpbyMKBde4leRIwe2U65?=
 =?us-ascii?Q?RG4TqOn0zAPz2WgpKTs/1md3nM/TrPhAKMnAPALE58WR0ShcZfphYeeHTR8b?=
 =?us-ascii?Q?hYz4EfhvT1SMwz3Zw++FSYfMFj+5SZbZoyk71OZbC/IAgdZTVmvUf4/xFgLK?=
 =?us-ascii?Q?ZXKbddWysIpQx7/dvNvR8PXxNqK49Puc9eeD/+Sqw7bWklgheYv2fGkVaEPp?=
 =?us-ascii?Q?UR4ePzVIi7deDTA5jtemD8g4uGAD3aGf+bjO3IChbcX7oQxGnzXuxJwyASdM?=
 =?us-ascii?Q?gNGqeTdc2NM55vhWKxEtF7595ZQ+IJAqfFs3G3Fylx1QcSAOZ2f+RVTbL1ed?=
 =?us-ascii?Q?GXBeAvnmZaqGhrRIQhhwKxV9gv+wMWdDFcaAtN2WjjmmxFJCPnGmSs5xVMhq?=
 =?us-ascii?Q?MM6ENXQyL7s7C9HD801WsQlNTMg8FkHzrgekxKRDK9n91YpYaFvsv4/XOi6w?=
 =?us-ascii?Q?t1q84VJycMlDoJjQ3axQSJZMVAbJh5ssuPZHwEESU3jbDxUIlYKLhKm+ReQB?=
 =?us-ascii?Q?c6vrPssLhXP0a6qox/AevE07u7iw1mkNZ4zLpG3FU21mQj7SMcE4AZ1QzJM7?=
 =?us-ascii?Q?vRVqNC1g/zo4PcbKjFTj+npx7yBGYfxUvwNJHpEY013V5twtiHQU1sUS2fg/?=
 =?us-ascii?Q?WiQL+RRTpftsQpLSTzf3mqDmXBG2aEpQnX6X+ENvjBZSobITJrM4cBpL37XW?=
 =?us-ascii?Q?NvLlvaTiyi3nk+8UoM+8UETIlv8/1wOYOy2VUmyMMOXyyXZxZF1rKSYlpD7w?=
 =?us-ascii?Q?E1D8pwAjLOC1T5iIFSwZUGpfVwIWI6HubKcLYYMbJfzQ5VGUOhHZ/e/ysYzK?=
 =?us-ascii?Q?r8K1mj71KNwY607id7/9sW/DPWQlTLeO6erELVauDZSEzJhV5R5Gk/m+p1pf?=
 =?us-ascii?Q?i/tqTpiSTqroyVYZ+6vBMIRg+HM64ziL1OiliPYNb49YJsAWJU5eYhyKVZs0?=
 =?us-ascii?Q?HsEz8v2Hxc7eWa6qnR9w004cmccSkAsI5bXB0fi4bB4495uw8N7/K1lB4c6s?=
 =?us-ascii?Q?ZsLWdemOHDkmXSfaCMiUCBDfz2R2mkb5MxSvEPEibwgyMiG0IO/Ra5S0gkpH?=
 =?us-ascii?Q?+A=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1226F2E328650A4F879A71751DC9061B@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: cmMoRpVR36MiPO0q+I4Ep9E1ZDXIjM3BO2CDyivz3VguZrRZeSlIs/2OVoeMe9DACuoWERcLm/LcMiBUzi3Mc5sl2Z/zvz9VW6/KFa+70DER8wRz6qkBdwEXv4F/8pvXavO2+ltjU1B7voAVdNkrTXS1BreHwgJ4ibQWY5XsdiWp4ZnzmORb3Dstjw0xZ/l2GotWl1Xio3I7BMDEn2LiLjapFfpRcVgMsjQnGS+UuqRuwQI7gVmADFCX3h+xreTjzQplKjziGSNXuWSHv5raS37n7NvAeRfS1o318Xuad/hg7NzQmyTb7oJ/e9T6upJ1oTAUYOG5lKD0HVfyqJclzwQZTDP8x5mdWDoxoLbGNnjhtCxChfSQsdUnm4cUCTswaLBsQA9Nr6Viv90Ab+rsmgsSNBLjLQY2A1/t2n4GXqAs8oN/C+NbViYIQu/g1SIjhrAIOBzYShOYIZQCIwdS6Sur+88LRJPaUs7xLbdVHijBKPePPpZW3oAK2HrUO1d+7FgZrWISnqJFqMEGmazSkErNP8DrmHUtI3L46lXPUeC7lEGrAkRoKhoWzOn/IslVrew+/81O8k63k7dRDr927TOiDisFpgjZaqOn7BYOmSkub5Hg0mfVdAwujmdMgEh5+ESGCKIq0CgUYhAV+5DCw4dN4Uvl+Pl676Wy3EqKZotwUBy7mYGps++r7xnrXhXJ+wB4/2tlwS0xuNvVmuTmPudt6FNN8XlLTh1whcijJ/FwcSu0PwoQ70mOnuqW6AMuPaM1/i3Mewr5eyg6PshfAD/9w+5dyvKf7ixcjhPbKdZuBwpWivbeY0+5X1aHQrj2Ih6cfeM5fK5SrQRCINbFn9jMqN6r3Jzg2TcXk1VQlunuAFm4elSEnaqDlF0oqC5Ma5/mAqC9E1WaNrLHOYjtlg==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN0PR10MB5128.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5bfcb6c0-1b94-49a1-8653-08db0b99a5ee
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2023 19:04:34.4206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6oPhEK/7CcuFwbK7sxQvV3jhaJd0/dz5Dzwe4pdxzvFTHbXHvfJmj3Pdrs7BpltRjkyUsD9Pxt0a1ez+33FL/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5064
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_13,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=883
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100161
X-Proofpoint-GUID: o4aO4MspcgZruyl74tGkKBlrKYayjcv6
X-Proofpoint-ORIG-GUID: o4aO4MspcgZruyl74tGkKBlrKYayjcv6
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Feb 10, 2023, at 1:09 PM, Jakub Kicinski <kuba@kernel.org> wrote:
>=20
> On Fri, 10 Feb 2023 14:17:28 +0000 Chuck Lever III wrote:
>>>> I don't think it does, necessarily. But neither does it seem
>>>> to add any value (for this use case). <shrug> =20
>>>=20
>>> Our default is to go for generic netlink, it's where we invest most tim=
e
>>> in terms of infrastructure. =20
>>=20
>> v2 of the series used generic netlink for the downcall piece.
>> I can convert back to using generic netlink for v4 of the
>> series.
>=20
> Would you be able to write the spec for it? I'm happy to help with that
> as I mentioned.

I'm coming from an RPC background, we usually do start from an
XDR protocol specification. So, I'm used to that, and it might
give us some new ideas about protocol correctness or
simplification.

Point me to a sample spec or maybe a language reference and we
can discuss it further.


> Perhaps you have the user space already hand-written
> here but in case the mechanism/family gets reused it'd be sad if people
> had to hand write bindings for other programming languages.

Yes, the user space implementation is currently hand-written C,
but it can easily be converted to machine-generated if you have
a favorite tool to do that.


--
Chuck Lever



