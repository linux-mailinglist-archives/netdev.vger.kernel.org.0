Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71660230F5F
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 18:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731500AbgG1QdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 12:33:00 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41024 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731268AbgG1Qc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 12:32:59 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06SGLa0T020715;
        Tue, 28 Jul 2020 09:32:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0818; bh=opLhjlTY5l3ClgjWBK8em9JNXVu/OvQwlLoy/RAnWlM=;
 b=xlo1bFL4CyNBBJPvRIpS1i62cjQvG5qPFUXTjaqzotN5cGyfE7Q639BU2wsBO4pMRsQJ
 H8bEU/fXh3I1NeynO5VN4+/uXXyKUspfDz9c2xt7nalFG5butntPllJF4p7INIBnK/WV
 Pi4DH1Y5gW5OPDXwrHhbLb1yTMDVe9ApYn8/m/hk2EDs2FUcB81rlKNaNi00LBm0doBI
 3HS6pdzdRk+Xf3DxXq+gVyD3k4cCMFNmw2VVbIzfYsdgpnAtKa61foOWLGu1MVEqXWc4
 TS77GhXzdNoLXBcj19A1zU70CF2t/vTYcaSW5nPMbb6Rbmr+rIT/dLgyMrwEIDBsPUEf MQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 32gj3qvum3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 28 Jul 2020 09:32:39 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 28 Jul
 2020 09:32:37 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.169)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Tue, 28 Jul 2020 09:32:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ifbq4FJzIU3ob++Nbzh6QVGnEWfQdc1+2K3blc4ApPXVMciuCgpwmAepOp8nIMOzwcgnoncF1l/80AGOfXfdYziEPHA9jX9q0VzKEipv7SPhoU/BhPldw8GHc7MN7hnQsBPeO8Cqbe3sAge/suE9aR+98R4J8dwEKvyJmc5mQMRs9xogzOriQhTP4XS7G0F37K1tK3JigK+mSJlivYLEIHi1xogac98+03Rupj9gXt8Ws2nRuTaIXNSyIDjx6zeJZwkifAjQHQ1BBX+CzfrjOMVjyfMEoplhJaIR24vBO7jVgN46z9eBt6V26J5imL8J2aLt2cWAXkTSQ+qgijYxuQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opLhjlTY5l3ClgjWBK8em9JNXVu/OvQwlLoy/RAnWlM=;
 b=SXGo1+ZgZgPSeTY2gwffD7ujHh8MGTujFhIIBLHlRXDs6XulU9CurZzhNBuF25gAr+7hQOS5GahGgjO1gl9Uw0I1OR9EUq+TmyQPOVJ7v15tSrHz2+9jrKDLLPJXAcVK3kQlBQen6JQfXXyO5AYvDidDgIeUD0IVcBhonHYrjZoKo4FTID3WZ8YRHroyU8Yz5pnLC6vKUoVipUTNH0kKA2Kq/BHJxtUiNMabsW3MU7Me7+YROn5CE9ta5WaivcD8a/yyqVnO4AXnvGMT5/Q5h/jA65pGiykCvvaBmF/O5Isr43/pmLJ3Pn+MuiRO+cOo3JG3fFBRRC/07B4768lLWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=opLhjlTY5l3ClgjWBK8em9JNXVu/OvQwlLoy/RAnWlM=;
 b=rA0U2+0S0BYt8iAja5dPacYe/CP03Z8eVWDAldvs/Q3YciN7n8fnnXk7nh2jjCIWsDIO3BWExflQa+jMra+hHXFiymt/ILllAPzx/mCqHy7wKIrpcLMyhDHnoA0nYtB8oua7hXhlH3vOWriHaMF0evEIf4zWM4z8T1ftXohMiC8=
Received: from BYAPR18MB2423.namprd18.prod.outlook.com (2603:10b6:a03:132::28)
 by BY5PR18MB3330.namprd18.prod.outlook.com (2603:10b6:a03:1ae::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 16:32:36 +0000
Received: from BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::bd3d:c142:5f78:975]) by BYAPR18MB2423.namprd18.prod.outlook.com
 ([fe80::bd3d:c142:5f78:975%7]) with mapi id 15.20.3216.033; Tue, 28 Jul 2020
 16:32:36 +0000
