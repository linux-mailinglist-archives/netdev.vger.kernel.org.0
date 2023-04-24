Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 259786ED8D5
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 01:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbjDXXaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 19:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230041AbjDXXaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 19:30:14 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2066.outbound.protection.outlook.com [40.107.223.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18A92BD;
        Mon, 24 Apr 2023 16:30:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l+Jc3JsMBSpOxmwTeQfwDfaPYoKIdrskmqvjZ49T7/k/ZfUinl1Ne3iJXec1QJrJ1fQ6sTkiUPrQhUxqr5ZSrG1ZAeVI8Jhpsepwv3H8cwscB5LYrfS6NlGwS0wQZ5cB4qLTtbIlfQBada7Jys9k6r97cneeN0z8ry4q9AEl+1WIle3osVo1Y0CPmw7aMDK/nlEuWWTIg/hyIMpdI88f8J5KOJ3NosEnqtgMBD5rG06Hna9crYSZ1+1W6MTCYGrgjFH34ZmJHfBzuX73Iwd2Dp93+kaco7QwAav33GWN1G3TH47K23D7w2MmjGW1cDhJkq/l9VerdRPy0iBpLt5iEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q6UtkuYUWomQFf8sg8VeCg/YMef9N5yjpZYkF69XA6o=;
 b=K39kn3esd6GnI/RcXNg0E0xKkUsFF8Md7JV3kNcyf7uNYt6zgIcyevcrQIiz+EXck1ZujgJI1B7WwQYzQJJJAQAziZzLkRJEKhAuxDpMYDLDI9vJvVKLoYwM5YNme2kQHL2N+siG2o5TCJYvBFYpYEn4W8racVMorGTouIdsZf1htVZkC+T2PP+aVB+l25mMNYh4rZer3MfKEH/zFG1fEnYvePt0/ajRwpgFmcoz8MEa2K25JlvzHW8Twheoe4OUOmItCB/7avjLviYiZ2SNaRYBLC9Bn1iC7VHGI3mQjTBu51ykRRxu2ACDux8ZLZHWHEAk/C2W3LVcFwdOCq0P1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q6UtkuYUWomQFf8sg8VeCg/YMef9N5yjpZYkF69XA6o=;
 b=LN1UuGzIGP1oCLZOC0NV7ekSACl944DQpG4rJ7dXKuYhJ9f6istm0NxSPcTS3zDpgA/P3BY9IyaEAUJyOUBAfacvUwBVvDtZsXawdHNqd7L2kdZ0LTSt9ZuUaBjH7l95jglLUskaMvTB810xupOol4emCZi1INV+15pS2CZIMq1JUvQbBfNX6fYcBopxeHOHO3/8klWuiggNfWNbF6YaacdxUYRNJsrb1INfrXqGNjtl/3EfvaTQBvzcwWGdv5VDnjYP0KtZnWix8nxoH31GRsten4b1eK0jqzTB3geZ+q8C4Qud9cv/hp5MWii7EABjhhRtcNHYFa5mIAUpebSj6g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from LV2PR12MB5869.namprd12.prod.outlook.com (2603:10b6:408:176::16)
 by PH7PR12MB6466.namprd12.prod.outlook.com (2603:10b6:510:1f6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.33; Mon, 24 Apr
 2023 23:30:09 +0000
Received: from LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab]) by LV2PR12MB5869.namprd12.prod.outlook.com
 ([fe80::f7a7:a561:87e9:5fab%5]) with mapi id 15.20.6319.033; Mon, 24 Apr 2023
 23:30:09 +0000
Date:   Mon, 24 Apr 2023 20:30:07 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Lorenzo Stoakes <lstoakes@gmail.com>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <willy@infradead.org>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Christian Benvenuti <benve@cisco.com>,
        Nelson Escobar <neescoba@cisco.com>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Ian Rogers <irogers@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bjorn Topel <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Brauner <brauner@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        linux-fsdevel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2] mm/gup: disallow GUP writing to file-backed mappings
 by default
Message-ID: <ZEcQ/44i0tL2ZZC5@nvidia.com>
References: <ZEaGjad50lqRNTWD@nvidia.com>
 <cd488979-d257-42b9-937f-470cc3c57f5e@lucifer.local>
 <ZEa+L5ivNDhCmgj4@nvidia.com>
 <cfb5afaa-8636-4c7d-a1a2-2e0a85f9f3d3@lucifer.local>
 <ZEbQeImOiaXrydBE@nvidia.com>
 <f00058b8-0397-465f-9db5-ddd30a5efe8e@lucifer.local>
 <ZEcIZspUwWUzH15L@nvidia.com>
 <4f16b1fc-6bc5-4e41-8e94-151c336fcf69@lucifer.local>
 <ZEcN92iJoe+3ANVc@nvidia.com>
 <ff1bb8cd-896f-4c7f-a182-42112f5ac5af@lucifer.local>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff1bb8cd-896f-4c7f-a182-42112f5ac5af@lucifer.local>
