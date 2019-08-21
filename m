Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15F609752B
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 10:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfHUIkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 04:40:14 -0400
Received: from mail-eopbgr140113.outbound.protection.outlook.com ([40.107.14.113]:25158
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726828AbfHUIkO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Aug 2019 04:40:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qs0ljEp2KzV0ewpG2DQCMWWptDxnf+oXw2z+eln2pknHL5moYyQ/rPZDQz9N+tqPz+5VO6sAUCE/wkzx2xqme6ThTtLwNqTPWpCw8x1v85ltx0gnXKKebLKwwEeSdBG+1HT4M52MFgD2zQHE4wfMJ5mYuvaDfB9hWPXGIcU0j7/2/Ur3etwpLCzViKogHLjOiLpmaQcM7FtuN0JX5168U2ExZg38ObN/12BDELmko8E0PpcvGHCnEM5U7+cgULLvT8LHf70l8pIx1E6sHV6AuFxAsQf6mw7I9JnhWLL4YJVRHzsYMPdPncKZWfHskHjv3OAUNJb7YxfuO7GsvXk12A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZO4dPJAZcI4FYTbH8FLR34filZKlqn5zPZmnfYbLcMk=;
 b=ZtQhaVHQ6fFKRdsZPlL+BjiZXkL4s+c8qxvKUiKpQTkOQ1BYdKNtdCJgDAhxkQKgDv67aprcGfM15OiWGfVOwUoBNvJmgmUqd9gCU4G0NllHCAbXepFA1sUkw53lGldPNciIbS5cm7k0fVRGYI/UAWT8z+4I+x+5bB5pdKSpKXeZOHjujFQLUEClrAVKNBi8iSAMc6EcmFSGlJB3IKeRX9AZtrfe2JYSFU0CM7yoAS3zXP1m0bQaj7pEFHqye6ra/y9qcjxRhS3sOHkM/lTLhbcP2PCDeV5UET+kiAZZLqO0HzUjJYrkUFZz92+ijgJmCku3aw9odh9Oi3DR4viwiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia-bell-labs.com; dmarc=pass action=none
 header.from=nokia-bell-labs.com; dkim=pass header.d=nokia-bell-labs.com;
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZO4dPJAZcI4FYTbH8FLR34filZKlqn5zPZmnfYbLcMk=;
 b=w8BW/vGsyREVBeH23E9oxx8Aks27gChLMnjpdVF9gIRz1lPWGySzwjuhNIHXRtgl8wPYfR4SYj7XqvNU209bZsdv7d3PsRV+auEk9As2HKsFNuJJuwQcHGVtH0zSu8TDPTHfOBXxqXqvozrWgMyeT/E7WAft/cFjEXBbytX2jSc=
Received: from AM0PR07MB4819.eurprd07.prod.outlook.com (20.178.19.14) by
 AM0PR07MB5617.eurprd07.prod.outlook.com (20.178.82.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.11; Wed, 21 Aug 2019 08:39:57 +0000
Received: from AM0PR07MB4819.eurprd07.prod.outlook.com
 ([fe80::3855:624c:a577:48dd]) by AM0PR07MB4819.eurprd07.prod.outlook.com
 ([fe80::3855:624c:a577:48dd%4]) with mapi id 15.20.2199.011; Wed, 21 Aug 2019
 08:39:57 +0000
From:   "Tilmans, Olivier (Nokia - BE/Antwerp)" 
        <olivier.tilmans@nokia-bell-labs.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Olga Albisser <olga@albisser.org>,
        "De Schepper, Koen (Nokia - BE/Antwerp)" 
        <koen.de_schepper@nokia-bell-labs.com>,
        "Tilmans, Olivier (Nokia - BE/Antwerp)" 
        <olivier.tilmans@nokia-bell-labs.com>,
        Bob Briscoe <research@bobbriscoe.net>,
        Henrik Steen <henrist@henrist.net>
Subject: [PATCH iproute2-next v2] tc: add dualpi2 scheduler module
Thread-Topic: [PATCH iproute2-next v2] tc: add dualpi2 scheduler module
Thread-Index: AQHVV/wDlLIxbiOWN0udLULzxJneMQ==
Date:   Wed, 21 Aug 2019 08:39:57 +0000
Message-ID: <20190821083724.507-1-olivier.tilmans@nokia-bell-labs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0087.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::27) To AM0PR07MB4819.eurprd07.prod.outlook.com
 (2603:10a6:208:f3::14)
x-mailer: git-send-email 2.22.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=olivier.tilmans@nokia-bell-labs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [131.228.32.177]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5d426d40-a4c3-4415-cb5e-08d726132561
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR07MB5617;
x-ms-traffictypediagnostic: AM0PR07MB5617:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR07MB5617EC059DD3D2429812BB52E0AA0@AM0PR07MB5617.eurprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 0136C1DDA4
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(39860400002)(376002)(136003)(396003)(54534003)(189003)(199004)(1671002)(6116002)(3846002)(2906002)(59246006)(53946003)(66574012)(1076003)(81166006)(71190400001)(71200400001)(256004)(2616005)(305945005)(7736002)(476003)(486006)(14444005)(8676002)(81156014)(86362001)(66066001)(66946007)(66476007)(66556008)(64756008)(66446008)(54906003)(14454004)(102836004)(5660300002)(26005)(52116002)(6506007)(386003)(6306002)(53936002)(30864003)(4326008)(25786009)(109986005)(99286004)(6436002)(966005)(186003)(6486002)(478600001)(36756003)(50226002)(8936002)(6512007)(316002)(579004);DIR:OUT;SFP:1102;SCL:1;SRVR:AM0PR07MB5617;H:AM0PR07MB4819.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:0;
received-spf: None (protection.outlook.com: nokia-bell-labs.com does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kgb4N8TQFG/AdbaUcCkjlQEziPf4HAifmhqN1KXvQntyMu8FisNCGe032pkt7NE45sywALxyzkAi/vjUlckFLG7KFPM4cLYRvTorUDMrxfy7CMvk/Gnji5WNIopTwF8WgFm+V7DC7ZLH1vjL0UJo9UvVCpIGdeXVa5xu+MXFaNRPlUbEm9Z5fHeXVjF3Gun1q4oxi3zEhzH9j6nKtUhJ+xRMZ49m8Svh7hnLyyWTobxVbTEH+FiKbj4AWd2cA5zvThN2/w+eI9p2dASysPE2a0hlmrdOK/ffSuJtB4KJbpZ5Rljnfu5moVHa58NBYpmrNgmVmdjqMr+pmG8xmwSRjIAJb/l6Fr+WsHNz3CUEKucNCaSMoB7iT9Q2kc+/f+yqDAjqBQLTiKt4jU8dIBkvu8clnwAvm7Xb4c4fxV5WgTM=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nokia-bell-labs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d426d40-a4c3-4415-cb5e-08d726132561
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Aug 2019 08:39:57.2642
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vtKOQnslYYqcfkaZ/HsYipp5qChSbPrgFGlkz3UC3qsXhBN0mqNT3iwDINIQ9RzRrMwLpBgbAIycDMAlvoNhC+FBrVtUPQnwh4g5apH/hDxoXEBdjd5KqaKw6blnEMP+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB5617
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Olga Albisser <olga@albisser.org>

DualPI2 AQM is a combination of the DualQ Coupled-AQM with a PI2
base-AQM, able to control scalable congestion controls like DCTCP
and TCP-Prague, implemented as a Linux qdisc.

This patch adds support to tc to configure it through its netlink
interface.

Signed-off-by: Olga Albisser <olga@albisser.org>
Signed-off-by: Koen De Schepper <koen.de_schepper@nokia-bell-labs.com>
Signed-off-by: Oliver Tilmans <olivier.tilmans@nokia-bell-labs.com>
Signed-off-by: Bob Briscoe <research@bobbriscoe.net>
Signed-off-by: Henrik Steen <henrist@henrist.net>
---

Notes:
    Changelog:
    * v1 -> v2
      - Update against revised Netlink defines
      - Aligned bound checks with kernel ones
      - Simplified set of parameters

 include/uapi/linux/pkt_sched.h |  33 +++
 include/utils.h                |   8 +
 man/man8/tc-dualpi2.8          | 203 +++++++++++++++
 tc/Makefile                    |   1 +
 tc/q_dualpi2.c                 | 439 +++++++++++++++++++++++++++++++++
 5 files changed, 684 insertions(+)
 create mode 100644 man/man8/tc-dualpi2.8
 create mode 100644 tc/q_dualpi2.c

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.=
h
index 18f18529..5f31ba46 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1180,4 +1180,37 @@ enum {
=20
 #define TCA_TAPRIO_ATTR_MAX (__TCA_TAPRIO_ATTR_MAX - 1)
=20
+/* DUALPI2 */
+enum {
+	TCA_DUALPI2_UNSPEC,
+	TCA_DUALPI2_LIMIT,		/* Packets */
+	TCA_DUALPI2_TARGET,		/* us */
+	TCA_DUALPI2_TUPDATE,		/* us */
+	TCA_DUALPI2_ALPHA,		/* Hz scaled up by 256 */
+	TCA_DUALPI2_BETA,		/* HZ scaled up by 256 */
+	TCA_DUALPI2_STEP_THRESH,	/* Packets or us */
+	TCA_DUALPI2_STEP_PACKETS,	/* Whether STEP_THRESH is in packets */
+	TCA_DUALPI2_COUPLING,		/* Coupling factor between queues */
+	TCA_DUALPI2_DROP_OVERLOAD,	/* Whether to drop on overload */
+	TCA_DUALPI2_DROP_EARLY,		/* Whether to drop on enqueue */
+	TCA_DUALPI2_C_PROTECTION,	/* Percentage */
+	TCA_DUALPI2_ECN_MASK,		/* L4S queue classification mask */
+	TCA_DUALPI2_PAD,
+	__TCA_DUALPI2_MAX
+};
+
+#define TCA_DUALPI2_MAX   (__TCA_DUALPI2_MAX - 1)
+
+struct tc_dualpi2_xstats {
+	__u32 prob;             /* current probability */
+	__u32 delay_c;		/* current delay in C queue */
+	__u32 delay_l;		/* current delay in L queue */
+	__s32 credit;		/* current c_protection credit */
+	__u32 packets_in_c;	/* number of packets enqueued in C queue */
+	__u32 packets_in_l;	/* number of packets enqueued in L queue */
+	__u32 maxq;             /* maximum queue size */
+	__u32 ecn_mark;         /* packets marked with ecn*/
+	__u32 step_marks;	/* ECN marks due to the step AQM */
+};
+
 #endif
diff --git a/include/utils.h b/include/utils.h
index 794d3605..0c8f43e8 100644
--- a/include/utils.h
+++ b/include/utils.h
@@ -279,6 +279,14 @@ unsigned int print_name_and_link(const char *fmt,
 	_min1 < _min2 ? _min1 : _min2; })
 #endif
=20
+#ifndef max
+# define max(x, y) ({			\
+	typeof(x) _max1 =3D (x);		\
+	typeof(y) _max2 =3D (y);		\
+	(void) (&_max1 =3D=3D &_max2);	\
+	_max1 > _max2 ? _max1 : _max2; })
+#endif
+
 #ifndef __check_format_string
 # define __check_format_string(pos_str, pos_args) \
 	__attribute__ ((format (printf, (pos_str), (pos_args))))
