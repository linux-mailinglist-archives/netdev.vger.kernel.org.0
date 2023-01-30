Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBD968196D
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 19:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238107AbjA3SiV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 13:38:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238349AbjA3Shv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 13:37:51 -0500
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-ve1eur01on2073.outbound.protection.outlook.com [40.107.14.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB5FEC62
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 10:37:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oV/cMgdEhdg0FMY1SiC9grMNnh2+bdSyIy2yn9cgZdi7LhOzaytvcV3VzWfzTgNMTjP5FH7MtlxHZRQTEvyyD9nI4/5SyhOpOmr0UTgam8ZB8ma0Y+oM/Tl8tLaAwhpWWjg0wNus39l2Fej1F7jX1cw2Pmlto46z9gC9qfNdexG2UvKpg8FKpHjK6V+rOsfCS6YgH2SuZGYHheyO5Jzgk8sM0QNmwxWzGX1b1qCHUGX2NdFuyV2lDYBPEh2h3jhXPr4cmNoPS0CXmg12EJsqxsTe8EYUV/tmHjVsOhT3s0q7nPVYmnjQQiTh2GDoq09ZfI6aA62BiFWzmQFUJWCUwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gy5LrVPlHBccvJbjQHj/vn6CuRevOfAoXDLOW6+zVU8=;
 b=TFdFAzJkICW1dgvUmWGAQEad/4LAas926dT1GH+7I5GMk4W0vuKKiWK+AYejGlXLXVYKrKyuUoL0ZAsadrhCn7BYPLkRjemb/wVlBmWAtJFIDoSXVoGBrR5T2nEf2qy5wd+J2ScQ9vC9Is9TidekpwiY7Fmtva7xrR3L+s6nHyQjb56SbRHiAHDdJIuSj4FWds12cPcHcF0QjAv1qlHyg8ySUKMLzi0vqjYLfPkAsz5lSoCia78+TOkfxY4A89CvRoeTkhZsESpolcG8MD3WTQ8BFA1X9Ug0xjEPw+Ht75xJ+YbKCLfzKyntDxLV3n050whRqVPXVyqRIM+15W2f/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gy5LrVPlHBccvJbjQHj/vn6CuRevOfAoXDLOW6+zVU8=;
 b=V41Wl4koo+t3Xlv8n+OwB3McWziOKfZKFaqMRzXXhHteX/G5+hJfOu/oglqVsZ239CP2S1BnEtkWG9VAENU4GV9Eo/3IMkt8g+pZrhe58M0YGbkEquUvY7NHMWIGfNCNO1f3wwwd66guswyUoDXpmYy98vJ7TIYHXED90wsj0/8=
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com (2603:10a6:20b:3b5::5)
 by AM9PR04MB8826.eurprd04.prod.outlook.com (2603:10a6:20b:409::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Mon, 30 Jan
 2023 18:37:03 +0000
Received: from AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::cafe:44d8:fd5d:1480]) by AM9PR04MB8397.eurprd04.prod.outlook.com
 ([fe80::cafe:44d8:fd5d:1480%4]) with mapi id 15.20.6043.036; Mon, 30 Jan 2023
 18:37:03 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: RE: [PATCH v4 net-next 08/15] net/sched: mqprio: allow offloading
 drivers to request queue count validation
Thread-Topic: [PATCH v4 net-next 08/15] net/sched: mqprio: allow offloading
 drivers to request queue count validation
Thread-Index: AQHZNNDN9sDS5pnSAUOO8sNo63ejF663PF7Q
Date:   Mon, 30 Jan 2023 18:37:02 +0000
Message-ID: <AM9PR04MB83977621774954ABED31037896D39@AM9PR04MB8397.eurprd04.prod.outlook.com>
References: <20230130173145.475943-1-vladimir.oltean@nxp.com>
 <20230130173145.475943-9-vladimir.oltean@nxp.com>
