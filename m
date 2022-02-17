Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F090D4B9B45
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 09:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237877AbiBQIji (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 03:39:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237815AbiBQIjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 03:39:37 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F3429E954
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 00:39:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645087162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=YUfkKf1l0FdXRHdse2iFcVvN6RUXq77bmt3x9WGe/KA=;
        b=ZBRDZAUNFK/vjpekAOANc57hM5m3T1Z0CFPo4S/6G2AzmzVJeQKxJoKIOmtAkA3MWMv2+I
        xxKGJPkWxvzH1h/azu4Z3ifT4n8Hq24+j/OaU5+QV/+29HV/X8AIbxPMqR/li1L1dnrjA4
        a7fB0hd1JbwVK6u6PU0x8VvhMVqyc+8=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2109.outbound.protection.outlook.com [104.47.18.109]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-35-R1wDjSKMMU6OWU3TJvQ7bw-1; Thu, 17 Feb 2022 09:39:20 +0100
X-MC-Unique: R1wDjSKMMU6OWU3TJvQ7bw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qd4CDXETQ7wvCh76WJj57Qn5u6UV2KX9IoWmlyaC5R6hQKlz5SrOsZJevJBDmcUxdg2LXPOEsGsjk5GgePWmrseU2bJLtfSCsUGsYA23Fmb5j5MqwnFgrie5jOS5waGrJUDMmE+0k113ieg9iOwfIq4OZyjlQDivbv6BAFIYiJxSQzPkvwlNGZVbsBSPFyCll3M4sxjSxrXCxtr6o6dv1F1BdTT+JYWPhEs6n1anH0r/UWUXK6N4PI/Y2960ydImSEND6KVkkVm3zavlKoCy0Lq5lzrqZ7ZyhepZpIuYiamkyHpuOr5qdkEq86xWPlOx3PWjEH0/vaJsFD28XvBDzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUfkKf1l0FdXRHdse2iFcVvN6RUXq77bmt3x9WGe/KA=;
 b=IKmf9pYCMVwcMIUPzYwujIQnQtt3CWmEcWh9AGBC3g3k/UyyskqfyJsD7HypSv6Acc4grCxTjqlBjlX7nuinW8N2W1k3pq0JUodeJgnAzUmeoVAO6oms30ReuQJmXeOumv1ChY22wpT5OaRg+lHtpdVliHunbVbe17zTtOVvGu4f+IZ5FIQEXQAMglttQ/w9agwzujyBqululH0tDJJYWJMLxMczlR1tV4NaxSoqEzr5h9mfviOqKWPH2DTAUcGCrebKkRZ4GZho0RfwSQtrkn7xZwvpuPhltqriF1AJhMai6wJW77Iqz/8W7Y3lCijBKgSfF4A6TABpgCzNtVR4Eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB7PR04MB5163.eurprd04.prod.outlook.com (2603:10a6:10:21::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Thu, 17 Feb
 2022 08:39:20 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f%5]) with mapi id 15.20.4995.016; Thu, 17 Feb 2022
 08:39:19 +0000
Message-ID: <87263446-1549-a98a-f532-e8b3faf62196@suse.com>
Date:   Thu, 17 Feb 2022 09:39:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stern@rowland.harvard.edu, USB list <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Giuliano Belinassi <giuliano.belinassi@suse.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>
From:   Oliver Neukum <oneukum@suse.com>
Subject: malicious devices causing unaligned accesses
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AS9PR06CA0068.eurprd06.prod.outlook.com
 (2603:10a6:20b:464::32) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 31cf7ca9-a03a-4958-f628-08d9f1f0fd33
