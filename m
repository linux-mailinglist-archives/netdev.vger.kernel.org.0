Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EE1A2F069F
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 12:30:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726341AbhAJLaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 06:30:05 -0500
Received: from mail-eopbgr80093.outbound.protection.outlook.com ([40.107.8.93]:31607
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726069AbhAJLaE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 06:30:04 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=izn7KQx2hDETA4BCkgEZTtHYP2Sb0KC/cXZuUgi8uVR4rK2Nqxfcc+wPDDU3IIW0XjBrRYgva/1hpEzNGq/JZMZS3wUO5uw6E+NQkD0R+qC+hJEQ9sUYlc4vMNp44hYfQCrdEJta9vBxGk6YXTjWMaP3zU1/npmW+I3hQK+gvS5GA16JnRKHyizZyDtbRipDKc+90LfQclXJ+7MTUNA0F+C3gpBS5+qnvoODoVv8RnBYh1TGhfPXPX7FJ/XOOcZm6rRWQYjJDd2pPwLyISAoYNneFw8rM7Yo1DS1YjKcoEEzGjbOmRgZm9GNgI0oRpTljbflRklGbwEu2TsgYNh4uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXKRLENuv7Fhhch/HvDmrgK8wk0vHA4bfqYsHDzEyWU=;
 b=UntUe/vY6fBmd+1k5QPTcqgbBbVELN4WQbvmNuL/5lBaKNowqvoP76ckOjqVQktG2EQ5LwU6jHkzZlZK7SrZGEOD2x481F48SP0tq3Bs9aHWqyrsEfrCGU1yk44tAbOezavlR9Ibxm0xAbfvgKe2dsAjlpg3tWKRs2nJADd8tqQEh9YfrJvAObJkLxSyv/HVcgvZZewQZcVYFGeyo09AlIm+QgutukZIidOyYsnIhQQFLdxitCYEI1DXV54FT4U0YWmVMJJngxOUrRYsXlRKmQOiiDMHt6xrNsIp7MoqKZiuAiKCNYAf0nogpNJaNcvv8GH6a1TiRFqbF1vzsCJvnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NXKRLENuv7Fhhch/HvDmrgK8wk0vHA4bfqYsHDzEyWU=;
 b=fFR5tJygcwA853SaABNTL3DdjzTfOQD8lfnQRadxiJ2IhFjA9OlcFmcGL34ZQl+In2KllksOPUKcF+xJNK4SgoSewFLLWNzpXXKaio3wdiD80AC8l+RY4dFfBb2HPN15nIJ5PYqM0ooIyuiOkDRYyNd7bjJ5XYRDq+PRLgXVmgg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=victronenergy.com;
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com (2603:10a6:10:192::11)
 by DB7PR07MB4476.eurprd07.prod.outlook.com (2603:10a6:5:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.2; Sun, 10 Jan
 2021 11:29:15 +0000
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::2968:8c66:182f:8211]) by DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::2968:8c66:182f:8211%7]) with mapi id 15.20.3763.008; Sun, 10 Jan 2021
 11:29:15 +0000
Subject: Re: [PATCH 1/1] can: dev: add software tx timestamps
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20210110103526.61047-1-mailhol.vincent@wanadoo.fr>
 <20210110103526.61047-2-mailhol.vincent@wanadoo.fr>
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
Message-ID: <043c3ea1-6bdd-59c0-0269-27b2b5b36cec@victronenergy.com>
Date:   Sun, 10 Jan 2021 12:29:13 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210110103526.61047-2-mailhol.vincent@wanadoo.fr>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2001:1c01:3bc5:4e00:e791:efe6:bf00:7133]
X-ClientProxiedBy: AM4PR0101CA0051.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::19) To DBAPR07MB6967.eurprd07.prod.outlook.com
 (2603:10a6:10:192::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2001:1c01:3bc5:4e00:e791:efe6:bf00:7133] (2001:1c01:3bc5:4e00:e791:efe6:bf00:7133) by AM4PR0101CA0051.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Sun, 10 Jan 2021 11:29:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88be9081-09c9-4bf4-616e-08d8b55af61a
