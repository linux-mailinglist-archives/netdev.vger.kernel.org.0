Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21C3D532AA5
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 14:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237473AbiEXMsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 08:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbiEXMsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 08:48:04 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD3056C37
        for <netdev@vger.kernel.org>; Tue, 24 May 2022 05:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1653396482;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=piYehuOsPHEH3zcOkVaVfcREcZg+X8jXeRT8GGUo2jk=;
        b=GIGh0EB1ozdzWIjVh9qjdSgGetUi4xwRJZK3d8WVPUzq9+FI6yDZIghRxgu1KA7rC3vXOX
        rbc8IM4TNH4DGB9ZP1S1llp5so75T6OeASpjbB/jkvRTrZfHU6BQa3U8iUQ2cUFdmD+8RJ
        mw6ojOh8/zbGEW2xyua9QDuTDgSSC8Q=
Received: from EUR05-AM6-obe.outbound.protection.outlook.com
 (mail-am6eur05lp2109.outbound.protection.outlook.com [104.47.18.109]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-34-LDAEgRCaNIiuYaxYtl2O2w-2; Tue, 24 May 2022 14:47:56 +0200
X-MC-Unique: LDAEgRCaNIiuYaxYtl2O2w-2
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JYp9DuZx+47WrOxKYbUYYXlc48Hn97mr25dKP584ke40vF0rL9SBDQ5CEfGB5k1Q476pdIkwjnyWVmMLOJvrnYNdW1BaMXcOauyu+VFyTyXkwSdFIs9kM5DRDPZDd8D30fqYqDldQvXtEnCq8I9IiQaH47Vf6cJ6oPCuR56hTLQfsNHcTDfQoZEIvQyrDdgX4g465cMs1yWco0E5EsPUr/zux42LNVBjb2cHLLcoQIrVOENs5BHO4ZJnpagq3W4jKbKb6a8TLxmLxzHug2rRogdcraqDjru7gHssLHl182pPoSYNKjqiaxpFIAKEkvqBOXX1bYBqjdsRDmcb8ija6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=piYehuOsPHEH3zcOkVaVfcREcZg+X8jXeRT8GGUo2jk=;
 b=UQkdw0NBuNrLfsFx88NMEqrKEjIsdxTr1MipJE3PWtXIgRPY5e8isuEkhvcvyb0cnNv8M6lAa8qjpSOQ3we6eRt6PGpzhwobuwlc6C8Gbsu5Shny/AaQw8I6j8tQUAj1ESsBB7CAPa1WuJinSi43MmKmhTSvl0u+1PDrIh7m71vNAJc0q230CWKh9x1qcv91cd8RdEDaDFzYZYrZJsCjQmR5P77xQWqPYY36DO3YOG1In1E7dkfVKCGTK+qhR6Etf8lJdFlhn84u5QCTwFULho5qS+8LeOqldbYPbtK8aTXxnc40tAIoxKuTCJGgOB0jlQewwMVw7X4Cg0+ATZL/TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com (2603:10a6:803:122::25)
 by PAXPR04MB8143.eurprd04.prod.outlook.com (2603:10a6:102:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.23; Tue, 24 May
 2022 12:47:53 +0000
Received: from VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::91b8:8f7f:61ac:cc9b]) by VE1PR04MB6560.eurprd04.prod.outlook.com
 ([fe80::91b8:8f7f:61ac:cc9b%7]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 12:47:53 +0000
Message-ID: <d73b1e87-bf6d-bd18-4b0c-431f8357a57b@suse.com>
Date:   Tue, 24 May 2022 14:47:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] xen: switch gnttab_end_foreign_access() to take a struct
 page pointer
Content-Language: en-US
To:     Juergen Gross <jgross@suse.com>
Cc:     Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, v9fs-developer@lists.sourceforge.net
References: <20220524124137.10021-1-jgross@suse.com>
From:   Jan Beulich <jbeulich@suse.com>
In-Reply-To: <20220524124137.10021-1-jgross@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM5PR0202CA0005.eurprd02.prod.outlook.com
 (2603:10a6:203:69::15) To VE1PR04MB6560.eurprd04.prod.outlook.com
 (2603:10a6:803:122::25)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc1c3adc-de93-477b-a47c-08da3d839e85
