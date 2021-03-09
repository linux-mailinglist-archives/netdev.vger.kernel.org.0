Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1224033280D
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 15:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231273AbhCIOEh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 09:04:37 -0500
Received: from mga05.intel.com ([192.55.52.43]:37240 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231237AbhCIOES (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 09:04:18 -0500
IronPort-SDR: iupS/DZbdj9s4+rJ8JfJpfKXFZM1ZTU0glP7qPqY4pReKxozLw2wWZzPxtf3tuNp01DiZhRc1w
 5mrUYfJCSi8Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="273272712"
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="273272712"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 06:04:09 -0800
IronPort-SDR: VaTyo9pAtXYum2WN/i+cNdsvJ/NlUiJRsM5pr1fQjqGYsVx4RSeOXFqpQ9rYFQ1EAbN8w+dIIb
 +7gbJIqz2Umw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,234,1610438400"; 
   d="scan'208";a="403242720"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga008.fm.intel.com with ESMTP; 09 Mar 2021 06:04:08 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 9 Mar 2021 06:04:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Tue, 9 Mar 2021 06:04:08 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Tue, 9 Mar 2021 06:04:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCeMStoQbz+//u+HkeRgRzdP3L8XWKhLiDAY5h4xLtNMfVapP7OF/id36WTS0Mi4QgcFWCoj/0S5k2kQmEBhAntPGgFI/1lFnfF1Mtr8F/y0Em8N1A+neBUOCpJaDOrkBDEOFIBuHcgt5DyZat5IzdKZ60A14hkQDmLZicWNbAEF1+DRoKta7zUct7GGaHE4dLc3MYlNQLOe03P+jk3qLo4X8yOf5MvrAXCSR0fM31uORVy1vqpRNKsBdytZLWulDeQpMUGZOuQYp2mutJPi/j8o2GvxcsSee03XXL5STdt6z0sE/hjYmacP6Cbm47tg9sGTW4mKCIwSfu9r2mNBig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB/4F4/Ddi1EmAXW1n0D/+voi94HjIuK7m9oClVYmwA=;
 b=OA3aErUoItAgFH70Q+XWOyTKRinUdiVPSd26WlNUbM0JwAo4tmeYRUn6N5rROg1EZ5/cobTwbPc+JQ87kVqAG8s9W5JFgqMftdc04yg312vbOnlTLmmccbWSxryab5j6GkY7L2LwboNFhC+5en2v+lgAkbX04wvhVCYUS9dnrvC3gZkngeDy39+ccOn3GRQUucLwIwh4eOhMyFgsr4bJD8Z1YOIwt7yHyBOHN52Pb0MLXpbzNU5fAlYnOxWiCJ8Qq2ZVMswmX4CxNDBZHZRF50kaEdYG4OaQTTvtYYYWuu8hNZk5iUrGjFyqCn6NJNpquM+UBaYEaly9n8UkfvB2bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gB/4F4/Ddi1EmAXW1n0D/+voi94HjIuK7m9oClVYmwA=;
 b=Ht2SacbOQPDqy6vWngJbm2MT2UFxTZvkxhVH8zh0OQG7yhzA2TTcjivDs1N0zDC8SZT3Ie65eVHYH2EhjGyit78gGpk3KMApSI4DH026o0XTvlWXIfN6GpyZh7a7vg/dYO6SqKzK5LuYE1fW5iIqcTlX86BiYZgnYX1bnFNndJ8=
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM5PR11MB1241.namprd11.prod.outlook.com (2603:10b6:3:15::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3912.27; Tue, 9 Mar 2021 14:04:06 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::49d7:5128:e3cc:695a]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::49d7:5128:e3cc:695a%6]) with mapi id 15.20.3912.027; Tue, 9 Mar 2021
 14:04:04 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net 1/3] i40e: move headroom
 initialization to i40e_configure_rx_ring
Thread-Topic: [Intel-wired-lan] [PATCH intel-net 1/3] i40e: move headroom
 initialization to i40e_configure_rx_ring
