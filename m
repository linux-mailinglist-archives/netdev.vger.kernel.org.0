Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08AB85A6095
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 12:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiH3KUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 06:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229883AbiH3KTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 06:19:39 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2055.outbound.protection.outlook.com [40.107.244.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 288C6B1C3;
        Tue, 30 Aug 2022 03:19:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hlwOUy40R0OgipU9FHazhukaYJ8YewU30BveRVZvVWsH2We/b18oAeQo5LN1OIKt2nOgRJLHq0qMoPWbRxnz2Yl6WGkSKfTvbYcTpM/aBC3nZ92sHZOGgPMz24wyVeE14VPXW8ofBfnulBaLwGzNu7rG4Ds9WXBsTMuGhEUiIQvf1CifL7jZIr3SKeFjLNzD34HOYu2Tgd9m9Per6TinAlrMNiA0wFmN+hvJwYe27nkgiJh0YI2pF4GU/JJ19OdNf4wsvW4S9an70N0BCdJZskh0vKPybovKhCiEiNBa/fJgKNXi0WJutwmDruZq737pl+Vg7G+HbG4D+Cak425oIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kR1gwjn7DRAapakmYH+EIbhjFaEf3YZZ85M/IuA4WQo=;
 b=mCIxHKH6jOs9+cHKLyG20kDcPSmuQYZDGFD/p4TUywu5lLu8B1dG18Mp3KQgqu+36E6QxjQEPXFPm/xXlYX4TfPB9ew57O7AKzWDJGHe4DO6lc18DLCKjfI0ppy2z6QQiC0EW7Uxpsf/41aGtV81b/IR5lMxrLk2+1dWXxID1fouhOJ60jRLLWH3fUxap8Tz0MP5vUkn/7Ius0Ecl/hBfb/hJBz3N0O3bSmyJm3R1RQiL36bYPwdIgk8DGrDV9FllDylNdJYSMIw/n4giqDZF2SusjTG/DG1mZil2+WcwP7sxjag6AoivSMqR9ggvW75AFNxsLO1MNMCoWX6A3xO4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kR1gwjn7DRAapakmYH+EIbhjFaEf3YZZ85M/IuA4WQo=;
 b=TBzpQ61EfOA0WZt2uYNNRegcWdv+i10dTCBzM81w/kK3RtYwmepEPyu9qznKW10UGMHjLPry60nTUQ4qZ/rsopNyqGm4ctl1ny31w8+u5knH+5/NqIWBYkHnnJ9cjMMIn5ypG0jlhJH6QugX7l0Ifmb7esWOPXxXNooQWzQTqBc84rdndIuNBJgFrTo7oPc6QMwBR0DOHW4WtSQWAmuK2MGXU/dtyp0MZNrEWBMmD263nWojdTaaQQa1o4YOvvtuMb5sv7CmiAOwKZu3lTDpLXpfBwuSgnFGEwuHlNVaeNfZg9LwjTqglrtJoy+a022dEYUgXj30zPsF4MKOHYLsOw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DS7PR12MB6288.namprd12.prod.outlook.com (2603:10b6:8:93::7) by
 DM6PR12MB3531.namprd12.prod.outlook.com (2603:10b6:5:18b::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5566.15; Tue, 30 Aug 2022 10:19:16 +0000
Received: from DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58]) by DS7PR12MB6288.namprd12.prod.outlook.com
 ([fe80::2caa:b525:f495:8a58%9]) with mapi id 15.20.5566.021; Tue, 30 Aug 2022
 10:19:15 +0000
