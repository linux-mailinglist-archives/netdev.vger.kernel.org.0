Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDE662659D7
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 09:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgIKHCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 03:02:32 -0400
Received: from mail-eopbgr70111.outbound.protection.outlook.com ([40.107.7.111]:48353
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725468AbgIKHC1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 03:02:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e37rFNxcEzti2AjCGonkprh8y9LzeKWStVTdRYI/j1mJP09s9McqdkoQFXMPPLbaSClUrh1kv40Nkv3/JRWuVFpC1JXy7SzH1I0mEHs6EMad+GyDAQBftSdLeW9V6gEUy0KrRouyLwCj07pCRIeanRTGeFMWoATG2rCEibvLbdIIhPzXDEA1IWm8XMvz7klrL2iz4KlqK58bIqLoanRZ0CYh07NOCjVM6oM0NbtTGSRMmbNyhVNS22/5pH6fZq7/ElJ+MCrNQr81YJQHOB98rpEj+bUr+OjnTaeaj43FPD8PwMwTVb5Y48HPk8ZhMWG3cDaBS5Hyowk+hgONGa/MfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mq2C81eBEKbjZS+T7g13tDoEsxYzI3bRRVpu2sGCteg=;
 b=iDSdyX03Oyon9Rb1W6wRCIo29n33W1s5RITvqbI+pfkh/bdpfq/qWkAqqvE44xQyAxVzvBi4YoWu3rQYv6kR+3taM3Ov6dJSdZt+6oiNFIG0mhc1Tqvq31xh+aETqwFcnVDkocjyV/7u4t7EsyPl8XlVlAP6+3s92ai2RG2vz9pbGbxlwONTu0iY2vUeMwY6zM1RqBICgszuak5gWXCeFVO7Le9VjtxdV6s0NMU2Aq8d+rs894fPNJDdZo5IXe7TybzxXVOPME1HssoBKBjbhc5LHbLICQ423X2O2NaM7zZ5zUUMqxIxJoin70KeyDQJZ48la3UTmikG7L1MyyDXEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mq2C81eBEKbjZS+T7g13tDoEsxYzI3bRRVpu2sGCteg=;
 b=Qr3jX/bkaGNcLl50Jxxdqb0IJy53LKPf5cyGv7McZbEOBoGytIR/QpQqwMhLzJa3ctrQyqVNGtGGzprtkz9V8p5N++sOcQfZ4ZaBJMwmIBWCM75rs6f7UYJdUrTVelnOi9t5WTDaUWysfDExUn7zDfpcdWVdMFxita+H9Ez9Nbk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0300.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5c::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3370.16; Fri, 11 Sep 2020 07:02:21 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::c1ab:71de:6bc2:89fe%6]) with mapi id 15.20.3370.017; Fri, 11 Sep 2020
 07:02:20 +0000
Date:   Fri, 11 Sep 2020 10:02:12 +0300
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Mickey Rachamim <mickeyr@marvell.com>
Subject: Re: [net-next v8 1/6] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200911070212.GA17183@plvision.eu>
References: <20200910150055.15598-1-vadym.kochan@plvision.eu>
 <20200910150055.15598-2-vadym.kochan@plvision.eu>
 <20200910183047.39e4cd7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200910183047.39e4cd7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: BE0P281CA0004.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::14) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from plvision.eu (217.20.186.93) by BE0P281CA0004.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10:a::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.5 via Frontend Transport; Fri, 11 Sep 2020 07:02:19 +0000
