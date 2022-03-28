Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2A1B4E9E91
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 20:07:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244341AbiC1SAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 14:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240539AbiC1SAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 14:00:04 -0400
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8BD167FF;
        Mon, 28 Mar 2022 10:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648490302; x=1680026302;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=K5Klvp2E2DyTI+73obw1coFuE3sYaxVk7zRXcCJh+5w=;
  b=mkijL23Tsah9OgOTm4Jcgr79Hk2ljyczkghUND+L5umC9udUb9lEsexJ
   o9uHXMmvC7fQfdpcDNWjvXztW2OGHSFdeXtLmVxdfUy2jrPhMKMhOqCyz
   XCLnvyWh435V3PNF7YZ3k/wzaE59lt6xZ1P5OvW+fpbLMZKV+4jhfzBSd
   5QQZT/BL3Ef9PukI0Fdccnwfa1JKWVM+LTtYioW+HHdGod8kHB0GbyPBd
   QjMesxTFSpyu/WAmxFnGJd5aCQtwn6LNfukMozNrWSQHRenx9MKecgRow
   xFa8FQ3Nt0G7S3RAn+//2ubDVO06kBEv2Zw9oWwd27gy/D984n8yJ9/IE
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10300"; a="259038861"
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="259038861"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Mar 2022 10:58:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,218,1643702400"; 
   d="scan'208";a="518307450"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga002.jf.intel.com with ESMTP; 28 Mar 2022 10:58:21 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Mon, 28 Mar 2022 10:58:20 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Mon, 28 Mar 2022 10:58:20 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.176)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.21; Mon, 28 Mar 2022 10:58:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ikv5WEyvbRdHM0pHcH5eFO8r0183isL04MWt0wXEeOFNMe3LhaRguPcQdra4G6itGxrujAT4ELG6xhPAktORIpUBNy17gtSkKBh6yoc3GDegJKyBTm5v0huwE9pwGAE9Wrumqv9QjgDhjstBJvcfqH4qx30N/sjZGQrCgiATbhb8KcEoSyETbAMUogJtAUCGzdGOdZgwJkGqfuJnNIR7M0cH7hlNLn5pSHW3efRcKa7vLcL9aRmaj25b4g4jJpRSQGPLCUUH9ZMnlZB5tGxW8CEm5OFmK9xzDtStnzjrBZrVEsM090F+ZA4GxjTFKFncg/R9rcE2ostUtsSXo00NCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OFBJ/9RnhCPn/6FTEHksQcb5Up9eiTjcDEmsxEGwYFc=;
 b=klAr3mw5lE1V3vdtFfJspV5Gh8eM6MDdebbwp7GTOG93FyhpPITtmqh803MQolvqucpRavn5zFvWOw/Nh8vwpw2NANI8E8/ZNGssn2rzGraiwxnmt5+xhXNOwunVLpGMEuknpS7duMNM2e3ikhbQ3w39SAtYLjA915srUaHdtRODCQ8BklevpVDtEaxE4vh5hQ4dTDPWyf0Aarx0QeJB8/tryO0nFggKlv5/OFdBncd9hO4jE2lymcIVzwGk9ZWo0XKIiv51nzSbtOHt+WRj31cuOF1cZih0bGjzzhKupC0Ix2llHjfVFb1pOPGB6ukzQRN0oCw1YnRtV/R0sP7Krg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by BN9PR11MB5417.namprd11.prod.outlook.com (2603:10b6:408:11e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5102.19; Mon, 28 Mar
 2022 17:58:17 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8%8]) with mapi id 15.20.5102.023; Mon, 28 Mar 2022
 17:58:17 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, mschmidt <mschmidt@redhat.com>,
        open list <linux-kernel@vger.kernel.org>,
        poros <poros@redhat.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "Abodunrin, Akeem G" <akeem.g.abodunrin@intel.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net v2] ice: Fix broken IFF_ALLMULTI
 handling
Thread-Topic: [Intel-wired-lan] [PATCH net v2] ice: Fix broken IFF_ALLMULTI
 handling
