Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 899E54C09CA
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 04:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbiBWDAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:00:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237722AbiBWDAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:00:19 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44AD056C33
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 18:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645585189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=J/WWkrKIdxBqKtuQ+M1jfSmc5WJGxQXYBhGNno54OjM=;
        b=dNeXErkbRrOzpSbJ2nvhNmjNXZcmWAlr2Sd7aKv7LylwrkLGrKzs3dObqZnYDkJadWWJzB
        lJFw9EtrC0HvYFaES68mDUP2oA/yVDSoLkvo2crLs2iGCx5PkrHzOgwbP8bTvYIFePiyb/
        MN+bMhfquJ5LblkwUlznRWXGsj8DH1s=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2053.outbound.protection.outlook.com [104.47.14.53]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-20-EHDbEqSGMXyG1g0wPzjV-w-1; Wed, 23 Feb 2022 03:59:48 +0100
X-MC-Unique: EHDbEqSGMXyG1g0wPzjV-w-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WmppBIkfb/B9o2fVYTcaWAEM2lfIe6fTABiyDhf8qZ1jWBTT59cQnS5zsgbMVvKmXTA/DEL403MGifC5A7PEB8DoYPyG0UB7dpWPz9EWn44i0p98+EWNG66u1nvFitRIC9jFOaVZbLyTb0XxeFUzhH9Fz0bRlvjO4+9PiNkhZ4ltmtZBWiFZuqwW6Jx6wro7s9livY9lcTjvclzV/RxfURicWvkC8oBr5nLvh77VT0A5/w3zfHAwcI9SMa3FRwd9XqQecC1hYSzJMe1eL7VvE3PSIjmbudzKYixODA46U6t8rWh88SShhQm4+3JkZbbMQtiHfXh5p56L7dJvh1l5hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7TNmfSsTYeiwxbo4rbwO298n2C1IdCvhgweo4Avhpvg=;
 b=E735mT4/OVALVb63zHxTkLQmRtefsulDzDs6t2CzwEML6Bw1cCwPeWwrokRuAFIC6HxOtD9z0bbGaoItvJqttKdKr/op7kflSq6JuM0/bprKLbwt9FRYQSuheusOSdhn2gULok2YOwJBFQfGl+pue2lF74ZpgOosKH5JwOuJgMf+0bhTJEohQVXS2JFXNVBLLU96aW3q7g5BVAq1O0lP0DI8tu5xoz0JYySBlI7mUOcU9FHYSErvqV7iVGK4qnTQ2ogpeiHOiTz9yoJ3xMlNCOi1JzXRkzwdNYTU6U39dOAol4aMHRdG+nKI2m9KmBK4dQeq5ch+/MquxPCN5C5GAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by DB8PR04MB6362.eurprd04.prod.outlook.com (2603:10a6:10:106::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 02:59:47 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 02:59:46 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH iproute2-next v2 3/3] mptcp: add port support for setting flags
Date:   Wed, 23 Feb 2022 10:59:49 +0800
Message-ID: <387a16252f20df06f0926d5e8ca328ce288b864f.1645584573.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1645584573.git.geliang.tang@suse.com>
References: <cover.1645584573.git.geliang.tang@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0155.apcprd06.prod.outlook.com
 (2603:1096:1:1f::33) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aaebefd9-94d7-4371-1676-08d9f6788ca3
