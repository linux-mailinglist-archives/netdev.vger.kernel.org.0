Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA1D850852C
	for <lists+netdev@lfdr.de>; Wed, 20 Apr 2022 11:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377322AbiDTJs5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Apr 2022 05:48:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377316AbiDTJsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Apr 2022 05:48:53 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9740838781
        for <netdev@vger.kernel.org>; Wed, 20 Apr 2022 02:46:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1650447964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=52PTIztO+gCoFSOMRqnb4ySrtRI2SSdR0EiNB4Tmwb0=;
        b=KLL9H1x2ii08ONi26F7TMu1yC2ybQ2eTwlfgrYt3TorYRevM6vY15usIPI1EVXE3UQ2iAf
        dBhMi124+/pouPqNoWJ98r2UVgEeoiqxtgT7xzYbebUOQRX5tUPcKTvPS4ceEdBR5LHuY+
        qBy68/JuhFhBs8hydl8448vBCapAYok=
Received: from EUR05-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur05lp2171.outbound.protection.outlook.com [104.47.17.171]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-13-Zumsf0OsNpKrC2eRaHyM7A-1; Wed, 20 Apr 2022 11:45:56 +0200
X-MC-Unique: Zumsf0OsNpKrC2eRaHyM7A-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R4/Dzhod1Cx8Yja7QCroPkwE4ZVBh7xmeZcthr5y824TDpHRJd0RxhdT2XSzm8xfqChNSdbKz8GPryZMFfqaEOjf9HwyupDl4s8Roxg4F6IjPWLhI6lRdjnt8wyJ2pHIhP4MMF1DPcI+dn3fov3/FZUJmcjRzgKtb59XTWRZOh98/GLKKo7h7AbyDQJj5oFPrYP2bDuT6FCQXDzwv6c01RvKHyNWtYgH4Vc0wV577S4MQbLQbibaO7+44qI3TzT1ogyYN7eNXUXm2EhP8SYOtEvIuctp8Ry6wXRrw7g7UvyWTiQE5Q89Rsz2Hp5iInQ0jZudch9Funen47uMHl0rYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFGFGeVVEVrBg8Pq8yXsuuheHj9rwQ9eye+isxu7W54=;
 b=fDwYEKAsV54vVrm2ylbjKIOG37Bd6YJ0CVM4tdsoP+FGJab7mCEOgzgOZkzqgknh+LqYXK3ErZlZjtIENPMi2VLn86VvVQ8mWE5spP3TcQ4ijYvHCfgFX2mJYTce0w+mtlATifDUdAnvSMZ25/PtS2KUr2JWjYunJej/Pl1jepcNp6bPcJVXI/MvWZqRP6sHJiuSmNxV8M+Y011cA6/a38Xmi+nRGpivX4YG0fxcBwFaHraWBLg+GhWBQrdn5Qao8Tf4UaOXwj9Mr0wAzBb8bPnVPiu6XVxMK3951UBotyfPYPcHWEWNS8hu5ZtPA+aelPGWb8begamvJcv2IUfL8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by VI1PR04MB4335.eurprd04.prod.outlook.com
 (2603:10a6:803:4e::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Wed, 20 Apr
 2022 09:45:53 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5186.014; Wed, 20 Apr 2022
 09:45:53 +0000
Message-ID: <aef0c568-e088-b897-f8ec-f22cfef124f6@suse.com>
Date:   Wed, 20 Apr 2022 11:45:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>, Oliver Neukum <oneukum@suse.com>
CC:     Andy Shevchenko <andy.shevchenko@gmail.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Dongliang Mu <dzm91@hust.edu.cn>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        USB <linux-usb@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20220409120901.267526-1-dzm91@hust.edu.cn>
 <YlQbqnYP/jcYinvz@hovoldconsulting.com>
 <CAHp75VeTqmdLhavZ+VbBYSFMDHr0FG4iKFGdbzE-wo5MCNikAA@mail.gmail.com>
 <d851497f-7960-b606-2f87-eb9bff89c8ac@suse.com>
 <Yl+utFmKEgILDFr5@hovoldconsulting.com>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <Yl+utFmKEgILDFr5@hovoldconsulting.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AS8PR04CA0017.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::22) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 98c941c1-7a3b-45a9-c2f9-08da22b28f17
