Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB012571682
	for <lists+netdev@lfdr.de>; Tue, 12 Jul 2022 12:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiGLKFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 06:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiGLKFD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 06:05:03 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2047.outbound.protection.outlook.com [40.107.95.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87C6AA83D
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 03:05:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eGgxzSSMiiOzg9ESJL5dM7qON8OHiBqZhpqM9/82S2eLpdSzS3LYDLpOpPXV3V3ixl16ZuH+LIqpixEiX7YqpmkGb34+elO0tqYDyf6wESq6XatEO1lga5VVkYmq+LwXPLgEnaLeBZnDwGkWR3HKfW8IMSPKQCeNvyn+agIRkIaLRiF/pyt9xa8SwmY7MSBW00mE6EVqC5tjkqgY+B8qLcd+IZT2+lbwwiEsG6Ceo7+oO/piNZ7ti5PjurdMrCIZxfC7jR00t0XfAaBxcfFEL73rXt7XfkIWC28yvuF5vaQdQNRh1OkFZPTsT5wbgo/8feY8issckKIFWFoop05iUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wTTqHnGYjwLV9tjRFsA2IElIEH+Dd3Shc1c3Hn0WZME=;
 b=PWa63stU6DO1PCDdxuhf5VrbaFIpcJJ0/f1uQ6Ht5Y+su77E5TW4BXAFOmM1VXT5lLUT21hri4Vuiy6IMJjoshY+mRFeDwl+yT0mgjmqAQBQhiDRwDlDlyK3GwU0oUeqOjAX7v1MfJy2U6EDgSsku639z9gfzSifU8zOgJTi02a+Fz0Cv9ZqRScJInulRq9XdnbasDwV42GXBD40RSfFi+KMJh2wLOmYWikzuJRO3NEnaqQ9Q28zfKm7dyDGtfg65TbwSzeJ8qIgZIGdRksBvB+T4MwTNbKBek9tzQhYvYj12YJco1JRPKIDmrymHFZjYYtPJdbNvHehzLD3UNaQ8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wTTqHnGYjwLV9tjRFsA2IElIEH+Dd3Shc1c3Hn0WZME=;
 b=dDrlSVZgiJswwoUt6nHnmHTfE6KUc3/uQfdxsRtaQxs0FeoPHQWoYiw1vRQQlmUG9EFW/9ZVTSRKJrrhIO4TQ/EwKa2j//8H1kUhLUWt+ppNApne/qOxwF1d7M9MtDWYivJ+FEU/XUqHPQLVYs/Z48+eWopSNTKCsY65R3gUH7WEazEDuopXLVdNEtSxACL3Qiz8M5GegfCmgjoPyopdmP21UrrYcgDh+ceEbWHgApQK3IYfeZY80JOGRkRf2Zz/d6h3FDaIQqTySXhgTtdz5A1NIy/uabhI0GyXt+F+JkhUUztBMUS54BEpKNR/HgsPpy5/k0cOi+Rgr5ngmKZoVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN0PR12MB5979.namprd12.prod.outlook.com (2603:10b6:208:37e::15)
 by MN2PR12MB3181.namprd12.prod.outlook.com (2603:10b6:208:ae::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.17; Tue, 12 Jul
 2022 10:05:01 +0000
Received: from MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282]) by MN0PR12MB5979.namprd12.prod.outlook.com
 ([fe80::6cf7:d2b:903c:282%3]) with mapi id 15.20.5417.023; Tue, 12 Jul 2022
 10:05:01 +0000
Date:   Tue, 12 Jul 2022 12:04:56 +0200
From:   Jiri Pirko <jiri@nvidia.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, moshe@nvidia.com
Subject: Re: [patch net-next v3/repost 0/3] net: devlink: devl_* cosmetic
 fixes
Message-ID: <Ys1HSDTQpU7kOd46@nanopsycho>
References: <20220711132607.2654337-1-jiri@resnulli.us>
 <Ysw0XA2NC3cGxWIY@nanopsycho>
 <fbb2e0580c0ac108db8ee47b4342c4981f4d66b1.camel@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fbb2e0580c0ac108db8ee47b4342c4981f4d66b1.camel@redhat.com>
