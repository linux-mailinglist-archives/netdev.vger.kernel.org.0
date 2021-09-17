Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914B640EE57
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 02:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237878AbhIQA3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 20:29:03 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:53068 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229684AbhIQA3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 20:29:02 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18GNdEB9010806;
        Fri, 17 Sep 2021 00:27:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2021-07-09;
 bh=U16iQLH07Wd10UoKS03KWKKx0r6T2LJ1rpaSakzCdb0=;
 b=a2ldZJki5tmcFAdYsOttxMjezlPX9mXe/WGEe54LZJKWNRbqHOIcTNdeKBmXcuMwzTsi
 zJBpzxsDXW7nM91iENsE/MKJn1DnYJxL6IZHKnyR4dx6gQ9Qe6+w+lHrWexmKiEJLqmm
 gbIv2yuxOT/H9f73Qj9Qo6hPxfjvgM58EaccY1EQvY7s24eX6WFYL/fUZ+VHZhiWvBOn
 K08Kh6pyUWQSGm+k/NsbDOmcZVNg3bEYmrQ2FlgI2dv+Hb0lfIs2k/UVkYYGHtncb1Cf
 yn3fRELPgWhDCi9tv0anuLT45O9MwzIpfYdy/R1hyLMMTYIUfF3DopEKRf2ClEVMtodm SA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=U16iQLH07Wd10UoKS03KWKKx0r6T2LJ1rpaSakzCdb0=;
 b=p8/QEhswCseACjGpzow36gZc/tN3A8xdZef3EZKUcAwkVkcd4xQEHpudSThLLJhn+hED
 2GKWAxB4YXOflmaaA8V0zKi0xDkH/ul9Mltosxtw/3vWENzj6/9xYE7BIVorfLKZsH3Q
 S0xct16YdL8Mvdlvr7lHSUwYO2py/euNhG0wVmM8eK8lETDuYds8HrXiYRKBmH28E2cb
 CpTbz73B5na94Ti64XOf2ovLpQ0vcQj3F29KdAZiWbDJun42SWCdMyDM5axUBpdVMu0C
 /qJZe52Dzr7NVnCM/jQTruYMyvRXUfvlDlsIX4lSJKVXqAEoxmNgRW6hJj8a0tJLNJ14 Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b3tnhvdr2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 00:27:39 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18H0PIuh177958;
        Fri, 17 Sep 2021 00:27:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3030.oracle.com with ESMTP id 3b0hk01dbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Sep 2021 00:27:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgLxfsO3ep6dbbKmeu3xgWXNaASezmhlJCCJAWvWeNa0DluVRQppyJXq7AQCR7+2WhTNKypm7AGfB8h+4v22/LTyDyWGfC2XRk1XwHd/DlLssRtdxxUMzswC0w+ckHdtPc7PUBYAitM09hSoQLAa8Ds8qEduTZvJ782o/48CPGV60ryxiOOWqxv2w4IDkMDaVTu6oF7r4ALBbHYvWieNAka7Q7CtRB3wtGCf4RwO1Oi/yMPQT1tdWCs9qtv0khoE3k719eCGzynBlujX/IV7APQEfl38OWMR616INKDDtdQ/6dkbcpRo18AkdkTz9m1FaKzvu7lQvyUEx4hto+qctA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=U16iQLH07Wd10UoKS03KWKKx0r6T2LJ1rpaSakzCdb0=;
 b=QNQSMvue037oKDfb2ys5tNif/5SnteXGxOWkNIMfVPEq2bT96EvZ1LDDksL81B/aZBTdcDiPlnBA2ioUa5ZgB3hu5lTwkZJhtnY1W5Y0h6BKRzwD8qWazRUlNnc0saSdra/3PFliHcqXXR9Nu9HPQknD5JL0NTaR28JCBfQSpdsGDAEsVgk36xnw9ceqZgYmvROcO6eEDgWnAT8oeaYn6dEHGnQOGvSCDWL5tx9iXC1xBnQw68nSVt4CeoZDoYvHqO1mA7gPCl61c8ECETmPJNRpeyGvUdhhIQfy5sOIemIn7ZSaYXMGbCS4GdhG/ST9O59EngCEeBuXwU9o92KO1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U16iQLH07Wd10UoKS03KWKKx0r6T2LJ1rpaSakzCdb0=;
 b=r583zkgRXqvKdTgUd5MkHHUtZa3zV6an3BG3KB5UklSEoG7lTFxvcQnhDmrwjfDLIKU7sDldFIBdrDnj9VIXPk9qk4ZpSMPDxsur9Qt+oMSNFgYilbPLnhYFfOfXI1jSrjHoiRyKPDB/uA8hjRLIPcGSMlNFBFsbFcDMKxoX1As=
