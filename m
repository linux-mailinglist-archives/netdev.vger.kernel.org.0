Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5050D643F51
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 10:05:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234537AbiLFJF2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 04:05:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbiLFJFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 04:05:24 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2040.outbound.protection.outlook.com [40.107.100.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5AC2639
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 01:05:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O1mbnOjmD0APN05Fjkbzin8kxCAmjDHvjOoWsABcRJ4SRsUwKbZIjEh2/g4ljPghzIr7ga8qJsvGXR5+5ZR+nIU1DDfmtbb7ikEpzQynPnRI4ks6wo8IfjCOIe8F0rIYtx7QcQJT1NLibSN7JcCtkXRM79bteoNEapUDRdAUxm3Rqy9K7bFB9EYMDj5PiZ6GkLCkg09EeZ/zs5W8PEmdgQRySq7b4iIkMaG7TcvY+z4cu0uZSSC9Bp34heozCNmtmKH0ekui6PX2qELydDM7nW+aq4oQVyCHNaNuFNJWpF3VNHCDMzI8sy4y1xZVpkkLt/sV/Maonhuj2T7HruoWmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=M+tkNzCIPo0oJBpWW9+u6z1YRvIgliHgMVIxQukW6i8=;
 b=AWbl9tZyDMQ2bVm39uaSxt3SbzJCp+nrCfq6YC6PPAdnpbKokotXVjf75nRjaV6lXl3aPjVK17v7b/gg/53DQIg9bRlRwQoucM2WY9w2heBbK8IEMeESDpDVVDJflo4B08WDNRU4kWWE+nq00TvjRmTPNNtOF5nYQtGI8IntN8zgiSu2kA+MD4kogU8R7mW69YnRnpqqQpgTmyPCto3FqcKcq9Tx3CKFViZnx6dyFuGjRxPe404zgNLiEYa6InV37Hz6LVh7alRfxI5dFglcGCrMZWwp58nHkW/kFEVa0trB73UhczgcUZOSvGnHuak3Ag6qKxSXCRrSD31VUOjlOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=microchip.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+tkNzCIPo0oJBpWW9+u6z1YRvIgliHgMVIxQukW6i8=;
 b=VTkfiUu4/X0CkOzVzVqHNcndAlurrvev6skukiqc8TyRlq6PYVAI25IUF67bJTd50j+ALUT3sIdjarbiY5s3vSXk8hU4wmEvWou3E7Hf5JPQ5LveMmNRh7v1Z/9nk+XQQ1hwpoJrbBBWuSpgpE0kfUPOO7UlcTFSPzbVqH1ob4+6NsUWjsyNn6YssB5fGAS4aOtMf9xUo5d66ZC2RAqU+uct8fiqP7Xj0yJTZoxsEOduCWMSwPgisZd35lgFvYanmLhYIK2arfW9AK7aSFr2K1OuB9xIFTLBQITNDBebSBJDWE74Rb2IJdU+1oEzZGE/ldk2esHgXgHtyQ2lO4o8dg==
Received: from BN6PR17CA0043.namprd17.prod.outlook.com (2603:10b6:405:75::32)
 by DS7PR12MB5934.namprd12.prod.outlook.com (2603:10b6:8:7d::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Tue, 6 Dec
 2022 09:05:21 +0000
Received: from BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:405:75:cafe::c8) by BN6PR17CA0043.outlook.office365.com
 (2603:10b6:405:75::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.8 via Frontend
 Transport; Tue, 6 Dec 2022 09:05:21 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT080.mail.protection.outlook.com (10.13.176.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5901.14 via Frontend Transport; Tue, 6 Dec 2022 09:05:21 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 01:05:07 -0800
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Tue, 6 Dec 2022
 01:05:05 -0800
References: <20221202092235.224022-1-daniel.machon@microchip.com>
 <20221202092235.224022-2-daniel.machon@microchip.com>
 <20221203090052.65ff3bf1@hermes.local> <Y40hjAoN4VcUCatp@DEN-LT-70577>
 <20221204175257.75e09ff1@hermes.local> <Y426Pzdw5341RbCP@DEN-LT-70577>
 <20221205082305.51964674@hermes.local> <Y45G/t9V3luxRDGF@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <dsahern@kernel.org>, <petrm@nvidia.com>,
        <maxime.chevallier@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH iproute2-next v3 1/2] dcb: add new pcp-prio parameter to
 dcb app
Date:   Tue, 6 Dec 2022 09:55:33 +0100
In-Reply-To: <Y45G/t9V3luxRDGF@DEN-LT-70577>
Message-ID: <875yeoewch.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail202.nvidia.com (10.129.68.7) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT080:EE_|DS7PR12MB5934:EE_
X-MS-Office365-Filtering-Correlation-Id: 07e45491-d2d3-41e9-b411-08dad76900de
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LdQF9L5SmimElw72WQk4WsYVO3fJVDWmW55zyPEXgmQCuc+L4rclarqp6aM5TyKQjQ+vbmgdBi1rzgas+GczNj6P7wV9h0Sh189blGQFwZFC3cNRPwV+W1jEp2pNvqTxNsO9q6iTA63V38QpINtVzTgUbiF7fxVDhmuf3XZGS9h9I1IK22kHlKFGX0WUwNMgEHagK3XN+IqfMKacAm+XABk8T+SW/1SkclMBEeIjRI2tOjl2SHBgtrJ6FiRejuPaW+oAKKYWKdye3IZGZ+71rAnEDEk8Bsg9wZ/uC6kz0lkWISFD4XLERmNc6EVLHzNZozff8T0FAkH8IB1VS5uV8ksFfVgW1x5qCuHrvnSJqP5A3KL+wgESyChuPQGoyQ0SE+/TqBS1YXxCGTWOZCbvz/8uKYR5VIXIO4G1ObkqbOFGGOS3MoffX7GpUpevwDWkCuRTMFy532D6KQx6DvPLBFabiEg51/rImcesZknC1CSep+Jm4fhwJuqwSPTVf2pjHic3OD0f93NzuZypbNUCKtBsowcSI7wRESxtphR+PUnpw3weTi9qHVONxk6P1MPfdXUTGcog4dpNFYUXHtZYKGALZ0HL2cXCrNEmWPHNSgRhdnBQOF3dZbco62Mo6cObqujpwzojGcxgqLhdiTGJyEfF11QskIvy5qhz6kZgNbD4PQTiNlkarGej6vKflPTCMXEtuX3Q6ysANjNs5HyBag==
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(396003)(39860400002)(136003)(346002)(376002)(451199015)(36840700001)(40470700004)(46966006)(26005)(41300700001)(186003)(40460700003)(8936002)(6666004)(70206006)(4326008)(356005)(7636003)(478600001)(8676002)(70586007)(2906002)(82310400005)(54906003)(40480700001)(6916009)(82740400003)(86362001)(426003)(16526019)(36860700001)(336012)(47076005)(316002)(5660300002)(36756003)(2616005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2022 09:05:21.0448
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07e45491-d2d3-41e9-b411-08dad76900de
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB5934
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> On Mon, 5 Dec 2022 09:19:06 +0000
>> <Daniel.Machon@microchip.com> wrote:
>> 
>> > > > Trying to understand your comment.
>> > > >
>> > > > Are you talking about not producing any JSON output with the symbolic
>> > > > PCP values? eg. ["1de", 1] -> [8, 1]. So basically print with PRINT_FP
>> > > > in case of printing in JSON context?
>> > >
>> > > What does output look like in json and non-json versions?
>> >
>> > non-JSON: pcp-prio 1de:1
>> > JSON    : {"pcp_prio":[["1de",1]]}
>> 
>> Would the JSON be better as:
>>         { "pcp_prio" :[ { "1de":1 } ] }
>> 
>> It looks like the PCP values are both unique and used in a name/value manner.
>
> In this case I think it would be best to stay consistent with the rest
> of the dcb app code. All priority mappings are printed using the
> dcb_app_print_filtered() (now also the pcp-prio), which creates an
> array, for whatever reason.

The reason is that APP mappings are not unique. It is OK to have rules
for both 1de:1 and 1de:2. And 2de:1 and 2de:2 too, it's a full m:n
relationship. A JSON dictionary would not work well for this purpose.
(It's not technically forbidden to have duplicate keys in a JSON
dictionary, just discouraged, i.e. SHOULD NOT rather than SHALL NOT, but
e.g. jq then doesn't let you work with both entries.)
