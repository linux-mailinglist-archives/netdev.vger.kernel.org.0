Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A9E04A88B0
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 17:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352273AbiBCQiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 11:38:19 -0500
Received: from mail-am6eur05on2057.outbound.protection.outlook.com ([40.107.22.57]:51717
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234433AbiBCQiR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 11:38:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mq/sGgWLRFESHf1HPdgT/bW0y4QaIuU72T+U44ApmVJCezNsioPSTNf5H6GTbfcLUQau2M+T3blj97h9+/qEG2RqPw/LSxRKEoIjWiEPdTA9qagGEuyJp/r0pZ/n7etGSFot4t3MqxedJS/iq2T8C1QmH0nNKU1Y36Zxk06g8+gdJWWs5HW3VdQUAvUaQ1wDTMnTfKYZouuFWnCoVWTmSEqFaOHXXdEaYl5hWaisbmLfLbwXuHBK8nqz39t25WTDpygxsONzTVoKeKBNNjmGALgbbJCyOKhEM6RFxzbtjUP0DpkbOu3GR/DNCwInZFxRwbrCmTEgDCnUkxEWR1H+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L8RACJM7i/Dy3Uz6v9T0PdsF81dAlzyQWVf6hC938TE=;
 b=bOzwL+ofHyOMu0fx0mmeN2oO0dYaFh2lX7q1RmHPItCEuN5Uu/H50ODQosci60uDJ+VAc7UtjKpJxl5CZaif6FeSZnCrmITXblyAMlUxulKQybWDbxLCPLAb02zUzXUASP+mwQ4vQ9iRK6WefyJBL2gFXHvL43WoYN9vTnI6Sg+tEmCBEdnl20D67E6LM86/Sokadc2L6d5FkkigIysX683B69h7mOcrvZFZxRd0lgdaN46yqmERnev+fbyOQkzFRsZonAPspa/fAEOifphxAHGqXCASvNDaR0eoJKRXbvGViMXKoDItkDiywdH9Z77vVsEOKCY8GhJ95PgpQigQqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L8RACJM7i/Dy3Uz6v9T0PdsF81dAlzyQWVf6hC938TE=;
 b=ePWlooXtJF6TNxetPWOJv9SN9FTZymrx8NBdLazrlvFx15loyY2txJOwHiFJmFY9JlPzZeyzQc0qeqw7wLYD050DttNHQ1xD2KT8xpTkpk9DGz6Y9HUtUOTf1uEQkPmT0RFtdaLBycfIq1nmW+YznAgcK72CrMFhBvXvkhSGw9g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com (2603:10a6:10:2e2::23)
 by AM0PR04MB4372.eurprd04.prod.outlook.com (2603:10a6:208:74::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 3 Feb
 2022 16:38:15 +0000
Received: from DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02]) by DU2PR04MB8807.eurprd04.prod.outlook.com
 ([fe80::9484:131d:7309:bd02%5]) with mapi id 15.20.4951.012; Thu, 3 Feb 2022
 16:38:15 +0000
Message-ID: <13dc6f72-8ef4-6990-1c67-2b92c6894e87@oss.nxp.com>
Date:   Thu, 3 Feb 2022 17:38:10 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net] net: stmmac: ensure PTP time register reads are
 consistent
Content-Language: en-GB
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Rayagond Kokatanur <rayagond@vayavyalabs.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        sebastien.laveze@oss.nxp.com, Vladimir Oltean <olteanv@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, mingkai.hu@nxp.com,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Yannick Vignon <yannick.vignon@nxp.com>
References: <20220203160025.750632-1-yannick.vignon@oss.nxp.com>
 <YfwCnV2TV8fznZ33@shell.armlinux.org.uk>
