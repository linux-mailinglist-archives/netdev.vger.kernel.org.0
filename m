Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDC8B4F78FA
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 10:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242729AbiDGIFG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 04:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242719AbiDGIEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 04:04:40 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D6C215D16E
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 01:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649318517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BZywxi4X8gvLc3fx2K6Z2dr8nxNJc6B99yIMn0l1lLs=;
        b=Ng2nS6R/z32QUKk+WZp05hoK8Yg/UD1xmT4lTrF8U+/I0fvzpZmk0sM5/3ak8ocV2JIRj4
        sToBnE7lLX/KERMSgn7RzT72HROt5VO81RfVNRf84AlVp+ixFeR78Rh4DcUKtUYTrxJxq0
        DbKvw1UdnDXZOdFQjuSfM1YXmZV2g3s=
Received: from EUR03-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur03lp2055.outbound.protection.outlook.com [104.47.9.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-2-u17umFqDNHadmA3TNKMecA-1; Thu, 07 Apr 2022 10:01:56 +0200
X-MC-Unique: u17umFqDNHadmA3TNKMecA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrKOREHEvu4FyCWXaq8pBaC19yn4y3Izt3Dc2O9SsgFylUi271aVGnL08Pt8j88I27mOhcwUO69q1q/6mzw1T1DLgQwnFrfXL5HEOTkiAfCMp62YqapI1J+9PrRhXyZwwCmK1I9uwgzg5AnRgKvrrwmgOV1DHwZM3F8IdsdQGZYbg5iI0puzdi6poknbAJKT+7+UZCmRnzjT3BXiQ5F1doH/woy66kgwEZECO1xNJyQDq5Nv0wtTd4SHz4V8YklC/wCPkqngZQqOQOsfCFRWYEsjW4z7H7+indpbIr4a+AxomRSsTwxc9IkChVYOf3LxU5k+pqiVW3HsXxI7bWRByg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zp/Cxh7Kdh9KWenjykU8ITr9puUVLChRwB7HuZ5dynA=;
 b=WzreP261zl+7PB49J26eEo4lG3D2jhYQ+obHTnXpACtdW8VF8wSxvxbzL9BYPluUF0yQsn6uEC9u7/icwQRVngz3hbxz9Br1LCik1ksgOYwOox3vFhAeIzH+2/ovk/uJinFmQSsXkbh8tANIgCvaLRRVo3zf5MH5fvbLow0gvUz/KqDm+IEpFaYS4rkCquOfRWwshXIzVH7teJ6us05epNtN6eT4f/JUEAA9uUp6FXDzKyALgrR8KqNu2bRcxbQ0vYCUmKyDbsycycQzA3ZPuGcRdT49OT3/PNNEpxuHekrWHqlla+7oxnJmwGO+4vvmqM2lOCunlMX6HpcbQQLkow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by VI1PR04MB5629.eurprd04.prod.outlook.com
 (2603:10a6:803:de::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 08:01:53 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 08:01:53 +0000
Message-ID: <8ed7760a-471d-19a2-0a3b-1e0fc3a27281@suse.com>
Date:   Thu, 7 Apr 2022 10:01:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 02/11] drivers: usb: host: Fix deadlock in
 oxu_bus_suspend()
Content-Language: en-US
To:     Duoming Zhou <duoming@zju.edu.cn>, linux-kernel@vger.kernel.org
CC:     chris@zankel.net, jcmvbkbc@gmail.com, mustafa.ismail@intel.com,
        shiraz.saleem@intel.com, jgg@ziepe.ca, wg@grandegger.com,
        mkl@pengutronix.de, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jes@trained-monkey.org,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alexander.deucher@amd.com, linux-xtensa@linux-xtensa.org,
        linux-rdma@vger.kernel.org, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-hippi@sunsite.dk,
        linux-staging@lists.linux.dev, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <cover.1649310812.git.duoming@zju.edu.cn>
 <8b1201dc7554a2ab3ca555a2b6e2747761603d19.1649310812.git.duoming@zju.edu.cn>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <8b1201dc7554a2ab3ca555a2b6e2747761603d19.1649310812.git.duoming@zju.edu.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6P195CA0022.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::35) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c60fd6fc-55c9-4762-b7d9-08da186ce077
