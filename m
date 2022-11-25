Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 040E26383AF
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 06:54:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiKYFyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 00:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiKYFyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 00:54:09 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2061.outbound.protection.outlook.com [40.107.20.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE3EB1AD91;
        Thu, 24 Nov 2022 21:54:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bv2xGymIxq+dT3A39NVbRbm/fhsq5ghP2s+Pdk+a2pRUvO7RSIJwmSq8Kleu5CRrJ10P6B+4L45ucz27azFh/zUEUP9eyDRBUFNQC4erKQnOl/mEEfuf62n25Y4r0Sr3NKMcs8grIrBid04rO2i4GsTuB1K/4deB4kCoi7rG7Ri7yN+YOs3Hl3WMJh3kjz4f2buUlNmg0YoxBdN/uwO/nvVxtSHvbfwMdL/Ke6mooowoWMVHTjXCSLiR2v/O7x2UEecSiY8q6SHM8I5wQ8k8lZ/Onfp6wT7yNjM7NaE6Iwb9NOlSD0wMSOe2hhzTS9KgvdJeyTsG3sYVLu04lFHltg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kEeZ1p+qhMu60B4yw8w0nFCKTVg/bhPZWugmR0S1E9I=;
 b=l1lMzJH49sHqCOtCPYtzaXlpvAytu7Q7senwezrN+kkbHsAhX9GI6I+A96o3Hr0lsdLbMqkHsFNG/+kBWh03KScZqjTl9t851B43J7csxVt+yj0qyu5q/0OoJhAQubnYTXWLlGORczFnqxNGFsZtk/MFdG2ZJVe5Ruxqz4ru2cWHjCh2vRzd8w7ctyUa/1Hrnqoth0Wj7t0XpBIALkRgoIexfnZpi20uyeD0QN7FrDmFpZy0afjv+WSnotXTRhU3oxtqJlUKR7Apwq4wz+L32rFpJinKA208T4t+LqQMT7WoexySiCkITRQFlSq1sMnkAvUCVDjXrH5CVCOhV+i31Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kEeZ1p+qhMu60B4yw8w0nFCKTVg/bhPZWugmR0S1E9I=;
 b=GXLPnmJuNTFH1FurUkhNSKBwN3fX6WGW/9su1v5JkrahUGq9byTW6l59Dm/UkPdg87Xw7JMIsvWZfaMC2i7L7jDR317tZfRr+zM1ykqMiFPTZwbhXESWBPN6RNx67E+uciYZjmB+ahaO2VIQxF7s3M9KHQ9+qo4lkw9mz+G/9u0YEhepZV9ZrSbkUexeBQU0Se3zfGgv44ImCGIPmu9FjPbWzebEx1l6RpW47wCVzxvmIFGxCGx/ejATv7PQXMGJFHLzrJajv76HGRyXPLxYJUtVwaLo5WWnYlynorPPCXtaO763MHe1p1w1c4FcKA5rBxmENTk4ScrmVjzpSHkr0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com (2603:10a6:20b:42d::19)
 by DB9PR04MB9473.eurprd04.prod.outlook.com (2603:10a6:10:369::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 05:54:03 +0000
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a]) by AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a%3]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 05:54:03 +0000
Date:   Fri, 25 Nov 2022 13:53:47 +0800
From:   Firo Yang <firo.yang@suse.com>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, mkubecek@suse.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        firogm@gmail.com
Subject: Re: [PATCH 1/1] sctp: sysctl: referring the correct net namespace
Message-ID: <Y4BYayUITRYcmVjh@suse.com>
References: <20221123094406.32654-1-firo.yang@suse.com>
 <Y34ZVEeSryB0UTFD@t14s.localdomain>
 <Y38PUmjeFWApHnrh@suse.com>
 <Y3+wbPhEAyPIUpbM@t14s.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y3+wbPhEAyPIUpbM@t14s.localdomain>
