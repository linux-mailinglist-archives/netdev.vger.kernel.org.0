Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8917028B48E
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 14:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388479AbgJLMYD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 08:24:03 -0400
Received: from mail-vi1eur05on2130.outbound.protection.outlook.com ([40.107.21.130]:53248
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388334AbgJLMYD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 08:24:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ErspcvCxU9H7AL9XBby/Fj+km1etRmRdKCo3boWSUjHN3/Que9KgKf3DOwCjb5siFfyQ68ELKnsB0Imm/hZLqMhHbsE8Sjdkvd93BPZYTkfvLJwduFjYSU89XUpmFpfu2yLaaF7IgXOxU4amFtt2oOwvq626F2LbruDY9P9oe4rn81Olg5J+DVrGrVJsYp58K9Cq4xcA2UAymIhbw1saaTxHVOeSgCzjcCrzeTv9DKZvQPNxlVU3umgZBjgXRFCbhAknT7IRVyniFdgdfTK70novrWftqcKD8K+9QvA8XcdP8M1M68CXxHSA8lIykDvkyVzLaUKht27FFDt2WC93vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtclSdYipEuZx3NL4olhHutdRYCsx1LE4x7YH/kTndM=;
 b=A+XfAuePDS20ypLX7/40vcOvjBusHL7JWE2I5t5W2yn4iXfOXqHojhhB4YINlfiaAaJFEQvNVrtVWtvBDCEP/y2MfgYXSEV1SqklaegsvYV3d13Kab5QQxU+hkrGijbpgjE0MObL5M79eO8PdxG7OtIrO7KvE1tBnS24HgOW72WPRx8iTAP6DzC92o6Q452Xq6j0F9h2CWExPFxHEyLN3x5tS3FfpKYp1SY/bjuHsGUM9rEFmtzU92zkhLXK/opAulr2mIQKF637XlDYB+f+bKiP39DKhkTNBRAgivMMU9wJe6DxfzRxRi1SxzduBb1ALcBmQf0bHrC4lY+HdGiI4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtclSdYipEuZx3NL4olhHutdRYCsx1LE4x7YH/kTndM=;
 b=s3wlq9VETvnlJshRfRWUsqr2Qv2Nzv/wZ8KzPYeT4Om7Tre/BY9EhE4nhvF2SIrcRmDOhFLoOhCUZr9BzkEvDT57GDGeWXLTm6ykntUSkuGsGyaW2ckUts9BIGz+xWVKpQR6in0d73tOR+Hp6ZDNbqBHYlOcfEvcwpQ7BgnjbAY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nokia.com;
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com (2603:10a6:208:6e::15)
 by AM0PR07MB5425.eurprd07.prod.outlook.com (2603:10a6:208:10c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11; Mon, 12 Oct
 2020 12:24:00 +0000
Received: from AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::acf4:b5f7:b3b1:b50f]) by AM0PR07MB4531.eurprd07.prod.outlook.com
 ([fe80::acf4:b5f7:b3b1:b50f%5]) with mapi id 15.20.3477.019; Mon, 12 Oct 2020
 12:24:00 +0000
Subject: Re: [PATCH] stating: octeon: Drop on uncorrectable alignment or FCS
 error
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     devel@driverdev.osuosl.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ralf Baechle <ralf@linux-mips.org>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <20201009094605.1525-1-alexander.sverdlin@nokia.com>
 <20201009094605.1525-2-alexander.sverdlin@nokia.com>
 <20201009122459.GP1042@kadam>
