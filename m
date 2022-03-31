Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 276214ED7D0
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 12:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbiCaKfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 06:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbiCaKfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 06:35:30 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DABC61A3E
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 03:33:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1648722819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=x6xOuGKLsZlpYGpodN5KjujxAPL8hT1jhGrXQX+8GpE=;
        b=ibq55BoafITkLCr8+csQgXgL44I6FnfYfEeAFbWHHa+O92dZePfHSU4TgXh6vZDSqLlNOw
        yPmkN+7gikl7dsNSDgBxN5fgJPJyqhHd2Ysa1BFp8H9C/ELNiVHfBB+YiTGfgvyuNGkLc1
        ZYUmx5CMaD58z53ARAuJOsx1hZYdCj8=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-23-E3wv0C1bPYmZ12M14yNJ_g-1; Thu, 31 Mar 2022 12:33:33 +0200
X-MC-Unique: E3wv0C1bPYmZ12M14yNJ_g-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kDpz235nPPy+BEdlbk+hjrPjdJWHr6uexOmPC8c28WMBAg30xc7M36U0oorCH5FJWM22v1Qe1CMw4H21E0KsA1ppGP9UMmawx58qHN4vgJ+F1kyzPh6lQ1xGhb2LO3vP+h28TqEDbAxBIPur+jinI6HyWdNumW3s5QdUUKH/L6WL8AcaNTt0D7i0bqOZa+g6WwBNn13tIiLQ+qaPeYcgLXYOvLcYAklbQvTToP+S7fPM0X0PCoSutuKaF4i38zSI766y0cD21lThyl5YTd6i2eW3ZrCS/e0Wbl7hnnqvOcdUTxKtfW690LJ2+6Id9jC6Y7Qm82T//yV9I0sw/nS8lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yUnpCFK0WPB0W1P+U4pQkdsNxPVZCFNzjKxId9khAx4=;
 b=j61tjVpcGzrdtMP89qT96TsB3J6Flbw3sCjlQJbIpsN2wLnkrz6Ub4kEnXRO/Xgy2PO/sr8dKCO6WAt+KleBm3et1Ciwr4ul9SoL9LomHXS1jsLlIWYPLB+kNzeLefjHT01Dz6viz45xHjq9KoZyMzQzpQiWTe6jLsQ9fEZQZzKRjpZfCKyv6hvg0lb+6diEQN8mrIWxxhNor0Xu4041Mhu+ErY1fPWEpUpR7+8l2EpigEnQ3jD3BgOs5FkD06LAgnGV6UnfVfNsCgySheuSVz/nZeqxIJ8Gz7R3XUvuO0p4EUCy1KBmBRCeaazjljvsFlLqTDrmO7drSwPrqLkdgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB8PR04MB7147.eurprd04.prod.outlook.com (2603:10a6:10:126::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.19; Thu, 31 Mar
 2022 10:33:33 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::dccb:257e:76a7:c42]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::dccb:257e:76a7:c42%7]) with mapi id 15.20.5102.023; Thu, 31 Mar 2022
 10:33:32 +0000
