Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E632A48564B
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 16:57:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241747AbiAEP5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 10:57:44 -0500
Received: from mail-eopbgr60076.outbound.protection.outlook.com ([40.107.6.76]:51267
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231191AbiAEP5m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 5 Jan 2022 10:57:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g0hbztrJO4JLPVff1LXNDNNyXiw8NDdkn6NRYHW7QeJhGwhUvQkN3i6NH5uiLXEVZffYNWq4QUoRy6E/rBbkciWbFGeeShTffEIrtzKLBu9l0q1lvRu5YDIy/4TfQpBDedrrB7lNpZ3eKk7v63VEPZ4ZXPKUbDQXld+o93Ew+Db+Ii9oiSfsM7y4r0jzYZpzXfJGNMVFKFOIDYEK1tWgDYZf1ByTiPkztmA3HgPE8SzfY43T0IZMkQUWx/h+TK+VrYbpRX14wR51BsWiFDHWQranJIe+0ZXnU6FtHLSG0cKFa6zjkwaJOax4cjEy4FM3bnjVW8wONrNvp79VC7QYww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7RIo+7ZW95vhR4dTA8T5OljUJ9IJ08lgRJxvfdB5qlE=;
 b=n2Qd19HIC2lJx3lpCuvBmwDOh8G9J1KiJkHiaWir3BnGsCz1pHS8B3KGoxGkL7RRR2cFbSUA8R0Ee+a0SWkx3LaExymhZr3KIoMZX/jI2d3dTq+KSzckOoPNsWBwrD4jXZeE+PewcVThwXSFv21zVtek8xewFkONLxizUjDQ/XMyP2Xup3scvqvmPd+iwEw2Cg5HhHUYwsS5nQOlhPgylMsd1XnGhnLdrcWrbeItUsEwiv45jN9vQu0/b3a88zkV3MPVNjhC+ET+uq5AAc/7E9+mnSGGvACUj+1LzIhh6PmJOHcYIOZds4hXRmEA6yIi/8pq7dPStqSIBxpwt++nzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 194.138.21.71) smtp.rcpttodomain=canonical.com smtp.mailfrom=siemens.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=siemens.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7RIo+7ZW95vhR4dTA8T5OljUJ9IJ08lgRJxvfdB5qlE=;
 b=yQedLdfe7WjDLiLY/4Qre8rNhxMwPqSEJgYKfnAO5292xOpKZs8SutzGJI/ZtuDNTMbX087kEEkwlnuSZGd9ZD7jU8vzHeSuZU09r/Pr50vWcfxQ94SqQBjno4s08Qf9JoM1jIHcvORiX550wq6mSdhQ8vNHC86lmvIVxkGNkfxthCVuMaWMcDAt9ZGCLzCIpCT0G6BqkIlBJxjPmi73XqNrG/gn1eFPAq46ardDZmTS0hxDFEoliesioD3+R9+LDxKn/K/cojVC/RANhiLUhKIBvmXd6hAfr9fSRJoJuf/TmZFeobU8A/PXcUDP5zIMH9u6b+sVDB1v8wEZMIExrw==
Received: from AM6PR0502CA0053.eurprd05.prod.outlook.com
 (2603:10a6:20b:56::30) by VI1PR10MB3520.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:800:13a::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.7; Wed, 5 Jan
 2022 15:57:39 +0000
Received: from VE1EUR01FT017.eop-EUR01.prod.protection.outlook.com
 (2603:10a6:20b:56:cafe::ec) by AM6PR0502CA0053.outlook.office365.com
 (2603:10a6:20b:56::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.18 via Frontend
 Transport; Wed, 5 Jan 2022 15:57:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 194.138.21.71)
 smtp.mailfrom=siemens.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=siemens.com;
Received-SPF: Pass (protection.outlook.com: domain of siemens.com designates
 194.138.21.71 as permitted sender) receiver=protection.outlook.com;
 client-ip=194.138.21.71; helo=hybrid.siemens.com;