X-MS-TrafficTypeDiagnostic: DB7PR07MB4476:
X-Microsoft-Antispam-PRVS: <DB7PR07MB447667FEAEF11E61B1296A97C0AC0@DB7PR07MB4476.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: If91ZXc938H648Z6kWdSG4QutIzCMyafEpAWeO9Ui6d11bA0wD1VpQq1XkFmxwBx/R9yaCwiuDaNpLAE3z0GiPtZRUQ/EeW7c+JRK9uA5phYt2DSTYmNoDpLXuiwW53sw8fl3oZL6EjMkT4GZXbGv4QnLgECjmBdq3zP5TrXHism9tEpdIprmhduyVXbbMHonxOcwp3mT7Eij2Br4CIJhpc/LPmCNgY4AUaTa3J9i73tBMhdfrDQPjCY7UqF4I6tFOB7czPnRtJxlKCPC+DXDC6ToYFGrMTtdkPkX957IXK81o9YNPWtVKxy3VBzQS/SLK9AJtMzTIxO10IbddAhRDydXlCORyHbpQlMU0XSxHrw8LXcDPKHVWLiZEH7jej+A4S8AEcPR18cnb4Yo03TrTQ0rpWbVdEf+Pq+H9utcx8gtCsaB+ckD/HY3wKK5KWn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR07MB6967.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(366004)(396003)(376002)(346002)(136003)(83380400001)(2906002)(86362001)(31696002)(52116002)(16526019)(186003)(6486002)(5660300002)(478600001)(8936002)(36756003)(66946007)(8676002)(2616005)(31686004)(4326008)(54906003)(110136005)(316002)(66476007)(53546011)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Nm5kTU9IeE5UekRKMW0zY3JhQlRRcFVrMlhpS2ZUTFM0SjZ5d0pXMlg3KzlO?=
 =?utf-8?B?T0RseG9xVWVMczd5WWN1a1VFSDJ2ZzdERnRUekdQQndjU1ZQSzYzOWpTSFFO?=
 =?utf-8?B?TVZwTitIdFRXS212WFdoMGlSVVRhTGh2b2YwekwrNGxYbWc0SDNiUzhyVXVR?=
 =?utf-8?B?RGJCSVN0S2VsbGRRRElwMnNHblJLR1VwTjlRME5Ray8wQmhzS1JRYU1xM2li?=
 =?utf-8?B?ZTk1anFGdmIveFFKa2liRGgxT0U5aG9TaHBzUGpwUVNvZ3hZVTU1ZlJ4cnFh?=
 =?utf-8?B?R25VbXFLbHN5bVBabFNZZ2IwL3dqNXJnZkFGTG82ZXZvSnFtUU5zT1p4ZmxO?=
 =?utf-8?B?Zk1KK09ZbzhqSTgrWEsrbEdYaVlwRlVKM2l3eU5OcXFIeW15U0dKQUpkQjZX?=
 =?utf-8?B?OTgrcWFFZFdkWk5tdDBRa2NHSEFVbEN5YWVFaldtZjdmMGdyNEdkZnpLYjZ2?=
 =?utf-8?B?aTN3SWxaN0pORC9CRWVPZmhQT3dHSGlKQnpiTVpXOUNncTV0Mk5ZbGhRTnZj?=
 =?utf-8?B?MU56VGlTczdydzVmOE9NYUxPRjlKZ3Nib2dxZlRYZFpTODVwOFpUZDc0dzhN?=
 =?utf-8?B?dXhxSG9wb1U4cTROZmJtKzlFaVRid3lkSXlFTGNoNWgvQlA2dGQrQWdLQ1Vr?=
 =?utf-8?B?WmZOR09mZU9ucUhUZ0VJZlBzRzdrMXBBZEpIMDBWZTZXaUxrQkNtNGFNQit2?=
 =?utf-8?B?dGNlNHNoQ3MzaHRXY1VYRE1CNVZoemFCb1liUzU1d1F5dkdWRnR0QUtxMDEz?=
 =?utf-8?B?cHJ5RTM3ZnppOU1jaGE5aGl3OFNWbm1LcVVYR0RoVHZ1WTBIRFBOUU5LbEwx?=
 =?utf-8?B?NTJvaWFDVUJoNm4rd3ZScnZITEtFZjNNcGdQblNyaEpDbDEvd0NVMU9taWlk?=
 =?utf-8?B?dmFYSlFvaG5mN3BhMkU2LzBmSzQwUk4yMzR4eVl4SHNHd2wwUWRuMldxK3Iz?=
 =?utf-8?B?K0RRbk0vQk5qRGMrZytoMUN4eFBrK3JNMmhsd3dZOC90SENQMnZvSnZZUzJH?=
 =?utf-8?B?UVRXTW0rb3VqLy9ZdnJGd2JGZXh2enN4d1Z5R3hJUmFHOUVZbm9ycEN4eW9q?=
 =?utf-8?B?WFl4a1lIM3JuMzB1WkozOFh3b29WdUNYQ2xmOWdzU3ZQUUZiWUgza3V6NE9Z?=
 =?utf-8?B?SWNSWjh5MXhYOVdBdEVDVEU2eG4rZDBNS3BTSm9iTFpWcUxla2QyS2lBTFEy?=
 =?utf-8?B?cmdlaDlZSVRJMlZHTVFkYkFSY09jWGQwSFc1alJVdGZlSDZ3Q0tWdFpNd1VR?=
 =?utf-8?B?Q0l1RVdYOTZjaDFRczFrVnU0Y0plSmsxVTNKS1FMcENGV2p6ZE5vVHFEMDNV?=
 =?utf-8?B?M1Z3OXVTTmZEdWx1RnB2NjNPWDhaSWZtbDhOTEVOTUFkWVNRYy9GNEJLa1BQ?=
 =?utf-8?B?blo3UXBxeFQ3KzVsbmo5SmZzci95NjVlVE41QmxxbkRyTnlheTV0NU40Rm9h?=
 =?utf-8?Q?YiauX/s2?=
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-AuthSource: DBAPR07MB6967.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2021 11:29:15.1860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-Network-Message-Id: 88be9081-09c9-4bf4-616e-08d8b55af61a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y2EmXF7t/scen6IXcnZkkSudUldJk/eFwjsNHL2nR0tzEUirZAlMEyUcAgQQWd2lFu2XSOgrKSPzBtbSoLpMSV6WcYBMGdbyWBt8jbzLzh4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR07MB4476
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Vincent,