From:   Yannick Vignon <yannick.vignon@oss.nxp.com>
In-Reply-To: <YfwCnV2TV8fznZ33@shell.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR10CA0042.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::22) To DU2PR04MB8807.eurprd04.prod.outlook.com
 (2603:10a6:10:2e2::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: bbc26de3-0260-49ba-7f0b-08d9e733932a
X-MS-TrafficTypeDiagnostic: AM0PR04MB4372:EE_
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB437272E1A26084B9B003A85BD2289@AM0PR04MB4372.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jEQtqBJ2hBlqCCqNH9+j6ZGLMbioPTDYZReo9mgUWcuZgCe4y69lT6oMSMLNqUsM+68gy3gBMGTeII5QNQRuTr1ky0ZYbJdSqVRRBvebHyfFcllJve7hDgoxXWJA0RPSDJ+K6M+uIOOg4AclRJ/WoCa44RAEbPfJMwcEtwz2y6/kp1ia9do73jKMzpLDKk1MiJ+EK0tZPunm6PJs8c04WtUzWtTC4Y1hosPu/Div2k6FhbxdhxYZQhdbq4gfgXZDDTV6GT5hL0wRFJ+D2TmA8l1PGoZ7N9ne2fnX5l1qoPOWToCTjIh+C8mwDC79awvRRntlnMEyxCEBmSoLh7HefqsbDUt8o4jv1wAJApnFQF42YbNULodOcxNKTpY6CeLyBStdRP3yOoZspBcuO08RritS2o7VoB+k3tC6azyqSmqJLUFUYRPlNwEj0PXArrYBL+d0voXcA+tjugwoRMfBRJmAtG1Vq2JJRa1Ja+3EXCxWPHprluNQjPeT7N5dvOEsp1xVXTf60fYCn0kee199btJM+T1HPuOQZsve2Gl/PH0lfUvwYr1serVxPU6hPJv54V3lIntP//tWLMknu5SQhjhVBfuiQPYiVx+OhQQPd5gAF0y7lpMM25YuuTYL/kbld9wRbW0e7XhHZa4G4MRNQ2ELtGAc2kMjGX1kbf3sMgFMVdyPK8bd87S2OKqqDH8vhyxUAn/5ZqUemX3GcpGkeMJPx7LQpCkPDVlf9xRaloPBfM3U/cRpSfyqcE6Kdkh+ED39u5TFcJaB1V1zdSmqfw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DU2PR04MB8807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(2616005)(508600001)(31686004)(2906002)(31696002)(83380400001)(6486002)(316002)(26005)(54906003)(6916009)(5660300002)(53546011)(7416002)(6512007)(4744005)(86362001)(8676002)(38100700002)(8936002)(66946007)(4326008)(6666004)(6506007)(44832011)(66556008)(66476007)(52116002)(38350700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SDNHUmRYU0dBZ2F0b09kRGlXV1lsQzlCeEU3Yy81c1VyZ1k0dUZYb2JNRkNs?=
 =?utf-8?B?U1ZOMEttNzlBSkpyd29xZGVLUkNZWTVEbTZVNjlDY05qY1BHMzhYeFlkcFRx?=
 =?utf-8?B?dVk1dlJ5aXNhMTl2dTY2aGNrZWRZdHJTYmdyOFFhUFo2cVIzOVdmakhQUTFr?=
 =?utf-8?B?NnNBbytlREZIWmlaQmpmbm1EOWhTWkZ6Q0FIdWRTR1FCN1B4SERKcTdMN1FU?=
 =?utf-8?B?aEhZbVhkSjgzZk8xRXppYzZvYXh1b21oVEMxbEd5eXhOZHFsbW9Salk5OFhT?=
 =?utf-8?B?OUovZWNEOGJRRmJQbEhGNU9EaFRlTWdscVdiZUtzTnlhamloU0JQT3ZYVURC?=
 =?utf-8?B?d21taVVneTFuTUNsOFVWbFpwMTlvb0NrblNyS0phVjJwWkkvMjhYT1JReVRT?=
 =?utf-8?B?MXhoVEZVRGJtNXYvSlZ5VDIweW5tK1JMUWRDR3ltc0puRTEwVS81S0pSRXJ0?=
 =?utf-8?B?ZzR3NDVJQ0FxVFhsTEVoUmovZDlJR1dTWHRmRjBuN2lXeStxVkF6STh0T28x?=
 =?utf-8?B?LytxYnUrSlpPTXZLbVgxd1VWdXBQbVIxMytubWhOcXRSOC9xUlY3YWVRL0Ja?=
 =?utf-8?B?UERTbXR1RjAwU05XcCtZdXdheDBaakg5bzIrWUNWajhIRjFiS2hBczJ2TWxt?=
 =?utf-8?B?cFEvb2hHL0tGQ3NWbytjWDJXM0srSWQ4dEV1MkRoeUthVFkySnlLeVpnajRt?=
 =?utf-8?B?bkhJL3hOc3M3R3hKcmVVQ0lBZU5QaGo3NzRTd2UrT0piNFFiQWxoc3JLQ2JJ?=
 =?utf-8?B?RnQxejEzWUhPYmk3U25lMDhmM1FhNFhPaU5yRDRUclZxQW4xUzI0aW1aR2Ft?=
 =?utf-8?B?NmI2ZmpkT1kwam5ueS8vTWRxcHhkRTd4UWVrczI0eEZ2bXRHd3hJcXdPcFhk?=
 =?utf-8?B?TkNoY01NZStwcU5QNTM3TTUrSEwrY2pQTWZIVUpTcXJjZ0ozTzJVMHBiRWxG?=
 =?utf-8?B?QWEwZ1hZd0RSY1dzaTR4NXNDZHdDc2xxSjkxUngweFVtMWpwVUhCd2lna2J6?=
 =?utf-8?B?ODVFNDR3djBXYm00Y0g5b1VwWWJGREJ3VDJsWHl0bi9PY1ltSHA1K3VCaUxi?=
 =?utf-8?B?SGlvY2VJV2JENlFxTTM0RmY2dzFtOHQ4TVFCVXh0d3lKK3VMb2pVSUR1TDJv?=
 =?utf-8?B?R2dEUDZaK21WWWUxbWlrdkxtcHRYUkcremVsS2FCaEdIZE1acTFuMjcva3dT?=
 =?utf-8?B?QVdUU29Lb0JiSzBwayt6ZWwrK1QxemMwVFVBVVFIQmN0enN2dW5PUFdtSHNH?=
 =?utf-8?B?VGViZzBEcVBZT285Z0VnY1dHUXdZQVI2SEVpdXQ3K3VxUFl5L2pTcUEyTW9s?=
 =?utf-8?B?cXlHN0FpckxRMy96dzB2cFA0azUvc1ZEYXo5b0h5Q3ZNV1JuNzdKdjZhTTBo?=
 =?utf-8?B?T1JHdUw5OEdiYyt1MUxYalcwemcrckpaYWVSQ2NLRHJxcWZRSWZOQzNDaWpE?=
 =?utf-8?B?QzJnODgwMW1SZVRHWSswNHB5dXhGUisyR3RBZTBsWm1yQ0pQaDZHZXp5NU9Q?=
 =?utf-8?B?QVJOWU13eithbWVqQVI5ZGljR0ZPbVRaK0pQRFB6MTlrcUE2YzhIeTAvQ3J5?=
 =?utf-8?B?UXJFTTdRSFB0VnRvMzZDbzRsdjA1NndsNGxTeGw4dWtZWHhiRXpVa2F4R2d3?=
 =?utf-8?B?Z0RzamhhRlgzbkI4TXNZMU9hYkRGcGRRNkhEZmJHQXB4UnhxZVpHUTlEQkhw?=
 =?utf-8?B?QlpDRTdnT1psdHZ0WVlBRjB4Z3N1aVZGaFBwQWtLSThMYW0xRkY5cmZBVU1w?=
 =?utf-8?B?cHF0aWtiTTZleDN5VjVTSThwY3NMTkplYTd5QmtUMFpJR0taWU9wQmdRcVVX?=
 =?utf-8?B?SEsvc0tsTzhTZFFIWExLMWN6TlA2QjJjVmtRWGFXRlVoOUN0NVVrQWdaTDZv?=
 =?utf-8?B?UkVZaEFJT1AyM0RJcGxXVWg1cXQxaDMyZFdyWW5RWXFwV3dSbzRsdEVoRFBp?=
 =?utf-8?B?dlVBd2Q0UFFScXAyVUI3ODRraDlveW8yaTgxYjZYcFhxSE41eVNCanZRVkkw?=
 =?utf-8?B?WXdZSjFHeU5FMWVqdy9LVXI0K0QzcDVva1lwRUJuYWFjUGlIWjA1bUM4a3ZU?=
 =?utf-8?B?NjhWbUo3dVlTT0FpbEdMOGg3UnJGanN1NGxIRjRWbVdiUWsxOTRRL3Jmd013?=
 =?utf-8?B?d0lYZTVObFRibnJ1WjdZS0U2TkJNZ29VREUvSHY3YkJTZmxsQjB0eXBacm01?=
 =?utf-8?Q?ewRocjRIqe+3Mu8S0qUNuTg=3D?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbc26de3-0260-49ba-7f0b-08d9e733932a
X-MS-Exchange-CrossTenant-AuthSource: DU2PR04MB8807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2022 16:38:15.4014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nUwZel7gRKetFzlBtNrXGuEJT81TZhcabvbgQlGO8DGQMOmMNdsDPuHLUTDb3Q3mRsvq7jZQdDnPTyBe5b/MGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4372
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/2022 5:28 PM, Russell King (Oracle) wrote:
> On Thu, Feb 03, 2022 at 05:00:25PM +0100, Yannick Vignon wrote:
>> From: Yannick Vignon <yannick.vignon@nxp.com>
>>
>> Even if protected from preemption and interrupts, a small time window
>> remains when the 2 register reads could return inconsistent values,
>> each time the "seconds" register changes. This could lead to an about
>> 1-second error in the reported time.
> 
> Have you checked whether the hardware protects against this (i.o.w. the
> hardware latches the PTP_STSR value when PTP_STNSR is read, or vice
> versa? Several PTP devices I've looked at do this to allow consistent
> reading.
> 

It doesn't. I was able to observe inconsistent values doing reads in 
either order, and we had already observed the issue with that same IP on 
another device (Cortex-M based, not running Linux). It's not easy to 
reproduce, the time window is small, but it's there.
