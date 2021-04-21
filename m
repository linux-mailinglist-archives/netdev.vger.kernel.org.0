Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0DDB366A71
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 14:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbhDUMIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 08:08:48 -0400
Received: from mail-dm6nam10on2088.outbound.protection.outlook.com ([40.107.93.88]:51936
        "EHLO NAM10-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235510AbhDUMIr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 08:08:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BekW0ViNXj1cRSU7+0qSfOGgdDAUoQXrkWSPCxwSfCNwcawdA7HpU5ZkXAN4M/nY9p6oT4PqT3poCZxK+dypNrGtTiwqWZL5clet60gIG2xVl0RirPnDSNoG1qjuh0yPEAPvxEGs8zSJrbXPgGEzQX8vvE1YJwioZ2zW6XeHPJryoPNUUmNUe7LvH7fs6ZzYui9wXFwi/f8BYlB5yyahobZltx9g+cxoO4hovtrecsqj6DCvi7KHgcp1QmB+lbdgOjZAb3kGCqY8YcSwSMUYCjpOcDf8TITaoQapGY+P6ZwTvgsQhJeOk6f5camRxtgWxC+woWHFaYuSUPSJA4/z4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5iwusd9e6FxNTvTiwDx6nivshpdzYCVsmJiaLh3vF0=;
 b=IHG9JU23L3c1h3v0sCYEYVgT58fUUG2i0InvY/2+Rl8ebhrT2fbHoowfx+frj9dyNfdbbJSfPltwu5nvClab9AE7tclL/E0u+RPN4dODkZtycorp2czqCNfeGrtlkURvHWQ2WKo7wHfdgGR6pdzzl2EKKtm4snLDC4IMJzXpRVXehDk6HeyEsj8Fmqu9iM57HYUTlPiBgxVyIRBSHOooOne6+7hYUKbBD2Y6v9OdEP8c4gtmcHr1Anwtb6JIMnIXB51MXHu2zH5a0rrrHDOVHvt8jcv8P+Bn5b1nZOdEJ+uUQRa6etfPU4zKebt1D9kBApL8PQRcZodedF9zg0VenQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5iwusd9e6FxNTvTiwDx6nivshpdzYCVsmJiaLh3vF0=;
 b=RlOPWSOrp7Wmzt2FWeaqZxa81jEJJQdaoUyyj8YMWg5nXnLgLsCNadWr0KXwPaE+uxgmY4Pn16x7sBGwx8mNIy8YNc4UowQPV59jAq6TK/hckz0iphBAxpaWzxqWpIZ55s3Zfc/i9lNNop31ZZHnTvkVpGWjeu4v7gI6hhu+kVvQqGaWS+Yvn4jhKhBEv64VTIS8yAuXG9ujO988pTIGv3WM0d8oT9q9iPxzkoNZk5cJaETOwCH3tOi5tj2sv/ByTGYIdNTi2ZQUnvpso2flWQx0zf+1c//Qagwp1PZfiyXf8KNrkAHPQZs+HgtUuWe+5lovfiDUvhPC949iNT5jtg==
Received: from DM5PR04CA0053.namprd04.prod.outlook.com (2603:10b6:3:ef::15) by
 MWHPR1201MB0190.namprd12.prod.outlook.com (2603:10b6:301:55::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Wed, 21 Apr
 2021 12:08:11 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:ef:cafe::87) by DM5PR04CA0053.outlook.office365.com
 (2603:10b6:3:ef::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.21 via Frontend
 Transport; Wed, 21 Apr 2021 12:08:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4065.21 via Frontend Transport; Wed, 21 Apr 2021 12:08:11 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 21 Apr
 2021 12:08:10 +0000
Received: from [10.212.111.1] (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 21 Apr 2021 12:08:08 +0000
Subject: Re: [PATCH net-next 00/18] devlink: rate objects API
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <jiri@nvidia.com>
References: <1618918434-25520-1-git-send-email-dlinkin@nvidia.com>
 <20210420133529.4904f08b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dmytro Linkin <dlinkin@nvidia.com>
Message-ID: <97442589-c504-d997-52fb-edc0bdf1cbe5@nvidia.com>
Date:   Wed, 21 Apr 2021 15:08:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210420133529.4904f08b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57699497-698a-46a8-65c3-08d904be226f
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0190:
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0190330DD74BB3F2CAE5AAB3CB479@MWHPR1201MB0190.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fsO5C4/sqshz+JP4AuCzbIuTgmq1fK9zyPYMz/59vYAw7DjGw/PQ+rhuVTfq0sO8upmGvJoV2fXGOYb37W2/Bz1Xl/EHQPKZMDTdE9Za4qYcWGR74or2kltknZLbYH1w31F2F4DZ0Dbc0KyE8vW8YMtppW7Ki8IQR+3LzbPnCilDwAVG3ZGnPK3Y/tuLUz5pLb9ouOTJc2PZnZzlSGi9+eVi6h2kFR/G49h7CEp0Hn2vtytWrtEfz4Y6Hrw7JdiB++DLgNoMW/nTTGuxy/EtvSyawWeD+tdLao2WmZP3+M6Qya6frCVNmbblOIxX2cdFChhl1gecgirQ2rBqRI35k9nlGcvxBKh6XvWSWwA/eya92VYzJkqb+SXD8VlCxjtzp+KF0uNcF3uSljEnifzlJ5YY1knaNrNontnKAejnccfrpFlVJze13K2VZsYMoXlobIA3mAt7/bUIa58sT88xVI1LHA3a9uU1eqVw7QCjKRPec63veE8g1h0cmzbT1PNZLde7geGqLVtXQ4xHKCbxwWg9jj1a0GBNOk/Ay+HEm/7ysCRz1VbzO2Orw+ZYADoSx8x9LEnz/2F7LH81FuaAb8Y+3AYmxTMswRFqSa/SQyh+TX8kpBY9Qrbi2L2+RRc6F23ju2+ElGgC+Nb0NLKGo1Ac2zfk4BSC7EUm1AE04Ch9Q5AQpja1SCBGQ5n79sOY
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(396003)(346002)(136003)(376002)(39860400002)(36840700001)(46966006)(356005)(186003)(316002)(36860700001)(36906005)(336012)(83380400001)(82310400003)(8936002)(107886003)(16576012)(82740400003)(7636003)(8676002)(4326008)(478600001)(47076005)(6916009)(2616005)(53546011)(36756003)(26005)(54906003)(426003)(86362001)(31696002)(70206006)(2906002)(70586007)(5660300002)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2021 12:08:11.6629
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 57699497-698a-46a8-65c3-08d904be226f
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0190
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/20/21 11:35 PM, Jakub Kicinski wrote:
> On Tue, 20 Apr 2021 14:33:36 +0300 dlinkin@nvidia.com wrote:
>> From: Dmytro Linkin <dlinkin@nvidia.com>
>>
>> Currently kernel provides a way to change tx rate of single VF in
>> switchdev mode via tc-police action. When lots of VFs are configured
>> management of theirs rates becomes non-trivial task and some grouping
>> mechanism is required. Implementing such grouping in tc-police will bring
>> flow related limitations and unwanted complications, like:
>> - flows requires net device to be placed on
> 
> Meaning they are only usable in "switchdev mode"?

Meaning, "groups" wouldn't have corresponding net devices and needs
somehow to deal with that. I'll rephrase this line.

> 
>> - effect of limiting depends on the position of tc-police action in the
>>   pipeline
> 
> Could you expand? tc-police is usually expected to be first.

Ok

>
>> - etc.
> 
> Please expand.

Ok

> 
>> According to that devlink is the most appropriate place.
>>
>> This series introduces devlink API for managing tx rate of single devlink
>> port or of a group by invoking callbacks (see below) of corresponding
>> driver. Also devlink port or a group can be added to the parent group,
>> where driver responsible to handle rates of a group elements. To achieve
>> all of that new rate object is added. It can be one of the two types:
>> - leaf - represents a single devlink port; created/destroyed by the
>>   driver and bound to the devlink port. As example, some driver may
>>   create leaf rate object for every devlink port associated with VF.
>>   Since leaf have 1to1 mapping to it's devlink port, in user space it is
>>   referred as pci/<bus_addr>/<port_index>;
>> - node - represents a group of rate objects; created/deleted by request
>>   from the userspace; initially empty (no rate objects added). In
>>   userspace it is referred as pci/<bus_addr>/<node_name>, where node name
>>   can be any, except decimal number, to avoid collisions with leafs.
>>
>> devlink_ops extended with following callbacks:
>> - rate_{leaf|node}_tx_{share|max}_set
>> - rate_node_{new|del}
>> - rate_{leaf|node}_parent_set
> 
> Tx is incorrect. You're setting an admission rate limiter on the port.
> 
>> KAPI provides:
>> - creation/destruction of the leaf rate object associated with devlink
>>   port
>> - storing/retrieving driver specific data in rate object
>>
>> UAPI provides:
>> - dumping all or single rate objects
>> - setting tx_{share|max} of rate object of any type
>> - creating/deleting node rate object
>> - setting/unsetting parent of any rate object
> 
>> Add devlink rate object support for netdevsim driver.
>> To support devlink rate objects implement VF ports and eswitch mode
>> selector for netdevsim driver.
>>
>> Issues/open questions:
>> - Does user need DEVLINK_CMD_RATE_DEL_ALL_CHILD command to clean all
>>   children of particular parent node? For example:
>>   $ devlink port func rate flush netdevsim/netdevsim10/group
> 
> Is this an RFC? There is no real user in this set.

Yes. I'll resend patches anyway, because of issue with smtp server

> 

