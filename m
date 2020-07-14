Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6CBE21F7C3
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 18:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728853AbgGNQ6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 12:58:36 -0400
Received: from mail-am6eur05on2049.outbound.protection.outlook.com ([40.107.22.49]:52320
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726062AbgGNQ6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 12:58:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HbdT1Lxay+o5LFx5cjVkv7I/wDHlBmeo0opoLpJVkOAhH4WUYLFuAVpQ86k+NNHW6pbmO0hYdu/PZoOZ40Skb8GQpdthy1Ovmf0Yy2K/JOcLvvM7Jv7PDSaDjFbE9aaXXoRFhIWusRqNEiq/828itB57+EWKJyH3PA9qyRNduB8o2vod2DzRiu61pmtjYSHrH9O17Zj/AJTxNoXl4IST4LxnNPutYtKBkARYqNa4KAkAjNkbNru31auAD5aMkLvHLCBnRj+CX2oUVMPz8w/wToGwSaH99z451nLfouU20nb1wcWyO9Jnh24bF1OPFFLq+zJO6UgA97yO/53FkWddAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ViUNjE6pootbG92lPEGS+iskodfGQMtiPsVqUrwOJRE=;
 b=RMD97ZsCO6c3HtpybWssgXyBOMg8nY3CzAQf0mYQm1PvLiDjwYE+rScVSCVVTRBwpeVl1/CpWR+IH/UmDRtwle8LX4CvFhSY8p1FmpeQpQFu4p6noVpUTm9qIn8TOaa6vFWaPnd9QkbDKE48kdFgIwREvFDd8s8a/L7UTAt/Mie8GoW0VqHxqBSSUvwLr054OS1kSSdBCIJ0xfwIDMxwu7Oy7V6rToIUPDQ7aIdEa51Kn0uB2p951H5bZojloJltvSD1NIYcjLZFqR2PbL6QkKyz9C4qTXgk+YOvHlpCP+C69Egy8AcnB92aVRL9brj7RTVSIf8ylFUZX2pdg0q2Ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ViUNjE6pootbG92lPEGS+iskodfGQMtiPsVqUrwOJRE=;
 b=XQ8BMFO8RZ7Ysg8GNEuKFkO2Mbs6qdbvR5/ZTsyvjnELJ9K6PfR1K5vDLebbVQOhhqUkaGMp9FFvrTq0epR05xG6rFH4M7F9f92ftlb2xLYk2EBOnxj5L9VDRpefhNabyjmWcsinpvN2BKx0GeCRaJ1VRMck/uSykAsWeIgkqY8=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR0501MB2842.eurprd05.prod.outlook.com (2603:10a6:3:c3::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Tue, 14 Jul 2020 16:58:31 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.025; Tue, 14 Jul 2020
 16:58:31 +0000
References: <cover.1594743981.git.petrm@mellanox.com> <32c55df4e3926b646ae2e818ed741b1b130d3b43.1594743981.git.petrm@mellanox.com> <caadc097-5ca0-00db-da7b-0a653fdeaab0@gmail.com>
User-agent: mu4e 1.3.3; emacs 26.3
From:   Petr Machata <petrm@mellanox.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next v2 2/2] Revert "net: sched: Pass root lock to Qdisc_ops.enqueue"
In-reply-to: <caadc097-5ca0-00db-da7b-0a653fdeaab0@gmail.com>
Date:   Tue, 14 Jul 2020 18:58:28 +0200
Message-ID: <874kqajaob.fsf@mellanox.com>
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0095.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::48) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from yaviefel (213.220.234.169) by AM0PR10CA0095.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Tue, 14 Jul 2020 16:58:30 +0000
X-Originating-IP: [213.220.234.169]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b41bdbb0-7273-4597-e866-08d828172346
X-MS-TrafficTypeDiagnostic: HE1PR0501MB2842:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR0501MB28420097B93F0F37D057001BDB610@HE1PR0501MB2842.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:53;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: C5royYPUYhSON7D6oDWp4Q6Ncd//haICVHlHYi0lXtI71wsNdvGWMBOMwVbAHOfUtVlmgJS/fm/2Zdeh0NuhdW1LQjEAKNoneA2HXBgFPMZjSSFb73BSHgRJ/HxWv8PHGsik88BEGdNaFOiMmIPoivg8JOilBc9aOKeLMrVUIozQcSzAds0j2rYsMBuLGybFuDnODB6stGhfdPDJuKb12KEMXjRUHjJum3KTh+6EdejrCB0vnJYRIVDBOCJIbA/4jXDAehoKT4CqI5AFIjmWYIAe7y1GDogYPWrbnbp8RMYURRMsyAnk29V3O8pNBu8+FCF98nYaQMp/UPLQxJuK8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39850400004)(396003)(346002)(136003)(376002)(366004)(66556008)(66476007)(66946007)(316002)(36756003)(4326008)(107886003)(2616005)(956004)(5660300002)(16526019)(186003)(86362001)(26005)(53546011)(2906002)(558084003)(6486002)(54906003)(8676002)(8936002)(52116002)(6496006)(6916009)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: mOe9gxIktT81PdLJtlWNHrXnursobwoemfRNf7JnOqgVd2iitJKZsGKq7wJProLek8qscmxmOCgpXewrlAdAla1HMlIqbSS0CPq3tUerUXL7KfQN9gcu8d3H4gBYQ4AfAkPV51V7ywA4PyWsPAMeLaOQLakMFfpJa6jEM1laNANos7zpwrQPxhenFdz8fiL/Y6cRjM/C1My29chCwh/rb8MhOZ2ozeLIA/eGvIglD7um5TTVOxyKi1Gqiw+zULYaXliqytOoaudOB25PeGyQfuEzPu4T4wZvTE/9MLGDryXsj1TEzFeINAzi4mlfcyycQWtnZuDQ2/Gk84nwKRkwRG3skjLbxrH46xecz32neoNitnP2lKKulv3wNoppoEfr+KhEey9cG1LOKYel8/79Zwko7L+S06uJ7lWrPH00A1P+3JGUcrNBFpPmiRo4M4/Z2+E55oYCUPZ6qx5cXXBTDKYEpQHuV0fuILaDV5sVZkgB2nfLwVFrWOQt3BH7DSXY
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b41bdbb0-7273-4597-e866-08d828172346
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2020 16:58:31.5912
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t5lZg/0yX+LrelqE8/2bwwgs6TS2hi7kt5fx0xEYTuNKk1UVucCXBIXb7Bh9g1HCE0o7v1MA8PydirsLfZlGkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0501MB2842
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Eric Dumazet <eric.dumazet@gmail.com> writes:

> On 7/14/20 9:34 AM, Petr Machata wrote:
>> This reverts commit aebe4426ccaa4838f36ea805cdf7d76503e65117.
>> ---
>>
>
> Ah, you still need to amend the patch, to add a Signed-off-by: 

Gah, of course!
