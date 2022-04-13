Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421134FF362
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 11:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233989AbiDMJ0R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 05:26:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232079AbiDMJ0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 05:26:16 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF0C53A49
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 02:23:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649841833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DWgr8ka6hNHu0LSBNJlrttv0llRsrt2/sEs9ZmhLF78=;
        b=DD9CPYtsz8Hd/F8Kpz+Avy2MJZqbhu4h5w/vnObJK4v6HlN2MDOoQbmpWG1tocLTUpOj3K
        XVFvoLc26SJIS1qVOvs3eu38jNPAuiK+yP5AelspZcfF4rCEiHb33dH/EVmcdprRPF4Gz1
        I8pqGHCcrTLSfhF64+FcnyrEa1ZXQWo=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2113.outbound.protection.outlook.com [104.47.18.113]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-37-ZmLhUWZHMoyEpbM8arbVqw-1; Wed, 13 Apr 2022 11:23:51 +0200
X-MC-Unique: ZmLhUWZHMoyEpbM8arbVqw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eYyS10SUNgrx6gTsfqLgb8RykktvPEFApLHl3zgyb+JyBleneFHKoojsy3SFOWM9meXb1BKVW0c2jNILWDLSt4Hu7kt/V7oa/tCa6bhUzWeyYDDaYjorTN8XoMQyw7ZDVwkcEySMGXuMe7ZYPvqRJxFvsEgvh5HmzGfmmeXXKR9xjxstnvtpkbbUvpRjC11R1T/+VImW38RCfXxM1LUwJkyYnmyg6dZqCtiEsC09sXZTSlDZtV6tZpaqy2VLQJFP+mL/nlHo3an6TW4Sdug1CjkKGrmjyFVOCazqXwHNYoXawYt+Cqv9eDtlzD3vfxnS2spy/pzhw3zHIP3cUSaaNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bRT/KMIQlVkcxD1JGLxpRtdVZQtuwqa+J0t0ntPoKFE=;
 b=e3kJ9sdr3j1B4qzE3iTJfv2KI6ef4WF/LWfHj4GWdR25VJVSFDEsQ8V6g1vGfrsZFakEwhVitugnwjyO2Tl8b+siHVaDE/AFoy/4jccSplCxUQuaHHwwedVt13LC3DtAdgaOBzfJuxjQLL0eVCMAYZ3SmltQKOof7x+90Y4EkJMH7qDdAW5ePDgHpG3kuEOdWQz3QJUMdsaBgpIV//UcJJtRILUdoY7wBxmQSWi7wpUiEYdKBo61fhoBMCit2UFVE9SgZPgxmoSp1mFJEZgOjtpW0CrcdrH/Or6+PAY7szhu3JnBaKH5Iq1yC6PIxCcIOhCgwmSZyAEoQehT5dp5WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM9PR04MB8146.eurprd04.prod.outlook.com
 (2603:10a6:20b:3ea::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 09:23:50 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5144.030; Wed, 13 Apr 2022
 09:23:49 +0000
Message-ID: <daa3bfc1-9c4f-4da9-e41f-adc592059a5e@suse.com>
Date:   Wed, 13 Apr 2022 11:23:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 1/3] cdc_ether: export usbnet_cdc_zte_rx_fixup
Content-Language: en-US
To:     Lech Perczak <lech.perczak@gmail.com>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
CC:     Kristian Evensen <kristian.evensen@gmail.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Oliver Neukum <oliver@neukum.org>
References: <20220413001158.1202194-1-lech.perczak@gmail.com>
 <20220413001158.1202194-2-lech.perczak@gmail.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220413001158.1202194-2-lech.perczak@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AS8PR04CA0145.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::30) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 230ce1bf-def1-4be8-0a14-08da1d2f514c
