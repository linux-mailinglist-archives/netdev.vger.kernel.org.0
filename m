Return-Path: <netdev+bounces-6365-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 85F69715F47
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:28:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BB2F2811B6
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:28:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 294B819936;
	Tue, 30 May 2023 12:27:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1416819912
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:27:55 +0000 (UTC)
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7FEE118;
	Tue, 30 May 2023 05:27:26 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UAdRCa016483;
	Tue, 30 May 2023 05:26:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=orias90HcK5ybaKRu2NkMeMHm86NgGU3/kYoq+gDYmM=;
 b=CZ61kTss7QB9Kwk2mGOLJL9gzA4n3SUnCFwfpLgDKLaFoeHhZMDrBmQO/XZuy0iJSa5G
 sZz8gY9pq456+RkM/pw7TQna+j5WZc9lVwgyJh8yKP/T7/W3L6hSB1O06DktJYiMnpZF
 ATMaNhHrM+xHre5p+Z7IF8InLM7CatKDad3VkSadKgyXUSLSR41sGymOlYQiIya5DXNt
 9zN6NqCHAQFeb7tZV+1D4IIVtPKjM2QFPWP+qVEkfvZw5t8Ax4ppauF0NmclQhKfaOBU
 9qiU5QKui/EA2k75abTun3jhsAKgX4I2FSM9Pypxoo86pnTagVCU5UWmklhOrx+OjIkk Sg== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qud53ac6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 05:26:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ab/gSddDI5Olcp1+CQ5d5hw14TUhpmk+ct90uH0t83KutUp0576L4L3OIT/laALPyngkSzLfDgCyDNNwzyvNa6NJr8LC9nd2a+jn3cQSdxHH1kpoU1TLSXHo6XiD8aK0oEm3jusYPR23cABJ1xkgBwpDUQFgHzDXlgyvK7FANTUqLGPB7Bu2ZyyV5JRjFD+9hqvFTF3Q9QT4zWYHf/lY0+dKbkMNtpZkyxsWbdSIKw4XDnUFvuMlq/w98+bmCRh0lxYIVwLXkiaUqa1EtBk9T5TNJYMDtllXkA7aW+0s/zUCITPJusMkCo6fjBL7e60vp6P/0KlO8r3wld8xP3sD9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=orias90HcK5ybaKRu2NkMeMHm86NgGU3/kYoq+gDYmM=;
 b=CqY35GKq8v8pkBj8NflqK2m6UBb4B0Zf2dP2+fcdY+FarQoPVQPTuThX9HKgSQm9gy/JXibX3H9MLgCf7vJuLZacuV908eXYejED8XcN3qkxFakeD8FG3yWTxco5DQCx9PdbfRwzUkTnoNS1KyQtRj9tYlZS3SiEgfUrkjxdqidyYzy++/hSv/4VTtKyEcnXB9qXTaWk5mqYzgBbPJox4wMAHlu2fkJVMw22fXj7Vs8G0Ro1hl2QnKHgbm3ALhoB7v1T2SFpL7Ccb+KsZDvX9Js3H/AVXQccY0lHXjqDNGlnAJz9RaSni3WQPRQOJFHbf+bN1n7cFcpmUm0DDXPbdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by DS0PR11MB7336.namprd11.prod.outlook.com (2603:10b6:8:11f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 12:26:45 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:26:45 +0000
From: Dragos-Marian Panait <dragos.panait@windriver.com>
To: stable@vger.kernel.org
Cc: Ruihan Li <lrh2000@pku.edu.cn>, Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6.1 0/1] Hardening against CVE-2023-2002
Date: Tue, 30 May 2023 15:26:28 +0300
Message-Id: <20230530122629.231821-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0129.eurprd08.prod.outlook.com
 (2603:10a6:800:d4::31) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|DS0PR11MB7336:EE_
