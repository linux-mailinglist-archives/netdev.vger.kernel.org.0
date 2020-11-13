Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28F982B1B53
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgKMMuP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:50:15 -0500
Received: from mail-eopbgr20093.outbound.protection.outlook.com ([40.107.2.93]:49864
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726267AbgKMMuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 07:50:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/nwqWBlKJrBSnAqywlYBaLMKF4BZRVAMAakSgkCvoEVj8Nzfwks351z0L+Se8AUzyEkg02Mm5pnszNU3GVgt3FYkqOoUjuEnfAhz4jKxywy8gF6FkKU6XuxRmf6aummoyWBcF3ZLHNKQrgFd825Tf6nj668tkXlSwfxLaPWaCw0UlwTk3d9L2VasCE3xnicfSMvCJhlo2FNjI/vEBeLvypTfbD+p+Nvd0QFedIzpGembsWAjyjKJiTuc295XLwoZIbdXvNwO9rFS3xKPucsM6LKPWAONqyk8DRZHFlrRMP++y534lcj7nwXx62fRR4qxUkscExy34hchNx4uEpJeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQmd95vdfIT7VHXnCIbsw/KXOdzYo/+ffcVenpQILQY=;
 b=I1ydAFJn2uQOtpHcJ3lhWsinSfeVS/3g2mbGVWPDAhHHEgBcxcls19tD9Rb1M9unB9e8/PtOXijqdRzr/TtdsALtwt9ji6iJVD7S7YlFhKpAQIZQkynjA4hUUdf+6BItNaQeWKY/MEZYgS6w/v5yOVJme5Q9T46B4GfHDrRQrhV6ZrsSYr5AqAH+/oq4CvWGn/ur6dwWWpuH1lP08DgI2cJCdn8z1VQKdpQjVTyjdpsppoYPbHxZt1xGtcvjxZYjbY4Z4LX51IPnqdmypm4IkHjXJ6YPhutN5DQbxVOgUXo0qdpKTaJ/oPITHxwcuneEGrlGck0LCwsZGs3wa30Zag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yQmd95vdfIT7VHXnCIbsw/KXOdzYo/+ffcVenpQILQY=;
 b=p/bSW/fJh5D7QGnwsdqevlMAmmNkwDsarxxbvt+dNftg41jB68z/peDC+z5JvAURfiHEoyZfSJdm1kR23ZabC2SIvN4N3w3xSAENVJJ7a4eP1YUEJ5mUYGMXveKyemccYzVYEowayKrrJQqe3HYkGWD8ZhhyrlLvl4G+f2w3gLY=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0393.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:5a::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3541.21; Fri, 13 Nov 2020 12:50:04 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::619d:c0a4:67d7:3a16]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::619d:c0a4:67d7:3a16%6]) with mapi id 15.20.3564.025; Fri, 13 Nov 2020
 12:50:04 +0000
References: <20201113113236.71678-1-wanghai38@huawei.com>
User-agent: mu4e 1.2.0; emacs 26.3
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, oleksandr.mazur@plvision.eu,
        vadym.kochan@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: marvell: prestera: fix error return code in prestera_pci_probe()
