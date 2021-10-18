Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B32E44315C7
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 12:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbhJRKUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 06:20:21 -0400
Received: from mail-eopbgr140100.outbound.protection.outlook.com ([40.107.14.100]:24964
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229770AbhJRKUU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Oct 2021 06:20:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZrn3dhj9IIy3elMV8Daz3kawx6iHZy/VZHfy8fu77mOr+B3rPdm8eYRD3LfKFkb3vdZ+3Nap1iDs6bFi9OsTcH7yYQf9qGcRAh9dyQ/eZ/kwFo8K24cakgcWChOAEHHMZEQdTbM2fKljbkpdPneOtY7U9x7IbSln3edvJCvKDSHxeCH7Olr+CCDcpLP3a3+HnzuejM7E45gR+HeOWUE4YJdk3Qls0Tsmu7np87v6j5ln2gtG9RGmIBJqlSuDmY1y6K+M1NjFfXZjJcMoPvcbul+WgYmd7q7h8kkL56aOfePzDn5Vb4tcxOoNz2tYDbdA3uWFao+Ven9IS26I4eN7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zwGjX1gBIsUK3HL5CcHVHelnl1DsSfCy6KqU9moy5M8=;
 b=Pdpj0n0G7cYz54SquolbfpBnvlheIls1idHd8eN112jx4WTgAtfdcyqIJadIxX98ch2fNzj68d/AdSIh0CAyxAXY1aABvUsPvHSXTSguPunEAn704oX0xrnbdefynzc1vjD1dEPdKij4+3pqSO3oVpd7iRX+luTs/qXkOULgMdg7NjchmZf5UY7Nt/Pm93X/FZeG2mjfxVVhd+XhojaePf43EG2/lCBRqO7z+UvlEb08ZW8IysKkMd+GzkxoDt0jt7GCZhey+Z3Auv1k9ke2uaWv8I4DB/2K72902bNyM34E99wmNFCh9ZSH1IRHi9Ka9qNFenjg+6mkPBlBOuX+Xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zwGjX1gBIsUK3HL5CcHVHelnl1DsSfCy6KqU9moy5M8=;
 b=ONPwyVlTz4FBoaJYtqdTu5SK4d+48ja8UCehWUbXDYnrct+YRQgji4An4CprE/Or2nRDV8kgFHwdPUWhoT/moqhFqZjxY8Y5SLkQ/6NZcRfG+9V1hLVZRP+eOtjfrLjNw6M41Z/kjAldkUDTtIV0iAq9bwAuocK3crSoE9ldcnE=
Authentication-Results: agner.ch; dkim=none (message not signed)
 header.d=none;agner.ch; dmarc=none action=none header.from=toradex.com;
Received: from DBAPR05MB7445.eurprd05.prod.outlook.com (2603:10a6:10:1a0::8)
 by DBAPR05MB6934.eurprd05.prod.outlook.com (2603:10a6:10:18a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18; Mon, 18 Oct
 2021 10:18:06 +0000
Received: from DBAPR05MB7445.eurprd05.prod.outlook.com
 ([fe80::98f8:53ac:8110:c783]) by DBAPR05MB7445.eurprd05.prod.outlook.com
 ([fe80::98f8:53ac:8110:c783%3]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 10:18:06 +0000
Date:   Mon, 18 Oct 2021 12:18:02 +0200
From:   Francesco Dolcini <francesco.dolcini@toradex.com>
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Francesco Dolcini <francesco.dolcini@toradex.com>,
        f.fainelli@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Agner <stefan@agner.ch>,
        Marcel Ziswiler <marcel.ziswiler@toradex.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] phy: micrel: ksz8041nl: do not use power down
 mode
Message-ID: <20211018101802.GA7669@francesco-nb.int.toradex.com>
References: <20211018094256.70096-1-francesco.dolcini@toradex.com>
 <180289ac-4480-1e4c-d679-df4f0478ec65@csgroup.eu>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <180289ac-4480-1e4c-d679-df4f0478ec65@csgroup.eu>
X-ClientProxiedBy: GV0P278CA0074.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:2b::7) To DBAPR05MB7445.eurprd05.prod.outlook.com
 (2603:10a6:10:1a0::8)
MIME-Version: 1.0
Received: from francesco-nb.toradex.int (93.49.2.63) by GV0P278CA0074.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:2b::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.18 via Frontend Transport; Mon, 18 Oct 2021 10:18:06 +0000
Received: by francesco-nb.toradex.int (Postfix, from userid 1000)       id 14A9010A08AC; Mon, 18 Oct 2021 12:18:02 +0200 (CEST)
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 04a1be7e-40fa-40a0-8f58-08d9922093b2
X-MS-TrafficTypeDiagnostic: DBAPR05MB6934:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR05MB6934237D28665C30319AEEA6E2BC9@DBAPR05MB6934.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2089;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXq3WiB4e+uMNSLFXitZNzVfIiQ5GoGCaLhyqjIUTJxpq3EKynPFPEsmEfyNHVi5io4KwoJO9feCL/48LGZ7pdTTZZy+hrYSv0bUiKz2SbRFi2WyIjzxJuRZgt+OjIsw7vviP0VrfziB2BTTM9WVgakgTtLj0pJrBHW1tcut0zMYy2kXQwfpdTJcx+Gqa8Gmy/Y00/sDLYmpLxc8NhYPZGd2eQmEjag4blP3LHi9DBi4u0VywajAOmMJroCRRkJFV7yroCd6Qnw1iupy8FMCZV+JsaBytDV7wYAbRFbRQJLW7ng7GjvhG8BSveqyyreEBGw2iE/KdHfGCVLXP3yU9OTkvQAatK79S2a5Kd75CJ/JwvlTGtX+eQZ9r2odW/LS/yCwgcE2riKDHDTH6bq4uX4u/K1Jiw9Sd3N6hcby9MN+hR2TAfAS4Ho7A/3cJk2U3p5snFNAHfXVij1C6OGnfQzY3KgXYj+YateUVe9pwrNJbkd7QNKgQFVTHSqbFW/Xye9FM4Y5VYZviLXcxNFm+aTX0/K+nfmoBHewMZFzzxte0qQYU3sL1IjedK+/u2tWiKCo/M5N8UwWu+pLiR9KsQdhJh/0WwgM3AiUmXNLiGJgC30YrFx/cUfz5OkxmB6s6QYkEKSckSrubP+09Q0ujd+DM28CdmgaUzJuu03jXP5Qc9HQ452pXNF68fcQyfxE3wz/GX/98g+Fp75ppcAp7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR05MB7445.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39850400004)(2906002)(44832011)(42186006)(316002)(66476007)(86362001)(83380400001)(52116002)(38100700002)(38350700002)(4326008)(66556008)(66574015)(66946007)(7416002)(5660300002)(6916009)(8676002)(26005)(1076003)(33656002)(6266002)(54906003)(186003)(8936002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?xvD9pguc+brTVUxAjSiTmKWxgNgyAhM4CkRwBhSGYo7qR3fgseRGtObkEr?=
 =?iso-8859-1?Q?EwyGaqlK9cuvpLeLy6QZzsQ6/EuUjwjfBnQPx6IGdm7s5qa6qcItaAukM3?=
 =?iso-8859-1?Q?RrpIIABe4AsbXiq2wqoVJS0/4o//gPsCqvn85Xctt/QID/KFNFTndbX4Ko?=
 =?iso-8859-1?Q?Fl/Ckrb+2Ev9H+OuLGKypbpgcIItkPt/+3ki8NkTAGFGyO35/GgXI+ZFAV?=
 =?iso-8859-1?Q?JofE8uWtyZ4dHOKCC6NwOQ42OtndBXV+sWOHqOa/nYZUdNG34cXr8Y/NEB?=
 =?iso-8859-1?Q?+282KE6fnn8e2Vl9d2el3zC0xtcJcdl6MMYqeV8DJaQrD6XhR2SEybvlOV?=
 =?iso-8859-1?Q?0vhJAks+ot2TAa8IVu0WmZ/7cQUWJGFAg+2BscyIMrSg9hbau9o4B0ccyD?=
 =?iso-8859-1?Q?qPwBkDSZkPWIhZJEvokeb6GrVswmymXXodSLu4yoIyNCHweEg8qhMr3ya4?=
 =?iso-8859-1?Q?ESaMyEjar2/ilSUE/ejoZ6ssgE6gpy5CRURn1VZ5CRsMjA+QkVouAfHJ3N?=
 =?iso-8859-1?Q?AbkirRffzKHwkJEfUU3ksZCoLAjbZxVniwpSMcWd4EBREYnfoc9deh7nlW?=
 =?iso-8859-1?Q?brBKNq0WcNODN7JrQswuOvXNlCy5muyd2D+E1roY6B69ii91+Va3y5/YWj?=
 =?iso-8859-1?Q?xL+2nermkWxbOdAbM4gd4tn3z9deBKEmGaimm9Vxs7UG8Z7+oSzwR1bYkp?=
 =?iso-8859-1?Q?7XxCvL8ejyohY7DI1A8yxPef9KsmhGmQ/L2Vh+0jEeZyNRmS29wZUagT/g?=
 =?iso-8859-1?Q?AIp0ofcZ/Jx9lHFigTalSnbGn1taaRBn8pSCzKIUtieBM1nQ+6pnjDRihs?=
 =?iso-8859-1?Q?yxu7354+VTnu3CtY+W1VjYfLxiKTSiEsv5PCRIC8QqL8RIjMyTcsoEBDaB?=
 =?iso-8859-1?Q?+NzTW6InZRChfE5Jber2xoxVUmEV6weXVw2xTGxNIEaZ4cGROkAGKFXl/v?=
 =?iso-8859-1?Q?mVM7/0thPwXONoBqdoyCMfL4Te0vI4z9QwGXzz0yc6ff7gdc6zQhtykuOf?=
 =?iso-8859-1?Q?wBvW7m94JTv9w9lIsdLiSGyp5iLyonQ//0WKVIh+ST5U+wyk3fFPuaNzTs?=
 =?iso-8859-1?Q?Py/Yk2thaHOuLFj9Hxo67YJIHSIj/CsduKJ7uK7/2ffSd2pin73Qc/EWFa?=
 =?iso-8859-1?Q?DLP0oPRQGVe5/qcyAWrU7eT0MtTJmH2AIaljQoJVWFE5rGXV/WE0qnjc3L?=
 =?iso-8859-1?Q?uwdBL5xB6EJtMnoDXjiE7Gm2p+5Vm1XoNZHwEZifeYbIzLctKMam+ja+px?=
 =?iso-8859-1?Q?iTJyNNyyPbGZ/7X75yFj3NeO7PXTksmp/WtxxloaGcfqeZ+Gydhfyi+E3b?=
 =?iso-8859-1?Q?wxT/ZYyyG39J2mWlX6NaAxUdFWCJAqxoMeFGXLaHU0Bf+CP0Sax+8cLmeI?=
 =?iso-8859-1?Q?BaWYdk9DPq?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04a1be7e-40fa-40a0-8f58-08d9922093b2
X-MS-Exchange-CrossTenant-AuthSource: DBAPR05MB7445.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 10:18:06.4844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ey0UXfQhS9Ozr1V+HBYIMMEe1odR6LsQfzut7he5xlv/htUVZPDPqRpFAoimD5IBaDJf4cllOJto30iIqo9VqE8Byj3asfTh8sw/Lt3ydHs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR05MB6934
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Christophe,

On Mon, Oct 18, 2021 at 11:53:03AM +0200, Christophe Leroy wrote:
> 
> 
> Le 18/10/2021 à 11:42, Francesco Dolcini a écrit :
> > From: Stefan Agner <stefan@agner.ch>
> > 
> > Some Micrel KSZ8041NL PHY chips exhibit continous RX errors after using
> > the power down mode bit (0.11). If the PHY is taken out of power down
> > mode in a certain temperature range, the PHY enters a weird state which
> > leads to continously reporting RX errors. In that state, the MAC is not
> > able to receive or send any Ethernet frames and the activity LED is
> > constantly blinking. Since Linux is using the suspend callback when the
> > interface is taken down, ending up in that state can easily happen
> > during a normal startup.
> > 
> > Micrel confirmed the issue in errata DS80000700A [*], caused by abnormal
> > clock recovery when using power down mode. Even the latest revision (A4,
> > Revision ID 0x1513) seems to suffer that problem, and according to the
> > errata is not going to be fixed.
> > 
> > Remove the suspend/resume callback to avoid using the power down mode
> > completely.
> 
> As far as I can see in the ERRATA, KSZ8041 RNLI also has the bug.
> Shoudn't you also remove the suspend/resume on that one (which follows in
> ksphy_driver[])

Yes, I could, however this patch is coming out of a real issue we had with
KSZ8041NL with this specific phy id (and we have such a patch in our linux
branch since years).

On the other hand the entry for KSZ8041RNLI in the driver is somehow weird,
since the phy id according to the original commit does not even exists on
the datasheet. Would you be confident applying such errata for that phyid
without having a way of testing it?

Francesco