From:   Alexander Sverdlin <alexander.sverdlin@nokia.com>
Message-ID: <49fae268-c88f-d4e8-6a03-60b69b060557@nokia.com>
Date:   Mon, 12 Oct 2020 14:23:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201009122459.GP1042@kadam>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [131.228.32.166]
X-ClientProxiedBy: HE1PR07CA0013.eurprd07.prod.outlook.com
 (2603:10a6:7:67::23) To AM0PR07MB4531.eurprd07.prod.outlook.com
 (2603:10a6:208:6e::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ulegcpsvhp1.emea.nsn-net.net (131.228.32.166) by HE1PR07CA0013.eurprd07.prod.outlook.com (2603:10a6:7:67::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.11 via Frontend Transport; Mon, 12 Oct 2020 12:23:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d98a427d-1c30-400f-296d-08d86ea9b2f8
X-MS-TrafficTypeDiagnostic: AM0PR07MB5425:
X-Microsoft-Antispam-PRVS: <AM0PR07MB54254DD12666E645F0B97AE688070@AM0PR07MB5425.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cmvBg7npGJsahhdJ4AOSIHy/QVDqSyneBluStNnwTY4Q1jlUQcZQv6Uw/OZ+lgTUlIkvrEbP1Rd+f24cF9Cj7CHm+A19vm6i2FF93DEts6QxVnSK5XSirh+lcRegatu/lOzA9FYdLh/k98G+JxSPSZ3Q+ezPAlT3++RjZfRV4A+wls3bm1EioHMVwA7lcMkclV5LgAT8/YhUToNNTxviAKOA5IsPCVIN0b1Ie/oweludeCaQW+QJJmxPPSbbhZ+OGZTpAHQLUQ9sLQjcBsZoiQ/+fUZooWIWqnveUnq/DpT9MUfBbznNzVDqHu8Zzpesr/LPD/cTTtCui2TlegnSzi1ngnr5ZF4j0BP3KOlBPee3l+1mfMRhNsF7A/v/Od+x
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR07MB4531.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(136003)(39860400002)(366004)(376002)(8936002)(6512007)(2616005)(956004)(44832011)(186003)(16526019)(36756003)(52116002)(6916009)(6506007)(31696002)(31686004)(478600001)(53546011)(2906002)(86362001)(6666004)(66946007)(6486002)(4326008)(5660300002)(54906003)(316002)(8676002)(83380400001)(26005)(66556008)(66476007)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: lMM2nK2okQgJmBk2bPRIFr1dc0bgtjuL0KWLNo41rZoNxYC5UXEroXA08lVGWSIxJGsq8iCLIHB2CzgyGe3AtnyrFoHtAL29eNlyMtoHBKB6GjIlR6TUQEM5CsdGyGYpHoAKv+8vFJh5JYfeApItBB5VRFxz5OcgRk4IzOy0ddakofk1ji4BfrIdC3Cs3GASnozarnKX5GwKW4ZIx3U0OWdVoqR4lFKirYWUUOm6ifPbNYXjTRztIHvpzvTV1vMA9GC3Djh3hwiab49ys/Y+ArF4G8lOJkDcqEOoXXMkpQUB2ClOCvjSEpP8dtc1/SGhMFcE2ZttOy+hbJg6T4a8SiY1fG7+UcOd95u6TAyNBOLsPat/mz7YZXuriOHa4iiWKHLyovJA7a72GDMz6JWRcZQatyXJftc0KMoV+HKp5AY7qaZ0TbY1FcrRNlAGCbh7Yidb+tiRFhKCPrR+vsS2/QnPYZtNpdCv8OO8qufC50dwDfwkV/yx+P5iy5LPP71fS18dmS6GJn3Mpw4k8ETwA/168slGfrUYckQ2tf5jHFlbyHTLH8sCmuYr29ktiYB/F6fSGYRpfaDJ5afhto98kQCUZgRXhnnfkuZMAYjRiO1ES6wiVWv8acrFgVeV9uNEtc1OoQN/FALZnV/VHVLDMg==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d98a427d-1c30-400f-296d-08d86ea9b2f8
X-MS-Exchange-CrossTenant-AuthSource: AM0PR07MB4531.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2020 12:24:00.6390
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cCfGnFd8ykeDnGg6e29H4OZFUYPA/t1/rSf4xrIiPpl8QC/QUs/8aWJP1CpjStze9MY+ZFCIIxukDURSuP75vBQb1Mz+LpS4pGDclAdUabI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB5425
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dan,

On 09/10/2020 14:24, Dan Carpenter wrote:
> On Fri, Oct 09, 2020 at 11:46:05AM +0200, Alexander A Sverdlin wrote:
>> --- a/drivers/staging/octeon/ethernet-rx.c
>> +++ b/drivers/staging/octeon/ethernet-rx.c
>> @@ -69,14 +69,16 @@ static inline int cvm_oct_check_rcv_error(struct cvmx_wqe *work)
>>  	else
>>  		port = work->word1.cn38xx.ipprt;
>>  
>> -	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64)) {
>> +	if ((work->word2.snoip.err_code == 10) && (work->word1.len <= 64))
>>  		/*
>>  		 * Ignore length errors on min size packets. Some
>>  		 * equipment incorrectly pads packets to 64+4FCS
>>  		 * instead of 60+4FCS.  Note these packets still get
>>  		 * counted as frame errors.
>>  		 */
>> -	} else if (work->word2.snoip.err_code == 5 ||
>> +		return 0;
>> +
>> +	if (work->word2.snoip.err_code == 5 ||
>>  		   work->word2.snoip.err_code == 7) {
> This line is indented to match the old code and it no longer matches.
> (Please update the whitespace).

thanks to your comment I took a fresh look onto the patch and found a logic error
in the change. Please ignore the whole patch for now.
 
>>  		/*
>>  		 * We received a packet with either an alignment error

-- 
Best regards,
Alexander Sverdlin.