X-MS-TrafficTypeDiagnostic: VI1PR04MB4335:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR04MB4335503B6B056F7B181B31D5C7F59@VI1PR04MB4335.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8VWmRWf3bmfa72m/UGa7eDaHr3Vr+AStnYxdg1rWz3cLVzgrclHIvbR1Pg6ZR9l+T0xcOjVyYCpJe/T17nZoKVxWqrVAvcPbJmTxR5prB2i5piGLo78lzLiUYp6q+GVryrIVzKAGPOrzBCewkx1fBIHE6xxGSaehFo8Wv8cKaFo8Rk2QyZld6GuNy9VOYRO+kBnzHaUq/m3Gkvd2RlNlfYyDxpuHpJf6n+BjbotOqHHhmZiyHbRzM/8Uz6adfY0sluJcDL0/avNyMWdInGT70J/zWk7F6RP5z+ncdhCmGgqtMWAGtabQ/jsF/4ryBRnuJAJoicgvamjxZMnS7QBzxmpAzyGSd5C9EvCana63geRF+jXbkyBVNZ8kCk1eBO+1+OmCtltPpKJkw7G6v6WJYlnBD7ZybxPmAQEhDB6jcimyP2X5/fV7YY/cKUzqgX9kAiG/nlbO+L/sV1nVWyPHNuVqYilYYXVmz/WcmgDK2Q2oy3oYOmt2wuc6u2mv9vCEJfHv9UcLrR99pPojj/CDbnMRxWQE1uOSsp8Aiv9DlsmfP0qLaxyH0NRmj/ztlq31BqoREGO2l9M0ynKPcoF6y88mQFnyJyVu0F0tHOGwWUuYHO3p1Ly+dDzsETkmNPw8ZFF3ju7ZfzncHYSzCSFYYusaOyZhWUb1y6K1BkZ9x/qYai8THd0tDSv1QjO2WAchCi3xB6prtB8tspZxmi3O68chmAiTOPbuyGzf1wuAHoQzQGbRP72M64epnsB2M/E5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(7416002)(38100700002)(6512007)(2616005)(31696002)(8936002)(6506007)(6666004)(31686004)(54906003)(66556008)(4326008)(508600001)(316002)(2906002)(110136005)(66476007)(5660300002)(83380400001)(53546011)(6486002)(36756003)(86362001)(66946007)(186003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kw/jG1rHfuOBxKvmV4yi3V5Fiyvn9gOv1lIcYLDJ5tN0GvwG292PteAfxSh3?=
 =?us-ascii?Q?uLi0cYn/kPZcmd9AMVHTPKCp/TRMIbckBv/rqzNhss5FyrZXHPLsLj2ur9EN?=
 =?us-ascii?Q?MLbtMzoDKS3lqw7fpidrgynguVcHD6K7g03NbEGc3wssZpmrzziZ8stXuoIe?=
 =?us-ascii?Q?PCZSuzIH4JGDFpLlOBpo0uoNaTQ1HN+GLvIDNq7SZ/KpKXYLCIBDl6wVUbts?=
 =?us-ascii?Q?QDWEVZeOPEXJgxg3VcwDxECmdvnEGcmvOogKeJvy3mFrmiqivsbZMhTwvaZz?=
 =?us-ascii?Q?Ke44rxb7WQn/iVqTmwloRnvYZZKXQ5DvPF/CBY28Ptp8DCnw2MSEHPDw6pN5?=
 =?us-ascii?Q?795kVBatf35SFEXzCXBoAdhRA3fatFmZ8Cn5W4Eqy7OdM//0d90EP2fkdo73?=
 =?us-ascii?Q?nhzSGm5H22SkghCFL0vLkLjl+FRp9q3Rq3OlBNjYL2xg3NtVrbyzBbrcWJ9f?=
 =?us-ascii?Q?ZH5WoAN3mDF8McboH4yQMtw5ZKnCauECE3IF50tSPHwRro9LVPW4r8+TMJAH?=
 =?us-ascii?Q?/GwsUvV6e23I/Bwip/tfwDocLnmIMY2hvRzgvuVC6nXdfgqok1Exy+HxBIPf?=
 =?us-ascii?Q?NoXVqDIDUVC94TARHZ36S9EGZeFX3xR+rshNd95e1K+mStLPyGBwBtyc51Yj?=
 =?us-ascii?Q?+G3+REVPb1JUr5VTXtG4/wyr8I0oFza5mEeKd2hBEJ+gzh7kxK0ZS6dAhg2R?=
 =?us-ascii?Q?1QT5dFT2QfqSbgD1VBm1ztAp3W13Dl5j99117gjLKbiHIF+1hTpEB5nZEYO4?=
 =?us-ascii?Q?FvK4LH5EmGCH74GzMksc32a9i6Uy9CA9hS16syQcKgTlPD2ioqF5hAxZ4fyF?=
 =?us-ascii?Q?RCsxWmjAQx0X8ZlV6EQnxwh8lMeP4CRsv2mKFNOyGJyTnMONK7KEv3+Gsi1G?=
 =?us-ascii?Q?UxtVDMpNy2oQIYdNP30YMBAjCRluLQdeLrqWJVlGYZsbDm2wsMFKz7iJ68ge?=
 =?us-ascii?Q?PWjavC/Mp5QmxD/TtpxAi8vQqa8ZFJev13bsmsgkdTCY6mLJ89YYiJ395DZu?=
 =?us-ascii?Q?G1b9DQbKSCKjpENGVB70wiLowu82feeYWZpjNUQ37oXgTgOB/8J9h48lLo03?=
 =?us-ascii?Q?Ztj3Puq8afCEWRwjDKuLT5dy30MMoBgHrX6FUQzSwrxT8jEmTEzO2UrolFkH?=
 =?us-ascii?Q?Sry82v1DazLrywKPabEJC7ly4D01n0Y4hFSiHt/9KhWaqSY2qbePpIPxUffg?=
 =?us-ascii?Q?O+YqFCyBBLS8AW4pOWzoGM98ER7UnpuNCTYWZ+fsDmK8BTSH1VPnNzA899g2?=
 =?us-ascii?Q?esTATo+pJr430xJNSbI0GpfxLwgvoWuuG5ROsipcKnU1veMoc7OUYVDq0Z9P?=
 =?us-ascii?Q?hn+ZgHhbWS4xc7heyeIUPbnGiEDABxnEX1g7J0jo7DySMcKRncY1eQwLWneg?=
 =?us-ascii?Q?ybE1dMxKTcrDLPR6h7zQGjQ1fr5X/0+bCpih2PNkQpPmqmojaS14NjUaXNuJ?=
 =?us-ascii?Q?fc0VPb+aoCDSUb2IMP0WcKwXgYoGWysJsWB2EOYLxNBirx2fU7qJPbUUP7mZ?=
 =?us-ascii?Q?WzE4IvUM2g8Oj5brBFPYd2+ruU2s3fIuib2gy1qjJdHOXMSZxMuChhWSnQYE?=
 =?us-ascii?Q?+bWhNrLCxiej5dk40bWGIIXDXDoDLy0lo5brLymflJX3Do349yU2pjdJLv0X?=
 =?us-ascii?Q?OD+6lxdH1zaHhO4LR/nkbq33qO5lRajmj19kiFLvQtmZT4RWhNVVWJ8SSoK0?=
 =?us-ascii?Q?x+tw9FTvgKjwvCl/IMBaboBgyl9ZEiKcCxBYEcDLGaKmdoNlxMOl3x/INS0l?=
 =?us-ascii?Q?LSx5ZVAi+UiE+uV0Du2oEkPQiPOJxaJTIeUNvxiCyImicfqLDm8q2HRBXxht?=
X-MS-Exchange-AntiSpam-MessageData-1: snNBOyMlvP80hg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 98c941c1-7a3b-45a9-c2f9-08da22b28f17
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2022 09:45:52.9381
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1AuBnmhtnMkMmWpGNXobFonnF6Fnq+LZUJQOB/RhsbhvvR/SCI2xdns5OJBsl1dLpTNDi90+g8IgV7VNnW2/og==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4335
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 20.04.22 08:56, Johan Hovold wrote:
>
>> =20
>> @@ -1214,7 +1214,7 @@ static const struct driver_info hawking_uf200_info=
 =3D {
>>  static const struct driver_info ax88772_info =3D {
>>  	.description =3D "ASIX AX88772 USB 2.0 Ethernet",
>>  	.bind =3D ax88772_bind,
>> -	.unbind =3D ax88772_unbind,
>> +	.unbind =3D ax88772_disable,
> These should all be
>
> 	.disable =3D ...
Thanks, noted.
>
> but you probably need to split the callback and keep unbind as well for
> the actual clean up (freeing resources etc).
That is the driver the problematic commit was requested for.
I am looking into it.
>
>> -	if (dev->driver_info->unbind)
>> -		dev->driver_info->unbind(dev, intf);
>> +	if (dev->driver_info->disable)
>> +		dev->driver_info->disable(dev, intf);
>> =20
>>  	net =3D dev->net;
>>  	unregister_netdev (net);
>> @@ -1651,6 +1651,9 @@ void usbnet_disconnect (struct usb_interface *intf=
)
>> =20
>>  	usb_scuttle_anchored_urbs(&dev->deferred);
>> =20
>> +	if (dev->driver_info->unbind)
>> +		dev->driver_info->unbind (dev, intf);
>> +
>>  	usb_kill_urb(dev->interrupt);
> Don't you need to quiesce all I/O, including stopping the interrupt URB,
> before unbind?
If I do that, how do I prevent people from relaunching the URB between
kill and unbind? Do I need to poison it?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

