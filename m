Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A47439EEA6
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 08:23:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhFHGZL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 02:25:11 -0400
Received: from mail-mw2nam12on2045.outbound.protection.outlook.com ([40.107.244.45]:4705
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230289AbhFHGZJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 02:25:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jLBLA8Reh9hEveAhkJdjlFMfNhlJ4bxbAalLANCW6NlQogCd+clbJC2/O7VGp7SHKPphd4A0ywYAU0sJipfw9aGyF4i66+LQBTpzU//Ml9Y/qn3GyDyxOWWtzMDKmpNkorQnD4FxccOhXorzmP3SV9jI40SefNk5Rq7tqNSxYKdXWz8M7D511pzbU5a6NIaXbC0joX22zmErk0f/YYBZKWjFVBZO6XD0CowFAiJ6CSiiRAMFHrf9R0B1UTeGTXt4TgU6kgwYppsgarUdlMnoNDTQMSA9GPqX4TT7dn2J+zryb74g3LqWVYD7Am2JnpDRH0n01gdzUEEM8lZU2452sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rN6egOLREeb92qmNz+XP3TkvZFXZQV/9vo5ukzVu+bQ=;
 b=M4BuMSgdIh+tD1mezFtrXj3Kh7oeO+mrGYmMjIPUw857oVVOT5k6MhswY/0Y8rR9b+ep9cspuXMpKj7WRb61lcc+b5ro9Qpd8Hq6iHD2uZQGs1fIg2Z9wv1sTYuwABtBAGz28XwY/r6I/oishayb1857oN+1uwxQgjmR36TLE+d8F+smdQTLauR9ys0RaCOuaol3RDdeC3jkxxIQ//8Zu6n3YUMHI2PXgIagkBaiK8glS1rEA2K6nVXpIKDkiwVM3zxrUGdOgZrAzd9NIOI7di4F7w2F8DiZDvKTJJZtzaZufbB3daXXvDFbDtt2U60sVpjlvXNRYVShP0Nprt/reA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rN6egOLREeb92qmNz+XP3TkvZFXZQV/9vo5ukzVu+bQ=;
 b=JSZ19edi3uGa5Ydj6uFlWPGWsL4WJQJmlSBh3nMHVmvzs+cB9ixfj8rdzPR9t3nrfN06LEP3JXfjRNRRSYojdgz1Tc1cAP9go97WcLG7zuhpffgoNXRXsxZjOB9tq2ul47IF68Qg3TvTvb6cbh39lZtknK0aF85sZRGtKIojJsNRiU9m+LG995uSb4tO7/aKTMbaxNl7xuVbTy0hbcqsIbVt4YcR9P5Ss2CHcBZCOrK49ouotGbJsp34Pzbm/HUoK3E1v7qCDlkaOlstPMoUGGp6xT7USZOJ0OR0h0dCK+chxPzlZZzFOe10W+L+mZ6b7mJppQHFos1T7HB1TAdQ9A==
Received: from MWHPR14CA0004.namprd14.prod.outlook.com (2603:10b6:300:ae::14)
 by BN8PR12MB3348.namprd12.prod.outlook.com (2603:10b6:408:47::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.24; Tue, 8 Jun
 2021 06:23:15 +0000
Received: from CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
 (2603:10b6:300:ae:cafe::83) by MWHPR14CA0004.outlook.office365.com
 (2603:10b6:300:ae::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.15 via Frontend
 Transport; Tue, 8 Jun 2021 06:23:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 CO1NAM11FT057.mail.protection.outlook.com (10.13.174.205) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4195.22 via Frontend Transport; Tue, 8 Jun 2021 06:23:15 +0000
Received: from localhost (172.20.187.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 8 Jun
 2021 06:23:14 +0000
Date:   Tue, 8 Jun 2021 09:23:11 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
CC:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Petr Machata <petrm@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
Message-ID: <YL8Mz573gNRktQTh@shredder>
References: <20210608085325.61c6056f@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210608085325.61c6056f@canb.auug.org.au>
X-Originating-IP: [172.20.187.6]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1403c89b-a653-43ff-e511-08d92a45e66e
X-MS-TrafficTypeDiagnostic: BN8PR12MB3348:
X-Microsoft-Antispam-PRVS: <BN8PR12MB3348F192523160115B6F3122B2379@BN8PR12MB3348.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:134;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8gTJcLczDcY6EB5cDd0MGUTS15DPk+3vUfARdCAm15CVadf12kg6ykKeNE0abrKWZPKPCNGEY3yi2cgVCKjUBce1wDg3kA+XOqSbll6ccnJgKoW0ik4QT5zI+7+bNWs/pNBiA0erheg23pdYi26xRHyLYcTtn4UqoOazpa3IsBB1FmZ9C8XlO4VUlOvTxJnKEKT3KVo4A58hKA/kwkjMftDgNSJozItuPO6CXbdtoOWDNVVqToIgo1jnzCFM2JMH2EzdtqrsWSziVS8+OMaMagl5zjQpEncsNCjnCO2LEtahND52H565/hUip30AqErExTKwytn50tJRsx3Vt5luv3bx7vMr1N9W6WcRAbRrO7o4vHQzrijNwL3t1dHBPWT8wG0jtTUk9A1g3eCMH841B7axrP4Oc552fHdwQYdXB5r+blxENT9GuNvLpYJq3pIXxQjZylx1WwMn+GEyr5Gvas1kDDRXaPPyTX/pQGvxR2W88nlRMaXcEeV6zEXfP/vyJ5BZs5YMWtrrBaLZxreiEAYwanNjJcvtN18SGe6ojd9jvtcR/HOp441SXJnfwhYhqsDmS2IvogpjEHPRADJ5vufXcJSqa6OxTyTE+J2T5WhPb6VxOHEE9kdIT3hElscT3UzwGvLU9bbtXWOtdDc5ww==
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(7916004)(4636009)(376002)(396003)(346002)(39860400002)(136003)(36840700001)(46966006)(70206006)(6666004)(86362001)(82310400003)(33716001)(36906005)(70586007)(316002)(6916009)(82740400003)(47076005)(426003)(54906003)(356005)(5660300002)(336012)(26005)(16526019)(8676002)(4326008)(7636003)(2906002)(8936002)(36860700001)(186003)(478600001)(9686003)(4744005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2021 06:23:15.5773
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1403c89b-a653-43ff-e511-08d92a45e66e
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT057.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3348
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 08:53:25AM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> In commit
> 
>   d566ed04e42b ("mlxsw: spectrum_qdisc: Pass handle, not band number to find_class()")
> 
> Fixes tag
> 
>   Fixes: 28052e618b04 ("mlxsw: spectrum_qdisc: Track children per qdisc")
> 
> has these problem(s):
> 
>   - Target SHA1 does not exist
> 
> Maybe you meant
> 
> Fixes: 51d52ed95550 ("mlxsw: spectrum_qdisc: Track children per qdisc")

Yes, correct. Sorry about that. The first was an internal tag. Will
double-check next time.
