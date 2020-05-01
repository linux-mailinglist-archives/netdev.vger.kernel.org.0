Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21B51C1672
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731726AbgEANsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 09:48:42 -0400
Received: from mail-eopbgr1410137.outbound.protection.outlook.com ([40.107.141.137]:40640
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730592AbgEANsk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 09:48:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I0ptF97QstfrVmGsYIbSrcrz3ckEROtsITQXvwxICpvq+AXxUrs0mGnynfC5Q2sjK6hcNaHscCf82SKCgaCV4VChf6IW/Stm/AG+UUjmIn73l1FFa7Gqa2tiALGqOfb7+1TY/dtXw6gBD+AyijnAYxNao1FDiUhdA2X4iUTX4sS7zI93T0URgMjzVhkNonOTCPlgEuhDVhOUjD5EP2rsPiAI9V6o5EDvyGU8I2x1862LnE3URvgPzg5xTqkiV3KLGq0RM0pq+v7BNMLTdaKi92izAu7B3alBx5Dvg7n/czwjM9/4lujBTr0CAwU+vBxG2wTWwWIeIr8QcrXgq0z5AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJ3owCfNI/HXKrhwoCNX5LYcb3JgafrPaJsvDzcv6Y4=;
 b=T5xyIjnCsbFm1t3ZKPWcOSeBWwC7CUqi4P5iIoUggxdh4pDjBGVcjjlv29uPAKFxcSfq8dN0kwIZtQGlMb/lfgG3xs2WXXHMIFlfea77jSPAbyw78kg7O23AKRzOc+JaY8g4kv1SO+hDfPp6GSWDwPUak+wDWlDtvqLz8kaR+E0FPUyf9s46ApeYBacxdKtYPyMBl9lYk2xTehoeRhTqRJNQsIiQjbE+1xsTGPmO8SvQX3RpYIZxjixuQeWQ+hbrqcCc8Ul2hnWPG7DpaynUNV7zz05TViar2eM0vfiPDKuvVFKT/GarnSQqSq9qUJADjR30VElUBO2Rzyyko4FXqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PJ3owCfNI/HXKrhwoCNX5LYcb3JgafrPaJsvDzcv6Y4=;
 b=XDbg+zVSD/CSH0kl3qU16I5F6K52uAJ4Qer0no7VCbCLNL4A1VcBadtbDEWsKFi4DwMHoVCN6puQtj10lIKbL+2SdBYM26W0eSqjJIDenqXmz1D3BmHHpcJ3ywc3aAlt2cSS5Tsp/7jUKxYT1Hv5HrTEQUz/z5LMXYooC3kgThM=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
Received: from TYAPR01MB4735.jpnprd01.prod.outlook.com (20.179.186.82) by
 TYAPR01MB5264.jpnprd01.prod.outlook.com (20.179.187.11) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2958.20; Fri, 1 May 2020 13:48:36 +0000
Received: from TYAPR01MB4735.jpnprd01.prod.outlook.com
 ([fe80::5079:4b36:6c93:3a5b]) by TYAPR01MB4735.jpnprd01.prod.outlook.com
 ([fe80::5079:4b36:6c93:3a5b%7]) with mapi id 15.20.2958.019; Fri, 1 May 2020
 13:48:36 +0000
Date:   Fri, 1 May 2020 09:48:24 -0400
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] ptp: Add adjphase function to support phase
 offset control.