X-ClientProxiedBy: TY2PR06CA0006.apcprd06.prod.outlook.com
 (2603:1096:404:42::18) To AS8PR04MB9009.eurprd04.prod.outlook.com
 (2603:10a6:20b:42d::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB9009:EE_|DB9PR04MB9473:EE_
X-MS-Office365-Filtering-Correlation-Id: c867d467-2348-471f-68b9-08dacea974dc
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jNeuEG/VBY/S6Cd37ywvt33FbsaHvJjdcKnLQS00SyyTa6d6eRFA17SkXkrWh1rOmFw3Q8fvNgWU2HhWA6cL6rXD3O3jxQGlVyLSSe4s7a/I+M+879eEbR2XcpNuEnnztltLGuTfHjIlIC01XXG9pV6poTt7etQr4joSNoAYKxulCbcaYntrkRnxNkbDXyrU1T30szX460prjPhMjntW1+FGdEb+l99e5ys+dUWeaN6KAlCYYhH7Wx0/ud60FdGPmcc7yD4HslXmFSbqqrMer3t5vlnEJahvYYHC7l941RrtHgT668IkOHb/I7LfBO2p/3NT/mMsUu+/eyzBSiIfR/KKA35FP9CjlytA3iQrM5ht/G82yzBr/aFTXUAAXZ3s2N2v65q9aPPHTRKqIaUjQLkJNg8ZtLd1mp8iyseLTX1Dfx/rw7UGozVRQ/gNHiWUl4RPRxemaJD1y2bFY1pWvUAj3e/b5Vvz/Ynj7zoLUyIqnytI2tPDmImt3/8jPcrjpX9tDwvUHmf0kKV8VwEdc023wh7gYW0k2q2csWVhzebWz3RoLL9+GiUHQwEcgHD2LEgDJalxNfo9Q1RRO/nuOlahoEiAIA2xbI9+VOsrhR+UWynFuhgClyhBTMik2fy69DSEEXe4feTSUbI+knO2/Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB9009.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(346002)(39860400002)(376002)(366004)(451199015)(2906002)(4326008)(8676002)(316002)(38100700002)(66556008)(66476007)(66946007)(6916009)(86362001)(36756003)(7416002)(8936002)(5660300002)(44832011)(41300700001)(186003)(6512007)(6666004)(6506007)(6486002)(478600001)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VVlWWDFwQXBPaitaMHc3Ni8rSHpiYThKaElUSVdCclpxSWloRmN4aGY0d28z?=
 =?utf-8?B?VDI2c0EvclJtZHdhWnhCOGZEalRmSjdHYjdTT25STmp6Y3RMaU9rUXM2dGY1?=
 =?utf-8?B?NkhrUUMwUElHN2hlL2FSUmVKUG9FRVZrZFgzTXZtT3Iyb2s0aklFcnFaYWFG?=
 =?utf-8?B?d1IzZGFScUcrT0RLNWlwUUtXZ0Z0YzRYQ1JYVWljL3ZrY3p5MmpnQmpTb01l?=
 =?utf-8?B?M3Bta0F6L1R3QUJkRTRNVmppN1VpU1RkN1ZhUitPQ0lUUExwL2NXZ2xMejBP?=
 =?utf-8?B?SUcrMUI1TUdneEU1bGVZV0E0WnRTclhMMTJxeCt4UUNnYUtDL2cwMUc4VDF5?=
 =?utf-8?B?RTVQMFcra1ZqS2Jnc0N6ZFZZVUlWWDdaelArQXlEaWUxaWVBbW90SzRyd040?=
 =?utf-8?B?YWRmYmlidkpBdnlnL2NDSFpQR1lpbm1HdnRJSkxXejkzc3d5aE96RlgxUG41?=
 =?utf-8?B?YURObUxCWFFHckNaOUhKTFBKUStlVXltOC96b1pPZExQSXovR1J1MC9rSXZr?=
 =?utf-8?B?alZPb2hYQ1VSOVRzYU5JeGZtNUtGTGVWT3F6TGxGZE9Kc2RmY2NjNWp0c25T?=
 =?utf-8?B?RHR1Z0JUM3E4TldDcUJLUzc4M1Q2U0RpQmkzWTFMb1ZoblNjbEFlLzg5MnRx?=
 =?utf-8?B?bUdvOHphYzNHK1RuZHQ5OXphc3hHRnM5T0Y0UXg0MURsanhtazdja1FXT1hk?=
 =?utf-8?B?ekt5ME9FSWNTM2tKRDVYNDU5T202aU5MOWtjckRtbzBVbllJZGhXdW12MCtX?=
 =?utf-8?B?VStWd1EyWm5Na1JXR2tVWXdQVjZySW9DN0NhWk1XYS9NOFRlRC9zRmJUYVYz?=
 =?utf-8?B?TGF3OUhOU0NJRjZ5aFRWb01ZeTlwVERuQTlxakdtRlBYcUdNK1dtaEFPUDgw?=
 =?utf-8?B?NGRublh5WlNoSDdNWlExM3ViUEFmZ3FqU3hHK0lDQTRBRGw2Z0dOdWx2RDFN?=
 =?utf-8?B?cHFRZUd6RnFoTDJiVnhOS25aRDZad3d6M3pQRVdkV0N3MGhwZG5GNFFwREJx?=
 =?utf-8?B?SEpEZE1sM2U0c05WYkJucGR0M3VRY0lTUUo3TGY1QU9td1U2dTFFVDNLZ0VW?=
 =?utf-8?B?SThNazFGM1Q3czZJRzBXQkZnbVd0Z0llekJMLzl6OWwyNUdDZFIvOUk4SEo1?=
 =?utf-8?B?eURmZ0tzcXNFZ0hObytsV2Q0SktNMmlDempHencvVnlYWGF3eCtDOXllUW9r?=
 =?utf-8?B?VEVxRWN6TzNtTTJsQnVyRW9PeU0yMlo4d29BZkZtcXVFeWVWbVEzU3h2U2RV?=
 =?utf-8?B?RVg1ZytpTGZPWXhPd01vUmNlTTcrOGsyK3Q2M2FXZTBJMHBrQ1NsQjlHeEw5?=
 =?utf-8?B?c0xHVzBwUmFRa1dJOElMejhBZjRjVVV4clFyZnhDMXVtbGJUUVBBTGJRVS9Q?=
 =?utf-8?B?cjRTazl5VTIxcXlMbTVVdXNoUTlCbnArV1VpbUw1bnFyRFkwTEZyNEN4ZFNa?=
 =?utf-8?B?WnBLRlZxMlRONUFKWUl3RUlvbVdlZGM2cjRHV05QRkd6WEI4UG1WT1dQTnlG?=
 =?utf-8?B?QTRXK3hZSkZvUG5nSlZhNXpjWlc5YS94MGFRb2xuL0hpNnd0K2lmbEczZWUy?=
 =?utf-8?B?TEZ1STNaZzQrOS9aQkFkUDdnNVJmK1VIdkhMNTMvOTAzR3JXZ2pSaWZvOUJG?=
 =?utf-8?B?czJSQUlrdFd2bDg2R1JmR3lZQ3g4N3JEN2hwdkpVb2F2aWN3Vk52bWVMeGto?=
 =?utf-8?B?bFpGRVpiZ3dMYlNaWVVsczMvV21Eck5mNTVkTHpUTWpyb1VLSDl1eDNyODF0?=
 =?utf-8?B?ZTNoZWVTLy83dGZLYnVONk1xNmN5dHZBZ0NTZFFzMm94cVhrL2RyUTBod2gy?=
 =?utf-8?B?R0lqVUc1M1dSclF3bkhHaVNKZ2N5bTFFTkRLOHg4dmxVZG5WYlozRGRWdzZs?=
 =?utf-8?B?ekkzbVFQb2lqQkJCNi9uWmc2U2g1ODRNTkNOSTBaaFZpdHlOUHNxZkN2RCtN?=
 =?utf-8?B?SEZFeDNPWWxXQ0NLeFNVdkNWOVdGbVZaQ3gzdTd0bjc4clo1S2p5RzR4NEho?=
 =?utf-8?B?dUdEQmVDR1VNaHN4SS8zQ2I0Q2JDaDVQdGhzSnZmMHV1ODI2ckdsd3lFMFhD?=
 =?utf-8?B?NjRXZEtpdXcvUHlWa3JYVjBlOXg2SWFteWsvNTJYb1lZSjVhZndJY0R5RERV?=
 =?utf-8?B?TmhSSFcwckM4aXh6U1RxWHhLSXF1WWdkdExQeHFpWUY4TkkxanBqZ2k1clh4?=
 =?utf-8?Q?RIwqfy6MW4hax4kPOpTRDWDKPccPN4xix2H4vN81lKn+?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c867d467-2348-471f-68b9-08dacea974dc
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB9009.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 05:54:03.3305
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oZWXzewoh8bppRAOBnC9y5DUqZqH5wMau3yNKpzvWmtj2X2DtAXv+nvE79+DrFYG2KtJBGLxZF1TmDYb8wv6+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9473
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 11/24/2022 14:57, Marcelo Ricardo Leitner wrote:
> On Thu, Nov 24, 2022 at 02:29:38PM +0800, Firo Yang wrote:
> > The 11/23/2022 10:00, Marcelo Ricardo Leitner wrote:
> > > On Wed, Nov 23, 2022 at 05:44:06PM +0800, Firo Yang wrote:
> > > > Recently, a customer reported that from their container whose
> > > > net namespace is different to the host's init_net, they can't set
> > > > the container's net.sctp.rto_max to any value smaller than
> > > > init_net.sctp.rto_min.
> > > > 
> > > > For instance,
> > > > Host:
> > > > sudo sysctl net.sctp.rto_min
> > > > net.sctp.rto_min = 1000
> > > > 
> > > > Container:
> > > > echo 100 > /mnt/proc-net/sctp/rto_min
> > > > echo 400 > /mnt/proc-net/sctp/rto_max
> > > > echo: write error: Invalid argument
> > > > 
> > > > This is caused by the check made from this'commit 4f3fdf3bc59c
> > > > ("sctp: add check rto_min and rto_max in sysctl")'
> > > > When validating the input value, it's always referring the boundary
> > > > value set for the init_net namespace.
> > > > 
> > > > Having container's rto_max smaller than host's init_net.sctp.rto_min
> > > > does make sense. Considering that the rto between two containers on the
> > > > same host is very likely smaller than it for two hosts.
> > > 
> > > Makes sense. And also, here, it is not using the init_net as
> > > boundaries for the values themselves. I mean, rto_min in init_net
> > > won't be the minimum allowed for rto_min in other netns. Ditto for
> > > rto_max.
> > > 
> > > More below.
> > > 
> > > > 
> > > > So to fix this problem, just referring the boundary value from the net
> > > > namespace where the new input value came from shold be enough.
> > > > 
> > > > Signed-off-by: Firo Yang <firo.yang@suse.com>
> > > > ---
> > > >  net/sctp/sysctl.c | 6 ++++++
> > > >  1 file changed, 6 insertions(+)
> > > > 
> > > > diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
> > > > index b46a416787ec..e167df4dc60b 100644
> > > > --- a/net/sctp/sysctl.c
> > > > +++ b/net/sctp/sysctl.c
> > > > @@ -429,6 +429,9 @@ static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
> > > >  	else
> > > >  		tbl.data = &net->sctp.rto_min;
> > > >  
> > > > +	if (net != &init_net)
> > > > +		max = net->sctp.rto_max;
> > > 
> > > This also affects other sysctls:
> > > 
> > > $ grep -e procname -e extra sysctl.c | grep -B1 extra.*init_net
> > >                 .extra1         = SYSCTL_ONE,
> > >                 .extra2         = &init_net.sctp.rto_max
> > >                 .procname       = "rto_max",
> > >                 .extra1         = &init_net.sctp.rto_min,
> > > --
> > >                 .extra1         = SYSCTL_ZERO,
> > >                 .extra2         = &init_net.sctp.ps_retrans,
> > >                 .procname       = "ps_retrans",
> > >                 .extra1         = &init_net.sctp.pf_retrans,
> > > 
> > > And apparently, SCTP is the only one doing such dynamic limits. At
> > > least in networking.
> > > 
> > > While the issue you reported is fixable this way, for ps/pf_retrans,
> > > it is not, as it is using proc_dointvec_minmax() and it will simply
> > > consume those values (with no netns translation).
> > > 
> > > So what about patching sctp_sysctl_net_register() instead, to update
> > > these pointers during netns creation? Right after where it update the
> > > 'data' one in there:
> > > 
> > >         for (i = 0; table[i].data; i++)
> > >                 table[i].data += (char *)(&net->sctp) - (char *)&init_net.sctp;
> > 
> > Thanks Marcelo. It's better. So you mean something like the following?
> 
> Yes,
> 
> > 
> > --- a/net/sctp/sysctl.c
> > +++ b/net/sctp/sysctl.c
> > @@ -586,6 +586,11 @@ int sctp_sysctl_net_register(struct net *net)
> >         for (i = 0; table[i].data; i++)
> >                 table[i].data += (char *)(&net->sctp) - (char *)&init_net.sctp;
> >  
> > +#define SCTP_RTO_MIN_IDX 1
> > +#define SCTP_RTO_MAX_IDX 2
> 
> But these should be together with the sysctl table definition, so we
> don't forget to update it later on if needed.
> 
> > +       table[SCTP_RTO_MIN_IDX].extra2 = &net->sctp.rto_max;
> > +       table[SCTP_RTO_MAX_IDX].extra1 = &net->sctp.rto_min;
> 
> And also the ps/pf_retrans. :-)

Sure. I will send an V2.

Thanks,
// Firo

> 
> > +
> >         net->sctp.sysctl_header = register_net_sysctl(net, "net/sctp", table);
> >         if (net->sctp.sysctl_header == NULL) {
> >                 kfree(table);
> > 
> > 
> > > 
> > > Thanks,
> > > Marcelo
> > > 
> > > > +
> > > >  	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > > >  	if (write && ret == 0) {
> > > >  		if (new_value > max || new_value < min)
> > > > @@ -457,6 +460,9 @@ static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
> > > >  	else
> > > >  		tbl.data = &net->sctp.rto_max;
> > > >  
> > > > +	if (net != &init_net)
> > > > +		min = net->sctp.rto_min;
> > > > +
> > > >  	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
> > > >  	if (write && ret == 0) {
> > > >  		if (new_value > max || new_value < min)
> > > > -- 
> > > > 2.26.2
> > > > 
