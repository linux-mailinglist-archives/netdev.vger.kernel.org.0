Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C593043E4DB
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 17:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231490AbhJ1PTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 11:19:34 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:2676 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231480AbhJ1PTd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 11:19:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635434225; x=1666970225;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OG6yaMqLqtCuNJ+NeiEtgQWdg/+6pkJ0dXVRA84okjc=;
  b=V+sWb6RNxf8oeXi7uprrd+8hhYc3OT3CZH0AlsuwHSNyzZHK+o4Bs3Wk
   mxqD3HeR67qxOSQ/G1E5CuM/yZHI+VmkTwixhEPKzqOIwMobIxjfxE7q6
   /6XkHImY+SlwCeKHpqsx9btDHLFVyuertlUSU/yL+/hm+5iTspYqBFfjV
   dkq36Dr1UxbG2I+Eg32QiMREYm4CcI+fIb+q0g2qMr6LLF58DqCavNZuc
   oExu+q6cgOJ0ayxcgLxapmxzHJ3xUV6pc6s10KYd95xQUPCLviXOOVdx0
   hirAP8TGmj0VfHKiFyMXYrGhI92eyLEqRCMRpAowE4UezHf1BJbTplzhp
   g==;
IronPort-SDR: Ry6QqlEkLaI7nMxnDjwf60qXJHVmTc7X8BXWV3bYT4M6bUzHvGLABJF+BGP2D8+MLfFbTfHf1x
 /yjz3Tm1Hhxc3HGt5X87GvrM5e6kQ8l3d3JQLmqVoB+/RQvxzwTioH0MHuoowL4hGZLGCWhYXS
 Ak//hfZHw9qqPpcUfLlpdw3Od36cP+Zm7pwNAPuIBQBaZbD4Bu2v9JcToTq1yRDHs4dyhdLEO8
 oeU7e8BCYGTZfCW5pNgLQQcaFEt9TSZrTdzzA2cvIxGRoVfWzGR3aLvo2XHw/E8vJXVb7Ec4KR
 bfVBRpv4zoU8l6b/LQSAn8M7
X-IronPort-AV: E=Sophos;i="5.87,190,1631602800"; 
   d="scan'208";a="149893057"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2021 08:17:05 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Oct 2021 08:17:05 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14 via Frontend
 Transport; Thu, 28 Oct 2021 08:17:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsRhB9w59N34H9l33Pm417iRJjV919Ly+iddnBhtg5PBnXI4zv3BRUpqd28lIfII6or0axXZ52hFHHIpiD5kG+6H29j+pgedEUQyqUN6ZrSQAED3Hq4zHiu8WewrmbHMjrN79Poovt4rRIp52uctggxdc9Bch++sQs9eJfanNtXRc+8HJy7opyiYJyik4uhNfHrJRBTrUn0G80EpyTW/PSUQCfhAsIZg8tL2lOBuUbo30weBGnhVSRLq7qEepdb5s2BcX6ZU2WKZ6FJEAzaceL5WY1klA2vNYVBIGOeuujx2MUPaVsbiltMSLD/1ypmVNgDcHNHaLHfUkjf3e06z5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OG6yaMqLqtCuNJ+NeiEtgQWdg/+6pkJ0dXVRA84okjc=;
 b=mIgBwqLtwUpT4MdgZlnP8HLP5Chc+Ku1lu2xyhqXqWrk7VmWtg0zURxSQ330bmQv4ZIqdsyecCp+GGGkb+EBoUTFphchT4Rjw7HgemqY7g712TBIJbiyDpi+ytM4ErLqp8dkeSv4PF1wk1iEZCE8LsotRR3mvVJWU29yLYq52UI2M2Q/APNxenPePHmfkyLckY5RR0IfhtNHoI/wBcrkAvyS3r0iQtDkgcdWQ3GHUqU4/OhqCDfl0d0eUWQvI9WobSzJabrmlFCMxtk7SMu0Wv4BqYtJXp86nc1gfshB1XLG2TayP++VzIprpC3ExYzZPUrFyTBmK03Rh94pLVfx8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OG6yaMqLqtCuNJ+NeiEtgQWdg/+6pkJ0dXVRA84okjc=;
 b=p3REr7nmNL9a3JRkwHdF0Pvz22Z45jwCzt9RGzqQBk3PCRjNnnEKw+ginKYDaNDtc0yqW8SdTQzVxFvhw2Vax3sBFX3vUk1qwLLGXZF9Zb1p3BzCLN2zkUNrHlPnuD+YxaUj8WJ6dbPwHsOwTXhzvfNHyw1EYcJBHvuj4tpfMF4=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Thu, 28 Oct
 2021 15:17:00 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::4907:3693:d51c:af7e]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::4907:3693:d51c:af7e%9]) with mapi id 15.20.4628.020; Thu, 28 Oct 2021
 15:17:00 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <kuba@kernel.org>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <Bryan.Whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net] net: ethernet: microchip: lan743x: Increase rx ring
 size to improve rx performance
