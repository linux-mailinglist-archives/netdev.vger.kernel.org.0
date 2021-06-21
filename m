Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 312793AE5EF
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 11:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbhFUJZV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 05:25:21 -0400
Received: from mail-mw2nam10on2113.outbound.protection.outlook.com ([40.107.94.113]:54753
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230411AbhFUJZU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 05:25:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a81zfzRdKL9oPCFLvDgxOaW5SQRNqPWKU16RcgqL5TtdsDmUnnbfV+dgvfveuFL6FcbknbcAnkDO4zgJC46HkwYLdIzi+Y0TAT7tKx8tZffFKQolRZ4JNbIK2dYLJIZlyKKkJxAiGhyF2m9miMubchDzofvJSkBAoR84UhnHGekwGIhthKj4IBJd3Q3izK3X6YgCz/sIxPp/k0UlUet+1RnMuNSGJwHjKaPIRKvAFmup61PzzPNMhoACsp4yWBjykeh3zjoSJJYzHhUfFM5uUXmTJVUWq3Be3HFVy3/saa73U/B3lA10EZZZk/RnFvOgyNLrGRUqpu4/G7zgNqgtNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHh2oIVWk68BMNVvWMlL1e6/WvNUknX/Ywxo9LmDuyQ=;
 b=GhCYL6gzd79Og5p5mmKcVzUr/Pn1Rw4WlbQ+BQP2Wry+b1ID+OmHtzg/UYh2gmU7CPRT+pAXxVZww+Qzp21/FW3YWPXB67YZ/It2Lj9sPyVhSZ44ynzDSwgnaaj+zEiI58R9lrlHJHOkITuQG3AP+w8T4bbhKz2BYxyafSZu/gUsMAZKFHG/iwu/pjnw9Ij98pXczqYiaO9HcjeZ3fwqgj6sQKWMQHNhmkd2aHJvlTSHnvk4c/DdZEfb0B7c0CSmFH6RKQX/vZ0cRCAwIg0jYM6U6XPQZWVTStaepXlTO6KkcBCkRvOovYGDLqm6EXDR3ENoTcYk/FDNzyULwGbOLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oHh2oIVWk68BMNVvWMlL1e6/WvNUknX/Ywxo9LmDuyQ=;
 b=N0aOE0Ea4a3I9P4mRN6Z4xP/VTFS5Q6GVGkIuuwdo93nM9uoSoVywc9iC40HnTSth0+/hDghhHV1HEOiyGM1a3WtyID8WoKnRqLi7kFLYfMjHd/sbSgCrPp/sz1/lMyc/6nflzb76vdEa/gpObWkQLGZEq6YjKVivwJ4YrsZX/4=
Authentication-Results: corigine.com; dkim=none (message not signed)
 header.d=none;corigine.com; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4828.namprd13.prod.outlook.com (2603:10b6:510:93::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.9; Mon, 21 Jun
 2021 09:23:04 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::4596:4181:eeee:7a8a%9]) with mapi id 15.20.4264.017; Mon, 21 Jun 2021
 09:23:04 +0000
Date:   Mon, 21 Jun 2021 11:22:57 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Louis Peens <louis.peens@corigine.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Yinjun Zhang <yinjun.zhang@corigine.com>,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] nfp: flower-ct: check for error in
 nfp_fl_ct_offload_nft_flow()
Message-ID: <20210621092255.GA26859@corigine.com>
References: <YM321r7Enw8sGj0X@mwanda>
 <94d89b59-fe5b-d959-e2f0-9e42ebf73636@corigine.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94d89b59-fe5b-d959-e2f0-9e42ebf73636@corigine.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Originating-IP: [2001:982:756:703:d63d:7eff:fe99:ac9d]
