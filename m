Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A923FCEE6
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 22:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241395AbhHaU7m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 16:59:42 -0400
Received: from mail-bn8nam08on2135.outbound.protection.outlook.com ([40.107.100.135]:33025
        "EHLO NAM04-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241370AbhHaU7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 16:59:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yov2N0vyYIMgubg8wJ1MWmIYrvCV2eAelrgwQRH5Ltla6l9Sob90w4s2C9mDAA4Gsi49S0XyiT8uYKgUpwwOvbVtZiOJSG24LMy+/vsfkla24tlaTST4IDRf9au7/R13tNKDHP2TYDH8iRJ2P5AUKHeQhwqWjP1anViN3+GSFrTmPECv1zRXJ0f0cEkQrR7vJDOmuonh8AIfIEgzhXrCCwV7Pe5zlyw1NRlI0H6BTSX7HD0CI223C5/zYGDcD+sW1NNDHG/BgTm6yP3Nb8wkmPN3bZlz37dvi9uPu+xOZlt+6qzoaZRmpwXUzYrKPoDiVt/le04CFTxoDPDM8w5UdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xekWPhIU+ICC+wyj0yHwxZYORRtoVe9CV5CjxrPto9w=;
 b=gCTkKFvfN6FXvi4iQegfl/ul+y1BEpE55PwIWby1uFiIjCPGfU2yKkylB9PhkJFfYcacHM73oykOOi/esnNjYPjm+38PNx5Z95nUpZ30ArYvPvqqmX0lKfmVteiw2b24JjAk+xpqr1oFG1cHrUaEJNr8r9COpuoZte7XykSlnnwpMN3LOuURFNV8XpXRuretsh2SxakGPd2sz8qVpanmOZW66VNO2qyNOCCKTAWInnM0Wm4wK2vWTosUqEsBUiY554DOJfuw23NGqwTm4puVQyHvG5/Z6ehMbSsXsQddQtZk/I87+9F738asmlVxvkbcVoDFI87KYXw2bZrx7cz7TA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 208.78.214.5) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=chidv-pwl1.w2k.jumptrading.com; dmarc=fail (p=reject sp=reject
 pct=100) action=oreject header.from=jumptrading.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jumptrading.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xekWPhIU+ICC+wyj0yHwxZYORRtoVe9CV5CjxrPto9w=;
 b=F2Y0G2EEtzzia318YjcXuP2IYtq9BAuK/5r+kijNs9qF7BuIRr/SGfrxvJq4wHoJroLZvIGywuFPzFYU9zcb0sea1CCnB9mvfXFUkqqT1Rwb+FAjAnDDgr5X8EluBVuic9F2PYOMpBQkm0XtRR/1u1stPZWr6bwwqYQsa3Zyxmk=
