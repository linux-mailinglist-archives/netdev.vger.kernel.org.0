Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24A7830D6F1
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 11:01:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233727AbhBCKBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 05:01:21 -0500
Received: from mga03.intel.com ([134.134.136.65]:60911 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232911AbhBCKBD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 05:01:03 -0500
IronPort-SDR: RDKP5sdSFbU8HouVpcoWi+t+FAmrwX82epFcQg1QbcByt0inn29ZSFXmyI8diMRkwHCARvmNJ6
 lFi6wJYNatoQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9883"; a="181091248"
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="181091248"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2021 02:00:13 -0800
IronPort-SDR: 66aPQZb7II6olLSRqPjKXM6LVnfIpaSKuokAxEm2AquwKwUipq1lFgQrUkViidzmihlpMSEiCk
 7vJRhvtD1dEw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,398,1602572400"; 
   d="scan'208";a="372320335"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga002.jf.intel.com with ESMTP; 03 Feb 2021 02:00:13 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 3 Feb 2021 02:00:10 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 3 Feb 2021 02:00:10 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.176)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 3 Feb 2021 02:00:10 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e/OWzPiujLYBxVyIY20Xt2771CkuWV9QOHWelVvvizJCBiIs5zz0+8peJKwYhQ7S1MffQFpVoTDNEUQ7NZ1uGEWMt9H+jFrmj5C/z/LXV3NhXDvmhM6pgR9FfQubu4GIGQ614pBsLF8cyhbPTjVCo4wrUEWLrj/QT7uwK7E80Uo72xtCVWY1ooJ19SeG/igdovIXf8oYarl7tKyoIBxxvcdgWjtJhJQFRJ63RK813zisWjb2AVNd2EUA569FXvpI88Y5Mwmva0zSvL+P2XjArX0a6iyl7zy06jEeosOHCCeFWv8Tm0tc0YaSSe4nX6swbTJaaHFeZHqgjKF4zo9d+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o79RHz/CAg8qy9Dn6qNmhwb3EyAxTuHbwhADex3zGm8=;
 b=dVz0W51oA0vu0Xe0VU9P2SsWiW8euk78uQUaQMNxHXu3rsZAu0girx9TkHYAehDcC5UaAvSAjonI+ScbnEC8PSnKTRYFT8Vy36TPjn7UMIQqkqCnWp2zaworjpXOrNPHtnUI1JURUk0/bEgfvJcBgpTXsjHQZZtLutOkOPLdIwglTA+pSba6yKhr/KJBMCwDKPXygnGnKZr7/tiBrKRA/kOf9Lcz2xTOgMvDUMIzJzBa1EBTE4vKtaZo0u6FOEa9yYt+6nt1jtSYuZuOm8NVFeUIhdmYaZG5mduKQct8fFxbsLMPIqrfxsGPuezpTcThIvZJsorJ5rd7eG0Z/b7EPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o79RHz/CAg8qy9Dn6qNmhwb3EyAxTuHbwhADex3zGm8=;
 b=k65R+qYzcveWEsZ7g1gJ9G2YSFpiPv/awVA9WK5jG6sFEOt6FHAYBiR8GZ/auWELMTANfzGlHe9AlseReOPKOg77FlcKELKby1fRfvcwAw34gyH2zQxKoLQQ/N7+u/r2Iwi+Rw7nmYHVLbtP4azixZKxTXruq1yoliXmBb7XSHk=
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM6PR11MB3307.namprd11.prod.outlook.com (2603:10b6:5:9::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.16; Wed, 3 Feb 2021 10:00:07 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::519:e12e:e1e1:517b]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::519:e12e:e1e1:517b%6]) with mapi id 15.20.3805.027; Wed, 3 Feb 2021
 10:00:07 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
Subject: RE: [PATCH net-next 5/6] i40e: Add info trace at loading XDP program
Thread-Topic: [PATCH net-next 5/6] i40e: Add info trace at loading XDP program
Thread-Index: AQHW+QpxBEoCi9GInUKx4Tg4yRhaSKpGMgfw
Date:   Wed, 3 Feb 2021 10:00:07 +0000
Message-ID: <DM6PR11MB4657968657193183F2082BC79BB49@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20210202022420.1328397-1-anthony.l.nguyen@intel.com>
 <20210202022420.1328397-6-anthony.l.nguyen@intel.com>
