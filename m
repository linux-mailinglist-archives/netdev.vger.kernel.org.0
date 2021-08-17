Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74E03EE857
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 10:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239050AbhHQIX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 04:23:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:44887 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238797AbhHQIXZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 04:23:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="238100381"
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="238100381"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Aug 2021 01:22:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,328,1620716400"; 
   d="scan'208";a="471079997"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 17 Aug 2021 01:22:52 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 17 Aug 2021 01:22:52 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 17 Aug 2021 01:22:51 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 17 Aug 2021 01:22:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 17 Aug 2021 01:22:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlXyBi29lWlySqeiCOHQpw/df1/boWj3Ztgy7DLFgXExXZMBIEj77pgJAGBv2SORdk+Xf9ZS7ZZ87vPqV3jgLFySK30K2kw/W066Gmo2x/ISmLRP7gazGFBPJfOkHfi/fx0G/LoMBo0bfljTTACpPXq5D404tgzzmrRpXODA9C4Ta0ScBJuN3om3fJe8z2cqJY1C7fHJyUBJMgl88ayNId4GIuFedti1XTSUjM5jJQD2KjmwErJDdwyX9SGd1kHl3XWmT9UIcZu41HN+RaAoh3jkcICEk7KCs3k8U1BppkTVJy1ueMjtNqDc1U+054lnOe51OgvfdYTlYswd1LoiBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1PffyItwalBeaX0Zh61/vv8RFCY50JI6H5bOKIzEYU=;
 b=RzCBkCMNO+rO7GVPyGev2G7cOQ5XPfIss++BIyl/EkW52r1yWJbdNe3u3HGR3i6WtVq/PTjsoonrIBvhiSRvCad4a0FKdEa8lV3anV4Gxj3AMgN+zaqL6V7BWR4PjlFq3yTJ97uq6JlLUOErLytAq4tQgVKoWEm3KPTzid14L3zAaEKJJn/dN58AAyyyvbTxnA0E9YMVzuTsXhcnUWOgQ4vEOpcNKEWzf7d1xJqVxC9h8Im3D/evCfKkefQ95CoUui3ctiknCvY2PBB3a99Fhn3JMnjdfXtgnKZvlbCqRxOz2WibT1P9ooasZAYj0bEuWXbJLz4QgaxhWPU+r+GeYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W1PffyItwalBeaX0Zh61/vv8RFCY50JI6H5bOKIzEYU=;
 b=CkOr9hGIRRUF9aBvQuhcg1YeT5cJwq5s1Jjx9olD6LpI04ZOFDFXFKEdk49p7oAup+GmNs9lCNOiz1AOAP6khRCWmjpRmqc0Y6SKlbREpE2jgIpHp+yPCe5nfPRhOuXfX91o2rau1CI2gimzvZFbHU9rk5LC7w0mINzGaPAEKwY=
