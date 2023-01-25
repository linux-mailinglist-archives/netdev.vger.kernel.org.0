Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86CBF67BF2D
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 22:51:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235791AbjAYVvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 16:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236034AbjAYVvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 16:51:04 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2070.outbound.protection.outlook.com [40.107.237.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FCF66FAE
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 13:49:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXlHcTZoN85J/Ap30s88TfsdA8TZM51BMWv9y1MsMX0Ub8zBVr7LCaUfpY3v5QDnl+3xexuvQ3WoxU8leqj3hSvJsIfd9SdcmqyKagUvubLNzjt7RYkaQ1bDq9BKyxG9Ez3edbA24AK8S55bcEv6Er7pzzJUnfvYC7hbFgq3y02ckiTdHvQKChA6x2Xyjmhgggd2va+6Fgk0KjGas9yxMdoLhJoD4YlY1E9gDYG3MtmG9kucoCc04zLTKRPzwMqfDDrY9dQAgZ4d28gAe/+8UXl2a1aNh62/5mfG7tpPKiN+FbznAhHOydBnBco6tJFzpUB2M8CAG7a4Zj/WhmDTSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l6CP6CjvgPEvziq+Zlc3zD4cbgPnhp/thMhKB2XD1Co=;
 b=hJR8J1C5lmqUSJFm7nsGrrKx2pVCddJ+Lj1znam0aluQNkMaRb+0FSrnxBgpDzEH542X+Kiej2GUHVLULQRVL6iUCaxdRSKtUhFbA4meehGb8fo7JfEfBFEUvUSHvy8WpNMvkGkH73L+G8zbtX3G17viMw/sPaR+7tJyPnpsTk7w+E6nCroWpxtznpjuWkdjY9RS2Ut7z8kCZyA5XHCOmNp8l9sQ+PPgv05t7TeW3+PmNaRHagN72ln+gejvcadWgnE6FDUDB/cJL1h7fDcybue4WV3qas+clcj9dlXHgWejWnkNMjYafRprBJ4RYOXhK7KQThmWYAaSXMTMvMv1Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=corigine.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l6CP6CjvgPEvziq+Zlc3zD4cbgPnhp/thMhKB2XD1Co=;
 b=KJJIpNiGov+30dFw3PKX4P1bPa3GQ6patb6kzvNO1YF8w0XMHFFX/dQ4j5IGvi0f9w4quZIdl1VCo280hggPix4WDF0nUPZgeJZH02zuJTV95BhWk8twTUeGVDY8uTTMwT/yoc6XZZNNc4h5W74AOk5QlkTVMwTkgFgm/aKG8IvL5kovfg5ZqK/c3Dh2oA5n5N5ZLxIbiPhK02301sDVvI//3qhi7jgvNN9Sp31HTLZIJY6yF/KuDFpmSptpx7hni42h7z4OjTgfxywFZZJz8z3tgjofhC+VG3GN1OTOv1kYgVhpLy3PCGdUNENlZ/H/SHlcCTaJJKMzYlKx4lIgTA==
Received: from BN8PR07CA0026.namprd07.prod.outlook.com (2603:10b6:408:ac::39)
 by DM4PR12MB7696.namprd12.prod.outlook.com (2603:10b6:8:100::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Wed, 25 Jan
 2023 21:49:31 +0000
Received: from BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::b6) by BN8PR07CA0026.outlook.office365.com
 (2603:10b6:408:ac::39) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.20 via Frontend
 Transport; Wed, 25 Jan 2023 21:49:30 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT063.mail.protection.outlook.com (10.13.177.110) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6043.17 via Frontend Transport; Wed, 25 Jan 2023 21:49:30 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 13:49:21 -0800
Received: from fedora.nvidia.com (10.126.231.37) by rnnvmail201.nvidia.com
 (10.129.68.8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.36; Wed, 25 Jan
 2023 13:49:15 -0800
References: <20230124170510.316970-1-jhs@mojatatu.com>
 <20230124170510.316970-18-jhs@mojatatu.com>
User-agent: mu4e 1.6.6; emacs 28.1
From:   Vlad Buslov <vladbu@nvidia.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
CC:     <netdev@vger.kernel.org>, <kernel@mojatatu.com>,
        <deb.chatterjee@intel.com>, <anjali.singhai@intel.com>,
        <namrata.limaye@intel.com>, <khalidm@nvidia.com>, <tom@sipanda.io>,
        <pratyush@sipanda.io>, <jiri@resnulli.us>,
        <xiyou.wangcong@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <simon.horman@corigine.com>
Subject: Re: [PATCH net-next RFC 18/20] p4tc: add register create, update,
 delete, get, flush and dump
Date:   Wed, 25 Jan 2023 23:44:46 +0200
In-Reply-To: <20230124170510.316970-18-jhs@mojatatu.com>
Message-ID: <87y1pqb7zb.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.126.231.37]
X-ClientProxiedBy: rnnvmail201.nvidia.com (10.129.68.8) To
 rnnvmail201.nvidia.com (10.129.68.8)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT063:EE_|DM4PR12MB7696:EE_
X-MS-Office365-Filtering-Correlation-Id: 92aaf911-c0b7-4383-4e2e-08daff1e09f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a92WuI7LF1hU2Iu8CpPVUeYecRWlAKkW2LW6ieGcNVFt43jAG/3nvuZuRnZoDJcvXi7SdqfxriOGA4b0w5ZVSKGlEKIwd2qon70uTAWH0B6GymuapGstpdZXRE6e9PSXutKld2TVzJsdtkYnC6LjkpWeR1XsBZZJOmScA/tei4PaP8hXbMHoC1UshX9214Ol7z5s7XkEyzrC+Rj/7YDUJ2WpPT9BrId4WUsva9UxD33Kd+P5nGtFibRmECL5iw3yP8k1Ftn6KX4SBu/GM+xy69aXWJ+RmJ7hCYqxft4koH6tpUeH7NXovq6alPMUMUE7W1EzY8KJXX3Lzg4EN6uP3bZRjjUcWij+Tdmeel5TtWgQSq5A72aeXXzkDHyrcRDKBIqGhHK+B6thjUopIy+3ZFbyq4o1UtC4cj494uecV3M0Fuxr7xvcZDxf++jGGXmyf+Mfl3cIlGgzAKcwXYUp2k9+w9FMUigXQTS/Wb72IZjpUZbevO4wBmNjI5RGJwQvyfGSKdmMWXPHc+7zoDLjpyXKNG1hNN4RvDqkzwFfaUtEAwN5sjw34YJ0mp7lo69b+1goBLRKpUgxsPB+ZuPsZQvc0MF1gewpn6jKMOrG5kGPdIoXy9aM2VjbhavyT6+BJZJ+wonUEJ/qYyoy7QL1DuqTi9+tOL6obTqQQjnGWhboKheyoKZGcuSsq7LhnxKcXpfO89sdXNT6lyCUDqcvT9sRjIcC6b8Uts4b9w3H3wU=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(136003)(396003)(451199018)(36840700001)(40470700004)(46966006)(36860700001)(36756003)(15650500001)(356005)(40460700003)(8676002)(40480700001)(86362001)(82310400005)(336012)(186003)(70586007)(478600001)(54906003)(16526019)(6666004)(26005)(7696005)(82740400003)(70206006)(4326008)(41300700001)(8936002)(83380400001)(47076005)(316002)(7416002)(426003)(2906002)(2616005)(30864003)(5660300002)(6916009)(7636003)(32563001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jan 2023 21:49:30.5488
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 92aaf911-c0b7-4383-4e2e-08daff1e09f5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT063.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7696
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Tue 24 Jan 2023 at 12:05, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> This commit allows users to create, update, delete, get, flush and dump
> P4 registers.
>
> It's important to note that write operations, such as create, update
> and delete, can only be made if the pipeline is not sealed.
>
> Registers in P4 provide a way to store data in your program that can be
> accessed throughout the lifetime of your P4 program. Which means this a
> way of storing state between the P4 program's invocations.
>
> Let's take a look at an example register declaration in a P4 program:
>
> Register<bit<32>>(2) register1;
>
> This declaration corresponds to a register named register1, with 2
> elements which are of type bit32. You can think of this register as an
> array of bit32s with 2 elements.
>
> If one were to create this register with P4TC, one would issue the
> following command:
>
> tc p4template create register/ptables/register1 type bit32 numelems 2
>
> This will create register "register1" and give it an ID that will be
> assigned by the kernel. If the user wished to specify also the register
> id, the command would be the following
>
> tc p4template create register/ptables/register1 regid 1 type bit32 \
> numelems 2
>
> Now, after creating register1, if one wished to, for example, update
> index 1 of register1 with value 32, one would issue the following
> command:
>
> tc p4template update register/ptables/register1 index 1 \
> value constant.bit32.32
>
> One could also change the value of a specific index using hex notation,
> examplified by the following command:
>
> tc p4template update register/ptables/ regid 1 index 1 \
> value constant.bit32.0x20
>
> Note that we used regid in here instead of the register name (register1).
> We can always use name or id.
>
> It's important to note that all elements of a register will be
> initialised with zero when the register is created
>
> Now, after updating the new register the user could issue a get command
> to check if the register's parameters (type, num elems, id, ...) and the
> register element values are correct. To do so, the user would issue the
> following command:
>
> tc p4template get register/ptables/register1
>
> Which will output the following:
>
> template obj type register
> pipeline name ptables id 22
>     register name register1
>     register id 1
>     container type bit32
>     startbit 0
>     endbit 31
>     number of elements 2
>         register1[0] 0
>         register1[1] 32
>
> Notice that register[0] was unaltered, so it is a 0 because zero is the
> default initial values. register[1] has value 32, because it was
> updated in the previous command.
>
> The user could also list all of the created registers associated to a
> pipeline. For example, to list all of the registers associated with
> pipeline ptables, the user would issue the following command:
>
> tc p4template get register/ptables/
>
> Which will output the following:
>
> template obj type register
> pipeline name ptables id 22
>     register name register1
>
> Another option is to check the value of a specific index inside
> register1, that can be done using the following command:
>
> tc p4template get register/ptables/register1 index 1
>
> Which will output the following:
>
> template obj type register
> pipeline name ptables id 22
>     register name register1
>     register id 1
>     container type bit32
>         register1[1] 32
>
> To delete register1, the user would issue the following command:
>
> tc p4template del register/ptables/register1
>
> Now, to delete all the registers associated with pipeline ptables, the
> user would issue the following command:
>
> tc p4template del register/ptables/
>
> Co-developed-by: Victor Nogueira <victor@mojatatu.com>
> Signed-off-by: Victor Nogueira <victor@mojatatu.com>
> Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  include/net/p4tc.h             |  32 ++
>  include/uapi/linux/p4tc.h      |  28 ++
>  net/sched/p4tc/Makefile        |   2 +-
>  net/sched/p4tc/p4tc_pipeline.c |   9 +-
>  net/sched/p4tc/p4tc_register.c | 749 +++++++++++++++++++++++++++++++++
>  net/sched/p4tc/p4tc_tmpl_api.c |   2 +
>  6 files changed, 820 insertions(+), 2 deletions(-)
>  create mode 100644 net/sched/p4tc/p4tc_register.c
>
> diff --git a/include/net/p4tc.h b/include/net/p4tc.h
> index 9a7942992..d9267b798 100644
> --- a/include/net/p4tc.h
> +++ b/include/net/p4tc.h
> @@ -31,6 +31,7 @@
>  #define P4TC_AID_IDX 1
>  #define P4TC_PARSEID_IDX 1
>  #define P4TC_HDRFIELDID_IDX 2
> +#define P4TC_REGID_IDX 1
>  
>  #define P4TC_HDRFIELD_IS_VALIDITY_BIT 0x1
>  
> @@ -109,6 +110,7 @@ struct p4tc_pipeline {
>  	struct idr                  p_meta_idr;
>  	struct idr                  p_act_idr;
>  	struct idr                  p_tbl_idr;
> +	struct idr                  p_reg_idr;
>  	struct rcu_head             rcu;
>  	struct net                  *net;
>  	struct p4tc_parser          *parser;
> @@ -395,6 +397,21 @@ struct p4tc_hdrfield {
>  
>  extern const struct p4tc_template_ops p4tc_hdrfield_ops;
>  
> +struct p4tc_register {
> +	struct p4tc_template_common common;
> +	spinlock_t                  reg_value_lock;
> +	struct p4tc_type            *reg_type;
> +	struct p4tc_type_mask_shift *reg_mask_shift;
> +	void                        *reg_value;
> +	u32                         reg_num_elems;
> +	u32                         reg_id;
> +	refcount_t                  reg_ref;
> +	u16                         reg_startbit; /* Relative to its container */
> +	u16                         reg_endbit; /* Relative to its container */
> +};
> +
> +extern const struct p4tc_template_ops p4tc_register_ops;
> +
>  struct p4tc_metadata *tcf_meta_find_byid(struct p4tc_pipeline *pipeline,
>  					 u32 m_id);
>  void tcf_meta_fill_user_offsets(struct p4tc_pipeline *pipeline);
> @@ -556,10 +573,25 @@ extern const struct p4tc_act_param_ops param_ops[P4T_MAX + 1];
>  int generic_dump_param_value(struct sk_buff *skb, struct p4tc_type *type,
>  			     struct p4tc_act_param *param);
>  
> +struct p4tc_register *tcf_register_find_byid(struct p4tc_pipeline *pipeline,
> +					     const u32 reg_id);
> +struct p4tc_register *tcf_register_get(struct p4tc_pipeline *pipeline,
> +				       const char *regname, const u32 reg_id,
> +				       struct netlink_ext_ack *extack);
> +void tcf_register_put_ref(struct p4tc_register *reg);
> +
> +struct p4tc_register *tcf_register_find_byany(struct p4tc_pipeline *pipeline,
> +					      const char *regname,
> +					      const u32 reg_id,
> +					      struct netlink_ext_ack *extack);
> +
> +void tcf_register_put_rcu(struct rcu_head *head);
> +
>  #define to_pipeline(t) ((struct p4tc_pipeline *)t)
>  #define to_meta(t) ((struct p4tc_metadata *)t)
>  #define to_hdrfield(t) ((struct p4tc_hdrfield *)t)
>  #define to_act(t) ((struct p4tc_act *)t)
>  #define to_table(t) ((struct p4tc_table *)t)
> +#define to_register(t) ((struct p4tc_register *)t)
>  
>  #endif
> diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
> index 727fdcfe5..0c5f2943e 100644
> --- a/include/uapi/linux/p4tc.h
> +++ b/include/uapi/linux/p4tc.h
> @@ -22,6 +22,7 @@ struct p4tcmsg {
>  #define P4TC_MAX_KEYSZ 512
>  #define HEADER_MAX_LEN 512
>  #define META_MAX_LEN 512
> +#define P4TC_MAX_REGISTER_ELEMS 128
>  
>  #define P4TC_MAX_KEYSZ 512
>  
> @@ -32,6 +33,7 @@ struct p4tcmsg {
>  #define HDRFIELDNAMSIZ TEMPLATENAMSZ
>  #define ACTPARAMNAMSIZ TEMPLATENAMSZ
>  #define TABLENAMSIZ TEMPLATENAMSZ
> +#define REGISTERNAMSIZ TEMPLATENAMSZ
>  
>  #define P4TC_TABLE_FLAGS_KEYSZ 0x01
>  #define P4TC_TABLE_FLAGS_MAX_ENTRIES 0x02
> @@ -120,6 +122,7 @@ enum {
>  	P4TC_OBJ_ACT,
>  	P4TC_OBJ_TABLE,
>  	P4TC_OBJ_TABLE_ENTRY,
> +	P4TC_OBJ_REGISTER,
>  	__P4TC_OBJ_MAX,
>  };
>  #define P4TC_OBJ_MAX __P4TC_OBJ_MAX
> @@ -353,6 +356,31 @@ enum {
>  	P4TC_ENTITY_MAX
>  };
>  
> +#define P4TC_REGISTER_FLAGS_DATATYPE 0x1
> +#define P4TC_REGISTER_FLAGS_STARTBIT 0x2
> +#define P4TC_REGISTER_FLAGS_ENDBIT 0x4
> +#define P4TC_REGISTER_FLAGS_NUMELEMS 0x8
> +#define P4TC_REGISTER_FLAGS_INDEX 0x10
> +
> +struct p4tc_u_register {
> +	__u32 num_elems;
> +	__u32 datatype;
> +	__u32 index;
> +	__u16 startbit;
> +	__u16 endbit;
> +	__u16 flags;
> +};
> +
> +/* P4 Register attributes */
> +enum {
> +	P4TC_REGISTER_UNSPEC,
> +	P4TC_REGISTER_NAME, /* string */
> +	P4TC_REGISTER_INFO, /* struct p4tc_u_register */
> +	P4TC_REGISTER_VALUE, /* value blob */
> +	__P4TC_REGISTER_MAX
> +};
> +#define P4TC_REGISTER_MAX (__P4TC_REGISTER_MAX - 1)
> +
>  #define P4TC_RTA(r) \
>  	((struct rtattr *)(((char *)(r)) + NLMSG_ALIGN(sizeof(struct p4tcmsg))))
>  
> diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
> index 0d2c20223..b35ced1e3 100644
> --- a/net/sched/p4tc/Makefile
> +++ b/net/sched/p4tc/Makefile
> @@ -2,4 +2,4 @@
>  
>  obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o p4tc_meta.o \
>  	p4tc_parser_api.o p4tc_hdrfield.o p4tc_action.o p4tc_table.o \
> -	p4tc_tbl_api.o
> +	p4tc_tbl_api.o p4tc_register.o
> diff --git a/net/sched/p4tc/p4tc_pipeline.c b/net/sched/p4tc/p4tc_pipeline.c
> index f8fcde20b..9f8433545 100644
> --- a/net/sched/p4tc/p4tc_pipeline.c
> +++ b/net/sched/p4tc/p4tc_pipeline.c
> @@ -298,6 +298,7 @@ static void tcf_pipeline_destroy(struct p4tc_pipeline *pipeline,
>  	idr_destroy(&pipeline->p_meta_idr);
>  	idr_destroy(&pipeline->p_act_idr);
>  	idr_destroy(&pipeline->p_tbl_idr);
> +	idr_destroy(&pipeline->p_reg_idr);
>  
>  	if (free_pipeline)
>  		kfree(pipeline);
> @@ -324,8 +325,9 @@ static int tcf_pipeline_put(struct net *net,
>  	struct p4tc_pipeline *pipeline = to_pipeline(template);
>  	struct net *pipeline_net = maybe_get_net(net);
>  	struct p4tc_act_dep_node *act_node, *node_tmp;
> -	unsigned long tbl_id, m_id, tmp;
> +	unsigned long reg_id, tbl_id, m_id, tmp;
>  	struct p4tc_metadata *meta;
> +	struct p4tc_register *reg;
>  	struct p4tc_table *table;
>  
>  	if (!refcount_dec_if_one(&pipeline->p_ctrl_ref)) {
> @@ -371,6 +373,9 @@ static int tcf_pipeline_put(struct net *net,
>  	if (pipeline->parser)
>  		tcf_parser_del(net, pipeline, pipeline->parser, extack);
>  
> +	idr_for_each_entry_ul(&pipeline->p_reg_idr, reg, tmp, reg_id)
> +		reg->common.ops->put(net, &reg->common, true, extack);
> +
>  	idr_remove(&pipe_net->pipeline_idr, pipeline->common.p_id);
>  
>  	if (pipeline_net)
> @@ -567,6 +572,8 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
>  	idr_init(&pipeline->p_meta_idr);
>  	pipeline->p_meta_offset = 0;
>  
> +	idr_init(&pipeline->p_reg_idr);
> +
>  	INIT_LIST_HEAD(&pipeline->act_dep_graph);
>  	INIT_LIST_HEAD(&pipeline->act_topological_order);
>  	pipeline->num_created_acts = 0;
> diff --git a/net/sched/p4tc/p4tc_register.c b/net/sched/p4tc/p4tc_register.c
> new file mode 100644
> index 000000000..deac38fd2
> --- /dev/null
> +++ b/net/sched/p4tc/p4tc_register.c
> @@ -0,0 +1,749 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * net/sched/p4tc_register.c	P4 TC REGISTER
> + *
> + * Copyright (c) 2022, Mojatatu Networks
> + * Copyright (c) 2022, Intel Corporation.
> + * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
> + *              Victor Nogueira <victor@mojatatu.com>
> + *              Pedro Tammela <pctammela@mojatatu.com>
> + */
> +
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/string.h>
> +#include <linux/errno.h>
> +#include <linux/slab.h>
> +#include <linux/skbuff.h>
> +#include <linux/init.h>
> +#include <linux/kmod.h>
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <net/net_namespace.h>
> +#include <net/sock.h>
> +#include <net/sch_generic.h>
> +#include <net/pkt_cls.h>
> +#include <net/p4tc.h>
> +#include <net/netlink.h>
> +#include <net/flow_offload.h>
> +
> +static const struct nla_policy p4tc_register_policy[P4TC_REGISTER_MAX + 1] = {
> +	[P4TC_REGISTER_NAME] = { .type = NLA_STRING, .len  = REGISTERNAMSIZ },
> +	[P4TC_REGISTER_INFO] = {
> +		.type = NLA_BINARY,
> +		.len = sizeof(struct p4tc_u_register),
> +	},
> +	[P4TC_REGISTER_VALUE] = { .type = NLA_BINARY },
> +};
> +
> +struct p4tc_register *tcf_register_find_byid(struct p4tc_pipeline *pipeline,
> +					     const u32 reg_id)
> +{
> +	return idr_find(&pipeline->p_reg_idr, reg_id);
> +}
> +
> +static struct p4tc_register *
> +tcf_register_find_byname(const char *regname, struct p4tc_pipeline *pipeline)
> +{
> +	struct p4tc_register *reg;
> +	unsigned long tmp, id;
> +
> +	idr_for_each_entry_ul(&pipeline->p_reg_idr, reg, tmp, id)
> +		if (strncmp(reg->common.name, regname, REGISTERNAMSIZ) == 0)
> +			return reg;
> +
> +	return NULL;
> +}
> +
> +struct p4tc_register *tcf_register_find_byany(struct p4tc_pipeline *pipeline,
> +					      const char *regname,
> +					      const u32 reg_id,
> +					      struct netlink_ext_ack *extack)
> +{
> +	struct p4tc_register *reg;
> +	int err;
> +
> +	if (reg_id) {
> +		reg = tcf_register_find_byid(pipeline, reg_id);
> +		if (!reg) {
> +			NL_SET_ERR_MSG(extack, "Unable to find register by id");
> +			err = -EINVAL;
> +			goto out;
> +		}
> +	} else {
> +		if (regname) {
> +			reg = tcf_register_find_byname(regname, pipeline);
> +			if (!reg) {
> +				NL_SET_ERR_MSG(extack,
> +					       "Register name not found");
> +				err = -EINVAL;
> +				goto out;
> +			}
> +		} else {
> +			NL_SET_ERR_MSG(extack,
> +				       "Must specify register name or id");
> +			err = -EINVAL;
> +			goto out;
> +		}
> +	}
> +
> +	return reg;
> +out:
> +	return ERR_PTR(err);
> +}
> +
> +struct p4tc_register *tcf_register_get(struct p4tc_pipeline *pipeline,
> +				       const char *regname, const u32 reg_id,
> +				       struct netlink_ext_ack *extack)
> +{
> +	struct p4tc_register *reg;
> +
> +	reg = tcf_register_find_byany(pipeline, regname, reg_id, extack);
> +	if (IS_ERR(reg))
> +		return reg;
> +
> +	WARN_ON(!refcount_inc_not_zero(&reg->reg_ref));
> +
> +	return reg;
> +}
> +
> +void tcf_register_put_ref(struct p4tc_register *reg)
> +{
> +	WARN_ON(!refcount_dec_not_one(&reg->reg_ref));

I must admit that this series overuses
refcount_{inc|dec}_not_{zero|one}() functions and underuses regular
refcount_inc()/refcount_dec_and_test() a bit too much. I'm not saying
there is anything wrong per se with reference counting here or in other
patches of this series, but I can't comprehend it TBH.

> +}
> +
> +static struct p4tc_register *
> +tcf_register_find_byanyattr(struct p4tc_pipeline *pipeline,
> +			    struct nlattr *name_attr, const u32 reg_id,
> +			    struct netlink_ext_ack *extack)
> +{
> +	char *regname = NULL;
> +
> +	if (name_attr)
> +		regname = nla_data(name_attr);
> +
> +	return tcf_register_find_byany(pipeline, regname, reg_id, extack);
> +}
> +
> +static int _tcf_register_fill_nlmsg(struct sk_buff *skb,
> +				    struct p4tc_register *reg,
> +				    struct p4tc_u_register *parm_arg)
> +{
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	struct p4tc_u_register parm = { 0 };
> +	size_t value_bytesz;
> +	struct nlattr *nest;
> +	void *value;
> +
> +	if (nla_put_u32(skb, P4TC_PATH, reg->reg_id))
> +		goto out_nlmsg_trim;
> +
> +	nest = nla_nest_start(skb, P4TC_PARAMS);
> +	if (!nest)
> +		goto out_nlmsg_trim;
> +
> +	if (nla_put_string(skb, P4TC_REGISTER_NAME, reg->common.name))
> +		goto out_nlmsg_trim;
> +
> +	parm.datatype = reg->reg_type->typeid;
> +	parm.flags |= P4TC_REGISTER_FLAGS_DATATYPE;
> +	if (parm_arg) {
> +		parm.index = parm_arg->index;
> +		parm.flags |= P4TC_REGISTER_FLAGS_INDEX;
> +	} else {
> +		parm.startbit = reg->reg_startbit;
> +		parm.flags |= P4TC_REGISTER_FLAGS_STARTBIT;
> +		parm.endbit = reg->reg_endbit;
> +		parm.flags |= P4TC_REGISTER_FLAGS_ENDBIT;
> +		parm.num_elems = reg->reg_num_elems;
> +		parm.flags |= P4TC_REGISTER_FLAGS_NUMELEMS;
> +	}
> +
> +	if (nla_put(skb, P4TC_REGISTER_INFO, sizeof(parm), &parm))
> +		goto out_nlmsg_trim;
> +
> +	value_bytesz = BITS_TO_BYTES(reg->reg_type->container_bitsz);
> +	spin_lock_bh(&reg->reg_value_lock);
> +	if (parm.flags & P4TC_REGISTER_FLAGS_INDEX) {
> +		value = reg->reg_value + parm.index * value_bytesz;
> +	} else {
> +		value = reg->reg_value;
> +		value_bytesz *= reg->reg_num_elems;
> +	}
> +
> +	if (nla_put(skb, P4TC_REGISTER_VALUE, value_bytesz, value)) {
> +		spin_unlock_bh(&reg->reg_value_lock);
> +		goto out_nlmsg_trim;
> +	}
> +	spin_unlock_bh(&reg->reg_value_lock);
> +
> +	nla_nest_end(skb, nest);
> +
> +	return skb->len;
> +
> +out_nlmsg_trim:
> +	nlmsg_trim(skb, b);
> +	return -1;
> +}
> +
> +static int tcf_register_fill_nlmsg(struct net *net, struct sk_buff *skb,
> +				   struct p4tc_template_common *template,
> +				   struct netlink_ext_ack *extack)
> +{
> +	struct p4tc_register *reg = to_register(template);
> +
> +	if (_tcf_register_fill_nlmsg(skb, reg, NULL) <= 0) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Failed to fill notification attributes for register");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int _tcf_register_put(struct p4tc_pipeline *pipeline,
> +			     struct p4tc_register *reg,
> +			     bool unconditional_purge,
> +			     struct netlink_ext_ack *extack)
> +{
> +	void *value;
> +
> +	if (!refcount_dec_if_one(&reg->reg_ref) && !unconditional_purge)
> +		return -EBUSY;
> +
> +	idr_remove(&pipeline->p_reg_idr, reg->reg_id);
> +
> +	spin_lock_bh(&reg->reg_value_lock);
> +	value = reg->reg_value;
> +	reg->reg_value = NULL;
> +	spin_unlock_bh(&reg->reg_value_lock);
> +	kfree(value);
> +
> +	if (reg->reg_mask_shift) {
> +		kfree(reg->reg_mask_shift->mask);
> +		kfree(reg->reg_mask_shift);
> +	}
> +	kfree(reg);
> +
> +	return 0;
> +}
> +
> +static int tcf_register_put(struct net *net, struct p4tc_template_common *tmpl,
> +			    bool unconditional_purge,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct p4tc_pipeline *pipeline =
> +		tcf_pipeline_find_byid(net, tmpl->p_id);
> +	struct p4tc_register *reg = to_register(tmpl);
> +	int ret;
> +
> +	ret = _tcf_register_put(pipeline, reg, unconditional_purge, extack);
> +	if (ret < 0)
> +		NL_SET_ERR_MSG(extack, "Unable to delete referenced register");
> +
> +	return ret;
> +}
> +
> +static struct p4tc_register *tcf_register_create(struct net *net,
> +						 struct nlmsghdr *n,
> +						 struct nlattr *nla, u32 reg_id,
> +						 struct p4tc_pipeline *pipeline,
> +						 struct netlink_ext_ack *extack)
> +{
> +	struct nlattr *tb[P4TC_REGISTER_MAX + 1];
> +	struct p4tc_u_register *parm;
> +	struct p4tc_type *datatype;
> +	struct p4tc_register *reg;
> +	int ret;
> +
> +	ret = nla_parse_nested(tb, P4TC_REGISTER_MAX, nla, p4tc_register_policy,
> +			       extack);
> +
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	reg = kzalloc(sizeof(*reg), GFP_KERNEL);
> +	if (!reg)
> +		return ERR_PTR(-ENOMEM);
> +
> +	if (!tb[P4TC_REGISTER_NAME]) {
> +		NL_SET_ERR_MSG(extack, "Must specify register name");
> +		ret = -EINVAL;
> +		goto free_reg;
> +	}
> +
> +	if (tcf_register_find_byname(nla_data(tb[P4TC_REGISTER_NAME]), pipeline) ||
> +	    tcf_register_find_byid(pipeline, reg_id)) {
> +		NL_SET_ERR_MSG(extack, "Register already exists");
> +		ret = -EEXIST;
> +		goto free_reg;
> +	}
> +
> +	reg->common.p_id = pipeline->common.p_id;
> +	strscpy(reg->common.name, nla_data(tb[P4TC_REGISTER_NAME]),
> +		REGISTERNAMSIZ);
> +
> +	if (tb[P4TC_REGISTER_INFO]) {
> +		parm = nla_data(tb[P4TC_REGISTER_INFO]);
> +	} else {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "Missing register info");
> +		goto free_reg;
> +	}
> +
> +	if (tb[P4TC_REGISTER_VALUE]) {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "Value can't be passed in create");
> +		goto free_reg;
> +	}
> +
> +	if (parm->flags & P4TC_REGISTER_FLAGS_INDEX) {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "Index can't be passed in create");
> +		goto free_reg;
> +	}
> +
> +	if (parm->flags & P4TC_REGISTER_FLAGS_NUMELEMS) {
> +		if (!parm->num_elems) {
> +			ret = -EINVAL;
> +			NL_SET_ERR_MSG(extack, "Num elems can't be zero");
> +			goto free_reg;
> +		}
> +
> +		if (parm->num_elems > P4TC_MAX_REGISTER_ELEMS) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Number of elements exceededs P4 register maximum");
> +			ret = -EINVAL;
> +			goto free_reg;
> +		}
> +	} else {
> +		NL_SET_ERR_MSG(extack, "Must specify num elems");
> +		ret = -EINVAL;
> +		goto free_reg;
> +	}
> +
> +	if (!(parm->flags & P4TC_REGISTER_FLAGS_STARTBIT) ||
> +	    !(parm->flags & P4TC_REGISTER_FLAGS_ENDBIT)) {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "Must specify start and endbit");
> +		goto free_reg;
> +	}
> +
> +	if (parm->startbit > parm->endbit) {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "startbit > endbit");
> +		goto free_reg;
> +	}
> +
> +	if (parm->flags & P4TC_REGISTER_FLAGS_DATATYPE) {
> +		datatype = p4type_find_byid(parm->datatype);
> +		if (!datatype) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Invalid data type for P4 register");
> +			ret = -EINVAL;
> +			goto free_reg;
> +		}
> +		reg->reg_type = datatype;
> +	} else {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "Must specify datatype");
> +		goto free_reg;
> +	}
> +
> +	if (parm->endbit > datatype->bitsz) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Endbit doesn't fix in container datatype");
> +		ret = -EINVAL;
> +		goto free_reg;
> +	}
> +	reg->reg_startbit = parm->startbit;
> +	reg->reg_endbit = parm->endbit;
> +
> +	reg->reg_num_elems = parm->num_elems;
> +
> +	spin_lock_init(&reg->reg_value_lock);
> +
> +	reg->reg_value = kcalloc(reg->reg_num_elems,
> +				 BITS_TO_BYTES(datatype->container_bitsz),
> +				 GFP_KERNEL);
> +	if (!reg->reg_value) {
> +		ret = -ENOMEM;
> +		goto free_reg;
> +	}
> +
> +	if (reg_id) {
> +		reg->reg_id = reg_id;
> +		ret = idr_alloc_u32(&pipeline->p_reg_idr, reg, &reg->reg_id,
> +				    reg->reg_id, GFP_KERNEL);
> +		if (ret < 0) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Unable to allocate register id");
> +			goto free_reg_value;
> +		}
> +	} else {
> +		reg->reg_id = 1;
> +		ret = idr_alloc_u32(&pipeline->p_reg_idr, reg, &reg->reg_id,
> +				    UINT_MAX, GFP_KERNEL);
> +		if (ret < 0) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Unable to allocate register id");
> +			goto free_reg_value;
> +		}
> +	}
> +
> +	if (datatype->ops->create_bitops) {
> +		size_t bitsz = reg->reg_endbit - reg->reg_startbit + 1;
> +		struct p4tc_type_mask_shift *mask_shift;
> +
> +		mask_shift = datatype->ops->create_bitops(bitsz,
> +							  reg->reg_startbit,
> +							  reg->reg_endbit,
> +							  extack);
> +		if (IS_ERR(mask_shift)) {
> +			ret = PTR_ERR(mask_shift);
> +			goto idr_rm;
> +		}
> +		reg->reg_mask_shift = mask_shift;
> +	}
> +
> +	refcount_set(&reg->reg_ref, 1);
> +
> +	reg->common.ops = (struct p4tc_template_ops *)&p4tc_register_ops;
> +
> +	return reg;
> +
> +idr_rm:
> +	idr_remove(&pipeline->p_reg_idr, reg->reg_id);
> +
> +free_reg_value:
> +	kfree(reg->reg_value);
> +
> +free_reg:
> +	kfree(reg);
> +	return ERR_PTR(ret);
> +}
> +
> +static struct p4tc_register *tcf_register_update(struct net *net,
> +						 struct nlmsghdr *n,
> +						 struct nlattr *nla, u32 reg_id,
> +						 struct p4tc_pipeline *pipeline,
> +						 struct netlink_ext_ack *extack)
> +{
> +	void *user_value = NULL;
> +	struct nlattr *tb[P4TC_REGISTER_MAX + 1];
> +	struct p4tc_u_register *parm;
> +	struct p4tc_type *datatype;
> +	struct p4tc_register *reg;
> +	int ret;
> +
> +	ret = nla_parse_nested(tb, P4TC_REGISTER_MAX, nla, p4tc_register_policy,
> +			       extack);
> +
> +	if (ret < 0)
> +		return ERR_PTR(ret);
> +
> +	reg = tcf_register_find_byanyattr(pipeline, tb[P4TC_REGISTER_NAME],
> +					  reg_id, extack);
> +	if (IS_ERR(reg))
> +		return reg;
> +
> +	if (tb[P4TC_REGISTER_INFO]) {
> +		parm = nla_data(tb[P4TC_REGISTER_INFO]);
> +	} else {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "Missing register info");
> +		goto err;
> +	}
> +
> +	datatype = reg->reg_type;
> +
> +	if (parm->flags & P4TC_REGISTER_FLAGS_NUMELEMS) {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "Can't update register num elems");
> +		goto err;
> +	}
> +
> +	if (!(parm->flags & P4TC_REGISTER_FLAGS_STARTBIT) ||
> +	    !(parm->flags & P4TC_REGISTER_FLAGS_ENDBIT)) {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "Must specify start and endbit");
> +		goto err;
> +	}
> +
> +	if (parm->startbit != reg->reg_startbit ||
> +	    parm->endbit != reg->reg_endbit) {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack,
> +			       "Start and endbit don't match with register values");
> +		goto err;
> +	}
> +
> +	if (!(parm->flags & P4TC_REGISTER_FLAGS_INDEX)) {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "Must specify index");
> +		goto err;
> +	}
> +
> +	if (tb[P4TC_REGISTER_VALUE]) {
> +		if (nla_len(tb[P4TC_REGISTER_VALUE]) !=
> +		    BITS_TO_BYTES(datatype->container_bitsz)) {
> +			ret = -EINVAL;
> +			NL_SET_ERR_MSG(extack,
> +				       "Value size differs from register type's container size");
> +			goto err;
> +		}
> +		user_value = nla_data(tb[P4TC_REGISTER_VALUE]);
> +	} else {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "Missing register value");
> +		goto err;
> +	}
> +
> +	if (parm->index >= reg->reg_num_elems) {
> +		ret = -EINVAL;
> +		NL_SET_ERR_MSG(extack, "Register index out of bounds");
> +		goto err;
> +	}
> +
> +	if (user_value) {
> +		u64 read_user_value[2] = { 0 };
> +		size_t type_bytesz;
> +		void *value;
> +
> +		type_bytesz = BITS_TO_BYTES(datatype->container_bitsz);
> +
> +		datatype->ops->host_read(datatype, reg->reg_mask_shift,
> +					 user_value, read_user_value);
> +
> +		spin_lock_bh(&reg->reg_value_lock);
> +		value = reg->reg_value + parm->index * type_bytesz;
> +		datatype->ops->host_write(datatype, reg->reg_mask_shift,
> +					  read_user_value, value);
> +		spin_unlock_bh(&reg->reg_value_lock);
> +	}
> +
> +	return reg;
> +
> +err:
> +	return ERR_PTR(ret);
> +}
> +
> +static struct p4tc_template_common *
> +tcf_register_cu(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
> +		struct p4tc_nl_pname *nl_pname, u32 *ids,
> +		struct netlink_ext_ack *extack)
> +{
> +	u32 pipeid = ids[P4TC_PID_IDX], reg_id = ids[P4TC_REGID_IDX];
> +	struct p4tc_pipeline *pipeline;
> +	struct p4tc_register *reg;
> +
> +	pipeline = tcf_pipeline_find_byany_unsealed(net, nl_pname->data, pipeid,
> +						    extack);
> +	if (IS_ERR(pipeline))
> +		return (void *)pipeline;
> +
> +	if (n->nlmsg_flags & NLM_F_REPLACE)
> +		reg = tcf_register_update(net, n, nla, reg_id, pipeline,
> +					  extack);
> +	else
> +		reg = tcf_register_create(net, n, nla, reg_id, pipeline,
> +					  extack);
> +
> +	if (IS_ERR(reg))
> +		goto out;
> +
> +	if (!nl_pname->passed)
> +		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
> +
> +	if (!ids[P4TC_PID_IDX])
> +		ids[P4TC_PID_IDX] = reg->common.p_id;
> +
> +out:
> +	return (struct p4tc_template_common *)reg;
> +}
> +
> +static int tcf_register_flush(struct sk_buff *skb,
> +			      struct p4tc_pipeline *pipeline,
> +			      struct netlink_ext_ack *extack)
> +{
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	struct p4tc_register *reg;
> +	unsigned long tmp, reg_id;
> +	int ret = 0;
> +	int i = 0;
> +
> +	if (nla_put_u32(skb, P4TC_PATH, 0))
> +		goto out_nlmsg_trim;
> +
> +	if (idr_is_empty(&pipeline->p_reg_idr)) {
> +		NL_SET_ERR_MSG(extack, "There are no registers to flush");
> +		goto out_nlmsg_trim;
> +	}
> +
> +	idr_for_each_entry_ul(&pipeline->p_reg_idr, reg, tmp, reg_id) {
> +		if (_tcf_register_put(pipeline, reg, false, extack) < 0) {
> +			ret = -EBUSY;
> +			continue;
> +		}
> +		i++;
> +	}
> +
> +	nla_put_u32(skb, P4TC_COUNT, i);
> +
> +	if (ret < 0) {
> +		if (i == 0) {
> +			NL_SET_ERR_MSG(extack, "Unable to flush any register");
> +			goto out_nlmsg_trim;
> +		} else {
> +			NL_SET_ERR_MSG(extack, "Unable to flush all registers");
> +		}
> +	}
> +
> +	return i;
> +
> +out_nlmsg_trim:
> +	nlmsg_trim(skb, b);
> +	return ret;
> +}
> +
> +static int tcf_register_gd(struct net *net, struct sk_buff *skb,
> +			   struct nlmsghdr *n, struct nlattr *nla,
> +			   struct p4tc_nl_pname *nl_pname, u32 *ids,
> +			   struct netlink_ext_ack *extack)
> +{
> +	u32 pipeid = ids[P4TC_PID_IDX], reg_id = ids[P4TC_REGID_IDX];
> +	struct nlattr *tb[P4TC_REGISTER_MAX + 1] = {};
> +	unsigned char *b = nlmsg_get_pos(skb);
> +	struct p4tc_u_register *parm_arg = NULL;
> +	int ret = 0;
> +	struct p4tc_pipeline *pipeline;
> +	struct p4tc_register *reg;
> +	struct nlattr *attr_info;
> +
> +	if (n->nlmsg_type == RTM_DELP4TEMPLATE)
> +		pipeline = tcf_pipeline_find_byany_unsealed(net, nl_pname->data,
> +							    pipeid, extack);
> +	else
> +		pipeline = tcf_pipeline_find_byany(net, nl_pname->data, pipeid,
> +						   extack);
> +
> +	if (IS_ERR(pipeline))
> +		return PTR_ERR(pipeline);
> +
> +	if (nla) {
> +		ret = nla_parse_nested(tb, P4TC_REGISTER_MAX, nla,
> +				       p4tc_register_policy, extack);
> +
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	if (!nl_pname->passed)
> +		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
> +
> +	if (!ids[P4TC_PID_IDX])
> +		ids[P4TC_PID_IDX] = pipeline->common.p_id;
> +
> +	if (n->nlmsg_type == RTM_DELP4TEMPLATE && (n->nlmsg_flags & NLM_F_ROOT))
> +		return tcf_register_flush(skb, pipeline, extack);
> +
> +	reg = tcf_register_find_byanyattr(pipeline, tb[P4TC_REGISTER_NAME],
> +					  reg_id, extack);
> +	if (IS_ERR(reg))
> +		return PTR_ERR(reg);
> +
> +	attr_info = tb[P4TC_REGISTER_INFO];
> +	if (attr_info) {
> +		if (n->nlmsg_type == RTM_DELP4TEMPLATE) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Can't pass info attribute in delete");
> +			return -EINVAL;
> +		}
> +		parm_arg = nla_data(attr_info);
> +		if (!(parm_arg->flags & P4TC_REGISTER_FLAGS_INDEX) ||
> +		    (parm_arg->flags & ~P4TC_REGISTER_FLAGS_INDEX)) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Must specify param index and only param index");
> +			return -EINVAL;
> +		}
> +		if (parm_arg->index >= reg->reg_num_elems) {
> +			NL_SET_ERR_MSG(extack, "Register index out of bounds");
> +			return -EINVAL;
> +		}
> +	}
> +	if (_tcf_register_fill_nlmsg(skb, reg, parm_arg) < 0) {
> +		NL_SET_ERR_MSG(extack,
> +			       "Failed to fill notification attributes for register");
> +		return -EINVAL;
> +	}
> +
> +	if (n->nlmsg_type == RTM_DELP4TEMPLATE) {
> +		ret = _tcf_register_put(pipeline, reg, false, extack);
> +		if (ret < 0) {
> +			NL_SET_ERR_MSG(extack,
> +				       "Unable to delete referenced register");
> +			goto out_nlmsg_trim;
> +		}
> +	}
> +
> +	return 0;
> +
> +out_nlmsg_trim:
> +	nlmsg_trim(skb, b);
> +	return ret;
> +}
> +
> +static int tcf_register_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
> +			     struct nlattr *nla, char **p_name, u32 *ids,
> +			     struct netlink_ext_ack *extack)
> +{
> +	struct net *net = sock_net(skb->sk);
> +	struct p4tc_pipeline *pipeline;
> +
> +	if (!ctx->ids[P4TC_PID_IDX]) {
> +		pipeline = tcf_pipeline_find_byany(net, *p_name,
> +						   ids[P4TC_PID_IDX], extack);
> +		if (IS_ERR(pipeline))
> +			return PTR_ERR(pipeline);
> +		ctx->ids[P4TC_PID_IDX] = pipeline->common.p_id;
> +	} else {
> +		pipeline = tcf_pipeline_find_byid(net, ctx->ids[P4TC_PID_IDX]);
> +	}
> +
> +	if (!ids[P4TC_PID_IDX])
> +		ids[P4TC_PID_IDX] = pipeline->common.p_id;
> +
> +	if (!(*p_name))
> +		*p_name = pipeline->common.name;
> +
> +	return tcf_p4_tmpl_generic_dump(skb, ctx, &pipeline->p_reg_idr,
> +					P4TC_REGID_IDX, extack);
> +}
> +
> +static int tcf_register_dump_1(struct sk_buff *skb,
> +			       struct p4tc_template_common *common)
> +{
> +	struct nlattr *nest = nla_nest_start(skb, P4TC_PARAMS);
> +	struct p4tc_register *reg = to_register(common);
> +
> +	if (!nest)
> +		return -ENOMEM;
> +
> +	if (nla_put_string(skb, P4TC_REGISTER_NAME, reg->common.name)) {
> +		nla_nest_cancel(skb, nest);
> +		return -ENOMEM;
> +	}
> +
> +	nla_nest_end(skb, nest);
> +
> +	return 0;
> +}
> +
> +const struct p4tc_template_ops p4tc_register_ops = {
> +	.cu = tcf_register_cu,
> +	.fill_nlmsg = tcf_register_fill_nlmsg,
> +	.gd = tcf_register_gd,
> +	.put = tcf_register_put,
> +	.dump = tcf_register_dump,
> +	.dump_1 = tcf_register_dump_1,
> +};
> diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_api.c
> index 2963f6497..5712cfaf8 100644
> --- a/net/sched/p4tc/p4tc_tmpl_api.c
> +++ b/net/sched/p4tc/p4tc_tmpl_api.c
> @@ -46,6 +46,7 @@ static bool obj_is_valid(u32 obj)
>  	case P4TC_OBJ_HDR_FIELD:
>  	case P4TC_OBJ_ACT:
>  	case P4TC_OBJ_TABLE:
> +	case P4TC_OBJ_REGISTER:
>  		return true;
>  	default:
>  		return false;
> @@ -58,6 +59,7 @@ static const struct p4tc_template_ops *p4tc_ops[P4TC_OBJ_MAX] = {
>  	[P4TC_OBJ_HDR_FIELD] = &p4tc_hdrfield_ops,
>  	[P4TC_OBJ_ACT] = &p4tc_act_ops,
>  	[P4TC_OBJ_TABLE] = &p4tc_table_ops,
> +	[P4TC_OBJ_REGISTER] = &p4tc_register_ops,
>  };
>  
>  int tcf_p4_tmpl_generic_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,