In-Reply-To: <20210202022420.1328397-6-anthony.l.nguyen@intel.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [5.173.176.249]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2d8be957-ba44-4bad-bdac-08d8c82a7c36
x-ms-traffictypediagnostic: DM6PR11MB3307:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB33070F674ECF285F5E0DB3029BB49@DM6PR11MB3307.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JA0iNiyDy4jA2oYejzDHBftOnvbOT0QdOwOZP7tilAVUE+eY40mI2nHwls9Q4du9vw8Ah37KzecdE+oxrJjXeMA73PytUGjVkYcE9WnDjn2opi+tLC83bi9sFXuKer2k8UjGPMjRBvOFJCyYt/hrK4W2+XO+vj6Ut+nEvgy3oYXt5QJe4sG3mMoyzQWwXqoa+RQJM29YOvJ1k8JCio0dHHjrh7++f5/0l1mZm9VX9T4It8sGqEKQ7hWDy+L6pk//F9GBlJ5wguJNATvKT4fKVf23V/hWD029sYxUwPElwC8SQP3ko0CTxWUDW4Md1LJ0v7bXpfvmNID+CNDc89ISguBTI4gEiiv62XLFY5UzWLF/QjBUDbvmDLagdhlGD/XOnjQnHLnP+z6SzeTKc44eUnpHfB/c4smEiFzHMsLp30MPWDchtjWfk6V5b1NzmndK4ZBErhqZEpYHc6OIP66BJUiSoRrJlc1aONpdBIe9WwQfdibw/knWmLIUPL6EvU73akghYfAVD8vIaiTwQuRwcA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(396003)(366004)(136003)(39860400002)(346002)(66446008)(83380400001)(107886003)(55016002)(33656002)(6506007)(478600001)(54906003)(26005)(86362001)(7696005)(66946007)(8676002)(52536014)(5660300002)(110136005)(316002)(186003)(2906002)(66476007)(9686003)(66556008)(8936002)(4326008)(76116006)(71200400001)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Qko6+hxs45KZxC69mfCZOVjEzlZPSYqyqhnZbCcgX1GPLXfhfm/7+peBiJb9?=
 =?us-ascii?Q?Zrxuubf/woMAzLCxkDBpC78MflANJORY98FK4TcIuqHjPsjlyzXTG75sjoc/?=
 =?us-ascii?Q?WZBvyT5/P7gPJofHksa3dsqgOUk8BYBIQzJi/sXq53vw+yQSiUZpKQbdtwJ4?=
 =?us-ascii?Q?HJ2ueh4p4vOe1fFMbxyhGuoTvXtQF3pEWiHw8OMReg1HwvKkh7XRySbMFGVM?=
 =?us-ascii?Q?LrNeegBxka9eJQN109GMrp6HMpxWttlpcdg07P2kQIC7iLeur2mWn40p+lxw?=
 =?us-ascii?Q?YIcqUnwPQuhOCSp4fWOvtlJY+XRdKrbE2OzKo4soFdBXcN+GxQwrUAq4MNjW?=
 =?us-ascii?Q?5P0pkVzVkqrCCoC4eMKR+jLcwNNT0zAOfvnJD0A8nURbKWcgeh98O1P+YvQu?=
 =?us-ascii?Q?DiOKHFbV5jo4HOSMoCt+1G6pQxS4FJZmXLlDF82onuemEOzzoMHZOjWk/SQ2?=
 =?us-ascii?Q?UnXGF/amC1L/y2ue6JkbPsG5pRW9U5+cqcu0PQll4A2ivczRPBy1gtexOgFO?=
 =?us-ascii?Q?liLuBpazvuBcTlq67GCmaRNxsA8e8u9JABx6YimxO/3dEzoPwL+PBYCyf8gg?=
 =?us-ascii?Q?zNQ5iAb5nPerykMDQxjvK1cUMHvVrvjdjIEGPwbHhfbugz59scwzy4CKRFKk?=
 =?us-ascii?Q?edd3OgMKenYUniZhN5FOIrS/4CVt9cLHNjFq5pYOOzD835l2WMDJo23ln8Uw?=
 =?us-ascii?Q?Y0lMUvMa8WiNK94H5z8hvserqOs0Kv0LvNz3JGX4c8SOfvd1oOG1PScXHiW2?=
 =?us-ascii?Q?zedozHGhKn8A/QSKChBlbOeb9xTqpEOxPA2xL4dohf2EVBWt1Jw1ovNab0C5?=
 =?us-ascii?Q?QPA2lwgIqq+bhcPsajFdps7lQ6uzKLk7M19Y5zEZZe/QaJDdIUYJ23MXmHT7?=
 =?us-ascii?Q?JH69kZRMoocle9glAnZy9qlXgSJ/19IkkfU36zynLUBMUokH/kREOZVhHM2I?=
 =?us-ascii?Q?gfbdSH8jybA4UoKMMEDcH7rG2GMV/PPdDSBir11OqzsmIXKGzB7NiKoeBxC4?=
 =?us-ascii?Q?aCR2sPue/fwVk00PGIMjibyvHgOkYtTF+ueRsJImWHeRVy1gJvHVJdpm4zcA?=
 =?us-ascii?Q?dg2ZCiW0?=
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8be957-ba44-4bad-bdac-08d8c82a7c36
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Feb 2021 10:00:07.0292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OCUeqI7LgCrLVycjoT8HEg8dc6hA5WArmrRhrLeVRQqlD0ww+lZ8BXYIyCgzYKzKXK02fUnA6pl+Q2picsVjk8q/XcIl0V+81fiELgaHESw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3307
X-OriginatorOrg: intel.com
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kuba, thank you for the comments!

