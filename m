Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA423DEF29
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 15:37:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236243AbhHCNgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 09:36:14 -0400
Received: from mail-dm6nam12on2078.outbound.protection.outlook.com ([40.107.243.78]:27873
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236271AbhHCNfP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 09:35:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P0TJeke0IGnTufcRtxggetSEBt4EvQfaEhHHnXxaFYYN1SDZCUuMC9En8N5H3lSjSuAb8VwiWB0IYzV50fIbUytBJGE5KM43m8cVE3r8TrOGRcUE/HoEMSxKRSYy9+jm94Q6WCB8GnGbNMTD9iehJOW/8BLck21Z8OLMRz46UNqw8jOaiX9AIeHbOx8fEylP9SRaJzXK7fw4eocogFMt872fFfmdRmVUj/vtaP3jJxkd9XyOc3twjNlOT3gIydB2snnsqGy3HQE4Yj/zlP/9DRBeE4zwFAMyTh2nZvq8E4TgzwKsXn5mCa6nS7JLQEljVulD0rEIdclOgnc7XgedJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lByfT9nAFTGij2U7I2jyyYSPaaxRtXaMyXxlHCaRJjc=;
 b=F9fraVuwAnXEq95+KRNdz2QwxhYWEphiHd/QH7CketakGZSavnQZXSZVRkGsFwViQwz+lLLaVM1ZrcoJ9Ytmwh3rTn3cmm6Rcwxly/TsFeD2bNc/bF8VrgG73OlmQ9M8rpnvm2P7GtWb2IQH0gL4QUzBU6lSyB74No3Pv3KRtcpas2vrhTBBg1un7GiGnkqQz1ZkauUldtoqh1m7Nd8Dy/k7Mo7l5xH5+SStbzWyfiK7r8Tfu83z5It3RB5cv1A2PlxCtnZHvlaSGUyvdwQFm2O7k4cP63pH40dr7UdpmrveSqesOaU5ETR/+EvDDFMUo7VJ1wE0Kfwn+3z6ecS9SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=mojatatu.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=quarantine sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lByfT9nAFTGij2U7I2jyyYSPaaxRtXaMyXxlHCaRJjc=;
 b=Pi/vmBOSHPHLvNCxqDx5PkSr9EXuebKExUT2vzPEBlwhHEYpbNa1dZ/NN3ehT5rS9y3cD0c8XQJFqnmF+mOCSeUOZAHCNlXIl7olH8hb/NHiQwzLKfEMuV8CwAAbn17ai4QlAW1tQVVohu6SjkuuIbd326ESY02q3f+k2z94mG3RIiVehE0brC5KpJTGEiDZu96nMGZNIxA3/ByQl05aC2sI89CsB9jLIfzyQj1SR2B+3DwGSp6asgFKOmJVanqYpa1nr/1BNqpBU7NzBQtL+7FiuYUNkZcN83mWwUAQ1/Wn17EiadRgjy4RmJZhgzfyVFDZF5nDHBS3PM/ONC4Ofw==
Received: from BN6PR22CA0046.namprd22.prod.outlook.com (2603:10b6:404:37::32)
 by BN9PR12MB5099.namprd12.prod.outlook.com (2603:10b6:408:118::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.20; Tue, 3 Aug
 2021 13:34:58 +0000
Received: from BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
 (2603:10b6:404:37:cafe::8c) by BN6PR22CA0046.outlook.office365.com
 (2603:10b6:404:37::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend
 Transport; Tue, 3 Aug 2021 13:34:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; mojatatu.com; dkim=none (message not signed)
 header.d=none;mojatatu.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 BN8NAM11FT064.mail.protection.outlook.com (10.13.176.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 13:34:58 +0000
Received: from DRHQMAIL107.nvidia.com (10.27.9.16) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Aug
 2021 13:34:58 +0000
Received: from localhost (172.20.187.5) by DRHQMAIL107.nvidia.com (10.27.9.16)
 with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 3 Aug 2021 13:34:57
 +0000
Date:   Tue, 3 Aug 2021 16:34:53 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <oss-drivers@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        "Jiri Pirko" <jiri@resnulli.us>, Roopa Prabhu <roopa@nvidia.com>
Subject: Re: tc offload debug-ability
Message-ID: <YQlF/bQFKH58wTH2@shredder>
References: <ygnh4kcfr9e8.fsf@nvidia.com>
 <20210728074616.GB18065@corigine.com>
 <7004376d-5576-1b9c-21bc-beabd05fa5c9@mojatatu.com>
 <20210728144622.GA5511@corigine.com>
 <2ba4e24f-e34e-f893-d42b-d0fd40794da5@mojatatu.com>
 <ygnhv94sowqj.fsf@nvidia.com>
 <31fb2ae6-2b91-5530-70c8-63b42eb5c39d@mojatatu.com>
 <996ecc2d-d982-c7f3-7769-3b489d5ff66c@mojatatu.com>
 <ygnhsfzqpvwd.fsf@nvidia.com>
 <092765ac-ffc6-5ccb-2dff-46370edb2e44@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <092765ac-ffc6-5ccb-2dff-46370edb2e44@mojatatu.com>
X-Originating-IP: [172.20.187.5]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 DRHQMAIL107.nvidia.com (10.27.9.16)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c524560-dded-4810-8326-08d956837ccc
X-MS-TrafficTypeDiagnostic: BN9PR12MB5099:
X-Microsoft-Antispam-PRVS: <BN9PR12MB5099AF49ACA1C01C3F90B70DB2F09@BN9PR12MB5099.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mQwMxNnSnCp09FmyHRFY0nnZxpEqhA6ldb7lTTDlqS9L/DMpqH5QYo3hp5vAXs/R1/CHSueyy467bq9wc7ue9XiSeJSid7DITM9q/jDp1n1Y8qyhdVsbBK0oMFrsd4Cfz3vUHBYXEzDjl4V+g89rDmmL/jR66McA2kJZV2bvKUIUpfNFHy7Cls8p/6lBKehCKP6Sjb8djfHD2jWmS8qM8uiQGikmxDiS88sbFxSS09kEbJJJcMbdDInIHznK1Ym4bu/rX9jki6FwwpBRFXRZ+WlaXpOcH1x74fTn7HIrEQ0Ye0qQp+rJRSb2/y471nygDh/LZp3KVJmvrgLfGXhlBpjyL7TQDEgMSCjkk5v5GJvRN1X970y1fDGTeWjdPq3s/o13izh+UdoI77+ITdPY5Pmyc+z4Wdnq/ZWRgctN5kV+3V9NnZ4JSsQxofQXId0Si3Aphut9iXpSz+mutmfAOQUWwRLqpTgApeIRibmI+oPiN1vwTyfahwUNZ0MFuSid54+RfZb0rdTrUsXbFL6g8GZ53qiLYyqH7hdPDdJrxlSuNed3GmUVeRTNx11R0+A5IVFx8lqiYRcaf2RqfmehGSVrjG9YvDp2qnUKBza1USM7NbHHG3VU1PJJEzAQT5x/2h6X+sYHoc0gZRdiinqY+Pf9PHSZnmgiyAWUY17N6OmpnXQfaoA66v7aWOIMkZzad3ppYtXub+M1n7DzfBHK9g==
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid04.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(136003)(39860400002)(396003)(346002)(376002)(46966006)(36840700001)(426003)(47076005)(8676002)(7416002)(316002)(6666004)(26005)(5660300002)(86362001)(3480700007)(478600001)(53546011)(70586007)(6916009)(16526019)(36860700001)(186003)(9686003)(70206006)(83380400001)(54906003)(8936002)(107886003)(2906002)(7636003)(356005)(33716001)(82310400003)(36906005)(4326008)(336012)(82740400003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 13:34:58.2508
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c524560-dded-4810-8326-08d956837ccc
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT064.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 08:50:27AM -0400, Jamal Hadi Salim wrote:
> On 2021-08-03 8:14 a.m., Vlad Buslov wrote:
> > 
> > On Tue 03 Aug 2021 at 15:02, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> 
> [..]
> 
> > > 
> > > So unless i am mistaken Vlad:
> > > a) there is no way to reflect the  details when someone dumps the rules.
> > > b) No notifications sent to the control plane (user space) when the
> > > neighbor updates are offloaded.
> > 
> > Correct.
> > 
> 
> Feels like we can adopt the same mechanics. Although, unless i am
> misreading, it seems Ido's patches cover a slightly different use
> case: not totally synchronous in successfully pushing the rule to
> hardware i.e could be sitting somewhere in firmware on its way to
> the ASIC (and at least your connectx driver seems to only be
> relinquishing control after confirming the update succeeded).
> Am i mistaken Ido?

It is simply that all routes are notified from an atomic context, which
means installation to hardware needs to be deferred. But even if we
solve this case, there are other cases that cannot be solved.

For example, in IPv6 routes can be installed in response to RA packets
from softIRQ context. As another example, you can have several routes
with the same key already installed in the kernel, but only the one with
the lowest metric will be installed in hardware. Once it is deleted (for
example, in response to a netdev event), the kernel will try to install
the route with the higher metric. As a user, you want to get a
notification if this operation failed.

The same problem exists with tc actions, not sure about classifiers. For
example, we can mirror to a gretap to emulate ERSPAN. The hardware
expects all the headers to be specified, which means the path towards
the remote IP must be resolved in the kernel. Due to FIB/neigh/FDB
events it can obviously change, which means that the validity of the
action in hardware (not the classifier) changes over time with zero
visibility to user space.

So I believe that we need to be able to notify user space about the
state of the action. Whether it is in hardware / not in hardware /
failed to be installed to hardware.

> 
> 
> cheers,
> jamal
