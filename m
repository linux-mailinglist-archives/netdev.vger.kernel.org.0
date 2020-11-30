Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3B4A2C918D
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730586AbgK3WvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:51:24 -0500
Received: from mail-eopbgr150107.outbound.protection.outlook.com ([40.107.15.107]:39554
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726614AbgK3WvY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 17:51:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obwD6NVgQ4BeG8dZlKSv3Wai4LpQUjozzgsKYkBSW5co5rM6M+DoAfPa4ICc8s43gaIfk8FLatp4YdCWS4kqZB/kBY31ThNpVnJkHBZIYSg1DBu8kqs96ctdZQmylDSW24aafO7puHqKP161ZpqFpXz3sm5DVPmQOa7JOSltT5HeaMOOnrowQsQe6qREmq+lw8PLNb96XQ63jB+3GBWCkzS0MQ7QuRm9ON9cOkXijRX5mAHUVwhNAa1GRwEbQMfevPA9iJd6qkelszPR9Elg7VOQF1Bz/wjYlmztuE6Ukd0GJKMR9RbWmED31uXmRmggPKkYsXlFNWGy5tiBGCKT4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0w9Aohh7lG3rV5e7MfTrRDKzc5tH547u8ip0KS0Gwls=;
 b=JoIgmIrndudlLOgLMN539+3/EhK+PrZZsN06M9QZ9bNCwju7fEjiH3i+HSEXZzgNI46r+YE4sQsndF/fMfGDrmx0gb44yh6P1DdMkLFHRUUfSzDpHtoiWrRgkvk7euI4ZZpzYFs6haI3xvC3oZA7jy7oAQuFC2BolTN972UREZsdbI0fXDpZ9pNCSIyuaf3EecUqmey0cpgDhFjB/FIaeT+bn7Gj01GGp4isk4/7EBJmglU/f8qdCzl2OppjAVnsEf6eAjtBlFLhR1ELeU+PXLZmgD9VuI9sm1hB0YvvvCgp1Gqr8wggskI5tLZW+5p/efsquHnSeU0YkKwQfAyICg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0w9Aohh7lG3rV5e7MfTrRDKzc5tH547u8ip0KS0Gwls=;
 b=W1tPB+oUuZsyT3952H8uF87h4s83zQqBV29Js/zT7s0TUcCv+JMPRpkcr6FVm3afp9Y29f6ywCRa3y68UHvABZbVXCJp3ROCb0JPaU00gZKTghSPhKuqnTr/kvDV+6fkMBtRxut4YNN261Biv2oT1Lpg9qwjOlN2fUdSAUPeMOE=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2356.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:e4::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.24; Mon, 30 Nov
 2020 22:50:35 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 22:50:35 +0000
Subject: Re: warnings from MTU setting on switch ports
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
 <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
 <20201130223507.rav22imba73dtfxb@skbuf>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <2d4024ef-f80a-475f-a247-e02971b55152@prevas.dk>
Date:   Mon, 30 Nov 2020 23:50:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201130223507.rav22imba73dtfxb@skbuf>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6PR10CA0046.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:80::23) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM6PR10CA0046.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:80::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.22 via Frontend Transport; Mon, 30 Nov 2020 22:50:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2badab8c-b253-4d76-ff9f-08d8958259a7
X-MS-TrafficTypeDiagnostic: AM0PR10MB2356:
X-Microsoft-Antispam-PRVS: <AM0PR10MB2356DE0F802AC3597722351393F50@AM0PR10MB2356.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gJRzuxQUiY7aJgCY8RL4qzycidWpzM0LfWKN/2woahHSCK5Y7g/pVdg50WwaUN++XqRElnevx3iu9QvPInHQi2wHwXbbQQPsxeBRkPLcgnjcNd+EDlEhw8HQ13CO4pT/FyfDRCGzqWqDeAVGRHezPxsmKKJpq88Odm35mj1X96wulZ+Z1R1kAvA6zLfh7JuArh270LfzSkcmNx+DeEQj+IDSlf3E0kxGIf3HojOc/nXqcu/GJxUG/6XFY/Baws9Q9coK/2ua0Wj3gC+XGxLW0cbS+i4usTNumzxHEYhKw72jI7xcl5d20FCAxg0GRXrPZoAeoVBZDl0fvDvCHbIDv0J7BrBuDxEunqgO7XfZ3tzmcZtD+INxFYaOL2SRCbBj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(39850400004)(366004)(396003)(136003)(376002)(8676002)(956004)(86362001)(36756003)(31696002)(186003)(2616005)(54906003)(478600001)(16526019)(4326008)(16576012)(52116002)(316002)(8976002)(6486002)(44832011)(26005)(31686004)(8936002)(66946007)(66556008)(66476007)(83380400001)(4744005)(5660300002)(6916009)(2906002)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?iVDdwkydrIgih4xQN5bMD3SJSSEpia/SBgp2JbRjcKJ6wRGqOy5K0Z4K?=
 =?Windows-1252?Q?WqOZXK1r3R5NTueDzCdb/GI0H0sqdW7CgUYZD2Cd4ViGuECV+gUcLgd1?=
 =?Windows-1252?Q?1/OPb9fk8ALWJDmEkFWhMP4oItk7cYGw91rIw42hu6tVRXeczNsbmkkD?=
 =?Windows-1252?Q?QNQpFzK3fsv4TsgTM5uTWap+RmF0faGCxN5dyKjzVCoaCode5gTAVkQw?=
 =?Windows-1252?Q?DW/XkAtulh6j2CmIfo1tPCLNp4AYhwXH/TkquvhRvxuThyOT1dA5WX3e?=
 =?Windows-1252?Q?YPQY15nrKo4bRuNEIIl67SLOvaitDqhnDAACshLwOaf8fj2b5U5ZypBn?=
 =?Windows-1252?Q?3ZllnR7KQy+oZXQ5diI/OvfCoLZ6JMY5WrvpGCRn5pmrK5EmS6OmRbRg?=
 =?Windows-1252?Q?7i56Zx4lotE0AOPMx+ZNO6Yo7DBOloDgSai6Dj7JYbAR74agIdAIUL6Y?=
 =?Windows-1252?Q?37TJBpPBV+JfJXoYgQ0rlBN5Bkl/MARebwZkZg4N6ObGX1Y0DidhIe0E?=
 =?Windows-1252?Q?8vn/imCGA2/p2A5uDY4syNfM33C8V6N1qtvLuKo8xbf6mjBUl4U8NfsZ?=
 =?Windows-1252?Q?rlAzC636i0UVfTE0PoH0fc/LeLVvl5zTRh57PrD6FrLbIZ24ssUrFjo8?=
 =?Windows-1252?Q?g8+pAILqZ8rzFrTmv0N7tPDJo/g5QjEtim1zZo7U5N3xzFdKq3BJkA16?=
 =?Windows-1252?Q?edsWD+M+spEeegYOoblK0n2nnLJKkurRC4kSXFGqn4n9oZ+t7qbpZzcz?=
 =?Windows-1252?Q?WoZ/XS7ChU3kFjz0tUD3eIXHEKFQ3KloVaWs2vENpnnKArlLFcLGLAzp?=
 =?Windows-1252?Q?GQwi0v7B5+4ZJGa6j4V27uZ4rD4Y/AmLnmsOuLAuh6HRCmOlKDbqayvT?=
 =?Windows-1252?Q?JmofGwylirfRSkUcgUz9SNoSJ4StTYof9DSIrOj2OnFUZw44sAq8KQRp?=
 =?Windows-1252?Q?OexGG3h/g2Vm5FAP2fBGdX7msyIrRRInUbyEUvB61sDIGDVca7WU8KSk?=
 =?Windows-1252?Q?c0iRMiyNU/0qiq6KUdpcjwYfgZuLlc5WG7bMgrqtiah4hJrHMZniGioB?=
 =?Windows-1252?Q?CeCx1vYTeeNpekeu?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 2badab8c-b253-4d76-ff9f-08d8958259a7
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 22:50:35.6333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tUOSQX/3PZkVUsAUYTM+qtsJ0ojZLCU9XQB+KlVoIZWQIiG4h6+y6GFA4WMBfIkhSmFW9S9pYP8i/Nc8dXnIGPUXbDcSYSwrDchF87qqAw4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2356
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/2020 23.35, Vladimir Oltean wrote:
> On Mon, Nov 30, 2020 at 11:13:39PM +0100, Rasmus Villemoes wrote:

>> FWIW, on a 4.19 kernel, I can do 'ping -s X -M do' for X up to 1472
>> for IPv4 and 1452 for IPv6, but I don't think that tells me much about
>> what the hardware could do.
> 
> IP will get fragmented by the stack to the interface's MTU.

Nope, that's what the '-M do' is for:

# ping -M do -s 1880 169.254.246.13
PING 169.254.246.13 (169.254.246.13) 1880(1908) bytes of data.
ping: local error: message too long, mtu=1500

Rasmus