X-ClientProxiedBy: AM0PR04CA0116.eurprd04.prod.outlook.com
 (2603:10a6:208:55::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from corigine.com (2001:982:756:703:d63d:7eff:fe99:ac9d) by AM0PR04CA0116.eurprd04.prod.outlook.com (2603:10a6:208:55::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Mon, 21 Jun 2021 09:23:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 768939d1-3901-451e-997c-08d934962c2d
X-MS-TrafficTypeDiagnostic: PH0PR13MB4828:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB48289E89402B493FA09AE477E80A9@PH0PR13MB4828.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1468;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zeOFvQi27EGk1+e4nXQC7/ggtOas9xOMP8UjyKBSuo+0sJjunvDXbrrYOTiL2/5eboCDAg5sDiDGnKHfRgzNfcJmq0Ods1FW9lvQr9uKMYjPP0mdLMVaf8JnRgnMa8hrdHmgN0fW6R5sl4evcN1UTD2zW16JxS4V5ArrmgkBuFIzBIIWbCEAL45N1cU8FzBEp1QVkEDGkJoMtbv1ENiWKhy1aIlIO5DkTBcm3jiCvF6s0fLUsvFk9zWREaQrcyb4920C7YHn387VmbRwiaULix/dNr0CAT7seNr0C3Imi4RQvjayBM9/a58pFfKxCyPQmrZUwVLo0fDRHTZx5EWUsL+k4lc2n/c1+qy4Ak6OuzYSUR9FLOddbfmvGShoThXEWEtOlVbfaXK2uYM3SZmC6cPH+mWL8USuVcU6rX2HnV2atHcHF4ZtLaX0jkZiL/eAMzGhkTy+no21+DcZkN7/thJdcmmPf27LJ4Akc3l84+agn2RpP5z6xUbyNpLDoC2R7eMWzkoGKiol4NtewGYnG+KicqzpWbWfqXRtE0cKacHnLwaeId6SH5hUhlwr/Hj2YToi6iFWjByInmmFFonRriwidiicvWbbbwCgMCx26kOQrHiTK+Ic0dmFM3gJlSSlaVO8FxpygwMS8UKmGofRiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(396003)(39830400003)(6862004)(8936002)(7696005)(2616005)(2906002)(52116002)(5660300002)(4326008)(83380400001)(86362001)(316002)(54906003)(6666004)(53546011)(1076003)(37006003)(44832011)(55016002)(8886007)(36756003)(8676002)(6636002)(16526019)(33656002)(186003)(4744005)(66476007)(66946007)(66556008)(38100700002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MjfNIiGPWyWtXm/XyjI/UY1q8c3SvufldMGeTUzbQhkK1bmXYtK+dUBLEwZg?=
 =?us-ascii?Q?xA4GSxf4vP0HmsH2VEZOr/R3JGZsOJDrslFHTBVRtr2OLf1OR3NeJqqiK5Qr?=
 =?us-ascii?Q?TfDeno4lqe0FdGxYKYCOV+8xHKzvy/uofZ0wLI55cCCZvmxbROD8zSIV6QBx?=
 =?us-ascii?Q?6Ob3v59aJt8ubFs21WK7ebC9Nh9Ycy351waAlqtWU1N9Z2bz87L2K0FqHA8Q?=
 =?us-ascii?Q?xGwFcUzmDa+7fBmiXZJiV7eetJksS33gYCFLQj2Gll7vnbwk15D1npdsSnZ+?=
 =?us-ascii?Q?SkQ0mvrS1F5G05hZjrAYYayLxMK97hRYk/DS02IKGM3qcFw3Y3rqa2067FdY?=
 =?us-ascii?Q?0ep0PiBTpGXxxVcvqclbCG6RzFvN13BzZ+NbdWrCKtZ4SBAPCATdg+MQ0ZK5?=
 =?us-ascii?Q?b60RLCy8DQctW6lY2MvwVPzBtUUjdjE6mWbpeZTUHdtUSWeVb1b3c6oYN3ER?=
 =?us-ascii?Q?A5pL/hmDzBFA9anpH4xTH9dxCYm94YP9kMFxiZp/XSuhj+eASU8DOPcQHMOK?=
 =?us-ascii?Q?GYYZchioPZMslk3ipyb5sHoD5MYDgCgHKGLCQm5V0Lq6Hituxe9vQ12Lpj3A?=
 =?us-ascii?Q?RPBB9MTLruKCHwuW9lWbr7wP73JZf5wyG/mloRRk9wUj7m508B2owd9QsDh4?=
 =?us-ascii?Q?j/Q/B/p5ldS9TZB9Ljp5sSDnAXauU5PT7EqjSDvQL8mdZg7t73iVQtbwpplN?=
 =?us-ascii?Q?FolyVR89+I5xu3dBrdfs73OutXP6dJUPmB24fbm2/RmOJ/YdiohCECN1OSqO?=
 =?us-ascii?Q?wIZkKK0GCjfwoVKuAYfeV+FQpOVDAIsmorBkLnaCVDsCjqc9sAohHBS+g0+n?=
 =?us-ascii?Q?yk5TqzCE1ePIrF7ZnvvN91iaFNFM6cBzQ0XwdUv2zBrfFlhuT0/wd4VQibeM?=
 =?us-ascii?Q?/JwoQoHwG1jES4FHBHuXbmyo0bYkfbkc6BAZxFk0do9xammOBdIjpGCfz2Ok?=
 =?us-ascii?Q?vsGL60ksEQ9D69GYdXZzYAZ7pR6HWr213QqEk3FW6E/w9Y6rnvyFCMYrQxF7?=
 =?us-ascii?Q?L/P93rwRxMenrrmQ70OfDz/7J6yaIfLJdItptao83NdjenII9sFsPLLT9MMi?=
 =?us-ascii?Q?NSoWUcTQJklpKhg+FlACYCWetcT+jcxnb9HA96erMPE8sLX9Xalb3rAK3J2v?=
 =?us-ascii?Q?/SmQacw44YQeNtnvVFN9hHwl0SKpik2V8nGYi7rSg2B0qAl0MLaRkENC0ROw?=
 =?us-ascii?Q?M+eFg7cnkV2VDYk5IYR2ESfKorcu7atmRFvrR+tPWzb6k5H3WPjsgsE08HnD?=
 =?us-ascii?Q?SPGnPYe54gM7d00hcUIBDBzcgCWE6IVeNZ9+zh/2z1haGLA8uxFl40sFOsIW?=
 =?us-ascii?Q?/sjdBfZTUqPl0W6yD2bEaB0HvtZWGjUT4gWz6ANlqZxIqaE/5PBXdUaIp3T9?=
 =?us-ascii?Q?1sNUHh8u3ZQArZuIn+yJuDkNTXV6?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 768939d1-3901-451e-997c-08d934962c2d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jun 2021 09:23:04.4204
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: liigYlt9VyIVoqPfMwUR2UtJ8Nnqcv+pr18d3S5EqJr170lHW5Zf9JgzuNkcZH/fx8xRPD/l7ib95yUPzBSadAwDOsrtwcgcgRa0n3oLTxs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4828
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 07:15:08AM +0200, Louis Peens wrote:
> 
> 
> On 2021/06/19 15:53, Dan Carpenter wrote:
> > The nfp_fl_ct_add_flow() function can fail so we need to check for
> > failure.
> > 
> > Fixes: 95255017e0a8 ("nfp: flower-ct: add nft flows to nft list")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Ah, of course, thank you.
> Reviewed-by: Louis Peens <louis.peens@corigine.com>

Likewise, thanks.

Reviewed-by: Simon Horman <simon.horman@corigine.com>

