Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A61E85AF411
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 21:04:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbiIFTDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 15:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiIFTCt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 15:02:49 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4749E8B98C
        for <netdev@vger.kernel.org>; Tue,  6 Sep 2022 12:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662490955; x=1694026955;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=vSFivKZ4Y2e91/6wo0+UgCg3CNwbFSh2gc3WDBuQi4w=;
  b=DAkhSqrwAirtbyOkf577T33MKUYFfP/7xKH1epFjkF7hHcVY4b//gP0w
   eVu8wOj1RaqkZdTKm8FLZORk7czNAgp0t0woTKLaiC9VA6K9s31G8ucPG
   +kj4O+sQ+zevOG7ryyqvnNP5Mt2k1Z6FhMXu8P7Q77UsRj2hz/L95sSOy
   XQxyzOljzpsCx9hMMZkNbPZ9X7aTB7f0rb3KOzZQaeQciJyyJC4CRd0cL
   MSPaHOOjEQqNtCh/PcL4Q5hndOW5iLvsLX+K2aeNpDo9bcVgRCoc1wF38
   V5CHwjEAjLgLd9FvxZakCfYCZI3o7/BCguR5PkiIUmq9Ss6/F+kYfxNDc
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10462"; a="279693521"
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="279693521"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2022 12:02:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,294,1654585200"; 
   d="scan'208";a="565209969"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga003.jf.intel.com with ESMTP; 06 Sep 2022 12:02:34 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Sep 2022 12:02:34 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 6 Sep 2022 12:01:22 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Tue, 6 Sep 2022 12:01:22 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Tue, 6 Sep 2022 12:01:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AjoVMafFYsrwYVacPvR17ArZQe7pyPKSh5QhYQY58KS62GG+ZjykisOPGa9hWY7QSnLqglgl/QIaNmfFG1VR0XitQTrMKaKk/mLRtof5PU3LUs/f4DLqDzLc8W6i6ssOfH2C65AP9NcdmGuNDIq3iSVLw0HcPT6dkGqF75Tyj/4ZpLxLIb6lZwEe1kWkxQfQFdhouLL8xhw2a25MCyQsbdv9pfgzd3AzpIxsXJAQ0XubSngLmVBd7qUmDFVMWnvRb0fIsBXhWX7h402Y9mvZ0McCBkIIqPj7sWr3dwXsUfyUJx51xifYnhMvAP86UAyYRhy0nk0NTSX4el8+L8kgiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BXAG6RP16ppuImuVATnN3swRMZTVLJDjosI9VWHyqx0=;
 b=dolmXRTVVvUJo7wzkkFfXJsibCSNoEkEHcWWImEp4E4r17lj+z5Wzk/nWPxgOGXTkdS0E1lvJ4/fQU9TQ3rnvUHoD/gKDsZbzk7Qm1n+TdoEWocDCNg0zkLs/yxvYSgdYprIaLPnSM7f7BVGEWizMoYeLbgsP1ZB9X+fR4BR1ISPApd9x1OWXHGHyCJfSY1o8Oz2aXe/sQqiZYX2AGYor2E+5mdLV+f7RE5gTOe6zT0N6o62P/ioHxHdvSr/HRZZ7qScXI0rjQjpXihhv5kX49DIIGy6ELzhWWxJoUDWC6tLHiK5qztnPIJo10hNLjlx3h6NJM3A8QnuPXn0JsD0rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SN6PR11MB3518.namprd11.prod.outlook.com (2603:10b6:805:da::16)
 by BN7PR11MB2689.namprd11.prod.outlook.com (2603:10b6:406:b2::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.12; Tue, 6 Sep
 2022 19:01:05 +0000
Received: from SN6PR11MB3518.namprd11.prod.outlook.com
 ([fe80::3425:fb30:45ed:85aa]) by SN6PR11MB3518.namprd11.prod.outlook.com
 ([fe80::3425:fb30:45ed:85aa%4]) with mapi id 15.20.5588.016; Tue, 6 Sep 2022
 19:01:05 +0000
From:   "Switzer, David" <david.switzer@intel.com>
To:     Martin Zaharinov <micron10@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        netdev <netdev@vger.kernel.org>,
        "Dubel, Helena Anna" <helena.anna.dubel@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [Intel-wired-lan] Urgent Kernel Bug NETDEV WATCHDOG ixgbe
 transmit queue 2 timed out after kernel 5.19.2 to 5.19.6
Thread-Topic: [Intel-wired-lan] Urgent Kernel Bug NETDEV WATCHDOG ixgbe
 transmit queue 2 timed out after kernel 5.19.2 to 5.19.6
Thread-Index: AQHYwfDO0NQ/EYug/06aa1AQM5v1xa3StXcw
Date:   Tue, 6 Sep 2022 19:01:04 +0000
Message-ID: <SN6PR11MB35188DA27C2DAF0FEE874A65EB7E9@SN6PR11MB3518.namprd11.prod.outlook.com>
References: <FA05D61D-3E1A-4C0E-BE32-CD427DFEEAD2@gmail.com>
In-Reply-To: <FA05D61D-3E1A-4C0E-BE32-CD427DFEEAD2@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.500.17
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 07496975-2761-4710-c3bc-08da903a263c
x-ms-traffictypediagnostic: BN7PR11MB2689:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pKiE5WAcclVhDEgaHAxZO224Idq4TMXyebUC71FopoTk9HgDf0Jj95Wc8kPL6MfJBistDJnp3GdZ3gt9jsDXby2dokVRjZWIpakJ/z/TxS1fpCqptriIleKPNDbIrLaFCfMiZtC81kNosfp+9RDM9IAK6NeA8lo03DWF20MX/vgbtfHCu+F9Lsx47e4lpnHvD6yxwtmJE7qd6/7QQteXnrzkmu4F8uzUo/roBe0/NzjiwGv7Omse3hfOGvTt7Gb68y4ssYdO8DkM/vbGOTTWrsPyyCGutir6m4lV0D2duG7fXSb8HsXKDF3QtQk6SIgUfHB8VM49q0swKpRWWxH4rEgsLre3B/xUqevj9g8Rzl2C2hAtDCvxyn83WCwEltwT4qz5YV0Cx7AhG4VjVSqdSxFKGfKptJ1ZCrwSg0WlJNX9igicvzxOUIQhPYc3Vk3RAdpXN+7aleVxNvIEFHW0zDS0W7gNs3olC8RXTncMDqs6fKKjs7kjK/S57HuK/HPfvXYvG+PiLg68dH3dfBkZx8F2GqZHcIkYl0q5TemcQ4BqcjznJPPQkyhkyuM07Bc+0wW7eGyZJz9Nz15nHi+9L4es71dlv/e6y+RA8oVqsrUftVQPQbtqrwnQbFrU7+bMzjQXADrzDetQ908jrs+1dBJUeRu0WfR8/p8Yx9BDGgOS2whLyb2Elt/prqO6xf94u53UVP46Xko3WAK7UkAdgzkkRQnFUlV24/pp2uQs16eW7SsTqhS/3mS8IluJJ/vkBh1kIjx0R25Vse4hqp18IzKFzF9kJyRhrNJGMBYH+zHMz61o7Mg+oozoLnThBYtR
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3518.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(366004)(136003)(376002)(921005)(8676002)(82960400001)(122000001)(66946007)(66446008)(186003)(66476007)(76116006)(64756008)(66556008)(38100700002)(52536014)(38070700005)(478600001)(83380400001)(8936002)(45080400002)(5660300002)(41300700001)(33656002)(71200400001)(55016003)(26005)(6506007)(316002)(66574015)(86362001)(7696005)(9686003)(2906002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eqv52LPZNvyK6ZdT4lqDZHo2/4EdEkoUa9GelhkjNFALbN2Br6V96N2Nc+AF?=
 =?us-ascii?Q?u1hYdV2UuaTwEzUVafVf5bVtZ9+HzooxddztP1OS63ByvldVNbRNfibqct79?=
 =?us-ascii?Q?2L58Gz6P+i9/UAm4x1tH6/OBHk+95hx+WLsdv7YO+Hx2f36Zqcb8lQn3eY1P?=
 =?us-ascii?Q?rpQGORShFHHnIGBkmQfDKSrWBoch3yGlbBKdvaMDBTNB17Qy/qLqZa02AT2+?=
 =?us-ascii?Q?8PGbMhjdf31bvt250xJ8OciCv2GRwPH9AuXXnmBgIXi1f4sYTansGrPGfKEL?=
 =?us-ascii?Q?9oQ/LGOMFTFYXgbjnmSTZskvfPUlYZnSkgItUNPluIXutD630qgEMjFrablU?=
 =?us-ascii?Q?RGG/LJcvkpP3Si1Tr/OEq11TBrFQdPHDIhvoOtDjfz6rYxt0bC/Qu6kR+L69?=
 =?us-ascii?Q?3uxO9/3FD/+C5OrZVf8YD2MmQT9k9TXt5+gklzsaTEXQgPDTRgnVQVo7DV3S?=
 =?us-ascii?Q?CzrAF6AiAW/yauXJFx9p3MtSL6csGyG2Q9GkDMfZVzjnlek9DBNpiEeurWBG?=
 =?us-ascii?Q?j2zlTU57Mg4c5kCTLEO9EipG9zNnNSe/b8fdze784L9mScfqgXs8e7nJ5Wn4?=
 =?us-ascii?Q?N5umkvAiZeRTPsCLiiBu4vzdA7dEZ7rT4p6NCpHLmDVSKjaD/q9+heRnrKQF?=
 =?us-ascii?Q?HtcWNuECqnKfYPUZMT5d0s2ptwpaMAG36iSdfRLc1z4EFaVKXCWxLDhMiyE4?=
 =?us-ascii?Q?Xu59Ejj3bgc87k0nTWwR0vgc/NGRApQX1KAvBdtsO7EiIq1cr0JmUo9aPAvY?=
 =?us-ascii?Q?IZ6vTALviYZdx2fF6WrOiMSeM+e1eByhzaorW6ILSYENvppybbEiFKOtvbaa?=
 =?us-ascii?Q?39B6iZNgs5RBGar18nc69EPUkjPg9W7aoPi0Hw5w6rGil6tumLhp9jyKBKCO?=
 =?us-ascii?Q?nWOWpXHGGNwDl22QDVWQPbSqTsKQl10ave9cXRfGVxiHwkvPqe0sux6wovDe?=
 =?us-ascii?Q?CNGsu94/pF5jtD4ZVibvUTp/A9t6G1zUoBN8O71e94ikx+vy28WczzCfQifB?=
 =?us-ascii?Q?yKQykxRewXgXLh3m/9M32X5FZyVkxxS3rK08VZhyEopj9Gmdw/SwO/uXPTte?=
 =?us-ascii?Q?eDDoSym9Wmzi354fR5b/kFkeUwVFFaJdlZaveQtbh/iMvOZq1ZAAVeJTljFy?=
 =?us-ascii?Q?+LgPuEY2F/YXepwjTIP+sJP8dlx3LhXTdGARdQR9XO1F39uBkT0IT0MJojDx?=
 =?us-ascii?Q?TQ2h2BTfivoZnF2WEcFjLIK/xeZanQKQDs3IWHeMvvttv832m9qBdX9Vy7bH?=
 =?us-ascii?Q?uaRFMCSc11PHo2H+OwIVMajLq3/67AWV+Ru9vwjan08qshZxL1TyXOXwHfSb?=
 =?us-ascii?Q?G981WVYNpKk73uh4fCpoklFjmDdsI+hombkrZVuV9ZUr8bFkW0VOhlIwg91M?=
 =?us-ascii?Q?i+wk1mp5o5QcuHTSHIjm/Leys0WOeTizH1OOjWT6x99FSO+lj9g/H/GioEF7?=
 =?us-ascii?Q?4O/IkQuW2jmd6es9FlWWMk7d3+K9o7VPaXVMDh07yuskPpmFqk0wkx1xnDi9?=
 =?us-ascii?Q?MzZ9c87y7N85E1scdTIHIZrgo3bBVmnbAzqNtBIvYx4c8l7CJaS6MAiw3O0X?=
 =?us-ascii?Q?axU2JhPls1JzS7V5w2Go4h9ULZmoymtbLYuWYcrA?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3518.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07496975-2761-4710-c3bc-08da903a263c
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Sep 2022 19:01:04.9584
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hffvAbN2BXjyT4GjxhnEgej8pfMZS57I7YAh70rZnZVJ7cqElc4836pZSw2goF9Wl7vexSvTW8Vyk88CMWOXRA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2689
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
>Martin Zaharinov
>Sent: Saturday, September 3, 2022 2:54 AM
>To: Eric Dumazet <eric.dumazet@gmail.com>; Eric Dumazet
><edumazet@google.com>; Fijalkowski, Maciej
><maciej.fijalkowski@intel.com>; Brandeburg, Jesse
><jesse.brandeburg@intel.com>; David S . Miller <davem@davemloft.net>;
>Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>;
>Nguyen, Anthony L <anthony.l.nguyen@intel.com>; netdev
><netdev@vger.kernel.org>; Dubel, Helena Anna
><helena.anna.dubel@intel.com>; intel-wired-lan@lists.osuosl.org
>Subject: [Intel-wired-lan] Urgent Kernel Bug NETDEV WATCHDOG ixgbe
>transmit queue 2 timed out after kernel 5.19.2 to 5.19.6
>
>Hi All
Hello Martin!

I'm Dave, a driver validation engineer at Intel Corp.
>
>
>after move to release 5.19.x (2 and up to 6 ) start geting this bug report=
 and
>machine reboot automatic after that.
I'm sorry you're having this issue, I'm working on reproducing your issue s=
o that we can have our developers look into it.

I will reach out to you if I have any questions.

Have a great day!
Dave
>
>With kernel 5.18 this problem is not happen.
>
>Machine run with 2x 10G Intel 82599 card in bonding .
>its a simple router with 6 core cpu.
>
>Sep  3 10:05:39  [193378.949952][   C10] ------------[ cut here ]---------=
---
>Sep  3 10:05:39  [193378.949965][   C10] NETDEV WATCHDOG: eth1 (ixgbe):
>transmit queue 2 timed out
>Sep  3 10:05:39  [193378.949980][   C10] WARNING: CPU: 10 PID: 0 at
>net/sched/sch_generic.c:529 dev_watchdog+0x167/0x170
>Sep  3 10:05:39  [193378.949992][   C10] Modules linked in:
>nf_conntrack_netlink nft_limit pppoe pppox ppp_generic slhc nft_nat
>nft_chain_nat nf_tables team_mode_loadbalance team netconsole coretemp
>ixgbe mdio_devres libphy mdio nf_nat_sip nf_conntrack_sip nf_nat_pptp
>nf_conntrack_pptp nf_nat_tftp nf_conntrack_tftp nf_nat_ftp
>nf_conntrack_ftp nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
>acpi_ipmi ipmi_si ipmi_devintf ipmi_msghandler rtc_cmos
>Sep  3 10:05:39  [193378.950023][   C10] CPU: 10 PID: 0 Comm: swapper/10
>Tainted: G           O      5.19.4 #1
>Sep  3 10:05:39  [193378.950028][   C10] Hardware name: Supermicro Super
>Server/X10SRD-F, BIOS 3.3 10/28/2020
>Sep  3 10:05:39  [193378.950032][   C10] RIP: 0010:dev_watchdog+0x167/0x17=
0
>Sep  3 10:05:39  [193378.950037][   C10] Code: 28 e9 77 ff ff ff 48 89 df =
c6 05 95
>3d c4 00 01 e8 9e 5a fb ff 48 89 c2 44 89 e1 48 89 de 48 c7 c7 f0 d0 ec a7=
 e8 c2 c2
>13 00 <0f> 0b eb 85 0f 1f 44 00 00 41 55 41 54 55 53 48 8b 47 50 4c 8b 28
>Sep  3 10:05:39  [193378.950043][   C10] RSP: 0018:ffff96320030cee8 EFLAGS=
:
>00010292
>Sep  3 10:05:39  [193378.950048][   C10] RAX: 0000000000000039 RBX:
>ffff898a4da00000 RCX: 0000000000000001
>Sep  3 10:05:39  [193378.950053][   C10] RDX: 00000000ffffffea RSI:
>00000000fffbffff RDI: 00000000fffbffff
>Sep  3 10:05:39  [193378.950057][   C10] RBP: ffff898a4da003c0 R08:
>0000000000000001 R09: 00000000fffbffff
>Sep  3 10:05:39  [193378.950061][   C10] R10: ffff89919d600000 R11:
>0000000000000003 R12: 0000000000000002
>Sep  3 10:05:39  [193378.950065][   C10] R13: 0000000000000000 R14:
>ffff89919fca07a8 R15: 0000000000000082
>Sep  3 10:05:39  [193378.950070][   C10] FS:  0000000000000000(0000)
>GS:ffff89919fc80000(0000) knlGS:0000000000000000
>Sep  3 10:05:39  [193378.950074][   C10] CS:  0010 DS: 0000 ES: 0000 CR0:
>0000000080050033
>Sep  3 10:05:39  [193378.950078][   C10] CR2: 00007fb39f41d000 CR3:
>00000001002fd003 CR4: 00000000003706e0
>Sep  3 10:05:39  [193378.950082][   C10] DR0: 0000000000000000 DR1:
>0000000000000000 DR2: 0000000000000000
>Sep  3 10:05:39  [193378.950086][   C10] DR3: 0000000000000000 DR6:
>00000000fffe0ff0 DR7: 0000000000000400
>Sep  3 10:05:39  [193378.950090][   C10] Call Trace:
>Sep  3 10:05:39  [193378.950094][   C10]  <IRQ>
>Sep  3 10:05:39  [193378.950098][   C10]  ? pfifo_fast_destroy+0x30/0x30
>Sep  3 10:05:39  [193378.950104][   C10]  call_timer_fn.constprop.0+0x14/0=
x70
>Sep  3 10:05:39  [193378.950110][   C10]  __run_timers.part.0+0x164/0x190
>Sep  3 10:05:39  [193378.950116][   C10]  ?
>__hrtimer_run_queues+0x143/0x1a0
>Sep  3 10:05:39  [193378.950120][   C10]  ? ktime_get+0x30/0x90
>Sep  3 10:05:39  [193378.950125][   C10]  run_timer_softirq+0x21/0x50
>Sep  3 10:05:39  [193378.950130][   C10]  __do_softirq+0xaf/0x1d7
>Sep  3 10:05:39  [193378.950136][   C10]  __irq_exit_rcu+0x9a/0xd0
>Sep  3 10:05:39  [193378.950142][   C10]
>sysvec_apic_timer_interrupt+0x66/0x80
>Sep  3 10:05:39  [193378.950149][   C10]  </IRQ>
>Sep  3 10:05:39  [193378.950152][   C10]  <TASK>
>Sep  3 10:05:39  [193378.950155][   C10]
>asm_sysvec_apic_timer_interrupt+0x16/0x20
>Sep  3 10:05:39  [193378.950160][   C10] RIP:
>0010:cpuidle_enter_state+0xb3/0x290
>Sep  3 10:05:39  [193378.950167][   C10] Code: e8 d2 0d b0 ff 31 ff 49 89 =
c5 e8 48
>68 af ff 45 84 ff 74 12 9c 58 f6 c4 02 0f 85 cf 01 00 00 31 ff e8 81 b4 b3=
 ff fb 45 85
>f6 <0f> 88 d0 00 00 00 49 63 ce 48 6b f1 68 48 8b 04 24 4c 89 ea 48 29
>Sep  3 10:05:39  [193378.950402][   C10] RSP: 0018:ffff96320014fe98 EFLAGS=
:
>00000202
>Sep  3 10:05:39  [193378.950411][   C10] RAX: ffff89919fca6800 RBX:
>ffff898a4206c800 RCX: 000000000000001f
>Sep  3 10:05:39  [193378.950418][   C10] RDX: 0000afe08b9e69de RSI:
>00000000238e3b7a RDI: 0000000000000000
>Sep  3 10:05:39  [193378.950424][   C10] RBP: 0000000000000001 R08:
>0000000000000002 R09: ffff89919fca5704
>Sep  3 10:05:39  [193378.950430][   C10] R10: 0000000000000008 R11:
>000000000000010b R12: ffffffffa8222f40
>Sep  3 10:05:39  [193378.950436][   C10] R13: 0000afe08b9e69de R14:
>0000000000000001 R15: 0000000000000000
>Sep  3 10:05:39  [193378.950443][   C10]  ? cpuidle_enter_state+0x98/0x290
>Sep  3 10:05:39  [193378.950451][   C10]  cpuidle_enter+0x24/0x40
>Sep  3 10:05:39  [193378.950459][   C10]  cpuidle_idle_call+0xbb/0x100
>Sep  3 10:05:39  [193378.950468][   C10]  do_idle+0x76/0xc0
>Sep  3 10:05:39  [193378.950476][   C10]  cpu_startup_entry+0x14/0x20
>Sep  3 10:05:39  [193378.950483][   C10]  start_secondary+0xd6/0xe0
>Sep  3 10:05:39  [193378.950491][   C10]
>secondary_startup_64_no_verify+0xd3/0xdb
>Sep  3 10:05:39  [193378.950499][   C10]  </TASK>
>Sep  3 10:05:39  [193378.950504][   C10] ---[ end trace 0000000000000000 ]=
---
>Sep  3 10:05:39  [193378.950513][   C10] ixgbe 0000:02:00.1 eth1: initiati=
ng reset
>due to tx timeout
>Sep  3 10:05:39  [193378.950525][T1766094] ixgbe 0000:02:00.1 eth1: Reset
>adapter
>Sep  3 10:10:02  [   30.021823][  T454] ixgbe 0000:02:00.1 eth1: NIC Link =
is Up 10
>Gbps, Flow Control: None
>
>
>
>_______________________________________________
>Intel-wired-lan mailing list
>Intel-wired-lan@osuosl.org
>https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
