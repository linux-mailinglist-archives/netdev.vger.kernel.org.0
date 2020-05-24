Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43CF71E01E1
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 21:15:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388039AbgEXTOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 May 2020 15:14:01 -0400
Received: from mail-eopbgr1410130.outbound.protection.outlook.com ([40.107.141.130]:23236
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387747AbgEXTOB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 May 2020 15:14:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TiGPX4o4Ot9L4+ztPdyT0YX4S1ijyhqRNyww6+6XPUP/HtWpeD9svCQ7A+AaZIND0a8LZMF48J0Q0eAfSrxTuLm51L6cUUcESLv2NbifMlNCW3Tw+VSfsEcFk/HQHZXyJ55b9DyEyf8B0LFfV9QxOlxlB9hUF7HPI/rJIk2WTnjLBe6husMsPQWdZoxullr2K+EpSSL0Jla8gzUWDgBJQa288r0UcuwGnIO4osBjoXi4jr88XJVHX2aQU/x4cdMWHibWhr7Xafd9n1E5T5Nrx4tclTRYDL9ImfH4zx/QsPYG+DTTblFJAttoPtbfZEYIhvRNhBJQtEBnw79ZmWzuhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKT7rVGZzs9OaaKWlApYA6g0s3Haky99AnSLC7Tt6/s=;
 b=hiCf2XOvBzVmU1w+73+UCZusCBiDC3Sfh4bkQV/4qYQbcMBc+MNH4lt9ERYw154C3TSBBxF3Wb6AVzX2Z2DzP05zLf3V4skQiEkAs3WNwTgu/6NCJALq7EO/tjgBjnupVf6aejX9Abf8Oq48584/knQUMbgWhO9gC8qW567RniVewSP0xrW0ia1DrtnyfpIegWgQEvOxtkh8iPFtsjdmmc0L2+FhXey2jpzMIj4pEzhPzvvmcwfoXUkS/i/o/ezLbWvPHlRwH7nqAzuBq0yigXh0qhUl7ulm5zDquMtg80vlndQrKSeIS6LQAkJUTX9Na2zCsfJKCN7YDo8MKMJG6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vKT7rVGZzs9OaaKWlApYA6g0s3Haky99AnSLC7Tt6/s=;
 b=esH5DOZ2psRCJJIiBzE0gjbNpjvG0OuIzn6jOqTqfF5lpg1c9pfkaBuucfsyZSxIUknrf1nEU3LCeNhr3ccx3q9ZAKKPE3c7JeJyeBUhShZr5ADesEHHEaE/a2JbIlrLC9BBgbwDuQ6sdSwVfrK3ujjlBgsYEJRyRn0bTXgVnqc=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
Received: from TYAPR01MB4735.jpnprd01.prod.outlook.com (2603:1096:404:12b::18)
 by TYAPR01MB4894.jpnprd01.prod.outlook.com (2603:1096:404:12a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.25; Sun, 24 May
 2020 19:13:56 +0000
Received: from TYAPR01MB4735.jpnprd01.prod.outlook.com
 ([fe80::618d:b9fb:9576:8a52]) by TYAPR01MB4735.jpnprd01.prod.outlook.com
 ([fe80::618d:b9fb:9576:8a52%5]) with mapi id 15.20.3021.029; Sun, 24 May 2020
 19:13:56 +0000
Date:   Sun, 24 May 2020 15:13:43 -0400
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH net-next V2] Let the ADJ_OFFSET interface respect the
 ADJ_NANO flag for PHC devices.
Message-ID: <20200524191342.GA9031@renesas.com>
References: <20200524182710.576-1-richardcochran@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200524182710.576-1-richardcochran@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: BYAPR11CA0081.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::22) To TYAPR01MB4735.jpnprd01.prod.outlook.com
 (2603:1096:404:12b::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from renesas.com (173.195.53.163) by BYAPR11CA0081.namprd11.prod.outlook.com (2603:10b6:a03:f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Sun, 24 May 2020 19:13:54 +0000
X-Originating-IP: [173.195.53.163]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 065ef4cc-b7e7-4ab2-5c2c-08d800169abc
X-MS-TrafficTypeDiagnostic: TYAPR01MB4894:
X-Microsoft-Antispam-PRVS: <TYAPR01MB489469824FE204DEAE01094DD2B20@TYAPR01MB4894.jpnprd01.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-Forefront-PRVS: 0413C9F1ED
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /IrNNIIGHjcBlX0obDA9MrhYPSnBjlldaLsmDYcS+oWnq1gLPSMSNwb8gDTdpge2ZVpBx/YVs7x70tTmgV18C3BEzYyOKITgyJ5l961JgLDiXK53ciAG+FehJi1VYaVCNW4T8IDy+mNu3zSjU4aRVvXgBWd97G1MUe74dsVH1UtmkTpKjdUhCrbTewUoKi3gEcazsR50fXTQyK9FahtPgmmUmucy8RTgZX1wzUvhnw8Oi8J0PeytUfqeqyaYnYHj017cX4+mKpYd4cRqyYkaq8ePMfuAWnXChuNEVvpumbJkkoMT1satEEiEU3Xt6P1t
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYAPR01MB4735.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(346002)(396003)(39850400004)(376002)(2906002)(66556008)(66476007)(66946007)(478600001)(55016002)(4326008)(86362001)(956004)(2616005)(33656002)(6916009)(1076003)(8886007)(7696005)(54906003)(26005)(316002)(186003)(16526019)(5660300002)(52116002)(8676002)(36756003)(8936002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: ilJYsXKTs+Yifge8Mfu20yl/UQjBmYY/j78/ONjKl18ziE9KmpkcmfKXI6DdeNJvmtPqB9zwLEp337/V3S6MpSuwWBFps7M1cDB4gNwmF6dTFKgXp/KvwOuWszj93V/HblimFoaPpOkwPemKvRe0GBjz4AOUuxfXnnocIB228alhblr90+Si3LiR5Shq9LJYLh1jxx4797pN5Wsgt+cHsixFoyMtMX8nBYCANq8dxVBW/RiURJYOGLfHFny8Aq0oRYx9NXpiVl5WFa/GM6pNcH6QQHLcRJCqKQygT/jt/Xa3urD9/1ghiGgISMvFY8aMH4Lw+0/Su+9fwo+4Vl15vOq0CGA0wQjHvlvMLuZQoaS06J0cJ8USSFcSLyZ6e4AaE1peb1QUTKeUHlc/Q77+1sfFTDDcmk2AzUsxkkyXy7ldfXJYXvLqaJDttyN5piDGTRshfihzSgGyhDW5La4SV01aByiiNAxM/K6HOdyXgC6dOG9nwc9FVNHkE9WI2lnj
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 065ef4cc-b7e7-4ab2-5c2c-08d800169abc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2020 19:13:56.0999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r7roxyQWkgPuhEboHDhEX30qxPOyjuU6wKzGwmbvDjDrRfcaam/4xB62b8fDaVTaATCNiWOqfa95jSgBzTKChplawGhqd2t9uMYd0pwnxKI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB4894
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 24, 2020 at 02:27:10PM EDT, Richard Cochran wrote:
>In commit 184ecc9eb260d5a3bcdddc5bebd18f285ac004e9 ("ptp: Add adjphase
>function to support phase offset control.") the PTP Hardware Clock
>interface expanded to support the ADJ_OFFSET offset mode.  However,
>the implementation did not respect the traditional yet pedantic
>distinction between units of microseconds and nanoseconds signaled by
>the ADJ_NANO flag.  This patch fixes the issue by adding logic to
>handle that flag.
>
>Signed-off-by: Richard Cochran <richardcochran@gmail.com>
>---
> drivers/ptp/ptp_clock.c | 10 ++++++++--
> 1 file changed, 8 insertions(+), 2 deletions(-)
>
>diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
>index fc984a8828fb..03a246e60fd9 100644
>--- a/drivers/ptp/ptp_clock.c
>+++ b/drivers/ptp/ptp_clock.c
>@@ -147,8 +147,14 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
> 			err = ops->adjfreq(ops, ppb);
> 		ptp->dialed_frequency = tx->freq;
> 	} else if (tx->modes & ADJ_OFFSET) {
>-		if (ops->adjphase)
>-			err = ops->adjphase(ops, tx->offset);
>+		if (ops->adjphase) {
>+			s32 offset = tx->offset;
>+
>+			if (!(tx->modes & ADJ_NANO))
>+				offset *= NSEC_PER_USEC;
>+
>+			err = ops->adjphase(ops, offset);
>+		}
> 	} else if (tx->modes == 0) {
> 		tx->freq = ptp->dialed_frequency;
> 		err = 0;
>-- 

Hi Richard,

Oops.  Thank-you for the fix.

Thanks,
Vincent

Reviewed-by: Vincent Cheng <vincent.cheng.xh@renesas.com>
