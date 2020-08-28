Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC6A12554AA
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 08:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgH1Gtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 02:49:31 -0400
Received: from mail-eopbgr1390073.outbound.protection.outlook.com ([40.107.139.73]:38176
        "EHLO IND01-BO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725858AbgH1Gt2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 02:49:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZ4yiZ3aR/7n5/rT3KwRy239+I4s5jFVZACxvbzUDkWp5+Sp/3fu0GJn1Ik0a3pN8afHwFEw8P2DK4h9DYiRi+YX93tvvq17zDTd+zSJuPgKQmrAp5lWfUmEW22vnlmx/39Tt/LjNLDFjbGZHtqW++qUS8RUdsc64WOaTEaD6RvYEwfoHkBU0MSpYGm9FMYju500zBj8bsxDH8wLduS2yctuLLWChZv4v/MGaPhe8LH6kITax12fiMuG5UyYlhclK2Pipf9N1sHwSR5SWafJlkEi3Qp2uhdDkSshehW1BjNfG9niRW2tmHqL0Ehh6wvGBi78q8w4UvxeZnKoKhPcFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhhikLaoK7nWL/Rf8j0MtPxZCzP55cw23v9SiTx3pLM=;
 b=Rrh/Ob6ZCefQmtLwBUD3DYJDZ9beQpMhmeu3VlQGRnZKiB0jy+pScVlVnrRKVb9OMlLWaLqDVQHqtmMsqE8KO29NojbdZjXKwvKgDB0rmMqa2IZQwisotmBP0DY1tTrxDjIRpF4I1bRIfyTwHoFYDfmjPEvLH/iD/0zlDoLYBHe1s/LE0urm46PPO60wdMbOohrHL/sbHf/9yDydpCE7Zy2oiTXWo4wL5vnFJuWLTTwG8w4XMFVT2Hn+IP37/fGjfSFbfpmjREFZX3t/g8GV04zQxUZP6VW1TV9RJTeF345kfiIRcJ4c1pPdQLbgxy+8xrCHml6fnTkgT19oyaRZZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=iisc.ac.in; dmarc=pass action=none header.from=iisc.ac.in;
 dkim=pass header.d=iisc.ac.in; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iisc.ac.in;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rhhikLaoK7nWL/Rf8j0MtPxZCzP55cw23v9SiTx3pLM=;
 b=lbB7aLEWbNUbTRXJXTYyArO22cFfrPTbHSzesSnREB4I4wkHn32SzMm+8sPXLtvhItYSnt019LwjoY99/PvAGUW8ulRy4Sn7rI6MMCBpitMyctAo6LRiECL/gM7Ew8TYJnCVz5WvNP8XjEW1leNOxB8adIGX5fmUcpbj4JJ8gq8=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=iisc.ac.in;
Received: from MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:37::23)
 by MA1PR01MB2217.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:44::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Fri, 28 Aug
 2020 06:49:23 +0000
Received: from MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::b478:1d:994f:46c1]) by MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::b478:1d:994f:46c1%6]) with mapi id 15.20.3305.032; Fri, 28 Aug 2020
 06:49:23 +0000
