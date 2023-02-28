Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06B246A5F11
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 19:54:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjB1Syg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 13:54:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjB1Sye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 13:54:34 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A997F2F783;
        Tue, 28 Feb 2023 10:54:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1677610469; x=1709146469;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ehnVYwdr0edVk+FTypZSCJTbeOY85c6NxmF3vwCPVkE=;
  b=COOGe58ww9q7sD17tVE712piS5P/e9UMhZalJEGHbRwrdSoa5Zdgjw0e
   h2oC3mcy1aeUlXTDaztWbGWPfObK011Y4qVa+0NskKDTRlfH5d2jJKvGD
   s3U+jYn3dLvIzCaTdMRjoRxS4y6RcuBnFzz7wcJCPQaGoSsi7M5zGxdlQ
   ovAQo/MTXo6++8h0sGfcwMAbimgUOsa7/9Gv8C7qt0hngPtEicZj5hcZb
   qozaCaKVj+5bzfbT1eVcCW4dSh2FDVHzUe843315018fWhYxMQx9x83iT
   CrpiwXxxmu5VN5GdLocCtz2HCiCh9rwEmB4jv1KksaHw83uxduFIepgNH
   A==;
X-IronPort-AV: E=Sophos;i="5.98,222,1673938800"; 
   d="scan'208";a="202946509"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Feb 2023 11:54:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 28 Feb 2023 11:54:26 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 28 Feb 2023 11:54:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QwwDFsJRj2BYsxbNbf5qCjBTCF57Od8XsHRcP2aZE0yFEnGEmA8jXcPDrz0nCqA2C/VEMPULD0TarN/5hwUU7dCuBm/t0caSlYJQa+OkVdhjpClTD/C8zxDSEu7UqK/GtVPmJ+PWy2/vhx6Xh+MD9QytouDZzX0ut7DfEnMvCAaih9ZtCPgwTW+B9iGBU2kD9AJrXi6O0yjULjjghr0GQgnKp/rPD2cmmkxV2+R3VaP3aZnh7NCEYTM87m7aZ4WhPqTeEsKCda2nJr3ar6G7/jWJGYFaJ87yknxF7SysFLhGEtQhWOYifYOlFeCHyJ+lGu/ZBcFvgYtVj0S8PY/zlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MBlUTinV7spN+Z1nwN8DkvzV+KRUo3O2yxqVkoHblDI=;
 b=FxIEv52RuUGXjac/o89HhfuDJwC3e55P2d/0DRZqAfhnlVrH2mASVu4M3kqpf/NnMtJ+KCbpUTN65AXJdlys8iQ2tCdVL9cP0IovbCGn+iSt7ZF0y79OUktZ2/YfmQIt58JHOsIwvXQ9Fh65J/F+tABAvzndB5kLb7sB5HAzqOVKc7+1IWuKo0J4H7IOhSdQr25gDn5ggT5HxoO7YPnOJIXnqIvH/y14qNeKwQlfAZp+sRxdWhkrHgJnpFGRPEr0bUOQ9Ix4olzhgqqEeen+VLOoey85AHTU8IatFuu+o0G1Jf6qYC5jp9sn6Z4LKKvGIUD3q5rkXe3YJHpvT9qBuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MBlUTinV7spN+Z1nwN8DkvzV+KRUo3O2yxqVkoHblDI=;
 b=sGL8ky7oNoTu8OwysA9BNF/Vfpi6s5QrnFrDRoXgd3TLyW8AghIw1DbdVlgJi87bqLC60hrD/tKCnOvaL4x1D2k+D7DMcHi1hfOl8kJ2vtmRxktguUVwGgshDr6l/8YRf8TyHxWlHoCY8LV08V7AKRzS2jsQvz6dkKGAx/wa6do=
