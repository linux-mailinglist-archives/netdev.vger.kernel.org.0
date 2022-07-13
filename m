Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA1FB572F3B
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 09:28:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234743AbiGMH2c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 03:28:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234519AbiGMH21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 03:28:27 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFE2E474F;
        Wed, 13 Jul 2022 00:28:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tv3lAUOEcsb7RAYEsUnzkJeg4uWJcnKDEGCHnqjCkhVaWygNIX3puyZ8Eb11f1tGLPmSUz1oTTWh5C17PGtu5EoFl1+WZlFc4K4rYmFSyTekO9A3SnbKFzSr+F5jzzy2o3u/VHqxHskwCoL/w70Wgo9IZpSJt8jNcf5Hp+vz78w/1qu1y+i2IuGqgDmNXv+ddV872UuJPg0q+tJNpAcGYGo9nmeixT4oU+zZp7/8eIpDg+9I+smmz1JDVbbGXB0VMnkN8ejVL8cegSY4bxwEHWtY1gMv0tmBl/Qv1Bw0NNaEXobBjmL4KR1Y8KXu5Dc6f4UkaAp2paX8sKgaKKcboQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qTGH/1ng40sAS0k1gHLsvrz+P88R7+4+DIOmRr6gxns=;
 b=RRLWXhFu7m9KM42ae3EHi2Mol8uGiSRC8hHyPdCSk9w0cG2M2iS+K6rg9vsXaH9xxmrG1RnYce5JzxaEHVT0Fik7p/pUgIHOImJJwwxZjHw1TfikYIhwG6z08ic/NeEEewzGxipBxRr6i5MBt/S6f/ai4Sgq09A7Tv1f/DYL7Q+2qVH8TgDvvijLmikh8jPnzXIpGXeR6FBUuJFgAAGi6oNiAxcnHrN3zkLGH+xu5KgzmIAfgv96dgMweZD/vypDOl50E1OcaJ80nZctNk1u5RPZYoWepfJSpl1C2SZOdalGGWYccA2ai+BVQLlPfbqNrsf/pIvOaYAm4moAHpH+gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qTGH/1ng40sAS0k1gHLsvrz+P88R7+4+DIOmRr6gxns=;
 b=olAL/sfpDK1fNj0GGRfkDZVmSNwXJfGplLW2Y9pl1+ksXFHOiRRe2rn99ekoWoZb9ra1mXVDkdcW9lRdarmaM+hEUu+x3q8HYFf0TOQcDYYoIsEloJfb79DI0gCC71pFK8DSCamd0gUFzhV3tBtldtclRlpGCOd1VKhO6SVG66LRxWXIWRMRsbsoy/8Kj9jH1hEtKvscwfHmseZhbyr6gGrC7TVvukjC09yz0t44Hl/Hp91woYjnxveAyc9Fh9IsiwE6eEi5pfzY24pEyjHVAYN3sn085hGpU4ltDDbZH0PI+GtGQnRc1fe5J6Ef74RTFz23fCh14Op028hNdSGkaA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by SJ1PR12MB6268.namprd12.prod.outlook.com (2603:10b6:a03:455::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Wed, 13 Jul
 2022 07:28:17 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Wed, 13 Jul 2022
 07:28:17 +0000
Date:   Wed, 13 Jul 2022 09:28:12 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, dsahern@kernel.org,
        stephen@networkplumber.org, Eric Dumazet <edumazet@google.com>,
        pabeni@redhat.com, ast@kernel.org, leon@kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next v2 1/3] devlink: introduce framework for
 selftests
Message-ID: <Ys50DGXCi5lPaRBB@nanopsycho>
References: <20220628164241.44360-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-1-vikas.gupta@broadcom.com>
 <20220707182950.29348-2-vikas.gupta@broadcom.com>
 <YswaKcUs6nOndU2V@nanopsycho>
 <CAHLZf_t9ihOQPvcQa8cZsDDVUX1wisrBjC30tHG_-Dz13zg=qQ@mail.gmail.com>
 <Ys0UpFtcOGWjK/sZ@nanopsycho>
 <CAHLZf_s7s4rqBkDnB+KH-YJRDBDzeZB6VhKMMndk+dxxY11h3g@mail.gmail.com>
 <Ys24l4O1M/8Kf4/o@nanopsycho>
 <CAHLZf_tzpG9J=_orUsD9xto_Q818S-YqOTFvWchFjRkR3LXhvA@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHLZf_tzpG9J=_orUsD9xto_Q818S-YqOTFvWchFjRkR3LXhvA@mail.gmail.com>
X-ClientProxiedBy: VI1PR06CA0176.eurprd06.prod.outlook.com
 (2603:10a6:803:c8::33) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3ff11602-51b9-4e33-d112-08da64a140e7
