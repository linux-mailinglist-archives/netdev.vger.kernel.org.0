Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 714561503CA
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 11:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgBCKDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 05:03:55 -0500
Received: from mail-eopbgr40084.outbound.protection.outlook.com ([40.107.4.84]:36998
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727027AbgBCKDz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 05:03:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oa/PQPr0e4amn4Oy3cOT2cHUDsmyHzJMrhYpAJKOTWmC9M1FnENRFBy85Amy0+cd9SJDtvdM7JDObb6fzHKAbaQ9HLuvUpdfgDw22FtqyFIE61dkNHsjQ8DtFXXUg/ysktyJAhyK4apzo3sSX5OU9Zm5fJ6Wlfxo2QbDDmJ+4Y43/IgqgFJ7vsq9spml2W4NWaC1nJZqzNIZLFlfc/TycNxnYyXIoQnkP/ro7RbowGSm7dNsw2GPIjPDZVjghM75eyNxUiqmWggnrxMtcMFdEIeZ5MxLNzkZo9IcqKBg9pbDYvaEru7bRBCCq42pHmRk1vmYzieFGSXc1dFoaWjleA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akvO1PwgNzOSkqx2y1qAsOKvDi/y2JJkRSeKHdNNSUk=;
 b=Us9aeevXCCVw0FTmKENClGV+Sn7Wr20JfGkvmnSqpMQsQuCNqnGL9oDLno5TEPGEu3rO0QnF5YG5wCShVmth9RAHhFWB3yxyEljVqbnwcUS7OkrXG+taqYyL/0ywvnx003//gVgvrZWuv7yER+2bPUD1vN9XihnA9OeNPqmuHjf0qSCCsSvIsYCSv6owhcZZsL90PawvslzOHPf3xf3qJvLkthKfHg6noF4V6T/W5QskFspoCZxAQLvJt/dT3IML7T1oXY0ULCwhF/0skQS1ROSlxgkn80t4wOUFuakIIkKbbz1TuwfqC0ELTT3bR/1Kv0p448AU4glVad6cMSKcrg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=akvO1PwgNzOSkqx2y1qAsOKvDi/y2JJkRSeKHdNNSUk=;
 b=Ipert6Nc2kIUWYekf+tvl49tl2sV5rVpv/23+oWPztYArs5lUWKu0xeO3cyrgfIP/Av3FFI/UgK849VYqeUGou1U4YzNHBFOe2tBUshQ8fenMMshlk2/0vR1K6smXVR81UvSLDkR5tjM2zj9PQ7gnj7EviGZpwKPlul8JAbi9/I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3193.eurprd05.prod.outlook.com (10.170.246.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.27; Mon, 3 Feb 2020 10:03:51 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::c146:9acd:f4dc:4e32%7]) with mapi id 15.20.2686.031; Mon, 3 Feb 2020
 10:03:50 +0000
References: <20200130232641.51095-1-natechancellor@gmail.com> <31537c12-8f17-660d-256d-e702d1121367@infradead.org> <20200131014816.GA54472@ubuntu-x2-xlarge-x86>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxsw: spectrum_qdisc: Fix 64-bit division error in mlxsw_sp_qdisc_tbf_rate_kbps
In-reply-to: <20200131014816.GA54472@ubuntu-x2-xlarge-x86>
Date:   Mon, 03 Feb 2020 11:03:42 +0100
Message-ID: <87wo94asxt.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM4PR05CA0015.eurprd05.prod.outlook.com (2603:10a6:205::28)
 To HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22)