X-MS-TrafficTypeDiagnostic: DB7PR04MB5163:EE_
X-Microsoft-Antispam-PRVS: <DB7PR04MB51631692B6B906CC70E0312FC7369@DB7PR04MB5163.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +b9myrAwuRQEYF5IZ5/kfsfyl2gVqyvwi14e/m0FD2x3DCwH+WdRoF7z/w2t6dNuYUpRQ8dD4bBUI3eVMaMjjjR8iz7BvsOYTjTztiiU7CMwbQoZXbYTcG84JQTYTzWg5LJW+zyzYmZq01e1Ni8z+OWDiY7EENnhXAmUmOLw6E0ggX+TwGpUn5EUHCXgoFX5d1fprqSKvhTDCVhJLH2A8xrZDXvs1FLedJsrBn8Kq5VXWTImIYJAcL7Pl8/fwQOYR2MGDhJsbkIbEcYyTHLXU+Al9Sjsytw3ALfF2YRq4Es6vRojWdx63CqxjRnmBmQoT3fWzdOL6SQ+GIZVWzJ+bn6l019fDSJ+lMgSmCs90z4dLccNnG92HpQ54Q0xQWbTvIE5ZxToz7sO5ALQHGJpAKLJtlw4/faxYmTY2/GVI1zvaydoEItzEcrMs+eKXaRmK/rNK+nHd7Gz+OS+OJefsRg9YdMmQIw+o1HZrgSwdC/lEEXBqW/bWkWKuEax0hAja9ormeUynEqpsX+N3UAGiJTRb/vw4q9sPCGOo1qY9N2/faHt9np5caR56zW40UJp7Y3drz1q+uzpKTlpD7prn61kKr+XlDaxWAwm1mwNKTMJY0luONqlG/VyEfx2l9KL4hJ1lBxXIVPequaCQXiFHdONkprP9LVy0ec/VGtKFCAYyL1ij/ze+XIgRXXnk5k6tlne4Zhglgt0l7te7QYriKTQ1pkJAK6pHM5tW5N/Sz0=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8936002)(83380400001)(316002)(54906003)(4326008)(8676002)(6916009)(36756003)(5660300002)(66556008)(38100700002)(2616005)(66476007)(186003)(66946007)(4744005)(31686004)(6486002)(6506007)(2906002)(86362001)(508600001)(31696002)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZTh3TGtFOWFNT1BPNmVWWEpXV3NSK082TmV1Z3kvZmk5dzN4WWdQNUdXK3hu?=
 =?utf-8?B?Nk8wMWkvdTNnYzh4WFlFUTdXbkEzb3dGSm5palFGR0VTV3VtTzdEdEZBdFBL?=
 =?utf-8?B?ZVpoSjBDWkwrc1RURDdQOGVKMDhrcFR2QmRwK0JLNFdDbFJTRVpxT2Zha0FQ?=
 =?utf-8?B?RUUwUWpUanZ1UGo1WEFqUHgvd25uL1pQZlk3cGtaaHVrTWczNFk4b2Q1YVRI?=
 =?utf-8?B?RE5RMnVUNW1iMjNxUkQ1YnkyZFl3c1MrUHJmMlpjQXNYa3JKa0dqOFBaOEhr?=
 =?utf-8?B?RkRkdVZQSnRnK3hZcjFHRnVLQVFINnZYc29EdG5WRHBKbkdRVGgrbWY3SGY2?=
 =?utf-8?B?ZERodGRCTEJMM3lneHZCK0RRUG1Xem11NzdjQ2MyZndTTmhVRm1paStmNzlF?=
 =?utf-8?B?R0FxdkwvTFZaY2Y4aTEvcHhCMS9QZkF2WG5oaHF2NjB1anRiTmRqNkJDSnNF?=
 =?utf-8?B?ZnNySFNSR1o2MFA1THdFenIrMS9uL3lyamRPRnpjOGRrdWFkbkExZVpBNUNi?=
 =?utf-8?B?TUpaWk1qdXdzRVFpb3pkWSs1azVzK2JBYmhFLzRERmFuUG95bVEzZm9sVW1t?=
 =?utf-8?B?THJvai9LOWlvUWZwTUlHK2FRaFhSQUxwNW93SzR0SkZhVVgyV0lBTU9STjUr?=
 =?utf-8?B?S0d6VGlCaVY4eW4yWE14ZU1lNk1hUWRIb25LQ0VIRVY1eGx6UzltcG9YRDk1?=
 =?utf-8?B?WENkeVRYWDJhK01iN2hITkpZL0hrV1BSbGpMK1RIcW9HSVRteHRRRkl2a0Zh?=
 =?utf-8?B?a25PSVpzeTFYdC9qUjVmMHZUcjYxbzIwMEwrSkk4bHF4NVBlL2FsV0RCeVha?=
 =?utf-8?B?UmdsUUZndFpIZW1TNGR6SmJJd0Z6Y0NveG5ReHYxb1I5dFRDRzk5YXM5TDN3?=
 =?utf-8?B?MjYyVGdlVU00MjFLMncrWHpVWXRMV3VYeGZlMmZMWDMyekJFaWxJa1lXMVRv?=
 =?utf-8?B?OUdnZHBHWmdqdXNSZGZQOEhJNzR0T1J3YTE2eHhuSG1TbE5kWXg0Z01CWkZt?=
 =?utf-8?B?MzZpK2w0SEtlNE81eVJHMFJBcDNsb2F0TFZZd2JjNDZTT3ltYUEvS3lyRCtQ?=
 =?utf-8?B?UytWQjFucjlNZTM0cmJNWTFFWnk1M1U0VWJFQmVwOU5CVCt0Q2pUR3Z6MG1n?=
 =?utf-8?B?VitRSWMvZEZ2SEUvN3JXT2d6YjRMWHdvc1NmUGpmMXNZKzFZbFNPYldTeUdO?=
 =?utf-8?B?VVp1bWlIZ0JMY1dlK3kxak5pcmxPOVJpWTdsdEwyWjVaWStPY0k4TkR1b3pj?=
 =?utf-8?B?U3MvK2Zjc2dYdzJoMHB4c2dlSHF3YU50NzFoNit6cEM3aVM3M0NlV3VkUE1E?=
 =?utf-8?B?M3JRQjZzZUx2MU03NVpRTkoxQWJWdzlMR0JHSkJxemRPZ015UnFRZG5EWEQ3?=
 =?utf-8?B?K3J2SEhCZzh6QnllMWtLMnJuV3hnblFidFRlSW9vSkkyZG9DN3EzSTRDTjNK?=
 =?utf-8?B?dzBrSDdyT3Rjc0lVM2VUUFlRdURLY0Y4bUMvK0lqVGNSYW81ZlBURTVYUTlR?=
 =?utf-8?B?VXd4QmZsYm1ubjcrcFFqT1V6WVc5VFcrb1ZpeHlpbXk5L2NCS3g5R2JDeHZl?=
 =?utf-8?B?WUZmMEExZmNxNVpCYkRUdEh4Ukg0dHg1ck1BaGNpczdyRzVqTEE4VysyUyta?=
 =?utf-8?B?YU5QVitzUmNjdWFzUDVXYStwSFRUOHA3NlV3aWJ5cTNzalZoQW0rdVFheDkw?=
 =?utf-8?B?NkFIRSszWmtiZ2EveGVQSXhLcGhHZ0g3ZGFKMVYxWDdLdlhWL2xaSTNZMzBy?=
 =?utf-8?B?U2Z5bkdpWktBL0dwZHJkblBTaWxZeVA3b2VBbmhxdDFLU0d6dlFpSFNscity?=
 =?utf-8?B?VFFpTTZTc3FveVc1TG81R2VnYUxuR0NNckxCcEp4aVpYc01wQXl6a3UyWm9J?=
 =?utf-8?B?bEZDbU5QTlBwMlkvQkFPYzBLWWVnU1k2blNJbEd2NXd5dWJTQXN6QmFlbnB5?=
 =?utf-8?B?cVBpdHRYN0dBZ01COVV1WnNUS0d5SllvM3Z0UVVsSHJDQXE0TGx3WDZ6OTJw?=
 =?utf-8?B?ZGFiVjZteGMwaFZxNmIrd2NPaEVHTC9TNXhZQmozOWVlSHpDdnBvZHR6dU9m?=
 =?utf-8?B?TDlaeCsxY0lDQUJ1NVowdXc5YmlnZXlSSkRBbnFuQlNlSmVzYUI4TG4weHdG?=
 =?utf-8?B?eEVWbFVmUFg2YzZXcksyRGRVRTd2bHNzRnA1UE04cGd5NU1Ebk9FUUhhWlU3?=
 =?utf-8?B?WW0vVElQTFFOK1ErM2Rra2NmZHlKeGJEMUNTcG4vbFpnZDNCdEw3dFFtWWtu?=
 =?utf-8?Q?s7ZD3YH+sLiWIFeTIH57MejgB23B0KbFRN/AVjmwKk=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31cf7ca9-a03a-4958-f628-08d9f1f0fd33
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Feb 2022 08:39:19.5246
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E8VfExKx6P0VX5PgUEsshkyde0NM94rOnODpQdHYG5jpg5W2K02UZkkVpZVM1kvnR2P/rCB2BzciHD2qixqTnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5163
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

while (offset + qmimux_hdr_sz < skb->len) { hdr = (struct qmimux_hdr
*)(skb->data + offset); len = be16_to_cpu(hdr->pkt_len); As you can see
the driver accesses stuff coming from the device with the expectation
that it keep to natural alignment. On some architectures that is a way a
device could use to do bad things to a host. What is to be done about
that? Regards Oliver