Thread-Index: AQHYQEw/k4hplRWYEE2HL3IQn8T+3KzVGglA
Date:   Mon, 28 Mar 2022 17:58:17 +0000
Message-ID: <CO1PR11MB5089929953C72CC1075D673CD61D9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220325132819.1767050-1-ivecera@redhat.com>
In-Reply-To: <20220325132819.1767050-1-ivecera@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7991c282-3c9e-4d43-0483-08da10e489b5
x-ms-traffictypediagnostic: BN9PR11MB5417:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <BN9PR11MB54178CC1EA9FAB4EDEF85317D61D9@BN9PR11MB5417.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0G7wSELJMRZz/6y6WFVf2f9aUwmH1P5wy5M3IaciYIYtJkm/VR/j5jiwjmaupNGwpy/aRKtJFEOGCJnKp5lN9BDpV635bCpq24VsIOm962W4a66rj5+5qU9waqm9GUHFw3enJpcTgS2EAt2mSK2xapw21g/Xa8EekGNTr0Ai6BMPChGV7cOoXYQQbxnJPl/+F7oKbR7GBT6x6cL31Hho+vqG34HSyCGnNpp4NPphYkpwV3WLk/vxsV7yMlQc7WiAHwHXx3P2LrruXs0cwkI97iT8XlzIl4da2wMGfzhNeTSt2MH8OMWoMIUYlmsatcFI6O9e+uDrPWnZgXvohl98ESf6WAhmC3yOOBWzLbvaeP2M35W4rVlKfXB8dpdRTNhVY1+2EW+OC1dnedWWdBrXEikgbvWzFhwB9QUoqJ0Vl/ghbrEGojCuDimCHrnkEq2eL2iLcNJTrkDkM8NRyvd9K9upMQylkvuba4JMj1v6l44yxp3A7MfBWkKYlvwI/VB/2xSZrKaJ972rD3Cw8ZQwt374OAy19taBhGwW37CkhY7YrilBHeomfY0F5daINkPf7fimbK1V74CbcaUTJvcG0Nwh5GhdDPVAVQ1I4UjAwvrk99j0t25YSdA5P3RJKbR6zzmYRNWEJ8GigV72hxFHQeq5+1B/pbH37shvX7jbSmkUbyYFVe4BPZwLvDfVkSyl67Uge+63WLCVAn1i/YiZi1SK6rw/4GD3whJaRVp2aBaw/Oa2XBVKiRL1xys5AZzY39k0XR6pa8iqgPh80/axGS2j85GQKD+l4nAFxh1P5ak=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(76116006)(66556008)(186003)(83380400001)(66946007)(33656002)(66446008)(64756008)(38070700005)(966005)(4326008)(53546011)(5660300002)(86362001)(8676002)(110136005)(508600001)(316002)(9686003)(54906003)(55016003)(66476007)(26005)(30864003)(7696005)(71200400001)(8936002)(38100700002)(122000001)(6506007)(82960400001)(52536014)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Gp8ezzYOgj17bduUd5jLmbV/bXf7tV6aI+lkYNk0oDK+GMVW/Q2NIDfhvU5c?=
 =?us-ascii?Q?xQzLa4WgmAXbT1gicEyV00qu9ffWP/pm54mjS4jZTntGeW425Yeelmdz985Q?=
 =?us-ascii?Q?5LLZxGAUPXwg3sGy1CKbcijEJxWoEYPLWSd4wERYq5va+rPevMQkzBwS87Kc?=
 =?us-ascii?Q?hTWB6HhwZc1IuuwAKws62XXdtQszmZ7ui0tjzVHoSTyvw0+8+bU5DqvLj/Fd?=
 =?us-ascii?Q?GMUu3eETuTvSVI3l6SZdDqhiHe1OqiRx/I2Rn0+Qh29/k3eomLKY4S+6GBSa?=
 =?us-ascii?Q?b/YPpOtGvXUCZA/Sdo3wDznpef2z7Caa/2egbYqM/oObHc3Wft+ffeluCINH?=
 =?us-ascii?Q?GzsrkvhhbEZiBIlD17vPg57so12/mOs8ipCRK7VDu+BwPL6Ywzjavgnzi6mw?=
 =?us-ascii?Q?TZDu7T3BXnvO7Do4U4XaRxAjZvdOJUMMJoGuklt5hpuUvomASepxARgVcpQe?=
 =?us-ascii?Q?+skwQr8LcKURYdSNEBJhveyyJCYBPZuX0eIn/IeMmaZreHH9haJMXOoCKS0w?=
 =?us-ascii?Q?FYXouh6ZLshLyq2aORcxJyW097LIID4JqOpiv+BQ4asJrMyT3SlkMwtFTUPK?=
 =?us-ascii?Q?7Uww7SY+d/m7mCmmxvdJACVLZR2OTG7tPwxvZ4qAV71g/0/VUtL3UEmgBNnV?=
 =?us-ascii?Q?s3AjA6draYaf8RqvxQ90alCbbsM1v5i0/OvT+1ENxqi+6uN1jUpCltIxYh7j?=
 =?us-ascii?Q?uGkFeSjzFVlg0ICBULpogU7qCSCNnoRpNTOElrM6WzvjvBmd7mGZH4XstzZw?=
 =?us-ascii?Q?9HwrX8ifxEG7Q61osD1btyzAmaGIpHdWes0zSJ18y7dv6yho/5xERB0kgj5h?=
 =?us-ascii?Q?QZMVO2DkfPt+MP9qDlsQhzztaNKTY7pLkIlcsBPzS9LJ+NXA7EhsCxo4JrxD?=
 =?us-ascii?Q?POi+UbbGrQcNSXMRCCoJ91Hh3swJlsveEHAWyiz9TUmyHc6ExRjUWNh5nadw?=
 =?us-ascii?Q?FUqX4iCP0gfWIha1vxXKdwBRK+jYEvP92JXdv15FZagO7iBfJgnfKTLbxkpC?=
 =?us-ascii?Q?/XeHgYe5ZBfFER2nO8tA2M92YYkK3QrpZxTQG/CKzq8wFOpOK56p78YddF0I?=
 =?us-ascii?Q?CO5Cv6YjMYHBnuuWc0JEyKMdqQoo/P+r/Wl7Bp9Sq1YpuU2v8lGUYEsp5Egc?=
 =?us-ascii?Q?jK7K7x65gWtNpk0PpZb+k4YhCkD6GMvvGuvFA1UXvUvFhI2E/VPaTBmiIta1?=
 =?us-ascii?Q?jTDF84Dzh1lUyS5pI0AaQirDCnq4b1Xe5wTQ6OnJwAY/BbeCcvtjGX4daBPN?=
 =?us-ascii?Q?8m6O+asRKe2sVqxczVasvDTDgomTqa77GMogcN+LEDW5p1n2WOWcV+gkcTk4?=
 =?us-ascii?Q?zTojncUTJ9h8ckmgeP5ot7cYNjoFd9kntvIxA4ysm6ya2UXxT8n6l/mNlPrV?=
 =?us-ascii?Q?3yK6oE2b5apwiohduiTP9ASKFM6S93dXtaaA5jsb0AVZnYfxjeQAi6zTqhXl?=
 =?us-ascii?Q?lx8H3F8xZ+5nH1XVE4RTTmXzQB3j3IiGlvj3pfEAyQoYTcbzGg+gQJ0y0Gng?=
 =?us-ascii?Q?ei/TAJQYzfVpxtxO3ACE0Sy4HxCiBH3uz/5ZlIdnzOpO3s55YylaXmao5/q4?=
 =?us-ascii?Q?YK8PkqDH6lwdrEtY2wjaDIoVD+KT055NoUXXRCGUhqiuwwPvP/8lhx0DVl4U?=
 =?us-ascii?Q?FVmgc40YOwdyr0AmrqYWq6oAto81eXYyuwyacfRLXomcPxh6DBgIwh16N1XN?=
 =?us-ascii?Q?zP1dHMZOVRKDB8eWJVfoAkBZz1VhDOy3PKp83yWpmDz797YjfNFUymGWi3uC?=
 =?us-ascii?Q?+lH/YawYcw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7991c282-3c9e-4d43-0483-08da10e489b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Mar 2022 17:58:17.3870
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MK8LEBSmb2X47vhsFOaK99y8xAQzJGB4FYT6t0+L5VabRV5ny7lDbgYbGs+agiOj/1WAv1n0Ydt0nYDhpjUrKKqRX+bAB0BvcU9lgx26yEE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5417
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of I=
van
> Vecera
> Sent: Friday, March 25, 2022 6:28 AM
> To: netdev@vger.kernel.org
> Cc: moderated list:INTEL ETHERNET DRIVERS <intel-wired-lan@lists.osuosl.o=
rg>;
> mschmidt <mschmidt@redhat.com>; open list <linux-kernel@vger.kernel.org>;
> poros <poros@redhat.com>; Jeff Kirsher <jeffrey.t.kirsher@intel.com>; Jak=
ub
> Kicinski <kuba@kernel.org>; Abodunrin, Akeem G
> <akeem.g.abodunrin@intel.com>; Paolo Abeni <pabeni@redhat.com>; David S.
> Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH net v2] ice: Fix broken IFF_ALLMULTI ha=
ndling
>=20