Received: from BYAPR11MB3079.namprd11.prod.outlook.com (2603:10b6:a03:92::16)
 by SJ0PR11MB4944.namprd11.prod.outlook.com (2603:10b6:a03:2ae::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Tue, 17 Aug
 2021 08:22:51 +0000
Received: from BYAPR11MB3079.namprd11.prod.outlook.com
 ([fe80::dcf9:9373:540f:8014]) by BYAPR11MB3079.namprd11.prod.outlook.com
 ([fe80::dcf9:9373:540f:8014%4]) with mapi id 15.20.4415.024; Tue, 17 Aug 2021
 08:22:50 +0000
From:   "Szlosek, Marek" <marek.szlosek@intel.com>
To:     Stefan Assmann <sassmann@kpanic.de>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Laba, SlawomirX" <slawomirx.laba@intel.com>,
        "Yang, Lihong" <lihong.yang@intel.com>
Subject: RE: [PATCH net-next] iavf: use mutexes for locking of critical
 sections
Thread-Topic: [PATCH net-next] iavf: use mutexes for locking of critical
 sections
Thread-Index: AQHXiQn7jwa4jbvQ1EqjxTfrr/4QA6t3bqsg
Date:   Tue, 17 Aug 2021 08:22:50 +0000
Message-ID: <BYAPR11MB3079F80FB5BAED591DD28125E6FE9@BYAPR11MB3079.namprd11.prod.outlook.com>
References: <20210804082224.15368-1-sassmann@kpanic.de>
In-Reply-To: <20210804082224.15368-1-sassmann@kpanic.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: kpanic.de; dkim=none (message not signed)
 header.d=none;kpanic.de; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9ce63938-85e0-4354-5589-08d961583413
x-ms-traffictypediagnostic: SJ0PR11MB4944:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4944EBEC5F03CEE02372AB52E6FE9@SJ0PR11MB4944.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:51;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cF333TKvKoEPdWp3NVRShMgXfm+nfBeF284Oz3SCVky28S0eb2HUArBKhrvF25U/06+YxeHqvS6+WVIJOF/uPsr+Z0qPteVZLNsOrLF8w6TuK1LnXsw/7eQ0+bkGQ0bGgYZTD3/SVgi+zsJwlyZV23odTZeQW8iKMyLG+R6+5rUOJXTbEnATDHS4xeqt7bdt+bSFi2YImRthR4dJn9pp/lQ2VXGKG4r1T+X5UrVE+IE6P8TET5uYA54CE1top8WI9MouX1CYjth1OVFzYpepjGYaKAujtOcFMHbWvwn3/nX0vF0F4dBAicaWGdTyPrlodo1DWVvwmx92lg6DGQMLivkgCyuj4NVZ2FFyqRFZ+lYa8awtOcVo+H+yIscEFgnC5j33cSIVbZm0yJ1m14Lg6flu5OfIs4fFlLF4XTAJfyo4AVV7Wq1GnP9Hwkcf3GwZSqb3NOkMdND6pLt2uvI5rY+W4jk7oU+f9MbcIA1nfFfGiT4cwLbq1PFwNYn2v+XObPhAOUdIAlwA/a0B9XF6uAkJXN+VdgaUnbKecb7OnFSmd51Qfb7ZrJe5/lQ2X5m+rFmC08CRnNOTZ6OjHel6q3+dIni9XDogn8NRbTKVk7JUpUyGptb/FRbHOIyhv/hguQ29tcpHf/CXRDRIiz3jbeQLjXRmuQGXmlZ0MwVBwVi4rbeNQyXp0ZmR8Zt3z5QQUzfgxf4XrcuprYlOm+Qyk0fwtM6Nq5zb9K4Y41ZPMxkpy735Vsy278WXq/7ZwzBFC/SEZjnRBrqm04lV96KKErwTvQZpp1qbOT+LufT1EI8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3079.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(186003)(2906002)(33656002)(6506007)(66446008)(52536014)(64756008)(107886003)(55016002)(316002)(38100700002)(5660300002)(83380400001)(8676002)(122000001)(478600001)(71200400001)(26005)(9686003)(76116006)(54906003)(86362001)(966005)(66476007)(30864003)(8936002)(38070700005)(4326008)(110136005)(7696005)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8XUSw1e116VS465WPhofOY3bMe93m+Cs3syPjKCtv2BMBI9kzgxecE5rVJ1i?=
 =?us-ascii?Q?bGvWEVXh9JsVIJMK+yWZkj5/l0i3LFajk2wQkopJVbLshpqd4Vkv2bGNuBNt?=
 =?us-ascii?Q?XbS/DK3MQj51R5FcGuRA0GYeiEnxSB1ppSqJHPiMYKaj73LFzUacPc5BBpiV?=
 =?us-ascii?Q?tpf43Ch1S3MEtluNMj+TEKnKXzyGSVvg5ttsUCnR/4qLRFnsNtf8tzazdlCd?=
 =?us-ascii?Q?hGzlxZW1jcmTfWJjTzef2H09f/9c0ikfaDa1koK+NHqz30SsS37gCnWS0pef?=
 =?us-ascii?Q?v0XQ93CcZaVtyyocaAPlq1AMYA5gB77nRuCnqsLMsvihuTLjqnOw5S3kSC5X?=
 =?us-ascii?Q?khCJfW/s7UrcWXFXFUa6zWEY2CcHsA/I1nkQugL+9I0CbSCmHKO3ylw2fWZs?=
 =?us-ascii?Q?/oXMBzn4fElr7WofAXf3Z1pwgBb+y44DFwMBKrdwsFCU92kNVILwFbGqrFlB?=
 =?us-ascii?Q?R8CfuJWqNKRI19Bvhn10RU17StdNOSXbxEL+1/iIn97Pk607HwsS3F4sSS36?=
 =?us-ascii?Q?T6CV3LR5KWts9YoOhPh66b0+l/AHNlirLj3eTc3eI5CXm9cNHbxi52eO1zyU?=
 =?us-ascii?Q?n9N+3C3CJedIHMS8T46DxDYVkr9kqIOJH/fbfk3evyZyrA/wXCwWTFq37TW6?=
 =?us-ascii?Q?oDyBmZPDpmiDVFRA34Gbu6WLuJXWGSMcmxrHeKGBZsgkBuktFgLk6EPJJZzj?=
 =?us-ascii?Q?gDBC2TA7HMI6hq5hYo9558WMAsz0YQ6rGOsT59BU/evr9rNn5gvysqLcQ2ZY?=
 =?us-ascii?Q?XEQnI5xvwVyLxFfmmARdJcd4huu+K5GTeU33HqTcIg/xDH8Ptl2h1IIKilTZ?=
 =?us-ascii?Q?ncJfh3S08fnwfyOumerz1vW0orPWc9dWH0l5+cAw6QZKKXAy99Sy2406r+yA?=
 =?us-ascii?Q?XMROXBTp383bXUPVqR2aWfRh3L4J7HEyP/epraceV7FcA1y3X74FtEXtIoxW?=
 =?us-ascii?Q?fQfXSTZu1chY1v9dbm9Uza4sO7PTJvsKyr7uGZZK4/70aIz2Jy8bPEDaHAbn?=
 =?us-ascii?Q?vw4glDjwB/4SvfLGwbDC1CIs2+etYybt12Nk5cWmvfKQH8mnUPse0BSBTxUe?=
 =?us-ascii?Q?15lL92R+IDIvQqHs4Mr9FH/x6GrRGgl+XC4VqAx7PZDb42apgb6RTbUxrk+k?=
 =?us-ascii?Q?8YJFNeGILgiGauAzlhKS8D5TdbC45jmFTrO+oJ0p9PbjeP9QjgNsPEAbMrUR?=
 =?us-ascii?Q?6k16UY378DEf1n7skhGj0zpITCYsAi4s5hXO3SrJ9edW3vuPmuWVVwuybB+V?=
 =?us-ascii?Q?GjBuhS+oRaNsmEzHx+JXJ+YP7c/o5hPKgIXAZh+QQFqgPXSH11/+GtEU+f+U?=
 =?us-ascii?Q?8Q4PpXOYJ/zNcfa6bL9OrjGB?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3079.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ce63938-85e0-4354-5589-08d961583413
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Aug 2021 08:22:50.7121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CTW3abuHtfAj4NDXgQRoI6KvegEdNwuDe9qKQmMCQG+vUTWq99jonWVtKY+VV2XL4Q4qF4fmtRg1acOZl66vQQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4944
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

To: intel-wired-lan@lists.osuosl.org
Cc: netdev@vger.kernel.org; kuba@kernel.org; Nguyen, Anthony L <anthony.l.n=
guyen@intel.com>; Brandeburg, Jesse <jesse.brandeburg@intel.com>; Laba, Sla=
womirX <slawomirx.laba@intel.com>; Yang, Lihong <lihong.yang@intel.com>; sa=
ssmann@kpanic.de
Subject: [PATCH net-next] iavf: use mutexes for locking of critical section=
s

As follow-up to the discussion with Jakub Kicinski about iavf locking being=
 insufficient [1] convert iavf to use mutexes instead of bitops.
The locking logic is kept as is, just a drop-in replacement of enum iavf_cr=
itical_section_t with separate mutexes.
The only difference is that the mutexes will be destroyed before the module=
 is unloaded.

[1] https://lwn.net/ml/netdev/20210316150210.00007249%40intel.com/

Signed-off-by: Stefan Assmann <sassmann@kpanic.de>
---
 drivers/net/ethernet/intel/iavf/iavf.h        |   9 +-
 .../net/ethernet/intel/iavf/iavf_ethtool.c    |  10 +-
 drivers/net/ethernet/intel/iavf/iavf_main.c   | 100 +++++++++---------
 3 files changed, 56 insertions(+), 63 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf.h b/drivers/net/ethernet/=
intel/iavf/iavf.h
index e8bd04100ecd..b351ad653d12 100644
--- a/drivers/net/ethernet/intel/iavf/iavf.h
+++ b/drivers/net/ethernet/intel/iavf/iavf.h
@@ -185,12 +185,6 @@ enum iavf_state_t {
 	__IAVF_RUNNING,		/* opened, working */
 };
=20
-enum iavf_critical_section_t {
-	__IAVF_IN_CRITICAL_TASK,	/* cannot be interrupted */
-	__IAVF_IN_CLIENT_TASK,
-	__IAVF_IN_REMOVE_TASK,	/* device being removed */
-};
-
 #define IAVF_CLOUD_FIELD_OMAC		0x01
 #define IAVF_CLOUD_FIELD_IMAC		0x02
 #define IAVF_CLOUD_FIELD_IVLAN	0x04
@@ -235,6 +229,9 @@ struct iavf_adapter {
 	struct iavf_q_vector *q_vectors;
 	struct list_head vlan_filter_list;
 	struct list_head mac_filter_list;
+	struct mutex crit_lock;
+	struct mutex client_lock;
+	struct mutex remove_lock;
 	/* Lock to protect accesses to MAC and VLAN lists */
 	spinlock_t mac_vlan_list_lock;
 	char misc_vector_name[IFNAMSIZ + 9];
diff --git a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c b/drivers/net/e=
thernet/intel/iavf/iavf_ethtool.c
index af43fbd8cb75..edbeb27213f8 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_ethtool.c
@@ -1352,8 +1352,7 @@ static int iavf_add_fdir_ethtool(struct iavf_adapter =
*adapter, struct ethtool_rx
 	if (!fltr)
 		return -ENOMEM;
=20
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section)) {
+	while (!mutex_trylock(&adapter->crit_lock)) {
 		if (--count =3D=3D 0) {
 			kfree(fltr);
 			return -EINVAL;
@@ -1378,7 +1377,7 @@ static int iavf_add_fdir_ethtool(struct iavf_adapter =
*adapter, struct ethtool_rx
 	if (err && fltr)
 		kfree(fltr);
=20
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 	return err;
 }
=20
@@ -1563,8 +1562,7 @@ iavf_set_adv_rss_hash_opt(struct iavf_adapter *adapte=
r,
 		return -EINVAL;
 	}
=20
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section)) {
+	while (!mutex_trylock(&adapter->crit_lock)) {
 		if (--count =3D=3D 0) {
 			kfree(rss_new);
 			return -EINVAL;
@@ -1600,7 +1598,7 @@ iavf_set_adv_rss_hash_opt(struct iavf_adapter *adapte=
r,
 	if (!err)
 		mod_delayed_work(iavf_wq, &adapter->watchdog_task, 0);
=20
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
=20
 	if (!rss_new_add)
 		kfree(rss_new);
diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethe=
rnet/intel/iavf/iavf_main.c
index fa6cf20da911..cd0a424bd5f4 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -132,21 +132,18 @@ enum iavf_status iavf_free_virt_mem_d(struct iavf_hw =
*hw,  }
=20
 /**
- * iavf_lock_timeout - try to set bit but give up after timeout
- * @adapter: board private structure
- * @bit: bit to set
+ * iavf_lock_timeout - try to lock mutex but give up after timeout
+ * @lock: mutex that should be locked
  * @msecs: timeout in msecs
  *
  * Returns 0 on success, negative on failure
  **/
-static int iavf_lock_timeout(struct iavf_adapter *adapter,
-			     enum iavf_critical_section_t bit,
-			     unsigned int msecs)
+static int iavf_lock_timeout(struct mutex *lock, unsigned int msecs)
 {
 	unsigned int wait, delay =3D 10;
=20
 	for (wait =3D 0; wait < msecs; wait +=3D delay) {
-		if (!test_and_set_bit(bit, &adapter->crit_section))
+		if (mutex_trylock(lock))
 			return 0;
=20
 		msleep(delay);
@@ -1944,7 +1941,7 @@ static void iavf_watchdog_task(struct work_struct *wo=
rk)
 	struct iavf_hw *hw =3D &adapter->hw;
 	u32 reg_val;
=20
-	if (test_and_set_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section))
+	if (!mutex_trylock(&adapter->crit_lock))
 		goto restart_watchdog;
=20
 	if (adapter->flags & IAVF_FLAG_PF_COMMS_FAILED) @@ -1962,8 +1959,7 @@ sta=
tic void iavf_watchdog_task(struct work_struct *work)
 			adapter->state =3D __IAVF_STARTUP;
 			adapter->flags &=3D ~IAVF_FLAG_PF_COMMS_FAILED;
 			queue_delayed_work(iavf_wq, &adapter->init_task, 10);
-			clear_bit(__IAVF_IN_CRITICAL_TASK,
-				  &adapter->crit_section);
+			mutex_unlock(&adapter->crit_lock);
 			/* Don't reschedule the watchdog, since we've restarted
 			 * the init task. When init_task contacts the PF and
 			 * gets everything set up again, it'll restart the @@ -1973,14 +1969,13=
 @@ static void iavf_watchdog_task(struct work_struct *work)
 		}
 		adapter->aq_required =3D 0;
 		adapter->current_op =3D VIRTCHNL_OP_UNKNOWN;
-		clear_bit(__IAVF_IN_CRITICAL_TASK,
-			  &adapter->crit_section);
+		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq,
 				   &adapter->watchdog_task,
 				   msecs_to_jiffies(10));
 		goto watchdog_done;
 	case __IAVF_RESETTING:
-		clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+		mutex_unlock(&adapter->crit_lock);
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, HZ * 2);
 		return;
 	case __IAVF_DOWN:
@@ -2003,7 +1998,7 @@ static void iavf_watchdog_task(struct work_struct *wo=
rk)
 		}
 		break;
 	case __IAVF_REMOVE:
-		clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+		mutex_unlock(&adapter->crit_lock);
 		return;
 	default:
 		goto restart_watchdog;
@@ -2025,7 +2020,7 @@ static void iavf_watchdog_task(struct work_struct *wo=
rk)
 	if (adapter->state =3D=3D __IAVF_RUNNING ||
 	    adapter->state =3D=3D __IAVF_COMM_FAILED)
 		iavf_detect_recover_hung(&adapter->vsi);
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 restart_watchdog:
 	if (adapter->aq_required)
 		queue_delayed_work(iavf_wq, &adapter->watchdog_task, @@ -2089,7 +2084,7 =
@@ static void iavf_disable_vf(struct iavf_adapter *adapter)
 	memset(adapter->vf_res, 0, IAVF_VIRTCHNL_VF_RESOURCE_SIZE);
 	iavf_shutdown_adminq(&adapter->hw);
 	adapter->netdev->flags &=3D ~IFF_UP;
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 	adapter->flags &=3D ~IAVF_FLAG_RESET_PENDING;
 	adapter->state =3D __IAVF_DOWN;
 	wake_up(&adapter->down_waitqueue);
@@ -2122,15 +2117,14 @@ static void iavf_reset_task(struct work_struct *wor=
k)
 	/* When device is being removed it doesn't make sense to run the reset
 	 * task, just return in such a case.
 	 */
-	if (test_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section))
+	if (mutex_is_locked(&adapter->remove_lock))
 		return;
=20
-	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 200)) {
+	if (iavf_lock_timeout(&adapter->crit_lock, 200)) {
 		schedule_work(&adapter->reset_task);
 		return;
 	}
-	while (test_and_set_bit(__IAVF_IN_CLIENT_TASK,
-				&adapter->crit_section))
+	while (!mutex_trylock(&adapter->client_lock))
 		usleep_range(500, 1000);
 	if (CLIENT_ENABLED(adapter)) {
 		adapter->flags &=3D ~(IAVF_FLAG_CLIENT_NEEDS_OPEN | @@ -2182,7 +2176,7 @=
@ static void iavf_reset_task(struct work_struct *work)
 		dev_err(&adapter->pdev->dev, "Reset never finished (%x)\n",
 			reg_val);
 		iavf_disable_vf(adapter);
-		clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
+		mutex_unlock(&adapter->client_lock);
 		return; /* Do not attempt to reinit. It's dead, Jim. */
 	}
=20
@@ -2301,13 +2295,13 @@ static void iavf_reset_task(struct work_struct *wor=
k)
 		adapter->state =3D __IAVF_DOWN;
 		wake_up(&adapter->down_waitqueue);
 	}
-	clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->client_lock);
+	mutex_unlock(&adapter->crit_lock);
=20
 	return;
 reset_err:
-	clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->client_lock);
+	mutex_unlock(&adapter->crit_lock);
 	dev_err(&adapter->pdev->dev, "failed to allocate resources during reinit\=
n");
 	iavf_close(netdev);
 }
@@ -2335,7 +2329,7 @@ static void iavf_adminq_task(struct work_struct *work=
)
 	if (!event.msg_buf)
 		goto out;
=20
-	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 200))
+	if (iavf_lock_timeout(&adapter->crit_lock, 200))
 		goto freedom;
 	do {
 		ret =3D iavf_clean_arq_element(hw, &event, &pending); @@ -2350,7 +2344,7=
 @@ static void iavf_adminq_task(struct work_struct *work)
 		if (pending !=3D 0)
 			memset(event.msg_buf, 0, IAVF_MAX_AQ_BUF_SIZE);
 	} while (pending);
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
=20
 	if ((adapter->flags &
 	     (IAVF_FLAG_RESET_PENDING | IAVF_FLAG_RESET_NEEDED)) || @@ -2417,7 +2=
411,7 @@ static void iavf_client_task(struct work_struct *work)
 	 * later.
 	 */
=20
-	if (test_and_set_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section))
+	if (!mutex_trylock(&adapter->client_lock))
 		return;
=20
 	if (adapter->flags & IAVF_FLAG_SERVICE_CLIENT_REQUESTED) { @@ -2440,7 +24=
34,7 @@ static void iavf_client_task(struct work_struct *work)
 		adapter->flags &=3D ~IAVF_FLAG_CLIENT_NEEDS_OPEN;
 	}
 out:
-	clear_bit(__IAVF_IN_CLIENT_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->client_lock);
 }
