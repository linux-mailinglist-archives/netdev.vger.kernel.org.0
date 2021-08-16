Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 896683EDCB8
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 20:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhHPSBR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 14:01:17 -0400
Received: from rcdn-iport-5.cisco.com ([173.37.86.76]:39462 "EHLO
        rcdn-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbhHPSBQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 14:01:16 -0400
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Aug 2021 14:01:15 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=2779; q=dns/txt; s=iport;
  t=1629136844; x=1630346444;
  h=from:to:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=2Wt06gvNZE58DEbCRXvp7vlIAT9vRQqK1pCfOOxraQw=;
  b=Qs/y2bDTkgR1xIFynub/IOBbAmfRvBoBDxGOQ1a8p+xmkbsd9ioRSBn0
   wNk/EBJrBsCfC7M4ItPme0CLfwsIJNfetCbsLzmeZ5sf9zZ5K6x/R8/nW
   04gEP/UPlvfBGzl7PtB8APSeBbdHhBqFMyo+umzO/GBmB5Y3GmINLM4vZ
   g=;
IronPort-PHdr: =?us-ascii?q?A9a23=3AQ13tohFcU/gJeHBo3Vqf6J1Gfj4Y04WdBeZdw?=
 =?us-ascii?q?oAqh7JHbuKo+JGxdEDc5PA4iljPUM2b7v9fkOPZvujmXnBI+peOtn0OMfkuH?=
 =?us-ascii?q?x8IgMkbhUosVciCD0CoNvPmbyUmWs9FUQwt83SyK0MAHsH4ahXbqWGz6jhHH?=
 =?us-ascii?q?BL5OEJ1K+35F5SUgd6w0rW5+obYZENDgz/uCY4=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AA8gx0ah/cO6VQJ76+EH25QL94HBQX3t13D?=
 =?us-ascii?q?Abv31ZSRFFG/FwyPrOoB1L73HJYWgqN03IwerwRJVoMkmsiqKdhrNhfItKPT?=
 =?us-ascii?q?OW9ldASbsD0WKM+UyZJ8STzJ856U4kSdkCNDSSNyk7sS+Z2njCLz9I+rDum8?=
 =?us-ascii?q?rE6Za8vhVQpENRGttdBmxCe2Gm+zhNNXB77O0CZfyhD6R81l6dUEVSSv7+Km?=
 =?us-ascii?q?gOXuDFqdGOvonhewQ6Cxku7xTLpS+06ZbheiLonSs2Yndq+/MP4GLFmwv26u?=
 =?us-ascii?q?GIqPeg0CLR0GfV8tB/hMbh8N1eH8aB4/JlaAkEyzzYIbiJaYfy+wzdk9vfrm?=
 =?us-ascii?q?rCV+O8+ivICv4Dr085uFvF+ScFlTOQiwrGoEWSt2NwyUGT0PARAghKUfaoQe?=
 =?us-ascii?q?liA0fkA41KhqAg7EsD5RPoi7NHSRzHhyjz/N7OSlVjkVe1u2MrlaoJg2VYSp?=
 =?us-ascii?q?Z2Us4akWUzxjIcLH47JlOw1GnnKpgbMOjMoPJNNV+KZXHQuWdihNSqQ3QoBx?=
 =?us-ascii?q?+DBkwPoNac3TRalG1wixJw/r1Sol4QsJYmD5VU7eXNNapl0LlIU88NdKp4QO?=
 =?us-ascii?q?MMW9G+BGDBSQ/FdGiSPVPkHqcaPG+lke+73JwloOWxPJAYxpo7n5rMFFteqG?=
 =?us-ascii?q?4pYkrrTdaD2ZVamyq9CVlVnQ6dvP22wqIJ9YEUaICbQxFreWpe5PdI+c9vcf?=
 =?us-ascii?q?Ezc8zDTa5rPw=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0AXCgD9pBph/5pdJa1agQmBWYFTUQe?=
 =?us-ascii?q?BUTcxiA8DhTmGRYIniluLTIQTgS6BJQNUCwEBAQ0BASoXBAEBgSiDOQKCbAI?=
 =?us-ascii?q?lNAkOAQIEAQEBEgEBBQEBAQIBBgSBEROFaA2GQgEBAQEDAREoBgEBOAsEAgE?=
 =?us-ascii?q?IEQQBAR8QIQcKHQgCBAESCBqFJQMvAZtBAYE6AoofeIEzgQGCBwEBBgQEhS4?=
 =?us-ascii?q?NC4I0CYE6gn6KdSccgg2BFUOCYj6CIIImg0uCLocCZRereJEZJl4KgyiBMpV?=
 =?us-ascii?q?QgWuFfhKDZaMQLZVkgh6NVpUoAgQCBAUCDgEBBoFgOzmBIHAVgyRQGQ6SEoJ?=
 =?us-ascii?q?ChCuDNAE8cwI2AgYLAQEDCYl1AQE?=
X-IronPort-AV: E=Sophos;i="5.84,326,1620691200"; 
   d="scan'208";a="650995374"
Received: from rcdn-core-3.cisco.com ([173.37.93.154])
  by rcdn-iport-5.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 16 Aug 2021 17:53:28 +0000
Received: from mail.cisco.com (xbe-aln-002.cisco.com [173.36.7.17])
        by rcdn-core-3.cisco.com (8.15.2/8.15.2) with ESMTPS id 17GHrSKf006685
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=OK);
        Mon, 16 Aug 2021 17:53:28 GMT