Received: from PH0PR10MB4504.namprd10.prod.outlook.com (2603:10b6:510:42::5)
 by PH0PR10MB5644.namprd10.prod.outlook.com (2603:10b6:510:fb::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Fri, 17 Sep
 2021 00:27:36 +0000
Received: from PH0PR10MB4504.namprd10.prod.outlook.com
 ([fe80::51d5:8873:e31d:a9e2]) by PH0PR10MB4504.namprd10.prod.outlook.com
 ([fe80::51d5:8873:e31d:a9e2%9]) with mapi id 15.20.4523.016; Fri, 17 Sep 2021
 00:27:36 +0000
From:   Venkat Venkatsubra <venkat.x.venkatsubra@oracle.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Konrad Wilk <konrad.wilk@oracle.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: Sending ARP probes (for arp_ip_target) over backup slaves
Thread-Topic: Sending ARP probes (for arp_ip_target) over backup slaves
Thread-Index: AQHXq1kYV8J9s6Ll3kClY7u2hWEaxg==
Date:   Fri, 17 Sep 2021 00:27:36 +0000
Message-ID: <PH0PR10MB45042C88B70810807BAE023AACDD9@PH0PR10MB4504.namprd10.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 9ab03846-6aeb-139f-ab31-e4f9f31e0e35
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5af69caf-a344-4ff5-4a8b-08d97971f2d5
x-ms-traffictypediagnostic: PH0PR10MB5644:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR10MB5644543F6062101320AF6325ACDD9@PH0PR10MB5644.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tqOMUZZXgsUgFsfJLw5XbWsGJLFAxUFHNrwCM9atpPam0iMR1GZnZ+5b54+41tWZWwrWQ0KO4kJQKbYzpBBveqazU2bKZcl7sY89SyVvOok9uqYT0EtKYj7RsHruDcbkyxgIQAIUoZz/aDeFvPLRCoI86Zj2BG1In7P6SMpfzCjwGQrFL5lfDpXK+tRhbvTAvbRam8elFy+FO6N9k9yeGwx0eyduDNRHeEvCRoHbkpdSo9tZD7nuOfdq+wXc/4KdhCjx6EPATyuooqYge8Rq90GfcSZ92o/c7AcPR0mK+F3Ro5Z125nOfJGL2jXfXbV3uAGSfRiWOUGX5khLnBGKHOszFFpJoScEXNbDvxagvV/a/6PjDqpYUl+1qGUlF4sVkhXXDYf28aRr07wAWY6IiL46C+IMpaClSdqCi9da7XCl1fgWB5z8XBi9sIVbVszqRKmMCfu8uNoTdJndr4CKIb8xt8VokhXGg5wTqjSsi7icKCW3+b04EIQ0QbzSMHzDY97VHC92+zVuOl6F6I9Mg9DrVVvWOavuWPxPOKUUxs8JAFPwlAFtTukOz9Hsk1vLgGEtveDciXnDb8zdnt9u3OvpPNB1W22w65cM47Q0FcAS6JMomIctGyik3qwiNaH/X5BgvfElkGAuEgfkM7mwIwTWHrjtBbQRM4uGq4YayXRp/nt3/q3bP+YOmgGo22q9PRBtIWK0jf72gNZp7DRtsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4504.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6916009)(76116006)(66946007)(86362001)(38070700005)(4326008)(186003)(7696005)(26005)(52536014)(5660300002)(33656002)(6506007)(55016002)(316002)(9686003)(54906003)(122000001)(8936002)(8676002)(38100700002)(66446008)(66556008)(71200400001)(83380400001)(508600001)(64756008)(66476007)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?tdhAkTlMhAt5nS8KNUJTnnRuCoe15K7jsD03OKam10NHQQyGxVBK+FDcWh?=
 =?iso-8859-1?Q?O8fzEG0gcUwPYV6ZwzhDeqvxHY/vFKlZr+/tjiDGvho+6vrl1NqpAvX4iU?=
 =?iso-8859-1?Q?aPbjfvDzR7yH7aR1msuIsiV1rKZ6hc/PphEUgemRxB0hGpasajNWlwj4Wx?=
 =?iso-8859-1?Q?Iy2yA3iE9slyB5KZHFrv+oqhgyE3My1LShakJ6cqiGd6KHsECFNLW5byOH?=
 =?iso-8859-1?Q?1QGfJJRlXZT7RHeO3UAM/6wZW4HWmVrh9eZw2RclrIrbwVrw5atkpCiE1t?=
 =?iso-8859-1?Q?/Y8lsIJfZ62l4tzN0VwJXqOXwBe2ZbR26qdXT7x0hkZbSNmtIlbGyr6krE?=
 =?iso-8859-1?Q?2vFK8tIgD4I4fXzddkucbWH3V2nVryVkaLKslM0wolrG8xM4zQJLrpCpxf?=
 =?iso-8859-1?Q?+2Xi3Q3M+WmHGk88JhWJZF184yhqZ+7w3ZLXNUEGRcgiepgy7n+7K+G7bp?=
 =?iso-8859-1?Q?fwif1c1J1Izcox1d3bsKAm/DleEPhclx/OGyfqxAZmtO1oPKFvGXSTNxqA?=
 =?iso-8859-1?Q?6TbyVzxMJvBL6oL9on+ZbZe1fnYw2D9e4cfzafXm2BfcKwY1avfrDWYxx1?=
 =?iso-8859-1?Q?5UnGCvJ03kkU8qofqgdY8jxN99L1C95rid5AC4rnLPjDxW+cPrChT5IIw4?=
 =?iso-8859-1?Q?/bWEYCJT8hZ9b7l165IFG1p6iy0T+2uR9JtJReWIw5Gnp58fxWv7O/Kd0e?=
 =?iso-8859-1?Q?b+NBvT1mOe8JcQxldLNbZGZ1AtYAsv1DwszvAPrpPynV8FvsvXaIyB2KaX?=
 =?iso-8859-1?Q?gkb4WLN++dhmyH4uDOf4yiPcEGut0G29BBN/D4ISi/KHelV4HGW8S7ZZXj?=
 =?iso-8859-1?Q?+bvyEsmp1UTNDmwtOzSmeN2UI9NomeIrJ9wGaWh9E+tAp2iXqPbfhow/fS?=
 =?iso-8859-1?Q?bX6gF4gZxybl34PR/EuXe+MIRCaKAnq/xLIgLzihg1YwXsgXs7ImG0Bz5c?=
 =?iso-8859-1?Q?HTLFmB7Lba12L4BrsoqSGJP01vgTUgzc7vDPwZBPGpt2MFlhh23ete84Yu?=
 =?iso-8859-1?Q?GOKN61H7yuuf4KYAZDBt1hmi/7L0296+pwcQucxhZl0h3LohWFQtH5WNvO?=
 =?iso-8859-1?Q?VCO8/+u2jTb/jDjUGxaMqgABMW2rNe+vHuXAxaSCehoa8O3n0Osn+Q8V3S?=
 =?iso-8859-1?Q?D014++lQZSbhz/48p2myxuSIMyDE6tDGkPaj3qciUl4RwT9tYbUeyQpdy+?=
 =?iso-8859-1?Q?c0qTcjp4kFD+J9xRIGng8HJUYlUVaWijfYRmPLZV/HeJ7J2Qbh2EHZilOM?=
 =?iso-8859-1?Q?cEA9wXLOnMRWJHGpW/sywDBjc5acC1PuQkP5KA76g1OWy4vDw0eJ23disL?=
 =?iso-8859-1?Q?nX/abwMaDkXTJLwqhGkqC6ZmybpfD9EqoJpBmEJWrf9nlBg=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4504.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5af69caf-a344-4ff5-4a8b-08d97971f2d5
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Sep 2021 00:27:36.1134
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: amJ3G7Wkav3to1PAeVaJsc9wWHBwkN2GTFb9isVCMHYIKYSMl5UHLlwagk4rX6f16a1+wKA+59Rz3H6vewj0PPlF4fw530/MFLLjHiGpO0k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5644
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10109 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 phishscore=0
 mlxlogscore=668 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109170000