=20
 /**
@@ -3043,8 +3037,7 @@ static int iavf_configure_clsflower(struct iavf_adapt=
er *adapter,
 	if (!filter)
 		return -ENOMEM;
=20
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section)) {
+	while (!mutex_trylock(&adapter->crit_lock)) {
 		if (--count =3D=3D 0)
 			goto err;
 		udelay(1);
@@ -3075,7 +3068,7 @@ static int iavf_configure_clsflower(struct iavf_adapt=
er *adapter,
 	if (err)
 		kfree(filter);
=20
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 	return err;
 }
=20
@@ -3222,8 +3215,7 @@ static int iavf_open(struct net_device *netdev)
 		return -EIO;
 	}
=20
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section))
+	while (!mutex_trylock(&adapter->crit_lock))
 		usleep_range(500, 1000);
=20
 	if (adapter->state !=3D __IAVF_DOWN) {
@@ -3258,7 +3250,7 @@ static int iavf_open(struct net_device *netdev)
=20
 	iavf_irq_enable(adapter, true);
=20
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
=20
 	return 0;
=20
@@ -3270,7 +3262,7 @@ static int iavf_open(struct net_device *netdev)
 err_setup_tx:
 	iavf_free_all_tx_resources(adapter);
 err_unlock:
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
=20
 	return err;
 }
@@ -3294,8 +3286,7 @@ static int iavf_close(struct net_device *netdev)
 	if (adapter->state <=3D __IAVF_DOWN_PENDING)
 		return 0;
=20
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section))
+	while (!mutex_trylock(&adapter->crit_lock))
 		usleep_range(500, 1000);
=20
 	set_bit(__IAVF_VSI_DOWN, adapter->vsi.state); @@ -3306,7 +3297,7 @@ stati=
c int iavf_close(struct net_device *netdev)
 	adapter->state =3D __IAVF_DOWN_PENDING;
 	iavf_free_traffic_irqs(adapter);
=20
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
=20
 	/* We explicitly don't free resources here because the hardware is
 	 * still active and can DMA into memory. Resources are cleared in @@ -365=
5,8 +3646,8 @@ static void iavf_init_task(struct work_struct *work)
 						    init_task.work);
 	struct iavf_hw *hw =3D &adapter->hw;
=20
-	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000)) {
-		dev_warn(&adapter->pdev->dev, "failed to set __IAVF_IN_CRITICAL_TASK in =
%s\n", __FUNCTION__);
+	if (iavf_lock_timeout(&adapter->crit_lock, 5000)) {
+		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n",=20
+__FUNCTION__);
 		return;
 	}
 	switch (adapter->state) {
@@ -3691,7 +3682,7 @@ static void iavf_init_task(struct work_struct *work)
 	}
 	queue_delayed_work(iavf_wq, &adapter->init_task, HZ);
 out:
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
 }
=20
 /**
@@ -3708,12 +3699,12 @@ static void iavf_shutdown(struct pci_dev *pdev)
 	if (netif_running(netdev))
 		iavf_close(netdev);
=20
-	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000))
-		dev_warn(&adapter->pdev->dev, "failed to set __IAVF_IN_CRITICAL_TASK in =
%s\n", __FUNCTION__);
+	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
+		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n",=20
+__FUNCTION__);
 	/* Prevent the watchdog from running. */
 	adapter->state =3D __IAVF_REMOVE;
 	adapter->aq_required =3D 0;
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
=20
 #ifdef CONFIG_PM
 	pci_save_state(pdev);
