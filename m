Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1E357E8BC
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 23:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235792AbiGVVNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 17:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233585AbiGVVNm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 17:13:42 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2408B5545;
        Fri, 22 Jul 2022 14:13:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658524420; x=1690060420;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1Hv4e8P7mJfgyYcW84R33tFFzuEeQQGyRL8Z1PHs1Xk=;
  b=R9LX9UflqMXChFzgjxd/Lf8SscEs0wGXruRE9+dekiYiAxb/yXg4uTfS
   JAJA5tjGquM3JGl2hU3uDagc2eZBy1Q2b97aJ1h7ftZbdUlSGBNBCIhYP
   ZT33BKT/mD0PvBH5pdcOZAfUtfB6huVNgQ+mGLQ4FfzvUqAEivMU9rgvI
   GLGxd/jptJo46fmE/gI5HFSQSp1Lt4qZDaMyzd+vs9HEfZfg45vMUmmnO
   oc6TAtryIt8Nm9JsgRDhOaybI6DVWm5/wSswSRDYZTKS21406QptfRO/d
   usE8Xj9rADKGoY1gNLzr9+3lhWJb69hrTJyjD+KVgFpfKNDsjhDBgc749
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10416"; a="349106115"
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="349106115"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2022 14:13:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,186,1654585200"; 
   d="scan'208";a="631701465"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 22 Jul 2022 14:13:32 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 14:13:31 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 14:13:28 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Fri, 22 Jul 2022 14:13:28 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.101)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Fri, 22 Jul 2022 14:13:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K4/DCEbVym8vOhl5TKq/8km0rCII4Q2I01g8CzExVhLXHxzCjTSwY+muBcsSUmujB9DVjgvvcQrbr3nzNP+kDxLymiqyXitpKaows9pSfJwr1hroWLjqlDBYRPy2MukdGv1lqRy7NdJIiWKUBRoGqlLV85nyk4U5/OyhxBCpp/v+2rOxIqWDPHU/KLA0POVGN6B9o/EZhX5v8cT1noUF5raMW2y82sgfyYYNGOcmyU0SoSq7h2BNfZfZ5+5IQKhiq636TgY86YwsO7UAhTxUwPKx8idOYyQgRobBZxHygbrfEjoF67Otj22Kj/IighzqLDzq27+ajn77JzOGsN4Wqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TVj081/m803yqPJV0h0C3iO8yLcwfiySnvKIYveENp8=;
 b=DSr11eA0GO1E+fXk+4hZpl5+LFvNF2aN2xlOJKTwk5Ay6M4bEoOaU7Uuu2679PWX1Dj9ugRnKXwFdDrCLFH+ZDyG9C0RshFDaByQMkU7MNlnM2xdYnS2ApYN5Fo5vAi0Sa9pETCCxhbc4Bfa69Lu99CRe0NrfRbGddXbgrpiUcTBnE7hjmtW4pGz0lpkg7L8Qk35WoGUXLOUMMOf5B8dDeDNbUk4yd9JdPp/U/HqERwfTYnkaUnYLzIzlwGkwC+1AZ0ugnrXiepheN/YNTx9tQ7tchTX0b6Pb/NNDsZAVJtwCaCnul5kIo92FcCFBLjqVJpFdGNgSzEO9icqhJ9BhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM4PR11MB6359.namprd11.prod.outlook.com (2603:10b6:8:b9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 21:13:27 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%7]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 21:13:27 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        David Ahern <dsahern@kernel.org>,
        "Stephen Hemminger" <stephen@networkplumber.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: RE: [net-next v2 1/2] devlink: add dry run attribute to flash update
Thread-Topic: [net-next v2 1/2] devlink: add dry run attribute to flash update
Thread-Index: AQHYnUb/eeDwate2U0GV62UcpX5Fwq2J7U6AgAD3viA=
Date:   Fri, 22 Jul 2022 21:13:27 +0000
Message-ID: <CO1PR11MB5089455E719480341AC226B7D6909@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220721211451.2475600-1-jacob.e.keller@intel.com>
 <20220721211451.2475600-2-jacob.e.keller@intel.com>
 <YtpDAQS+eQI9C+LV@nanopsycho>