Received: from BN9PR11MB5558.namprd11.prod.outlook.com (2603:10b6:408:103::19)
 by IA1PR11MB8174.namprd11.prod.outlook.com (2603:10b6:208:450::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.30; Tue, 28 Feb
 2023 18:54:23 +0000
Received: from BN9PR11MB5558.namprd11.prod.outlook.com
 ([fe80::9ba1:23a1:1883:b0a0]) by BN9PR11MB5558.namprd11.prod.outlook.com
 ([fe80::9ba1:23a1:1883:b0a0%9]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 18:54:23 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <andrew@lunn.ch>
CC:     <enguerrand.de-ribaucourt@savoirfairelinux.com>,
        <Woojung.Huh@microchip.com>, <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>,
        <davem@davemloft.net>, <UNGLinuxDriver@microchip.com>,
        <linux@armlinux.org.uk>, <edumazet@google.com>,
        <linux-usb@vger.kernel.org>, <kuba@kernel.org>
Subject: RE: [PATCH v2 net] net:usb:lan78xx: fix accessing the LAN7800's
 internal phy specific registers from the MAC driver
Thread-Topic: [PATCH v2 net] net:usb:lan78xx: fix accessing the LAN7800's
 internal phy specific registers from the MAC driver
Thread-Index: AQHZQtEV706iWMvdfE2bwz1LWDBCB67TMPwAgBGVUOA=
Date:   Tue, 28 Feb 2023 18:54:23 +0000
Message-ID: <BN9PR11MB5558A96F351417E0896939858EAC9@BN9PR11MB5558.namprd11.prod.outlook.com>
References: <20230217130900.32757-1-yuiko.oshino@microchip.com>
 <Y++NuMM6EKvtBzeq@lunn.ch>
In-Reply-To: <Y++NuMM6EKvtBzeq@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5558:EE_|IA1PR11MB8174:EE_
x-ms-office365-filtering-correlation-id: 45e5978b-5db7-4fca-a9fd-08db19bd3507
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2Lr5BClw4jdaiQ35o+hd56u5BTt6RBF4bGow9BCAh2N29HC1O7TS+3tB2mBmxIKFdPjtpLnwpPcAFo0Lc3k9+7XnYod/CLDx4c6eM+7lnpNjt9bROJ/5QfAaFdiUQO+Aw4VYvbYv52st0koV3fsbS7XTpbc5URce3hWOKV4xY0j6GE6KwqiGc/ayM52sUzKCUyJxluOxfCIa/xvWz8FM0q1xUnLUYdZdp0sUSZUHMlPHnzpennNuWWCAY3HkakEzIbj8cN1Xe123dLgahX79+8SAEOJImlgOunns9lN7CIYMHNYmna37P0h9BYSToS+1v5g8nRZ0yJ/S/W3CXpfJy0c2GV2NngeMvpv9iquOAAt0XSwsjlQu4b52wupNUUkJcWOD9f574JnjaEcUEnFpJWiZkvUssRUVLn33o/fFgGH3Posj7tK9Gl7/O7dGzp51xWZkhAt6Sf8PpVAbUr6m3M9jO6ctr/G8PVM2YraPuTY/2V8J5HiYZN++/t7SZ8GUspOFoopfdk/1VucEfNdCuRN6Aj/7EbzmAYKmCmcEHxZRe2ej208HTOQQ6Y8REBRbproOcJ2+8RzBnutBAk6f3xXEeNABeNhpZ5bH2Jt6hGZNxxIcgchPiRlGskCfbRun9lIabVMaxfQgTt3uH9O3Skm49tjC4TtIqO1Go3fh8VZ3GrpwSNISW6TREkwUjOmJA+26F7QC9658CvQbQmFPtw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5558.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(136003)(39860400002)(376002)(396003)(366004)(451199018)(33656002)(38070700005)(86362001)(52536014)(55016003)(41300700001)(66556008)(66446008)(64756008)(66476007)(5660300002)(66946007)(7416002)(8936002)(8676002)(2906002)(4326008)(6916009)(122000001)(38100700002)(7696005)(71200400001)(478600001)(54906003)(316002)(26005)(83380400001)(76116006)(186003)(9686003)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ryt26ogufI29NJWbhTvTVvsUyClVl8mpFcVXzJPHg28yCUmuyQcauQ4l83HS?=
 =?us-ascii?Q?QHbcce/RQwnOhiPJzTS/IFEO7nvDnLFHoeHQ9rqcgb9JOmITcOBcqhj/K5iL?=
 =?us-ascii?Q?QI5CdqcbHdhPXUuZgQhTfAaWC43ab9ulhcctf2mSnrMmoxiPe2XaxdXPSnUC?=
 =?us-ascii?Q?P4aOG3H89/faeIPD+8/AOvRmWBdMchO+sKvdqrOJbfkdr6Oo0kD/MZnYevKM?=
 =?us-ascii?Q?5Gj5wO9/FVToFrQPzAuGxfFL/kBKIPXZHvoNIX1oyrtU3Vvz2ufIMqNdNVSX?=
 =?us-ascii?Q?tvtG2SChEWjw7On+7qoxyyi+zM6AV9V5z0afqqQMeVIchbAYdxxQ8waYwgRh?=
 =?us-ascii?Q?tjE2pmeMN6GkQbMGchaMZsjpzwYDYrbOaTS3y7owj93HtrfR6NcLnaqtQATQ?=
 =?us-ascii?Q?BP9mFyBYFapghKFtnxsy/u3uEV9wn48+VhZrWq9yk0+yetRmZrWynRNAbFLN?=
 =?us-ascii?Q?do13h6lXCtTF18GnqpEp/ZSsp4HrGM8sV8WlkJwiAXa6WmXdQYAc6WbNcEfo?=
 =?us-ascii?Q?AnKY4z08YQcdNPE3gy4wv7/milCFYysp8GvqFS2oJHOFUEre98THAJH8m70R?=
 =?us-ascii?Q?g29sWqgZpSJTf/b4/0cYQj2J93J1e0ZO5t64vXxw+4FGlyqFurNP5y5CUmRe?=
 =?us-ascii?Q?x1tGbrEGOgRCz5S5kIYhqJJhZa781P/9sbjTYqHzMVphrG393E/pj/XvROq3?=
 =?us-ascii?Q?kJFliqeeEr7xTsfwE1kPYDLRH3DvMn400unUZYqqPxEahsFvkHZQ7ByPlQWB?=
 =?us-ascii?Q?iPEqb+ySt7i3JuzJeIFBmGMaYxse+dsy444ztAUOSEf9wbNE4tXj8VKr7jgZ?=
 =?us-ascii?Q?W8VAOCedPRCSDtrFFY5K+etvJpPbIW+pjGH2qxRWdsMOOnXtQdpVXOXa/nT7?=
 =?us-ascii?Q?skOgt3wTXucTi3ESH1B/eyRN/xXgUQjc+eaYV4M3anMA5zwC0f/fyuLRMmC8?=
 =?us-ascii?Q?iZRvqgZY+XgzLN1mbpUDNg3eJQiKQ1mtR61s/R5S8277m6asqYLjW1Hrpy99?=
 =?us-ascii?Q?3kYb3vxcRJ/txDlTZdodimFNsLbfNjXvIl4/FZJmL/+VPYYFnuWB2yaiqAzU?=
 =?us-ascii?Q?kGTsQB92mqMpkX/twJPuZnE7KvVwZMay2X1eNCh31cFiJDtQbXw8zlehOrAF?=
 =?us-ascii?Q?pE5HpRVZwhrSq5EqN+O24Y5EiiPcrpjfvVENuKgzoDbrhq5Yl+/tBowQZMLE?=
 =?us-ascii?Q?b97GZ9age3COK8uz3dkP69pWlpKUzD3Pg3vJPvwyHg3VisRqfzWD5M/He73u?=
 =?us-ascii?Q?a+BlmJ+qF4NsSHeLLJjozJudPYqRXoNejMFvosxunltBxgRuRIzkWurcFjEU?=
 =?us-ascii?Q?NAfhIprlbxbTwDoiC5Voi5t3TY0/eFXxPl+PKZi+ZE98IDCuRxdG/+YRr9Ln?=
 =?us-ascii?Q?56tycHqWhLbOxSJgWaQUprei3OScsZjcHTZIoLxURUwrNO4JhRPC34j0eQcV?=
 =?us-ascii?Q?upDdnM80gP6XPzpVKmhn3nvKt2lDx+rte9r30xuaTLbkTbgAX5309r+FVR6R?=
 =?us-ascii?Q?71gfPvRyUxz35btNnohSBf9ORVcMebcFvJktwsheGh0c29U4ck3BB7r73E7F?=
 =?us-ascii?Q?8cREM/2/c8AueBf7pu+47gHMXBcU/tU/SybLn+dd?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5558.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45e5978b-5db7-4fca-a9fd-08db19bd3507
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 18:54:23.1639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F52/X0W7B4Zlzz7Q3Qq24WrTUPqW0XxOVV4+OsC6wqfnhb6r90J2FGr+rTYrmN1SKHVwbhjXHUaUpOwwu9bDb0wz1uvi11z/weyGjfqnZ4c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB8174
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Friday, February 17, 2023 9:23 AM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: enguerrand.de-ribaucourt@savoirfairelinux.com; Woojung Huh - C21699
><Woojung.Huh@microchip.com>; hkallweit1@gmail.com; netdev@vger.kernel.org;
>pabeni@redhat.com; davem@davemloft.net; UNGLinuxDriver
><UNGLinuxDriver@microchip.com>; linux@armlinux.org.uk; edumazet@google.com=
;
>linux-usb@vger.kernel.org; kuba@kernel.org
>Subject: Re: [PATCH v2 net] net:usb:lan78xx: fix accessing the LAN7800's i=
nternal
>phy specific registers from the MAC driver
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>On Fri, Feb 17, 2023 at 06:09:00AM -0700, Yuiko Oshino wrote:
>> Move the LAN7800 internal phy (phy ID  0x0007c132) specific register acc=
esses to
>the phy driver (microchip.c).
>>
>> Fix the error reported by Enguerrand de Ribaucourt in December 2022,
>> "Some operations during the cable switch workaround modify the
>> register LAN88XX_INT_MASK of the PHY. However, this register is
>> specific to the
>> LAN8835 PHY. For instance, if a DP8322I PHY is connected to the
>> LAN7801, that register (0x19), corresponds to the LED and MAC address
>> configuration, resulting in inappropriate behavior."
>>
>> I did not test with the DP8322I PHY, but I tested with an EVB-LAN7800 wi=
th the
>internal PHY.
>
>Please keep you commit message lines less than 80 characters.
>
>> Fixes: 14437e3fa284f465dbbc8611fd4331ca8d60e986 ("lan78xx: workaround
>> of forced 100 Full/Half duplex mode error")
>
>Please use the short hash, not the long.
>
>The Fixes: tag is an exception to the 80 characters rule, it can be as lon=
g as it needs
>to be.
>
>Otherwise this patch looks good now.
>
>          Andrew

Thank you, Andrew!

I will do v3 shortly.

Yuiko
