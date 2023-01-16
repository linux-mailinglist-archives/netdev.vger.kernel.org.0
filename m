Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887BB66CC8B
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 18:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234721AbjAPR06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 12:26:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234617AbjAPR0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 12:26:24 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7282728869
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 09:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673888630; x=1705424630;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bPl6tAAYFlkqavk1JbKvbQnRg4H4IK/nbiopsFTVyG0=;
  b=ZZzATuiKVohAaBeP9Dvk9c7VXLLkgL1J4RcZDrmIYohbxextBOiBrr/j
   a5EAYdBrwDOMPoUREjolwLF9VryCNW9bg33j45jpv3aIU9q/pZpm+MssH
   HkNxpJZTxPVY5T8flMkOsQAQwRNvFU2PBlhKxS0yh5t1DV4Wbz6yz5GVq
   IpcJUO+qb83yttJr7IcpSXO5PxAZkeLvRMPqpEDG464X8KTBcTem04uXV
   Dq7SHPYRYCPQsY4tL/5DUbmV7gYMPM9B9ohLXubTZ4pQDeqiQcnSGiLe9
   9t5pWnwBzHfPwY6tDZX1UgeV792vRvuk+IqMn7khq9DZDYuTZuzV/TFbv
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="326563862"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="326563862"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 09:03:43 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10592"; a="832892170"
X-IronPort-AV: E=Sophos;i="5.97,221,1669104000"; 
   d="scan'208";a="832892170"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga005.jf.intel.com with ESMTP; 16 Jan 2023 09:03:43 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 09:03:42 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 09:03:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Mon, 16 Jan 2023 09:03:42 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Mon, 16 Jan 2023 09:03:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTfb0nyU6TAbHvbGAY8P+AQrnKk1NuCEyafTE7KJJz7eLrGD1ZtbXPIYskCC8WPrvMadnORkZMb6CqAe2f2BlRX35iuPXDzCEdwjWxuSItc53cavQ/UKzrLNQKqTxtx+6kQxhBMapXfVhbGeGoQpEiK7NKYuxiFPVvWREI5O+9auKKQnWkjvKxCzz5kPLcb1GO0v5ZW8ByMOOr/Laz99hkKCm9T/6HCeu+BLlGhG5JI7szsqLwEHjTG3TRFLuAs5++sxWQ6qpPpwPb62pC6emyNxhQCEWDHrn/lu+D4CBfvxR0fnmlAc5B9vwaEWf8qJpvRJ4q99dod9JKEILM5Iew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ClPmS/RwmGnPoI+S3dajDt6W3rq9bTt3OZKQUtlb7hY=;
 b=BCXWTIfrWdafnEhE4mBYtt/grkbvk2B23c/pDe0Vav4y0VHQASNTd88MwDUh/ByxkRGrENNRsYmB9gZR30JHBK8fAJNL3gtuBSBqCBqfXFbeLT36v7tzY5nDRO7F5bQlmruBYphxeA0Ui33Ipnuy32HIVKv7CjTNpBmEYUkiYKXTOJl6y+Q+jAQ8DKt+S4m0AHENp0ADBeEJ3HKuBux3lc3RBhG0KXEVyE1K3Jq997nmhCb7EdKkPGHeRWvrmAmFy2aa5RxMLYyyKwq/RnxH0w0w6CNHRvr6Kee7cor62rL04kcIzxesfo9j7K1l+fEaASUIWUDg816CSFodbRf7kQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SA2PR11MB4843.namprd11.prod.outlook.com (2603:10b6:806:fb::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.23; Mon, 16 Jan 2023 17:03:39 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.6002.013; Mon, 16 Jan 2023
 17:03:39 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "johan@kernel.org" <johan@kernel.org>,
        "jirislaby@kernel.org" <jirislaby@kernel.org>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "Michalik, Michal" <michal.michalik@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: RE: [PATCH net-next 1/1] ice: use GNSS subsystem instead of TTY
Thread-Topic: [PATCH net-next 1/1] ice: use GNSS subsystem instead of TTY
Thread-Index: AQHZJ5jICviMsD0P20+G2DeTiV1NFq6dfVmAgAPLyTA=
Date:   Mon, 16 Jan 2023 17:03:39 +0000
Message-ID: <DM6PR11MB4657338804C682B6A1EBF1499BC19@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230113214852.970949-1-anthony.l.nguyen@intel.com>
 <Y8JTsxcUsZHG2AHU@kroah.com>
In-Reply-To: <Y8JTsxcUsZHG2AHU@kroah.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SA2PR11MB4843:EE_
x-ms-office365-filtering-correlation-id: a88b3f82-59bd-45be-c49a-08daf7e39d40
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 3spFLNjhEAcK11WnfGEP0mlXBGcOrX+ODa1WIbJ3csYRFAJhkT1IdnvWE+4IEndxEq8r1MGuJ4/7e87C2xdrjICqTQksa5c7R0UZNUbcVF+tb+emFmaJQY87UQ+QHnwht0iuGfQRS7Sh0viglU88bCuOrMSeII0iqbp3GxnmM+01C9H0rlF3q/0UZ7fTehGEgOCThvShx6hXKp40G+9c6mpFUNfd1qoGf2oAEuuzRb4Wc1Voedy+ZtenxGag21XMwRxIhwMhBWdIAaOQrQpIS1+l6UJ0nWfVt9thMTWr1IqtbQ1mPLWWiX9+SZmNqbZxeVkSH2DXShtrk1igsqzMOXDBoSMCDBXhIrPhii5SKBCAbJA0peGwXfQ3TC4tA9Avj12vigIdEsEFBynAKrv6C6Nz6IP3gCcv/7X7WWwHdolJwvV81fnm1wHjOTn9jcpouQGuRCw9gTNODrKwU+qUM2ovvT/UDTbCU3umnmYPeCv1eGkNnZi4yU6Mn0pqJmQqbIzjTS0IEvEKGynUQOheGW9tn6OhaOG3tJuDivuVMzRZnd1l5VxhNwyPdukmapXJkVMlduIF0TUqOxFtH3Tj/9w5cvf1P8CPxREjJodYq7dWtIyGD9TIQA3R2M+Bl2YgCelckxL4qkYKPYYqZ4/fHD2zYHSC8r0STjID7nC8pt5ZcExwXUQshMT+PwPMX1+QPFjLjfk2xTO43eiClUhhGw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(396003)(136003)(376002)(451199015)(86362001)(33656002)(9686003)(26005)(4326008)(64756008)(8676002)(76116006)(66946007)(66556008)(186003)(66446008)(66476007)(41300700001)(83380400001)(316002)(6506007)(55016003)(71200400001)(54906003)(6636002)(110136005)(107886003)(7696005)(478600001)(122000001)(2906002)(38070700005)(38100700002)(82960400001)(52536014)(5660300002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XcpkA9iTHcaL2W30lxwUtADs/Q8YEamhfA/npVlTP7OiII4OwVU29AgY0lpl?=
 =?us-ascii?Q?fPK9NzxSVcDWfHKF4RZO1rrxKPvr2/dyJ++CkvyJos+OqJag7aOgFjjkI7gm?=
 =?us-ascii?Q?CmwqGmzH7Gbel7CoVGX+vSOpGq1ZRlWu81vVUuwmnGYY15sbQ1XG3NT9fIJ+?=
 =?us-ascii?Q?i8t/f1ochRLt43Kr+h9y1dm/QeVSeT92nFUXhRQE56GWLYE1EpElfLbeI5iA?=
 =?us-ascii?Q?yo4WOnSBoSjb3BQCOIQI+wXyAZP5PnutuiiIFkcObmrJI0hbj1d0d3azJkEG?=
 =?us-ascii?Q?J7GDwyfHlizVPkZhyy8UObckFuHLmpnXnJqKb0dsXYZJrSCABxdpxNuXhQsY?=
 =?us-ascii?Q?6npnIR+33MMnWmpjZaqy6OjNCh9j4OWFInQ53CTQvKAPqNUAR6QkZSQXb9oV?=
 =?us-ascii?Q?oWYf4w3EU8ADmmmIisLPmdEJOdVC5kBvBbR2m4+f3JQ/6L7HdT63lzgmKxWj?=
 =?us-ascii?Q?DzQ+bCyzbps4PC7nDz0IOAdmM7q3QuxJKF6nzDwKF1p6V9hiESAoU7InTVbK?=
 =?us-ascii?Q?u+vU7kDJjHbRlMcFJiBQPh4CJSWeHsddkqAsv/vqx8MuKWYyth0ax+OOK8Mx?=
 =?us-ascii?Q?b7Mci/hcK8S4AYsDtjOH9W4uV669Hl7hrlR0VgWk+FNoqeoXqh4MFoFUm7e7?=
 =?us-ascii?Q?LOv3ZD5dF0GQbapNmdoIWE/obtmTgSo9CUyXA1qZ9jw6ruZUuGpEse2aUkgt?=
 =?us-ascii?Q?EMJ65rwD7vieNKPuQvWcE1McVO6ecPEBJi+/UpKyEGa/YJshb+eVfWyax3/v?=
 =?us-ascii?Q?vWlAleK7aKWGnPzWFeio+/ClJDtbn2YeDSwwFbWD2hkoc1M1VhRcvIspDHRx?=
 =?us-ascii?Q?8eDtV4XMPO+LablUHfrVbA0XKf2VSCJo7zIsjkrdLpDRZrTkn9kmKKJkj/fP?=
 =?us-ascii?Q?mXrfff7/ynEM7qOlD/YN9alTAGEka/YUKmdRkKEnDzCA/8TOg0Ryp1TmDUbZ?=
 =?us-ascii?Q?+ppE/As5gG/1MUke4+eVXlJnWO46BQnSb13/jvVqm0DHXRSBeKLdTyM6Pv/v?=
 =?us-ascii?Q?eA0Fow77Ne5cyrSpCo10tV8IePe7uiA20x8bx+n5SMvc52uMzgdsih3LCZ3O?=
 =?us-ascii?Q?Ww8qb6htaq9n9CMGpvfYLnTxOMxh55gSjRHFU5QmyfZHuvdSkLR/viXCOBeK?=
 =?us-ascii?Q?wycORyUqmpdQO6WgWyZf3BFV6v0N7MbXlnis/ndy3vNeIzIp3l5BB1eycdri?=
 =?us-ascii?Q?bzzgw921ydwm8wopIqPQUkBQnKGonKtcsNq08M/+JFTMZRIzITonn+gf0zp6?=
 =?us-ascii?Q?oHzqQ4idr9A+ATY2wjI2TrlXk0VY1lpG0qGmL0x/B2QKngwx1AxdSWtK8Bnb?=
 =?us-ascii?Q?l5Jm8IN3mHNfWoZdUdBIIKv3VQBDkaJu5bh5w1vQSJQN6ZfJVbWrZBfbJSwC?=
 =?us-ascii?Q?gkH0aNC3hk62IVBJ3HnVmUDeZn4CuN7WU6f34mSTDrYyMAjEelsA14hPsWA4?=
 =?us-ascii?Q?mKHC5oqIfgb2gtQ8F282NYyYfXcrUyC0sqAC3J9jigyc3kx/MYvd61zanqK1?=
 =?us-ascii?Q?rWKPjNZ40ERyu6OSw0QEq+7VbO0YuQkx4zqrR2kQK5qk0vT8niu95xObXB5Y?=
 =?us-ascii?Q?By9dV0NnLUkm864i/aT3J7WYsgCf0NdZ9DeQrCeCUn0acN0AcbWVc7HA7MgV?=
 =?us-ascii?Q?Ng=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a88b3f82-59bd-45be-c49a-08daf7e39d40
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 17:03:39.3626
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WW6hpJvDaEkyZw1iteWbRpZ2CC1Nlcjl/x8ScQudGGdQEaLaVBS+VJw8hQDzxJFO3Rp2Gjdq4nlf668kpqIKntPfItozrVs6PMYdPowLjro=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4843
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Greg KH <gregkh@linuxfoundation.org>
>Sent: Saturday, January 14, 2023 8:03 AM
>To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
>
>On Fri, Jan 13, 2023 at 01:48:52PM -0800, Tony Nguyen wrote:
>> From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>>
>> Previously support for GNSS was implemented as a TTY driver, it allowed
>> to access GNSS receiver on /dev/ttyGNSS_<bus><func>.
>>
>> Use generic GNSS subsystem API instead of implementing own TTY driver.
>> The receiver is accessible on /dev/gnss<id>. In case of multiple
>> receivers in the OS, correct device can be found by enumerating either:
>> - /sys/class/net/<eth port>/device/gnss/
>> - /sys/class/gnss/gnss<id>/device/
>
>You are saying what you are doing, but not anything about _why_ this
>change is the correct one.
>
>You are also breaking a user/kernel api here, how is existing users
>going to handle the tty device node going away?  What userspace tools
>are going to break and how are you going to handle that?
>
>While overall I like the idea here, you aren't really providing any
>justification for it at all.
>
>thanks,
>
>greg k-h

Sure, going to fix/explain it better.

Thank you!
Arkadiusz
