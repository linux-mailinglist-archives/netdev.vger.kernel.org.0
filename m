Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0AEA015B272
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 22:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgBLVGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 16:06:53 -0500
Received: from mail-eopbgr60097.outbound.protection.outlook.com ([40.107.6.97]:14375
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727138AbgBLVGx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 16:06:53 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WZhvG9dxJg0cVoSYBL3hUsZpyQ1iME0U1kN3ID1yMDhf/VmfbDS035baBx6UGYlhJNq2Ta0XgzVd6Oxe/ZYUFTxM0EiWijaqV0rmAD+VbquE6UrMW18v8mX5eYiFipJw7HKyNJzKyAAS5Edw8RCMJrJTZBT5OAla+cQa4brgjGBUwdT2GZZC4OorkOkSlDnzE0LKGpAvca7Yqu0pvKsreva+MPDsgKEyti526pboqZbVK6hZhCXnZo4qY79svU0vfGoRuMEzUHEAkMzQLhgd+SVwLTuWxGy0XGfXIUT/EUhlhLPOVgbj6Hb9B+KvjLVIDK9qTi9uVacs79tZ4wpj+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vErBOtzjglspGzVvAzy37gKNQa3oFldnzJUUPPgC9lE=;
 b=ggQoeh7Bk1ad4N/5BUsBdLADSOSff9E+GYEY0//NfPMXEYODn0CEFanBLtZW2TKri8xOvNmutzTQhInIyyN3lTKlYzWRm32TR0bGzs0sKs3Cu3mFfnY4JjDOg54URSy3qFmeu76ivFFFdGq+4ShZtjecZj8jSS5/tBofgTTqmdDNPSv8Jfix6cr3OyrGHd/1dZuwXxnLIH8lgQzVH97mAk92rVjyw5yljina73v0K6o2w3C6L8Eri7bc7K0ddtN2Z0Nx14tz9b5ztvF8oP6sJyrk4Mt+a+ify8gawAybThAFCctK5mH1Zhow8tOcf8VlPxhRQyTET4DfpcwWsuUlnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=criteo.com; dmarc=pass action=none header.from=criteo.com;
 dkim=pass header.d=criteo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=criteo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vErBOtzjglspGzVvAzy37gKNQa3oFldnzJUUPPgC9lE=;
 b=FPCRAlL16zzKy+iVQbqlRRWleTsz912xh6Ex0cDzzopvM2lGO82x3kHv5u3ZeadxxUmfz/lz52ZDEIy8XIJMcErkHtDiHZmwnXl/0fqK2oe1Z9+hODcNJyJvFZ0xIFIgEpKCt2SF9jS87QyydHdf1JAMERzuSpknaOP1oPT8sRU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=w.dauchy@criteo.com; 
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com (52.134.71.157) by
 DB3PR0402MB3900.eurprd04.prod.outlook.com (52.134.71.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Wed, 12 Feb 2020 21:06:50 +0000
Received: from DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b]) by DB3PR0402MB3914.eurprd04.prod.outlook.com
 ([fe80::917:f0e9:9756:589b%3]) with mapi id 15.20.2729.021; Wed, 12 Feb 2020
 21:06:50 +0000
Date:   Wed, 12 Feb 2020 22:06:47 +0100
From:   William Dauchy <w.dauchy@criteo.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v3 net] net, ip6_tunnel: enhance tunnel locate with link
 check
Message-ID: <20200212210647.GB159357@dontpanic>
References: <b3497834-1ab5-3315-bfbd-ac4f5236eee3@6wind.com>
 <20200212083036.134761-1-w.dauchy@criteo.com>
 <ce1f9fbe-a28a-d5c3-c792-ded028df52e5@6wind.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce1f9fbe-a28a-d5c3-c792-ded028df52e5@6wind.com>
X-ClientProxiedBy: PR2P264CA0007.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::19)
 To DB3PR0402MB3914.eurprd04.prod.outlook.com (2603:10a6:8:f::29)
