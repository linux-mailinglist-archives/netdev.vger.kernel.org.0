Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03FAC25E371
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 23:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728075AbgIDVtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 17:49:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:48426 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727020AbgIDVtI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Sep 2020 17:49:08 -0400
IronPort-SDR: G79NhZkOQ0rDaqLXGcdoh4Xd3wIBN7riJSLSUpv3UDRoT8YZ8cqXmTpo3nE5/IWoZpjpkSbP0g
 UbXYvxjvVMmA==
X-IronPort-AV: E=McAfee;i="6000,8403,9734"; a="242637124"
X-IronPort-AV: E=Sophos;i="5.76,391,1592895600"; 
   d="scan'208";a="242637124"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Sep 2020 14:49:07 -0700
IronPort-SDR: 3v+Hzz6BuqD9vDePJTCNnHdVz5duBZUccL/99oQdT9ydbnwt3U8FLMuFIlWsbURRW+yJugm6ud
 mer1iAeHbOqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,391,1592895600"; 
   d="scan'208";a="326832665"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by fmsmga004.fm.intel.com with ESMTP; 04 Sep 2020 14:49:07 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Sep 2020 14:49:07 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 4 Sep 2020 14:49:07 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 4 Sep 2020 14:48:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ARpYZgm45ycZyP3ZuYDEBYmh5yRtr5sEYMBDeyzefwaPPr9MCkkNxfVN4jNh2vajPE1cKs6bwR3G+Za56Nlg6aPUa/w02sG01s3j0E7He4UzNLYa17SlelJ2rj0hANg71fPKzdCBjTg8gdJsq7NXvoWbcutMOttq2Dgrh2K1znV/9AzcmfNxyZJfdVC0mBlGJ7XC5+K/ZD+/Sy73nyWdd5W/XmKsYJ44Xfa2fsb3BVwjRwJNMhdUH0DSpNemXZJsRMGdakahx/uqZpfLvS48npsP6y2eXw9I/1ggsHQ9zUc8dlw94ptBg+9qDRnmfLjme/8NeRbRIioLMepulsFKfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAOb1Wcho7A05zHd6hmjLkJeeINgalgxSyExYQ0jq8Y=;
 b=Cs+2QWEZqQnsifwmeb7Y9RmwHs1TiVWU74ufTQlWXrNVuHJ9jPZBmVUrROr9dPJb+uD7XWfyqc1VKP7w37l7EETBQozL+hhjG2mPnZQjRxxsfUfIFi2gqs86auGXnu6BX+VNWUaEzbPtKCQGzTG1uwN169ODCk/Tl2ygLgxVJc59kH8nyCg0a1isO+7r1vU3OMAc9jO2CF0aWwyexzibZZpxUZCcSo7U9BdC7mN6pIjbaVofPIhLbKge/LddIRC87K1QghqZLmK7cCrlaqTM6U5vZ5FEYN/7zLiv9fykSHycRj4NluhGZRj3Sb+x19wzrjuXdOZdtCbTDLslGvaP6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAOb1Wcho7A05zHd6hmjLkJeeINgalgxSyExYQ0jq8Y=;
 b=n3xt4Bz8yybZ7DAjYtLAurqCV/52zPKCbkzg6ojPihU0Ivo/vBj2ZJpHsQMtAyaesT5AMGGOuDREc+g27AXbVaGevcbfDTLQjhWih2WlvfRC+v4LEbEZNDM42OExe0ntNePL5ocPBHxk5mGcxTjL0aCz0x1miI4qUSxAUd00yPg=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB3723.namprd11.prod.outlook.com (2603:10b6:5:13f::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3348.15; Fri, 4 Sep 2020 21:48:36 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::25c4:e65e:4d75:f45f%7]) with mapi id 15.20.3326.025; Fri, 4 Sep 2020
 21:48:36 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Li RongQing <lirongqing@baidu.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH][next] i40e: switch kvzalloc to allocate rx/tx_bi buffer
