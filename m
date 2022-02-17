Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58374B9B64
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237944AbiBQIqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:46:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235672AbiBQIqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:46:30 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC9B222187
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 00:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645087574;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=quCziLOs3O2O+wohFVJtvZencs+avzEHPgM0f/ylLdc=;
        b=kqc9cgwXD7PH+5Bx8pfZg9lm09QDOaOcAHQS4OPmLW7uv7wEpt/1I2VOYlr7YupecXI53M
        00iXz+6oeepoH4G30trefmysJZF+xHA3S4tC3pCbGSdVWbg7+MSTZTBe25qBcWRdpHlHB/
        k9bHLeAN9I8lPFcU0rKjEJXKs+FHyfU=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2052.outbound.protection.outlook.com [104.47.9.52]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-13-OkqECPJZMR-skmRSh4HsWg-1; Thu, 17 Feb 2022 09:46:13 +0100
X-MC-Unique: OkqECPJZMR-skmRSh4HsWg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ELXJ6cn23A9Xmpbods9a/pyuPnyQjJ/GsFKlrQjw0DUMZkefQsQIKKM9tkE4iE69DMj31bIUmmB7cqMhfbrQkK9WwxX7IDjQirqEKud8KVU5MarFLmsJl0n8PlHh+Q7mHwjGwHo/zcHSCsSlRGcdM62aWRHRyaIE4cwVUfotpveRqtjnmq5l8g2E/JbrQDPd/haDRuuz5Ct8e6eLvOG9DShHquSooKJnxUm5gkc1owAef31EglsoHA+mTSLBg8U0JKu3wKuRvQuBv85dCto/Vd2PwE4r/Wk4MmkCo08s1RjyixEpkeKYIwNu17XXdZ+mLl5xuKSeSGV07L8N23nL1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zALXBDbGN1LwmXNktxOkhqkwtpgcqM5Zcpi/7RwgUQI=;
 b=D7wRVgmD/zbWGQ5lshJtQG7xQ7szoMye9J3nCF+XO0RKobyIBDd6KyWxV9iI4FrwtXODpygebtBEd55hH15RPViOYDyrQ1V3nCbiYfxDvIb4OK9ATwJy0hjQYgE3err6aRSDk3BU1kkxYDLeITkRPPjz4qGNeqDJy6Ad/Zx2ZtVZ1Z0XPB47gr1i+hrA7tw9DH4W8wToPSWUJiIZMp1b0Jm3vqk5e4dNlpjfKJufJhRQDoonye1lUi4BDoaKApoaFOzg1QM3JLIwOARbV4sReTHyT9IbA1F/Khas4U0yOXWRHY1Ftq7xSMpKimD0aFJ+eJSYtMcwkzET/UuiRSicJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by AS8PR04MB7925.eurprd04.prod.outlook.com (2603:10a6:20b:2a2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 08:46:11 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f%5]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 08:46:11 +0000
