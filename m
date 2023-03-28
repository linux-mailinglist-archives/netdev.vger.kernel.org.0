Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0599A6CC185
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbjC1N5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:57:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232484AbjC1N5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:57:16 -0400
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2045.outbound.protection.outlook.com [40.107.241.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C11CF729B;
        Tue, 28 Mar 2023 06:57:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qb0D4sYCQsB0e+GERBn8qAvDQG/zsiOhGZWGgwJCeBQv/ucU3c1pMN11r7sZJPtAY4h9Y2dQSAHclD4Yadg7pj5uMEGiW0Aizu31DzhQn9xJXKwTVAvT/Bw9qvHaTQGpPo4u2VXbEMo6PFXXmdWU7bIpyf9jYJz5n7rBIATg3M5QCNlbKwwritz7q9j+Ht64hk26Vm3anwoUNFrcvimiE7V0NBjhrnAX+YkAKzZ/Al4yX8YY418z9yjef+KN/EVPLy8m7mBNDo5xSadexgp/m5NaS3C0Id4hqNbk2rS64hYdI4hvYZT+Z70URLtgdwaSxZRjsqHeU9lxFc6qgNwp0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+9TUmBIYEGl46AeH09cvKAPol47UwJJ/LDEqA7e1ToQ=;
 b=Vwb4EHEdSM0hJJ0zPhWZQvMo2c4Wwenl5os9Au3XjwcDaQ3Wkdg9ypnrx8mvXRdiR++7+uCCluDgZ6DNd3Cy8/QCOHqELy/3RqzehaBta2OeufCn4cNNaX4dDmcngQ7oDzVvtiQ+MDreu+7gMR9F/A7Ww8qV3HYeGM57hCDx8wzTGNy5Lzy2e5AGWt6bTTCBGpA9OOa6YTLPDmH2z99+u+isAkV5b01m4yyKEMJBNWMqVZHKAVNIxqaU1uOINvijm3ZQPDJQKd8CEPjI9GOIViXVfO/IcAWMFXCSN/xV3seyxgn+2DcXkaZS0cLfj2dUnJM0/h/zoCuhYs2voEwmNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+9TUmBIYEGl46AeH09cvKAPol47UwJJ/LDEqA7e1ToQ=;
 b=nlysnF0Jyk2sIC4+Z+TpJL5kYA2E28u8DxoZlTgGqgjVL0RxBqX1FPXMsRLU/7T64k1347buqLulJTzX287h0DUwnT0fiVl4TUP5JVfW2aclKBnh5GNEZbj8msn+wgeiezPmLmCi0gsULjCKSIXpukBTYVYwOvZBXXAM19tgVx3aH3Kd/ymrWmzMJgdo+DoQX1rFrXrOoOHqzHIrg1KBO1JJu1GL9SRifFTM2M/JzDYEfgCR0+sb4inY/tKFYb9jMHaB/8SyLuS+2ANbRJj2wLAatYh9oOLD9TILHdZGvLyD6O1t7Sfcp9LjkMpozjHCPWOzwySam+0PI2GhdjJYlA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AM6PR04MB6551.eurprd04.prod.outlook.com (2603:10a6:20b:fa::20)
 by DU0PR04MB9657.eurprd04.prod.outlook.com (2603:10a6:10:31c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41; Tue, 28 Mar
 2023 13:57:09 +0000
Received: from AM6PR04MB6551.eurprd04.prod.outlook.com
 ([fe80::4189:2d2a:eb83:5965]) by AM6PR04MB6551.eurprd04.prod.outlook.com
 ([fe80::4189:2d2a:eb83:5965%3]) with mapi id 15.20.6222.030; Tue, 28 Mar 2023
 13:57:07 +0000
Message-ID: <7fcb4be2-2c8c-dc17-3266-82c35a45eedd@suse.com>
Date:   Tue, 28 Mar 2023 15:57:05 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2 0/3] xen/netback: fix issue introduced recently
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org,
        Juergen Gross <jgross@suse.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20230328131047.2440-1-jgross@suse.com>
 <da45f73bcc2642260ef7718a6650dc535cc05c86.camel@redhat.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <da45f73bcc2642260ef7718a6650dc535cc05c86.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: FR0P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::15) To AM6PR04MB6551.eurprd04.prod.outlook.com
 (2603:10a6:20b:fa::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM6PR04MB6551:EE_|DU0PR04MB9657:EE_
X-MS-Office365-Filtering-Correlation-Id: 076ed602-5b48-4ff4-ca55-08db2f945155
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fUXPCu5GUYkWtxsfg/QpC/BynnqmidM3jSkLVcA8N7ZmtuqABLspZ6ye6NKZHuslMAHBzBlxfPoNNEhfk6TcFZ3qtzgWc0fLxfxtCwu9m9yMv1OWlDUWnjNt+tacshjE1paJc5UE5eXCyb97LwO3O+J884aZB+OPzcNCyvQLzoyxeU6Idm+Tm3ibx7+3csgS2DDerUOn3KJyOIgPE2BVyzs25s8UuZ9R99Nj1CY1RtLLYHy3MkMnSFjV9n2Ou2EzOPuJAbJKUkwPJB6PIvcZNXJzeuwJxE3KdBS4FGsnSyM31qLutdVLDNpgCWxoe8y4ZqKJ4g15cCu8S2UFEWNqFgqdxkgzhZvu19eKySiu3/7D4xy7PeDMs1yt+XbzcNFn6/LDCrpdb/8yCp6VNGFcc6PkT2wxEZJ42MALvU7PYNyvOoI97aEwSQfGJFVjueHWMk5xmGpljwpIJJ1ucYdqxjI3F/fzrwQS2WmXHMRXEzn4AldMGl7mXLySA1Y/fyipgRadhZ9zxab5iCoS4ZOmBmd9JMCMzr2SUZ9iTsoqk7m14vW2a+VSSrRRoHKEXyJcH++hSN4vi8qhgAtjoFPTSHlhCbGrrfRgZNY3USQPPkQ/NEWSLptLbAgRt1iDYl2ZX4VINYxYJlkUoZCPq0ymug==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB6551.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(396003)(376002)(39860400002)(346002)(451199021)(38100700002)(53546011)(26005)(36756003)(6512007)(6506007)(186003)(83380400001)(6486002)(86362001)(54906003)(41300700001)(31686004)(2906002)(31696002)(8936002)(316002)(8676002)(4744005)(7416002)(5660300002)(6916009)(66476007)(66556008)(2616005)(66946007)(4326008)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TGVmMHJPZ1d2ek16WmE5TmJRaXBwWUFQdWx0R0lUQ2pJVWVZR2NlaWZtMW52?=
 =?utf-8?B?OVZzTEVxcG54Z216ckh1NlJOYzg5S1lxNnZ6SWd2TFFISnY4dm1id2pSak80?=
 =?utf-8?B?ampGck9ubHdVcmNvTU9GQUlGN3Z3V3l0cmhSajYxSHRWR2hhV21oTUI5Y3ZR?=
 =?utf-8?B?OE9VNVVpbFpsWUR1YjI5VTZlUC9FekF5RXR1WmsvVTdvOWx5VW5WcHBnakNQ?=
 =?utf-8?B?VEVmN3F1TXV6b0oxZk05OXQ1T3NDTnlnenpxSm9aNmpROU5yL2hka0NWcHB0?=
 =?utf-8?B?azFHc0pzQkhSd1Q1YlV3Nk5HTFV1WGhEZmFENlE3ZGNYVUVabFpjM2sxU2Ro?=
 =?utf-8?B?WkgrcVVxYXJieVpRQ25MVEJ3YXlIL0hjb09oTVZLbTQzSFZnalhTa0NVTzd5?=
 =?utf-8?B?R1NpR3R1djNFTTFERVozcDhvZG8vV1VrNE12NXNtTEUwT2FqeDVwUEhYbDNQ?=
 =?utf-8?B?VWtUc0h1S1pmb2laQ3VSRDlWekNaMjhQNHZncUU0UmlrUFo0dWJLTmdGOHZx?=
 =?utf-8?B?ZHhTUWVKRndmdm94QmFEM0dsVHg0YzdUOU9ndFNFOEsrZ1ZuT08xYzhJZ1Fy?=
 =?utf-8?B?U1VqVnkvcTFnNXZpRnRUK2tqVDYxM1NId04rcGRzNGpMbU5SaGFYa0NHcXla?=
 =?utf-8?B?YzMrYlpjOXY5NVArOVdtdXluZURNeDlycVp2NEpOOVI5UWpFanlmUCthQjBn?=
 =?utf-8?B?WDBRenRiS3VPMXRNdWN4Q1FMOXhndVJzZXhyNEtGdTVjbkNVLzVQZFpnQXZl?=
 =?utf-8?B?bVR2UUtMK1JVdjR5djRuUllGRU1XV0I2MTgxeWJKelRGcmIzWURnNkdHWXNG?=
 =?utf-8?B?aURlaUgwaXBYYUdSVzlyM3BjQ1RlSGNGcVhETEsrRWtENXFENXpoS2RqODNy?=
 =?utf-8?B?U3JtUXBZSVgzT3RyekY3dUJ5MERQTVlFMUlsa1kvUWVydVdTRm5SL0kwR1BH?=
 =?utf-8?B?SUV1QStrTXdGZXZ4S3o0S2xLRDNEZ2d4RkpGTzYycGV3VkdVNDhDQ2xOY0lG?=
 =?utf-8?B?S1ovSDk5Qy9lK0F5dDNPUU5KS05DeG9TTk55SnZibVNtUENzbTVDYnVMMnFE?=
 =?utf-8?B?b2NsMURLZjlucDZqR2RSdGNQVndNdHYrRm54Q1pLcGRlazV0NWdrWDEvVnRZ?=
 =?utf-8?B?V1JUbUlIR0pJaUxZdmlOTWxVYXhoTTBXdU5zckU3a29wWUhWTzVMblFzZHdG?=
 =?utf-8?B?VTZ0UnRsRytRUTAyU2U4RFRtTlA2WnhFR1JTcy9oeEZvVndSU0lMVm90b0Zk?=
 =?utf-8?B?ekdCa0VsSnBieXZjMFNvM212cmtiZERhd25ycXQ0YnFPRG9jcXBDcWZJYlFR?=
 =?utf-8?B?eGg3aUVlSVZmUDVjVUFIOGNpSmQ5N0w3NkZXUlhSM1g4VDI3OE9rZURnOUlX?=
 =?utf-8?B?Y1B5REUvMHZRMTNIS3dBU0lOQ3FuZVVXZjVycEN4YWZMZHlOSWZDK1NnRHBy?=
 =?utf-8?B?YXZWMjNqZTh6bHIxK0d5V3JYZm1YcE8xaHNQaHF2cGpGVXQrTkpUK3YvMWMz?=
 =?utf-8?B?SnJCLzMzaG5leSs4WmNBZGZEc3E3aW9EcW1TL0lSb1ZzbkF6dFlWZ3hLeFpP?=
 =?utf-8?B?R2QwMnF0cUx2KzlkVThUYVYxRFBvNVhEUENKTEF3UEExaUdhNEcxYWVvWStt?=
 =?utf-8?B?c1IvRlgvRXc4ZENtajNHZlMvNXNwVjZnT0orTDFPL0szQlRJRTBwcTU0M2N3?=
 =?utf-8?B?Zm5yWGdycE93VWwxdkRWUFJYV2NxOUwvNWlrVjNwVkNPYnNWOU5RcjhKYTB6?=
 =?utf-8?B?UkJRb3FiV3pyUEFWeElaT2FmV1VCNjMrbHRpMWxMVTNuenVsNjliNUlsbGJm?=
 =?utf-8?B?dnkxRXV2YUtvQnA1OFVHaldFZ3dHR2JleTdERzZGYkZBUTB4VVQ1NHppVFNP?=
 =?utf-8?B?OTM3YkZVbEFBbUd0dytzeXArNjkxRGttU1RHTm1veHZBWjNUYWdEUHkyUTdt?=
 =?utf-8?B?bFdiL2xPakgzY3R4eGFNZHVNZGhQKzBoQ1RMWDllUnFKZjc1aUk0TlBIWEJ4?=
 =?utf-8?B?UmtjSkM5eHZWZ2RBQmpweWdmN1ZBQnFIOTQ5Q3BqTkxLZXRPZFFadTF5cG9x?=
 =?utf-8?B?SDBHR1dObzB4aTdPTXNvOVNId3EyRzZlM1JMYTU0V1VucTA3cXJJNWovL1Ax?=
 =?utf-8?Q?atFtUP7SUBuJTGHLF5c/Q/Vsx?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 076ed602-5b48-4ff4-ca55-08db2f945155
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB6551.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Mar 2023 13:57:07.0760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ErKnn2eW9ki8FF24/p/klBK1wr7aFywRgIfCdLBZzirej1YKnLpF/7DODiZOPtraqxd1pTKk7pjzJMDw4jmuQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR04MB9657
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.03.2023 15:52, Paolo Abeni wrote:
> On Tue, 2023-03-28 at 15:10 +0200, Juergen Gross wrote:
>> The fix for XSA-423 introduced a bug which resulted in loss of network
>> connection in some configurations.
>>
>> The first patch is fixing the issue, while the second one is removing
>> a test which isn't needed. The third patch is making error messages
>> more uniform.
>>
>> Changes in V2:
>> - add patch 3
>> - comment addressed (patch 1)
> 
> I misread the thread on v2 as the build_bug_on() was not needed and
> applied such revision. 

I guess it's not the end of the world if we go forward without that extra
check. It's a safeguard for theoretical future work which, as Jürgen says,
isn't very likely to occur anyway.

Jan