Thread-Index: AQHXEEXSgDdNXugALEGxeu0MuPq7xqp7uVuw
Date:   Tue, 9 Mar 2021 14:04:04 +0000
Message-ID: <DM6PR11MB32923242A018780B50182999F1929@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20210303153928.11764-1-maciej.fijalkowski@intel.com>
 <20210303153928.11764-2-maciej.fijalkowski@intel.com>
In-Reply-To: <20210303153928.11764-2-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [198.175.68.36]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e465194f-bb4a-446c-9edb-08d8e30432cb
x-ms-traffictypediagnostic: DM5PR11MB1241:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR11MB1241A75C6769DF5965BDD93BF1929@DM5PR11MB1241.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JVy5iCR21TPyMl5a78u4Nc4AQOrziktQqMCbEWwCcNU37CoZK+M6NbxkpkycFR4oUw6PqVXhzECyXcU4QmyGqu5nRBS2JH27Zem+IjFxIKsrUz+vq+BjeRAVbm5VudcVt/QWrZhewgRG5NsohNGeKRxiT76nr0YVCzFwxukh/rL6J+cEVLwf5Ht/iLD5tes3vtEoTOhUPQrD6K5sXKTZ0FnSIh7EvSYZJ0JY7aLf+EDj5vL5eK4fAAZrPsnLsnWA7DNQks2kTNPOnLGsFTndbReXc/VJ0Urx2YJbuDAXEfXtdyO4g8/TyuzW6L/yjnS0TMpOByZby+3niaZEqm8KuKX/D/FyaK28WGoI2/TjtpfGzM2kjqYPGWiO9Wf/nHitA5uLPDh6mF4zOJ2+N6d0/0gjGPD0lznhvLX7TnauXC2XUuTfI5bhw6U58hp6+HJil8CdvZ9o7c/zvQPgVesCsViF8OzL03pppWqpRG6NSmPXZNmic2H5N9XG48BgraIQ2lZb2DBzB+JdKHdipvkx5A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(346002)(136003)(396003)(33656002)(4326008)(9686003)(52536014)(55016002)(83380400001)(107886003)(478600001)(26005)(8936002)(8676002)(86362001)(53546011)(6506007)(7696005)(71200400001)(110136005)(2906002)(54906003)(76116006)(316002)(66946007)(66556008)(66446008)(66476007)(64756008)(5660300002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?yYeVTVrwiluehNHN2FSHBK2E1b6kAGEk/ySUf/yWe1FhcqozA451AvRTOmzo?=
 =?us-ascii?Q?A3J9gGx1BM2ecagUsX92qQBoKbnd4EzHibchPtsse8pTp8L6F9OjitnKSBm/?=
 =?us-ascii?Q?3qJ7hiMzER/5ZYUFqtvT9RDLZtq+8TQNouHooK+m6RyEimh1r6o25TdTKMCK?=
 =?us-ascii?Q?H94vYfOyCMjAqNH//WVA0xaqnr7QVHSDGXsNVceKo+8TI6hcDn4FT1HBwhR8?=
 =?us-ascii?Q?iA0CLLbhAYmkyZNouEbP0+4KwTB5OfrQ+Cmuaq+5MoMO8LlWVo1I3G3FCQeU?=
 =?us-ascii?Q?t9RBMV5UlqirKAeyf8McuV8ytvrzYFulM+yOAx60KqAcBBS6zkeHIAEz9/99?=
 =?us-ascii?Q?/SP2/ghaBobVu3msFbvnw1cpEJ6LQslU4ghKkT8oZEJNAE6NxkoKOCz4ZoIP?=
 =?us-ascii?Q?ATgk0+XfqBowWgOIT0HngJ1wgNKaC/kkASnrAk73htO+B/bPhTPqPLqA2wTO?=
 =?us-ascii?Q?i0ULEN7+Xk6ONx4dKp/gEcFN0Cc4+SLg9JnXoZOB1FW0U5yt/AV5M9f1FnPd?=
 =?us-ascii?Q?7t4VOw/Vx6oT6bP0pwgVq0QZ3E/RZKcJ59cuOB+f088NPvvbyZHlrK0cFEb6?=
 =?us-ascii?Q?PTnw/BnH6z6T9lQq2N86SDqM/ztXISPvFkmIwhHklIayjzkLUPRqVDqILL5i?=
 =?us-ascii?Q?hVgWvSrBFfwehF5/9G27bNyp10yLPaVp8sZZ6tAU1/L8nPnBDiJTrl7SHqpu?=
 =?us-ascii?Q?CvQlulOe7+PQiUdXDFMpVJiCQ5oNzy9G+fFjsWah3w8cY69iMVvEia/sY616?=
 =?us-ascii?Q?E4AI0eOwK60v46yoQpnOECUaFjCTB8t7E50OMDlOglMsJ0z12/qKSBKgL5FH?=
 =?us-ascii?Q?d57H8MsWVS9L25Po0YXV5B89oNB4d+eFe52s1JUogXGhGmk7sD5VFT3LtHN6?=
 =?us-ascii?Q?PtngXvp97fK8uEFstyWYmzXmiD8To7HzWRtwKPz90bQLprwdkYGdPwU0hBSC?=
 =?us-ascii?Q?MUq7rblJn73VnVelbeLHoWhNhykcsfo+Z8UnFjkVciFlCUhQksGsSVFebd7l?=
 =?us-ascii?Q?92ghQDZxDmFtwGu93Gd5miBs5Jo9THh8C9fcgBSQRTf2InXCKMBW8++fYgjd?=
 =?us-ascii?Q?vMljAVe6R2cMaU6S+gIVChYRNSHAoGoad3RerMS11iYMDVq75+fkbuCM5hcT?=
 =?us-ascii?Q?FfpLY0VwpgvWgfceCwE0GUOvDLvb37Xy8CMQgfjbUne5aph6gEIOFuaMhIwr?=
 =?us-ascii?Q?mSPrZRaSh9OM6qPMkSeUcYGbVrgSdMfCQWseWNdTO1h/5qp4RNCp80GqdVt4?=
 =?us-ascii?Q?8MDHllamMtRtmFp5GITF0VylQhrStHE5RGGWvIgOY3fte3+gyUlfT+OfyluK?=
 =?us-ascii?Q?SGS/ibGcWlOuPLVnTFhGxgfZ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e465194f-bb4a-446c-9edb-08d8e30432cb
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2021 14:04:04.2885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SQwQyHl86f5jAEaCCpYw8UIk5fzztpCzFSW2HgcDCF9oxRE5ePMRY7lv3WMiq5kdTSXucHWbk47+E79n3RDx1r9COL9kpfOqZ1XX6Wiz1Xg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1241
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Wednesday, March 3, 2021 9:09 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; brouer@redhat.com; kuba@kernel.org;
> bpf@vger.kernel.org; Topel, Bjorn <bjorn.topel@intel.com>; Karlsson,
> Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-net 1/3] i40e: move headroom
> initialization to i40e_configure_rx_ring
>=20
> i40e_rx_offset(), that is supposed to initialize the Rx buffer headroom, =
relies
> on I40E_RXR_FLAGS_BUILD_SKB_ENABLED flag.
>=20
> Currently, the callsite of mentioned function is placed incorrectly withi=
n
> i40e_setup_rx_descriptors() where Rx ring's build skb flag is not set yet=
. This
> causes the XDP_REDIRECT to be partially broken due to inability to create
> xdp_frame in the headroom space, as the headroom is 0.
>=20
> For the record, below is the call graph:
>=20
> i40e_vsi_open
>  i40e_vsi_setup_rx_resources
>   i40e_setup_rx_descriptors
>    i40e_rx_offset() <-- sets offset to 0 as build_skb flag is set below
>=20
>  i40e_vsi_configure_rx
>   i40e_configure_rx_ring
>    set_ring_build_skb_enabled(ring) <-- set build_skb flag
>=20
> Fix this by moving i40e_rx_offset() to i40e_configure_rx_ring() after the=
 flag
> setting.
>=20
> Fixes: f7bb0d71d658 ("i40e: store the result of i40e_rx_offset() onto
> i40e_ring")
> Reported-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 13 +++++++++++++
> drivers/net/ethernet/intel/i40e/i40e_txrx.c | 12 ------------
>  2 files changed, 13 insertions(+), 12 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