In-reply-to: <20201113113236.71678-1-wanghai38@huawei.com>
Date:   Fri, 13 Nov 2020 14:50:03 +0200
Message-ID: <vrcxh2d00hto90.fsf@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6PR10CA0024.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::37) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan (217.20.186.93) by AM6PR10CA0024.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:209:89::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 13 Nov 2020 12:50:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3782fd77-918b-4b92-2205-08d887d2a46d
X-MS-TrafficTypeDiagnostic: HE1P190MB0393:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB03938DB8DACBD5583682986095E60@HE1P190MB0393.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YWnRAMPijRt8BIlYIAMKiJ7TMJXd1Yyyb77HrKu8qHV9VkIv+3BYXp15uFGuIbSqA6wLoPsFeCtZYkiWMJt1lATnSgue2hjsvnwsiBfSTA6WquR+vQqKDnKgxPmKg9+lFOPQpLJT8s0jsT173/+bVn/3snrUXORnjWp5WV3531anwjwkpYQnVjjHwUiPKoLva82zRfbnSHIqVgG49f+LriSA/TvZ+WB9v+C9IJy2JWUuWX5PkdgXl1BHIenrFh/NCitv2NjxBeDzCHjy23rmP4kZyfqT2Jf9sCYP/rsdhVnkFMAxxYOWU3iJBS1tC0QOu0hz1RWswYH1Qg6UqYaR3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(39830400003)(346002)(366004)(136003)(396003)(478600001)(4326008)(2616005)(6916009)(26005)(66476007)(66556008)(66946007)(8936002)(86362001)(8676002)(52116002)(316002)(83380400001)(5660300002)(186003)(6486002)(44832011)(16526019)(36756003)(2906002)(956004)(6496006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: BfTzHMVEhzgmaEAIzjPmDrpeUCycZjP3qnN1u59X6L4EptM7FXR8W3n+F0fNBQwmO3Wmp4Py7Uo6xA0VncpXD6xfbjs6htmxTMfJ9h+TVw4d31wvqKUqitjdxNClVPnCXmsP+XkZ+dXT/dhJOt7SuHmSfm8mB2LU2CdQ6oZb1pIIlN3IQb0itbAanSGFV7N/TEUTwmUao0oPsxkEfM9WZG+J828ieAg5mOEsOFqM+NsQzFN+X1x240zi8GfEafqoHsIz++RFqJExx376hwrM5nOHCOdvvJ8jqvNp3tvm6UNVyV4h1/GqUBUQDL5GSUYvRdfK8ngfHHEM0BybRLMhz+NLM+7+Mbd07EAvRhKcwNy6xIMr8AISKD0IaRnwDo2rH71jkQLsFApBwV1vdv5gK63gTLBTQ/QSDpyUG0Gcp6LWSD7VqNh0c4+1cyic9QfJd1JyNZSLjJxUQF2TWNuHk471ZrjkDhz+FgVPp29rW9OVNbUzInH8wRxXFkL9e9qLcjtoHX/QbQtvNcuz53cH2aYQ9vQDn3vuisvH0iPDmr96lkHBpFBmFSaPycivfARts+1d4FW0miv/gGIoQ0ED9KGHp36j1f0qzrBSvNiq2AcDGAlNoXkh3td2At1G7Cuui9G9P02q0y86rQWiOq5hGZTUWXSLf0YHlYw42GT8UK+oNNR7iEGbn8o+g9wJq8JosbOv7fz1i/HKaP/joUNTo1KpeHHrMeBhM/dgzD+EBHiMfElrkYWulolu0Nk3p7066gA2Pw+LHJ/8+jrqZP8GPcXhln/kbQum6hk7i5LyRqN4gFT8o6jaoDGDBgILaCRrTNgbk7glSSYTM7RE5bmg2zh1T/eDx/IEuSVvjIs68pikTKkKAKd8sX6q2XplnAjqKGDGGq67YhZCJU1g87kIXA==
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 3782fd77-918b-4b92-2205-08d887d2a46d
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2020 12:50:04.6608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hGe1D7SLxZ2KVI+aUVynlKvw73BTZVMlUIwZN23KXOhnT2MpY4sQRAkpTvvxOP3cHUMlo0DgnYsLuNzV5JYV7hknn/yDEddoVsbFosDljPI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0393
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Wang,

Wang Hai <wanghai38@huawei.com> writes:

> Fix to return a negative error code from the error handling
> case instead of 0, as done elsewhere in this function.
>
> Fixes: 4c2703dfd7fa ("net: marvell: prestera: Add PCI interface support")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_pci.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> index 1b97adae542e..be5677623455 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
> @@ -676,7 +676,8 @@ static int prestera_pci_probe(struct pci_dev *pdev,
>  	if (err)
>  		return err;
>  
> -	if (dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(30))) {
> +	err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(30));
> +	if (err) {
>  		dev_err(&pdev->dev, "fail to set DMA mask\n");
>  		goto err_dma_mask;
>  	}
> @@ -702,8 +703,10 @@ static int prestera_pci_probe(struct pci_dev *pdev,
>  	dev_info(fw->dev.dev, "Prestera FW is ready\n");
>  
>  	fw->wq = alloc_workqueue("prestera_fw_wq", WQ_HIGHPRI, 1);
> -	if (!fw->wq)
> +	if (!fw->wq) {
> +		err = -ENOMEM;
>  		goto err_wq_alloc;
> +	}
>  
>  	INIT_WORK(&fw->evt_work, prestera_fw_evt_work_fn);

Thank you!

Just in case it is needed:

Reviewed-by: Vadym Kochan <vadym.kochan@plvision.eu>
Acked-by: Vadym Kochan <vadym.kochan@plvision.eu>
