Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B4A620CC6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233798AbiKHKAn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:00:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233800AbiKHKAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:00:36 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150132.outbound.protection.outlook.com [40.107.15.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB57B13CFA
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 02:00:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UmfZSQWO+x/iXjZY22+q+ckxYk23V10YEhUX0b5mzC0zB6gsLImnKeI8537kQP1WI9fiCrKQNOwUOFg941FXmgxHt43zu8jyi3DvJk64goSDFd8ZYajr1oJBsgJX8mymWS4QtKjS5Il7DQsp+8MJUAUXgga0Kcnd7f374cCl1+OiGE986U13I9Wyg4cwgba3FCQJ4hUj4H3c1AE0MWTM7Fdu97kgPC7Dxx8DO5Y5Xit+JiA9OhufzSThe76qQyRQk28LcJeCFczUpCouUL7CbUiIKjZA1ZOh2yzvEqsM41hDTMED/aw2MWzn12D8sp9wgQs98y58Eao03kDO2geT7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=D7gWVxZYxNvMSOg0YZRpVtHCN9MIUkNgPwTZaK2aEFg=;
 b=ib0KkJj3+sEZP4Uh7cZRydyapIEkxzvSx8XjEdFthPrtKi22ZSUMterLmNikwaQDaSku+N1iHRQph1E4DCQ5rxqcCdrPcRBC1fpPfxg36zQRAFbq5/pkUuxcG+iaPWzZ6expYNa/vihydHs0xwbMNLdaShNq7Vq2EGde8uloauCql4S0eYX/18SqPMUmz/f5dhR4wbGcvMWj6UOJhFYt8sEZVjOrQz2tSKsjT49P3APi89eWqQmIlIEsWm0SSEXvrIanu0nSFE2gqx54GYeOu5pEFsILQLH9I0dXvuI78MBpC4mc4h16P+EylC6JoQ6QakaM3j/ZlnowOzy2VWyffQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D7gWVxZYxNvMSOg0YZRpVtHCN9MIUkNgPwTZaK2aEFg=;
 b=uPT3TxAPY/OYmaqCMzVRY+I3HRScGK2uy7uOQWUzF8LsJBfQxUCGiEXz69hYcPPXL5XhTb7PdOhGJPqG96tfpOTbA20qQPKb4VZBnkql3CgQi0mi59aL2/EhNt2d+0g5m7xfNCXxxks2DAIZ6v9bSPj4FKh5yVvfYzdv4H0nX1U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
Received: from VI1P190MB0317.EURP190.PROD.OUTLOOK.COM (2603:10a6:802:38::26)
 by DU0P190MB2027.EURP190.PROD.OUTLOOK.COM (2603:10a6:10:3b4::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.27; Tue, 8 Nov
 2022 10:00:32 +0000
Received: from VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 ([fe80::2b03:a6ec:3529:b969]) by VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 ([fe80::2b03:a6ec:3529:b969%5]) with mapi id 15.20.5791.024; Tue, 8 Nov 2022
 10:00:32 +0000
Date:   Tue, 08 Nov 2022 12:00:31 +0200
From:   Vadym Kochan <vadym.kochan@plvision.eu>
Subject: Re: [PATCH net] net: marvell: prestera: fix memory leak in
 prestera_rxtx_switch_init()
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     andrii.savka@plvision.eu, oleksandr.mazur@plvision.eu,
        weiyongjun1@huawei.com, yuehaibing@huawei.com,
        shaozhengchao@huawei.com
In-Reply-To: <20221108025607.338450-1-shaozhengchao@huawei.com>
References: <20221108025607.338450-1-shaozhengchao@huawei.com>
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0074.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::20) To VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:38::26)
Message-ID: <VI1P190MB0317E11D22D2A7F03878D532953F9@VI1P190MB0317.EURP190.PROD.OUTLOOK.COM>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1P190MB0317:EE_|DU0P190MB2027:EE_
X-MS-Office365-Filtering-Correlation-Id: 7b27e205-e055-4736-12b0-08dac17012f3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XVUSygA2ZwstSXWDC8VflJGArZ886541eeG2SSGNRObq8k+auakQf39Y0wWE40QsGGeFeea9Q9YiVGTi7L/nIACCOB+aOVhCo1m1Pgz05byoGlDLx0PabPzvR6nXQixdztkgOxM7Kwr/OAQ2dCo0GwxoH1w4RgNRzXl5ct1Y+3mZLjVHa5cQAlFa3D5qTa+UTNx5ocukwa6giLoyoejdU5TL1etzVZwoO1HCW/8mr+wHejxnJOq0kXpCu7fklzPFJ4UzNKlwTDvqpKYvGUIAL/C6VnIJDldf4hVfqLBqAw03egd4DfIC1J/+zB7yu14ElEki7P1lLoqTJZluZD701wfMuuMs757h4gbq9JnyviKJbr0PzC/bJWYooFwoA6l+KAigyJNaS4r7k24FRPZtAmg1ykzr9A8kaNunEXEp/1R8RKYz5Sm8VhNO41DzsmY+EZEWhkYja3BxCcAx0ZSF25aIMzfkVi2USAXszgfX6gpRFrpXgkIdBTROuxK6EbpkTf5vLbn1dO2/1g1CQiUfrneXLqztZPnNV0/VjaZAi4utng5lThhpsiWSQ0FbTZpA/qfQ/3jrsPKJxsLKt0Ai140WwMoWT5NDKdnYsFmLfH4booXnWRScXVQCP/iezMiqnrvflPU4BQCmUQEu3Ek4oXuOi2Dm805e6sxao68t+zVqycdLE0+eO+W2YcoiNb+R+pBcZE2wpb/QMzhOAfyN222+uVnWQARtlQqOAhRQP7/X0XxEw0dh/iI5rUSKKYV4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1P190MB0317.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39830400003)(366004)(136003)(396003)(376002)(34036004)(451199015)(86362001)(5660300002)(33656002)(52536014)(316002)(2906002)(55016003)(9686003)(38350700002)(38100700002)(6506007)(44832011)(52116002)(8936002)(508600001)(7696005)(186003)(66476007)(26005)(4326008)(8676002)(41300700001)(66946007)(66556008)(83380400001)(41320700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m6WRi5UkJdLLMO9rWM60/Ahk/jM7bqEtPQM3hHeZFQlTAbGpt0iuiqIOj6n9?=
 =?us-ascii?Q?GARoQx7OhUopUneKijmrFb4YH/Gje8jzfZU1mKVpJC8pQXnnYpw4GQyYPoRA?=
 =?us-ascii?Q?XC7RxMISZ8eQePdtDEH1M3kypaydgtmOo2DhIZueg16+QWXHlHUgJyeR78iq?=
 =?us-ascii?Q?qKhnvHZTuFdR/ZBB2FoxNBvduMbYvJBwCjRHaar0zcAiRyol5YRb7HeWNVbb?=
 =?us-ascii?Q?euhI89KcOnZer1/0a6P1u/ZEZ2GdcUtbOGNHIy+QBPl/HNWtYR8Bf+33uzOM?=
 =?us-ascii?Q?ulhGyzx2Eckgr9yiKy9cDtzJJadbO1YaDFOohXpqDb8EtEbmJL/bhVIrRcug?=
 =?us-ascii?Q?/K7D6V3J4HKnEufR3GyMPJt1N2+lFH1kAoUciNJuaGnWK1IIN1Oo0yd6+RK4?=
 =?us-ascii?Q?m0vrBjGyxgc06g+T/+7iT4v+CTIBixkccUReg50oFQr0VZG/D1ijQHSNTgUA?=
 =?us-ascii?Q?cGqtX3/KslgmtKuHpgIrKnMnd6KMUKakuoSY2l6ywzMkA/vBHXFm/pb6Lr34?=
 =?us-ascii?Q?0qIH2a3ogsUbuOc8/7gJxapuyKopAlpgSOXCPcTK+CgPNZQcFwmLW1o+48qP?=
 =?us-ascii?Q?4VhrRlxQT918MjB+AAxzUdro2Ybe81Tjm+moz32xLGyccK77sDVJsvhpkcGd?=
 =?us-ascii?Q?BkedBAxz+PzX16Z8oRvw3kDq0SHY5wpqQKCsIuoK8KWre4vaugc0UjxQ9uXQ?=
 =?us-ascii?Q?KL83opEeo1TqfB8cobIk8nOC8toHHWEzrH8HFrsUEqdax0oRqPhEV7QUSjWo?=
 =?us-ascii?Q?/4uNfdQN4xbDtev1n48z6HA+JZoNW+Qxvwh2nJSOG8OlEKffelyOKaER2IC5?=
 =?us-ascii?Q?s5tTbUYSkw3IAgWUSRcaPyZWej7Ajou+vggJqBe57DMNlnsDS2C0bJMGwRmF?=
 =?us-ascii?Q?eSyXnlrjjcmbUvgK7PYSLWUfaGsp/+CGxEctH86rD3kLNWu7cy2hzGW+rgs4?=
 =?us-ascii?Q?/OVKcz+yLKwyDgWS7egU+LDS11/4wHfd+gpOAgUqxmZ6g1pQG76vtOylfIpi?=
 =?us-ascii?Q?sbyRITWw9aC/iAfp1SfUBWo5cSBCFLVe/JZaoj6e65X+d8LdWAUCQKaJ/zmA?=
 =?us-ascii?Q?8/aCYoxScHBWDolVpmAu+4kasBZE/c0hz2y2MxtnHZrzb+ShBFTdAllswXXE?=
 =?us-ascii?Q?XcT6G9Fwa5K3jk3v9y/i71cfg+xs3YBnW12+rRvq22J2rEolbJT762Y5xf9U?=
 =?us-ascii?Q?DyERBg5fAaWYxQuS6lvRW+xJVO1lJJOLDmd09vmgRbCgswkVSFKSYYgsOHOf?=
 =?us-ascii?Q?Xm9kVyJ2EjK87+85NMY/ASLw8xH67hQ4x4IokhcLmbwFJEz2ja9r39QpFFH0?=
 =?us-ascii?Q?dpjlqSHnN0Xq1+8FGfLRmybZd/3QRiuLJuBKnChwg2woru2hrdITTIiU5jWo?=
 =?us-ascii?Q?ZmslEoO7opBOCl4RkSBaO3i3YA33OR9JMvhU66G57ADBmBNuIblDoRk5Qkud?=
 =?us-ascii?Q?zbMcSlhgcmOLsiBOqWEBUnndg1zquETsEwLp748MnLJwn2o7gO8omt8iYNK/?=
 =?us-ascii?Q?u0CAgLHX2Y1DvcB8zel8GsYcZE/gQCQ/m9/UaPR3dBd4kvG7jGoZEwP3DItP?=
 =?us-ascii?Q?AKkowbyY7pKn86pJWWlYuIYFEXHzdOZoUqN3ju6rEOhfcluKvyBfWI8aV840?=
 =?us-ascii?Q?Nw=3D=3D?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b27e205-e055-4736-12b0-08dac17012f3
X-MS-Exchange-CrossTenant-AuthSource: VI1P190MB0317.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2022 10:00:32.6014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xvS7+40PyocVSzyjnPG+/ghPTbvyVqgj2gTfr+gLTEXdshTZgCMoF/bCCKoKEguA49vnB3tPWVUSbJ7Dgo7KEiAosT+fbFZMm5/0AoORf/I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0P190MB2027
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Shao,

On Tue, 8 Nov 2022 10:56:07 +0800, Zhengchao Shao <shaozhengchao@huawei.com> wrote:
> When prestera_sdma_switch_init() failed, the memory pointed to by
> sw->rxtx isn't released. Fix it. Only be compiled, not be tested.
> 
> Fixes: 501ef3066c89 ("net: marvell: prestera: Add driver for Prestera family ASIC devices")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  drivers/net/ethernet/marvell/prestera/prestera_rxtx.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
> index 42ee963e9f75..9277a8fd1339 100644
> --- a/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
> +++ b/drivers/net/ethernet/marvell/prestera/prestera_rxtx.c
> @@ -776,6 +776,7 @@ static netdev_tx_t prestera_sdma_xmit(struct prestera_sdma *sdma,
>  int prestera_rxtx_switch_init(struct prestera_switch *sw)
>  {
>  	struct prestera_rxtx *rxtx;
> +	int err;
>  
>  	rxtx = kzalloc(sizeof(*rxtx), GFP_KERNEL);
>  	if (!rxtx)
> @@ -783,7 +784,11 @@ int prestera_rxtx_switch_init(struct prestera_switch *sw)
>  
>  	sw->rxtx = rxtx;
>  
> -	return prestera_sdma_switch_init(sw);
> +	err = prestera_sdma_switch_init(sw);
> +	if (err)
> +		kfree(rxtx);
> +
> +	return err;
>  }

Thanks, it makes sense.

Reviewed-by: Vadym Kochan <vadym.kochan@plvision.eu>

>  
>  void prestera_rxtx_switch_fini(struct prestera_switch *sw)
> -- 
> 2.17.1
> 
