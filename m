Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10A0F6B9882
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:06:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjCNPG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbjCNPGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:06:24 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2112.outbound.protection.outlook.com [40.107.94.112])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2F1DACE21;
        Tue, 14 Mar 2023 08:06:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOw4pfLzbNsDwL9CUJQPHKTRLpXz88jFxX+aq/mLLqyAXeso/KZ/D4bZmOCB/CqtOYoRYHJyEcsQOXC2Psa02raWRj3l391NQhidtK/zJpASOTxk2YYAloJzigqWjugXIpkqeHAJO+zuNnUKarBPwAbfLPt2lwlRjhXxXdFrlOJuETCtO+Lcrsrhu4lqa9ACtgXy3IeWh9Ox2nBLAfaYyp/f0f/MK62GS3w7QVidH/6B/ICwDkkH8VQWEbe0lYhYusccL/yo4X8tUVJ4tSAOjyUVmktr0X9X3P+kK4rTGETDBM0un3aFz8dmwUvw7lGCcdy+JO5c7LkQUWsKsVaszA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UOgIskxvFGCilz86xUbm4fpfoWfJf92i9whjeVn6VVA=;
 b=B/DopJMfaQtW2ID0sQ/6yfFkwLVLm+nR8oXk+uSQRmsi6znGp90ZsMtQ3k8Q6C9LaZau0LFurxdTFR4JJUZ/JO7UXwQl4amb1G4dXnLgTy2F9mHF5/RI/TSJo/PXRXVeQIUCi62PFK21AHHJZvHmhrJi452wxFxvqksFcNrQKuyCYPWsI93y3OCNFQ1eFyB7tXGK4OLPCkNBY9pthWQC3pC3zejRp0SotwyAdDTqbiCgVimXpYAKXfWIC0Fu9+ebttIndoRreO3Npe8aVd6Ayw3Z8q7/C+URIz6XWPOtzr82gCYhuyYuMYHg1TtiPNJC+jQF+c/GEurz1xmMgd7PtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UOgIskxvFGCilz86xUbm4fpfoWfJf92i9whjeVn6VVA=;
 b=SYQqgHlMEB1E6e5EitdB6ukbMonKi3ui94S44jZvMqBh9O/X24f9svZj4yQT2EnOu+b6u4IcTJMDtJlKZgu7EoMy7+hMHeM3xlCVS5X+jd+Jx6H2Dg+3Vig16R1QWc0TFaOHViY7qmobUIziUDSnHzH/FTEkcVVHL8zmzSlb1V0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW3PR13MB4010.namprd13.prod.outlook.com (2603:10b6:303:54::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Tue, 14 Mar
 2023 15:06:19 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 15:06:18 +0000
Date:   Tue, 14 Mar 2023 16:06:11 +0100
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
Message-ID: <ZBCNY8NoNkrA2nyN@corigine.com>
References: <20230217100223.702330-1-zyytlz.wz@163.com>
 <CAJedcCxUNBWOpkcaN2aLbwNs_xvqi=LC8mhFWh-jWeh6q-cBCQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJedcCxUNBWOpkcaN2aLbwNs_xvqi=LC8mhFWh-jWeh6q-cBCQ@mail.gmail.com>
X-ClientProxiedBy: AS4P192CA0006.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:5da::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW3PR13MB4010:EE_
X-MS-Office365-Filtering-Correlation-Id: f9feb88b-2420-4dac-c706-08db249da9d9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZoHhbrnnijZgUlGI1PNTzuhtCqpR68wCNOu5d9dqOzg0hiEjxVaawbpczVSZ4+rv6tOM+/nNIIG0xbHYHvIXBFtimg/wkyIoAklvp1v5BzNBzYX/hhCb6Fmnwz7tLH/BuRSGBKqxKk/bRZNKZ3260jMH5KTCqNnMom0bTdjiB5gxUlFz5j/m2010vmKLqn1Ayp9av1/9VX2cqeF6aOBSF7sOdpGjbUWOcKKvqC6P9GPGRsphYALdFebx5n4TIM/UlVMcP2kD1J19T1biAYZBzNrjUXajT4YBsRQxwSyZIH3i7a1sQwCkViSOjZGIlATLloMGp3RJJNUF9PSgCz/GT0m+72MxaU21GwoyHeUu9DOUfXws0sibVUcGhDemt1E0PWL4rjOg4a0AjLR53Ia8BspaWu8K5XTskI29bhGOqr1/q6jRhAqUlcP4kzx2+iu1hQvSmyleqIESjHM3RBNiJtgnF+odhWFI1rZ2AOXuwJSbTfHNjpjZyyfknmV2EPx8lJP5Vr1dOS3/21RgX5BXveGtU3OYe5DDsW2AGm6XCH/gRBN+fKed2K6XWxBgQTB/r0EAGPdf9SvD5tqZ0sm0pPNk7Y9sg1wcK9EsZD3gzGvfgTmdW4NjSTbAdYZOIxpjEw4AfNudjENk1OIsi7JJuA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(376002)(396003)(39840400004)(136003)(346002)(451199018)(2906002)(41300700001)(8676002)(66556008)(4326008)(36756003)(478600001)(66476007)(316002)(6916009)(86362001)(66946007)(38100700002)(6486002)(5660300002)(44832011)(6506007)(6512007)(2616005)(186003)(7416002)(6666004)(8936002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NXpTeHlJS1ZnbVhyc1JpL2VuY0JhRUdwcXd5bkZ0cTI5MGQ1QWdWOURKT081?=
 =?utf-8?B?aDgwTVJrMmo1REtrVTZjZ3k5eFI0MXhqNGFNYkNPQml5Y0dXNFNMeHlmbzlj?=
 =?utf-8?B?a1B2aG5pV1NaaGdTTEg3aUdoWVFDaHJNcE03c09zc25tVFJLb1Q3TEtkcXlI?=
 =?utf-8?B?R1R0Zm1pYi9remxTR2wxbkdCdHJBMStKaHkrMTJ3Y0lFMFQxaEF2bkx2S2x3?=
 =?utf-8?B?TUJCR0lFdHJBcjB6WG1BMjlTNDdrOXVUVStXWnJrL3RKK0ZtSWYyVXBMdHBm?=
 =?utf-8?B?bi9DUktPV2IwWmRydDhKVWpBMG10dUFTRlpQVFZvdU5GMHE3ZDNhWExOb3Vv?=
 =?utf-8?B?ZExkaDF4N2ZPTFcvOTZRL1dhSGtRRmk5b0E2Wk96NUpsY1JRVWk3eVBDdnNI?=
 =?utf-8?B?OS9LZW9obXV1WENpZXlsWEJxejVYR1ZlRzZiL0FoeW9NRWkzWDNOQms0OWNG?=
 =?utf-8?B?dmM3bHVrdGlKZGliaXYyTzhUMHlvZWxHWHlPUnlGVkpPTURwZWNpWjMyVjh2?=
 =?utf-8?B?K1N2eElPTHhDL2tSYThPUDl2ZCtyQ2IwakQrT3VYcDAvQldDUzZNcjdla3Vt?=
 =?utf-8?B?Vk1qcFJwaS9wQ3U2SGFTLzZJbDJTK3FVeno5S0RJWlUvdmFJc1BuU1BseG90?=
 =?utf-8?B?b3pUbWFFQVRYS0JaZHRTaXdjQnFab3psU3VGanU4cUtLM2cyd1A4V0xGb2VT?=
 =?utf-8?B?cmljOGtRaUxOT2lUQnNyRlpQSlp1MzRQZ0FFK0duL1FUdXo2TDBFTHZiejRq?=
 =?utf-8?B?ZjU3bUZmY0RERDVBekUrT0xhaGxuRDF3a0docGJoYnRpMDloYVFUODQ1ajJB?=
 =?utf-8?B?ZGQwWElmNFpzVXl2eTQvcnR6RUtaTG5nRUNObVNQK1FQUzlZMGpOMnlIQmk2?=
 =?utf-8?B?bjVwSXJ0cEhER3E1RHF5czFMSXVhbTZFeVhJU2FtY0prUEMxcFNsYXJiQ2JX?=
 =?utf-8?B?OWtwRGNiVjhUMjlMNGtzM2hiTWdNY3gxdjNhL0ZyMGhEMHBBQUlzQTgwak5o?=
 =?utf-8?B?NFMyaW1oOVJHUDlWVFZmcGczMGhDUzJNbmlDMjRmVTBkNmRKcXprS0hGeEE2?=
 =?utf-8?B?V2tYWVVNc3VCMXNxM3MvcHRac1dTZXJJR3hST0h0QmZEN20zMEQrWnNWOFdu?=
 =?utf-8?B?ZTJ1R2FlWTBhZVFra1FRclpQSEp0NFl4UllxOGhYekg1bzY1cEMyUmpuOGNx?=
 =?utf-8?B?Q0Iwa09qRlRzY3RVWVUyeHMzT3BsLzl1SEYzelpYUjJXVm1xREUwYTZkVXl2?=
 =?utf-8?B?azFjODJyWnpFa0dpeXhyaGxHVnNjcERiR3NyVkpkV1JRUWtQSzF5eDZhd3lh?=
 =?utf-8?B?eW43ejdjelhRZUo3bGNjaHNwYmhaMndXMW5PdElOZkdRSllPN1RyTGMwMHdy?=
 =?utf-8?B?UVB4cVlkWW1WSnZxZXlhWWprZFBlSW5EN0lIaU0rWjJndVpJallEc2lHQnQ5?=
 =?utf-8?B?MU9KeS9KOFlYYkJ6clVZUC9pcjlBemxtQktWdTJqS2c5elZYMGRsckhHZzlP?=
 =?utf-8?B?ZWFJUjRxSUFNRER0MGxWQ0xjMW85Y0N1TURwMVdwZGp5QUdyNzRyS1BpTXJs?=
 =?utf-8?B?OXU1ek9UTEdqM2QraXZvblFEaXIxUzU0bFE2M2p5MXVMUDhtdlBIUzA4MVR3?=
 =?utf-8?B?YmNnUVljUnRaemxNN29CVkNHdWRIa2JMV3RpM05Pc1FPL3NEb1Rod0hONGFC?=
 =?utf-8?B?UVBkc2hVZzBSM0hpb2M4alBlc1o5d0ZHTFBOVkxaMStVeTBBWTBKRFZkUEJh?=
 =?utf-8?B?ZUpFK0IvVUJvT2FMTnVaOHZnOWRGL1gwU1Q4V2Q1Q1BHTlRweUoxZm8yRFc2?=
 =?utf-8?B?YXZMM2p3enhDeDRiVHZUYzVvMnQ5dFdkQit3WllqbVpXYjZDb2x6S29iQmFT?=
 =?utf-8?B?TzB2NnFVOUtySHVLU0dXV2h0T0lWS2sxS0NNbnlSNGFheUF2L2NUeW9uZ1B4?=
 =?utf-8?B?NnhSNHAxbUZtNTV6Tm9YRHd5a2MxSlVNYVpSd2RvVHZ3TzNsOHV3eXRQVEFi?=
 =?utf-8?B?eUhLS1g3RDB5Zk9qdlZHTk8vYVBGUnkvWStsUCtmSVBZdVc2M3R1OFp0cXJt?=
 =?utf-8?B?VGwweWVQYnQwNGJiT2w3YU56VnY0d3ZQbWk0WFhLSHRYRGtlVzZ4QmhERDZW?=
 =?utf-8?B?ck1kVW15TjNGY1VrYUptYmV2TjV5bXptaTFpRGdudWJSNU1hNVF5N0NueVlP?=
 =?utf-8?B?L1psS28xSktIR01DMHZGdnhkRzhTUXNmUnpMZFdjckZVZzV4TGdMTEt6UHlv?=
 =?utf-8?B?ZlpsRWlZQXFLY09rVU41TEdZSjRnPT0=?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f9feb88b-2420-4dac-c706-08db249da9d9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 15:06:18.7200
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Soq4UkfHvJsG7cHpWz0BlIkYze5jLnSpNFbllcPnQ1s0ztVL0hykvwOmjyvZjIVvTufhN9sR+8+/44aQde/glln0Ps+sIygWBiRC1NxlcNo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR13MB4010
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 13, 2023 at 05:55:35PM +0800, Zheng Hacker wrote:
> friendly ping
> 
> Zheng Wang <zyytlz.wz@163.com> 于2023年2月17日周五 18:05写道：
> >
> > In hci_remove_adv_monitor, if it gets into HCI_ADV_MONITOR_EXT_MSFT case,
> > the function will free the monitor and print its handle after that.
> > Fix it by removing the logging into msft_le_cancel_monitor_advertisement_cb
> > before calling hci_free_adv_monitor.
> >
> > Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> > ---
> > v2:
> > - move the logging inside msft_remove_monitor suggested by Luiz
> > ---
> >  net/bluetooth/hci_core.c | 2 --
> >  net/bluetooth/msft.c     | 2 ++
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
> > index b65c3aabcd53..69b82c2907ff 100644
> > --- a/net/bluetooth/hci_core.c
> > +++ b/net/bluetooth/hci_core.c
> > @@ -1981,8 +1981,6 @@ static int hci_remove_adv_monitor(struct hci_dev *hdev,
> >
> >         case HCI_ADV_MONITOR_EXT_MSFT:
> >                 status = msft_remove_monitor(hdev, monitor);
> > -               bt_dev_dbg(hdev, "%s remove monitor %d msft status %d",
> > -                          hdev->name, monitor->handle, status);
> >                 break;

I'm probably missing something obvious.
But from my perspective a simpler fix would be to
move the msft_remove_monitor() call to below the bt_dev_dbg() call.

> >         }
> >
> > diff --git a/net/bluetooth/msft.c b/net/bluetooth/msft.c
> > index bee6a4c656be..4b35f0ed1360 100644
> > --- a/net/bluetooth/msft.c
> > +++ b/net/bluetooth/msft.c
> > @@ -286,6 +286,8 @@ static int msft_le_cancel_monitor_advertisement_cb(struct hci_dev *hdev,
> >                  * suspend. It will be re-monitored on resume.
> >                  */
> >                 if (!msft->suspending) {
> > +                       bt_dev_dbg(hdev, "%s remove monitor %d status %d", hdev->name,
> > +                                  monitor->handle, status);
> >                         hci_free_adv_monitor(hdev, monitor);
> >
> >                         /* Clear any monitored devices by this Adv Monitor */
> > --
> > 2.25.1
> >
> 
