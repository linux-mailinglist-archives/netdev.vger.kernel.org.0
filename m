Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB3623546B
	for <lists+netdev@lfdr.de>; Sat,  1 Aug 2020 23:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727790AbgHAVcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Aug 2020 17:32:31 -0400
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:41731
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725883AbgHAVca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Aug 2020 17:32:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HDjssyLoO9AhN06P9rJREx9VwWWnRo3L+5o5TpBQVJPxMgaIPT+zn8o139PF1URleB50qF4EFShTQ+BzwHVMkh3oXdVwPoquHSnfeKtPcuD4nbDgqTtDwDs9hK+Q9K/PdRguVygS7oaz8X/GYFmoOr9q4QMlY2XNopZ6UjWQjqIQ3hyrqd36ArA64WebdZhqDWK12DOTNBUCJosp1tOIIgN2eRLnpbMA3oJr9MeN/J86LvOR6qMYPua2xbbXSQJWyvhyhheB5O4zRRImFl685ZUpkcwupqdkzZriW6sWrzUply613CRIvqB7ZNStsvBOzFZr6TbGhqFxjOO2ci0KRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9lMSLVc5ZM2mkSTck3+ZLWZ4XtmPJilx45S1jHfD28c=;
 b=jZSL+q8plhD2KC7rsKXOfvB5xeaq7k8d8/f5p9/gYPhtRhB7Bhdi0mmO89rW+B81QkfsfZJnjT8dgwDZp+lj7Dg3OHnDwrDScY9DXqAGrKdeQxDXavBhFQzDaqGOsfITnUO2lRoYNBaHcHlOqkN9XrwWGj1YvSgTEKq+JsdCqQy5bclTlt/ef92xlRE/PHzcsdiYjFk/HX5W7FN8TvruJWmWopR4IzFVJ9JF41s1b5RN0i/F9KaXby3UZQN0W42FkBJaHsxLUEarBFqrKCDg6xCl7gNoUyYvibIB/MlKRAMY4qbBhTW3okN0EQSCXItoKbjIuWCmgUwVsYKtSWg5Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9lMSLVc5ZM2mkSTck3+ZLWZ4XtmPJilx45S1jHfD28c=;
 b=PB0RL0c7LWl8i4d7SZwCKL3loKOjprtXZqQyDjgSwmGFPREP1rn8D+3fJnwmqc61YnnVe0Zjx6dA+13HoJmUVZe0TlKuqeRTUOzRqRszX+0UXCSh0Df44yPBqLUkWyygBGNfGjf44w9iNDnBrN/J7JvxHvaNsobzhEDqZXb7v8w=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com (2603:10a6:208:63::16)
 by AM0PR05MB4452.eurprd05.prod.outlook.com (2603:10a6:208:5a::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.20; Sat, 1 Aug
 2020 21:32:27 +0000
Received: from AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f]) by AM0PR05MB4290.eurprd05.prod.outlook.com
 ([fe80::21b3:2006:95aa:7a1f%3]) with mapi id 15.20.3239.021; Sat, 1 Aug 2020
 21:32:27 +0000
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
 <1595847753-2234-2-git-send-email-moshe@mellanox.com>
 <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200728135808.GC2207@nanopsycho>
 <464add44-3ab1-21b8-3dba-a88202350bb9@intel.com>
 <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d6fbfedd-9022-ff67-23ed-418607beecc2@intel.com>
 <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
 <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
 <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Moshe Shemesh <moshe@mellanox.com>
