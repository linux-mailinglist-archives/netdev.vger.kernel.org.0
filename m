Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 425B5494575
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 02:18:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245400AbiATBSw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jan 2022 20:18:52 -0500
Received: from mail-dm6nam11on2051.outbound.protection.outlook.com ([40.107.223.51]:65120
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231224AbiATBSu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jan 2022 20:18:50 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bY39drpjYkBymhsE3MDA1v5638+6XiJLBsbcvsIbbhL+WLDNIaURrbi3q6kHgwQpu73oUq8/25cVPjWVEZ4G0/iIIyc1SWJl1cRB6vhenjOHOSbctH6oZnbJPdqDAg4Vx+53+CkS4bHCcZfXkEDcNbYEX58KW6ONyFwGH74t/PHfprQG7uYwPnT/VWE7rqLSK/d5lSj4XkeCdgUoilH5Kxp/2F8ad3NqIagJZZ4YLqgf/6/i7Z4DSVIE9wbTj76oM9p7I/1r/GC2P1coO6qvB6bt1z6aW5Kr9QnxZT6i2gOV7a1f/Rf9YVk4oJrIBGoFt5591caGxCMUe19GKrgnzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJuvjpm5Wp6Ne/P2A3nc9aYv0zwe010cpA9T7V+8IMo=;
 b=QDbktrL+LDayerdYSeDPu4bwjPu7H7GsKPZx/hsaxbp3ar0V5JER/lw6DfjjX/ph6ClVRIugg8RSiHV2RnFWUA6DnL4W5+ZVCqgkqzdcGBQZ7gsTd6NYwf97AsLpJ5n4xe8DCUZFuTzGfHfW6Kcwoar5YPOJPRa2G7jy6cLq/0UO+GgeX77dkiUF48nQoJgK2qPLBiTJGh9n5hWppM2q7iHKVZOA0D20S6tjvIVszOyS31AyhRUYycwrv6U5maVww9/bhAta0FFWVXFpVOn/IkoPZsJPmkE+4dIUg12PE93gBlHKwRv5kBzKk4B2kY1ZiKfuG7JZOiIfznxvm335Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=redhat.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJuvjpm5Wp6Ne/P2A3nc9aYv0zwe010cpA9T7V+8IMo=;
 b=Ws6v+ILI5ZhoizKLeBTBueUL9wQzypL7GdjsPutQelk+nkPPSIXzHGRQiixZ0ips4uqyef7Y1WdC8WG9lyZvC7DUgGQdEJlxARw5S3GlE9op+8h6XgRSgCB0dRoTGdCBejPwUOpWUf4n6/TIgwQpERAgR6Wl+WVEABi7i2c6ttjhkvBDiXxTdIhTGov5/7zecPPP934OnC8QvAmWA/u8REMzGv3jXPTgI8PUHdzDG3J2TIp1MfTDpqYEumbDreT2iT21c8xENRrlGMvE2DQcAmwBbriE1pYWApURKXPJZcpTVdRaDMkfXtrHexL2t0Hqlo/q5VL4ngIcI6VLLq/15Q==
Received: from MW4PR04CA0382.namprd04.prod.outlook.com (2603:10b6:303:81::27)
 by BYAPR12MB4710.namprd12.prod.outlook.com (2603:10b6:a03:9f::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Thu, 20 Jan
 2022 01:18:48 +0000
Received: from CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::16) by MW4PR04CA0382.outlook.office365.com
 (2603:10b6:303:81::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8 via Frontend
 Transport; Thu, 20 Jan 2022 01:18:47 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 CO1NAM11FT020.mail.protection.outlook.com (10.13.174.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Thu, 20 Jan 2022 01:18:47 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 01:18:47 +0000
Received: from nvdebian.localnet (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.986.9; Wed, 19 Jan 2022
 17:18:42 -0800
From:   Alistair Popple <apopple@nvidia.com>
To:     Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        =?ISO-8859-1?Q?Andr=E9?= Almeida <andrealmeid@collabora.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        chiminghao <chi.minghao@zte.com.cn>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL VIRTUAL MACHINE (KVM)" <kvm@vger.kernel.org>,
        "open list:LANDLOCK SECURITY MODULE" 
        <linux-security-module@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        "open list:NETWORKING [MPTCP]" <mptcp@lists.linux.dev>,
        "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        <kernel@collabora.com>
Subject: Re: [PATCH V2 09/10] selftests: vm: Add the uapi headers include variable
Date:   Thu, 20 Jan 2022 12:18:39 +1100
Message-ID: <54757552.kJZYbtWA24@nvdebian>
In-Reply-To: <20220119101531.2850400-10-usama.anjum@collabora.com>
References: <20220119101531.2850400-1-usama.anjum@collabora.com> <20220119101531.2850400-10-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10abd2f1-c3f7-44fd-3a1f-08d9dbb2cf60
X-MS-TrafficTypeDiagnostic: BYAPR12MB4710:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB4710AA8FA2265A4DC9A56E54DF5A9@BYAPR12MB4710.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2PrGDR22P30U4oAOvt1Ew6Gv2KYg6Gy4QW91H79kT/zmrgGHFiBjCwWiq7xmqhfmHXMZN6tJd/n4JGFAdTKK92xJa4GN5HEO3AesYssBBDfsTRLlEKrT8IZSd++oeajAW+n1djOR44UGlydQk5ZgDpOu8lZU1z4ZBQMgjAC65uaDogUAGaI2EwlPuGMOOI1phwCuZks7l1PjAM1u8tbvPqU96WJnwLpe5EgkZ8X3fW4Obd9qyyP7RqnF94YNW+JS9+e16eDQ4HGL3zmgaPGwFn3c0lIRKwP3ThI3LaFLuo2w/MLaUynMvLJJpG1PofqLVgmFIQvi4IpImPVB7KTF5nupRwyJPQCbe0fHTj02qh7OUbBO0nfuy7rSsnNdgvRUzh4MZy0TgAZ+eFzlZ03klU/D7YdqkFaL8vsMIwO2wg6rL1kI9n7W/lHTssjI4HZtNstl8TSaCCjeIdr5ywaQJdsihDKWU+7/2m2ZT0EcBMVJ3yRfTHDGv5O2/kzTfto/tiSU6kTYsFBuP5YGiMNitCCvZ1OSePhVTqUWg9wnY6v1vxXi4rYUUB4ihpLZgn82uHS3xEZtbHgiDBygWNhUTz0qpRruvGG3TThq/340FvQXl7Mg0kX1L5NYWjHKbtHOj1GXcavCUBLg4dvuKlCZ/qB/d3ce7yO/id0bMr3J9ZmA2T1KoBAehguNzrScGIoF7CP7DiiWHTwE4L2j9iTdKMTrFP/BajpT6Fh6vzQPHT/YU9pWOdUmBXB4qq9+X0DzqOYk7jeV8bkQC4KvYxk5lOWnw/9gn9UGvDP6VdY79cYvw+0WfLZgG5rOZWGQ3zgvcNG4hpzWDCL/wkY9eogps0nQmq4I2Z5EzfG53Mr6FrQ=
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(9686003)(81166007)(5660300002)(40460700001)(186003)(26005)(6666004)(47076005)(316002)(86362001)(70586007)(83380400001)(426003)(336012)(70206006)(16526019)(82310400004)(8676002)(921005)(9576002)(2906002)(33716001)(508600001)(7416002)(8936002)(36860700001)(110136005)(356005)(39026012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jan 2022 01:18:47.8393
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 10abd2f1-c3f7-44fd-3a1f-08d9dbb2cf60
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT020.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4710
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for fixing this! It has been annoying me for a while but I never found
the time to investigate properly. Feel free to add:

Tested-by: Alistair Popple <apopple@nvidia.com>

On Wednesday, 19 January 2022 9:15:30 PM AEDT Muhammad Usama Anjum wrote:
> Out of tree build of this test fails if relative path of the output
> directory is specified. Add the KHDR_INCLUDES to correctly reach the
> headers.
> 
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> ---
> Changes in V2:
>         Revert the excessive cleanup which was breaking the individual
> test build.
> ---
>  tools/testing/selftests/vm/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/vm/Makefile b/tools/testing/selftests/vm/Makefile
> index 7d100a7dc462..96714d2d49dc 100644
> --- a/tools/testing/selftests/vm/Makefile
> +++ b/tools/testing/selftests/vm/Makefile
> @@ -23,7 +23,7 @@ MACHINE ?= $(shell echo $(uname_M) | sed -e 's/aarch64.*/arm64/' -e 's/ppc64.*/p
>  # LDLIBS.
>  MAKEFLAGS += --no-builtin-rules
>  
> -CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS)
> +CFLAGS = -Wall -I ../../../../usr/include $(EXTRA_CFLAGS) $(KHDR_INCLUDES)
>  LDLIBS = -lrt -lpthread
>  TEST_GEN_FILES = compaction_test
>  TEST_GEN_FILES += gup_test
> 




