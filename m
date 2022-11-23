Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F39A46365AD
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:25:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239056AbiKWQZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 11:25:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237578AbiKWQZf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:25:35 -0500
X-Greylist: delayed 589 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Nov 2022 08:25:34 PST
Received: from dispatch1-eu1.ppe-hosted.com (dispatch1-eu1.ppe-hosted.com [185.183.29.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713428CFD4
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 08:25:34 -0800 (PST)
Received: from dispatch1-eu1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A149A214F6
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 16:15:45 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04lp2050.outbound.protection.outlook.com [104.47.12.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EE26D6C0067;
        Wed, 23 Nov 2022 16:15:42 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ri0cal/e+pFIZrNvezplV3TuCsS+kuqfOfrCx4jLWMOuKMn8VF3KxwbGffBoe9ZYNl9jqmwQZVZhXJOXQxjJIWrAw+7ptQ3wDbb2o3UDIRzIyaJ1pYEoOOr2YFKVPxMvQwi8jwSPJPu4dO2VSYDoR4ERWqaQkhu/7N3poufepUzP5gt37wJ964O14R4nd59EQOQhPgt6seQA/Sjz4WBTCEV+U/qn6LNcClmL1E4bfMPvnGm1xhRM5/9sfS9Ll8a6gyZdULIp7uXk7mKiDibrjMhDa0hhI2cwB73fo2R4yCLwFa44se1/ZGdKoQ5N8GL9vk6wz90gL+YWMgI8zZcOIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IEPz0J8ZoW0qfP4k04ADvVwLVxwjXQ3R6SxV46fEmI0=;
 b=DpsbalOLc+0vrvohOM88lwm+x8MzWHM0ExnMZ0nEAzz0LM/eE866mMQAAyw4wgGjfAwp68GoklgXOhfxczezb+loY7ubvVQh9I9BhgQdCwzVvc8Cce77KlYgVKAgvWAm3Ng98MdPPhdYQ1zviIwYQZy/Pe1RIQwSm/FXzKwxRL9RrTBrpZVkdvK78gUZdNO8ma8HzALiavkLUNQ78mgKHkRez68tl0gaVYEMLJGnd44ppGlrsKjIMoldjBCyXwJN439Wrn0TAnjLn/0GcyLgsUQX7GukHtJFi4ZdXjguDZ4JDTCd347HePklsvJgWt42d3O9osspxgbwYLm1NbQBfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IEPz0J8ZoW0qfP4k04ADvVwLVxwjXQ3R6SxV46fEmI0=;
 b=rRRIRspNGIrJ3hICfRfvaLaFk1P71Pr+RYrATAy/WoMBaXeGmwtgkPDq/kZT6Iy9d3MhcM7pEBzr2qufvnzgG3UsqfyT2fTXoWdUJXTd014cFZlB/Zu7Zx/UyurV/M44aGbYtfaVI06qB8pATK/ntO6tOujKT12WPzwyv0Q7tbk=
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com (2603:10a6:20b:aa::25)
 by DU0PR08MB9511.eurprd08.prod.outlook.com (2603:10a6:10:44d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Wed, 23 Nov
 2022 16:15:41 +0000
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::978d:4c38:f2c9:e40f]) by AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::978d:4c38:f2c9:e40f%4]) with mapi id 15.20.5857.017; Wed, 23 Nov 2022
 16:15:41 +0000
From:   Gilad Naaman <gnaaman@drivenets.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Lahav Daniel Schlesinger <lschlesinger@drivenets.com>
Subject: [PATCH iproute2] libnetlink: Fix memory leak in __rtnl_talk_iov()
Thread-Topic: [PATCH iproute2] libnetlink: Fix memory leak in
 __rtnl_talk_iov()
