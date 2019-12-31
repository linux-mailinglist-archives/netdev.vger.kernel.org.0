Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ADA6A12D86B
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 12:35:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfLaLfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 06:35:38 -0500
Received: from mail-he1eur04hn2080.outbound.protection.outlook.com ([52.101.137.80]:48355
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726659AbfLaLfi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 06:35:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j+UzeDrneiApAIVpCay4uAI96cb+HIWHOErJ+yfrOjikPptQAHokk+UiBe/nkUXsKd2+WarT+Ia0vsIm/KVSg7JmK0eN8UHV4Qtj2dDB00730U4gYq7XhAlRsIR3Eact1d9Oul3yLFP1Pvwe5D8opbuk87EuaKlTWFmvvdaFPX0Cv+plE+hCWGA3+UwOwtIB5Yq2vHY7uphv0C1LKQUSFl+W0njjXpSGqE6Z50sscfxKxcZYUcdOeyFge5ey22Jkr2JtJddZFYqYUceWW1nZke/jELH/hVXowQdlu/DQqaBNNm/oJCXTatXLsUiU5WP0+uH+GEWRSvVJsvUQZECSDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLS1qIm9Xr7h8dtoVOkjJQC7YykMD5LDx6JoRXpPelw=;
 b=aCQGRZ5pCDm1SCLdiPVldduHGd90s5Lkq61ABLqm5E+9YJoyNyT2ORGtAh5+u6gPy4AdKlah1iOoVkFXOlWduq5WDVNq0xKhO8GDyvH6kpvRQ2Fntnj0tyomLZ0NPnj4bBJ/qPz6sh+HH6f/g8jXjR6scXcA9I0N1bfhTU2tVVWhLbU1Ab1gLO4gjnnOmm6UBtf1Ll4F1uee/MAVTVN5yg8ZSHr+knjvkp7fWgOmFW5XAr/kqVUajh+b/ZgSbn/N8ExrGK3byu8/3aQp50VIVthBS0iKkR2kWZsVMBsfJWvDTopATWeagK4ZZTReAOF2cr1ipDRDRAiNTtfAy/e6tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dLS1qIm9Xr7h8dtoVOkjJQC7YykMD5LDx6JoRXpPelw=;
 b=mpNgr/TwI9oDm6neeHEmmkNV1gVqxp92r+97gT4A533z45RDRAK7+LrILwJRkjLIRFYCL1aprF0iht9UNtcdUEMBeKaimJPVK/F7UwyI68QsBSMrU9jeXxlV+iFavyfo4/baoLekd/qJwAJaoDT/SY70URh4iVdIUXE1zuYFJkE=
Received: from VI1PR08MB4608.eurprd08.prod.outlook.com (20.178.80.22) by
 VI1PR08MB3439.eurprd08.prod.outlook.com (20.177.59.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.12; Tue, 31 Dec 2019 11:34:44 +0000
Received: from VI1PR08MB4608.eurprd08.prod.outlook.com
 ([fe80::acb0:a61d:f08a:1c12]) by VI1PR08MB4608.eurprd08.prod.outlook.com
 ([fe80::acb0:a61d:f08a:1c12%7]) with mapi id 15.20.2581.007; Tue, 31 Dec 2019
 11:34:44 +0000
Received: from rkaganb.sw.ru (185.231.240.5) by HE1P189CA0008.EURP189.PROD.OUTLOOK.COM (2603:10a6:7:53::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.10 via Frontend Transport; Tue, 31 Dec 2019 11:34:43 +0000
From:   Roman Kagan <rkagan@virtuozzo.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>
CC:     "sashal@kernel.org" <sashal@kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>,
        "vkuznets@redhat.com" <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
 offer sequence and use async probe
Thread-Topic: [PATCH V2,net-next, 3/3] hv_netvsc: Name NICs based on vmbus
 offer sequence and use async probe
Thread-Index: AQHVv03LHhmTIWa4QkCi/JM0N1XuXafUHfgA
Date:   Tue, 31 Dec 2019 11:34:44 +0000
Message-ID: <20191231113440.GA380228@rkaganb.sw.ru>
References: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
 <1577736814-21112-4-git-send-email-haiyangz@microsoft.com>
In-Reply-To: <1577736814-21112-4-git-send-email-haiyangz@microsoft.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
mail-followup-to: Roman Kagan <rkagan@virtuozzo.com>,   Haiyang Zhang
 <haiyangz@microsoft.com>, sashal@kernel.org,   linux-hyperv@vger.kernel.org,
 netdev@vger.kernel.org,        kys@microsoft.com, sthemmin@microsoft.com,
 olaf@aepfle.de,        vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
x-originating-ip: [185.231.240.5]
x-clientproxiedby: HE1P189CA0008.EURP189.PROD.OUTLOOK.COM (2603:10a6:7:53::21)
 To VI1PR08MB4608.eurprd08.prod.outlook.com (2603:10a6:803:c0::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=rkagan@virtuozzo.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4fc0f803-5cef-4acf-90c0-08d78de56ec3
x-ms-traffictypediagnostic: VI1PR08MB3439:|VI1PR08MB3439:|VI1PR08MB3439:
x-microsoft-antispam-prvs: <VI1PR08MB3439EDA69115A7AA246AFD85C9260@VI1PR08MB3439.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0268246AE7
x-forefront-antispam-report: SFV:SPM;SFS:(10019020)(346002)(39840400004)(376002)(366004)(136003)(396003)(199004)(189003)(55016002)(66476007)(478600001)(66446008)(4326008)(66556008)(33656002)(5660300002)(64756008)(66946007)(9686003)(6506007)(7416002)(86362001)(52116002)(6916009)(8936002)(956004)(81166006)(7696005)(54906003)(71200400001)(186003)(316002)(26005)(8676002)(36756003)(2906002)(16526019)(1076003)(81156014)(30126003);DIR:OUT;SFP:1501;SCL:5;SRVR:VI1PR08MB3439;H:VI1PR08MB4608.eurprd08.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;CAT:OSPM;
received-spf: None (protection.outlook.com: virtuozzo.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zIhszu+VGE6/aaBr3RPCxV+yjuEoKwTIJ3W5C2ax1tT8NpnRRt4aUH25wsMq3OMlVFI6rqNT462avneG44Tpc6KWcbjCPDC0EQSJwgYN2GRfwJ9/uvswkDQblkd3HBvkThqYJQjM8iVhMac1EiEugDTXAgIWGZuVYMl74Lg+7L0KUmBwNqnn2EJaDTpjkBhs9XJQUWVaUl4eiM512MN/2JXtEhEo10S2/5yZH4abnUCFhRSBn9cILiFiNYBXvOHEJxaZDHaOP5xeQoAPlQoGwz55QCuYsEPCIJdH5Yvlcv/nEWNs/MbXGPEKYRgIUALLhuQLcDu0+nq+TU8QiI/E+RU7KFDTy5QFuMTmW8mizw2AZ+EW3SBvBc3OBY++R8XzzIssUw6mH/hbEN9+NGfG+IJag3qKZxZWjkSMcup69IG29+aZavXaEZy5N/LH39gsfQ07XuJ3nr+RsIb00CML4l9p3Y2ihyGmYFaWHruUpUThZ00JfWBnunLl/Z8U/EnUoYmXpmCxhq0Ifz/fm7Kv21956AGkALVnxbtFsckukxSmsZ64j+rjqn6pGJiXKILA9D3INL5l+O/uSitrnnzc4Tl1hh/5d+PMYgDFlEE80S5DN0Ztt80m0EETBNYq44W8ECy2pWLycElnyUDiAVlWYIlOLXF8viNCiISc1/Q2wdF5R1Ge8hlt9neOof4AXzUNacQjagG+JxBNREaGJL/kuJDObNhpBzkEzH2IJWTZXi68FVvF9fhMtAKiig3ispr+i2IfFMOg4vwK/Zf0JcZGBA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3A4816A744BDFA418BF8E475928DE17C@eurprd08.prod.outlook.com>
MIME-Version: 1.0
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4fc0f803-5cef-4acf-90c0-08d78de56ec3
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Dec 2019 11:34:44.3680
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6Qrgaj3CLSfuSlAY+uwP94wiX0CnOiRTM5UI3M+YtIuG40Llf701QQn9qHVObf9TFZ3XZ+kfPDMdeElMBCIzMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB3439
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 30, 2019 at 12:13:34PM -0800, Haiyang Zhang wrote:
> The dev_num field in vmbus channel structure is assigned to the first
> available number when the channel is offered. So netvsc driver uses it
> for NIC naming based on channel offer sequence. Now re-enable the async
> probing mode for faster probing.
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/net/hyperv/netvsc_drv.c | 18 +++++++++++++++---
>  1 file changed, 15 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/hyperv/netvsc_drv.c b/drivers/net/hyperv/netvsc_drv.c
> index f3f9eb8..39c412f 100644
> --- a/drivers/net/hyperv/netvsc_drv.c
> +++ b/drivers/net/hyperv/netvsc_drv.c
> @@ -2267,10 +2267,14 @@ static int netvsc_probe(struct hv_device *dev,
>  	struct net_device_context *net_device_ctx;
>  	struct netvsc_device_info *device_info = NULL;
>  	struct netvsc_device *nvdev;
> +	char name[IFNAMSIZ];
>  	int ret = -ENOMEM;
>  
> -	net = alloc_etherdev_mq(sizeof(struct net_device_context),
> -				VRSS_CHANNEL_MAX);
> +	snprintf(name, IFNAMSIZ, "eth%d", dev->channel->dev_num);

How is this supposed to work when there are other ethernet device types
on the system, which may claim the same device names?

> +	net = alloc_netdev_mqs(sizeof(struct net_device_context), name,
> +			       NET_NAME_ENUM, ether_setup,
> +			       VRSS_CHANNEL_MAX, VRSS_CHANNEL_MAX);
> +
>  	if (!net)
>  		goto no_net;
>  
> @@ -2355,6 +2359,14 @@ static int netvsc_probe(struct hv_device *dev,
>  		net->max_mtu = ETH_DATA_LEN;
>  
>  	ret = register_netdevice(net);
> +
> +	if (ret == -EEXIST) {
> +		pr_info("NIC name %s exists, request another name.\n",
> +			net->name);
> +		strlcpy(net->name, "eth%d", IFNAMSIZ);
> +		ret = register_netdevice(net);
> +	}

IOW you want the device naming to be predictable, but don't guarantee
this?

I think the problem this patchset is trying to solve is much better
solved with a udev rule, similar to how it's done for PCI net devices.
And IMO the primary channel number, being a device's "hardware"
property, is more suited to be used in the device name, than this
completely ephemeral device number.

Thanks,
Roman.

> +
>  	if (ret != 0) {
>  		pr_err("Unable to register netdev.\n");
>  		goto register_failed;
> @@ -2496,7 +2508,7 @@ static int netvsc_resume(struct hv_device *dev)
>  	.suspend = netvsc_suspend,
>  	.resume = netvsc_resume,
>  	.driver = {
> -		.probe_type = PROBE_FORCE_SYNCHRONOUS,
> +		.probe_type = PROBE_PREFER_ASYNCHRONOUS,
>  	},
>  };
>  
> -- 
> 1.8.3.1
> 