Message-ID: <281493dd-4b3c-3c99-8491-f5e6b0af602f@suse.com>
Date:   Thu, 17 Feb 2022 09:46:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
From:   Oliver Neukum <oneukum@suse.com>
Subject: malicious devices causing unaligned accesses [v2]
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     stern@rowland.harvard.edu, USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Giuliano Belinassi <giuliano.belinassi@suse.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6P193CA0134.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::39) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6a17e92-c529-4a46-d2ac-08d9f1f1f2ca
X-MS-TrafficTypeDiagnostic: AS8PR04MB7925:EE_
X-Microsoft-Antispam-PRVS: <AS8PR04MB7925F62409694B1ECDCE5292C7369@AS8PR04MB7925.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fwnjM2fisuF3NwOc9jX3bOiWbu1aiokEJb8Gv69NDqp1sp+eKsSWqEPPgnrUgXUrA99oFmu/fHym6oXdUjEXzpLqQEYZNYP2CIQeHd6RG9ASQxFbdASVou69DfRs8bQU8q0qcAEry+mK8+4xELoGAgCEgB+CnTk+dwNgdqFiLiX6LKl4blyYnghMaepfpX5QqKQrYWKSHy37NxOW4B6GZ5iE/HdG0F6y0SA5OAiEFG4qse1ZB/bHHRqzZxth+KzV6TtjDm4KL2H/s3X3kH9hj18Pqu/UvOvOPNQorFZ6+C9ZFZnShpC1Iky+SPNrwnkoNgFcQfZkX57fw+51m/ZpmnE5921mQYJQ9n3ZKNemlkEWnTBO0Sa1ShlUc+jrqnVJQvPzCK477kzNahg09CVjyT+fJhcz0GHdVRvi6zaSxSw214DKH7JAF9K0DfEXQs6pmbnYOAz7wIIzhiqshaczLsVfsLf5h66fXvkF4Fg63eukwNiam8DZBZv/zEB6qMCwFnp+YDdFKNEDARk4wzquk6kjGj2IRyWLHDySVyors60mQ5W5pJz8YULtqGEak53QPnj81CvV6h9K2NEbI/qnrTZX14iWSCFerVNVc8Wk56WQ6OUTAiqgE5JSIOwiB4QZpKgecodmDPG17gQfUU3mKhBIPSeWZhKbXUH0ZWUc4ZQn3nL74LBNq0hxM302C1Q0wsB69UZ3REzGL6xpCu1gwCx+6gX2b4UBZPYVATV/5vY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(4744005)(8936002)(36756003)(6916009)(54906003)(66946007)(31686004)(2616005)(5660300002)(186003)(6512007)(38100700002)(31696002)(4326008)(6506007)(316002)(8676002)(66476007)(66556008)(2906002)(86362001)(6486002)(508600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?07ckaRrCo8Y3AoRFnvgZgaYKJlY0MHa5/BeXGVJFN8AchtaQfFlQi7yoSGCo?=
 =?us-ascii?Q?0UAnE+3twOnsD/AyLWBu0LD8ZhWNTv0hZ60FrjO9UEHCd+lLzqQMiXqy8mq+?=
 =?us-ascii?Q?GHQGui9yrgrqcHnQ/eaaCH2X5rfF0dFFNN6pkRJ+slW5oP88Q6s+Ox5Wag+a?=
 =?us-ascii?Q?dWd19RhG3T/suLjrjzqDr1egx6ajVX9WtJ+3ug9n6C+yleLTHnWylOsUo3qv?=
 =?us-ascii?Q?fdk3XKj0lZT7qbrpv18pVvZYUgLij6uUgkYGiXgRqY4dwUCO3jDvFY7Gei6Z?=
 =?us-ascii?Q?9u3IANoJs+GjGW4EMfIu/g76gUgbik+Bu5ZNU4J/8HkdNUp0WsdVfTD3GWFG?=
 =?us-ascii?Q?3v44PuxAeHgANG8gudSJQOXx/Qyn95mqN+b+O6HKo/JDJKVF3NeWzYQlXTBO?=
 =?us-ascii?Q?pFwczGOwiI6dztz/yHDgv1ZnLQxBHrlJksWKDk8JnND8Orl3upkUZPhSUUMq?=
 =?us-ascii?Q?4wUI5k1tl1ZoRcukWYaUtvvfFiyYsUFBtkwwzZLuEbAvi6sgrpcRwv4QJDdg?=
 =?us-ascii?Q?ZxX3nVq+hqUT4FRi9rK2zs1t5ayRNku0kcV+7lYN3KUUJzBI3cyEijGE0Ekv?=
 =?us-ascii?Q?m+Q3egLwoLvvDDYCYrtBFU1vfsNvFh8rFlhxa1g2QiRgbCPfRvt9fQ0GWv3V?=
 =?us-ascii?Q?MqPVOlGNt/c24Q54G7vYMaQDabIg3zd/eeKhVqaXvUZR9qPVeOo2NvDhXq6P?=
 =?us-ascii?Q?TCavEUJ3qvh2M8xewwR5A5gEv/cMLlAzPr6/wG1mlRFg6oSSTTqW02qeJKs+?=
 =?us-ascii?Q?GGzMxX1zg1T0kOlOFIKFD5HOn08Pf4Q2e37EUpH7vZiTq6xRQO45DFHDajNS?=
 =?us-ascii?Q?7krAFA04/yDi4E4fd7EXJQHGAswe2gYsJOZwrgAAsROHfqaThfsHAeLlr4P/?=
 =?us-ascii?Q?xK7IkwIxJvpxtb7nS+HMK9xFPK27UyDPt83j40fAgbFHYCSWxHEsIJCB4Duo?=
 =?us-ascii?Q?J1ljAf8Hi4207iPjZKZRQrm5mt+EAf5Th5hrjH70ULtfbWCYmGCEJhL+yAp1?=
 =?us-ascii?Q?t6+ebMIuP4kPQulDyT7IxeocVokJO54UOyBsRToIAUDIWUWLlHYYryzvqnHq?=
 =?us-ascii?Q?s4Xd1F65cPmA658LlCmBdvDDZKFN6cl05SxduLrTEQ6ODewwIqPZoIm6KMbt?=
 =?us-ascii?Q?mLQf1aatFOxrOZMN3wTUmwlrmD8czAh5+76prxfn2tGDgejq58RJUwMZ0qkg?=
 =?us-ascii?Q?+rq6kH/4iBl/OAtrPVp692Yu/YbeF3czF5uYxtGySeZosMZeWOLgIRA6tuG6?=
 =?us-ascii?Q?xcCpSbhG+S8j5wjxgMuyRXY7D946nv91BzSDtLSNc0sT9ks21Ts0+gHeMtYQ?=
 =?us-ascii?Q?Cy7svlFzi7sYOLUnmzYvGopVxsbek6XbTcK1VRxBc/o/uqZ7XuZgiZDovz3P?=
 =?us-ascii?Q?TK12BkCqanG/jbNgVwRseSpCs+7ZtXnxw2BuKW6NTktuwN9+o97bzmnU4W85?=
 =?us-ascii?Q?KYXpRUw7WBcnpC/VXYowysqmAkhstVKPD4Y1e1EPFHrmF1lkIZVVX9UH/eSj?=
 =?us-ascii?Q?+N+aaLQ8P1IxzeacOjowmq50xQUE+lQReRRYvKQoILtMqsO39BeoJaua9G5y?=
 =?us-ascii?Q?bZoTUeMZgYbEQguCdPx3rlUsBBtDslF+Z7HRaolmkbz7GNgU6jIHLqE//gPd?=
 =?us-ascii?Q?iPUgnBVGS5p9tbOr+ue2BQVQV/tAq+eyKy+466ctMmvuHrMiVrB6iI9uWbc/?=
 =?us-ascii?Q?ZUQkeuwAjkKAHcapehXGInKPr9M=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6a17e92-c529-4a46-d2ac-08d9f1f1f2ca
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 08:46:11.4301
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oTZSpn+aEezRnVDbxjq40fl1l3JsobToGShilcG8RBhVBRHtf0lrG3cHiH+hSa4pYTmhp1BzIkaNPHdslwdL1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7925
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

going through the USB network drivers looking for ways
a malicious device could do us harm I found drivers taking
the alignment coming from the device for granted.

An example can be seen in qmi_wwan:

while (offset + qmimux_hdr_sz < skb->len) {
=C2=A0=C2=A0=C2=A0 hdr =3D (struct qmimux_hdr*)(skb->data + offset);
=C2=A0=C2=A0=C2=A0 len =3D be16_to_cpu(hdr->pkt_len);

As you can see the driver accesses stuff coming from the device with the
expectation
that it keep to natural alignment. On some architectures that is a way a
device could use to do bad things to a host. What is to be done about
that?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver


