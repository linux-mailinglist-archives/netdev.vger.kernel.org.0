Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29FD34C0751
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 02:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232045AbiBWBqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 20:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiBWBqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 20:46:42 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E454506F2;
        Tue, 22 Feb 2022 17:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645580775; x=1677116775;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=jt6R5BR3VU+yeErnnx906W5WRH9L6ZrLorNxM6L4UOs=;
  b=RghSXviICdLnu6r9buiiTOiMBiY6ny39O0lwyfByqzrTSh0qliB4vl5Y
   ofNt4j+zTuE87B5VtdD7/QQXnzKa5lUdGL2BBuO+rsb3+aIZC4uu+YSYc
   oIRGufyY29103hpGKkaL9xbmlg1+KxZ1bps9bQGq1RkdCRKIzeBCPar38
   csGV3wsvGTiGeKr9dkgO4rBD18fH+1mM7zrOXC8vWdthwbUEurWJkrGp2
   /eJctpKIk7khbUI5Bf85npLdog7uCiZ7X/B9q+ggu7+daqcqBiuypkfoX
   NI+rE2lwn20WGMRgMAqJQyjMhSX3t9Zfvd4w7Wld5xY4DSHl+t94+O6G8
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10266"; a="235369354"
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="235369354"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Feb 2022 17:46:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,389,1635231600"; 
   d="scan'208";a="637236088"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga002.fm.intel.com with ESMTP; 22 Feb 2022 17:46:14 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 22 Feb 2022 17:46:13 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 22 Feb 2022 17:46:13 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 22 Feb 2022 17:46:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MiAf4vqlmtj4VX5Aww40IJEAawxytFHxH2yPqMwlLdSKYKoYaKoGJZXjHqLY+SP4+JCz7/0o0N2gUX3dimC3NOqkntYfX2tyycLhou28S0WGEPBI7L4SWa2tsjMDYyzRBxkLbewrK0gUQ8/obabCtjI0Hnw+RTie5nXoShzYB4/OqTO82CofYsmcQsKqyDk2bo81h1s3WB/eybNvSPXagU68kI0T0zEZw0L/syr8aqud0wRfXn9hlpo0zhv/8fzsdWA2E+fTvaxP6YjoxFJUvalAPRETR5WZTKi3AVArerobrHe/lIKOEBbSAcxJ/bpRR9P75+UspK3/HlOWa+XDRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jt6R5BR3VU+yeErnnx906W5WRH9L6ZrLorNxM6L4UOs=;
 b=cF8zEhNhl8NZCU1wQ5Yg87PEtzzq7jCKSG7plDpP2o0TAC+VY1x+WRtkEvCKHjahROTs76ZxTHZBzSAe+lqyryel6LS92xrhHyi9cBJTlol6I9dzqTejTJfR+rPoMPlM2v5JUtrimGmogX51YBe9b7HbsUn8qyRBIk1v1uwzP7qXdGekNfywicNYR2Y4YPvB066yhrRqWI2mM7/mgii0NA/FGJED/de5Mkpj+L+2h53f3YJzJon/XFaBFLBFE9pKkstGl500hK0Q92v5d9w8GP8QTOJgrMnjmqD7DP4xCr/FicwA2iGuEF4QfNi+pf8kZs/JLzfYXr20xod0FmzVCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR1101MB2203.namprd11.prod.outlook.com (2603:10b6:4:52::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Wed, 23 Feb
 2022 01:46:06 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%3]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 01:46:06 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH V7 mlx5-next 15/15] vfio: Extend the device migration
 protocol with PRE_COPY
Thread-Topic: [PATCH V7 mlx5-next 15/15] vfio: Extend the device migration
 protocol with PRE_COPY
Thread-Index: AQHYHEeP9+yi67MoOESanaHY+teTS6yY7QGggAB71QCABXaE4IAA7/8AgACRoKCAAAOCAIAAAeqg
Date:   Wed, 23 Feb 2022 01:46:06 +0000
Message-ID: <BN9PR11MB5276B8C8AA760FC52B33CD328C3C9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-16-yishaih@nvidia.com>
 <BN9PR11MB527683AAB1D4CA76EB16ACF68C379@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220218140618.GO4160@nvidia.com>
 <BN9PR11MB5276C05DBC8C5E79154891B08C3B9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220222155046.GC10061@nvidia.com>
 <BN9PR11MB5276DF4B49F7D57E81675C068C3C9@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220223004432.GH10061@nvidia.com>