Message-ID: <0f2467fd-ee2e-1a51-f9c1-02f8a579d542@mellanox.com>
Date:   Sun, 2 Aug 2020 00:32:25 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR06CA0088.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::29) To AM0PR05MB4290.eurprd05.prod.outlook.com
 (2603:10a6:208:63::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.0.105] (31.210.180.3) by AM0PR06CA0088.eurprd06.prod.outlook.com (2603:10a6:208:fa::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.17 via Frontend Transport; Sat, 1 Aug 2020 21:32:26 +0000
X-Originating-IP: [31.210.180.3]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a648b713-e17f-430d-80c1-08d836626364
X-MS-TrafficTypeDiagnostic: AM0PR05MB4452:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR05MB445207A6D7E279B9B9DEDF82D94F0@AM0PR05MB4452.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MAsgiK9RARe94NQanwHKVIRJymJetxlNstFmj6Xs+T33nM3Mle+wenNw/WCWmDRHFTvn8fjMSip92caLqjrjeXKehlFIGGmanD8NUgZAjnUpLfyRzyj64zjuL93kYEDp8IfJ5uFJD/ONzIFPMoUXYYjolDA1ePfjAGK5A7mh3l8Ey17GYWGYL/idhZ31HiSo1kFNY2/ofli+7UDVUfaImfiz9s6JbIlhBpfwHuQT8rjtVbbnhPY3mnePu+t68zDtep1SYZ2+DitB8rLmQWymoDzKyfBpWcUiyj0NIoG2Q6U2wRornQdCE2gQWHzYg0/WP5XDrVUhOE3NiFYWel1xEKJlvmFduj1l94/N0Z81y+qfSbaWmgNcC1aI8I7Y78lL
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4290.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(366004)(39860400002)(396003)(6486002)(956004)(36756003)(53546011)(2616005)(83380400001)(8936002)(54906003)(4326008)(8676002)(16526019)(31696002)(6916009)(16576012)(52116002)(26005)(316002)(478600001)(86362001)(2906002)(66946007)(5660300002)(186003)(66556008)(66476007)(31686004)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bXgcEKH9pKEO23VsKiAp+nrQoYURxiTFjQMqf1Mzxm3jAu/n443igybElGOE4q18KXBHUp+hJhcR3N8JdNN1u0P8kHGeCR9hiRX136vUruanZUMUTuH9RtisVuDBkEWPwGL3kV9+apE+Qg4KlhQb7UCpc9DMh9XSxIvnvzJAJI7a0CLR0UhR0XiQgoBCqDQOhxJg2M19/k6qepCqVY2D3KV+3vgcEkW4zI6L/PbNMKsI9jQ0Jy3sDV22UjxRufjKT+OrrzaWCU0B3j+pGlKIvF/whdKln8zDx52OKi1cWOHex7XS2gCs34h3t0tRPQhAOy6nLPeNPyLE0C5utdaDoEwe8FY0fAXy7rUcQeo5hkQrtF8UiPYHI1TScoL9o2eF0xWx95pixjD9xOfGQM2f6BJQd8m9HsUyHJeqljbm/zuQzGr/H+8zfp8UBPxD62NGdJ1uqXV4l2GCt5GkROuB+ImlswQMt2QhZWyxql3JKd8R1HLlqYGt/wYSrFN7HcptJIvV9vGaegwPLVGmEc+9F1zOF4YID5qjaD+PXyqlypyKFyop3XZXNHhzzDhH3YpqEo1T1DdzhPmWKrhmXs/1roOyfpMJVkYiEBugsyt68HMr15iooOPVrPgfcRNOnksoXEe2WfYJHKOY2uYv1YVLVg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a648b713-e17f-430d-80c1-08d836626364
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4290.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Aug 2020 21:32:27.6620
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: da3ULpmT1Qk+dlrV0ymvgN4i1tR+VUBCgVMi/Y7vjHr+NzrC4iyXKVPJwq8Fd0HkDegghBWOVJZiSTv4b4d2ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4452
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/31/2020 2:11 AM, Jakub Kicinski wrote:
> On Thu, 30 Jul 2020 15:30:45 +0300 Moshe Shemesh wrote:
>>>>> My expectations would be that the driver must perform the lowest
>>>>> reset level possible that satisfies the requested functional change.
>>>>> IOW driver may do more, in fact it should be acceptable for the
>>>>> driver to always for a full HW reset (unless --live or other
>>>>> constraint is specified).
>>>> OK, but some combinations may still not be valid for specific driver
>>>> even if it tries lowest level possible.
>>> Can you give an example?
>> For example take the combination of fw-live-patch and param-init.
>>
>> The fw-live-patch needs no re-initialization, while the param-init
>> requires driver re-initialization.
>>
>> So the only way to do that is to the one command after the other, not
>> really combining.
> You need to read my responses more carefully. I don't have
> fw-live-patch in my proposal. The operation is fw-activate,
> --live is independent and an constraint, not an operation.


OK, I probably didn't get the whole picture right.

I am not sure I got it yet, please review if that's the uAPI that you 
mean to:

devlink dev reload [ net-ns-respawn { PID | NAME | ID } ] [ 
driver-param-init ] [ fw-activate [ --live] ]


Also, I recall that before devlink param was added the devlink reload 
was used for devlink resources.

I am not sure it is still used for devlink resources as I don't see it 
in the code of devlink reload.

But if it is we probably should add it as another operation.

Jiri, please comment on that.

