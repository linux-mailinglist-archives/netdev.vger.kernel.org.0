Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB6E6E296D
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230378AbjDNR3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjDNR3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:29:36 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A79459ED
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:29:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681493370; x=1713029370;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=w0I+bXLXlheEHeK6Rl/l7jJSHowur40XMd9UZCv91NY=;
  b=JeSQNTlzEjUtKP1bDu/VG6WvFj7d/DUXLRpsRFmn7NXve/XXtX/NVR/+
   niDcQlyF6vJNEsMfOf9RbpVDScldEtt6yyuP3VlwcWxDvTjf8UmzFWUCV
   XreR/sKB1DQTyMZGZJzzxRjiH4rGmPnonPXxIE5Vx1GcO8H0l6iTKLUIA
   m76HWO3zY/QgpwfRzj3Pyb6Py8Kny77p3DY3SYwNgJA1qQOiKHxpI0ILj
   nA0IVtqeDQnwI0VJwE+kGRSaRCBNkT+TvWmH0NoEMAnJsLDqvtnOKQeQG
   JEgqkFknL35Kz9zlQ3V/6asXKwTWCBBrQXP9dCYw+XWJ3ExKOQ9791dWu
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="372388259"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="372388259"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 10:29:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="720357611"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="720357611"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2023 10:29:08 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:07 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 10:29:07 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.109)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kb4rMnZJfVvis0YtN7ifruCBE2nUyUy5qJMEB9wEMHD3TiHU2TokDLNFYur4WE/z1CUWK/BCf1+tUolS0ir8m9J/Zjmi/B1cw+OFr2JlsU5h8h+aADYozStjXoRRStHp5GmMWUqBhxut+KhDLS6Or8Zz/KoSIenMmt6OGcmO84hjPuJ/Y+WWSMiEs4f9fcoC5j9QHg3yelowd5yTLqda1+7SaxkL7h/EcWjbl48ExjO4iyZjwMTD2d0jYXt6apD5Jz112il1WwzrxUXA0It8qLVCnmZCihP7Dv5DkTzBJU0zvTg5mmQi/6nY6HqgjzHfBzINf4w4RTpbHRLTVcTwZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XvIsbrr9cPUFshy2mqxGLpUFP3iQYhNmD+l+2P1EzK8=;
 b=SZtVF+w/jjEi6fCpdjlQ9vpQ4RI8sFWuoBbtDDhG/BpasFFsnbQSuZz22ZYlIaJD0VCqfvGZeJ2jR9EcZyNwWa43LMAE9sOeDsy4edgs/TakMrSxkpZ5pntTBKK/yooLk5KPveiupQjAgh62Y2GrDf2fnlTBTh/H68J9K2JBdWICr0yLfKFPMPtgawm6prVnKRTgOf37P+1NKmLc6XfM1fFRm+ne0lhKWkaJvE832tFLXRhjhoFTQ/GejZY08OuQ/c3ka5+ASTQ9Sv3AgBdVhD4Uh716Q5CYrBKq4Ke5D3VZS7mnAXxIzV0tTsViETp+SAOeM2bWR35veYUxOMzUHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM4PR11MB6454.namprd11.prod.outlook.com (2603:10b6:8:b8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Fri, 14 Apr 2023 17:29:00 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8%4]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 17:29:00 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     mschmidt <mschmidt@redhat.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Kolacinski, Karol" <karol.kolacinski@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Simon Horman <simon.horman@corigine.com>,
        "Michalik, Michal" <michal.michalik@intel.com>,
        poros <poros@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [PATCH net-next v2 5/6] ice: remove unused buffer copy code in
 ice_sq_send_cmd_retry()
Thread-Topic: [PATCH net-next v2 5/6] ice: remove unused buffer copy code in
 ice_sq_send_cmd_retry()