X-ClientProxiedBy: AS9PR07CA0024.eurprd07.prod.outlook.com
 (2603:10a6:20b:46c::33) To MN0PR12MB5979.namprd12.prod.outlook.com
 (2603:10b6:208:37e::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b2bb003-57e8-4c52-0fb0-08da63edfbca
X-MS-TrafficTypeDiagnostic: MN2PR12MB3181:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: v6lg+u1KVukOp/7zTWEhISJUoE/gwnPaklwXYxNG38CMqXbaCNYDKcca/2sBsF1Wp6D7mM9NJtSXdJkhNtjFtPlE9/fGvOogSMUcds++M0utrlvXo50u/mrKdnDr7FbVEzx7Q9P5t7Gr0xueTKGogtlH0qF6VBNTkBDIanL3Gry8T3JiMjnTAYOAWIpsZf99KMokhiKE2wJw4WvoOvZ8D3I25M7EBXLhSCLbpW9iZFEkFlnhfWu42guZZ2v0NbCoB+E69VDahF/izTbB3VyfP7CvhepTfVvm15ccQm9zLkKJmyu+Fl4pi1jphKOrJXfEpixxPvjBWp/VVK7N2PzmOcMF+QjiUcUMRYaK4bTrCRNtMWBlj1hteuHTnmOl+xCKRQCo48BmNZpvt+JYI00SmbDz3mRgxZslUFqMsd1G2bwWSYwQda4GdErxn4SqrKf/TCuzwe6gL3wnG0VtwxEkLTC1bdVcG09NFhGBqL9ip0fIWr76Z+GJZlC1qPJNJ1IIjyTr29BNk1nRNBzUjvd7Rp4f450aBnCDBNb+e8dlYJCtIJDx6CkRsUw/SVTGPwrBoCWuN3sX3wzZ+0kh7qKRQziCkNKJHrw60Dq3iGw5bB2Nr39Cs/ljwpTqaY9vYiFkSVosQ+tLoT4VxXZVancBmNOqqB5nhm8a92RzO/gBR9upcRmum5eTyzjbwSe3dhJ3+Y4yVA0PtbL4QIYR2zFeSZTp4TAgvEhTaJbVGY+Cj10jvP6OJIo5aNf9KX8locMs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5979.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(376002)(39860400002)(396003)(136003)(366004)(66476007)(316002)(6506007)(33716001)(2906002)(86362001)(6666004)(38100700002)(6916009)(8676002)(4744005)(41300700001)(6512007)(26005)(9686003)(66946007)(8936002)(5660300002)(186003)(6486002)(107886003)(4326008)(66556008)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0S3+QXpIre6ExEGD4Anhg/WROE7k03bckZM8RtRXMC/4df1rIgGMFjJFiKM9?=
 =?us-ascii?Q?HrRAkYp/muF/Le3J3u2X83micwzFf5bs1cvKSGcIpJDoNNcm8BlapWBNc1oy?=
 =?us-ascii?Q?rRlHCc8WenLEBOj+6Q7J74ejzvz1xmbi7+pYQaUiNj0fbuLoXq4oCG2oJVvl?=
 =?us-ascii?Q?nDMjouA4CJ7GcHc7QXLOljOeIZCcZ7x1CQkoRsp7O6GrFKVGslNF9FAWM1xQ?=
 =?us-ascii?Q?oUHJMWStlPkU2KOSdNQ4s5y4FJTbIm8q14TkG0KgYSD+Gp35uczBBMfJwl/9?=
 =?us-ascii?Q?Onlk7SBsy0uyhTLwT62xqw1cc3DKagAkpaFgQAhVZOKgPU/2CSXvge9S0Kmp?=
 =?us-ascii?Q?zrUNWW0YmZwjYrz+gzj0TOhdGglyQf/h4qNvI8BzFISEaSjuuhgP6WiAgBuo?=
 =?us-ascii?Q?WwQy/J+ybvMa8MZnFtK2LZQKLU9J0UV9Dsh/GXodooIq54Pl2Ci/2QD+6O/m?=
 =?us-ascii?Q?zWlxMRm3bpSTGLAdAQq2wAmLzSwUkrpylwpfzS6SUHV1JBBA3uDCedCpSWO6?=
 =?us-ascii?Q?yCQJpiFn/P58tgdQlORZ0Mmj268Q8B/14NPS+d3FnF/v3HsffQ1bYeVfbLD4?=
 =?us-ascii?Q?HfRLVbvZWtq+bvyowHbInJ4C15go5nkp5pOb+9qFMkYvU0+4xD67nwdHvw7W?=
 =?us-ascii?Q?l4fW1ECiPrOQ4wpgxw/Z2L4HJ8l+np8PM+ap3mEJUBTWY5YXSy0tf5ldnRHL?=
 =?us-ascii?Q?8iMHRHcqVPk1dOuJGOnwmDEm/fonB7vorH4DLsM/2SvXUeZ9Cij+ycIituRy?=
 =?us-ascii?Q?6poM21nipnACcRV5RGBqAySIHw5nNcoBnbp2xGdvMTf6ixhexIl1foeXUd/k?=
 =?us-ascii?Q?xxMqyrXXnbpFgYDeNBmgBgS9M4UXO0wSQZJKCJg2I35OzalHdjuQGRAIGe5n?=
 =?us-ascii?Q?g3ArHs1zuMGaMz4G18tEGiKnr0mpzeV6IL6bH4GE5Kk+IAG5xP59nm9paLG7?=
 =?us-ascii?Q?HMQa3emj04hbAcfhdL9KGIIJKdAArc8lm5tKXskkx3V/GPVh7pSeHDHMWTFU?=
 =?us-ascii?Q?UExMdTYhskuY+lGHUyfFHAZe1KvqirnUfI0qmpviaRmWDrenxuKW6/sUyG0e?=
 =?us-ascii?Q?GI4+MIDvoNK0apuwuGh0FwpnaHis7CUjOuzoqPF8PIQ/FDGvau9GjdBXbWwr?=
 =?us-ascii?Q?onm9TzY7muJ0PTdYbDKYtKb11HvSQ6OOsJrFGmn+Rw9Tl/BWzoCwC4sfg58B?=
 =?us-ascii?Q?aDMnEet01+ye4DoV/RP48+JSeuRN4vQKL+O0QpnotUmo6nx9/0ndKj0qoxuP?=
 =?us-ascii?Q?1HoW9IbKetaqrpwzsUru+BR2B+d5SKX67CvqLqh+Zga1fyyXOM2ivqY4yWA+?=
 =?us-ascii?Q?p0Nk8sHoUuyGYLTSffZBn9FML817u8gUl8ZdPHpXM/eMzV4/zpd51WkIbx8K?=
 =?us-ascii?Q?o5BPz+6GnjFP6wUt3H+IMK2KHizqSWlx0I0MGkbQ3kYRMxcLkPs3DvNnXB8s?=
 =?us-ascii?Q?HhhES9svAG8kjAYXYP2siMJrrHEA0j0oJ2uGeCLLTIDxO2SUnU4L2qAmGtR6?=
 =?us-ascii?Q?zn3T8tZZaTJgzrzb2oZdq2bMXKOy+Z6DJRzEO9F4b1WGiA94ua9DibXgr3Gz?=
 =?us-ascii?Q?zntUMeiJ29mrgLbEbwQ=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b2bb003-57e8-4c52-0fb0-08da63edfbca
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5979.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jul 2022 10:05:01.0631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: onvSZc/tlOkaopNcWd86BJpaGbIh838uF99Ocji154s4DpBFTave6pLfnclmTFlO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3181
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Jul 12, 2022 at 10:53:38AM CEST, pabeni@redhat.com wrote:
>Hello,
>
>On Mon, 2022-07-11 at 16:31 +0200, Jiri Pirko wrote:
>> Jakub, this will probably conflict with Saeeds PR. Let me know and I
>> will rebase. Thanks!
>
>Indeed there are some conflicts. Could you please rebase? 

I'm on in. Will it to you in a jiff.

>
>Thanks!
>
>Paolo
>
