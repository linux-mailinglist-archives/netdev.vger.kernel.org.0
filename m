Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85510115693
	for <lists+netdev@lfdr.de>; Fri,  6 Dec 2019 18:34:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726413AbfLFReA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Dec 2019 12:34:00 -0500
Received: from mail-eopbgr130057.outbound.protection.outlook.com ([40.107.13.57]:36598
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726287AbfLFRd7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Dec 2019 12:33:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FOntT5ivJaCfcT9VJBMYKFWaPeDvO6W/s//Zk1YZzaiKCfFPBdf9ufiVTz9izK3L9hgDXsmN0M8m3OfZ1j226Q7if5HUBLPfaU1PvwO/AI2oCzSThwGyO3NJSWJResljQVtdzGBGXmpLHhvvG1FKrnAdDoqLYVErKGzfhzuIJvcHt3/d+KeFzh7TmeFbT4SDEeLt/Kzxe5ns+Kh0cpQMqKGgVKPoqnvj7iOATiHqO3APL2ADquoGLWO7sfjswCuzRcU2ayBwTqkDoGs0mkNUpnZtXxW3t3u0azeyuDRlPRDNq3OnAQ0cN/WeQ/5KUu+7GigDc2j+CsjzjwPXzsjXag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAKZ0oWtelkQx810IA/Eb7iqWUUJGx792MVrIgTL1mM=;
 b=Mw3Zggrh8jy8GNS/Fd56Q2+bFOjiwgBayMT3y8Dewj1Kte8/4U6/nZtbn0WWPk2Qsmz8dzubzFA7p5G6kAXMT9sLEhT/o3yQdEH7aV5BzZj8k6OVdw0/URswJbnMDUeM+1NG7ig03q9OQFB11kuSxKRHPPopYShYG5AAC5mV8sBWkQYBh9Bbk/ZxE3S9x0tL0V1zcMdM1/TFlUk3Uy8zT/sdKG3F+ZQTm1JhRL9isVDQKXayDFr/E3YX6oev66/EqsKWMpLAwD3YHFah/cp5Um5rtdM/+7PkfxxZqKpfoquu2SZsOTWUv8nrQ4Z9SWv8chnnf9dNd4Vrx/bDPDElSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vAKZ0oWtelkQx810IA/Eb7iqWUUJGx792MVrIgTL1mM=;
 b=WACglOtTbkSjA5Dw577+Emq+ugvRA+3+OGacwrLXATDyx6OA64wIafhJeQVsHfloECuK2xWWD046/gqtxRayhzBp04PWA1KZo/QDUbDVzu/06SqJ7zRF2/YZ4TFslfvhjjLx/V7ty78emubxKBVoKsKwXePTYMbGiTnO4MvMRfw=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB5028.eurprd05.prod.outlook.com (20.177.40.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2516.15; Fri, 6 Dec 2019 17:33:53 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::16:9951:5a4b:9ec6%7]) with mapi id 15.20.2516.014; Fri, 6 Dec 2019
 17:33:53 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Zhenyu Wang <zhenyuw@linux.intel.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "kevin.tian@intel.com" <kevin.tian@intel.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jason Wang <jasowang@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Topic: [PATCH 0/6] VFIO mdev aggregated resources handling
Thread-Index: AQHViikX93ntAS7QxEa+ZUX9CByqKKeAQaYwgADEfoCAKW0u8IAA3JMAgADWE0CAAN0dAIAAnz6A
Date:   Fri, 6 Dec 2019 17:33:52 +0000
Message-ID: <79d0ca87-c6c7-18d5-6429-bb20041646ff@mellanox.com>
References: <20191024050829.4517-1-zhenyuw@linux.intel.com>
 <AM0PR05MB4866CA9B70A8BEC1868AF8C8D1780@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191108081925.GH4196@zhen-hp.sh.intel.com>
 <AM0PR05MB4866757033043CC007B5C9CBD15D0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191205060618.GD4196@zhen-hp.sh.intel.com>
 <AM0PR05MB4866C265B6C9D521A201609DD15C0@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20191206080354.GA15502@zhen-hp.sh.intel.com>
