Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410D94B5B90
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 22:01:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbiBNUxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:53:17 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiBNUxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:53:15 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D66BC8E
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1644871875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZbuTMcviG7OWTzwY82uarnv/vTEE/mCf3OU/7FKtpjo=;
        b=Iw98DhcmPtqgNvRk/Pzw2TANQBrFLQbIal0uB9VMZ9hXcApQ+zdH69lppXaOj3prkJ1VLR
        PKHxZYi3ISldJOqJYHLO2KYItkA9p0RDNhnakPEc+9bSB+MNfYtFN2J+tyqHAxZxe1JdjY
        dMKP46cY7lgGB5eKGDeT1Ak4X0YbZa0=
Received: from EUR01-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur01lp2050.outbound.protection.outlook.com [104.47.0.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-19-tsY4SxzaOTaOqsUYn6qZqA-1; Mon, 14 Feb 2022 20:30:09 +0100
X-MC-Unique: tsY4SxzaOTaOqsUYn6qZqA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQRC8aoY+JfNEuzX813NWonAiJxbv6DdaszI9N45Lf+q1p77ZYJtAh2KkuAZA6Wetmn1FQEz2FptbsXYaK8wyajyeSNSG7ECO/PWqFDEl1ppLhmZPwb8/QR8YeUvfSQfqz3R79ohhS1v7r9Ib0warHFBHlV4cQetrS6WMWAtLGUn9FQlZwcZQspGJuZSnXIO/7mWYXeYpMK3WqU37U56w2zxYV59RgbD50dcG61fqZfrCDukPSNqc8vVNQcMLlsaIjqmOeL+Q+5Rr7SWSya1bGWc12bgslcfBL90vXx2jw/ICzWnWSKiufHede9d7fRsuw4yhiOo3XQinb670ex5ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fjmWFd7s4hhKWXR+iImDvYo25dVQowaP5yoBEZaQpPA=;
 b=iRGv79nevKFPj/U1R6zX477bYZuCTCwdn8kdT52F/Thf85kBFNUnO5AgRiGRQBknLhsdGqXwO8aQTBSoeHDgupTXV2w+zQgl6/wDlzJRkqhTUPeJxAUiTq8CyV/NUQrX6mkEZFyUKNi8OGzGXfY0vimg0N3MTHdEM7RpdaPsOPN2BAvW4PrPeXPjJDVVqpakrzczXrCfaRNucM+wwFVq+TfPJICdEinKpYoih/4Rko6tm09J98NQnk0dJXt+no9yuu/4NA+XCaDP27qoXvOWsg5BbLfMF6A478S3tgF6bgAcN+RWFb/FlI1JaajeyLSL4O9yqekt4BwBsB3QZxvwvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com (2603:10a6:10:22::23)
 by AM6PR04MB4325.eurprd04.prod.outlook.com (2603:10a6:209:47::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.18; Mon, 14 Feb
 2022 19:30:05 +0000
Received: from DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f]) by DB7PR04MB5050.eurprd04.prod.outlook.com
 ([fe80::98e0:cb7:30fd:254f%5]) with mapi id 15.20.4975.018; Mon, 14 Feb 2022
 19:30:05 +0000
