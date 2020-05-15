Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A01B1D4C87
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 13:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726140AbgEOLZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 07:25:57 -0400
Received: from mail-eopbgr30077.outbound.protection.outlook.com ([40.107.3.77]:63725
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726023AbgEOLZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 07:25:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dOR+mDE1QKoY6ULuwJcW/MfOhZKCl2N3WE2Uv0ojLGlZOFgyw0yCmt3hxrpdPorFjE4fwCI/1mgIz8lcRFebPHfMmSLFIg1iFbEQNUEcN4gzoIIuilc05WwigDM2iPbtyEeGx7QCV0POWOM70v0ljLMhZOGVeoPY/nf0bOQW1oyxTS4/R8IfdTPNntzGRzHZxPT1+40uKimB2KWWapiTAMBPbA1zsJRE7Tt3xYHQwshrU8TdE6A2AMaYRDPDEJXHe8SSK7Q3jsEl9dMwi8VZABrokOEKVMVLeCaiThH+aMc7h3mxxJG2CQWv+1u33StWjUvRTTSjxvtf5KA9+7ywsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JCPCbfUgbzPiafuvaXlN5BA0ar9HtpqB96hsc0pJfU=;
 b=Sbmp2hHYw68nx7swf+JErYPhDD9dzkL0HrjWNtzjQZS3wqPEmdG779BRu5elyF74RoM50j6DtMbVl2LXdabZ2+784Au0TlwUcorEdapStqRkG58jKoo9B3o+C2tJINeNgIOXGPBHM1EwIJYYqhkA2ls7RnLyuQm72PyaoY59ekPcAAXiYYmTazrg87MrAkwzzjhPK+6m/Pf+ZKUckxV/jldgpv0AmPqFvvYiEEicIXBQU0CLxVMMO5Op2MGockG+HSYMY1lAC9RTtBC0l5bXOryoqxgpp3rIRhRInpok3J56mQ7Jvc1p5U5qB36rE+moK+BoHfDq+KXay9e9/z0wPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6JCPCbfUgbzPiafuvaXlN5BA0ar9HtpqB96hsc0pJfU=;
 b=P8NYasMNFaFsnVb/iXP5Epn0bNPSp3Mi0HCEO4DO0ebAXK2UzJyDvHmrMUcY5UtPRlnKT9++hbeGc/mzG1uXUgJcgG2IOzwtfRio1ZZVI++4XBqtEqrjUGRUQlGTALUgdIu4BMBuJhs6noPJsthzpcopE5NF9RdrqjqEg+xbib4=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
 by AM7PR05MB6664.eurprd05.prod.outlook.com (2603:10a6:20b:141::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20; Fri, 15 May
 2020 11:25:54 +0000
Received: from AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e]) by AM7PR05MB6995.eurprd05.prod.outlook.com
 ([fe80::3903:9c1e:52e0:d74e%8]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 11:25:54 +0000
References: <20200514114026.27047-1-vladbu@mellanox.com> <20200514102647.5c581b5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-agent: mu4e 1.2.0; emacs 26.2.90
From:   Vlad Buslov <vladbu@mellanox.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vlad Buslov <vladbu@mellanox.com>, netdev@vger.kernel.org,
        davem@davemloft.net, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, dcaratti@redhat.com, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next 0/4] Implement filter terse dump mode support
In-reply-to: <20200514102647.5c581b5f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Date:   Fri, 15 May 2020 14:25:50 +0300
Message-ID: <vbfpnb5fni9.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: PR2P264CA0004.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::16)
 To AM7PR05MB6995.eurprd05.prod.outlook.com (2603:10a6:20b:1ad::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from reg-r-vrt-018-180.mellanox.com (37.142.13.130) by PR2P264CA0004.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 11:25:52 +0000
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 4085118b-0d22-46eb-d40c-08d7f8c2bad4
X-MS-TrafficTypeDiagnostic: AM7PR05MB6664:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM7PR05MB6664AC7CEEBDE97E0CDA2187ADBD0@AM7PR05MB6664.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J3FI9vo7IncT8NnZiZuQCkDwLRReXKeYoWmsUidRWbyV0W0V8KtmbPeqXOHALSHSiGMU8ULOe5Zk3x1zU/GZgRnpf1Cn2GaRX2NlzP8DhJME2SbIns+W6Te7iXLPbetLsaAbzQnsdv7SIszugHPIyG4XEL9Vna+aiMZaQoN1MtSXB0qxtZMqMaCdzZUuMqrZVTDadWK6pjigVHBgCCiA7sqO7cJMcrJicMkEndYXK18FGFNb8E2BzLob96Ja5N+tZrpIvXpNXV+JMWZsstydAhrQ6kLUOlQK/z2ADdDXzZ8DrL61b0APQ4bgVfhm2TZMODMgOj+ArkmX+40HkZNp+l13bUuvZvJAK9kmCGlx3h7n4zwJE20kwjXEKW4cgiPVwOEmubbMEpfZh3OJpS5JZLm0NwmhgHtVezfB+NBbFAcIezDL+vNpuO/R0ThXOkd7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7PR05MB6995.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(2906002)(16526019)(316002)(478600001)(6916009)(6486002)(8676002)(956004)(2616005)(8936002)(66476007)(52116002)(26005)(7696005)(36756003)(186003)(5660300002)(86362001)(66556008)(66946007)(4744005)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZBeIdOzEXpZ6glrNZlC2ImjAlhToCkT1O6w0k2EqrnlSzoYRWuU50mC0ZYUGQD6jPFle1fuWC9PgBEP2JzOry2LLvrkMT6grRuzTKA3kVLj/HmpN5Kvxy5ufUhdZlOt51f8GLHPkYT9YPEvYzL0DP+GjvCgvXomvR7kpBPJEExCL0UnpNUKqap3twb7y1Rja1HT+jkxsE0kCv1t6SD9xuExY4EHJwBHtJAxtTxj3QnpO8q4TllaonDm7kKJZbX8rAo6wcXQsV0jWrJdMndP7cE+rjS0L8s9OQdM08wq28Myj6XgzwT0Yqd+732HglAgWKWh4O63M9/movPMQcuvq5OgyZWb36T02v6VCqhwvrQaP1n6GzrWrE0Qgl2Ppzd094vdF0iFBASZ4qtYQnrPokUYDNg3+v7uJQftejjIAw/AjEAwEmAlMXq/F4AwW0QOsraOPb/RVPnqm82SIz3l29SExxGwBH6T4SCDbN7Oc7IQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4085118b-0d22-46eb-d40c-08d7f8c2bad4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 11:25:54.0776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kaXIxg8momvOmIg1GVEvOC2AnxKE/FQ1xb5iWNWEtJ5LpEJ35RPIf7V66KpJTKez9+IJogb8riReQ3rW5FYVUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR05MB6664
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 14 May 2020 at 20:26, Jakub Kicinski <kuba@kernel.org> wrote:
> On Thu, 14 May 2020 14:40:22 +0300 Vlad Buslov wrote:
>> Implement support for terse dump mode which provides only essential
>> classifier/action info (handle, stats, cookie, etc.). Use new
>> TCA_DUMP_FLAGS_TERSE flag to prevent copying of unnecessary data from
>> kernel.
>
> Looks reasonable:
>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>
> Apart from the change in NLA_BITFIELD policy build bot already pointed
> out there is also an unnecessary new line after a function in patch 2.

Hi Jakub,

Thanks for reviewing my code!
I'll send V2 with those two issues fixed.

Regards,
Vlad
