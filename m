Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD94420A4F
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 13:45:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232995AbhJDLqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 07:46:51 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:57066 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232978AbhJDLqu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 07:46:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1633347900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6HJhGDSq7Qq3ZxqHEhSaEcPK3AccoB8ZDZ90soSKsV8=;
        b=M5nmCD5/TomJ+YPH2fNwjgKeiLJzVvHMdqOG9mgF1ogT4r6Yy57XHmenHeRYffbmBFq1JM
        156CMw4HX9Z4OlKfDzSqdZ0kEdwic+nn9nm2+OpQBED3/J4Sa7RA0Hk2fdYYe1rOtQzSZx
        2Qd2pRsl6NJhL/FbEfSxnxYZwCbviIU=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2051.outbound.protection.outlook.com [104.47.5.51]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-11-DfE0Ghs0NJueObAAdyYh5Q-2; Mon, 04 Oct 2021 13:44:59 +0200
X-MC-Unique: DfE0Ghs0NJueObAAdyYh5Q-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EwvqVFxfyvUzvQc5We9xY1eYLkOVYetZJxLtE6hDkQp8EXzPBFli4/+h8YdC07wU4RLYHMCgxJMF/clFUs5RNGxClbtEOe3U9Kz+FSktQbgtBU3nmHBxwix2lRFCJOh88qZXQYHaij3tVinKSWwhpCyY9j8xHLUPSnhtmXcuF2bPYNR4pntKQnzLHcrJfCXssHh2T68uF627rDaykJsOZo8oKf0VG2lt4BU1iKHzbJShQe7LArcF2u/SNu+7Exf8dQxq4kOLYpMg3508L9WpZX/orG1biUM9izf1Fk58OoBxFIcg1MBnKntD1ohwkUqKcrEc/16AK78LjGzDhxcFOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P5yWjQdy0GDPdICeCJdHGvyoKANhQNDpuJwXdpryihs=;
 b=ngPwPJcH1NoUKq2E/CtUB+LBeBc6AI8W3dJI5xdr/5nRx8SW9s/oZ67/Jr0ea7RQmftxd53Kr6Kq1AQGFkXIb49VAqFUqeW6XXEIdVMsSATl59voxtUUv7eqYHq6qppS50DG6lIcGGgi/DX6lI6GjKoBQ6CjKsBdXVV63VhOVSiKbwPSZ9IpF7C4xUj6mGbPwNa4vZiha7EANLn4Ls3PeYylD/ZX+FgtcjYoNIBm4PcqycYJlSjDmhbOQpFU5l2On0PUIFcMgVMcD79zpQLab4FhQrvITJTPTOBY/JgHkPIyLEGGGro8ZH3nhAtwmVFtQjrP04GH2YdQGto9zvNgVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: realtek.com; dkim=none (message not signed)
 header.d=none;realtek.com; dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by DB7PR04MB4537.eurprd04.prod.outlook.com (2603:10a6:5:35::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.15; Mon, 4 Oct
 2021 11:44:56 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::61c5:2592:9e7f:a390%5]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 11:44:56 +0000
Subject: Re: [PATCH] r8152: stop submitting rx for -EPROTO
To:     Alan Stern <stern@rowland.harvard.edu>,
        Hayes Wang <hayeswang@realtek.com>
CC:     Oliver Neukum <oneukum@suse.com>,
        Jason-ch Chen <jason-ch.chen@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "Project_Global_Chrome_Upstream_Group@mediatek.com" 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "hsinyi@google.com" <hsinyi@google.com>,
        nic_swsd <nic_swsd@realtek.com>
References: <20210929051812.3107-1-jason-ch.chen@mediatek.com>
 <cbd1591fc03f480c9f08cc55585e2e35@realtek.com>
 <4c2ad5e4a9747c59a55d92a8fa0c95df5821188f.camel@mediatek.com>
 <274ec862-86cf-9d83-7ea7-5786e30ca4a7@suse.com>
 <20210930151819.GC464826@rowland.harvard.edu>
 <3694347f29ed431e9f8f2c065b8df0a7@realtek.com>
 <5f56b21575dd4f64a3b46aac21151667@realtek.com>
 <20211001152226.GA505557@rowland.harvard.edu>
