Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8022B6AC76C
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229494AbjCFQOZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:14:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbjCFQNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:13:45 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on20700.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eae::700])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25D1D60D5D;
        Mon,  6 Mar 2023 08:10:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FYsEld39lSRNknX1cztJC4YSwEYrpj7NAKr8OVPHjnExYrDqPr9ZZOD1felGfvFOWajUOivdUVdEKij4gxAH/0HCloGIp6Vw/fcaWLGQLADQTTsWxR0lIPOjxIo+eqimY7c/7QjYrxBXXXo8rsxFUWhwVSrufCApD2p3SZ/UYQheuN1H2d9W8kUxYaDh010ebSwnf4jMYkNLkFkJIGAcwgTHwSZEjsI3H+ZOAAjQAZR2s4q2NsVVofP/RYEiz6bbQVltEU7XGQ/D0ayDJnZqlifNef552XSCwcWQY+9yrDhAxvDEwkqspcThPREyXZJ3Icmq3Rz6Ac+Ix4ikPSHklg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QlP/yJCVvnEexeGY8HEPgfq5BgclUqytFi+xQaCN4eQ=;
 b=Gi3+GnOJcZ8ojBT46tvC2jsK6gOErlntkpuTk9v/Dv26PW5Imq/FgQTBo6AirOHtxI13kg5Xf0wuCYuW9uqGzCL7TbQifdMqzFYUCYqwyuG4R5NxJrc/4N2vTv1r4IGv0mlWpU+qwCeV62J8j2kbqbr5FycgfMXj68sNQKeX6MADrS6WGozQiaFhw35lIkmOABujzubBKoqpFPDQiNFXvT/526LlxgKhKuBkjoPEq9MhRlseUNw/78wIreFrvsyvlgWAp38DcF07/OQ+AOkEvG7w/WsAAgqTFQO6Uf6Gtbp2+AfwsGa+wBu//JPvh1G3ddryD99ku8VFqr+iwaVfMw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QlP/yJCVvnEexeGY8HEPgfq5BgclUqytFi+xQaCN4eQ=;
 b=tuQXjwahEucquGRx+8bki9TmNTNv6LfHim2CL8j4NulQF+QAnJS5qED5PzCyHnWcGrR4Zn/8di3r9SeVHUNIpqjjItQ1Hd37fA1vAOCH6Vpd1+sQfgmUe+P3OL7G4saHF9zTiH6sghI8lhnXGK5IOhxAHzqCppq0VGuOEtDy2Lk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA0PR13MB3920.namprd13.prod.outlook.com (2603:10b6:806:9c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Mon, 6 Mar
 2023 16:02:40 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 16:02:40 +0000
Date:   Mon, 6 Mar 2023 17:02:33 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/smc: fix fallback failed while sendmsg with
 fastopen
Message-ID: <ZAYOmSy9+pbZpTag@corigine.com>
References: <1678075728-18812-1-git-send-email-alibuda@linux.alibaba.com>
 <ZAXbkUh4h2rIJdR2@corigine.com>
 <5e64b96e-5c8e-a631-287d-f960f52d8aaa@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5e64b96e-5c8e-a631-287d-f960f52d8aaa@linux.alibaba.com>
X-ClientProxiedBy: AM0PR10CA0056.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::36) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA0PR13MB3920:EE_
X-MS-Office365-Filtering-Correlation-Id: ef406200-eb3a-443a-af7a-08db1e5c3698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RWCBK1lbZC5mwcMynr34YgTUzQJeXkuRpkO7/mQrbfqU/zue3E6Za2/8z/+Ir9qvXF0twx7TOs9KelevdnvGsBqS+JIdayeoQqY9oNQfTSbT1RYISoseOWF74EJ8E+BLmx+PLWV+wqmojKZy29YcJNDqT3IhueuByWt2G7QUf6t3f3C/rYiKVow39vh1P7IxePUr3Ecu7HW8UJVCzNN2tpdzUi+yIijrXc5vRwYGyAHAaFVgQXI/9kgftzUWm/eCgIxFlFrob/jPcoBJYsNz5PZrghePqb63vBUnjeOsnjFMldoEWxPWKrG1i3zVEb0iryfS86VljxfDbqtxN0J7N0a68fVjKfsPcd8x7W+pwUnPLk+LrOS9T81cMhgGsBwM2Jfxxle1aUTBWUIfnN0ADB6A4yosRLFdbLOAxTcLoK78T4Z662fvy8uBzE9BT8F13Im2I95uHTRh+D8OMg5AJcCxfvyOWTSxXPsUO6bv7CyEEy0u0tyGbHz61TthN02ht8EAK+XpDohaYaqjeQmDf4eMVjjsfG1p7prSGEXjIQ6ERRZnAkst27UKtdi8n3HdvTmpaf+Qux1kxV/LW6gwW/PpKKSYY/J0IAnkYI6yc3cU68nqceeA6xfrTOwWU7uDEm7+QLful2FiRGBlYoxQkepc5gbdpU9M/qcMaa2zm9k+sqESJ/0MN0DZHZ6i4z/M
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(136003)(366004)(376002)(39840400004)(451199018)(4744005)(8936002)(5660300002)(66476007)(41300700001)(66946007)(44832011)(66556008)(2906002)(4326008)(6916009)(8676002)(316002)(478600001)(36756003)(6486002)(6666004)(6506007)(6512007)(186003)(2616005)(86362001)(38100700002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MlhGQ2FJeWo3RW1EdEVsWkcxdER5Y2NDNHJZZVRFeVFXbml4N1JaTVlTYXZ5?=
 =?utf-8?B?WEFPSWhUV2RkWkg0aHlmQmdaa2d3d3gzSWNPaU5rTldlTnQ2TXdYbHR5NVpt?=
 =?utf-8?B?UklmS3Nrd294MjJqdFlQbzg1RTAwQjNHZ1lHY1Y4NUZOYjJjMUxINlJEUFA4?=
 =?utf-8?B?VzlUWWpFNHZFSk9Tc21MUTV4MUFXL3FxQmZHSmN4NjhVWFFndFpJcVRvVDBS?=
 =?utf-8?B?RkR4MzlrRTdwaWRqYThVbmc1WGlUV1BTMGhuZWUxaGJlaDJ0b21Sd0dBMExw?=
 =?utf-8?B?d1dxT3E3TUJuK1BVUEYyczdLNE4rVnlJU3Y5WnY1LzRVNzhNNmkrUVlCRUxm?=
 =?utf-8?B?elh3WkNWUHQxa2MySTFERHJhY1c1R3hmSWdHRDAyODlzbzJISERSYi9HQzhy?=
 =?utf-8?B?RWhnMEVhMmZlQTJqbHBPdUFSdCtSODkzeTQ2LzZGN240RFN4ZXpNWlk2U0lJ?=
 =?utf-8?B?TEhscTJsOFliSm1ERHNmc2QvcXFtRlF0Y1hYUitFUlBxQkNMQXZsQ3dxMkx3?=
 =?utf-8?B?Yy82d2RLTVVrQUxheDdHUlI2R3REb3BEN2xzVXhCcHkxZU1GeElwaC80bDhl?=
 =?utf-8?B?c2FTeWlqZC9iQ1ZvRlJFVVVkdUk0ZzZCb3FJNjA1RjhkdGYxL1pFd1kyc1ZP?=
 =?utf-8?B?N2RTbUtoVVdHNXM1OCsvaWoxVzc4UzBtYzR0SDl6eWNOUWM0ZWQ2amZtcFZu?=
 =?utf-8?B?U2xQQlpNRVJsbXZKZmgybFp3eUpsMW01aERuWndoblNjM1VUWEI5QktEdFVq?=
 =?utf-8?B?SnlyYUxJUGw3TFVwdEtSanB5aGNCS0hEZW1ralhuREtHODErK2ZKZTZkMXhr?=
 =?utf-8?B?OFI1bDNTSCtvT2lRdTdaOU41bWtPQ1VIOTVkcWRKRFZocFE3anlDQ1pqU0Mx?=
 =?utf-8?B?UTlRcm5RaFlid0tlam1oeVo0RXRnbGllL1djRWZtY05KdXBVSjhKMHNkT0tn?=
 =?utf-8?B?eTNZWmRFQVZwVkVTdnhITVFhcmhsS01Qb1FXR1g2Z2JpaGNkZ21ZT3ZMQTBI?=
 =?utf-8?B?R21iZmRRb3FnaS9EOWRMVkFSd2xXc1NXTU1pYS9IWEhHdjAvWHl5a3c3ZEgv?=
 =?utf-8?B?djFSZTdMVGhiZ0N0VUlvcGo0NEVWam16YllNQzBrcFlXNXdnNzNGR29wck1O?=
 =?utf-8?B?ZFl6YmpIamV0VFBCd3V2UFJTTjQwQnFGSHczeFEzTHN5cGFNYmxWK3dFejJW?=
 =?utf-8?B?UDIyOE5BWGVjQ0JmcnRKODFJQzdLTkpwNUtZL2FWSkJMNzFDRTRCUUtMclh1?=
 =?utf-8?B?d0IybUFLSGxTWXpRTFU0VTZLT1YxMkNEVE01bHhaZDV0L1A3MFRYazlFYUNF?=
 =?utf-8?B?QUFMcUxJN0Qxcng1NWlRR3RBRCswbjF1UW9IdWJyZ3h0T3prVDFxQjM3b2RJ?=
 =?utf-8?B?eUwxOWRrRExaZEQzVzhCQ0xZTUlnc3dCNlNveUtnMGFDVkVhaDI5c1V4RjI0?=
 =?utf-8?B?TFBIWnJJQWxqR0JKbDloKzIyYWs4dTVZRDM2TFZ0d01PNXRicEJMS1RqUnVJ?=
 =?utf-8?B?aDRtRFNwWkhqYkFQMHhIMFJLS2hKRmdGMk1vSTFKMEpKcTNvMXFGNmxsMlRL?=
 =?utf-8?B?WjNlc0w1OE9ITkVTdGxCQVlKTEVSSG1NUFZjT3VpdThwQW0wYlFlM01aWTd0?=
 =?utf-8?B?dUtDYk1WVlpmcXBkeWxXYWUzWUJGZmFQSjVoYXo0ak5ZNHJReWhiUDY4WFpp?=
 =?utf-8?B?dEVCQXQwd2RlQm9XNkxYWWptU0hZdXJ2YkppejJnL2FESExvNnpSeVBOR2Fl?=
 =?utf-8?B?QXJUbjdLbHhjMmRxeUNMQkxUZERZdm8zZkY1MlZqL2t1UXNCOWppVFZUenBl?=
 =?utf-8?B?dDNrMXhUS0NwejVWWmkyZU5wZURNK205ZWNEdGE0a3BDYXo1dFQ2K3JKNXh2?=
 =?utf-8?B?NVlKUy9ibThMSlVMd2cyTG4yWHRoQU02YjNpSUt6UU84RXZkTUdrTlhNb1Js?=
 =?utf-8?B?a1dGdDhxNWpNUmNQY0w4ZXhkaWxjS1RaWjFZY0MyZDF1OGNZMTc5cC8rTDVL?=
 =?utf-8?B?OG1LOW9iaTZHOG9hZmNwQ0k4djRLOWhGcmJtcERzZVh4dG1GZXhJb0tXQ3dy?=
 =?utf-8?B?Wlg5ZTRNU1F6MWxLMlNkYzRPSERXR053TzZtTVJiMmZpRUc2UjkwSEVnVVpX?=
 =?utf-8?B?cDFkUGRUOE5MY0dyR0tnRXVTN0JtdmdzYkNESlVrR3ZKN0phUVdwdW1HSENN?=
 =?utf-8?B?VnAyUFhrQVNGR1RESUlFYWJOS2pPNUEvQ2lUQXdNNE4wYzNZQTZUekJ0RzBU?=
 =?utf-8?B?MG9oeWtwQmNIbW9jSm8zOWhUNmR3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef406200-eb3a-443a-af7a-08db1e5c3698
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 16:02:40.6576
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QcueNowPRfima3byS1EGB0HRZCh8jmen/aAX5ollA16BltZ9XHzO+opCfMLAWM+xPkoLc48iratvPV76HXnRU14CrFvM6tg9ad+ii7vxa6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR13MB3920
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 12:01:01AM +0800, D. Wythe wrote:
> Hi Simon,
> 
> Thank you for your suggestion.  Your writing style is more elegant.
> 
> I will modify it according to your plan. Can I add your name as a
> co-developer?

Sure, thanks!

If you need it, my code can be:

Signed-off-by: Simon Horman <simon.horman@corigine.com>