In-Reply-To: <20220223004432.GH10061@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c037778d-182d-4386-1afb-08d9f66e4232
x-ms-traffictypediagnostic: DM5PR1101MB2203:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR1101MB22035D721A2FE3C6218553D18C3C9@DM5PR1101MB2203.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8+6Y+qxcELrRKvpyff2YZ42j2NU284fJR/FjTYFDHnT82SqMs4D9Oeg6olT7cRTBMT6RB8qwKHWgNTVeupNU3dT6og+KbxEzVM9cv49cOhBwNaLACws1a2CTcAfmi/JyjxKka6U14KN2LVRUm6UORGpUMFS8wGNsO0WWMISbdWYPHTnTBIItpGcHfAJx2KhPlHSCNltpFMw4L6yTlrseQq1j536WmmqtlgP573xxctLjRgrpIpTOl07j6Fj/7hOmkZo6ssEfGD+Boi1TNN3Edw01CKUQ2Zbu+v/0fBrmSdPhR6sPkQUrUrKF8uk+7k9Y65gYPBQdlbYU0e/ATkKfoDm1OT/CCk6sqzsqNf+ASnmptG4Pkx9ph365nN2fP8XUM7VbWjLUU6Gv0uWog/dI0dM7lo1YuZqVpRAHtyTE2xnm+APuMTXOkBFteKVE0XVBwtzUWvUAnzWXNJjKK2EVi1wqZSKFT//B+XAXp19JeMHWjy0Z/0CC4/hn+2LnkfnErI0gmbXmXAO1Zvlhf89q2p3MEh7FL6YaGPJbhrckriANxuccJBNak/O4d52gBaGWOWUM5eD5DQp6Ug6XQ5IzUsY+zO9TfQmi6Sy/1HIoXp7Vzf0zwTkRSudpAr8rwyC0CR8Xn2wXMKoCSTc/B44Ocicp6yLWvhJ6Nig6hJpA3djufN5IVma44c7UFgqCbWmXJ5GhNYz3/gIvivGoYlxw6A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(508600001)(33656002)(316002)(76116006)(8676002)(4326008)(64756008)(55016003)(66476007)(66946007)(7416002)(5660300002)(7696005)(6506007)(66446008)(9686003)(71200400001)(66556008)(26005)(186003)(82960400001)(38100700002)(86362001)(122000001)(52536014)(8936002)(38070700005)(54906003)(6916009)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?RTlvUy84eHI0ZDlCcEhRdVBmc2xCcUFVN0lmNFZMNUdvYzQrc1VuTW5vUnZM?=
 =?utf-8?B?VmMzOHFzNlhZUGJqTUxkRHVtTzZtalYyd0ZkakxUVUhkblp5eDIwK3ZLa0kv?=
 =?utf-8?B?TWswdXcwN2lPV3RLOTEyKzcxd0kyRkFYcmJCbm50bGtvVi90bWxpV25LR2tV?=
 =?utf-8?B?WGRTNUVRYkl5WWxIdnhVRHZ6bDlLZFdjeDd0bVFpNU1rRlI2dXluRlFLRWlJ?=
 =?utf-8?B?RnhzZmZ1UGZ1RjZUMG9ieE1SbnlnNUFGN0ZFSDg2Ti9BT0w5QUY2MGhNZDZ2?=
 =?utf-8?B?ZXdwQW9XczJCNHpqQUhLb2cvb1d0aGhLdHFWSVdXNWJvUWpkWUd1S3BKbGFX?=
 =?utf-8?B?OVN3Nm4rcTQxKzZaSXdmdmZoRk5FRVVoVU5ENzBYeklsWTNiUGcydTg1QzdX?=
 =?utf-8?B?WXhXaHdPeUJnTXB3V1YxeitVdVRmdXBOU0c0Q1hRWGRJVzdCSU53dHJNOXpU?=
 =?utf-8?B?L21kZm4wTXJNaHFuRWwwWDVVc1c4NjBCZXVWVURrbU9TeFlCT0g5TFhXVTkw?=
 =?utf-8?B?Y0tQaXBFOEJGdnQvcU04anFrTTFNWllZSGx3MDR5aWU3RWhBNmR1YlV3Qmx1?=
 =?utf-8?B?eXl6U2huT2hNMFp6OVNpWG9KTTU1L3N4OEtpenBaTE1RY3hvc2pLN1dEYXc0?=
 =?utf-8?B?by84OThoWDVPNktWdUlQNndqV1d0MHpvTm9lV3pIbDhXVXRMMEtnbXVBYmRT?=
 =?utf-8?B?UVJ3WFBFZitrUy8zU2s2OFMyU3Q2Ny9na0h4S1hXeWpJS0NpaUc4WkJ4S2Vj?=
 =?utf-8?B?eWJldkdaSzFGUWdxeDg2OFVvMkgvUllQcTNGMm0ydmRIRXZvU053K203aktF?=
 =?utf-8?B?Y3NpUElxZnJXT2p2d3loZTRBNGpvSEdlamExajdKbnZSSTZSbFhrNElpUDBs?=
 =?utf-8?B?TGd6dXRTUEdQRWozb3pUK2pIdXRSUFBLR0laS0Z4czhiNzRyS2FubGNvbXBo?=
 =?utf-8?B?Tm1KYjdvN25pK1FmYy8xY1MwK0tMaTFFYUJaczFtMEZGcDRhTXBEQUVyd3NM?=
 =?utf-8?B?bDRSUzFxcXNVczZrYVFHUUV3VTV4RkY1aitOQU9aYjE4SEJob2FaalRqamRi?=
 =?utf-8?B?SiswUFM3N09rRldSajlpV0poNU8xc3lCRTJiYnd1SW9UUWZqaGd4YlpQSS96?=
 =?utf-8?B?akZLS3VXdjBSREpFRmdLZGk3eWJQQmp0TytQZGRVbEY5b3orMitBWnRMTFFO?=
 =?utf-8?B?dHdDaHFXRTVYMjVRYjhGNmtoNWo5TkluUFdqY1RZaUZJVGVyamVVRTNlaVJN?=
 =?utf-8?B?cE14Y1dWcHVCZVhwRkxPQ1BtWmJ2d0hqYTdvRjZBZVlYNmRMQndCYzFMVEgw?=
 =?utf-8?B?T0dLa202NkZPbGZiVWxwemhRS0NnUWN1V1FlUWRNU082UlQzQWlGWVhJN3lk?=
 =?utf-8?B?WTBnZVdRQkVSbVRnYm9GYzlyUE9JYXR3ZXlBcEVYWTdnQ2FPNUMrV2hiWTNZ?=
 =?utf-8?B?WFhPbTkwbmQxZjREL3EzZHpFR04va01wTkdKVHo1S3RtRlhHdWJ3ZjRJTmpu?=
 =?utf-8?B?aHZtZDdmUjY2UmpxZWpSR0JnN2pscXhzNUJlS0lyVjFrQStpZTRoU25ZazZ1?=
 =?utf-8?B?Z25jS0QvalZFNXBjTUxTNmtXbzlMVnVidlR4ZGhYdXYwSkx3Tlp5cFRrd2tn?=
 =?utf-8?B?WUZ0aUtxcnR4Z1o4N3BlSVlCNkxkaDhPUmVoeERJSEwydjBWK3BPVXV0SS9o?=
 =?utf-8?B?MjhESGFHcTNaNTZEMzZEcmZCVnZZR1BsRDlseU9LekFXbENnL0ptN29DRjBo?=
 =?utf-8?B?VjdDaVhTUWZoZHFhbGMxb2JHM0tvZzNsdXhRenFtbWpCa1Q0dTlqampSZHVC?=
 =?utf-8?B?TGg4dEw0aG1oUGRRVzE5WmRUTVRYS0hRTG1xZHZlcC9DWUFqQlU4SmhjeXg3?=
 =?utf-8?B?TFpzc3FSazdFTmR4Q0JSaDV1Sk1DeG5vL2FVT2tDSi94WWtMV1lCVmtsVDkr?=
 =?utf-8?B?QkY2R1ZHZUV0Uk03RkVJaTR5bGFNQjl3Z2gyV2x0TUF1aTIwa3F1eUdXb2Q2?=
 =?utf-8?B?NjNlMm5pWVhsb0VqdlJQZy9WTXFqM0dVcDVPSXJVNk9aZW5ZSDI5a0dKSnRh?=
 =?utf-8?B?VDZ3MjNqKzkwdW9FTW9iYUFIcmF2YW0yb250T1c4Zy9laFpSWXQ3b2Y1N3Jn?=
 =?utf-8?B?Nkw2RXB4aGdqTHRhOXhsOERpeFZ3amlIMzZ5Z3NDKy8wVU1VaE41NW5iTzZK?=
 =?utf-8?Q?l5q3AYsQ2rw6Q07JgOMLZP0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c037778d-182d-4386-1afb-08d9f66e4232
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2022 01:46:06.6270
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 83Cjqeiq3ouMR5+u0pBzFEQJBUL6oLlWVl6l1qVHiPyeHkg5yUGWOzjZxEUNALSElQ2CQYFPA7QvdO0RJNjOyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1101MB2203
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBKYXNvbiBHdW50aG9ycGUgPGpnZ0BudmlkaWEuY29tPg0KPiBTZW50OiBXZWRuZXNk
YXksIEZlYnJ1YXJ5IDIzLCAyMDIyIDg6NDUgQU0NCj4gDQo+IE9uIFdlZCwgRmViIDIzLCAyMDIy
IGF0IDEyOjQwOjU4QU0gKzAwMDAsIFRpYW4sIEtldmluIHdyb3RlOg0KPiA+ID4gRnJvbTogSmFz
b24gR3VudGhvcnBlIDxqZ2dAbnZpZGlhLmNvbT4NCj4gPiA+IFNlbnQ6IFR1ZXNkYXksIEZlYnJ1
YXJ5IDIyLCAyMDIyIDExOjUxIFBNDQo+ID4gPg0KPiA+ID4gT24gVHVlLCBGZWIgMjIsIDIwMjIg
YXQgMDE6NDM6MTNBTSArMDAwMCwgVGlhbiwgS2V2aW4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gPiA+
ID4gPiArICogRHJpdmVycyBzaG91bGQgYXR0ZW1wdCB0byByZXR1cm4gZXN0aW1hdGVzIHNvIHRo
YXQgaW5pdGlhbF9ieXRlcw0KPiArDQo+ID4gPiA+ID4gPiA+ICsgKiBkaXJ0eV9ieXRlcyBtYXRj
aGVzIHRoZSBhbW91bnQgb2YgZGF0YSBhbiBpbW1lZGlhdGUNCj4gdHJhbnNpdGlvbg0KPiA+ID4g
dG8NCj4gPiA+ID4gPiA+ID4gU1RPUF9DT1BZDQo+ID4gPiA+ID4gPiA+ICsgKiB3aWxsIHJlcXVp
cmUgdG8gYmUgc3RyZWFtZWQuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gSSBkaWRuJ3QgdW5k
ZXJzdGFuZCB0aGlzIHJlcXVpcmVtZW50LiBJbiBhbiBpbW1lZGlhdGUgdHJhbnNpdGlvbiB0bw0K
PiA+ID4gPiA+ID4gU1RPUF9DT1BZIEkgZXhwZWN0IHRoZSBhbW91bnQgb2YgZGF0YSBjb3ZlcnMg
dGhlIGVudGlyZSBkZXZpY2UNCj4gPiA+ID4gPiA+IHN0YXRlLCBpLmUuIGluaXRpYWxfYnl0ZXMu
IGRpcnR5X2J5dGVzIGFyZSBkeW5hbWljIGFuZCBpdGVyYXRpdmVseQ0KPiByZXR1cm5lZA0KPiA+
ID4gPiA+ID4gdGhlbiB3aHkgd2UgbmVlZCBzZXQgc29tZSBleHBlY3RhdGlvbiBvbiB0aGUgc3Vt
IG9mDQo+ID4gPiA+ID4gPiBpbml0aWFsK3JvdW5kMV9kaXR5K3JvdW5kMl9kaXJ0eSsuLi4NCj4g
PiA+ID4gPg0KPiA+ID4gPiA+ICJ3aWxsIHJlcXVpcmUgdG8gYmUgc3RyZWFtZWQiIG1lYW5zIGFk
ZGl0aW9uYWwgZGF0YSBmcm9tIHRoaXMgcG9pbnQNCj4gPiA+ID4gPiBmb3J3YXJkLCBub3QgaW5j
bHVkaW5nIGFueXRoaW5nIGFscmVhZHkgc2VudC4NCj4gPiA+ID4gPg0KPiA+ID4gPiA+IEl0IHR1
cm5zIGludG8gdGhlIGVzdGltYXRlIG9mIGhvdyBsb25nIFNUT1BfQ09QWSB3aWxsIHRha2UuDQo+
ID4gPiA+DQo+ID4gPiA+IEkgc3RpbGwgZGlkbid0IGdldCB0aGUgJ21hdGNoJyBwYXJ0LiBXaHkg
c2hvdWxkIHRoZSBhbW91bnQgb2YgZGF0YSB3aGljaA0KPiA+ID4gPiBoYXMgYWxyZWFkeSBiZWVu
IHNlbnQgbWF0Y2ggdGhlIGFkZGl0aW9uYWwgZGF0YSB0byBiZSBzZW50IGluDQo+IFNUT1BfQ09Q
WT8NCj4gPiA+DQo+ID4gPiBOb25lIG9mIGl0IGlzICdhbHJlYWR5IGJlZW4gc2VudCcgdGhlIHJl
dHVybiB2YWx1ZXMgYXJlIGFsd2F5cyAnc3RpbGwNCj4gPiA+IHRvIGJlIHNlbnQnDQo+ID4gPg0K
PiA+DQo+ID4gUmVyZWFkIHRoZSBkZXNjcmlwdGlvbjoNCj4gPg0KPiA+ICsgKiBEcml2ZXJzIHNo
b3VsZCBhdHRlbXB0IHRvIHJldHVybiBlc3RpbWF0ZXMgc28gdGhhdCBpbml0aWFsX2J5dGVzICsN
Cj4gPiArICogZGlydHlfYnl0ZXMgbWF0Y2hlcyB0aGUgYW1vdW50IG9mIGRhdGEgYW4gaW1tZWRp
YXRlIHRyYW5zaXRpb24gdG8NCj4gU1RPUF9DT1BZDQo+ID4gKyAqIHdpbGwgcmVxdWlyZSB0byBi
ZSBzdHJlYW1lZC4NCj4gPg0KPiA+IEkgZ3Vlc3MgeW91IGludGVuZGVkIHRvIG1lYW4gdGhhdCB3
aGVuIEVJVEhFUiBpbml0aWFsX2J5dGVzIE9SDQo+ID4gZGlydHlfYnl0ZXMgaXMgcmVhZCB0aGUg
cmV0dXJuZWQgdmFsdWUgc2hvdWxkIG1hdGNoIHRoZSBhbW91bnQNCj4gPiBvZiBkYXRhIGFzIGRl
c2NyaWJlZCBhYm92ZS4gSXQgaXMgIisiIHdoaWNoIGNvbmZ1c2VkIG1lIHRvIHRoaW5rDQo+ID4g
aXQgYXMgYSBzdW0gb2YgYm90aCBudW1iZXJzLi4uDQo+IA0KPiBJdCBpcyB0aGUgc3VtDQo+IA0K
PiBpbml0aWFsX2J5dGVzIGRlY2xpbmVzIGFzIHRoZSBkYXRhIGlzIHRyYW5zZmVycmVkLiBPbmNl
IGV2ZXJ5dGhpbmcgaXMNCj4gcmVhZCBvdXQgdGhlIHN1bSB3aWxsIGJlIDAuDQo+IA0KDQpUaGF0
IGlzIHRoZSBwb2ludCB3aGljaCBJIG92ZXJsb29rZWQgKHdpdGggdGhlIGltcHJlc3Npb24gdGhh
dCBpbml0aWFsX2J5dGVzDQppcyBzdGF0aWMpLiBBcyBleHBsYWluZWQgaW4gdGhlIGNvZGUgY29t
bWVudCAnaW5pdGlhbCcgaGVyZSBtZWFucyB0aGUNCmluaXRpYWwgcGhhc2Ugb2YgcHJlY29weSBp
bnN0ZWFkIG9mIGEgc3RhdGljIG51bWJlciBmb3IgdGhlIGVudGlyZSANCmRldmljZSBzdGF0ZS4g
RHVyaW5nIHRoZSBpbml0aWFsIHByZWNvcHkgcGhhc2UgZGlydHlfYnl0ZXMgc2hvdWxkIG5vdA0K
Y291bnQgYW55IHN0YXRlIHdoaWNoIGhhc24ndCBiZWVuIHRyYW5zbWl0dGVkIHRoZW4gdGhlIHN1
bSBvZiBib3RoDQpudW1iZXJzIGNhbiByZWZsZWN0IHRoZSBhY2N1cmF0ZSBzaXplIG9mIHJlbWFp
bmluZyBieXRlcyB0byBiZQ0KdHJhbnNtaXR0ZWQuIE9uY2UgaW5pdGlhbCBwaGFzZSBpcyBjb21w
bGV0ZWQgaW5pdGlhbF9ieXRlcyBpcyBhbHdheXMgDQpaRVJPIHRoZW4gZGlydHlfYnl0ZXMgYWxv
bmUgcmVwcmVzZW50cyB0aGUgcmVtYWluaW5nIGJ5dGVzLiDwn5iKDQoNClRoYW5rcw0KS2V2aW4N
Cg==
