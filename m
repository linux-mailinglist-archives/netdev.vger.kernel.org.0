Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80D326BAFCD
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 13:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbjCOMEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 08:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbjCOMEE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 08:04:04 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2043.outbound.protection.outlook.com [40.107.241.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F48231F5;
        Wed, 15 Mar 2023 05:04:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTfvAIY/FyCSAmUFA6tV4AAxrFYt7vPET/yvcXqj4CQ7w6EUn2hCixM7BE2lKsD0R4F4rnsJXUc9COa6pByumgoy2nbvCrl3Eu3h95M5OTigk/m7XPj9/MxXwXeNuf4Q7e8J3mDgrN/Saor1Tf8YAGv5E0CMmZTGekz0LHT60Olfu3UAV4Fx5YgZrIwl7FxeI+GzmtgRAj2lmxmgaQJu+F1VUdL5kwI6pGVmqMIFOWGx4XjFYNPeFKSm66dhMqol9ghXFLc7QEvWYYSyFTswsG/+DnQqJ61GIFANd98wwdyIassU+o2XV4KjmZlqpeoP9neHJ+GV3qgRFrAQ0W48kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IhNUpN4/41nl6G24YH5/xajqUGUD/tIQsSxjb0nYD0o=;
 b=Td29bZ4301Fk9zDvvvlMUY3zVWtsqvYcDo2yZHs+P+kTQbudXBaOVeLOQmI7pWkUjDF94qhWna6L+eNK1a8/ApF90qLlxZQDy/yr2GmCvDaFoACV62uL87FVZeDZZmArSjHwfQm47btDbF7U078gFz8CLDOAuavN+jJ5y8G5zUUJB+kP00cREkRyk4SvPW8DTxVR3KIhYGlRwxa0BPQsMZD4RfzeGWQ5D3cDamz0i8zfV5Cn0R8Nnp+caK0i/GNmQiEY9zqmmg3uH91w1wZoitAm0NtWg4xhYxYkbJNQ+FMMTkCzpbYuQoeEGHgpkHepeC2kKX+0HRz46mI2ERw8Og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhNUpN4/41nl6G24YH5/xajqUGUD/tIQsSxjb0nYD0o=;
 b=gzdP4HXfGbX5cxjSVdGJXDREAY7IoKhWVG8WOXyyVJOd8IgOWMx6H/EvHCpZTjdnBhEr+LfnyfYcUanI4cq6ecKrW70Uh+Q42WEvYDSULHLojIOnj+mBfG2CRsnuej91y+pScM9ChAoSiNkj/U+Deq20i0Zh8jCcbBvlFuoxDBw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by DU2PR04MB8629.eurprd04.prod.outlook.com (2603:10a6:10:2dc::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 12:03:58 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%7]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 12:03:58 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v12 0/4] Add support for NXP bluetooth chipsets
Date:   Wed, 15 Mar 2023 17:33:22 +0530
Message-Id: <20230315120327.958413-1-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SG2PR02CA0096.apcprd02.prod.outlook.com
 (2603:1096:4:90::36) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|DU2PR04MB8629:EE_
