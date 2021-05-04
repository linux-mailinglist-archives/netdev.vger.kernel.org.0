Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FCF6373186
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 22:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhEDUi4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 16:38:56 -0400
Received: from mx0b-000eb902.pphosted.com ([205.220.177.212]:44956 "EHLO
        mx0b-000eb902.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230217AbhEDUiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 16:38:55 -0400
Received: from pps.filterd (m0220299.ppops.net [127.0.0.1])
        by mx0a-000eb902.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144KYkP0018519;
        Tue, 4 May 2021 15:37:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=garmin.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pps1;
 bh=hb38XH+yM07WGRcGwGh5Vt0v+WlRZZP2QH2DF8kYNzQ=;
 b=fTOPYw/uMIBR1rD5D7XIVWAzdlDmXXzwlcyQErxqsl3yLoU/Vrle+8ZKe2Bfdqc4FmiC
 NDd+t5/dU4UVjwRozGwoITMEK+6DpvUlEKu62MicrtdDZbDbHTxP39dPuabvLRjHg27L
 9MrIYm6agMzOgB5ZT1M+CYlfdb9pyShGOoLfhWm4o0r5oJZlL+VsnyZWNTx9JFbUcYD0
 wccCNrTaB+Kwbdz8yHnRA9EJGKDB3A6djrT2Y0HiZ4rbfigOoLEUPvG/kqlpMCIX72Iv
 8wu+AfcIDGu3tS6iShDwrUJYax4s6dhFnh47ntwXJj+GYoERhU+mFGK50PrdIZM+qZoz NQ== 
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
        by mx0a-000eb902.pphosted.com with ESMTP id 38ajpd2dq2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 15:37:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XSc/wMcWx/r7jDDj16BAh8tMcTm3rFE15i2xKaPnmyHPreDpdtr2RHxNUKJNVk8ovlAL7Dk4gtYTjldHsNrhwBI6wZsDgVSwg91Rtx87bMctGeW+jXHa0TdgU4HFPnWVvJjgJRisonuG0oLsRHu+ZujWJShtiszXbA1lzPkwNTG/rPeSUVtHNG2pDLNrvNpaJXmSFUrsj/OjrqFgD/hvTfyt6FYdZBnWa/iU2xHdYLiXOqcPh4V11IzzeCjAReqmFw7P9sGhR9696Pls5HncXbqawSb3L6oZjJeQjKi++gY8TSF3noIY3GIPmCrNck5OpoGoR4DfulviJamYvjKn6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hb38XH+yM07WGRcGwGh5Vt0v+WlRZZP2QH2DF8kYNzQ=;
 b=B1knluaVEcYyq4+7NmfYqiLRnZWNgmtu/+JPk5TGCRvMPu5tJVrgjAvBSKpMF5S+86gjBu/gaCkIXwxpras+R2h2oYbYd/hUvUT4jy3FHWDPyzPZRkZONfw6JnUnREfOUXJdd1V0gKQ5/FiArVQgu+OwbZz/05qi97kfg6TsaB5L0g1TdBeXnUaOMUHfFE0jx4L/m7tbfzJlpYjKssyFIpdMVLwPu7TQCnPZqsm3JW429e2RMgywS1yqmT721u9RTOWcfmw2kKW/CgM3N8IfQjGSlUY4BuR6pYKiADM1HDEVqzc0kSUUt/MQ8LH0reKw1KcbD6lZdBaACfHeXr5tkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 204.77.163.244) smtp.rcpttodomain=nvidia.com smtp.mailfrom=garmin.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=garmin.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=garmin.onmicrosoft.com; s=selector1-garmin-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hb38XH+yM07WGRcGwGh5Vt0v+WlRZZP2QH2DF8kYNzQ=;
 b=Gdyac/GgN9nPZV2BBRzwnGRnjjPu416QLjtbuT6f1EjCaiRBF+FEG6gvdKRw7xLVg3QmonlH1d4elOW83+0M0OB/AvQbS2bKIW/KqW+NDlssw28hx3xhf6S2UrgJ8VMMWQKmu72bm+n5gNuRq4gsqDgWVOVvNsFbl2eET3NwuEg1DBkzY73lUQXK0sq8lCPWmocGNJ2ql2/+Bh+0HdzUiu+PobqxjJOIkR3geYhKH7dRcPLcC+zgKauiSOeXd7YI9zs7IaYA4AocXxjjrU9Cz5NNbQi4QUGhZAJ0mUKZ60JnW9bH6+/mg4wfihLlZHXEEFkc8WzFt5GG2RFNBs9SLA==