Date:   Fri, 28 Aug 2020 12:15:12 +0530
From:   "S.V.R.Anand" <anandsvr@iisc.ac.in>
To:     netdev@vger.kernel.org
Subject: packet deadline and process scheduling
Message-ID: <20200828064511.GD7389@iisc.ac.in>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
X-ClientProxiedBy: BMXPR01CA0070.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:2c::34) To MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:37::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from iisc.ac.in (14.139.128.15) by BMXPR01CA0070.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:2c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Fri, 28 Aug 2020 06:49:22 +0000
X-Originating-IP: [14.139.128.15]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34a6b1e5-5f64-43a6-61c3-08d84b1e7f46
X-MS-TrafficTypeDiagnostic: MA1PR01MB2217:
X-Microsoft-Antispam-PRVS: <MA1PR01MB2217B696FDA0DE333EDACD6DFC520@MA1PR01MB2217.INDPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QpSf2dLxfhXUQsWyVQZD028+IyyIGHM/zu5wRFW/wGxZWH3TCLy2OR8C19tBSHnPFc/yW7LEzzK3Q2KJaOY7V9PkYg6cwUdV/Ulc1Gkpz4EBp8MmmWFKwH2be9FvY421tn/nYzsC5svXZmd/Kg+pE7MfdnNxwSHob0J7CjqJJvHoF4A2XSkrKb4SKr1uKKrCvecD8r53Y5Lw/JoBGBeMgkHD1aO5UBjvpopk2+Trcw1VCsRyhyCUELPI6W85XPC0IdMuGVYTnEOoK9MWiqt/+bOk8LSPO7s4ixFOKlbzgrWSa6rtZ45XN/S9E2M90IiUFqeKK5Humcmb36/KsprSiQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39860400002)(136003)(396003)(366004)(1006002)(2616005)(4744005)(86362001)(66946007)(956004)(66476007)(1076003)(33656002)(66556008)(478600001)(5660300002)(16526019)(83380400001)(8676002)(316002)(6666004)(2906002)(55016002)(36756003)(186003)(6916009)(52116002)(7696005)(786003)(26005)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 0SqGczqedFQKQYBA+UOqnK3+YQLsiFowYAB4hv4ND0K9ykeOacrnFExXHrUPmdk2n6mBXGiQnvcRedxbh5j40Eg4ITzDxfHHdH8BE0ABe5nRgqBoOM3tPss/IiQzzKI5uo/dACTtM6IjPEoK3tyqt9HuSsIDsVKPQWvaCp/Ac49NYR5HW9vASukhzpzesRJCS1MSXuTQty80uWIwTRDeyasXorhbdPoUNWk2k7xyF/S5DWNU5aOokW0VW/MbpxSmCasADrvIQdPN2yZzKGWdZD0wUi0Z7DpJ3dgpridgE62bfq5fc0dPOYJ9Kiq2W4lOml6OTgUiM/2j4EWxlpQLK97Gq5SMQlzjxsxCA+TdPXVY1CAuyA9+N9hAmcrYbAjOUpAHfLfZaEmXhDGsElAWXdBUxBkAtRKi2j8Dh62UZHuE8e/AxoSxSHRubSZyTJ0hmO/LewglbtDJpeS40UKqXxcA2q5cO4gJ2NaMXySJ1SYpheFd1A7HK522JgrZsqj7FNuKfI5qMzwoIb/SeHRddO3jHK6cbEXeREu27fU9nizxNVuY1Xe2DIYXlQjGh/Gd3ucGwVJ8L1YV9wcQWxvzJyZ1J5Ju+KKzX1iJND/847KT+FcGsdnZSFpe0/u7RkGqAO8NeiT85UIC8FYaNh+FWw==
X-OriginatorOrg: iisc.ac.in
X-MS-Exchange-CrossTenant-Network-Message-Id: 34a6b1e5-5f64-43a6-61c3-08d84b1e7f46
X-MS-Exchange-CrossTenant-AuthSource: MA1PR01MB2218.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Aug 2020 06:49:23.1425
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 6f15cd97-f6a7-41e3-b2c5-ad4193976476
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpqpzVhd1E6HdYns6X+s2s5HV1ZhENRwU1BHBISZNowDaQ25+YsCRF0V6c51eHIrG7GFj58ju80CAtOaV63bHw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA1PR01MB2217
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

In the control loop application I am trying to build, an incoming message from
the network will have a deadline before which it should be delivered to the
receiver process. This essentially calls for a way of scheduling this process
based on the deadline information contained in the message. 

If not already available, I wish to  write code for such run-time ordering of
processes in the earlist deadline first fashion. The assumption, however
futuristic it may be, is that deadline information is contained as part of the
packet header something like an inband-OAM. 

Your feedback on the above will be very helpful. 

Hope the above objective will be of general interest to netdev as well.

My apologies if this is not the appropriate mailing list for posting this kind
of mails.  

Anand
