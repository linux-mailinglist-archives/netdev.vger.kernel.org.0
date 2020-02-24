Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD5C16A22F
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 10:26:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgBXJ0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 04:26:48 -0500
Received: from mail-vi1eur05on2073.outbound.protection.outlook.com ([40.107.21.73]:16580
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727240AbgBXJ0r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 04:26:47 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eLhB7iH5YDJQd/UPqkLrfmxKIxhuOEeRo6o8Gcea5ND0iEi6k7xi2hbTiBGcZD6y9L8ZIeZ7GxgbKqzuCARa7/dxorkh2FV0tXrKJ8Ra3ueH2QOrhQR2BVB9ND61nTS6hiqe52Hw857jN0gmuASJvbtl52mlJGUcpB2VhpnKZ3Dqw7UEFFnx46aiueqYaDFc9MbpOdSY7X8GibnhUFK14SWvLTiaNrgW0TRlPxoyU6EH2PvLqam6QUHSR+kw1fqJbcKG+OWGwxp35cemaWPZDxuu4U7JyGfSybZXsBGdp7BbXCLhaHHQ+/HKYILfLsUnsj5/tYpZ96zDQo9S5zqmXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmGwAKElI2u+A0z/EETBIou5ic5kIe13D9NL0wb7U2M=;
 b=CGZrT9/zeWLslICwnV47CvnyCi4tEwQUvjqq4frvluTbtOh5IsXbUWZuRHjfuSArjnFQ7V8qGqVtI2g+xSErDkkqpOSMvLUpueUfM/Y9a9cvMUxhhRbsXuIIRghZMWr0aoiTyBh0F+ZkCM8+Y3hBx6wkGKIKjlk/4z7TKSRnyf7C+/w9hY+f31izRZKM57PBovCQDJhle01mAgeJWMacphqeZc477gRYs6vLNoJsWtMM5xovPP/PM0OZc9LqnyZrXo8PTjlcKfMmfh2jHrdSdSA+MTMjrhYqLuJajloIZjDMLL7d3s9hytgzdiyLTjnyRxL1AizGgpggJZlBlsKWag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 188.184.36.50) smtp.rcpttodomain=kernel.org smtp.mailfrom=cern.ch;
 dmarc=bestguesspass action=none header.from=cern.ch; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cern.onmicrosoft.com;
 s=selector2-cern-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tmGwAKElI2u+A0z/EETBIou5ic5kIe13D9NL0wb7U2M=;
 b=treHLM/wuTE3F8KbK3ygj/ORGGmbE9HBEQqYgWyAmRwvSPW5jnP+JZ60wkplYx3/8FOYO8MRW3svCyvPlLsPYQKPlKNIaLUHO55uV6xCD9MQs9BFPL7WD+jRjhSKWoD25d/Kj3n/1EbzSGqtTHjsNsdj0qDL4wKrkQGEOj305CA=