Thread-Index: AQHZbRerhFfdcLZ42U+9RnPA9qYMnq8q5J1g
Date:   Fri, 14 Apr 2023 17:29:00 +0000
Message-ID: <DM6PR11MB46579AE0BB21C2B642DFEBA89B999@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-6-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-6-mschmidt@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DM4PR11MB6454:EE_
x-ms-office365-filtering-correlation-id: 8107f963-e863-4f60-d3ce-08db3d0dbc16
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199021)(38070700005)(7696005)(71200400001)(41300700001)(55016003)(86362001)(8936002)(26005)(2906002)(186003)(52536014)(33656002)(6506007)(5660300002)(76116006)(478600001)(66946007)(66446008)(64756008)(66556008)(4326008)(8676002)(9686003)(66476007)(110136005)(54906003)(82960400001)(38100700002)(122000001)(316002)(83380400001);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8107f963-e863-4f60-d3ce-08db3d0dbc16
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 17:29:00.2201
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xUvPt9PcUPqB0iP8tFNB8cqA+2trtoCQH7olEIW3qsHocJj5prP7eIql3Z6jQCC3GakYQ2rtuvHvD6/mght226mukMvPqS+7elNjSr7MheU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6454
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Michal Schmidt <mschmidt@redhat.com>
>Sent: Wednesday, April 12, 2023 10:19 AM
>
>The 'buf_cpy'-related code in ice_sq_send_cmd_retry() looks broken.
>'buf' is nowhere copied into 'buf_cpy'.
>
>The reason this does not cause problems is that all commands for which
>'is_cmd_for_retry' is true go with a NULL buf.
>
>Let's remove 'buf_cpy'. Add a WARN_ON in case the assumption no longer
>holds in the future.
>
>Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
>---
> drivers/net/ethernet/intel/ice/ice_common.c | 13 ++-----------
> 1 file changed, 2 insertions(+), 11 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/ice/ice_common.c
>b/drivers/net/ethernet/intel/ice/ice_common.c
>index 3638598d732b..c6200564304e 100644
>--- a/drivers/net/ethernet/intel/ice/ice_common.c
>+++ b/drivers/net/ethernet/intel/ice/ice_common.c
>@@ -1619,7 +1619,6 @@ ice_sq_send_cmd_retry(struct ice_hw *hw, struct
>ice_ctl_q_info *cq,
> {
> 	struct ice_aq_desc desc_cpy;
> 	bool is_cmd_for_retry;
>-	u8 *buf_cpy =3D NULL;
> 	u8 idx =3D 0;
> 	u16 opcode;
> 	int status;
>@@ -1629,11 +1628,8 @@ ice_sq_send_cmd_retry(struct ice_hw *hw, struct
>ice_ctl_q_info *cq,
> 	memset(&desc_cpy, 0, sizeof(desc_cpy));
>
> 	if (is_cmd_for_retry) {
>-		if (buf) {
>-			buf_cpy =3D kzalloc(buf_size, GFP_KERNEL);
>-			if (!buf_cpy)
>-				return -ENOMEM;
>-		}
>+		/* All retryable cmds are direct, without buf. */
>+		WARN_ON(buf);
>
> 		memcpy(&desc_cpy, desc, sizeof(desc_cpy));
> 	}
>@@ -1645,17 +1641,12 @@ ice_sq_send_cmd_retry(struct ice_hw *hw, struct
>ice_ctl_q_info *cq,
> 		    hw->adminq.sq_last_status !=3D ICE_AQ_RC_EBUSY)
> 			break;
>
>-		if (buf_cpy)
>-			memcpy(buf, buf_cpy, buf_size);
>-
> 		memcpy(desc, &desc_cpy, sizeof(desc_cpy));
>
> 		mdelay(ICE_SQ_SEND_DELAY_TIME_MS);
>
> 	} while (++idx < ICE_SQ_SEND_MAX_EXECUTE);
>
>-	kfree(buf_cpy);
>-
> 	return status;
> }
>
>--
>2.39.2

Looks good, thank you Michal!

Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