In-Reply-To: <YtpDAQS+eQI9C+LV@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d074193c-4204-4b55-bc8a-08da6c27050a
x-ms-traffictypediagnostic: DM4PR11MB6359:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4T1+5raPRTyRZIKgyn+/V6YlsiYJ/8BqGm14gJYiqzP6Jq+vBXws3/ckq5OibQtqSjqOWo2o9FTMAbLcA6Rt0fYwDpgq0U6gEegT4yNPI/etw+VncMW5q9Om0fgaI9QL/uKg6dRGyP+PfM3NWqD3yQ0lAD9SkpLBazQgGGuNHDSXV5slkBSwgvl40Su18nmpmsW1ZYSLO3c99tQWbmz4KpS14nQZ/0CxaH0egHAJ0ataIBvMfO7SRlKuCNYEkTL/CiLCaZCPf/RjnoPSbTz1AIu/wJseSV+7L333B9dbPls3BlUTzVq4Fv1cm03lM8o7j05WFc1iKQ3Z1LRGyd6eeU4SSRXrdBoJGJYkFXt6wGnjSSWXfboqj5A+VuBDxJuZKxOmGlxg98CIRU1JFUN+9Wy8dZ4U3fzUynaeSmqYGQkYqtMw4bwl0ZMz2fl7adZypGEPK+s+Sht2ESrBRz7CuSZJAIL45yHcO51YmRO7Z/ueLNobY859ITQU7SGm2MCtG1BRZDcn33cYXziEwVCCVgz9mDXB1WOBnYHczfQB8/k9ZFPEjubVU+PwAPbAlS68QVzN7yQ+6KFRhMnrRAyirFjpCv5czPqoXJ7EmZDR81vHynpl354qtJhs62IV1LQmIzx59jbexnbGbg+4ANrxEdPaG0j6HRblwer3yX8bVZkSTsSI0pygZS5Wakb6B5iXC97U1oSq+xLvggQS5dfiit/yJVHFWtT6DqqZAgo0oqADtCPtmWxaxwGMcusDG8BBwIP4lRtpuDXuPlzQ0FKseLTgVSeu7EKV0TabNPo8uxrhWyOKM4yO7UL6XJEdW/Q1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(396003)(346002)(366004)(376002)(33656002)(82960400001)(86362001)(38100700002)(71200400001)(6916009)(53546011)(122000001)(41300700001)(478600001)(186003)(316002)(9686003)(26005)(6506007)(2906002)(66446008)(8676002)(64756008)(76116006)(4326008)(5660300002)(8936002)(66946007)(7416002)(52536014)(66476007)(54906003)(83380400001)(66556008)(15650500001)(55016003)(38070700005)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?nrwy6Hn1T5cseuER9aNNURVlKg+JxWgfflIVHc+705cn4adszVFwPlKEiXnk?=
 =?us-ascii?Q?6g5z8UymDxTF9OfDzXSRrui4m0d4XDaSisR8GYw+F3hHgn7BCyQilfj1YSms?=
 =?us-ascii?Q?IVB6UPjzwl4CqEuRxMkbl5Hbo4qI/rcsZHzRDezwQhj2vUWWRR7xDUQuSNJj?=
 =?us-ascii?Q?hpdbKHXhiElmQNPDDV5Ogz648ek3veJnDyaGa5cOVJ5LFyb9WKB2HQiR75k5?=
 =?us-ascii?Q?mVQKqkW0gZ7MRIS8ClRU/5+LvDSfxqZufawNl3myvULwR6DFthG43e/GQ50+?=
 =?us-ascii?Q?JNAh1IpgeXT38RdrqiUe1wWfLpu0drrk9jU1qDDMO3S2DjWwWI5DILbS2T46?=
 =?us-ascii?Q?4zVrFR96CxKX8I5J1goOn0Nf5zie3EMbcQhwvgDZThAPh8R75WDYQ7P5omhX?=
 =?us-ascii?Q?38jMqdGOX832t9Qmh7RZ3fwG7N5GxqnylFwHkNsNhFVPX4POuu/Q7LQ2ai4n?=
 =?us-ascii?Q?7YgQxuIov4jD1lddWhg7D/qvSFkdSvt7+K8ou9SNjdg6Ur3pVmRYZ+dy84bj?=
 =?us-ascii?Q?+DFLDOB8iMK/Itw1FYmZr0cFz7Ip/HZKWoDuejs1BnYb4osqn86idZ4XWgEY?=
 =?us-ascii?Q?Oa/vvN3ijd25USH5GFV92js/gqP3pDlLsjpHMhK47Gstn8FFUVLP8Irfogww?=
 =?us-ascii?Q?tstEiGy1dYoeTLyyz9Pa9VK5MOJg2cxi9LvUbscCuU4bJUCDnT6s3FO3sO9D?=
 =?us-ascii?Q?OZjaH4wAIV47htQ2+xlBZxu4C4OxW1HiwKzCA/Tg4imivQD44hebCSWreIl7?=
 =?us-ascii?Q?QKeDZrd0qZ2IOTDBlnRMZZwPVq9kyBKFIkplgs/snePMJPZ4b8mxGPrK1lch?=
 =?us-ascii?Q?109QAlsauFhVnxX5mlmU+klVNar4ADYLKzrTvr2baZdp6DBf2sR4a/g9JDjF?=
 =?us-ascii?Q?b/8y+ZgnPmKIUBoC+QoNBWSU+5QrhK+QBeiG3O8RLbHEZ14F/pcfNaDt4TSs?=
 =?us-ascii?Q?nY9qxFiB4WPOb/O6b/iBL6N0HGdsAjNPN61yDlgKEda7gme+H8WEf3WeeTjd?=
 =?us-ascii?Q?UmU7TC0vt1G3/ZVrl6p1XPowDor9WHByc1UG/badR/k8vmto5wSNaJcvmIYm?=
 =?us-ascii?Q?99j3GwJoXhuiLeln1fUrw/3xdmjvV4urIWZLuJ4ELM2V8Dy1VoV27IuZK/pT?=
 =?us-ascii?Q?xvOT0NBfncu/OjUXNqksXDQhc/mTkg61tmYenglkxbwV+QXvzXbhK2QsTZOT?=
 =?us-ascii?Q?Gd711UXduTbTjWNkCQ0Mav1rcnUcDnzNePlJP9gXVDorrJ5CerxndmXoWR8p?=
 =?us-ascii?Q?Eti4nuZxze+kqTSFSyiyo7eLcKgkYeyQbm2r2aBdhcyosWtkuXCebghlLjQB?=
 =?us-ascii?Q?Xds2s2fcOIbZPEOEEEuYq2Lbtg0LEhQn322GwaGgqzch7r5XA8mvOFvzNU1W?=
 =?us-ascii?Q?bbqTElIlJhxA0fxBcb3JrQ1vsUfED5Lu0I2dFjEeFHcYIS/VDWHooMTpIBse?=
 =?us-ascii?Q?h2JJieXZhIYEtjF1j72LIHgD5cQhY2kL9dP5s9fwEaTp/hlKH0EY5jhefduY?=
 =?us-ascii?Q?LAA8Tqlnq0O/E4yGgKl+hNvG5YguuaCBjxcq6e4LB/RVN193kqjoNgqdYkMk?=
 =?us-ascii?Q?4nkEawG6kf4Kltkxavb8wm+mwQNLc5yy/rDhQ9YZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d074193c-4204-4b55-bc8a-08da6c27050a
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 21:13:27.0304
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: htqtc3DxmwOXb2Vme2BgzPBN7UWD5M0AQ9dDrt+quGbo+fsY1SJ2Pv+3YqvyM1MK23ihfNzpDhSdtMQuG6VeLhBDkcXzY8vCWMA4mstzkSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6359
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Thursday, July 21, 2022 11:26 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jonathan Corbet <corbet@lwn.net>; Jiri Pirko
> <jiri@nvidia.com>; David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> David Ahern <dsahern@kernel.org>; Stephen Hemminger
> <stephen@networkplumber.org>; linux-doc@vger.kernel.org; intel-wired-
> lan@lists.osuosl.org
> Subject: Re: [net-next v2 1/2] devlink: add dry run attribute to flash up=
date
>=20
> Thu, Jul 21, 2022 at 11:14:46PM CEST, jacob.e.keller@intel.com wrote:
> >Users use the devlink flash interface to request a device driver program=
 or
