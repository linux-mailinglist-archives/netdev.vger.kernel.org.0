Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D10C1CDCB6
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 16:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgEKOL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 10:11:27 -0400
Received: from mail-db8eur05on2116.outbound.protection.outlook.com ([40.107.20.116]:7009
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730180AbgEKOL0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 10:11:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YrNZhATZm2nQ0sk0o7kjJOHoTa85i4waZDR0CoKObZwxSXrqrTwYZE53J7fa4WUuPrjawlmxD95RcM6bZ6fco2j71Jn8zjwSvSbT/0aDrXj7uVLz8uTk+QAYyItbwgyMUdmZjzKG7GWs7exjhPLLN5MZePyVPh5svCBVSU0jTxbCnxY5tW2CxzMDJ53d0+AHlyGT6Tat9AK/44f/AJS06krbcrj+ZoN0vNlpkeurOPiszF6mgicSkMcLSjwZvyQ1m3U0Sz0kVwI3Tqb5YQCzuunmbuFMXcFwe39uex+JtsCD/muj9EIwRxNvlG5QPQK0Yytu9mYIYwodLZYPmS0dAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hz4htdFottX34+kRWvPg7Kbl2/Zjiizl0BBqD7kodYM=;
 b=YH6myAZy1KnHUpCmdR8ncsXtZ8xyy4R0Xz6DCrkTR2HRDq8ETji6ASPZED3kR6sUOCC3tahpz2/804rTo9KmYMmIE5D3ePZyJZXVRXZB/WEbvpEGxHvSmWKo4bJVVcRCEzW3DJ4Ls+R6QQKYK4QuWO68zra+ukJugOAZ9quUv7JlKvIR81PFIWv6dKfYtU6572vVXbUDYsmeRiuoEYjv20mtHfDyikPK2IcBkn7VQOC8dct7SKczEfcKhzxh3Moz30rHoPemIToVx577by7UNpGzWl176RjzLmyg3ILcg7CDJ206o//IWEGlESfa0GTV3Y/lzYfmvgdxPfVy/eZ8iQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hz4htdFottX34+kRWvPg7Kbl2/Zjiizl0BBqD7kodYM=;
 b=HXIr+icx4URPtDNYqTt6EiM/tMu3LYJhKixyseYldgLwaIaus10bJm+hP8lQZHqD+RZegXdyr8TUPPMDPicYgmFmTZkp9BDVWsFcBxZ9esB3ptyJgG380McRyEIFPmaQ4XZ1Quo69eD05y0LReYbSDtvdJK7MVwasJJp4lOFEEU=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:35::10)
 by VI1P190MB0142.EURP190.PROD.OUTLOOK.COM (2603:10a6:800:a5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.29; Mon, 11 May
 2020 14:11:22 +0000
Received: from VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c]) by VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 ([fe80::f983:c9a8:573a:751c%7]) with mapi id 15.20.2979.033; Mon, 11 May 2020
 14:11:22 +0000