In-Reply-To: <20230130173145.475943-9-vladimir.oltean@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM9PR04MB8397:EE_|AM9PR04MB8826:EE_
x-ms-office365-filtering-correlation-id: 5a9f3e43-f45f-462a-1f04-08db02f0fb28
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Cd+LlSBbMTDVwk0pB3GC7kInzJccH/FzzXcEksIAh7JBahWYcOf3tkQ6oaCI0r7n3Oja/ksayDmNtxcHm4rTz4vo8S6wNJfK87Pf7YSFl8rR2OCiLqguioNYIge6TLWPBGIcC4oVwwIRQJ6cHOIvsk/DzLrOWTvQO57qTblZUXPmq+i9EPVYEOICtszx/51oMe/69Y6Es1Rxjm2uXw7bUUMmyiRMxDpvmfQGSJiwWKeoJx/+xbe7wyNDLraSXRzo7acPfvHHjGBc5EFpmsEWmBjxW5UP9JxBPeb57s7jxsl0wGPUUYmzdb3MCQu/YtrxbOkE5kry6/PWQnLkPAO87IPtIg+qqMtbFp8pF/JnDbPS/T8bIEwtKU5MIL1p+2Ise6K5JDCPKwoSluJoLFbKrJnQmuaGTiG6zdVbLaXTkOM549QhsEpAX6PS5YZOeTyhGRWzuoeZwt3tv8HqnsZOr0oTajbhwqS8IOAkcvwL8IX5NXPgvkhZitCX0Nw3bTSRPzjz3DdmyrqrBUC4bBW0sAx2sbGQt1mVY8DdfQsW6/QiRQrj5X1yj/dVN2k46pQXdKm7S44g9MPlNNojSna8dQEOr5YTZKRSKHMiRs+MnvGN4KChuiTG1v8n8H9T85Gvmmh3F81mCnamqLXjjUUu8qycXijtZ5MBWQhJ4fmatuI5OJKvWgyLTxnO/Vipe3tEDNQ+ZpX82L6KfLMI5QIYvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8397.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(39860400002)(346002)(366004)(396003)(451199018)(110136005)(54906003)(66946007)(66446008)(66476007)(8676002)(66556008)(4326008)(64756008)(76116006)(8936002)(52536014)(316002)(5660300002)(122000001)(38100700002)(86362001)(33656002)(38070700005)(53546011)(71200400001)(26005)(6506007)(186003)(9686003)(7416002)(44832011)(55016003)(2906002)(7696005)(478600001)(41300700001)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?H3SRY+k3fkjmSHRN54THvcXDy0pSwPAyXWjiIpZ0nZg+UWrrX2ataGGhtfRD?=
 =?us-ascii?Q?TK7gZnF5+/d0yQLeAUZBwWua5Zgx5eb4XRwUlZo6BEq26UCn6esKRwubIKz+?=
 =?us-ascii?Q?abSFFKF/N0tNledRji44ZB90LJN7S1jQqmZc8Ytid6ku3R3sAvMHZUWIexGI?=
 =?us-ascii?Q?fMafJrREm6EKiqELECunNz46clfQcWhgJtk/OPpVycWso54jYRcLX7UmUmo4?=
 =?us-ascii?Q?rCzP60S+vMjyDOAXMj6EHJtqTxIT8hECefk84nOoC18uej2gGRz7pGkU7E7b?=
 =?us-ascii?Q?a0VueqxPzrcoyDXzHBYijsmS+r5HKNlMfui/ynPpSSI8vUCiyNLx47C4znya?=
 =?us-ascii?Q?UkB8TEWw8y7wj33zRWvx1MKwr7sisq5HIvv8u9wieOet5EmUs3S2T1Qa2f+C?=
 =?us-ascii?Q?x0esx35eWJ/YC7OzmmAazobd9E/Fcpjtag7zHGNCan/w4GoA/fYRuSo0q648?=
 =?us-ascii?Q?wQsLWeXVqGMTm1YhUS4hpxR8ft8Ky7jvbrHDKosssz0IAbnTvD9bpdCENCWs?=
 =?us-ascii?Q?lGpcE36mxYx2wN2k86v22kyz2x4qubK9ZrJsNrFdJERuf29mkV7llHyvtNMa?=
 =?us-ascii?Q?T6RvoI4P55AWd8OFbSiB/2+IAiXj0HAwyBFVRcC4+SoS7qqelJJP5HHCdBiP?=
 =?us-ascii?Q?tv/uUgum9x8myK8VT5kUiez82VCXitPvGCkxcAkBcMuQKrExnWXFAXCYOZlp?=
 =?us-ascii?Q?JvlAz39Ua2+s7yNFdeVvhbtWxbYIJYjti2MYvc9HHB++2Z93E4ZAWHjmlft4?=
 =?us-ascii?Q?unNtOXldYF+ZDKF13USEBsliAd3+5JUtWAbVtML1rp9HHBurrFwJdmVcO+vy?=
 =?us-ascii?Q?tMOqySrL8YJ89EKznEjTtmK4GLuAlSh17COP7tSRizat5rr21C1PkWYmY5VN?=
 =?us-ascii?Q?7XEalmGp8nctjueUap3xK79js7wc0DsZmVS73jtOpoY38YbaCoO8HS1Iainu?=
 =?us-ascii?Q?0cUo1qCsH2L318hH5Z8rYTXjc4TZPT6hLN8tXy9Yvz9GCRta+IEhgRD7JQMg?=
 =?us-ascii?Q?JtdVZXYvpq7P4/fP+4lJymG6EH5MHZGQ62oBUa4vQ+GVsxS/gLHNfctVX1sQ?=
 =?us-ascii?Q?p6MN9t75I7r4w+DvL/kfAB8s1IJ8JYWiCT88u2j/nHIyJ8FyY/1yJA9vGzRQ?=
 =?us-ascii?Q?i4CWt7/AQCUBGXHNgLphUYqL4PJN0cSHnRtAIbDoRBcHXl2iEtCdqJLb9tLF?=
 =?us-ascii?Q?+F/wF2rPE2/fpNlQmY23BM+aC3wBNmzlPyskMneKhyVbiKE0Ulg+Sd4urViP?=
 =?us-ascii?Q?z5EsZCWCY1nnGLryhfNw8xL9WmFP8rFEmKg3psSfFP524O6v1jQFtBI507fu?=
 =?us-ascii?Q?s0xCkeFzbNKFx1POi1DS99CWetu8K0CwFdSAO4ObX48NFp9s8+UKKy8JJFA2?=
 =?us-ascii?Q?czv+5thrX/3Dgm1Rz+xLxBGCKgsuprmyRCBnaVoz86tQEvet0Hfw8iH59YUI?=
 =?us-ascii?Q?sX8q3b463qQYtvnZWNqxEuR1xtIpgIkD/ACs1sxqKXZxJA9xXfXJgz2yVt3f?=
 =?us-ascii?Q?KG61o9fX8hb9p8F1zhaatgSOdU/MpqexRZkTvwFKf472KSF6Y2YLK4Q1Etu7?=
 =?us-ascii?Q?aJSoA8okkqxQ66znEq0JVetrWQ00buSD+3+Dsy/M?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8397.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a9f3e43-f45f-462a-1f04-08db02f0fb28
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2023 18:37:03.1705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QzNwkPfwFFjI/fQ1F12Y03Q8xCrrUrMapLOISmOjAeXabOQMr1pxYlAVa4S7hmhNRTmO/BnTx80JGBphCTaIsA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8826
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Sent: Monday, January 30, 2023 7:32 PM
[...]
> Subject: [PATCH v4 net-next 08/15] net/sched: mqprio: allow offloading dr=
ivers
> to request queue count validation
>

[...]

> +static int mqprio_validate_queue_counts(struct net_device *dev,
> +					const struct tc_mqprio_qopt *qopt)
> +{
> +	int i, j;
> +
> +	for (i =3D 0; i < qopt->num_tc; i++) {
> +		unsigned int last =3D qopt->offset[i] + qopt->count[i];
> +
> +		/* Verify the queue count is in tx range being equal to the
> +		 * real_num_tx_queues indicates the last queue is in use.
> +		 */
> +		if (qopt->offset[i] >=3D dev->real_num_tx_queues ||
> +		    !qopt->count[i] ||
> +		    last > dev->real_num_tx_queues)
> +			return -EINVAL;
> +
> +		/* Verify that the offset and counts do not overlap */
> +		for (j =3D i + 1; j < qopt->num_tc; j++) {
> +			if (last > qopt->offset[j])
> +				return -EINVAL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +

Not related to this series, but the above O(n^2) code snippet....
If last[i] :=3D offset[i] + count[i] and last[i] <=3D offset[i+1],
then offset[i] + count[i] <=3D offset[i+1] for every i :=3D 0, num_tc - 1.

In other words, it's enough to check that last[i] <=3D offset[i+1] to make
sure there's no interval overlap, and it's O(n).
