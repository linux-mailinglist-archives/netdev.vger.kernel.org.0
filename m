Return-Path: <netdev+bounces-7599-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00303720C8C
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 02:13:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27D781C2125B
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:13:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B52DE19D;
	Sat,  3 Jun 2023 00:13:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B176197
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 00:13:36 +0000 (UTC)
X-Greylist: delayed 242 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 02 Jun 2023 17:13:35 PDT
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DB2E43;
	Fri,  2 Jun 2023 17:13:35 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
	by mx0c-0054df01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 352NHxvF019830;
	Fri, 2 Jun 2023 20:13:17 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2175.outbound.protection.outlook.com [104.47.75.175])
	by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ques3pd0m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 02 Jun 2023 20:13:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RFKW8w7mg/IQWxivK2k7N60SWOclSIJWyo7wiQLZmlB5L3YySX8us3m/zFJKSyDEt+HGR/q+caqvIhGQSSRykqpb1IUCaVdX7z6md5AgmLagFdepQWB9chkwFKRFTbHCnefxPK5Mv+Eigdd9yZ1Pk/fu5PWDgwBOiDsxNQM2pju+P3tYhfbhdNlovVeN4U2Q4zB58lIILch19yoUWsgZNrz4kLL9cqZ6OKZDmfFcMz3AkEWnyIMevsyaL79iHWrcy8G34s2Ci2htFQe7p7QHPq/YsIm6DAzZYohdLizssaTmBg4A2LsRIR1Ceol438McyrafJpUWtJanKrKHp5G2yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I/5zv3xIna3QzQXxCMJoUcrS8sssa3x902HehhOMZ3Q=;
 b=RNHRn5R23D057NndYR5L/pLSEHy98DKANkGGZY1hSz3ycZntEV1K8SRKdKgNUBzZkFAi7hp/YQQjLaf/+GPSqpry6dXomO46+uhuwbDVeBiO9Fs6+zKC9Z+DU/KbwT/0z3w5X+OQdGwp3IMb1OxxmZxYaQH63/U2NtEBbKQ1YY3bP6FhKNoJe/k3Y6jmPdyLEXwbVJLVeD1ZHrQJD12/hZL3ZePgDj2iXRgtraEJy8MY9yiJ3mjnmUYaEdOA59dWJgQU65oFAm2nxMEXhdphljXC+MgBKmNYCfDcEeO4wUrSGAzFOccVb6EMHA1Y9CABRIzF1Hx+GiGoFgeimT6ZdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I/5zv3xIna3QzQXxCMJoUcrS8sssa3x902HehhOMZ3Q=;
 b=eoKwt6gZdkdpMHDsBPsV+QxTXhMQbEQ4dhLI12Eivoh4v5EPmC81O/iEOqzlzQjWkbbUZfBzU8ksUAQirBRwmBiMeRxodCIytgu4P8PU+BxO7tTZPwrns2opdtm6WHyFZlAkFJ6lk1dWnFdA1f57UpZTArDaC5raGjfa7qA1HmM=
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:b9::6)
 by YT2PR01MB10646.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f7::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Sat, 3 Jun
 2023 00:13:15 +0000
Received: from YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0]) by YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::c059:dcd5:ca20:4a0%6]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 00:13:15 +0000
From: Robert Hancock <robert.hancock@calian.com>
To: "andrew@lunn.ch" <andrew@lunn.ch>
CC: "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net"
	<davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "woojung.huh@microchip.com"
	<woojung.huh@microchip.com>,
        "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "edumazet@google.com"
	<edumazet@google.com>,
        "UNGLinuxDriver@microchip.com"
	<UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH net-next 0/2] Move KSZ9477 errata handling to PHY driver
Thread-Topic: [PATCH net-next 0/2] Move KSZ9477 errata handling to PHY driver
Thread-Index: AQHZlavIF1vuUAm/lECPBpMvOGeVQq94MoGAgAAChwA=
Date: Sat, 3 Jun 2023 00:13:15 +0000
Message-ID: <8f512a9409ff824595855de5ef41b83776791715.camel@calian.com>
References: <20230602234019.436513-1-robert.hancock@calian.com>
	 <1faa28be-7881-482d-9b47-c407d8159f47@lunn.ch>
