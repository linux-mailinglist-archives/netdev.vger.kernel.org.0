Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D8E4452FE7
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 12:08:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234664AbhKPLLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 06:11:12 -0500
Received: from mail-bn8nam12on2085.outbound.protection.outlook.com ([40.107.237.85]:35324
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234715AbhKPLLH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 06:11:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K5NQXhLmmC/H48B08S/7wBkYBuweWWVMkrcgT1WkD4d942xsU8mAhti0wiMaIDLdAnCyR9170xXGNYo6/B7HjGcxWEc1SfrNo98MxDZo7wI9X4RMF8Zavqao2VnOGI5zeALsDKzW42JFTNniz96uNN5POy4waFP8pFMAsd9vcXpoUX7TVaUXr6K2HJ/mEFoqC8xfk7VAFvP5qql6oYIGEqT5z3HM3bXPabOJym0/+ZcMVfplPyX13GnOgkYQb8BAUR1+W/sE3SX/Ez0pl57VrO+zSFpSokmwanXPf5TZPbpfJuvZ9s+e5MNDc6QcGMZrGzRg4KyRJ9U2S4rGTDRy8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g+tLRtg+CISNgiAxjnhpHGk6WhUjhPD7qmpdFrPeAgo=;
 b=Pe5i9lHacUKjqd8HlNs4gz6lNs5483qMMR+CRX0HWQ44609jNb5/sj8yaOZxer21TOZZuxpKWz61oABol1LsbfdBejf0OwVxrmRQAvWMWbItw78qR4sdP2/jzzyGKK23ymk3tvfHIu96OQppo+qnrVPgVol3Rj0HggN5+zHK9N81exBeqfFWM6464xjlogiPhDMM8l2rQOuKSuSGgw5YWnditDrlEl3Wv3TWZMcs697ViapYfsmy6uviohnHOs8FK7mKgvucUX/CR9I4rxz0dSYhr28gOrydumdQi90rcgKuvaEJRjWXJ8E1I1HAX1WVyJ0xMfORxf3DUoMsswJOJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g+tLRtg+CISNgiAxjnhpHGk6WhUjhPD7qmpdFrPeAgo=;
 b=fc7PPeTjW4UYnEsQzaSChVrK36V2q04Z10iVbUQr3ryeLVw5hV3tX/Vw9v0hnfpCR4LzQzbb63HKWLZwVDm+0Wf4VofLxXD4O96R42ASQhHvCLcHh7Nn6HWVqo669oGGjJmNx5439w+RJZYaT/M0ZmlC88E0Akqoni4CHs6Nb1+ZL16JK5h5oRVPWmuZKMMHi0VmfWtl13xwDW4uz+m8G/x1CADhxx2StNCnMwVkhChROHRj9xiMx2OvnfIole88XPfLKhQyYwR/sEGuFxT1Hny/SYoj2rP26J+7fyCDjVREd8VXPIZs75x8dSzIwPJv0xiwU3DWxFwklK5hZrQevw==
Received: from MWHPR19CA0018.namprd19.prod.outlook.com (2603:10b6:300:d4::28)
 by CH2PR12MB3909.namprd12.prod.outlook.com (2603:10b6:610:21::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Tue, 16 Nov
 2021 11:08:03 +0000
Received: from CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:d4:cafe::ae) by MWHPR19CA0018.outlook.office365.com
 (2603:10b6:300:d4::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26 via Frontend
 Transport; Tue, 16 Nov 2021 11:08:03 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT067.mail.protection.outlook.com (10.13.174.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4690.15 via Frontend Transport; Tue, 16 Nov 2021 11:08:02 +0000
Received: from yaviefel (172.20.187.6) by HQMAIL107.nvidia.com (172.20.187.13)
 with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 16 Nov 2021 11:07:58
 +0000
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
 <20211110114448.2792314-7-maciej.machnikowski@intel.com>
 <87tugic17a.fsf@nvidia.com>
 <MW5PR11MB5812E733ED2BB621A3249CD5EA989@MW5PR11MB5812.namprd11.prod.outlook.com>
User-agent: mu4e 1.4.15; emacs 27.2
From:   Petr Machata <petrm@nvidia.com>
To:     "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
CC:     Petr Machata <petrm@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: Re: [PATCH v3 net-next 6/6] docs: net: Add description of SyncE
 interfaces
In-Reply-To: <MW5PR11MB5812E733ED2BB621A3249CD5EA989@MW5PR11MB5812.namprd11.prod.outlook.com>
Message-ID: <87k0h8tl2s.fsf@nvidia.com>
Date:   Tue, 16 Nov 2021 12:07:55 +0100
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL111.nvidia.com (172.20.187.18) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 81ee197e-60ab-4ed5-8367-08d9a8f15bd6
X-MS-TrafficTypeDiagnostic: CH2PR12MB3909:
X-Microsoft-Antispam-PRVS: <CH2PR12MB3909A0A8040BDDD8A39BD15DD6999@CH2PR12MB3909.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fs51xMbPS2V6uwhS5yZnv0eVRzU6tY/jaIv1p8ETUxQWK1vIMd2C/hZvWeJTkpsw2CjvbmmkzOvk6W+xpE/rBwmUA+EARCbM757Rm4OTznduyAdBoOIsGWmS65vfj3A7gKPcMjRdrfh/SCgHRTGTmVu4lovs2U1/PGFOKhl8RlZpq7pqMQlfAH9psyYKhSIfar6AO2ye9RPnzk0KYBLV2roict65BeKjLpmoI3QltfCSFQUknUSYj7atBRmDHkYOFhHf4sy2zlk8i9ED/DEAFsJd9uI+eFYUDiYU/iI8vOVZ8Dv750cuGwawO50Bgb8jdAP/hNjh6xs8vIqxLMomM6mu/Gq0Ko5ouM626MmZOpbuOfGKa5EhvMoyfj/rivbrV73si8bmXnnu5YDLXhFfcYuVQjZ/lGs3IVVoVJlfULklC3ggAKi5pLTRqoZb/j6l9So0w06tIOoHriw1f/7ieWxT5PrFQ/eGPtF9sarjFCQXHpZuos6KViY73XTAlgp9Bvgx+Nbdge/gHNQbcfgppEO46dRTxEVpJqtjNFtztexk6VqHg+viPecQOQihAONW4V8joSuedLy6c2ETaah6rmGO/BOi7LVewKQ+JD0pxX/2+jdtIrDbJQ+z8S7SVIxNOyxqiRqvPWKiq8kfgsba5PFG6KL5mEpoD9kG6sXE+Ow9tzlRV4DqyAnfKQgHmSyBQ0k46VoKOFemjNj2mfk8OA==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(46966006)(36840700001)(336012)(186003)(36756003)(4326008)(8936002)(83380400001)(356005)(16526019)(2906002)(508600001)(426003)(8676002)(2616005)(7636003)(316002)(6916009)(70206006)(70586007)(5660300002)(86362001)(7416002)(82310400003)(36860700001)(6666004)(47076005)(54906003)(26005)(53546011);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 11:08:02.9886
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 81ee197e-60ab-4ed5-8367-08d9a8f15bd6
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT067.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB3909
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:

>> -----Original Message-----
>> From: Petr Machata <petrm@nvidia.com>
>> Sent: Thursday, November 11, 2021 1:43 PM
>> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
>> Subject: Re: [PATCH v3 net-next 6/6] docs: net: Add description of SyncE
>> interfaces
>> 
>> 
>> Maciej Machnikowski <maciej.machnikowski@intel.com> writes:
>> 
>> > Add Documentation/networking/synce.rst describing new RTNL messages
>> > and respective NDO ops supporting SyncE (Synchronous Ethernet).
>> >
>> > Signed-off-by: Maciej Machnikowski <maciej.machnikowski@intel.com>
>> > ---
> ...
>> > +RTM_GETEECSTATE
>> > +----------------
>> > +Reads the state of the EEC or equivalent physical clock synchronizer.
>> > +This message returns the following attributes:
>> > +IFLA_EEC_STATE - current state of the EEC or equivalent clock generator.
>> > +		 The states returned in this attribute are aligned to the
>> > +		 ITU-T G.781 and are:
>> > +		  IF_EEC_STATE_INVALID - state is not valid
>> > +		  IF_EEC_STATE_FREERUN - clock is free-running
>> > +		  IF_EEC_STATE_LOCKED - clock is locked to the reference,
>> > +		                        but the holdover memory is not valid
>> > +		  IF_EEC_STATE_LOCKED_HO_ACQ - clock is locked to the
>> reference
>> > +		                               and holdover memory is valid
>> > +		  IF_EEC_STATE_HOLDOVER - clock is in holdover mode
>> > +State is read from the netdev calling the:
>> > +int (*ndo_get_eec_state)(struct net_device *dev, enum if_eec_state
>> *state,
>> > +			 u32 *src_idx, struct netlink_ext_ack *extack);
>> > +
>> > +IFLA_EEC_SRC_IDX - optional attribute returning the index of the
>> reference
>> > +		   that is used for the current IFLA_EEC_STATE, i.e.,
>> > +		   the index of the pin that the EEC is locked to.
>> > +
>> > +Will be returned only if the ndo_get_eec_src is implemented.
>> > \ No newline at end of file
>> 
>> Just to be clear, I have much the same objections to this UAPI as I had
>> to v2:
>> 
>> - RTM_GETEECSTATE will become obsolete as soon as DPLL object is added.
>
> Yes for more complex devices and no for simple ones

If we have an interface suitable for more complex netdevices, the
simpler ones can use it as well. Should in fact. There should not be two
interfaces for the same thing. For reasons of maintenance,
documentation, tool support, user experience.
