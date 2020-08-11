Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07E74241A52
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 13:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728730AbgHKL0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 07:26:25 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:7206 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728423AbgHKL0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 07:26:24 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f32802a0000>; Tue, 11 Aug 2020 04:25:30 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 11 Aug 2020 04:26:24 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 11 Aug 2020 04:26:24 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 11 Aug
 2020 11:26:23 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 11 Aug 2020 11:26:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PT54Lv7Lj5GVTOdk3An7ZtgQR466RZLMswdffvHAuorsAcrMkWg198kQjkq3MwO+XCI4Y7Y6MVcKMBfZKie/qu5dXzeCOdDqHMmIqEDZKfqr6/Vg1nZqwVqa/YsP0DO6oX0nz6atuOqs3OxqTwD71gw6X6H13zJUu6ASFA1+ZUt8KS2HCIFwUFijE0l6NEmFkpRax8OmpNYzq/MTC6D7FWXMns7NkvUkyG1qmbI+P8R2bfF7xsSpJk+oS/LU9+tvkUXHL6lWWcpADXGf1Ah5OwsrKAcUELjauM7RXfSK9ayoWcqLApCfmgKkdf0YtB1m1dsyhl5CmY7pkDQZLNOjzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cvlcm8bIpJIzZmjcvYYNBnuPX4zNBpqCbgAxDft/c7Q=;
 b=gXoK4uHwJdc7Q5OVGqAE8BxHVjVDY50/AKdYtlaiSGDw7tKIgzerG87kUjD6tniiNHirGAVzRXW9wpMnfQmoBypr+i1waP/inYClipDgME6UepSOUsNva4wmLIu5XPTKyi8qERIzbNYzdTLFR2upBcDASI049Xjwymo9VGg/+Lnus5i+Hwbs5meu9CK6iGIJjaZEo7KBL0q2CZ3P2jkDFUg2EcB1WXk7w7VE/P3jUbAe49SGOtb2E4dVQWTbNfjPUfJL+YuhdONpK6TVX4aprfXymLLHf/5fPcLE486Dj55TCcNW9V3WEgxR5LWPAK6mlNZgGhjlvp9xDYdJ0yfbSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BN8PR12MB3425.namprd12.prod.outlook.com (2603:10b6:408:61::28)
 by BN6PR12MB1348.namprd12.prod.outlook.com (2603:10b6:404:1f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Tue, 11 Aug
 2020 11:26:21 +0000
Received: from BN8PR12MB3425.namprd12.prod.outlook.com
 ([fe80::8941:c1aa:1ab4:2e39]) by BN8PR12MB3425.namprd12.prod.outlook.com
 ([fe80::8941:c1aa:1ab4:2e39%6]) with mapi id 15.20.3261.024; Tue, 11 Aug 2020
 11:26:21 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eli@mellanox.com" <eli@mellanox.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Majd Dibbiny <majd@nvidia.com>,
        "Maor Dickman" <maord@nvidia.com>,
        Shahaf Shuler <shahafs@mellanox.com>
Subject: VDPA Debug/Statistics 
Thread-Topic: VDPA Debug/Statistics 
Thread-Index: AdZv0SSA/p/JVf9BSJCSJo3Lye0OEA==
Date:   Tue, 11 Aug 2020 11:26:20 +0000
Message-ID: <BN8PR12MB342559414BE03DFC992AD03DAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [37.142.159.249]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 98b0ba9a-67a8-4316-7428-08d83de95f8e
x-ms-traffictypediagnostic: BN6PR12MB1348:
x-ld-processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR12MB1348E1643B553221D8F55673AB450@BN6PR12MB1348.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +UQz+tBV3MkozBW09Sqp1k3RfloUg7mGL5gC6Yip7+7CWHlJwspobH8r5np8QFtCODkwBWl/KbN/BaXPJ/xsMIn2ugVfmltVvOTi9RxCjp7zM3ftasz81BeySoBBfT8EX+oCUu/U8y3Di/jp+SNAi3lBoJonaT2EyrMvjNCRbCI2dXzO2R6cZGRR/Fgp7KyPj2jDjcpVWS1FcZMqLawyIOkJHQ8O3JlnwhLXGZw1tbZz+wfhBnhjT7oQLz3PQJuni/iiuKX1+DPBRkBGH4OtJUZUy2dbXailGuanFGOVbqbr8zRJ6l2uR6YZniC03WRNzxWUXdKxLGKFbnzXutFBmA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3425.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(66476007)(64756008)(66446008)(52536014)(66556008)(4326008)(8676002)(2906002)(186003)(86362001)(4744005)(71200400001)(107886003)(33656002)(83380400001)(6506007)(5660300002)(54906003)(110136005)(55016002)(26005)(8936002)(7696005)(4743002)(316002)(3480700007)(9686003)(76116006)(478600001)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: nYuHAcmJkwSUszewQEtAt5gChOtefuAmdxYfGoy/Xzm6WNIXnIU4gHmintedIEkPliWSkvDmEpvlUl5KBLmu3RacWiLIPz8iyEZ5C5jXGT6AkULAm+BMYa3OWdfh4kcFv7oGoqvd9Rdbv6ZLZ8P5JbJCwtK7RxOD7y9+hD58N6om/IYSuudw9t/pJOLtcgMTo3vSVnRIlz82rxGaTQRCgeO4cmUex3j+Nd50w1PSmU+V0sqw/fNcuPzmwsXstrS7kI3TTZmhiFLmcFGPb+yrnVeYWz3+72uOFV0vgO1/e0PCt2ua1RarBwrhX4T9Ra+lqe/gJ/ZrlswZNGSH3+tIr4cKc2bLTcyS6ShqBoDNgZ83h0q6Lj3XC/opuNAqb522i9DyzsEEr6WsQq5WQjqbB3RXKBNoGmgGU/uhInY7yVMMqFbRPIsYdhYdqgpDHtYxo/1maGhrTt7KQviQQhm7oWgH/5G0IWAVOqBvcXQHT8Vsd9ONd6eW4DUDCxIibuw5ypBZ+qE6RjCO859c392Q/qV6OvxvVZ80/ffRqJZHDojn6C5K0XhVsez7AgIDWfSZ6N6/l6RkP/GiNDxqptVYXX2ixCToIJ/aTs7kr/R7ZSIEqHwuuaVMH3DpzGTHxbBYSMoO/QFK2pJoK/UKtrMx+A==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3425.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98b0ba9a-67a8-4316-7428-08d83de95f8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2020 11:26:21.2081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ib3EjQ0O7FAZdK8hRcj1T1kC2COHe20oaGUTrvOkt8+6Nsq3w/KsEO9LUYlx8AHK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1348
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597145130; bh=Cvlcm8bIpJIzZmjcvYYNBnuPX4zNBpqCbgAxDft/c7Q=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ld-processed:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Rt/DpGUzm15S7awQ1fc/70TnpQNI1xwln0XrKzynW4AmSUhe0OWa2XT69/Icst18+
         zDUx+JdJuqwHA61/AKBYsJ3EzRjB4/5Gy8NpXaXIVOLljFtSSK9RawACm07gubFRdF
         OXgln8f4+LTlpwWTFv7kpaNbFJ8Ve2BMYy4AC51XrSqUgW9D5HWqzoyUKg6ySLkzcU
         Z2N3X+UukQ4kCUItXK+xueYWEmpGm+n6GFindW2j1R1LSnS5GIuujsXVgP5GC2fiye
         J+HOCHfBBABlF2+sE9IVtvAZxO/6AIJ7jQg0w/tYOhX5D3tknItNufCOJFjZ+k/hRf
         6TvRmmqQA6PRA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All

Currently, the only statistics we get for a VDPA instance comes from the vi=
rtio_net device instance. Since VDPA involves hardware acceleration, there =
can be quite a lot of information that can be fetched from the underlying d=
evice. Currently there is no generic method to fetch this information.

One way of doing this can be to create a the host, a net device for each VD=
PA instance, and use it to get this information or do some configuration. E=
thtool can be used in such a case

I would like to hear what you think about this or maybe you have some other=
 ideas to address this topic.

Thanks,
Eli
