Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E037917A060
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCEHHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:07:04 -0500
Received: from mail-bn8nam12on2065.outbound.protection.outlook.com ([40.107.237.65]:6059
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725877AbgCEHHE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 02:07:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OvEEeguQK8Z+8VUGdT769sGnr1+Ba6/If1alXPGvgTjkcAxZNkNwrV//AJGiuENc2rHJigdEijQbvo8pdCokxmMKwEzTRqPCigvrPsikXhAvQmMF4QYPe2g1mGBqmmcT6BpNBV+qtTv814d4viRgkGhe6TMLoHJqTy5EPnJNJHGMDKixRfMqalqnIDCqH0LYkUxucZ/G4mZ+mUP+TXUjB/XQLnS9s0TJTC467BQR8WTr5UfJvPh2e6BMOJXTN1ymttyKHZwvbBMYlgltO0YVMLTuNGF6duwB7fnwRwzqD8Vdc+HjgZyC7cPfVSOL+RezY2DkISbc3cf9IvowZnxl5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p91bTofGqjLPFIff0yanPg5p7fSvw+Ak+aofAZHpFoM=;
 b=DVuZl8tvcd7NHLCfHPbVscia56/D+ZCZiW5+f82epqVPfXtYlKYnbAeMt48FS/bGtx7ClscCC7YEfCK9HbLocrYanB+Cg1JJXYJjOxV2gSMJQcwBv5GXplHsIjU5yy+8DMYkFxHMAIvkDtyK+UbPd7WGDFfNqWcCrVZeAoih6U1uqSQxV0WRUWV8nGdKlxn3ek4ds+iBt0NJeVYeJfW+OUOFKVWsOxSl+Cy67sN/BuCZv32Ru7hA1YpgfKR0nerhcMxBUl4laOJ60BqbDyHyS53knZ9HIuPT0qd9xblxB6L3d2k5SGRCdjNLMGrz00au8WKsUJev8zlen+wYxxqKyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=permerror action=none header.from=amd.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p91bTofGqjLPFIff0yanPg5p7fSvw+Ak+aofAZHpFoM=;
 b=hOJsO3Ce3rmg0W6KpAqX+0Pegg8Ww+0jpinc0N1c8y1lwTTPmQjFcANbMoTvULRh+8gGeyPUZSMJQQvzUBAdhessOgw+xXee0hhgP/rWTCXSBqPT89kNvWmdgBAqSBFn0JWCAT8uWAwIX7ujEVdwOMHAaKyWY+//DQxmiWHbB10=
Received: from DM3PR12CA0131.namprd12.prod.outlook.com (2603:10b6:0:51::27) by
 MN2PR12MB4335.namprd12.prod.outlook.com (2603:10b6:208:1d4::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.15; Thu, 5 Mar
 2020 07:07:01 +0000
Received: from DM6NAM11FT062.eop-nam11.prod.protection.outlook.com
 (2603:10b6:0:51:cafe::35) by DM3PR12CA0131.outlook.office365.com
 (2603:10b6:0:51::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.11 via Frontend
 Transport; Thu, 5 Mar 2020 07:07:01 +0000
Authentication-Results: spf=none (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=permerror action=none
 header.from=amd.com;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
Received: from SATLEXMB01.amd.com (165.204.84.17) by
 DM6NAM11FT062.mail.protection.outlook.com (10.13.173.40) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.2793.11 via Frontend Transport; Thu, 5 Mar 2020 07:07:00 +0000
Received: from [10.217.80.179] (10.180.168.240) by SATLEXMB01.amd.com
 (10.181.40.142) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Thu, 5 Mar 2020
 01:06:59 -0600
Subject: Re: v5.5-rc1 and beyond insta-kills some Comcast wifi routers
To:     Tony Chuang <yhchuang@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <DM6PR12MB4331FD3C4EF86E6AF2B3EBC7E5E50@DM6PR12MB4331.namprd12.prod.outlook.com>
 <4e2a1fc1-4c14-733d-74e2-750ef1f81bf6@infradead.org>
 <87h7z4r9p5.fsf@kamboji.qca.qualcomm.com>
 <4bd036de86c94545af3e5d92f0920ac2@realtek.com>
 <DM6PR12MB433132A38F2AA6A5946B75CBE5E50@DM6PR12MB4331.namprd12.prod.outlook.com>
 <c185b1f27e4a4b66941b50697dba006c@realtek.com>
From:   Jason Mancini <Jason.Mancini@amd.com>
Message-ID: <ed6e071d-00c0-fb4d-4bbe-1f3668a0c140@amd.com>
Date:   Wed, 4 Mar 2020 23:06:58 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <c185b1f27e4a4b66941b50697dba006c@realtek.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB01.amd.com (10.181.40.142) To SATLEXMB01.amd.com
 (10.181.40.142)
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:165.204.84.17;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(136003)(376002)(428003)(199004)(189003)(70206006)(478600001)(2906002)(426003)(70586007)(8676002)(31686004)(81166006)(31696002)(2616005)(53546011)(110136005)(54906003)(336012)(316002)(81156014)(4326008)(16576012)(5660300002)(26005)(16526019)(66574012)(36756003)(8936002)(356004)(186003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR12MB4335;H:SATLEXMB01.amd.com;FPR:;SPF:None;LANG:en;PTR:InfoDomainNonexistent;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1e8b58b4-9fee-4f90-b252-08d7c0d3cd34
X-MS-TrafficTypeDiagnostic: MN2PR12MB4335:
X-Microsoft-Antispam-PRVS: <MN2PR12MB4335C2185558DB38CF1B8F21E5E20@MN2PR12MB4335.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 03333C607F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: biigbgUVKPaf67Vp5smU0u+9hn1yWkhDiUL27uko2WCr7o6eNsc62Z7QW/cKFHQ35mJeyOYH3vrhpcHSIcm3VgX5YEkB1Sbu35veF3MRK+i8MsRgNZVWvRf42BlBHdNuq2JhgqiTKdkjCLyLL89FBMv6ngnKigZtPsfHM9lGATCLbK+knz1U8SMi4BwGWijO2VBGSXceVs39xwLPkvQBgZrW7i3zpVfEeXhqN1S7yxF74+s1/sEjn+j1G9/3MnVY5kNbi4JqyLc8MOuSC8m58Yd5ATbM3U954hF80Ee6Q+TByV8F5OeFaVJI+ofIMUNnK+CsmaaYv89pGdXwaQ839ShRun5/Ek+GvG/Rdze3btnOF7HfIaUHn0bFFrkfeF4gyhWI5mFX6kE4+cZgW59OyNACztNCO/eL0m9jrIk7mU4aDqzg20bKDaKRlYLk+I03
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 07:07:00.8790
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e8b58b4-9fee-4f90-b252-08d7c0d3cd34
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB01.amd.com]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4335
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/20 2:41 AM, Tony Chuang wrote:
> Unfortunately, no, there's no flag to turn off this.
> But, from your experiments, if you applied that patch,
> ("rtw88: disable TX-AMSDU on 2.4G band") connect to AP on 2.4G, and still crash
> the Comcast AP, then it looks like it's not TX-AMSDU to be blamed.
>
> Assume the return value you mentioned is max_rc_amsdu_len, if you always
> return 1, it will just disable all of the AMSDU process.
> You can try it, and to see if sending AMSDU will crash the router or not.
>
> Yen-Hsuan

(Specifically, this Comcast router is "Arris TG1682G" firmware 10.1.27B.SIP.PC20.CT hardware version 9.0)

I re-tested tonight, here are the results, from *unpatched* kernels:

(1) 2.4G only w/5G disabled via router control panel: kernel 5.5/5.6 seemingly doesn't upset router.
(2) 5G only w/2.4G disabled via router control panel: kernel 5.5/5.6 definitely kill router wifi.
(3) 5G only w/2.4G disabled via router control panel: plus get_max_amsdu_len forced to return 1: kernel 5.6-rc4 seemingly doesn't upset router.

As you can see, the suggested patch isn't going to help result (2), and apparently isn't needed for (1).  And this router's 5G seems
allergic to amsdu per (3), so somehow amsdu is involved it seems.

Well, I'll just work around it with (3) custom kernels, or (1) leave the router in 2.4G mode.  But be aware that apparently there's at least
one common buggy wifi router that's going to puke on 5G + amsdu.

Jason

