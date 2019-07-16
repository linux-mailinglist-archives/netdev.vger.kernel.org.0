Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 605A86A1ED
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 07:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbfGPFqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 01:46:54 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54482 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726603AbfGPFqx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 01:46:53 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6G5jJFp008439;
        Mon, 15 Jul 2019 22:46:29 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=2NJiUrxjZ4lgKGU9NovuVnMcaNU979wyWIHkbCDL1vw=;
 b=Jau7bR5d9gKAWpRX0LFmmQJ10vq7cTci1yHeTq5iDI6hbCLw2wEx3bEUBQ1cJL9zCfpa
 MqUXY3s+1OzEUj+3Wk2Gg3rxhszo0NqaIDyLoGAkUjc/ikrFCh8w1ItzTyjhUD6Coco5
 26fRhGAhQrvesxQ3BuHoTwzG2lvYIVXfR5E= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2trvkhje3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 15 Jul 2019 22:46:29 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 15 Jul 2019 22:46:28 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 15 Jul 2019 22:46:28 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=idwxeqHOy9j47BC0EOUHjDN70tr9tUfzg4cz0D9cuVBvwFAl14FjMx40Jq76oYsRJAUQbD25mS8vzCAIXrkIL6usm1hoME7MPswBUZxm4AiMANeXRf2cN0SJ66GoFyIxqbH1VJJdsrrCPRan4HCBmrw3AWMLGdK+KiqxH4+VLCOP8i/jRe+z42Ay2t0MwtOwhhHpqe246RRpxARcUh4T34QmY8Zg0jziThtBWM0fVbWwbTvBwckBCUgUUM1NZlIp6af0pQL4E6jMiiWx2edZv4fOR3xVDpaRssW0QQCc0ryvqayZQIR2cXlVNlzx8SL7whsAT0b2MVkuZslxdvhFfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2NJiUrxjZ4lgKGU9NovuVnMcaNU979wyWIHkbCDL1vw=;
 b=MVPWDuegVWhjEIZHdC52dz3z0hBTz3DcQkvfgb5fW/CAtl6ECu8mcu+CD1j/Fk/1yCZki/IJqeKyOXfZKl1V5o7xig9YItS33DrAh3HeKGHLRD+kZE74gCzT0rFkO103YfEhC6s3RVngHU2ix7V7usRp35KaJD0+mdo5Esa6ije2jSlZtLbG2krN31u2gmYBM8XoW3rBmL8sTkOMLzLosm1kENpZXF8f1Sbn5k0y0eKVESrlpkoyWBGz3RFZuvS19GoNOHVULXC0tCuunHKW7tTaOp5W50E7BfDF4ck1qE6RY9fstgY6+f4Q+j7VErTZlSBCQK3xiUfehW6qGQDzqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2NJiUrxjZ4lgKGU9NovuVnMcaNU979wyWIHkbCDL1vw=;
 b=dsctJejdRvyGkT3Yg8eEuiWjXPBb7fTd5n9adCaA47ui04VXBWcj/oI9aQ5SQsE2YEs7v0OaPVuyzFP+mM9wUMNC7bdLS4Rb49f6lRmCgLjTr5gGNsCfQgblH6KZYlO7jxr8eiOggFrwAWp74Z/1FDPRVJ85xmTBmqx2ibICr7Q=
Received: from MWHPR15MB1790.namprd15.prod.outlook.com (10.174.97.138) by
 MWHPR15MB1583.namprd15.prod.outlook.com (10.173.235.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.10; Tue, 16 Jul 2019 05:46:27 +0000
Received: from MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::9d0a:3a7e:bbad:a705]) by MWHPR15MB1790.namprd15.prod.outlook.com
 ([fe80::9d0a:3a7e:bbad:a705%7]) with mapi id 15.20.2073.012; Tue, 16 Jul 2019
 05:46:26 +0000
From:   Martin Lau <kafai@fb.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf] bpf: net: Set sk_bpf_storage back to NULL for cloned
 sk
Thread-Topic: [PATCH bpf] bpf: net: Set sk_bpf_storage back to NULL for cloned
 sk