diff --git a/man/man8/tc-dualpi2.8 b/man/man8/tc-dualpi2.8
new file mode 100644
index 00000000..d325ccda
--- /dev/null
+++ b/man/man8/tc-dualpi2.8
@@ -0,0 +1,203 @@
+.TH DUALPI2 8 "13 December 2018" "iproute2" "Linux"
+
+.SH NAME
+DUALPI2 \- Dual Queue Proportional Integral Controller AQM - Improved with=
 a square
+.SH SYNOPSIS
+.sp
+.ad l
+.in +8
+.ti -8
+.BR tc " " qdisc " ... " dualpi2
+.br
+.RB "[ " limit
+.IR PACKETS " ]"
+.br
+.RB "[ " coupling_factor
+.IR NUMBER " ]"
+.br
+.RB "[ " step_thresh
+.IR TIME | PACKETS " ]"
+.br
+.RB "[ " drop_on_overload " | " overflow " ]"
+.br
+.RB "[ " drop_enqueue " | " drop_dequeue " ]"
+.br
+.RB "[ " l4s_ect " | " any_ect " ]"
+.br
+.RB "[ " classic_protection
+.IR PERCENTAGE " ] "
+.br
+.RB "[ " max_rtt
+.IR TIME=20
+.RB " [ " typical_rtt=20
+.IR TIME " ]] "
+.br
+.RB "[ " target
+.IR TIME " ]"
+.br
+.RB "[ " tupdate
+.IR TIME " ]"
+.br
+.RB "[ " alpha
+.IR float " ]"
+.br
+.RB "[ " beta
+.IR float " ] "
+
+.SH DESCRIPTION
+DUALPI2 AQM is a combination of the DUALQ Coupled-AQM with a PI2 base-AQM.=
 The PI2 AQM (details can be found in the paper cited below) is in turn bot=