X-MS-TrafficTypeDiagnostic: DB8PR04MB6362:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB636236AEEC19B8A098D25750F83C9@DB8PR04MB6362.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: l3fvSozGVYLHCmDHvZfjNaA1NqiFx6Y0OdEULW33nCFulB8B3PtA3d/XZLw7P/nn5mhXiEvROoW3vZlaZu82kFFv3wcii9UY/UPtWtxL/pEO9uQJ2yfJMCQUQjxm9vKzCIm6q8iII9wsXnZA+qSJwv7P5M43sn8kDy5qwoPw6LW2xUbhcWs5t2xuOCR36uXz7ePMUyc91YrOoOe296Cfui9gSK8ZEaKRC06aZUkRs61H96LUyJkfNu4IUDqmqmEPZ9HioeY6oNGncCrDDu3zYaXeSWNOH1sd+bohxAtwGvXjF5oxcAV449iZgMMz87zyaGnKVFmmmzp48ujMMflKZcRiemdP8wlkSp2SDS9qXXMERhLOSrtVXKj3atDgCZEWMixM9vdKQi9G9VkW6pzPI6TUzFAQ7hi2RbQ8ZmNGW0G6d9cvPtyaa5w0vReXfWsyKgYY6kjoNK3RJ8HVkK3pXKbzhuzLAjOK7CC30UxZgwpvAqvqNIqCkb4P+69lQHWBMbyTBkN2XM8qyN0Wums4J8CXfPb+Filu/OkoamsjAz8IWahtOWzYD2kZJmp38mD2zW1Eb5pzPbmOTrSnYNf5bjbFEs1qj+ecPwYzy5aIg1W3LBog/iwza96vPekxrg7WE2oKW+DCjvm0NgfwZHy6rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(316002)(5660300002)(110136005)(86362001)(54906003)(4326008)(8676002)(66476007)(66556008)(6486002)(8936002)(508600001)(66946007)(186003)(26005)(83380400001)(2906002)(44832011)(55236004)(6512007)(6506007)(36756003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h5mXyk+cieBYKZ2FrIKhsaGl7lcEzNS/I/rloe0Vc3PeMV19KWoF7ptpXMcX?=
 =?us-ascii?Q?Qnn39KSvOVAt/LEbFjoGOoaITSjS+JbfluCpXKKECyxVkh+xc6CKa9XA3gPA?=
 =?us-ascii?Q?b+gQ2d9gflm65ASDk/GFfeXUfTRLcCx6PHwzyUjXpWygvyXLtLbQZU+wnWJO?=
 =?us-ascii?Q?BPXXLBDVXQTuIecUkELnxuCa4zNEz9XtSDrCWSnQm2+EEB0eBK3p7hgruHRA?=
 =?us-ascii?Q?D397yXQw4Cfo/mrmnW19o9gxzYo30ylVrFNXMUV9ybUzOi4pTIEApi2arzCh?=
 =?us-ascii?Q?YAmg1pmeBfiopfwm2ogwUFf4KE/0hMLOW0BNv+/DQ1XdyM0anu/kxLpqeO4p?=
 =?us-ascii?Q?moT+1JpaN3tzPz3XmYVnwcdounZZjhWDY9TUV/ihbJTec0TaEBmbWhorh5aI?=
 =?us-ascii?Q?Pu51RcS7mXG09IUmJvrSyG8ecaZHXBE1UuaHdzeyTpDfLg4toAS2LZGfcgc7?=
 =?us-ascii?Q?oPz0RiISnUbmt8xTnui5B3hY23TXIj986j/pBYMkKODJxWKxd83NqnTEMZ0A?=
 =?us-ascii?Q?ASxClS4Se3fN+CumfgpXTeefy+H2yfF7V6H9g8KphYl3gUh6yTMgfa7mwqCW?=
 =?us-ascii?Q?D+HZvs/LCXhW4mLvZBYtc4vXifcWlC1L/5jrwChY5462BXmf9kKyS20Z/jjX?=
 =?us-ascii?Q?1m3jNO/jgU+F+sYgv1ajyJQ0z3u7BkeanH3wxaiHsaJ4iOtKsLj2HfT+E4cA?=
 =?us-ascii?Q?3MUnM3ExDCBY5VrG3dSISN1ivrA4zhgiHeQ9kXMccrOVj+3KN/WCzbVBzLNV?=
 =?us-ascii?Q?NmaL/qvR67bAyUO2uE7qxzG8T+X4f2tfECjkGx33eS8HgkxImprM7JCEy1Zd?=
 =?us-ascii?Q?XCbvThEc1BMpPV9S1CYG16pG0IO86CpaO0kjH9JKqupWuk9QtUtt8ebyIO6V?=
 =?us-ascii?Q?Rt+SXeNxiA/725D5DuojSMnONljzKSNJqvKCKb16zzSgyV3Sv/DWvi/cPBBu?=
 =?us-ascii?Q?aadKIFFtD29pe6mr5xB9s4kV/3oH+/PQdI1/fpCZMPYlmpXpwfmDL9MUvZLh?=
 =?us-ascii?Q?VEazq/B0tma+I4WWihMSemqMDQANrfayzHZoNTlkwccbD1WUAXCK78Rbo+SW?=
 =?us-ascii?Q?pLrDZV+C6lkugzMe02J46hecfDF+btyjVt+yALEzhGr4znygabuCVQ77VwS0?=
 =?us-ascii?Q?6jlc+9Lyqyy1UsPbVDS3epA3zvHqLOiOXeF/0xy433v+Byo2PbcoSbbYt4YY?=
 =?us-ascii?Q?b+7DLmU3KUMFAblf+qvh0Ih3t9asbpAeHviHRhR6Yzr1uJCk0uwhKXQAnGdM?=
 =?us-ascii?Q?bFuJVNfRGirKL7SHSQ/zlPibPdT49DUWh70zItbtr4LC6oK8mX08DYUrzeCL?=
 =?us-ascii?Q?PVIqhHJJhpzf7yeR5kEjXiRUmRZ5i/FNUKB07y7sjuvIslO170k87bOpqYx6?=
 =?us-ascii?Q?oYMlAZAUBx2o88OoHwPjpMfsZD8gJztrIsjK1MD9AN1kYPn65pcAzN08TGDC?=
 =?us-ascii?Q?gyi94C7ESwLKGlIs0K3QYOpCyxACPfCd9ddIer+tlqrkRn0XhsXFWj1O/36w?=
 =?us-ascii?Q?QmJTZE3AZKJtGTOqt78r/lo4SsUJFOF+zXVIsBFH5cn0of6Ycl60wUqx8O++?=
 =?us-ascii?Q?eKRQN7yU4iEslToa8ZLZeuYZ4qQpw4zQ+M4V6j/WIGXnbbw0jorfmQ74zJDs?=
 =?us-ascii?Q?UCNnoM7BBA3uAzl7F8G2NR0=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaebefd9-94d7-4371-1676-08d9f6788ca3
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 02:59:46.8454
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DtoluO6dHhkOPQ3rmiSGa6wpXp7acQ5Butk0iI77Scp3YpMlbEQEfPPdiCfGsxsv22CcCgLp4ZfWh/0NfIaoHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6362
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updated the port keyword check for the setting flags, allow
to use the port keyword with the non-signal flags. Don't allow to use
the port keyword with the id number.

With this patch, we can use setting flags in two forms, using the address
and port number directly or the id number of the address:

 ip mptcp endpoint change id 1 fullmesh
 ip mptcp endpoint change 10.0.2.1 fullmesh
 ip mptcp endpoint change 10.0.2.1 port 10100 fullmesh

Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
---
 ip/ipmptcp.c        |  7 +++++--
 man/man8/ip-mptcp.8 | 11 +++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index 247d1caf..b06afcf7 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -25,7 +25,7 @@ static void usage(void)
 		"Usage:	ip mptcp endpoint add ADDRESS [ dev NAME ] [ id ID ]\n"
 		"				      [ port NR ] [ FLAG-LIST ]\n"
 		"	ip mptcp endpoint delete id ID [ ADDRESS ]\n"
-		"	ip mptcp endpoint change id ID CHANGE-OPT\n"
+		"	ip mptcp endpoint change [ id ID ] [ ADDRESS ] [ port NR ] CHANGE-OPT\=
n"
 		"	ip mptcp endpoint show [ id ID ]\n"
 		"	ip mptcp endpoint flush\n"
 		"	ip mptcp limits set [ subflows NR ] [ add_addr_accepted NR ]\n"
@@ -175,9 +175,12 @@ static int mptcp_parse_opt(int argc, char **argv, stru=
ct nlmsghdr *n, int cmd)
 			invarg("address is needed for deleting id 0 address\n", "ID");
 	}
=20
-	if (port && !(flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
+	if (adding && port && !(flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
 		invarg("flags must have signal when using port", "port");
=20
+	if (setting && id_set && port)
+		invarg("port can't be used with id", "port");
+
 	attr_addr =3D addattr_nest(n, MPTCP_BUFLEN,
 				 MPTCP_PM_ATTR_ADDR | NLA_F_NESTED);
 	if (id_set)
diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index bddbff3c..72762f49 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -38,11 +38,14 @@ ip-mptcp \- MPTCP path manager configuration
 .RB "] "
=20
 .ti -8
-.BR "ip mptcp endpoint change id "
+.BR "ip mptcp endpoint change "
+.RB "[ " id
 .I ID
-.RB "[ "
-.I CHANGE-OPT
-.RB "] "
+.RB "] [ "
+.IR IFADDR
+.RB "] [ " port
+.IR PORT " ]"
+.RB "CHANGE-OPT"
=20
 .ti -8
 .BR "ip mptcp endpoint show "
--=20
2.34.1