X-Originating-IP: [217.20.186.93]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2ced28c-2b4c-4683-071b-08d85620a093
X-MS-TrafficTypeDiagnostic: HE1P190MB0300:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0300FCCB248403383D96B18F95240@HE1P190MB0300.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0Pqtzpw358xn1Dp7kEjynUW6h7eWUumjIALRuefAefJka8hbWWi6hG6MmY+72Q3W1X8zOIGRX0zpstvdd7g7AsYjCDr1yEPFAbWbZwWa1UZ6adX93RBLXTj82wOUJGKxCAjoY2t7CuKKTukSpyZ8DYPkhmoIa3yhhbPa/ylio2bC28qg/YPt5SpJGRO9PnFI4e3ToHDcYn2RuM+vso8MIMMXlr660ldbU4UuLrt73o8sU8FQX3EdkugpiKmXeXyCLZrEc5bj5UQUndy/OEkjjSSF+8Lywni0yfv3+St+xC25rLs9r/Zv4Mwm/bAdYB+KLoc3jvocFBoPZnq6rtwNA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39830400003)(366004)(396003)(6916009)(5660300002)(8936002)(4744005)(36756003)(478600001)(2906002)(4326008)(316002)(1076003)(2616005)(33656002)(83380400001)(55016002)(8886007)(26005)(86362001)(16526019)(66556008)(66476007)(66946007)(44832011)(186003)(956004)(8676002)(54906003)(6666004)(7696005)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: c77I2/wB/pXqBEVHeHC2tl0g8T1smQO1DwI3v1UYnTXLNyujf4OtkrLrk7CKbyc7XdrF5DwwrBg61R+ZqdQrg3WUMcFQgInwwH6OA6RLpTwk8ePMLUzoT29S+rtJ1jzOTmz+A7H5xSAHfe2sJH56AeoZj+VgbNVo8deCjPWv4/9hfMPTGZszZO4jeqUm1o0bru8ibCHUrc+lXPxXysYnD8YaznbhcqhIclhaKmMlN5kNDv1fHSzHEnpetgYvDzayytKSgXgiqe0E+lvSV3ceE7JjpRvI3/vB0nFbrBX+DthubIJj2Cva1J9VUQs4vquTjLl7nUoumIDDvNVxyE2XLp+kjt2MYeCKVcYQvyE965zZGKq6R+afMHcKyCft0FJv8eqG5rEyyZwip/sn1m9iGSwgR3oMRICJhCa0ZRCfc+NZmJVegxLKV11ZxOMR8RWpT5w/21IGR/HwJ5tkQZYUc9PkiPGBbih89pnjzu2u+xmYTxOYoJXa8bVRUEDPRmxdXMsvbdoOYZRiv8l4IMbC10ZBJB8t/sJychfTbQ8IOa0IGvJKUY+sV3RZdEtQxWzMsLpw/rcdJcML9dBpPpurykhWrdwBb3WzIF4Buo+2Y/tLWcYPFm7iwlK4MKWDch173Gxbh9/0zSNDmT0ZM2VveQ==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: c2ced28c-2b4c-4683-071b-08d85620a093
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2020 07:02:20.8595
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k9bI6zIUy8xlDoB5mqykwQZuy1dDzcQUR6JshcyKGmtJpW0d9e2Jpzsf21kKwCGiHaep5l+dcK0raEo3jOo5mpLxDIzAktjgJbXqaUcgT+c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0300
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 10, 2020 at 06:30:47PM -0700, Jakub Kicinski wrote:
> On Thu, 10 Sep 2020 18:00:50 +0300 Vadym Kochan wrote:
> > +static int prestera_sdma_tx_wait(struct prestera_sdma *sdma,
> > +				 struct prestera_tx_ring *tx_ring)
> > +{
> > +	int tx_wait_num = PRESTERA_SDMA_WAIT_MUL * tx_ring->max_burst;
> > +	bool is_ready;
> > +
> > +	return read_poll_timeout_atomic(prestera_sdma_is_ready, is_ready, true,
> > +					1, tx_wait_num, false, sdma);
> > +}
> 
> This is strange and generates a warning:
> 
> drivers/net/ethernet/marvell/prestera/prestera_rxtx.c: In function ‘prestera_sdma_tx_wait’:
> drivers/net/ethernet/marvell/prestera/prestera_rxtx.c:695:7: warning: variable ‘is_ready’ set but not used [-Wunused-but-set-variable]
>   695 |  bool is_ready;
>       |       ^~~~~~~~

Sorry about this mistake, will re-submit new version.
