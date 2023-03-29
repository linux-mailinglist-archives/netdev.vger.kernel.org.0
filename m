Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17F756CD71F
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231417AbjC2J67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231234AbjC2J65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:58:57 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3702F1AB
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 02:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1680083937; x=1711619937;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=KsgVA0loi3ciNBi+YJSJbOl8b4gjgB8+9BBKAQeS9OM=;
  b=PghWwc9rm0O47le0GdYABHWn4mrpA/B+M9wUrecjLNnWM9zGG4nOgDSQ
   NhCSLl3M8Zy4J3P1jBIDGHgZigemKwxxbwLYJZEzQ0ezEd8UZb3TCPGag
   IMUPJSRUaHUz7fozi/9stKZGxm3AaDrm5ZPHEZGIoeweCh+3vCon1AWgm
   jLtNl3ktf2xDHt/7ulAxTJ6I4taYy1eJsQJwd62Oa93va4mY852wu7nIi
   TeCFA7WrF4EQFrBTgjNVZyoWp60RkH7sUYZBURt4XhKQg7Ex1l7m5NwEI
   7T+tEktVVYAABYdtaDkb7ruvZg6cyEHUuqzui5o9eTlNZDKlEFGzW1vHe
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="368603675"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="368603675"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Mar 2023 02:58:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10663"; a="795171439"
X-IronPort-AV: E=Sophos;i="5.98,300,1673942400"; 
   d="scan'208";a="795171439"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 29 Mar 2023 02:58:56 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 29 Mar 2023 02:58:56 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 29 Mar 2023 02:58:56 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.21; Wed, 29 Mar 2023 02:58:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ebrhQJUCmh4LuqIKxCedz8QxvkJrHYgOfjrtTf+ducgwK1oIEhi9i3ePseDLeRtgz/iVpBkgIK9tWsuYObU6BXZPJLUwHy8gJLMSblmSceRYousopWvgTArmJwYYGck3s3kAISPJbohzJBrLd0sYQU1xHd+8IJV2e2VrKJJ59ZwHHd3SKpK5mdjItCgLAp4ZMx0gyZCQINoL7YFR5BgT5jXakz21dExuOJOIh+OWQPOOTVtKi3rb4nwAcrf40GU+9MtYg6t+IIu/sDo7koz1AIXztIp6j2QxhunU+uuw/EYsNLDL3llvKhkHCkn+i5GwM5zLZorpmQrb47/83V+DMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6RjGCxG39pLjb501Uoj2M9kkK7MgPrt5sohMK3MbAVM=;
 b=gmUJE/GOWV6vgcnrBA6u1lg2/VC/Z24KvRt2WZ3vC5u0I7aDkFY/jzebHeyzumBwPsxwpsPVKJKW4xg/XaRATVAgjF1A35UCDqC6xeLGWatsdcYUD0QbMMiGCPLvGy0Eg6Y2P2oqwgWu5RyvrV2528/o6Yn7ZE8/1Jw4kNq5C65tI9thfwb6cQTmcpsR+6toy0PJHG5FOAWE04de46RGT9zdnW3Xfx+qp1yF3QEZiXTjTC8/66OfaOVDfrmBsLp/JrotRonQGYVmV8ymVbdIZs3ahEk9jNQeqYLIw3s/gQ622IaSA0e6PJYya2NkO1cL7qMZxQPrOB83cqK/ItZw8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5800.namprd11.prod.outlook.com (2603:10b6:303:186::21)
 by PH0PR11MB4856.namprd11.prod.outlook.com (2603:10b6:510:32::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.35; Wed, 29 Mar
 2023 09:58:54 +0000
Received: from MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::bf39:c299:c011:1177]) by MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::bf39:c299:c011:1177%8]) with mapi id 15.20.6222.035; Wed, 29 Mar 2023
 09:58:54 +0000
