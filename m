Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65DDA63F25E
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 15:11:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231224AbiLAOLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 09:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiLAOLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 09:11:46 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2089.outbound.protection.outlook.com [40.107.244.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD58DA7AAE
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 06:11:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CBr7y4sYiOrI+UxyB1LycXbR9R6rBq86IjuA1SEZ8iGvU9c0MzUpedDNeTzn+RPMEMI75/fsQvRmn7zfOe3o0scIjoH2S373sqCqhGk3RpB+Bs9UTjwH/CJ2lHOY/NWJ/Tc1cTEWAkkFU/ggkkxbgkxFupfZCrEeide8yK5H4LRbRJA9RUyVEddmoKFGBr9bDHyX1OaDLQ4L1DgMeWXKBOTWZ2JSotteiGTjrFHd0nkbaSJGt+NSZUw7vZYRREh+2Dg6TTceRKzV7O0tMqLA5F/v9Pd9HeIedFYQEQTCWk6Das7p4+zDnPUI3++jkYHXSj4HfKESd1Cf3Qf9l/eDpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8oNcpoyXznEU4V5nZieIM4WGR9Paq6KCT8hHsbklZl4=;
 b=d01JsfBxNMaiUrSgunwU1DDz3rDLu9ZtrHR5CytajqrpnHTkqZ4K8mJ1SOOHB7beqsRcKQQ7y2E7KTSVzs+8KrdNal1d8XIklim3qAbYjdgcgzP2IYC4x3r0vHVh1dYA16BGVRIlIslw1/s/Zxbd/frTlzw3ScdPMAMb1cHLF1yys/PDpRztvQz28MoQakFpAK6KEp44ryI53m0/zuu6oByErzVap4drtvVJpVMeo8OFhemgtUnHNO0mFYgplmwicaBhZ3aEtMOJeqxW3I2vbY9tJASZwib7K89gg9hFUigbcnCUvHmHCCkEoRHJE9+KHJq5oQhboGG0tUCm3uUGDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8oNcpoyXznEU4V5nZieIM4WGR9Paq6KCT8hHsbklZl4=;
 b=kB8VzW9b/3nTwroRKiDXxY/PdPKbF2xzlfCLd6JLMHfR899QAmFpTlwhUPAqtQAzjHrcNP+2yZMyxnHh1F4R9Et66oiU19JisF+P0ip7Qbzh/CrkIbtAAtxoJcbvRTvfAkiSEdeuKhm+GTew5wQfU+YLN7dqZGcCsWYod28hslBBvCVNd7yGrFkkx6eBCaJufdtHE/VdfQIYMoO4/pePiHa8nRgbWsuteDgZEIUeGehLyVoKbFUcOhZeO5Fxijj0FiSEnhjuWhMwXqmVKRYFo7YGju1/POly2iUAqOZvvSWI4GAeMol/I9VWD1vP8M3Etrkhm7JxLWKrPV2nuIoMbg==
Received: from DM6PR08CA0066.namprd08.prod.outlook.com (2603:10b6:5:1e0::40)
 by IA1PR12MB8190.namprd12.prod.outlook.com (2603:10b6:208:3f2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.6; Thu, 1 Dec
 2022 14:11:44 +0000
Received: from DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:1e0:cafe::e5) by DM6PR08CA0066.outlook.office365.com
 (2603:10b6:5:1e0::40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Thu, 1 Dec 2022 14:11:44 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 DM6NAM11FT013.mail.protection.outlook.com (10.13.173.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5857.21 via Frontend Transport; Thu, 1 Dec 2022 14:11:44 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 06:11:28 -0800
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Thu, 1 Dec 2022
 06:11:25 -0800
References: <20221128123817.2031745-1-daniel.machon@microchip.com>
 <20221128123817.2031745-2-daniel.machon@microchip.com>
 <0642f8ab-63be-7db2-bd7c-16f19a3bdddc@kernel.org>
 <87cz93fky0.fsf@nvidia.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     David Ahern <dsahern@kernel.org>,
        Daniel Machon <daniel.machon@microchip.com>,
        <netdev@vger.kernel.org>, <stephen@networkplumber.org>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v2 1/2] dcb: add new pcp-prio parameter to
 dcb app
Date:   Thu, 1 Dec 2022 15:10:00 +0100
In-Reply-To: <87cz93fky0.fsf@nvidia.com>
Message-ID: <87r0xjdxis.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail203.nvidia.com (10.129.68.9) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT013:EE_|IA1PR12MB8190:EE_
X-MS-Office365-Filtering-Correlation-Id: 1b48e6e6-2064-4b8f-5c68-08dad3a5f9eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tp6ZhMgQBSuHEnYuLuS502uGgPhJYDLvWYc5P5vy2hf5A6b+/alUWjtNduSOVqHf+mCMhp0q+boyTzuPp5hrdTW00jGNvj01vTkJifJ3jbQhWgrgdoEZCIWk7j2uAjeDWjstXwfoxf6zKt64yWnP/4efCcKa5xAN/5wgldetxz8j+uOZN+Jde7kOkZNDQgIRvYV6ms0Rd9mD218JouN64Bc1kobzZ5UuVUDd32tGaaERWd4J5FCZZmLmeNgmEYRI65f3EQNBIlyQEO5uNe+GsfG86ainqi82yL2gKhajQrNSFIVVJ28CYoeV3wxw63kPTcrewVL8P8T8CfApCkPBndJXXqrBjTKMCr/oGACSmmeNYvy5wUWIGVSTOZjSu4mo3IVId+bq4fIVq5fiCN42EKUD+qTyimNHUTYe14GMOdf9nnUj7Gt6n+A+TtE8KBgb1Ioj6kYJGh3yo9WkXYwB3JM8R2PTTYujEKWuo0ZsVc867Cxj0/YgKpGgz4aE34oEqlHUyKsDzQnglQMx30krQpJj6/NGcPuQ6F4mcXegbqkW++Bh8//sJOzpwFyLYCFVTnsoSh3nna602CFYTaBzqHpGzyO2W4ORJRKhRKX0Ewh1T8ai1KUDmnWDmLWwL5xiWobvnkB6UnjkuXJ+O7SxFF3IzyC48S+IT9kXpOP9EDNznZriJtQkxyHPB+JQedYNI480fNc9qtcuYzcxP3/4pQ==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199015)(36840700001)(40470700004)(46966006)(70586007)(36756003)(82740400003)(41300700001)(2906002)(6200100001)(40460700003)(4744005)(47076005)(426003)(356005)(36860700001)(316002)(37006003)(2616005)(8676002)(478600001)(54906003)(70206006)(7636003)(86362001)(53546011)(8936002)(5660300002)(336012)(6666004)(6862004)(82310400005)(26005)(40480700001)(16526019)(4326008)(186003);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Dec 2022 14:11:44.0800
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b48e6e6-2064-4b8f-5c68-08dad3a5f9eb
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT013.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8190
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Petr Machata <petrm@nvidia.com> writes:

> David Ahern <dsahern@kernel.org> writes:
>
>> On 11/28/22 5:38 AM, Daniel Machon wrote:
>>> @@ -344,6 +420,17 @@ static int dcb_app_print_key_dscp(__u16 protocol)
>>>  	return print_uint(PRINT_ANY, NULL, "%d:", protocol);
>>>  }
>>>  
>>> +static int dcb_app_print_key_pcp(__u16 protocol)
>>> +{
>>> +	/* Print in numerical form, if protocol value is out-of-range */
>>> +	if (protocol > 15) {
>>
>> 15 is used in a number of places in this patch. What's the significance
>> and can you give it a name that identifies the meaning?
>
> Here in particular, it is ARRAY_LENGTH(pcp_names), and I agree, it would
> be better to express it this way.

(protocol >= ARRAY_LENGTH(pcp_names) obviously, not >)