This version reads how I expected. Thanks for cleaning it up for v2!

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>

> Handling of all-multicast flag and associated multicast promiscuous
> mode is broken in ice driver. When an user switches allmulticast
> flag on or off the driver checks whether any VLANs are configured
> over the interface (except default VLAN 0).
>=20
> If any extra VLANs are registered it enables multicast promiscuous
> mode for all these VLANs (including default VLAN 0) using
> ICE_SW_LKUP_PROMISC_VLAN look-up type. In this situation all
> multicast packets tagged with known VLAN ID or untagged are received
> and multicast packets tagged with unknown VLAN ID ignored.
>=20
> If no extra VLANs are registered (so only VLAN 0 exists) it enables
> multicast promiscuous mode for VLAN 0 and uses ICE_SW_LKUP_PROMISC
> look-up type. In this situation any multicast packets including
> tagged ones are received.
>=20
> The driver handles IFF_ALLMULTI in ice_vsi_sync_fltr() this way:
>=20
> ice_vsi_sync_fltr() {
>   ...
>   if (changed_flags & IFF_ALLMULTI) {
>     if (netdev->flags & IFF_ALLMULTI) {
>       if (vsi->num_vlans > 1)
>         ice_set_promisc(..., ICE_MCAST_VLAN_PROMISC_BITS);
>       else
>         ice_set_promisc(..., ICE_MCAST_PROMISC_BITS);
>     } else {
>       if (vsi->num_vlans > 1)
>         ice_clear_promisc(..., ICE_MCAST_VLAN_PROMISC_BITS);
>       else
>         ice_clear_promisc(..., ICE_MCAST_PROMISC_BITS);
>     }
>   }
>   ...
> }
>=20
> The code above depends on value vsi->num_vlan that specifies number
> of VLANs configured over the interface (including VLAN 0) and
> this is problem because that value is modified in NDO callbacks
> ice_vlan_rx_add_vid() and ice_vlan_rx_kill_vid().
>=20
> Scenario 1:
> 1. ip link set ens7f0 allmulticast on
> 2. ip link add vlan10 link ens7f0 type vlan id 10
> 3. ip link set ens7f0 allmulticast off
> 4. ip link set ens7f0 allmulticast on
>=20
> [1] In this scenario IFF_ALLMULTI is enabled and the driver calls
>     ice_set_promisc(..., ICE_MCAST_PROMISC_BITS) that installs
>     multicast promisc rule with non-VLAN look-up type.
> [2] Then VLAN with ID 10 is added and vsi->num_vlan incremented to 2
> [3] Command switches IFF_ALLMULTI off and the driver calls
>     ice_clear_promisc(..., ICE_MCAST_VLAN_PROMISC_BITS) but this
>     call is effectively NOP because it looks for multicast promisc
>     rules for VLAN 0 and VLAN 10 with VLAN look-up type but no such
>     rules exist. So the all-multicast remains enabled silently
>     in hardware.
> [4] Command tries to switch IFF_ALLMULTI on and the driver calls
>     ice_clear_promisc(..., ICE_MCAST_PROMISC_BITS) but this call
>     fails (-EEXIST) because non-VLAN multicast promisc rule already
>     exists.
>=20
> Scenario 2:
> 1. ip link add vlan10 link ens7f0 type vlan id 10
> 2. ip link set ens7f0 allmulticast on
> 3. ip link add vlan20 link ens7f0 type vlan id 20
> 4. ip link del vlan10 ; ip link del vlan20
> 5. ip link set ens7f0 allmulticast off
>=20
> [1] VLAN with ID 10 is added and vsi->num_vlan=3D=3D2
> [2] Command switches IFF_ALLMULTI on and driver installs multicast
>     promisc rules with VLAN look-up type for VLAN 0 and 10
> [3] VLAN with ID 20 is added and vsi->num_vlan=3D=3D3 but no multicast
>     promisc rules is added for this new VLAN so the interface does
>     not receive MC packets from VLAN 20
> [4] Both VLANs are removed but multicast rule for VLAN 10 remains
>     installed so interface receives multicast packets from VLAN 10
> [5] Command switches IFF_ALLMULTI off and because vsi->num_vlan is 1
>     the driver tries to remove multicast promisc rule for VLAN 0
>     with non-VLAN look-up that does not exist.
>     All-multicast looks disabled from user point of view but it
>     is partially enabled in HW (interface receives all multicast
>     packets either untagged or tagged with VLAN ID 10)
>=20
> To resolve these issues the patch introduces these changes:
> 1. Adds handling for IFF_ALLMULTI to ice_vlan_rx_add_vid() and
>    ice_vlan_rx_kill_vid() callbacks. So when VLAN is added/removed
>    and IFF_ALLMULTI is enabled an appropriate multicast promisc
>    rule for that VLAN ID is added/removed.
> 2. In ice_vlan_rx_add_vid() when first VLAN besides VLAN 0 is added
>    so (vsi->num_vlan =3D=3D 2) and IFF_ALLMULTI is enabled then look-up
>    type for existing multicast promisc rule for VLAN 0 is updated
>    to ICE_MCAST_VLAN_PROMISC_BITS.
> 3. In ice_vlan_rx_kill_vid() when last VLAN besides VLAN 0 is removed
>    so (vsi->num_vlan =3D=3D 1) and IFF_ALLMULTI is enabled then look-up
>    type for existing multicast promisc rule for VLAN 0 is updated
>    to ICE_MCAST_PROMISC_BITS.
> 4. Both ice_vlan_rx_{add,kill}_vid() have to run under ICE_CFG_BUSY
>    bit protection to avoid races with ice_vsi_sync_fltr() that runs
>    in ice_service_task() context.
> 5. Bit ICE_VSI_VLAN_FLTR_CHANGED is use-less and can be removed.
> 6. Error messages added to ice_fltr_*_vsi_promisc() helper functions
>    to avoid them in their callers
> 7. Small improvements to increase readability
>=20
> Fixes: 5eda8afd6bcc ("ice: Add support for PF/VF promiscuous mode")
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h      |   1 -
>  drivers/net/ethernet/intel/ice/ice_fltr.c |  44 ++++++++-
>  drivers/net/ethernet/intel/ice/ice_main.c | 114 +++++++++++++++-------
>  3 files changed, 121 insertions(+), 38 deletions(-)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice.h
> b/drivers/net/ethernet/intel/ice/ice.h
> index b0b27bfcd7a2..27d1b61e097c 100644
> --- a/drivers/net/ethernet/intel/ice/ice.h
> +++ b/drivers/net/ethernet/intel/ice/ice.h
> @@ -301,7 +301,6 @@ enum ice_vsi_state {
>  	ICE_VSI_NETDEV_REGISTERED,
>  	ICE_VSI_UMAC_FLTR_CHANGED,
>  	ICE_VSI_MMAC_FLTR_CHANGED,
> -	ICE_VSI_VLAN_FLTR_CHANGED,
>  	ICE_VSI_PROMISC_CHANGED,
>  	ICE_VSI_STATE_NBITS		/* must be last */
>  };
> diff --git a/drivers/net/ethernet/intel/ice/ice_fltr.c
> b/drivers/net/ethernet/intel/ice/ice_fltr.c
> index af57eb114966..85a94483c2ed 100644
> --- a/drivers/net/ethernet/intel/ice/ice_fltr.c
> +++ b/drivers/net/ethernet/intel/ice/ice_fltr.c
> @@ -58,7 +58,16 @@ int
>  ice_fltr_set_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
>  			      u8 promisc_mask)
>  {
> -	return ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, false);
> +	struct ice_pf *pf =3D hw->back;
> +	int result;
> +
> +	result =3D ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, false);
> +	if (result)
> +		dev_err(ice_pf_to_dev(pf),
> +			"Error setting promisc mode on VSI %i (rc=3D%d)\n",
> +			vsi->vsi_num, result);
> +
> +	return result;
>  }
>=20
>  /**
> @@ -73,7 +82,16 @@ int
>  ice_fltr_clear_vlan_vsi_promisc(struct ice_hw *hw, struct ice_vsi *vsi,
>  				u8 promisc_mask)
>  {
> -	return ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, true);
> +	struct ice_pf *pf =3D hw->back;
> +	int result;
> +
> +	result =3D ice_set_vlan_vsi_promisc(hw, vsi->idx, promisc_mask, true);
> +	if (result)
> +		dev_err(ice_pf_to_dev(pf),
> +			"Error clearing promisc mode on VSI %i (rc=3D%d)\n",
> +			vsi->vsi_num, result);
> +
> +	return result;
>  }
>=20
>  /**
> @@ -87,7 +105,16 @@ int
>  ice_fltr_clear_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc=
_mask,
>  			   u16 vid)
>  {
> -	return ice_clear_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
> +	struct ice_pf *pf =3D hw->back;
> +	int result;
> +
> +	result =3D ice_clear_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
> +	if (result)
> +		dev_err(ice_pf_to_dev(pf),
> +			"Error clearing promisc mode on VSI %i for VID %u
> (rc=3D%d)\n",
> +			ice_get_hw_vsi_num(hw, vsi_handle), vid, result);
> +
> +	return result;
>  }
>=20
>  /**
> @@ -101,7 +128,16 @@ int
>  ice_fltr_set_vsi_promisc(struct ice_hw *hw, u16 vsi_handle, u8 promisc_m=
ask,
>  			 u16 vid)
>  {
> -	return ice_set_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
> +	struct ice_pf *pf =3D hw->back;
> +	int result;
> +
> +	result =3D ice_set_vsi_promisc(hw, vsi_handle, promisc_mask, vid);
> +	if (result)
> +		dev_err(ice_pf_to_dev(pf),
> +			"Error setting promisc mode on VSI %i for VID %u
> (rc=3D%d)\n",
> +			ice_get_hw_vsi_num(hw, vsi_handle), vid, result);
> +
> +	return result;
>  }
>=20
>  /**
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> b/drivers/net/ethernet/intel/ice/ice_main.c
> index b588d7995631..cafff82593df 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -243,8 +243,7 @@ static int ice_add_mac_to_unsync_list(struct net_devi=
ce
> *netdev, const u8 *addr)
>  static bool ice_vsi_fltr_changed(struct ice_vsi *vsi)
>  {
>  	return test_bit(ICE_VSI_UMAC_FLTR_CHANGED, vsi->state) ||
> -	       test_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state) ||
> -	       test_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
> +	       test_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state);
>  }
>=20
>  /**
> @@ -260,10 +259,15 @@ static int ice_set_promisc(struct ice_vsi *vsi, u8
> promisc_m)
>  	if (vsi->type !=3D ICE_VSI_PF)
>  		return 0;
>=20
> -	if (ice_vsi_has_non_zero_vlans(vsi))
> -		status =3D ice_fltr_set_vlan_vsi_promisc(&vsi->back->hw, vsi,
> promisc_m);
> -	else
> -		status =3D ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
> promisc_m, 0);
> +	if (ice_vsi_has_non_zero_vlans(vsi)) {
> +		promisc_m |=3D (ICE_PROMISC_VLAN_RX |
> ICE_PROMISC_VLAN_TX);
> +		status =3D ice_fltr_set_vlan_vsi_promisc(&vsi->back->hw, vsi,
> +						       promisc_m);
> +	} else {
> +		status =3D ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
> +						  promisc_m, 0);
> +	}
> +
>  	return status;
>  }
>=20
> @@ -280,10 +284,15 @@ static int ice_clear_promisc(struct ice_vsi *vsi, u=
8
> promisc_m)
>  	if (vsi->type !=3D ICE_VSI_PF)
>  		return 0;
>=20
> -	if (ice_vsi_has_non_zero_vlans(vsi))
> -		status =3D ice_fltr_clear_vlan_vsi_promisc(&vsi->back->hw, vsi,
> promisc_m);
> -	else
> -		status =3D ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
> promisc_m, 0);
> +	if (ice_vsi_has_non_zero_vlans(vsi)) {
> +		promisc_m |=3D (ICE_PROMISC_VLAN_RX |
> ICE_PROMISC_VLAN_TX);
> +		status =3D ice_fltr_clear_vlan_vsi_promisc(&vsi->back->hw, vsi,
> +							 promisc_m);
> +	} else {
> +		status =3D ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
> +						    promisc_m, 0);
> +	}
> +
>  	return status;
>  }
>=20
> @@ -302,7 +311,6 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
>  	struct ice_pf *pf =3D vsi->back;
>  	struct ice_hw *hw =3D &pf->hw;
>  	u32 changed_flags =3D 0;
> -	u8 promisc_m;
>  	int err;
>=20
>  	if (!vsi->netdev)
> @@ -320,7 +328,6 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
>  	if (ice_vsi_fltr_changed(vsi)) {
>  		clear_bit(ICE_VSI_UMAC_FLTR_CHANGED, vsi->state);
>  		clear_bit(ICE_VSI_MMAC_FLTR_CHANGED, vsi->state);
> -		clear_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
>=20
>  		/* grab the netdev's addr_list_lock */
>  		netif_addr_lock_bh(netdev);
> @@ -369,29 +376,15 @@ static int ice_vsi_sync_fltr(struct ice_vsi *vsi)
>  	/* check for changes in promiscuous modes */
>  	if (changed_flags & IFF_ALLMULTI) {
>  		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
> -			if (ice_vsi_has_non_zero_vlans(vsi))
> -				promisc_m =3D ICE_MCAST_VLAN_PROMISC_BITS;
> -			else
> -				promisc_m =3D ICE_MCAST_PROMISC_BITS;
> -
> -			err =3D ice_set_promisc(vsi, promisc_m);
> +			err =3D ice_set_promisc(vsi, ICE_MCAST_PROMISC_BITS);
>  			if (err) {
> -				netdev_err(netdev, "Error setting Multicast
> promiscuous mode on VSI %i\n",
> -					   vsi->vsi_num);
>  				vsi->current_netdev_flags &=3D ~IFF_ALLMULTI;
>  				goto out_promisc;
>  			}
>  		} else {
>  			/* !(vsi->current_netdev_flags & IFF_ALLMULTI) */
> -			if (ice_vsi_has_non_zero_vlans(vsi))
> -				promisc_m =3D ICE_MCAST_VLAN_PROMISC_BITS;
> -			else
> -				promisc_m =3D ICE_MCAST_PROMISC_BITS;
> -
> -			err =3D ice_clear_promisc(vsi, promisc_m);
> +			err =3D ice_clear_promisc(vsi, ICE_MCAST_PROMISC_BITS);
>  			if (err) {
> -				netdev_err(netdev, "Error clearing Multicast
> promiscuous mode on VSI %i\n",
> -					   vsi->vsi_num);
>  				vsi->current_netdev_flags |=3D IFF_ALLMULTI;
>  				goto out_promisc;
>  			}
> @@ -3488,6 +3481,20 @@ ice_vlan_rx_add_vid(struct net_device *netdev,
> __be16 proto, u16 vid)
>  	if (!vid)
>  		return 0;
>=20
> +	while (test_and_set_bit(ICE_CFG_BUSY, vsi->state))
> +		usleep_range(1000, 2000);
> +
> +	/* Add multicast promisc rule for the VLAN ID to be added if
> +	 * all-multicast is currently enabled.
> +	 */
> +	if (vsi->current_netdev_flags & IFF_ALLMULTI) {
> +		ret =3D ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
> +					       ICE_MCAST_VLAN_PROMISC_BITS,
> +					       vid);
> +		if (ret)
> +			goto finish;
> +	}
> +
>  	vlan_ops =3D ice_get_compat_vsi_vlan_ops(vsi);
>=20
>  	/* Add a switch rule for this VLAN ID so its corresponding VLAN tagged
> @@ -3495,8 +3502,23 @@ ice_vlan_rx_add_vid(struct net_device *netdev,
> __be16 proto, u16 vid)
>  	 */
>  	vlan =3D ICE_VLAN(be16_to_cpu(proto), vid, 0);
>  	ret =3D vlan_ops->add_vlan(vsi, &vlan);
> -	if (!ret)
> -		set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
> +	if (ret)
> +		goto finish;
> +
> +	/* If all-multicast is currently enabled and this VLAN ID is only one
> +	 * besides VLAN-0 we have to update look-up type of multicast promisc
> +	 * rule for VLAN-0 from ICE_SW_LKUP_PROMISC to
> ICE_SW_LKUP_PROMISC_VLAN.
> +	 */
> +	if ((vsi->current_netdev_flags & IFF_ALLMULTI) &&
> +	    ice_vsi_num_non_zero_vlans(vsi) =3D=3D 1) {
> +		ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
> +					   ICE_MCAST_PROMISC_BITS, 0);
> +		ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
> +					 ICE_MCAST_VLAN_PROMISC_BITS, 0);
> +	}
> +
> +finish:
> +	clear_bit(ICE_CFG_BUSY, vsi->state);
>=20
>  	return ret;
>  }
> @@ -3522,6 +3544,9 @@ ice_vlan_rx_kill_vid(struct net_device *netdev, __b=
e16
> proto, u16 vid)
>  	if (!vid)
>  		return 0;
>=20
> +	while (test_and_set_bit(ICE_CFG_BUSY, vsi->state))
> +		usleep_range(1000, 2000);
> +
>  	vlan_ops =3D ice_get_compat_vsi_vlan_ops(vsi);
>=20
>  	/* Make sure VLAN delete is successful before updating VLAN
> @@ -3530,10 +3555,33 @@ ice_vlan_rx_kill_vid(struct net_device *netdev,
> __be16 proto, u16 vid)
>  	vlan =3D ICE_VLAN(be16_to_cpu(proto), vid, 0);
>  	ret =3D vlan_ops->del_vlan(vsi, &vlan);
>  	if (ret)
> -		return ret;
> +		goto finish;
>=20
> -	set_bit(ICE_VSI_VLAN_FLTR_CHANGED, vsi->state);
> -	return 0;
> +	/* Remove multicast promisc rule for the removed VLAN ID if
> +	 * all-multicast is enabled.
> +	 */
> +	if (vsi->current_netdev_flags & IFF_ALLMULTI)
> +		ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
> +					   ICE_MCAST_VLAN_PROMISC_BITS, vid);
> +
> +	if (!ice_vsi_has_non_zero_vlans(vsi)) {
> +		/* Update look-up type of multicast promisc rule for VLAN 0
> +		 * from ICE_SW_LKUP_PROMISC_VLAN to
> ICE_SW_LKUP_PROMISC when
> +		 * all-multicast is enabled and VLAN 0 is the only VLAN rule.
> +		 */
> +		if (vsi->current_netdev_flags & IFF_ALLMULTI) {
> +			ice_fltr_clear_vsi_promisc(&vsi->back->hw, vsi->idx,
> +
> ICE_MCAST_VLAN_PROMISC_BITS,
> +						   0);
> +			ice_fltr_set_vsi_promisc(&vsi->back->hw, vsi->idx,
> +						 ICE_MCAST_PROMISC_BITS, 0);
> +		}
> +	}
> +
> +finish:
> +	clear_bit(ICE_CFG_BUSY, vsi->state);
> +
> +	return ret;
>  }
>=20
>  /**
> --
> 2.34.1
>=20
> _______________________________________________
> Intel-wired-lan mailing list
> Intel-wired-lan@osuosl.org
> https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
