Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425556E2980
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbjDNRau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbjDNR3s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:29:48 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0068E9ED7
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:29:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681493375; x=1713029375;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bpLzopjPhDOwj71b+0HE/HhkKnSaAE/kpypqYy0JL80=;
  b=jyBQYInlFWF9EsGd3I5paZUFWQ587/OOTbeT2W3l+UmMJjubqzIoxC6w
   e2lh3H73y1G/Ul+g1+e4h8jdYzT5voACjlT624MIQrlfQvB4y5EwbfJy5
   h6v4wF3bViPWopAFbaHqk3Pai3/xHuP4dOLjLjFldVTkV+gi4GCnOOHFB
   toESnAzK4euenZxkduvKpcBZ5isU5TJbVmK4WpGlVTxsg6Noe+ySBaSb/
   7qpmrv+pQTkugobe5UOWfT4JmsE7JgXdnx6YM/aBcJjFki9eTfoHxV1pO
   GZJ38L6eItzpBsVqorYRGYxu+1/Dm71OGmhh1okeRBa0S6evaPGPrKXee
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="372388283"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="372388283"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Apr 2023 10:29:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10680"; a="720357639"
X-IronPort-AV: E=Sophos;i="5.99,197,1677571200"; 
   d="scan'208";a="720357639"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga008.jf.intel.com with ESMTP; 14 Apr 2023 10:29:12 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 14 Apr 2023 10:29:12 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 14 Apr 2023 10:29:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxXw/vmDk3WrM/QVcn2XKPRcubTC42nN0l+v+k8Pfc05t4ttaYukJisQXJvjxsZczj5w0ZIt+lnt1kSGLh9qQp+SLjXOmH75roYOKqzx2kacDZ2rJE4ajWJlNnORTWgQOyuoWRd9P0Y+Oe/4MoYwlwanqFdIDubZ1WVczWl1tZjDc+Wwte0cGt/mEzWtmYnLO3BRmF4LWQCxCFS74yFdVynyqspeCLHQDhgNEk0p8GWSiugXxWFJGVxF91sdnH4m0leY62PBTxG7s0BZYXSC5dNyYcdEIr9QEftgXNuJQvGdvN4Y4G4a1aVTpAD8lXlo9DA2wXGXMuK1wEaEVl8Gsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ePKwiNHkTp4fsqgWx0r5WmoEUb21aYkHHASs5KKl1WM=;
 b=dNUibcdFYnWfa9w86Wm88CgwpP5AEV05XxRaSJo/u3t5Uj0l1qg3vy7eu+NieDCqjIbMnnhQjnYJCVe+ALtsaQNulqDGagFEwsNUA0ANg76JDD0MnRpCLf+7gz1X+gPkAaGYPrgqnsWhO5Yi9xM+cw4ZPcXEKawG5DikwIEv71/wPhnxfXk3B23hjpAU8CZPZE2cvdhW0tbi1toqDQ0ZvbhEubWAR45M0xKSuu6h48685RODPHu8NZgXFx/8faSnlGRbDhUDYQbu3FTsHHXSpMWUiZ+G+fo0Gctm5iddWTJZ3PPpYI2mMYYAI14CMAGJwPtDSvOI9uiWNxxRfdzrYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DM4PR11MB6454.namprd11.prod.outlook.com (2603:10b6:8:b8::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6156.28; Fri, 14 Apr 2023 17:29:10 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::f829:c44d:af33:e2c8%4]) with mapi id 15.20.6298.030; Fri, 14 Apr 2023
 17:29:10 +0000
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
Subject: RE: [PATCH net-next v2 1/6] ice: do not busy-wait to read GNSS data
Thread-Topic: [PATCH net-next v2 1/6] ice: do not busy-wait to read GNSS data
Thread-Index: AQHZbRedXym6hw6240WG+0AAEmeJoK8q622g
Date:   Fri, 14 Apr 2023 17:29:10 +0000
Message-ID: <DM6PR11MB465782F454C40C30993F9A099B999@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230412081929.173220-1-mschmidt@redhat.com>
 <20230412081929.173220-2-mschmidt@redhat.com>
