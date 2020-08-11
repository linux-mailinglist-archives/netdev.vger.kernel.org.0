Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68330241AB4
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 13:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728859AbgHKL61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 07:58:27 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15065 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728469AbgHKL6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 07:58:25 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f3287d40000>; Tue, 11 Aug 2020 04:58:12 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Tue, 11 Aug 2020 04:58:25 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Tue, 11 Aug 2020 04:58:25 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 11 Aug
 2020 11:58:25 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.174)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 11 Aug 2020 11:58:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hl90s2MeFEmcQGDLUIC5C48oxHaBHpAq3hgYpWpFEgCmDSExArKZuXmeBxZWt+3Xdg5XbS/bZSXjE88hzPPEhLCUVVuSls93qfM/noXjyo8dSW8JX3WmNuykdeO4I1yv/j+VSGOxNxtAq9RmBkmpOlTDTfKclbF0amKzc+zZV62vWVUgErIqw/AvUm4gzoPYBs63SsTreffquO+ElJSYCjvdC7kIS36l9KZgBqQIwUpX/VLWQU2y3oT8LPQcbufDEFz7h+DORYjQ80lzocc79OB7wzkSlRvmW7TN26f9kowcsrgSAB6lJIFKtY87AUN53FWOGucpOTtpeFuwS79ryg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f6ZQZFJWx5F3kfEGWwVFTMFrnC4Q9OeREi5+g2wW5p8=;
 b=GM9+pX9Zb1BP4m9K53TxSicqY7Aqij/dbmkT3S3UUkHjMQdSaIHaQ8r2y9CqxwfXfXSWgw+FStquKuHnduNzMG5BHBFHmkvREaii80J2FskPpnW1UXdFa+HVHKE9BTg0E+QPC8KdsdvnIt5L2Pi6kG/YFgUEuVrk5OFLCZ+MB3X/XXMx9qrY4cpPPiZ8dfwtjnWAEo+b4HrKK87eCuJy7kwsychS+QlwOQrBmp4m+64C+14ukbxpIpwLRGoZ/qgNYIfYM1MVf7ul9at+UOqxGmj2cQAijGE8YXwki2hyQEioaXwwXScXQ7nzcJKUTE8ychPfh93LrNNAaRC0Bjlwbw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BN8PR12MB3425.namprd12.prod.outlook.com (2603:10b6:408:61::28)
 by BN8PR12MB3124.namprd12.prod.outlook.com (2603:10b6:408:41::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3261.19; Tue, 11 Aug
 2020 11:58:23 +0000
Received: from BN8PR12MB3425.namprd12.prod.outlook.com
 ([fe80::8941:c1aa:1ab4:2e39]) by BN8PR12MB3425.namprd12.prod.outlook.com
 ([fe80::8941:c1aa:1ab4:2e39%6]) with mapi id 15.20.3261.024; Tue, 11 Aug 2020
 11:58:23 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
CC:     Jason Wang <jasowang@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "eli@mellanox.com" <eli@mellanox.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Majd Dibbiny <majd@nvidia.com>,
        "Maor Dickman" <maord@nvidia.com>,
        Shahaf Shuler <shahafs@mellanox.com>,
        "Parav Pandit" <parav@mellanox.com>
Subject: RE: VDPA Debug/Statistics
Thread-Topic: VDPA Debug/Statistics
Thread-Index: AdZv0SSA/p/JVf9BSJCSJo3Lye0OEAAAhW8AAADKLnA=
Date:   Tue, 11 Aug 2020 11:58:23 +0000
Message-ID: <BN8PR12MB34259F2AE1FDAF2D40E48C5BAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
References: <BN8PR12MB342559414BE03DFC992AD03DAB450@BN8PR12MB3425.namprd12.prod.outlook.com>
 <20200811073144-mutt-send-email-mst@kernel.org>
In-Reply-To: <20200811073144-mutt-send-email-mst@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [37.142.159.249]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 026cd186-1bf4-4009-e71a-08d83dedd97f
x-ms-traffictypediagnostic: BN8PR12MB3124:
x-ld-processed: 43083d15-7273-40c1-b7db-39efd9ccc17a,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR12MB3124703A07615E0E89BE17FBAB450@BN8PR12MB3124.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X1hjGoI4Gc0Qa5CD/tIjZJA6amEcMKuBQAV9AjcXtDaEgvXSuUai0ke20qNvXstkWGvellE/043d1773gVwVLb8xUy/mWMuMj25YXNZfw1MmjIAnPCadbvpFZbZkeN4pVcvS6YReWwf+cqmlOfxK1P/TplRdpcNcnsg431nmHfy/gWmKy3iKKh6S/NB6v2MXhef9L9zfqTi0ScEy32HG1QFJmg1JUWVp+oJobfdH8kTglIw7VNbM0r4kBIsymlCC06i3QHXwUQNBObDNziU2sUCblJJ7BQXYH2PGc4Zos90QhQftqklbE4JsXjbRvtg29Uhh+mlW4HUqMHgyC9/xOQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3425.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(346002)(366004)(39860400002)(396003)(66556008)(64756008)(8676002)(76116006)(66476007)(66946007)(83380400001)(8936002)(66446008)(33656002)(71200400001)(86362001)(107886003)(6506007)(55016002)(3480700007)(5660300002)(4326008)(52536014)(54906003)(9686003)(2906002)(186003)(7696005)(478600001)(6916009)(316002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: noRbEu3USd1MGB51yHIvemE1J7PRpaItdSmVAp86UqEKCW4AV49uUd+Ukslk2KMJt7R7jWW1Gtx/a2oYeUdlJ6Et9yb4j6ZkCoxWHM0r9mFpoOCCtDcS2z2aCPLLk2kyJbjRz8rndh02qzOuUKsoM9wEPBjCX79UcxNFsryCRMRIpreMPW+8bipsdebdBJ3s1oXjMdte9ciF6MnjV+zsukdQnB70M1oPX8Hsn0JQu2go7TOaLTVH5yV3hkBW5vfY73uxr4wGhLmSMuhjQADyefTwiDVvxn2hzPcL3RHgLs4/h2Bd11VxHaWBRyPJC0DJVrJNiWMOeCFDS5ezqHhpZewvcZvTFnpDhdyybOHKZBAywz+AJq2bT2uXOC1Bg5GM/IIoxjib2eySKoQp+Zjc+RKAVS7V+nQbIoth9pWdZ5QV7tIot7ogVFJw4hFs3fLzpgz0f/HA/gH1WZ68wN07ynlfLfqN/lG9fuKfQjRfga8A+iPKBVculbOCCg4/dqllkSMF9Xht7rHPYNC2DsXhTgRVnxbk6l+HMgmU9zLdVAkNcefF6vf3iSOH5OeZboKVfoPZoecG/nXeYzBUNHT4RTO6XTgEeOS3FDR3mZotd7l+CUZEJMQrH7IK6qPpIDvyTjfNvTDRPMSNHDPgwNuxBA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3425.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 026cd186-1bf4-4009-e71a-08d83dedd97f
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2020 11:58:23.8017
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Sh1TaJTzGiy8CvE8uUte9TOYrCoCQpdTsHeDQ+GkJ6XGj8cuf+fZlK1bIAMc97Gm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB3124
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1597147092; bh=f6ZQZFJWx5F3kfEGWwVFTMFrnC4Q9OeREi5+g2wW5p8=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ld-processed:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=P3BLAikVvSqIO4qoEGqR+PzaHyg8fkItfWCpFRUPAiAdUGC/23op/TjdPeuOIfTry
         TfamnzXlZJ32YDtruH72hPOuxZhj169FHCyo3ijBA2kHCEi4HnNpbNbfG/wYKHUw46
         E3tOcrxihMCr/7jjWvniyA1pjPO/QnBscpPDsnyIipgr5dY6G8gWYT6rs/fkIfbLxD
         5/f1f2/LTwKcB424Mna6eJWNXgbwE77wXZW7Syfbs+k3DIziuMW8jbUqbzks+3hoz7
         R56NrpybVphvduVmzPVTwWGOwPQgRShYzkLfKxL+tnq8X+duGreosCgw0g1U3ESHZk
         ph5MLpq2haKZw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 11:26:20AM +0000, Eli Cohen wrote:
> Hi All
>=20
> Currently, the only statistics we get for a VDPA instance comes from the =
virtio_net device instance. Since VDPA involves hardware acceleration, ther=
e can be quite a lot of information that can be fetched from the underlying=
 device. Currently there is no generic method to fetch this information.
>=20
> One way of doing this can be to create a the host, a net device for=20
> each VDPA instance, and use it to get this information or do some=20
> configuration. Ethtool can be used in such a case
>=20
> I would like to hear what you think about this or maybe you have some oth=
er ideas to address this topic.
>=20
> Thanks,
> Eli

Something I'm not sure I understand is how are vdpa instances created on me=
llanox cards? There's a devlink command for that, is that right?
Can that be extended for stats?

Currently any VF will be probed as VDPA device. We're adding devlink suppor=
t but I am not sure if devlink is suitable for displaying statistics. We wi=
ll discuss internally but I wanted to know why you guys think.

--
MST

