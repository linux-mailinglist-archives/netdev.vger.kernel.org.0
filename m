Return-Path: <netdev+bounces-333-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E3F26F71FB
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:34:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CE157280E26
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8881279FA;
	Thu,  4 May 2023 18:34:52 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77AB1FC02
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:34:52 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECD4249DC
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:34:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N4142Fwian9S0WfrKv6A1YFMLsLXLErmYhx4m69zpgjZNLuCVTGdm6DJeznNaGXieqwsyK6guCQkel9UpAYDrKLswJrj2pxvDbswAS3HniZJZQzuVWFd+8tEcU7PB+668/w9fJ3a+S6tYFtF+z3BkVKsfeZiEfDgtORk/+mixFzrizPa/jTXeTBvdeRK3o9c3mhjsoj2RZTnVwn6MjCPemdHsMR3o6QniKEbyo0467rmX3jXLNrWAEVU6dNT312i12rSy4zwOLCyYAsjL0VR6+pyoq4EjeHPviU0RbL5BTsGc6Tek6hvk1vcZMgS0cBgqkRFcLPwIx0iNpFqZWWm4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0/StxlrhFOBpIGyiKlvEiHX7efqQ7YXNnudWt/DW4Fc=;
 b=J+0oz/bG0EDdIaJnr7Vt/Wl24jPi/svMIWYw5/xxSqdaTEMedF7v7iGRPL2/InrVgWhYZnvfemwkHF+SenhWQQbIVMXxMe+LLcxgdpfPomcHFWMSZG320jJ6RYycaUDmCTJOWuSs0itT9xGUAB9nT9S2kF2ESHPN6ixdO+HFtT6xgVKE5aroh+DfWZYHseR82lx4pRzoDXoJN0gpBJJwEAigAnFFEWyGdUT6BVaLQ3y4Y0/qaKLmGLqzz0tIQmgIB3BE5y76I0a+W3mhalQqQ7H/zpR1dilWNaxfugIQUKnNupYjN6van8RjN+r1Mu2C9B5BUEu4ZaWEdosFsT8CoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0/StxlrhFOBpIGyiKlvEiHX7efqQ7YXNnudWt/DW4Fc=;
 b=lNNtDtIQPa/QXabpJpEeAOf5s47njS4r98v9ZG/afwIumD+vf0x+Z5C/VZBnofUWInZ1U0HqZX7lWT2FberAmrtjVmR6YqS0aSiiX8FSs9bcIA++hxRwPby1ptnzpRG+VUnzgYSTZoZ4qOls0/QR7oLMSOpGpszqQsBzsHcbGKpHMd4pzaC42ULVtDEEuqNO5t6qDlTePaEMof/3fzPXRiRyh0AEmypouSCE62I/Vp+FNdvgxmQl/BORisB0ns6etdtzqEwEHBawPCriBZaT1Kx/Vq0cSZ1FYPOvs5+/of2CjV/91FWOo8hfLKZTv9vPs7ZfKrlh8Lv8AviHVNs6Mg==