In-Reply-To: <20230412081929.173220-2-mschmidt@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DM4PR11MB6454:EE_
x-ms-office365-filtering-correlation-id: 61c5b07c-13e0-4360-d4ba-08db3d0dc222
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(39860400002)(376002)(366004)(346002)(136003)(451199021)(38070700005)(7696005)(71200400001)(41300700001)(55016003)(86362001)(8936002)(26005)(2906002)(186003)(52536014)(33656002)(6506007)(5660300002)(76116006)(478600001)(66946007)(66446008)(64756008)(66556008)(4326008)(8676002)(9686003)(66476007)(110136005)(54906003)(82960400001)(38100700002)(122000001)(316002)(66899021)(83380400001);DIR:OUT;SFP:1102;
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 61c5b07c-13e0-4360-d4ba-08db3d0dc222
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 17:29:10.3817
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /fRUN/Ym/2LAfGufp++3De+fY3+hc+z0kfgaLQcusFDo55EcUqylzRSFpX9/gTUw5T8hH6o288ifNUdmCdsNINNIvhx2iaLyK/QI4VPs3Pk=
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
>The ice-gnss-<dev_name> kernel thread, which reads data from the u-blox
>GNSS module, keep a CPU core almost 100% busy. The main reason is that
>it busy-waits for data to become available.
>
>A simple improvement would be to replace the "mdelay(10);" in
>ice_gnss_read() with sleeping. A better fix is to not do any waiting
>directly in the function and just requeue this delayed work as needed.
>The advantage is that canceling the work from ice_gnss_exit() becomes
>immediate, rather than taking up to ~2.5 seconds (ICE_MAX_UBX_READ_TRIES
>* 10 ms).
>
>This lowers the CPU usage of the ice-gnss-<dev_name> thread on my system
>from ~90 % to ~8 %.
>
>I am not sure if the larger 0.1 s pause after inserting data into the
>gnss subsystem is really necessary, but I'm keeping that as it was.
>
>Of course, ideally the driver would not have to poll at all, but I don't
>know if the E810 can watch for GNSS data availability over the i2c bus
>by itself and notify the driver.
>
>Signed-off-by: Michal Schmidt <mschmidt@redhat.com>
>---
> drivers/net/ethernet/intel/ice/ice_gnss.c | 42 ++++++++++-------------
> drivers/net/ethernet/intel/ice/ice_gnss.h |  3 +-
> 2 files changed, 20 insertions(+), 25 deletions(-)
>
>diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.c
>b/drivers/net/ethernet/intel/ice/ice_gnss.c
>index 8dec748bb53a..2ea8a2b11bcd 100644
>--- a/drivers/net/ethernet/intel/ice/ice_gnss.c
>+++ b/drivers/net/ethernet/intel/ice/ice_gnss.c
>@@ -117,6 +117,7 @@ static void ice_gnss_read(struct kthread_work *work)
> {
> 	struct gnss_serial *gnss =3D container_of(work, struct gnss_serial,
> 						read_work.work);
>+	unsigned long delay =3D ICE_GNSS_POLL_DATA_DELAY_TIME;
> 	unsigned int i, bytes_read, data_len, count;
> 	struct ice_aqc_link_topo_addr link_topo;
> 	struct ice_pf *pf;
>@@ -136,11 +137,6 @@ static void ice_gnss_read(struct kthread_work *work)
> 		return;
>
> 	hw =3D &pf->hw;
>-	buf =3D (char *)get_zeroed_page(GFP_KERNEL);
>-	if (!buf) {
>-		err =3D -ENOMEM;
>-		goto exit;
>-	}
>
> 	memset(&link_topo, 0, sizeof(struct ice_aqc_link_topo_addr));
> 	link_topo.topo_params.index =3D ICE_E810T_GNSS_I2C_BUS;
>@@ -151,25 +147,24 @@ static void ice_gnss_read(struct kthread_work *work)
> 	i2c_params =3D ICE_GNSS_UBX_DATA_LEN_WIDTH |
> 		     ICE_AQC_I2C_USE_REPEATED_START;
>
>-	/* Read data length in a loop, when it's not 0 the data is ready */
>-	for (i =3D 0; i < ICE_MAX_UBX_READ_TRIES; i++) {
>-		err =3D ice_aq_read_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
>-				      cpu_to_le16(ICE_GNSS_UBX_DATA_LEN_H),
>-				      i2c_params, (u8 *)&data_len_b, NULL);
>-		if (err)
>-			goto exit_buf;
>+	err =3D ice_aq_read_i2c(hw, link_topo, ICE_GNSS_UBX_I2C_BUS_ADDR,
>+			      cpu_to_le16(ICE_GNSS_UBX_DATA_LEN_H),
>+			      i2c_params, (u8 *)&data_len_b, NULL);
>+	if (err)
>+		goto requeue;
>
>-		data_len =3D be16_to_cpu(data_len_b);
>-		if (data_len !=3D 0 && data_len !=3D U16_MAX)
>-			break;
>+	data_len =3D be16_to_cpu(data_len_b);
>+	if (data_len =3D=3D 0 || data_len =3D=3D U16_MAX)
>+		goto requeue;
>
>-		mdelay(10);
>-	}
>+	/* The u-blox has data_len bytes for us to read */
>
> 	data_len =3D min_t(typeof(data_len), data_len, PAGE_SIZE);
>-	if (!data_len) {
>+
>+	buf =3D (char *)get_zeroed_page(GFP_KERNEL);
>+	if (!buf) {
> 		err =3D -ENOMEM;
>-		goto exit_buf;
>+		goto requeue;
> 	}
>
> 	/* Read received data */
>@@ -183,7 +178,7 @@ static void ice_gnss_read(struct kthread_work *work)
> 				      cpu_to_le16(ICE_GNSS_UBX_EMPTY_DATA),
> 				      bytes_read, &buf[i], NULL);
> 		if (err)
>-			goto exit_buf;
>+			goto free_buf;
> 	}
>
> 	count =3D gnss_insert_raw(pf->gnss_dev, buf, i);
>@@ -191,10 +186,11 @@ static void ice_gnss_read(struct kthread_work *work)
> 		dev_warn(ice_pf_to_dev(pf),
> 			 "gnss_insert_raw ret=3D%d size=3D%d\n",
> 			 count, i);
>-exit_buf:
>+	delay =3D ICE_GNSS_TIMER_DELAY_TIME;
>+free_buf:
> 	free_page((unsigned long)buf);
>-	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work,
>-				   ICE_GNSS_TIMER_DELAY_TIME);
>+requeue:
>+	kthread_queue_delayed_work(gnss->kworker, &gnss->read_work, delay);
> exit:
> 	if (err)
> 		dev_dbg(ice_pf_to_dev(pf), "GNSS failed to read err=3D%d\n",
>err);
>diff --git a/drivers/net/ethernet/intel/ice/ice_gnss.h
>b/drivers/net/ethernet/intel/ice/ice_gnss.h
>index 4d49e5b0b4b8..640df7411373 100644
>--- a/drivers/net/ethernet/intel/ice/ice_gnss.h
>+++ b/drivers/net/ethernet/intel/ice/ice_gnss.h
>@@ -5,6 +5,7 @@
> #define _ICE_GNSS_H_
>
> #define ICE_E810T_GNSS_I2C_BUS		0x2
>+#define ICE_GNSS_POLL_DATA_DELAY_TIME	(HZ / 100) /* poll every 10 ms */
> #define ICE_GNSS_TIMER_DELAY_TIME	(HZ / 10) /* 0.1 second per message */
> #define ICE_GNSS_TTY_WRITE_BUF		250
> #define ICE_MAX_I2C_DATA_SIZE
>	FIELD_MAX(ICE_AQC_I2C_DATA_SIZE_M)
>@@ -20,8 +21,6 @@
>  * passed as I2C addr parameter.
>  */
> #define ICE_GNSS_UBX_WRITE_BYTES	(ICE_MAX_I2C_WRITE_BYTES + 1)
>-#define ICE_MAX_UBX_READ_TRIES		255
>-#define ICE_MAX_UBX_ACK_READ_TRIES	4095
>
> struct gnss_write_buf {
> 	struct list_head queue;
>--
>2.39.2

Looks good, thank you Michal!

Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