Message-ID: <20200501134822.GA19989@renesas.com>
References: <1588206505-21773-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1588206505-21773-2-git-send-email-vincent.cheng.xh@renesas.com>
 <20200501033734.GA31749@localhost>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200501033734.GA31749@localhost>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: BY5PR17CA0027.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::40) To TYAPR01MB4735.jpnprd01.prod.outlook.com
 (2603:1096:404:12b::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from renesas.com (173.195.53.163) by BY5PR17CA0027.namprd17.prod.outlook.com (2603:10b6:a03:1b8::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Fri, 1 May 2020 13:48:35 +0000
X-Originating-IP: [173.195.53.163]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7bd19677-f244-43da-54ec-08d7edd658bb
X-MS-TrafficTypeDiagnostic: TYAPR01MB5264:
X-Microsoft-Antispam-PRVS: <TYAPR01MB52645F7AD6A8DC2E8E54F488D2AB0@TYAPR01MB5264.jpnprd01.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0390DB4BDA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Tf8rrKAYeKVfjucJTRwEksSbctxvEo3Z+rBfPy+TxVT6kfYGCkObMWl2h5dp7PsoCIVJ+uZv7NXlXFApw4gDfOWi8687MRDu+Oq7k7rqRvis9nxyDcUwpRJUZ0W/OYSFK9qgOaNZzcN8PJ1e2OonSsr0OlqOMrkhHvw3D6Io7opjOcqI2BUR/9qkFsNLzYUNfXhrte16j6uCEKNQ6wOe0nj8/oWnb1zyrYykkF6YWi/7sPgTIm0ELSzT+He6wyexSpFyr7JE9DPnKI6FvGG3txeuDrzhNMUNtZJiAJwGEjmbg+RNshOBMSbF5BlQ1uiajXYrncCLu1/+Qh7bCDZgWnx72B28MV46NzjgeV0RWeq96GNYMXbab9i3xpgvgbjeUvh56pAaR8eXpZ1bTbnYUE1bYOgzDZ3MaGu/iub0mAxRGGP04UM/m2VhqmmFtAx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB4735.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(5660300002)(66476007)(1076003)(6666004)(66946007)(66556008)(4744005)(86362001)(36756003)(52116002)(6916009)(7696005)(186003)(956004)(16526019)(2906002)(26005)(478600001)(8936002)(33656002)(316002)(8676002)(2616005)(4326008)(55016002)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: X6OiBQgPIB6u9MNlSdyyZtom/yxgnknwnpMu3AMtX+sUzr4IkyqIQjqPC+EkW9S4mBCIiFiBLpKFTtcJvC9QFqhvuevS4Bky2qF0mhILBVfSXVRP7Cz4D0DVFLWpv+uj7NfkO2WJp3aPzt8DRg4N/HLFMhlPwpVE4A3J+eG6Wg5ozE+bITneIRVsm2MVWFCXsZvEY/L4MGBWTDIvfAd6F+TYrHkUmNwxEB4j3vPC10WbTWUpUH1bAaeupju9I+3b2HyGZECP8ktu44nKxw0WACyHt0id0/mdDAGzaA1TKEIpeVxmTkxBiV3PW/AUfYDFzRiM8asd5Nvgl3xEWoT56LVgmpz1sEAW4ZW16gi1+noKjAoViiOU+yGyhTxLilSjt0IYW2DEEIyPYy+YtNCjBBCyRj8VV/QirrifTyK4e7EhG8NZRqB4ExduLvUD5aBSkU7VYP1TDZAWwT6k+s4Rw5fRIC3TtLZ61skcwYfS/i1Ps66KsMg6B1UO7nscX7XS0nhI6aC7eXRr5i5gPuBUc3uLsm3aI4d/Pr5F+W+piIL/kJQvUZXYIWTEYClPRhl4c/Mw6KzNebaCJWqDYvTWYjRbLxkmAx7pg9p4Z/WGz/ldGbk6Cc9+VHrcKmkmB/zfHuiM/pSxE9OeHLShKo+QSVn1YK6664JR0GJ9gKB6ZNc+Q4u7CiC7E2rr40VW0DJS4Ws4hkw+TNk6lHof3YBbDYqkaTPdpbZB+WNhEkj5K8ovb82rnshyoJTV4BX0g/ndcQRVXp8CnZLcXMmDrJG1d1mgYaJ2lJWbAU27tTkYs/g=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bd19677-f244-43da-54ec-08d7edd658bb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 May 2020 13:48:36.5449
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S4Rm15b3t6UuwfgIExhDtBY06EkxljUFDsa7hrpDpnH8wor1YySjTxqKZ+5S/yrWrLUNJ46i+p2wL6AxLGbYGIsa+bXZDxCwYuTCbg1UpPo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB5264
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 30, 2020 at 11:37:34PM EDT, Richard Cochran wrote:
>On Wed, Apr 29, 2020 at 08:28:23PM -0400, vincent.cheng.xh@renesas.com wrote:
>> diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
>> index acabbe7..c46ff98 100644
>> --- a/drivers/ptp/ptp_clock.c
>> +++ b/drivers/ptp/ptp_clock.c
>> @@ -146,6 +146,8 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
>>  		else
>>  			err = ops->adjfreq(ops, ppb);
>>  		ptp->dialed_frequency = tx->freq;
>> +	} else if (tx->modes & ADJ_OFFSET) {
>> +		err = ops->adjphase(ops, tx->offset);
>
>This is a new method, and no drivers have it, so there must be a check
>that the function pointer is non-null.

Yes, good point.  Will fix and resubmit.

Thanks,
Vincent
