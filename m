Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8E01502576
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 08:17:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350379AbiDOGUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 02:20:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350399AbiDOGT5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 02:19:57 -0400
Received: from APC01-SG2-obe.outbound.protection.outlook.com (mail-sgaapc01on2119.outbound.protection.outlook.com [40.107.215.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C06AFB2E;
        Thu, 14 Apr 2022 23:17:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TBAVPIZ3uatkbYnDd0POmyxyr9Yrpj1y/C9I1BWr2tIGeX8vBGShl+qrhaT/frP6CTpzKjCV7paYpq3SnYiNdz7B4mt9MOqqjZKgu+1wwl5wN0oOqYKj7LPf7gf4MommUD0ppDo0YY38coDkgmAoveEUtTzdUy9cKWbf2WW8Xh+lhDul7PjNGh2o5a8YUZT1Bg3Dbm+YwxVKEB1gz3Bnqx8SzkUhbda58I6lrRIPxJ5OFT4MaXCs6ehWTpv5JRQ9OCSgGFT67T8Tt4wDY8S/P5DKgjnDw7XJ8poeVLf2fPR0qpu+fveFYilMIignNaX8jHAoDMaszTP0XLwgvv+pdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w5n18LKRnrBrdfUlI2r1IupJ8j2pL/jM9rPM4GI9mMI=;
 b=Z34GyRa3dR9gwkUjZytZs0DATP0iukKVDn1S7xUIVh40tcQVIgjrKrrz5cGJsMhiA1/HFlk1mjRtc2qQJHoWfpN9mTHbv8gWS5ZxIpmhbwhI7QcrdehQjxh+srDRb4cMEkymbqMdLzUX6YWfVQoEV90VITGY9Yb4rdAKV/3eS0Jy/8h8JPynrHlC7ItVW7GpEa8PyJ3bUwZMdK7RST5bmZsB2K6szqk5jEgbBKzH6HOgnNiiyRAUA56xtVnnZEkt1F80FzgvG+V6UfEsJWMgpyqNFMV5TRi2iehNF7aaIGQrMQyfN0J72tEhhO0lnVkeIDGA7tTCZIFMG7zf8uJovw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w5n18LKRnrBrdfUlI2r1IupJ8j2pL/jM9rPM4GI9mMI=;
 b=I83tPjd5mrYU2VA1Nhz+scjNV+Q3Nbi1P2oVntP79yhZ5+wW5LfkWoX60U7HjuVB8GcM/r7OJ3L3wiBIiltS7oi5hPiqpq1PwkvtnBKq2NQ70chhW5XnAKf1zv2NMd0S4J3OFFB2XJgO38S8q1kSOHCBRqps6HbM1PXJzKxdKC0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by TYAPR06MB2175.apcprd06.prod.outlook.com (2603:1096:404:1c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.19; Fri, 15 Apr
 2022 06:17:21 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::d4bd:64f4:e1c0:25cb%4]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 06:17:21 +0000
Message-ID: <c579fa38-5cac-1c51-5cdb-ac366b6043b7@vivo.com>
Date:   Fri, 15 Apr 2022 14:17:17 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] net: qlogic: qlcnic: simplify if-if to if-else
To:     Benjamin Poirier <benjamin.poirier@gmail.com>
Cc:     Shahed Shaikh <shshaikh@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
References: <20220414031111.76862-1-hanyihao@vivo.com> <YlkHQkZ33rkzAwhS@d3>
From:   Yihao Han <hanyihao@vivo.com>
In-Reply-To: <YlkHQkZ33rkzAwhS@d3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR04CA0060.apcprd04.prod.outlook.com
 (2603:1096:202:14::28) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ac99d1c7-6e44-48f3-2949-08da1ea799ca
X-MS-TrafficTypeDiagnostic: TYAPR06MB2175:EE_
X-Microsoft-Antispam-PRVS: <TYAPR06MB21757AF820BF25EB365BD9E3A2EE9@TYAPR06MB2175.apcprd06.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hoac1Z/3rc+ZbBexQido+iLKBupJDN3cH1WCV8xO6J92Q/BQZrVCdabz1BPH9mwhKnquvvAQWYd45ii3vWidH9eeVkG6fLKofGnnCCUDpT3PIxXsWxXWXQLbWgpGD4xj0hR8VObLKJFloqdQndaIGXizyOK9YiFIwyIBaOv+dmB6ll3QlbyQGe/y/1sH7p12K0PB7Eeln1eWqgm0ocRv699+E5g4AWlG08opm9q5fjnjbCYnO1coidH62xuPiLzBLkL6a7YNR1YsNwK9hsHkXXQpANuDaoWK1eNCGMiB3Gv0P7K2+J7RLyBAgpJYbbgMf6SO09RnSvel7OgsPUdLgrmjRCIpi1DT7sh8ORpn8In+TKM9KP6JcnP5koRZ6TLhLBsBpt6ZoAfiJ/IvMPR513CLUJg+6jSt6j3frG8GgCfwI7UucIhR/hQuK9QGN7AsfyCUr92E8YC8xTql+BCuP8ts4sHWlCHztcNIEUExLIdptm116zQj/QbQWZSUIP4Ch052O9ACXEE4KzFrSstfbYrOtt76d6MiYkrecoznH6MpyV9826LKWCDANk9VhwaBPq+nbiJYNu1Rl8W7FFYmdcQlllEzrVYsM29FJwlhwBZAKfIfIOrvBEiWbUs/DeK7sa0uKpSBbAJ5KgVfjlDk+F59N8XKhM/Ti3TD3rHt5huPBPDEaLhtFz93I985VkvFZObsy/Nt7lssMSMeKYrQzfACrPMS58SWcxYU3flF/Izf4tp1oYsnvZqp4m9h8H5Qsjr1GJVyq6/PQLR93tt1nxb1MmcakgKJCLakDglJk5kvHn1b/rvFtzaB0gY6wM3+xSwVK1eFelRqBuFJ+FZoZ80IPDWitcfDwSAcq/scHDw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(107886003)(966005)(2906002)(2616005)(6486002)(53546011)(52116002)(316002)(8676002)(31696002)(66476007)(508600001)(31686004)(83380400001)(36756003)(186003)(26005)(6916009)(54906003)(4326008)(6512007)(66556008)(6666004)(6506007)(86362001)(5660300002)(66946007)(8936002)(38350700002)(38100700002)(43740500002)(45980500001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NVdLak9TbTFocCtWTmRVaEVRclk1R2d4REFCaG53VDNaUGxzWVpCN3c4bTFC?=
 =?utf-8?B?Z0lWRnovakdzSGpsS21lanlrOStoT0c3T2hpT3YxR2VvbXRONXBvbEVkc1Zr?=
 =?utf-8?B?SHhiTkFjV3lkS21PaUx1dEZZQk5UZG0xVlBhZmNhVDFWbVB2dksvUnhjbXg4?=
 =?utf-8?B?WlpicStuS09GdGphaS8zVXVTeTI3UjVsV09iM1BGdDM5L2lUSUg3REgrZEpy?=
 =?utf-8?B?SWpNVjZPOGhteU1wNkxFTVRHM296RGRkQnVnakx3Rk42MUVZS28xR09xQnRX?=
 =?utf-8?B?d0U3cHAwV2RqMTVLSmRUd1IvYmNSUXA0UUhscmIycC9TUllQK1B3Rkk5Y0E5?=
 =?utf-8?B?TjdxVnlIRWV5dUVhR2J1ZExNeHFrVmFsbkMyK29uVlBuMVNNeTFQc3FXTE5w?=
 =?utf-8?B?Q2Q2NEkwWXJKQU5lQmVBKzRMbmJYcVBYV1JBd3dycTBSWktSL2F1WUZXbk14?=
 =?utf-8?B?NUxmcTVXdW5PcFdEVnZIL1A1a2NQTnNhL3FXYjdTYUJZMXY0cjUxVVpwdVFV?=
 =?utf-8?B?ZHhyeGUrVGZXUXhHY01PSklBaHBkRWZ6V2ZJbHF2WmYxVkJIQXVDNjFUUkFZ?=
 =?utf-8?B?NTFWdFFlTTAxdmlOSnd0RTFQYlZ5ejUrNjU5UE41N0sva2lkUkRDaURRQXNM?=
 =?utf-8?B?NHhsT1RjaEVpZFU4UFBmOWJybFFMZC9IU0pmTWlzMGFPbFltNFFEcWFNV2NU?=
 =?utf-8?B?Z0VLMm9FRmZ0aktlKzc1VWxoUDZyTlc3SHV2bFFRSzZ2RVFJVXpoVlVOcWEr?=
 =?utf-8?B?WmRmVXp2T1dXTk1NQTFxalZYeVlJdDYxSVoxYkFGb0JVRmdaZk1JSEVqVFdH?=
 =?utf-8?B?WStFRWcyTlJPajlHSEswS0FiUm40ek8xREE2MmVnci9lMzJINE8rMkgzQU5H?=
 =?utf-8?B?Yit1cVJxbkVxZmtPYzZMS2dscE0xd2RiajVmTks4bWxEaWR4QmFwTEdZKzFn?=
 =?utf-8?B?VzZ3Z1dhSVFybStBbUxyVzJteU1udmRMWkFxc2FyNTN0ckVBcE5NL3B1RGRp?=
 =?utf-8?B?bFNiS0FWNTNPMVJxVnh3dVVTb3VaUkRRS1diUG55WUZoVWdhb1VjY3FFejNj?=
 =?utf-8?B?MDJnQk1nclU4L0JjZi83VERIVGkzWXVKRWp5MkNwSW1mSXQwYnhpbEhLdFFs?=
 =?utf-8?B?UGdySEpEdE1sUVQ2bEg1VmZBUjJHZFNJaCtzalhEZFQweTJIQTBxMy9VZVlV?=
 =?utf-8?B?dWNKeEUwU2NxS2pjNDRUaW5rc1lWUXoxWEpWOHVsTWxxSWsyRDRTdDV4OW1K?=
 =?utf-8?B?UEVMeWV0ZkFLV2lxUXJ6Rms3QTQ3QkdsMXA1WWN4dDBoeUV0aUVXdFRTV29t?=
 =?utf-8?B?RVgva01BSC83a1YyaHBUcG15ZnNTTTU4S3kzT2hHZWJGM0VQREVKMjdzWkRw?=
 =?utf-8?B?bmRJS3A0NDIzVm9pblIyczJWQmgrYnFVWjloeXdLUnovRG8zMms1bkhzTFlI?=
 =?utf-8?B?RUF3U2dxRUFtMGp4NHpwQXlaZ1lCQko4Z1NaMUJKN3FRakRRU3h3dU5DYlBQ?=
 =?utf-8?B?RmNaT0NGTmFsbUZoRS94ZGZOMnMyZzZPVHY3YVBiUHBrVUdReFZXdWNlb0d3?=
 =?utf-8?B?T3VxbFZDMjN5Ym9FdlpoWXoxY0V0V1ppaG9PY2JxRHJvSmdYMUYxcEExSGdM?=
 =?utf-8?B?dEkrOGIzTERya0FjZEhyN3kyQy9NdVVRTlp6Z2JPVWZPRHd6bjNaL1dXTjRE?=
 =?utf-8?B?ZWpwZzJiVUdRQXB4K0hOMlhvTjZZM3dUdUN6QXNTYTN1ZXovY2ltNWpQWGIr?=
 =?utf-8?B?TEZzU1NYUHNpZmw5NDhVR21ZWTJWWTlrbXI2NFFxd1dvNllwL0tCSHk0ck83?=
 =?utf-8?B?R2NaL1lQR0ZmRE10SGpvTmVNRzRjbEhCL245YXQxSVZ2V01rb3A2RUxLcUc4?=
 =?utf-8?B?MStBM3FmY2QzVEVCOTZEVmY4VytjcWg5SVRzNkpXNEdtaXpOME93UXJtQ0VS?=
 =?utf-8?B?bUNNMEZiZkJHYXNkQjJzdFZCNnREV1hNdVQzK0ZnZ1V1ZVozaXE1Ly9FVFB5?=
 =?utf-8?B?cjFFZXc1UGJOZE82UXJvN0lmVW0wdGFXQ3IzNmNJVHdjdjAxOWxUYzl2ZmlF?=
 =?utf-8?B?bnVMMUN3QUhORlduWkZZOVdmSG90YTI5Qkcxb3hvYWVVUXJQSEwyb1FacWsv?=
 =?utf-8?B?R0RMdHI4LzlOUlk3QmRXaEZ2TDlzOUV2RldmZStQZmw1T2k1anZ6Y0syRnh5?=
 =?utf-8?B?WW1ib01zVFFocHZCaTdENWNnanVwMHhBR3ZENVd6eFJaZlU4dG10dGF2cWts?=
 =?utf-8?B?cDVzWTY4dFc1eFA3eURvbytBcG1Xb0hjQk9DU09MTWsxcEcvbUFFaG9qZTBr?=
 =?utf-8?B?OS80QWV5WmNYejhyZUptalNZcjQxc1BUQUd0eXRyekdlczRqTm8yQT09?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac99d1c7-6e44-48f3-2949-08da1ea799ca
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Apr 2022 06:17:21.6300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tsoHdkAf3cvSqHSPRC2Xly/bHRqN1xetBJ513DcfI/0gYAkR1B2vVF8+MZ/J6NMn1DDlIBe4RLQmD0cE1Xgyhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR06MB2175
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022/4/15 13:48, Benjamin Poirier 写道:
> On 2022-04-13 20:11 -0700, Yihao Han wrote:
>> Replace `if (!pause->autoneg)` with `else` for simplification
>> and add curly brackets according to the kernel coding style:
>>
>> "Do not unnecessarily use braces where a single statement will do."
>>
>> ...
>>
>> "This does not apply if only one branch of a conditional statement is
>> a single statement; in the latter case use braces in both branches"
>>
>> Please refer to:
>> https://www.kernel.org/doc/html/v5.17-rc8/process/coding-style.html
> 
> Seems the part of the log about curly brackets doesn't correspond with
> the actual changes.
> 
>>
>> Signed-off-by: Yihao Han <hanyihao@vivo.com>
>> ---
>>   drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
>> index bd0607680329..e3842eaf1532 100644
>> --- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
>> +++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c
>> @@ -3752,7 +3752,7 @@ int qlcnic_83xx_set_pauseparam(struct qlcnic_adapter *adapter,
>>   	if (ahw->port_type == QLCNIC_GBE) {
>>   		if (pause->autoneg)
>>   			ahw->port_config |= QLC_83XX_ENABLE_AUTONEG;
>> -		if (!pause->autoneg)
>> +		else
>>   			ahw->port_config &= ~QLC_83XX_ENABLE_AUTONEG;
>>   	} else if ((ahw->port_type == QLCNIC_XGBE) && (pause->autoneg)) {
>>   		return -EOPNOTSUPP;
>> -- 
>> 2.17.1
>>
Sorry that I made a mistake. I will send a v2 patch about this.
Thanks for your review.

regards,
Yihao
