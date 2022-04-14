Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4232A500970
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 11:13:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241577AbiDNJP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 05:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236614AbiDNJP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 05:15:57 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E2F6E8D3
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 02:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649927612;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MlMey9xYnAFQSsOJ2uTulGHgh8/7c+NyApR2zr+7Z00=;
        b=bzBN6WaykbZUo5fY7HG1E/w29i7TZeLszFrmxeeMsRMI30gqLzwTxFVq/dFk7rk7ql0aVW
        ekiFP08w462eLmT4/csrnCr0EJ+VMJL5BEYNut1ahIChepl0p+lH23EbtqxLTNxuwlVthA
        u2yo8UHBZNl7BadxVTFffp8TWSroyew=
Received: from EUR02-VE1-obe.outbound.protection.outlook.com
 (mail-ve1eur02lp2054.outbound.protection.outlook.com [104.47.6.54]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-36-6ccfoGUTOuWqAoq6TB-BYw-1; Thu, 14 Apr 2022 11:13:30 +0200
X-MC-Unique: 6ccfoGUTOuWqAoq6TB-BYw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MuLZrIteIj5CsMe2TJ1PsK9uh9T8YxeQ4FGIcpMLsVQ/pc/NYhkhfe48x/vkZz2TW0XAmNPs9s07HnoRtCgVTmTQPpgOAbKnPR1cKxFHueip2RsJughl0zmGIG+cFV2a+ZqOKD5oOIO7WVy1b/yLQt1tV+hBbPt5f3DY/bDSyhsqpP10oDZXzko15NSATK1m8ukLlKaDy7gqcstk73sd4ul94HMGVAZ7qGFgW3b9qmMTtwXttNAXflwHSEc/X7PxvFDbdcHkmNL7Dee3Y1bFJp0UCfJpbtWZSAcoZ1hSHHW0sLisBR9J3vcJV8yN3Gh4HLDPIYVDmYcBSYwzy+6P3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=izy5GNUjRqgtpu+RLGypPNA2X4mSeDZ102v4GigUClU=;
 b=NvUzpitx8iT1jM2m2SLnndHGMstAMtw3wRfp2+BnB+Ui2mS+63YS4y2snyGV0r0KZKARqJ5TnlOWGRLrDo6Cfh8fC6tvu7t1YnxPbU6Ihl+U47jpsYlmX+3pbjBJzRFRk6hYZol9YMsaA2nvp11mjj+FnJxEQB1GLnSwW6Nh5kym4DBjVhvd8klKhnMnzDv9nBjWpPiTZltokhpTS3RqRUw311HHBZz5mKvfC5mWaGUsoxak9DvhTi4LSPHnnMwFaawMwOhY3MYKjz1RQhojSSblW3wYjD4DMZ8Myapy2PQ/Bes9JmeCTGyeYTGjnbh4YfKLriPAJqBRd83nDPATHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by AM8PR04MB7377.eurprd04.prod.outlook.com
 (2603:10a6:20b:1de::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Thu, 14 Apr
 2022 09:13:28 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5144.030; Thu, 14 Apr 2022
 09:13:28 +0000
Message-ID: <0ece0ee4-baca-bff6-89e0-ad10483a5f8e@suse.com>
Date:   Thu, 14 Apr 2022 11:13:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] net: ax88179: add proper error handling of usb read
 errors
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Oliver Neukum <oneukum@suse.com>
CC:     David Kahurani <k.kahurani@gmail.com>, netdev@vger.kernel.org,
        syzbot <syzbot+d3dbdf31fbe9d8f5f311@syzkaller.appspotmail.com>,
        davem@davemloft.net, jgg@ziepe.ca, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        syzkaller-bugs@googlegroups.com, arnd@arndb.de,
        Pavel Skripkin <paskripkin@gmail.com>
References: <20220404151036.265901-1-k.kahurani@gmail.com>
 <20220404153151.GF3293@kadam>
 <CAAZOf25i_mLO9igOY5wiUaxLOsxMt3jrvytSm1wm95R-bdKysA@mail.gmail.com>
 <20220413153249.GZ12805@kadam>
 <523330e4-cbd7-62a6-9368-417534ddb0b6@suse.com>
 <20220414082115.GA12805@kadam>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20220414082115.GA12805@kadam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM5PR0502CA0002.eurprd05.prod.outlook.com
 (2603:10a6:203:91::12) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c66fc3e-d974-4997-99f2-08da1df7099e
X-MS-TrafficTypeDiagnostic: AM8PR04MB7377:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <AM8PR04MB7377D292E9A87A6026F26F72C7EF9@AM8PR04MB7377.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oQEiH2y5/vH7Lj0RnXXKJflWx/fXIasWhRKb+9AQBEmLu9DArRAeY63qhygYoczX5nzHT3RgzLtB3SUvcy+oz2x5he+hoj6SjXSEdg2Vp+mx4OMSH0lco02NaAprDp4Mvi+REvuRPviPhOd/9vIDHMnX/pluS9opJ6/taGqEy4NGlkbYb1iILmDaao14UBi2a5g0bVaucg+bd4u123tMOvURbuXxoVxBhr02XfKVj6+lzuclCfOggDCi4/mPX/IXWc+lXL+YzUznODhNXdNt0j3ud/+sWp/cAAsbWtHOomB/0JM/2sya3TUA1ipoc7ZOFcCbq781sL4wM2fxfUqSzJCr9NnnNoiwM0tmkdu9swgBwqwi9ZR+oJ+kBfppZAxEZ2dJWtMGNNSLnis8dH0oyPcplnoEQV7UQTD3nsNjQpqHtSpPtwmnAZ1aSHfWRDZ/IZbaxMD0qsO4hsZSMK+U+EUEvFnXSYv0UOvUfASxkI3cRybs0FRGuEs72tKrJtAwP0MGOhsdV4+eeHLcH1N8USkw9fsnkNlxYWmj5YGbqMk5zM3Y5c4XjLdT9OkvSvLF5XETeLwNcTRXWHIs6SjZ+Y9r1J9GOuXmAotGnYgssbD4MobieMziKcwPf8oVHJBsyOStzZxG5s4co9IMcSo86fVD0ovnIe4f9QLPvm1eFE3MgZaCZcb3gvTn+HFVs57cT+ZBfwtarCvekfjfGihJngV3FNytpxL7mWkBzSpa8BY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(53546011)(6486002)(4326008)(8676002)(36756003)(31686004)(66476007)(66556008)(66946007)(6506007)(2906002)(8936002)(6512007)(2616005)(316002)(7416002)(508600001)(186003)(110136005)(5660300002)(54906003)(86362001)(6666004)(83380400001)(31696002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6HRBIh6EEzGjN4sAyWY939LuMJWtBsypWubRZYvZfPC9Hh76swx0EyWLNLeI?=
 =?us-ascii?Q?4kJf8GTbLBPzpYVHFJu+YjmkT+DmLsjCC6Ns4KjnRWKS0wQrfy91vsdXWTFy?=
 =?us-ascii?Q?6uDIw3UTzqzeKwUh+UIkSZzwR0QxQe6RworTEMy38CSwhLd5boOEVaXyjSNl?=
 =?us-ascii?Q?aICfSWoqasdsyjA6cyvzg5jt0a2WBBUFdvrV4WfUxrgJ+MzzDmWjswz5o2wy?=
 =?us-ascii?Q?OXRNA8Z2T0kvkOxtxz7nAa2vAeliPTgaPSksQ42xDjNa+lRk5NRXw9aDuAa1?=
 =?us-ascii?Q?Ej/s04HKo8bvVikhnAKOuL4P7PzUOU0j4kCI6Z3lDrLD/cTih7atEPWYKPZj?=
 =?us-ascii?Q?0sFXsfPGHIlSef4fH7GFlUudbWVr/NwAUCoTxHBM/o68BUpJR4IvSNqm15ze?=
 =?us-ascii?Q?pBqb11WHCJDb4eROTqE0+bG7YRVDSUppf5rvuRjyNd0iBR1cm4rrf3rxstcc?=
 =?us-ascii?Q?iMRHiNRrN7f6iPZ3gne6e+q0V6qFAjLkkuF2beYJdJjaGNvWXwMw3kGxZxOM?=
 =?us-ascii?Q?k8+4vLKYplYJWmsfjIOd+ABnz3qiFPvZPytHGg7K8UlCqwlQmc85wlwcBFmu?=
 =?us-ascii?Q?q+tfqlrwLdfVWKU8k34LxloKWXiyc3qJEMndJBnb83xFwmluxT+Tha4PGhki?=
 =?us-ascii?Q?7pq551K6llGvF3S3ziBFl79hCQIAWTc+wQ/LgENdp3vQm8qao1ZlewrA30fE?=
 =?us-ascii?Q?yLORkj6eNeaOOYpE0SnFghbVKPhw1fYylnMqVCQr4FxOPbPgtS458MsZQNGg?=
 =?us-ascii?Q?rK9qH2rmHuCSdGqrLkN45Cnpl1X+IbFm9M4Qwu6Tdl9I9kkG0GbZMYFAf1yJ?=
 =?us-ascii?Q?ReROJU28czuLvCQBPG2ZRHvB7KrvraEV57b9ne09m+JO8mx8EwMF8LF/3RML?=
 =?us-ascii?Q?I6ml4KGAMSnHaR9vdwlAYXP8X4cRf11l+Ek1lJKjpTGIzWyyAEGdHUIeI1G8?=
 =?us-ascii?Q?jpaKTvQUeHGDexW/ZqXSJbYNCpC1rF74r9cAohQdqXVB+7Sj7xgfPX3Z5F83?=
 =?us-ascii?Q?uwQIr5KJt5MozlVWr8smoZzQyroztjyMBnoBvL0Coc+qg8yHlLYFRIIBMM9v?=
 =?us-ascii?Q?IVWFLn5XgZu2zAfN+d+UYNb8+P/KWWYEfxbGEOloCzsVw8J29Vf4zEwBWLQx?=
 =?us-ascii?Q?iZ876aNWrPW5+R6+eaGpbyEwUCuf+1o918YwSnI/L5Z1xVrUvLiYjJwnl/Le?=
 =?us-ascii?Q?Hgf6yq/tnDzAuLtPS9q1ERYWQyBEt3MDtZ5tN2p3eigFN9MVNRFOeYxczVUE?=
 =?us-ascii?Q?7fYQrOjER7jIY1WTsJoEyAJnT11i7VX10+ODs2Zb/u3v/PUpxDM3N8NYHWVx?=
 =?us-ascii?Q?L8fAAna0d4oN6vZljPx0sl8bmk03L2SJOm15zjrAH00anGuoRaUoJfjQUpHh?=
 =?us-ascii?Q?D4fmEZfpCrjz3a3GACzXnHTfWovc4suzSXvlaLK/42x0IThyX3MEM6bbxLKu?=
 =?us-ascii?Q?yfMsa0Q14cMcgyhjNjjz1yjVsP+mhUWM9Wo5PhJv3CBn3oNffshwnRG1IPt0?=
 =?us-ascii?Q?dRLbdSV5ZeYI+aFnRkqcH9G8BB3hYF2QrWN/KYdkqpXsz5jGOyP9U336kZus?=
 =?us-ascii?Q?oqoRRwCHpwTkYA26c3U0U0z2qA5WVe43+7BQh7LLxbvWQ7t0UUG2DbtM02ox?=
 =?us-ascii?Q?2q69+4BnldmLxpdbL0Zr++rqaMDU9VjZtrPifZn7iJcT00IkrV4J5DJSyjrU?=
 =?us-ascii?Q?vC2qlCZGx7HielXGaMQr48XcNxhZkyYxJLBy1snS0BG+qQFMQ6mY53UEUs14?=
 =?us-ascii?Q?iccWU9RKRuQGZiCrLqhvR3BU+Afxl1eHnczj1xSOSvC4fu5a+FmTtxITiUKA?=
X-MS-Exchange-AntiSpam-MessageData-1: gAOi9NJtaEkttQ==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c66fc3e-d974-4997-99f2-08da1df7099e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Apr 2022 09:13:28.4050
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wLq9x1l8YRsQb0dU38EYSG4r5rSCvry03IvYF11LYjVrBdQNi7JMm4isqYg7bGIxiEzG6FCoqD1fAEl9xFtaxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7377
X-Spam-Status: No, score=-5.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14.04.22 10:21, Dan Carpenter wrote:
> On Thu, Apr 14, 2022 at 09:31:56AM +0200, Oliver Neukum wrote:
>>
>> On 13.04.22 17:32, Dan Carpenter wrote:
>>> Bug: buffer partially filled.  Information leak.
>>>
>>> If you return the bytes then the only correct way to write error
>>> handling is:
>>>
>>> 	if (ret < 0)
>>> 		return ret;
>>> 	if (ret !=3D size)
>>> 		return -EIO;
>>>
>> You have to make up your mind on whether you ever need to read
>> answer of a length not known before you try it. The alternative of
>> passing a pointer to an integer for length is worse.
> How is it worse?  Can you give an example, so I will write a static
> checker rule for it?
My favorite example would be:

int usb_bulk_msg(struct usb_device *usb_dev, unsigned int pipe,
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0void *data, int len, int *actual_length, int timeout)

The actual_length parameter is horrible. Now, there are situations like thi=
s
where this pattern is unavoidable, because in addition to an error you
can get a partial completion of an operation.

Do I see it correctly that you would prefer this pattern even if
you could report either an error or a result in the function?
> There used to be more APIs that consistently caused bug after bug where
> we mixed positives success values with negative error codes.  We
> converted some bad offenders to return the positive as a parameter
> and I was really happy about that.
>
> Another example I used to see a lot is request_irq() saved to an
> unsigned.  These days I think GCC warns about that?  Maybe the build
> bots get to it before I do.
>
That needs to be checked for.. In fact while we are at it, do we check
for integer overflows?

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

