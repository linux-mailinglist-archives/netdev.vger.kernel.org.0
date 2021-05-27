Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA9D4392FE6
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 15:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236547AbhE0NkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 09:40:09 -0400
Received: from mail-bn8nam12on2066.outbound.protection.outlook.com ([40.107.237.66]:45440
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236335AbhE0NkI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 09:40:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OJfPaPUOPLhJtLqpd2l9ZmjkZxULdkYeWlw0we7eMVkqLvLJePF/u8cdktT2MgwYxY6FczfZT8R93Qfcet8qZq8Y5GjJhayCHcmNO+p+cbZByKniQ0MKjxgT2E5u7qiabrJTu9ZMQlwZHKo9XswJ4d/m3WzHd3C82PSdRnI6+jDMk7vd84NqEIS/ZUgH/qvikUmr26ozTiW6EZYDcOhjqm5jxDLOWlitK+4zwBlX8abWt4NoC1EzV4txpkzHpUNb/K7aquo3pw5rYsb0dIUOiHtCIFvCzAtX+xTG03njjuWOXEaiyuMmXfmrq7YciC/LnG9+YlS9Ee5Dz4qBbxPJLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6ZaPS61cNOH7a36roS2Maa8+I2aqgF9OWA0kVliOVY=;
 b=Y4ku6MKwtyJ+A9V5NPRFEx5YjjKIkf0AgMEcR2fClod+k0zKWHupfrEzNQ7x1WDzkaLZXpP8pDSTso/RC+J/yVjmQjewV6Nsb13QBgIWz+5t+o44Ih7I9puhKnyzTDkJ7Zx/LN7tK80WVDHgm4Oa8ixfSYEvF3DWMOMQEGU69f2uOr7vShWpess1nulAEdpgYS7EbG3OmljOQKdII3sDXlk2tukcsl04GX641DdoUMA/BW2lt6CErgm5b7/ltpU/6s0RlZvazbpo8eFI0VPl84j3cWR0ZT0Q6tTx5PIz62wfslzOc+bGYZc7jwuRoRIl9jpogh01/kGMz7lljrIc8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=foss.st.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j6ZaPS61cNOH7a36roS2Maa8+I2aqgF9OWA0kVliOVY=;
 b=ZfJ/CxdFz2Bqq2HoH+ZKd5rNQCFaA5mPUoowr77rnXQbZX06+u7GIPySrpicnI6GxRTiElbjV7tT20S5TYVP8mI0bzhwNX/t6paja/ZZxlucQ0xHbeZL2Go1jh7+iIcag/BNezitvJy8e7AKoVcVeOu76xX956Y2pBi9g3H23d+UvzeFlM7do7fGzJE1LmlcuaB4QBnXUT5MAWxJcHKetONUXtgk6aQ6TNw/hpt2szpxx3eom+ZM2NfJAjb351Hya8X6fI0gtI12HPjd0XJiaf+1/HNclr7O1LM8OO1W0OSdIBc8Z5Gyte/YMfS9QKu4NlXYz7FH6f3QL4/Oa0hWYQ==
Received: from DM5PR18CA0086.namprd18.prod.outlook.com (2603:10b6:3:3::24) by
 BN8PR12MB3233.namprd12.prod.outlook.com (2603:10b6:408:9f::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.20; Thu, 27 May 2021 13:38:33 +0000
Received: from DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:3:cafe::2) by DM5PR18CA0086.outlook.office365.com
 (2603:10b6:3:3::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend
 Transport; Thu, 27 May 2021 13:38:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; foss.st.com; dkim=none (message not signed)
 header.d=none;foss.st.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT060.mail.protection.outlook.com (10.13.173.63) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Thu, 27 May 2021 13:38:33 +0000
Received: from [10.26.49.10] (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 27 May
 2021 13:38:30 +0000
Subject: Re: [PATCH V1 net-next] net: stmmac: should not modify RX descriptor
 when STMMAC resume
To:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "treding@nvidia.com" <treding@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
References: <20210527084911.20116-1-qiangqing.zhang@nxp.com>
 <e2f651f8-e426-1419-dbdc-4854b3d6ee83@nvidia.com>
 <DB8PR04MB67959938BC55D9ADA00488EAE6239@DB8PR04MB6795.eurprd04.prod.outlook.com>
From:   Jon Hunter <jonathanh@nvidia.com>
Message-ID: <ff7a837d-2ba9-f6fe-9c22-cf9d1c9e9e31@nvidia.com>
Date:   Thu, 27 May 2021 14:38:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <DB8PR04MB67959938BC55D9ADA00488EAE6239@DB8PR04MB6795.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8245ade4-32d5-48ab-e9d1-08d92114b8e3
X-MS-TrafficTypeDiagnostic: BN8PR12MB3233:
X-Microsoft-Antispam-PRVS: <BN8PR12MB32330EFE33608B847651D194D9239@BN8PR12MB3233.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2/ivWL3ELK6+Fq9ihbniusSZRD+yyPha9FIGeXjW7sXVzsXyE8WXBA6hYP2y62v3lBCKyvR8fxMx0KP5YTDcsInW6jAJEOu1MObRkUlIr+Ly/S8+fKSJ4kkewTvLyUUTvcJ3uJAOnD4IK4UHr6ISOVdlWLUb/caoZQEG8VtN+/TX1+7qI1UAxuYfOJQ8TC8tZOTe1O3hMenrubxOB2t2uFrYXEfoUi5t801hopSqyWxtmwM3pn1Gs+WqEP1UxaiEadmfsAbYMzMsMcHmMK0XOh2/Z+yxtmGCJ3H4+LqanFXdzChL0TUmM2ifu1nUy+4FoY+eVypU9Aivow9fq7gwpeHstvCFqMkzQrgzDfyr/ZP07pRbc1Mta/ndmxgXkovd7ZTuBC/FMpjgVVUFbtQeUPluGmDG/v4AhnbAQ4S4kOZ3pL1tk3RLaiXrUh/E4+4rw0f3tNbf67O38Z3HRHIgSsT6FijEZpmtYxrmfEVssu3rvtMLoW7MoyiKa5HEkYzQcNfc66OyV82Kn5rqKF+yZrvhxYN17Znu3cD8cRwlf19aRA9ilhcc6n0syGoNVi5nZL50WgkYEWvRDgCovcHrNhMxpGHy5YO4CQvUJjjn8lg9rZyMTt5u3XjCUbA24Ae6IO4g6YxzdgQE8cahT4dZYqDqN5kyhggj/nCVeYmIdMedqFQ2uSGv92CNvHbGl184U2PyRPXNMN1ohVX5Y58uPQ==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(396003)(39860400002)(46966006)(36840700001)(8936002)(316002)(16576012)(921005)(36906005)(53546011)(356005)(54906003)(26005)(36756003)(2616005)(2906002)(31696002)(426003)(86362001)(110136005)(186003)(47076005)(7636003)(5660300002)(36860700001)(336012)(6636002)(83380400001)(8676002)(7416002)(478600001)(70206006)(70586007)(82310400003)(4326008)(31686004)(82740400003)(16526019)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 13:38:33.3643
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8245ade4-32d5-48ab-e9d1-08d92114b8e3
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT060.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3233
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 27/05/2021 14:13, Joakim Zhang wrote:

...

>> So as previously mentioned this still causing a regression when resuming from
>> suspend on Jetson TX2 platform. I am not sure why you are still attempting to
>> push this patch as-is when it causes a complete failure for another platform. I
>> am quite disappointed that you are ignoring the issue we have reported :-(
> I first pushed the RFC and discussed about the issue, I think this patch trigger a potential issue at your side. 
> IMHO, you may need try to find the root case why this patch make regression on your platform.

I am always happy to test patches, but I am not sure it is completely
fair to ask us to debug an issue your patch is introducing. Yes this
could be uncovering an underlying issue with the driver, but that does
not mean we can introduce regressions.

TBH where are the maintainers of this driver? We really need their
inputs to help us figure this out.

>> To summarise we do not see any issues with suspend on Jetson TX2 without
>> this patch. I have stressed suspend on this board doing 2000 suspend iterations
>> and so no issues. However, this patch completely breaks resuming from
>> suspend for us. Therefore, I don't see how we can merge this.
> If you read the commit message, you should know you can't reproduce this issue if your DMA bit width is 32 bits.
> Please take the commit message seriously, do you admit this is a real bug? After the analysis, this may a common issue.

I did, but it seems that you are OK to break devices with 32-bit DMAs.
If it breaks Jetson then it could also break others but you don't know
that yet. I am not saying there is not a bug, but I am saying that you
cannot attempt to fix it, by causing regressions for other platforms.

>> Given that this fixes a problem, that appears to be specific to your platform,
>> why do you not implement this in away such that this is only done for your
>> platform?
> I really don't know how to take your case into account, let us add a flag in "struct plat_stmmacenet_data" to 
> separate different cases? If maintainer agree with this, I can do.
> 
> I agree keep this patch doesn't merge until a way also fit your platform. If there is still no good solutions, I will try to add
> a specific flag in platform data.

OK, so I am not sure why you are trying to push this patch again without
coming to a resolution with known issues this change is causing. And
that is the problem I have with this.

Jon

-- 
nvpublic
