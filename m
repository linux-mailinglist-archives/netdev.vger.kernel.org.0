Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC7C54629A8
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 02:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236113AbhK3Bam (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 20:30:42 -0500
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:14012 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229459AbhK3Bal (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 20:30:41 -0500
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AU0VoRl020993;
        Tue, 30 Nov 2021 01:27:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=0pKrLXI7c5oPGJQDoNbRIQxNKz9aQZet2QCoppc4t/w=;
 b=Fzo4gRbyiZsxMlwcd/WC5iTnJ6MfACTHHIyuPxIxsTUm7KOK4Oe9zhZ2AZ15PfTgTtRP
 LqUoUV5UvCgffyAR0LbvfaxAXQEw0NNBbOIFRklJM44g+q1DAhF6LXUiiSO+2hkmkYRB
 nx8RExls/V+YLTG3afArRRmXjkKjJH+F/Mf0z1jKUAutaVSQ1UwWj6dPTxyCXzKCrQZ/
 ZBP6cP4awKVNgERHRKNjLFaguGEK3oqp9erI/Hkjy7TMxaPqnOWrmpsTZE8jTMNJHRlg
 3hV4TPY+RIv/yQzhIfLGFQbW2rNAjhipmPsr9WZyNETxyphnYKTvMmuK2gxyNdMdCAbe cA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3cmvmwnnsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 01:27:15 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AU1G5Z4171239;
        Tue, 30 Nov 2021 01:27:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3020.oracle.com with ESMTP id 3cke4ngwqr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 01:27:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UPu5d1fKK18S/YpvlbuDxWqndujVF4N1bSFTkrD43H6zigJ4bC/vVizpOO++fddOUv5Hb+tuQeYkz5biV7gac52/8HGMB4GkYXNrZMIm1hig5dzlmETuL8VEzeNbTgXHHRXUOoyfnt7GrPaJ9QiRo3fNmn2ro3dPWSlP6C56qpMacT6lOhV+lenYh7NR7tsjaRBtkSFrjD+11RjO4yF36jmlSyEgDc3WKy8lxt2wxZyUIx/52jdcuWM2xaSsLIrpaoMPzmY7Snt3itobQ5ayP5ki0uNXmDCUN39cNxLf2ncE8C7iXQOv63wjfEBgfg6vqgxViPEi7W001TPT3E1qTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0pKrLXI7c5oPGJQDoNbRIQxNKz9aQZet2QCoppc4t/w=;
 b=QwOWCfGvaC46CUc1of+8NzTgg8yQ2u3Ka/g/dg/Fs0lp2i8FNJ+OUx6G6ID4HystmoNZJpyXj++OSLMUD5U8AEmLBax055n+2blQmHoFeEF2rmlArbb4WmXSLfrjwMgHqyc5fpUzL07MwLVcI8cP0DzrciQqhD12WxrJRFgRZri4v6toxI1l4QJoArxE78vWaq29Xwl3DHAKNgTWh0Rigrt7UjTtllcBctj4Coxk3na1pqskdicR6e2wYyHfaQT7UGwSFrLsTGkgFj94mkIjDkxOwnLPvMcK+rO+hC205jEpIV81IW3wwTAYkqhZXkN4lSahc2DdNDFwg1bFpeYBZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0pKrLXI7c5oPGJQDoNbRIQxNKz9aQZet2QCoppc4t/w=;
 b=KS4phsPoY2H5O3lkTQ+vS0msTkhMSDYp21xK82vCwpLJ6WIGHCrnCoSUL884Vl/IT2mCcsiK/BY9ozwJWU6xx3BonoPVstfZcVdvbU2u0zmS6YtnhnGBkkfEuev5OeOYuKtGpEB8fimZiU3hLU9tdN77nudZXfCAwtNlHH54+zw=
Received: from PH0PR10MB4504.namprd10.prod.outlook.com (2603:10b6:510:42::5)
 by PH0PR10MB4679.namprd10.prod.outlook.com (2603:10b6:510:3c::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.23; Tue, 30 Nov
 2021 01:27:12 +0000
Received: from PH0PR10MB4504.namprd10.prod.outlook.com
 ([fe80::d197:3d27:4962:ee8d]) by PH0PR10MB4504.namprd10.prod.outlook.com
 ([fe80::d197:3d27:4962:ee8d%9]) with mapi id 15.20.4734.024; Tue, 30 Nov 2021
 01:27:12 +0000
From:   Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Scott Dial <scott@scottdial.com>,
        "sdubroca@redhat.com" <sdubroca@redhat.com>,
        Konrad Wilk <konrad.wilk@oracle.com>
Subject: Performance regression in "net: macsec: preserve ingress frame
 ordering"
Thread-Topic: Performance regression in "net: macsec: preserve ingress frame
 ordering"
Thread-Index: AQHX5YddfrpFH3ehA0ap9y1TavcaGQ==
Date:   Tue, 30 Nov 2021 01:27:12 +0000
Message-ID: <PH0PR10MB4504FA1F6C46E49CFD71D625AC679@PH0PR10MB4504.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 56dc6fc6-e875-f529-4000-d372055ca7be
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 862e53da-0b04-4c4d-d106-08d9b3a08925
x-ms-traffictypediagnostic: PH0PR10MB4679:
x-microsoft-antispam-prvs: <PH0PR10MB467931738383CB6BCD1B69DFAC679@PH0PR10MB4679.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GpEGIOFMiLSuXE7UEDamz1yFlMrpYyQRjBdfVs0eCRbVe5Z6OxmwA2Qeu08nIXrbm05FmtTEj5/cL2MclYykRbzOWTm4zM7PGeiD4ubAy52pEidu4LkF+tRSd+QdoPR06uNkPL572ZDQvGvale3msBd+qDBt1ISZjl2Ic5y11Q033nDwc6KkzDdp2JHNoZJVTkAtOtyWNAYI0Ge5s9lnc1YAhosQ3iwV4D7Plo/JCMcUrKEPCXpbmhfFKGKyWLvdKFPZxIZtt0C5UTUmdICRzXbzeQ/YDI6WlAHouSPuxNDwRd5gfj1gWYkKSMBgioXoPt/nNlKJ0MjEf8dMi1zMnsvGEbaqPDb0zns//u46alOm4IiAJ9daMgJFknjLQXhAh+GOQbE1elCieNKkib5+htiMTT8RmvPvcY8XNS38N0c7TnOuTYkmR6+pJtcqDNwGgPhv7QB+X0XorlsL5YS6D/KW+IGXLKJ/z+lMweLeErFQ1JtxIMHobgSWU0I+iSnYGxRns4oJ91PgUgQcvyI8+jzxrEuf/CVMwBTr+jweriuYN6wiFAN/NVa6LKe7DdC8wW9GRnTAzdFYy5ujCUqUWq+FEsSNiXiUZedlBdBQ7cHfRYpS8TFI93HMHqB4IIWMY/uqk5foiV7ibMFxUB1b0IFWFybfLJvhoyAAzFeTtOHEsD/ta5igTqFzbPrL8GmZ3PNJ/Q5PebEwzc0rTi6GKgQv2olChdfdpaF776Aj+t7rNCGqSDMK5Ucs4Dg18l/7sQxmOWQS+QHz+KMrrrg0Quk5KL0BhESh6geakSfDvsY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4504.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(2906002)(38070700005)(55016003)(38100700002)(86362001)(9686003)(26005)(66556008)(66446008)(66476007)(76116006)(6916009)(4744005)(66946007)(64756008)(8676002)(54906003)(107886003)(8936002)(83380400001)(71200400001)(122000001)(4326008)(52536014)(316002)(508600001)(5660300002)(966005)(7696005)(6506007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?NXl21luNJrxAYqshTG8E4P6PwSJBs8KpULzUcGGrwKQ3In7Oaiu6/EUN0W?=
 =?iso-8859-1?Q?7a4iwAAJa5wxUgaNtq+HjNphO8CfZzqWvES3JF+E0AZTStuNzZzdPX+c/V?=
 =?iso-8859-1?Q?hfbgjeqo0H/Cd3jX26P+P8neIxY3EzsBpie07GV5Ix9AChagLVxdQyEu8m?=
 =?iso-8859-1?Q?yB5LacwmVTDxi0/o2ZuTbR4FkinEIzGhfqLYSIu3lhTftLJwG5R3r7rgde?=
 =?iso-8859-1?Q?L4MurWsolcyERH/2URzNKRf3iKUjmekM1eeifV4aKfAE0G5vTJYj/FNTzc?=
 =?iso-8859-1?Q?Q3enNnNRF4auz2k97YCmXDYiK6cAmly/9AILYMZ9lTVHJ131bBFPiG3BxL?=
 =?iso-8859-1?Q?Tek9hvpi3kAzrhYIQKGWzg60W1/BgIaqAupLfiZpmHQOXBwK+tqfew68gM?=
 =?iso-8859-1?Q?VUjLmpDh11jmwyQgzng3SNaie7wSOELzYbY1nzPTfR42vkkyiQKyVNNxDE?=
 =?iso-8859-1?Q?MM4170Lm35TA3RW+tCgf2dwWg7bTpk+SVhpvlPt30wNEqqHJakvHTwnK+t?=
 =?iso-8859-1?Q?pgBtXZ7OgS3QZUOggB6SwaK4fwS7QN5aswPLD5rhWalRdgVZHtFhU+I0dy?=
 =?iso-8859-1?Q?7CEmSq9PEW4I1kRUQpUgH+zb/OccM2S98ROp9pzCyTpbFvmZ1GtLIAYqEQ?=
 =?iso-8859-1?Q?TRCo/z4O/zNOn301cCd+G2S33iCxdIx+Pb3O0lzNmEFvTQ5L4P9J2hKwT0?=
 =?iso-8859-1?Q?g4bRr97UtAUAJ7B9wipX4chiOln1CjX9iwCMvoI3+kCkzOmYq5S6aMuFW+?=
 =?iso-8859-1?Q?6k4w9UMnzzunVY+jto9EyycsTJkdqSqgTkP2iY3T6OX4z+xYlDfhRuHjaQ?=
 =?iso-8859-1?Q?HdzONFS2Un2jjg4I140U/W20XUBv/EaSbqAId1Qr5kw6VxMFUK8BZepYlm?=
 =?iso-8859-1?Q?/5hrFkFo4BN/tHpeNKqHR0CgqLd71t4/uQzxC8sidLwIDG00lSLY4yjbAn?=
 =?iso-8859-1?Q?6S6r9FSSVP2KGTwzT3s5r2A80+sWY+5zm42DAI6js2E3vkuqM/0hDmG7pt?=
 =?iso-8859-1?Q?SUFDaYmpXxRaHB5y0uzISgq2jgZegvY3vIJ5MMd499QEl5GDhkNTOHjV2R?=
 =?iso-8859-1?Q?AZmmKTtdHaxgRm/9ty/dcRJGR8emtoTs5y6KQMVGKZ5zgYFT+pCHFe3FXL?=
 =?iso-8859-1?Q?YgpUhLiwZFZW7YBe36C0rETZzYoVhcdTp1NhGm6226lOhRSdMkgc9KB6OE?=
 =?iso-8859-1?Q?+LOUBvkvfBh++Y0SSD/eXTdNmbjVAq1xuPL1qQzJoDew+tMoBrkxiGvusx?=
 =?iso-8859-1?Q?CGjS6cP42orqxnQLbQ7EFEv40XWif5XFn3b159XFJqf+BJpeRqUmUVQpY/?=
 =?iso-8859-1?Q?D9+nUOw/Y33s42UbP1YTMqsRinik8YM9Ou0JweI5ZE9Jm2k3xTJ9935IT3?=
 =?iso-8859-1?Q?JVMFh2Ki7Wp+FKFAnOHnFydyWtGWaOqTzyvMybBdlQ9965mTTQoNNYLzYF?=
 =?iso-8859-1?Q?LtjYabtMCcppD3Ic4d/e0LX5+VcxfMtqvLCkMBa/iYIH1o7SRG9qpow6yT?=
 =?iso-8859-1?Q?9FhYPPOurp09q2M3L2faOn7uWWY5JOpAYCN71sajot3Y5l5UqDvHeZksSo?=
 =?iso-8859-1?Q?mp0qQibgNhAt/1rJrWAyheFcOtTr/zUN1kN0jiBG/Q2n/m31tSpcyIsW3y?=
 =?iso-8859-1?Q?fTVMjJI4uOKKOSb8zLFHRBKQ03ZX6oECH29uRbtj9vxILmCQr56LoM6tbr?=
 =?iso-8859-1?Q?ENzle7FgOgHBzVdTOl7ASHEv15D0L6acrtGGl6YPtiKyWXAGk6qTks2Yoz?=
 =?iso-8859-1?Q?dmAA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4504.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 862e53da-0b04-4c4d-d106-08d9b3a08925
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2021 01:27:12.5298
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FzI33mBr59t2D3/eIrzrI7Z1JLehl0P4QYyLC4y23GIZEeJPsidNpPgC2kvOfinCC4cEgnNJnKTd2/xHkD4NBa2aNNkzm3qzj4qA2+pC+6A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4679
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10183 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=565
 phishscore=0 suspectscore=0 spamscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111300006
X-Proofpoint-ORIG-GUID: oSIDY-uPmIFMhDKQ_mU1ZB9Te4GqQc1f
X-Proofpoint-GUID: oSIDY-uPmIFMhDKQ_mU1ZB9Te4GqQc1f
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello All,=0A=
=0A=
Based on the discussion covered here=0A=
=0A=
https://lore.kernel.org/netdev/7663cbb1-7a55-6986-7d5d-8fab55887a80@scottdi=
al.com/=0A=
=0A=
would a new "ip macsec" option to choose between the 2 ways=0A=
(pre-patch versus post-patch) be OK as a temporary relief for sys admins ?=
=0A=
=0A=
If that might be OK, I can send a patch for review.=0A=
=0A=
Thanks,=0A=
Venkat=