Received: from xfe-rtp-003.cisco.com (64.101.210.233) by xbe-aln-002.cisco.com
 (173.36.7.17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Mon, 16 Aug
 2021 12:53:27 -0500
Received: from xfe-rtp-004.cisco.com (64.101.210.234) by xfe-rtp-003.cisco.com
 (64.101.210.233) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Mon, 16 Aug
 2021 13:53:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (64.101.32.56) by
 xfe-rtp-004.cisco.com (64.101.210.234) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15
 via Frontend Transport; Mon, 16 Aug 2021 13:53:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dfnQBrV41hPt5DIU+nXUTl4osXyMBvwVrFNkJhNn04SCtHqZXEzLGWFaDli1hlrYfbblyieG6L5x4pgFuleixcb2YmLUWz/mRvwiRoBhY0S/LxpmpRfYVFgbLCTc20cUUXvDoEaDA2lSl+PVjuuKqWsYuU/M9mMXhQwCshwmZIdnf4WY4riT4EvxYq4yCNMgMaChIyRTrTfVXfdFoSwXgLzQQ2M+8szTKorwuDjwMexpJNrqndfsm07U2wUXxSnKn1ZC5QPgxtqVxOq8n3FEa5Tjz+Y+9TlWtMZVV6iq89ffp2dwndmBCKz7yiEPh9w7ADUiP3trGlK2WIhz9OAzwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Wt06gvNZE58DEbCRXvp7vlIAT9vRQqK1pCfOOxraQw=;
 b=K6rSV1+/JDLgnZ66e6vg/r2tX+xnfZ1plQtaQykwjBGtQ0yfUm/pveIMAzsmbRhLo8C8ZGqL6lKhQNp2IHnnSNdNrhX1XyFFPfDhGLIveZxLcTsEzkLsATFYsyt0RkHBFoTnm1ReFwYHYHCH7AZjY1QYyCXYOJ12VU1FVn74yePsHJA7m/UWsAsml2IqwIoyvI5pC+YBekme0SRb/096kTKzhxGwNG430Jfog2REMpgzPNw6MFdlccXEyUjcHiY1xdEnTCY/bup/e4vg6KWkmB4tlvyu7o4D8DdX6k547AdoH3TdTon8/YxLaJr5O6NmPkudJN1HwrlA86lysls+ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Wt06gvNZE58DEbCRXvp7vlIAT9vRQqK1pCfOOxraQw=;
 b=jIy85MnscNDDZo+joeCuL84GDjZO/cntsJ5pxvLafMFOsd/NeAUqJN4mhsvnwso+JquT4vMnmIglZVCxqsiqLHvElbGZxoB2YRLvFXbiiqvHn30j3xRygtdkO3AesvDwuqZTYm7IOfRbg0pP4BC5wPkBEkWKx+vba7SrG61u8BA=
Received: from BYAPR11MB3799.namprd11.prod.outlook.com (2603:10b6:a03:fb::19)
 by SJ0PR11MB5182.namprd11.prod.outlook.com (2603:10b6:a03:2ae::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.15; Mon, 16 Aug
 2021 17:53:25 +0000
Received: from BYAPR11MB3799.namprd11.prod.outlook.com
 ([fe80::b06c:c552:f96f:a7f1]) by BYAPR11MB3799.namprd11.prod.outlook.com
 ([fe80::b06c:c552:f96f:a7f1%7]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 17:53:25 +0000
From:   "Christian Benvenuti (benve)" <benve@cisco.com>
To:     Nitesh Narayan Lal <nitesh@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "robin.murphy@arm.com" <robin.murphy@arm.com>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "jbrandeb@kernel.org" <jbrandeb@kernel.org>,
        "frederic@kernel.org" <frederic@kernel.org>,
        "juri.lelli@redhat.com" <juri.lelli@redhat.com>,
        "abelits@marvell.com" <abelits@marvell.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "rppt@linux.vnet.ibm.com" <rppt@linux.vnet.ibm.com>,
        "chris.friesen@windriver.com" <chris.friesen@windriver.com>,
        "maz@kernel.org" <maz@kernel.org>,
        "nhorman@tuxdriver.com" <nhorman@tuxdriver.com>,
        "pjwaskiewicz@gmail.com" <pjwaskiewicz@gmail.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "thenzl@redhat.com" <thenzl@redhat.com>,
        "kashyap.desai@broadcom.com" <kashyap.desai@broadcom.com>,
        "sumit.saxena@broadcom.com" <sumit.saxena@broadcom.com>,
        "shivasharan.srikanteshwara@broadcom.com" 
        <shivasharan.srikanteshwara@broadcom.com>,
        "sathya.prakash@broadcom.com" <sathya.prakash@broadcom.com>,
        "sreekanth.reddy@broadcom.com" <sreekanth.reddy@broadcom.com>,
        "suganath-prabu.subramani@broadcom.com" 
        <suganath-prabu.subramani@broadcom.com>,
        "james.smart@broadcom.com" <james.smart@broadcom.com>,
        "dick.kennedy@broadcom.com" <dick.kennedy@broadcom.com>,
        "jkc@redhat.com" <jkc@redhat.com>,
        "faisal.latif@intel.com" <faisal.latif@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "tariqt@nvidia.com" <tariqt@nvidia.com>,
        "ahleihel@redhat.com" <ahleihel@redhat.com>,
        "kheib@redhat.com" <kheib@redhat.com>,
        "borisp@nvidia.com" <borisp@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "govind@gmx.com" <govind@gmx.com>,
        "jassisinghbrar@gmail.com" <jassisinghbrar@gmail.com>,
        "ajit.khaparde@broadcom.com" <ajit.khaparde@broadcom.com>,
        "sriharsha.basavapatna@broadcom.com" 
        <sriharsha.basavapatna@broadcom.com>,
        "somnath.kotur@broadcom.com" <somnath.kotur@broadcom.com>,
        "nilal@redhat.com" <nilal@redhat.com>,
        "tatyana.e.nikolova@intel.com" <tatyana.e.nikolova@intel.com>,
        "mustafa.ismail@intel.com" <mustafa.ismail@intel.com>,
        "ahs3@redhat.com" <ahs3@redhat.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "chandrakanth.patil@broadcom.com" <chandrakanth.patil@broadcom.com>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "chunkuang.hu@kernel.org" <chunkuang.hu@kernel.org>,
        "yongqiang.niu@mediatek.com" <yongqiang.niu@mediatek.com>,
        "baolin.wang7@gmail.com" <baolin.wang7@gmail.com>,
        "poros@redhat.com" <poros@redhat.com>,
        "minlei@redhat.com" <minlei@redhat.com>,
        "emilne@redhat.com" <emilne@redhat.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "_govind@gmx.com" <_govind@gmx.com>,
        "kabel@kernel.org" <kabel@kernel.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "Tushar.Khandelwal@arm.com" <Tushar.Khandelwal@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [PATCH v5 07/14] enic: Use irq_update_affinity_hint
Thread-Topic: [PATCH v5 07/14] enic: Use irq_update_affinity_hint
Thread-Index: AQHXfb7sMOBjDjkJHU6TF0PX7txZbKt2ksPA
Date:   Mon, 16 Aug 2021 17:53:25 +0000
Message-ID: <BYAPR11MB3799AA4F4FBB502D22DEB259BAFD9@BYAPR11MB3799.namprd11.prod.outlook.com>
References: <20210720232624.1493424-1-nitesh@redhat.com>
 <20210720232624.1493424-8-nitesh@redhat.com>
In-Reply-To: <20210720232624.1493424-8-nitesh@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=cisco.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6eaeefec-2e1f-420b-7f6f-08d960debf0c
x-ms-traffictypediagnostic: SJ0PR11MB5182:
x-microsoft-antispam-prvs: <SJ0PR11MB51822DBE34773018EEBAA352BAFD9@SJ0PR11MB5182.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7eAPI2gwVdO8h1sVgxQUAIwufFsSZnfNQPUbU/VW7cLM/T3d/VwC5vARRCcCi4aGuZtyMVF3bLgCtloBlR3yq3Z6XQpSY9HF9LAJiSE4xMRKNgtbX/9D83mOQzy4w+8jSLIHGZ+oXHSNdYfrMC4Kyz84RRQXDW4WKOZ/4p5nRgMaTwWI9hLHnyA5P0qlAiBSPIz/s0QQygMClekXk1TrFcEf1Jczv86kyYGN1BJhP4eQEAElroupX1fgHmxK5t99TvPJKIOwGhz3gBFdsRjml4S0f5L9OURK8VpqhCEnhfi/fFPDj8dT/Z85cHQde/13iV+gYjgI9yIMTcRN2O4Bwfjqf8HgHL+biMapb93a5a9NQXs3XMWhgjT+mUiX0HyHBWEKbFZPCq1q+znWPhwTmy8O6/2eIMFq84ODUlQuiVz4C05mYEjvwVd4t8X4d8iXedYC96HO9Xor2BMWXlU0PQo3QwBEl8hQhEEM/1/XkYEY8LUIa9HTGbvpArzvWx1/ligJgQfOjB600RfPgYSmqZE++hTLWub78BnPL39uV5ovjKPuXhPCzWW9guXDH1fy/INPZ00xHPAfbE38EDtBX4KbVigisFxNv4PL0yx6JaBSrN+mzrtbF0I9WXLaOejZ+CNti+h1LtBOeWW3PVJNanJPXCRGagZyfVLcJt1kXXikffNKEZQvsWtIiuY2pniFBdKcO7QdrZVBIBFKHgX5WARhuiA4FtZJDEcvawrFyt4GyNQsREMorGJS+DhS5y70
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3799.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(366004)(136003)(376002)(346002)(396003)(53546011)(6506007)(86362001)(7406005)(33656002)(7696005)(7416002)(7366002)(5660300002)(921005)(8676002)(26005)(83380400001)(1191002)(2906002)(478600001)(8936002)(66556008)(52536014)(64756008)(66446008)(38070700005)(66946007)(9686003)(110136005)(55016002)(122000001)(76116006)(38100700002)(71200400001)(316002)(186003)(66476007)(518174003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OJt/4gTUd3J8fOkTvV4qBBey0PbX8xtRpw6DZAvIetxF5QQLpffrAavYX9kM?=
 =?us-ascii?Q?wbV1gnD22rwgN1N6hkhrf55xyhNC3b5FZ6HT23JYCZSget1d1YcaOr4GWbCs?=
 =?us-ascii?Q?MRxIzexJmiCFJBRRNwVET72uKGXAKM6/1kQwWnwpbsg73xVl85u/mRLIE+dk?=
 =?us-ascii?Q?MGpncMu6ON/nIsTAjE+xBdwl2mXHTrs2OzFKdm8YvdQe87JOFJeeOVV62EDZ?=
 =?us-ascii?Q?2CdobdWjJzD8M6xmj2rY3KRPa/ewGwOhNu2VHbJoSWijrTu7nwacHEWMxBGh?=
 =?us-ascii?Q?hB4BT9NMtSh1KBLDoobuj5Aa6cROt2X2vjviNyYy55/eO2+gYvM1Ti7LHzbi?=
 =?us-ascii?Q?y5KKe2QePytT893YE7AnxhwWFrooxD+5Tvcccjc7FR+FWAc5zcfLyqZqWBHw?=
 =?us-ascii?Q?NCzxdVsvhu5YYv2Ug7kGWsyMHumjqfwtmud3mxpRwiuBOlbUjn6/nNL+MHwZ?=
 =?us-ascii?Q?qjf0EaoBf4NKKOe2GMcWuAHb1dc6NOhjgft8Y3FSyYuBM5T2IG7gMqmMPa0s?=
 =?us-ascii?Q?l+abo2UxjiWnhAJZplowUa3MU1f9WVmjwxnLQOqZqdFE0hBkxEIuweF9z53f?=
 =?us-ascii?Q?SPz71msRiN1AkHhKI+SviLCgPjF4Eg1CtD/ee0P0M12ulfuqJN90Yiunvm9T?=
 =?us-ascii?Q?BR2tSYdmQYDD58GH1/Y5SwRfVXboX5ihqzNiVeEq6nteUXDxFAQgtaEKAnzK?=
 =?us-ascii?Q?ikDcfh3K3zl1gh1sGjOgdwC0SRviUvqyaB21lCPiBO+PFkiazCN+ySFPMyJF?=
 =?us-ascii?Q?XMFotRkEpYO01uvgQXHoMuewaupaAW3gjeZ7ehXdaCd7jq5hVrVNpsAxm52x?=
 =?us-ascii?Q?573iX8i8O60D6XS/27y7MS7hMGGW7fo8JvoRy8wUGXRKwhWYxvGyBeAppjKI?=
 =?us-ascii?Q?Xzj/l4dZKwYONxYFimgVqjMz584+8Sc1a2bZVY5TD2fek9OAZYth37W9sFHt?=
 =?us-ascii?Q?leTNUbpEokkMoIPDIm/GlpOR4nL0zwGxKsvxoMtEfeCibLOhPiGL7lpYczVC?=
 =?us-ascii?Q?CNJs76f695plUp+Fch9hPKcp7MQMotMHs3bBp0+IMbxHStR7Ej3wBANPBa52?=
 =?us-ascii?Q?0xlciGImniMZTP2EIvmY9QPnRfr4DQLwHh23OiYvhCjxDs0ako56JDEp8kYM?=
 =?us-ascii?Q?EY3jG9oZR4cbTLaAyqqJvsXz52GuGOCHgVOGCY/Uw6US1cNvXSHAsy/Vt/fw?=
 =?us-ascii?Q?6801TcLftJtoPJH3ViLFbPFGOY4Zjsnj9Rxh8lRsrw6ZqkgrWrYcmCg61ZUP?=
 =?us-ascii?Q?7neI6h9M7aJxUAldY6GpI9r/L//aWRb3KmnDuvIxa9TDVRhXDRt9F/cEus0T?=
 =?us-ascii?Q?g5IR86tjuwSNMQdIYzPPHrU9?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3799.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6eaeefec-2e1f-420b-7f6f-08d960debf0c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 17:53:25.1390
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CfirkLaELQLMgMTeZU2QOQ8fDrJL+L0in6QWwERi0jg8PdX8DEbw4casYzGwlL9P
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5182
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.36.7.17, xbe-aln-002.cisco.com
X-Outbound-Node: rcdn-core-3.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Nitesh Narayan Lal <nitesh@redhat.com>
> Sent: Tuesday, July 20, 2021 4:26 PM
> To: linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org; intel-wired=
-
> lan@lists.osuosl.org; netdev@vger.kernel.org; linux-api@vger.kernel.org;
> linux-pci@vger.kernel.org; tglx@linutronix.de; jesse.brandeburg@intel.com=
;
> robin.murphy@arm.com; mtosatti@redhat.com; mingo@kernel.org;
> jbrandeb@kernel.org; frederic@kernel.org; juri.lelli@redhat.com;
> abelits@marvell.com; bhelgaas@google.com; rostedt@goodmis.org;
> peterz@infradead.org; davem@davemloft.net; akpm@linux-foundation.org;
> sfr@canb.auug.org.au; stephen@networkplumber.org;
> rppt@linux.vnet.ibm.com; chris.friesen@windriver.com; maz@kernel.org;
> nhorman@tuxdriver.com; pjwaskiewicz@gmail.com;
> sassmann@redhat.com; thenzl@redhat.com;
> kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> shivasharan.srikanteshwara@broadcom.com;
> sathya.prakash@broadcom.com; sreekanth.reddy@broadcom.com;
> suganath-prabu.subramani@broadcom.com; james.smart@broadcom.com;
> dick.kennedy@broadcom.com; jkc@redhat.com; faisal.latif@intel.com;
> shiraz.saleem@intel.com; tariqt@nvidia.com; ahleihel@redhat.com;
> kheib@redhat.com; borisp@nvidia.com; saeedm@nvidia.com; Christian
> Benvenuti (benve) <benve@cisco.com>; govind@gmx.com;
> jassisinghbrar@gmail.com; ajit.khaparde@broadcom.com;
> sriharsha.basavapatna@broadcom.com; somnath.kotur@broadcom.com;
> nilal@redhat.com; tatyana.e.nikolova@intel.com; mustafa.ismail@intel.com;
> ahs3@redhat.com; leonro@nvidia.com; chandrakanth.patil@broadcom.com;
> bjorn.andersson@linaro.org; chunkuang.hu@kernel.org;
> yongqiang.niu@mediatek.com; baolin.wang7@gmail.com;
> poros@redhat.com; minlei@redhat.com; emilne@redhat.com;
> jejb@linux.ibm.com; martin.petersen@oracle.com; _govind@gmx.com;
> kabel@kernel.org; viresh.kumar@linaro.org; Tushar.Khandelwal@arm.com;
> kuba@kernel.org
> Subject: [PATCH v5 07/14] enic: Use irq_update_affinity_hint
>=20
> The driver uses irq_set_affinity_hint() to update the affinity_hint mask =
that
> is consumed by the userspace to distribute the interrupts. However, under
> the hood irq_set_affinity_hint() also applies the provided cpumask (if no=
t
> NULL) as the affinity for the given interrupt which is an undocumented si=
de
> effect.
>=20
> To remove this side effect irq_set_affinity_hint() has been marked as
> deprecated and new interfaces have been introduced. Hence, replace the
> irq_set_affinity_hint() with the new interface irq_update_affinity_hint()=
 that
> only updates the affinity_hint pointer.
>=20
> Signed-off-by: Nitesh Narayan Lal <nitesh@redhat.com>

Thanks Nitesh for the patch.

Reviewed-by: Christian Benvenuti <benve@cisco.com>


