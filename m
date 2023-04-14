Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 266ED6E203D
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 12:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbjDNKFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 06:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbjDNKFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 06:05:37 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDB0CA256;
        Fri, 14 Apr 2023 03:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681466694; x=1713002694;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vJ8iw5t/QEHvF2JLl4JszZJXVzQpXWMGfubzgdRjk38=;
  b=AFtN3SB78arwmIkonGLsFVDBGca3GVImzGu0SFiNOOz2FO8f9mbADl4n
   57E64spcwaBkn12GpwVUpl5NbPAUbu4d3lHInE5ru44goCLqAf+dLCqtR
   quhXbE+cAoD0nZTkasbB1HZB4mzt4QPYuWYvhZbHYRFvxSh8Hg50QKpHw
   ikeq7AtRxWoAyyHL4cKOIAXpz7c4h3zxrddhfwayBBhoWBrv0D9GkMf9p
   eUOuKnR17jx4FzlpFGz0NumQt0eDSYREJJlltNFdmRB0CfEpkaukKsbFS
   E6sEHqkFMvuU5HCSYZoRx/6uBb+AYuwIjBjXJd77rNlswSQb1FzAzlwVM
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="407302444"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="407302444"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 03:04:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10679"; a="801148031"
X-IronPort-AV: E=Sophos;i="5.99,195,1677571200"; 
   d="scan'208";a="801148031"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga002.fm.intel.com with ESMTP; 14 Apr 2023 03:04:09 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 03:04:08 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 03:04:08 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 03:04:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V9e8ttAi11qLz496+1cce7mMRTDi0COFsT3uwwHSGozO+dtAKYh0k3/1npAfupCIgnYOL4XaqblQ+52PxJ+QEJoKMfI2LG180TIAEwMLqoMn+jlO2nXVo0EaRXitIheyCKqyjpXjis87HgaSpj6mdyZGRlSlV9q3tUgbItx9DA9Bjq2AsacncoZaYTm9v37K2VeIlAaojSEOPC15P3eO5W15OsqIxEH4RDLFrcsVhFt2k/+d7a/26AqbHq5YlIQupVxWcbPrJmlJPDETMZclPUSyRnOSQ14ymwTLyuE4sKBy3T0TMnT2qDKlwHxNEdw9g7iw025BrrCZTG1zjsiyWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vJ8iw5t/QEHvF2JLl4JszZJXVzQpXWMGfubzgdRjk38=;
 b=bgOxSBnFkuxPdrLl4EsaRSADaaCGaaniUddF693xMAxZyUSuNYNVfVGAyCN75bAGCZpk5XK9VskSpNOz65sqXX7cgw9Z3x7pCQGQiKxE769c0w9sL8rSpU6uw82DgorbmPom6W08HZ6pLc9e8qND8kBE8gzdUvD0Zy07ROZOV4nSIul4nBlqixFq2iSM3d8BdcBmRYSPmoP2vfylzQlcGHmy1s9HRM0nGgFJw0sjIUCFqf6PcIf+pmJFFC2XxtVg0Niz8yBPBJroNV8/3rpjQXTNmUBcZ5pQ+WRDnUjOws27cFr9Zt85xnaEK2GAH8DatzDnH/YE7TqfDi9YDQ3TZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 SA1PR11MB6687.namprd11.prod.outlook.com (2603:10b6:806:25a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 10:04:06 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8%4]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 10:04:06 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "jiri@resnulli.us" <jiri@resnulli.us>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [RFC PATCH v1] ice: add CGU info to devlink info callback
Thread-Topic: [RFC PATCH v1] ice: add CGU info to devlink info callback
Thread-Index: AQHZbURL//7N1kf7H06LoNzMTKXBn68ol1EAgACoMpCAABhVgIABPbbA
Date:   Fri, 14 Apr 2023 10:04:05 +0000
Message-ID: <DM6PR11MB4657EF2201A5E110697C9E129B999@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230412133811.2518336-1-arkadiusz.kubalewski@intel.com>
        <20230412203500.36fb7c36@kernel.org>
        <DM6PR11MB46577E14FE17ADA6D1E74E789B989@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230413080405.30bbe3bd@kernel.org>