From:   Derek Chickles <dchickles@marvell.com>
To:     Joe Perches <joe@perches.com>,
        "wanghai (M)" <wanghai38@huawei.com>,
        Satananda Burla <sburla@marvell.com>,
        Felix Manlunas <fmanlunas@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] liquidio: Remove unneeded cast from memory
 allocation
Thread-Topic: [PATCH net-next] liquidio: Remove unneeded cast from memory
 allocation
Thread-Index: AdZk+tlMhJrU4BpnT4mc6tWR6ytKZQ==
Date:   Tue, 28 Jul 2020 16:32:36 +0000
Message-ID: <BYAPR18MB2423DDEA48A93DFB082C6CE5AC730@BYAPR18MB2423.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2601:646:8d01:7c70:75c5:f7c5:1663:bfbd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3c9a82b9-ecc0-44ca-0db0-08d83313d65f
x-ms-traffictypediagnostic: BY5PR18MB3330:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3330B2FA622947BDACDE71BFAC730@BY5PR18MB3330.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +xOiJKMtY/VPutiOEzVL+Iug4us2r4eWSfPbvDXUUXC1ZFeeLmGyYM5MqqED46d4nU2+iGVcAwgYyUGmcCQ4Uw63iLkKPvQQFuREk4TntidXDc6s99qrpkV0CDWUy8esIhu9L6pBnap1I+a0W6pHe2HGyrJqbhpqN4qretb5SgPsxcCVbiXPp3XowmqkfGb34Gvi2ImcVXVa++CPK+LPzh7obUnXMSjJEZdDDnP3fwGyVFBojS1WyLLMRy+omKvlJdkesUXf10xrQmli/lTb41Yp+i6VciDaz0VFSsPeEQxbkMo/YXEp1XVo+PQ9Tyk1JEDUcrJ1FJFuhUI2GVYM4w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2423.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(39860400002)(376002)(346002)(5660300002)(76116006)(186003)(64756008)(66556008)(6506007)(66476007)(66446008)(66946007)(7696005)(4326008)(86362001)(33656002)(4744005)(2906002)(8676002)(8936002)(478600001)(110136005)(71200400001)(55016002)(9686003)(54906003)(316002)(52536014);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: PlCjXzKU3xzCM7HmPz+ZEhcwHCfSKJ8Y6KGMSc3UNqxUB74dIeF3bxQU4Bx4mz8eomJWIVE8OyKi/kEQhMXOaE9Ii0svOu9Eo0n8siQGJkzgf0VbpZfH/5Tgrqh6PCOyx+sJSu8B/S2R3idMb65zDjaiYEr/muBcxDwbSXY7ISe4arviCjYgiZNgmvcLaqzul1R5ICHJ5AOh8R/w2Mn7T26rnTBBNmfrgNCMcJXuQn9UR0I7GVF76cWK36UssFOiBLrpcGy0oB8AAZhqgjH0UVLRg1g5GGQ9EFXPXtvcIkgjHCDDoizkID+nOSsb9wudpGeoJWF4kx166Y6AAGfpZo8Cc9+5jZI8TZvKMiJm0WW7PxMdxsJwT5JV5LjXbuG7TQQ/UrwE/f202IMLLwylMBgq95ahs6IAr3ntSL8RdmH70Bfmik+1N8eHNC2anE1ERfm0Uzv9M7YwaiTOhtyYZYzU5nw0H8m1CErrs2qikIH1FgNFVYzbf1OFw0XWnaqqo8W01qoyxb0cHXP+cBNn3xblf50OS2IScwFpojXWiuYM8pC4ffUb0EOGvLQRCuw3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2423.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c9a82b9-ecc0-44ca-0db0-08d83313d65f
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Jul 2020 16:32:36.6434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gJWrrKPHjHC+S6KQ0y6+C+HYODukgtjgtl3GU32nR2LddoSeNLoBylwzIIMe3cO724PASLn9m86oCwFUYvKvzw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3330
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-28_14:2020-07-28,2020-07-28 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Joe Perches <joe@perches.com>
> Subject: [EXT] Re: [PATCH net-next] liquidio: Remove unneeded cast from
> memory allocation
>=20
> On Tue, 2020-07-28 at 15:39 +0000, Derek Chickles wrote:
> > I think that is fine as well. We just used vmalloc since there is no
> > need for a physically contiguous piece of memory.
>=20
> Do any of the allocs in the driver actually need vmalloc?
>=20
This doesn't, but I believe some do, especially when they allocate lists.