Received: from BN0PR04CA0074.namprd04.prod.outlook.com (2603:10b6:408:ea::19)
 by MWHPR14MB1293.namprd14.prod.outlook.com (2603:10b6:300:8a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.19; Tue, 31 Aug
 2021 20:58:36 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ea:cafe::4e) by BN0PR04CA0074.outlook.office365.com
 (2603:10b6:408:ea::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.20 via Frontend
 Transport; Tue, 31 Aug 2021 20:58:35 +0000
X-MS-Exchange-Authentication-Results: spf=none (sender IP is 208.78.214.5)
 smtp.mailfrom=chidv-pwl1.w2k.jumptrading.com; vger.kernel.org; dkim=none
 (message not signed) header.d=none;vger.kernel.org; dmarc=fail action=oreject
 header.from=jumptrading.com;
Received-SPF: None (protection.outlook.com: chidv-pwl1.w2k.jumptrading.com
 does not designate permitted sender hosts)
Received: from mail.jumptrading.com (208.78.214.5) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4478.19 via Frontend Transport; Tue, 31 Aug 2021 20:58:34 +0000
Received: from njwf-exnw1.w2k.jumptrading.com (7.9.212.134) by
 njwf-exvnw1.w2k.jumptrading.com (7.9.212.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.14; Tue, 31 Aug 2021 16:58:31 -0400
Received: from njwf-esa1.w2k.jumptrading.com (7.9.212.139) by
 njwf-exnw1.w2k.jumptrading.com (7.9.212.134) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15
 via Frontend Transport; Tue, 31 Aug 2021 16:58:31 -0400
X-Internal-Message: True
Received: from chidv-pwl1.w2k.jumptrading.com ([7.2.64.201])
  by njwf-esa1.w2k.jumptrading.com with ESMTP; 31 Aug 2021 20:58:31 +0000
Received: by chidv-pwl1.w2k.jumptrading.com (Postfix, from userid 44223)
        id 79544600D2; Tue, 31 Aug 2021 15:58:31 -0500 (CDT)
Date:   Tue, 31 Aug 2021 15:58:31 -0500
From:   PJ Waskiewicz <pwaskiewicz@jumptrading.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "pjwaskiewicz@gmail.com" <pjwaskiewicz@gmail.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Dziedziuch, SylwesterX" <sylwesterx.dziedziuch@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        PJ Waskiewicz <pwaskiewicz@jumptrading.com>
Subject: Re: [PATCH 1/1] i40e: Avoid double IRQ free on error path in probe()
Message-ID: <20210831205831.GA115243@chidv-pwl1.w2k.jumptrading.com>
References: <20210826221916.127243-1-pwaskiewicz@jumptrading.com>
 <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <50c21a769633c8efa07f49fc8b20fdfb544cf3c5.camel@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: quoted-printable
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d92648b-1394-4138-af25-08d96cc218b4
X-MS-TrafficTypeDiagnostic: MWHPR14MB1293:
X-Microsoft-Antispam-PRVS: <MWHPR14MB129376B4097C6317BD7D1A8A88CC9@MWHPR14MB1293.namprd14.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k34jcnjYDobghKXiFMAPzJWUezLSFDBp2mIibcvTLihIqpTNrcL/8SM/NUPugCUCLb06l9R2s9m4AgKeJ3+jVsYA2DEXQPPvJYWdsWbFaVrwlCcjLdcoBvhspbYzLTfoZ2z7t8nVm35PPpVIHnEeepLFZUEKxxDXjeAlDglErbLmpyZk64g9mTB4vzUeCGQy/6s1EhIvCjQdBdE9AjN+G7rUwpSxdMmrEC+42Bv3FsUmrUCuA+L6ghONXT+scY5f2djM0ytv8XEMxKkO63OpkAI2eRWPLcQUhpfp2zuYRBeQ4BtpkGeJLpo390YZlWDuNXN6N9QRtKMKfPl8EofCuLicGk5Z93OCgHQD/MOrfOwVk+7Tx86qMNaNT3wr0AsUhy9z4pNkWv2FGNepuKH9o1efRQTClIWAcgmuiDCb/Llw4gK55EkQSuq+iZgR6+n5VeLPJrz4V/yon+hWB64cY/ZSxJ7oNMoXRIKODC+ao0kwkfS9R3YzMYmw2sNlNgdmOFgknTZs24zrUEML6Y2KJmdIhQ/6tMghYIwjQaY/zvaqyZfaNnoIiyi2Nrhv0KyXhE0ZcH8cya0ntmRSKpQJwjze+AAlgNZuTIu8Bi1UFY5ar5AltIE4yVC7PewT5yTq/l9aIxnHhvvM75HnKxEW79f/TpvOcn4UBLXc0QFNlVE=
X-Forefront-Antispam-Report: CIP:208.78.214.5;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.jumptrading.com;PTR:ErrorRetry;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(396003)(346002)(46966006)(1076003)(6862004)(83170400001)(356005)(35950700001)(107886003)(8676002)(336012)(81166007)(4326008)(26005)(70586007)(8936002)(82740400003)(33656002)(70206006)(82310400003)(83380400001)(2906002)(6266002)(498600001)(5660300002)(47076005)(426003)(54906003)(42186006)(316002);DIR:OUT;SFP:1102;
X-OriginatorOrg: jumptrading.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2021 20:58:34.3266
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d92648b-1394-4138-af25-08d96cc218b4
X-MS-Exchange-CrossTenant-Id: 11f2af73-8873-4240-85a3-063ce66fc61c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=11f2af73-8873-4240-85a3-063ce66fc61c;Ip=[208.78.214.5];Helo=[mail.jumptrading.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR14MB1293
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 08:52:41PM +0000, Nguyen, Anthony L wrote:
> On Thu, 2021-08-26 at 17:19 -0500, PJ Waskiewicz wrote:
> > This fixes an error path condition when probe() fails due to the
> > default VSI not being available or online yet in the firmware. If
> > that happens, the previous teardown path would clear the interrupt
> > scheme, which also freed the IRQs with the OS. Then the error path
> > for the switch setup (pre-VSI) would attempt to free the OS IRQs
> > as well.
>
> Hi PJ,

Hi Tony,

>
> These comments are from the i40e team.
>
> Yes in case we fail and go to err_vsis label in i40e_probe() we will
> call i40e_reset_interrupt_capability twice but this is not a problem.
> This is because pci_disable_msi/pci_disable_msix will be called only if
> appropriate flags are set on PF and if this function is called ones it
> will clear those flags. So even if we call
> i40e_reset_interrupt_capability twice we will not disable msi vectors
> twice.
>
> The issue here is different however. It is failing in free_irq because
> we are trying to free already free vector. This is because setup of
> misc irq vectors in i40e_probe is done after i40e_setup_pf_switch. If
> i40e_setup_pf_switch fails then we will jump to err_vsis and call
> i40e_clear_interrupt_scheme which will try to free those misc irq
> vectors which were not yet allocated. We should have the proper fix for
> this ready soon.

Yes, I'm aware of what's happening here and why it's failing. Sadly, I am
pretty sure I wrote this code back in like 2011 or 2012, and being an error
path, it hasn't really been tested.

I don't really care how this gets fixed to be honest. We hit this in
production when our LOM, for whatever reason, failed to initialize the
internal switch on host boot. We escalated to our distro vendor, they
did escalate to Intel, and it wasn't really prioritized. So I sent
a patch that does fix the issue.

If the team wants to respin this somehow, go ahead. But this does fix
the immediate issue that when bailing out in probe() due to the main VSI
not being online for whatever reason, the driver blindly attempts to clean
up the misc MSI-X vector twice. This change fixes that behavior. I'd like
this to not languish waiting for a different fix, since I'd like to point o=
ur
distro vendor to this (or another) patch to cherry-pick, so we can get this
into production. Otherwise our platform rollout hitting this problem is
going to be quite bumpy, which is very much not ideal.

Cheers,
-PJ

________________________________

Note: This email is for the confidential use of the named addressee(s) only=
 and may contain proprietary, confidential, or privileged information and/o=
r personal data. If you are not the intended recipient, you are hereby noti=
fied that any review, dissemination, or copying of this email is strictly p=
rohibited, and requested to notify the sender immediately and destroy this =
email and any attachments. Email transmission cannot be guaranteed to be se=
cure or error-free. The Company, therefore, does not make any guarantees as=
 to the completeness or accuracy of this email or any attachments. This ema=
il is for informational purposes only and does not constitute a recommendat=
ion, offer, request, or solicitation of any kind to buy, sell, subscribe, r=
edeem, or perform any type of transaction of a financial product. Personal =
data, as defined by applicable data protection and privacy laws, contained =
in this email may be processed by the Company, and any of its affiliated or=
 related companies, for legal, compliance, and/or business-related purposes=
. You may have rights regarding your personal data; for information on exer=
cising these rights or the Company=E2=80=99s treatment of personal data, pl=
ease email datarequests@jumptrading.com.