MIME-Version: 1.0
Received: from dontpanic (91.199.242.231) by PR2P264CA0007.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.22 via Frontend Transport; Wed, 12 Feb 2020 21:06:49 +0000
X-Originating-IP: [91.199.242.231]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb7f57e9-a743-4366-7cc7-08d7afff7a51
X-MS-TrafficTypeDiagnostic: DB3PR0402MB3900:
X-Microsoft-Antispam-PRVS: <DB3PR0402MB3900E0B5043319AEB216E2E2E81B0@DB3PR0402MB3900.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(396003)(39860400002)(346002)(376002)(136003)(189003)(199004)(2906002)(316002)(33656002)(33716001)(956004)(8936002)(6916009)(55016002)(66556008)(5660300002)(81166006)(66946007)(66476007)(6496006)(8676002)(9686003)(52116002)(186003)(1076003)(9576002)(478600001)(4326008)(81156014)(4744005)(16526019)(86362001)(26005);DIR:OUT;SFP:1102;SCL:1;SRVR:DB3PR0402MB3900;H:DB3PR0402MB3914.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: criteo.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X8s4dfXJ3DkEaOoMYus+Ohm90zD0RNrjkrIs1gbYmT7qAktogTElFectJGX/LVMG/0KjjQaRfJrZeL45Pm6HDyXS+C5sed6nVjwzs5RBoLq52XFD8XOCDY1I7RTT7GPcRKSp+T+0fAO/rpixh81s9x6ld4pERnxdbsZ2bTMYzEFT6vaPJbhHsviz+faSPjvxpPv3C+UWeWVGe3mlImeXRY3SmAIe38mt+K7m0qBGx0nJPqi+Xj6iAbxUk7skNOziErdb8vdZ4WSSdZVqgmZFYe2RnsnRXCRje8/R7Uja+E4GQc5KFklV7b6Z4OHIm6E5UWBoZ8T8NzW+0cVB4rEdd0w/Ce+c6ERDbbYea52II8Q0m/txl0PaDg4qTqVPgjU7s8AnksUV4dXJOSqxqju1iqTDW3cwoYwnAUxUGBdXxrHwzyXu58fIuyLFgEvTL2vU
X-MS-Exchange-AntiSpam-MessageData: E1lrKUi1fLkwh10JQlI//FPYkBwQawpiXFaPzE0N/ZuRw2zPg14Zv+aAnn7+eTgNq36BhmO7UY/T10Fg7kF0eGFVMpZSse0JTnhIwrBdXaEuGRSVIn2//Hl7WDuIqxJKjVQm2xLqS4u4BDcZTAhCTg==
X-OriginatorOrg: criteo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb7f57e9-a743-4366-7cc7-08d7afff7a51
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2020 21:06:50.1937
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2a35d8fd-574d-48e3-927c-8c398e225a01
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pFqsEbp/xjYq8EXTTwQkAtJnk5Y0ehF8g/D1gjwu4Aas2zCOg8RmGf9qkYQa+Q+zmKJD3byJ2sTg2tUTz98Z2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3900
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Nicolas,

Thank you for your review.

On Wed, Feb 12, 2020 at 04:54:19PM +0100, Nicolas Dichtel wrote:
> Hmm, I was expecting 'tdev->mtu - t_hlen'. Am I wrong?
> 
> In fact, something like this:
> dev->mtu = ETH_DATA_LEN - t_hlen;
> if (t->parms.link) {
> 	tdev = __dev_get_by_index(t->net, t->parms.link);
> 	if (tdev)
> 		dev->mtu = tdev->mtu - t_hlen;
> }

true, I missed that one; I reworked to something like:

int mtu;

mtu = ETH_DATA_LEN;
if (t->parms.link) {
	tdev = __dev_get_by_index(t->net, t->parms.link);
	if (tdev && tdev->mtu < mtu)
		mtu = tdev->mtu;
}
dev->mtu = mtu - t_hlen;


However in ipip we do:

mtu -= (dev->hard_header_len + t_hlen);

Do I need to use hard_header_len as well?

Thanks,
-- 
William
