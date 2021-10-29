Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCFE343FCC9
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230475AbhJ2M7z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:59:55 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:15857 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhJ2M7w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 08:59:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635512243; x=1667048243;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=eErcCp5nrqkkBY15QMynkgRZg1Auy0recZsJkfF3kRg=;
  b=k8UjyVaxfXzawd57MOSf0lhuVW9UNwTOqA5zXji03LydLd7jPCfRg3V0
   muU0pTV/2Nj8Y1siJHA4kvxd2hTmTLnlUPDhDBRTDB0BsTdM2+Xf24FP0
   QhPQmrBDGFJl9R978/78hqHBCPYyQlAcSeeyBlyL3jG6mp/onFNKygUev
   fVZ4+3BolQg9694IZMV9y5vm0v8nAWwpBlGnnTzUSPGiBix/D4QVNhJ/v
   XAXeBG2FRUJe97gPoyNWfGoxuG0ttFi8otaQ2VjOrmP3ohILQObMSeAyd
   2WCdXscA4zFv7OSLf1hgWbZOdoIDxoUJUp3D780+JBzp9orQZjCW0TNvQ
   w==;
IronPort-SDR: 6jl70StsjsH0hZyGQv0ZgHLd0zN0mSPv+LfcALjBEGXlsmkgjIwQg1F/KtTjLzkgd5RV613n16
 6W4OlzS2t61vYS0SA5tco6RPAjhfb0c70ko15S+h3ubBMG3dyxwtTyDVEQCvQrBBBM44k6Kcs3
 wQXhmc7/xBYnD0ngR5JrtpBWTPY/ZEcCd2o6d6ZQy+8uLkazm6EXxvx+6TgHhz/J7bJs39mrgC
 mGDQsQUiIl7ZKHaFOcsir7/rD7YQrsabNURNMuciZAK2okyQqyQJxfN4ionyYIJ6mxuf1vG1xW
 axj0LJ8EQagveMkviV8A2Yyk
X-IronPort-AV: E=Sophos;i="5.87,193,1631602800"; 
   d="scan'208";a="150030381"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Oct 2021 05:57:23 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 29 Oct 2021 05:57:23 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14 via Frontend Transport; Fri, 29 Oct 2021 05:57:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1roYTEpUGQryLuTw0E3f2LKSQ03BwSZgMGToHvlS3F2p2pF+RkkDaaVvvYSJgo5yRCNDPqkADdRROq4hnSnPZkTYmaXn0G3PGwhUBB3YEhqPijgJBBCkmB10kSzwbVvrKfu35EpT4u+RdmHClxucV1hQkBvcpvEpoj0+e5ogIJf8Csna3Dgtr+Zjo31rIJktXkt7Ei68gmHP8tS24nf1s8uk4HbObf+OTTc7bJr/YAhKV/LC+NeoWpcHdofpzwDWxB9mrG3q6LFs5sgBrKY1QfBQeaHnosiPSyAQFS96kPly2eLyTtKutg2ayFiawfmdmVqhTNVsd7tOqsFPXOyKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OSA83EFPOuDqYP1ZGYH8RuMz6g+1WlPWnhNTYPXbc2Q=;
 b=fKvbdYSfjq/JElTtVdlQ6FJUC9+E8mdZa1OrHVEVPmdYAJXmNZrtMmoQ3LWTS+GG+0ANq6RwFjk7XN32Esodl87wN6leQO8Y93/0JJK+fMoNRa5SgDNZFpmWxcAZJt7yQediN7bdjpefqekn3HDMgGZcBFveH8Y/B4L/9IKo30djr2P61XXlgCr6a7bVomX4HhiPqivRqyFrHfi2CTgWqxvEfYmKMuBmj7FpdAMM1ltAFs2uHt0WfiNDS+B9Sk2JT6R+wVqKVhDzn9b+IFoOFupulxyf/GOKXlMM1iMQVRzLvAeMl2gNMsQTj7jbGZUpQCM/+lvzGGV39HqN/GJ5FQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OSA83EFPOuDqYP1ZGYH8RuMz6g+1WlPWnhNTYPXbc2Q=;
 b=B+SyQgS6kRtZd77CPzgRC95/Ciypi25r3RA9UcCvlcn0XRgvc3tmlyvdNirwdczWw2zvz9K14ZlDzb6R5ddSzuFnI/rtNtZiXEFhQm46sWvnLblQSW2y+nNfcekSjxvC+ugxBP6QmSJINpt4r3bwS8af7fsR+pbUzfivM3Dx+fQ=