h an extension and a simplification of the PIE AQM. PI2 makes quite some PI=
E heuristics unnecessary, while being able to control scalable congestion c=
ontrols like DCTCP and TCP-Prague. With PI2, both Reno/Cubic can be used in=
 parallel with DCTCP, maintaining window fairness. DUALQ provides latency s=
eparation between low latency DCTCP flows and Reno/Cubic flows that need a =
bigger queue. The main design goals are:
+.PD 0
+.IP \(bu 4
+L4S - Low Loss, Low Latency and Scalable congestion control support
+.IP \(bu 4
+DualQ option to separate the L4S traffic in a low latency queue, without h=
arming remaining traffic that is scheduled in classic queue due to congesti=
on-coupling
+.IP \(bu 4
+Configurable overload strategies
+.IP \(bu 4
+Use of sojourn time to reliably estimate queue delay
+.IP \(bu 4
+Simple implementation
+.IP \(bu 4
+Guaranteed stability and fast responsiveness
+.PD
+
+.SH ALGORITHM
+DUALPI2 is designed to provide low loss and low latency to L4S traffic, wi=
thout harming classic traffic. Every update interval a new internal base pr=
obability is calculated, based on queue delay. The base probability is upda=
ted with a delta based on the difference between the current queue delay an=
d the=20
+.I "" target
+delay, and the queue growth comparing with the queuing delay during the pr=
evious=20
+.I "" tupdate
+interval. The integral gain factor=20
+.RB "" alpha
+is used to correct slowly enough any persistent standing queue error to th=
e user specified target delay, while the proportional gain factor
+.RB "" beta
+is used to quickly compensate for queue changes (growth or shrink).
+
+The updated base probability is used as input to decide to mark and drop p=
ackets. DUALPI2 scales the calculated probability for each of the two queue=
s accordingly. For the L4S queue, the probability is multiplied by a=20
+.RB "" coupling_factor
+, while for the classic queue, it is squared to compensate the squareroot =
rate equation of Reno/Cubic. The ECT identifier (
+.RB "" l4s_ect | any_ect
+) is used to classify traffic into respective queues.
+
+If DUALPI2 AQM has detected overload (when excessive non-responsive traffi=
c is sent), it can signal congestion solely using=20
+.RB "" drop
+, irrespective of the ECN field, or alternatively limit the drop probabili=
ty and let the queue grow and eventually=20
+.RB "" overflow
+(like tail-drop).
+
+Additional details can be found in the draft cited below.
+
+.SH PARAMETERS
+.TP
+.BI limit " PACKETS"
+Limit the number of packets that can be enqueued. Incoming packets are dro=
pped when this limit
+is reached. This limit is common for the L4S and Classic queue. Defaults t=
o
+.I 10000
+packets. This is about 125ms delay on a 1Gbps link.
+.TP
+.BI coupling_factor " NUMBER"
+Set the coupling rate factor between Classic and L4S. Defaults to
+.I 2
+.TP
+.B l4s_ect | any_ect
+Configures the ECT classifier. Packets whose ECT codepoint matches this ar=
e sent to the L4S queue where they receive a scalable marking. Defaults to
+.I l4s_ect
+, i.e., the L4S identifier ECT(1). Setting this to
+.I any_ect
+causes all packets whose ECN field is not zero to be sent to the L4S queue=
. This enables to be backward compatible with, e.g., DCTCP.
+.PD
+.BI step_thresh " TIME | PACKETS"
+Set the step threshold for the L4S queue. This will cause packets with a s=
ojourn time exceeding the threshold to always be marked. This value can eit=
her be specified using time units (i.e., us, ms, s), or in packets (pkt, pa=
cket(s)). A velue without units is assumed to be in time (us). If defining =
the step in packets, be sure to disable GRO on the ingress interfaces. Defa=
ults to
+.I 1ms
+.
+.TP
+.B drop_on_overload  |  overflow
+Control the overload strategy.=20
+.I drop_on_overload
+preserves the delay in the L4S queue by dropping in both queues on overloa=
d.
+.I overflow
+sacrifices delay to avoid losses, eventually resulting in a taildrop behav=
ior once
+.I limit
+is reached. Defaults to
+.I drop_on_overload.
+.PD
+.TP
+.B drop_enqueue | drop_dequeue
+Decide when packets are PI-based dropped or marked. The
+.I step_thresh=20
+based L4S marking is always at dequeue. Defaults to
+.I drop_dequeue
+.PD
+.TP
+.BI classic_protection " PERCENTAGE
+Protects the classic queue from unresponsive traffic in the L4S queue. Thi=
s bounds the maximal delay in the C queue to be
+.I (100 - PERCENTAGE)
+times greater than the one in the L queue. Defaults to
+.I 10
+.TP
+.BI typical_rtt " TIME"
+.PD 0
+.TP
+.PD
+.BI max_rtt " TIME"
+Specify the maximum round trip time (RTT) and/or the typical RTT of the tr=
affic
+that will be controlled by dualpi2. If either of
+.I max_rtt
+or
+.I typical_rtt
+is not specified, the missing value will be computed from the following=20
+relationship:
+.I max_rtt =3D typical_rtt * 6.
+If any of these parameters is given, it will be used to automatically comp=
ute
+suitable values for
+.I alpha, beta, target, and tupdate,
+according to the relationship from the appendix A.1 in the IETF draft, to
+achieve a stable control. Consequently, those derived values will override=
 their
+eventual user-provided ones. The default range of operation for the qdisc =
uses
+.I max_rtt =3D 100ms
+and=20
+.I typical_rtt =3D 15ms
+, which is suited to control internet traffic.
+.TP
+.BI target " TIME"
+Set the expected queue delay. Defaults to
+.I 15
+ms.
+.TP
+.BI tupdate " TIME"
+Set the frequency at which the system drop probability is calculated. Defa=
ults to
+.I 16
+ms. This should be a third of the max RTT supported.
+.TP
+.BI alpha " float"
+.PD 0
+.TP
+.PD
+.BI beta " float"
+Set alpha and beta, the integral and proportional gain factors in Hz for t=
he PI controller. These can be calculated based on control theory. Defaults=
 are
+.I 0.16
+and
+.I 3.2
+Hz, which provide stable control for RTT's up to 100ms with tupdate of 16.=
 Be aware, unlike with PIE, these are the real unscaled gain factors.
+
+.SH EXAMPLES
+Setting DUALPI2 for the Internet with default parameters:
+ # sudo tc qdisc add dev eth0 root dualpi2
+
+Setting DUALPI2 for datacenter with legacy DCTCP using ECT(0):
+ # sudo tc qdisc add dev eth0 root dualpi2 any_ect
+
+.SH SEE ALSO
+.BR tc (8),
+.BR tc-pie (8)
+
+.SH SOURCES
+.IP \(bu 4
+IETF draft submission is at https://www.ietf.org/id/draft-ietf-tsvwg-aqm-d=
ualq-coupled
+.IP \(bu 4
+CoNEXT '16 Proceedings of the 12th International on Conference on emerging=
 Networking EXperiments and Technologies : "PI2: A
+Linearized AQM for both Classic and Scalable TCP"
+
+.SH AUTHORS
+DUALPI2 was implemented by Koen De Schepper, Olga Albisser, Henrik Steen, =
and Olivier Tilmans also the authors of
+this man page. Please report bugs and corrections to the Linux networking
+development mailing list at <netdev@vger.kernel.org>.
diff --git a/tc/Makefile b/tc/Makefile
index 14171a28..35f02da3 100644
--- a/tc/Makefile
+++ b/tc/Makefile
@@ -9,6 +9,7 @@ SHARED_LIBS ?=3D y
=20
 TCMODULES :=3D
 TCMODULES +=3D q_fifo.o
+TCMODULES +=3D q_dualpi2.o
 TCMODULES +=3D q_sfq.o
 TCMODULES +=3D q_red.o
 TCMODULES +=3D q_prio.o
diff --git a/tc/q_dualpi2.c b/tc/q_dualpi2.c
new file mode 100644
index 00000000..1fda2ec3
--- /dev/null
+++ b/tc/q_dualpi2.c
@@ -0,0 +1,439 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright (C) 2019 Nokia.
+ *
+ * DualQ PI Improved with a Square (dualpi2)
+ * Supports controlling scalable congestion controls (DCTCP, etc...)
+ * Supports DualQ with PI2
+ * Supports L4S ECN identifier
+ * Author: Koen De Schepper <koen.de_schepper@nokia-bell-labs.com>
+ * Author: Olga Albisser <olga@albisser.org>
+ * Author: Henrik Steen <henrist@henrist.net>
+ */
+
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <syslog.h>
+#include <fcntl.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <string.h>
+#include <math.h>
+#include <errno.h>
+
+#include "utils.h"
+#include "tc_util.h"
+
+#define MAX_PROB ((uint32_t)(~((uint32_t)0)))
+#define DEFAULT_ALPHA_BETA ((uint32_t)(~((uint32_t)0)))
+#define ALPHA_BETA_MAX ((2 << 23) - 1) /* see net/sched/sch_dualpi2.c */
+#define ALPHA_BETA_SCALE (1 << 8)
+#define RTT_TYP_TO_MAX 6
+
+enum {
+	INET_ECN_NOT_ECT =3D 0,
+	INET_ECN_ECT_1 =3D 1,
+	INET_ECN_ECT_0 =3D 2,
+	INET_ECN_CE =3D 3,
+	INET_ECN_MASK =3D 3,
+};
+
+static const char *get_ecn_type(uint8_t ect)
+{
+	switch (ect & INET_ECN_MASK) {
+		case INET_ECN_ECT_1: return "l4s_ect";
+		case INET_ECN_ECT_0:
+		case INET_ECN_MASK: return "any_ect";
+		default:
+			fprintf(stderr,
+				"Warning: Unexpected ecn type %u!\n", ect);
+			return "";
+	}
+}
+
+static void explain(void)
+{
+	fprintf(stderr, "Usage: ... dualpi2\n");
+	fprintf(stderr, "               [limit PACKETS]\n");
+	fprintf(stderr, "               [coupling_factor NUMBER]\n");
+	fprintf(stderr, "               [step_thresh TIME|PACKETS]\n");
+	fprintf(stderr, "               [drop_on_overload|overflow]\n");
+	fprintf(stderr, "               [drop_enqueue|drop_dequeue]\n");
+	fprintf(stderr, "               [classic_protection PERCENTAGE]\n");
+	fprintf(stderr, "               [max_rtt TIME [typical_rtt TIME]]\n");
+	fprintf(stderr, "               [target TIME] [tupdate TIME]\n");
+	fprintf(stderr, "               [alpha ALPHA] [beta BETA]\n");
+}
+
+static int get_float(float *val, const char *arg, float min, float max)
+{
+        float res;
+        char *ptr;
+
+        if (!arg || !*arg)
+                return -1;
+        res =3D strtof(arg, &ptr);
+        if (!ptr || ptr =3D=3D arg || *ptr)
+                return -1;
+	if (res < min || res > max)
+		return -1;
+        *val =3D res;
+        return 0;
+}
+
+static int get_packets(uint32_t *val, const char *arg)
+{
+	unsigned long res;
+	char *ptr;
+
+	if (!arg || !*arg)
+		return -1;
+	res =3D strtoul(arg, &ptr, 10);
+	if (!ptr || ptr =3D=3D arg ||
+	    (strcmp(ptr, "pkt") && strcmp(ptr, "packet") &&
+	     strcmp(ptr, "packets")))
+		return -1;
+	if (res =3D=3D ULONG_MAX && errno =3D=3D ERANGE)
+		return -1;
+	if (res > 0xFFFFFFFFUL)
+		return -1;
+	*val =3D res;
+	return 0;
+}
+
+static int parse_alpha_beta(const char *name, char *argv, uint32_t *field)
+{
+
+	float field_f;
+
+	if (get_float(&field_f, argv, 0.0, ALPHA_BETA_MAX)) {
+		fprintf(stderr, "Illegal \"%s\"\n", name);
+		return -1;
+	}
+	else if (field_f < 1.0f / ALPHA_BETA_SCALE)
+		fprintf(stderr, "Warning: \"%s\" is too small and will be "
+			"rounded to zero.\n", name);
+	*field =3D (uint32_t)(field_f * ALPHA_BETA_SCALE);
+	return 0;
+}
+
+static int try_get_percentage(int *val, const char *arg, int base)
+{
+	long res;
+	char *ptr;
+
+	if (!arg || !*arg)
+		return -1;
+	res =3D strtol(arg, &ptr, base);
+	if (!ptr || ptr =3D=3D arg || (*ptr && strcmp(ptr, "%")))
+		return -1;
+	if (res =3D=3D ULONG_MAX && errno =3D=3D ERANGE)
+		return -1;
+	if (res < 0 || res > 100)
+		return -1;
+
+	*val =3D res;
+	return 0;
+}
+
+static int dualpi2_parse_opt(struct qdisc_util *qu, int argc, char **argv,
+			 struct nlmsghdr *n, const char* dev)
+{
+	uint32_t limit =3D 0;
+	uint32_t target =3D 0;
+	uint32_t tupdate =3D 0;
+	uint32_t alpha =3D DEFAULT_ALPHA_BETA;
+	uint32_t beta =3D DEFAULT_ALPHA_BETA;
+	int32_t coupling_factor =3D -1;
+	uint8_t ecn_mask =3D INET_ECN_NOT_ECT;
+	bool step_packets =3D false;
+	uint32_t step_thresh =3D 0;
+	int c_protection =3D -1;
+	int drop_early =3D -1;
+	int drop_overload =3D -1;
+	uint32_t rtt_max =3D 0;
+	uint32_t rtt_typ =3D 0;
+	struct rtattr *tail;
+
+	while (argc > 0) {
+		if (strcmp(*argv, "limit") =3D=3D 0) {
+			NEXT_ARG();
+			if (get_u32(&limit, *argv, 10)) {
+				fprintf(stderr, "Illegal \"limit\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "target") =3D=3D 0) {
+			NEXT_ARG();
+			if (get_time(&target, *argv)) {
+				fprintf(stderr, "Illegal \"target\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "tupdate") =3D=3D 0) {
+			NEXT_ARG();
+			if (get_time(&tupdate, *argv)) {
+				fprintf(stderr, "Illegal \"tupdate\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "alpha") =3D=3D 0) {
+			NEXT_ARG();
+			if (parse_alpha_beta("alpha", *argv, &alpha))
+				return -1;
+		} else if (strcmp(*argv, "beta") =3D=3D 0) {
+			NEXT_ARG();
+			if (parse_alpha_beta("beta", *argv, &beta))
+				return -1;
+		} else if (strcmp(*argv, "coupling_factor") =3D=3D 0) {
+			NEXT_ARG();
+			if (get_s32(&coupling_factor, *argv, 0) ||
+			    coupling_factor > 0xFFUL ||coupling_factor < 0) {
+				fprintf(stderr,
+					"Illegal \"coupling_factor\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "l4s_ect") =3D=3D 0)
+			ecn_mask =3D INET_ECN_ECT_1;
+		else if (strcmp(*argv, "any_ect") =3D=3D 0)
+			ecn_mask =3D INET_ECN_MASK;
+		else if (strcmp(*argv, "step_thresh") =3D=3D 0) {
+			NEXT_ARG();
+			/* First assume that this is specified in time */
+			if (get_time(&step_thresh, *argv)) {
+				/* Then packets */
+				if (get_packets(&step_thresh, *argv)) {
+					fprintf(stderr,
+						"Illegal \"step_thresh\"\n");
+					return -1;
+				}
+				step_packets =3D true;
+			}
+		} else if (strcmp(*argv, "overflow") =3D=3D 0) {
+                        drop_overload =3D 0;
+		} else if (strcmp(*argv, "drop_on_overload") =3D=3D 0) {
+                        drop_overload =3D 1;
+		} else if (strcmp(*argv, "drop_enqueue") =3D=3D 0) {
+			drop_early =3D 1;
+		} else if (strcmp(*argv, "drop_dequeue") =3D=3D 0) {
+			drop_early =3D 0;
+		} else if (strcmp(*argv, "classic_protection") =3D=3D 0) {
+                        NEXT_ARG();
+                        if (try_get_percentage(&c_protection, *argv, 10) |=
|
+			    c_protection > 100 ||
+			    c_protection < 0) {
+                                fprintf(stderr,
+					"Illegal \"classic_protection\"\n");
+                                return -1;
+                        }
+		} else if (strcmp(*argv, "max_rtt") =3D=3D 0) {
+			NEXT_ARG();
+			if (get_time(&rtt_max, *argv)) {
+				fprintf(stderr, "Illegal \"rtt_max\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "typical_rtt") =3D=3D 0) {
+			NEXT_ARG();
+			if (get_time(&rtt_typ, *argv)) {
+				fprintf(stderr, "Illegal \"rtt_typ\"\n");
+				return -1;
+			}
+		} else if (strcmp(*argv, "help") =3D=3D 0) {
+			explain();
+			return -1;
+		} else {
+			fprintf(stderr, "What is \"%s\"?\n", *argv);
+			explain();
+			return -1;
+		}
+		--argc;
+		++argv;
+	}
+
+	if (rtt_max || rtt_typ) {
+		float alpha_f, beta_f;
+		SPRINT_BUF(max_rtt_t);
+		SPRINT_BUF(typ_rtt_t);
+		SPRINT_BUF(tupdate_t);
+		SPRINT_BUF(target_t);
+
+		if (!rtt_typ)
+			rtt_typ =3D max(rtt_max / RTT_TYP_TO_MAX, 1U);
+		else if (!rtt_max)
+			rtt_max =3D rtt_typ * RTT_TYP_TO_MAX;
+		else if (rtt_typ > rtt_max) {
+			fprintf(stderr, "typical_rtt must be >=3D max_rtt!\n");
+			return -1;
+		}
+		if (alpha !=3D DEFAULT_ALPHA_BETA || beta !=3D DEFAULT_ALPHA_BETA ||
+		    tupdate || target)
+			fprintf(stderr, "rtt_max is specified, ignoring values "
+				"specified for alpha/beta/tupdate/target\n");
+		target =3D rtt_typ;
+		tupdate =3D max(min(rtt_typ, rtt_max / 3), 1U);
+		alpha_f =3D (double)tupdate / ((double)rtt_max * rtt_max)
+			* TIME_UNITS_PER_SEC * 0.1f;
+		beta_f =3D 0.3f / (float)rtt_max * TIME_UNITS_PER_SEC;
+		if (beta_f > ALPHA_BETA_MAX) {
+			fprintf(stderr, "max_rtt=3D%s is too low and cause beta "
+				"to overflow!\n",
+				sprint_time(rtt_max, max_rtt_t));
+			return -1;
+		}
+		if (alpha_f < 1.0f / ALPHA_BETA_SCALE ||
+		    beta_f < 1.0f / ALPHA_BETA_SCALE) {
+			fprintf(stderr, "max_rtt=3D%s is too large and will "
+				"cause alpha=3D%f and/or beta=3D%f to be rounded "
+				"down to 0!\n", sprint_time(rtt_max, max_rtt_t),
+				alpha_f, beta_f);
+			return -1;
+		}
+		fprintf(stderr, "Auto-configuring parameters using "
+			"[max_rtt: %s, typical_rtt: %s]: "
+			"target=3D%s tupdate=3D%s alpha=3D%f beta=3D%f\n",
+			sprint_time(rtt_max, max_rtt_t),
+			sprint_time(rtt_typ, typ_rtt_t),
+			sprint_time(target, target_t),
+			sprint_time(tupdate, tupdate_t), alpha_f, beta_f);
+		alpha =3D alpha_f * ALPHA_BETA_SCALE;
+		beta =3D beta * ALPHA_BETA_SCALE;
+	}
+
+	tail =3D addattr_nest(n, 1024, TCA_OPTIONS);
+	if (limit)
+		addattr32(n, 1024, TCA_DUALPI2_LIMIT, limit);
+	if (tupdate)
+		addattr32(n, 1024, TCA_DUALPI2_TUPDATE, tupdate);
+	if (target)
+		addattr32(n, 1024, TCA_DUALPI2_TARGET, target);
+	if (alpha !=3D DEFAULT_ALPHA_BETA)
+		addattr32(n, 1024, TCA_DUALPI2_ALPHA, alpha);
+	if (beta !=3D DEFAULT_ALPHA_BETA)
+		addattr32(n, 1024, TCA_DUALPI2_BETA, beta);
+	if (ecn_mask !=3D INET_ECN_NOT_ECT)
+		addattr8(n, 1024, TCA_DUALPI2_ECN_MASK, ecn_mask);
+	if (drop_overload !=3D -1)
+		addattr8(n, 1024, TCA_DUALPI2_DROP_OVERLOAD, drop_overload);
+	if (coupling_factor !=3D -1)
+		addattr8(n, 1024, TCA_DUALPI2_COUPLING, coupling_factor);
+	if (step_thresh) {
+		addattr32(n, 1024, TCA_DUALPI2_STEP_THRESH, step_thresh);
+                addattr8(n, 1024, TCA_DUALPI2_STEP_PACKETS, step_packets);
+	}
+	if (drop_early !=3D -1)
+		addattr8(n, 1024, TCA_DUALPI2_DROP_EARLY, drop_early);
+	if (c_protection !=3D -1)
+		addattr8(n, 1024, TCA_DUALPI2_C_PROTECTION, c_protection);
+	addattr_nest_end(n, tail);
+	return 0;
+}
+
+static int dualpi2_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr=
 *opt)
+{
+	struct rtattr *tb[TCA_DUALPI2_MAX + 1];
+	uint32_t tupdate;
+	uint32_t target;
+	uint32_t step_thresh;
+	bool step_packets =3D false;
+	SPRINT_BUF(b1);
+
+	if (opt =3D=3D NULL)
+		return 0;
+
+	parse_rtattr_nested(tb, TCA_DUALPI2_MAX, opt);
+
+	if (tb[TCA_DUALPI2_LIMIT] &&
+	    RTA_PAYLOAD(tb[TCA_DUALPI2_LIMIT]) >=3D sizeof(__uint32_t))
+		fprintf(f, "limit %up ",
+			rta_getattr_u32(tb[TCA_DUALPI2_LIMIT]));
+	if (tb[TCA_DUALPI2_TARGET] &&
+	    RTA_PAYLOAD(tb[TCA_DUALPI2_TARGET]) >=3D sizeof(__uint32_t)) {
+		target =3D rta_getattr_u32(tb[TCA_DUALPI2_TARGET]);
+		fprintf(f, "target %s ", sprint_time(target, b1));
+	}
+	if (tb[TCA_DUALPI2_TUPDATE] &&
+	    RTA_PAYLOAD(tb[TCA_DUALPI2_TUPDATE]) >=3D sizeof(__uint32_t)) {
+		tupdate =3D rta_getattr_u32(tb[TCA_DUALPI2_TUPDATE]);
+		fprintf(f, "tupdate %s ", sprint_time(tupdate, b1));
+	}
+	if (tb[TCA_DUALPI2_ALPHA] &&
+	    RTA_PAYLOAD(tb[TCA_DUALPI2_ALPHA]) >=3D sizeof(__uint32_t)) {
+		fprintf(f, "alpha %f ",
+			(float)rta_getattr_u32(tb[TCA_DUALPI2_ALPHA]) /
+			ALPHA_BETA_SCALE);
+	}
+	if (tb[TCA_DUALPI2_BETA] &&
+	    RTA_PAYLOAD(tb[TCA_DUALPI2_BETA]) >=3D sizeof(__uint32_t)) {
+		fprintf(f, "beta %f ",
+			(float)rta_getattr_u32(tb[TCA_DUALPI2_BETA]) /
+			ALPHA_BETA_SCALE);
+	}
+	if (tb[TCA_DUALPI2_ECN_MASK] &&
+	    RTA_PAYLOAD(tb[TCA_DUALPI2_ECN_MASK]) >=3D sizeof(__u8))
+		fprintf(f, "%s ",
+			get_ecn_type(rta_getattr_u8(tb[TCA_DUALPI2_ECN_MASK])));
+	if (tb[TCA_DUALPI2_COUPLING] &&
+	    RTA_PAYLOAD(tb[TCA_DUALPI2_COUPLING]) >=3D sizeof(__u8))
+		fprintf(f, "coupling_factor %u ",
+			rta_getattr_u8(tb[TCA_DUALPI2_COUPLING]));
+	if (tb[TCA_DUALPI2_DROP_OVERLOAD] &&
+	    RTA_PAYLOAD(tb[TCA_DUALPI2_DROP_OVERLOAD]) >=3D sizeof(__u8)) {
+		if (rta_getattr_u8(tb[TCA_DUALPI2_DROP_OVERLOAD]))
+			fprintf(f, "drop_on_overload ");
+		else
+			fprintf(f, "overflow ");
+	}
+	if (tb[TCA_DUALPI2_STEP_PACKETS] &&
+            RTA_PAYLOAD(tb[TCA_DUALPI2_STEP_PACKETS]) >=3D sizeof(__u8) &&
+	    rta_getattr_u8(tb[TCA_DUALPI2_STEP_PACKETS]))
+                        step_packets =3D true;
+	if (tb[TCA_DUALPI2_STEP_THRESH] &&
+	    RTA_PAYLOAD(tb[TCA_DUALPI2_STEP_THRESH]) >=3D sizeof(__uint32_t)) {
+		step_thresh =3D rta_getattr_u32(tb[TCA_DUALPI2_STEP_THRESH]);
+		if (step_packets)
+			fprintf(f, "step_thresh %upkt ", step_thresh);
+		else
+			fprintf(f, "step_thresh %s ",
+				sprint_time(step_thresh, b1));
+	}
+	if (tb[TCA_DUALPI2_DROP_EARLY] &&
+	    RTA_PAYLOAD(tb[TCA_DUALPI2_DROP_EARLY]) >=3D sizeof(__u8)) {
+		if (rta_getattr_u8(tb[TCA_DUALPI2_DROP_EARLY]))
+			fprintf(f, "drop_enqueue ");
+		else
+			fprintf(f, "drop_dequeue ");
+	}
+	if (tb[TCA_DUALPI2_C_PROTECTION] &&
+            RTA_PAYLOAD(tb[TCA_DUALPI2_C_PROTECTION]) >=3D sizeof(__u8))
+                fprintf(f, "classic_protection %u%% ",
+			rta_getattr_u8(tb[TCA_DUALPI2_C_PROTECTION]));
+
+	return 0;
+}
+
+static int dualpi2_print_xstats(struct qdisc_util *qu, FILE *f,
+			    struct rtattr *xstats)
+{
+	struct tc_dualpi2_xstats *st;
+
+	if (xstats =3D=3D NULL)
+		return 0;
+
+	if (RTA_PAYLOAD(xstats) < sizeof(*st))
+		return -1;
+
+	st =3D RTA_DATA(xstats);
+	fprintf(f, "prob %f delay_c %uus delay_l %uus\n",
+		(double)st->prob / (double)MAX_PROB, st->delay_c, st->delay_l);
+	fprintf(f, "pkts_in_c %u pkts_in_l %u maxq %u\n",
+		st->packets_in_c, st->packets_in_l, st->maxq);
+	fprintf(f, "ecn_mark %u step_marks %u\n", st->ecn_mark, st->step_marks);
+	fprintf(f, "credit %d (%c)\n", st->credit, st->credit > 0 ? 'C' : 'L');
+	return 0;
+
+}
+
+struct qdisc_util dualpi2_qdisc_util =3D {
+	.id =3D "dualpi2",
+	.parse_qopt	=3D dualpi2_parse_opt,
+	.print_qopt	=3D dualpi2_print_opt,
+	.print_xstats	=3D dualpi2_print_xstats,
+};
--=20
2.22.0

