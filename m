Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5EF018F295
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727885AbgCWKUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:20:25 -0400
Received: from mail-eopbgr150078.outbound.protection.outlook.com ([40.107.15.78]:61159
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727858AbgCWKUZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 06:20:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V6eFYOLolYCfsfEpdwER1mWK4wA9E8dukh4EueIyIfnlLpqAPhjp01jcbQzlEGqelNLw4VsUjlwShPcAHs//WnG3rfEUdxT4eUKqflvupaBDC92fOnW1VPunWWsoXMcRApDxAbf2XRFr6MfTzuSGwNTSSw036Gka2p4ajVTn7MEHS/jyObrjkVwzOkIQ0DDenhTMYGfhFSd2SghsXbucpHZZLF2z5D6Myzy8YFyzNPQJLv8GGkq/pwQtW5q6bliJW7LhatTrMnzLb5iYpfG9HHAK6zWWYPk+6tp4LwbyHqlWaVL0F22gEZFMpFvNIjpJ58/gb48bhvcqIKhJf6C9jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nxaij0RrhvARUTAlUIM/uBEtOLATXQNb2icTgZ7xDHU=;
 b=aZOrXNsD5jBYzel6HcrXKN6IHTDG0dctdoSYs0MVe38O+DmIls+WR9sFB3FKI6HZFhi1P+cLQKaj3/JsS7bAHPz/NYpTm5RaoCcaYKPZZ2pVu1birmxHG0lF6pNNaG8y9Bg7VmEtU0d6OfI19Z+cYySeWhtuYTeE+RJf87MydKTpjj27VAA4d+A/iYq5zHw9Sn1onIKpcUVGQ6UbaCjpWb4/jDCJgmbWGXtr/v4ILkpf0h94yNImucQhEuR4+A/r6mn+ksVvtBAzgQ+PqXBiJWTse2HCoBEA8+QX9ShD6Va5xvKlQvgcYzW/68FfOCzcfgRBq1vDGMTj9iqQUzU16g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nxaij0RrhvARUTAlUIM/uBEtOLATXQNb2icTgZ7xDHU=;
 b=WFvsJQmR7AVV099isP11pgIoQliF4nBRDxXTGMl0oQOo4XQH3BDzgOc2jbLdTN901nH6X2Wc7iW9i+wez8KiVcvbjj35fGlAHHF3DuWhz+L0QTQ2SOL0oeWLLGB56EGhAVTLCjhd5Vc9TvsvOn42AmkFsVPoc9bA7JJP4xSFwG4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3385.eurprd05.prod.outlook.com (10.170.246.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Mon, 23 Mar 2020 10:20:21 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 10:20:21 +0000
References: <cover.1584533829.git.petrm@mellanox.com> <bb3146bd93e4c5f089033311e8a0418f93420447.1584533829.git.petrm@mellanox.com> <4ace5bb3-df27-44eb-dee7-6469deb0ec1b@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next 2/2] tc: q_red: Support 'nodrop' flag
In-reply-to: <4ace5bb3-df27-44eb-dee7-6469deb0ec1b@gmail.com>
Date:   Mon, 23 Mar 2020 11:20:19 +0100
Message-ID: <87zhc7v0d8.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR0402CA0016.eurprd04.prod.outlook.com
 (2603:10a6:208:15::29) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR0402CA0016.eurprd04.prod.outlook.com (2603:10a6:208:15::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2835.15 via Frontend Transport; Mon, 23 Mar 2020 10:20:20 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 05f985c9-48af-48ca-b403-08d7cf13caa9
X-MS-TrafficTypeDiagnostic: HE1PR05MB3385:
X-Microsoft-Antispam-PRVS: <HE1PR05MB33859EC6FD6862AFC1D6A13ADBF00@HE1PR05MB3385.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-Forefront-PRVS: 0351D213B3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(366004)(136003)(376002)(346002)(199004)(2616005)(478600001)(316002)(6486002)(956004)(66476007)(66556008)(81156014)(2906002)(8676002)(81166006)(8936002)(5660300002)(66946007)(4326008)(26005)(6916009)(6496006)(52116002)(16526019)(36756003)(186003)(86362001)(4744005)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:HE1PR05MB3385;H:HE1PR05MB4746.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DafxGDonxnv2KeTIUVecS8KiIAjDhC96N1pH6houMg1gT5eQsOhwGFjWHY9xJqfSaAvpViPbggckLqbiwb2snkA6XLXnxVaosISLee+96fkpPX015UsPdv0MA0w2iIeRY9e/vBEi9Ggwe6xlEBNH4g/KiNzc0JNmgyzTbRx9IMmuv2lTfzMiOLVg5a76PxB/RJpODMp7DQXyz8uTgqqVO48SZkiCcJLPo12M3hv3KljOsvIAEJvMEXLCG8fhXcsQzWOaa5ynfjnBnBo0Zbizux95hEpDAEDtKcBKpHsgmSYE0Dnu4PcKQWzlWGBS6ShE0Xqg7ZmKn9CjItyAqDrgNTFBkSQpu0LF9LaJXdYafmwQ/su1qwj5cIe1pS4dj17ReH5tDBpZjRrL6W1+h2XH84l/C6WD5jDLO3ApRPicRsoiFETT3OvAseoOObEaB+9s
X-MS-Exchange-AntiSpam-MessageData: VbInKvf8Wk4tRT4IGJdoyQh9S+shXQYxk+jDQUHrMPedHlZV5+8qfzsoH38ha3Z1/LIHK4dVJsLQE7GKNV+HYHeHyQh8fjwrouAUoVrTB0wy0CieXA1Bx14BaYNtAfqccMIJPqaWJXQYQcayqQJIwQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 05f985c9-48af-48ca-b403-08d7cf13caa9
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Mar 2020 10:20:20.8701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ON8MLkoq9bqCRnVwswejGGcYxNdpiwWrbIr1T9YLXqPzUN/7YfYVFxCOjJuQG9u7ccuR7U769otW35+B5MXdOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3385
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


David Ahern <dsahern@gmail.com> writes:

> On 3/18/20 6:18 AM, Petr Machata wrote:
>> @@ -154,6 +161,7 @@ static int red_parse_opt(struct qdisc_util *qu, int argc, char **argv,
>>  	addattr_l(n, 1024, TCA_RED_STAB, sbuf, 256);
>>  	max_P = probability * pow(2, 32);
>>  	addattr_l(n, 1024, TCA_RED_MAX_P, &max_P, sizeof(max_P));
>> +	addattr_l(n, 1024, TCA_RED_FLAGS, &flags_bf, sizeof(flags_bf));
>
> the attr is a bitfield32 here ...
>
>>  	addattr_nest_end(n, tail);
>>  	return 0;
>>  }
>> @@ -183,6 +191,10 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>>  	    RTA_PAYLOAD(tb[TCA_RED_MAX_P]) >= sizeof(__u32))
>>  		max_P = rta_getattr_u32(tb[TCA_RED_MAX_P]);
>>
>> +	if (tb[TCA_RED_FLAGS] &&
>> +	    RTA_PAYLOAD(tb[TCA_RED_FLAGS]) >= sizeof(__u32))
>> +		qopt->flags = rta_getattr_u32(tb[TCA_RED_FLAGS]);
>> +
>
> but a u32 here. These should be consistent.

:-/ That's a leftover from previous ABI, thanks for catching it.
Will send a v2.
