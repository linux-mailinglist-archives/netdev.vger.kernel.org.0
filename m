Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C53F26A468E
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 16:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjB0P4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 10:56:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbjB0P4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 10:56:40 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2122.outbound.protection.outlook.com [40.107.94.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3ACE20682
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 07:56:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XXFYLpfVE1Z5TF2sh3+nuojrAkn7GTcH/yA/DV7GyGMgWzgfu59uJa01EbZs+jc5gkb2cQbUK1Ywri5UoNaW8W0aX/c8VDXFoQxGpuZd98NlNWEQdh4UFGsV1SUN27k5GxrOBiWfeh/VOGF5yf+v6Fifopi3cQKYRCxreLnkmGh3TsYYZxbVV4U41EiOo1Ng/lBvGWkOj46ieVh6H8kT1OXGzE1KBMy7YzNuARMLB3DDqvVQRo4x+649KIQBSaPh4iaLecouCpQ2fj6KtfQWfnZlJ+0KKl2WB3iE6OigyPlil4PAsi1+4xRJLTZCVdzkePKywRStbD8CnBNhtN95Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yFSmcoExTwNTc70Jzp8Dq7QoY5S4oligP/vNKDNMK1I=;
 b=JnHx7yCTdGHbQ1zL2Bh5k3IOsPoIGVXaRgsd0rWBo+E3xVe6PO7ZSx8FTvdE0VDiw9SHzXAXiTpN5FHj2g85y1q+H/qKcp+21G7JhVywrWqF9R47o8qpR7ZqMTg+Pr+PUx1BJ3RG1ASzeUO1jKNUOBQSLeni3fYhRLGbVPRItIKGwn238bHl8cSoJ6ioVujq6ucNd1TL2GU68DLo7LiUToVLcYwTPrtacUltwBzPb1POKz18ImcRsqm4PwdyW3Mm6P+oSbZDWx9KU+OgwNLCw8LvXgYmxOV98Dd4VCZfHgBmghqyLIH/bKfATElttLVFA5b+CoHZKOPVTO3rEgnAyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yFSmcoExTwNTc70Jzp8Dq7QoY5S4oligP/vNKDNMK1I=;
 b=FnYYlye4OHeqH7WWHyMZbMiizg1z6t4OmgSCeDmE8oMQQz5cbBVSPuMCVjajhVw8mv+fZdgZHJzpZZ3jd9ZS8GVS4qsqAXCifJqJ7O4Zf+gVZT0NrLWb6zMX3oKA5uxgSfLarV4ZAtPwuh/hhhiR2eJApzqfzggvNHowLYPb1ys=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB4159.namprd13.prod.outlook.com (2603:10b6:806:95::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 15:56:37 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6134.029; Mon, 27 Feb 2023
 15:56:37 +0000
Date:   Mon, 27 Feb 2023 16:56:30 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, error27@gmail.com
Subject: Re: [PATCH net v2] net/sched: act_connmark: handle errno on
 tcf_idr_check_alloc
Message-ID: <Y/zSriFDhaywcFPZ@corigine.com>
References: <20230227152352.266109-1-pctammela@mojatatu.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227152352.266109-1-pctammela@mojatatu.com>
X-ClientProxiedBy: AM0PR01CA0141.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::46) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB4159:EE_
X-MS-Office365-Filtering-Correlation-Id: 115a63a4-b095-4499-4a5e-08db18db3514
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dmc6g9+ZGmUPBjvznuCecaPpr58e76rLxph9H4NxfQ4wV/1bMIjiIl45hUk42W8goWPp6l3iIAkGtHureBT5MwNL4I8ABIajQMIoOqHzjafC4PjD9W8siSWuvyioQG+0pXLBc+w+YZTxMBV1fIFq3ov08mZQQiePfI9OoS6nTAoDbh/56NnTmEYbjZB5imfIUMK0Ioi+rbL5F6whhf65svqgx2yGssqWWWOmUts0l7936Cd64CXJWiv+ZGIyH6WyZSs/fHA+y9UoMEMqgrWUKyvSMVMUba9E0E76zGj8LAuZo7sUyhPlznG5wuF1fWDs9WbE9+vXyMCokSERQUA8EGCEGT55DDQWgzKm5a8JeZDnxn9cluX5qWn2hyW/grR/hPKp3T78IjV/Me4GrnCAzVL3E35i348lpAMl8EXDLs2y+61e+km1vPL/aoEHNenlXLXlPBCj0p8nZi9z5Y5X0x+0DWYVDI7bxy9Eyfu7ae047be7I8un68j3RmyyQjf+xVP/VoPWfakAX8YHhKpIFtbtQQ/59SpdUpaspxBS8amFbgnXq1FRicsJmfEm6TnQ6fapGvJAnBfnvPvFQa69hUJglBc3QtQAuK2kQvMRqQ2jagSubzfT07YW6b0rRbuxvv+/bj3fRPCuZULbisYwF9xJnd8H1g+N/XxVbvy+BzlLXJwxbtzKVFLrsvOO7TXX
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(39840400004)(366004)(136003)(376002)(396003)(451199018)(2906002)(44832011)(7416002)(8936002)(4744005)(5660300002)(36756003)(41300700001)(66556008)(66476007)(66946007)(316002)(4326008)(6486002)(86362001)(6916009)(8676002)(478600001)(6666004)(38100700002)(6506007)(6512007)(186003)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+qkNi+YZsA32Rq2ejkf+Jd5HVdeh6OXwPZJy0xP2925kZ1S/M0EA+tmvi1IU?=
 =?us-ascii?Q?DjZcEl5MLSTKn4aSgltpH5udpblPFBGkKueh94/sF7KpjxClqGsUly/CyEDW?=
 =?us-ascii?Q?1KmkTuoBnZggKe/PrK2cXm7VOs24eQnPFp9f6jI8wK9Lf8OUTfM744nhxaVf?=
 =?us-ascii?Q?6xBUBykAs9Jm5bIKq+ThTpddvlU1SpXO+pS+n/ACaZSlmsDCvhFormzscxLb?=
 =?us-ascii?Q?0L+fWzomrNJRtuwSVJ7KqcdTd8tMAiRzcjmmekqnr8uK1iC+sL7KICRLg7yo?=
 =?us-ascii?Q?l24ICpRCrbPULn91fZtiw4R7s0/hYNkecWOySX/5zFwM8KQhVxzCwdXX/AA6?=
 =?us-ascii?Q?v3vAA1yziFobfRaemOBdJo7lZyHMZ1UwzGfmJ61P1weUomMHa03xFuk12WFT?=
 =?us-ascii?Q?RLU4JhciaFw5KVzGBgTlDWSVHogZJg03voB/ptthaDdLWI3ZH8krGq1kTIDH?=
 =?us-ascii?Q?AJqFiXcHd/jwb5nfvu8jBSO5PSkBM9PvsBB/k19MDO7V/gtv6AGANCuK81OY?=
 =?us-ascii?Q?r5NUCfqcK4jVpfm9LI3S/51xcDb+WdDzk/PtyMPiYWmqa8bBsfMlWWFrdo8f?=
 =?us-ascii?Q?OjQNrS6KtTFMPhCOUGdGmUfDN32DOwkU4ZJ8OMiRgd8VDCYDnImgY3Hn0akx?=
 =?us-ascii?Q?aDA7CLChCVzPfTFThkB/dYuwEvioEwUh0IG9r6+gexfwOuc7uN5HctM7thNw?=
 =?us-ascii?Q?D+TsvZn5maOpssV1BAtgPw5Z05Lsfg2SOKrANytwk0nmmVzBP8bOuKZw8d2B?=
 =?us-ascii?Q?cLesI+dMpmMiQtowR5ZyXCzOEiQFzGlij0bVb75dMdPNRJwgX31ywIumm/mQ?=
 =?us-ascii?Q?k2JPj0Klf8nIHdsyltfWltNUrEOgR4Eaw+WLVolumlKQPgpNMHFbNwFmsKbV?=
 =?us-ascii?Q?Mj6woVUWvvOMqo7qtq/s/jcKHGye2zM6ofQeXdkgrtxBpYGsOJ53e5cv71uT?=
 =?us-ascii?Q?PrAfwXcM34KpDmEnGs5ltHfi5BPHg5XndDkbLI23qHWtpBnaIVNrhH7/vcv7?=
 =?us-ascii?Q?fCbGfUkHBZfNvDThJnz+qFm1tIN7dV40+uLQY+NlLtWiuaxpI34oZ+RrGNxT?=
 =?us-ascii?Q?TXEmG1eV/WbmsrDmMPKzuweSuhX/ZbAC6qW1qAuoSxbMm8TFBr0aaKCB+ASs?=
 =?us-ascii?Q?HlcV4l3OV04M7yM5lrJ8CdyVFGfGOrt8F7HuJ0E2paPlsWSf9ffTpG/ed1sU?=
 =?us-ascii?Q?iujxErcP0iz7O4vyGN5W0zZTMArCYsuoyeqxafOjarmxuIqXsZszRgBcIzqK?=
 =?us-ascii?Q?jW3jJu36UT+vMhwOG3MSNd3Y5NUnaOQLPi9GjEdauxVEDdJ6bewCSGvZjoWX?=
 =?us-ascii?Q?Lhi37CspLw+d8gw0npC/t2phWj15YowEVYiQbKmEnN3ooRGyYb9ECq1yqMjH?=
 =?us-ascii?Q?HL4fmJAl23IJsp8fnIjUVa+DFoKlal8zPpQgvfOXFSOUJP1YTzl5ef/j4USe?=
 =?us-ascii?Q?/18/yuEy+yKUNGdp/aOlb9CihiFkbA1BntQ5f9P43pdjE9yh77ZjbJvX2Xm5?=
 =?us-ascii?Q?+rIVEiTEzYZJXpj0plbb1G//Z7hg3Z5ML9o1ve/7G3ONWKSd+YFnOX7ItASO?=
 =?us-ascii?Q?Yq5BctK926Ac30js5abWIczVT/y/NFsesiQFQQzl1R7XV+sNBR6XQteN558p?=
 =?us-ascii?Q?YhKdzSLoeQsJOC3LdBvYbPB0IvukiP2JkECsXT1jO/e138fCnDls19xnPQuX?=
 =?us-ascii?Q?SB7LWg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 115a63a4-b095-4499-4a5e-08db18db3514
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2023 15:56:37.1929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hY1BMjKu0N+Sc7ZyHjTjizu5RskEEOLed/OLIVG79j+KKUgO7u36TM8OCKjq1lBjWC3WrY9liFF+Cy3igD85LMYt3rOEdwSIwQW3ZyjXuPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB4159
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 27, 2023 at 12:23:52PM -0300, Pedro Tammela wrote:
> Smatch reports that 'ci' can be used uninitialized.
> The current code ignores errno coming from tcf_idr_check_alloc, which
> will lead to the incorrect usage of 'ci'. Handle the errno as it should.
> 
> Fixes: 288864effe33 ("net/sched: act_connmark: transition to percpu stats and rcu")
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Thanks Pedro,

looks good to me.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
