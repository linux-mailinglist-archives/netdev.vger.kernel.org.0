Return-Path: <netdev+bounces-6389-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 186D271612D
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 15:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C23802810DE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 13:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22BDE1EA87;
	Tue, 30 May 2023 13:12:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F69D1DDD7
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 13:12:27 +0000 (UTC)
Received: from mx0a-0064b401.pphosted.com (mx0a-0064b401.pphosted.com [205.220.166.238])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3EC299C;
	Tue, 30 May 2023 06:12:26 -0700 (PDT)
Received: from pps.filterd (m0250810.ppops.net [127.0.0.1])
	by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34UCNOsc001382;
	Tue, 30 May 2023 05:57:50 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=PPS06212021;
 bh=sqQgc3rvdLEkhp/Zu7NmA+Dc6LkSYq4aAymjg9n3I4Q=;
 b=dGBLcybgiykVOmfgK3Dtr/PRBP9cqB6R/uheAXqmSA/bF6FRK04qNpJDTybmKMHuLyIG
 StG5YUqhZ3PT4fY7RaVGXplQ3vBoRVoQyGoNlKgJsgDWNdx7T0D2NStzZid6I40Ms7yx
 CRVH2Q/9Qo2a3W0rgxS8DuZ47qEVwDkNtQkeZ3XOJG+RR5ljoqaV9GwaJacmMj9IJPWE
 Tuoo8+i38It/sB38Aox9GEdnEG1Kku+F2oC+hYck1h6JK/f5wrqb/rZZtX1m+ioeKXIa
 nmQyhZHT+emgO3Ez1cVqmI3u/aQURCh+ixFa9JQtpPQqFF8/xxh0rmUxUuKkY+cfGgpQ Dw== 
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
	by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3qud53ad0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 30 May 2023 05:57:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YSMdYRe1j+NCVXkDX1dDBMAidLEzhz0Y3jzuwnY5g2KyNl8VQieIgx/ytLP+vR/YD2hQQi9XNhBSsRAMyHchnEG7v+2OIcqF6U/hljqPB6/bnIPZj22P3o8e4KSpXrNVVGLP5fG0D5Zw030roYCXYqoJcOr+Txk/QVpweuPZnxJJ2ZLI/x2PPLbsMEZfzZIYSt3s55R7s5YLH551jFDrz3uvpSgVpOZeJqNTSeiiARwWwCf3b4uDH9Wq3PD1KFXa/bQ7MU39xUdwOXALmCnW74dSr3Lqa22lPumW5ItBuuH1LfIByECaRzeEwhnFlEVaKne9+DOJyzWdI3reAsW/rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sqQgc3rvdLEkhp/Zu7NmA+Dc6LkSYq4aAymjg9n3I4Q=;
 b=oaMDUiJY7SIMpYDwNzKOy1ihGrWLJnvJ6LrhXvcpZQoBVdO0h0UDsXcI49DlY8Eqjo5C6hDFNaxraUDeqIM+x2h3ItF3GTxSqoEY4LDNQtpMPqhJIskfVKdshII5r6aYn0W6K/3rypA/vGTVMxjW97qT+SK2TU0fF8yQIcUjeGXrGDAqSXbRcweE2N57+tyFJAlHKwehOuFSrGSRgPeaN1k7psXmbWowM9lNw5kKQO29ab2QkE4sq6eQgE44ZIOTJ8P5+EEOp5ltgGMAqMM+cyKmyb2GPZlXzwkpl2QVLvRyti3RuvntAhDqds1SO+9u8tEzpEzVYuEck16wemZJ8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from PH0PR11MB4952.namprd11.prod.outlook.com (2603:10b6:510:40::15)
 by PH8PR11MB6562.namprd11.prod.outlook.com (2603:10b6:510:1c1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Tue, 30 May
 2023 12:57:45 +0000
Received: from PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa]) by PH0PR11MB4952.namprd11.prod.outlook.com
 ([fe80::5693:5120:1f58:9efa%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 12:57:45 +0000
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
Subject: [PATCH 4.19 0/1] Hardening against CVE-2023-2002
Date: Tue, 30 May 2023 15:57:30 +0300
Message-Id: <20230530125731.253442-1-dragos.panait@windriver.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0102CA0027.eurprd01.prod.exchangelabs.com
 (2603:10a6:802::40) To PH0PR11MB4952.namprd11.prod.outlook.com
 (2603:10b6:510:40::15)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR11MB4952:EE_|PH8PR11MB6562:EE_
X-MS-Office365-Filtering-Correlation-Id: 783c67c4-0848-470c-c996-08db610d761c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	K2Qbu7HHa8b23e8lMbBB5yl3Q9+647c0lT44zn347fKi60B9S3FB1JkgdFo3a/R683tHDekWShyCTA11MhseeAi1+1lfqnJYeWNwKtS8KpWKgtefwe6eADLJ/hImrJJMYUcXHHIXIas1yYT2VcGZo41sim1kwsqZRHrfuR82UOTUrYPmJTiw8QWK/GG82Hp1oc8aPIrwwPh+J2ZhqB9N3KBcm8YAia5bQvqtlnjXqq30V4Fj2de8dMtdEVdapiSKZcsjlRaL7NANER6D65OaNJQoQFHemmWXdNWPF7JrfNlzYrU9IocqSwcdFa+SXKJVIEQ1L4fwmFhJmEM9sd9R3oZ9N6b7conlmFm9ANKAC9+cK0cVAOvZjO4x+8/oAOYJff2GyNIfRrWs603NN/MEyuLNMPPh2G9f51CMFhDbvGDGFOAm5fbj/Amsn6xWzXIp9QcNhkEgt2JI4JH8tN4/vjicBcG21xYQzZwizdeBR0/XrApM4wG9MdZCtl03I96QQ1L196Antx0g153jENBvPs2gEOKbJI8rLw31Q1wzM9yLc4CKoeIe9TeYLBELwkEOxi4YPR2qb5zIz+LlubN4fABrOwtrTQjUOESna/wuC6g=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4952.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(396003)(366004)(136003)(39850400004)(451199021)(6486002)(52116002)(186003)(5660300002)(41300700001)(6666004)(38100700002)(36756003)(8936002)(8676002)(6512007)(966005)(26005)(1076003)(6506007)(38350700002)(54906003)(86362001)(2906002)(4744005)(66556008)(66946007)(6916009)(66476007)(4326008)(478600001)(2616005)(316002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?Cf21LN7vmO142/5rQMu3xLO1ZMwbWb1jZ0rg1p6NTFsNJNFpjWoPqR86ubG9?=
 =?us-ascii?Q?frdk3NuJ9BDoQRQwARW7OhrfcZZSnqk/vNQuGbNIwupyGPQFLlQEFqf+MdFq?=
 =?us-ascii?Q?PXie1100EC86FFXlu06qAO4fFb+ldMeEOkPoukSTeGRv+a/ZJ5DJL2SAFXq+?=
 =?us-ascii?Q?mOr0Rdy1k31yMFpkEncz97Os/UtqkWAenAsj40nw8yCmTGrMeeyvcmIPDQmO?=
 =?us-ascii?Q?ZKr7oJberN3eOB63frqHVotMMr4WFH4L/5r1Pgo7EsKp53SW3sZblXlVUAq+?=
 =?us-ascii?Q?qD7xgRCLa98Pgf6K2VwXwWUkTmNQ/DNP8eR5rV/dnqMRSJn56Ia2tQNJqJqo?=
 =?us-ascii?Q?Fhpga6Jbsqw4rSGCKJTrLmhafVysD7PIWdhXaasOko//yejCqiOXBbsmvGMe?=
 =?us-ascii?Q?pCrU4KwSP1CyD0Wr4ahHlSt+gBM0hb9vxcZ1IsmnHEIxvWuiCUmB2PdaSDZh?=
 =?us-ascii?Q?M4MlMc82Ishwptthbmk8rsJLmuZuGXOVqIJijntUphBXKw5VZ528HWeQhB0q?=
 =?us-ascii?Q?xppdtrBViWhkYEVgoWZZxscZNfDyJNUYvWHTUHasAlNdkT0vTLDNCu02ii9C?=
 =?us-ascii?Q?Tk7XPcEzZiplTC+ouDAPhnDu724MweQCHDWJn7PZNiKrU+zkI9aJo7sEarTc?=
 =?us-ascii?Q?YOrEvkVdRFa/TXIqVx0k3aGn/FjNa0ZK2bgNzvnXOqU0rrsM6ZibuZrP7s/R?=
 =?us-ascii?Q?SMq+8OGjEvTLQ1CLCeoSINe3qdrKn1CtzhFzaQ/6RDn77/RHFX9mFFJPzsc4?=
 =?us-ascii?Q?rV4xcZjOSqeo1QJgLSsg4Ux0P6k9iVR4BvyA6fn9y8rXR/gl7E/uN8vWEo5/?=
 =?us-ascii?Q?FJb1XKeM2ouEpCJDeQh1EWic/7qAX/HHPwzVLMCaP5TmU5RfCfh93Fbtp7TK?=
 =?us-ascii?Q?92kr1FwAXbxX8c2/JSoqvu1Zh502ILhfgIFne0xqeJHDQVl2CSZOB3cun1iz?=
 =?us-ascii?Q?8XwQWnTs49Rd0eOiPAZKW74x31Htw42F2tJA/hTToA+WcwI2oLI/20mIgjh7?=
 =?us-ascii?Q?x6eDa71OoOgvvF6Skinxi4Q1i/Whv7d9ro+R2PQGJJ90npQnCwFvWlkhfx3p?=
 =?us-ascii?Q?ICcAsW9mScHTdy6E7UZZrHUJjOyyHyJIPy0y64uFqOF/SeDASHj6fBk+M72a?=
 =?us-ascii?Q?Feg9QECPDCe9FaJwtnpvUYNhofO/5i4BvNgSG0RTjaktaEyVM2P6rw9v2+1M?=
 =?us-ascii?Q?AGvcwxQsTh+wg1cLQaZxblrd5WMfQ0yCXpKDmpV1WHJ0jB4vuxNXbekCIWAO?=
 =?us-ascii?Q?L80kUOOCXnH2Gu6TXohf/uT30+W1L7zCSd5ZwQO5Ce3Ra5h/yibcKwRrMryG?=
 =?us-ascii?Q?o0N30oXYHX/wIq2SXkjFk3zLV0m7ENfhUZTFkLU9x3YiBzijXgv3FwmpJyzj?=
 =?us-ascii?Q?71F/NWZOJV7w0BYUdY5c1dxBHWHjXbe+TjMcrnbT82q1C0mkqbwRyi0Dv/OG?=
 =?us-ascii?Q?ztQm+qiF5FHRmuF+viEFVNMc/8JgMXE9cZcfwhDZrGu54PuG8mpEjICyWWh2?=
 =?us-ascii?Q?tkwhbArgwDblQo5accANcIvf7JmmO8fAQQNLBSUJX/YFDBt0lAPhETI4Vh01?=
 =?us-ascii?Q?ufJTfntQ8ga9umr3gWRDjAZqI5JQ/wibHoGLtT5Tg161rCgQvb/kuFYbnUvV?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 783c67c4-0848-470c-c996-08db610d761c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4952.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 12:57:45.1441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g+s/IaDMPmyDYJoLBLkr/x0+hgvupbz/i4EkaevPGRGScMf+Xcd0Si+toJnJ8Prl9LzwcwTwrtaJVO1YQ01raYQVoduOk+jCmg/Q2KV+s4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6562
X-Proofpoint-GUID: M6BtJHeaN-yWPxTLY0RWB6aVAY85vSa-
X-Proofpoint-ORIG-GUID: M6BtJHeaN-yWPxTLY0RWB6aVAY85vSa-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-05-30_09,2023-05-30_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=602 spamscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 suspectscore=0 mlxscore=0
 malwarescore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2305300105
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


base-commit: 3f57fb8b1bd06b277556601133823bec370d723f
-- 
2.40.1