X-MS-TrafficTypeDiagnostic: AM9PR04MB8146:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB8146D124A37614BAFAD0C3ACC7EC9@AM9PR04MB8146.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RCaRxt02E8DRx2x40aDPK7cVCotDQZsc3umc3uhInoZ0HRUMQd4+VTTL6YRpwUX1Ibp37PEdr5SZ0L0LMf21lt8j/b/QMQV1vEPSObLmlM9DzWLLH+aAfDFm6VQnAb1T7BSdRMbZ76TkfUytBA5pABeTUGvzuN9yxj+rSf0hJwo4QikbQPe+SvLKfr/T0cY35lWdDWgqD93ewNpdDJDo3XboyCE1YC0IgxA8HnzJ2UPRg6kIL8CTRcUsGYcezRnYyjznr6T5+z1bOGbz/hI7kl/ghyxoMffq5HfSJTXoUmb8yI5Q3fRiLZP/cwNK7bg87DV+G2EP6HiJuOFw6QS/ontMlOjqS30E/U7/mft4MV9al2cBWTcUgA95veGw9i3mSjUGXH+vi9Im6GEmgzzGlOtdB4mC3c5VP182v+ZXDFkI7kMEjqWDFFrurioePSUsI2fauKsVFOsVY+Ws7JtalP2+xYUX16QRHVecA3oJ03zY4JQ3nGQYOgSU1surC2M4kLXZxdKGgTl3rMAod++FCNlnjFpyz/zamlCz0IGLURHKBwAveGIbV/pKAeZvIiRS7efr1twTjCpwjBMpU/70sVFM8wEHvVQvFLmm5chwO7/oHAo1v/RquXe2MElJM3QI5MtljRW9bUFsUfiIQ4z8MzG7ggEEelqUfh1qazPRVYERxrP6ZmpaX6E0aYtbIz5xPqS8+yFQewPPi1ieqMOPZ8JxT+nAN0Fo8CcBVV/Q5VY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(53546011)(508600001)(66574015)(4326008)(8676002)(38100700002)(316002)(6506007)(86362001)(5660300002)(36756003)(31686004)(4744005)(6512007)(83380400001)(186003)(31696002)(6666004)(2906002)(66946007)(6486002)(66476007)(54906003)(66556008)(8936002)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LOtjph57s9qJiPp5bYWHEDHKP8j50o9lyile4HiCO98TsCH3IUkLdMnYDodq?=
 =?us-ascii?Q?lXu6iUUj3mmb7SBL8jJCyC6g+neF+ysHCpgS5uL0KxS1QHJUnn4MfWUPzkIh?=
 =?us-ascii?Q?7GgKp9by3FA6E4PzGVsiWzbg96C4WZR/DkZkm5pLbp536qpioMyMnlyG0Imw?=
 =?us-ascii?Q?YU1iXTKsmNaovQYF2QK3McbuP23PAZIqMkIZwo/CeSLDoFD/xCdFBcZQMbO/?=
 =?us-ascii?Q?Cl2fD6mCyp6RqayA2vMEvIO/jY6mHTfRzdOPJM7Jc0LDKkIUYaxXVc8Ij9gg?=
 =?us-ascii?Q?up7ANjVSOoh8pfGnOxJJeSg/LRKtIjf9HBDOHufDdg7lWt9iL9HEJfvEkN4V?=
 =?us-ascii?Q?a/btlrUeaqHldTsbOm76dSahIYnwAIo54FIAMosel+1dF50EAF71VzBM0YEF?=
 =?us-ascii?Q?wRaMhT4/zaZF1ApejsLXDoJSKdPpPFWADGEqTrWdmB6LtlDgkz3j9dleLqNm?=
 =?us-ascii?Q?FDHRBNfiILDimak2niBKJWsvkiAT7u/IDsCWhqQKxGgV/ODt4Z+Wo60Eaft5?=
 =?us-ascii?Q?rqYphj+vzIloMB4ZytOCQ4Z7o6v28c9oBDLqJg2gtPElGfyBb6ZAD6PSMtqC?=
 =?us-ascii?Q?LLeX+ti8v4c3jdmB/eVSpCTP8QMd6xG83b7cd4PX6f28e9r9hdHf+4N9z1RA?=
 =?us-ascii?Q?SlyRgK7lxum5MgcmAeoDXBn0zvgMAyoYCFV3NO9UXeBoS7ei/11QzwzQiE5P?=
 =?us-ascii?Q?fPKqV/mhwzjE8EA0ceudTXsghFwDwSZgCUyx5LAtdPc2aTOjvCr5j4f0iLi2?=
 =?us-ascii?Q?iN0p6kmcXB9dNSR2oQZMVMkoUEC5RrrpAdkAa44hTlfVvsufgbGdTYgs30sq?=
 =?us-ascii?Q?W3wQZgKdbrLP864kTUlW5tOLxULKfciwehlIyTjdpI8k7u0JMj2NN/8fkK53?=
 =?us-ascii?Q?6XC91RG/EUcsWFFgm+R90/SXM/e+a8e3MMeBfWhGVr4HQf3ae+16w1TsHUcR?=
 =?us-ascii?Q?9FuznKinyLevUPLwlHFGebMSwwufvnwc/xj/a2JCwlMZ3Sz8yOxqn09GeZ8b?=
 =?us-ascii?Q?y54HitUHVjc19UEo6ACKgvr1sWcWqGFT4XgxMafFZs0ZwF0wTJV3icQPkc1O?=
 =?us-ascii?Q?g9JcxuvhKHAsldwgwSZwCWCw8tiaVKwktyEWMih1rWYWIXO4PWVJ+99LsP8u?=
 =?us-ascii?Q?SCQj1+aLK9BxWD4grXlQd561uDqxjNXMy6yKKlXQL2s0VyWAT7wJpzxp4gcc?=
 =?us-ascii?Q?X77CTAj3zPtex/H4u5N2EY+kGg3y5maTImVUYsHDf+Nm0Iflvl6g81WFF6hP?=
 =?us-ascii?Q?kGfVY2eldQK4cWZXoBAH8Qmt64eyvz3tA8rr0+2fOgMiA+4WFzxNuqzDxCXu?=
 =?us-ascii?Q?n94kCFy6u8RYdMNdAveUUtTDbq2xStkgzDVlC8X3wW0Kw8yFbwSFPai5xw8/?=
 =?us-ascii?Q?ADhbYD5gP78mHUUDdNqObjzqn3Zru0g3gdODCKz+Jan59St4H6+5bGJoWVRd?=
 =?us-ascii?Q?sNp9VXi88Xh5XY2HZLtyNafxgXgh3D+g+zUrYXieRai59bP38c+vqs/t114q?=
 =?us-ascii?Q?1/WyyBQTn3FZPv56/o0oVp9Mv3JAkPtcWNVmJ/KlLwqhB/opAltY9GzNTVPk?=
 =?us-ascii?Q?gUaUd+Ema6x9xlvMHfvjTewCsJkGQ1YxUnbhp62qcI2GCGUKjhOwlvPiRfJ7?=
 =?us-ascii?Q?4wv/hIpCUg+Cib/bp9PZzp1CL7XUdUB/WuPFY+uY8yyeEmjwEig7ocvybpP+?=
 =?us-ascii?Q?7UaB1Ok+JiP6TJD/KGdsMAdVCPPkuymNcTpm8SnpHEA7XWqQCxWOx5arzCBm?=
 =?us-ascii?Q?bAqgyOmdKCfMUu7q4OgTuAHbG0/ZmekPza3h0HgIydA7aKcGb4dtfRr2rsho?=