Received: from hybrid.siemens.com (194.138.21.71) by
 VE1EUR01FT017.mail.protection.outlook.com (10.152.2.226) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4867.7 via Frontend Transport; Wed, 5 Jan 2022 15:57:39 +0000
Received: from DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) by
 DEMCHDC9SKA.ad011.siemens.net (194.138.21.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 16:57:38 +0100
Received: from md1za8fc.ad001.siemens.net (139.25.68.217) by
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 5 Jan 2022 16:57:38 +0100
Date:   Wed, 5 Jan 2022 16:57:35 +0100
From:   Henning Schild <henning.schild@siemens.com>
To:     Aaron Ma <aaron.ma@canonical.com>
CC:     <kuba@kernel.org>, <linux-usb@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <hayeswang@realtek.com>, <tiwai@suse.de>
Subject: Re: [PATCH 1/3 v3] net: usb: r8152: Check used MAC passthrough
 address
Message-ID: <20220105165735.38b629b7@md1za8fc.ad001.siemens.net>
In-Reply-To: <20220105151427.8373-1-aaron.ma@canonical.com>
References: <20220105151427.8373-1-aaron.ma@canonical.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [139.25.68.217]
X-ClientProxiedBy: DEMCHDC89XA.ad011.siemens.net (139.25.226.103) To
 DEMCHDC8A0A.ad011.siemens.net (139.25.226.106)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1bce4969-c1d5-43a2-6c28-08d9d0641997
X-MS-TrafficTypeDiagnostic: VI1PR10MB3520:EE_
X-Microsoft-Antispam-PRVS: <VI1PR10MB3520A8335A12607C96657AF6854B9@VI1PR10MB3520.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: huZS4CO35BvFiU6zqPEVWSfTDtu+QdRJXHedgXOW0EkFeF/YXfzglim84YQ5rQ4rAg4F+pRndSoSYWSKqcjysTijSEteGaOjWY0o6Z2690mXp6ZGzH3SxuaNhiHhQ6fRyR+nxdSU6+y9ukRXgEeWEtG05WhXnhbAL7k7NjpWTqYlKomoJhhu9fE5JvaliEgIboEw8PW46MVRRbT5ijvVj8so+ZskvTK00HpvTix3jTpcfTcGIxBk0b4rszQKQvqm3BdCmWWaYNX26kPb4thiTlE1ZA7mtKbnM3crpG/h/zy0eTZh1U0ernckQTgcXR9ZIit238VAXXwxehuHPEuJd8p/efNF7oYJpk4+h0mXYplb2j7L04a5/7TtI1pY6PnxmxhCj/cSw5EUAx88/fclt5VdIYbDuCZa1jMxFVEKIDzYMlv0kkc8B5hNZzwlLjtorp9t3QXqwOe2JCca2eNcL7KgaqmUFHsE5whN63tw7f4eJBaOAtj12FMAPpzOBg++E5UG6+L+J6decSpTZ206s4IeVrXt6MG2Sj9DPMqMnNTbdyTZZS1Wb+BEltVnoMB0VQahskFTd6rnAHnkawlaCS+cEeJlLLrxP7mmCTg2C8XCxBWpI2y4oRZBn3/TCjw6g+JyAPCe6heb9helGpj0QMD6PerH6EkK/yw1D8LpdWd97ATNC5q974tJOS84ggM0iMFcDB2zD3rLE8ipcOWACYv3g1bH57qOupRNo17wM9wxDBYZfm0GVvS144TcbrUOgnOFwpDEuPUtA0WTKYCKUGJ0U3p+lP7HX63eWYyINeIVBLGKJT337JPourljJ2GHvs7FoUsw2QtqlTrlIQqFvLrxQqdxUlnG/wUpEgERDFl1hVoGCzwbnO32gr3hwYQk
X-Forefront-Antispam-Report: CIP:194.138.21.71;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:hybrid.siemens.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(4636009)(36840700001)(46966006)(40470700002)(7696005)(16526019)(966005)(186003)(26005)(508600001)(8936002)(8676002)(86362001)(2906002)(54906003)(82960400001)(81166007)(5660300002)(4326008)(47076005)(83380400001)(55016003)(40460700001)(82310400004)(356005)(336012)(70586007)(70206006)(44832011)(956004)(9686003)(1076003)(36860700001)(6916009)(316002)(6666004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jan 2022 15:57:39.3671
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bce4969-c1d5-43a2-6c28-08d9d0641997
X-MS-Exchange-CrossTenant-Id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=38ae3bcd-9579-4fd4-adda-b42e1495d55a;Ip=[194.138.21.71];Helo=[hybrid.siemens.com]
X-MS-Exchange-CrossTenant-AuthSource: VE1EUR01FT017.eop-EUR01.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR10MB3520
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ok this now will claim only the first plugged in dongle. Probably as
you wanted it. But still breaking my always two ethernet cables and no
"lenovo dock" anywhere.

Still feels very wrong to me, but i have no clue how it is supposed to
work. Lenovo documentation talks about PXE use-cases ... which means
BIOS is spoofing and not OS. OS should probably just take the active
MAC instead of the one from EEPROM.
But it also has a link to one "dock" that is really just a dongle. And
the whole thing is super dated.

https://support.lenovo.com/ie/en/solutions/ht503574

Henning

Am Wed,  5 Jan 2022 23:14:25 +0800
schrieb Aaron Ma <aaron.ma@canonical.com>:

> When plugin multiple r8152 ethernet dongles to Lenovo Docks
> or USB hub, MAC passthrough address from BIOS should be
> checked if it had been used to avoid using on other dongles.
> 
> Currently builtin r8152 on Dock still can't be identified.
> First detected r8152 will use the MAC passthrough address.
> 
> v2:
> Skip builtin PCI MAC address which is share MAC address with
> passthrough MAC.
> Check thunderbolt based ethernet.
> 
> v3:
> Add return value.
> 
> Fixes: f77b83b5bbab ("net: usb: r8152: Add MAC passthrough support for
> more Lenovo Docks")
> Signed-off-by: Aaron Ma <aaron.ma@canonical.com>
> ---
>  drivers/net/usb/r8152.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
> index f9877a3e83ac..2483dc421dff 100644
> --- a/drivers/net/usb/r8152.c
> +++ b/drivers/net/usb/r8152.c
> @@ -25,6 +25,7 @@
>  #include <linux/atomic.h>
>  #include <linux/acpi.h>
>  #include <linux/firmware.h>
> +#include <linux/pci.h>
>  #include <crypto/hash.h>
>  #include <linux/usb/r8152.h>
>  
> @@ -1605,6 +1606,7 @@ static int vendor_mac_passthru_addr_read(struct
> r8152 *tp, struct sockaddr *sa) char *mac_obj_name;
>  	acpi_object_type mac_obj_type;
>  	int mac_strlen;
> +	struct net_device *ndev;
>  
>  	if (tp->lenovo_macpassthru) {
>  		mac_obj_name = "\\MACA";
> @@ -1662,6 +1664,19 @@ static int
> vendor_mac_passthru_addr_read(struct r8152 *tp, struct sockaddr *sa)
> ret = -EINVAL; goto amacout;
>  	}
> +	rcu_read_lock();
> +	for_each_netdev_rcu(&init_net, ndev) {
> +		if (ndev->dev.parent && dev_is_pci(ndev->dev.parent)
> &&
> +
> !pci_is_thunderbolt_attached(to_pci_dev(ndev->dev.parent)))
> +			continue;
> +		if (strncmp(buf, ndev->dev_addr, 6) == 0) {
> +			ret = -EINVAL;
> +			rcu_read_unlock();
> +			goto amacout;
> +		}
> +	}
> +	rcu_read_unlock();
> +
>  	memcpy(sa->sa_data, buf, 6);
>  	netif_info(tp, probe, tp->netdev,
>  		   "Using pass-thru MAC addr %pM\n", sa->sa_data);

