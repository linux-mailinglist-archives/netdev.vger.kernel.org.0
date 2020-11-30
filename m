Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05E6A2C90C8
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 23:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388670AbgK3WOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 17:14:31 -0500
Received: from mail-eopbgr50099.outbound.protection.outlook.com ([40.107.5.99]:23713
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388659AbgK3WOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 17:14:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MvnLEV7F44H77AMjej1kb1nVShhSfOqte02DwA0dkb2WAfGRYOfYSqknyztSVhQ2rjLz+o9ST0segQETrCEbjJgVY8oYWmzb43HCz5zMtvz0+S+g5YWSvy5XT34IXTvZ9B+X1DKJgOnrN+h0T4lY9blhQLXo7SSxt0vsngWEhvSTL/Q4/JUY4qsi7DOOEVbZHQxsZwXcMtVMQe6Fq0w2iGZ+7E/5M9Q5b9PlgSpiNDM6+IcdLG/wgGdKF+4CBejd2xiNdv5VY4F1W6gsn+uNqlaAZ6ACJft+ToWqplc0eKfuYROcev8WcKK4zx3WTrd5WgmDTy1L/xBDecOa5qOgIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6Y1PkSIg4E1DscpTcQzZ22piqRMKH/n5C5J8DjPAFg=;
 b=Js7Q/X5+CnhfvmvPEYWB04tplj8SSLKjvg8b5znt4rud6iPQQ6Rm7lL4yAJeaEFaiRwRFXdqVq4fs3qm47jALK1zzOQx1i4FkGKq0RttadRMzV0PIAs43v0VdK8mITFLaJvN88NSqKkuGm/v9pLgXhys+6AxAKgSXWboQ2qdWNYVJ9wdycJaVmybZTVNdC1qq6QhS1aRFO8SPFilZ3rxF7wNBaDCXVWsnA7woIYMrk0ipekDoqPckQFqFlDmC+VKGcxtn0ohECYnlPqjjTm920UCEEffogmM/HoniXlTOPjKL3QQqrF/SdFoZBz89sTT2tYLaIP3rtqNurSgVmO/wg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L6Y1PkSIg4E1DscpTcQzZ22piqRMKH/n5C5J8DjPAFg=;
 b=G74GutVkVWTGpjNz78/dSUUn1kbHbZQaVOAZXp7MN9OUWM43dFPq9uKjAoNTY271SC1gNXdCpVR+btqQx05pWl9Ji/EQ0qK9kjXcUHDeJvDhDewOR5H+94NwVe8mvT69TT0JepBnDgH5uC7Is6mpU1lUqhvBW6aXDjTl76LyLJY=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM9PR10MB4321.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:269::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20; Mon, 30 Nov
 2020 22:13:41 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3611.025; Mon, 30 Nov 2020
 22:13:41 +0000
Subject: Re: warnings from MTU setting on switch ports
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
References: <b4adfc0b-cd48-b21d-c07f-ad35de036492@prevas.dk>
 <20201130160439.a7kxzaptt5m3jfyn@skbuf>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <61a2e853-9d81-8c1a-80f0-200f5d8dc650@prevas.dk>
Date:   Mon, 30 Nov 2020 23:13:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20201130160439.a7kxzaptt5m3jfyn@skbuf>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AS8PR04CA0014.eurprd04.prod.outlook.com
 (2603:10a6:20b:310::19) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AS8PR04CA0014.eurprd04.prod.outlook.com (2603:10a6:20b:310::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Mon, 30 Nov 2020 22:13:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 43ec4baf-b017-4b7f-bcd7-08d8957d317d
X-MS-TrafficTypeDiagnostic: AM9PR10MB4321:
X-Microsoft-Antispam-PRVS: <AM9PR10MB4321E275B18B78BAE759864A93F50@AM9PR10MB4321.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MTUxV6OfYxg5inMd9tvl6/+8iXfJGPeaP0oGBs8XaO8zgVj0vdpVs/HxaJALOfCGmxTN2zupws7yypV/t1syy5axYuyLfBA6RIKJcOHZSQ0ct8wpFvtt4ZI2d+todYXG94kP5jMjjFOpVG6FdMiBuA0qywCHrTcf7tYWyqWcpBAQNtRVqr+GwCUGwGuCKSRGH56y0tPcMRTOjNPNw+4DbMg9Wi3JOIr3O3V1OHb0RYOh4JxHNwCURYabthq0/XmsjdIrtNZPLewxd9pIpBiYQ17EVkEIfv6BaaTgrRo9rnsvhDOtrAqReUXehQBV/I04zaPfSJxXFlUxEY9QhMaXvrgX6FaSfRP6pvgYCilxMLVUmg/f2fZ1q2YJanXvOVeN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39850400004)(396003)(136003)(376002)(366004)(346002)(52116002)(31686004)(2616005)(66946007)(66556008)(956004)(66476007)(6486002)(8936002)(5660300002)(44832011)(8976002)(2906002)(8676002)(4326008)(316002)(478600001)(16576012)(86362001)(83380400001)(36756003)(26005)(54906003)(16526019)(31696002)(6916009)(186003)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?Mrw5Ifs1h1dXB4ZFYrifH6ZW/yjMBeMtUExl1mpFNG6Hp+0bpLaBXvXC?=
 =?Windows-1252?Q?+cirOXdz/fRUINfsQBIu0DbRzYQ58pS0uHUWSU4vKSOnVEjLtrpjD++X?=
 =?Windows-1252?Q?L9TOpdz+ExEDmfsInaXNV+PIcAUyWazufwV5mmFZ9zPzN+kcSa4+/prS?=
 =?Windows-1252?Q?uCNNbIR5vdPe6TIYqUYuqmooCd7XC61Tzlj3M7wNgkif/NGfeceq45f+?=
 =?Windows-1252?Q?pXlH394UZ5EANh4RdI+HVhhaVhAEyPGpel8s5hmGwtfx0lhot3vQn5Hr?=
 =?Windows-1252?Q?5OFjCHFPmkIutSaDhDHMYzRxkaqtMXjP69s409PVSvNtC85qtF5qegxz?=
 =?Windows-1252?Q?7/zuORdsTTHCwxewqgDSuGHv2ZM//LWKE9XfOx+3wJLZQ6nD+3/IMtEE?=
 =?Windows-1252?Q?GT/kK3wllxyvvI3wamlqt2kot0db1rPMk8Q/dDG7B5VhgMR2xFth0v67?=
 =?Windows-1252?Q?MF5zyQm8+2iZPHB/EqT5lq2vm04jfHqgKCs/GEtI/MKiarILzn7FSTpk?=
 =?Windows-1252?Q?Hz+Ne6C+pBo7lrDPaIXZ5fuGOgU3wqXrmG9ZeyUICfYRh/s8zWKkc27/?=
 =?Windows-1252?Q?qlMx6R8yQOVN516WBdAQ5bIv1zmEx8h8K/OIjJjxCd6rjhPQAqaP7D6v?=
 =?Windows-1252?Q?zAhu8Fg7n7TVzTFpRw34BM7dlAXUnLGXRZ1FQDaqxauAPMdHGZfDiP2h?=
 =?Windows-1252?Q?9v/ypjndxMOgbZ+x1cMgPkLZHyhALpjrbeqgezUdB0/1Szj1rCKiSbl5?=
 =?Windows-1252?Q?KGRfgmTkiMmg+iFdCEtyDl5DPKXJjOXstCJI8klHPwLUdiIIJtOEjJMW?=
 =?Windows-1252?Q?K7M2POIc2/mr66y8SDW2TZVv4Nz/puXdcJKbJO12vfpdgEyPENt02Tsl?=
 =?Windows-1252?Q?rz0CAeNm2PKk72/g5y4GHJfN8HjGpbltCbtKE16BlNcjth263F/SA7b1?=
 =?Windows-1252?Q?R54wtvmaaSvpkUnzMK875gJjAm+ePj9T79HljpsgcRNxFUF3fRqiNKka?=
 =?Windows-1252?Q?xOcSfLcZsgvgUNnvO74kQdo8JfGik14nl2qd3ecUVnyb72iSFGqIJWkn?=
 =?Windows-1252?Q?gyAUkAgvdHrM19gH?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ec4baf-b017-4b7f-bcd7-08d8957d317d
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Nov 2020 22:13:41.1387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZMs7lZsxuZmWCIkNDmwOIclhdbS9GPeqK6FX5YTJLSZZQyUbbIH4a9TmuU8e7MKEkwpS3FPCndVv0fIDD5eF7kXzvRrpqfbokuHKG8wpno=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR10MB4321
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/11/2020 17.04, Vladimir Oltean wrote:
> Hi Rasmus,
> 
> On Mon, Nov 30, 2020 at 03:30:50PM +0100, Rasmus Villemoes wrote:
>> Hi,
>>
>> Updating our mpc8309 board to 5.9, we're starting to get
>>
>> [    0.709832] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU on port 0
>> [    0.720721] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU on port 1
>> [    0.731002] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU on port 2
>> [    0.741333] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU on port 3
>> [    0.752220] mv88e6085 mdio@e0102120:10: nonfatal error -34 setting MTU on port 4
>> [    0.764231] eth1: mtu greater than device maximum
>> [    0.769022] ucc_geth e0102000.ethernet eth1: error -22 setting MTU to include DSA overhead
>>
>> So it does say "nonfatal", but do we have to live with those warnings on
>> every boot going forward, or is there something that we could do to
>> silence it?
>>
>> It's a mv88e6250 switch with cpu port connected to a ucc_geth interface;
>> the ucc_geth driver indeed does not implement ndo_change_mtu and has
>> ->max_mtu set to the default of 1500.
> 
> To suppress the warning:
> 
> commit 4349abdb409b04a5ed4ca4d2c1df7ef0cc16f6bd
> Author: Vladimir Oltean <olteanv@gmail.com>
> Date:   Tue Sep 8 02:25:56 2020 +0300
> 
>     net: dsa: don't print non-fatal MTU error if not supported
>

Thanks, but I don't think that will change anything. -34 is -ERANGE.
> But you might also want to look into adding .ndo_change_mtu for
> ucc_geth. 

Well, that was what I first did, but I'm incapable of making sense of
the QE reference manual. Perhaps, given the domain of your email
address, you could poke someone that might know what would need to be done?

In any case, something else seems to be broken with 5.9; no network
traffic seems to be working (but the bridge creation etc. seems to work
just the same, link status works, and "ip link show" shows the same
things as in 4.19). So until I figure that out I can't play around with
modifying ucc_geth.

If you are able to pass MTU-sized traffic through your
> mv88e6085, then it is probably the case that the mpc8309 already
> supports larger packets than 1500 bytes, and it is simply a matter of
> letting the stack know about that. 

Perhaps, but I don't know how I should test that given that 1500
give-or-take is hardcoded. FWIW, on a 4.19 kernel, I can do 'ping -s X
-M do' for X up to 1472 for IPv4 and 1452 for IPv6, but I don't think
that tells me much about what the hardware could do.

A thought: Shouldn't the initialization of slave_dev->max_mtu in
dsa_slave_create() be capped by master->max_mtu minus tag overhead?

Rasmus
