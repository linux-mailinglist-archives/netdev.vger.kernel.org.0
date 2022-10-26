Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5625060E3D4
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 16:55:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234270AbiJZOzY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 10:55:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234398AbiJZOzP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 10:55:15 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14F1113D5C;
        Wed, 26 Oct 2022 07:55:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IfNG5Bwkn4T10aMEtSm6DflTBJYVLWKcwoFGQwU6sey6oqb2PnTMfR+auTZmf45sya1r/VuKi/5V6d4dGh29X+AmzS4nPQSb2ycJTIRLfw7pK3TKwhngGa+P+oW1zlJCbwv14ew/MKTnhnUG1GpYFZ/7VxDe0ZL2kpoZfdncFDfJIdruLLt/Ho5fNT2+RXdavvyfacAAkqJlz5AWhml1lvI0/+Wvg+Ox7Kj8r7OG3U1tyBcsx872L7raK8q1BYlSFqka2wwP4U22sY5mo2nZQfOeuZMAaiYlpav5YNMRNmYaDabSLFdzp6EapcbsBQ733uzrsWds25QTiKnXEtfhQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=78+eN9scEcWw/knemipW33ExY/3ws/gPJbJWRMlFDQA=;
 b=R/DiuOiHr8pbuUrjQovSC0H84/bslMHaAGkkvH+iHspC7sKheZFKSCPDdeZIiAeuo6NeOa08yo+PJxeTFxCme6coGCVfwQRBN43XJC66vS5H8C7BKxuhyR7geLWpUSg3OwDZtITqMk0ejf/aP1ogtAtxbogJEH15+vTNFf4tqvFEuTYoX2/z1wYhGIuPgyNiUw38F2t/Oj5Aigdg+z0VqoT0kQWZmpsVkJwYfH9cZSqMV/i8RLNLnh9sxuNsJsU433XZ56hZeVmjNTP8gCcL15mGRrczmIBHdOEaIIupKH8Ws/ee0HFb6mIVhXL/oFvAHPG2KOgkiJ9oxml0khLy1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.160) smtp.rcpttodomain=lists.infradead.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=78+eN9scEcWw/knemipW33ExY/3ws/gPJbJWRMlFDQA=;
 b=dK8Sg6H26up/uMmowl8O0rH16DhjRmF0bphbYRW1io/GsTUTHTUXzPz02OYgxP1QvILnL814+w1CnMNSTgRBb/CQ2lBc1/vuHxLYeYoaoBb+CJYjKcF0fTGQvuRhBw5jtAHQmUePJ/FLe6ADb2P2KQLG3CIfem2htarLav5v2LL7Im8JTIEsv1D+26R41NSqxZ1OMncIhrz9wlXJ9AIk+LrBgmWbbAVGieqGu9tWjbHQZ8LRK/HtjqMjqMiCFgpacFq0qim57fmQF/1jEeACZhWoYC+8H9n6i5Wo4zce4FT6tFgjr9v/2+X995YJQBNsUt6iACv3b2mkfsaiBU1hFg==
Received: from DM6PR06CA0041.namprd06.prod.outlook.com (2603:10b6:5:54::18) by
 DM4PR12MB6301.namprd12.prod.outlook.com (2603:10b6:8:a5::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.33; Wed, 26 Oct 2022 14:55:12 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:54:cafe::75) by DM6PR06CA0041.outlook.office365.com
 (2603:10b6:5:54::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28 via Frontend
 Transport; Wed, 26 Oct 2022 14:55:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.160)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.160 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.160; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.160) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5746.16 via Frontend Transport; Wed, 26 Oct 2022 14:55:12 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.66) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Wed, 26 Oct
 2022 07:54:59 -0700
Received: from yaviefel (10.126.231.35) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29; Wed, 26 Oct
 2022 07:54:55 -0700
References: <20221024091333.1048061-1-daniel.machon@microchip.com>
 <20221024091333.1048061-2-daniel.machon@microchip.com>
 <874jvq28l3.fsf@nvidia.com> <Y1kaErnPh5h4otWe@DEN-LT-70577>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Petr Machata <petrm@nvidia.com>
To:     <Daniel.Machon@microchip.com>
CC:     <petrm@nvidia.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <maxime.chevallier@bootlin.com>,
        <thomas.petazzoni@bootlin.com>, <edumazet@google.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [net-next v3 1/6] net: dcb: add new pcp selector to app object