Thread-Topic: [PATCH][next] i40e: switch kvzalloc to allocate rx/tx_bi buffer
Thread-Index: AQHWd5nJZnupeRG9fEehyGQYRNyHBqlZGp+w
Date:   Fri, 4 Sep 2020 21:48:35 +0000
Message-ID: <DM6PR11MB28901397ABF26EEE1918F17BBC2D0@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <1598000514-5951-1-git-send-email-lirongqing@baidu.com>
In-Reply-To: <1598000514-5951-1-git-send-email-lirongqing@baidu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.215.99]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 97be3532-24c5-4f35-b20a-08d8511c46b8
x-ms-traffictypediagnostic: DM6PR11MB3723:
x-microsoft-antispam-prvs: <DM6PR11MB37230D957384B42C7AF8291DBC2D0@DM6PR11MB3723.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:422;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D83HY05Wv4vyQeM99R6vSHvS9rnRwZgs+wpjXzTlFh0dR2ZhnzEMVy5sJo6KmALNXJPDkSyBia5djO3rWEFetgSfBr8bp9fGZZIl9AjtkFohjWgiEVyYQ8gMcBrylpzc5WVaufBV00jUBavPlz+z+jtEMDcMUfehiBqOChLVtQ97caQb1ANIq2O3X+A8YAcl5eJOaDiiWJUqK2ve1glcag4L/LcoIlr+XJA5kSbhlHsy6ATSp29ErGchUXvnQv8vCuYQdCkodocJS3Fk9GGHikZQsRyx3u4+eJq4LWiv32hrSjujSsq//ZTJtVm+TjopbJAdYJXcsfDagmzxO7JgJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(366004)(39860400002)(346002)(376002)(7696005)(55016002)(2906002)(9686003)(64756008)(66556008)(66946007)(6506007)(316002)(76116006)(66476007)(110136005)(83380400001)(86362001)(53546011)(66446008)(478600001)(5660300002)(186003)(8676002)(71200400001)(8936002)(33656002)(52536014)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OtTn325TeW0YAv0Cz6kFeeXsDxbpkrrjZ4zG1U0RlG7ji7axj9K/d54tmyEL7MjYGtKJhRYs7AtDXU+VP3+qPOAB/NDk1hdi88Lill1ja4xVvczpgDs/e10UBvArXZIdCHUsbbe/4PasTYQ5pw4FYC2EjTNhAIi0CCOjkuYkhUfsRaaJghEGtgPJZJcsiy4QzHO6DEF9pKltyfD1fcFsWB8GL6MG0biQgo94sjnfbq8d/Wjfr3wT0TvAGOqGmJlkiRQwKl5Q1pZR5ogzT8CyYjK8LYJ+tgrPSdlnPacZWISItgIQgfsa8FAfkslJV6EzoArxRgo0HPjakQOC/E0t5zUSu7QIv7WfU2l3aL9Skpb73FQXyB0a1A2faoun9g97uRsZe2dzYtwFFHKdQdEn0cSxot05xWqpO9q3go9p7JETA0h2czrg01lObh5pGcvhEarjjXWbv5nOeIMtIQOz5OmJZn/Y/3azWRdoeFq7VUNMqZb78rT6tcb5Ee/1C9HLtDZWej72IGxJvgOFC08cmTLznToK53IGiRo/r6HMCMu2OPLb6OdNtx7XXcQRKkeJ89+nyHlWYRK/Yw2/JhT9Y7y3AYUoyF5SoyQ6oeR5YjOzaE9vcHjKkwpgXNfIV2gD4uDC89a8bzqeQQPmv+eKrw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 97be3532-24c5-4f35-b20a-08d8511c46b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2020 21:48:35.8369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bH3fN2V8wRdKkCwwkKtLsngPobtrxTj9q0YUVNdJsVJt7sd1XQ9/F3/EvcAXAaFMxG3xbg7H0uzn1v6hbl5tlA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3723
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of Li RongQing
> Sent: Friday, August 21, 2020 2:02 AM
> To: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org
> Subject: [PATCH][next] i40e: switch kvzalloc to allocate rx/tx_bi buffer
>=20
> when changes the rx/tx ring to 4096, rx/tx_bi needs an order
> 5 pages, and allocation maybe fail due to memory fragmentation
> so switch to kvzalloc
>=20
>  i40e 0000:1a:00.0 xgbe0: Changing Rx descriptor count from 512 to 4096
>  ethtool: page allocation failure: order:5,
> mode:0x60c0c0(GFP_KERNEL|__GFP_COMP|__GFP_ZERO),
> nodemask=3D(null)
>  ethtool cpuset=3D/ mems_allowed=3D0
>  CPU: 34 PID: 47182 Comm: ethtool Kdump: loaded Tainted: G            E  =
   4.19
> #1
>  Hardware name: Inspur BJINSPURV2G5Y72-32A/SN6115M5, BIOS 3.0.12
> 03/29/2018
>  Call Trace:
>   dump_stack+0x66/0x8b
>   warn_alloc+0xff/0x1a0
>   __alloc_pages_slowpath+0xcc9/0xd00
>   __alloc_pages_nodemask+0x25e/0x2a0
>   kmalloc_order+0x14/0x40
>   kmalloc_order_trace+0x1d/0xb0
>   i40e_setup_rx_descriptors+0x47/0x1e0 [i40e]
>   i40e_set_ringparam+0x25e/0x7c0 [i40e]
>   dev_ethtool+0x1fa3/0x2920
>   ? inet_ioctl+0xe0/0x250
>   ? __rtnl_unlock+0x25/0x40
>   ? netdev_run_todo+0x5e/0x2f0
>   ? dev_ioctl+0xb3/0x560
>   dev_ioctl+0xb3/0x560
>   sock_do_ioctl+0xae/0x150
>   ? sock_ioctl+0x1c6/0x310
>   sock_ioctl+0x1c6/0x310
>   ? do_vfs_ioctl+0xa4/0x630
>   ? dlci_ioctl_set+0x30/0x30
>   do_vfs_ioctl+0xa4/0x630
>   ? handle_mm_fault+0xe6/0x240
>   ? __do_page_fault+0x288/0x510
>   ksys_ioctl+0x70/0x80
>   __x64_sys_ioctl+0x16/0x20
>   do_syscall_64+0x5b/0x1b0
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
>=20
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c |  2 +-
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
>=20
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
