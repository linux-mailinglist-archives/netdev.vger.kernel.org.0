Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F3F731A9D8
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 05:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbhBMESv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 23:18:51 -0500
Received: from mail-eopbgr1410130.outbound.protection.outlook.com ([40.107.141.130]:53532
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229570AbhBMESs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Feb 2021 23:18:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FY4FneK/L3Ha81pgiZ8fn+Yhls3fJqUcZNn1QekprEgaBHfOSm3Bb5ouIlWhQeHHuGBBeVVxpBI0lYDdJoUVvaVW/p8EfboU5FAnxA6cHfxf0o1aglSJFMebxU++QQg3eFI+X8Y58sIYpXBSo2ZB06cpWmRdOKrHNrpPHaFGy5mttDEd92ctjI8h02cBW3QWKwN05sHexPmdsdkgNs15Qp9CmuS3R+5PCne7OW0v9g1eC+lzqg5L6HYP1msGDHYxwOyptRJJJoIm35lmenVUpHxhDVN6Y3kYz1xSplsp9bsDqGPFTK7Bshbxaub2veJX6WmaYBEMDXY697geYm2gEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWVQbwUeR7xa/vRZ6uEadnmrQvIm79GhxfWotQmkJzs=;
 b=It+cvkF6h8PpP3R2/tsSg/oy6ueylsd2ns70sPcxR53oIMGum09zjDElwCk+d8JfjLi4+R2X66gWFwrXu881u6kPU3gyd/iVNwkmpfhxHs3CukCcR6u8w/F1R0wg2upelML6CqkUXkhpmxXcGeAo3aJoU2rZeujxaUmDBDFTibnG9Rw6bfOu88wKgQhA5Aj4auG4RvHds6LfP+dMSGialWfWNMA0d/1ThluKzSJQQWP++4o1IAp+FY99wuNRgWmwao0Nw0Im0c9gXVTzETqhRk/GJl8e68i5cD/lEaXD/w3cOvY3WfSxOp3PHjDVB7Jufgu8Gw7SAvBrD/d/37BCsw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yWVQbwUeR7xa/vRZ6uEadnmrQvIm79GhxfWotQmkJzs=;
 b=I8wrkg+vzu0LCnHuzxc4TTDwqrDmq20TsidhFlwcsbhZZA7JP+bUJLs/UMU9ZpKGSHhstdRlTwUSJwTHtuq9s+cbTUkmEYi9sa7ARhgpfBEZiXwg7NrScSNW6I2EwJof4zT5QDIJzoT/IQoB6Dv1jMt6R7NdRvp7cf1BQSx1Ggw=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
Received: from OSAPR01MB5137.jpnprd01.prod.outlook.com (2603:1096:604:6d::17)
 by OSBPR01MB4262.jpnprd01.prod.outlook.com (2603:1096:604:4f::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.26; Sat, 13 Feb
 2021 04:17:58 +0000
Received: from OSAPR01MB5137.jpnprd01.prod.outlook.com
 ([fe80::d46f:1a71:68ad:42a4]) by OSAPR01MB5137.jpnprd01.prod.outlook.com
 ([fe80::d46f:1a71:68ad:42a4%7]) with mapi id 15.20.3846.030; Sat, 13 Feb 2021
 04:17:58 +0000
Date:   Fri, 12 Feb 2021 23:17:45 -0500
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] ptp: ptp_clockmatrix: Add
 wait_for_sys_apll_dpll_lock.
Message-ID: <20210213041742.GA14189@renesas.com>
References: <1613104725-22056-1-git-send-email-vincent.cheng.xh@renesas.com>
 <1613104725-22056-2-git-send-email-vincent.cheng.xh@renesas.com>
 <20210212153140.GB23246@hoboy.vegasvil.org>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210212153140.GB23246@hoboy.vegasvil.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Originating-IP: [173.195.53.163]
X-ClientProxiedBy: BN9PR03CA0239.namprd03.prod.outlook.com
 (2603:10b6:408:f8::34) To OSAPR01MB5137.jpnprd01.prod.outlook.com
 (2603:1096:604:6d::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from renesas.com (173.195.53.163) by BN9PR03CA0239.namprd03.prod.outlook.com (2603:10b6:408:f8::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Sat, 13 Feb 2021 04:17:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8349e046-384f-43d3-89e4-08d8cfd65823
X-MS-TrafficTypeDiagnostic: OSBPR01MB4262:
X-Microsoft-Antispam-PRVS: <OSBPR01MB4262D482007317103C641557D28A9@OSBPR01MB4262.jpnprd01.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vLUeN8ceuW38Rvg0cc7zeWnSWXmWEgQEh3fT0tfF3nzo3B9dzsAdC9uv9sbeFJof6VI7CAXrey+Yz+cCuRR9nAYDhLCO5nzq7/Nu30q15mUdVeLt7tJhg84N5ScY1eJuFc33h6EL+4vuP9sW/NNxg+h96zOtCreIcE86udC7Zhux12IBkwHit5EaCkxKhFr8gYnwakNBqG5MwVPGA2wl81Ly/ijVFjzzNgBotoYbcsbr8VcjokEeGdtpJCZCwU8QeQNyRM4h5gzbHgEOjE2QoJ7cFSbwuGkATx9Sh1HS1njSqlOjiZGE1Yi3Hrns24Y87mVlOJWx8PK6qoCiCRmFzYVOjnwKpuNYdjSmBvHERuWLYbuGqCYs6T3T5FfuDKgfws8qxW0eKDqhKaCsjIjKch4WPjgL33NuClQUSX8TF9EbqQ2qCMWnAVNBa8LX8LQXjHpMnKVHwgyYxt0Yde3g2CMZkLiy3eHG++cAlNn2WBo9Hpwn+8qmx5cvvmnDnsXm1etgtga/0D5SxgJyA5S0sw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OSAPR01MB5137.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(346002)(39860400002)(136003)(366004)(66476007)(83380400001)(186003)(66556008)(33656002)(8676002)(8886007)(8936002)(6666004)(7696005)(956004)(52116002)(6916009)(316002)(66946007)(2616005)(4744005)(86362001)(478600001)(26005)(1076003)(16526019)(2906002)(4326008)(36756003)(55016002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Y3ZOOVcvd0hkWXJ1RTNtTkM2S1Z4cmd1cmN2dW1PMjR4bTFRaVFNMW82eUM4?=
 =?utf-8?B?YXVZNWg3cndyVkpST3c3Sm40cEY2NzVtQlZmeVVlMG5QUngxcFJ1Rk9TNjRF?=
 =?utf-8?B?R2dsbDAzT2laRmk3eHQ3TzlkVEloeGttT2lRS1VXQmtFVjBQL0NXdk9BU3N6?=
 =?utf-8?B?Yk4wR1BhazNZSWpHNzJTL01xM3ZTd3JrT1huY0VRTS9ZaXhGVzhOUisxbzNq?=
 =?utf-8?B?SnNMN2Z2ZEVoNlVSbXJMWDFHandOenVLRzdiWVU0cWFvcGwzci9OWkNvdk1C?=
 =?utf-8?B?dmw0THZvUlczSUc3bnZyTlI3WU9vWnE0UldZWE1seXgvWHBESy8waldVNXhT?=
 =?utf-8?B?T1lDcExzWkFseEFSc3pTZEtCdTZZaW8vYlpheWpSM0pPcEltYkhBbFVLR2hv?=
 =?utf-8?B?SU1HVTZsM1U0Ym03MXJKbW9MVk5TTFp1UkVhalhHNk1uZDdQZ1lFMk5CTHVo?=
 =?utf-8?B?TjNHcXlWQzM3R0tHdzBkbjJoNHpkM1lyWVl6cEp2ZndCYnZ1OEtJWVVkdFJ3?=
 =?utf-8?B?VlZPNFJvaU53ZGorSEpxZjE1aHVmeGczemZ2Ukl1Z1NTM1A2RVNPUkg0a0xB?=
 =?utf-8?B?U2NSSnlYVUYzSFUvdStNU3dnUWdtaWdNUEc3cGtoSE1nTUpzbk1qNlJRS0pJ?=
 =?utf-8?B?bGlQaXJqMzA4alYrQUROcmtnSHJwVHNOS3VDNlQ3RVBleEJuQ2JOcDYwK3Nr?=
 =?utf-8?B?dFA5Z3FaempBQlkwTXRjOS9HYWUvNktlMVFKUk9VN3dySXc4NytKNHp4K3pi?=
 =?utf-8?B?M3RQd1pIb2NYdG1lL0wzUE5TVTJocmphNzk3dUZIT2NGMWlDTEc2aUNFblFq?=
 =?utf-8?B?dDB5V1RkRHJ1MndBNzNhL1o0aDFzVWQvWW1NcnVNeURiKy9XeHdHMVVzeklI?=
 =?utf-8?B?U0RSdHBLcENsNm8wUFN1YVRsRFlraDhETE40b2Q3UWJncVhNNFd4S2VieTZG?=
 =?utf-8?B?cHFzQmRxQzcyT0UxdWZzM2xZSEI4MkVQQ214Z1ZWVzB5NU4xMGgwaXNxQWtW?=
 =?utf-8?B?WXZjMVgxVVdZTGZOVmd6aDRjVktPa3pZVjA3Nk91ckRETlU3YVJvd1JocTc1?=
 =?utf-8?B?SkQxQk16TVJjbVhtQy9WRHRpL1ZzWk5VZHJCMWpaR25DWk8weHhaWGxla2xu?=
 =?utf-8?B?WG96Nmw2eWE1bE5OZjhqdlZhZmZkcmZLcUJJeTRJdkNLbEllYm01QXJPdmpM?=
 =?utf-8?B?Y211YUJvcFk5VXZDUlZtSmFMbVRiOUdDY1lzeW9aMmZzRlRrSzNHMURJVmVM?=
 =?utf-8?B?MTRNWklnWmtySDRwY1ZpUzhXQVBvQ2plWkZzMTg2QXZza2JPdWtGNlFpWjh5?=
 =?utf-8?B?UVQrL2ZRbWE4dHVNYXBLQXhSaW9UTWs2RUFSZi9tYTVZYlFINGV2UUNESzN6?=
 =?utf-8?B?eUh5OFJ4RmF5VjNCMWxMdXhoK085cTl0bExKQXZwYVhoc3JoeW5nUEtnQnh0?=
 =?utf-8?B?MGpnWTJSc2duaXpzZm4vTzNZeG9nRFNMQTlGZTdiQ2VJMHA3VTd0Tit6UFh0?=
 =?utf-8?B?VmpIZndMOSt6eThZck5TVjhLVnVpejdmZFRSRzVZTy9scDhLdHN1N2hiRDVS?=
 =?utf-8?B?aS9DSmo0QWd1QWlFNGhoYlQ2S1pXcEFoS2Ivd3pTVHJRV1BCR3RFQ1FRZFli?=
 =?utf-8?B?VHpDM1ZKWjRyeWRJRHFTSDJRNVIvRjZSVE1vcVZYdDJadkZMWFdTd3MwZW1J?=
 =?utf-8?B?R1JibnFrZ2lnUnNRZ2ZUbC9vakd2STJ3bnBxaWZIa3ZFQ21pcjA2WjRWUlJX?=
 =?utf-8?Q?eJHl3aAlqUXcsrvB473x/QNJTQ8PY4LY6DMpDKR?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8349e046-384f-43d3-89e4-08d8cfd65823
X-MS-Exchange-CrossTenant-AuthSource: OSAPR01MB5137.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2021 04:17:58.5178
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5Iin5S9yMOvywrakpAF2fQ8xj9GOM5r14mZR/68eqyteJO1iVwzqkMfltYgkJc04pkXGeMzlpShvIQtWPAoNwLDNAInnrlFCCdipF8sMFVQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB4262
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 10:31:40AM EST, Richard Cochran wrote:

>On Thu, Feb 11, 2021 at 11:38:44PM -0500, vincent.cheng.xh@renesas.com wrote:
>
>> +static int wait_for_sys_apll_dpll_lock(struct idtcm *idtcm)
>> +{
>> +	char *fmt = "%d ms SYS lock timeout: APLL Loss Lock %d  DPLL state %d";
>
>Probably you want: const char *fmt

Good point, will change in V2 patch.

>
>> diff --git a/drivers/ptp/ptp_clockmatrix.h b/drivers/ptp/ptp_clockmatrix.h
>> index 645de2c..fb32327 100644
>> --- a/drivers/ptp/ptp_clockmatrix.h
>...
>
>> @@ -123,7 +137,6 @@ struct idtcm_channel {
>>  	enum pll_mode		pll_mode;
>>  	u8			pll;
>>  	u16			output_mask;
>> -	u8			output_phase_adj[MAX_OUTPUT][4];
>>  };
>
>Looks like this removal is unrelated to the patch subject, and so it
>deserves its own small patch.

Ok, will separate into separate patch for V2.

Vincent

