Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF8AD3B58C5
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 07:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232179AbhF1F5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 01:57:17 -0400
Received: from mga17.intel.com ([192.55.52.151]:30749 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229692AbhF1F5P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 01:57:15 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10028"; a="188271432"
X-IronPort-AV: E=Sophos;i="5.83,305,1616482800"; 
   d="scan'208";a="188271432"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2021 22:54:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,305,1616482800"; 
   d="scan'208";a="446426334"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga007.jf.intel.com with ESMTP; 27 Jun 2021 22:54:46 -0700
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Sun, 27 Jun 2021 22:54:45 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Sun, 27 Jun 2021 22:54:45 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Sun, 27 Jun 2021 22:54:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mmy79+gma4XYcMd82AG/z4TYmACwbqqZcnJxukQMBxBv1RVCPHRC4qyko7w5XMxC56c+x0AbpIhQl9w2HziY2ath5B0XmnXciqkr2gL4j8AXN2ziPlG702RKWegIZDqWd+FR+7v60YZ8391bpaZ3Cg6nJ4WLDBGHcWw58H9XcwDnNgH94GI+DCKSacvkhlD7tGIfYD+qUr2NVNrsOK04wmhr9yXIEha4wHVRBLq38ZQw6+/viIEiWFY8aUkcgrZMJ18mvdGIgRIOKr/ymUtNil8H9shvhjBKitcT3R3l7yQaYe3KZrpAOTNTrxwALa+BfXTkpAVwv9/RoNCO0qZPgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHu4ubxfy0C1nqBE6CjuXn65kuW2V86UBUx6rJIjlSE=;
 b=HrxErLv1AiVmthSaX8NCzHHKLE9YwGnv5/Hrcoe8W+fmBC13EGxLjC+7leAcgXE51JmFJWyZ8nZ5u6tSKpb1GTaXmMGfba6hqRdtvBwtx5ccmiE2cfmPtzwirXrlz70LC1/b67qqkFlKK6gYyEOh0TMNRRSxNP4l4YOswzPfhP/hTEz6GlTY+gO70Iw+VRSO0kG3NVgijErxMemDlykcV1TrqN7CSsOw+Oks8ep6JqMOzGVlsIH9UtePc6evxSiRKPBqv6+QdNBjYnsk7Fm+bbMCb6qY3T5I0qVZkaWl+eHP8uldKDirV1SsFK4LfdTRj2zFRnR8oQm0P9jEFt/qNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KHu4ubxfy0C1nqBE6CjuXn65kuW2V86UBUx6rJIjlSE=;
 b=mhZFlkZtkq8ec3GCiFnwSl7kGhPy1VV3I0KPL14WH4Zb891VhI8WFvn/t47Y6cQNzvWRI3x+s9bNTQ2XwPu9tPnIL5YWgERdfNgX+WZRM+y/K6dg9zTn2ezO0Nhu9gsJ/vCxoboaENj6Puk/yT5yTZGvKXg59tvqdG2EBEGCmHA=
Received: from BYAPR11MB2662.namprd11.prod.outlook.com (2603:10b6:a02:c8::24)
 by BY5PR11MB4165.namprd11.prod.outlook.com (2603:10b6:a03:18c::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Mon, 28 Jun
 2021 05:54:42 +0000
Received: from BYAPR11MB2662.namprd11.prod.outlook.com
 ([fe80::103d:74b9:605e:b05b]) by BYAPR11MB2662.namprd11.prod.outlook.com
 ([fe80::103d:74b9:605e:b05b%6]) with mapi id 15.20.4264.026; Mon, 28 Jun 2021
 05:54:42 +0000
From:   "Liu, Xiaodong" <xiaodong.liu@intel.com>
To:     Jason Wang <jasowang@redhat.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "sgarzare@redhat.com" <sgarzare@redhat.com>,
        "parav@nvidia.com" <parav@nvidia.com>,
        "hch@infradead.org" <hch@infradead.org>,
        "christian.brauner@canonical.com" <christian.brauner@canonical.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "willy@infradead.org" <willy@infradead.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "mika.penttila@nextfour.com" <mika.penttila@nextfour.com>,
        "dan.carpenter@oracle.com" <dan.carpenter@oracle.com>,
        "joro@8bytes.org" <joro@8bytes.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
Thread-Topic: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
Thread-Index: AQHXa8kUCtmikoHekUKCGV4xYFF/O6so1l4AgAANryA=
Date:   Mon, 28 Jun 2021 05:54:42 +0000
Message-ID: <BYAPR11MB2662FFF6140A4C634648BB2E8C039@BYAPR11MB2662.namprd11.prod.outlook.com>
References: <20210615141331.407-1-xieyongji@bytedance.com>
 <20210628103309.GA205554@storage2.sh.intel.com>
 <bdbe3a79-e5ce-c3a5-4c68-c11c65857377@redhat.com>
In-Reply-To: <bdbe3a79-e5ce-c3a5-4c68-c11c65857377@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.46.52]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9fc8719-43e9-4156-12da-08d939f93962
x-ms-traffictypediagnostic: BY5PR11MB4165:
x-microsoft-antispam-prvs: <BY5PR11MB4165BAA95149EDDDC27109F48C039@BY5PR11MB4165.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x4yYlIXkkcQ9W0zD1SujJfxeqCjJQQtkrGc3x6rOArUZd/Yh+t8JJ42GbA5mtc8Ltt18XYg/vY9RdQZf2wJ3LowUpNxVZNaCTEik7v09y6H3qeFGsKHPujGc+lJH7JQVaiITxwakqdYzlihtu5L18KeZOnD6fL95DoXTMKIqV9i/oUCqyT8OmPDLYBOCoHFsj4QVLnEe4EkKmkkbL22WUPpUtlpU6tQ2wdzoyOM3TJXNGAxSXmOpyBTPWDT4MPz8GmdRLHydw0koo7nV1KWqhrF5DPfd9uvinJWpcHADR9jbI6oj85qg4v+F4po72WDW5A7Dwe+aGQ/LVBTFKCAp/ttLKLL13rCtrY0bAtRJW0Wg6z/QNPPcW18jzY1H9zOB5wYYQy/vw8JOTycWjt5XkA/KyMDK/ihv5UnWRB5I/9FjbKS4BiJ1av8fPfbznYDw/QKX0aF5488RSmY/9dfktXeL1Vkn6MPrvmSM0rFVfBhFQ8KqLkoMcLoPnRXv9fEbv6ZqrG+uoNQUqFEYSFmuRbF0Sh+q37BmZzRWBSR3UcThe1Yi48u+mPTtBDnlB8FTqz2HzMkbaH7Vm/TOkQXm1bz7qOKSyz0p52ZWdfqSeeWLzfOezF6ClM/ZEw0IhbHFsH3zqMFdPYsKaCpLguZIXL1zvqByO161cQhJgBgVVmVwVMnu/gBDMvQnCV1/yKPiHesW0gIa+gBKahR79J5JKiqBrtGVyYAxa9vkgIYgc0O3D/vuhdjRrnY7d1iXpjBCwJ7o/41ycgzILq+u4gg9VkfkxhaxuJocX1+rmnP6+U6SQJuzBU4lfUw68X2l9flJ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(136003)(366004)(396003)(966005)(316002)(33656002)(54906003)(122000001)(38100700002)(8936002)(2906002)(7416002)(110136005)(76116006)(478600001)(26005)(4326008)(66476007)(86362001)(66446008)(64756008)(66556008)(66946007)(921005)(71200400001)(9686003)(7696005)(5660300002)(186003)(83380400001)(52536014)(30864003)(6506007)(55016002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-2022-jp?B?QkRzcm5iblh6NFhHb2pPR3RJWmVjekxiYWMrQWdNcHVnenI1TGtmRnQy?=
 =?iso-2022-jp?B?Zk9Pdk1Gcit1bVgwWmp2ZHgwN0ZoN0RXUnZkNVBtTEd0SEtPbnJIdkYy?=
 =?iso-2022-jp?B?cUNDbUdHejgvZDJrWm1zNzBJZ0YwVUdNWXRIUVR5bzRDMUhLdTh4bUVW?=
 =?iso-2022-jp?B?Z1NYZWpFWHdmTHpWYUhVeGxpczluZ2JjZTI0ZEhJcTA0TXB3VDcxejlm?=
 =?iso-2022-jp?B?L0QyUjhHQU5qM2g4VXZjWnZrNHZ4WHROTTFXY2hKQ1FBaEVQUk5VZklu?=
 =?iso-2022-jp?B?N0lhWWFBaDdvaWV6QlFSRmZpdDhqbDhwRzhQV0dBYjczLzlGQnNvTDFL?=
 =?iso-2022-jp?B?Tk1xeTd1Z1ZlQ212QVBIem1EMjhMazBaVllLLzFaVGZNVGFjWHBCbkto?=
 =?iso-2022-jp?B?N21MSVZjS2c2N1dYTnoycTRsc3IwMUNERVdYYjI4WWU1VytiTlNxeUhv?=
 =?iso-2022-jp?B?UjVkOFkxMllkajBmYW5ERkZ1dXhBL2RSbXVpZVVSYU8wUG9WTUxmbTR0?=
 =?iso-2022-jp?B?cWZwTU1mWGJSeGlXODd5SHU5d1l2YjhPMnl4NFFEK2dwdjRQY0lxeUR3?=
 =?iso-2022-jp?B?aWRnRDZYZ2k2Y0VCUFc0L2FHV0pScUJGVWFKNXk3clRIVGRjLzNFaXVF?=
 =?iso-2022-jp?B?RURKRmpsb3R1dEdzS1lobTR5QldNTFMzbklOSDY0UnJ2emVaRmZHNnAz?=
 =?iso-2022-jp?B?czZIdG5ybzc3R2w2VkZmMGNWd2N3b0l3dzJYQXJXRVdjVzROSUdpR01T?=
 =?iso-2022-jp?B?d05TaEJtZklSNi9ZalFIQlpGaUQ2dW5DNUwxY0JLeXBMQnNUNHMrRFEw?=
 =?iso-2022-jp?B?TVRSaUEvQzArdm9qUGRRM1ViMnR4K0k1WVg5cElqTXhJYnBpbis4RmJT?=
 =?iso-2022-jp?B?cU05bk56N0MxRFdwNTM3WWlRb2l6RS82QzJLckFrV3pncDFoS2VWc0FW?=
 =?iso-2022-jp?B?RDd1R2U5MEFaaisrMzRQZkdMRDZPeWRSek9JRmZXWWhNL2lOczFKY2JI?=
 =?iso-2022-jp?B?ZG9JR3Jpc1NrWjc0enNucVZpZW0wQUs1cUczREZiYmhGME9VZis5YzBj?=
 =?iso-2022-jp?B?VTdWejdRRGErYWZSODJ1RXNWWUxLK1hrUVhoYXFXOS9GRmRCVUJ6VnhI?=
 =?iso-2022-jp?B?dGsreGNjV1hOdUpCc3R5eGNobWozUUVZRDhhK3FkL2dld1VlK245aVFm?=
 =?iso-2022-jp?B?eEZPUzhXNHBBcGdQL2pYWnZoaFpXMXR3QWVkYVBaNnBkbDNkZEJ6UHNz?=
 =?iso-2022-jp?B?S2dGdXRJQ004TURTUXR2WFlhdkVzaGtkTXhmY3A5eTZTRkpUbk9YblFS?=
 =?iso-2022-jp?B?NG1OYi9WNWVBWThCSE54NDdqZzJDamhqMEZsWXlaV0s5N04rTFJDSmtZ?=
 =?iso-2022-jp?B?VW9JODh1OUhxUVZLVzNMTDFScXUzMjdteVVwZ1FwSWVPYVlzS2ZGaEFZ?=
 =?iso-2022-jp?B?ZWNtN2prbVVialo1U0Q5b2dOQ3gxSm9lMURjSFlSTVlCSXdISXhXUmY2?=
 =?iso-2022-jp?B?MFNML0E2L0RWcDlNT2lWaW4yNXpWVW1RelZteFhIbkRtdTdCK3dJUFNK?=
 =?iso-2022-jp?B?clFuN0lNTzFFb1dRY2lPcU9HK2JwZzhEQ3IrYkRTZS9IbjNkbk5oK3BM?=
 =?iso-2022-jp?B?TFZxN3FsbUJWSkxOejNDZEg3T1VYa3hGRGRiRTRVTEp3STdXU001OTlY?=
 =?iso-2022-jp?B?MWlYU0ZaemhxeVkwOTJ1YWx6Rm4rYWFUSkNOQXR1WXNvdlowNlVyY3JJ?=
 =?iso-2022-jp?B?UStRSEtpb1BMelpDUGRjdnhHWUhNWEhOVHgzUXB4TWs4dlZneUduYUd1?=
 =?iso-2022-jp?B?SnNNT1U1QkxkajlyK2tHTXhrZndxSVpza0w1OTltSmVLaUZudGJDMkNr?=
 =?iso-2022-jp?B?NW1Nb09YZTZpSGl6dzg1VmZ6Y20wPQ==?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9fc8719-43e9-4156-12da-08d939f93962
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jun 2021 05:54:42.0705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /5XxtfexUDb10n4yZtthvcl4BEuwRnL8cm0gBUFLO1/N2tcaEC0MSjXAp1ttr2FkokPZmH8Q8DS5fqSuIXjUlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4165
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



>-----Original Message-----
>From: Jason Wang <jasowang@redhat.com>
>Sent: Monday, June 28, 2021 12:35 PM
>To: Liu, Xiaodong <xiaodong.liu@intel.com>; Xie Yongji
><xieyongji@bytedance.com>; mst@redhat.com; stefanha@redhat.com;
>sgarzare@redhat.com; parav@nvidia.com; hch@infradead.org;
>christian.brauner@canonical.com; rdunlap@infradead.org; willy@infradead.or=
g;
>viro@zeniv.linux.org.uk; axboe@kernel.dk; bcrl@kvack.org; corbet@lwn.net;
>mika.penttila@nextfour.com; dan.carpenter@oracle.com; joro@8bytes.org;
>gregkh@linuxfoundation.org
>Cc: songmuchun@bytedance.com; virtualization@lists.linux-foundation.org;
>netdev@vger.kernel.org; kvm@vger.kernel.org; linux-fsdevel@vger.kernel.org=
;
>iommu@lists.linux-foundation.org; linux-kernel@vger.kernel.org
>Subject: Re: [PATCH v8 00/10] Introduce VDUSE - vDPA Device in Userspace
>
>
>=1B$B:_=1B(B 2021/6/28 =1B$B2<8a=1B(B6:33, Liu Xiaodong =1B$B<LF;=1B(B:
>> On Tue, Jun 15, 2021 at 10:13:21PM +0800, Xie Yongji wrote:
>>> This series introduces a framework that makes it possible to
>>> implement software-emulated vDPA devices in userspace. And to make it
>>> simple, the emulated vDPA device's control path is handled in the
>>> kernel and only the data path is implemented in the userspace.
>>>
>>> Since the emuldated vDPA device's control path is handled in the
>>> kernel, a message mechnism is introduced to make userspace be aware
>>> of the data path related changes. Userspace can use read()/write() to
>>> receive/reply the control messages.
>>>
>>> In the data path, the core is mapping dma buffer into VDUSE daemon's
>>> address space, which can be implemented in different ways depending
>>> on the vdpa bus to which the vDPA device is attached.
>>>
>>> In virtio-vdpa case, we implements a MMU-based on-chip IOMMU driver
>>> with bounce-buffering mechanism to achieve that. And in vhost-vdpa
>>> case, the dma buffer is reside in a userspace memory region which can
>>> be shared to the VDUSE userspace processs via transferring the shmfd.
>>>
>>> The details and our user case is shown below:
>>>
>>> ------------------------    -------------------------   ---------------=
---------------------------
>----
>>> |            Container |    |              QEMU(VM) |   |              =
                 VDUSE daemon
>|
>>> |       ---------      |    |  -------------------  |   | -------------=
------------ ---------------- |
>>> |       |dev/vdx|      |    |  |/dev/vhost-vdpa-x|  |   | | vDPA device=
 emulation | |
>block driver | |
>>> ------------+-----------     -----------+------------   -------------+-=
---------------------+---
>------
>>>              |                           |                            |=
                      |
>>>              |                           |                            |=
                      |
>>> ------------+---------------------------+----------------------------+-=
---------------------
>+---------
>>> |    | block device |           |  vhost device |            | vduse dr=
iver |          | TCP/IP |
>|
>>> |    -------+--------           --------+--------            -------+--=
------          -----+----    |
>>> |           |                           |                           |  =
                     |        |
>>> | ----------+----------       ----------+-----------         -------+--=
-----                |        |
>>> | | virtio-blk driver |       |  vhost-vdpa driver |         | vdpa dev=
ice |                |
>|
>>> | ----------+----------       ----------+-----------         -------+--=
-----                |        |
>>> |           |      virtio bus           |                           |  =
                     |        |
>>> |   --------+----+-----------           |                           |  =
                     |        |
>>> |                |                      |                           |  =
                     |        |
>>> |      ----------+----------            |                           |  =
                     |        |
>>> |      | virtio-blk device |            |                           |  =
                     |        |
>>> |      ----------+----------            |                           |  =
                     |        |
>>> |                |                      |                           |  =
                     |        |
>>> |     -----------+-----------           |                           |  =
                     |        |
>>> |     |  virtio-vdpa driver |           |                           |  =
                     |        |
>>> |     -----------+-----------           |                           |  =
                     |        |
>>> |                |                      |                           |  =
  vdpa bus           |        |
>>> |     -----------+----------------------+---------------------------+--=
----------           |
>|
>>> |                                                                      =
                  ---+---     |
>>> -----------------------------------------------------------------------=
------------------| NIC
>|------
>>>                                                                        =
                   ---+---
>>>                                                                        =
                      |
>>>                                                                        =
             ---------+---------
>>>                                                                        =
             | Remote Storages |
>>>
>>> -------------------
>>>
>>> We make use of it to implement a block device connecting to our
>>> distributed storage, which can be used both in containers and VMs.
>>> Thus, we can have an unified technology stack in this two cases.
>>>
>>> To test it with null-blk:
>>>
>>>    $ qemu-storage-daemon \
>>>        --chardev socket,id=3Dcharmonitor,path=3D/tmp/qmp.sock,server,no=
wait \
>>>        --monitor chardev=3Dcharmonitor \
>>>        --blockdev
>driver=3Dhost_device,cache.direct=3Don,aio=3Dnative,filename=3D/dev/nullb0=
,node-
>name=3Ddisk0 \
>>>        --export
>>> type=3Dvduse-blk,id=3Dtest,node-name=3Ddisk0,writable=3Don,name=3Dvduse=
-null,nu
>>> m-queues=3D16,queue-size=3D128
>>>
>>> The qemu-storage-daemon can be found at
>>> https://github.com/bytedance/qemu/tree/vduse
>>>
>>> To make the userspace VDUSE processes such as qemu-storage-daemon
>>> able to be run by an unprivileged user. We did some works on virtio
>>> driver to avoid trusting device, including:
>>>
>>>    - validating the used length:
>>>
>>>      * https://lore.kernel.org/lkml/20210531135852.113-1-
>xieyongji@bytedance.com/
>>>      *
>>> https://lore.kernel.org/lkml/20210525125622.1203-1-xieyongji@bytedanc
>>> e.com/
>>>
>>>    - validating the device config:
>>>
>>>      *
>>> https://lore.kernel.org/lkml/20210615104810.151-1-xieyongji@bytedance
>>> .com/
>>>
>>>    - validating the device response:
>>>
>>>      *
>>> https://lore.kernel.org/lkml/20210615105218.214-1-xieyongji@bytedance
>>> .com/
>>>
>>> Since I'm not sure if I missing something during auditing, especially
>>> on some virtio device drivers that I'm not familiar with, we limit
>>> the supported device type to virtio block device currently. The
>>> support for other device types can be added after the security issue
>>> of corresponding device driver is clarified or fixed in the future.
>>>
>>> Future work:
>>>    - Improve performance
>>>    - Userspace library (find a way to reuse device emulation code in qe=
mu/rust-
>vmm)
>>>    - Support more device types
>>>
>>> V7 to V8:
>>> - Rebased to newest kernel tree
>>> - Rework VDUSE driver to handle the device's control path in kernel
>>> - Limit the supported device type to virtio block device
>>> - Export free_iova_fast()
>>> - Remove the virtio-blk and virtio-scsi patches (will send them
>>> alone)
>>> - Remove all module parameters
>>> - Use the same MAJOR for both control device and VDUSE devices
>>> - Avoid eventfd cleanup in vduse_dev_release()
>>>
>>> V6 to V7:
>>> - Export alloc_iova_fast()
>>> - Add get_config_size() callback
>>> - Add some patches to avoid trusting virtio devices
>>> - Add limited device emulation
>>> - Add some documents
>>> - Use workqueue to inject config irq
>>> - Add parameter on vq irq injecting
>>> - Rename vduse_domain_get_mapping_page() to
>>> vduse_domain_get_coherent_page()
>>> - Add WARN_ON() to catch message failure
>>> - Add some padding/reserved fields to uAPI structure
>>> - Fix some bugs
>>> - Rebase to vhost.git
>>>
>>> V5 to V6:
>>> - Export receive_fd() instead of __receive_fd()
>>> - Factor out the unmapping logic of pa and va separatedly
>>> - Remove the logic of bounce page allocation in page fault handler
>>> - Use PAGE_SIZE as IOVA allocation granule
>>> - Add EPOLLOUT support
>>> - Enable setting API version in userspace
>>> - Fix some bugs
>>>
>>> V4 to V5:
>>> - Remove the patch for irq binding
>>> - Use a single IOTLB for all types of mapping
>>> - Factor out vhost_vdpa_pa_map()
>>> - Add some sample codes in document
>>> - Use receice_fd_user() to pass file descriptor
>>> - Fix some bugs
>>>
>>> V3 to V4:
>>> - Rebase to vhost.git
>>> - Split some patches
>>> - Add some documents
>>> - Use ioctl to inject interrupt rather than eventfd
>>> - Enable config interrupt support
>>> - Support binding irq to the specified cpu
>>> - Add two module parameter to limit bounce/iova size
>>> - Create char device rather than anon inode per vduse
>>> - Reuse vhost IOTLB for iova domain
>>> - Rework the message mechnism in control path
>>>
>>> V2 to V3:
>>> - Rework the MMU-based IOMMU driver
>>> - Use the iova domain as iova allocator instead of genpool
>>> - Support transferring vma->vm_file in vhost-vdpa
>>> - Add SVA support in vhost-vdpa
>>> - Remove the patches on bounce pages reclaim
>>>
>>> V1 to V2:
>>> - Add vhost-vdpa support
>>> - Add some documents
>>> - Based on the vdpa management tool
>>> - Introduce a workqueue for irq injection
>>> - Replace interval tree with array map to store the iova_map
>>>
>>> Xie Yongji (10):
>>>    iova: Export alloc_iova_fast() and free_iova_fast();
>>>    file: Export receive_fd() to modules
>>>    eventfd: Increase the recursion depth of eventfd_signal()
>>>    vhost-iotlb: Add an opaque pointer for vhost IOTLB
>>>    vdpa: Add an opaque pointer for vdpa_config_ops.dma_map()
>>>    vdpa: factor out vhost_vdpa_pa_map() and vhost_vdpa_pa_unmap()
>>>    vdpa: Support transferring virtual addressing during DMA mapping
>>>    vduse: Implement an MMU-based IOMMU driver
>>>    vduse: Introduce VDUSE - vDPA Device in Userspace
>>>    Documentation: Add documentation for VDUSE
>>>
>>>   Documentation/userspace-api/index.rst              |    1 +
>>>   Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
>>>   Documentation/userspace-api/vduse.rst              |  222 +++
>>>   drivers/iommu/iova.c                               |    2 +
>>>   drivers/vdpa/Kconfig                               |   10 +
>>>   drivers/vdpa/Makefile                              |    1 +
>>>   drivers/vdpa/ifcvf/ifcvf_main.c                    |    2 +-
>>>   drivers/vdpa/mlx5/net/mlx5_vnet.c                  |    2 +-
>>>   drivers/vdpa/vdpa.c                                |    9 +-
>>>   drivers/vdpa/vdpa_sim/vdpa_sim.c                   |    8 +-
>>>   drivers/vdpa/vdpa_user/Makefile                    |    5 +
>>>   drivers/vdpa/vdpa_user/iova_domain.c               |  545 ++++++++
>>>   drivers/vdpa/vdpa_user/iova_domain.h               |   73 +
>>>   drivers/vdpa/vdpa_user/vduse_dev.c                 | 1453
>++++++++++++++++++++
>>>   drivers/vdpa/virtio_pci/vp_vdpa.c                  |    2 +-
>>>   drivers/vhost/iotlb.c                              |   20 +-
>>>   drivers/vhost/vdpa.c                               |  148 +-
>>>   fs/eventfd.c                                       |    2 +-
>>>   fs/file.c                                          |    6 +
>>>   include/linux/eventfd.h                            |    5 +-
>>>   include/linux/file.h                               |    7 +-
>>>   include/linux/vdpa.h                               |   21 +-
>>>   include/linux/vhost_iotlb.h                        |    3 +
>>>   include/uapi/linux/vduse.h                         |  143 ++
>>>   24 files changed, 2641 insertions(+), 50 deletions(-)
>>>   create mode 100644 Documentation/userspace-api/vduse.rst
>>>   create mode 100644 drivers/vdpa/vdpa_user/Makefile
>>>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.c
>>>   create mode 100644 drivers/vdpa/vdpa_user/iova_domain.h
>>>   create mode 100644 drivers/vdpa/vdpa_user/vduse_dev.c
>>>   create mode 100644 include/uapi/linux/vduse.h
>>>
>>> --
>>> 2.11.0
>> Hi, Yongji
>>
>> Great work! your method is really wise that implements a software
>> IOMMU so that data path gets processed by userspace application efficien=
tly.
>> Sorry, I've just realized your work and patches.
>>
>>
>> I was working on a similar thing aiming to get vhost-user-blk device
>> from SPDK vhost-target to be exported as local host kernel block device.
>> It's diagram is like this:
>>
>>
>>                                  -----------------------------
>> ------------------------        |    -----------------      |    -------=
-------------------------------
>-
>> |   <RunC Container>   |     <<<<<<<<| Shared-Memory
>|>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>        |
>> |       ---------      |     v  |    -----------------      |    |      =
                      v        |
>> |       |dev/vdx|      |     v  |   <virtio-local-agent>    |    |      =
<Vhost-user Target>
>v        |
>> ------------+-----------     v  | ------------------------  |    |  ----=
----------------------v-----
>-  |
>>              |                v  | |/dev/virtio-local-ctrl|  |    |  | u=
nix socket |   |block driver
>|  |
>>              |                v  ------------+----------------    ------=
--+--------------------v---------
>>              |                v              |                          =
  |                    v
>> ------------+----------------v--------------+---------------------------=
-+--------------------
>v--------|
>> |    | block device |        v      |  Misc device |                    =
 |                    v        |
>> |    -------+--------        v      --------+-------                    =
 |                    v        |
>> |           |                v              |                           =
 |                    v        |
>> | ----------+----------      v              |                           =
 |                    v        |
>> | | virtio-blk driver |      v              |                           =
 |                    v        |
>> | ----------+----------      v              |                           =
 |                    v        |
>> |           | virtio bus     v              |                           =
 |                    v        |
>> |   --------+---+-------     v              |                           =
 |                    v        |
>> |               |            v              |                           =
 |                    v        |
>> |               |            v              |                           =
 |                    v        |
>> |     ----------+----------  v     ---------+-----------                =
 |                    v        |
>> |     | virtio-blk device |--<----| virtio-local driver |---------------=
-<                    v
>|
>> |     ----------+----------       ----------+-----------                =
                      v        |
>> |
>> | ---------+--------|
>> ------------------------------------------------------------------------=
-------------| RNIC |--
>| PCIe |-
>>                                                                         =
              ----+---  | NVMe |
>>                                                                         =
                  |     --------
>>                                                                         =
         ---------+---------
>>                                                                         =
         | Remote Storages |
>>
>> -------------------
>>
>>
>> I just draft out an initial proof version. When seeing your RFC mail,
>> I'm thinking that SPDK target may depends on your work, so I could
>> directly drop mine.
>> But after a glance of the RFC patches, seems it is not so easy or
>> efficient to get vduse leveraged by SPDK.
>> (Please correct me, if I get wrong understanding on vduse. :) )
>>
>> The large barrier is bounce-buffer mapping: SPDK requires hugepages
>> for NVMe over PCIe and RDMA, so take some preallcoated hugepages to
>> map as bounce buffer is necessary. Or it's hard to avoid an extra
>> memcpy from bounce-buffer to hugepage.
>> If you can add an option to map hugepages as bounce-buffer, then SPDK
>> could also be a potential user of vduse.
>
>
>Several issues:
>
>- VDUSE needs to limit the total size of the bounce buffers (64M if I was =
not
>wrong). Does it work for SPDK?

Yes, Jason. It is enough and works for SPDK.
Since it's a kind of bounce buffer mainly for in-flight IO, so limited size=
 like
64MB is enough.

>- VDUSE can use hugepages but I'm not sure we can mandate hugepages (or we
>need introduce new flags for supporting this)

Same with your worry, I'm afraid too that it is a hard for a kernel module
to directly preallocate hugepage internal.
What I tried is that:
1. A simple agent daemon (represents for one device)  `preallocates` and ma=
ps
    dozens of 2MB hugepages (like 64MB) for one device.
2. The daemon passes its mapping addr&len and hugepage fd to kernel
    module through created IOCTL.
3. Kernel module remaps the hugepages inside kernel.
4. Vhost user target gets and maps hugepage fd from kernel module
    in vhost-user msg through Unix Domain Socket cmsg.
Then kernel module and target map on the same hugepage based
bounce buffer for in-flight IO.

If there is one option in VDUSE to map userspace preallocated memory, then
VDUSE should be able to mandate it even it is hugepage based.

>Thanks
>
>
>>
>> It would be better if SPDK vhost-target could leverage the datapath of
>> vduse directly and efficiently. Even the control path is vdpa based,
>> we may work out one daemon as agent to bridge SPDK vhost-target with vdu=
se.
>> Then users who already deployed SPDK vhost-target, can smoothly run
>> some agent daemon without code modification on SPDK vhost-target itself.
>> (It is only better-to-have for SPDK vhost-target app, not mandatory
>> for SPDK) :) At least, some small barrier is there that blocked a
>> vhost-target use vduse datapath efficiently:
>> - Current IO completion irq of vduse is IOCTL based. If add one option
>> to get it eventfd based, then vhost-target can directly notify IO
>> completion via negotiated eventfd.
>>
>>
>> Thanks
>>  From Xiaodong
>>
>>
