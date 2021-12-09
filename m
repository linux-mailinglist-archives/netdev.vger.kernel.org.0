Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8503246E90C
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 14:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbhLINZB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 08:25:01 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:34915 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230439AbhLINZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 08:25:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1639056087;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o4u5hUcsbhZ3e+vNRV8gk/Ej8h/UWrikzmo9F/apW9A=;
        b=iOkFRO2RU5vkCidlnhlpVstNsK26nBZGElw2tKanpyxQNJ8kIdyLnD/fkvMeRPxS7FbrAa
        Z4aiiqHDw35/9M3xpf8Ik+DxWVJ1nrj2AqEPBT9mNmI9fK9ItZJF5tdiNq56lBwHPF+9Bx
        LfvSTkNdaNj/kpxxr4tiatsRTh0VIBA=
Received: from EUR02-AM5-obe.outbound.protection.outlook.com
 (mail-am5eur02lp2050.outbound.protection.outlook.com [104.47.4.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-12-hBVBF48gPeq5R82_mhpPlA-2; Thu, 09 Dec 2021 14:21:26 +0100
X-MC-Unique: hBVBF48gPeq5R82_mhpPlA-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oDfrWXvaXC0Y2zeqUsnSRWBOD9E4baWDl820jiUVFUdx4Waecfa04Zss+8B/dl4yLbZdqfPn51othbYFvxtWolXhMznVv1Fi/hwN6XSCNXfyx6ola8gJlX5s+qLvFKyP8X6cNiE9mEySjf/aWf80Mz6zgFQvqS6lmG9FYPLrgBgVELaJYeOnO9ZycL1pDJrGrQbt0o0i52a7O5JaB6aLQnXiLh/ldc5WmUXatNDcvTUsSoxZ2P90IEkeeOYjJ7fMJUZbc8rFR0BGdleHk+KW9xURDpi3GKlbegUh1WZkxKEdhPBbt+2svKgfxpls4xCI/R3SG/GvgyJfZfWsGNxOnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Muq7AbAPlg4KWQ5TxumENTEiOuhMaMtWz343yh8ZPWo=;
 b=RUZah3+GSH7MCFq8uiNbHGn0biYNfFoKc+ZntKYMJQMHzX0xmfCzg4RXplURwdKVt7A+aAUAOAKWcQvxClX1fqfRuFP+ndjwIP4WqWljZP0fRPTP9GA1ifoAKeZNUZq7taFSBR8y1EL9rZTIzre7VpAhuRV4gk/fCTSiAXbcJzTfoey9TpMiyws7/FSIiEBtDssXVtPardpuDKlf3bXshnkubiBBU9FvPi2KnTkQQklpy9TNRNnmwf/RvCbGZbFFwOuBPoMYJzE50GUrK6o261J3pl2Wddh/hdukdziKQyllCZLY11yewH6wuuvV8SyOsgL3kVIvSYQQBgpuE8PIpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB7PR04MB4139.eurprd04.prod.outlook.com (2603:10a6:5:26::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 13:21:23 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::e9d6:1be9:d046:af1]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::e9d6:1be9:d046:af1%7]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 13:21:23 +0000
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 hci_cmd_sync_cancel
To:     Benjamin Berg <bberg@redhat.com>, Oliver Neukum <oneukum@suse.com>,
        syzbot <syzbot+485cc00ea7cf41dfdbf1@syzkaller.appspotmail.com>,
        Thinh.Nguyen@synopsys.com, changbin.du@intel.com,
        christian.brauner@ubuntu.com, davem@davemloft.net,
        edumazet@google.com, gregkh@linuxfoundation.org,
        johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, luiz.dentz@gmail.com,
        luiz.von.dentz@intel.com, marcel@holtmann.org,
        mathias.nyman@linux.intel.com, netdev@vger.kernel.org,
        stern@rowland.harvard.edu, syzkaller-bugs@googlegroups.com,
        yajun.deng@linux.dev
References: <00000000000098464c05d2acf3ba@google.com>
 <3e8cba55-5d34-eab3-0625-687b66bb9449@suse.com>
 <14584c1a1e449cc20b5af7918b411ee27cf1570b.camel@redhat.com>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <f47f6972-b977-aae8-dd4d-44d85db2e8a4@suse.com>
Date:   Thu, 9 Dec 2021 14:21:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <14584c1a1e449cc20b5af7918b411ee27cf1570b.camel@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: AM6P194CA0047.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:84::24) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from localhost.localdomain (2001:a61:3b82:1901:9d6b:5ffd:1b6b:2163) by AM6P194CA0047.EURP194.PROD.OUTLOOK.COM (2603:10a6:209:84::24) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Thu, 9 Dec 2021 13:21:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4f68ea42-e28b-448b-a420-08d9bb16cbe6
X-MS-TrafficTypeDiagnostic: DB7PR04MB4139:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <DB7PR04MB413920A6AC3E38FA83C9364AC7709@DB7PR04MB4139.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5wloBCcZ6nfS5XMlEaZzmA2fBSYk34eAks6LHSJyyr3Q11eHqYcvjER1q8dW4EbNib64WM4tx+6lJCPQwt8KsCreINEb9mhMCZW74F8zcLgaDpj3T8iuxZCOU6BOzm7F/iJJVGje+n7AiHL9Q42RselR4AmfWP1soLFz0aUxjIIg6eOZp/IOZiqTo2sD0n+ZWisMoTXtCrQ6GAurEhKp/VIoRp4WxkWKY92UXrEYEYG/ddReEaDZs9OcI8wiJgOVJexn+fYH0WUvwGZEJCipnYRXRxvEbK05bV4pFzFT4BptI2hlLT3bXKCVm9aaFoGfIBTzGoBShV9wLz9ibdbR0kXmMKmoE45kJc/lBy36oEXDJTorwMLV0dGVJ1Rikp1iFcT2ThnoobWeYK88O7WGuOPvLZva9/rm9mP98nMTIxCA4QWyxUNHLUeyzzMG388xmp/YxC3a7mLQB//4+AhfdrM1ZqnTVMJ29+tCMxxGkUiQbK6bNXakMvew3R1GhfrO/14P/NlACkuZByRMnFf28j4xtIeQqNkYdPWxRKwju7R0Q3e/hIdiEygjgjoZ+iSatuyW4fCuNyNp8jK1ptpBmfVPR72D+iQqAXf47k5/VZZN5eBPqTf78UfRY3C3OF59z8r5hqiNXkyqhlhpYYnm6D3JKmFFgDr5US1iptjjnMhoGox7gHZm7DVqcQOyScSmDLZd8l7QG5c097bm9mw4MkQ0Oyulk7Iy/4ELRRg7x5nRH8DgG+FaVB6Njs6BlykP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(186003)(53546011)(38100700002)(2906002)(316002)(2616005)(66946007)(36756003)(110136005)(6506007)(921005)(7416002)(508600001)(31686004)(6512007)(4744005)(8936002)(6486002)(5660300002)(8676002)(66476007)(66556008)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eIoaYPLrjZwoIy2zZG0u0qEIwKkamA2HownzlR6DC5tnQWXrtULZWS6/5UGH?=
 =?us-ascii?Q?Mrdzoe25NGXCNy97oWhszJUmbcEGBoLQenTwWxex5aMPrWOLsJ+uWsCCCGQ8?=
 =?us-ascii?Q?/+qKzwORbJepMMAQCOjQ5ghTQsMy+KeCB985EpK5X/VNfLc3q47psLWTtnsY?=
 =?us-ascii?Q?mB7v2fUf7PmCHCrzVc2orSwI4NPBWhZlX8Nwce/QrSR8V7uO+zHA2JR4bbMm?=
 =?us-ascii?Q?JMj9EtKgtHBUqEKYq8Zev/Kgar1nWdNtMWo2S9nXWK+kh/cwdsX6SMNJITNr?=
 =?us-ascii?Q?TovYM5VUOrVFyGU1khTxTbeyMyDV19eoY7dm2QBr5mMVezyH+71CeyTqL2uv?=
 =?us-ascii?Q?yKeZoH0aHXc1k4Vq9U0MTiMREEcFcXBHpO27+ksHA2W86KgMrMSdOHxCf+yR?=
 =?us-ascii?Q?r/Uorw1w0HuQtxHmwCSrOHj/yeSKW9aD81neTXz5vdw7wKFmMG+WylCkg1PZ?=
 =?us-ascii?Q?IW8DDxiaUkvW+49aOTxdbPqWXJDyXpCOLZuqvWQTsJnUtm+Sj5lFx2Jlb+47?=
 =?us-ascii?Q?i748JiJq9CMEHiY9y7FjuL4W0t/47k1D0EVgcvgQWDOIZ0LsSrDeqwfwQO8G?=
 =?us-ascii?Q?fWmETxRWcdo4uNIuE3M67tWhJlfuNaeupeI0cJ4hSC/7OukaNT6kUGf/RhPz?=
 =?us-ascii?Q?HMS+oTxtzrVvBe9GwEA61YVoB+0nbBlie2i/YImKmzvugIN6/DbgeNLMD2r1?=
 =?us-ascii?Q?wGyAMkJGR1LyxySJ3UoXM7QyCzhypPFYXdjdHicKuzxxbP6hkwVQSZLG2LF5?=
 =?us-ascii?Q?7Bmgl/aHpir4HeAjA2CmjVUL+y4/9JoAYxXKnuT0uu4dQivSgmsvgmxOvtdz?=
 =?us-ascii?Q?2U9DQh1MjC4G6o8Ae2kE66ai3bwtrVNX10tyC2LHJ5WekZ2kVD7O8PSz9hFK?=
 =?us-ascii?Q?SuE2We8st9vAcwe8rElhZ90Rj85ONMsQ5MMkCfmZd69KxkK19KvQiEkLOrJo?=
 =?us-ascii?Q?RrLDY1P7lEyquJAjZ9bBZ54BO4QtNHYvhFD8/zFJjCVPdNk+7izPyTAO+pBC?=
 =?us-ascii?Q?sIZqsj41LEJQJRx8k0K0HCKgXcqXStA6yIKOKpCWaoaB180GdfiJEuGpPmvr?=
 =?us-ascii?Q?h/rwcvj+C8dYZ3I6mfnSK8SXgv+/NpDu0+rK5bkn8UTZCV1u+7ErG5sFZDdg?=
 =?us-ascii?Q?6eonK1AAZZQPchVnsioUMkrQFhbOGOkjYMq2Q7NEElvdBt1NghUXN7PVkQIo?=
 =?us-ascii?Q?u6xjjLo7vrOTB0wkKmSXdoilXYsUVJk6XengSWrxmAmTBzetFobOLgRcJ+pc?=
 =?us-ascii?Q?0nFraLZ1XR1xE9h3OleeZpLvzscz9pEgUr7wowWNGCkI4VD9pbAg9DLC8YIt?=
 =?us-ascii?Q?Oa6dbQcnA10tXky9ATNsvHSa52ToYe+YA6uuHhtvVh7FrztbbJGEPnTUVxRj?=
 =?us-ascii?Q?am6QD8iEwEsVvtATwJrIXnW/AR3x/x3hMVVc39Py2PZiYoTePzsiZ1cwvlCb?=
 =?us-ascii?Q?HI/HIfQVXxFcvlSLN70kwDxV9KeHMPrUERIeoFJUQ4jirU5D1VS2czjS5a4p?=
 =?us-ascii?Q?gtV/aJlgf0ZTOdz0FKS7IfteClTcfLEA/gTGXIeXsOXQQCGPy0FrZ1DVlUks?=
 =?us-ascii?Q?bQf7XOt1QWzZUlaqSAC2s7cXPZR8NzYve3E/gkuv9Df1eIoh+miMBh9QI8Es?=
 =?us-ascii?Q?5eNeLq+yfMfZCN1u5d9eJqw9TcUGBOjFAg1vrJyx/1DLmXUhbJaUjKQykjff?=
 =?us-ascii?Q?/WPC/3WBEpUe9sH6NMZt33jjWgk=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f68ea42-e28b-448b-a420-08d9bb16cbe6
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 13:21:23.5789
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /+eyHZ3j43Q0ckLzkLAu2uo2kw40/8pJJpvlvHBzMli/eloMwpdMGFKidASXypt6DO+fTY2MIWgoAFoHt0x6vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4139
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 09.12.21 13:46, Benjamin Berg wrote:
Hi,
> On Thu, 2021-12-09 at 11:06 +0100, Oliver Neukum wrote:
>> As __cancel_work_timer can be called from hci_cmd_sync_cancel() this is
>> just not
>> an approach you can take. It looks like asynchronously canceling the
>> scheduled work
>> would result in a race, so I would for now just revert.
> Right, so this needs to be pushed into a workqueue instead, I suppose.
It looks like overkill, but I have no good alternative to offer either.
>
>> What issue exactly is this trying to fix or improve?
> The problem is aborting long-running synchronous operations. i.e.
> without this patchset, USB enumeration will hang for 10s if a USB
> bluetooth device disappears during firmware loading. This is because
> even though the USB device is gone and all URB submissions fail, the
> operation will only be aborted after the internal timeout happens.
>
I see. Something ought to be done. The issue is in good hands.

=C2=A0=C2=A0=C2=A0 Thanks
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