From:   Oliver Neukum <oneukum@suse.com>
Message-ID: <72573b91-11d7-55a0-0cd8-5afbc289b38c@suse.com>
Date:   Mon, 4 Oct 2021 13:44:54 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <20211001152226.GA505557@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
X-ClientProxiedBy: AM6PR01CA0064.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:e0::41) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
Received: from localhost.localdomain (2001:a61:3b0d:4601:21ab:d1da:15e9:ca07) by AM6PR01CA0064.eurprd01.prod.exchangelabs.com (2603:10a6:20b:e0::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Mon, 4 Oct 2021 11:44:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03850ac4-310b-413d-2cdb-08d9872c6351
X-MS-TrafficTypeDiagnostic: DB7PR04MB4537:
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB4537543E6789CE0D57790F3DC7AE9@DB7PR04MB4537.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SeYP5kUtIEwfTbgaf5+MheY8ud7LZaw01r79BTIj9jjK4hrsnA+R/A+xlPP0n6hFEGj0QfNp/9IPgDNpU9w0jGxUOqaO10FHJ5BIvMGct9f5oSfPSeYmVge/8ASjeKbYhfpGZu8+tOHlCFfeOPbUcPr0Y8G1hPB4vQN40RW2BnE/aft+VNeuWLrmOtwQkb+rymJ73ZqzKr+YkIH32DSSO0QRCAyzZS5mFQI/Db/9JC4C3YtjLt6t8w5h0+HLvz9xQWq1ycHc/KMjW/qj5nqLH/QaPbO1GUA3CsWoWjwv+7qeBwfPKqbu12Cox+wKnE6t84kmcQNum3L6vkPIqSUgOnBsptT1K2gw7mp1c4q2Qo+a5pqFTnj8qDnz16amL9e79Y4I1EzLHnGgrdiYKiqjpj5k0DWYbBwgBas0QC60fjewGZsHLK17N5ZKo0SN669xkftAirg/uAhYaG/68ZImKo/r1bV1dBxUG4LDqRrzMJNu2HmSst1YXFu0qufbxwGY0cEYttOLXkT66cRTOliUsT9zAofo6YboNfrnqXphnpQZSfozCUP71ZlvwOYf7n+DG1fsp/WX8UUCMW5F0ZdZG5RJJ3h6ljz7Dn97Qq9woEGk0GDEhglfFCxi/OiKdQSRuon4OtpGfNNz4S6irYWOnojxOKX2PdLcT+zvyG3RJVyZtCOtcxDHvD83Ww5QpfUqJcmisCSxzQRTMtIJ6peE8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(53546011)(6512007)(2906002)(316002)(110136005)(54906003)(6506007)(38100700002)(31686004)(36756003)(186003)(8676002)(83380400001)(6486002)(508600001)(66476007)(31696002)(66556008)(2616005)(7416002)(8936002)(86362001)(4326008)(66946007)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uKPzfWzrP0Vnduti6RA2fdraCTibW4wCH9MnwaoZTGuyksHIZ/lIRrEcEfhq?=
 =?us-ascii?Q?WxLHmAhY7thAlI1qHfLFD764CkdTS2swJHBbOBnXjCpHMm3uKBXwu2cCpNgI?=
 =?us-ascii?Q?kgdYmBotWghCmxvMUfFjSjOu1+F80k4q+qDx3IPDsMAWMwN3UEH+BZVq/R8s?=
 =?us-ascii?Q?XXrHWw9zsAkKDJFp4uJJS2SqkFKWOXVan9Zr0GmvM1+UpSLW1NSXrJe3sFEj?=
 =?us-ascii?Q?s7I5+kVJoDfsEIX7UBbF98EQfh3K05eaJ5LeSMKkA+zsIC9IFIFCayEqQMqQ?=
 =?us-ascii?Q?dTOhM65D+YRsKi7WQKnBKxAjLFPII6AB7tq/Egv0bUPfvYpDi+Rdbh+1PZ1R?=
 =?us-ascii?Q?dGLGIPl29aX+mJ9WY9fodlxhnJcmvmRue71PDDzVMVbAXh8L7QqS3PotQC1L?=
 =?us-ascii?Q?gVt+Ahl/bWLm6NVr4H4NlGQbr9IDhbZw82dwdKzw1XVQPIIPh4v5QsB9OjTt?=
 =?us-ascii?Q?CorkvM01LlVuZCKM9Z9ytjTeIU22iojBzhX3Cvt6M8b1a/e6DCWXKq42q2qS?=
 =?us-ascii?Q?+sURLxXSByi0EUhjspiSvo1LXMp2dyEgaMUJTFaUxaMajsWn57KvNUNggJNf?=
 =?us-ascii?Q?66bKPA6DInDZpq9ZqXGLiaY/zzQOSYWJi+K9F+fH6AsAdAYAI1dblW+AK3Xz?=
 =?us-ascii?Q?rXfYqRboQURdByj75vSesytGS78glVm/f+Vbvrm+dlPN9iyD7nVDuDzNFY5C?=
 =?us-ascii?Q?roVYwS39A4kB2K0q8R28f/fW8hvGE6DnkOKvIY1S8dqpY/jKAfxJkAEpQg0U?=
 =?us-ascii?Q?kSIE0ZHCiTqsSqWvY6Q6opUCkZItps3LnRvZVvUrLXof0tXVotrR0NpeAxMF?=
 =?us-ascii?Q?+52HZGg9V6vY4/U+PD5D0NyznKsgbJpulO4wYrAVGP6WV6QxcUZo0TRVXkQq?=
 =?us-ascii?Q?lR4t8L5ANTAqXtHxrI45ntL0a7VVy7Hhk+11VUufTGWHAbs5wPp8fJ92svxQ?=
 =?us-ascii?Q?1xVl9An0RypUzehunBuTflAhY/rKn/wuKD1IJbiB2Mw7gD+9tVRsyNLXbsH2?=
 =?us-ascii?Q?TM01ivee4axvy/2TirdyJXMHd1+IRhjyhMiogT7nl3ild4Y5fvx9B/Rm7kjr?=
 =?us-ascii?Q?L7+RdhCe5AyWGagPGoVNIPTGO2P3t+YQDhXqhIwIHFqlU8iGkqf7ZyS9PVsP?=
 =?us-ascii?Q?c09rxxN6BMywt1an/GzTX1trZZB2CtbFhV8Myg5vDbh6eZU7y3Q//b12JARW?=
 =?us-ascii?Q?WaeO3XMeIjZ4b1hmJwXNh2G5fFNwXimj8BU/jRUjB/qwdm6ulhFGdoF6QF70?=
 =?us-ascii?Q?0kho9fI5mXEujTTGPF3F17MYfMUUSQB2QVyllUtmr6dAGFHJJSyGyq/fO6Fe?=
 =?us-ascii?Q?EPR6QeyD4DkDk3LLLkHgl5Fyt3Avu6j1xynvMRvFKGOy68FehCGog6RgMs35?=
 =?us-ascii?Q?Rw4CZCnnWh9d2ufdMyHqdmrDg4WD?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03850ac4-310b-413d-2cdb-08d9872c6351
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 11:44:56.5919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ogf5DAn4WV6+hRBj3A0WBBPCdi7PAtNaFAO9bDltvYnhpVfop20cyHroNluiwqNpLtCq/UpCjMYNM3VEby5Q9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4537
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 01.10.21 17:22, Alan Stern wrote:
> On Fri, Oct 01, 2021 at 03:26:48AM +0000, Hayes Wang wrote:
>>> Alan Stern <stern@rowland.harvard.edu>
>>> [...]
>>>> There has been some discussion about this in the past.
>>>>
>>>> In general, -EPROTO is almost always a non-recoverable error.
>>> Excuse me. I am confused about the above description.
>>> I got -EPROTO before, when I debugged another issue.
>>> However, the bulk transfer still worked after I resubmitted
>>> the transfer. I didn't do anything to recover it. That is why
>>> I do resubmission for -EPROTO.
>> I check the Linux driver and the xHCI spec.
>> The driver gets -EPROTO for bulk transfer, when the host
>> returns COMP_USB_TRANSACTION_ERROR.
>> According to the spec of xHCI, USB TRANSACTION ERROR
>> means the host did not receive a valid response from the
>> device (Timeout, CRC, Bad PID, unexpected NYET, etc.).
> That's right.  If the device and cable are working properly, this=20
> should never happen.  Or only extremely rarely (for example, caused=20
> by external electromagnetic interference).
And the device. I am afraid the condition in your conditional statement
is not as likely to be true as would be desirable for quite a lot setups.
>
>> It seems to be reasonable why resubmission sometimes works.
> Did you ever track down the reason why you got the -EPROTO error=20
> while debugging that other issue?  Can you reproduce it?

Is that really the issue though? We are seeing this issue with EPROTO.
But wouldn't we see it with any recoverable error?

AFAICT we are running into a situation without progress because drivers
retry

* forever
* immediately

If we broke any of these conditions the system would proceed and the
hotplug event be eventually be processed. We may ask whether drivers should
retry forever, but I don't see that you can blame it on error codes.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

