Return-Path: <netdev+bounces-6372-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 92C72716037
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:44:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 47F652811AB
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:44:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 699AE174DD;
	Tue, 30 May 2023 12:44:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566FD3210
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 12:44:17 +0000 (UTC)
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF794135;
	Tue, 30 May 2023 05:43:50 -0700 (PDT)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UAhl88017338;
	Tue, 30 May 2023 12:42:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=Ms7z8yy75ru7illg2TF8FuqUoZ2WjIGbiDZXPxlKPjo=;
 b=iswwv7msk64CWgh9k+f3HjqKMzV4gI+eGfOdXcV7b70Yz6sW5sg1YS/jsqfpyEIuCPbE
 aa8E85YoaU/MQAwFAqnQI3qGzbf7Qre0b4sf59D1dX80kuevitY3hkC+0VYmAhSs17ka
 5J5WI5XdJF6h+t5fqrPjfLXXeBAR9xJIdc3PMych2r6CpAvyJB1UXurv9ttLXMt2lybx
 q6PJo8t1rmGvYAXIvWR++NNvbs2VUG0LodfwKwSeuo11BA6aUptVj4Dg36OyvQNKErvJ
 IncJ/ySNimFu922PEr5ppfFhievMUqslsw22Y0Oh7qv2nSkIEJnr9z1XZijoHMT9TIFw tQ== 
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2041.outbound.protection.outlook.com [104.47.56.41])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qu8u8jjf3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 12:42:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nRiBAKVze9CsdOPkjL3MLLBupVK3drF/JG2DaUqoq654nbjUMghWfz1d3syRu282n1oXyfNaSaJXRZoeP2VEwuN0KYRttge+nDc5Yw0TFKbJ6I/W3Z/BP03H/kJ25VjZd5HmSXjB5fOVP/N9I1gpj2Nk38cZZWBkCmy1FwiX8I31TKqepIV7moWsJAX5wX6tiL7gZQzKWIwbIq9Ls6bqnM3LT22EYs/5YSjJZD8QDHDxRo4fPrT+hQ7JQ+M5mawtJn1KYGnixqgfQuYmLs8MABNbD0twqrCuh3h1rERbHBYFhNuOO5tZhzR8n4B799+EDBMO9uBa58Vw3KCDOJ+YaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ms7z8yy75ru7illg2TF8FuqUoZ2WjIGbiDZXPxlKPjo=;
 b=oJmlz8yOjzh7uqxkC1nPnXR08LSRfCOUxxR8/tjX1NpivTQ5FLQTE7ObDrZAmPGiur3Zy4kZq5Q7vjHSsBjjq2CSMsQDmYkQc7ZsacEjsOUJhujkbKLgq7AWkv10gkTpaWFo5Q2B6mao1ELS24hBP/epAX2DlWRoRr8wwhlmzqhAw6YuJo4zKSgw8n4amFKPK3ug9y+mCSv8hMjdHQ19iMllV6+oTqxgPnQWsdNFHLFiW+TSXB94H5F+a9hyHB8vgX01arTXVDSnF5mpKgZB7hgRLNCfbiIpH9lurJCjpkwNx463/igtKXxIPlIgnKzoYDRc59xhf7nJoaiHFa6CMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by SJ0PR11MB5117.namprd11.prod.outlook.com (2603:10b6:a03:2d0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 12:42:22 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:42:22 +0000
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
Subject: [PATCH 5.10 0/1] Hardening against CVE-2023-2002
Date: Tue, 30 May 2023 15:42:07 +0300
Message-Id: <20230530124208.242573-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0076.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::44) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|SJ0PR11MB5117:EE_
X-MS-Office365-Filtering-Correlation-Id: 84b5adf4-8bd9-4025-1601-08db610b504d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4mFjX3mX50OxsNtX8UzRJPhnFbzg2+Ezvj3YQjN4Ob6g/b69m452YjtO7Kx4cN8noJgjDiNewWqp5E9NcWVQH/eDBVrXA01GZ0YBfRZdV6KPdbZHoHo9joJGBg6sZpMXKyz0HMwJC6spxNE5cyZNJukk79/Hj+Gq09ma0hyAWMeTDcYGfPpYCkNeVQBKv79SEJ1ArNoM7gQbYZCiNnC6ixM1b8w44MC3Tsf6gHARLkiYeQ77PImUBaDdkxuMv8/ZGkABkM1HRuleU/SeS0/8HpTIBikZ4+zfA9Y8SmAbKlKmPoybl163s8YGNuFW4j6b4XBilWop5sdEi93pxmSMwEl5lRoW1ffjE051JmBA9s5XCEGObxBdHLuumAdnuvlunk99daVrhnH+ZieW9vgrt9HglJcje3ZVhFgniileLPuEHhSmKIzogI9c3wp/CXJNlwEMTIi8PcGcX+7/cza17qRp46mh71N6X0UaWYi3GzpvGgSZmdicnsOtlNKmh/6Aau2vJxWgsrfovyU1gEvZRY1y/kXFGvcKh/ES/o4o3UlALZuPUfa+odmSLUzZhj8DrpsX9rNH1lQJZuSzH08phNpsfza8k5rxQPyPptlsn0I=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39850400004)(136003)(366004)(451199021)(186003)(1076003)(6506007)(6512007)(4744005)(2906002)(2616005)(36756003)(6916009)(4326008)(6666004)(316002)(66946007)(66476007)(66556008)(966005)(6486002)(41300700001)(52116002)(478600001)(38100700002)(54906003)(38350700002)(26005)(8676002)(8936002)(5660300002)(86362001)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?UV0RTJEA/cXjCXNHAqFdQbDDZ8norJ983wSVWhTULGAJr6CG02FYqE4goyHF?=
 =?us-ascii?Q?LNgW6fu2NI1p09Kp61ps2WOO5X9tqde3DvK3g06vQoWdOh+U1uqhqur2dtSy?=
 =?us-ascii?Q?1Iy7mgjOGUgJiaoweCPmqNzThlWgPuft5IvopKT2OfjRNDPdK6go063oLd94?=
 =?us-ascii?Q?e3ILYqjLXdL9BzZs/LotkOBQeFZsFbbbXg0GwLbDSOWF/mtZaJ9EIcSzQxOn?=
 =?us-ascii?Q?CAbxYQe8fb1braz4biXqBnoMNf0YFxR+VfxnJRcYfNim4+WlejlfXop9urQM?=
 =?us-ascii?Q?8f4y6uQwRNmA3yVh/KV8GEzaUK38aLtdSv0RMnJTr8TJe0Tb+U2Im6mZ14Ol?=
 =?us-ascii?Q?Ob9YS9ei4sN6ZUF9FaS4jrn88Kdzga7ivTx3Uw3rmngXvi1NNQqNSMXR2hdz?=
 =?us-ascii?Q?kz/OnCMeNYyyYZnCvj4ISKlbu66B6d65LW6vHAOw8zNZv7rLsoDi3aDUT2Hj?=
 =?us-ascii?Q?tOgbk5kVTCeE8SbMLcBbr9Cc8uGpHeiF7rc8BIS29I+qv3bG0fIzYfnHTgWO?=
 =?us-ascii?Q?prTxtC7au0sGjDsaWHEnzqZzQMLJrvVQ8ltVpMV0GgkSUdCGpCip5622BPod?=
 =?us-ascii?Q?WhAUOpuThletQGEBZAF1fqVwuJL+C4sGOBXFKi8PMNeS9/7tfHY5Wc/RO2+B?=
 =?us-ascii?Q?YQZ/rJkZhYDs4d0gBWKVP0C0RS7DDg54Vj4/Og4NI5uwuGBrJBsbNpt4ThFy?=
 =?us-ascii?Q?4psFWmUvVRCHH3Mb2JFUv9dOFGbqTwyB2u0uHE067fJU17My3vfcpJ1ddeUr?=
 =?us-ascii?Q?iWDBvihViyqJqZWu9dejncrFLNDsrB3H8dGtL33vn6f19aIsgoEiG+8OpZib?=
 =?us-ascii?Q?pwqskDkS8dvv6GKZ/Co0XSqr08+m8tlFrYawQBTUOKSqbfJpGmKX4CNzEQN6?=
 =?us-ascii?Q?o0qesEthQ1Zn3ioZzHJkEzDhPPx7+rqmRv/+6DHa0LE/kwGgXxG7+XEeGaav?=
 =?us-ascii?Q?QfZZshsIJHNh59wAvhBCoY9IBORC96LdD5wKecgYOw/KbYLOM+oSK8yznMah?=
 =?us-ascii?Q?1pUz4W0vl/uA6AY9N0fBe23wSSHoBd+SW5Ste3quDNMrHzoeHdokUAW9nSX4?=
 =?us-ascii?Q?Uh9yBHq5sf2YhSXx8U+ggUEZp8/gjIFIys4OI9zYbasl7eJ37H2vOy7hobEp?=
 =?us-ascii?Q?dwxzxUovTAn82Xteq/r5XfJDueqEfdA07egpw4+NEmiMeZ7DXX0ZXekgXmNk?=
 =?us-ascii?Q?PO83H0atuBSE5idgFbvkhSgo0V1Qtt3691qVqEFc+YUipEQL8ELIgoUy0tRp?=
 =?us-ascii?Q?5OAPROE2Es7Q6hORTqTvC8IwuKb81R3/RXWdv0QT7yO7kUWX4+lv4vgourKG?=
 =?us-ascii?Q?Lm/t5XjL4oNJIkFK2dcZs/cCk2Edu4ToAQxM7aFIuy7CsqpcnlxUg0haQpkA?=
 =?us-ascii?Q?WqVrTWJdR+8JFplnUSJydQew9fDdounDWCE3E9M2qBL1ZO2cyiNDvISGYN2t?=
 =?us-ascii?Q?BOOJzqNhDHRPJXoBq25+iv/jFVdy9I9PmQmxeYmtBlzvEN1ELwUuo3MfH8No?=
 =?us-ascii?Q?sR9l6khKMemoryoNK+3wKWBtTdpqwBesTtEhPL2RjFS7AZOFBeTR7L5yvmHB?=
 =?us-ascii?Q?z/QAI1+WvvjH4Nkv1UeFiXCvOnEVu80pVcezytMqvp0uvVgLzhya1zko5xxf?=
 =?us-ascii?Q?+A=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84b5adf4-8bd9-4025-1601-08db610b504d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:42:22.7066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WMpAEyxmxy8emj41E/UnEAkvBSxd+ww+zrLK0S7ycOIqCL5ILCN26+oeEJJUzJMClkyZkNZFfpEPQw5fNRZXf64Ek1dw/p/qqO0M/4nVADE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5117
X-Proofpoint-ORIG-GUID: zeQPKb65bBnngAQkxlHpGA0kK62ochhD
X-Proofpoint-GUID: zeQPKb65bBnngAQkxlHpGA0kK62ochhD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_08,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1015 malwarescore=0 bulkscore=0 mlxlogscore=602 impostorscore=0
 suspectscore=0 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300104
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The following commit is needed to harden against CVE-2023-2002:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=000c2fa2c144c499c881a101819cf1936a1f7cf2

Ruihan Li (1):
  bluetooth: Add cmd validity checks at the start of hci_sock_ioctl()

 net/bluetooth/hci_sock.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)


base-commit: 4c893ff55907c61456bcb917781c0dd687a1e123
-- 
2.40.1


