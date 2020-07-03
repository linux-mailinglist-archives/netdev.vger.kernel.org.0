Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916862130BD
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 02:58:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgGCA6k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 20:58:40 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58434 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726028AbgGCA6j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 20:58:39 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0630teVv017521;
        Thu, 2 Jul 2020 17:58:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=prC9j2c78RT8i0lxdsuEsDdobZf+ZYgoRMCQLW61k60=;
 b=umiuo43oY88Ul2STtZKTam/UvC9+b8XbdGKxAUSDtOQ8Wfk12D4ejEZ9KfqwPsv1ykiK
 rTge/DbWQA+fYHHDM7/sFYcLA4+8M5JvxBYoqrr7SiqV8tLbW8h7/nyZbUDna25qGnxL
 8ydOUpwNPglcbt+e0F4V4Yrq71/ipFvV9vU9Q/kG+kN14dUMYAT2jm/42Wi6Q1ZqxK8a
 Y2FEZj/+x14Gry64pmDbim7QmZfFgGhsIBiSpa+C7a72YuK9rQA4vXrBomagnNBQ8C2o
 Nof54qTdhLopUynr/wA6wCkKPcioW/uzHY2XiPjQFYvgNbokFKRYgqflnkFGll5RjxGy YA== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 321m92sjcr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 02 Jul 2020 17:58:37 -0700
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul
 2020 17:58:34 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 2 Jul 2020 17:58:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlGcNVxuNJ9F/8RDSG+AGNrFiWo2EVI7woul8hCXKVMjVHg0CehYv6opx5mLDm42KzP//X2oV9lwuYF5rugS3tfRk4CMD+v3FMAKuPFn8G8aixMT43sQMARkjsz/MvS06CWRQqCqNDBRt2l+DmzfqNymxKhgII4PIC5zGMJ20ma5u+dm6zbTztA9Ia9C+9pNvwDUkN6KgCylDQVmIxJ75OdTsUgcQM3VkbSmS8EWfyXTt3R1sc0TVRx+z6VVqK+9mt/7H/xDs/6jYyK7IMn5jhuejJ2WM8caJVr9AND763yg4F1fh411Xu8l0KQfRPWESGiTlGGSlOYgoYXqTPV+5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prC9j2c78RT8i0lxdsuEsDdobZf+ZYgoRMCQLW61k60=;
 b=kjjHDxz3uZ9+a95wucSD7XWMiyNGM23hbCp7qokPAdKSwEh7IEyHpU7sfdIpsFiX+vit/WPiGyJXDmlaLsmU8bBAbIYLnC0p9cF/fc0a+B/sf4Ta5BXn9DGS+OjwRYCmY3v8xBegG4Rn2eMFM+r7W5AfiWy2cPZCpLrb7dAfowog9K1o8gs8hK61lrhFCtM8+fI6zMn9vsA+HpbaoYBeFeK+Wpyh89QwxEOqMzsT5PodfTbkJJJx74Jsc50aVordXUg8PUE5Y2sXCk2G90n1/RafAUBqlfzws3Gayd8ISu48Y9DEB6Di4QTmZ9wU27WwNqnfGV3Xp8IiAJx29ZRwOQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=prC9j2c78RT8i0lxdsuEsDdobZf+ZYgoRMCQLW61k60=;
 b=oeg7v1ZBBa+a/O+wdQD4qlxF4mmrGQKo3gHp/KGZCzD3Tjgv5Dzu0acLuhVDI5jq/IzknXHMNDIoeFLB3Gtfz14FLk87mubhyswxhrf5FBE1nQGfMkNvXv4OiPUVbnGdSBqMFEyu9/UcGHRUOC+g5t5NMPRzwK9Qg+q9nEofxWI=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (2603:10b6:208:a9::22)
 by MN2PR18MB3006.namprd18.prod.outlook.com (2603:10b6:208:109::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.27; Fri, 3 Jul
 2020 00:58:32 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::dcc:95db:afcb:9b1b]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::dcc:95db:afcb:9b1b%7]) with mapi id 15.20.3153.028; Fri, 3 Jul 2020
 00:58:31 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>
Subject: RE: [EXT] Re: [PATCH net 1/1] qed: Populate nvm-file attributes while
 reading nvm config partition.
Thread-Topic: [EXT] Re: [PATCH net 1/1] qed: Populate nvm-file attributes
 while reading nvm config partition.