Message-ID: <fbaafccd-60ee-1c29-a014-ec50661f58eb@suse.com>
Date:   Thu, 31 Mar 2022 12:33:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Oleksij Rempel <linux@rempel-privat.de>
CC:     Lukas Wunner <lukas@wunner.de>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>
From:   Oliver Neukum <oneukum@suse.com>
Subject: ordering of check in phy_state_machine() since
 06edf1a940be0633499e2feea31d380375a22bd9
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AS8P250CA0028.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:330::33) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac835712-7357-48e8-9638-08da1301e763
X-MS-TrafficTypeDiagnostic: DB8PR04MB7147:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB7147B6742BD79A84E51BD494C7E19@DB8PR04MB7147.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dBBbOVHD3L2fnaqtn3CYQzJnTM+2gVdsNdQkVeuFnEtUJFgFCSq9syAmYvHnDO320sZC+GG8URZAeZGj3UQi1vrCDSnzF6ugKvUqrpD5OHxhcOhssiedKwA2kgo8NC2cxzt0v5Ju7V054jsrOaETs+uxxqlh/w5R0K6vQpO4K3ytg2VXWeDbmAE2js3sehW2UV6YMVHe9CdnULOdEYfCezC9FGytgyGbsXB78xXtqj1hAhrqbtLgfuKK3Z0c83Q8g+X3Jp4R4McirYIohustXg8qo/2/EW3iTeCiUJG8WfkDwhLZLj7jOyg8wRNYaIcHsdPhKMiqzXioRack2pyMzDQJjOBemwm9UHMWdFb3DPkmmx1gAdD/z+yT4yjV6FVAvrZ4pZiOl+SeZ5X1pBl+kQRe7K71E/7myVqNvleeHG7/5nc2GdgGzuW03cdnmXmPinWHNXgo2GTRT9YPVzXHYVqnh8zqu1JUGHF+xnE1aiuupL87yXuCJr5+uwGhOya5+SmfEZqV4BrCNsKqZWNpWh1Dxq9RgfuCMQoie8ZJidjFCgqDBOLEdrmFHoKxB1HLIYvtz18V2X4ko3Lt+YI8ypCze8NQ/b4tzL4JFGg4JXKAJWeu/K2fd3ZuX1/lE9TgjvClpqAEn5LjzlKHmm6wLVCb9UnKiUQTnyelR7d7AJ69gxHrft01ijrQaFc9kOUVyEZ/S0eJgzBFF8gqK6VQH0MMWGaNlugACT2BGMlarw8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(558084003)(186003)(6486002)(36756003)(8936002)(66476007)(2616005)(54906003)(6512007)(66556008)(8676002)(508600001)(66946007)(4326008)(6506007)(31686004)(86362001)(5660300002)(316002)(2906002)(31696002)(38100700002)(6916009)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?bi7K860lzqD6Trs3q8r+LB3TrIJwW3r0fz0poT4OZsrItqBM6SzZbGHYjxfZ?=
 =?us-ascii?Q?VoUJx8ZgoJq57Yant7+W99QVIVB9zI1tFMA7iMOOa+c0oKbPLK5YFvarLEdi?=
 =?us-ascii?Q?8mL5vqToLrlEtqj4NNYikOUW2VSxdXx770yD5DB7uExVaeNxff8HbZdFe5iB?=
 =?us-ascii?Q?b+oZohWXU4yWiODUdNMqGBykJyaKbVEUqp/Ae2wRG0VhEv4qam5+sUUNRFAj?=
 =?us-ascii?Q?/tvv8agPH5FypZoc7uRnVlXqGhAwyf4r9pHErqAS5nhpziwDOdIl4/UrnmbN?=
 =?us-ascii?Q?Ae8hGgeQ/sCeXyt/kgqu7RKKDRViG0SOLbbnAI1Bwjk/TyzuUAA9e9BSZfZb?=
 =?us-ascii?Q?wQn3yXPrF3NnxV6uIS12I2llwOfOyNBOf8QDwOLlJFtmH1sNx61N//DVSf92?=
 =?us-ascii?Q?ECihlEpmg85TWjRFdnbrZwXHV1oOz9gnGd4M+MGZfiQzNb5KRcp8yAifF7M0?=
 =?us-ascii?Q?CTNfnmzTF490tCcroKatwbzAbO7RJQqXFNNTdSl5O7TZXAtuVu4dYmD8aG0K?=
 =?us-ascii?Q?3aGYSlOYIhW+JQ9jzgGjtCHHGd0MDFFFG3UQn6P+XM7JNzsW2eBwcUZVaRl7?=
 =?us-ascii?Q?QgWNINSYYazNdb44oWr6k8cCF3TlBRW8FATAhj5z7cRIj5b0lEKRDFYgfISN?=
 =?us-ascii?Q?PMFemkJCOsIZqhmjE46AHIvmOIsFFqL9H071Mhx2HQ1p7H4eXkqrB3EBE/gF?=
 =?us-ascii?Q?jGVep6RRA0xYIH1mcb6EPJh9dVVpFqJ578NcRAApLoqR49vgzCxRJ17ezFKe?=
 =?us-ascii?Q?fUPTEKYO7TdRFO5e0ipxTzXd6+LESQqoM5LADIwXvtpbIlGrXsXPgHFi3TnC?=
 =?us-ascii?Q?eQZDNiOBd20L81zquW4teV35qBhmNHlPm9/tZnJANeJEoxob5YSUl10DKvzh?=
 =?us-ascii?Q?5RwG5lMn0aDoQZmf3McLndelnnZExuIKPG6p0jBSCA+VNlBguohdQGAjsucA?=
 =?us-ascii?Q?9h+s6D8fP2WADc4aVUytkx1AkJ6l7QlxGMxxGFITNhYud1cRvCFJ92NZ4WsM?=
 =?us-ascii?Q?XsRd6fz3SNoFJCypze/ZcfOOJNSZGV0IYVKNL4bcjeCWiWPTPjmgUh8CHyEB?=
 =?us-ascii?Q?LX7B4+fPXjCfO8U5Bz/IMXFDAYHWzvTCdeBVnYqh4B/YvE5X8iXSjXscJW7M?=
 =?us-ascii?Q?itjklVuJDz8uknzd68wYUEvMSQBDd+0QXusBn9YhHDbLS6qYLGJBW6+VCVT2?=
 =?us-ascii?Q?btS2hBiuKCchrf0HVD6CtjVVaSK27l7X+MAZQWzNrFbMcWQR1VjqdPNBcwN2?=
 =?us-ascii?Q?dfM6Mi2zGd3eUp+iuXwz5ed+yRrRQ+xF2cAhZoa+tcD1Ptcn3HBqwgi/xv6k?=
 =?us-ascii?Q?XV4ranPOXQZy+iEyxhXFStlR/8qnAmUezcHQpviF6oxKAKHDC5YelPNXBmFI?=
 =?us-ascii?Q?NLXz6jeFwdh8W3wNxRjWyDcCzm4OJJ/yQ+2Db+d0/BjItt10y0EVi0h64NO6?=
 =?us-ascii?Q?r+AIxbg+CAQuda3fCYjD/1JkfZKlIedI06efQigsd7Ktf5fOcIOdsjeTtc63?=
 =?us-ascii?Q?Y+jHBD/XPgk4zndPn4mUp9uuaGvXOWbZUNn5BLfrcsaz4Zf5Zk8Ils+hYXfa?=
 =?us-ascii?Q?UfA37f/GUeh851nO6lo1dmb/NQoSWL3xDmZqGHIgjYDV/unCa1IzY0qDKgaz?=
 =?us-ascii?Q?dNa/FaiKZxEB4txUsHBmymAZogGRRO8XF+YVMwyP14xF6LC8KZUMVBPV3BE6?=
 =?us-ascii?Q?35B/SeBS8fgCWsFzG5EjpeusbY9a8Eg3tK/lPKPRQjepjDsrJXzhAp4ncGYj?=
 =?us-ascii?Q?5WtKlGbr5aH6NESTh1KKBPyjcddjYVSIJeNAs6YbMm1Hp+EIBtf6d0Ua+wJc?=
X-MS-Exchange-AntiSpam-MessageData-1: 1N9+GDYtwN8OlA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac835712-7357-48e8-9638-08da1301e763
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2022 10:33:32.6492
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8BbHi4ePq93ie2MldDr5bwTxMW52vncqI3iAiMIDDd0NAJhQ77SyAewZGSJn5jsvMdwBrNSvI574ictvwX3oMw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7147
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

looking at this I wonder whether the check isn't too late.
Do you really want to restart autonegotiation although
you know that the device is gone?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

