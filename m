Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2328722240B
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 15:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728755AbgGPNhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 09:37:01 -0400
Received: from mail-eopbgr80057.outbound.protection.outlook.com ([40.107.8.57]:46102
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728260AbgGPNhA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 09:37:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m/raVsexahmirrjUNvVRZlfqLMSi5V/YrLQi8x/Zd5ho2/uzhymmm+j1C0gg05V4eIoOPrCiIeBSiuX7Zwb5r0rVEBWH0i42kmc361yAEw2P/BdWb5fgyjI7Qk/ZcoNdQ5q3k/BY2Q0XYg55C/bcS4L1xv4OuubE+LDFMoc1CvppVVzu01E+COzoM7N3UhoZeRDK4nKniS1LoDqiUpmIgPyBAuG0iDXjBsx1sGHunECOgHDaZXimzmkOZOyVcVO6AXbyO2aAg3hcWla865k8lU4seIBA9NESDkPn0sF+xUCqcKWTO+L1xJaI9b+Px1BSGayXtN8CpVc+8iwll7x0sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu9xI2LWElJHpUl3asTnob8b04sl/T2YMx44ojXS7Yg=;
 b=LgNjFySDzVJ+/KntACYrhnIJI2JQCm6oMcGcZEPxcQTMJWEB9ViAZwIZe6ev2id477LgQmWHu3BMBib1IX6+4fcVxMrqce95mxz2YdZUtTo6zThJmtRmfGVV6GGo98vJT4yevW8GpTA26Ssd6qgDRGzFTiF9k87w4puVse7PO125MsW6e8UxHJ1BTW2Ypfstj+7B0gg47uBaAfwoStbh8H75I2eD9OVnTSM5zoivOBSw5pzqZbl1F8T18UXK2iolu3y8UUwNluZGEeNAvqOXf+NNWyDU1c7VFAGe/HxQJLP7VUrWRE7SeV094vhafRJp/t5Cfa4F2syrlCfYlGl+ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qu9xI2LWElJHpUl3asTnob8b04sl/T2YMx44ojXS7Yg=;
 b=HcvOqkFF8Zoh8s9PllhcIsQpAPCKoTSUYOOEyz7GxIB41MOHqApbgt3sLQjg3VaFav5RXD2JIk/j6AdxLX5bh17d1YoxBgYpgpYFBzp2Q5w1nqbTlNVbllL3nDGBW7U084b84RYo/1GO4pyqZ8mCtnfZllPPSm3j0AChSz1P0Ns=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0502MB3115.eurprd05.prod.outlook.com (2603:10a6:3:d5::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.24; Thu, 16 Jul 2020 13:36:56 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.026; Thu, 16 Jul 2020
 13:36:56 +0000
References: <cover.1594896187.git.petrm@mellanox.com> <bcc2005258f2453a788af112eb574d40c58890ab.1594896187.git.petrm@mellanox.com> <20200716122718.GA23663@nanopsycho.orion>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH iproute2-next 1/2] tc: Look for blocks in qevents
In-reply-to: <20200716122718.GA23663@nanopsycho.orion>
Date:   Thu, 16 Jul 2020 15:36:49 +0200
Message-ID: <87sgdrinta.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR06CA0113.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::18) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR06CA0113.eurprd06.prod.outlook.com (2603:10a6:208:ab::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.18 via Frontend Transport; Thu, 16 Jul 2020 13:36:55 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 333d1cb7-263f-45d0-c685-08d8298d4ee2
X-MS-TrafficTypeDiagnostic: HE1PR0502MB3115:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0502MB31153F2CF3B6CD84F01CDEBCDB7F0@HE1PR0502MB3115.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /1ASv7koydcxNt8Anc49DuRutJ6FRrv6i4uFPEndNzesTRedmoLEgPKi8lvzevsHi8BLrULKF54Exx7NHZO66cVWjmnPI5aOpMr7JplevF9qWuohH/kQGCO98JbX73+8Hph81iooTNp5TLWN+lhrRKpkJ4b8fxaQ2FJXnVfkU10xv967R4t8gqhQ9tiEzjQuJAVetwB62/an8G+6mKQm4NX4Vdi6wazAg793SIDCtWhVqDincaVzyLmPWySs7EneBHfC1PxMuz31JfdehaYRPgmD2+bVE4zUj4RC+BGRpGVCmsOoUoQplxcpTAwxjRwPjh202TqbcXxlhEKUj+y8iA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(366004)(346002)(396003)(376002)(54906003)(83380400001)(6486002)(26005)(4326008)(186003)(16526019)(66476007)(66556008)(86362001)(66946007)(5660300002)(6666004)(107886003)(956004)(36756003)(2616005)(52116002)(2906002)(8676002)(316002)(6916009)(6496006)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: U2h0dQywUJfVGcZcpfEbuFPsVEiTwZ2/dAJmdMyKhrpyM8Rj7ambyUiFRYqKLOYj4i2sows47WSQz5vQVXLE+4On65g89XMXRZd3//5Ay2Wv/qFY2oaEDla+kO3Y2zSiJnt1K2sc4qRr3wGoMbRU666mUsjL73an10+uM9Zvb9W1XUoBTZ1YiQtJgRjgrMfMpp5dLt+Tf5DIi6O8oCWcSFAjaqnwHbEsCod/Y0cae4vmyOiZWZod110W6vxeh3bt8Iz+O5VgzqEMZ0V/OzsSqLPYEh8798Lt4UKrmrYQRLAc3QILr9OXZusukEoe/93MG+VsiBKYZCr7oYSc956Y6TdFGnUFGEu58A/PVw3qp3vMv32hgD5/pyo7pI1nlGq+Rcb2XYt6Mt1WCzzhfGvnRM9L9qGK5mBQm7Xgit2d2hBRZfVIYJBTllr9h2AXtwfeNXcRtDRbeKuUp1kKuTmW37ZWSgtvdWXWmFoUZ6H/dWz1YIoaWX49fdtFR3OP+Ibw
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 333d1cb7-263f-45d0-c685-08d8298d4ee2
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2020 13:36:56.4437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qyMm4dbfdIpGT2r8PzAA/zuzEKQkqhoqzdC6cJU856EWq8yY3tMzAocKKPcWCvv3sTnGkA8WfmvRtxv5K8mBfA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0502MB3115
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Jiri Pirko <jiri@resnulli.us> writes:

>>diff --git a/tc/tc_qdisc.c b/tc/tc_qdisc.c
>>index 8eb08c34..bea8d3c0 100644
>>--- a/tc/tc_qdisc.c
>>+++ b/tc/tc_qdisc.c
>>@@ -477,7 +477,9 @@ static int tc_qdisc_block_exists_cb(struct nlmsghdr *n, void *arg)
>> 	struct tc_qdisc_block_exists_ctx *ctx = arg;
>> 	struct tcmsg *t = NLMSG_DATA(n);
>> 	struct rtattr *tb[TCA_MAX+1];
>>+	struct qdisc_util *q = NULL;
>
> Pointless initialization.

Ack.

>> 	int len = n->nlmsg_len;
>>+	const char *kind;
>>
>> 	if (n->nlmsg_type != RTM_NEWQDISC)
>> 		return 0;
>>@@ -506,6 +508,14 @@ static int tc_qdisc_block_exists_cb(struct nlmsghdr *n, void *arg)
>> 		if (block == ctx->block_index)
>> 			ctx->found = true;
>> 	}
>>+
>>+	kind = rta_getattr_str(tb[TCA_KIND]);
>>+	q = get_qdisc_kind(kind);
>>+	if (!q)
>>+		return -1;
>>+	if (q->has_block)
>>+		q->has_block(q, tb[TCA_OPTIONS], ctx->block_index, &ctx->found);
>
> Op returns int yet you don't use it. Perhaps it can directly return
> bool?