On 1/10/21 11:35 AM, Vincent Mailhol wrote:
> Call skb_tx_timestamp() within can_put_echo_skb() so that a software
> tx timestamp gets attached on the skb.
>
[..]
>
> diff --git a/drivers/net/can/dev.c b/drivers/net/can/dev.c
> index 3486704c8a95..3904e0874543 100644
> --- a/drivers/net/can/dev.c
> +++ b/drivers/net/can/dev.c
> @@ -484,6 +484,8 @@ int can_put_echo_skb(struct sk_buff *skb, struct net_device *dev,
>   
>   		/* save this skb for tx interrupt echo handling */
>   		priv->echo_skb[idx] = skb;
> +
> +		skb_tx_timestamp(skb);
>   	} else {
>   		/* locking problem with netif_stop_queue() ?? */
>   		netdev_err(dev, "%s: BUG! echo_skb %d is occupied!\n", __func__, idx);

Personally, I would put the skb_tx_timestamp, before adding it to the array:

         /* make settings for echo to reduce code in irq context */
         skb->pkt_type = PACKET_BROADCAST;
         skb->ip_summed = CHECKSUM_UNNECESSARY;
         skb->dev = dev;
+       skb_tx_timestamp(skb);

         /* save this skb for tx interrupt echo handling */
         priv->echo_skb[idx] = skb;


I don't think it actually matters though.

Regards,

Jeroen

