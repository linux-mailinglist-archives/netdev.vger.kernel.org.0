Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28FA3735FF
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 10:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhEEIGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 May 2021 04:06:12 -0400
Received: from mail-mw2nam10on2047.outbound.protection.outlook.com ([40.107.94.47]:56257
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231520AbhEEIGL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 May 2021 04:06:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A0pNE1l2dttKTvXL9GdOgRZ50R4mISSMKcBbWK6EoWmNIa6wnW0g73jvfcqUy0iSglns3mR14uNzOxpBFwL578KJawICCBD7tQzTErlajuC+ltz0Z2c47kcHoqH9Jpizl6ykplwwaV+dyVSQX/wMZ6l6hnUKc41zOPLMApWbmfMEUz2ZFys7wdmBVua1XbxJdkKjwLjCnbQ3Xynbdd1YR6mPuTZJlBEKf3woAtbUCBPjky/JawsV3l3VuxoVpuV7CBNNM2FO9wd89CxQqJgxbfGjTo5DDNx6ziyGlrQ0NbNE1Qccn4xpF8ZNicz59sW44XlRcHM/WhH2xnZpAjIWbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPRkVEdo6It5UdAvByp33n16ncMMUhJ5LaQ2ZR7vG3E=;
 b=YsJbElx8ywg3xEaR3ugwYTlElmHwmqWJo3wlmwuY9x/290GNv9uonuVMFbJwBmVwivAz5PrzYH5anRNtJhIEQHvb2MEtEuANxk5TRfWf1L8MoUuXh6FQ/WgjXzW2HkARTUkG3HvjD6d4zFiqxzVcRTD1SRJzj92ejKX5bzs2n0yydYlagqYNVdLjvfGk0PCw9LqbkObi/CwrT49KXrT158hZ28Q+GiK4+iEbd2X6yAdXHyE+9p/Kdrpa/9bObkfRc7MhtPTDbaIKNwo0Twv3PS3hcK+3M2uURa4itRKMAQ+a+zpZXHg16hKeWJaK6K+yaGDAeqROcA+pMfidhLTUeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.35) smtp.rcpttodomain=kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jPRkVEdo6It5UdAvByp33n16ncMMUhJ5LaQ2ZR7vG3E=;
 b=gYPnC1xnAQELZ4keKX58DHJYyR7T2Tw3FPZKHxjDP+emFrPJs4V4aoyddBXfgPbwNUStivgM6jJTzE0VEp+1pkI/46Z732EQbxXA47Bkd/18oPTKtI8hRr+KuWz0b56AgK2FNxZuO2+r1SmODn/pNMX0n+PIGXRHBVZg7o9QYFM4OlRiUhSr12WDwkmQ8drbGpL3vQo9+/6b92q1drMiwV9A2cB3A3JdU+fbffM7Gz6S7bUh+0DPIgOagVq6ouzRR+GTy6lDQBngTHNB/CjyCrLyVlOzdRKzzhOyaDyPwHC3o3mFKq3PRR5t4btpWp2gHFoJdI4i1WlcUkURe4vhPw==
