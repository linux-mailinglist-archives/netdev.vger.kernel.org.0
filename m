Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB346B98E0
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:22:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbjCNPW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:22:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjCNPWy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:22:54 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2120.outbound.protection.outlook.com [40.107.93.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B882295E29;
        Tue, 14 Mar 2023 08:22:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbjF+XhU5eRwfcW4PdxKLblRzSYqV9vhZN0+CJgiCWNAoD7pR903D2Fr5qE9EgJWD4RUPP93xjejVuTpE+/po1Uv2gZFIXhRmbQ42w1zjUvU3zr8vKuGsssLJMmQ/w5chBissuqtQ9i1zCbnZtZlTZNKwghFCgnrfma9FRCdwgeRn8Qv+K26Zkq+BxUa5bBzqNlcXjyS+u96S8hDqtZEQoNpfEGF3371Azih6OtNxLpns651c3zRHGdPzjh3xs7AzlCB+uz6kAUgU1NztxmPwqhuLRNbTsdY7+arjfUfStS1BPnJHvgM9dUCwj5EV+rywgbFnva37uONfGUdzGzbCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wx0Xxnc8DCQb1kEE7w8GrBPPxDJXVdkNs3ZJP0ZkhYw=;
 b=h0ARgErlW7BKHwttrS1Wc0mhgVQ5+Vat3Vz7GM9y8m4KYKeHQyUU8fFpSfd0/tjbz6hxwpo10EUykqEYLltqSCWtAquTuZibqVOEG9BRzbOVy/2y4IsTCOVABBQdB+3x/gh05W3A7pJwpvywSbfixE7bzbDXNu9SA/JkNxULnNJwyBJ6x64gDNxZlvhE+uEXPIq4OkBFkeC18TUCrnJmT+kpYTf7U6SkObxQ2aSx9Lnyidh+c2bSRyJotRGwMFdnhLKoDf0DBHEoGIbjlqcLc2bkqHUyDNDVTTs14q3bYi+3EP1UtMy2QZ2t1AiRuk4Co931XvDlxoe8A7PNzutqnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wx0Xxnc8DCQb1kEE7w8GrBPPxDJXVdkNs3ZJP0ZkhYw=;
 b=AfoEGX6oydlRqdunGplP8QMnIqcugpwEC2hHBs9APv09cQG6bGESBffAiDy70HT/FEPR3rX21raKAiEUs3wb/8EWM0ye2pSNRJT72o9hhb+lX7q9J8a3bvTtlEzp7N4hYSzXXHxc+h60RZIRjHb1Lo8e1iSKnJOX5H6gm2tGTSM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6168.namprd13.prod.outlook.com (2603:10b6:a03:4fa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Tue, 14 Mar
 2023 15:22:51 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:22:51 +0000
Date:   Tue, 14 Mar 2023 16:22:44 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Zheng Hacker <hackerzheng666@gmail.com>
Cc:     Zheng Wang <zyytlz.wz@163.com>, marcel@holtmann.org,
        alex000young@gmail.com, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, pmenzel@molgen.mpg.de
Subject: Re: [PATCH v2] Bluetooth: hci_core: Fix poential Use-after-Free bug
 in hci_remove_adv_monitor
Message-ID: <ZBCRRL8+EtTBH2tl@corigine.com>
References: <20230217100223.702330-1-zyytlz.wz@163.com>
 <CAJedcCxUNBWOpkcaN2aLbwNs_xvqi=LC8mhFWh-jWeh6q-cBCQ@mail.gmail.com>
 <ZBCNY8NoNkrA2nyN@corigine.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZBCNY8NoNkrA2nyN@corigine.com>
X-ClientProxiedBy: AS4PR09CA0012.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6168:EE_
X-MS-Office365-Filtering-Correlation-Id: 69f50bbf-d424-42f3-2d85-08db249ff9c4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5KrFLXBlZ2Fgl4D4A28ktdWWMURSfq5yU1qUNu/r+PDneExDNj1qY0vSAQo1AWibRq+guU8XUAGNBu7PqlGaMjQcx7zgYFhHbQ6s3tTMjZn5lqwhSObMneuGuh0+2W1cnt+izwWs/RWu3M6CCk+W+Cdb3gYgYQIeaPxG6/wJFwrUbbApXNlbQvc5NBJD7tdgmPU2G97pqp7LPYFuc/BtHvkfPcDjCiCspFNrW/6Bnrz18rWJhqX2Qx5SEbqqVrY8tEn8HuPlrtjDQ8uL0FQl1oqUDSBjmu8kO6eYjeM8yYoIcryg2yk36XpbmMW/vPLEzkmcNUAziUjfEOCMEvWjbBzNcf8dzssO+s+oOiA5PJtDZb7Q8/NsdUNqYwVIYhf7F5y7AjGzpchETpGRzG1TMATz1j5u5bBPa5HcBL+zKODKcKzCzS338MBCVE9TpqkT+jBgqlgyovmBtmQdVnd0K7vFMKBJPCbSaeplsM/Q8Ire+RNlAlDkCNtI1gw8HqKY442fjPP8Pbj6ClhpbGp+D1k2LaoAfbbgYikTNbnd/BxOZP8QPF8rnsK4SG5PDx5Ppt02jMhTfcQBrUAxk7Au05P0GtTzD8JxYrxLpolHIJGkpSL9bO8jHs3h8vk9d8W2NJmb4HoJjoJ+xY4VjkZkGsF/voP4lQYGD70UV4p/CDLjZkAorH6UoZtXmfRbJKy5eiOcCQIxjb9Ow9K33C9EfNPu5kTd8rzGgRAQGdxsdpA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39840400004)(396003)(136003)(376002)(346002)(451199018)(36756003)(86362001)(38100700002)(2906002)(44832011)(41300700001)(7416002)(8936002)(5660300002)(4326008)(6512007)(2616005)(6506007)(186003)(83380400001)(316002)(8676002)(66476007)(66556008)(6916009)(6666004)(6486002)(966005)(478600001)(66946007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RG1uVTRQbWd4WDdNY0psVWVNbndGYWs1MWM3VWVFZjVLd25hWnBSQm1wYnpC?=
 =?utf-8?B?WWpMUG5QNG5PZjlncGZiamFGUzRib3hyaHVDQXRzTTB3UWJwRGQ3eG5sZU5u?=
 =?utf-8?B?TlhuSG1qZ3dlcGJoZ0o0UnNJR2lVYXdmV3NhcGhLcmFsc1ZaWVRyQk9QR1lN?=
 =?utf-8?B?SXlweWp4c1A5MEhSa2V1VkxZZEtDaGUxZm5aNVBXOGVCTmJjWFNKNnR2L294?=
 =?utf-8?B?clMxRGRkTnByb1FhdDZmNFBGWTBnT2xUeWhSZE8rUWVEUU1XM1l6bW4zNnRT?=
 =?utf-8?B?TmtnTWVRWXlFK0EwRkpSWHVkdHVqMGFxZUdYVGhON0NWQTEyc1R1d0xyNUpl?=
 =?utf-8?B?em9MTUg4TmtBemhuaHgvUHVqV014U1ExeXFhM3F3ODBYU1VvTkZxSjM3d3pz?=
 =?utf-8?B?NmxldGJnU2huK2t1YU5GRzdFdklqUU9aSUdmZXh5WEdSbTNvL1dGeEZ3UEpK?=
 =?utf-8?B?YTJCMEVKNU5FNHIvRmo5TjVPZ21CZk1BNUFBZkwwak95NmY3aThoOU5sdEhI?=
 =?utf-8?B?ZFZpYXZsczEzV3oyYi8wRFBlZXc3MnJRRERwZk5TbjI4a000emwyc2dYbUVh?=
 =?utf-8?B?K1N3RU1HZUVSRnkrVWpCZ3dwQXprS3NGRDRHNWlFM2QzZ0dPTEhqOXhtb045?=
 =?utf-8?B?MXowV294WmRVVzF1RVhQQlRZQjVzcnlrSXhkNEZQUm83WVRtdEc0Z1ZhTWlh?=
 =?utf-8?B?bE9xMFdmVXBFUXRCbjd4OXNCamRqenp4MllSbFNpZ3hsblp0ZEJyWEVpMkxT?=
 =?utf-8?B?Q1RGUkF1ZzcvT25pUk1FOG9WVFhMaGhUdTRORVB0d09aZHY5d1FxQWNUMnJh?=
 =?utf-8?B?aGl0UTJmNERSVTZFY053akNlVlQ4SWpRb1MwM3pPUW53MEY3eUdMRDdUeTNu?=
 =?utf-8?B?Mm8yanlSYWdEUUJzUmRDVDdLa3pUUmxRZmFvQzFwanJmeFpaVVRvQkVXNFVG?=
 =?utf-8?B?VWN5V1FlcWxvc21zanpDMUFxbFJhNmVPZWxRMmV1OVZBZU5pNWMybXZ4Mzc3?=
 =?utf-8?B?emFmYkFsK2VxdzJKR05UUk1sUzhDc3J0aVNUZkJUbGplczlxYXY1YzNmRElZ?=
 =?utf-8?B?bkdCRjlmZitJWFNPT2pTcW9WVGZTV3EzM2syL3NnSzFybExEZWE5Ky9leFNU?=
 =?utf-8?B?d1krbHBtMG9IdVVKQWpiSjZBOUZYSUhNTEpBMXlkSHVROWZLRk9xNHp4TFpt?=
 =?utf-8?B?bTYvUVJJb29XTEdsdzZBSlNLSmJMWTZycmZaWnpkdkR4dVdsaE11TVVUWGZD?=
 =?utf-8?B?UGtrKy9oK0ZlRFVLMHFnNVFYTXZWUitPMG03OVRkZnZieiswSzlBM0dyeUcz?=
 =?utf-8?B?RGR3QkFIek00MmthSDVQZXJTNVk1L0swL1VkT3NpdVJYb00yVlZPQTMxcmdw?=
 =?utf-8?B?YThUeW54Rkk4NFB1L3FtelZkbHBsRUUvR3pOaVJneFhCNS9uajF4aEE2bXRH?=
 =?utf-8?B?aUpXOHp2SlNMcnRESUN0d2s2a3hVam52T3FrNmNSM1RDVTdJUWJmS1JJYmpK?=
 =?utf-8?B?NlNHeWZOV1NDVEsyS1k5R0xnaXNaV255MGJBVWw0em1vTEpDbElXK25hVktP?=
 =?utf-8?B?UUQvRHlzUi9FODVuVWY1T3V0cGM1b2NLU1hnR1NMN0lwZUhBREhwWW1yd29O?=
 =?utf-8?B?R0JXSURGakFzcWoxQkh4YmNsWmJSS1EwWHNBTGoyb2NyYWJXOEJtdnl1bDdF?=
 =?utf-8?B?aG5UQ3I2V3V4V2RmckE2b3NkQlpONDBXUno5RTNxc0pHWlkzamUxWVcyLzJY?=
 =?utf-8?B?Z2V1QS9uMFFzVmtxbkhyTnRLa0hXTE9nK1ZneWVvZ1JtcXpRUmhIeXU3bDJq?=
 =?utf-8?B?ZXNlalNOTzVPZ1pDSll1SEs3MXgrUHJnMGJhWllaTnUvc1Roc3VJUGlteXhX?=
 =?utf-8?B?YmZydUw1WnNKbXJvd3pWUlBPRVU0Ym5pSnZ4Q3V5UWRKNytSSnpsNHhyemhh?=
 =?utf-8?B?MGx4YnhTOTBjcUx1QlRJaGk5NHMyTnJWVHVtOGkrNlZ6RlhKUVA5MlJ1QkNB?=
 =?utf-8?B?cUQ1S3QyNGhQem4ya1lLNFlLdFRteUJYNXh1d1F6bnkvdzludWFIb3k4WElQ?=
 =?utf-8?B?Mk05Y1ZTaERZY1Z0TDdNV3Q4anRCN0tQQjBWYnQ4QjFzdHJueEFEdTNDMFFY?=
 =?utf-8?B?aXhiQVZkbXM4WXhCTktPNnhwOXRvRW9GTEJrZ3lRK25BZC85S05rOFBXc29p?=
 =?utf-8?B?cVJ6ZVR5ZE5wNnpXMTZ1aFllOUVrVTNJdG1BYnZwQUx5blRtdHhFU3hVSUpv?=
 =?utf-8?B?U3o0bi85RmwvQk1peHBRQ2xOQVV3PT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69f50bbf-d424-42f3-2d85-08db249ff9c4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:22:51.3402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8JWrBG8HOrZN+Tl7DJRp/6w7YbEGKxxgq22mf4n2xuTTy7+CM+MsD6lsaYkO1ssJ68YwdPwOAUg7CviDCB89LmKwLCCuLU/8zJ2MKrZ3NnI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6168
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 04:06:11PM +0100, Simon Horman wrote:
> On Mon, Mar 13, 2023 at 05:55:35PM +0800, Zheng Hacker wrote:
> > friendly ping
> > 
> > Zheng Wang <zyytlz.wz@163.com> 于2023年2月17日周五 18:05写道：
> > >
> > > In hci_remove_adv_monitor, if it gets into HCI_ADV_MONITOR_EXT_MSFT case,
> > > the function will free the monitor and print its handle after that.
> > > Fix it by removing the logging into msft_le_cancel_monitor_advertisement_cb
> > > before calling hci_free_adv_monitor.
> > >
> > > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > > ---
> > > v2:
> > > - move the logging inside msft_remove_monitor suggested by Luiz
> > > ---
> > >  net/bluetooth/hci_core.c | 2 --
> > >  net/bluetooth/msft.c     | 2 ++
> > >  2 files changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > > index b65c3aabcd53..69b82c2907ff 100644
> > > --- a/net/bluetooth/hci_core.c
> > > +++ b/net/bluetooth/hci_core.c
> > > @@ -1981,8 +1981,6 @@ static int hci_remove_adv_monitor(struct hci_dev *hdev,
> > >
> > >         case HCI_ADV_MONITOR_EXT_MSFT:
> > >                 status = msft_remove_monitor(hdev, monitor);
> > > -               bt_dev_dbg(hdev, "%s remove monitor %d msft status %d",
> > > -                          hdev->name, monitor->handle, status);
> > >                 break;
> 
> I'm probably missing something obvious.
> But from my perspective a simpler fix would be to
> move the msft_remove_monitor() call to below the bt_dev_dbg() call.

The obvious thing I was missing is that was what was done in v1
but Luiz suggested moving the logging to
msft_le_cancel_monitor_advertisement_cb().
Sorry for the noise.

Link: https://lore.kernel.org/all/CABBYNZL_gZ+kr_OEqjYgMmt+=91=jC88g310F-ScMC=kLh0xdw@mail.gmail.com/

> 
> > >         }
> > >
> > > diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> > > index bee6a4c656be..4b35f0ed1360 100644
> > > --- a/net/bluetooth/msft.c
> > > +++ b/net/bluetooth/msft.c
> > > @@ -286,6 +286,8 @@ static int msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
> > >                  * suspend. It will be re-monitored on resume.
> > >                  */
> > >                 if (!msft->suspending) {
> > > +                       bt_dev_dbg(hdev, "%s remove monitor %d status %d", hdev->name,
> > > +                                  monitor->handle, status);
> > >                         hci_free_adv_monitor(hdev, monitor);
> > >
> > >                         /* Clear any monitored devices by this Adv Monitor */
> > > --
> > > 2.25.1
> > >
> > 