Thread-Index: AQHVIJ8XOQk2ERkZFkS/FdlfNuU7G6bCpsyAgApLkAA=
Date:   Tue, 16 Jul 2019 05:46:26 +0000
Message-ID: <20190716054624.ea6sbbzn62grde2n@kafai-mbp>
References: <20190611214557.2700117-1-kafai@fb.com>
 <20190709163321.GB22061@mini-arch>
In-Reply-To: <20190709163321.GB22061@mini-arch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR2201CA0065.namprd22.prod.outlook.com
 (2603:10b6:301:5e::18) To MWHPR15MB1790.namprd15.prod.outlook.com
 (2603:10b6:301:53::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:5218]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7fd64db-0eb9-454c-4001-08d709b0f15d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1583;
x-ms-traffictypediagnostic: MWHPR15MB1583:
x-microsoft-antispam-prvs: <MWHPR15MB1583F2A719D2D5CDB7BF0931D5CE0@MWHPR15MB1583.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0100732B76
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(7916004)(396003)(39860400002)(136003)(376002)(366004)(346002)(199004)(189003)(8936002)(478600001)(6486002)(7736002)(11346002)(6246003)(14454004)(1076003)(71200400001)(186003)(476003)(305945005)(71190400001)(316002)(6916009)(446003)(86362001)(229853002)(46003)(9686003)(14444005)(256004)(76176011)(6506007)(386003)(4326008)(53936002)(8676002)(2906002)(81166006)(81156014)(6436002)(6512007)(68736007)(5660300002)(64756008)(66446008)(33716001)(99286004)(486006)(66946007)(6116002)(66556008)(102836004)(66476007)(52116002)(54906003)(25786009);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1583;H:MWHPR15MB1790.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hvsm70eQYSDHiHDiIIzjk2aflyntjC2oHHDqcKWtCwtEsMXiSXwRS4ABiU3V1G0F/I+DWKsnNQFzrPMZoiYKPucF5O+BHCw+9FjdE6Tu4y0QrO+VTG1tq/4B6NmP4D8QBBoI/OBS3iku7UEAMLWeSiM8NBFFYpoF2wXhrWIV+YnRuL9z7cMlypSd9m31H9mYQERHh4bje1m0HescPjYjkdzcD+LUcuX0JF4mbhzXFxroxzUUkVWL4dr1asalLL+pUZN8F3o3ei/VR16lRZ5RujmpmQ5jZJczEg59yB0alggapw4vQuLqMj4LornuWcp7o+1k5T64tswrllLvlweR4gygnjo1IV+n2RlqZI3h/DlDyj9giS4zmGS5YzuKfv+2/QDfRDta5qp9cFT2tt8yXSwczBufzTjfKaV6c1BWC7U=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <70CDF5A15CF0964790AD1C09E46C7B1C@namprd15.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d7fd64db-0eb9-454c-4001-08d709b0f15d
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2019 05:46:26.8091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kafai@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1583
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-16_01:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=736 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907160074
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 09, 2019 at 09:33:21AM -0700, Stanislav Fomichev wrote:
> On 06/11, Martin KaFai Lau wrote:
> > The cloned sk should not carry its parent-listener's sk_bpf_storage.
> > This patch fixes it by setting it back to NULL.
> Have you thought about some kind of inheritance for listener sockets'
> storage? Suppose I have a situation where I write something
> to listener's sk storage (directly or via recently added sockopts hooks)
> and I want to inherit that state for a freshly established connection.
>=20
> I was looking into adding possibility to call bpf_get_listener_sock form
> BPF_SOCK_OPS_PASSIVE_ESTABLISHED_CB callback to manually
> copy some data form the listener socket, but I don't think
> at this point there is any association between newly established
> socket and the listener.
Right, at that point, the child sk has no reference back
to the listener's sk.

After a quick look, the listener sk may not always be available
also (e.g. the backlog processing case).  Hence, adding
the listener sk to the bpf running ctx is not obvious
either.

>=20
> Thoughts/ideas?
I think cloning the listener's bpf sk storage could be added
to the existing sk cloning logic.  It seems to be a more straight
forward approach instead of figuring out the right place to call
another bpf prog to clone it.

Quick thoughts out of my head:
1. Default should be not-to-clone.  Have a way (a map's flag?) to opt-in.
2. The listener's sk storage could be being modified while being cloned.
   One possibility is to check if the value has bpf_spin_lock.
   If there is, lock it before cloning.
