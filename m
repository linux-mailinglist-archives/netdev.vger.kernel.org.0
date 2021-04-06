Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF14354BF3
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 07:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243725AbhDFEyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 00:54:43 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53910 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239685AbhDFEyl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 00:54:41 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364o270075949;
        Tue, 6 Apr 2021 04:53:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=z6WUpdpP7QuueY+6HVjqRyjPlcWvW85PeHWksryxc1s=;
 b=SZgD5nxpzoPP5BC/kCwEtImG++GGuRJ0VsqbamZHDVSVjgaRvtQ/6rVKOY+yEZKEyaDO
 CLcSPT2WMzlgk+oCe9lnQfwmIRFUHkunczw22nyPnuFT6fXAHjB83QuQW3E2d7pZPU27
 qySJdDM8rjLgOxzYD1La6zZp+F/nwteSl4OYbk7olbPnzAjewLgFZSYSJsh9HT4yO9fg
 gYkYZzp1l4shtyjVdZHLIUk754lEP7qacfu8Z0Ruf2YDZNAUt8e3yOlNDRuTk1xliiih
 TH0fIDyeCY2obmPG7Ajwy80lBmEYoL5EpSc0onIHDnrXjlstWlEZ00Hee+afFMCDS6bP 9Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37qfuxbbu3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:29 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1364ox0U070460;
        Tue, 6 Apr 2021 04:53:29 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170])
        by userp3020.oracle.com with ESMTP id 37q2ptrhk3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 06 Apr 2021 04:53:29 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SAGSNV40JtFcwq3X7jA9RSJD/Ev1XspRw/n8rPitetg5YIpFELbxK3V4M+KXS0UszdBmvaPFWc3vOFsdhip6jgK5p9jWQJTwlT9cvPzSS3vejPAuLNGfMs0SHh/b58Q9Yq33KftC273jCoZcxuw4KKrR/CJJSDWMa2W33F/GYvHtRaGVIdK46vRGyn3viQqWQ3XV77ltcHl6QLvZavRHM54eKom/a7GgX3cx29O91lqxxXdd/9SdQgccR/wcM1qU8gMNJ/eldKEc8JSw0fYXyVZsA2/d8VjJQm3twjgvRCXNHGVtYSx0gVm22P569EPMke/Me793j0xQT78zf3EyFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6WUpdpP7QuueY+6HVjqRyjPlcWvW85PeHWksryxc1s=;
 b=RCWQqqIce2QJZRTRPi0FuQETmNMEsa+8gCTHOwOrzt5mueeqEJKtnmlrQWQL1kDPfHVrWMHYLAvQhknYuqsGiKrKTXXTewDGoGg9Hy4YcdgrFHz2+7eSI02p0Jb093+3wllobRXe5ojx6McrotNkmKktg/+R8bE0FpGxVxVUlfhC72AjNVzlPDbiGM1rfTSRQYy8V3I6Rtot9bqxX6zulr/w1nyWYSzE9E6rOVNFdCvGXYvtuZmohMDKfrIFEknu0O8ikA+6Hx+IUC4Ne1L3a7CQEaQ2RjYyWocbQB+s98zP73upkHs37i9gq7YO8lbQcQuvNtdrwk4pKC+piWjjcA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z6WUpdpP7QuueY+6HVjqRyjPlcWvW85PeHWksryxc1s=;
 b=d8dNvvSXzSsDMO6sC7yDvuKOp/gJV3ecOQzOQPp5O2/jZPQE7A53hdLOFYygRW8DLoGoYFVHzeqRK9yCO8B14byUHVGUWJJ2W+OasQyi0zfXgDxuNIw/p3mYFpaj2yRzZp0HArxHhc3nAKGKrN9oI/hgzaxCNK8dUiv+C525g/E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4407.namprd10.prod.outlook.com (2603:10b6:510:31::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Tue, 6 Apr
 2021 04:53:27 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 04:53:27 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-kernel@vger.kernel.org, Martin Sebor <msebor@gcc.gnu.org>,
        Arnd Bergmann <arnd@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>, x86@kernel.org,
        linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-wireless@vger.kernel.org, tboot-devel@lists.sourceforge.net,
        ath11k@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        Anders Larsen <al@alarsen.net>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        cgroups@vger.kernel.org, linux-security-module@vger.kernel.org,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        Simon Kelley <simon@thekelleys.org.uk>,
        Ning Sun <ning.sun@intel.com>, Tejun Heo <tj@kernel.org>,
        intel-gfx@lists.freedesktop.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        James Smart <james.smart@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 00/11] treewide: address gcc-11 -Wstringop-overread warnings