X-Proofpoint-GUID: ho37_IRjxz0mDi_ylkIr9hjw721zT1K3
X-Proofpoint-ORIG-GUID: ho37_IRjxz0mDi_ylkIr9hjw721zT1K3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

For illustration purposes if we use this config for a bondeth0 =0A=
with slaves eth0 and eth1=0A=
=0A=
"mode=3Dactive-backup arp_interval=3D100 arp_ip_target=3D192.168.1.1 ..."=
=0A=
=0A=
and let's say eth0 is the current active slave and eth1 is the backup slave=
.=0A=
=0A=
Currently bonding sends ARP requests over eth0 only.=0A=
And our switch does not forward them back over to eth1.=0A=
=0A=
Let's say some packets keep coming in over eth1 every 1 second.=0A=
And this brings the eth1 state to up (arp_validate not set).=0A=
=0A=
time t0:=0A=
ARP probe sent over eth0.=0A=
ARP reply comes back over eth0.=0A=
So, eth0 remains up.=0A=
But eth1 link state goes down due to lack of any incoming packets.=0A=
=0A=
time t0 + 1 second=0A=
eth1 comes back up again due to arrival of that "some" packet.=0A=
But only to go down quite soon again =0A=
(no more incoming packets for another second).=0A=
=0A=
And this keeps repeating.=0A=
=0A=
Now, if we send the ARP probes over eth1 as well (every arp_interval),=0A=
ARP response returns back for us over eth1.=0A=
And this helps eth1's link state remain up and not go down.=0A=
And we avoid the continuous link flapping.=0A=
=0A=
Seeking suggestion on adding a new option to select whether=0A=
the ARP probes need to be sent over the backup slaves too.=0A=
If there is a usefulness (at least in some scenarios), I can send out a pat=
ch.=0A=
The part that some might be able to relate is where some switches =0A=
don't forward the ARP request over eth0 back on to eth1.=0A=
=0A=
Thanks,=0A=
=0A=
Venkat=0A=
=0A=