X-ClientProxiedBy: BL0PR0102CA0001.prod.exchangelabs.com
 (2603:10b6:207:18::14) To LV2PR12MB5869.namprd12.prod.outlook.com
 (2603:10b6:408:176::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: LV2PR12MB5869:EE_|PH7PR12MB6466:EE_
X-MS-Office365-Filtering-Correlation-Id: c98c3c65-08cb-469e-5860-08db451bd7ef
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KpubcZZ/K/hFiihKVporQc0gAvWaHplEJwenT7fS5GMtbl+FtRdF7rRpmltNaDhN0fJo6ZIwC2s7LIYtOHYdSEN6sZbkAti2pHqsq0TEzxBK0E5BvPgAhgH6YlYbonN3wd7CR3s2tQ8jB50vcolHPo1EgNS1siFlWPw36+WjfpRdKt/ejFoH0DcQZz/6SW4B59Uwy+o2A5giNKowsmzcTWudc0e6DlFEY+6A15f80CjfmmWfD6vqdxleQWeiZzDEfjwxP72/RZi1fbAw6l7nWPrg5MX1EaLEAmA8OPY9nA2smJdeU+sxX+kjuUZkvLspAQwl9BVBXjMN8y+HUjz5q6V8hOkgAyRE8uhEWfN35fTLXmG+2RGPvOMrnor2M/esyY8fd1o0ZvGrYlKYuVP9+ghC7W3Dok87yUi8XKelg0WQLto5Fm+pC9zIc4LuQfJZ9T2/BUnnHMeZ587A9p2ejSwaUBiDd7W+WcOzTg+lhaY+Ylo/ngXZu86wx6ZJVuwWjc39foxBFbTi4gK9wXhkedCuLzmplt67bNv4aO5ITedjI9ZR9NTOLWgX0CNf3o/k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV2PR12MB5869.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(376002)(346002)(136003)(39860400002)(451199021)(186003)(86362001)(6512007)(6506007)(26005)(38100700002)(5660300002)(2616005)(6486002)(83380400001)(478600001)(54906003)(36756003)(41300700001)(7416002)(2906002)(8936002)(8676002)(66476007)(66556008)(66946007)(7406005)(6916009)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dPwtEvS9Rx4roKLkL865VFzt0+qKQjp307rRbXRSt5hLnm8kC9HqhrPBWSmh?=
 =?us-ascii?Q?BeXzXGa6/bzhxHPr0TSQH2T2d2bjw/BYHI8lO8A8odXKG2XN4uzNe5TIWul5?=
 =?us-ascii?Q?ux8EPFxjMN4CxBE/sqH7QGFuuY0dczLSSHJGxNbL5RepBarCcSvsFe8JDj64?=
 =?us-ascii?Q?efUSft/sHv0jQECb4Kx1Vl0I1bmQYkmwpmYiXH08bG/hgXcWi8LQhX34d0ko?=
 =?us-ascii?Q?xNRl8M30XhfEOufsk32ZX5udoB05U08p/C7DG22ZZPMYVv29NL3I07bUgk7l?=
 =?us-ascii?Q?n+8n/Kex5rrYU7cRA1yTr8gMOvd5ofGagji+v3FbFTpmJ8f3akXnVo7yRpev?=
 =?us-ascii?Q?pvvu+8naUopOP+I5OaR8sxvfuVcDlATUStpq5ez0tABjXqXsmDFEK72EzH5C?=
 =?us-ascii?Q?W/JsdTdozUd565w9uHU+nePgTRCSf7uMH/xvjwPVjhDzCA7uYXqd348VytuZ?=
 =?us-ascii?Q?AP1njNBnPHStcppKDipj9wKtprI+NSzsDhLIrXZ4q7uQG1XOrSpD2NL6M2T+?=
 =?us-ascii?Q?gP2pbTFrGYGKGpITgjvmFXWEJGEq85DeAbd1MkagGtTSPEY1pTDxoV2wJSzz?=
 =?us-ascii?Q?N/pQy/hH3BU+bU/qqa6t0/I0SKqWgPhspjuuh8XUaHzd7YeZmh08A5hlLBbR?=
 =?us-ascii?Q?QCwQIpBy5Wfz2YGgQXsxS6Civ3X0dtexPtX7AkO4X3qtmUOSUHLvxhSlnlEv?=
 =?us-ascii?Q?1bkzZBThbaSwZ6HpAgCY6iYHqHfpQ/leBirYkkhWZrQkEUqeacYQqFld8NAS?=
 =?us-ascii?Q?fRed7XSkRSq2Q3d4AzPZoqLbqh8dkjE920GaOZP3peh4Ld5s0KppiMORxzpS?=
 =?us-ascii?Q?1usZRXhwAMKQqcw1uFH6OAFLJXxis4VRcZhpm9VT+PIYCtTCJa7HrsYIrEzE?=
 =?us-ascii?Q?VNPjSDm5B1FlsFwbOMOvU6TSg6RcrMJP+TImiu5omoFcoHviI+iKEqzdjs1F?=
 =?us-ascii?Q?SbJCXpt1NcXVzFNdbmqPIEp79haydCjjd6yn2muITfNiAEm5i+OFe3UsO4vc?=
 =?us-ascii?Q?37pu9oCG7ZbTAmOZehRimd3lJCLtnnOv0ybLD8a0k9ma6692BFJlswVtZgLC?=
 =?us-ascii?Q?HfD8qBKa0BXei95qVrcf4jBcJBCOQb4ax05OKBAxNHiJuLEFE6vgOf6/7R3S?=
 =?us-ascii?Q?2H4WnsHAEhREnPLDUEOrA//+FELVPQBtzInMoscwuD2GPHpQ3BZDadoEWck3?=
 =?us-ascii?Q?hu7Fp75nhmPw5R7dIG1Id1wPMOJAW0QA1CMiHbUrJ0kmqo3TtxMRxFtCDY7Y?=
 =?us-ascii?Q?aygUhu9RKmY8jUuLM4AbYf4SpoWB3UKakhisCNHP08ZXPBqugkNIuAReZ6HN?=
 =?us-ascii?Q?0zguMW8h9AkZdr+hmSQJloNYP9HY75AvPiEBLKxyN8ZhL6Wg9DW9ka0vD/kv?=
 =?us-ascii?Q?yUzmZfqCor1eGcaiF5a4ngp//4BSNHkrzl3B5ukJ0UyDyCFiy+Nqx+QWdrzs?=
 =?us-ascii?Q?QDKzImE+bQVjpX7NsgQ6ewS15Ayg6Ct4Ixth/Am7UWkYM/LBcqorskIEAarw?=
 =?us-ascii?Q?IcN4w4spcuA0aYh+gNx98ke7bZA00xE4ERkDyt5Bb22QcGk468C0JpADNDEA?=
 =?us-ascii?Q?Hbd1jSUSUteeTlAaRQYFKdkK2NcejGr5CmCS5Cjz?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c98c3c65-08cb-469e-5860-08db451bd7ef
X-MS-Exchange-CrossTenant-AuthSource: LV2PR12MB5869.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2023 23:30:09.6338
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rt6IUMeJXYL50YI/9iKSC/Aw7V2jWy7VcRtAPpdKWlZ90Gnsf0PVJ34NdpebjcY+
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6466
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 25, 2023 at 12:26:25AM +0100, Lorenzo Stoakes wrote:
> On Mon, Apr 24, 2023 at 08:17:11PM -0300, Jason Gunthorpe wrote:
> > On Tue, Apr 25, 2023 at 12:03:34AM +0100, Lorenzo Stoakes wrote:
> >
> > > Except you dirty a page that is mapped elsewhere that thought everything
> > > was cleaned and... not sure the PTLs really help you much?
> >
> > If we have a writable PTE then while the PTE's PTL is held it is impossible
> > for a FS to make the page clean as any cleaning action has to also
> > take the PTL to make the PTE non-present or non-writable.
> >
> 
> That's a very good point! Passing things back with a spinlock held feels
> pretty icky though, and obviously a no-go for a FOLL_PIN. Perhaps for a
> FOLL_GET this would be workable.

I didn't look closely at the ptrace code but maybe it would work to
lock the folio and pass back a locked folio. Interacting with the PTLs
to make the lock reliable. It is the logical inverse of the code I
pointed to for inserting a folio into the page table. (but I've never
looked at the folio lock or how the FSs use it, so don't belive me on
this)

Another interesting idea would be to use mm/pagewalk.c to implement
the memory copy fully under the PTLs.

Jason