> >update the device flash chip. In some cases, a user (or script) may want=
 to
> >verify that a given flash update command is supported without actually
> >committing to immediately updating the device. For example, a system
> >administrator may want to validate that a particular flash binary image
> >will be accepted by the device, or simply validate a command before fina=
lly
> >committing to it.
> >
> >The current flash update interface lacks a method to support such a dry
> >run. Add a new DEVLINK_ATTR_DRY_RUN attribute which shall be used by a
> >devlink command to indicate that a request is a dry run which should not
> >perform device configuration. Instead, the command should report whether
> >the command or configuration request is valid.
> >
> >While we can validate the initial arguments of the devlink command, a
> >proper dry run must be processed by the device driver. This is required
> >because only the driver can perform validation of the flash binary file.
> >
> >Add a new dry_run parameter to the devlink_flash_update_params struct,
> >along with the associated bit to indicate if a driver supports verifying=
 a
> >dry run.
> >
> >We always check the dry run attribute last in order to allow as much
> >verification of other parameters as possible. For example, even if a dri=
ver
> >does not support the dry_run option, we can still validate the other
> >optional parameters such as the overwrite_mask and per-component update
> >name.
> >
> >Document that userspace should take care when issuing a dry run to older
> >kernels, as the flash update command is not strictly verified. Thus,
> >unknown attributes will be ignored and this could cause a request for a =
dry
> >run to perform an actual update. We can't fix old kernels to verify unkn=
own
> >attributes, but userspace can check the maximum attribute and reject the
> >dry run request if it is not supported by the kernel.
> >
> >Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
> >---
> >
> >Changes since v1:
> >* Add kernel doc comments to devlink_flash_update_params
> >* Reduce indentation by using nla_get_flag
> >
> > .../networking/devlink/devlink-flash.rst      | 23 +++++++++++++++++++
> > include/net/devlink.h                         |  4 ++++
> > include/uapi/linux/devlink.h                  |  8 +++++++
> > net/core/devlink.c                            | 17 +++++++++++++-
> > 4 files changed, 51 insertions(+), 1 deletion(-)
> >
> >diff --git a/Documentation/networking/devlink/devlink-flash.rst
> b/Documentation/networking/devlink/devlink-flash.rst
> >index 603e732f00cc..1dc373229a54 100644
> >--- a/Documentation/networking/devlink/devlink-flash.rst
> >+++ b/Documentation/networking/devlink/devlink-flash.rst
> >@@ -44,6 +44,29 @@ preserved across the update. A device may not support
> every combination and
> > the driver for such a device must reject any combination which cannot b=
e
> > faithfully implemented.
> >
> >+Dry run
> >+=3D=3D=3D=3D=3D=3D=3D
> >+
> >+Users can request a "dry run" of a flash update by adding the
> >+``DEVLINK_ATTR_DRY_RUN`` attribute to the ``DEVLINK_CMD_FLASH_UPDATE``
> >+command. If the attribute is present, the kernel will only verify that =
the
> >+provided command is valid. During a dry run, an update is not performed=
.
> >+
> >+If supported by the driver, the flash image contents are also validated=
 and