Thread-Index: AQHWUH9qysaCM76j+UOZU3SmKSXgA6j0fbuAgACC+TA=
Date:   Fri, 3 Jul 2020 00:58:31 +0000
Message-ID: <MN2PR18MB2528A42E23CEDB4163CD30C4D36A0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <1593701075-14566-1-git-send-email-skalluru@marvell.com>
 <20200702093933.042c930b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200702093933.042c930b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [157.44.73.196]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d394429-f800-457a-9935-08d81eec34c4
x-ms-traffictypediagnostic: MN2PR18MB3006:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB3006D4394831BFDDC3E1B737D36A0@MN2PR18MB3006.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 045315E1EE
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vpF9MOI/dyzNgLf6Pypob33StNpOidpX2KuC19hWZImoyCLInC6cVlJTPTP7YjSD2wEbp1amwM6bxHLhE0TZ347dwHrE+ZEKKQdYikNh9HMOhHmKF7gYfRNdeigKvtEl6S4zgACd7iEQadVmntVPsVlyuw1DGxjOJ2ZveWvCrqMYFWCLnV/stE9i5GA7CPJtCLKdLtvWYLfa8YH3Gnk6J4x7sSmt1ajss31yzgCfV79FBtHbuHJ7SJMP52cVxnHi9N4av/TCfT1Wa7gZIuyJ5KCWeEYzvP8IofDWdEZDg568qUiRSCgGP3vJPbATwRIpXxM0PE6C6+FQTnuDgFyDkg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR18MB2528.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(346002)(136003)(366004)(39860400002)(26005)(83380400001)(4326008)(186003)(4744005)(54906003)(7696005)(2906002)(8936002)(6916009)(316002)(86362001)(8676002)(76116006)(33656002)(478600001)(66946007)(66476007)(66556008)(66446008)(6506007)(53546011)(64756008)(107886003)(52536014)(71200400001)(55016002)(5660300002)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: IQe0LBcdc51l/xoWRzeFfTecynBG2IAU4sjs8Ut6ehFj4eKpC7K6QksPKRo29IVxRrveUupP3z9fvhKYSDC3s2CffB40TFXx8jvVE7Fq0DAheyGbQCCY4qiEq3er1yYblDyMW7QivfO9vGCQ5SmlIeK/BeXMk8QsKKtB3WYEkrO83RfEaQxl0p0j/o6oyisJZLBw2XtgAnVm5uKuezLyTNoanK8zALk9zhGDTSvjTtVb0gB7ROVx1Jfdz6x7CETX+lnUcQp7cc+4ktnEgbi/iV2xr/olGFo1P/UjftVSvseLLwGBW7xWr+1yMWvnRcdwywBdmyIqxUXf9L+CGkSdsF0FQL1QoUbGQc7dnIpfGz3bNKq2ASpmMxgfocfn9DnXmXXrNJCmSyfvCUHHVi7ui/0XEGbDgtWn4USGW4b8l/NoegfAnThqeZXAVaXBpyeEE31GIYu2kNm5Eo1MCsrBHLED8v0j3RrumzLabTQ4TjE=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR18MB2528.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d394429-f800-457a-9935-08d81eec34c4
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jul 2020 00:58:31.6871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E4bxKzhLLwasoFVqJT7HrAB8G2985PutrkUSEMG6GAWSVtgMHkJtdwu08oPnsueclyeAqssFwPjF9IIjtIw4aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB3006
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-02_18:2020-07-02,2020-07-02 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, July 2, 2020 10:10 PM
> To: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Ariel Elior
> <aelior@marvell.com>; Igor Russkikh <irusskikh@marvell.com>; Michal
> Kalderon <mkalderon@marvell.com>
> Subject: [EXT] Re: [PATCH net 1/1] qed: Populate nvm-file attributes whil=
e
> reading nvm config partition.
>=20
> External Email
>=20
> ----------------------------------------------------------------------
> On Thu, 2 Jul 2020 20:14:35 +0530 Sudarsana Reddy Kalluru wrote:
> > NVM config file address will be modified when the MBI image is upgraded=
.
> > Driver would return stale config values if user reads the nvm-config
> > (via ethtool -d) in this state. The fix is to re-populate nvm
> > attribute info while reading the nvm config values/partition.
> >
> > Signed-off-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
> > Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
>=20
> Could you provide a Fixes tag?

Thanks for your review. Will add the fixes tag.