From:   "Kolacinski, Karol" <karol.kolacinski@intel.com>
To:     mschmidt <mschmidt@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
CC:     poros <poros@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH net] ice: make writes to /dev/gnssX synchronous
Thread-Topic: [PATCH net] ice: make writes to /dev/gnssX synchronous
Thread-Index: AQHZXmy419UbuKmoMUa8AYIwt+2bjK8RiWmc
Date:   Wed, 29 Mar 2023 09:58:54 +0000
Message-ID: <MW4PR11MB580019D13E9E393B1993D89086899@MW4PR11MB5800.namprd11.prod.outlook.com>
References: <20230324162056.200752-1-mschmidt@redhat.com>
In-Reply-To: <20230324162056.200752-1-mschmidt@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: pl-PL
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW4PR11MB5800:EE_|PH0PR11MB4856:EE_
x-ms-office365-filtering-correlation-id: 1fc43131-7c85-4e05-16a4-08db303c3497
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4zrLQRcl0tA6d8yhvAwqOi1WecJcxY8cVOhZhq7vzeLGZeMEu1xIYpLOolLJf3mWzxw7k8bmLnxSanm/ZwIYA+yaI6NMimb6M7CTwzxZDtqJemg6zPmx0H/KBhOr4ik4qMystt2WwwacbSYWjtXnMWwgpM1L/hzab0+XbtMBVHaHB+d3p9rEY+wQlmr830nKEppsvt/TFJUXJiYoskQLikVCLDzoMiFCjwJ8Z7uAMi997K7ilRjPx14xlaoxsI1A8lCcgpzfRT3lWOnHm5Q9Vzb7dFJ8Dc4+XL+6bxfned/ULeL/qkMlC8ig0lvN6v/pu4Yu/abk5NbhjhrINxmuNSJyIZtNvPApxm8W8oExljUjIDMNQhL1JnDVWc5JnaTUIG4okfsWX2KIL4ZP/VBSlYWC/EHpOEGGIqwxCO1va+F97gQPXgz9ZLkPqRlL6xSV+/PJ5VX+uUhAUtq4m8adUwWuXCVxuFNh/1nJinhpivwrzAex80d6KElRe0Dsl9AVIGZd16VBVKNYsfg3r0vbcqAop/e33Pp96DlVhKMVxBVqDUVr6/RieE43KhcJ6AKqRUN+Y1lbWjP6AUUZ+qXEUHtFLTyH+eYq8y7NmDwburIz17SajBXzpjkH8OkEnlOQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5800.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(396003)(346002)(376002)(136003)(451199021)(83380400001)(6506007)(71200400001)(26005)(9686003)(478600001)(7696005)(54906003)(6636002)(66556008)(64756008)(91956017)(66476007)(316002)(186003)(110136005)(76116006)(122000001)(8676002)(4326008)(66446008)(66946007)(82960400001)(41300700001)(2906002)(38100700002)(8936002)(4744005)(5660300002)(38070700005)(86362001)(33656002)(52536014)(55016003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?FqVoBqCEULjO5Zo92tGw3NVz6Dyxmnh4ib5rE8UEy18SCSQOXVOGJKKlx7?=
 =?iso-8859-2?Q?hUv60IJzPfthSIfdDYjXI9aoXpPURoYPJBr2/u7lJaFOM95+CKrd5RQAJr?=
 =?iso-8859-2?Q?hl2L4w0CWcQGzEKjRUIadSdsboZJu94D4X0j2jwGJYphB2c38fX6ufHagD?=
 =?iso-8859-2?Q?rsptXi17pGmTiXhEI6jwe1uBz3lH3qSwYbQim6waPdrWhlims7YdnFXLNo?=
 =?iso-8859-2?Q?8yACkU8FteM3UzP5Ia4TSdopRvX3CKMSCmMUOXt5W1elhaX2l7Z8IyO0rw?=
 =?iso-8859-2?Q?oatwNy44kO+GoZmpaemk9T5zRUNrd7yZiEz6Do7rU6LCZDmYhH3AWuEynJ?=
 =?iso-8859-2?Q?I8r28LgszWvUhQOxmB+/rKPOzqsSL/GMjrAHxqV1WjAbNFAoeUViAYP/RE?=
 =?iso-8859-2?Q?UC9tTX0fdkURwwZRAabMmfI3P8E7JfVwoZqhZn9r4Sty1si/Eg26YwzAnx?=
 =?iso-8859-2?Q?42D76PobOdje+5MYdianUdDXJjxwF57K/ZDnOYDLA8YVz0DtzZfgIdd+EH?=
 =?iso-8859-2?Q?QSqE/L+lyuhaaI8A/C5SiTNTGMgnDW7j/GJPT0HJ2iJdW1Y1X4AkNSVmjs?=
 =?iso-8859-2?Q?nUw1lG1yEkxe3JWQ5VTH1AymmEyi0qo1+vP4T5L8WUmlQRtmN+tTlc+3vS?=
 =?iso-8859-2?Q?XbnmYlFmcpDx+fSk8pTSJvxb58Pfagt/Wq6Ezv4z4skt+6dFwEWu78yLT3?=
 =?iso-8859-2?Q?mBl44LRcx/wwMHUiVt5glhdUfJ9W97mW7gMkbZJxCk6TM3ojE47B3BRfw1?=
 =?iso-8859-2?Q?X5fvANwhSNBYV5tU4yxnheK0LQ+KDQBsKL+sasnaJwjOgbAfmYVqAvROin?=
 =?iso-8859-2?Q?+XsOZKz2W0mIaYQSnmDQatHD0bhBQKdiKfNKdDUgU48OSIPPzRPxOfWPN4?=
 =?iso-8859-2?Q?kndUvbydL/B5+raQ/GnftY9Awi5z2Kq/EVhcAWjB82UTsyiE8FHpIUAWq3?=
 =?iso-8859-2?Q?QvvTH1X8gSICHvVBdozhE6l6wdUc8RhirVIEf5j/2OY0pvRdxMp/h5YX4U?=
 =?iso-8859-2?Q?nQOdQnifOsYg152LzMWl6Lak7M9Prri2X3CUdRH5TKSPS/j2kmKn9e6PRC?=
 =?iso-8859-2?Q?Uiy7gDqLHrDFrNOsfkpP+rLlHOq0vxIi/WAqvhsBeOQw/p94SIs6uaFOYZ?=
 =?iso-8859-2?Q?pEsDimNrUI3TgKjvug/pWIcodSGt/Zif1OZTHdf1aQV36SLUuCM+6U4GwK?=
 =?iso-8859-2?Q?Qgvv9xYq5itBznjdxL5NDlMC33XkZyZ9PXwT6XkCzJNA8aa3UVPYD942+h?=
 =?iso-8859-2?Q?XqFM3JDSh1adCxtyBzUhkHVY8KK7i8aMWi+3N/hER3Afuaz94MKoRCPFfM?=
 =?iso-8859-2?Q?KDPQvCKvSEgdi0cmBWWX4W0MhYOAjjsLDfA4AYwqXPy5FS/KjDetlro2V+?=
 =?iso-8859-2?Q?f8EpybjOcUyob2hjDF4d0Ts0qOKSo39qgBFbsXKIL1s3/n7HiX728PcR4w?=
 =?iso-8859-2?Q?n9YdAlVxR8HBdzjctkmt6kAw3+hYt8OeK6Ghnvuz77J6Xsyb9V6vmJV3nu?=
 =?iso-8859-2?Q?EucTEsUBN6pBwN7jmLDHEAYk/YlSJGPFiE3nVRdrgvk7HlxA/oUnip1ccC?=
 =?iso-8859-2?Q?s93ihalJX2vHIEr+TyN/gA7AS8vO1uTohA5akOcPLjV3kYW2niUMYNz0To?=
 =?iso-8859-2?Q?0s3FpcLVxTJ/jMYzhCVN7rLeXiysOlveRX?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5800.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fc43131-7c85-4e05-16a4-08db303c3497
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Mar 2023 09:58:54.1020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: boo1+TUr2wcmRzQayQq/sAkHf799zLBG6d8y6d5NPlLAixy80C/cuxkOmGPf/ahZqGX+mKNwfQ0NauuYGUmKf/wYRtrbVrt1YFqRazsdUy4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4856
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,=0A=
=0A=
Thank you for your patch - we really like it but need some further=0A=
investigation and deep testing.=0A=
=0A=
>  - The GNSS write_raw operation is supposed to be synchronous[1][2].=0A=
=0A=
Synchronous writes were present in first design but we experienced=0A=
multiple issues due to the asynchronous nature of our SW -> I2C=0A=
interface.=0A=
In the case of this patch, I experience terminal and gpsd hang and errors.=
=0A=
We need to check it on more different systems.=0A=
=0A=
>  - There is no upper bound on the number of pending writes.=0A=
>    Userspace can submit writes much faster than the driver can process,=
=0A=
>    consuming unlimited amounts of kernel memory.=0A=
> =0A=
>  - The possibility of waiting for a very long time to flush the write=0A=
>    work when doing rmmod, softlockups.=0A=
=0A=
This will happen anyway, because I2C writes are using AQ. This is done=0A=
in a loop, AQ write can sleep etc.=0A=
=0A=
Kind regards,=0A=
Karol Kolacinski=
