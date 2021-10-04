Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE375421620
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 20:11:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237786AbhJDSNJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 14:13:09 -0400
Received: from mail-dm6nam12on2048.outbound.protection.outlook.com ([40.107.243.48]:5345
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237210AbhJDSNI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Oct 2021 14:13:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EedM9eJppS3l5UafrY4V0QecZSI4LGaWOgnAvTFYvaQOuQvtvTlNKI7iaMrJq4QT63CKVgOrWj3/g4wth40xuc4Rhskcs3ONm1jUMRYgKaFLaiuuRi0lhXf1bsJPh3uMs2HnvIdX8AL4GwOWR+qgxF66fDxstch7sUNiEILBOpS1U2SyDoy2D73yAtKaDmsPPCQM7dQiU6vM9KLUhAupUdvxE7TLkyzHq42vTCJXMq1s3PMaTwk3zw6Es5eCoqW9jWob/yIuHbfmYj/8LG6DzCKztiUK5M0b+vKX/qFwb89Tvk9eg5CWI5ERmN9WpAF+a0QJmGSjGtAJ9ZoSxbywUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4bSPnB1TkKJJybiWYXYHO3d1kHPx58RuZCumYktR31Q=;
 b=TSHE28i6anGsZH8JKSLMlIVVizENrcj0Zz/kvixkvaJRYtdaxbYFRaBFfQDXpD5ppqyM3J+FhD2nXnsQ7I77hgQMOROR+eGZ7n1QyKP5ZNYI6Vwh+kTnSKULygFs1UY3eTx2QkXIxjCnHx6I6g6QkpghaB1LD+HYcKuqreYfbk6TslhxcLiXDFkfrjzWvlvJKmb5/hr5hL6ZucGyMfmxyF15pSqvLktOGNPxok3zyBINaAgh0m+MTlB23Rlr+2pCeJMDZCGJZ5FTeWDEd9plEAnfqiVyYi+aLfamzn/NUXdK5J4WRKfLpys8D6TbgmkIUPwAEHjydQMAnzVjJtSKdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bSPnB1TkKJJybiWYXYHO3d1kHPx58RuZCumYktR31Q=;
 b=OKim3XL5fpSO1n735IBoGbYcYY76zkxKTgWp3Ej1lyja93rVq+8YsZRtCmL/5ANP2R9E1b5zEU5ul8gWnxOAAxzRVwFWIZWpgNtrhavo2Z65XOGStzp7IAUwznHDilZik2u/wuOLTeY7eeIPj5FcYmZ4FDS+ROkavpv/23n9lCxAf0obBVDaLJL8ntsJDWtXrZoqUyZugyH0uHSx0Fc9xrB3ozjbp0kgY2MbRFjPmARm6zmGVho8UPvrwpw4zJXO+NblAEull2Nph72waoqG5JBK+AutFMtZsFK+jsyQNMQTiwa5PwnUK5YSJEJDTI5yrf+ipA9Zggd5OYU/ZsVlTg==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL0PR12MB5556.namprd12.prod.outlook.com (2603:10b6:208:1cf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Mon, 4 Oct
 2021 18:11:17 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4566.022; Mon, 4 Oct 2021
 18:11:17 +0000
Date:   Mon, 4 Oct 2021 15:11:15 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Aharon Landau <aharonl@nvidia.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Gal Pressman <galpress@amazon.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>,
        Mark Zhang <markzhang@nvidia.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Mustafa Ismail <mustafa.ismail@intel.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Neta Ostrovsky <netao@nvidia.com>, netdev@vger.kernel.org,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next v2 00/13] Optional counter statistics support
Message-ID: <20211004181115.GF2515663@nvidia.com>
References: <cover.1632988543.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1632988543.git.leonro@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0098.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::13) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0098.namprd13.prod.outlook.com (2603:10b6:208:2b9::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.9 via Frontend Transport; Mon, 4 Oct 2021 18:11:17 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mXSQl-00AYxf-KF; Mon, 04 Oct 2021 15:11:15 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 762c7494-f4fb-4c13-e8b7-08d987625c1f
X-MS-TrafficTypeDiagnostic: BL0PR12MB5556:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR12MB5556B07AC4E8B19F86573CC7C2AE9@BL0PR12MB5556.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cO2R7xzq2Pp5hFLObGsgxKdZaAUMygVKC2KhK3AV3d7TvKb/gVTAlfhbDnxdfqNxB58F7bj8HaIveEWgKKz2+HJ2bT7Y3jJ+9K827ZU84AkgDBbgULAFQh4lqVcy3LviQw/lx7wGkc97uOnLkXBtwiW6Bz6eubsaqMVECAe7y02c6Dz0HFg8qN6556EP/gup3AgeuuHOFM/f3KA/v651QmTE1krT1dO+zLe3K+0c77L1NhUx0D3xC+gHqpzIm/I93pv3hLKFAHMXgvZz58wWsc6aAOkYArkfCQM6QP6SyCaJ7+HXSnA7xHaY85fzpdfJq8AEAsjWwOkMdAnsUlimXxL6Pd9FSDgi/KoBa9YbPEqox718Onb1KK70KiOBOBy3AwCtVDClvpE1y+Cnm1iggboBmseKBX8qMckn0+3j6pfon0BpFWg9B+PzAE5RbrLuNKxf+ZoWidJb3Oy2DDRraZnHRUbJdvPB41cGYd3OqELE1d/deTFj3C6y7Sv6CcShozEBqNkWQDhsk4RII+lqsgru5Riyf2K/xZ9687ImdrnkWYfkXS0CIwOsf43oeAbQV5L9HhLm9lYBTRe5JtTzKRkNaAuh4tkU8Ur4xZQ4087KDQYqDkZQdTnaYqPHTYb6sAz/CAmTSNhut3j/+jDVPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2616005)(316002)(8676002)(2906002)(508600001)(426003)(8936002)(38100700002)(9746002)(54906003)(9786002)(26005)(86362001)(33656002)(6916009)(66946007)(66556008)(4326008)(66476007)(1076003)(186003)(36756003)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?uryHHH6CmtMKymXitQuNOWYtF38sxby4ubNKpVaVytW7zV2oLrJ+vNRoG02a?=
 =?us-ascii?Q?HLsior2HKLgDo3fygS8rxLpzNh8A0iowrWs01RDuy5zZHPsPRZD2o+d3Diti?=
 =?us-ascii?Q?A7nsE+kmjFiG9DViqv8KkAWI+vUUdOVmmeEbSNbcN7rfD+9UznzqOZz6h+2L?=
 =?us-ascii?Q?P3lORCiLDpW4pKyws1MktI8IINk9T8nhmMaef3w2H4unvV7u5HlSkyPmkcms?=
 =?us-ascii?Q?YX98Z6qVntCoH0hrG5O+aEgfxdZp53FZ6YpEv7luUp031HK5eMaynbLFCwXS?=
 =?us-ascii?Q?ivTdut5W4GhjQ+9WbX+wZa2STFgT+ymKTHV4CjMl24MM6YgjjfgC/cMJnxFT?=
 =?us-ascii?Q?g/rxe349ir4EqmfN77pKvZD0qCBYZwKuUVMJp1s4bTwb1cX0Gv+Xrofp3+j8?=
 =?us-ascii?Q?dfFvu1V0+jZEpNawfNP6s+f9swgW9BBpyGKbkZ9HPZQQuMOfhxPtp7Ucw4Y7?=
 =?us-ascii?Q?riTUpu1h7jlCC7uqV7KMze1V4hg+x4XtD03ITlSYgoXHzt26EqSzyzO6aCZY?=
 =?us-ascii?Q?j521iJIs5+FAl8Fi4PH3NVg0KcD/DveZRtmZEAqvVSwSWG3UdhJ393yMMPtO?=
 =?us-ascii?Q?N6LzBogv5J/fJausvh6H1WfBpuvT1BO3gWj0S3ut1zFZ7JKj0M72/vfOOFVX?=
 =?us-ascii?Q?Glg2zNgheRHivCZcB5Qsa5VxLMHRElZbKjb+9sYBIKdiMRx9j+o3EFB2Uiid?=
 =?us-ascii?Q?LOIH1izhyWXCQk+OcVzl3ia0abTUL3In6b6bs9CN/UiMO8KZLrY2v2Jgmc93?=
 =?us-ascii?Q?2Vg8DugEmxW0isjkRFYx4j1hrjIQKSry4RUJPjKooqQL7hpwsQiSRFd5VMli?=
 =?us-ascii?Q?00r9+un4LlvACrl0R5k5DzKqTh6Sks1QHWKrNm142me+bq9ToBWW0gFzI6ei?=
 =?us-ascii?Q?7D83+5RwX8AK+SFprWeZb9LYtC/YFqd0lSSzBxA1XovopiF9Mo2+DGitnRwv?=
 =?us-ascii?Q?bG5FaMN1Lr7GIxpN4rrmyOpOG4NbqZvb8I3mJjrXpRSxNGfPbpTcsRhYY9LA?=
 =?us-ascii?Q?Vv2nohs89CyrnZMjZ1g+M5iqmTvuGlBUIZKXFY1RPjNeppintgWR4qJqtf08?=
 =?us-ascii?Q?neTMBAOYmGnoG3H6UzKI/EkenqTb0qan9y5kvRUAUJTaGqhSRCZjmA+PwJwl?=
 =?us-ascii?Q?LxO38ZQXZVMLh14v1ry89D8DSBD8SXaYxcf2VyFcsMQ4vR1kqC2toqIJFxcE?=
 =?us-ascii?Q?TtcGdrtUP0ot9RwqYz+AGh17TavRc67Rw0CHDaA8Pq5LjhSdqYY1G0dBxvPJ?=
 =?us-ascii?Q?pSBXcFUUuv5TlbrgHMOVMeofrSxdv3cAVkZn1KmDsA1+TyPezwu+PGSw4E35?=
 =?us-ascii?Q?BblsRkYB/mD323tf0WJMlHUQdorRWzIaW+5cC18qClAvHQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 762c7494-f4fb-4c13-e8b7-08d987625c1f
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Oct 2021 18:11:17.4244
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PV6Unfz3Ty8iXJRP8jeyGls7MF11pdcKOa45itoWzpz/hvsjNjRoJuSGoL9/JRjv
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB5556
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 30, 2021 at 11:02:16AM +0300, Leon Romanovsky wrote:

> v2:
>  * Add rdma_free_hw_stats_struct() helper API (with a new patch)
>  * In sysfs add a WARN_ON to check if optional stats are always at the end
>  * Add a new nldev command to get the counter status
>  * Improve nldev_stat_set_counter_dynamic_doit() by creating a
> target state bitmap

Other than still having different get behavior it looks mostly Ok

Please mind some of the wonky formatting clang-format-diff will give a
clue where to look, I got this list:

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index adbddb07b08ed9..a7f9fe234a9e93 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -1910,13 +1910,13 @@ static int nldev_stat_set_counter_dynamic_doit(struct nlattr *tb[],
 	if (!stats)
 		return -EINVAL;
 
-	target = kcalloc(BITS_TO_LONGS(stats->num_counters),
-		       sizeof(long), GFP_KERNEL);
+	target = kcalloc(BITS_TO_LONGS(stats->num_counters), sizeof(long),
+			 GFP_KERNEL);
 	if (!target)
 		return -ENOMEM;
 
-	nla_for_each_nested(entry_attr,
-			    tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS], rem) {
+	nla_for_each_nested (entry_attr, tb[RDMA_NLDEV_ATTR_STAT_HWCOUNTERS],
+			     rem) {
 		index = nla_get_u32(entry_attr);
 		if ((index >= stats->num_counters) ||
 		    !(stats->descs[index].flags & IB_STAT_FLAG_OPTIONAL)) {
@@ -1959,10 +1959,9 @@ static int nldev_stat_set_mode_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	if (!msg)
 		return -ENOMEM;
 
-	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
-			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
-					 RDMA_NLDEV_CMD_STAT_SET),
-			0, 0);
+	nlh = nlmsg_put(
+		msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+		RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_STAT_SET), 0, 0);
 
 	mode = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_MODE]);
 	if (mode == RDMA_COUNTER_MODE_AUTO) {
@@ -2052,8 +2051,8 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	u32 index, port, qpn, cntn;
 	int ret;
 
-	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
-			  nldev_policy, extack);
+	ret = nlmsg_parse(nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1, nldev_policy,
+			  extack);
 	if (ret || !tb[RDMA_NLDEV_ATTR_STAT_RES] ||
 	    !tb[RDMA_NLDEV_ATTR_DEV_INDEX] || !tb[RDMA_NLDEV_ATTR_PORT_INDEX] ||
 	    !tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID] ||