Date:   Tue,  6 Apr 2021 00:53:17 -0400
Message-Id: <161768454091.32082.3141021591391350544.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322160253.4032422-1-arnd@kernel.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN7PR04CA0193.namprd04.prod.outlook.com
 (2603:10b6:806:126::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0193.namprd04.prod.outlook.com (2603:10b6:806:126::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 04:53:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f385b0ec-113a-4387-b9b6-08d8f8b7ea54
X-MS-TrafficTypeDiagnostic: PH0PR10MB4407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440778A91E46EBDCE62741098E769@PH0PR10MB4407.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 93uHS3GeWRBYH1lOKR45QUqNQwRZQxoCkbtPesys8HPxVodQfcYx1A7FwnjQ6J7pvxo6fQxRdHYR+FxcuaptEEe+5OA/W/c3kwaJ6ckLRy8rJoJ3EKqN5ApyalaqIMuKr5rKBCO1uSiGgG05qQIe0jGFtmXt+7Htl7UrFKazxK7fI53oojqGKl/C/Jzmz83sdd4lN/ZqxPVRxRMfxsQQqR3V1M/e24Gd5Dp8AuRZcbaZkzltqhB0wukp0pZw0wmwCRSkDoyIuj6syX4v0t//0ELOWq+tupyvGKuHHuCkn7N/Y3q2Soo0bRzJ4npiXuYhojqNvZ3QpUm9/7ua9s9FnKwPqgGgZImGuquSNvFOJK9iGHD6ZnUDmQgGx+pakdUl0X6aSMSgXY/cbf+F3/3n+zwElnVT52jn2xPWNL4DD9vB/RMxItZDDakVZNR4EawhLxUzFXaYRJZyTj1EKrnS5Emh+ERRNKo5O1TI6ceqNsXof5LHymo4GYSHDcnTkeUXc6OVEH2lhNnNqjsllAt7RORmWt4FmxkHcP+yYL1bDyZh+NI1bnbVQXqWCTuB+q4rI5r+pwlALMdu5e+f8km7h/MRnJeNh3ehNllJ/P9Z4XjQDdFmxRnqxinfU0WmgzxQeUQFqQiYylJxnkP8/ZEFIfJ20fCN47k/8sI+DtvCW99i+wzme/Ajk/3tEqINiYAUWT+bGqXkDoe0Ty7RvsPm/14+ULdeG9vvL47Qce7S2gEPVH8qzgcTisE1bKCaygzJKaofWxyGj/c9RR2tlhgxvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(376002)(366004)(396003)(136003)(52116002)(8936002)(6486002)(7696005)(66946007)(66476007)(186003)(478600001)(86362001)(966005)(8676002)(4326008)(66556008)(956004)(2616005)(6666004)(26005)(16526019)(4744005)(7416002)(36756003)(110136005)(316002)(2906002)(38100700001)(103116003)(54906003)(5660300002)(83380400001)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YURqcGlvY3ROSmtUTHZFNFIrY3lKV0RmbWcrVTVzdDRPaFVxRk5uVC9QZWVE?=
 =?utf-8?B?akxpSVFEODl0MzZ2aDRSV2VMSXZ3V0VTb2pnUVc3K08zTXpCeHNyNGFKR1J0?=
 =?utf-8?B?K1ZvTXZsQnM2VS9mdnFEd3R4aGp5eVVIL24xNGRadXFONnNpVCtYOXRXRFpy?=
 =?utf-8?B?ZVJKeG1HQXZnRnBaM0VJaVpIRm5WT3l1WHcrRnBMNzMzL1RvZ1JDT2txVC9a?=
 =?utf-8?B?KzNzTk5PU0J6eEc2L3hRTWpnb0FIVTlnRXhCUXArMUVXZlgvZGFicHh5bHlr?=
 =?utf-8?B?SndVb2JCZWtrd3FJclNmVllEMStDM3VNUUVQSm43Vnc0bmdYUGFlcnVvQ1hO?=
 =?utf-8?B?VEhPanY4amlDWUcyTWFJQ1RWVHM1cG9MZE81RDh1T0hKd29aT0t4Q0FzSUFO?=
 =?utf-8?B?WENkdFlzUDN6cUdMMTZwN1RJcEdwdkFoeDk2d0xiUHNrYTRteGkrYmR4SUdt?=
 =?utf-8?B?UkZQTXU2R3dQdWN0aUJUMzk3bXdGVXZZMzdmSjIxd3ZZOTBodFpOTVlCTC9V?=
 =?utf-8?B?NHMwSnlmUFNzRUhPb2pPZ0lXSGxhclBGWGFwWlc2NDI2aHlVSlVkVHhNa3RC?=
 =?utf-8?B?MEJEamVjMFIwRHA0Nmxmd3Vid2JRRUhuT1UrVmVIdy9wU2RMVzNrRDNlQlA3?=
 =?utf-8?B?UGROZTVVTDQxa3U1ZHdVTWxnYjVIbXl5R3ZrQU5CMjBJK0U0Y1lVN3dMZ2ZX?=
 =?utf-8?B?WHo4Uk95Q29RNGRSVUZYY1NsRUFYWnQxMEY1ZnkxcmdlaEtYN1k3YjN6SXh5?=
 =?utf-8?B?NlNGdmpBeGlneVlIVU02Q3UxaXNFRzZtL3lCWSt1VDBPTHR1aGoxSEVsYzdF?=
 =?utf-8?B?L2lmWHBWWUVSK1dGK1A2dDhQL01HYlc0WUdRODVyNEwvZ0dzSWRBSWhmblRk?=
 =?utf-8?B?K3lXb21TSnR6U1ZjakQrOEgwTGY0WHk5MDM1QkJPTmV5bWZ0aEFjT1dwN0tQ?=
 =?utf-8?B?NE8zM1FPSFRvaGtSeHUzNTZsK2NuUVBHTU9waEg2THZwdlB3RWd5QndUMVA1?=
 =?utf-8?B?UXFQaWtVRWE0Q3FTbHp1cXlLSklvUVgwVWI5SGRIMmUyanBGZVgvd1hyQTFO?=
 =?utf-8?B?V3lFRmhGSmE5aVNJZHFoYTZXYkFpRTIrZStrMU12ajR1a050MnJoNTh6VXhE?=
 =?utf-8?B?cnNxTHZwQkRQYjZzTkFnR0NKbHh3WUF3ZW01NVdRQVZ0emRHODFpUllmYURw?=
 =?utf-8?B?aW56MnQwN3NQOThwZlBXU3kwVy94eSs0MHQ2UWVxdHBRdzdTSnowMkFKMUJj?=
 =?utf-8?B?MXVhcFpXTXZnS0JNbUZxelc0VkZHSURBNFk5YzlGTDZ6cUYrU3h4N0xDT05x?=
 =?utf-8?B?VW5OSmhzcGFyR0Q4QlF3SWpVeUEwVnQxckcybm1uUk5TNkZ3RlRZMGp6Q0dr?=
 =?utf-8?B?TjNUVkJZWFJRM2dyV29EZWlTc0U4ZWNteTluaWV3S0JBWXJNUkVkbGIwOENJ?=
 =?utf-8?B?NStyWkdpOUxMMElVM05OYmV2d01LYWtYM2I4T2pEakd5d2xMekxqSDNoQjJN?=
 =?utf-8?B?N1FRSUptSDNlNDJuWWt6a0UreExzcWdZNXBOR3g0anJDeGk2SkRxWEhKQjZw?=
 =?utf-8?B?U1VNa0RaOTNyWndyUTNkWmM2Rjc4cHNQOEJyZFFxSDYzemtPY0ZFWjZlaVd5?=
 =?utf-8?B?N0NiSDY1aVRuQWdQbTh2dUx1V2tENkVVMk9YNDFraFdoR1lqS1ZNakFhb202?=
 =?utf-8?B?TnVjTlhMU0ppQ054VGd1U3V5dmtzd0UzWnFjTDJBUnRNSnJsZ3ppeEpFT3ov?=
 =?utf-8?Q?5OHyi5icPi59JqAm82Fnd0uLlP6brlh28gYHedq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f385b0ec-113a-4387-b9b6-08d8f8b7ea54
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 04:53:26.9548
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xmVdxnGdf7a2vnYXIwTtK7NJsct9SYMrVudDygXaznCttKr22dqZGLJ2ixyBv/3wty5+YXVUWk6YkXKH1mrVgRPp6OIfH9PLVeRYRFBLMMc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4407
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
X-Proofpoint-GUID: _1EE_DsccH4Sfb1pX4B7aUVVtInHHQSF
X-Proofpoint-ORIG-GUID: _1EE_DsccH4Sfb1pX4B7aUVVtInHHQSF
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9945 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 malwarescore=0
 suspectscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 mlxlogscore=999 bulkscore=0 spamscore=0 adultscore=0 phishscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104030000 definitions=main-2104060030
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Mar 2021 17:02:38 +0100, Arnd Bergmann wrote:

> The coming gcc release introduces a new warning for string operations
> reading beyond the end of a fixed-length object. After testing
> randconfig kernels for a while, think I have patches for any such
> warnings that came up on x86, arm and arm64.
> 
> Most of these warnings are false-positive ones, either gcc warning
> about something that is entirely correct, or about something that
> looks suspicious but turns out to be correct after all.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[09/11] scsi: lpfc: fix gcc -Wstringop-overread warning
        https://git.kernel.org/mkp/scsi/c/ada48ba70f6b

-- 
Martin K. Petersen	Oracle Linux Engineering
