Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B5929715A
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 07:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfHUFEC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 01:04:02 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:54998 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726463AbfHUFEC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 01:04:02 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x7L50oXf006778;
        Tue, 20 Aug 2019 22:03:56 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=0se5OS/zv84LQjO9svHYrr4HE4PlXeriJla1Pna3H2A=;
 b=Pi8le+Qpy9Lu4k+GZKILreeQiLuhJSmdXLx2R2r5oW86UnwKlWNi7kzaofRgcuKOsxOo
 IdQyMKrBxsr0PEFVbwczSD6A1vQ4fLdYGpluvrwWyH96Ti+3fmy+60AOLcvWXHaWSiu7
 2wDWz+XaRzk+GLjBpLhHm9pPumHVMa/zrOPhYv6wUEjHjDHPPT6FqrjxnQlipSuuHdhI
 OQd2hasWvejsZgtLNn3bXz1zJEy+aEBhX14Vxnw4dn+d0KasuEG3PzOS1kO6e8T5iwB8
 BV65jXaEjTuB2GPSpTPZIaYwv5hMkvHtPHyNFDw/xT+kf1q1fta7HhMSpTc45hmVkLWF DQ== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2ugu7frt6m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 20 Aug 2019 22:03:56 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Tue, 20 Aug
 2019 22:03:54 -0700
Received: from NAM05-BY2-obe.outbound.protection.outlook.com (104.47.50.50) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Tue, 20 Aug 2019 22:03:54 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kknxlOh5d9jKvrikGfuioEI2dGyCKQ8ZNtZp9vCQBu7QxukjyRwWBRbnHTiyAGt0k9daiuzxIUhjzPfSRLF8rkXEd3hVcih7iFUkwZykxgfKdUzHLoWpKHegzDijH7pstFR3EwMMKpNobCyiB1MWwhbr71szavsNlxi5zNY0wBsZav0M7DEobvyG0AfD0jJPQ7tWWxERnVq1A3Jm6cUZXgEdypjEVJVIs9awyRoHQza3em+1bMUKj/R0CYVHLwOvG6UV5pvMXXNmjiI/9DLLPs5qHYCK4vJUXTLB+7z5B6wqXoeDmBN60Th1I6s4gtoPhNAru3B34Id02qKx8FJMXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0se5OS/zv84LQjO9svHYrr4HE4PlXeriJla1Pna3H2A=;
 b=iJ1HCCQCV7WlI8LPVPgWF4+UChmCjOdt/ZSUYnGubbBliOvGK2mHfMRL6Jvdlva2GUU3ibISFR2LuqoKAdmROpFU1Htg5yX55gFxbe1rj8hJ54YARTYmbrWj98SauY7PCVddcowJLwCnsPmM1Roz3ZO1Eb3NS7q7DdK5zAsrX4cgWqkqEkh2hcO+UpyHIpWTTe/EVz1irWUz41DbXsjo9CuiRZh8N2N/JczqJM0DhkulfWNv8GJm3oxmRI93ySmHv2TIqbJU7alFV+HokhZv8Qc4OMJOwt5dW0HJebY3pUookbKfEah452DhMGj6BBat84w3QdJFoGDz/mOO4hKt3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0se5OS/zv84LQjO9svHYrr4HE4PlXeriJla1Pna3H2A=;
 b=eYjNnvhek9hEMritbBxREdVw9asJiXHLwO4OvHomnJECrOq4LKPh4ePNWIcj0AieveB7jTMJ+qPOaePtJqkNgHHXULL+fyW93UAUEWIU+Cjp+mwiOXOfAyn3qBqP+VJMr2QzLAfD7ohOEUMjGzFqHDkOqBkF6GcHn39OO6Jxy1o=
Received: from MN2PR18MB2528.namprd18.prod.outlook.com (20.179.80.86) by
 MN2PR18MB2733.namprd18.prod.outlook.com (20.179.21.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.19; Wed, 21 Aug 2019 05:03:50 +0000
Received: from MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9]) by MN2PR18MB2528.namprd18.prod.outlook.com
 ([fe80::cd80:d44a:f501:72a9%7]) with mapi id 15.20.2178.018; Wed, 21 Aug 2019
 05:03:50 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Wenwen Wang <wenwen@cs.uga.edu>