Received: from CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8)
 by CH0PR11MB5561.namprd11.prod.outlook.com (2603:10b6:610:d4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 29 Oct
 2021 12:57:18 +0000
Received: from CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::c096:557e:a1b5:bc5c]) by CH0PR11MB5561.namprd11.prod.outlook.com
 ([fe80::c096:557e:a1b5:bc5c%7]) with mapi id 15.20.4649.017; Fri, 29 Oct 2021
 12:57:18 +0000
From:   <Yuiko.Oshino@microchip.com>
To:     <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <Bryan.Whitehead@microchip.com>, <UNGLinuxDriver@microchip.com>
Subject: RE: [PATCH net] net: ethernet: microchip: lan743x: Increase rx ring
 size to improve rx performance
Thread-Topic: [PATCH net] net: ethernet: microchip: lan743x: Increase rx ring
 size to improve rx performance
Thread-Index: AQHXzAzaB7qTyZBseU2ukQ57dom3rKvokomAgAFd15A=
Date:   Fri, 29 Oct 2021 12:57:18 +0000
Message-ID: <CH0PR11MB5561DB4E2AF8C8FA7EE77C0B8E879@CH0PR11MB5561.namprd11.prod.outlook.com>
References: <20211028150315.19270-1-yuiko.oshino@microchip.com>
 <YXrJxb0LtllPkOse@lunn.ch>