Date:   Wed, 26 Oct 2022 16:51:32 +0200
In-Reply-To: <Y1kaErnPh5h4otWe@DEN-LT-70577>
Message-ID: <87k04mzlc3.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.35]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT011:EE_|DM4PR12MB6301:EE_
X-MS-Office365-Filtering-Correlation-Id: 4b28ed0c-02b9-46dc-a791-08dab76215a9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OTf3nNtc/LktkBSLxo/Da7KJE2LfOc+ZVA85CIvom7BAYh7bVrNINpkahH5QeAL6hBRzwkf+2Wd6zGHEfI2+9wZ0DYM1eupHrSNayUpHXThZQcxVH8/6h5LbXMR4QnSC0uZq3cyZ4JVSRnfkW7BQ8bF8+8+ppZyHkCqP5ic7IzrBD9Wbbpmh4VByQYT827XavWtqMBXEnSzwJALtzgtOLirFf61Hy4tkvPhpvVlCqe3HtGBAdkyFh/A+2/CNttaYvSrTdCXQFkr03J+NqZjTcTuZ1Y9ZLmigkQPtrsfGUdjsTj3vLqaKGlBTPVEHD1dmZlMdvHkTMTW8GpLEVBX7s084csQJ6GBlpxah4Wjhaaz8bO+bdzPSSVp38Yt/Yk2Uie+4vgfV94GYM2ghhxY2eHspPaNicKGOEHEmMQrj8oNfKHAloCO9u2KIL9k77Wsriip0REOGnTBpLQGJCS5j1S7FKf9odNKw9YElQmjfDgcNSuWKoOuni4iKdmcCaS4rgGlS9d8v7jDBKqUNVapKiWbWF+sb57udnEhrUutycgFITFa3OyHWDfjq1RWqbUF5/nDXfr6VzGS0t/v7j4wU2F1sVDImfCb8NWh5xvitOoKffObCEzcLufywQqfdPISRrz696sG/Uf+JlLNOOvcnH8oPUKXuiznbgcSxPAJKOMETxGgVh15jeLO3HSkNWw0PKdoNYYjD1z1c4vfc2m4PhfuL4PE/K7GOtStT2AocPc6gBtA+LdYUj+JBY2CIyQ4uht/pGXUvg4wctXJIRK+jrQ==
X-Forefront-Antispam-Report: CIP:216.228.117.160;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(39860400002)(136003)(451199015)(40470700004)(46966006)(36840700001)(6666004)(186003)(41300700001)(478600001)(7636003)(36860700001)(36756003)(8936002)(8676002)(54906003)(4326008)(40460700003)(356005)(2616005)(6916009)(86362001)(426003)(16526019)(82740400003)(40480700001)(336012)(26005)(316002)(82310400005)(70206006)(83380400001)(47076005)(2906002)(70586007)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2022 14:55:12.2902
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b28ed0c-02b9-46dc-a791-08dab76215a9
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.160];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6301
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


<Daniel.Machon@microchip.com> writes:

>> I'm missing a validation that DCB_APP_SEL_PCP is always sent in
>> DCB_ATTR_DCB_APP encapsulation. Wouldn't the current code permit
>> sending it in the IEEE encap? This should be forbidden.
>
> Right. Current impl. does not check that the non-std selectors received, are
> sent with a DCB_ATTR_DCB_APP type.  We could introduce a new check
> dcbnl_app_attr_selector_validate() that checks combination of type and 
> selector, after the type and nla_len(attr) has been checked, so that:
>
>  validate type -> validate nla_len(attr) -> validate selector

This needs to be validated, otherwise there's no point in having a
dedicated attribute for the non-standard stuff.

>> And vice versa: I'm not sure we want to permit sending the standard
>> attributes in the DCB encap.
>
> dcbnl_app_attr_type_get() in dcbnl_ieee_fill() takes care of this. IEEE are
> always sent in DCB_ATTR_IEEE and non-std are sent in DCB_ATTR_DCB.

By "sending" I meant userspace sending this to the kernel. So bounce
extended opcodes that are wrapped in IEEE and bounce IEEE opcodes
wrapped in DCB as well.