Received: from AM0PR06CA0026.eurprd06.prod.outlook.com (2603:10a6:208:ab::39)
 by HE1PR0601MB2617.eurprd06.prod.outlook.com (2603:10a6:3:4c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.22; Mon, 24 Feb
 2020 09:26:42 +0000
Received: from VE1EUR02FT030.eop-EUR02.prod.protection.outlook.com
 (2a01:111:f400:7e06::205) by AM0PR06CA0026.outlook.office365.com
 (2603:10a6:208:ab::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend
 Transport; Mon, 24 Feb 2020 09:26:42 +0000
Authentication-Results: spf=pass (sender IP is 188.184.36.50)
 smtp.mailfrom=cern.ch; kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=bestguesspass action=none
 header.from=cern.ch;
Received-SPF: Pass (protection.outlook.com: domain of cern.ch designates
 188.184.36.50 as permitted sender) receiver=protection.outlook.com;
 client-ip=188.184.36.50; helo=cernmxgwlb4.cern.ch;
Received: from cernmxgwlb4.cern.ch (188.184.36.50) by
 VE1EUR02FT030.mail.protection.outlook.com (10.152.12.127) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.2750.18 via Frontend Transport; Mon, 24 Feb 2020 09:26:41 +0000
Received: from cernfe04.cern.ch (188.184.36.41) by cernmxgwlb4.cern.ch
 (188.184.36.50) with Microsoft SMTP Server (TLS) id 14.3.487.0; Mon, 24 Feb
 2020 10:26:40 +0100
Received: from pcbe13614.localnet (2001:1458:202:121::100:40) by smtp.cern.ch
 (2001:1458:201:66::100:14) with Microsoft SMTP Server (TLS) id 14.3.487.0;
 Mon, 24 Feb 2020 10:26:38 +0100
From:   Federico Vaga <federico.vaga@cern.ch>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Reply-To: <federico.vaga@cern.ch>
CC:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, <linux-arch@vger.kernel.org>,
        <kvm@vger.kernel.org>, <kvm-ppc@vger.kernel.org>,
        <linuxppc-dev@lists.ozlabs.org>, <dri-devel@lists.freedesktop.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <linux-unionfs@vger.kernel.org>, <linux-mm@kvack.org>,
        <linux-rdma@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kvmarm@lists.cs.columbia.edu>
Subject: Re: [PATCH 3/7] docs: fix broken references to text files
Date:   Mon, 24 Feb 2020 10:26:39 +0100
Message-ID: <3929512.qvrp2sLpzG@pcbe13614>
In-Reply-To: <5cfeed6df208b74913312a1c97235ee615180f91.1582361737.git.mchehab+huawei@kernel.org>
References: <cover.1582361737.git.mchehab+huawei@kernel.org> <5cfeed6df208b74913312a1c97235ee615180f91.1582361737.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [2001:1458:202:121::100:40]
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:188.184.36.50;IPV:;CTRY:CH;EFV:NLI;SFV:NSPM;SFS:(10009020)(376002)(39860400002)(136003)(346002)(396003)(199004)(189003)(186003)(9686003)(16526019)(33716001)(26005)(2906002)(478600001)(9576002)(426003)(8676002)(44832011)(3450700001)(336012)(246002)(53546011)(8936002)(7416002)(4326008)(86362001)(7636002)(356004)(70206006)(316002)(54906003)(70586007)(5660300002)(39026012);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR0601MB2617;H:cernmxgwlb4.cern.ch;FPR:;SPF:Pass;LANG:en;PTR:cernmx11.cern.ch;A:1;MX:1;
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07a24c03-738e-4624-7506-08d7b90ba88c
X-MS-TrafficTypeDiagnostic: HE1PR0601MB2617:
X-Microsoft-Antispam-PRVS: <HE1PR0601MB2617DD6A6BADE420AB7F4408EFEC0@HE1PR0601MB2617.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2803;
X-Forefront-PRVS: 032334F434
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0qIX6XFVupoujn6tnMIXACZrhD5q3UXodzvYwqyh0hsK1Lsu+/pJ+LkIjl/NeexA/acueRAQl6tWpe3CFd900UWE/3Dp2zl9mkWVMfYl1qYpVkPmqLAGWnMEDEKi64JQPs3cOzEfTL3WjHbAxZ5gqNC3mLax0dvKusUdgcmqXKLya466pUHPmvk05PkmAw4VpLa35W1pVnc1avg4zQD+W+XccjzAi6cB/jeg95xVwyZEdY7wigcHbjHbZjeUw5bGbym667i307aOvjm5Vli7k+a11ZX1tZ2pjiiBWvLEYzJaJJQ2pSEH9ApQf6ZUYQ5f7TlyJmnEtMyipzP+fXgRIINxHtYghfwKLsQ7Fb2NPkqtE2mY/QN0LGNAE519BJMKJ2V6htEDDIZVXfSjSq9NkQg4un3jbv63EjF6kc6RkQ3fn2TRPhmkbiqtoHaEDIQdUEz7oStS5w1dmTB8Bw7vHuPaRBQq1lv0uJabtpvDjKCWQdNtDjiBIr3Z5wRpVLzv
X-OriginatorOrg: cern.ch
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Feb 2020 09:26:41.7248
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 07a24c03-738e-4624-7506-08d7b90ba88c
X-MS-Exchange-CrossTenant-Id: c80d3499-4a40-4a8c-986e-abce017d6b19
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=c80d3499-4a40-4a8c-986e-abce017d6b19;Ip=[188.184.36.50];Helo=[cernmxgwlb4.cern.ch]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0601MB2617
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Saturday, February 22, 2020 10:00:03 AM CET Mauro Carvalho Chehab wrote:
> Several references got broken due to txt to ReST conversion.
>=20
> Several of them can be automatically fixed with:
>=20
> 	scripts/documentation-file-ref-check --fix
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---


>  26) If any ioctl's are added by the patch, then also update
> -    ``Documentation/ioctl/ioctl-number.rst``.
> +    ``Documentation/userspace-api/ioctl/ioctl-number.rst``.
>=20
>  27) If your modified source code depends on or uses any of the kernel
>      APIs or features that are related to the following ``Kconfig`` symbo=
ls,
> diff --git a/Documentation/translations/it_IT/process/submit-checklist.rst
> b/Documentation/translations/it_IT/process/submit-checklist.rst index
> 995ee69fab11..3e575502690f 100644
> --- a/Documentation/translations/it_IT/process/submit-checklist.rst
> +++ b/Documentation/translations/it_IT/process/submit-checklist.rst
> @@ -117,7 +117,7 @@ sottomissione delle patch, in particolare
>      sorgenti che ne spieghi la logica: cosa fanno e perch=E9.
>=20
>  25) Se la patch aggiunge nuove chiamate ioctl, allora aggiornate
> -    ``Documentation/ioctl/ioctl-number.rst``.
> +    ``Documentation/userspace-api/ioctl/ioctl-number.rst``.


Acked-By: Federico Vaga <federico.vaga@vaga.pv.it>



