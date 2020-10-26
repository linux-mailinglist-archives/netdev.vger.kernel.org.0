Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14239298E67
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 14:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780627AbgJZNrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 09:47:25 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:13074 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1776607AbgJZNrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 09:47:25 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f96d3740000>; Mon, 26 Oct 2020 06:47:32 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL109.nvidia.com
 (172.20.187.15) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 26 Oct
 2020 13:47:24 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.57) by
 HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 26 Oct 2020 13:47:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NfcidODSZPwgM0AL0XZamMXRs/QHKaeZEHDTmL0tQ6FYo0LrTBpSObPt+jbiOBgpZGAJBEtKIUtQtrFx6zAfEYbDXqH2z8tLc8r4VoeMyC7eSxRND/yKyAMg8EaSk+gkxdsKB+FdsK7PD3O3gSgc3NbKlJReDtCuBYoYFTznLfmgbYt730XATqcwVpYqcNe75/wMetmmy0x/xO9c7ZpKXeonpZQidUH/ha4LLVWQc5xE/aQfJR1qNEAIptD7Cc3UM6tsGLI+uHplt79B4gs78u6GjN6sAOQRaWhrrQ/Z0qQ9UjgfbBa1TO4zG5NCGhebWZlQc0C0PA9pRUWl8CC/Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B4jMlmUGsAuFqtyT3V0hIWUXijmhy6tFiBn893nLK8o=;
 b=PkT+DrQwMVPAq0nF8Lqk6q6egYF8nty4MQYPI6kqTKvSMieNs83T5BU/HVPlwJA1Qy02xwHwlLlhvXPyl+ypeU5gMwtExJvTc5v7YqGQGyy3Gvuyxx7xtwvrbbeUbErUCQb/yu9dbctQ/qekTDOrXZTnAD6oB8Ln0Zt4STOD6vOYkQZdaBxugEwG0mpbRZ5Io0GVkmse6ipuEmxtgrvSWDVPlg1D+axArCFkQFUgPDV6lvrpQ8wytQHRWpNzkFiBwZj7QPTX+1rcA21yzoZr6yb5z2nXEQcHO5WxIdhNYv8W4AUqIBc3YrRVsJF5nADo5/DKTHNxM+eHiHUApvJ/Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3223.namprd12.prod.outlook.com (2603:10b6:a03:138::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Mon, 26 Oct
 2020 13:47:18 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 13:47:18 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>
CC:     "jiri@mellanox.com" <jiri@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "michaelgur@mellanox.com" <michaelgur@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace
 deletion
Thread-Topic: [PATCH rdma-rc] RDMA/mlx5: Fix devlink deadlock on net namespace
 deletion
Thread-Index: AQHWpdiUyESckSXaE0yVQeBJxm0NBamp7umAgAABsHA=
Date:   Mon, 26 Oct 2020 13:47:18 +0000
Message-ID: <BY5PR12MB4322960FBC4219A6DD7D37BDDC190@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201019052736.628909-1-leon@kernel.org>
 <20201026133835.22202-1-parav@nvidia.com>
In-Reply-To: <20201026133835.22202-1-parav@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.195.223]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78252909-c27e-4676-0a19-08d879b5a7ea
x-ms-traffictypediagnostic: BYAPR12MB3223:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB3223FBE3A7BAE3124DBECAAFDC190@BYAPR12MB3223.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:655;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TxsKu+zswedmXl52EJYOQwBO28we5+HrA0n0v3nIHYsfycUsgGlu/CzzbP4U/ccLibFyYEb3zFBwlZ8ddAy6TrgPgJt2hfb0Q6iRQJbKM2h5EGluo1w2l9N4wsaaDv81GuBgrVmW9j/eX1md5W7GVqZyMH2PBYN5Tw5MpSQBnHYwbRvQ98VSTKvuiGyvoufNSlBxgcy5VxvPytaCcnlT3IuNpo+gdd0aNEdGERrbn2bxFRndy0kI6IH/KMIwdZFinpSpwH3GfDw79iGKkyVdpmSfEZqix24eV+GvdAjiWSGWEgLHTOenofA5PaTffxD2vCyXFxRuaQBYMM00YtfpHfXDXw7y9CASpfpMb3wUn5eL6wYh5CKFkyig8YlOmnOhWwKIKWXssg+Gl3BbGLjVlQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39860400002)(366004)(376002)(346002)(54906003)(107886003)(478600001)(316002)(110136005)(6506007)(2906002)(55236004)(7696005)(4326008)(6636002)(966005)(8936002)(186003)(8676002)(26005)(71200400001)(9686003)(66946007)(86362001)(76116006)(4744005)(55016002)(66476007)(66446008)(66556008)(5660300002)(64756008)(33656002)(52536014)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ay517UK8itMrEqwjGaLB2rSTghZcsTyvtsj9gY35vhlDtCt1g3+Jv9IPHDaoP2XSJa2AsPLI5+oUxDihDHRNvFx5eBrCXfZt+5rTMsQ/8Zpz3XXc87ey0FyADWEACbkNfExL4PHvjmaJf5FTzpwjxYEaivcx3JVcKL6fhzU5YhnIk6w6wRf/aEEIxInV52O4GsEXhDwV/Dc+WFY5ve7ux0WQOtfmHPwR/kxs1A0vp1ibnYmPGxSmWZvEaBXsB4/ag2BlmNqMkXM09tsWXaQRODXwj7uOO5bog4XHL8XfL2Wxg8ePHWPQpk42baRdPlrfj5RGLheUtUtPS0NRDtA76wN3yUX6x+YKViyyPFhvfIJYQx5XH7VWTk4cK+5YA6tkfkKEPjtfFO32kIdd4le1WC2WHV4LJs+oPwqfiHeqhoUSSJXAnLfa0LdSm+95oRyVzs8xG+BhvTScrOoxngwhpxDGFJHM0W6SWACOigXcxrJre0F15eq3ptOX7eR+0328KOMdZtrMKDWjJCmWIrrNHpEl8FMsxgjFFYkhNqrEtB+EhqY31ForcXmkkq/zllglrb6nnltUZ6q6lFZfXGF11UdcYLmIokJSmLST/0FnLZwoaL8dcO52KiSDh6LdRNdwfo9hG5TzUuTnG1PCgmBwCQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78252909-c27e-4676-0a19-08d879b5a7ea
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2020 13:47:18.4636
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BQ53HcThziLpGh7JCj41WlRYrYcmKy+MiYVGLTaRn7JKVcKuzYgrKFUxDv0+T4FOYews++9CRJ+phq1sUOe3zA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3223
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1603720052; bh=B4jMlmUGsAuFqtyT3V0hIWUXijmhy6tFiBn893nLK8o=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
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
        b=S/jnluQaAsY/VY0qk+RoQBUvBV+LFfG2BgEHO6wX9QEfPbxtzjD0lotcTEAVny0fP
         VKre9fFGxsOLrZgQK2iSCVzbV7WBtgCXYUtP7589iTJBvCe8FIThHVifUMkgnpsbIV
         IfJ2NPE6HlHj6HDwTPK/1THKbG7u3vFrLsJCbv/jEQ+AoEqBOQb8++iCIwG46zWxAp
         N76nMR7DSBFL9cAFDYvoeR6gFXJFMT/syHXhNiZt9Qg6z8sUTsdDMg6Co7PYi2HB5B
         asX06KUAtC9qEIdnDM88PbCxApejKn/3/gd0XsscP5nzIA+2xPYSzh/nEGmEYkFPxO
         ut7bmjXwfKdlA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Parav Pandit <parav@nvidia.com>
> Sent: Monday, October 26, 2020 7:09 PM

[..]

>=20
> Fixes: 4383cfcc65e7 ("net/mlx5: Add devlink reload")
> Signed-off-by: Parav Pandit <parav@nvidia.com>
I missed to include Leon's signed-off and updating version here.

Sent now with correct header and signoff at [1].

[1] https://lore.kernel.org/linux-rdma/20201026134359.23150-1-parav@nvidia.=
com/T/#u

> ---
> Changelog:
> v0->v1:
>  - updated comment for mlx5_core_net API to be used by multiple mlx5
>    drivers