Message-ID: <393ec81c-52b4-842b-1ecd-4ffc29743665@suse.com>
Date:   Mon, 14 Feb 2022 20:30:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC] CDC-NCM: avoid overflow in sanity checking
Content-Language: en-US
To:     =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Alan Stern <stern@rowland.harvard.edu>
CC:     Hans Petter Selasky <hps@selasky.org>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220210155455.4601-1-oneukum@suse.com>
 <a9143724-51ca-08ea-588c-b849a4ba7011@selasky.org>
 <87v8xmocng.fsf@miraculix.mork.no>
 <3624a7e7-3568-bee1-77e5-67d5b7d48aa6@selasky.org>
 <YgXByzVayvl3KJTS@rowland.harvard.edu> <87k0e1oory.fsf@miraculix.mork.no>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <87k0e1oory.fsf@miraculix.mork.no>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6PR10CA0029.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:209:89::42) To DB7PR04MB5050.eurprd04.prod.outlook.com
 (2603:10a6:10:22::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9a4964dd-dd95-4838-1866-08d9eff06719
X-MS-TrafficTypeDiagnostic: AM6PR04MB4325:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM6PR04MB432584BE37403D6F0DAB53F5C7339@AM6PR04MB4325.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x+uwwxPd9FTAQPRTc2PxXBbuyTrRBx2sHescYTW/NJFxIrksEFLIUy6yHbPP2t1Wio9nKyW7l0qL0RWH1A6UgQ4NRcaaC7LYwr+jj2KzNOCFhhvCj4JddLRJyhtwEaTaZuhXRxglWg8N8oBK6Sc642FP2l9FduDMQeSUQpxcPfiOahyb5ohLyxvDUXunz21txM9KJ2Mr0hJpMHImAabmITQE3zRX1p+lMblOajpUcCbMfQ6sK1HQLA3DBZ7j4eJgxgd5gmqg1hWvcrfBLGPuhc6L4t/5YICbeQezNv8c95sIylWkQuUTFoL/BPFsd97nyzcarWO2z2Z6Zr4jKgepS3exuLDEdyd/LGKFyRqn0YN302j3JieCr7FG+gNe/LONwDa3UBPag4D4o3uF7eDhkjlWZQJz9SipXtmYGFbplxvdZIB3V8Mmg7+hDgwm5PzvhyO+BcAofti+yFYPVyduWmCO0du/521mYAUoew7ylxj7pjcwM9DRH6fNLDcCjNJpR8Pmgtf0c3pmB016ewo1sP6ySCk2tF4kPl4hV4v7Cwq51busR/lqDz5AQ7opb+wAyz8pnRG+evoR4NXkhSbldrqhJmtjsrgzL+LD1NUSU6kdBcml8PRTFyAeQFy19/qUerh77QpUR2vKqHOkt4d1wdBqHcN9uhn36zinFWIUyIpc44hnNz0vAQQZkRD/TR7OqcMA27qgmUHLPuyWGT4PLSjSx97/3EVuK2KWTXfp1aM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR04MB5050.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(2906002)(36756003)(66476007)(186003)(316002)(8936002)(66946007)(8676002)(31686004)(86362001)(31696002)(66556008)(38100700002)(5660300002)(6506007)(508600001)(6666004)(53546011)(6486002)(6512007)(4744005)(54906003)(2616005)(110136005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sAASz81deDLwVOOO3eRbfP2Zr5fz/YacsrqbASGQPo8uNTYFKkuSb5NZY4qb?=
 =?us-ascii?Q?TlGqeDUBPxpB/hklmfFJvIkLxRzKxsN+C5zioMPQVsRjBoyMsmYE+OncQAL0?=
 =?us-ascii?Q?cwPZmQ2lOhZIvz2P8bpaPaqKvEiVgXf1Tg2qcRnElnBHhxotc7Pt/ypL9lFg?=
 =?us-ascii?Q?PlDhHxemc2OgpLzdYCwXXWPADGbu7rO19eauHwbXQIXKldO0wSvx5X8f6fag?=
 =?us-ascii?Q?7L02MzUHPPkOXfGHoIzSonq0S6PxioKeDmWYB5p+Tfy3gofaYBrRHkZpaNog?=
 =?us-ascii?Q?J5FSVSrqcEVTJ32mlD2g2Tlzl6n5UcHWfkj8FUqrsoWbmTMNIBg17D+wc+8e?=
 =?us-ascii?Q?z4XSwkCax492uwJcbBTCayW+PcFefngab6CW75IAUruv0St7nJADfIH/FBtf?=
 =?us-ascii?Q?osOg3JpJ5HkKBdlcxMAKaqaIySR+b3VmYJMO0dxvtcGjqejrKzvAEWNnvl7Q?=
 =?us-ascii?Q?AkHJzN12yLSQuRrCydKQ436SxsrTI8nbXW812QjAkxo1jbqcZEauyROnbY2R?=
 =?us-ascii?Q?5GNh1m710dgEhAVFhnixGRG9E6E82bwkYwt0GgjVyFvaZlhpljT5PHhlEmXn?=
 =?us-ascii?Q?sHTwBKXkwvFOgDhLJZJbzT8DOXFqotaJk0vsF3cKVFVk6le/2JSaC5ZvX4LN?=
 =?us-ascii?Q?n9lm7LriAw1LZivdRbwOn5hs5pxiKpXzDJhiPZX1X4jqWm+FCyQctUqbZ5Np?=
 =?us-ascii?Q?3Qwag4mlWTeG60YxJiUjY0LSF1qq6nK9doNgaEgNPWtQe3h0R4O+w9O7A7P/?=
 =?us-ascii?Q?sq4oFJtuC2bGmtwfX48Wy3/mSs3OhioJeDH+yljuf3iMQoh4kx2VOxm5R4/n?=
 =?us-ascii?Q?d1OfQSo5SKU0IBXYVXGeZ9nT5Lhd0n82gLMyv9B49G7Cq1HekAatST5etsZn?=
 =?us-ascii?Q?xBV3211eMfmcBOYt2dXH9QFtdFNEYo5V6umPtaOEDz6Hvk+0c+0DpMBR35Ti?=
 =?us-ascii?Q?yIfwEHLpVNobZw4YTVO6qdot73X27KW6CLySwqq+fPpd8as3quZD3Kn+uQhF?=
 =?us-ascii?Q?t6+Ad3jv2KbA/G5zP+ihZHOLu+oyyTxKTPMrOI0y2cCcSnfcFodBCqno7ISr?=
 =?us-ascii?Q?/a64jEAtRa5jO04oNm48cpu1j8+juWI8F84A5QLPO8dzBYsI1NzQHg7DAY+u?=
 =?us-ascii?Q?BNHBz3yPnvRSi4/kWJ9PIbvunoG/x3Eb92mhUffDadI56iSTQQ4mZoZiPmZR?=
 =?us-ascii?Q?Bmblc1tkhOoPkMTdj6WmIskMf3mminh2h+PClwZZZXLni2EfFIYImpGExLzh?=
 =?us-ascii?Q?6b770krw03qnD349+EAlSAn6JENzX0BTSwfPA0zMMWGcn31D704je8GjvIci?=
 =?us-ascii?Q?Hk6SzDsb9Ee8uHJWEaJ/cwn1PCpLm1l1SQBcCyHH7pW+48IeyMQmHexlzilf?=
 =?us-ascii?Q?sugy7T5s2OabCCQ0Oit6jAMWZ2ceYBSjo7EAEPiLinNsWJkIg5/+zW9O2Hvn?=
 =?us-ascii?Q?FNPKDO/C3JIlPAJi4oRgEI64pkus+Xf3OdN2RVgLgAu3/zGnOD0cCZYi+WWA?=
 =?us-ascii?Q?SaWURMS3XLi1YaOgOiWZKMNY287JFj5E/vqiuaXHx9bfnAqd5+OLjjOjVsdP?=
 =?us-ascii?Q?M/4gx5zHvpvYiRnGh6+QhnG1URLnDK3g3HvxEhiD71iIlNCCOpbbR2vjtSeO?=
 =?us-ascii?Q?oiq2N/NiFFF3wCSdmd07hXLI+gRtaV+7OpuPFDaMI/OZeqjJ1Ef8ouKFvDQv?=
 =?us-ascii?Q?3piSScPsUl+7+0JPB/Q1aLZMtzQ=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a4964dd-dd95-4838-1866-08d9eff06719
X-MS-Exchange-CrossTenant-AuthSource: DB7PR04MB5050.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2022 19:30:05.3960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LLqqA6h4YROthIofdjnuxvXe2bur8NQpNFMkxsE/CqaqSL822YikXmXVjUwXTkq8bOZAgE4BOb5RpCzJeP5s0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4325
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11.02.22 08:17, Bj=C3=B8rn Mork wrote:
> Alan Stern <stern@rowland.harvard.edu> writes:
>
>
> Only  is that the existing code wants the inverted result:
>
>  	if (offset > skb_in->len || len > skb_in->len - offset) ...
>
> with all values unsigned.

Its logic is

if (!sane(fragment))
=C2=A0=C2=A0=C2=A0 continue;
process(fragment);

rather than

if (sane(fragment))
=C2=A0=C2=A0=C2=A0 process(fragment);

A simple matter of inversion.

> And there you point out my problem:  discipline :-)
>
Do we still agree that unsigned integers are the better option?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