X-MS-TrafficTypeDiagnostic: SJ1PR12MB6268:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /6xLTUjo5aXx9EaBjZ+opWAx+fbwHd19mbI+STuQrobMz3wx8V/1u1/nueqSyVceF2TqvT1OKMPDDJMuJQ/d8XoPofvYR1To/V1cQDSevJRNVphku0Y1Ny4BUmkR468ra1agcfaH26GhIv+Tt3Aaw51ugv6i34omUTzzZakQON+RpRzMG1epsZCNoA8/RyRYNDwJ697+zxUOiDLQe9qshvHX79QZO9k30QnglH6/53lngPL9mYW6g+/f3SseFKo0XJIfhW83L9LVpiOHaaoEusS0HP0zuV1iSvMVAYR/VLxeJD8YqNUqdvP4r4HuaKdNYcIDLc32wPU+GV9kQJaKy7sZHL35gxJQGdxfzUmd1rx6fddrEqgQoM7BMhQWqYWQQZmLA5tTvK04B1x1nnl/znnkGweaTNWiZXVQYnxdEdYSmt8ENCkA9XMKZRYJNKzvZA5QUc3J8+84tR01c1/LwnrTHWsawrSpLjfY6DxveVooiDE2kXSDRKB87GEVL1NBT4AwiMpOzEm55uztmRneeRSO0rxOab+/hnmFSZvu3SkrfEhiq2MrRV0xz7GnCuKNw/FjsGIx8WUd4sob5CNIZbBsK6waiaLgLw4iOoVt/GpfY1iiF8ZPSppxtCxQ9hwc4ffLFDuQe/S4/d7wTEI5df3IQIZtNdfPCqU5UVMKtDbaG3QmiAPgC0C0nT++BpwvNL4yJR7lNiIr9Ve1ws/MDGuoMJuLAqjtPZPXao+PIzuS3ypuZA538WP5smt/vEFaIpct1WLYiAxBcKi3SQEV+Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(376002)(136003)(346002)(396003)(39860400002)(366004)(5660300002)(6512007)(83380400001)(2906002)(7416002)(8936002)(33716001)(38100700002)(6916009)(6486002)(478600001)(54906003)(86362001)(316002)(66556008)(8676002)(4326008)(9686003)(41300700001)(66476007)(6666004)(6506007)(66946007)(186003)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/DslvnYa0LR9+Mb8eYM2KoTN9FeL1YWLRuoAPvb29dqZ2DG88aKiRg3F2Z63?=
 =?us-ascii?Q?Z31WJI15bsBSgdjcQ5fUXBEDwcik1phXUo/MfWzHMC5QcezWP3nqIjcuyb6w?=
 =?us-ascii?Q?xnUNudNDF6arE8vuTvYIzz9a9rIr8lSAg0Wek4c7uWSl9mebjr0YoAS6RiTc?=
 =?us-ascii?Q?5pQKKJn/A3jYoRZ31aNh3S4gqpCSkhsz2/XL+ZVsQPK9ZcHdwbJKxGW6ern4?=
 =?us-ascii?Q?BhIXOdFZaOq7K55MYObeUm7wtiblQgddK8M3euVY5I92EqfjuW4y77xDCg9r?=
 =?us-ascii?Q?9pj17z79aZRfiwr5jm9m5HAU7X3yE2T1O5DSGCDUtyyZikWJRjbvxD3WZbss?=
 =?us-ascii?Q?HgEbt7VX7auQtozu9zGZoBT+3YZsEcgxctmUM2HaA5t76TXVWQiIvVhUPjZG?=
 =?us-ascii?Q?/hYuFLOZN4JkIvSlAnDf5GvbX35Q5Ys38kdlQVs/CS4Rf/Gefs/7Vxr+upcu?=
 =?us-ascii?Q?zefQgtM5w3rkYZ5w2Jxf+SjZQy+tEblpNifgO54xaRt9F5UvYajoSkjZkNBi?=
 =?us-ascii?Q?IVx5FKLk25yYuafCKpMnsMkA+lpvibYY9TZQSF7meQl99aRhc9xCTWn94GVW?=
 =?us-ascii?Q?w9oN+qQkSQNxaITjDyS58vRDuchIUqHEru+XzDUk2RBKc/0rPwMSFpYymJK+?=
 =?us-ascii?Q?eq8lGWGzmVEj+zaP9FXIUuU/PvNhzVahblp6hB1vqrJrGJo+QdfKH09sBsJA?=
 =?us-ascii?Q?j0CtEnVNvWiuCudPLa+j22qxZpfBOmHspCzPB0iw/6XRWIvZjhmlINOBi925?=
 =?us-ascii?Q?NGBHnlZQO5WETqKpB2TwGhTxI38SgJ/MyIAP4Q0ZZKNKZPFcRx639Y08lJdP?=
 =?us-ascii?Q?jfbD3fU2z0m3OvMuUkmN5eXAh/p2yTu3QtpVuitOqjLNu9gv2K/RUibu583v?=
 =?us-ascii?Q?VklTmk8eITw8ifDqxjXF2ok83rqDzW6eJtOReZGUaXIrRUByp2Q34dvqCpd5?=
 =?us-ascii?Q?Z90hih/cDYcmvjUggqLQnMHLPCE8Xcpq0VZkBXL3N64Y2yVxe1bciLNcYZ/M?=
 =?us-ascii?Q?MPOVHaVamgaOm14iCQX2T5oso22dNwyxJz4dK5jHa1uls/5ckJsPUjDBxnF0?=
 =?us-ascii?Q?nBn0AASD4h7nCj9HGmSRyW6Kel/VB4g7KsxhWdDRv9/Zw29u/a6AFWXZuvuR?=
 =?us-ascii?Q?v4EKHkkTvyImv1dS4/ACN1VO7A5EvnLKl9fPN34Ng7QthtONaBhh0rGIPHg7?=
 =?us-ascii?Q?vLVFKLw4mwru32Vi8UuybMRs0yViBMuaP5hsZWdNPovSHJiih8QHPwHUHpxu?=
 =?us-ascii?Q?7gEP/iCV6M8kYYs9Xo0y/9FyHtK6EbFew6Q7NO2D42z12CHfyLZx+DWzA0OX?=
 =?us-ascii?Q?gIWlFt+V/2/e6WtKFnrUhWb0NlgtbYc+RqT5TfNsWmkRxdW2AJun7HG3K+GD?=
 =?us-ascii?Q?ulU8hdIiLg5QK9buyUOk6SsDcl/fSQ5YzDQYrymQ9RhHsDi0AbFB+M4JHu4D?=
 =?us-ascii?Q?gQNLtzgtmi/U0O85kZy47GA/gXxffk70H/W+u8e+fA+MaaeixbFkobDRx0XV?=
 =?us-ascii?Q?CdbygP1gQ6GqnedGBHLDd22K5WIxPhRakX5gjNyxYYDHKksv70oSxtixmGWu?=
 =?us-ascii?Q?9Vjf/X95PVMPZmpu8uJvENfW/8zQJv2eHbzpwve2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ff11602-51b9-4e33-d112-08da64a140e7
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2022 07:28:16.9511
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qLgGWVVqkPw8u16ERXxurXUErzBt1wItZmeRmkocBHWGMg6Coj+MHbZC/5IAkDNQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6268
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Jul 13, 2022 at 08:40:50AM CEST, vikas.gupta@broadcom.com wrote:
>Hi Jiri,
>
>On Tue, Jul 12, 2022 at 11:38 PM Jiri Pirko <jiri@resnulli.us> wrote:
>>
>> Tue, Jul 12, 2022 at 06:41:49PM CEST, vikas.gupta@broadcom.com wrote:
>> >Hi Jiri,
>> >
>> >On Tue, Jul 12, 2022 at 11:58 AM Jiri Pirko <jiri@nvidia.com> wrote:
>> >>
>> >> Tue, Jul 12, 2022 at 08:16:11AM CEST, vikas.gupta@broadcom.com wrote:
>> >> >Hi Jiri,
>> >> >
>> >> >On Mon, Jul 11, 2022 at 6:10 PM Jiri Pirko <jiri@nvidia.com> wrote:
>> >> >
>> >> >> Thu, Jul 07, 2022 at 08:29:48PM CEST, vikas.gupta@broadcom.com wrote:
>>
>> [...]
>>
>>
>> >> >> >  * enum devlink_trap_action - Packet trap action.
>> >> >> >  * @DEVLINK_TRAP_ACTION_DROP: Packet is dropped by the device and a copy
>> >> >> is not
>> >> >> >@@ -576,6 +598,10 @@ enum devlink_attr {
>> >> >> >       DEVLINK_ATTR_LINECARD_TYPE,             /* string */
>> >> >> >       DEVLINK_ATTR_LINECARD_SUPPORTED_TYPES,  /* nested */
>> >> >> >
>> >> >> >+      DEVLINK_ATTR_SELFTESTS_MASK,            /* u32 */
>> >> >>
>> >> >> I don't see why this is u32 bitset. Just have one attr per test
>> >> >> (NLA_FLAG) in a nested attr instead.
>> >> >>
>> >> >
>> >> >As per your suggestion, for an example it should be like as below
>> >> >
>> >> >        DEVLINK_ATTR_SELFTESTS,                 /* nested */
>> >> >
>> >> >        DEVLINK_ATTR_SELFTESTS_SOMETEST1            /* flag */
>> >> >
>> >> >        DEVLINK_ATTR_SELFTESTS_SOMETEST2           /* flag */
>> >>
>> >> Yeah, but have the flags in separate enum, no need to pullute the
>> >> devlink_attr enum by them.
>> >>
>> >>
>> >> >
>> >> >....    <SOME MORE TESTS>
>> >> >
>> >> >.....
>> >> >
>> >> >        DEVLINK_ATTR_SLEFTESTS_RESULT_VAL,      /* u8 */
>> >> >
>> >> >
>> >> >
>> >> > If we have this way then we need to have a mapping (probably a function)
>> >> >for drivers to tell them what tests need to be executed based on the flags
>> >> >that are set.
>> >> > Does this look OK?
>> >> >  The rationale behind choosing a mask is that we could directly pass the
>> >> >mask-value to the drivers.
>> >>
>> >> If you have separate enum, you can use the attrs as bits internally in
>> >> kernel. Add a helper that would help the driver to work with it.
>> >> Pass a struct containing u32 (or u8) not to drivers. Once there are more
>> >> tests than that, this structure can be easily extended and the helpers
>> >> changed. This would make this scalable. No need for UAPI change or even
>> >> internel driver api change.
>> >
>> >As per your suggestion, selftest attributes can be declared in separate
>> >enum as below
>> >
>> >enum {
>> >
>> >        DEVLINK_SELFTEST_SOMETEST,         /* flag */
>> >
>> >        DEVLINK_SELFTEST_SOMETEST1,
>> >
>> >        DEVLINK_SELFTEST_SOMETEST2,
>> >
>> >....
>> >
>> >......
>> >
>> >        __DEVLINK_SELFTEST_MAX,
>> >
>> >        DEVLINK_SELFTEST_MAX = __DEVLINK_SELFTEST_MAX - 1
>> >
>> >};
>> >Below  examples could be the flow of parameters/data from user to
>> >kernel and vice-versa
>> >
>> >
>> >Kernel to user for show command . Users can know what all tests are
>> >supported by the driver. A return from kernel to user.
>> >______
>> >|NEST |
>> >|_____ |TEST1|TEST4|TEST7|...
>> >
>> >
>> >User to kernel to execute test: If user wants to execute test4, test8, test1...
>> >______
>> >|NEST |
>> >|_____ |TEST4|TEST8|TEST1|...
>> >
>> >
>> >Result Kernel to user execute test RES(u8)
>> >______
>> >|NEST |
>> >|_____ |RES4|RES8|RES1|...
>>
>> Hmm, I think it is not good idea to rely on the order, a netlink library
>> can perhaps reorder it? Not sure here.
>>
>> >
>> >Results are populated in the same order as the user passed the TESTs
>> >flags. Does the above result format from kernel to user look OK ?
>> >Else we need to have below way to form a result format, a nest should
>> >be made for <test_flag,
>> >result> but since test flags are in different enum other than
>> >devlink_attr and RES being part of devlink_attr, I believe it's not
>> >good practice to make the below structure.
>>
>> Not a structure, no. Have it as another nest (could be the same attr as
>> the parent nest:
>>
>> ______
>> |NEST |
>> |_____ |NEST|       |NEST|       |NEST|
>>         TEST4,RES4   TEST8,RES8   TEST1, RES1
>>
>> also, it is flexible to add another attr if needed (like maybe result
>> message string containing error message? IDK).
>
>For above nesting we can have the attributes defined as below
>
>Attribute in  devlink_attr
>enum devlink_attr {
>  ....
>  ....
>        DEVLINK_SELFTESTS_INFO, /* nested */
>  ...
>...
>}
>
>enum devlink_selftests {
>        DEVLINK_SELFTESTS_SOMETEST0,   /* flag */
>        DEVLINK_SELFTESTS_SOMETEST1,
>        DEVLINK_SELFTESTS_SOMETEST2,
>        ...
>        ...
>}
>
>enum devlink_selftest_result {

for attrs, have "attr" in the name of the enum and "ATTR" in name of the
value.

>        DEVLINK_SELFTESTS_RESULT,       /* nested */
>        DEVLINK_SELFTESTS_TESTNUM,      /* u32  indicating the test

You can have 1 enum, containing both these and the test flags from
above.


>number in devlink_selftests enum */
>        DEVLINK_SELFTESTS_RESULT_VAL,   /* u8  skip, pass, fail.. */

Put enum name in the comment, instead of list possible values.


>        ...some future attrr...
>
>}
>enums in devlink_selftest_result can be put in devlink_attr though.

You can have them separate, I think it is about the time we try to put
new attrs what does not have potencial to be re-used to a separate enum.


>
>Does this look OK?
>
>Thanks,
>Vikas
>
>>
>>
>>
>> >______
>> >|NEST |
>> >|_____ | TEST4, RES4|TEST8,RES8|TEST1,RES1|...
>> >
>> >Let me know if my understanding is correct.
>>
>> [...]