X-MS-TrafficTypeDiagnostic: VI1PR04MB5629:EE_
X-Microsoft-Antispam-PRVS: <VI1PR04MB5629A60B46EFB7120A28B0CBC7E69@VI1PR04MB5629.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LHrQKyGre7nKuUslvrKjnKwhMzAl8dMYuGtSB8cEJmplV4qey6crhcLik6Z6wY8VfcPOcsbsksI0M22OnuUDXBZFB7EbyURfEmkQ4PpKX/OBoXKjHoaXTuS7TfKYWe8FuzKE3bjFC0+LVM7i2mzxwzkYNfPi5a4QqBsek8mpLKYkT+uuH3zGaToXct+mHiwu/YZANqrHXwdb7pLPyoODl9h063oBLfGLVKpIaLKbuiKo16Qq7QnTzrFyP/yOshGBL7rqGAScDQTlDiTOCWzN6/WFE4+a7Uvbz7q1969O/3KMmwEftYpqPJsBHbu/dd3rb6QqIWzYUq0vUB41IdKl90fIi5iWiAAFND8I5iMUU4qmnHCaJeaOjvQeGkmFmElX9plhLYXHEt97v2pXoyj/ufej5zTUzpCh2YN6ZEECX3yZXgNfpDIy69Ny0SiFTFV/yIRmXzrOR8KAtD30riLP+YwSOX1dOv2cb9ET6oD5AIi0KbUjKvTZ4QE3uyQ/omLLjpRS88jpi8qYRSWVYgAHIIaiv6dThGfBZuS8oABjHzcWdVfqte59hp+I9LdIDFKz2IOLXwWU9tNbqB31aTHgr8Mn0rJ+SULeoYA+E0vBXPQD/vGbuAi6C1wSdnVtmeFLxX+1yjL5Pg5cWReqjtvaer99NgKBqkDiA7ZlIlGSUgEHkDXBthvQelWXqBlHmuk8cWcm5p8dLZAVhMyU/lpLT4ZbJTs2WL2kz4PMcDX3ZRg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(86362001)(7416002)(31696002)(6486002)(8936002)(5660300002)(508600001)(53546011)(2616005)(6512007)(186003)(2906002)(6666004)(6506007)(4326008)(38100700002)(66556008)(8676002)(66476007)(66946007)(316002)(36756003)(31686004)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?T9SPt2wJrGUHywXJ/sCDf0aK6Xe6Yhg2Jr7+YedWfqMdlpdQ97Q9nieTLi5a?=
 =?us-ascii?Q?MdIrw9Vj+TD50byWNO53xVTEM2VizRhVkO9QW5tTAl4QTjg7D1w+QejVo1om?=
 =?us-ascii?Q?mh+2Ch7Dh+FD0aQlwGJBv1EqT7zm5o7Z2G6VafZzjAmgKV70+Pbi0Z7PtXyS?=
 =?us-ascii?Q?TcdvKRIuMqFRWUe63oY6cnKvbyMqCvC+2EmzdyYINlXf+J19TJzU0z0dc/jy?=
 =?us-ascii?Q?wIKufrMfAI6oP6i4nkXbung3SKqTa1Sz77pSutmg1m5/eptSv7f9guWcMAzy?=
 =?us-ascii?Q?EjpsPTPbUlUhIVJ2qfhgu0XM1V5jV+7GallXx5LpE8et/SF1ClfljBLGcdLr?=
 =?us-ascii?Q?QZQ6Et8kUc4FMnC4EObVhmwcOcCqovlNyTOnYl1B5eCv4oSGCXr2h7FbPaIg?=
 =?us-ascii?Q?+q6HU7OVhiD+oWsTj8Myj45v7eZykW1/R8VXd2bvyIkZx/5LBGF4bG+gGDBg?=
 =?us-ascii?Q?JTChcyBgOzaGFSV1vtTHfowh3T4QFUr+WsyzQ/B7N4uAHYYj0Ae0xMW6xvtw?=
 =?us-ascii?Q?TS2osd1oc888ONad0blb4q94sb5ByjAH1HopMTX9NoAHmt2aGDhub+0QOgg+?=
 =?us-ascii?Q?yQBRGvZJwjYuZGVxUN7geSL3KiZA9knYDDhxyOvJtt1m5zTqv3XcX5vHnjDm?=
 =?us-ascii?Q?Je9Gif8lxfwK3yftZ2+lBmftMlMkITZM1fHbCN+8O8pDO3YISfcOn1Liu/na?=
 =?us-ascii?Q?ruyRM2AQ3CUl/ejMohJPdufuVisAzqVVhiqHTsfSpAr+gKWCTtXEHeHneSzC?=
 =?us-ascii?Q?cxDZ1HIhNRJxmJ9cFMn0WjaBBpBcCRb9WZP/v4WnT2uGXE7Ohw6BWsUFu9Yk?=
 =?us-ascii?Q?qZaoe8yMVwL8EzIb50A7193TbOAjMU+P0Iyj/Yq+WhDIul5iv/+0uQuCBuLE?=
 =?us-ascii?Q?PaGJMnWCHCxBl2SGIZJmtD/Sl0xwC1+xwX76m8I3qqnU9/0Pl9xAE2D/1goo?=
 =?us-ascii?Q?zsQLLsBRtDQWgzllyNEwej2wB/KaqG8Qex7rtDauoGASiQkSVTNsxv/WMfjt?=
 =?us-ascii?Q?uA9IduIT2yyo7xgYGX7KoUON4EEM/cfK/I5h3awpM3HLDp761DypRPDp+RFb?=
 =?us-ascii?Q?ITX21KcwL0odxXN6onVhk3O2HerlOqh9K6d+7XTy1sQTkGiRlUiSwAhn48T3?=
 =?us-ascii?Q?Nr519KwhUuuehapwxU628+oLWSdwGnhHjF2zZDZsC1o0M2X4hRx4LdCYo2d8?=
 =?us-ascii?Q?1oIozVD8lzi5s9ILGSCVhBStFMzzt8Urm8uHeyL5ZvaH094J7e/zlZxuXSMT?=
 =?us-ascii?Q?UYIk4ybG6f5idQuTsu5gRectV+v7m0afVl9tkrbNYp9eOiSv7jEHJfOtiN6X?=
 =?us-ascii?Q?M1G7yINZuIfM97yJGU+JGqhbX4RqmVmNzAFSfh0oxe+g6K9O2aNtXoNseAmv?=
 =?us-ascii?Q?fFBtiHJYgAeozBLZTeDDlsSghjnAro/1kmgrvMe0MHYaWhkwAQtBKci5Nubk?=
 =?us-ascii?Q?PwlQXFXqKKO9+z0W3py9qFOjZYarTOiHQtnK0ShtGmlUYKaP1Sc6hhHqh3e0?=
 =?us-ascii?Q?eyHR/IuHp8yqtWTqI3IMf08BzDCVrHFskYnylYZ8ANDIXr9Z/hBYgGTwxYgo?=
 =?us-ascii?Q?kREIhiEk1oMQ5CYPmoc8hMK78WB4crLuz+hd7sS1RDrVtBdEsj0cgTX0QGTV?=
 =?us-ascii?Q?PtNN1DKH3PSC/u3zXS8Ha3wQxiabxLvmYGOTEwDkHl9du2Qct1eF07O894IP?=
 =?us-ascii?Q?TC/a0bOS1ZzzjwzHKrGa4WypKFRGArmfFmoHi1MY/+CxjrBcr73ZtV/baXG+?=
 =?us-ascii?Q?HWUcPmcVL5IKS4BjGgT0WNvg+Ho82SA2k5zTGmG663RYceOj2VxszbaQIlU7?=