Received: from MWHPR21CA0052.namprd21.prod.outlook.com (2603:10b6:300:db::14)
 by BN6PR12MB1572.namprd12.prod.outlook.com (2603:10b6:405:3::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.38; Wed, 5 May
 2021 08:05:07 +0000
Received: from CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:db:cafe::6b) by MWHPR21CA0052.outlook.office365.com
 (2603:10b6:300:db::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.1 via Frontend
 Transport; Wed, 5 May 2021 08:05:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.35)
 smtp.mailfrom=nvidia.com; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.35 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.35; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.35) by
 CO1NAM11FT010.mail.protection.outlook.com (10.13.175.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4108.25 via Frontend Transport; Wed, 5 May 2021 08:05:07 +0000
Received: from HQMAIL105.nvidia.com (172.20.187.12) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 5 May
 2021 08:05:06 +0000
Received: from [10.212.111.1] (172.20.145.6) by mail.nvidia.com
 (172.20.187.12) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 5 May 2021 08:05:05 +0000
Subject: Re: [PATCH net-next 00/18] devlink: rate objects API
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <jiri@nvidia.com>
References: <1618918434-25520-1-git-send-email-dlinkin@nvidia.com>
 <20210420133529.4904f08b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <97442589-c504-d997-52fb-edc0bdf1cbe5@nvidia.com>
 <20210421115955.5c7fee82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Dmytro Linkin <dlinkin@nvidia.com>
Message-ID: <f834ff9f-8567-71f3-8dc6-50af24134d07@nvidia.com>
Date:   Wed, 5 May 2021 11:05:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210421115955.5c7fee82@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 28284ad7-559f-4562-4c82-08d90f9c7f30
X-MS-TrafficTypeDiagnostic: BN6PR12MB1572:
X-Microsoft-Antispam-PRVS: <BN6PR12MB1572838834E31D97BEC8EDBECB599@BN6PR12MB1572.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1079;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CbqMSs8GDomBE4TYntI06b60q6GCD1y6qGIRP8iPHzKV/9y49qrNsW/cSpmIGKnL0yBEoPXp4ywjMyLuppB7yececJlJ4qDvvAFxrSXfv0RMgd7ZkA2aTJY6u4pHZbqkSFxjoXqVSyIhrMpK+x67CBeTAGS3zB4f7Nm34QN83wQnE7OEfsY3mzlwRovTEyykxVDTrh7+1vi8WbCGRhnqF2r+pBAQMDLPmXGqbCkefE87EX4ItHL2k/hSeQsKF9yd+pqxVX4NG23qoftvbKzpIoz8oofIYnkPIvZW0Q7svMbLp9V1QzN1FIotEPP5LCZql61ig/7aiey7qHMJc1vivi5ppZE8NsIz0t+OKxnxhEYD7Fris7z6oM575q/t0N2NF7zP3TezNfgWhsR/n3gBdhRumkmjJEuIB4qpW9XdTw6ix++wFkHnHYmhQV4XrDZaJBuQOlceJDZs/WW/vg+Q//WGebI8oS9pK/Q+3ZXD/iX6yCjTE9cVaonlo91Nj87QqUncLqq6Bs4vqJ4hyZ4d2b8wGiL3ONnHyRDtvZ3RM80ADIg1l6YGxwYR7jdyuLzLTglbEUYUvgCARSuTFwWqtzroX631WP2PkL3sI+Rtv1EKrK5VU9fvbUEbuLJ8wiWc1Rt3wT9IYkJrrqwb2kyvT/cFeySL9Ft58SLOHPpgv+gl7JxU+zDgAhDZcyF4EEfV
X-Forefront-Antispam-Report: CIP:216.228.112.35;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid02.nvidia.com;CAT:NONE;SFS:(4636009)(136003)(39860400002)(346002)(376002)(396003)(36840700001)(46966006)(2906002)(6916009)(47076005)(31686004)(4326008)(53546011)(70206006)(31696002)(107886003)(70586007)(82310400003)(186003)(36860700001)(26005)(316002)(356005)(36756003)(83380400001)(8676002)(7636003)(54906003)(8936002)(5660300002)(426003)(2616005)(36906005)(82740400003)(336012)(16576012)(478600001)(86362001)(43740500002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2021 08:05:07.1792
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 28284ad7-559f-4562-4c82-08d90f9c7f30
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.35];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT010.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1572
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/21 9:59 PM, Jakub Kicinski wrote:
> On Wed, 21 Apr 2021 15:08:07 +0300 Dmytro Linkin wrote:
>> On 4/20/21 11:35 PM, Jakub Kicinski wrote:
>>> On Tue, 20 Apr 2021 14:33:36 +0300 dlinkin@nvidia.com wrote:  
>>>> From: Dmytro Linkin <dlinkin@nvidia.com>
>>>>
>>>> Currently kernel provides a way to change tx rate of single VF in
>>>> switchdev mode via tc-police action. When lots of VFs are configured
>>>> management of theirs rates becomes non-trivial task and some grouping
>>>> mechanism is required. Implementing such grouping in tc-police will bring
>>>> flow related limitations and unwanted complications, like:
>>>> - flows requires net device to be placed on  
>>>
>>> Meaning they are only usable in "switchdev mode"?  
>>
>> Meaning, "groups" wouldn't have corresponding net devices and needs
>> somehow to deal with that. I'll rephrase this line.
> 
> But you can share a police action across netdevs. A deeper analysis of
> the capabilities of the current subsystem would be appreciated before
> we commit to this (less expressive) implementation.
> 

Hi, Sorry for a delay in answering.

We have a customer request for a traffic shaper for a group of VFs.
tc-police action is a policer, so shared action isn't suitable. Since
request was more about group shaper, was reviewed a case when
representor have a policer and the driver will use a shaper if qdisc
action is continue and qdisc contains group of vf – but such approach
ugly, complicated and misleading.
Also TC is ingress only, while configuring "other" side of the wire
looks more like a “real” picture where shaping is outside of steering world.