Received: from MW4PR03CA0276.namprd03.prod.outlook.com (2603:10b6:303:b5::11)
 by BN9PR12MB5290.namprd12.prod.outlook.com (2603:10b6:408:103::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26; Thu, 4 May
 2023 18:34:48 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:b5:cafe::da) by MW4PR03CA0276.outlook.office365.com
 (2603:10b6:303:b5::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.26 via Frontend
 Transport; Thu, 4 May 2023 18:34:48 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.27 via Frontend Transport; Thu, 4 May 2023 18:34:48 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Thu, 4 May 2023
 11:34:32 -0700
Received: from fedora.nvidia.com (10.126.230.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Thu, 4 May 2023
 11:34:28 -0700
References: <20230426121415.2149732-1-vladbu@nvidia.com>
 <20230426121415.2149732-3-vladbu@nvidia.com>
 <4a647080-cdf6-17e3-6e21-50250722e698@mojatatu.com>
 <87bkjasmtw.fsf@nvidia.com>
 <1bf81145-0996-e473-4053-09f410195984@redhat.com>
 <ZEtxvPaa/L3jHa2d@corigine.com>
 <bf6591ac-2526-6ca8-b60b-70536a31ae2a@redhat.com>
 <87354ks1ob.fsf@nvidia.com> <20230502194452.23e99a2c@kernel.org>
 <87mt2kqkke.fsf@nvidia.com>
 <5c325bab5f4b4503c7740fd73e9ab603285d0315.camel@redhat.com>
User-agent: mu4e 1.8.11; emacs 28.2
From: Vlad Buslov <vladbu@nvidia.com>
To: Paolo Abeni <pabeni@redhat.com>
CC: Jakub Kicinski <kuba@kernel.org>, Ivan Vecera <ivecera@redhat.com>, "Simon
 Horman" <simon.horman@corigine.com>, Pedro Tammela <pctammela@mojatatu.com>,
	<davem@davemloft.net>, <netdev@vger.kernel.org>, <jhs@mojatatu.com>,
	<xiyou.wangcong@gmail.com>, <jiri@resnulli.us>, <marcelo.leitner@gmail.com>,
	<paulb@nvidia.com>
Subject: Re: [PATCH net 2/2] net/sched: flower: fix error handler on replace
Date: Thu, 4 May 2023 21:32:40 +0300
In-Reply-To: <5c325bab5f4b4503c7740fd73e9ab603285d0315.camel@redhat.com>
Message-ID: <87ild8q72m.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.230.37]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT036:EE_|BN9PR12MB5290:EE_
X-MS-Office365-Filtering-Correlation-Id: 2162405c-abfe-4034-f18b-08db4cce3dd8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	zQqsPvj8FnZaAKYwKodkxg/Gn70GUyOKlnsItTs7NtcopW/QHHy9h285mpPQiAY0FmN6SWdnxJ2AfubF8UAWXX6BC8nP9KBkyIBVbktkXjO/9iUpK+I1AB+YstDzrZw9G52oH3jvBF3wRMcSAazdWacJBpP72LNnrwfEJ7P2+k/k97d4+Mq+gr9aEk6sGExAuNvbyO59sgI40PRDWKbdRXxxxrK5m+h7Gdf7KAt6Mjowl3T8oCitWh2O0e0gIWNlIKiM/HnCrgiAYwWs1t2P+3tk37os1CvZZemcTubn7q7dIRWiI1UdTiTYo/xxZ1ssiMQl6HPLCuvm4KuFrypcs2VjQacolGcKQL+yG63C7gqVdplpjbVVXSFFg9HLZKw7u8IJU81bkBmJWnsZ7FAIK5OLs5jjpFOdytGHMbKaAYmY3cNt6raBkEBF7xEIPkaNlS79V8ALpwgowKS+zjnA1ybCtYGTCrAnGkEPeI2/4TQJhRAmcQMBXqXIt6hwzDOTRaij3Vzi873V1ZK1kNthipc/NLb2sgwHCE4ebRVObQ2SfXn/ekUtrlYTnYvNCFYgvrIM6Qr+BWZd+jgoZeBOBkFjdxUCLQrnkmQrLu9dnFormDIADqPenHcWIOQthsdggvbedxolPl4+vnIwX9515oVTGRLtVUsebIJ3QAJjTtPd+EhuXr1nvhGsIvYikQbK+u8SaaEYLeSMgI44zYXzZw==
X-Forefront-Antispam-Report:
	CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39860400002)(346002)(136003)(451199021)(36840700001)(46966006)(40470700004)(316002)(36860700001)(8676002)(5660300002)(8936002)(2616005)(70206006)(82740400003)(47076005)(4326008)(6916009)(70586007)(86362001)(426003)(83380400001)(2906002)(336012)(7416002)(186003)(16526019)(40460700003)(26005)(40480700001)(6666004)(7696005)(36756003)(107886003)(54906003)(41300700001)(356005)(7636003)(82310400005)(478600001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2023 18:34:48.6252
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2162405c-abfe-4034-f18b-08db4cce3dd8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource:
	CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5290
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On Thu 04 May 2023 at 16:24, Paolo Abeni <pabeni@redhat.com> wrote:
> On Thu, 2023-05-04 at 16:40 +0300, Vlad Buslov wrote:
>> On Tue 02 May 2023 at 19:44, Jakub Kicinski <kuba@kernel.org> wrote:
>> > On Fri, 28 Apr 2023 14:03:19 +0300 Vlad Buslov wrote:
>> > > Note that with these changes (both accepted patch and preceding diff)
>> > > you are exposing filter to dapapath access (datapath looks up filter via
>> > > hash table, not idr) with its handle set to 0 initially and then resent
>> > > while already accessible. After taking a quick look at Paul's
>> > > miss-to-action code it seems that handle value used by datapath is taken
>> > > from struct tcf_exts_miss_cookie_node not from filter directly, so such
>> > > approach likely doesn't break anything existing, but I might have missed
>> > > something.
>> > 
>> > Did we deadlock in this discussion, or the issue was otherwise fixed?
>> 
>> From my side I explained why in my opinion Ivan's fix doesn't cover all
>> cases and my approach is better overall. Don't know what else to discuss
>> since it seems that everyone agreed.
>
> Do I read correctly that we need a revert of Ivan's patch to safely
> apply this series? If so, could you please repost including such
> revert?

I don't believe our fixes conflict, it is just that Ivan's should become
redundant with mine applied. Anyway, I've just sent V2 with added
revert.