Thread-Index: AQHY/1bV8IwAL023KUKPSsqypkBN8Q==
Date:   Wed, 23 Nov 2022 16:15:41 +0000
Message-ID: <D239DD38-BC1F-42BE-B854-7DED97F11D91@drivenets.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.100.31)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=drivenets.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR08MB4118:EE_|DU0PR08MB9511:EE_
x-ms-office365-filtering-correlation-id: 5920f11d-abaa-46f3-7bf2-08dacd6df78a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fYkAvzv+74FnZAfGRaQJrtf47/WeVB8Y4R49poah7zm5TmlXBL3aN1zbemUkoNAKhL1PjWvTPwNfraM9RRMg0PNTP3JruTQmlC+obz6wg+Xp6dRmYuiRvoih/KriQr4tzTTSHL5ekJHwOz6yXf2BZLTnHY+Dh+4wRw5cUeJDIJmkbnGEZYDMNtqNYIN8yTXPGFQ8dJVCmIkWZ/CJ101mgOLgdwAmBd9EPuGkjYCSdB1QpCPfOt4ovc5xXxvKZXJpvazM5BUjC/ac7/2yuoGunxMJKlV5A9FUKZhfkkCn0td0sVDxJYuVYMpMxn/X8Y1DpyeoX/uUQ1W+e7Ps+lSfrVnY1OqCmnA+27J5Ilg803CPknyQpJweAjTDW56eKaIlQVrU0ZWO7MMhGHYch77QpXMFd0IlgpPfDCN7+PvSSCjOLLGYT9ojQgzrxz61sDC/Fp+flYFz0nmCC7FFVYt8Lq1DQeO+14XfZFokAUpz3ijtZIEWwQENT881EctE/MgF5BR6IZdbzXAMp55M4WoA5lsi2PUmb1uOyOnM7UYMzI15ZLUzg//ew8Jpk+pfG+zu6U3iV3ax2ME7s1tglu5m96+nwJzDUpE8tPBagX9avKO1pc8qMkhqFNPKSu9oTrrftq/BS71zoWjOFROOCKF+gnsALT48ZJnAiBXZ167OvDSx+gkMrrQoovbNj3blb3OjSHeCH32Dp9guJMgut02MLRXmNw5Ktw/dX8Jxwr8Ibsw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4118.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(376002)(39850400004)(136003)(451199015)(122000001)(54906003)(83380400001)(86362001)(2906002)(38070700005)(38100700002)(66556008)(8936002)(4326008)(64756008)(66446008)(66476007)(8676002)(41300700001)(66946007)(5660300002)(26005)(76116006)(91956017)(107886003)(6512007)(6506007)(71200400001)(6486002)(186003)(6916009)(316002)(2616005)(478600001)(36756003)(33656002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jd3P4+40PCx3uF00bi54nmu3XHsBgR5Z6GkwECeiZreV6hCpGabYUx1VzApo?=
 =?us-ascii?Q?jxyS5Xbit6PELceJK+/l2DcohCrJ29yMaaL+N10+tuqmGtuU0HbCBhhUijBi?=
 =?us-ascii?Q?wlegVO1BMULiTj7mPwGIF+xEFzwx3o4H0590RA1JeRptECQYHWPAb+DKW8+c?=
 =?us-ascii?Q?/drJIQOqohRy1tvJWOBaqARK7cMsl50Rh3fb3PmUvOhBgksKG5jzNKf/+Sl6?=
 =?us-ascii?Q?1mOc2A3D5Sd/WUi6PIY4l1R2g0DzH6mW+Sqbm7HxRJ3N6u2reYiWl6r/JqBn?=
 =?us-ascii?Q?KJCzCVMcoDT20Xy0y0JfSS/Ax02lgEz6jC9UNUTAm4031+o1Xbs97obqgt9j?=
 =?us-ascii?Q?3XQBgn5baUxxM1qYKosQn4JM2Q2vMbVtm74bKTCYxJGw0xs+N+exgeXjMJe6?=
 =?us-ascii?Q?ReosfTjNr5yBSbZqUH34wgp1Fp5iehrTx/NHRVpWockNrBS7sf7/c7ZU8QOQ?=
 =?us-ascii?Q?KATOFb6aNmyVndzhMA9wB+OUBjJWzRofV0M0RDBPDzJSCEgA5+X3JQuyzDeH?=
 =?us-ascii?Q?WALdbIHuatzGTzeUNCuhGIS3Lmwsl1+AmqWJ7ppTKPy1oB5a0cZYRuZxPFiD?=
 =?us-ascii?Q?7gju6v2HEHj3s9vo2sZQoecHazzWGyrhT40hnQIfti2bgCGTatZ8ELbhi2WI?=
 =?us-ascii?Q?sp1nT1K/F4XFm9EB2rCy6sm4JM8ujVpoC5V+PVU14ubUR5dPQLklvhLQIyyG?=
 =?us-ascii?Q?lMMC4FXlAUXdch4MsM8njJBR7ZVgIWG6ycRps68Ibo46H55HzMU/hGe1orur?=
 =?us-ascii?Q?5sOQOQSWwqBAc/5G2MXfIIrklSlABGVoAjcMKh2wmJ4cfQWAlojKXIs/bckG?=
 =?us-ascii?Q?hv9MwwqL2JSR3E1ekjGOboM0ddo3XHnV9A8UbVQ6J68o2AGpdmtvfB1MnDbY?=
 =?us-ascii?Q?XaYcHoHq/iNg14BSGHAmphnxRV8DSR8R2ku5c/q9SmMhTFApWhOuBrt6rgR+?=
 =?us-ascii?Q?6JScwXZhvIgwIEMCySehszI9IyKvR7s0Fg8JkfdIBYttc7IUCCbm8t7kQtyf?=
 =?us-ascii?Q?+qPjr3OVf+Rp4KuO6W7/pDiohCbA03dPorwMJOIxl8HEmMqwpGp1FSocFouV?=
 =?us-ascii?Q?Qz1QeROvU85ZteRu0LZOtnbZh5cPi2uoZykfbC0I/OTyZTt+c8vg8KeuOMyc?=
 =?us-ascii?Q?IE9wINr6VxvCwMOm023b3lf5zsVPPHXYE8u+TQ1/mhZ+xMiL6Wa/vO8X/fCz?=
 =?us-ascii?Q?0K1JcvTx2boqbKXba8c/2VtMZ+b3Iyl1rtVyk9bKFzKCfU/8Jgw0LQuCwadF?=
 =?us-ascii?Q?zHqddV6b53A3We+tL293TfhS9LTGmVvuvyCsdcKiNbF1civdVmOR7ad7XOPF?=
 =?us-ascii?Q?sLNEQZJOK2qNwccIBCQj1W+r98h29A1LkAVJcHQPd6DYcPP+CHE/OlLN1qFl?=
 =?us-ascii?Q?xjDOhNRaPA7Vkfy6Uy4L59QD7m8EfOYZM8ggGcPdrvARZTVbVD3Q8VLwCWK9?=
 =?us-ascii?Q?eZ5UKRNwK5NsAZoUz37Gr1ia1UkxTrIqtBlN10uOlu22RDpcJflwiZDaLFQk?=
 =?us-ascii?Q?3BST1gbieuUsKVJ85P8umSfRQLPNiG2ajF5lTKrSrimdSa08IhdjaRg24T1O?=
 =?us-ascii?Q?jtUHpxLc71Hqzz9Sv2ecEr4bI14N+zQhnWDN0fFvYBmXYGFFqA71knzE/0ot?=
 =?us-ascii?Q?kg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <DBA7C20E3CE8324BB8AF89DB1C21A6A7@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: oG0xOHE8yScgz6qtGh9xTJTieVqqOYTgldX84X27tKbwE2pfKGjveMeYH8twY4Fo7jXksFgdUV3fu62xYs0KajWvZryY/M7k7+tFBGAJLs+wzqlkYZCWd2cKqlnXukfaNdJQvh7v4ms/Tzkh6nAHJkkz/m+ZR3Qt4kPvvuvyyY3GR9SwJsDzmmeMqxQ2HvYW62kfMJjkGlFx8vsvHLP3Q+K5kWD7o4V3V+Kzu7FP55f80txFy2NlV2vwFOJ48KtAAqEAYS2SpE7y7GH7g554rSRZ6KWov+TsZ1/7mSWPREinqRJzb5cMgfMpR2NXS2e8Q6OBeg8T5zAFGJYHFQezWvERohMMgpL2hAq+JeTRbqTI1AKmjdJ/GizQc1IMJbX9wW3WD3icX5LqfRxfmt7Be7rh7nVWbr4NEbJosC0zEFbd6QNZkEGbu0M106VqKVkH8twsanKw2R9lslAxPqWEUcdBAQGOIsC5NaxXPdvjB0RJ8L0NkcyuKWStGeMP8gRUmgUUbZCKYDCP3vNBGqglVZUVzoful0jYr3meWwCrfNuooEf/PBbSoQSchOo7f7MR6jY/5P2N5IgQ1pIYGQIJoqxo4JVW7JR0Zdlnyfm96QNXlOvcl+fYgl+UicRpJ3B2xX1S26qVK+zin5fH+GuKTAc7jpfYU5sBtO2fRwJTAR4z2IK+aZXfC57ZRuWvoJ6UR3vSrSzdmFn1Wdu/M0Jhkrj/dXUB/RpFp/o02bj+t9uNkeJoWfsO8nKkV27qnugo/09zYEDWj8juxKDDYjDDRuslnJq7n4IOnPXo+7v9siwkXkGpRVI5SEGhk7K6xXzJSP2Gre5r7s71kNbsWmg3yA==
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4118.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5920f11d-abaa-46f3-7bf2-08dacd6df78a
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 16:15:41.4367
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0BJganBxeTZ5kaZ3Qra67Zkcv4TEwQ4R8qc7BL4OLCXYt+k/JA3j6E1EMwu92cft+/vXU1Q3ZnW/fe7p3ReZjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR08MB9511
X-MDID: 1669220143-C_QedH9QaA-3
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If `__rtnl_talk_iov()` fails then callers are not expected to free `answer`=
.