Thread-Topic: [PATCH net] net: ethernet: microchip: lan743x: Increase rx ring
 size to improve rx performance
Thread-Index: AQHXzAzaB7qTyZBseU2ukQ57dom3rKvohLEAgAAAmLA=
Date:   Thu, 28 Oct 2021 15:17:00 +0000
Message-ID: <CH0PR11MB5561200392EC2B25B0D10F0E8E869@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20211028150315.19270-1-yuiko.oshino@microchip.com>
 <20211028081344.2e6e9415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211028081344.2e6e9415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e1eb803d-283c-419a-3f63-08d99a25fd81
x-ms-traffictypediagnostic: CH0PR11MB5561:
x-microsoft-antispam-prvs: <CH0PR11MB55619AC926D5F8884B5A942A8E869@CH0PR11MB5561.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Nk6TG7hgSIubVUvjgKoITJKpaqTvELH+T1FicIuKO9Gt4dHoU3o8Jd+cCPBfhtEbdtMH70KP3nLW0qS8egmG8heI4vjF8B4HPp/tWDA8gVhweJgWxk6akVJ9mz7hJs6sqE+ei9LmVyzz/X3a4D5yGR2AEb+W6IRibDcyADeUyCmlFqHHCNAk5C8o4pUHT4hJt1LjE02HHfYMXyD4+S8ucr+F6uX4QZtcgoBJNUb9rhemzMSDhF6aT1LqVc1ZMzdn+EmglRPbUHjuA5ONd5byaAGknwn9MVuKi72lTdGifLZbCo4sDuuIECXM3W+YSbpT5SgcEqemuZTcEyumRa1bVdZdkyW0mpW/IKRiclePsO/EeqyXPdGLjVDNMKaxQoUbJOuZujtISyy3Vr+SrmLAQ/T2x2ziXyvGFqGNeIvuSvETFSFPNkO1UsTuPOkowrdCHlIWscgVPVSjA8HVgLCS2yoAVYbG3w8zrAk4j9K+LsOHZ4GMwR9UtY3gh3H1h5u0+AiyW+6FUDqjrJ1kHEFe0qE1NIHiFfOdPxzC9hIpne3Os6WCaHa3trkr3atg785gV0z+7bymPh0u/fOLmNlvV2oGJVYxoRVHJK3olkFBLrXA9VeZH/4j5oOZ8hgN5Z5htj/EOJBYcUzJoKU3iUW2hpdk7AZEU9SZcpOlbqa2RirZr2LgXw46TsoH9LgAFoqzZNDb4YzQel8zbq2pxkTM+g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(83380400001)(76116006)(66446008)(66476007)(64756008)(54906003)(52536014)(55016002)(66556008)(66946007)(107886003)(122000001)(38070700005)(86362001)(2906002)(316002)(4326008)(7696005)(38100700002)(8936002)(6506007)(9686003)(6916009)(33656002)(508600001)(186003)(5660300002)(8676002)(71200400001)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?p5FjK0pPzoF5ltXkRga9SVkZ1YGOUzM8wi7JDNOOFl0Pg2k2MIETquCDYU7e?=
 =?us-ascii?Q?dAtiLfKAUbYZxkH0FtKMU/pg1NjXO0KytStt6FuZq0AnYSeEkF7/l6TztRs4?=
 =?us-ascii?Q?qE1wHS3Z0vvAWGZms759SiWJBAHHf+4dWVG5D+RFNlBXFX/G5vTTa2VXBat2?=
 =?us-ascii?Q?tHJRSgnuupfMftgtcRHMiUFXNbF31m6hehtpsgXbpIZgQeeQ05scwXukqG34?=
 =?us-ascii?Q?kfSBee4rWSc5HCRtzfIEyKryXbn1U12FG553JLCpbE65EMjPwho/HSO91o/J?=
 =?us-ascii?Q?ig4AeZebu46gIohhvCamtQGVVhCHyLChi+6Yp0Z+Ieb7hX2S81BcIUxdf3kc?=
 =?us-ascii?Q?C9ixG7hpRfqu/MvfYY26GKVWfl3GoowfWS36quAOJzuEyzSKZtFoke2pFbgc?=
 =?us-ascii?Q?7iIXb/hmFgDbzG2Z9UOuIkE8jOb/zsShxxnAYPYgV1KCcvMNNdITXDyLBP62?=
 =?us-ascii?Q?IojKIXiCpdhgSrdYsfAsEWdVlbOPCwvD9ej5FzbwOc/zUG8EpD724WvzVbrp?=
 =?us-ascii?Q?XuFAwlrwaY2pvOuOSCXUxlQCfRQWBQQtwafMOZyWME6OFs5lVs03QKXE1WMO?=
 =?us-ascii?Q?1AAEyliLL1YW92ISRCabg2WrTNd3xQPiJL4cNSLiQvt15yUn0ix6/XtbvH+1?=
 =?us-ascii?Q?2QPOZbMRBmneyXrYhhcRFJRuVUPbBTOQ7ZXg4Mva4NVcSbMfaWXq8T/vci0i?=
 =?us-ascii?Q?elv32aSekieW80GKGUFi7CeMzsNx2jrCkRUzLnXHHm+c0JwDcEMAMn61xBSM?=
 =?us-ascii?Q?7XmnbzjhQbWjyFUtHkvPyC+O+lkWcPjkPW+I+4nfNdRIESxrdhVy29oMJGhg?=
 =?us-ascii?Q?XU7yaUmvi0E0pJy6sLl+zpLhJRlGxqBP9bMbjDhTF6t16rFVtJmw+CdPe6iy?=
 =?us-ascii?Q?9cIWh8J6fxjmuADtd1tQeCaBKGfYlJRcSozOhyuCw5ZwMSOe+m2+gsVRpx16?=
 =?us-ascii?Q?+6TfgTpAcLZj/FgDTHCbHO8z/hZQ1mqPM/7xY8hmfITgJb/0HKToI5nlvt4D?=
 =?us-ascii?Q?Mrte1utMwrbohaWBEq4SaxkSlSNTmRSAZDfW0xLT8phkvabQz7XIi3u0wLZ8?=
 =?us-ascii?Q?NfeHa+kOrKAk53686t+SGSFetKVvf5bryk+mjsnwpFbr2ME5ByfaE/wDLrZL?=
 =?us-ascii?Q?zbpv+C+lsnie4Z8CsPuk1jhudtFebeGD2lC491Zqr7nLdJniDD+pr4oUgkWW?=
 =?us-ascii?Q?pTAkQoFJvjY8GA4DhV8y2ETGJmrAfPKMG1ohrIUq8AM3u3o5CmNvHsRLbmOV?=
 =?us-ascii?Q?j9pyHM9kxAD083ocJGRwinlbKrNgUPdr03BPmetOro9BggM3TWIDQo7TaKZy?=
 =?us-ascii?Q?0YOrxVmZmEIVHVkl46uv/OWBG1jgBITWAZOBcR+Tbr+7toVPqbptpuYeRZ8z?=
 =?us-ascii?Q?Z+2DwAyk9flGSlVUcV6W8gdQck7auduDeldZPZr6Zos6ql2/rDjRGQcrkFD/?=
 =?us-ascii?Q?D+x9U1agfmJhLWyPwoHpTKuLirmMSHyry8OpuGzxEt00R2WxeXTzshMyKj/d?=
 =?us-ascii?Q?fuL1I0GvUxDwzVc8ELE/Z2JEW3bc3ctqMAImodgzcdAifrBpzmqXb9KMLi0f?=
 =?us-ascii?Q?WUslsreyb7fXBXlFfVh7MB033ke7dH+3PkV6lxj/H3ocvvUeknzHHioT56xQ?=
 =?us-ascii?Q?jZyxgrxqsMQp1KFIv5btAnszd7IcXCmCamm9HPSFaapqqWBbSQ1H0Z3bl66X?=
 =?us-ascii?Q?Ao1u+w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1eb803d-283c-419a-3f63-08d99a25fd81
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Oct 2021 15:17:00.5905
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zn5LtqzJ07wClAbzj2cMwgY6huoaR+KrSoT9cIcOpwjn/h3mwr5DlwhSZ1QZYSjLxI4lpV6uoY5aaIkLyx4S7IC7vS6Icsqn8c0zXYRdiiE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5561
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Thursday, October 28, 2021 11:14 AM
>To: Yuiko Oshino - C18177 <Yuiko.Oshino@microchip.com>
>Cc: davem@davemloft.net; netdev@vger.kernel.org; Bryan Whitehead - C21958
><Bryan.Whitehead@microchip.com>; UNGLinuxDriver
><UNGLinuxDriver@microchip.com>
>Subject: Re: [PATCH net] net: ethernet: microchip: lan743x: Increase rx ri=
ng size
>to improve rx performance
>
>EXTERNAL EMAIL: Do not click links or open attachments unless you know the
>content is safe
>
>On Thu, 28 Oct 2021 11:03:15 -0400 Yuiko Oshino wrote:
>> Increase the rx ring size (LAN743X_RX_RING_SIZE) to improve rx performan=
ce
>on some platforms.
>> Tested on x86 PC with EVB-LAN7430.
>> The iperf3.7 TCPIP improved from 881 Mbps to 922 Mbps, and UDP improved
>from 817 Mbps to 936 Mbps.
>>
>> Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x
>> driver")
>> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
>
>You seem to be posting performance optimizations as fixes.
>800Mbps is not "broken" for a 1G interface. Please remove the Fixes tag an=
d re-
>post this with [PATCH net-next].
>
>Thank you!

Hi Jakub,
no problem.
Thank you for your comment.
Yuiko