Date:   Mon, 11 May 2020 17:11:17 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200511141117.GF25096@plvision.eu>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
 <20200511111134.GD25096@plvision.eu>
 <20200511112905.GH2245@nanopsycho>
 <20200511124245.GA409897@lunn.ch>
 <20200511130252.GE25096@plvision.eu>
 <20200511135359.GB413878@lunn.ch>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511135359.GB413878@lunn.ch>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: AM6P192CA0033.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:209:83::46) To VI1P190MB0399.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:35::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by AM6P192CA0033.EURP192.PROD.OUTLOOK.COM (2603:10a6:209:83::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26 via Frontend Transport; Mon, 11 May 2020 14:11:20 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0e046a4a-0c79-4b6e-eeba-08d7f5b52f28
X-MS-TrafficTypeDiagnostic: VI1P190MB0142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1P190MB01425D58274187447A7EE82C95A10@VI1P190MB0142.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-Forefront-PRVS: 04004D94E2
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hSDmXvaRGI6A78PtC5hFbe1BKw1mngI8wWp9+YjPaqm9Mx8lk8ogSbwoIBdpIid32ESzopDT0l/0v/hdqYmgJFFC+D3I05Ijm6A/xG5Qo8fuA0WAChNk0FXmr+49GvileZmHRfioKi8BHtpXVf7SqsA6bZDig1gbe5lLt80hxHhMgMGTtmHV5p889wV20k2r6q9Ia2vN/ZBQfkYRHH5TGwt+sR+DZmTx9mkCQYYM/wGeiF+9g2RO2ml/1chtqeRkCjELIfy7DD5gy8nDqIG/SW/7PIH+SCVWSwOC4uH8kXEEkE7Y0XTXt4LbhqoqqOKJ6Mf5KnpP+f6lPA8QiiJxj7+c1dYhUG3kF9aLgIXQwmiWTxkJ50UG/lxqnrHeQsbvniZNNmOldBCMTYwnascUqiSkkNXndFAZW7rIT6mhP2DTEpyMNvaqWpgGVjCaKJCu/FyMSYTdXFZGIkygsK2L7u+omM2GF7RVxMmNkEBkgw11LvpEj8zWloWrRT+eLhrV3ghn5VqGzG9dM6sPU2RM0g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0399.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(366004)(376002)(39830400003)(346002)(136003)(396003)(33430700001)(956004)(6666004)(66476007)(16526019)(36756003)(186003)(8886007)(26005)(33656002)(4326008)(66946007)(44832011)(66556008)(86362001)(6916009)(508600001)(5660300002)(54906003)(2616005)(33440700001)(55016002)(8936002)(2906002)(4744005)(52116002)(8676002)(316002)(7696005)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: nTp6TaghvHun/PoEWq2gzpwZGOIUjBFfa2MGslHEdKcLvsnhxjwNK77GHCisKP8mGqZEWh801FkZPDjBhOmemM0z6w9ZGNkDoO8xNpMMIjVSNwVKQVQQERef7amrk+q4V5SK2FBzswfaNITMBEddN+oeYsf+SNd/JASX/NsjUNqG3xXTasldlWO8iaIe3hrin/PzYj46gb6kIt/gbPjt6mGEJ95sg76h2E4TwW80+P2QJPcNBe3wJXk0+Hyc17lBcX2utCOgBCvzg36W2GGWOXYPQ1/AbNZBcHC0Ka5CfM29tGOvnryuvjF1MYRSsje94SxqIqscepLOyEi1fHfC3Ao/flJdZzbG05bgVkPrpkZ2VJk1R/4IlozfmeSiHl3MxgnO5XZO1cc18gBf+8L+Szngu+6kWjnvmBxlVvFaL2T2Z0c1iTpR7ifP6a6ssMti1SaxDRmVS46URHq1cPkUMa9uFPEy4sowuXotS0ZDl4Q=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e046a4a-0c79-4b6e-eeba-08d7f5b52f28
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2020 14:11:22.7670
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +SpQy4ZAOxH3qa/0go7d+rpQFrx1hUffq2bSxI62udE7s2ADNN2alvq0WFPs8YzCRUfF1kNEi70qSpzWKleqBG3ZxonuJm81pcdpQmKQbIw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1P190MB0142
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 03:53:59PM +0200, Andrew Lunn wrote:
> > Looks like it might be hard for the board manufacturing? I mean each
> > board item need to have updated dtb file with base mac address, instead
> > to have common dtb for the board type.
> > 
> > And it sounds that platform data might be the way in case if the vendor
> > will implement platform device driver which will handle reading base mac
> > from eeprom (or other storage) depending on the board and put it to the
> > platform data which will be provided to prestera driver ?
> 
> Hi Vadym
> 
> This is not a new problem. Go look at the standard solutions to this.
> 
> of_get_mac_address(), eth_platform_get_mac_address(),
> nvmem_get_mac_address(), of_get_mac_addr_nvmem(), etc.
> 
>   Andrew

Thank you! I will look on it!
