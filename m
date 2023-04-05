Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3DF6D7938
	for <lists+netdev@lfdr.de>; Wed,  5 Apr 2023 12:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237330AbjDEKDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Apr 2023 06:03:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236884AbjDEKDt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Apr 2023 06:03:49 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2112.outbound.protection.outlook.com [40.107.244.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 685E990;
        Wed,  5 Apr 2023 03:03:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gwj6xO0XngKVhLvlhRTtzoXZy1Zw+Vi+DYj2QnK5xjtIehQ4ye75/QzvdFXmhgHfKgovlPPoSKF+sMKLzcFaRuanu6kBhbkdipZfOdzyxTDo1AdevkFd0NrxalF7Zr0tVi1MxoilYtHFfhhQpjAREwdN1GNycAE2gU7yWcO0ftseZB15zKon98cIhmZZFHTrUYBv1i55aHE4Z8LZv4Y/5YGWvAqrV73ghuSr+FlVMMyf3gPPVUriXbZLUfmsqx44TI5wg6wErn+fkTmCymsh0+g0t9cFMWwGflnkyHrTLM9uNzs/ZlMXq97SyyPhDQ2IJk3ylfwb4rPL8TtE0PjCgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N8L6wvjqPdkcpzSpSIQ1wFu1iP7XSc1vE+ot8JyUwBk=;
 b=i5zD87X5mE1m+i9tUnGPZ7erXLVoek4/MDNUYfHGIBVXi+SgD0vSUveF6Nf1CsHTT2EkKmmJ4A0glr1xy16l1ycnQ5Ftj9f0L0KXoqbRjt8brnuIxKMzkcFpXcifl3OHzzUEiAtVIRv7JoIhOWjgqeu0aSwmAnsmwEhyZOWdaNydLlTMQAbfW7PCUO6U+f49tD27HlLYmhZVQWB1++FwJKmWLUrbZUwoNk70U4yRpZakiyLmLGDpzJat3y/dVbKDau2jmT8hEuY9GFe0vTXZIzHCRATXTFp6QwpeF+UJU4WvP+EpSc0RgEMJz2ImfLygfiGDz3bMJS6SZu7fvzLiMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N8L6wvjqPdkcpzSpSIQ1wFu1iP7XSc1vE+ot8JyUwBk=;
 b=Q5Gwptmuz7UauXZ1sNLJ2CSctTTTLUuBj/KgNj4ZMpHSsYXHHhaf64rKwWpGpF/XtWDzhSYiQE7i325cdqOyWzA5C5rObHB9JZOShlBZdJnX/8y66DJGJjr8JiHUaRbrzIvUSKzjjLmjWfIPvOwJQsnzvmUO+4xts9U2g+rAUTw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5761.namprd13.prod.outlook.com (2603:10b6:510:118::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.24; Wed, 5 Apr
 2023 10:03:43 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::c506:5243:557e:82cb%5]) with mapi id 15.20.6254.035; Wed, 5 Apr 2023
 10:03:43 +0000
Date:   Wed, 5 Apr 2023 12:03:36 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Chenyuan Mi <michenyuan@huawei.com>, isdn@linux-pingi.de,
        marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next] bluetooth: unregister correct BTPROTO for
 CMTP
Message-ID: <ZC1HeIAMhrN7NSHz@corigine.com>
References: <20230404015258.1345774-1-michenyuan@huawei.com>
 <ZCxE2zHwezg5DyjX@corigine.com>
 <CABBYNZJmUfCqyn_+12s8KA0rRE0g_cv=hSKfj7grP58-g99y3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABBYNZJmUfCqyn_+12s8KA0rRE0g_cv=hSKfj7grP58-g99y3g@mail.gmail.com>
X-ClientProxiedBy: AM8P251CA0030.EURP251.PROD.OUTLOOK.COM
 (2603:10a6:20b:21b::35) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5761:EE_