MIME-Version: 1.0
Received: from yaviefel (213.220.234.169) by AM4PR05CA0015.eurprd05.prod.outlook.com (2603:10a6:205::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2686.32 via Frontend Transport; Mon, 3 Feb 2020 10:03:50 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0bba5a10-0903-442a-e8cb-08d7a8905e54
X-MS-TrafficTypeDiagnostic: HE1PR05MB3193:|HE1PR05MB3193:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB31933C21A031EFC9C3B5D763DB000@HE1PR05MB3193.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0302D4F392
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(189003)(199004)(956004)(2616005)(2906002)(52116002)(36756003)(6496006)(8936002)(6486002)(86362001)(6666004)(16526019)(186003)(6916009)(54906003)(478600001)(26005)(316002)(5660300002)(81166006)(4326008)(66476007)(53546011)(66946007)(66556008)(81156014)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3193;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Dtf5QfWzrktG2GpnTy5DG2SfMWXsFnwdxoC+eK1PKR4Yu2MVKCn4LEfvyEJZwerBCd/yrsDVSx5F0ZHwsdlKhL1+WQSUv77Zl0bi834X6jnqCjPE+PU0RC7mrthNO6N5n/3jfBGAzz0b2dGcNGFpxkpVmDYD2hBmrx3yEbRDdDU4oL2K3phe+ueykpoNAENnr34YOC5YiNKVXjRz8x6Y40+v9OB/JH/BqUGl0ANehr0zof5dLwsY8Mt5RmaSlJ+on7xQ1jmFZC80OJ9Nl8H0Yu/nZ8xN69tCWyJTQ5u6c/FkP5prif5CoQh4wzTXCIcLL5Hh6bmDhahz1H964F1vSpGisleEEt+2DN8E3pSXv773QLBBv7GuEN908ZgJCbKglAlEjCceueq/Gc4zxQXpODcpmaZ4iMk/iU8ERTwtIRfXTlRSPWvp5f2aqrUn01vT
X-MS-Exchange-AntiSpam-MessageData: iS/v6ga0Jis/Ta41Ik+Kjt+J8pGjPWMbbxH8vIY3IQOmcY8PsEvDKkeo4TP5Pmf/xAOjdRbtmkwALSKqQnWa3JfRz13/GKKuomaRlnH17GC1Ru8G0yCnsi49sWNbFM4HXsdb95ntrYTJwGLaH6rBlQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0bba5a10-0903-442a-e8cb-08d7a8905e54
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2020 10:03:50.9353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pEeVXOCo55WvtyDyqhjN/83UyJmjvA+bx2Q5R6Yx9SrRzoRM2SVJJXZoGGblqPJWxt0EEVxUX6xAvGdOIfq40Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3193
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Nathan Chancellor <natechancellor@gmail.com> writes:

> On Thu, Jan 30, 2020 at 05:43:56PM -0800, Randy Dunlap wrote:
>> On 1/30/20 3:26 PM, Nathan Chancellor wrote:
>> > When building arm32 allmodconfig:
>> >
>> > ERROR: "__aeabi_uldivmod"
>> > [drivers/net/ethernet/mellanox/mlxsw/mlxsw_spectrum.ko] undefined!
>> >
>> > rate_bytes_ps has type u64, we need to use a 64-bit division helper to
>> > avoid a build error.
>> >
>> > Fixes: a44f58c41bfb ("mlxsw: spectrum_qdisc: Support offloading of TBF Qdisc")
>> > Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
>> > ---
>> >  drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c | 2 +-
>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>> >
>> > diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
>> > index 79a2801d59f6..65e681ef01e8 100644
>> > --- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
>> > +++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
>> > @@ -614,7 +614,7 @@ mlxsw_sp_qdisc_tbf_rate_kbps(struct tc_tbf_qopt_offload_replace_params *p)
>> >  	/* TBF interface is in bytes/s, whereas Spectrum ASIC is configured in
>> >  	 * Kbits/s.
>> >  	 */
>> > -	return p->rate.rate_bytes_ps / 1000 * 8;
>> > +	return div_u64(p->rate.rate_bytes_ps, 1000 * 8);
>>
>> not quite right AFAICT.
>>
>> try either
>> 	return div_u64(p->rate.rate_bytes_ps * 8, 1000);
>> or
>> 	return div_u64(p->rate.rate_bytes_ps, 1000) * 8;
>>
>
> Gah, I swear I can math... Thank you for catching this, v2 incoming with
> the later because I think it looks better.

Yes, that's the correct choice. Divide first, that way we can't
overflow.

Thanks for taking care of this.
