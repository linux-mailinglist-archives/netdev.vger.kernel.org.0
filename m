Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD3CB1C4F92
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 09:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728238AbgEEHuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 03:50:12 -0400
Received: from mail-dm6nam11on2136.outbound.protection.outlook.com ([40.107.223.136]:30692
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726337AbgEEHuM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 May 2020 03:50:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkpM4IH0wU7CJf15m8QM1tE4pEGEITsPDMqy3xadeqjkcaB+g+Uf+j3Mgz/j2FwYxV63cnRJvW/0BLiBQGIpnFCVrUiB8euJ9DP31ZXlR9EM2Z2xI9mPncQhlNt8pRRKMn42uJza1K6keuziqjA9OfNpptr37VncjMUNmUSgTgm6rmHaY0MeemxBumaagPASBG/7Ob0GxVSh334jDByGJOEESn2CRRuNlp0RY/dGxqYox4u3e0qh5/XGCFIIB5+MJBcJG1lszgOCEebNAqvbODcF2dI8MFZKMxAkp8kOyB3iRA8doqk70/jQOIitvyZ0O3DPjSiFyzmtO7P05qgJow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f56w56JSqyWTJSwbFCkv2hYmPrYJ9QHwAwOCmhHouBI=;
 b=KUyROUJLWR4EkEz/e6+7SbIFy+zR6D7FpPhY2U63rTXHg03jfFScz8lZx0ls8TqJc6F+xHGx+PhOhZiuAIxQ20mc2x00Zf7V29/UBVohndXCY7pzbQr0uqSHPPEHqJa/ObMWgTww2LmiQHvRKICiChq7TDgiQll/K/m9dWmU3UG0SgFJWgZ+y7dJkj9m8NXk3nindCcqFcSQhQR1qtrUu7tj72ayq7m+3kk2sajlfKtyZzktnyIjLRIVxz2GFC4PcMLkspUixTh2JOl/S8eiugPmQiT5EUoAtuJyqOmLk1wY5qB9pal8UtlVO2upmqduPqtecWtlC47RPuSXGhW9Tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cypress.com; dmarc=pass action=none header.from=cypress.com;
 dkim=pass header.d=cypress.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cypress.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f56w56JSqyWTJSwbFCkv2hYmPrYJ9QHwAwOCmhHouBI=;
 b=R2xsZk+wNMUfQf7K/ahHdJBJlpBZtSudjRYqS9GSBH1LGHtgTpA9YYmtxE0UYMISeLNWtn2gHuLnWOrGdi54WLs9s1TQ7an+eKDI1f+WzioZJIdR6abx8jH8M8tjwlxmczXINJKZpNyOaCaCHEA1cnEFhot8dOV5GbbBo/cZZt4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=cypress.com;
Received: from BYAPR06MB4901.namprd06.prod.outlook.com (2603:10b6:a03:7a::30)
 by BYAPR06MB3829.namprd06.prod.outlook.com (2603:10b6:a02:89::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.29; Tue, 5 May
 2020 07:50:07 +0000
Received: from BYAPR06MB4901.namprd06.prod.outlook.com
 ([fe80::69bb:5671:e8b:74c1]) by BYAPR06MB4901.namprd06.prod.outlook.com
 ([fe80::69bb:5671:e8b:74c1%3]) with mapi id 15.20.2958.030; Tue, 5 May 2020
 07:50:07 +0000
Reply-To: chi-hsien.lin@cypress.com
Subject: Re: [PATCH] brcmfmac: remove Comparison to bool in
 brcmf_p2p_send_action_frame()
To:     Jason Yan <yanaijie@huawei.com>,
        "arend.vanspriel@broadcom.com" <arend.vanspriel@broadcom.com>,
        "franky.lin@broadcom.com" <franky.lin@broadcom.com>,
        "hante.meuleman@broadcom.com" <hante.meuleman@broadcom.com>,
        Wright Feng <Wright.Feng@cypress.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list <brcm80211-dev-list@cypress.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20200504113346.41342-1-yanaijie@huawei.com>
From:   Chi-Hsien Lin <chi-hsien.lin@cypress.com>
Message-ID: <41f77019-087f-95c6-6287-1b9ab3a87298@cypress.com>
Date:   Tue, 5 May 2020 15:50:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
In-Reply-To: <20200504113346.41342-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR03CA0022.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::32) To BYAPR06MB4901.namprd06.prod.outlook.com
 (2603:10b6:a03:7a::30)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.9.112.143] (61.222.14.99) by BY5PR03CA0022.namprd03.prod.outlook.com (2603:10b6:a03:1e0::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Tue, 5 May 2020 07:50:04 +0000
X-Originating-IP: [61.222.14.99]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5051780e-1ff4-4a01-25e1-08d7f0c8edcc
X-MS-TrafficTypeDiagnostic: BYAPR06MB3829:|BYAPR06MB3829:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR06MB38291A7585E7CE7564A4E158BBA70@BYAPR06MB3829.namprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:312;
X-Forefront-PRVS: 0394259C80
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YGnmaeqWT1D149D0JCM5QadNujkLNvsJnHCfmPgF/CWtlJgp7rx4yTxf+QImGXB2cBb2DSnu2E8XbyjHb7z/aHK7Cfy++iHSY9HqOvEV7Vs9jdF7gagsj6vCJIB41dcfAnn/bQZ7i3pf/oHDBtyGlPbPhqXx/Eu+TV7zCm47lApaPGO9QZOt4gFGWWUDb92Sd0+KoKClppeYoka5lid8FxN8UChTak+/IAn/5/zVbsocbtxdUMbt2i5wSHd9WJ/hPGhd8iARNQSu7995DLrzeW18fWegcjYHpZxQ89k//b1DZoXoNpP9Ok/JG8oj0QFYJH2B67JpJjhMdqrpUT4KvU/4voBbncj+fbp6Qtf+AXCot5Qj0x6JxtJgUWirOhT7KTxvw6UcWWuyOdCtQfn12v0PJ9GNYXPrul6snngEAaNcizb+BSwMiLk43PdwPLKh1eO/7oqR16FhRO0LRJeeCEcRVkTQDiJS5n3eBrYT3bTQOCdD/Tlq5SRZhFsxNa4mYpTIlCAGH7CfVtN1czH7UOuGIWOinLJjpeBww8SYv0lcPfDvEIeDiY/fRXP54YmYqW2nt2/WVUEt7jOkJ5uTtQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR06MB4901.namprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(366004)(39860400002)(376002)(136003)(396003)(346002)(33430700001)(6486002)(66946007)(5660300002)(66556008)(66476007)(33440700001)(186003)(53546011)(16526019)(956004)(8676002)(6666004)(26005)(8936002)(2616005)(52116002)(36756003)(110136005)(16576012)(7416002)(31696002)(2906002)(3450700001)(86362001)(316002)(478600001)(31686004)(70780200001)(921003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: AAmpXHFtWnodAsgOUKc0NVHH8Lahx0BVGx6bnE735yc/cTrpSuERAMVY2Gbw6yEaLWh1Tf2soVC6dT/TyR4l1IF0W0oHXulsNrm6ba35a86a8AyjoihDmBimsBXFUgtx2IYopFY55fRDZJPBuRuQLykKwbR+G1xBSjdjobxZLUUZRd/VizZNrbWn0R0+0Fqwb2mYo0OVluQuXAB24+lnorRwO+c7ztZMY64oT3uiXMP/GlHUlcXsnT3ZidZoupH75cLCFlv4969I9fVf52SBUohj6NZxvy/qo7a1Erboro1KgUdDOeUN7EIWWtbv2iMgJkACK2gpL3nRtCv26zhYhWmvmv9WtPSAiLYKmIpD2Ekdi2svsuemZsHE7ZPkVKDpI4sZtqKNC4nSPMDqCPtQK20WlQHQXhkGDxFvpU/B0kifo52BxiFGkrPCi1xaRBMuDgpOzzYurXBOK1iUDjI0webqvhuSizcplET2422+KXit26EOMyb7JTNUVDo7bhXiMWdqBmIRnOXC1UILcRilxuYv3fjelTyoLezdzeAIAHjurs2ETQuIePDky4DmKGTsN51KW5vVtzMv+VGNMUP0D6sqFkHj+aYzQRGrEDqwmX8jVWGDuH5qBpbiJPpvw0H6mKMgQtIA/7LpUtaaUj+vnXmP7vnfVGnKv4v+vskeNYXeqWj9heVzwC/WG8nPYI9HdrkJBFLM4JaRIKqvlCy1+KnSARGUsNBBk1HpWMQmnHd6632k68sF0xu2CmfOS3oM2xKquT5bHXVOrDsVJKO73hxfgy9evQC3oKT1QTo4zDY=
X-OriginatorOrg: cypress.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5051780e-1ff4-4a01-25e1-08d7f0c8edcc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2020 07:50:07.3167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 011addfc-2c09-450d-8938-e0bbc2dd2376
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VolswaNUukFQ5ee//wT+WVc/piQXoAjM4o9wtRoD5aQHn7K6GyY6zYCpk1+y40E6QsO+gJ4OM6PG+dVlAjlhEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR06MB3829
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/04/2020 7:33, Jason Yan wrote:
> Fix the following coccicheck warning:
> 
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1781:9-12:
> WARNING: Comparison to bool
> drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c:1785:5-8:
> WARNING: Comparison to bool
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Chi-hsien Lin <chi-hsien.lin@cypress.com>

> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> index 1f5deea5a288..16b193d13a2f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
> @@ -1777,12 +1777,11 @@ bool brcmf_p2p_send_action_frame(struct brcmf_cfg80211_info *cfg,
>   	}
>   
>   	tx_retry = 0;
> -	while (!p2p->block_gon_req_tx &&
> -	       (ack == false) && (tx_retry < P2P_AF_TX_MAX_RETRY)) {
> +	while (!p2p->block_gon_req_tx && !ack && (tx_retry < P2P_AF_TX_MAX_RETRY)) {
>   		ack = !brcmf_p2p_tx_action_frame(p2p, af_params);
>   		tx_retry++;
>   	}
> -	if (ack == false) {
> +	if (!ack) {
>   		bphy_err(drvr, "Failed to send Action Frame(retry %d)\n",
>   			 tx_retry);
>   		clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
> 