X-MS-Office365-Filtering-Correlation-Id: db33953e-faaf-476b-4d34-08db254d5b5f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CklU6qoVhE/kLXG/CeVjmDSkQxfFguRfB2oRURuwvJ6EFkuz7gnh0E5TP44qCOPlh2iCaCw5sqU5/JeUu7jnQjiAs5yuWJ5/Yvdoq+ULqgCklirOkV5Ab/ZWc+0u2l/iP7+5wPcssKYom5/V/TExFLhqNxnGWJhTmCSHXzv/UQLt3B9Ghgs6bNWEvzMu1l/f8NnH6YKmo4uR6UKXmR0FMxvm1AXVBhrE1RTzerj80KEX82K4+ETtel2j2kltPmau8/+7Zj2rtCtPHlBWOOKd3ek5nBGfmLr0AeGmAuCZYaVzOB5pfLFQacPKR/vUaq/smjMZuSJsyXFnSkwlmTDEq8kXXuq2VJ4J+yvfKo/MKZ4kImlpp9BCZrTEteMDDg1w/wLMhs6DvbBJETw4XRsljIePlm3/77rFWzpkc1uoi+zOrzgHnOkWqBWsaupL+zZtKD9duvF3okN5Ub0CcDVUNV8c+sfzCtIZiNufv727GQinol+HcO7m5RxAkQWU6DNKBc6pDb7h4JUIbxmjY4jH0OWb3uxFrAb95bChOpPpYu9H9QtWa6UielFQYnZz5QzUiiWGoWGWji2lwFq63l7P5BdRJgV6NIHHnQrP8kSrn/UzkbYRvvn4IkXY8nUZylqCgLP2ypRJyQO8AIWNWmgE4o+JeQKC21uwC2VHaL2fhE6uoAtBe82LGAiMk7Jm2kwxFc6Plmr83jWRwFBVDjuUyhooDr0FdeYW6WjKOCRBoSM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(451199018)(66946007)(41300700001)(38100700002)(2906002)(316002)(38350700002)(66476007)(66556008)(8676002)(4326008)(8936002)(478600001)(5660300002)(7416002)(186003)(52116002)(6486002)(921005)(36756003)(6666004)(6506007)(1076003)(2616005)(26005)(83380400001)(6512007)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?S1dnNHZOblhFZ3Z0YUVMQ3VqcTkwUzJ0LzRWd3VQMXBRSERJNmxxakZ6MGND?=
 =?utf-8?B?WC9LQWM3c2dWbFUrZkxRTWdZdm51MWRZRVpTc3k5dG41Mnd4cHlnelp0cVg4?=
 =?utf-8?B?UDZGSy9XOFpaek02czJOYXQ4Wk5TQ3ZWcjdsMG9ucnorSUhtM3RPYjUyOEpt?=
 =?utf-8?B?eHpBNGEwL1pHQWYySG5JQjM1M3p2ZWFJZGtEL1N4bWRIVHN2V1psdi9lYWgx?=
 =?utf-8?B?OGp1OHlPWHFtYkNESzF5dkxoTUEvclNIYnpWVElsK2EyTnp5TW1jTGRDY1A0?=
 =?utf-8?B?aHM4V09UaHFoSkZJbC80dnNEdWFTbFo2bUErUUxWZjZGMEZXd1paQk5YNjJr?=
 =?utf-8?B?dnRFZ2w0WFBrMDN5NFBpUk4yUC95UW1JQ2d2T2lURDZBY0hSeXlWNXMvTXdv?=
 =?utf-8?B?TElBQ3BuOVFRQTdMU1IweUt5Q1hNajFuTkJmNnloNzEwMW5WTkZSSHh0QnVE?=
 =?utf-8?B?aVExZ3diamVLVDFPQkZnNkhmOU5CZlpKV0tIR2pxQnIxNG56d292OHlCNVB4?=
 =?utf-8?B?SVlxaU5WVUh6MnhXREFRYUpuczlyclJCcHFBVytFUkdHanBqV2xLWlFlVkFv?=
 =?utf-8?B?alkxQVRETWlpMEV0Qi9qZ1NrSmMxYTM5aGM0c3lNakxqcmhiOHFQNUV0em1q?=
 =?utf-8?B?TnFTWEx5VFpaMmhVbHA1ZWdqenRxUTIrT3kyMUlSeWpxK0UwMlhUTHZneDEr?=
 =?utf-8?B?VzQ1Q3pKK1ViWDhYcWx0Y3RIa3lyQisxdk1uTUZqaWhhV2hza3ozKzByM3VT?=
 =?utf-8?B?QjJRWC93cFZMOTA2Q21kcE5yQm9XTmkzUHhrTlNsZ3laaUJPRGlXTC9WNWs4?=
 =?utf-8?B?dlA5UDV3cGt1ZUdSdWVXSi91UlVRUlJ2aUlSRzJNQVBqRUJBUnBhdWRUaWQ4?=
 =?utf-8?B?RGZBa0JDOWF6NlJ6WWxtR1c3VzNMNWloQ2xsVEJYbE45dk9MTkxQR3V1enpL?=
 =?utf-8?B?VEVmcksvcHlGZU4wNkxzOXJWYmptdENBZ1ZlUEJ4NktiWnJjOTZZWlpLMzlD?=
 =?utf-8?B?MTRYRWNSOUhhTnpKdGVqMnBETlRQSXFDWnVaZkdQNk9qcExVSFlnVlgxbzJC?=
 =?utf-8?B?OVZqazVuWWthZVlVb05oY0ZZWTdIL3JuSkY5c1pRMG0vTU5QTjVGTDdUbjNO?=
 =?utf-8?B?SS84REMrNXc5b1VJaHBuN1BxWldiUGRnd3JQb2JOMWlsakphZTc3dStJdEJO?=
 =?utf-8?B?MFdkc1Rmc0l2YXlPbW9NOEJwd2RNemh6R0hhdDlUR0FXOTFDQVdsdHRsdGl6?=
 =?utf-8?B?c2x6Q2ZtQkswNEhCK0drUVVYZWthRWFCc1BLaWIxSEx2UFJMVWpRTUdqUFpX?=
 =?utf-8?B?ODJ2Z3V4S2RzWHZibVRDQlBTNWZzNVJOaG1TSldndjRkYUFnbUxzOXhkYUlG?=
 =?utf-8?B?RFEzckRoRXo3OEJOQ2wyRGpDZDRhTjBVS1drMFI1WjQ2RUxiWE5qL1FWQjJm?=
 =?utf-8?B?ZmhOaWdLcGtVNXYzVnVvYUtiMVVBYm5EUUJPVUNVMm1PTzVreEErUnRmZHk2?=
 =?utf-8?B?NFd5d0xid0tuWXpnc1JFOHE4WEpld00wVnRwUEN6SENBVXFTVkZ0M09tcko5?=
 =?utf-8?B?RDN1bkpKaHBqQi9tWi9CdVlSaXdnYU8wVmhhVEhyVkdNMXBJR2lMaml5L1A3?=
 =?utf-8?B?Z01zR1U2MzdOa3I5ZmlEZVhNcklsWWhlMWJpeDdabGtkek5YTHplWkQxTFUz?=
 =?utf-8?B?czNtUlVIZVQvZ1ZndC9sQytiOHE2SStkN0xsNExLY0RueWtRQUk1Vm9HOUNq?=
 =?utf-8?B?S0trc3E4dkppMlphRVJGaE5sdnVrejgzcHpkY0lCRnJ6VGxqbk1GZ1lObDlT?=
 =?utf-8?B?S1EzaytZbHBIejkyekRDQjAwM0Y4UCszQlhzNjliSU54WGp0d3RUYW5KOGhh?=
 =?utf-8?B?Z3p4Snc3aDJVL2svQXV1WklLbVg3UWgvZk54S0VaT1lQeVhvVGlVZWZJZkJu?=
 =?utf-8?B?djl3Z2FHVkZKUmFLUGNMcDNCVjJsNTlKdnd4TkUrT0FZK1lwR2piMGRPUUlN?=
 =?utf-8?B?Z290WTRJY01NL0JyekErM0hmR25XMUZxMTFGVDJCSk0vRmtBcUpVbWYvL0xQ?=
 =?utf-8?B?TEdhOEw3Y29TTnlPemExTzFLVVFDZ3dsN211aWx1RVlHWkpTM21nSTFRc3h4?=
 =?utf-8?B?Q2F4WnlHT3I5U1lBZmRXTm1mT2FpNi82dFZwQlNwRXZUdllzbUZ6aTJIcERJ?=
 =?utf-8?B?Z3c9PQ==?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db33953e-faaf-476b-4d34-08db254d5b5f
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:03:58.1095
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D1zG5QD0F941oKli7bxPSc1U7tdgWpnzLylO3/cLnYr5oMVxJ/ChvG+nggAzrf8mocaAUkJK8id/G+pDYYt9oxHd8oHW8vx52w3ipmofrck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8629
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds a driver for NXP bluetooth chipsets.

The driver is based on H4 protocol, and uses serdev APIs. It supports host
to chip power save feature, which is signalled by the host by asserting
break over UART TX lines, to put the chip into sleep state.

To support this feature, break_ctl has also been added to serdev-tty along
with a new serdev API serdev_device_break_ctl().

This driver is capable of downloading firmware into the chip over UART.

The document specifying device tree bindings for this driver is also
included in this patch series.

Neeraj Sanjay Kale (4):
  serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
  serdev: Add method to assert break signal over tty UART port
  dt-bindings: net: bluetooth: Add NXP bluetooth support
  Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets

 .../net/bluetooth/nxp,88w8987-bt.yaml         |   45 +
 MAINTAINERS                                   |    7 +
 drivers/bluetooth/Kconfig                     |   12 +
 drivers/bluetooth/Makefile                    |    1 +
 drivers/bluetooth/btnxpuart.c                 | 1289 +++++++++++++++++
 drivers/tty/serdev/core.c                     |   17 +-
 drivers/tty/serdev/serdev-ttyport.c           |   16 +-
 include/linux/serdev.h                        |   10 +-
 8 files changed, 1390 insertions(+), 7 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
 create mode 100644 drivers/bluetooth/btnxpuart.c

-- 
2.34.1

