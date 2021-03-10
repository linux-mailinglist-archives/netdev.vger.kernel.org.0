Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D47573332CB
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 02:35:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231335AbhCJBe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 20:34:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:3158 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231703AbhCJBef (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 20:34:35 -0500
IronPort-SDR: X/ROgY2dMGcGVHs1x4vvxqRPBb5DQJQ9obejMWSBe3yB+MId8lSmmjRtrito63fYNbyUqmbRj7
 dLLOYUw5n5cA==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188461025"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="188461025"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 17:34:33 -0800
IronPort-SDR: yGTL0tVAa1z9TkcLUeRGjqXlTtinQFDkJTlZ8D3zOVDhxWcbyJMu0fdME/LbUc+OfzexRavkTc
 JlYJ8DjDwEjg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="scan'208";a="369987010"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 09 Mar 2021 17:34:33 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 17:34:33 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 17:34:32 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 9 Mar 2021 17:34:32 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 9 Mar 2021 17:34:32 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b7ZhY8bV8JmkIfg2THQggKlbTSq5o4XgeK3TQ/gsPuBXK4UAs+nwPU0EDKdAaVrM8CJnnqkqRTTGIOqePY9yg4k5KGLW+ptCR+YQec3aD4C8blV4DOctYSUoIGlu9kpiZAL5AncLMKiWr/8n7zqFUvjQlj9+Wz/du/i9n07n9Xpyn6LiUYYvelgfMXEgkb8n0lqxfc8FFEiRVR3depDrM3whtcqINX+MaiqDlzXnx79vt0kG+eww3oazcZ5hiaMiPg86V/sFakort83H4KQW3hnM9pFFQKn7gYGQwai0pDfdxbnatF2X8ykHFxO6oM+l2xHv7zrePbxPHdjw3KqB6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmbToCkwZJXEG7oXzNpcUj9AzHQLHqQOselFLHg/HsI=;
 b=QIQ40Na+rUvBeTIlZBgn6RD0Ek0/jvXg37hGLRdMx3er954QrObhTkTyTwQHsatjy3gLNTGDfTnhCUM/EKaCd9c00dXiWuLdYn4lt1pTEJNKRBODk8X6GMoLd8TIyl09NMR7Orqpju12VuhrC6i0zRzlx9IEVI9Hsd2u/haTtNVWMvj++yvD4wqnkB7MO8qmfJg1YqV+OutAWhxmpRlWNwY2+xLvpCkgef+mgbv3dhqOGM8cAfUVORwYw1+eGgN2JW5ucUlsUWF/TxRm8f99/AN1FnzGeEPCLRS9N6nvXhvBoh09asClo8eh5Dxe4IxEm+oibj5kk5DfxhfS+cjnXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmbToCkwZJXEG7oXzNpcUj9AzHQLHqQOselFLHg/HsI=;
 b=rfeNHsyxzZpIviHxu4uEmJUjM8FrcezHRhNYp5Wb0WYVB9OWyolodLH1Dhb3EC0f+v6mq/+8bsOxfYSLOcMhJkSKW1FzD1Wl8jIaLFD5fkpyvEwZtQZMz332Ri7dS8hxzDp/tVZNlKoXza3OV8D0zxyflGra9pTvxOxdVT1kTEk=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by BYAPR11MB3366.namprd11.prod.outlook.com (2603:10b6:a03:7f::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17; Wed, 10 Mar
 2021 01:34:30 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3890.035; Wed, 10 Mar 2021
 01:34:30 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: RE: [PATCH v10 04/20] dlb: add device ioctl layer and first three
 ioctls
Thread-Topic: [PATCH v10 04/20] dlb: add device ioctl layer and first three
 ioctls
Thread-Index: AQHW/9Z0NWmw8oaockWkEmkQNRyDvap7jMWAgAEKE2A=
Date:   Wed, 10 Mar 2021 01:34:30 +0000
Message-ID: <BYAPR11MB3095E9D74CCBC85704EA3AECD9919@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <20210210175423.1873-5-mike.ximing.chen@intel.com>
 <YEc/KwOPzvnozaV4@kroah.com>
In-Reply-To: <YEc/KwOPzvnozaV4@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: linuxfoundation.org; dkim=none (message not signed)
 header.d=none;linuxfoundation.org; dmarc=none action=none
 header.from=intel.com;
x-originating-ip: [69.141.163.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0460c574-9d75-4f73-5b45-08d8e364a670
x-ms-traffictypediagnostic: BYAPR11MB3366:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB336656BE5B51BC7DE18C760DD9919@BYAPR11MB3366.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bZPRm3LQ8sHrI+WakfTXIiMfna2zrjUwsvl+XNrERKXiPEtwe45W/VFpgZbvKdmGeIlczoJ/6wFHnSiI3fJjE8E2tCD6d0beC8ZC/S0tnwo//xUaL9JkISk9xlQSmaXWAK5NY0iktNvu00Pf5zBLwO6btadWn7aE6w4oO1okZAp136y3NhPaZverJs1eHCL7nyiU9UpxiXP2egeVcQquRav7K40XVFDvhoGMs2N6f/SfWPXk04wy/EBwl3nH42BVhV3QVndDxE5ZyxG1cVlzKJfPgVe0rvm6KYo2CWeNUv3UspzityFG6rQxaQFAvlJlUl6a/wxmjr6eGwqyA6F6k7QUIJcXsVSatq5s9lYEX1KQbFnZ7qa6f6Dpv91TLJ+R88MDuZsGqDHspG0LJGwP0+hFiP5mUTkxuXfvEh8O1iZK38OzUjtWaCti0rqiDShSMLEl27ETARIxpNwhPB/pDlaAK8SxXmZsaK+YPxHCpW61dzwVEpwOaGVNTscFevpLBPCbFKA98W1QETwq09Dvag==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(376002)(396003)(39860400002)(346002)(6916009)(86362001)(2906002)(9686003)(66446008)(83380400001)(66946007)(186003)(52536014)(64756008)(33656002)(4326008)(66476007)(26005)(478600001)(5660300002)(76116006)(8676002)(71200400001)(8936002)(7696005)(55016002)(66556008)(316002)(54906003)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Iu9AqJdhkHevdrBBT1T7LQ/tRNr7SNP7WtNQaaVxRjs6Zv1fzA27m9qDRuww?=
 =?us-ascii?Q?9agrBKu8DplLtBYh8kVeg5mqqH11UhD+0AOcvkLYvlHMPDPdRus84y0y4vJ+?=
 =?us-ascii?Q?DQq+TrcyYJEQm+Zi6vDT5halnK+cEKpbxRLTIqWwmDUISRxmzgzO7iThbvlL?=
 =?us-ascii?Q?A8cuZ7G5tXO6hzXjwBk3tzN3LQxdPTEtUHUqfbT4TnPFsEzJLZG+7SfTWvOe?=
 =?us-ascii?Q?rHYexRoSbpWnHjHkvaviBLhXV4cMLTkigbMpVavBNH4ePOjLmkMYHAF56CuP?=
 =?us-ascii?Q?6aVsagT8o8GD+JCrCS2MCqZ8vvfPvf2sPJa+khmWFh/xXe4njH8rQcwB5zCb?=
 =?us-ascii?Q?UES1FygRg5PlzxELrMza0tNkPGDjWLyeA6CiBTg2aDC/AUFdPRki9QnUZeVx?=
 =?us-ascii?Q?YgttbOmIzgmA59QGOumoATcDs3fCXLvDpjwqRTS2E8vGjcawegbV+x5F57+v?=
 =?us-ascii?Q?+YGFg9/hLsxSFkd4d2Ymp2J+izGb+q6EK2Cw/akGkAwLSye7dEFHLTGPrKJJ?=
 =?us-ascii?Q?feXw693Ko6/62NRkyRKwWY32m/raGrUqkd1CjFiFZ82OhYB5Ip1426BlL3nJ?=
 =?us-ascii?Q?okN+iwR4j31sQNIjHCruCg0EBeleZp0l2Y+MMO2lv+/m+jPGBoZbU10/Ty0h?=
 =?us-ascii?Q?Dsa/TalwRDwYDK2Ne3QGL5Td1bbAlgrGjqNGjtQa1sv4a8ude7Hpjcd6yKgR?=
 =?us-ascii?Q?dTVsiEHFilrmR6N2FcxBOQPt59bTr2K/WZLS9XvLHhjzNahYKz7XvBsB3RMd?=
 =?us-ascii?Q?Fwl0wyRXBfo3ulX9tmjhmKF11LbtCjo6/n27r1Fni4O98kXDIi7hFsuu92/U?=
 =?us-ascii?Q?MtwpUzLPqONWgx/q1K5QSnyDcPEIs2wz7UVIvxoQuXa4KuIZYpI7IpX10h8K?=
 =?us-ascii?Q?W8gdXGpxMg+j1aYsXnDgtmBK5otBBJznK3o+Zzk8rqCDkj7djAd/kmpt6JFP?=
 =?us-ascii?Q?XzFq/+vmhUh1NOhpfKSrDoJjuXvoz9gJpzxf52rtn6MkUY5tvlQRkoLN5bSh?=
 =?us-ascii?Q?LNkFq+2F+i18exxR6LGigi3InTTiYvhm3iWYz2nCtMtaQpkbEXH38+/qKCWc?=
 =?us-ascii?Q?OgrqUXEG70h7Eri4p1JybIX9WPgF8SlrsNCsiPQJtfM/Q3uHOWVXTF8spYOA?=
 =?us-ascii?Q?Q70Kpj00TuEbsykHBAuT5EQyLssiV2+sIkZppXUo+mdWs2CZCR1FRx8bt+UW?=
 =?us-ascii?Q?ZlusVaiMHivUFc2gpxuPJySMFmPdLDsJaaF+abkzg14YeQ4RC47HKm4qiKSZ?=
 =?us-ascii?Q?6wenfrCcuibBYVQMBHqXXeIOHW+MZWuoePDk1dhxgSi9OaPBwGRy7SOPgmQx?=
 =?us-ascii?Q?rKuNGE46tW5LHknQTehTlEue?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0460c574-9d75-4f73-5b45-08d8e364a670
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2021 01:34:30.0661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: esTR/gv0iI+wWegj3UGgDv7865xvjZhHmz0ZO8chnoVja41dF+9TeD59GZgsYHOUeWPzhaKXzI+LyTVy28KDEdOliREoF1CCK1XAu4B7rkU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3366
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Greg KH <gregkh@linuxfoundation.org>
> On Wed, Feb 10, 2021 at 11:54:07AM -0600, Mike Ximing Chen wrote:
> > +/*
> > + * DLB_CMD_CREATE_SCHED_DOMAIN: Create a DLB 2.0 scheduling domain and
> reserve
> > + *	its hardware resources. This command returns the newly created doma=
in
> > + *	ID and a file descriptor for accessing the domain.
> > + *
> > + * Output parameters:
> > + * @response.status: Detailed error code. In certain cases, such as if=
 the
> > + *	ioctl request arg is invalid, the driver won't set status.
> > + * @response.id: domain ID.
> > + * @domain_fd: file descriptor for performing the domain's ioctl opera=
tions
> > + * @padding0: Reserved for future use.
>=20
> For all of your paddingX fields, you MUST check that they are set to 0
> by userspace now, otherwise they will never be able to actually be used
> in the future.
>=20
> But why do you need them at all anyway?  If something needs to be
> changed in the future, just add a new ioctl, don't modify something that
> is already working.  Are you _SURE_ you need this type of functionality?
>=20
OK, we don't need the padding fields then, and will remove them.

Thanks
Mike
