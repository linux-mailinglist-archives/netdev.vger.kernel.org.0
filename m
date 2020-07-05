Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00E65214ADD
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 09:19:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbgGEHTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 03:19:18 -0400
Received: from mail-eopbgr40082.outbound.protection.outlook.com ([40.107.4.82]:62101
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726270AbgGEHTR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 5 Jul 2020 03:19:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DgG/D7qAXlpcM7OXlVzqUhMnQnqhrbfiE7p0DcMn41qzVlgZHCHDPQQ2r3p3TcaMPkhfT9gYvr5I56HLjbF72QKtnWIEDy7WypHC3+zS/qj5CT4jZVKVvHQC703LphF6DtgktfXAnlZXTFbFqFGrXUq1U6BIWKRsayWHbaqmuZi7/V3b2ODBRbWo2IcFhqW6CLAz+ecZ+6VQW3aVP2Z/itHJ/FOKmZ8h68ZWoKgvE6p2a6bt0cIrpj/8K/sA3TjdzbO2XQSxx02gzTbNQlYnN+iwb6xCmHJrN4lKZ22ktPfPVcwBXrs/HGrVPO67ZB+XM3qnuea2cGCDw9JGhs6xdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYMQH9DZQ3kbrHf2Zn02r+p9IFiGgzrNzmS4T40UF3I=;
 b=mesX2fD7Zcnjt2cVXLSIPgFhTwLiiTdYgz0S9c8IHFBAawcXaIVdV6iyJ8vNosYr4+9XcUTF9jpxT96eN0NdYiXmI2brvaNwvybVg71XBBKcucnav2jRd4jCxKKunjNU+LXkVBdbWT73px8+omXnJaG8x6zpzttKBpTS3yyhCisdDF6k6m/67dFZnievu4jtBHF+b4ChISufkFgeGFptClT1mZM6uoUVfyUeoighG3YI3Gkmo1WUvXHAFal7AN0ptt4/EUg3x9NimRwKNRwuKUTVi/GroZQQ9z2K67kyGKym9TFycHSjc0tIbBIkALc+0jvYgOFB7y3Im5LWMrblZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NYMQH9DZQ3kbrHf2Zn02r+p9IFiGgzrNzmS4T40UF3I=;
 b=tcpHZZTTIeiLw/y2owQGRV/2d5MACxqiYV8Hob7e6LCLFUkLbbbI1D+pwIyPfoW8Tk1khwm1qmLfPrf6doswJk+Wy7NwKiDh+j0Q7n68C9gP6cITocelKxTuup82UN00df5dGZR1BDzSpFy35/IOHHwTqfhof38TenxnT4BSjDA=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com (2603:10a6:208:b3::15)
 by AM4PR0501MB2338.eurprd05.prod.outlook.com (2603:10a6:200:54::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Sun, 5 Jul
 2020 07:19:14 +0000
Received: from AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::e00a:324b:e95c:750f]) by AM0PR05MB4786.eurprd05.prod.outlook.com
 ([fe80::e00a:324b:e95c:750f%7]) with mapi id 15.20.3153.029; Sun, 5 Jul 2020
 07:19:14 +0000
Date:   Sun, 5 Jul 2020 10:19:11 +0300
From:   Eli Cohen <eli@mellanox.com>
To:     Or Gerlitz <gerlitz.or@gmail.com>
Cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>
Subject: Re: [net 05/11] net/mlx5e: Hold reference on mirred devices while
 accessing them