Received: from DM5PR04CA0032.namprd04.prod.outlook.com (2603:10b6:3:12b::18)
 by PH0PR04MB7224.namprd04.prod.outlook.com (2603:10b6:510:16::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.44; Tue, 4 May
 2021 20:37:46 +0000
Received: from DM6NAM10FT062.eop-nam10.prod.protection.outlook.com
 (2603:10b6:3:12b:cafe::61) by DM5PR04CA0032.outlook.office365.com
 (2603:10b6:3:12b::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.28 via Frontend
 Transport; Tue, 4 May 2021 20:37:46 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 204.77.163.244)
 smtp.mailfrom=garmin.com; nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=pass action=none header.from=garmin.com;
Received-SPF: Pass (protection.outlook.com: domain of garmin.com designates
 204.77.163.244 as permitted sender) receiver=protection.outlook.com;
 client-ip=204.77.163.244; helo=edgetransport.garmin.com;
Received: from edgetransport.garmin.com (204.77.163.244) by
 DM6NAM10FT062.mail.protection.outlook.com (10.13.153.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.25 via Frontend Transport; Tue, 4 May 2021 20:37:46 +0000
Received: from OLAWPA-EXMB2.ad.garmin.com (10.5.144.24) by
 olawpa-edge4.garmin.com (10.60.4.228) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Tue, 4 May 2021 15:37:40 -0500
Received: from OLAWPA-EXMB4.ad.garmin.com (10.5.144.25) by
 OLAWPA-EXMB2.ad.garmin.com (10.5.144.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2242.4; Tue, 4 May 2021 15:37:45 -0500
Received: from OLAWPA-EXMB4.ad.garmin.com ([fe80::d9c:e89c:1ef1:23c]) by
 OLAWPA-EXMB4.ad.garmin.com ([fe80::d9c:e89c:1ef1:23c%23]) with mapi id
 15.01.2242.008; Tue, 4 May 2021 15:37:45 -0500
From:   "Huang, Joseph" <Joseph.Huang@garmin.com>
To:     Nikolay Aleksandrov <nikolay@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ido Schimmel <idosch@idosch.org>
Subject: Re: [PATCH net 0/6] bridge: Fix snooping in multi-bridge config with
 switchdev
Thread-Topic: [PATCH net 0/6] bridge: Fix snooping in multi-bridge config with
 switchdev
Thread-Index: AQHXQRKRJez3iJGzm0eCT/EpouXvN6rUE08A//+0kwQ=
Date:   Tue, 4 May 2021 20:37:45 +0000
Message-ID: <685c25c2423c451480c0ad2cf78877be@garmin.com>
References: <20210504182259.5042-1-Joseph.Huang@garmin.com>,<6fd5711c-8d53-d72b-995d-1caf77047ecf@nvidia.com>
In-Reply-To: <6fd5711c-8d53-d72b-995d-1caf77047ecf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.50.4.6]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d28cc703-faed-4f91-3cb3-08d90f3c79cc
X-MS-TrafficTypeDiagnostic: PH0PR04MB7224:
X-Microsoft-Antispam-PRVS: <PH0PR04MB7224AC5F7271E01E14FA9FE8FB5A9@PH0PR04MB7224.namprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9C2j4fRrnwkLuBbx+m2pZnKPcq8GM3J9PZNgbOjPRLF0CrcL7nKN2IciSuNq3shX1gDtEj3PNBqB9edYM1k1l8TmbjTXvcf0dfHFIEVHCcU1QJP/8lUGpsd0dfkzZbvonyjXzwFlrcUH/mJU/ALrU1S5Bdnv2hL9ES6tVF7HvwpRqUIpasP3DWq4mjCKIQbKuOL1vhRksKeLa/aLihQLu0tKFZG767jp0ia/qow8fmnVZ0Kg+h2QVnFybopdWfgapXkXQ4cBCovvYXN1qVUoJAznjfApeWdwT5lohMkEG7jFOErMBp3KgQ+2yof2LbMNlCyCq4O9VSFWS0h1lC/OIqgYQbnzWbfV1FZs6H+WLx4T2f/MGbTxJzP2KE71pO9mYVIFLRoL/IKAiy9Ys3A3NLXD692vhHvAi38bzc0Jie8Oq4ehrS9Dr2poNy9Sw26gfsCGW8lkufSv/rbM1mbO65+CiviN1xd3qCnoYQrqSRvBu7jmOoF2TAi/i7LWAkkNpPDpXY/54nNrdOHe5KDnD5Lrd2D/A75gKLnnRxXWrrwHMMaO6W7ynljW0+PKo+JmNlUgntYaD9KegVstepGLVMElY0P3EtsmB7TX5RItlYpBL8FuLgjA4KChIsfauidkMpBkppE/ej5amweFmjzx3A==
X-Forefront-Antispam-Report: CIP:204.77.163.244;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:edgetransport.garmin.com;PTR:extedge.garmin.com;CAT:NONE;SFS:(396003)(346002)(39860400002)(376002)(136003)(36840700001)(46966006)(4744005)(26005)(478600001)(70206006)(2616005)(426003)(2906002)(8936002)(47076005)(336012)(186003)(7696005)(36860700001)(82310400003)(70586007)(316002)(8676002)(356005)(7636003)(83380400001)(24736004)(36756003)(86362001)(108616005)(5660300002)(82740400003)(110136005);DIR:OUT;SFP:1102;
X-OriginatorOrg: garmin.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 May 2021 20:37:46.4328
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d28cc703-faed-4f91-3cb3-08d90f3c79cc
X-MS-Exchange-CrossTenant-Id: 38d0d425-ba52-4c0a-a03e-2a65c8e82e2d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38d0d425-ba52-4c0a-a03e-2a65c8e82e2d;Ip=[204.77.163.244];Helo=[edgetransport.garmin.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM10FT062.eop-nam10.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR04MB7224
X-Proofpoint-ORIG-GUID: --Q2QQ_LzBjJQxmvOzT8IjsFlLTp9zCO
X-Proofpoint-GUID: --Q2QQ_LzBjJQxmvOzT8IjsFlLTp9zCO
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_15:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 bulkscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 mlxlogscore=999 phishscore=0 clxscore=1011 mlxscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040138
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi,
> This patch-set is inappropriate for -net, if at all. It's quite late over=
 here and I'll
> review the rest later, but I can say from a quick peek that patch 02 is
> unacceptable for it increases the complexity with 1 order of magnitude of=
 all
> add/del call paths and some of them can be invoked on user packets. A lot=
 of
> this functionality should be "hidden" in the driver or done by a user-spa=
ce
> daemon/helper.
> Most of the flooding behaviour changes must be hidden behind some new
> option otherwise they'll break user setups that rely on the current. I'll=
 review
> the patches in detail over the following few days, net-next is closed any=
way.
>=20
> Cheers,
>  Nik

Hi Nik,

Thanks for your quick response!
Once you have a chance to review the set, please let me know how I can impr=
ove them to make them acceptable. These are real problems and we do need to=
 fix them.

Thanks,
Joseph