@@ -2079,10 +2078,9 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 		ret = -ENOMEM;
 		goto err;
 	}
-	nlh = nlmsg_put(msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
-			RDMA_NL_GET_TYPE(RDMA_NL_NLDEV,
-					 RDMA_NLDEV_CMD_STAT_SET),
-			0, 0);
+	nlh = nlmsg_put(
+		msg, NETLINK_CB(skb).portid, nlh->nlmsg_seq,
+		RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_STAT_SET), 0, 0);
 
 	cntn = nla_get_u32(tb[RDMA_NLDEV_ATTR_STAT_COUNTER_ID]);
 	qpn = nla_get_u32(tb[RDMA_NLDEV_ATTR_RES_LQPN]);
@@ -2109,8 +2107,7 @@ static int nldev_stat_del_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return ret;
 }
 
-static int stat_get_doit_stats_list(struct sk_buff *skb,
-				    struct nlmsghdr *nlh,
+static int stat_get_doit_stats_list(struct sk_buff *skb, struct nlmsghdr *nlh,
 				    struct netlink_ext_ack *extack,
 				    struct nlattr *tb[],
 				    struct ib_device *device, u32 port,

diff --git a/drivers/infiniband/hw/efa/efa_verbs.c b/drivers/infiniband/hw/efa/efa_verbs.c
index 35d818b38e7780..e5919bd9a25106 100644
--- a/drivers/infiniband/hw/efa/efa_verbs.c
+++ b/drivers/infiniband/hw/efa/efa_verbs.c
@@ -60,8 +60,7 @@ struct efa_user_mmap_entry {
 	op(EFA_RDMA_READ_RESP_BYTES, "rdma_read_resp_bytes") \
 
 #define EFA_STATS_ENUM(ename, name) ename,
-#define EFA_STATS_STR(ename, nam) \
-	[ename].name = nam,
+#define EFA_STATS_STR(ename, nam) [ename].name = nam,
 
 enum efa_hw_device_stats {
 	EFA_DEFINE_DEVICE_STATS(EFA_STATS_ENUM)
diff --git a/drivers/infiniband/hw/hfi1/verbs.c b/drivers/infiniband/hw/hfi1/verbs.c
index 09354f1257a947..ed9fa0d84e9ed3 100644
--- a/drivers/infiniband/hw/hfi1/verbs.c
+++ b/drivers/infiniband/hw/hfi1/verbs.c
@@ -1614,10 +1614,8 @@ static int cntr_names_initialized;
  * strings. Optionally some entries can be reserved in the array to hold extra
  * external strings.
  */
-static int init_cntr_names(const char *names_in,
-			   const size_t names_len,
-			   int num_extra_names,
-			   int *num_cntrs,
+static int init_cntr_names(const char *names_in, const size_t names_len,
+			   int num_extra_names, int *num_cntrs,
 			   struct rdma_stat_desc **cntr_descs)
 {
 	struct rdma_stat_desc *q;
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index fd4dfb43006b54..38742e233915f9 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2152,9 +2152,7 @@ static int mlx4_ib_get_hw_stats(struct ib_device *ibdev,
 
 static int __mlx4_ib_alloc_diag_counters(struct mlx4_ib_dev *ibdev,
 					 struct rdma_stat_desc **pdescs,
-					 u32 **offset,
-					 u32 *num,
-					 bool port)
+					 u32 **offset, u32 *num, bool port)
 {
 	u32 num_counters;
 
@@ -2186,8 +2184,7 @@ static int __mlx4_ib_alloc_diag_counters(struct mlx4_ib_dev *ibdev,
 
 static void mlx4_ib_fill_diag_counters(struct mlx4_ib_dev *ibdev,
 				       struct rdma_stat_desc *descs,
-				       u32 *offset,
-				       bool port)
+				       u32 *offset, bool port)
 {
 	int i;
 	int j;
diff --git a/drivers/infiniband/hw/mlx5/counters.c b/drivers/infiniband/hw/mlx5/counters.c
index 206c190d0ce4f9..f72dffd2f42c03 100644
--- a/drivers/infiniband/hw/mlx5/counters.c
+++ b/drivers/infiniband/hw/mlx5/counters.c
@@ -478,10 +478,8 @@ static int mlx5_ib_counter_unbind_qp(struct ib_qp *qp)
 	return mlx5_ib_qp_set_counter(qp, NULL);
 }
 
-
 static void mlx5_ib_fill_counters(struct mlx5_ib_dev *dev,
-				  struct rdma_stat_desc *descs,
-				  size_t *offsets)
+				  struct rdma_stat_desc *descs, size_t *offsets)
 {
 	int i;
 	int j = 0;
@@ -34,7 +34,7 @@ int rxe_ib_get_hw_stats(struct ib_device *ibdev,
 	if (!port || !stats)
 		return -EINVAL;
 
-	for (cnt = 0; cnt  < ARRAY_SIZE(rxe_counter_descs); cnt++)
+	for (cnt = 0; cnt < ARRAY_SIZE(rxe_counter_descs); cnt++)
 		stats->value[cnt] = atomic64_read(&dev->stats_counters[cnt]);
 
 	return ARRAY_SIZE(rxe_counter_descs);