Message-ID: <20200705071911.GA148399@mtl-vdi-166.wap.labs.mlnx>
References: <20200702221923.650779-1-saeedm@mellanox.com>
 <20200702221923.650779-6-saeedm@mellanox.com>
 <CAJ3xEMgjLDrHh5a97PTodG7UKbxTRoQtMXxdYDUKBo9qGzdcrA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ3xEMgjLDrHh5a97PTodG7UKbxTRoQtMXxdYDUKBo9qGzdcrA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: AM0PR04CA0139.eurprd04.prod.outlook.com
 (2603:10a6:208:55::44) To AM0PR05MB4786.eurprd05.prod.outlook.com
 (2603:10a6:208:b3::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mtl-vdi-166.wap.labs.mlnx (94.188.199.18) by AM0PR04CA0139.eurprd04.prod.outlook.com (2603:10a6:208:55::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23 via Frontend Transport; Sun, 5 Jul 2020 07:19:13 +0000
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f495eb97-8749-4fdc-2593-08d820b3b89f
X-MS-TrafficTypeDiagnostic: AM4PR0501MB2338:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4PR0501MB2338F342CC89F63D77516B3EC5680@AM4PR0501MB2338.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 045584D28C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XRXS44L19cP9jRV7cuonM2daxulCTC51cKWY9MA+Ufzrw9OJrmVA7MpzhrmZds3PnhBpz0O6wma5D+PAck98pxGcLg+y6loQ070VSPQX2b//PzXujyhEYpUeURfeNjrfVYDDFmKrq/rTkhDjkIdz44EktmnPPtBmSTayLrFFvio4BJ7L72OmaNb2oRE5nrqGjGCha+tPTVFKEtV+nUq0KIFoAN4DItQT030D+KmAYTJ9od6i6Ub4sRQqB6ezqKuqzRARCzNqzt2df1JIhFsGKLf5Y2xukdjBJZNKyk8K147WR9g+iIzyenk55qjO0YU+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4786.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(39850400004)(396003)(366004)(346002)(136003)(1076003)(86362001)(8676002)(5660300002)(6506007)(6916009)(66946007)(66476007)(53546011)(52116002)(7696005)(66556008)(186003)(16526019)(478600001)(33656002)(4744005)(8936002)(55016002)(26005)(9686003)(83380400001)(4326008)(107886003)(54906003)(316002)(2906002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 73VWnRbDqyYS5lgoRLHq0SXDuCVspl9Me1yLAPegqRq2AlCrJDIORupf08wvOPcESaubIp1IS9aYvwV1j1knhgVzvBmsseKFYixouhIt5vj3INzL5ulzeB1MI4h8AF3118/9BCno3JmzgXGbzBxZT4466j+Sb63Z4ckhgQfy21Dk1Vixky2SoOJh9iZPTB70bQ2bTg8soAsvkGNUyHQCkBpjgKl7ZpFW2yvWh4OAIC/6ZPndtpKpHjK1b9tm9ay2YfIjnozQ6jS0rlhay6WwDdIQpP9SyegYNqG94HZDgLl1uXr8YV2abXXDSz0EaWBlBRDxlUg0+NegkqY5uT+ZCwvq5fyM8NJ66Wl1vcdCY1E52hziCZ4A/fJkAHWyf81kQBuRFP5+4gUsiYE4ui2Oo24Km4tlQkaBrDY/RtbfVAFbVf8Tl3Bp+55IcK3wnHKNeVCRqrToxbk8e1xmfKMNoERkgeYWeoHVCP1RaYQJ7sk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f495eb97-8749-4fdc-2593-08d820b3b89f
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4786.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2020 07:19:14.4096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uC1qh+s9FZdQ3WeTlBRij/dZdaJswuvjqnLCJWWFyijQaqLRSX6cp+cBihaLwMFYw/bzKVu+i73y6O6p5+zI1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2338
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 03, 2020 at 12:33:58PM +0300, Or Gerlitz wrote:
> On Fri, Jul 3, 2020 at 1:24 AM Saeed Mahameed <saeedm@mellanox.com> wrote:
> > From: Eli Cohen <eli@mellanox.com>
> >
> > Net devices might be removed. For example, a vxlan device could be
> > deleted and its ifnidex would become invalid. Use dev_get_by_index()
> > instead of __dev_get_by_index() to hold reference on the device while
> > accessing it and release after done.
> 
> So if user space app installed a tc rule and then crashed or just
> exited without
> uninstalling the rule, the mirred (vxlan, vf rep, etc) device could
> never be removed?

Why do you think so? I decrease ref count, unconditionally, right after
returning from mlx5e_attach_encap().

