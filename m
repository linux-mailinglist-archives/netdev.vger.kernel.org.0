Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB6E7474531
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 15:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhLNOej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Dec 2021 09:34:39 -0500
Received: from mail-dm6nam11lp2174.outbound.protection.outlook.com ([104.47.57.174]:6217
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230309AbhLNOei (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Dec 2021 09:34:38 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BS/rAFGq4SxTdftSj51nBEfzMqrm5GKFGG4oeJlyfcbB0vzEw0ZvRIrvcMlUijkIc6WIaWlhyW+vDZCXVoreMdPYtZwn1/miuFC7ksnvPgdbc0fuMDeyGeHRkJrGuO+rp5W8793PIBh67WL5iJJLzcYkNlwyv5VA/ZhxcGVUs/KjZqa0m7mBXg8cyFI0cSTGRLRXvdwuCRqLcYO2Dn5YZ8gkB6tFD+mWJ1qBFX5w1Br+w+qp8+QidN0Lu3DgTJ8vfj9EEN/zl4eUj7FdcTvIuuHlpMWOF6CB7/6vUoc7Xp/HlaaxLpdN6jKTmmvvpN0PpW6MJsx5KJU1YD3rYMRSOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=imwBf7UkD5mxP6SutuTUw4tFcEA1vymAqjCHQBBgNxE=;
 b=NXRkTDbE35lj96hmI7Q/IMe9l1UA0ztbjuIP9HFzlSolR6U55RzuHu7qFPxbZnFERETI4hD9EnR/eihBXFBW8yVz9ueP31MKoWNqfJfQJdtrSjVqslI/H6b8kj+RvZrz94/r7ZeVABBbACnUGQ4uPWd3zrNo/BQhWPEBwx+MoRD7h6HlsOThWRx7ZiJplDpvPMNwX8y3TiyPo7c231WJqsjDAmk+44wraFsAW+pFG3Z+8Wy9DwkUZ2O6nklCSH5lFX9bhJr01xG60NWy/9ZUyL83o3jyb+zlvW30FQt/UrBm1pAd/8L/kDENZdqAW+0lriufLC9BYLoPP/7+mdAdmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=imwBf7UkD5mxP6SutuTUw4tFcEA1vymAqjCHQBBgNxE=;
 b=bwC+0R3HpwBPsXqC8VOUZi9MtGts2TTqvRJ8VVmuBUeyWXOC3/ktADqXnZ5CmkVcjmw3BDMLR7pUzAa1riB9lO8ESD9k/1jRTlsL1SWASqCu7tTA59woswNR8q3qgttU2TZ+zIlMfEw0SRUX+WZaQ3k+Pc6JPn/z36cJvc7TMVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB5573.namprd13.prod.outlook.com (2603:10b6:510:138::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 14 Dec
 2021 14:34:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::a01a:4940:c69a:e04c%9]) with mapi id 15.20.4801.014; Tue, 14 Dec 2021
 14:34:36 +0000
Date:   Tue, 14 Dec 2021 15:34:29 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, netdev@vger.kernel.org,
        oss-drivers@corigine.com, roid@nvidia.com,
        baowen.zheng@corigine.com
Subject: Re: [PATCH net] flow_offload: return EOPNOTSUPP for the unsupported
 mpls action type
Message-ID: <20211214143428.GA463@corigine.com>
References: <20211213144604.23888-1-simon.horman@corigine.com>
 <163948561032.12013.18199280015544778926.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163948561032.12013.18199280015544778926.git-patchwork-notify@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR10CA0038.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e98076c-5932-4aed-e0a3-08d9bf0ed9fc
X-MS-TrafficTypeDiagnostic: PH7PR13MB5573:EE_
X-Microsoft-Antispam-PRVS: <PH7PR13MB55732D8919BA75B18BD56147E8759@PH7PR13MB5573.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FBniHd5bVnO4zh9HVcbOVJLI97VD7Ip8XHOosch6XkKNcEhV2bDRdbEDTJ6W5SxSY3GWoAc+M0utjzSWXlbKa6pXNKYfG2FfK9SbjUkXEsJj2By8TTtz4mSPFX9y1ywuGjT/tdNyViBqK5tOOWrCmK4WVRZmxKUEt3c5zGyBY3E5upB1ubPOoYyijDkDjh1v+qN4caBXjvR29syDxE7lORSaDnBxeMvRQbbCZZJn+iT+Z7m4L4NsNi8KfwBGAXfiMxVEWOuZX6snH6B8a2Ry3kfFebJlAZHy6k0LFRcsti9COiXDkbUd/F88MnhxbU8QM1Zcbe2Au8pOxoiUWp2gdH7wgmM3+F/L9B+zIkgaRezu06E4UvSxHRg7v2wG+PVahueIeIrndi0DQYgtrBJEmfOMIVlRGALMTzKJniuu8bITaijDu6H3/hdDD0uGdGOoH4LbKub1xPRvJhiAtapdSCfgvxUIgOu/QK1I7DOnfVuCr5yxWIqO+PzuKM4K4b/q1TBAWlbHb5wm8Yw4ezhsB3ZR6nUzC44O5hF2RXtjOFYP3lwO9NhqcDLN3HlKV64NPa5sZNy+q4u+wRAU366CFpz9gTEgqLQ0YfijznDSPB+5yVXcpjSftSuYERJSNtERVk2ZZCN2ML71Ckp2kdLBCFdrrbjGG6dnQ9nZSSUwyut5TPCPqZNy8afRoVKxhd9ITX6XLu6vZqVzC+CDUF5jKNQd7bV3FlYfxfooWSKweNvlXsUAzlMv5j1AOc1rWfeRjsef3wQiJOxlvbLHVfR18A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(366004)(396003)(39840400004)(346002)(376002)(1076003)(186003)(2906002)(6512007)(5660300002)(44832011)(107886003)(2616005)(8676002)(66556008)(66476007)(6486002)(52116002)(6666004)(36756003)(6506007)(4326008)(8936002)(508600001)(33656002)(86362001)(38100700002)(966005)(316002)(66946007)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yhLlp44X+Sre6QIorJMsrAIVta/UjMsxMZZz+ucy+dpRPdjAxOnJQm9/sEcu?=
 =?us-ascii?Q?KzjY5gL+GWgEYOKEDUq/+MFgWNqsrJnyAO2PDgGLukBfecjTFZpJs86TjiA+?=
 =?us-ascii?Q?i+V6eRv9D6c6UIrf9u90pVzC6sd5CdADngpMspENO/2NDZjSq1JLhjjtD7WU?=
 =?us-ascii?Q?tE/zrgpFgxdkhiNe41zH0sJUvhxWy8ty8x485o956WJFl7QjixGkrYF2uFV3?=
 =?us-ascii?Q?uTkk9lhLz2DEw5mXHL71wCfru1xXt2RokVT+pMUadL6s7IttIr1HEA4TfAGQ?=
 =?us-ascii?Q?L8i0H5mQlVp35ZfoPQ870ZrARwYl0AASq2vHnS51iM68y/0PQ1tI5jaxDz6+?=
 =?us-ascii?Q?k+uFATMgHDRl3OIiIBXsmMWuSzTlzOH5IiHpXWfumhibl8p88SJ6yPn964+a?=
 =?us-ascii?Q?yy3zxqy2Uw4hcw9rwVxpXU9HVjoX+zmExB9v+SYt1ONO8X9Fko1xZ+qgrIxe?=
 =?us-ascii?Q?rc9dkPh2jl/ANq8/4JM4FVZzs0L6RFCpDENgd0Bq/RKwKHgQUZNNXtK2nhaG?=
 =?us-ascii?Q?pK5GM9+5CiACezwzX94sgbvj+IgQnvRSVLiImm7knyuy3iho2wlYw3gLUkY3?=
 =?us-ascii?Q?vDIsGJlsiOSGZECjYc7e9a9ZT3rWaOzFppckpYvX1jpu71CAVJc1o/ZwOcsO?=
 =?us-ascii?Q?UuG6plFs/iQKo+mrspuk3UXDfSW1Pl2wzYSVqb9QHFEzxr9G9L61zpRFKbLy?=
 =?us-ascii?Q?jL5gIaN4T1ExIfYHJAa6J6s1gjxI8RRdrEtxUb8VV1ZEmdoLwVoG8bdP7x+z?=
 =?us-ascii?Q?wg8EtjyHpzwC+HRy706M3LxTJ8EUZ8i/h5DK3oSoKCTAgACmul5VSklMHiz7?=
 =?us-ascii?Q?I655MTrnbtA+aXkX8/doNKhYyPBwJqicW8xRTiGJv6jmSmSHgpceThX4+I1e?=
 =?us-ascii?Q?zbgsoBs3ruBjxGyXREWwSHz4k/M554+GsvFt5JC07jLrDAVhoWNJRCh96aY8?=
 =?us-ascii?Q?jf8G7B4iZ2xuVoxzGLFFfNgh1G001zpZ6w8s/HTB2uQxSrgP5ZfKr4hgAhwh?=
 =?us-ascii?Q?tHYXgFVjTVy19U/UShG0hZW8TWKzMPvMqlBFhfkKUYjQAUWyNXsU+jp3FClu?=
 =?us-ascii?Q?jS25wUqhHO9MXCHniUihQ/JUWWPeQjZiaqyadPNq6YyimvKJkru7k8ON/zNZ?=
 =?us-ascii?Q?4Vvoe/TccrUfTkQZavkWgXLcAwXjKa8RB6R+neDyM282TDzuf9OEa85Wf7kE?=
 =?us-ascii?Q?N6LsItpQkWaSdUBmIhC4bPoBNsZkRlkX+cTwnaSOqkKFIcD51DukCKiLIL1p?=
 =?us-ascii?Q?sssFn6rNTl0meW/no6p5P5nTxV+7WtFKCxCVrozE5VEPZnVGdZxNTvYqIlHo?=
 =?us-ascii?Q?MXuLtYbBaMrhxHn+TqMeGG1o6JpC4/aCMqC8TQhTBRuJq4xkMksA8ItBVpTi?=
 =?us-ascii?Q?QShbeSnfS+62LdKNf2a4je0rXqMuZPM+h3REtbOB8fH+Ik5ysTVJFFrfb8al?=
 =?us-ascii?Q?zM1q2ou1/ZkCvjSF+4oEiNRliDfeeFMZrzd/05JKQtIhF3jEkOsAsWlvzfAX?=
 =?us-ascii?Q?j4V6fI6SULdq2RsXnA9R7LqHZS/fyzXxcUbwzZyZfCfea6lQ/OCq/8E/q3Yq?=
 =?us-ascii?Q?fXlnjCIOws8u+ZTera6bvd0y9TRVQPAHTQn2Xa/kbeBiztjkSb17o+AkhkBE?=
 =?us-ascii?Q?RmGWydooEY1v4LX0H+4lFONZBg7TFjbMBILstP9/WE6u+0lAeGxvnLxvgdVn?=
 =?us-ascii?Q?hwb+gyStGcbWm/mqwwq24HqOvGe90AvRVBhmBbFhdIE2dEmWBiDo7/tHz87m?=
 =?us-ascii?Q?AIJ88TBOOg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e98076c-5932-4aed-e0a3-08d9bf0ed9fc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2021 14:34:35.9502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dFrxqEh6AheLyZJ7guhUNtA4QDcjQAxsLecwRESPpccIMg19gCPUIZXS88heJNNnsDc41gMIhNgcApWyqZnDyobAcFd2C/3dPK61QmZZA8U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB5573
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 14, 2021 at 12:40:10PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Mon, 13 Dec 2021 15:46:04 +0100 you wrote:
> > From: Baowen Zheng <baowen.zheng@corigine.com>
> > 
> > We need to return EOPNOTSUPP for the unsupported mpls action type when
> > setup the flow action.
> > 
> > In the original implement, we will return 0 for the unsupported mpls
> > action type, actually we do not setup it and the following actions
> > to the flow action entry.
> > 
> > [...]
> 
> Here is the summary with links:
>   - [net] flow_offload: return EOPNOTSUPP for the unsupported mpls action type
>     https://git.kernel.org/netdev/net/c/166b6a46b78b

Thanks!

Could I ask for a merge of net into net-next?

The patch above will be a dependency for v7 of our metering offload
patchset.

Ref: 
- [PATCH v6 net-next 00/12] allow user to offload tc action to net device
  https://lore.kernel.org/netdev/20211209092806.12336-1-simon.horman@corigine.com/
