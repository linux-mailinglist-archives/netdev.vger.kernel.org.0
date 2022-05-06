Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8BE851D2F4
	for <lists+netdev@lfdr.de>; Fri,  6 May 2022 10:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390043AbiEFIRc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 May 2022 04:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389962AbiEFIQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 May 2022 04:16:38 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30082.outbound.protection.outlook.com [40.107.3.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0896830F;
        Fri,  6 May 2022 01:12:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VRKlEj/Zk8xaT+Qib4REb59XdPYKoDxC95GgwLB2uWyAcoL7MAWUU6pDhzAag7G56GMKwParE28Wi9uSJNnL1RcS+3m/NqZNSFmC7qmbNrvR3cRX2te/7HLJ4WdAb1UhrKZXifpGa9TYeNgkThBDaYit+f1YxIP/DlHZi+/KkVRVVAY2zYi+2rUzG4PlpM0kkWhNtqKVF5scFanIBMS5vPR7gh47qeWvSqXWh8NriliHKT9z0mcUFpkYzNk2Ti57G9FU/2LRWM2cOu/r7d3XwtTCNYIDDcBXRdmy+Po4CmOSfnk8dNt3AUMjwf+SvOi+9eeGWqGZENkJmJCKCJ5Mvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Up0AdSSXSWJsAIdIFkUV01dBaHRr8eH4MQPjP4b5sv4=;
 b=k15MFG1KRu+ht7eHHKoNqnoD5wuE5JGYwu/Aov7gMjVhbWryHxIJpRu91JpA5+Qau7ShSJtxq9bspUt6KD6E/066M9lcvMCNCL/A1NMMP89veP6NKtMEGMRRhuHuyZ3cBPxRO9vTreZiV9svuMwBAqWC8iWqINosZr4M+VARYwkr5LVsgqcIKZFFlNzDMYVc9dlWcgqdDjhP6dkqATzkC9DzqqYaRpa/iwgulXR6v5Gh6z+Hp2X5DgaY7LzHH+Y2eIukw8roZ7OkKtIFZFqrWcHZDkp4r1NQ91lP7e4MFFL5hFlaarKdZ6rlpFbRWpM6ssT2nlUK4PQWDnaXdsg6yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=technica-engineering.de; dmarc=pass action=none
 header.from=technica-engineering.de; dkim=pass
 header.d=technica-engineering.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=technica-engineering.de; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Up0AdSSXSWJsAIdIFkUV01dBaHRr8eH4MQPjP4b5sv4=;
 b=jXD2uTV8Mv4Czir6HeZLbt4p7nS9tvuhAc+j9b45F44XoRveHm0hHvNwv7Rj8T47ukvrpqEerBOgXgRyJ7rAMUbiYhSnXAtFQqxstN9O9/A4oU84fxAJ6UCjRx/fEBibMNdMnbNbrFwmQQ/N0+3fa7aIbEwpIIXypw44b5Qe1ek=
Received: from AS8PR08MB6790.eurprd08.prod.outlook.com (2603:10a6:20b:397::23)
 by DB6PR0801MB1797.eurprd08.prod.outlook.com (2603:10a6:4:32::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.27; Fri, 6 May
 2022 08:12:51 +0000
Received: from AS8PR08MB6790.eurprd08.prod.outlook.com
 ([fe80::69cb:2a53:cbc:f90c]) by AS8PR08MB6790.eurprd08.prod.outlook.com
 ([fe80::69cb:2a53:cbc:f90c%4]) with mapi id 15.20.5206.027; Fri, 6 May 2022
 08:12:51 +0000
From:   Carlos Fernandez <carlos.fernandez@technica-engineering.de>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Carlos Fernansez <carlos.escuin@gmail.com>,
        "carlos.fernandez@technica-enineering.de" 
        <carlos.fernandez@technica-enineering.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/macsec copy salt to MACSec ctx for XPN
Thread-Topic: [PATCH] net/macsec copy salt to MACSec ctx for XPN
Thread-Index: AQHYXh7FrCHDrNQm30CdmaZlLiGY560NCZ4AgAMxHoaAADyjAIABDkzf
Date:   Fri, 6 May 2022 08:12:51 +0000
Message-ID: <AS8PR08MB679089E765CDE7A8AC25B5DADBC59@AS8PR08MB6790.eurprd08.prod.outlook.com>
References: <XPN copy to MACSec context>
        <20220502121837.22794-1-carlos.escuin@gmail.com>
        <f277699b10b28b0553c8bbfc296e14096b9f402a.camel@redhat.com>
        <AM9PR08MB6788E94C6961047699B20871DBC29@AM9PR08MB6788.eurprd08.prod.outlook.com>
 <20220505090432.544ce339@kernel.org>
In-Reply-To: <20220505090432.544ce339@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 97b9db33-f582-df87-495a-49c19e7713fd
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=technica-engineering.de;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 57fe9b24-884a-4e8e-7653-08da2f383710
x-ms-traffictypediagnostic: DB6PR0801MB1797:EE_
x-microsoft-antispam-prvs: <DB6PR0801MB17970FB6BE6254B3EC709D6CDBC59@DB6PR0801MB1797.eurprd08.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IYDVibvzjy2vlyUr0YU8tpQkhy+QVVphHgA4kYP/Qw8oVbXxZarSu997YHOKfOtq3/PXKL3NT6HkhJJ0IoXTBrWDmkKCdhrb340isRDIMjhxpnRVkO4hVRpyWwE7Gr9YZhU+qPBB1JJODh18jLGwZx0rUMmkeNXhQ+iFiiXdv1HfdsWFQ5vGNbkfBl9myyS604RXF4sWYB7r5H9v1GrY6P3UU7qNx+sW4liwNMXwUUq/LwX1lbGpMuSkXhix/OQPw/YMK58GpESqwZ2XuCjYWkyx2aF4PqvtyszSdQfiHaVl2S1DKCYHl2LmiyUm2ZPZPot2kiY7WGYt1rY7e0SnyC1QPumcWPc9ZEqWbQj3244wJdHYpoWisyyXNA1RNLyMSZPChJ9ZpVgQbY2H2Ui55WQ7mIiPHBfZnyZ2kil1JgQ9b8X4mmk36JFVg5YtUSXT/zj4UBLUigjDfuZEDCXzlhmxWVLsomaVzbzcmPo4XALkPBWWXP2bsTVDgw5YyGFZtlLFnICL7GignquBL6JE0YlTznYV7efZ+bGjvYkvT6DUXz/L3xIJRcAOGFSixmlnOklA9nXxJ9GDo8VqOOtChftg0CP8YvHwhull8TUM5jyTEqYoKP0hxFHS8f1azT6oqf7sfuZBfPdsf3p5oyO+zZuqzE4IJ4o9j/4ZOiG0ztoItOCRWYpcfSUiIIB5qeOyWVhdPed6mJiHtsY9GmkoQQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR08MB6790.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(66476007)(8676002)(54906003)(6916009)(508600001)(66446008)(4326008)(64756008)(316002)(66946007)(66556008)(122000001)(5660300002)(8936002)(38070700005)(2906002)(44832011)(38100700002)(52536014)(55016003)(86362001)(9686003)(186003)(26005)(6506007)(7696005)(53546011)(71200400001)(76116006)(91956017)(83380400001)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RHXiMs6ZyKL3ytFUcqBnQxoMpCTADy9TpNTFN1ZO8D7kaxQBDWbwnh3OwezY?=
 =?us-ascii?Q?0Z12y45QYpjHdBrjTOvjodlu2TFuVpe8A9KcCCMtOG8st+6fxzvW2ziTenU7?=
 =?us-ascii?Q?UN1yi4hpHlon6VxxRSOgelihRf2H990MoTeon0KtAXepOsRr4TupQUzqex/M?=
 =?us-ascii?Q?dp+EbAr0dba1z5yebdh/AU6f71GYN3RYgoZ103Ak6o2/iTHJwmjP5S3KpsEy?=
 =?us-ascii?Q?zfYRx136ETNAWBKyuc1JC4aLrxTQu8N0n/wH+ORjeK6HwuKWOKqGWecU5SDR?=
 =?us-ascii?Q?03SyWzgV5kywb+dIjFDW75/LcsXfL4OABm6oKg4xZuf+/oSpsrSQOqsPLTEG?=
 =?us-ascii?Q?EvsGYo92ZcnRcwmsJSnFB3m/+v4s6hTydjPdK332cohOUyXda/K2UcUoRCwK?=
 =?us-ascii?Q?Wpw0FCM8liwNyDo8/gTVzKW43b5mxb8eP3A6Y33uq4so2uOzbnccoFHC6a2f?=
 =?us-ascii?Q?gaIGvPAuCzwwrP7Vct+Jbx9ZoQPREpHVooGe8HfohlDu3qKpLx2TZA0K35ul?=
 =?us-ascii?Q?hEgsDLY0klWTl5Oz1qtfzvlUrzTsMbADRUBMFC+8/wOxHoREwuUcJaj+nbD5?=
 =?us-ascii?Q?flEaC968c7IgxWkXszmBkQh8BWwRz4gVTXoMJrFdsLmyR+JTtdZH8q2f/bPq?=
 =?us-ascii?Q?A2q/P9zd4hEJKHWtaNQ66VwceI253rM6s+s+auXY5iR+N6+pZX+VHotyuG5i?=
 =?us-ascii?Q?NeMFI0JyW3XDCZhjE1xwJNLVAtGZl/j/e54MjQBdkKl1wvuN9um7MymUqqOn?=
 =?us-ascii?Q?IPCYZaiM+x3A9sDRRJhnxzmJpz0pm467IeZGR14w9e5XxvYgbDUDos1ldxsQ?=
 =?us-ascii?Q?VD+cyejrrz9/tUjxdO250FwOjcjA0brveS6tWnGTCYe2boZwvbOEFoAUjFyS?=
 =?us-ascii?Q?z9qq04iD9gHEBvOKoRTIf+QwIw42nsbkkKC5vumIdhCcWx1k5XJ9TJnsBQli?=
 =?us-ascii?Q?gL30VaW31nKdP7TWIE2AdgC+0ab2C50+G/zkdPSFss3lEQqMeS4rN+SV0ue2?=
 =?us-ascii?Q?eOmw/WjtTU0HBejtTYfmpPkvaNgG5mrrCIBsiLh4fY69I0CfEmQ2S2tLhT3J?=
 =?us-ascii?Q?fH+tFJ68q7Vc1BJZ2gl3TiKWoFCm9RrPDhbM/FcV8DMTUNx2jqez6W5Kliz3?=
 =?us-ascii?Q?hio0LRcm2+0ixY3zTq8PY6P3RVgMAHQlkz5OeyrjiWGwmPadL580cx0bvXyJ?=
 =?us-ascii?Q?sBbBLyDniufw41C/w1NgsIUOUt8s+UIv02XypqHTCIRhwpqPJhWSUbIvfytu?=
 =?us-ascii?Q?mjDJybcOS7YoCGo6GkY8wjAyzennAFeatn+ANokz2Eu4RhpId1SH904LG1nX?=
 =?us-ascii?Q?EPnjWvMZmfDwrDzf6Kmdl0fk1jpWAP4vA2Lenfzt8t2HUfi1N4F6sEG8caJn?=
 =?us-ascii?Q?LN1vmkMJQgS0ccm/stRQTXubXYZnpESUWbGEa7pZC476wPXSYJ/k7dsuY7n7?=
 =?us-ascii?Q?hXcMKLTx8RfIRanwrPgcQ5wN5ftUDrlYqjE0m3elnVceE+06Bd4OkccanfuO?=
 =?us-ascii?Q?KdI4kxOxLkSd08Oqzn6bkPbnZXlTVphatfK56Ev/jfpG9Sd9cMWmJGXlFzNP?=
 =?us-ascii?Q?dDehcWA61qCuCp7IbClavGoAwt0paEm3FJM81OmkH1kz72Z//5UanQ6a0Cze?=
 =?us-ascii?Q?HJBASlW7MYuO195oFmRcq2P0kW0foTa9fkpJdr9tSoToUcTUA5q2OvBJ/6B6?=
 =?us-ascii?Q?pGlCGuJrmp8g030iEwW+GET0G94VjELwxjHQMZtV3l8sBh/xDPya3gDpfdrV?=
 =?us-ascii?Q?YRaRfVpvIMfHIVH/s/3G+5jwxbbl9xXGfzveyv734dxYxHqikX50?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: technica-engineering.de
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR08MB6790.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57fe9b24-884a-4e8e-7653-08da2f383710
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2022 08:12:51.4533
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1f04372a-6892-44e3-8f58-03845e1a70c1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZTYtyvcMmCIFfXiAeYg7r2XF/b4sJvnffelrMPnB2ordNdt1kXEex4OnYngcReIcJxhjOlyMoWh5AWTVHKWnv0Dg21omaRIlkn2L7zFmpy/aC11ROFFRIqxmF53rb8bvdKboM8I087kfRDovujbhJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0801MB1797
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks, Jakub. I'll create a new patch with all the changes and send it aga=
in.

________________________________________
From: Jakub Kicinski <kuba@kernel.org>
Sent: Thursday, May 5, 2022 6:04 PM
To: Carlos Fernandez
Cc: Paolo Abeni; Carlos Fernansez; carlos.fernandez@technica-enineering.de;=
 David S. Miller; Eric Dumazet; netdev@vger.kernel.org; linux-kernel@vger.k=
ernel.org
Subject: Re: [PATCH] net/macsec copy salt to MACSec ctx for XPN

CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you recognize the sender and know the c=
ontent is safe.

On Thu, 5 May 2022 12:32:33 +0000 Carlos Fernandez wrote:
> When macsec offloading is used with XPN, before mdo_add_rxsa
> and mdo_add_txsa functions are called, the key salt is not
> copied to the macsec context struct.


So that it can be read out later by user space, but kernel
doesn't need it. Is that correct?

Please also see below.

> Fix by copying salt to context struct before calling the
> offloading functions.
>
> Fixes: 48ef50fa866a ("macsec: Netlink support of XPN cipher suites")
> Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de=
>
> ---
>  drivers/net/macsec.c | 30 ++++++++++++++++--------------
>  1 file changed, 16 insertions(+), 14 deletions(-)

[snip]

>         rtnl_unlock();
> --
> 2.25.1
>
> ________________________________________
> From: Paolo Abeni <pabeni@redhat.com>
> Sent: Tuesday, May 3, 2022 1:42 PM
> To: Carlos Fernansez
> Cc: carlos.fernandez@technica-enineering.de; Carlos Fernandez; David S. M=
iller; Eric Dumazet; Jakub Kicinski; netdev@vger.kernel.org; linux-kernel@v=
ger.kernel.org
> Subject: Re: [PATCH] net/macsec copy salt to MACSec ctx for XPN
>
> CAUTION: This email originated from outside of the organization. Do not c=
lick links or open attachments unless you recognize the sender and know the=
 content is safe.

You'll need to make a fresh posting without this quote and the legal
footer. Posting as a new thread is encouraged, you don't need to try
to make it a reply to the previous posting.

> Hello,
>
> On Mon, 2022-05-02 at 14:18 +0200, Carlos Fernansez wrote:
> > From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
> >
> > Salt and KeyId copied to offloading context.
> >
> > If not, offloaded phys cannot work with XPN
> >
> > Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.=
de>
>
> This looks like a bugfix, could you please provide a relevant 'Fixes'
> tag? (in a v2).