In-Reply-To: <1faa28be-7881-482d-9b47-c407d8159f47@lunn.ch>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4-0ubuntu1 
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: YT2PR01MB8838:EE_|YT2PR01MB10646:EE_
x-ms-office365-filtering-correlation-id: 222988e4-52b4-4890-ba49-08db63c75367
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 
 RcC8jmr1UzYc8eeQFk1D5Rj2CpayenuWOGdTfQKg2KW+7fbKS7ecY72nePIR+tKLMugDDguDBYq87sRKmQuX2pW1iDRQCpwp5IySJf21GFI4cmbyk6vE2+o3d4rr9iNIVLLiHKEi88vTdkPLEIF7a6dcxqhjqeXCoSlwKbI0gvH3ps/Yo/H+fcjSqLilnSYOLswc4N2aLehbhXMu44vLvz1aYjqo7XDOwuOiuiRnNOq/cuXTOj1hMEu0+5snI2GKXAHMSCsVMD8BXGj3csTlsodrZVjK6Bkrg+7VGB6r5BdIZg9eLSYyfgpNd9KiAgUJm1mtaX5n5CEByThP5yxiPVuRxWtSSZeaPR3vcAURnC85mYLLXxnNrJcnHDSyjMUHVWHDBIf14fzRWw9RjrsrRqnv45QXSF6Io5ofbCIXcpQ/fIXTLhTqbHouhYjhCpR25eKuist9f/wlbbUUJYdDzaedId0kSasJmAhKK3wRacGcIQH5P6pkAucBzjZ/l24ZvmEvgF9ocPz7H8Xtv6ZFZVe1iKijqSKHDr8vOEEF5jJU4uHA4o7IZ7wUYlsdPN2FuhWHwHGxkF8fSSGDKYKh1S588lW2+g/K8x699HzWnEX+e5SweU2lINvOQ1FoPATl