X-MS-Office365-Filtering-Correlation-Id: 3d347d42-3251-4391-88d0-08db35bd098e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L4/jQSn8c3zqQnMToOcwNYu1FpCYMBmUb5kyn28EP9eYNM35zsKE3jZcdCgD2KOR1Gx7TxyfYifV9dZNC7OUYqo4NTe3706a3q03Q9iFpIPIi6J6HGW4wiF+oSyDWLW6v74IQjxGfpKiYqAWc6LKiD9P6ZlUvkCVxgTrDBaY66v2JfYtKMV34YOlHc1+9lDTCheqvIxKv2QO0s8FMp+r31560FmfRs90+q3NjMPQW3EYpMN/CH5fUXHqpDpIRO//6o+mKB0G7F8Y5VvgUs/UuqDHW+d5oiMmnHRHU/PXmfNsV8D01yTrAoaSdZqZENLFdoRSjglsgR7bbcmL0dB31cj2D2KEl1PWqNxBfs4R9kFw71eTjV+/nOtt5WixYnGWamYwiWkxNbkDC3NDou8ERy0JXmnAVNAjvhh+NwKUgs9jj4PzzyBpJcXToDzsH8W9Kt28imrXCj69tPkQ34LWEWlmmJnXpyXnBgzxswuJL19U2fh8vn8E6avpXp5153zDUvWbtc2knLtfNgRsXbEcdOHWt3KtXNO/UI+emVPWs3FFZJ4xf6gI4nVoji8YueZf6pzt47pjXuu0Geli2zUAPWh4l7LtFk2lJUCr1Y0mavw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(39830400003)(366004)(136003)(451199021)(44832011)(41300700001)(66556008)(4326008)(66946007)(478600001)(66476007)(2906002)(8676002)(6916009)(36756003)(316002)(5660300002)(38100700002)(86362001)(186003)(83380400001)(2616005)(6486002)(53546011)(8936002)(7416002)(6666004)(6506007)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TlVWekZqcWlXUW80Q0dXMmM5YW5ZTlY3N0I4SU56YnFtSWZvWlBzZGpTZy8x?=
 =?utf-8?B?UG5vaGczWTE0Tk1WY2ptcFA2N0lhcXN0blNJa1NkSmFqKzFwNlRIQ0kzSWNq?=
 =?utf-8?B?NzhIWUhMU3dCaXlJR2tJOHgxUkdQcjByQTg5QWw4RkY2U2xJcVhnR1pIMDM4?=
 =?utf-8?B?a2ViazV1T2ZhbEhaN2k0cUxHRk44VVA3bVhyemM1RGxwWVphT2M0ajUxanFR?=
 =?utf-8?B?VzlXZVdDb3VZbEx4WVR6UjFFN3d3VDZpWE53MzQrUzVBRVI5QlFkZGhEN2RB?=
 =?utf-8?B?ZEUyR3JpRFhybEdNeE43d01OUURJSUdvcG9JRHRaLzZiU2RiMyszL3VnVGpo?=
 =?utf-8?B?MmxBZHpCUmg0L1FNWm44MVhyYUZORmtMVTNvZjE4b1ZnWXZQZ01rRzVhNHZ1?=
 =?utf-8?B?S05rdmZuWERzWEF4NzlDcnBFcUQwb28vc1pmUThiQWJiT2hUYnJ2R3JDcVI4?=
 =?utf-8?B?dDJnRHVpMDdRWS93SXpCK3N6aFJHQmVQVTh0ZWxXYnVYeWM4UkVTc1ArLytD?=
 =?utf-8?B?alBCZHhzTkl3L2VUTUl2QWZ5cUpheUJJYytHOTNoQkZiWkpJazVRaC9EL3B4?=
 =?utf-8?B?V1kzWkdMYzlmejcyL0lOZklRVFgzZCtjVXFYOFJLMTd3SFdaZ0hXU0ZIdGpj?=
 =?utf-8?B?TEZoeVNqdzhZV2lEQzBybGFMcXRrdkFWSHBrcDVFRUFoYTQvQXhQUlhCT3lk?=
 =?utf-8?B?K3dYYVJzSzNEN1owY1NnaDY2eVVZU29IdklzVGpDNnBuekVudDZaaXkrVVh4?=
 =?utf-8?B?MHM3WGFNaDRCc2RrVUVFeG5ZVzAxRFdhWkpKSkUrUDJvaTFxek91c09UZDM1?=
 =?utf-8?B?c3ZSN0FkaGNSZWg1Q09mb2NXU2xaQ29jNm0zczFjR05FVkRISzFZSC9RMlll?=
 =?utf-8?B?R0VwVkZjazltUFlFd1UvZ3YyZEFla2N0MXMzdWk4cm51blZVSC85amRHR0l0?=
 =?utf-8?B?TWQvOEtNMDNndGM3MUQzZE0vdlNIRGtqRmlTbWNEMFBkelRibC8yUE5JOXJG?=
 =?utf-8?B?aWpnYzE1ZW8zOG10MVhlOGMrY285SDRNS3N2ZS9mY0I2aC9vK0ZoYmt6OHRR?=
 =?utf-8?B?NmRhc0tnZmI4R25jWmJZQkpJbld5ZHNla2JJbEJJUndNRkF0YU5kRHJDTGt6?=
 =?utf-8?B?QUhOSDJiMUVqRXFvODU2OHZYNjFFZjhpdDFyM2pwbXpCUFczanQ3VzVjYStj?=
 =?utf-8?B?V1Y3Q2c3akdiQW5WSzJ1TEwrcDdFclROdFB1RllJS3pwekxFWFhYME52SGto?=
 =?utf-8?B?Y3VPRUZLQkFtY0ZKejFwNkpmNk1tMG1Cd1ZaRGFSL045V3R0VGx4Q081SEJy?=
 =?utf-8?B?dEpTYjlmbWc2RzRDSjJobmpxbFp3SWtGVEdCbmNDSHBDMWlOVlNPSloxdU1L?=
 =?utf-8?B?L1dRMFZJVzJMN2NiTm1oa0VNQ2xYTEhUVHZmWmpPWXZpM2xpMVp0RmQ1Qmty?=
 =?utf-8?B?L0QxTWFyQXY1MHFteTN0blgxcktYSG9lSTlaQzJ3ZVRnZlQ0dmxqckdqZVdJ?=
 =?utf-8?B?MWF3UFB5YnRpVElKZjFhSzVBTjlpUFlraGhPbi9FSWFDaEp5UGIrMzRXeGZZ?=
 =?utf-8?B?RzNINVRaYXlYRTBGWmw5ckRzVzl1bEhoclJMT3p5dndsUUNTWG93QXNYdTJM?=
 =?utf-8?B?Z1JBU21jL1VnN2dOdGdsWHdiSk1zbC9NUFUwaW9KUVRVVU1CdlA2T3lQTThD?=
 =?utf-8?B?VEdsZnpwd0RyL2hjelQ5S3N4UjFDR2hzY2VQeHFkcVVwSUtCZkRvNmhWMW03?=
 =?utf-8?B?RWg4MUk5dnZvS2RNLzlxTUViUVh0STd0TC96VXZiTmhPZERUVzVSRjNBSTdh?=
 =?utf-8?B?WXVXYmhtSE1tdUJrTGxVOHZrSTJSb2VJak56NS8rdWNxKzBUNW1zeE5DaGkr?=
 =?utf-8?B?ZlpLNXNRMTc3MnhkNW4yeVhSajNaM2xiTE53UFQ4QzlLVTVGMFoydjZCLzJh?=
 =?utf-8?B?TFB2cG5pWndzZGZvaVVEdDIxU0JOcEUrTFY4bGtQYVVwMFhEOEtrUHF6UE9R?=
 =?utf-8?B?RFNwY1FZNlMrQVA2Qndpd1F1dm5ETjFHYkRUbVBnOFU5bmEySHRFeGdMa2VD?=
 =?utf-8?B?aUMyVkZtbHk3Qnc3K0pQaklrVzdhRFJEL1JaKytYbG9ibkw5NzRkRzkydGZ2?=
 =?utf-8?B?N1Y2enViRjcvQWRhZUFZeGZKU3FyZmxaSHRiMGM3aGhVZVVIUkdjOTZKeUFJ?=
 =?utf-8?B?ZzFuWWQvaHQwbFo2YmNpUVBSNzZRczNyM2t4KytpK2JjcHVTbmNuZUVJWExB?=
 =?utf-8?B?UTFiVit2dFRXbjZUdk9XRU43c1BBPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d347d42-3251-4391-88d0-08db35bd098e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Apr 2023 10:03:43.0786
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KjoCB3j2cq05bQ4bmlwT7C4MZBzB6OCJZu+zQ0O7b+gfBdKOxO7o9UgbzYb2Tban89d2mhj9zBC4towjFogRo4/zGwyU5IoxVW0gK33OM74=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5761
X-Spam-Status: No, score=-0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 04, 2023 at 11:24:20AM -0700, Luiz Augusto von Dentz wrote:
> Hi,
> 
> On Tue, Apr 4, 2023 at 8:40 AM Simon Horman <simon.horman@corigine.com> wrote:
> >
> > On Tue, Apr 04, 2023 at 09:52:58AM +0800, Chenyuan Mi wrote:
> > > On error unregister BTPROTO_CMTP to match the registration earlier in
> > > the same code-path. Without this change BTPROTO_HIDP is incorrectly
> > > unregistered.
> > >
> > > This bug does not appear to cause serious security problem.
> > >
> > > The function 'bt_sock_unregister' takes its parameter as an index and
> > > NULLs the corresponding element of 'bt_proto' which is an array of
> > > pointers. When 'bt_proto' dereferences each element, it would check
> > > whether the element is empty or not. Therefore, the problem of null
> > > pointer deference does not occur.
> > >
> > > Found by inspection.
> > >
> > > Fixes: 8c8de589cedd ("Bluetooth: Added /proc/net/cmtp via bt_procfs_init()")
> > > Signed-off-by: Chenyuan Mi <michenyuan@huawei.com>
> >
> > Reviewed-by: Simon Horman <simon.horman@corigine.com>
> >
> > > ---
> > >  net/bluetooth/cmtp/sock.c | 2 +-
> > >  1 files changed, 1 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/net/bluetooth/cmtp/sock.c b/net/bluetooth/cmtp/sock.c
> > > index 96d49d9fae96..cf4370055ce2 100644
> > > --- a/net/bluetooth/cmtp/sock.c
> > > +++ b/net/bluetooth/cmtp/sock.c
> > > @@ -250,7 +250,7 @@ int cmtp_init_sockets(void)
> > >       err = bt_procfs_init(&init_net, "cmtp", &cmtp_sk_list, NULL);
> > >       if (err < 0) {
> > >               BT_ERR("Failed to create CMTP proc file");
> > > -             bt_sock_unregister(BTPROTO_HIDP);
> > > +             bt_sock_unregister(BTPROTO_CMTP);
> > >               goto error;
> > >       }
> > >
> > > --
> > > 2.25.1
> > >
> 
> This one does not appear on pw for some reason, not sure if that was
> because of subject or what, so please resubmit it, don't forget to add
> Reviewed-by you got in this thread.

Yes, curious.

Perhaps it is due to the 'net-next' in the subject prefix.
I previously advised adding that, which I now see was
in correct as this is a Bluetooth patch. Sorry about that.