@@ -3807,6 +3798,9 @@ static int iavf_probe(struct pci_dev *pdev, const str=
uct pci_device_id *ent)
 	/* set up the locks for the AQ, do this only once in probe
 	 * and destroy them only once in remove
 	 */
+	mutex_init(&adapter->crit_lock);
+	mutex_init(&adapter->client_lock);
+	mutex_init(&adapter->remove_lock);
 	mutex_init(&hw->aq.asq_mutex);
 	mutex_init(&hw->aq.arq_mutex);
=20
@@ -3858,8 +3852,7 @@ static int __maybe_unused iavf_suspend(struct device =
*dev_d)
=20
 	netif_device_detach(netdev);
=20
-	while (test_and_set_bit(__IAVF_IN_CRITICAL_TASK,
-				&adapter->crit_section))
+	while (!mutex_trylock(&adapter->crit_lock))
 		usleep_range(500, 1000);
=20
 	if (netif_running(netdev)) {
@@ -3870,7 +3863,7 @@ static int __maybe_unused iavf_suspend(struct device =
*dev_d)
 	iavf_free_misc_irq(adapter);
 	iavf_reset_interrupt_capability(adapter);
=20
-	clear_bit(__IAVF_IN_CRITICAL_TASK, &adapter->crit_section);
+	mutex_unlock(&adapter->crit_lock);
=20
 	return 0;
 }