x-forefront-antispam-report: 
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(451199021)(6512007)(6506007)(2616005)(38100700002)(83380400001)(41300700001)(6486002)(186003)(71200400001)(478600001)(54906003)(4326008)(91956017)(66446008)(66476007)(66556008)(66946007)(122000001)(64756008)(6916009)(316002)(76116006)(7416002)(8936002)(5660300002)(8676002)(44832011)(2906002)(4744005)(86362001)(38070700005)(36756003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: 
 =?utf-8?B?UUhUcVdBREl0UWZIUVdnSWMrU2hBcnBreWJJbmpJak41Y3lub0Y2Y3ZobXN0?=
 =?utf-8?B?byt1TG91QmR4LzlUcHBNU1hPL2hJbTNIeGNWSGZ1elZKMHB4dENLbHNFSE81?=
 =?utf-8?B?RkpJeEl4U2VLcDhXMS9uQWcrelVoZFY1bnVTQ0Q3c1RBdVZUREhWUWhKaXFq?=
 =?utf-8?B?K1NzNC9UQ0tlbGY0OTU1N2hTU3pqRjdBN2k3RjRWWTBGRGZSNTYzZ2tIYUE4?=
 =?utf-8?B?ZjRkakIyUEJiOGhxenRmdVZobXRZNitDcGNtU2Y4ZlZVdmhGaFMzYm1rMmIz?=
 =?utf-8?B?MWRrNVVVd1ZhTUZuYzZBeHZRU3kyMlA5NTBnSmtabVhyb3VlNWpCVGlTbG44?=
 =?utf-8?B?N1ZrdkhoUXdUYW9sKzF2NkFuZjBFMXJBaXptS2pGQ1BBTFVmRFErSFUyb0g3?=
 =?utf-8?B?dzRFOHJ6TE55b05STEE2NUdYNnlyZ3FXcXZabHRicWM0VFY3RFpZeHE3L0dl?=
 =?utf-8?B?elJDdDNHREVnM08vMENkYmM5M2JDMjhvaFlhMVdrZS9tV2l0a0V2SHkvL2tr?=
 =?utf-8?B?WldHY1AxaWJIM0g1VEtHT0Zldnd0SVUyRW9OYjdHSUs2c3QwZ0RnZnBPdVQv?=
 =?utf-8?B?Y0hXMXV5UmZQbXQ0aUtZSzBpemV3NG12eUVHM3Y0WWFLa25KZHYvZStZbmg3?=
 =?utf-8?B?M2YwVzI0ZUxnZXlZNFN3V2dnNFV1WUtGYm96SkZnTEJKbFlubllGdVpBY2N5?=
 =?utf-8?B?NHNUY3UwR0FGekRNZUNwZ3Z2M3Fob2VuazVrbUVmWTdLeE9lSHJ3RTdaVkpI?=
 =?utf-8?B?SUdiNFBaVGVULzduRTcwTUJIMmQ3d0pUTHpCb2F1TDhpbjhBMjU5a0U0L05T?=
 =?utf-8?B?YnUxSlhEK3Q4L3ZadUN0d2xFYkUrYzc5RnF4elBQSHhCOGJMV00zU1lpbk8w?=
 =?utf-8?B?azBmWWkwZFk2WU1sMWN5eTZCVlZkQkZyRUVqSUxSQm80ZUtSWStvWkZjaXBC?=
 =?utf-8?B?Q3hseW10T21iZStYVzJPeldZam9LZEZrL2hHNUlIcGswZ3hYQWJZN2M5am1u?=
 =?utf-8?B?b3lBZnJPUE1nUVRINGNBdGpCbzhLeDhVVkF1KzFVTXhpNHozcFB6UGlMRmlw?=
 =?utf-8?B?WGQ1a3ZJQzhwNWEzK005WGtOcGlYYnEzbGpORjRLM2c1d1VUdTdrMFZtdWM0?=
 =?utf-8?B?ckE1WTZ2MjZvYmc4RDVHRlVRSG1NY0lkbGdLd0p2a2lReU5Qam5RUXBuZHVS?=
 =?utf-8?B?Nk00Tzc5c3QwV3BKdFM1aXo2SWtmb0hzN1VnUUJOdUZ0NVdFUGh4amtXeXNa?=
 =?utf-8?B?ZWdES29CS21KcVpIeEUyS3NiVXdUVnpKbG1zZlgxSHEycjdRNFFMOXB4YWdy?=
 =?utf-8?B?NHZUM1ZCaEJaaE8vL2c2dEpheDJxdVNhUi9iR3JUWStwNzVBMFk2SWkxS0dQ?=
 =?utf-8?B?OFdJeVJVWHNhQVJIRXBCRWNkNUNFM1VxUTNyUEJralp5WDBZQmszNFhGMGk0?=
 =?utf-8?B?M3lFTk8zN3grUGNwVVM4ZDV0bWFmZnNPYW5tazlKa0krS3ZadGcxZlNxWU9W?=
 =?utf-8?B?RC9hZXJudGF3NlcyV2k2SWhML0ltSTJoQk1SeCsyc2FqQlVzOFJSWnNQbStT?=
 =?utf-8?B?ZlBDQVlaUmwwZFZVSk1qUmhTTkJVZUNZVml2Sld1aDFwUlAwN1V2UVBNTjhE?=
 =?utf-8?B?MndCV2FTckZmSDNiU0FiRHI5WmRQalNlT1F0YTA2MXJ2N1dhbi9va090NnZP?=
 =?utf-8?B?Tmk0SEVYeUZxUVNNbW5CY2pFVWJFMzVpZ1lTWGwzZXZZc0pXNFo3dm9tSXBR?=
 =?utf-8?B?QnI0WGdCT0p0N1VKcjdUN1ZmbGoxWUJ6Tk8zSmI5bDRMTEsrNWtLbFNXemlX?=
 =?utf-8?B?eG9VMGJzdGppdVZBdjNRdzJaOHlVK2NMWDROQW01b3VsdjR5MXNLR3J0Uk1H?=
 =?utf-8?B?U0ljODNJWWpHeVcrNnNINGlYU0o3M0V6UG96Wmxxc2ZyZUhGQnkreVhIbXZw?=
 =?utf-8?B?VmZlNkd1eE9WbzVWSHU5QmlQSTVhUk90M2lqRkVBd05acEJYQmJtNmpyMldr?=
 =?utf-8?B?M09wYUhNMHkwM0ZWTWJUS1FpOVBrdTVzWGIvWTRDVFhxWGtHaTc0eTQzcGFD?=
 =?utf-8?B?NGFmL2FNZTBvd1VWd1dieDM3blZnME5CUHlSazFuckJOS005RlBGQ3JrYXVO?=
 =?utf-8?B?bjdZQ2loVFRGYW0wVElNekU5bTBlVE1mQk1mcWVRMmNCOTl0TGJnd2tkQ3Zp?=
 =?utf-8?B?N0JCcHp6QTExc0VtM1RHLzIxVjlNNXN1WVVSUVU2dWlqMG9CT2VZaThTR0lk?=
 =?utf-8?B?eXRDMmt3THA3MTJUc3F2TlZiWTdBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E2CA28D0805D2D46B53F3D1ADAA8A15B@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	=?utf-8?B?Z0N2alFOZ3ZlMjF4SXVaRWUveW5RemdIK0pwaXJiUTdGT1RxUVV2cXlweDls?=
 =?utf-8?B?MmpPYmEvdFJGSFRySlROaVR6REV3dVcxMjYvUmVHUXZlc1NDS3ZzbWtLMXJp?=
 =?utf-8?B?SmMvNUxrWXU2cElra056WVpmbyt3SE9ON1pLUjQwU3dKUjJhbHZUdDhNZHQ3?=
 =?utf-8?B?SGZRRCtXWGJ5UDJoRHdrNzBWSUFyZDdHbUEzcGJ6WjRYZ09QSS9JTk9ESHdx?=
 =?utf-8?B?blM0VEZuMDNyU0dvY0d4QzVFeXFHZzh2S09HMkdSR2kySmdvUHdXOThHUysy?=
 =?utf-8?B?aTdyM05aZi9NMTdwTU16dU8xdno1QTR5Q2hXenNBV3dKbEI4TlY3VUlPTmVt?=
 =?utf-8?B?amQ1alVHaU9YL0tEZDlFTzIrd0J4ejlRYUJWT080eUtxK29xLytxd1RORFF2?=
 =?utf-8?B?bWZJcjRCT3JZZCs4NXFiZlZvZUJ6UFFoWVZJVnZaM3ZKRisyTmFWNVZZRFNE?=
 =?utf-8?B?eHBBOEQ1cDBFb2EzelN2ZVFHTWJyMDd4Y3hyWjVJUnF2eENEclRCbkZIZjFs?=
 =?utf-8?B?MzJOUndGNXVsNGtFMElkUERyL251ZDFKR3JGYjhIamhHcnFjbzZzN3lHYzVV?=
 =?utf-8?B?TkVuRjdoSVVwNGUzRk8vSWl3RUM2ZE5YQy9YWkJWSUdsbFJCNVQvelViTWtS?=
 =?utf-8?B?RkRkYklTSW53c3dFQ0I3T2VaME9xeHpBUGhrWFFNQU5LT0NFRjFtNTFLSzQ1?=
 =?utf-8?B?NlhGUlNReTQ4VjV5ZHd5YlRPSkpkWXF6Zlgya01ZYmVTV1E5RFo3VVdSMDIv?=
 =?utf-8?B?Q3plSitVRW5Mdkdsd3pEZWlCQ1hMaGFwbGI5bmdFNnlETmFNdTU0U1VWUDVl?=
 =?utf-8?B?dzh4dncxU2dJRnlVVlhWc1lGMFJNNC84OWRKSHJWMVRIdUNWR1JsbzNNWUdu?=
 =?utf-8?B?NzIxYWkvZG9nUU12NDJSeWtXM1pGRVkvcjA0cUUyaTJQRTVscEVsc2h4Tk9s?=
 =?utf-8?B?aUFGV3RUbGdHMkl5RTJnQjdXQ0JMQmR3eWQ2eldsL0dBeDZGbFFiWURkUkR0?=
 =?utf-8?B?Qlc1bmFabTFJWWZwYUp0NjVXN3gxKzUvbVM0SXNDeUZYNks5Tk0yaVJ0TWk0?=
 =?utf-8?B?S0tjeTg2dDF5eUhudHU3RUtLV2QzWUN1bG8yc3o2cHpCQW9NUE5XZzIwRTds?=
 =?utf-8?B?dTdLZkMvWXI5OTN5UUFYSnNiWFVHaUdmZ3JsbkZoZTZMVG1FYmY0OGNIbVFM?=
 =?utf-8?B?RlplOWFzRFB0Q2hHbW9PVk5ON3RZMjJ4T0tQd28rd09STEpFOHQwckZpVDZI?=
 =?utf-8?B?SnozNnovK2krODM3RWc1OEx5dTBEMUJBK3ZpNGd6TkdLMkdMeDF3K1h5bW9V?=
 =?utf-8?B?aUljMTlKL1hJWUlzZnh3YWR6UlVHNmRybXV2d0lQUmdHLzVsSkhFNVFpc1lz?=
 =?utf-8?B?cmtvZ09aTDFnNkE9PQ==?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT2PR01MB8838.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 222988e4-52b4-4890-ba49-08db63c75367
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2023 00:13:15.1815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TYpVAmGn1S40knkif5kWX0KJNBDyaNBXQAEvYcvshoEuXQPJUL+9rfUcNzCJj6gWq/TR8TgF4U3W66TI6fLRwlyztZnq6dKb69nn6ECSjTg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB10646
X-Proofpoint-GUID: 52Uuc_V9k3xKad7FZItu6V0jL0gIwyqc
X-Proofpoint-ORIG-GUID: 52Uuc_V9k3xKad7FZItu6V0jL0gIwyqc
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-02_18,2023-06-02_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 impostorscore=0
 lowpriorityscore=0 mlxscore=0 priorityscore=1501 bulkscore=0
 malwarescore=0 mlxlogscore=591 phishscore=0 suspectscore=0 adultscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2304280000 definitions=main-2306020191
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

T24gU2F0LCAyMDIzLTA2LTAzIGF0IDAyOjA0ICswMjAwLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
T24gRnJpLCBKdW4gMDIsIDIwMjMgYXQgMDU6NDA6MTdQTSAtMDYwMCwgUm9iZXJ0IEhhbmNvY2sg
d3JvdGU6DQo+ID4gUGF0Y2hlcyB0byBtb3ZlIGhhbmRsaW5nIGZvciBLU1o5NDc3IFBIWSBlcnJh
dGEgcmVnaXN0ZXIgZml4ZXMgZnJvbQ0KPiA+IHRoZSBEU0Egc3dpdGNoIGRyaXZlciBpbnRvIHRo
ZSBjb3JyZXNwb25kaW5nIFBIWSBkcml2ZXIsIGZvciBtb3JlDQo+ID4gcHJvcGVyIGxheWVyaW5n
IGFuZCBvcmRlcmluZy4NCj4gDQo+IA0KPiBIaSBSb2JlcnQNCj4gDQo+IElzIGl0IGFuIGlzc3Vl
IHdoZW4gaXQgaXMgcGVyZm9ybWVkIHR3aWNlLCBib3RoIGluIHRoZSBQSFkgYW5kIHRoZQ0KPiBE
U0ENCj4gZHJpdmVyPyBUaGlzIGNvdWxkIGhhcHBlbiBpZiBzb21lYm9keSB3YXMgZG9pbmcgYSBn
aXQgYmlzZWN0IGFuZA0KPiBsYW5kZWQgaW4gdGhlIG1pZGRsZSBvZiB0aGVzZSB0d28uDQo+IA0K
PiDCoMKgwqDCoMKgwqAgQW5kcmV3DQoNCkkgZG9uJ3QgdGhpbmsgeW91J2QgcmVhbGx5IGVuZCB1
cCBpbiBhIHdvcnNlIHBvc2l0aW9uIHRoYW4gd2l0aG91dA0KZWl0aGVyIHBhdGNoLCBpdCB3b3Vs
ZCBqdXN0IGJlIGRvaW5nIHNvbWUgcmVkdW5kYW50IHJlZ2lzdGVyIHdyaXRlcy4NCg0KLS0gDQpS
b2JlcnQgSGFuY29jayA8cm9iZXJ0LmhhbmNvY2tAY2FsaWFuLmNvbT4NCg==