> >+the driver may indicate whether the file is a valid flash image for the
> >+device.
> >+
> >+.. code:: shell
> >+
> >+   $ devlink dev flash pci/0000:af:00.0 file image.bin dry-run
> >+   Validating flash binary
> >+
> >+Note that user space should take care when adding this attribute. Older
> >+kernels which do not recognize the attribute may accept the command wit=
h an
> >+unknown attribute. This could lead to a request for a dry run which per=
forms
> >+an unexpected update. To avoid this, user space should check the policy=
 dump
> >+and verify that the attribute is recognized before adding it to the com=
mand.
> >+
> > Firmware Loading
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >diff --git a/include/net/devlink.h b/include/net/devlink.h
> >index 780744b550b8..47b86ccb85b0 100644
> >--- a/include/net/devlink.h
> >+++ b/include/net/devlink.h
> >@@ -613,6 +613,8 @@ enum devlink_param_generic_id {
> >  * struct devlink_flash_update_params - Flash Update parameters
> >  * @fw: pointer to the firmware data to update from
> >  * @component: the flash component to update
> >+ * @overwrite_mask: what sections of flash can be overwritten
>=20
> Well, strictly speaking, this is not related to this patch and should be
> done in a separate one. But hey, it's a comment, so I guess noone really
> cares.
>=20

Ah yep. I'll split this out since I need to send a new version to split the=
 iproute stuff into its own thread anyways.