>On Mon,  1 Feb 2021 18:24:19 -0800 Tony Nguyen wrote:
>> From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>> =

>> New trace indicates that the XDP program was loaded.
>> The trace has a note that in case of using XDP_REDIRECT,
>> number of queues on both interfaces shall be the same.
>> This is required for optimal performance of XDP_REDIRECT,
>> if interface used for TX has lower number of queues than
>> a RX interface, the packets may be dropped (depending on
>> RSS queue assignment).
>
>By RSS queue assignment you mean interrupt mapping?

Yes, interrupt mapping seems more accurate, will fix it.

>
>> diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/e=
thernet/intel/i40e/i40e_main.c
>> index 521ea9df38d5..f35bd9164106 100644
>> --- a/drivers/net/ethernet/intel/i40e/i40e_main.c
>> +++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
>> @@ -12489,11 +12489,14 @@ static int i40e_xdp_setup(struct i40e_vsi *vsi,
>>  	/* Kick start the NAPI context if there is an AF_XDP socket open
>>  	 * on that queue id. This so that receiving will start.
>>  	 */
>> -	if (need_reset && prog)
>> +	if (need_reset && prog) {
>> +		dev_info(&pf->pdev->dev,
>> +			 "Loading XDP program, please note: XDP_REDIRECT action requires the=
 same number of queues on both interfaces\n");
>
>We try to avoid spamming logs. This message will be helpful to users
>only the first time, if at all.

You are probably right, it would look like a spam to the one who is
continuously loading and unloading the XDP programs.
But still, want to remain as much user friendly as possible.
Will use dev_info_once(...) instead.
---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
ul. Sowackiego 173 | 80-298 Gdask | Sd Rejonowy Gdask Pnoc | VII Wydzia Gos=
podarczy Krajowego Rejestru Sdowego - KRS 101882 | NIP 957-07-52-316 | Kapi=
ta zakadowy 200.000 PLN.
Ta wiadomo wraz z zacznikami jest przeznaczona dla okrelonego adresata i mo=
e zawiera informacje poufne. W razie przypadkowego otrzymania tej wiadomoci=
, prosimy o powiadomienie nadawcy oraz trwae jej usunicie; jakiekolwiek prz=
egldanie lub rozpowszechnianie jest zabronione.
This e-mail and any attachments may contain confidential material for the s=
ole use of the intended recipient(s). If you are not the intended recipient=
, please contact the sender and delete all copies; any review or distributi=
on by others is strictly prohibited.
=20

