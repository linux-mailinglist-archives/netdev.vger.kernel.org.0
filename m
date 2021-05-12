Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4668037EFA7
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 01:21:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhELXUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 19:20:21 -0400
Received: from mail-mw2nam12on2114.outbound.protection.outlook.com ([40.107.244.114]:18368
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1443450AbhELWSr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 18:18:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z7Se5L/ckD73EdAIQKXuIFsDEZCFp4t6EfcltNkTui9ez/fJejy0n8OTn4pzLhVX5kdJZKu0gOziYAZplGeK6egVJemlR3d5qlXXJjAOJ1545XTT28AJOZNpdugSt0dFiQS+l5OiWcnZ6Bh0YEc1+UFSo9dtpnFP7tsYZwEJElYWCrsZ9gMeH58LzItODAMOc5sRCObb97ln2xqDxL+OemoB//t11HWxLF4DrCNnKNC0Sp6KKAwFNpIO16m2d0Dxkrdq9mYnt/wR1mZnkLOlRTS+vhPfoyUXNdxdMajGC8sEB9TJ4yhKu8M8o6caty6uXib3p4WhMGlCxcj9t1MAOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzIGbe4q2YfKkwLi2sUH2QdtHq5fDSPjn1J6ej5jmjI=;
 b=UNsMbZLRTZpomyQXCStsOIqp4EpX9f36aVA4XUS9KV9Z2n+DzqQyvRhdoo08f4P08TzieQqb/Vn+euAn0uQhGpy1nXsnZf5PYtpT+2GYwNSiQwT06j7kLG7/FDvJ160D0LIa+YKh48tHp4XfNGJKSBGMAKUeVEyfV6MzUPqpKx8YzXR/rDuPjEM4chSXPW4BB8QcSnFbHd5hafYVHiZ8jqg169VGxgR/lmWK6GQAxzIH/+kytK6C0mg9+BkYFGk8eAQ13P9LqTpi5YW3HnPrbWr/tfGLLu369CnutYgsFHBK5a0x4CzYGGDzJwEdEneiBEqYIe6jvS8s8e7cbrZUnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzIGbe4q2YfKkwLi2sUH2QdtHq5fDSPjn1J6ej5jmjI=;
 b=K/Sp11r3HvNfWNPWETF64QX6cknDV/T2I5CgOsReT3/5YV/T3H1sxBN66Ipa92bQXIdXLkdvMS9EoSz5Paqhu8Gyd33q9cdZhRvy6C94Ksd1BOonuOPBeTuRfFUPWs3/wYZCMNmouizNrrr2iiCladQio8oK1Kukk3oQrh2hvd8=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW4PR21MB2075.namprd21.prod.outlook.com
 (2603:10b6:303:122::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.8; Wed, 12 May
 2021 22:17:22 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%5]) with mapi id 15.20.4150.011; Wed, 12 May 2021
 22:17:22 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN 