In-Reply-To: <20230413080405.30bbe3bd@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|SA1PR11MB6687:EE_
x-ms-office365-filtering-correlation-id: 8d397050-d098-46da-71ea-08db3ccf94dc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ne2WC0SCN5qRZNEB2o+vyHs6zqBlFJE6Yga5v93IG+NQON+bNLd0IxrmzEGeOZtuOf1rrQL59LJe0px8kQ5/aOMYY4paeSNizlarlKgGfAO9aJ2lEQ6DbMWOa/44C8V1IiSik4YqHsgU2+8oiRO7M7B7p5VPLFxrZzgA61zOtKwg4a54lMB8XpRj1Ytl1ij6NpSWGhBkux3CDrILgxZ+8RHMWhiiVV6kkD/fNGqufvSOPBJiWR8YbdmdpGMXPyPcgxkxiQXNRaynLms+SCioaz9THoYpl0GinX8OIpwStXoaEKs0pRhdqdAl2wtjdTSPLU4iCKUNWqGdJRvtcLakENyIEpcE6VNzNkEhzRHhz8jZz/F+X3L5vWAaOIcQNyrAoMNqjIxeUsfVYJF/g1nfjyrUtmUqUO96ZK9B69ftBKGnW7eXB1Yi2WUk5STTt1at8DN1aKYbFkHdXa9WAU3NAz6aC6uweC4IFZsJkTd7bfe6jBbFUuhOdvhQpmGuYYvVX60C8uipLDF/CtSCnVSSrSOPcLBBCPeDZ5mkafu3ibf71t6GVO2ekpWrZ/75jrccU+oDefKQo2sjx9W8zr6lQ7rp0XaYpPE/F2KfJ1w32chR0d5gL+xLyOrJ5sz7eW+n
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(346002)(39860400002)(136003)(366004)(376002)(451199021)(71200400001)(7696005)(6916009)(66476007)(66556008)(64756008)(66946007)(76116006)(4326008)(66446008)(2906002)(7416002)(38070700005)(86362001)(38100700002)(122000001)(52536014)(41300700001)(82960400001)(5660300002)(33656002)(8936002)(8676002)(316002)(478600001)(55016003)(54906003)(9686003)(6506007)(26005)(186003)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?0OiKSa9hnQEEXhaF/Ke+X8y3hGBTQBzL1DQ8m4ZdaP8iR7Jwjar5BoI6nkZd?=
 =?us-ascii?Q?uSgFOnONJ98DzLgCzDWgfM8jUr+/iq011FZcYgKnR3s2JLjsUCQOgOcLiGtY?=
 =?us-ascii?Q?XZJuNxIKf4QVl2s4b6Ssw4Dxx391kVdzM0mzc5pkVUqtlQxL/iK/ab8rDvws?=
 =?us-ascii?Q?Ne+6D92UZh0cfyKA5kL7N8Ps6WHD4VmxVee8hnAqqcLFe6sRN7NhKlBBYapr?=
 =?us-ascii?Q?zdNZHAB08pRvpWH2N12UzDG1fO833l+Sb0RmlJ7toGcUNOZv7hCvmIz+wn8K?=
 =?us-ascii?Q?kNtGlhNXUgeruaAXOItg5a4moX76WGz0x2YmGQ0XQ0fZkGblhJThBqEtr+JH?=
 =?us-ascii?Q?zKVGc5VNvZ2A+vvL3CALpRXaki6Ta40eEQPPo0MGNoa3apu/8y6Z1g/joQgK?=
 =?us-ascii?Q?Chs8LG7BDID1H67Giok6ACt3W4of0m36eg9CFeWSzYAItSifmxRpbn+oiu22?=
 =?us-ascii?Q?eKLqV1RYrQgKEZkLW5s8hw55SGHzWVvO3yiUH5B+WWVtyvfVf5oe157nHLVi?=
 =?us-ascii?Q?ujiTyjCPZcsru1qaGMNWY+6gIvA64bfswWiXAz7ta6KvdSjdF94wur4vhuYH?=
 =?us-ascii?Q?BSK1aCYIgfAXncswGCDySGyppTPtlpgq/pY2Z+k0ztWQIYzNy2NeFJKR3Ay5?=
 =?us-ascii?Q?q720d8rm3lw5hXpyrsLq4UyM23jA0oNs+z+JcX9yXJ7oJXSQ7fvX9YadTxE9?=
 =?us-ascii?Q?mUgYP5epnsEZFfFiEllZJj+2qtN3g2keMtBzUYuuL3zJu1iR22tfaumL4+Q1?=
 =?us-ascii?Q?WbAcEgy3VCGUSo8Ny7Ol+QP3D+7sgMwl+CaBVhu7uuR9Wtax+KhanYC2okBk?=
 =?us-ascii?Q?u1Vki/BlqvUjPJldb3Am2zVzrIg2EqSG1nYQZEWilvdSIvk01mSNGvnJf2Fv?=
 =?us-ascii?Q?wG7ZGQnLJr7Msfk7eHIYNQb0mv00+JTxGftmCIkibwkfE9VvaUv7KSVe0KMW?=
 =?us-ascii?Q?tmp7OaM1K3cF5rKfzGDUi4m/LgRQdSc0UpxX9GSltMBpZN5bgeA8VaeiPIHP?=
 =?us-ascii?Q?PofbPQn43uBa0FAGniAs+p8Ll1K6fOzVhaXGod3dc5XXsl8jkkvPmmayia0k?=
 =?us-ascii?Q?tu4wZC2GQxN/BaI+9J3r7+XYhQbY+cY/FjRR0KYo2MDRYQqEVpv7+283Phsj?=
 =?us-ascii?Q?iPt78GkWkNPiHWRkajDxf+Rg0iRm5t6KWK6lvejP/VabF1fdCNaTKmEPhmej?=
 =?us-ascii?Q?HwHL15cn4MwFJssfpYanyJu3+I+rVJSRAePLhAxW5gajYnQ7ZDdUNyPErqAq?=
 =?us-ascii?Q?AgUHI4WjH0sQQ6h5krNg4o8js2Vm723LS1BZa0h+KBCQtVsCGeVeQ7bFmeX+?=
 =?us-ascii?Q?o0koW/EenT4cAJVuyVY81NEariuq9a3tZVSrDMN8x1FvIXuepAK8Zn+76bz5?=
 =?us-ascii?Q?ejSNn5dhZnqGOjwaORh40vngJKhqxDpX+5qg7wlN4U0CzW/5L2FfBD3vAJ9D?=
 =?us-ascii?Q?PLjm0B0O7BDiFKJe+YxY4yhU+fXbTvABaTWCJwMN2LLmlNc1YJQ/gAlK82y4?=
 =?us-ascii?Q?Y5vBodfqIdhK3oQb9qtB9A7s3vLk85k70CbHtnyoMrLn/DG1QxSqJ8INvXOY?=
 =?us-ascii?Q?7mVGGCd9rkdB8joJHmkfqxuyITATgJQIk1F7L2I+CZwB5pnigyQWlXIyxnRl?=
 =?us-ascii?Q?7Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d397050-d098-46da-71ea-08db3ccf94dc
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 10:04:05.6182
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: AdX4zIre5ssUud1UXmRIFgs8tMUQJmleq1CjtbjGjynB0ZT6g1MuhyB6C0A++tb6OzKtUhuQWz5M0voRMyBYlLfaql1i3sANpAe8w1XfPIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6687
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jakub Kicinski <kuba@kernel.org>
>Sent: Thursday, April 13, 2023 5:04 PM
>
>On Thu, 13 Apr 2023 13:43:52 +0000 Kubalewski, Arkadiusz wrote:
>> >Is it flashed together with the rest of the FW components of the NIC?
>> >Or the update method is different?
>>
>> Right now there is no mechanics for CGU firmware update at all, this is =
why I
>> mention that this is for now mostly for debugging purposes.
>> There are already some works ongoing to have CGU FW update possible, fir=
st
>>with
>> Intel's nvmupdate packages and tools. But, for Linux we probably also go=
nna
>> need to support update through devlink, at least this seems right thing =
to
>>do,
>> as there is already possibility to update NIC firmware with devlink.
>
>Only FW versions which are updated with a single flashing operation /
>are part of a single FW image should be reported under the device
>instance. If the flash is separate you need to create a separate
>devlink (sub)instance or something along those lines.
>
>Differently put - the components in the API are components of the FW
>image, not components of a board.
>
>We had a similar discussion about "line cards" before.

Well, this makes sense.

Although I double checked, and it seems I wasn't clear on previous explanat=
ion.
Once FW update is possible with Intel's nvmupdate tools, the devlink FW upd=
ate
also going to update CGU firmware (part of nvm-flash region), so after all =
this
seems a right place for this info.

Thanks,
Arkadiusz