X-MS-Office365-Filtering-Correlation-Id: e284f056-8936-4b09-c961-08db610921b0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pnaq9IfncYOBBE/8iGeiWEqNOycognFMOU1ZwFJ1Xj1wSqUu7mXuQGMt0adrlE+hmsJB4PZeASO8Q/l3CuZeHTURn5xS/jQFvbxgmsf/FWgFpWG5tq3dTZmH8FP/U++r5ofjQq8fFNuTjpw294b27n4YDTX8pPb3Jtqh5gMhSu07WKKocwC6SZRbBSnBpikU8o68gqrsxtD8AsJLIPQbspa7AOU6J/1RWy9dmqUQg2QJcOHEt1IpHc9opEcAf7DvbwGVJ6Ir+q+WBocvSZxgNZAfyaoUTDQDkSqaMPGq3BnzxcQRAHmj+23bs+u8ZW2M7dbk8De+K85nvyyUzZx/C/BFMEOeshVKQMz+D0SMqSd0iZzYyx7CXkmxFjO3xFFrqfM8jpJUjy7ch0XG5mtUfCAtWK5SOMPv9/euIGL2HdB+KbMsy3MoK2hUZ4+gvCJaMpNTBWiJT7cyD77oeGZPv37qaan7KdEe5lvCQH/XHj1A+NDyHmhJk3j0cehoaFLSxlcgDxC8r9GjBuiACbo6V+RbzjA1j42lI5eTZq+C9G+TYuX0TlKHkx9qnQcze1qahEqVCuGe723LWG7Ga8A21sDBGuHmTQWgFXekSM90RAA=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(39850400004)(366004)(376002)(396003)(136003)(451199021)(966005)(38100700002)(38350700002)(41300700001)(52116002)(6666004)(6506007)(1076003)(186003)(2616005)(6486002)(26005)(6512007)(478600001)(54906003)(66476007)(66556008)(66946007)(4326008)(6916009)(316002)(5660300002)(8676002)(8936002)(7416002)(2906002)(4744005)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?BmSEU1JfMqIFVYv7xHoUJ4ua3aiu6hK+1wNxYDGYgw5Lh/YCvtTRTM5ymxl0?=
 =?us-ascii?Q?1rU7QTmBoU4iDuNvtG4BpC6cWGmp6lHOFaHuMVHhREVfsLS0HYoWm3+acyMY?=
 =?us-ascii?Q?GJzkHUMi4jWK7w/nbHmRegYgeWZnM3MivN2SuoU1pO4bYv0afE1IadsMs0CG?=
 =?us-ascii?Q?W9PKgVfSVYJZVbY1VdK7Aktfv5wAOlWSYad+80rm4aWwBrgDXKS324vmcNcK?=
 =?us-ascii?Q?TcBuWqt4/I3uVnFKNekTEPK3fw071miSY/+YIRu7f1rJz64Y7Msb6NIZ/Lyj?=
 =?us-ascii?Q?MtFgyV9QCeZp7ERatnTQxQFExuSIlfhBz9kMuF1MGWHzMG9qZ1dcfR9M1/XV?=
 =?us-ascii?Q?obrMitDyL2gTTYmo7HzvzeHfFG1tsXQLthGEp0C/WxOYJ3iSmMI3r8bx9ZIk?=
 =?us-ascii?Q?667IXwVBR3ehP90J8yV4KOGePZaEN0+z9qEjjCmVuy7yADEV5tSa8TABfKj7?=
 =?us-ascii?Q?N1G+QVLiRbQxHB2N2an9se69YTpJotTRPB4TVDNscMzJF9mgBS74w8nQWkBj?=
 =?us-ascii?Q?Baxayo53TuHyI2Np3jMIqW7Pa0XqCE0Kf0aFrKnPfUJkFCfRKAj3UP94Rg9l?=
 =?us-ascii?Q?eAFKjQJEJBspXxbRXQkJelDD4JTalhku5P0c/nVzgODftqVhUPsoG+kACdKP?=
 =?us-ascii?Q?qHE9fDSnGwkEel/I7rLI43Fdbf5iscF6XUGWX/QWEUrc58RDVuIhewKy1Ato?=
 =?us-ascii?Q?bJwbS3y3CymXV9wOfDbj2sZmwYMRBBCAZeV/JmKWj3umPK9//+HIo9fTPYiH?=
 =?us-ascii?Q?lL2bTqIcYLpwhQZw95QK365tFPtnYN0aim3rzSBriL7mTGEoRl+Lef49O6bI?=
 =?us-ascii?Q?WLZVe/pn0EXc5W9yivsQ38YlJJ0P4ZvdtNGzMBD0GyDCNC8j5KISid3364Tz?=
 =?us-ascii?Q?8DBwtwIRjWtg8MEWX1d3IByxAEVRLcpEj/AGiiqbs2kjkfFn3/VdvL/cgctw?=
 =?us-ascii?Q?oXu+pvJ4Nv8KOeGr3Pdda8ve6yfB0tn/QLZYgNVdBGBQC2M5oMZp2ApIe54u?=
 =?us-ascii?Q?r4BuIGHe9jC3dGSXCCrn8s4OFn3kgfWY+F2QtCPFYSy8pG7oDQH3QkrbZSbA?=
 =?us-ascii?Q?2XCF04QP3w7XsyX7KI2J4pxYWTUebRsYNw+j47Y+tYfNCAWouoSRMSYuToTS?=
 =?us-ascii?Q?lt5MDSXGoQkb13pcHVLAXspB77MPS52iYugP5XSDf5MPg0hDhHqHkqayzDWu?=
 =?us-ascii?Q?0ZlozbaYe7jhLLGFL4lcl/33QAlZl5Ij9vK1qM4aQidw2y6Y5piNxUMXwOyX?=
 =?us-ascii?Q?0WQhmdukkzSz5SJP37KQJGgendEl/QUyIYI5N2vxGZF5JbiC7Z8eHmrVS2OG?=
 =?us-ascii?Q?cIkPHl2hjcEHzd/wn2KDAgUAOlvaKaYRY9cqvKFabd5/5an7q6cYAb1PQsh8?=
 =?us-ascii?Q?hpqW1bE+MxZyO5HhOwwFCfV+w7dvQAbGcH0o1OLV2okC/qirFCVjMl6dLnk6?=
 =?us-ascii?Q?HfmloiNjT4MN/vXB503U/pJUHrkiPWfi7lQhqsxcrBwwfPvMJ4tYccbdxVhG?=
 =?us-ascii?Q?dDVmOViW0TeIvId1rhPzK4X/NCXXb5K1klM6fQubMNXxoT7mDl5GNLZUUZ7P?=
 =?us-ascii?Q?9VhtqgGsPpGIrFCQF3m+ytznt+8dtLz1zCcuWZGNDJM22JlWL3qXAf9aKZM0?=
 =?us-ascii?Q?Xg=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e284f056-8936-4b09-c961-08db610921b0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:26:45.4691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vb5W2dWT6sXWPoJqhLoXXRSk7pxL/ozBPLm/7Ez6w5x5HLN9jhSdLMuVoHY8mYEEKWqlg+lJIiSIouhAVbdCm7yzHvK5ppwwmf9WQlAu/tY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7336
X-Proofpoint-GUID: 2_keXzumSba5HSmOg_9OLXOzw-hpYiK4
X-Proofpoint-ORIG-GUID: 2_keXzumSba5HSmOg_9OLXOzw-hpYiK4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_08,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=602 spamscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300103
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The following commit is needed to harden against CVE-2023-2002:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=000c2fa2c144c499c881a101819cf1936a1f7cf2

Ruihan Li (1):
  bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()

 net/bluetooth/hci_sock.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)


base-commit: fa74641fb6b93a19ccb50579886ecc98320230f9
-- 
2.40.1