Currently if `NLMSG_ERROR` was received with an error then the netlink
buffer was stored in `answer`, while still returning an error

This leak can be observed by running this snippet over time.
This triggers an `NLMSG_ERROR` because for each neighbour update, `ip`
will try to query for the name of interface 9999 in the wrong netns.
(which in itself is a separate bug)

	set -e

	ip netns del test-a || true
	ip netns add test-a
	ip netns del test-b || true
	ip netns add test-b

	ip -n test-a netns set test-b auto
	ip -n test-a link add veth_a index 9999 type veth peer name veth_b netns t=
est-b
	ip -n test-b link set veth_b up

	ip -n test-a monitor link address prefix neigh nsid label all-nsid > /dev/=
null &
	monitor_pid=3D$!
	clean() {
		kill $monitor_pid
		ip netns del test-a
		ip netns del test-b
	}
	trap clean EXIT

	while true; do
		ip -n test-b neigh add dev veth_b 1.2.3.4 lladdr AA:AA:AA:AA:AA:AA
		ip -n test-b neigh del dev veth_b 1.2.3.4
	done

Fixes: 55870df ("Improve batch and dump times by caching link lookups")
Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
Signed-off-by: Gilad Naaman <gnaaman@drivenets.com>
---
lib/libnetlink.c | 17 +++++++++++------
1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/lib/libnetlink.c b/lib/libnetlink.c
index 9af06232..001efc1d 100644
--- a/lib/libnetlink.c
+++ b/lib/libnetlink.c
@@ -1092,14 +1092,19 @@ next:
						rtnl_talk_error(h, err, errfn);
				}

-				if (answer)
-					*answer =3D (struct nlmsghdr *)buf;
-				else
+				if (i < iovlen) {
					free(buf);
-
-				if (i < iovlen)
					goto next;
-				return error ? -i : 0;
+				}
+
+				if (error) {
+					free(buf);
+					return -i;
+				}
+
+				if (answer)
+					*answer =3D (struct nlmsghdr *)buf;
+				return 0;
			}

			if (answer) {
--
2.37.1


