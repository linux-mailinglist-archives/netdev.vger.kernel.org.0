Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE2625432B
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 12:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727902AbgH0KIh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 06:08:37 -0400
Received: from mail-eopbgr30103.outbound.protection.outlook.com ([40.107.3.103]:47254
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726093AbgH0KIg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 06:08:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R+6ZeIsmwTqWT23sH7T32GyXPcyrIQAoFNW8WF0UdvoHorZpAmaBlLCvEJuS1i1uQmMY0UCnkm9PK6uV6fR49rGpZVy3hrqBUXV98eERn5VDvAhA2UsNxqKQsAZGXRAbvzqzi2cMqC4K8Id0CQzc90SOvlFiolCOrJUA1yY7ui7pjRHI1P0SXpJjUD4KXxMEljHiqpobAmlMD67UxOyBSGA2GUHCzGKxb2ThHopHXa6Udf8TEo9uHD1Qbo9hgnYFhlt7C90QymmBBlaZAoMGFAsIaVhvUWCl86o0QPLyfNoLi+QGBvpk4L4bFgFZp67fJ3GEKd//LsRF6YxbBDOj0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZcP9hDmPSDD3HCxoQgan2B8xhEBYnZ5BAs1S6XIgYE=;
 b=JwI59ByH44P+qgDq0ZTqaIg6yXZG7UcGtAwDkod8Mv84z1maPzxHWow8HhqhWE2CrU89T94s24M9HU4+tw36R1JRMzDMZYRoQntLpDcKG4kXn0FOKvYhNyTj4z/i9L9k/i1cWiVA9Jisq4K5Lbl/1JqQaiPcpHJIe2f/wYH4Zlfq26bH+pItfzTrOjKIL7WqiNlo68PBRDCrwuaJneeRTpRLtPfQ1QzkJX3WMTfZypMzhFcZLkjTf+BPh1xvrkEHhzodOM9KLNkPY//OpbYpaFnAS6ScbXmjj1pwTEx4/zjQkkgLc0D+5js5L2pZXFtsNF4qjs3yiVvwCAym/J9jCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oZcP9hDmPSDD3HCxoQgan2B8xhEBYnZ5BAs1S6XIgYE=;
 b=L7My7l9bXedHgS8wsAovkQGduhiSJmAWpkRGI19QoqFJHBujV85a/ei0W7gWzhovKOmBlvBCwZm3vFD1JbjhH0cz27ddO103KENYa19vxNwnEBDPW8mumOKR7UPSX0k7xW16Ns6wR4OknzSRzuZC+miWn/MWJK3EahAnN90FRVM=
Authentication-Results: prevas.se; dkim=none (message not signed)
 header.d=none;prevas.se; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB2161.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:d9::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Thu, 27 Aug
 2020 10:08:33 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::3cfb:a3e6:dfc0:37ec%3]) with mapi id 15.20.3305.032; Thu, 27 Aug 2020
 10:08:32 +0000
To:     Network Development <netdev@vger.kernel.org>
Cc:     Lasse Klok Mikkelsen <Lasse.Klok@prevas.se>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: powering off phys on 'ip link set down'
Message-ID: <9e3c2b6e-b1f8-7e43-2561-30aa84d356c7@prevas.dk>
Date:   Thu, 27 Aug 2020 12:08:31 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR04CA0099.eurprd04.prod.outlook.com
 (2603:10a6:208:be::40) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.11.132] (81.216.59.226) by AM0PR04CA0099.eurprd04.prod.outlook.com (2603:10a6:208:be::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Thu, 27 Aug 2020 10:08:32 +0000
X-Originating-IP: [81.216.59.226]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 909f6d5f-a561-4701-e3a1-08d84a712780
X-MS-TrafficTypeDiagnostic: AM0PR10MB2161:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB21618CA2E6AAC8FD09EB1E0993550@AM0PR10MB2161.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: E+HB0BTAPCzk9H2CsgKy/uLQ/vJEY2IVKln+x946IuBliTMrPemcArhmoWpCx0Jpsk2I1LZTClYpr8EpweJPRGD0pnBmOOkPAbivHnkrkxZHmwURK0CotouQS4aH0+NcHTpmJl6bd9xhZ/Tzn9sYOVFQSEFHfmbudiLcKKPWTS1GKaODuFGxqwnQHy49vqtVllD8G3Kdq5SAirFXIwVDA23nUI1mLNJnkaUwEaRYM/Q7HwQbw+iPvsReSHKkCnO3/QkLUR3N7qJ/M//V7DM0hyRi/9vjmmgu2N42axulsi/I/Z3akEitSqnX0di1GssdHUSryoC8y86/X5bg2sCwA8kkTXZtDUDVduQyRagsNpiL2pkbj/CHDNsG0oRrwctD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(39840400004)(376002)(346002)(366004)(83380400001)(186003)(31696002)(26005)(6486002)(2616005)(5660300002)(44832011)(956004)(6916009)(16526019)(52116002)(4744005)(4326008)(478600001)(107886003)(66946007)(8936002)(316002)(86362001)(36756003)(31686004)(8676002)(66476007)(2906002)(16576012)(8976002)(66556008)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: O3Xgvzy2MfnJyJHi3+x2egm3MMEpobOEHKRmhPelrqx1x9JJpOd/RCcZwRaojL2I2Dj/3o/ILqJuD1S2K1z4m7/37AOWcepeWU5GAQEUXpoTtuHR0WIlqBQGW+uMqO6su4Fwa05DCk73HI6vl1CNRhBr/Y63r9JEVKkzj7M5oQwW8j6HxDTs9sVObOmAad5PWqACod3yqJJ3l+HnvDNxwraT+1vcvNEaVezyr7P17TJ5GMs+A5BfzsEDEGFh0vajoVXat8X039Dil+9txcGfsq5zg44EMT9huM3cOFYwCx2Cw0OhQWkJ+n4iP2Ztbb2MNy95DVN/51MhvRuxyi+ZlEcvk+rn10eNk8lYtPGp0hSFdd8OtVZkjVLjbLgQIxngEZQx9bvyyit+0sid5auDK5czW+/ZpMneBgfNbX18MaBI8CTm0Ry9fyzXWLPTJOIs1gxWwSSMWOkcDqiXegEq64m39npK2tnieUT6yrFVVCsTOOYXC7FgE97+aKgZBPQG9Fk2O/6PuN/zQRusFpKpH1ONI+yx32tEOa7Oq4BM9WyktizsXBNI3tECl+fMkcjU2XKYwlhUl34gw7LC2UUSbfnO2JHfFvKSRr3IalUahlh80nfrMKFV0sqE3Vsq3m27CsWLbvOtTQyjfGM7jIT04g==
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 909f6d5f-a561-4701-e3a1-08d84a712780
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2020 10:08:32.9622
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MZd+kO/qiQz6QDEAYDx+BX9yofwqI3uyuANTV08vCyLNJb/2W42Ii/2Y1sXaWINulbP5QIbqmSjX1CiMYKtjstp8iG8zYFUeWKfYoNarPmk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB2161
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

We have a requirement that when an interface is taken down
administratively, the phy should be powered off. That also works when
the interface has link when the 'ip link set down ...' is run. But if
there's no cable plugged in, the phy stays powered on (as can be seen
both using phytool, and from the fact that a peer gets carrier once a
cable is later plugged in).

Is this expected behaviour? Driver/device dependent? Can we do anything
to force the phy off?

Thanks,
Rasmus
