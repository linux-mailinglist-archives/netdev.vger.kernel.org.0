Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCFF47FC5F
	for <lists+netdev@lfdr.de>; Mon, 27 Dec 2021 12:56:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233631AbhL0L4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Dec 2021 06:56:02 -0500
Received: from mail-bn8nam11on2078.outbound.protection.outlook.com ([40.107.236.78]:62048
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233610AbhL0L4C (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Dec 2021 06:56:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlOYkhFttKOFFEN7rdspn07guutzR2QD8ZLZ5Up8KGtlsW/09Xiea9Kd7ZDiXVzDGLw6Io/J8vs6Y+u0nyerWFpbLWr5F6mqin706SAAM0X2lSqx4ZleBKXDWgMBuXnG70momJJ7QbWEhJpdygTMwIcVMsdu6qmIOnIMr4MqjJuamUbNs8OTc6szuEi0+ink9aDe8CpiNz0L69MSqbcNUD5bTiiZkkJcF6Sj0c3yhslQzXJTPvca9TZITWYu/KCTBfsH2c/U+7mfyW1LxKaK4ZqX71QGlQD3JNGrTwKb25cOwJx6qtyazgsuGOhP12xgP+OGbrwahdFSge/kLELMFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rHjc+haXJ3N0fI3TA9Jur+pxStmTK8+xRk3JKyYpXu4=;
 b=hFqBa+LWP3wEBHcnHaJmBlqrmogcjUDDAmIN5/QBDmt8Wdmr+igiO9SDZaqa0TrTpVJTpb7js6Bh5JjtrQVVOsMNWhtqjhmndkj4zJgh8jLIUPTUnUCf/167i1P+joD5YbxYOyZK2nE9Kdi7JdXjDDH/R74kU6q8ZWNRM2fK5SO9bXOoi4ilIYFR2SVT32L04fBkBwl1XtfejMNBWV85s/plKA5TPexsnLhD7oIu9MLx4XO1v13Kc+rxX0QjjN5ZZJ7cCPgMYwIamED+0xPmrfdwW+iqgbGqM1OcnV/Acl2uc7ZfFrtPr5s9l00HWvq4YxC1qIht+r+rkbEOJsyADw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rHjc+haXJ3N0fI3TA9Jur+pxStmTK8+xRk3JKyYpXu4=;
 b=MZDkm1eIe8dDle4fvPlAWj2UJzGWlMQT466hy45/eqkmBOB7SP0JlkvU4VuhtWO+1YI2kaM4vt8dHQ9vB41coASIti+x62krHNln5a2IcKdXh1EDUB9nqOKh6o6kSfGNmXU2TqcX9QYzOxigd8NLmx8rZv9n5zV+RQDex0FrdZE62rnh2v/ybdttwQWdkM2xe3vJ26Sokm6lW1E+lQPyk7hyqQmWiD88KIPKpeQfKpSQBiCSxnfEZSsI0he6dVBuzzSXFv+K0dXobdaSZT5LhaPg1WLH8gnDgpLMDes3zlQI8szoKmoCuWNpngHg7238KAekrgKKt/FXxITtAXdF1g==
Received: from CO2PR07CA0065.namprd07.prod.outlook.com (2603:10b6:100::33) by
 BL0PR12MB2401.namprd12.prod.outlook.com (2603:10b6:207:4d::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4823.19; Mon, 27 Dec 2021 11:56:00 +0000
Received: from CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
 (2603:10b6:100:0:cafe::4) by CO2PR07CA0065.outlook.office365.com
 (2603:10b6:100::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18 via Frontend
 Transport; Mon, 27 Dec 2021 11:55:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT005.mail.protection.outlook.com (10.13.174.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4823.18 via Frontend Transport; Mon, 27 Dec 2021 11:55:59 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 27 Dec
 2021 11:55:58 +0000
Received: from [172.27.0.136] (172.20.187.6) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Mon, 27 Dec 2021
 03:55:55 -0800
Message-ID: <ec0cd540-e785-3a3a-311f-10f0d7bc7adc@nvidia.com>
Date:   Mon, 27 Dec 2021 13:55:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
Subject: Re: [PATCH net-next] net: bridge: Get SIOCGIFBR/SIOCSIFBR ioctl
 working in compat mode
Content-Language: en-US
To:     Remi Pommarel <repk@triplefau.lt>, <netdev@vger.kernel.org>
CC:     Roopa Prabhu <roopa@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <bridge@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
References: <20211224114640.29679-1-repk@triplefau.lt>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
In-Reply-To: <20211224114640.29679-1-repk@triplefau.lt>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 961b0ec4-69de-47ea-e238-08d9c92fd96b
X-MS-TrafficTypeDiagnostic: BL0PR12MB2401:EE_
X-Microsoft-Antispam-PRVS: <BL0PR12MB240134CAB399A236C6D2BD6ADF429@BL0PR12MB2401.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:339;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6B3xJdT/y+nZVaZdUkY5G6SE1KXk98/UOtBpzfx5n6U2klOutLv6E5Wc3NNtuTliuJS9hRuR3cRkBvGnpQR/KP1XR9fo/H7kVmRz1je6JHP6368stEluT0zAyxDs6mIUf/CRlWpRZe2qQb3lcin7/9XKR19cY+Fk88eu3nU1dW5qiW0EUBb6nfaWwEhkV9Sa2Py8fbpg+L2y8A4piXOZV0MPeIYeIrO8V6cB8N+CegWt8NKVhM4BOGP1+Hj52aiAKeWBeGhb6VsWwd8WpOw4U4Pr/xgAsg/uuLYJYO4YJ85GFAmY+KzKDTTyfNBY7qtGjEQeZnbf6czqQqWBW/nDkJAt9JEG1P4wBTO3Pc6NNRosY8x7rg9PBG9k1LzkoPjZfNc7SCKU9Zu/FXimyyRqwcsaithlFY3H/ggkWgA2YT5UWaa1ePGXih0XzV0HQuumg+Z05hy6G95ujsSqpQ2t9Rzz4vPsWhyDZJPs813s5i5zeBwZ7mOqlhyW6r83+UyQyTm04NGGdvOmCySnnloCxXAm+y3sO006e2Sc6AlmLhJYICpRvVje0mcxIHfHZZpu1oF8BYe+N+7KI3hTe+TvQCa+FKxDasLk7kOA6T6Bn3pmJ1uCPtlIXc92wRq++JzbftPzzEJMUcgscQdL55NDDLhUG3sAo9ZKjd9DxKbWxAVM+OEjfA38NL2turhznrrIxpDDc15M1s2siZkN0f1k9d4kNZnQ1C0POSf3EieQNrhuG6UUSXzTZ/9jdClK+AkrDCAe2YVIxNwywPjhRMJhXdNcY80Kvbua3Zf0pjj5bIvajUR1cRoCqGWUerVdaYdMI1w+F/oH2+NDRxbwncH2LQ==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(40470700002)(46966006)(36840700001)(316002)(356005)(110136005)(70586007)(70206006)(8676002)(36756003)(16576012)(81166007)(31696002)(508600001)(86362001)(36860700001)(8936002)(47076005)(2616005)(31686004)(40460700001)(82310400004)(53546011)(16526019)(426003)(336012)(186003)(26005)(83380400001)(4744005)(6666004)(4326008)(2906002)(5660300002)(54906003)(43740500002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Dec 2021 11:55:59.6757
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 961b0ec4-69de-47ea-e238-08d9c92fd96b
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT005.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB2401
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/12/2021 13:46, Remi Pommarel wrote:
> In compat mode SIOC{G,S}IFBR ioctls were only supporting
> BRCTL_GET_VERSION returning an artificially version to spur userland
> tool to use SIOCDEVPRIVATE instead. But some userland tools ignore that
> and use SIOC{G,S}IFBR unconditionally as seen with busybox's brctl.
> 
> Example of non working 32-bit brctl with CONFIG_COMPAT=y:
> $ brctl show
> brctl: SIOCGIFBR: Invalid argument
> 
> Example of fixed 32-bit brctl with CONFIG_COMPAT=y:
> $ brctl show
> bridge name     bridge id               STP enabled     interfaces
> br0
> 
> Signed-off-by: Remi Pommarel <repk@triplefau.lt>
> Co-developed-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  net/bridge/br_ioctl.c | 75 ++++++++++++++++++++++++++++---------------
>  net/socket.c          | 20 ++----------
>  2 files changed, 52 insertions(+), 43 deletions(-)
> 

Looks good to me, thanks.
Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