X-MS-TrafficTypeDiagnostic: PAXPR04MB8143:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <PAXPR04MB8143B67FD8EFC2D2A122FD3AB3D79@PAXPR04MB8143.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QsLbAR8stLSSmZfvID9XqngfmmnrXiBCUf8JuyEq4YCDxMrYmnvUDbEjl1/P2XzT21JcqxXU/xMqSJXYbzp/h777jpVF/Lk8e3UfgoVynIqksEjr9kAE10Dzs2PkrF8xPg414oif+OJ9rtlDFibqR3AvSI837Y97FLTRTOnSelgf79+GZt6Fi2gTwxL8pffvpaUVqkA83+hsnBHd/jbg8eLARgiD9Px6ENsfxPuLBbvgi4RDY3MNB1IdxmPJIsiM6blSY6jYnT3EbFH/41oK5AoVnKiK3E+puvmtGidJ9yncLD5C9tSkz/5cexQsLtK8orP5tLNTrAU05cOC5dO0AwtAHNI6txclF0fMDQAkcSl/d16jWc8RqSGZbJdRMbZZg+07TMtsgR5aTTCixNt3mWdy/e3+G/QNy+WQvEBfRMzDmByviEuYXQ68Xw5VZPQ7P2Cf57k6qKmAHuicnZtiRcLCVfetlrsdlIltORLLvhgjOkqPlAjnhVyrUbB/kvVnO+5z3omegRohvvQcSY2caLwhWPcOYRM7XZpdjtknpdY7ybcvAKncegnE3Ah/a76J3uJ37jEN9/I/tBbS5wYTTV29WN0JapgX1e4JROkP5gpL5YVEBWqGwwRNkbCo1kDqYHzxk1pTSpDtwACZ5AdsnRJbOs0CVoXxzfUV6OKba3PGC4j8uCCYzzeXZHxyXFJwhr8aXA/6CX4o7iQOOcW/RbXL+pMwA9YvEKa+H6nIAg/wk1BPIyZkzMQH24f2adUN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6560.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(31696002)(2906002)(2616005)(38100700002)(316002)(6636002)(54906003)(36756003)(37006003)(186003)(5660300002)(6486002)(8676002)(6862004)(4326008)(508600001)(7416002)(66946007)(8936002)(66556008)(66476007)(31686004)(26005)(6506007)(6512007)(4744005)(53546011)(86362001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NU9URGdjZDF6NnVpNmFyUEJOMHpzUnRGa3FTc0hkYWVvam54djFiOXNxRHRs?=
 =?utf-8?B?cDBGUS9udHdSVElOZ21tbVpBeHVYZTh4MmpRb0gyT2J4NEtTd09HTGdCM3Bo?=
 =?utf-8?B?eHlnbkhlMm5JUVlXakFUVHJINEhTNGtVdHBjOTYzcEc3TkJoUElzY2d2UUIr?=
 =?utf-8?B?ai9xK2QzTStHOEVCckV6MFVOQ05mNWk5eXY5ck9CaHVwMXlHek5ZZnVpQVE2?=
 =?utf-8?B?WDkwb0k0WnF4VTF4Zjh3Z3RKREtaQldPRTRmNUdUbFZ4enNsZWtSeXZGWTVB?=
 =?utf-8?B?REdVa1Qyb2FZZWVOaEp6SmY5ZktKdUsyMFh6WWZReURjeWsxV2hXWnM4ZTdt?=
 =?utf-8?B?QTlkalhIbzRST3lVNWk2VFM2UXdCV2VJUDQxV2x6cGhSem1wOThKVmtzUlZx?=
 =?utf-8?B?Y3JyRlJIdFlaSC9JbnB5RVI5TGQyeGh6L0FBMklIUExDRFlvZGJzM2ZHMExW?=
 =?utf-8?B?a3F0MTBSRXRUWDhpcnovbndXVm10VXB4M0N6and6NXpTU2tyKzBwRC9aWnI0?=
 =?utf-8?B?ck9URXBPMHVQaXQvQjg3TENWNCtuK2FmV3E2Nm12MUpKMHdwYm9ORzdvLytE?=
 =?utf-8?B?Y21ZL29ncjNzM3N1bTRrRUFwOGFvQW5qT3BiUU0vbjY4b1A3YzNFVVlHeU1V?=
 =?utf-8?B?ZDNWYzNBSU15VHl0aWh0QlJiS2JqQmxzc0FNdDAvbzRXa1ZvK3lyck1zaGVF?=
 =?utf-8?B?TUpiT2VMVnRyWGV3bEtTTmJSTVdqR3JrV01HQktFSURVa1ZqalkzcHI5TkxY?=
 =?utf-8?B?RTVYeU1DblMrMFhaNU11NXdhcnFndTE4M1pYRDc5eWNaUDZFSk8wQXgxQmFz?=
 =?utf-8?B?V2RKRkxGOXJTOHNXOExVY3ZuWVZ6RUw3WUZxMnlNVmhxMlRScFhlUUhsK2JZ?=
 =?utf-8?B?SHlSOUJpOWtPS0RPYy9yU1ZaYTJMT2xGblJzcDYzRld6ZVNaTTZWMmNLZGpF?=
 =?utf-8?B?dUNPYjhxQ3Z4WUFSSlZTRm9IMUNrTnNuTHVwUDZoZEduZm81NG4vZmhaTUlj?=
 =?utf-8?B?Y2tBYUhoTUg1SGRTcnhxb3lDU2QySmZ0V2YzYlRuUm5Qc0l0TThGWE90Qm40?=
 =?utf-8?B?MTNBb1BaWElRRXpOYTF5Y1FGNzBMc08xYUVZT0E3Q2pLVGJsNGhxaU5UbnBq?=
 =?utf-8?B?OVJVbE5HbWlFN2EySGJpK2EyaGVjWWpPejAyTGJLVlRPbEpHRGNmV29RNlhB?=
 =?utf-8?B?bGRKVXl0NVdYTERBWXRQRTQ3Z1lSRno1UEZtbm5hQnBXY084U21sQkl5eGZ0?=
 =?utf-8?B?ZWZNTG9oSUxLYVJmTTFBR00xS2Q5ZTg3bE12RGVHVDNrbTVmNHUzaDA2RVZt?=
 =?utf-8?B?S21BUjRXbFJRQmc1V0M4ZGNtWlF4ZWI4OGcrMEFMWlRUK1RQOFo0REdoZW9C?=
 =?utf-8?B?Q1ZlalhBT3lwdGhoVyt0YjZTUmp5ZFk4Q0tVQWpNTHpIcHlCc1c0dzhvTVRV?=
 =?utf-8?B?bXN4MUd1VE9sNm81aWQxMks4YmVIYXNsdCtXUU1wTzhzb0hBMHI0clhmT0lE?=
 =?utf-8?B?WVBmL0lMaFQyUHN4eHVXbkdjU3M1MUNpa2IxbG5CVWJvT1Voc2VRNm5wamZJ?=
 =?utf-8?B?NUpvS0NROFRMM0xwVCtwM2JRVndtSGZrZG5GNjVjSVJWbzNkUVJsL3pQSE16?=
 =?utf-8?B?NExSeDNpMkpFNU1vZHZhWGVoZnFjYkxCeitwejRXVEg2dlRpV0dBYnVMMlVx?=
 =?utf-8?B?QUpaVmV6ZEpWYjUwTE40b25hNmY5UUtJWXR4bmkzc0dYZHFqbk9icXF5N09Z?=
 =?utf-8?B?aTJpaEU5b2RyWVpmNEtIWVd0YzBJNURMREFndUExWDVKUnlLclVDZTEzYUls?=
 =?utf-8?B?ZU05bFQ5d2NHclVlRFFwQWw0WExTMGxIcTlrMjBWYnoxOFllVG8yZnJjQ3NH?=
 =?utf-8?B?RXBhT1FQa1Bodm5vMWNLV0puRXNrRHF6RStnb04vdGJ4U00zY0NrdDFUcGNo?=
 =?utf-8?B?eTU1bXJyNmQ2RXdPcENaeUNtbGRPM1YxL2p1YW5mMEdJQXZGTGxLZHdSVWJT?=
 =?utf-8?B?L0NscW5ObFlBbUJDaHFUVU1jdEdzYzJGTnYzS2ZIb2xMRWJ2NmVUNzhrQXYy?=
 =?utf-8?B?N2pIT24zWFQ2ampMMEJmSnBNNWhOVWtBcHY3aGxTMWhmQm5CZ2M1N2U1UFJ1?=
 =?utf-8?B?RklUYTZ6NjZyb29BdVlqSUgxN3N3Ti9saVRRTG9ZMEVIVzFYT0FML0c1am0w?=
 =?utf-8?B?OTQxUTAwTFhUVWZLNmVEV3FtNENyN0g5UHE4emJvNmJxTVNYR2h6WVFqUTZj?=
 =?utf-8?B?VmhybEpndzFOWVl1N3NQbWU5WCtsMklKdWZSV2g2Nk9kSC9uUXZSbHhBYks4?=
 =?utf-8?B?cTlVLzZYRGJqRE5yMDNxeEZUWk9JWndiNWlvUEJzTmFDZFExZW1rdz09?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc1c3adc-de93-477b-a47c-08da3d839e85
X-MS-Exchange-CrossTenant-AuthSource: VE1PR04MB6560.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 12:47:53.7633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bcH45iaFIUCEJO+WopRz49xyOoiV+veTUrgHkbMsiaHEswqlWnikUg5gQ+JkfkjQ+6s5G/c855867/5FZ/Kwog==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8143
X-Spam-Status: No, score=-6.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.05.2022 14:41, Juergen Gross wrote:
> Instead of a virtual kernel address use a pointer of the associated
> struct page as second parameter of gnttab_end_foreign_access().
> 
> Most users have that pointer available already and are creating the
> virtual address from it, risking problems in case the memory is
> located in highmem.
> 
> gnttab_end_foreign_access() itself won't need to get the struct page
> from the address again.
> 
> Suggested-by: Jan Beulich <jbeulich@suse.com>
> Signed-off-by: Juergen Gross <jgross@suse.com>

Reviewed-by: Jan Beulich <jbeulich@suse.com>