In theory it could return actual errors (such as an attribute reporting
block 0). I'll have it handle the return value through the usual "err ="
stanza.

>
>>+
>> 	return 0;
>> }
>>
>>diff --git a/tc/tc_qevent.c b/tc/tc_qevent.c
>>index 1f8e6506..2c010fcf 100644
>>--- a/tc/tc_qevent.c
>>+++ b/tc/tc_qevent.c
>>@@ -92,6 +92,21 @@ void qevents_print(struct qevent_util *qevents, FILE *f)
>> 		close_json_array(PRINT_ANY, "");
>> }
>>
>>+bool qevents_have_block(struct qevent_util *qevents, __u32 block_idx)
>>+{
>>+	if (!qevents)
>>+		return false;
>>+
>>+	for (; qevents->id; qevents++) {
>>+		struct qevent_base *qeb = qevents->data;
>>+
>>+		if (qeb->block_idx == block_idx)
>>+			return true;
>>+	}
>>+
>>+	return false;
>>+}
>>+
>> int qevents_dump(struct qevent_util *qevents, struct nlmsghdr *n)
>> {
>> 	int err;
>>diff --git a/tc/tc_qevent.h b/tc/tc_qevent.h
>>index 574e7cff..d60c3f75 100644
>>--- a/tc/tc_qevent.h
>>+++ b/tc/tc_qevent.h
>>@@ -2,6 +2,7 @@
>> #ifndef _TC_QEVENT_H_
>> #define _TC_QEVENT_H_
>>
>>+#include <stdbool.h>
>> #include <linux/types.h>
>> #include <libnetlink.h>
>>
>>@@ -37,6 +38,7 @@ int qevent_parse(struct qevent_util *qevents, int *p_argc, char ***p_argv);
>> int qevents_read(struct qevent_util *qevents, struct rtattr **tb);
>> int qevents_dump(struct qevent_util *qevents, struct nlmsghdr *n);
>> void qevents_print(struct qevent_util *qevents, FILE *f);
>>+bool qevents_have_block(struct qevent_util *qevents, __u32 block_idx);
>>
>> struct qevent_plain {
>> 	struct qevent_base base;
>>diff --git a/tc/tc_util.h b/tc/tc_util.h
>>index edc39138..c8af4e95 100644
>>--- a/tc/tc_util.h
>>+++ b/tc/tc_util.h
>>@@ -5,6 +5,7 @@
>> #define MAX_MSG 16384
>> #include <limits.h>
>> #include <linux/if.h>
>>+#include <stdbool.h>
>>
>> #include <linux/pkt_sched.h>
>> #include <linux/pkt_cls.h>
>>@@ -40,6 +41,7 @@ struct qdisc_util {
>> 	int (*parse_copt)(struct qdisc_util *qu, int argc,
>> 			  char **argv, struct nlmsghdr *n, const char *dev);
>> 	int (*print_copt)(struct qdisc_util *qu, FILE *f, struct rtattr *opt);
>>+	int (*has_block)(struct qdisc_util *qu, struct rtattr *opt, __u32 block_idx, bool *p_has);
>> };
>>
>> extern __u16 f_proto;
>>--
>>2.20.1
>>