CC:     Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:QLOGIC QL4xxx ETHERNET DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2] qed: Add cleanup in qed_slowpath_start()
Thread-Topic: [PATCH v2] qed: Add cleanup in qed_slowpath_start()
Thread-Index: AQHVV9uErkMhUHV+uESKDd4I7CEBVacFC33Q
Date:   Wed, 21 Aug 2019 05:03:49 +0000
Message-ID: <MN2PR18MB2528CE8CB05F12BE7F23AEF1D3AA0@MN2PR18MB2528.namprd18.prod.outlook.com>
References: <1566362796-5399-1-git-send-email-wenwen@cs.uga.edu>
In-Reply-To: <1566362796-5399-1-git-send-email-wenwen@cs.uga.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2402:3a80:538:ebe7:b8f4:f7ff:f796:7d44]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fdeeb798-4fca-4c33-fba8-08d725f4f4ba
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MN2PR18MB2733;
x-ms-traffictypediagnostic: MN2PR18MB2733:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR18MB2733D5C517301B90FC758886D3AA0@MN2PR18MB2733.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(13464003)(199004)(189003)(99286004)(11346002)(256004)(46003)(2906002)(478600001)(316002)(296002)(305945005)(102836004)(54906003)(74316002)(446003)(6916009)(6506007)(8936002)(55016002)(7736002)(9686003)(229853002)(6436002)(8676002)(186003)(2171002)(81156014)(7696005)(14454004)(76176011)(4326008)(86362001)(53936002)(81166006)(53546011)(52536014)(71190400001)(33656002)(6116002)(66446008)(66556008)(66946007)(25786009)(76116006)(66476007)(64756008)(5660300002)(476003)(71200400001)(486006)(6246003)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR18MB2733;H:MN2PR18MB2528.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: iOKLD0K5J2nboHou7uIDArhCW+GvnBFQzawOmun1ZPv0JQumNOdq9qI55alhgKc+3uRwAOVkMLYEhjNqo5L+xgdZnCOsrt6axWk6bQkpzqBMZKhzzBWOXwlqrvsjfc0HJn8BlTVgLvt7qDFgv/8PnpEVteDS8TAyhRB/Lwn5H+vMM80GjBbXg2h8S5pMG4sIp1OePLYLah02jrhm3KbNqo7jCb9DS7FgGl9x/yYkmDNRb9LbuzRykSyZPnbqdWsvQurKosD9+lr0cYPaXb3RWDtW1oQw3tQUvwOuaOQUSbOUaeRYhh7M8drtxY21xYOVq3Q+aIzuOJGbNXhIAJ7oIwqw+FIxKkep16Sp5O4MIeayE2en49vYcUV1p0TQ0wy1sPs38h301mmTVkyuv4enwBwb6242xy7Mq9eBu9SO3to=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: fdeeb798-4fca-4c33-fba8-08d725f4f4ba
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 05:03:50.1638
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y19f8bmEyhiEmNB58lZkW+oCKHjO0/huLHwfI2bsldCHTsWXtkSzaGi+yTKL+9k5poGJwNw9q4WS1hW9qLdOcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR18MB2733
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:5.22.84,1.0.8
 definitions=2019-08-21_02:2019-08-19,2019-08-21 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Wenwen Wang <wenwen@cs.uga.edu>
> Sent: Wednesday, August 21, 2019 10:17 AM
> To: Wenwen Wang <wenwen@cs.uga.edu>
> Cc: Sudarsana Reddy Kalluru <skalluru@marvell.com>; Ariel Elior
> <aelior@marvell.com>; GR-everest-linux-l2 <GR-everest-linux-
> l2@marvell.com>; David S. Miller <davem@davemloft.net>; open
> list:QLOGIC QL4xxx ETHERNET DRIVER <netdev@vger.kernel.org>; open list
> <linux-kernel@vger.kernel.org>
> Subject: [PATCH v2] qed: Add cleanup in qed_slowpath_start()
>=20
> If qed_mcp_send_drv_version() fails, no cleanup is executed, leading to
> memory leaks. To fix this issue, introduce the label 'err4' to perform th=
e
> cleanup work before returning the error.
>=20
> Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
> ---
>  drivers/net/ethernet/qlogic/qed/qed_main.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/qlogic/qed/qed_main.c
> b/drivers/net/ethernet/qlogic/qed/qed_main.c
> index 829dd60..1efff7f 100644
> --- a/drivers/net/ethernet/qlogic/qed/qed_main.c
> +++ b/drivers/net/ethernet/qlogic/qed/qed_main.c
> @@ -1325,7 +1325,7 @@ static int qed_slowpath_start(struct qed_dev
> *cdev,
>  					      &drv_version);
>  		if (rc) {
>  			DP_NOTICE(cdev, "Failed sending drv version
> command\n");
> -			return rc;
> +			goto err4;
>  		}
>  	}
>=20
> @@ -1333,6 +1333,8 @@ static int qed_slowpath_start(struct qed_dev
> *cdev,
>=20
>  	return 0;
>=20
> +err4:
> +	qed_ll2_dealloc_if(cdev);
>  err3:
>  	qed_hw_stop(cdev);
>  err2:
> --
> 2.7.4

Acked-by: Sudarsana Reddy Kalluru <skalluru@marvell.com>