In-Reply-To: <YXrJxb0LtllPkOse@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8a6e421c-82ad-47ae-2117-08d99adba3fc
x-ms-traffictypediagnostic: CH0PR11MB5561:
x-microsoft-antispam-prvs: <CH0PR11MB5561598795F989BF53E262548E879@CH0PR11MB5561.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GSo0ytbR6HFqk9+kTlCxur6skW9rBVYiPXcaOM2ucWZIchwftFMfzSLmbo+pOyi4DHB2vIbKsrkcjfRrOzx29iYZWM4F7fXvTTEnOIJ2epvRsrCHSrK+ulKOPsaJazk8v8tn/5O5vqVybIxKf/acKirEOcxmUb79bYZj7uLg247EpD1ZCsopOhbilcGuoFvlr+sEADV3w3APEodzZaglhN8YTkICgBwdOfJ2YAKowodCrT2RwkUyu0AXMBp16YlI7Sybdue+XlPXPpjpaQcU74Lepr913wywYbPLy8DUS40VjlB2CSG1jl1ynpRmYKFNBJmmRIev/VNn2HBMbsywqpihLBZhh6o3ACPNfYq6Dx8DRBiYRHlg/dzWAl6wbNnmjH+weIAqKU+D1UgJZCwSh8J117vPtyAg56nUKjGF/PVjZ6M7ATpdWs++OOQZk+RmOLI5oC88jpIQp0U+0pXHaifYt980ZDmMALr/8f3mYDVDJ+yochIuA3DBRQTmrF6fqdv1XOEX3WxcOQPaaUhy/PQIa9VjImmE5h2lWVrAijLzI6Kf7gZ0BwMIyzdIhTBsZQgAB7ZCRyD4eciU+LWPyszRHo6rwFiD4OMkiYxUVY8RpH/PA3Nsu9P6BPHpCzvvUSQYiglqFD8J1eQgkwKpboPEscQW+xN79iYN/lE5546bNsx2HRFnQlBstke1xAr+afD6F1Wde4OBOluWsvtbYQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR11MB5561.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(316002)(66446008)(66476007)(66556008)(66946007)(76116006)(71200400001)(9686003)(64756008)(8936002)(6506007)(83380400001)(186003)(55016002)(26005)(122000001)(7696005)(8676002)(54906003)(107886003)(52536014)(33656002)(38100700002)(5660300002)(38070700005)(4326008)(2906002)(86362001)(508600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?d50A5SJuHfHU6jzWDOue/B6uIP2OU0f+a2YO1dGWTdHaga6MNOIGsrwz1pDJ?=
 =?us-ascii?Q?naUgQPa2dZS6nN/xt76Vygqu6uScWGgD46UiGHUds8XP9Gtzskw+jFnspBJ7?=
 =?us-ascii?Q?fmKh3EIpef6wQf1+bStdhgWIjjxeOxya9i8PkMyUwj/c0d556b63vyffSBZv?=
 =?us-ascii?Q?U1EJqv6hiZSJatTKNsj1Sotn3+GfMTcLJAQPoR5wluFNmkSGv2az4HARhFwQ?=
 =?us-ascii?Q?LZTRB8/if11Wq4+SYO3cg5OVCde24axG2e8YyQZx1ZpjFUQUL6IQ6TlK3+iC?=
 =?us-ascii?Q?+/owz6dq3U3h3qnTESNhtXEgdYVLcpJFoL9rA/5YqwBi+aYq1EkOiHsghKMm?=
 =?us-ascii?Q?D+qgxCQVdZEnIQLEbJ2aws3T8QBwDPZXBfEFmhRLzRgsyt1YgDURjS8AnbZK?=
 =?us-ascii?Q?4il8tJRrE2BO/lz8zNMUsf+0BK8v6HWKJ4XNnSDnmtt4ss2gBTuLfIEXLsB9?=
 =?us-ascii?Q?PtS0TNgTog3FHaZN/kOAG62pN2KVyr5uw7pCO7WbPuzWR2UR0fbojstzSJmn?=
 =?us-ascii?Q?n8+J1mt3g2yYIynhGkzQsjBFIYQGkLtZCos0ZPPws9/BPRr+cFZx8q6UVv+6?=
 =?us-ascii?Q?2sxFXbVJAUNSvDqmAtOrQQND16tB6QuIC0Ry5t+qnIc/aLTLoAqY3GRX60IV?=
 =?us-ascii?Q?D7sVgh1M/aBRVFUMHJzCvASjxg12ga2dbIiV/gMPpdal0a0K8o2gCAseno4R?=
 =?us-ascii?Q?9Kl/BvHhY3T4ak+JNZi4hWQ58+pZ5wnxkf6TsghZ76GogFJA6tYOrYp+HERk?=
 =?us-ascii?Q?seP4XNKl6Okfald/J4Jp4pkTE8FFQAfAFplKIQ+0koOwdrxA6kl8zF6sd4WU?=
 =?us-ascii?Q?Novg9F4FsAGT6VcfmqgDIRBZlru2z9MwmiV08N1dxSlEdpHuoaJFIQ/DIeTu?=
 =?us-ascii?Q?XGRR/6T1G7pBCK+c6TZ0pb8UIM1GZkmjpNVQ6csl1fj59S182F/+dINFO0t5?=
 =?us-ascii?Q?zNK0VmnylDTKvax0jM2NFURecvNz1eZFk82llfguVIHY19wmA8RTqRqbpRtH?=
 =?us-ascii?Q?mLmymnJ+fFhNX+ZRFxZ/GIH/zEnpNYGg0OqISLe0OjsVRVeeGf8663yGAcJj?=
 =?us-ascii?Q?rJzElHC/0cacOwgh+m7MKPfqmWMIxZZBmEijRDbt/j8Kv7LVMCTl53I06+Pu?=
 =?us-ascii?Q?aHEEXO/zVvzhH/FSD3WwzArc4Bt1ksgYrPUg98+54f/a/mqj8JnDTSXEifcb?=
 =?us-ascii?Q?cFEGVUFH7VXa3egBD+L6T5F4PDnHYMn8igKp8LO1qXFU0QetOIzikTz9MJ8/?=
 =?us-ascii?Q?yqIyLOG7grNeSRp5ER/S3HqeiAkTKybBt3CvWDY+alowJ8pmtpkxfBn8jNju?=
 =?us-ascii?Q?FjEyxX8pZvyrAijzQGEmuQ4zuqMNM5zaqK7YiqABLXrLP03dE7QqpLunHc7/?=
 =?us-ascii?Q?cZUJi01lwXROFFhAOUnqL48fYkFdwoK13RKn6ZqI5yoi7fV99pWvIk+8FcYh?=
 =?us-ascii?Q?v2vK+ShPEKjlp1uRsz79X0q3R61A7DRvD6TYWgf519mafSTA1XWvlMpBvtaP?=
 =?us-ascii?Q?xuHdVkQFYvxEqfSD84gZkExA+oMbV4nRvhhABFgmUdDFOfS+vUEUbjJW1XZ8?=
 =?us-ascii?Q?l+7wUBQheMLBEs7jV5dbNkdx7tDyXHrVYqQL2AFCvom235CF3Tudqbk40EhS?=
 =?us-ascii?Q?qruErpS7JxTTfYU3G9osn9mQCThB3e9GUaXq9g+jCYJEsD9FPUwdeEoyMrGv?=
 =?us-ascii?Q?OAMxdQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH0PR11MB5561.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a6e421c-82ad-47ae-2117-08d99adba3fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2021 12:57:18.8046
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TK/qzpnoMElaFbbSLAMhYnG8i4ghNOjF0ACVOPSgxYbBgsrfTpXO1/s7VSQ3yMYVCKTdiyRzN1Rcy1ssUNddPvv3oueys38090Ye/KJl/IY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5561
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>-----Original Message-----
>From: Andrew Lunn <andrew@lunn.ch>
>Sent: Thursday, October 28, 2021 12:03 PM
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
>On Thu, Oct 28, 2021 at 11:03:15AM -0400, Yuiko Oshino wrote:
>> Increase the rx ring size (LAN743X_RX_RING_SIZE) to improve rx performan=
ce
>on some platforms.
>> Tested on x86 PC with EVB-LAN7430.
>> The iperf3.7 TCPIP improved from 881 Mbps to 922 Mbps, and UDP improved
>from 817 Mbps to 936 Mbps.
>>
>> Fixes: 23f0703c125b ("lan743x: Add main source files for new lan743x dri=
ver")
>> Signed-off-by: Yuiko Oshino <yuiko.oshino@microchip.com>
>> ---
>>  drivers/net/ethernet/microchip/lan743x_main.h | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/microchip/lan743x_main.h
>b/drivers/net/ethernet/microchip/lan743x_main.h
>> index 34c22eea0124..aaf7aaeaba0c 100644
>> --- a/drivers/net/ethernet/microchip/lan743x_main.h
>> +++ b/drivers/net/ethernet/microchip/lan743x_main.h
>> @@ -831,7 +831,7 @@ struct lan743x_rx_buffer_info {
>>       unsigned int    buffer_length;
>>  };
>>
>> -#define LAN743X_RX_RING_SIZE        (65)
>
>65 is interesting. 2^N + 1. So there might be a reason for this?

The original developer wanted to give the hardware a power of 2 usable (whi=
ch is the ring size -1) number of descriptors, but that is not required by =
the hardware so for this update we decided to take it back to "rounder" pow=
er of 2 memory request from the OS.
>
>> +#define LAN743X_RX_RING_SIZE        (128)
>
>129?
>
>        Andrew

Thank you!
Yuiko
