Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B66A5A2F11
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 20:47:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345150AbiHZSqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 14:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345356AbiHZSpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 14:45:41 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04AAAF14E3;
        Fri, 26 Aug 2022 11:42:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661539325; x=1693075325;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FNKEaMGjPOgw+IFAsI6AZlqnnKNSVVcelpucaEvdLhA=;
  b=VDcI2oDX9yCS9NcD230/AAC8vdpgiTKAw3xq6DZ7MGd0aebcyev+qqbH
   mMgIPcpsPwIvODkjrJKV1/oQN13VDKw+qRJGKrPVbqjiCd7uV1MIiNUAb
   VQzGGfdXnZ/jZzZj1N/CSh3o06WMSYAsnb9MKedVxNMo5BpvmPomsFsUB
   mQmsH/Trleid9tzb5mUKVWHa177Ow+avvFmQrxztIyZ2RgGg9gtM3e8nU
   itQM15HwHJwBQRF3GwfsrCypNbw9K+46y9vD6isCGuDg6THs/k08t7Fx+
   r5f9xxfOTYRPz1oza6uA1Tii89ACILMFx/mEtmufTfX+IZVi9UoD2sc9F
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="295349782"
X-IronPort-AV: E=Sophos;i="5.93,266,1654585200"; 
   d="scan'208";a="295349782"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 11:41:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,266,1654585200"; 
   d="scan'208";a="678955429"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 26 Aug 2022 11:41:49 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 26 Aug 2022 11:41:49 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 26 Aug 2022 11:41:49 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.172)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 26 Aug 2022 11:41:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KFsqH/BZ8K5i2+1wYFlz4nMlnpmK4cswnc7OQp2cVsTU9KQS/7/bcrE9vjMQoXAqLhinZojKLa7rCMv8GIn1M3vTrSAtNB7SjvyvR4kYMZGYQISNw7g1tWVwAh8kooJ4VlYL/9SnisiLIiJpwJ2lBEik50Q0yeP5gTHt8oFWhpla/WF5hSDlJoYZn7+w1aKrigSheg4k8sevqveVAFqTSrghBAMzdTscgdMA/WGSc9uYYS9C7LN7MC3yCzVBGTkCredez+Y2auD1++b/bV1hWsmZx7zC0QwUmi/YOwC/UwX6otDT7pG1+EC9JFLLHLjpn18nxOreQ5821Lv+NL63aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AlG8VdD2AMGI+GRg2qhIGzkr010jT6xSbCHcjiY4PIQ=;
 b=UhZR9NBysGKeYsLOPMd8muJaQy8/PalvPNcSzlqwLJeupav+e7ErjcMhJZl9ZXXBbm6LQ9vPNQCgfqde/tZaZZagljCXjVsinMvPyPxnVR8W378ZzLwVGNddDsn5DobS2ydWDXJEDZZlqbHAYLGU51ZJojWowpg9L9qh8QV9eXvBVnZyodISySREk+PzJXsba/cV4cjjHA+y59JX+sglTQZ0n4I4boGFykgkz9TWsDtRIj75GYvV0tK4cPc3MeyN/V7iYJvOzY1aA2kYgdlkmzUhp1yzyBK1+MDKDrebpWU+Y0Fv728LUZyd1Yg1NxT0/WaNFYqFGbVUpW02A18Xaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3113.namprd11.prod.outlook.com (2603:10b6:5:69::19) by
 MWHPR11MB1294.namprd11.prod.outlook.com (2603:10b6:300:2a::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.18; Fri, 26 Aug 2022 18:41:47 +0000
Received: from DM6PR11MB3113.namprd11.prod.outlook.com
 ([fe80::7100:8281:521b:ff31]) by DM6PR11MB3113.namprd11.prod.outlook.com
 ([fe80::7100:8281:521b:ff31%5]) with mapi id 15.20.5566.016; Fri, 26 Aug 2022
 18:41:47 +0000
From:   "Laba, SlawomirX" <slawomirx.laba@intel.com>
To:     Alex Williamson <alex.williamson@redhat.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: RE: BUG: Virtual machine fails to start on 6.0-rc2
Thread-Topic: BUG: Virtual machine fails to start on 6.0-rc2
Thread-Index: Adi42gn6sxbvtLg7QcKy/nSIRHLahAABeEuAACbMSNA=
Date:   Fri, 26 Aug 2022 18:41:47 +0000
Message-ID: <DM6PR11MB311348977F72639F5345335C87759@DM6PR11MB3113.namprd11.prod.outlook.com>
References: <DM6PR11MB3113DF6EC61D0AB73F3A2FE387729@DM6PR11MB3113.namprd11.prod.outlook.com>
 <20220825180807.020471c8.alex.williamson@redhat.com>
In-Reply-To: <20220825180807.020471c8.alex.williamson@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6675dd46-d657-40c7-b9da-08da8792a1ad
x-ms-traffictypediagnostic: MWHPR11MB1294:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4IIjFNA+HrkFjd8GoJ2QkirXzxcUbhWaynIEokYmvNF2wZJb8g7jvo+pgClr3jDDn37cHHSZgI4tbXPo65M8uWM1MO7oy8pyY0PgE7P7FuVuq2yVCGPykq0sAlSTCjlLtZDX9KnErsd4oruMnhOR3zPBeeFsm8d6T0gnTqophTEpykGCC1/Rt+wZMRf8K9i+IdQHzahlH6YAYGTu7DZ+39uufPGZ4RJX5hplm3WWKv4us2d+PMdreuxfiqMRCvos+OxJ7tn72E7leYKZ7fzwgpo0h9eIWe9qM44fF6u2alFR9jf9Xpkasq3UpM1AHtfOakZbAqXSFmkzL1rdWv7RaczQYbRNjYk5Fl0luec1+FBdYn/EdpK2Zo34zJIYpTWRmqeczydjeY8zktLpAAwq7frQVFQhBfDyVz2/CqFWvFD+akLuPINSjIDg/C1UaiUYuXTqWu82+cDYZai1KHz6L3nNUul0adfSTNQAbtgHQGJgSlPQ+Ewx8F4eXCVakMVWLC/0lj9aqpsSoP6UXSNwcPLrE1n5rPipZ4CVyZDa7pDpyWp37185QtoePUdM9PEfES0mpf+jzGu2zSvNUbxVozpz659f8IN/72UI5A+cmu+/sB3XJNlxjtxM/u46xGSCNLxFw+K3gnd52ujyeU/jtAgptthBRl9BkYLvCfvfL9jrdVZNldXqkEdHZC6CqRKju79Xkm2/pitLYzGlMUTNgjPRV5zTPo2ugkcLU2W/+zjuEDI/8BH/tzsBirWbTAxrQrAsWNnDbVGGhGXgxa9m5Rvyq0Oq0Sh0EwSP+b1OvdU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3113.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(396003)(136003)(366004)(376002)(38070700005)(82960400001)(86362001)(122000001)(38100700002)(6916009)(54906003)(316002)(2906002)(76116006)(52536014)(8936002)(66946007)(5660300002)(7416002)(66556008)(66476007)(66446008)(64756008)(8676002)(4326008)(186003)(83380400001)(478600001)(966005)(33656002)(55016003)(71200400001)(53546011)(26005)(7696005)(6506007)(41300700001)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eyuAFVCLdVoWV9loNQaDs+lEZtVCAUMYHwY46AY2oDmYGSz75f/61HemONqP?=
 =?us-ascii?Q?/eMC1l+bTFlobas2z4LhxFuwrZ/nkP38BTnsfI7QMYbWbEWvEMwrwyAUOQVz?=
 =?us-ascii?Q?vRtLQVb6fU3yvhSjPevPlY3Xa8eznzUhRskf3SGKk12XWHOcPMvs6upwAesb?=
 =?us-ascii?Q?vFvXRR/5A7xI3LOpYXlrsQ7bnI+QjDNPand550XWBuk/8W2X3m/FviBxmhkt?=
 =?us-ascii?Q?24Z0PLhVA1hf/TUE4exQ6QNKzhqtEEQQYaBuMhsfc0oK12tzZtWilnB+9jJW?=
 =?us-ascii?Q?rgG8w9UR7Qaepu2QueuhKFlBw4LTQVK04V1W+MEIg+gknjRe4aFgoWXeLc4t?=
 =?us-ascii?Q?KCfFlulQB9vqDU0vNLIv4bydoV8rnQ9gZhTcd/M0i1T5qwcfquxTXHrZcOyZ?=
 =?us-ascii?Q?8P6MuB2VnWFhFodd4iVbGzpHqC9dl7PMmKMvzLMIuALoYcOSOyAYJBqMh7CS?=
 =?us-ascii?Q?ZAN0HqvbL0HdBzr+AhnrhecGeyWJ821KAx5IL1C8m4p0NmgaOEKxdeWQOiaB?=
 =?us-ascii?Q?6z0ItIorGyNv8wQVElutzGN1tHGpa7InJQkshdUrl81iK+lBjEu44RQFJlzL?=
 =?us-ascii?Q?v2h5oV3KVlRYf3WJjPrPRC69RHzQBpvX8IKkESTQvxJGitcUOVTc4bGgEwyW?=
 =?us-ascii?Q?UjsLWjLtCKv8ihkIKqxl/MOl3Zsdh5wLi1bnd/2G1Zqewistydi/xRG8oGDM?=
 =?us-ascii?Q?Rf8J8WICkJgzPnU1dAplJofuyIvNaxqPYpALHwDbFXckrvYUvXNpNIxPYCl4?=
 =?us-ascii?Q?YNRwGKujeVUnvqiIfTxzd2fKY+FZ0k2Tvvi6PdfGa9xnX7quCjgo4mdtlL0v?=
 =?us-ascii?Q?tbrrZ1JrWurQXi9IjvwwYNtwmw3Mvgco2bXfr1bn/x9WMeghYAovnhiIX+cI?=
 =?us-ascii?Q?8CTtwTdBXQVQfPlGI2WUhNh3HQzWUw7t3KdsyUEBe7A7q4dtc8jtStlSw0pZ?=
 =?us-ascii?Q?xsk1h6tdcEr/R/bgMwM/3wbnzsBpRz6fVmVx27ID6D8eUOBHl8NJQ93uw3E5?=
 =?us-ascii?Q?XaUG7eW6fUIBm1jX4F2EzatXbn4Cy73ZlkcJlQtn9DiLRTF3AwwVoD8iYbPH?=
 =?us-ascii?Q?X5OptsoVX8X411S6CeNXd1UdCuIimKBd9N0Fb8AE44dyiOB+XbA0x71J5Y8O?=
 =?us-ascii?Q?aavD2KwjT7p/bBq0ObU9sDqWk7tmnzGsh8GLLK8T1EoDKLQ7KaSR1HO0y7Vq?=
 =?us-ascii?Q?7cYlkJJhxl+qGm2IHrBHuOsZ4j+sxpkdgbs1Y5mq6xCuIdjqhddyFGImUQcw?=
 =?us-ascii?Q?3yESsW5fQYH02gy1sNAFw2a7phzOJBqU7Ka14bv8lxsNmyj9GTA9yzf35VCu?=
 =?us-ascii?Q?SBBDHSh2tG/hTVmCTKOSn8pgfsiaLQ0nPsWAs0wFwMCr1v4Sr7bSfiPxOVMA?=
 =?us-ascii?Q?Zxgi/umqC3P1Vp4UeCZCtk9KLZBe0GZldI9lSE4TIovL4xlW8jcPzBndLmmB?=
 =?us-ascii?Q?MeDMBD/Ra6NrLFYDZFPdEyr/talrpVjeh4r3ZSOXA2gqw0DlBFqCtl5o/9gu?=
 =?us-ascii?Q?KBjg9BbLWZtSHaLuXIo1GvDqg+3DcnKYoID28xjDrrfNcuSe9LgiH07IgKBg?=
 =?us-ascii?Q?BApV4mGhfIhB2Yw5M+Gq323Rq9Ec888s0UZZkN8r?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3113.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6675dd46-d657-40c7-b9da-08da8792a1ad
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2022 18:41:47.3526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E+l4U6x6P8BEWCZyHYACysCfZvTnDJlp4sxuTWQh26o7qOTQtQua/oBYQpHoBlGP1WAKDSPNYSmNcOiquLsPsCDo5yk8x/YPw7kgViGTj+w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1294
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

> -----Original Message-----
> From: Alex Williamson <alex.williamson@redhat.com>
> Sent: Friday, August 26, 2022 2:08 AM
> To: Laba, SlawomirX <slawomirx.laba@intel.com>
> Cc: linux-pci@vger.kernel.org; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; regressions@lists.linux.dev; bhelgaas@google.com;
> kvm@vger.kernel.org; linux-mm@kvack.org; songmuchun@bytedance.com;
> mike.kravetz@oracle.com; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; Andrew Morton <akpm@linux-
> foundation.org>
> Subject: Re: BUG: Virtual machine fails to start on 6.0-rc2
>=20
> On Thu, 25 Aug 2022 23:42:47 +0000
> "Laba, SlawomirX" <slawomirx.laba@intel.com> wrote:
>=20
> > We were testing the changes for our VF devices and noticed an issue
> > when starting VMs with passthrough VFs. We then moved back to mainline
> > kernel and reproduced the issue on 6.0-rc2
> >
> > We noticed that the startup of the KVM hangs.
> >
> > Steps to reproduce:
> > Create a VF from the PF interface.
> > Configure VM XML with the VF PCI.
> > Start the KVM.
> >
> > To isolate the issue we moved back to kernel 5.19 and it was working
> > fine.
> >
> > Working tag v5.19
> > Tested failing commit 4c612826bec1
>=20
> Does this resolve the issue?
>=20
> https://lore.kernel.org/all/166015037385.760108.16881097713975517242.stgi=
t
> @omen/
>=20
> This is currently in Andrew's mm-hotfixes-unstable branch and we're waiti=
ng
> for it to be merged to mainline.  Thanks,
>=20
> Alex

With the patch you linked, the issue is gone.

Thanks,
Slawek