Thread-Topic: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN 
Thread-Index: AddHdN+snMbFwQLHQSmZ6J2vO7HZjQ==
Date:   Wed, 12 May 2021 22:17:22 +0000
Message-ID: <MW2PR2101MB0892FC0F67BD25661CDCE149BF529@MW2PR2101MB0892.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=356357d2-2a65-4b3e-86cf-03509df80d8d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-05-12T21:20:54Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:9d16:8ec9:e190:4c0c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 075ed133-0be5-406b-0ad3-08d91593b743
x-ms-traffictypediagnostic: MW4PR21MB2075:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB2075CA816166432EA0377DF4BF529@MW4PR21MB2075.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WeE9FKI901heSmbDYEYFjH6RfPyETZwrUtlJ4Q4RxKzcCCCxcIpf2YBdPd4mXOS7OcWoyxdy7xjrNhHsJaV0EKCZdSaU4JMtcUz6S74Ogj8rB09sr3j+IjCp7Me6Zlp3UDF2erwYhWms0Qnx2OwBBMJn/w57K+1uuEcG4bIcAlk/V5sRuYAudZ3Lny+j1PBN188DvnnU8DtDWPzzwlk0Xm73Ua7DpNOVCbXZNFjdLsBX77oMucT9xMDRSO6Yh3ougyzZP97eesWvFzl3qUEuYbYxaPr2YqjCxBaNvnUog4ltzxAnryJsKVW2GSKpzEM9zPfYafvC3snK7LHhadVa+YwnWBS2+I3ZV0XT63koPEn16k+Ld/QAwc+/VsxiZ8V9wHmrstWExRoSrUoWEEoibfhmnYfORAlArWS0cli/mwYhLTJ1VwdjrQFJlvkNMaR6EiD4wRIdUULEQmuYY6ZtLVNZFWtX2k4UCnjOLyud3H8z6yVIUK3sR+N4hojsxzGyFdMogre7Gfh8l9l5Jy/fsvLGqm2QJj6KQZFI17QrU1RVnboQ3eJkOb6GoxvvjIeqZMeWJeeCgdonJ85SH69Fhe3xvPnBqW5da0oypjkFnetBjIfE+lMqJ8Bg9WOjUEOLDCKa52qFZxnrufqLVydAAs3srgIJ9RKA20L8FczpfORqVduYbETdIXqs7VBVNPMgj3a7c809Mx2+8aRiBb2zGIHQc/pDmnxIF4drhb43tmw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(10290500003)(15650500001)(316002)(122000001)(4326008)(54906003)(83380400001)(52536014)(2906002)(478600001)(110136005)(38100700002)(33656002)(450100002)(55016002)(8936002)(66446008)(9686003)(5660300002)(82960400001)(186003)(64756008)(66476007)(76116006)(86362001)(6506007)(8990500004)(66556008)(4743002)(71200400001)(82950400001)(66946007)(8676002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7Oao87CmCqJIShxkecVqvsQop8UU2dtnvflAX0svjdcwh0O/grFxFKnW0prM?=
 =?us-ascii?Q?Xvw/dfNa5QfY4l4pQJEJWS1Te2GGLtEu/Rw46vxwqPcBy0Nud4exjLHXcU0b?=
 =?us-ascii?Q?1Fh628PrDMMTXyuQnUIv1CGieOFPZHEgv1qDDHcubAKpVJ3BhLgNHssDuHgX?=
 =?us-ascii?Q?n9RSzB9etvrZDHmtp58Bs4wO/75oqX7fdziHv6qFz/cb94UCj7zuVBz4Dpog?=
 =?us-ascii?Q?q5mhBDDCDysBjvdjtS4YYzOa+5WUY+lYma0Ymh/YPAXVDRIlUTpxVSKndb8Y?=
 =?us-ascii?Q?yqGsHl5yBBITmAZKDIhQgCTtDe2oLt9LYO2YyJwNlGCnAjV3JKVkkgRSPxe0?=
 =?us-ascii?Q?6PS59mHPR1SBgOwqTG1RNqPUYUY27EEEEJBguWRnVyJEbNAtioqIqYMR6TE5?=
 =?us-ascii?Q?1O1L/Of2MlS/EDRaqWpGq3ufRZL8NxOZqi9bu92Ga1mx2QYB20q46R+kP+gN?=
 =?us-ascii?Q?d9VPoTljSIoAnOSwiYLIaw2wmw0wzr9xQwdtlY3apJ37fxpMUk+t4QpaJOcu?=
 =?us-ascii?Q?5SGH/q2JzEzTPBWO7qns5iXMcdS0I5izFNmkttUm6WgT8Dp9pbhlghrMZEEI?=
 =?us-ascii?Q?Ouf94aQmGlP5YLYj53z+BMKQCKPoPCsarfFBUgxXE0bTRKaGQIXdAL/SIiZC?=
 =?us-ascii?Q?riDGUXNccchQaE9+/VES2XP6Ag/VDV5o9PLnC+tgrriid11pB7ZET8UHwxs0?=
 =?us-ascii?Q?orDHein7wcp8s07/sEnl6PvNQ8oTYYBPTDWKvqEpSZF7BwkkCLIh0jx0jyFn?=
 =?us-ascii?Q?4+5i1mZb5KnDwpSXPKFLnQMnGPl2lksf6GjkcXoaOIkgP2vdPeXSzmPGL17p?=
 =?us-ascii?Q?OkdFYvkndiLv4up0UdQA9vbPk0s7par74QjO/yCZUQWKr93qRpDLTyYuXP2u?=
 =?us-ascii?Q?yMztubbUyuiD5oYa9j94ZHEhHLeZ3jJnJPNiGxUjcMKmA391LKT0uWdCIMPS?=
 =?us-ascii?Q?J+f/JeQLFpKSuDB9ZztoimWTv6LZNz/0nEIBVwrQ?=
x-ms-exchange-antispam-messagedata-1: nUR0N/nUYDfNzweTPyuOimRJDcQwjgDOG1f6Es+GWt1EzcHU4+IlNxeEcuK3JOmlPWek0P2trAGKF0oeq8CrkmxIcsuIrzxkNybueUqFFCTCiB+bpmWrbutkLKeR3JruKRhh2dt5d0uqXRD+FlF04EXp8EnevJD7vmoMFR7ftxx0kRf12W1OqGsYpOvHr1a1Xw73Rzup8vzSkfpR4gybQG8wuTcaDAXFx1NmHaWMdagD0WfV6tfUgHDj+n4KGSMDhiCz5Gdr13iE1S5M2UBWME19LSfWjFPV9+BuUnREataCi64VTmQlD6E5qvBDwCO+cqIehXzHDid49Spu/Ebs9JvMBTOT/MpB/aqe+WVrR/1yhfHV5sia7LHUggZakiC2euDFZafEL9Gv2honeZMwYaqs
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 075ed133-0be5-406b-0ad3-08d91593b743
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 May 2021 22:17:22.7146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x8JTNwsNcTdhrYCr345flm5rFZFwLvBuStVR5RI/IQd6703/MsjNVPUE4YQCPHZxErICK2nX1EIdp3A3X8U7cA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB2075
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
I'm debugging an iptables-restore failure, which happens about 5% of the
time when I keep stopping and starting the Linux VM. The VM has only 1
CPU, and kernel version is 4.15.0-1098-azure, but I suspect the issue may
also exist in the mainline Linux kernel.

When the failure happens, it's always caused by line 27 of the rule file:

  1 # Generated by iptables-save v1.6.0 on Fri Apr 23 09:22:59 2021
  2 *raw
  3 :PREROUTING ACCEPT [0:0]
  4 :OUTPUT ACCEPT [0:0]
  5 -A PREROUTING ! -s 168.63.129.16/32 -p tcp -j NOTRACK
  6 -A OUTPUT ! -d 168.63.129.16/32 -p tcp -j NOTRACK
  7 COMMIT
  8 # Completed on Fri Apr 23 09:22:59 2021
  9 # Generated by iptables-save v1.6.0 on Fri Apr 23 09:22:59 2021
 10 *filter
 11 :INPUT ACCEPT [2407:79190058]
 12 :FORWARD ACCEPT [0:0]
 13 :OUTPUT ACCEPT [1648:2190051]
 14 -A OUTPUT -d 169.254.169.254/32 -m owner --uid-owner 33 -j DROP
 15 COMMIT
 16 # Completed on Fri Apr 23 09:22:59 2021
 17 # Generated by iptables-save v1.6.0 on Fri Apr 23 09:22:59 2021
 18 *security
 19 :INPUT ACCEPT [2345:79155398]
 20 :FORWARD ACCEPT [0:0]
 21 :OUTPUT ACCEPT [1504:2129015]
 22 -A OUTPUT -d 168.63.129.16/32 -p tcp -m owner --uid-owner 0 -j ACCEPT
 23 -A OUTPUT -d 168.63.129.16/32 -p tcp -m conntrack --ctstate INVALID,NEW=
 -j DROP
 24 -A OUTPUT -d 168.63.129.16/32 -p tcp -m owner --uid-owner 0 -j ACCEPT
 25 -A OUTPUT -d 168.63.129.16/32 -p tcp -m conntrack --ctstate INVALID,NEW=
 -j DROP
 26 -A OUTPUT -d 168.63.129.16/32 -p tcp -m conntrack --ctstate INVALID,NEW=
 -j DROP
 27 COMMIT

The related part of the strace log is:

  1 socket(PF_INET, SOCK_RAW, IPPROTO_RAW) =3D 3
  2 getsockopt(3, SOL_IP, IPT_SO_GET_INFO, "security\0\0\0\0\0\0\0\0\0\0\0\=
0\0\0\0\0\0\0\0\0\0\0\0\0"..., [84]) =3D 0
  3 getsockopt(3, SOL_IP, IPT_SO_GET_ENTRIES, "security\0\357B\16Z\177\0\0P=
g\355\0\0\0\0\0Pg\355\0\0\0\0\0"..., [880]) =3D 0
  4 setsockopt(3, SOL_IP, IPT_SO_SET_REPLACE, "security\0\0\0\0\0\0\0\0\0\0=
\0\0\0\0\0\0\0\0\0\0\0\0\0\0"..., 2200) =3D -1 EAGAIN (Resource temporarily=
 unavailable)
  5 close(3)                          =3D 0
  6 write(2, "iptables-restore: line 27 failed"..., 33) =3D 33

The -EAGAIN error comes from line 1240 of xt_replace_table():

  do_ipt_set_ctl
    do_replace
      __do_replace
        xt_replace_table

1216 xt_replace_table(struct xt_table *table,
1217               unsigned int num_counters,
1218               struct xt_table_info *newinfo,
1219               int *error)
1220 {
1221         struct xt_table_info *private;
1222         unsigned int cpu;
1223         int ret;
1224
1225         ret =3D xt_jumpstack_alloc(newinfo);
1226         if (ret < 0) {
1227                 *error =3D ret;
1228                 return NULL;
1229         }
1230
1231         /* Do the substitution. */
1232         local_bh_disable();
1233         private =3D table->private;
1234
1235         /* Check inside lock: is the old number correct? */
1236         if (num_counters !=3D private->number) {
1237                 pr_debug("num_counters !=3D table->private->number (%u=
/%u)\n",
1238                          num_counters, private->number);
1239                 local_bh_enable();
1240                 *error =3D -EAGAIN;
1241                 return NULL;
1242         }

When the function returns -EAGAIN, the 'num_counters' is 5 while
'private->number' is 6.

If I re-run the iptables-restore program upon the failure, the program
will succeed.

I checked the function xt_replace_table() in the recent mainline kernel and=
 it
looks like the function is the same.

It looks like there is a race condition between iptables-restore calls
getsockopt() to get the number of table entries and iptables call
setsockopt() to replace the entries? Looks like some other program is
concurrently calling getsockopt()/setsockopt() -- but it looks like this is
not the case according to the messages I print via trace_printk() around
do_replace() in do_ipt_set_ctl(): when the -EAGAIN error happens, there is
no other program calling do_replace(); the table entry number was changed
to 5 by another program 'iptables' about 1.3 milliseconds ago, and then
this program 'iptables-restore' calls setsockopt() and the kernel sees
'num_counters' being 5 and the 'private->number' being 6 (how can this
happen??); the next setsockopt() call for the same 'security' table
happens in about 1 minute with both the numbers being 6.

Can you please shed some light on the issue? Thanks!

BTW, iptables does have a retry mechanism for getsockopt():
2f93205b375e ("Retry ruleset dump when kernel returns EAGAIN.")
(https://git.netfilter.org/iptables/commit/libiptc?id=3D2f93205b375e&contex=
t=3D10&ignorews=3D0&dt=3D0)

But it looks like this is enough? e.g. here getsockopt() returns 0, but
setsockopt() returns -EAGAIN.

Thanks,
Dexuan