X-MS-Exchange-AntiSpam-MessageData-1: vDNhRNnWoiNPGg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c60fd6fc-55c9-4762-b7d9-08da186ce077
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 08:01:53.1416
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7fjZPmdWT0psiNNmwya64OxxthZhzquIVbI0XfaO0GAVpFvvI98W/ZOpyNQE32g3KnivHZElI3uTsoQufYQPUA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5629
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 07.04.22 08:33, Duoming Zhou wrote:
> There is a deadlock in oxu_bus_suspend(), which is shown below:
>
>    (Thread 1)              |      (Thread 2)
>                            | timer_action()
> oxu_bus_suspend()          |  mod_timer()
>  spin_lock_irq() //(1)     |  (wait a time)
>  ...                       | oxu_watchdog()
>  del_timer_sync()          |  spin_lock_irq() //(2)
>  (wait timer to stop)      |  ...
>
> We hold oxu->lock in position (1) of thread 1, and use
> del_timer_sync() to wait timer to stop, but timer handler
> also need oxu->lock in position (2) of thread 2. As a result,
> oxu_bus_suspend() will block forever.
>
> This patch extracts del_timer_sync() from the protection of
> spin_lock_irq(), which could let timer handler to obtain
> the needed lock.
Good catch.
> Signed-off-by: Duoming Zhou <duoming@zju.edu.cn>
> ---
>  drivers/usb/host/oxu210hp-hcd.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/usb/host/oxu210hp-hcd.c b/drivers/usb/host/oxu210hp-=
hcd.c
> index b741670525e..ee403df3309 100644
> --- a/drivers/usb/host/oxu210hp-hcd.c
> +++ b/drivers/usb/host/oxu210hp-hcd.c
> @@ -3909,8 +3909,10 @@ static int oxu_bus_suspend(struct usb_hcd *hcd)
>  		}
>  	}
> =20
> +	spin_unlock_irq(&oxu->lock);
>  	/* turn off now-idle HC */
>  	del_timer_sync(&oxu->watchdog);
> +	spin_lock_irq(&oxu->lock);
>  	ehci_halt(oxu);
>  	hcd->state =3D HC_STATE_SUSPENDED;
> =20

What is the lock protecting at that stage? Why not just drop it earlier.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