X-MS-Exchange-AntiSpam-MessageData-1: oWUfih6FAdY5DA==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 230ce1bf-def1-4be8-0a14-08da1d2f514c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2022 09:23:49.2983
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hDVmbNTt6Lv3Ydq8K6pzszVtCi6tjJ1wvpT2sCPjEUP0Md8JYuYAcMykDV/HYMGz0k/nysSl67h78PhP3xXSQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8146
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13.04.22 02:11, Lech Perczak wrote:
> Commit bfe9b9d2df66 ("cdc_ether: Improve ZTE MF823/831/910 handling")
> introduces a workaround for certain ZTE modems reporting invalid MAC
> addresses over CDC-ECM.
> The same issue was present on their RNDIS interface,which was fixed in
> commit a5a18bdf7453 ("rndis_host: Set valid random MAC on buggy devices")=
.
>
> However, internal modem of ZTE MF286R router, on its RNDIS interface, als=
o
> exhibits a second issue fixed already in CDC-ECM, of the device not
> respecting configured random MAC address. In order to share the fixup for
> this with rndis_host driver, export the workaround function, which will
> be re-used in the following commit in rndis_host.
>
> Cc: Kristian Evensen <kristian.evensen@gmail.com>
> Cc: Bj=C3=B8rn Mork <bjorn@mork.no>
> Cc: Oliver Neukum <oliver@neukum.org>
> Signed-off-by: Lech Perczak <lech.perczak@gmail.com>
>
Acked-by: Oliver Neukum <oneukum@suse.com>