@@ -3932,7 +3925,7 @@ static void iavf_remove(struct pci_dev *pdev)
 	struct iavf_hw *hw =3D &adapter->hw;
 	int err;
 	/* Indicate we are in remove and not to run reset_task */
-	set_bit(__IAVF_IN_REMOVE_TASK, &adapter->crit_section);
+	mutex_lock(&adapter->remove_lock);
 	cancel_delayed_work_sync(&adapter->init_task);
 	cancel_work_sync(&adapter->reset_task);
 	cancel_delayed_work_sync(&adapter->client_task);
@@ -3954,8 +3947,8 @@ static void iavf_remove(struct pci_dev *pdev)
 		iavf_request_reset(adapter);
 		msleep(50);
 	}
-	if (iavf_lock_timeout(adapter, __IAVF_IN_CRITICAL_TASK, 5000))
-		dev_warn(&adapter->pdev->dev, "failed to set __IAVF_IN_CRITICAL_TASK in =
%s\n", __FUNCTION__);
+	if (iavf_lock_timeout(&adapter->crit_lock, 5000))
+		dev_warn(&adapter->pdev->dev, "failed to acquire crit_lock in %s\n",=20
+__FUNCTION__);
=20
 	/* Shut down all the garbage mashers on the detention level */
 	adapter->state =3D __IAVF_REMOVE;
@@ -3980,6 +3973,11 @@ static void iavf_remove(struct pci_dev *pdev)
 	/* destroy the locks only once, here */
 	mutex_destroy(&hw->aq.arq_mutex);
 	mutex_destroy(&hw->aq.asq_mutex);
+	mutex_destroy(&adapter->client_lock);
+	mutex_unlock(&adapter->crit_lock);
+	mutex_destroy(&adapter->crit_lock);
+	mutex_unlock(&adapter->remove_lock);
+	mutex_destroy(&adapter->remove_lock);
=20
 	iounmap(hw->hw_addr);
 	pci_release_regions(pdev);
--
2.31.1

Tested-by: Marek Szlosek <marek.szlosek@intel.com>
