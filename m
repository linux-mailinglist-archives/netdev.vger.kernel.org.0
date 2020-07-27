Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D285822ECAB
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 15:00:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728476AbgG0NAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 09:00:19 -0400
Received: from mail-db8eur05on2043.outbound.protection.outlook.com ([40.107.20.43]:22689
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728141AbgG0NAS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 09:00:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g3QVIL+MyuB+WMxF7FVCgfkXTKjjIsF2ypxZliTsI0rPK1QGaR1jwzLWfUYXNuPWbtzm5fWklep5iF57JGT1JJTa4fO5BnxoGbUXjADxK/3OwmEqphbz3mHGtSD4BW3a3Zqo4zHsNq8RApyz88+jp0TZF6MKdHtU1K7KgEy0mwNKy3DYbr83Mz4CDLNRnbRv6z8wu5rGm9qSCP1heQO3IEMVyqNnC4x0g371rAOZ4L45BMXQQ14KpU5AtYKsW0YvyAE2EybtZiShzbYMku3OpDOSEULyC4mzTbDEQJfxy7adrLVDrKWkSDf6mhDhS/ZyCaLE4AeEZqlYQSnf0Of2BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPh+MpMFmmitKU6ECdKAR9vlo5qkvWrHSnQp9RqYeAk=;
 b=GGe8XOKLyoHuL7qTRwAhnxCz7LnJ70i7socWmcWGMdolSDhPNDXdu/EY8JLZqVI5xNyp50CHC9ilU0NFuBnl4jeWCjhS3LTQJFoinQFyaB7s6C2+MjvdfFiCeyO2hDO20Ad+MOPHIa6HKgDCpimsA3Wm9An8aIb7tEQ+rnfFANEL46JFBaIcHptOYTeUs3/OrouBJJ3pwj/P0uJatnagD9x49p33YNmrv79DqCunFlMWIRzY/0ysf/uLOp8su7mUPGGjiG5XGaia64+KNRveLt6ve8ZAb7rFduJZr6wNE2OdiNqPyAG3EirpTtG1sitT8DMhYc+ZptHKSr9Qwz6FMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPh+MpMFmmitKU6ECdKAR9vlo5qkvWrHSnQp9RqYeAk=;
 b=eqND41Ay/a3uR6SnphaX8dYNGS3rhFfo5lQW7vBi6TnA6Rg7cgj3/tpgqNl+sQqUtKu6bQmRa3Jb8Ezwpz38aqWua15ZdyTDrl4Ii2N+hofF/eyf8L+LGS4RGaUa144y/9ljE67aT5Zk//OWTfhTcsBbhMGFVPNgoyx5KyAeKB4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0501MB2844.eurprd05.prod.outlook.com (2603:10a6:3:c1::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3216.27; Mon, 27 Jul 2020 13:00:15 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::56c:7b22:6d6e:ed2b%5]) with mapi id 15.20.3216.033; Mon, 27 Jul 2020
 13:00:15 +0000
References: <20200727090601.6500-1-kurt@linutronix.de> <20200727090601.6500-5-kurt@linutronix.de>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 4/9] mlxsw: spectrum_ptp: Use generic helper function
In-reply-to: <20200727090601.6500-5-kurt@linutronix.de>
Date:   Mon, 27 Jul 2020 15:00:10 +0200
Message-ID: <87a6zli04l.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0141.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::46) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR06CA0141.eurprd06.prod.outlook.com (2603:10a6:208:ab::46) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23 via Frontend Transport; Mon, 27 Jul 2020 13:00:13 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 788500eb-7257-43a1-84a2-08d8322d00dd
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2844:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB284474A9E47FA975573A0A89DB720@HE1PR0501MB2844.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GxNCqZXXCKESdN/fKMNODcLgxArDG6aB7ouUXQpRVI/1yZbJ4DQHHxMTfNVj8LrZYCihVPq98thpcvSCyJfIV91bx+rzliBiqC+jlGENnHewq+OOBO9kWr0jsJw5AtIPC1XVz1vth2ysNKgOX6JllOn9Oe0fXOFhCmjBuzzK89JkBMVrPbkXDOAeuu/5ulUL8Bq4p/SvAmFXX4fZSOquFo48lAW8YyVCE+bbW47sW+hO8+mlxQUs/Wf0jVLStxrSRyeceTaLeit08n7DYQhTqG/u6kE+uwqzGmFARyswK5E0k9evPfGGgEYWCCHgdrfgl8e+vhA27fhPiC5e2ecgEW3G6a6C9TWlqt/gTWpRMY7QNgiRPs85RbNyKgBitr1+NF6BRpulV4jhAPJMMthPAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(6486002)(66476007)(7416002)(8936002)(66946007)(26005)(956004)(2616005)(186003)(16526019)(66556008)(8676002)(6916009)(316002)(54906003)(6496006)(4326008)(478600001)(36756003)(2906002)(5660300002)(86362001)(52116002)(41533002)(505234006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 9hkym0t4Xey9CjPOK5rs4Pu3vorA+86jUwQu8mZYTCUsN5ftD/D5XUos13Wuf2acD6/wgEevooL6yQArvTDWQTlH/A9ALl+e5iHQ2jkK3FiaW9F2oiB2qam0tNrevFtT0mleOzu4kYfl0FhLmXBlxta6y3qkajncMfMzmA1gMBdMorPeEEJCCLAohi1egGgixaE7fWOE49VTn/SVtvr18XQYikB0vV2djk4BDiQuNhJ7CKf4rxeEQJWWMb2Ncr7T1AjktzoeZBhaPMhqqm5fNhJrg9atiY5Wicy/sUD0RmJD3xWJDNCthfhZcvhALcUNG0vi38fLLn27l9mjAMNFUFQvqOvPVtgTd7GvGnKP/WZEQVuvwHPg7baB+0o0T5PYRYnjNGWQzAa14EvjDNFoZgkAq3p76xEuLcetIJ7c9HHu97Q2GtznYT36uhXDbOA379+5d9FXXQd3Rg1JJg698m2SWwGc75rwEobrS6JBdOA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 788500eb-7257-43a1-84a2-08d8322d00dd
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2020 13:00:14.8416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yEnH0fi8jLOS7TIl5tIZq1haxiEXzRVbscLAbxZNZNfs6dk6H9j88Wjb3B/MEbW61zyC9YJ5dNEHBysnaCTDkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2844
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Kurt Kanzenbach <kurt@linutronix.de> writes:

> @@ -329,30 +327,14 @@ static int mlxsw_sp_ptp_parse(struct sk_buff *skb,
>  		return -ERANGE;
>  	}
>
> -	if (ptp_class & PTP_CLASS_VLAN)
> -		offset += VLAN_HLEN;
> -
> -	switch (ptp_class & PTP_CLASS_PMASK) {
> -	case PTP_CLASS_IPV4:
> -		offset += ETH_HLEN + IPV4_HLEN(data + offset) + UDP_HLEN;
> -		break;
> -	case PTP_CLASS_IPV6:
> -		offset += ETH_HLEN + IP6_HLEN + UDP_HLEN;
> -		break;
> -	case PTP_CLASS_L2:
> -		offset += ETH_HLEN;
> -		break;
> -	default:
> -		return -ERANGE;
> -	}
> -
> -	/* PTP header is 34 bytes. */
> -	if (skb->len < offset + 34)
> +	hdr = ptp_parse_header(skb, ptp_class);
> +	if (!hdr)
>  		return -EINVAL;

So this looks good, and works, but I'm wondering about one thing.

Your code (and evidently most drivers as well) use a different check
than mlxsw, namely skb->len + ETH_HLEN < X. When I print_hex_dump()
skb_mac_header(skb), skb->len in mlxsw with some test packet, I get e.g.
this:

    00000000259a4db7: 01 00 5e 00 01 81 00 02 c9 a4 e4 e1 08 00 45 00  ..^...........E.
    000000005f29f0eb: 00 48 0d c9 40 00 01 11 c8 59 c0 00 02 01 e0 00  .H..@....Y......
    00000000f3663e9e: 01 81 01 3f 01 3f 00 34 9f d3 00 02 00 2c 00 00  ...?.?.4.....,..
                            ^sp^^ ^dp^^ ^len^ ^cks^       ^len^
    00000000b3914606: 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 02  ................
    000000002e7828ea: c9 ff fe a4 e4 e1 00 01 09 fa 00 00 00 00 00 00  ................
    000000000b98156e: 00 00 00 00 00 00                                ......

Both UDP and PTP length fields indicate that the payload ends exactly at
the end of the dump. So apparently skb->len contains all the payload
bytes, including the Ethernet header.

Is that the case for other drivers as well? Maybe mlxsw is just missing
some SKB magic in the driver.