Message-ID: <09270720-bc55-29e5-2310-980cabb444f4@nvidia.com>
Date:   Tue, 30 Aug 2022 13:19:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: build failure of next-20220830 due to 9c5d03d36251 ("genetlink:
 start to validate reserved header bytes")
Content-Language: en-US
To:     "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org
References: <Yw3X1cB1j+r8uj7W@debian>
From:   Gal Pressman <gal@nvidia.com>
In-Reply-To: <Yw3X1cB1j+r8uj7W@debian>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0227.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:315::13) To DS7PR12MB6288.namprd12.prod.outlook.com
 (2603:10b6:8:93::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e7390fb8-7d4a-483d-a253-08da8a711784
X-MS-TrafficTypeDiagnostic: DM6PR12MB3531:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xTOZa52cl3Ptc14IXGND3vE8Hw3uNdyx+Dpq2uiKntfVFGZfizEwy5Vb5/Qo22/2MypR6RWHFXQdWxivtIGfM32EprLuhGqgQSRglTRRd5mqxwv8IXgqVs06STtZPTOfHLU12uvQ98LvpITMAYIhwEgXFkRMAJLp2bUFlmKX145NkVt9mQSPHswIGlugCBRSUEjwwGT6v/BsGD2usGv3YREtdaIZSieZ4OxfJwv09T+saDZwznuF46OFy4S7sSRiURRAZ9y9U8a5qqaGlhIZqpfQpOXu2g1NiS7hzG4zruKHYxMQHfZT/8zlZ6nhXEczI0NM6j2QhKW6pMaxdyyUgpTdV2bpjy6qLBZzjw0+j35V2KU0SrA9okwIups7RmnJ4YACzxIL0rrA4qIOMpWWr84q59w3p0qf66a+k5CdhDida4QL3+/tMLYvDHT5EoGaFZEIAt9j5c0KXOtUdwiGjSZG9/a/puOUWP+gzxr1xaMnlz3pFzGNrveArfDFa8/q5VTbEMzh/ungc3e8Ksxv3o/mKKtvbBz4U/IxHbAWW9IwWuq+i+mJnmiMI73Iuvweo33/8fhidpddOna4pNx2Yqq48W3WRcWLz4m6giOJdy+h00JeZQWuI+hrqLxR6lWW2yaH7h6l65csXGP+cTXI0uN6rBu5YNQR0ujb6ZbIOzNZO7WiufjLZZ917ipBZK3aIEnAVtA7C8VPF6yk1lnbOiVUXkCya8IBkiX/Jy0VNFp9uTN/XUuHVtClExBQu3Rs/cRr2jqUvWloNlxYUoVy/bknS3fDF24oTjESnEWa0FqEX08V1m15VloiUveM7JiEVT8Z7JtO0K4vPkdeYOMn2i8f2C4c8hT43zCOz1PS6AS4MznplNKw04bmAP4ry4eC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR12MB6288.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(396003)(346002)(366004)(66476007)(66946007)(316002)(54906003)(110136005)(4326008)(5660300002)(7416002)(2906002)(38100700002)(8676002)(66556008)(4744005)(8936002)(36756003)(6506007)(6666004)(6512007)(26005)(31696002)(86362001)(966005)(6486002)(41300700001)(478600001)(83380400001)(15650500001)(2616005)(53546011)(186003)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TTZDbjZqK2kwL2V0NHZlaXZsYTllenNoMkNtVitZUzJOeEptSVV6bE1QaGMx?=
 =?utf-8?B?WUYvWVlmSnEzelBubm1maHEvT3NPMEtsV050TCtqVmtNNnhra3d3MldGVzN4?=
 =?utf-8?B?b055SnVCT3k4TTk2WHp4aTFoNElJMGJhanA2NlBELzBwUWNTTnNjczJTSXAx?=
 =?utf-8?B?aWE4YjFHZzE5bEo2b2lXd2gzZ21MUUp2eW1Qd2FKK2ZicFBSeHhId3RsdW5t?=
 =?utf-8?B?amJ3bTVPS0Q1aTY2bE1ibG1hbFJBWEhQUHJCMExtdElDTDd0SktCQTZVc0hX?=
 =?utf-8?B?aFcxQ3dRTFFza09Jd0dHa09hYlB5ak9xUjgyYkdTb3dXdlBDdis1RVEwWkh6?=
 =?utf-8?B?T1VaU0FCZmh4Sy8wdzVjYmdFbThJejdEMWZ0cm0yeUhiQmRIUHR2VUwwT1NS?=
 =?utf-8?B?YndIdjFSNGhHVmU2TE9ZK1BOQ2x5RzBjT1VFL3p1akFwdlU0OGdreng5NHBk?=
 =?utf-8?B?T1ZHTTRqSjlhS0NUL0JqYjhhVThrZUtIMVhZeC91MnJITTJ3dXVTTG1jajdD?=
 =?utf-8?B?L1Iyb3pleEpjNlJsZmNmOVJZWnlKWHlmTnZrSDRmRElZYXAzSXpjRjV2c2Qz?=
 =?utf-8?B?SHluK3cvZTIyOWtQL213T3ZNZ2ZiVnNPMXZVeDdZdHZmVWJ6MitwSXdhN0JK?=
 =?utf-8?B?V3UyU3dWVVZSUjFiSElHVUlucDlWdE5lTzlRcStDZWgrQWd4WkZFQlorbzNO?=
 =?utf-8?B?S1RtYXNpWjhqL0dlUjdpRGY2NkVIc1crKzFpTzU3UFN6a29jMzNZTmx4ZkNp?=
 =?utf-8?B?Ynl4TjBzaUNLZnNZM2Jndk9CMklyMEUwZWZQaThGUnkxOWVWVjVJYkQ0SlZL?=
 =?utf-8?B?QU5nc2xKaytYR05tR0RYSGJhNmRrUEkzc2xySkdHbGtORXd1VTRreWxkTlZ1?=
 =?utf-8?B?WldYQnl0c1BXbUtiMmZrMktSeUZzeVp5bkkydVVDSlN4T2VCQWhYcHBHOGh4?=
 =?utf-8?B?WHBjNGRZcUVkNTVxYTM5ZWd6K3VMWGtkQlRHWStNeGMrS2NuNHpBMU9QbmR1?=
 =?utf-8?B?d1JQR0RJeU53N2YxUmF2aTlCVTM5ZEJQNnIyTyt2K0RVSEIybzcrN2dUbmxp?=
 =?utf-8?B?cGRVTHM5Z0luVnY4Y3BOYmhYdXdYQWY1T2FHUXY1SU5CYXJubkpHQ3E3QXBV?=
 =?utf-8?B?NjVDTFUwU0N1TkdFWVhEcTZsalA5N3hTdEhVczEvMitzc1loWm1LayttdGhq?=
 =?utf-8?B?NXBQdnlYa2R0OG5MTko3eG5QWWVrWFlLMTU3U0I3NzNGdG1BNGc4K3d5Sjcr?=
 =?utf-8?B?by9BOVVBU2YvNG1wSzd5OHVsajViS1VGMkxFK1FuQnhkaGNyVHdHTjVtWldk?=
 =?utf-8?B?QzZveDFnQW5RdTBQREJrYzZSWjBpZFNuQ2NMT0xLSkZVNHJRN25hV3NJVFA1?=
 =?utf-8?B?Y2lDTytMWTJaMC9xNXIrOWVOZXM0aEZ2eXVKb29WdjRWQkpWelFwd2dNcjB4?=
 =?utf-8?B?ZUcwdmExdVA5dW1FR3dnUDZrTmtyY3YwdmZtTGlYbDJibDJLbEVlcnFuVzhs?=
 =?utf-8?B?aE9Wd3E1QXhhK2YyVCs0U1pPcWJ3cHFGNmNoV2toa1hEL2NVZnVDQXB2NWdV?=
 =?utf-8?B?RGw0QW5wNHByTThSV3dVelJUR3RtYTZIVkFsVlZCYmt6YzV5L0Z0SnJ4K2Yw?=
 =?utf-8?B?aVk0Snh4VTVneTcyYnE3SjFYWmFVNzcrTDVqWndqSnYxTFFJdTd5cDRKUjJD?=
 =?utf-8?B?cC9QZ1UyRG5FM1ZkWkFGaWpna1Z0NHprbHlkQXdSM01mQ1RXWmFHcVJsbUo3?=
 =?utf-8?B?YzVKWVRoaUtYelZlZklVUmFUSGN2UHJZODg5bXBnN1ZxSWh2eHQ0anJ3eXQy?=
 =?utf-8?B?SnRRMXdiRGlUWkc2a3YxQ2FWVU40aXVHaVUxcS9GZ09BRk5CZDY2cTM0Z2o3?=
 =?utf-8?B?TWNhL2cvck1xU1lKbUZNRFBkVmJTK3h2cklUMy9sZ1A2MnVDeHltbVMvVjUz?=
 =?utf-8?B?ejkyNUFkbVNWM0JVY2tpT2lNWGZkYzJ6UFg5azdrbmVBaGUrL3JaWDgvaVdX?=
 =?utf-8?B?L0xrSXFkSktWZ2dmb3RWN0ZuRFZKUys1bjE3UUM3enFKUmk0Sldib1QvTHZ6?=
 =?utf-8?B?NnNkYU1EelBQdjM4Y1ZpbVlPWUYvM3ZGNWJNMmoycFFRek51aG8wcXhZeHBK?=
 =?utf-8?Q?/5CiiRJsGmLvDXAKGPWa7fFXJ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7390fb8-7d4a-483d-a253-08da8a711784
X-MS-Exchange-CrossTenant-AuthSource: DS7PR12MB6288.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Aug 2022 10:19:15.9352
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qrorRuQAoLgyWoWrtUxDjc6VYk01jCxnv6s1NrV6xXu+Vpia+jgwT1mrGN5KBtz/
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3531
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/08/2022 12:26, Sudip Mukherjee (Codethink) wrote:
> Hi All,
>
> The builds of arm pxa_defconfig have failed to build next-20220830 with
> the error:
>
> net/ieee802154/nl802154.c:2503:26: error: 'NL802154_CMD_DEL_SEC_LEVEL' undeclared here (not in a function); did you mean 'NL802154_CMD_SET_CCA_ED_LEVEL'?
>  2503 |         .resv_start_op = NL802154_CMD_DEL_SEC_LEVEL + 1,
>       |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~
>       |                          NL802154_CMD_SET_CCA_ED_LEVEL
>
> git bisect pointed to 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
>
> I will be happy to test any patch or provide any extra log if needed.
>
>

I posted a fix:
https://lore.kernel.org/netdev/20220830101237.22782-1-gal@nvidia.com/
