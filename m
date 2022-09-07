Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3544F5B0AA8
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 18:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbiIGQxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 12:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiIGQxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 12:53:15 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2046.outbound.protection.outlook.com [40.107.21.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24663AF0EB;
        Wed,  7 Sep 2022 09:53:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GublmDbEdpdVRixlPZcgHpPWrXx/HraVzUpkGO1tQJfVZ0pEQpObT1aHvc/qwWag6pUh7d+GxLB+2Vr2rwJzewsru1Sc0YHTIEbmINlC6Lzt+VdI0Y8igXtbdAIC4pg66e7V3VcKEvx6IOKi21p2B4tJ62YRiAgRquPS1M7KBJdDIvuVrnf1coYh/oW9EV2/oaPuoiUM5bcb+A3YDoSZDQJoZiW5QC3is4/gQER+KZ6wIk4hjNw4y8fEfPP4yUsKnP6bCbAzdrbE51PVbaFe2+EvIz2QlJ7X4lufeaP4x8YQrbZ872nkAsCu8IvfvUXgPOi+DlQEljMfKmzLD8GEog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOPOAT4HS4ZevmCsYW4LNYQrg7uj1tTiriFiW3KGaZk=;
 b=L4aGh++EP05ghpTDtLr1rlrWgCHF2L612wFj/HfYK8qLmcUQyTya6vhsjFwd2VpxuPEaywgXV26aEC4hoo4h+BlBJ0xMBIr6S/EZ34/EDzXmiaB5RVTm1k+W2tgdkws6XNuShw3H6NUDVpIlGEhaeloopnC0rm8QJT/lCKK7Xge/OzAvHkVeGeSb9ni3Lg4LIBA08Oy/VCkr6GDaG2XZpsJlQr6e1naKYoj3GzkCn5JA7eEnYrxwP43WipOh2IZULTeseo1+cJQ0IaR3/CZcqKzEBM+mlX88TW0/cZo+cyPaB/8amcwS7dBMtPBd8/wDKOrILArpqvES4vVJMQxNzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOPOAT4HS4ZevmCsYW4LNYQrg7uj1tTiriFiW3KGaZk=;
 b=TkBn7RpSlXRDAFJFle+fQAW51yhHEqmNk+KkiYcUdDiyv8PYumFxgLiDA6yiMfD1p6UpqwdVeINyd+b2/aTy4k6pSxdQyfLljn+I8y0lmpjDhtj4iKJIW3F5kFVh3LcabouNy5qNd26tCTXUYSFZwue8OwW2aqNv92e0TWHlDSSBig44GKzKaXBOR0fJmOXzV6h9WRz4nIgDPV0TdfMVSUAB1O3sekDt82xqSHYP0HkgRLrfX2IIzMlYWMVD11Qc2GpgOORJVy7dHFcIeJirQZ8YpbBZDBxzMPLypHD91N+lG1u3uazLiHD+wACBB4kLVNXSj3HIOky1v4LAKS3yfg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM0PR03MB3841.eurprd03.prod.outlook.com (2603:10a6:208:6e::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.12; Wed, 7 Sep
 2022 16:53:06 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5588.018; Wed, 7 Sep 2022
 16:53:06 +0000
Subject: Re: [PATCH net-next v5 1/8] net: phylink: Document MAC_(A)SYM_PAUSE
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>
References: <20220906161852.1538270-1-sean.anderson@seco.com>
 <20220906161852.1538270-2-sean.anderson@seco.com>
 <YxhmnVIB+qT0W/5v@shell.armlinux.org.uk>
From:   Sean Anderson <sean.anderson@seco.com>
Message-ID: <8cf0a225-31b7-748d-bb9d-ac4bbddd4b6a@seco.com>
Date:   Wed, 7 Sep 2022 12:52:59 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
In-Reply-To: <YxhmnVIB+qT0W/5v@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BL0PR1501CA0028.namprd15.prod.outlook.com
 (2603:10b6:207:17::41) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6dc46392-dc08-49c3-81bf-08da90f16fb1
X-MS-TrafficTypeDiagnostic: AM0PR03MB3841:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RqdxHOzvI6ywXCjKmLODWHgH4By7cWzFgei3dtYGDvSQpao0/v7I+vsHh/3xPsdRxO/+JionGXWkw0BouL4sjeSTUPZ4UwuRqtAAVh0EoxVLpue7D+0rLK0KLxkt2B4WNQJpzyk/WzGzDIKlujutG5J+cq1mXTfsW/jP/VA/+P8JRGaJnWIfVAUoY+28IDlW+Bc0eN++3b0zNsCAtKZeF86f0rTcPOMlZL4dYmDXlHD16U3v3b88lofz02nITYr2S7Y52EoZYWU4mlIZ1yGQ6+eLQR6C0hxySShWDEa9L26F7M16eD92LKDIUzGcCWgUHAanXOIFjukFPy4fJ4nxzlWvo2I9gllzsEFD0KkboFYPHE2vxfyghv/niuV0WTDsvBDW/HNXiWOdWybrkKqL6syMlx4HYb6H7ISU/I0ojE8owud6jAURcLa0hMsdj2tS0fIk1w77856xw6THI1bUCjcZbJ4iTFr9GxHYKfP+PyS9eT9Q9P+H+1p5EvImZa7ZtBijB7hpWWSNyzGx5ImiLLjRjdUOdaSEI7QzUhhoER7i8D59ngnu67J8hckiclC553n4HbwR6INsigl9bUqAJpvykTHuOy5Lc3kY1gzAosq6ZAIONdguCGhPk3cfqpqRRNH8uSDNH6IYW+DThK0v24Cv2iKt+BO1xb/6AKv5QZ6j4azvjSObQ254CRjtii+s4o6psm3lM6jsYWBykozsAe/XnwkF8to15N1mC78EYYZjmrIYmhntGGhwhEU9YoBNoTOaNu61MF0gMPSqJb+VCBO9rMwQ9OI+xNGjpAHR4mImpeRAFCV0YvUl++e+4KBPjqXypKzDn0kYWi3J8shmgQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(39850400004)(136003)(366004)(2616005)(8936002)(5660300002)(7416002)(186003)(44832011)(2906002)(53546011)(52116002)(6506007)(6512007)(26005)(31696002)(6666004)(86362001)(36756003)(41300700001)(31686004)(478600001)(83380400001)(6486002)(4326008)(8676002)(66476007)(66556008)(316002)(6916009)(54906003)(66946007)(38350700002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aytxc3N1azVQcjNHNUl5N29YQ0JJd3Q0Qm9ZOEVFeVJSbjVodzV1c21mbk8z?=
 =?utf-8?B?cWlJdERrNFZlN2tXeXRXdjB1YzBIWVJLU21xTXExTDRqWS94b29XejZrM3lR?=
 =?utf-8?B?enl1bURBUko1VW1VNXdtUVRqNWFUTkhTVzc1NFc0MGVPOWZKQk9qVFFCVEhs?=
 =?utf-8?B?UVQyTFpkVS8wc0EwVEVWaXdGZUZGM2YzS2Q2UjhvWHAvQ2NraVFhN0pvVld1?=
 =?utf-8?B?SWoybFEvNXNZQUVUbkFmNFUrQTFFcXlkd2dBb2dPR3pDRU93VmF5SE1icDU3?=
 =?utf-8?B?cHpWZG4reUhXQ3lod3dQdld4VWlmQndQMXRUMm1ndW52aE4rbnB1cERha2lU?=
 =?utf-8?B?emRrVnBOSmxqMC9qOTJnOVFZNGgzblVFbWR4b3B6SGJYVmMrRWd2aVV3cTZY?=
 =?utf-8?B?OGtGYmNLZnR6UE1hakk1WitzZXBuaDlwVUMrQVRDVmRHWXMwWHR3RUNIVXVD?=
 =?utf-8?B?ekhCdTlucVFhcFVxRzhuUnRSamJlRTNuUWtOUkxaaDhjanlVeWhtL1RMdTJI?=
 =?utf-8?B?cUJUMjFaV2MwdCtLTENsRDFvT21BY295dk5JNVkxdEVlWk9sN2RYRHpqYldh?=
 =?utf-8?B?RVBxbGJtYzFMT1V1ZXdHNTk5aUw3K3VCNGFIU2NFcU9hclZXUjRwOW92Yjh3?=
 =?utf-8?B?aFMyeGNOTEJRUkp1R2ZOUGFIOFVYRGxLdExYQ0VPUjJvZUJxWGRZY0EzZEo4?=
 =?utf-8?B?QVAvSjRibEloU1BpRHZKRE1lcnZJdVpYamdaaTNlanhUUXpoYVNNbldERENz?=
 =?utf-8?B?TmZKZ3dWQTJWblZlU3ZKSUZwUVRXWGQxcjM4ZENBdzc2SGk2OGZieDZsSFcz?=
 =?utf-8?B?cnM5azhLejJ1NkNTMjQ0OTBTbzVzWUxtSEJreVJlR3FIYzczMTNPYzRYYTJv?=
 =?utf-8?B?SnVRZk9ERmxXc0x4R1FFa3FkSkl3NEVyOWQwaTluak9pakk0K0Q3THpxeW9s?=
 =?utf-8?B?MElzRkFyc2g5VFcxMUJCSjh2MTFVK3BORjl6SDQzT0xaNTgwcEg1NkNra3pM?=
 =?utf-8?B?U1Z5VW9USUhGTFFRSVJFdkVxOWtsbkwwMXZ1T2M1dk54cXhBRk13bE5NTXZp?=
 =?utf-8?B?c2tEbDlqc2ZaRVZxNjdjZTZKdUdJaGJjUERaOVhqNzZKZGEvZE1BeHRmSXZ5?=
 =?utf-8?B?cWRIZktOaTZzczNXL3RxRjIvdHJ3bjFVVlpiTGtCOUM0aGZZemt3ZXV2eGpN?=
 =?utf-8?B?V1ovYTVUeXJUeE9sZUM3YmR3QjhkWGJNQUZmS1pVYlI1Y3h1ZGxPZUYwbWEv?=
 =?utf-8?B?V2E0OHdORmpRc2RBVVltZ1R0bG9pMGpOVkQ2aWdtTmtVdDU2b0ZOTnluMkZE?=
 =?utf-8?B?T3hYL2xnOWloeUg4eUM2Z0d2T0ZBeENHamhxMXpPdDJMME90dWZ6WmZ3ckZR?=
 =?utf-8?B?RlVndk9IWU1QQmdTL3lNQkhPdndSWWo4RHY5UUtXSlhlOXROWTVvKzRWME9H?=
 =?utf-8?B?cjdVbXlVTnVaZlplaW1VY2YydkpmZkloQmc2emQvTzdTcDVvUXFuYkVZRXhw?=
 =?utf-8?B?OTRDekhYK2gveXlXQVhkVzBRVWRvVFJWWmRKdEZzK2tJU29RT2c4ejh1YXYy?=
 =?utf-8?B?cFhpaWlueDJmTFFKdCt5WnFack4va0RrTFJIZkVaREdxc0VZbG8yUEFrNzRZ?=
 =?utf-8?B?enc4S3pPbEhzOUF3K21GK29QaUs4OXJ4SUlFTjZjMjBWWVlwT05NUGhaSURy?=
 =?utf-8?B?eWpEamZuWGtNUUg4OVZnb2JpdTRwVS9PQ1VISUkwSHdFUWxTb3NSYWRyWC9o?=
 =?utf-8?B?TkF2TTFzOWdpVEt2ZitUUkxSekFwd016OUxWQUh2aklaMjAvd2cvRlFJVlZy?=
 =?utf-8?B?dGhvWHl5amtnQjZaTnlpUFBqWnk4cmMyNnpnOXl5SkdBckxUZVdJNUVxclhn?=
 =?utf-8?B?UWRud2IxenIwRlB5ekZ4enlYRHZKUzB1V1JGYXcxU2J1ZW1iWXZMUFZSWUtJ?=
 =?utf-8?B?ck9uVkVYc25sMElNRmt6TmZ4blZ4WndVSm5FZlhlemlLMGJqNk9qSXdmRTRQ?=
 =?utf-8?B?OGN2aGtKaDh4SzVETjltc0xwdXJQcGNnOWs3elpvZzN6ZUVXNEl0VmpoR0dL?=
 =?utf-8?B?R0crUnpybW4ybTBTVExPUStjcERqVTB4TDkwVmxwcnB5N2JncDY3RnV2Q2lj?=
 =?utf-8?Q?rFLl8LI+Az2RDEBOQLEArt8gA?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dc46392-dc08-49c3-81bf-08da90f16fb1
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 16:53:06.5205
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dwJFcPH/iPsn9OZ1bN6JasbgTfxgrGwA+tZcvqCsNst21GJ7Le0z+UO8gZvnPpcu64eKZj+674jmEsvdbLB5aw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR03MB3841
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/22 5:38 AM, Russell King (Oracle) wrote:
> On Tue, Sep 06, 2022 at 12:18:45PM -0400, Sean Anderson wrote:
>> This documents the possible MLO_PAUSE_* settings which can result from
>> different combinations of MLO_(A)SYM_PAUSE. These are more-or-less a
>> direct consequence of IEEE 802.3 Table 28B-2.
>>
>> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
>> ---
>>
>> (no changes since v3)
>>
>> Changes in v3:
>> - New
>>
>>   include/linux/phylink.h | 16 ++++++++++++++++
>>   1 file changed, 16 insertions(+)
>>
>> diff --git a/include/linux/phylink.h b/include/linux/phylink.h
>> index 6d06896fc20d..a431a0b0d217 100644
>> --- a/include/linux/phylink.h
>> +++ b/include/linux/phylink.h
>> @@ -21,6 +21,22 @@ enum {
>>   	MLO_AN_FIXED,	/* Fixed-link mode */
>>   	MLO_AN_INBAND,	/* In-band protocol */
>>   
>> +	/* MAC_SYM_PAUSE and MAC_ASYM_PAUSE correspond to the PAUSE and
>> +	 * ASM_DIR bits used in autonegotiation, respectively. See IEEE 802.3
> 
> "used in our autonegotiation advertisement" would be more clear.

What else would it be (besides advertisement)? Regarding "our", these bits are
also set based on the link partner pause settings (e.g. by phylink_decode_c37_word).

>> +	 * Annex 28B for more information.
>> +	 *
>> +	 * The following table lists the values of MLO_PAUSE_* (aside from
>> +	 * MLO_PAUSE_AN) which might be requested depending on the results of
>> +	 * autonegotiation or user configuration:
>> +	 *
>> +	 * MAC_SYM_PAUSE MAC_ASYM_PAUSE Valid pause modes
>> +	 * ============= ============== ==============================
>> +	 *             0              0 MLO_PAUSE_NONE
>> +	 *             0              1 MLO_PAUSE_NONE, MLO_PAUSE_TX
>> +	 *             1              0 MLO_PAUSE_NONE, MLO_PAUSE_TXRX
>> +	 *             1              1 MLO_PAUSE_NONE, MLO_PAUSE_TXRX,
>> +	 *                              MLO_PAUSE_RX
> 
> Any of none, tx, txrx and rx can occur with both bits set in the last
> case, the tx-only case will be due to user configuration.

What flow did you have in mind? According to the comment on linkmode_set_pause,
if ethtool requests tx-only, we will use MAC_ASYM_PAUSE for the advertising,
which is the second row above. I don't see the path where we set both
MAC_SYM_PAUSE and MAC_ASYM_PAUSE and then we resolve to MLO_PAUSE_TX. Would this
be due to manual user configuration of both the advertising and the pause? By
that logic, couldn't we get any pause mode from any combination of MLO_PAUSE_*?

--Sean