In-Reply-To: <20191206080354.GA15502@zhen-hp.sh.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [208.176.44.194]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 908fdc5d-7605-4318-6940-08d77a727701
x-ms-traffictypediagnostic: AM0PR05MB5028:|AM0PR05MB5028:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB50287019BECB1478822CBA46D15F0@AM0PR05MB5028.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0243E5FD68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(376002)(396003)(189003)(199004)(13464003)(71200400001)(316002)(36756003)(5660300002)(2616005)(6916009)(81156014)(4326008)(81166006)(8676002)(229853002)(71190400001)(305945005)(86362001)(2906002)(8936002)(31696002)(66446008)(66556008)(66476007)(6506007)(53546011)(966005)(76116006)(31686004)(76176011)(91956017)(6512007)(26005)(186003)(64756008)(66946007)(102836004)(6486002)(54906003)(478600001)(99286004);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB5028;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hb7Ff16AouavwMPOSyFd6Tnj/wVu7vHGuTGXBbWn3dK4CPKNo/BVN+B42PP9mbw4Xhuq8CBf4uCYb8fopmvV86OMmoOAVEzhM56Arw9XTWee2CDzMdvvRl74K8xQ9TcqMW652tLVw/lKIh8RpKzWyN6e/qMDLmMRbSrlLNgTHHu1sECl+zQ6+wv54FhLMTzBJYb8CFZsui/zxjdUtlV8dEUzqZdHq8BQ5tBNuuz5vW+upzYK+2hzNREYz2FpEKJJnV2dKewC9fZYuzkZ7vqkTE5ZkjWdZkjx+2zdCXt85A/ur8oXQYYAxMTds/xA8zx0QQXSR0kmLM6iwlCxFyGZY9HZY2aspkPeXEkvXnkKVvz+CaXZhXYuQMObLrUeOd2/NbpyARHSr/vkIRESDutb6mG8H/SSnXE8j/31EyRZuRSepZSikNeSGe5Rhhkj/RiRQ4/3GU0PBZ16/0dVJVSbS6sNgvR+RNbwSB8s3Xrt0aRT8QQ27/b4SwqVrvnyaqr/WD9JbhlHrcBtoFaCgjIK84qqiPfnT//TlTyAqZ6gR4M=
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <60C677C4420B3143B19C5A9F95F66D38@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 908fdc5d-7605-4318-6940-08d77a727701
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Dec 2019 17:33:52.8811
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TWwZqlRdjpp1x56x0wplgj/pJff56HPd/PsimPlpLSBzhn21cZfZeZ+opB5QJQ664tnPWyZ4FwCP/M1QByTmbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB5028
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/6/2019 2:03 AM, Zhenyu Wang wrote:
> On 2019.12.05 18:59:36 +0000, Parav Pandit wrote:
>>>>
>>>>> On 2019.11.07 20:37:49 +0000, Parav Pandit wrote:
>>>>>> Hi,
>>>>>>
>>>>>>> -----Original Message-----
>>>>>>> From: kvm-owner@vger.kernel.org <kvm-owner@vger.kernel.org> On
>>>>>>> Behalf Of Zhenyu Wang
>>>>>>> Sent: Thursday, October 24, 2019 12:08 AM
>>>>>>> To: kvm@vger.kernel.org
>>>>>>> Cc: alex.williamson@redhat.com; kwankhede@nvidia.com;
>>>>>>> kevin.tian@intel.com; cohuck@redhat.com
>>>>>>> Subject: [PATCH 0/6] VFIO mdev aggregated resources handling
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> This is a refresh for previous send of this series. I got
>>>>>>> impression that some SIOV drivers would still deploy their own
>>>>>>> create and config method so stopped effort on this. But seems
>>>>>>> this would still be useful for some other SIOV driver which may
>>>>>>> simply want capability to aggregate resources. So here's refreshed
>>> series.
>>>>>>>
>>>>>>> Current mdev device create interface depends on fixed mdev type,
>>>>>>> which get uuid from user to create instance of mdev device. If
>>>>>>> user wants to use customized number of resource for mdev device,
>>>>>>> then only can create new
>>>>>> Can you please give an example of 'resource'?
>>>>>> When I grep [1], [2] and [3], I couldn't find anything related to '
>>> aggregate'.
>>>>>
>>>>> The resource is vendor device specific, in SIOV spec there's ADI
>>>>> (Assignable Device Interface) definition which could be e.g queue
>>>>> for net device, context for gpu, etc. I just named this interface as
>>> 'aggregate'
>>>>> for aggregation purpose, it's not used in spec doc.
>>>>>
>>>>
>>>> Some 'unknown/undefined' vendor specific resource just doesn't work.
>>>> Orchestration tool doesn't know which resource and what/how to configu=
re
>>> for which vendor.
>>>> It has to be well defined.
>>>>
>>>> You can also find such discussion in recent lgpu DRM cgroup patches se=
ries
>>> v4.
>>>>
>>>> Exposing networking resource configuration in non-net namespace aware
>>> mdev sysfs at PCI device level is no-go.
>>>> Adding per file NET_ADMIN or other checks is not the approach we follo=
w in
>>> kernel.
>>>>
>>>> devlink has been a subsystem though under net, that has very rich inte=
rface
>>> for syscaller, device health, resource management and many more.
>>>> Even though it is used by net driver today, its written for generic de=
vice
>>> management at bus/device level.
>>>>
>>>> Yuval has posted patches to manage PCI sub-devices [1] and updated ver=
sion
>>> will be posted soon which addresses comments.
>>>>
>>>> For any device slice resource management of mdev, sub-function etc, we
>>> should be using single kernel interface as devlink [2], [3].
>>>>
>>>> [1]
>>>> https://lore.kernel.org/netdev/1573229926-30040-1-git-send-email-yuval
>>>> av@mellanox.com/ [2]
>>>> http://man7.org/linux/man-pages/man8/devlink-dev.8.html
>>>> [3] http://man7.org/linux/man-pages/man8/devlink-resource.8.html
>>>>
>>>> Most modern device configuration that I am aware of is usually done vi=
a well
>>> defined ioctl() of the subsystem (vhost, virtio, vfio, rdma, nvme and m=
ore) or
>>> via netlink commands (net, devlink, rdma and more) not via sysfs.
>>>>
>>>
>>> Current vfio/mdev configuration is via documented sysfs ABI instead of =
other
>>> ways. So this adhere to that way to introduce more configurable method =
on
>>> mdev device for standard, it's optional and not actually vendor specifi=
c e.g vfio-
>>> ap.
>>>
>> Some unknown/undefined resource as 'aggregate' is just not an ABI.
>> It has to be well defined, as 'hardware_address', 'num_netdev_sqs' or so=
mething similar appropriate to that mdev device class.
>> If user wants to set a parameter for a mdev regardless of vendor, they m=
ust have single way to do so.
>=20
> The idea is not specific for some device class, but for each mdev
> type's resource, and be optional for each vendor. If more device class
> specific way is preferred, then we might have very different ways for
> different vendors. Better to avoid that, so here means to aggregate
> number of mdev type's resources for target instance, instead of defining
> kinds of mdev types for those number of resources.
>=20
Parameter or attribute certainly can be optional.
But the way to aggregate them should not be vendor specific.
Look for some excellent existing examples across subsystems, for example
how you create aggregated netdev or block device is not depend on vendor
or underlying device type.

>>
>>> I'm not sure how many devices support devlink now, or if really make se=
nse to
>>> utilize devlink for other devices except net, or if really make sense t=
o take
>>> mdev resource configuration from there...
>>>
>> This is about adding new knobs not the existing one.
>> It has to be well defined. 'aggregate' is not the word that describes it=
.
>> If this is something very device specific, it should be prefixed with 'm=
isc_' something.. or it should be misc_X ioctl().
>> Miscellaneous not so well defined class of devices are usually registere=
d using misc_register().
>> Similarly attributes has to be well defined, otherwise, it should fall u=
nder misc category specially when you are pointing to 3 well defined specif=
ications.
>>
>=20
> Any suggestion for naming it?

If parameter is miscellaneous, please prefix it with misc in mdev
ioctl() or in sysfs.
If parameter/attribute is max_netdev_txqs for netdev, name as that,
If its max_dedicated_wqs of some dsa device, please name is that way.
