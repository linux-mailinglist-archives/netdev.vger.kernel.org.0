Return-Path: <netdev+bounces-3298-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D5470662E
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 13:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3F43C28105F
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 11:08:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C50117AAE;
	Wed, 17 May 2023 11:04:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BBF2099F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 11:04:47 +0000 (UTC)
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B113F3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:04:23 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id af79cd13be357-759413d99afso624771085a.1
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 04:04:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1684321452; x=1686913452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LMOJQm9CyF20HOcAOv/drwQGo/PZ7/rgyHcrSk7fmDA=;
        b=Img53V3I7SfQqkieUd8g+R0TqklaLaJYDUt6sRx3+1vd6csHjCqjyssCy9X6Aro+Qq
         eJCcrKu0YzxK/uNnOg0qIjHC4QHcTvCYanvImTDJPQRG1e/5jE2JKSAOLY0np9hDQh6N
         1qCNJ0gtEUb2owwEr3igNsRru0Vpcz/TiTNIGKtTgf9HFt33mYnDQFJV0lHN0M9v+9tb
         l2mlObzYV7dNWv9JU/4eRSPeQchRmC0yaIKIG/6b0MZDZsfWFMbnK0bJkIdqEmPahHMd
         o9ALJ9FFRMkvebFuhan7OXaCiFnfVwrbtw//Bmtsk3iU64ecyiwtIuGTo8Ys40YqTT+Z
         tB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684321452; x=1686913452;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LMOJQm9CyF20HOcAOv/drwQGo/PZ7/rgyHcrSk7fmDA=;
        b=kaAQ7Kb9cM+LB45jOpMCQvc7jTJvVMlAij5drQwEQrdJ7fQ5Zi+1b8KIfIVsXO6dku
         +7sKUhmm29ltwQDYqhoTy/Yjimc73ovtdMwmC0bj5MGzyQjoWEp09wTO10Igl+JMtWuO
         ZE3KzV+CuuDZTc25SNqbEjlzohbDJJ3xNdHteMZTH2RAFiLhBqrXfwzt/ZbM88H8yG7w
         oZWr9242Cnbk9/WzYIXcscadXJXXu0574IKAURYjrfBXU+zB1GYpRJFPlJ/Vz9VgYGwV
         ImEL28YyAXhCG1h+ehg//Hg5hvpZpWs5LfAdM0YY1eVJIY4XT38sLvmm3LYEP8GidEWZ
         1uHA==
X-Gm-Message-State: AC+VfDzCegHBpESyjY3kp5P0YKnDgQ+ZUOuQkgLjQCS7R2/ed2LuCjPp
	UNwZ7xeAoc+7D8EMcC9/FZHAFbJff7Mk78oNfsA=
X-Google-Smtp-Source: ACHHUZ7Kq6PrnfFy6ZrRj7m0g3I5ErtzfgEtM3Vl1cXwqTNBXq8B4Gw/ZTxO61XiM+HJwqMUDNyCsg==
X-Received: by 2002:ad4:5cc4:0:b0:5e9:48da:9938 with SMTP id iu4-20020ad45cc4000000b005e948da9938mr3325899qvb.11.1684321451445;
        Wed, 17 May 2023 04:04:11 -0700 (PDT)
Received: from majuu.waya (cpe688f2e2c8c63-cm688f2e2c8c60.cpe.net.cable.rogers.com. [174.112.105.47])
        by smtp.gmail.com with ESMTPSA id w18-20020a0cb552000000b006216ff88b27sm4064975qvd.79.2023.05.17.04.04.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 04:04:10 -0700 (PDT)
From: Jamal Hadi Salim <jhs@mojatatu.com>
To: netdev@vger.kernel.org
Cc: deb.chatterjee@intel.com,
	anjali.singhai@intel.com,
	namrata.limaye@intel.com,
	tom@sipanda.io,
	p4tc-discussions@netdevconf.info,
	mleitner@redhat.com,
	Mahesh.Shirshyad@amd.com,
	Vipin.Jain@amd.com,
	tomasz.osinski@intel.com,
	jiri@resnulli.us,
	xiyou.wangcong@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	vladbu@nvidia.com,
	simon.horman@corigine.com,
	khalidm@nvidia.com,
	toke@redhat.com
Subject: [PATCH RFC v2 net-next 14/28] p4tc: add table create, update, delete, get, flush and dump
Date: Wed, 17 May 2023 07:02:18 -0400
Message-Id: <20230517110232.29349-14-jhs@mojatatu.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230517110232.29349-1-jhs@mojatatu.com>
References: <20230517110232.29349-1-jhs@mojatatu.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This commit introduces code to create and maintain P4 tables within a P4
program from user space and the next patch will have the code for
maintaining entries in the table.

As with all other P4TC objects, tables conform to CRUD operations and
it's important to note that write operations, such as create, update and
delete, can only be made if the pipeline is not sealed.

Per the P4 specification, tables prefix their name with the control block
(although this could be overridden by P4 annotations).

As an example, if one were to create a table named table1 in a
pipeline named myprog1, on control block "mycontrol", one would use
the following command:

tc p4template create table/myprog1/mycontrol/table1 tblid 1 \
   keysz 32 nummasks 8 tentries 8192

Above says that we are creating a table (table1) attached to pipeline
myprog1 on control block mycontrol which is called table1. Its key size is
32 bits and it can have up to 8 masks and 8192. The table id for table1 is
1. The table id is typically provided by the compiler.

Parameters such as nummasks (number of masks this table may have) and
tentries (maximum number of entries this table may have) may also be
omitted in which case 8 masks and 256 entries will be assumed.

If one were to retrieve the table named table1 (before or after the
pipeline is sealed) one would use the following command:

tc p4template get table/myprog1/mycontrol/table1

If one were to dump all the tables from a pipeline named myprog1, one would
use the following command:

tc p4template get table/myprog1

If one were to update table1 (before the pipeline is sealed) one would use
the following command:

tc p4template update table/myprog1/mycontrol/table1 ....

If one were to delete table1 (before the pipeline is sealed) one would use
the following command:

tc p4template del table/myprog1/mycontrol/table1

If one were to flush all the tables from a pipeline named myprog1, control
block "mycontrol" one would use the following command:

tc p4template del table/myprog1/mycontrol/

___Table Permissions___

Tables can have permissions which apply to all the entries in the specified
table. Permissions are defined for both what the control plane (user space)
is allowed to do as well as datapath.

The permissions field is a 16bit value which will hold CRUDX (create,
read, update, delete and execute) permissions for control and data path.
Bits 9-5 will have the CRUDX values for control and bits 4-0 will have
CRUDX values for data path. By default each table has the following
permissions:

CRUD--R--X

Which means the control plane can perform CRUD operations whereas the data
path can only Read and execute on the entries.
The user can override these permissions when creating the table or when
updating.

For example, the following command will create a table which will not allow
the datapath to create, update or delete entries but give full CRUD
permissions for the control plane.

$TC p4template create table/aP4proggie/cb/tname tblid 1 keysz 64
permissions 0x349 ...

Recall that these permissions come in the form of CRUDXCRUDX, where the
first CRUDX block is for control and the last is for data path.

So 0x349 is equivalent to CR-D--R--X

If we were to do a get with the following command:

$TC p4template get table/aP4proggie/cb/tname

The output would be the following:

pipeline name aP4proggie pipeline id 22
    table id 1
    table name cb/tname
    key_sz 64
    max entries 256
    masks 8
    table entries 0
    permissions CR-D--R--X

Note, the permissions concept is more powerful than classical const
definition currently taken by P4 which makes everything in a table
read-only.

___Initial Table Entries___

Templating can create initial table entries. For example:

tc p4template update table/myprog/cb/tname \
  entry srcAddr 10.10.10.10/24 dstAddr 1.1.1.0/24 prio 17

In this command we are "updating" table cb/tname with a new entry. This
entry has as its key srcAddr concatenated with dstAddr
(both IPv4 addresses) and prio 17.

If one was to read back the entry by issuing the following command:

tc p4template get myprog/table/cb/tname

They would get:

pipeline id 22
    table id 1
    table name cb/tname
    key_sz 64
    max entries 256
    masks 8
    table entries 1
    permissions CRUD--R--X
    entry:
        table id 1
        entry priority 17
        key blob    101010a0a0a0a
        mask blob   ffffff00ffffff
        create whodunnit tc
        permissions -RUD--R--X

___Table Actions List___

P4 tables allow certain actions but not other to be part of match entry on
a table or as default actions when there is a miss.

We also allow flags for each of the actions in this list that specify if
the action can be added only as a table entry (tableonly), or only as a
default action (defaultonly). If no flags are specified, it is assumed
that the action can be used in both contexts.

In P4TC we extend the concept of default action - which in P4 is mapped to
"a default miss action". Our extension is to add a "hit action" which is
executed every time there is a hit.

The default miss action will be executed whenever a table lookup doesn't
match any of the entries.

Both default hit and default miss are optional.

An example of specifying a default miss action is as follows:

tc p4template update table/myprog/cb/mytable \
    default_miss_action permissions 0x109 action drop

The above will drop packets if the entry is not found in mytable.
Note the above makes the default action a const. Meaning the control
plane can neither replace it nor delete it.

tc p4template update table/myprog/mytable \
  default_hit_action permissions 0x30F action ok

Whereas the above allows a default hit action to accept the packet.
The permission 0x30F in binary is (1100001111), which means we have only
Create and Read permissions in the control plane and Read, Update, Delete
and eXecute permissions in the data plane. This means, for example, that
now we can only delete the default hit action from the data plane.

__Packet Flow___

As with the pipeline, we also have preactions and postactions for tables
which can be programmed to teach the kernel how to process the packet.
Both are optional.
When a table apply() cmd is invoked on a table:

 1) The table preaction if present is invoked
 2) A "key action" is invoked to construct the table key
 3) A table lookup is done using the key from #2
 4a) If there is a hit
 - the match entry action will be executed
 - if there was a match and the entry has no action and a default hit
   action has been specified then the default hit action will be executed.
 4b) If there was a miss
 - if there was a default miss action it will be executed then

 5) if there is table post action then that is invoked next

Example of how one would create a key action for a table:
tc p4template create action/myprog/mytable/tkey \
   cmd set key.myprog.cb/mytable \
      hdrfield.myprog.parser1.ipv4.dstAddr

and now bind the key action to the table "mytable"
$TC p4template update table/myprog/cb/mytable \
        key action myprog/mytable/tkey

Example of how one would create a table post action is:
tc p4template create action/myprog/mytable/T_mytable_POA \
 cmd print prefix T_mytable_POA_res results.hit \
 cmd print prefix T_mytable_POA hdrfield.myprog.parser1.ipv4.dstAddr

Activate it..
tc p4template update action/myprog/mytable/T_mytable_POA state active

bind it..
$TC p4template update table/myprog/cb/mytable postactions \
    action myprog/mytable/T_mytable_POA

Co-developed-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Co-developed-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 include/net/p4tc.h             |   92 ++
 include/net/p4tc_types.h       |    2 +-
 include/uapi/linux/p4tc.h      |  112 +++
 net/sched/p4tc/Makefile        |    2 +-
 net/sched/p4tc/p4tc_pipeline.c |   15 +-
 net/sched/p4tc/p4tc_table.c    | 1664 ++++++++++++++++++++++++++++++++
 net/sched/p4tc/p4tc_tmpl_api.c |    2 +
 7 files changed, 1886 insertions(+), 3 deletions(-)
 create mode 100644 net/sched/p4tc/p4tc_table.c

diff --git a/include/net/p4tc.h b/include/net/p4tc.h
index 6111566b05eb..fa8c6a43c6d3 100644
--- a/include/net/p4tc.h
+++ b/include/net/p4tc.h
@@ -16,11 +16,18 @@
 #define P4TC_DEFAULT_MAX_RULES 1
 #define P4TC_MAXMETA_OFFSET 512
 #define P4TC_PATH_MAX 3
+#define P4TC_MAX_TENTRIES (2 << 23)
+#define P4TC_DEFAULT_TENTRIES 256
+#define P4TC_MAX_TMASKS 1024
+#define P4TC_DEFAULT_TMASKS 8
+
+#define P4TC_MAX_PERMISSION (GENMASK(P4TC_PERM_MAX_BIT, 0))
 
 #define P4TC_KERNEL_PIPEID 0
 
 #define P4TC_PID_IDX 0
 #define P4TC_MID_IDX 1
+#define P4TC_TBLID_IDX 1
 #define P4TC_AID_IDX 1
 #define P4TC_PARSEID_IDX 1
 #define P4TC_HDRFIELDID_IDX 2
@@ -111,6 +118,7 @@ struct p4tc_pipeline {
 	struct p4tc_template_common common;
 	struct idr                  p_meta_idr;
 	struct idr                  p_act_idr;
+	struct idr                  p_tbl_idr;
 	struct rcu_head             rcu;
 	struct net                  *net;
 	struct p4tc_parser          *parser;
@@ -197,6 +205,70 @@ struct p4tc_metadata {
 
 extern const struct p4tc_template_ops p4tc_meta_ops;
 
+struct p4tc_table_key {
+	struct tc_action **key_acts;
+	int              key_num_acts;
+};
+
+#define P4TC_CONTROL_PERMISSIONS (GENMASK(9, 5))
+#define P4TC_DATA_PERMISSIONS (GENMASK(4, 0))
+
+#define P4TC_TABLE_PERMISSIONS                                   \
+	((GENMASK(P4TC_CTRL_PERM_C_BIT, P4TC_CTRL_PERM_D_BIT)) | \
+	 P4TC_DATA_PERM_R | P4TC_DATA_PERM_X)
+
+#define P4TC_PERMISSIONS_UNINIT (1 << P4TC_PERM_MAX_BIT)
+
+struct p4tc_table_defact {
+	struct tc_action **default_acts;
+	/* Will have 2 5 bits blocks containing CRUDX (Create, read, update,
+	 * delete, execute) permissions for control plane and data plane.
+	 * The first 5 bits are for control and the next five are for data plane.
+	 * |crudxcrudx| if we were to denote it as UNIX permission flags.
+	 */
+	__u16 permissions;
+	struct rcu_head  rcu;
+};
+
+struct p4tc_table_perm {
+	__u16           permissions;
+	struct rcu_head rcu;
+};
+
+struct p4tc_table {
+	struct p4tc_template_common         common;
+	struct list_head                    tbl_acts_list;
+	struct p4tc_table_key               *tbl_key;
+	struct idr                          tbl_masks_idr;
+	struct idr                          tbl_prio_idr;
+	struct rhltable                     tbl_entries;
+	struct tc_action                    **tbl_preacts;
+	struct tc_action                    **tbl_postacts;
+	struct p4tc_table_defact __rcu      *tbl_default_hitact;
+	struct p4tc_table_defact __rcu      *tbl_default_missact;
+	struct p4tc_table_perm __rcu        *tbl_permissions;
+	struct p4tc_table_entry_mask __rcu  **tbl_masks_array;
+	unsigned long __rcu                 *tbl_free_masks_bitmap;
+	spinlock_t                          tbl_masks_idr_lock;
+	spinlock_t                          tbl_prio_idr_lock;
+	int                                 tbl_num_postacts;
+	int                                 tbl_num_preacts;
+	u32                                 tbl_count;
+	u32                                 tbl_curr_count;
+	u32                                 tbl_keysz;
+	u32                                 tbl_id;
+	u32                                 tbl_max_entries;
+	u32                                 tbl_max_masks;
+	u32                                 tbl_curr_used_entries;
+	u32                                 tbl_curr_num_masks;
+	refcount_t                          tbl_ctrl_ref;
+	refcount_t                          tbl_ref;
+	refcount_t                          tbl_entries_ref;
+	u16                                 tbl_type;
+};
+
+extern const struct p4tc_template_ops p4tc_table_ops;
+
 struct p4tc_ipv4_param_value {
 	u32 value;
 	u32 mask;
@@ -254,6 +326,12 @@ struct p4tc_act {
 	refcount_t                  a_ref;
 };
 
+struct p4tc_table_act {
+	struct list_head node;
+	struct tc_action_ops *ops;
+	u8     flags;
+};
+
 extern const struct p4tc_template_ops p4tc_act_ops;
 extern const struct rhashtable_params p4tc_label_ht_params;
 extern const struct rhashtable_params acts_params;
@@ -352,6 +430,19 @@ struct p4tc_act_param *tcf_param_find_byany(struct p4tc_act *act,
 					    const u32 param_id,
 					    struct netlink_ext_ack *extack);
 
+struct p4tc_table *tcf_table_find_byany(struct p4tc_pipeline *pipeline,
+					const char *tblname, const u32 tbl_id,
+					struct netlink_ext_ack *extack);
+struct p4tc_table *tcf_table_find_byid(struct p4tc_pipeline *pipeline,
+				       const u32 tbl_id);
+void *tcf_table_fetch(struct sk_buff *skb, void *tbl_value_ops);
+int tcf_table_try_set_state_ready(struct p4tc_pipeline *pipeline,
+				  struct netlink_ext_ack *extack);
+struct p4tc_table *tcf_table_get(struct p4tc_pipeline *pipeline,
+				 const char *tblname, const u32 tbl_id,
+				 struct netlink_ext_ack *extack);
+void tcf_table_put_ref(struct p4tc_table *table);
+
 struct p4tc_parser *tcf_parser_create(struct p4tc_pipeline *pipeline,
 				      const char *parser_name,
 				      u32 parser_inst_id,
@@ -402,5 +493,6 @@ int generic_dump_param_value(struct sk_buff *skb, struct p4tc_type *type,
 #define to_meta(t) ((struct p4tc_metadata *)t)
 #define to_hdrfield(t) ((struct p4tc_hdrfield *)t)
 #define to_act(t) ((struct p4tc_act *)t)
+#define to_table(t) ((struct p4tc_table *)t)
 
 #endif
diff --git a/include/net/p4tc_types.h b/include/net/p4tc_types.h
index 26594c0b0298..bd3217c938ca 100644
--- a/include/net/p4tc_types.h
+++ b/include/net/p4tc_types.h
@@ -8,7 +8,7 @@
 
 #include <uapi/linux/p4tc.h>
 
-#define P4T_MAX_BITSZ 128
+#define P4T_MAX_BITSZ P4TC_MAX_KEYSZ
 
 struct p4tc_type_mask_shift {
 	void *mask;
diff --git a/include/uapi/linux/p4tc.h b/include/uapi/linux/p4tc.h
index 15876c471266..99a24ce8f319 100644
--- a/include/uapi/linux/p4tc.h
+++ b/include/uapi/linux/p4tc.h
@@ -31,6 +31,70 @@ struct p4tcmsg {
 #define PARSERNAMSIZ TEMPLATENAMSZ
 #define HDRFIELDNAMSIZ TEMPLATENAMSZ
 #define ACTPARAMNAMSIZ TEMPLATENAMSZ
+#define TABLENAMSIZ TEMPLATENAMSZ
+
+#define P4TC_TABLE_FLAGS_KEYSZ 0x01
+#define P4TC_TABLE_FLAGS_MAX_ENTRIES 0x02
+#define P4TC_TABLE_FLAGS_MAX_MASKS 0x04
+#define P4TC_TABLE_FLAGS_DEFAULT_KEY 0x08
+#define P4TC_TABLE_FLAGS_PERMISSIONS 0x10
+#define P4TC_TABLE_FLAGS_TYPE 0x20
+
+enum {
+	P4TC_TABLE_TYPE_EXACT = 1,
+	P4TC_TABLE_TYPE_LPM = 2,
+	__P4TC_TABLE_TYPE_MAX,
+};
+#define P4TC_TABLE_TYPE_MAX (__P4TC_TABLE_TYPE_MAX - 1)
+
+#define P4TC_CTRL_PERM_C_BIT 9
+#define P4TC_CTRL_PERM_R_BIT 8
+#define P4TC_CTRL_PERM_U_BIT 7
+#define P4TC_CTRL_PERM_D_BIT 6
+#define P4TC_CTRL_PERM_X_BIT 5
+
+#define P4TC_DATA_PERM_C_BIT 4
+#define P4TC_DATA_PERM_R_BIT 3
+#define P4TC_DATA_PERM_U_BIT 2
+#define P4TC_DATA_PERM_D_BIT 1
+#define P4TC_DATA_PERM_X_BIT 0
+
+#define P4TC_PERM_MAX_BIT P4TC_CTRL_PERM_C_BIT
+
+#define P4TC_CTRL_PERM_C (1 << P4TC_CTRL_PERM_C_BIT)
+#define P4TC_CTRL_PERM_R (1 << P4TC_CTRL_PERM_R_BIT)
+#define P4TC_CTRL_PERM_U (1 << P4TC_CTRL_PERM_U_BIT)
+#define P4TC_CTRL_PERM_D (1 << P4TC_CTRL_PERM_D_BIT)
+#define P4TC_CTRL_PERM_X (1 << P4TC_CTRL_PERM_X_BIT)
+
+#define P4TC_DATA_PERM_C (1 << P4TC_DATA_PERM_C_BIT)
+#define P4TC_DATA_PERM_R (1 << P4TC_DATA_PERM_R_BIT)
+#define P4TC_DATA_PERM_U (1 << P4TC_DATA_PERM_U_BIT)
+#define P4TC_DATA_PERM_D (1 << P4TC_DATA_PERM_D_BIT)
+#define P4TC_DATA_PERM_X (1 << P4TC_DATA_PERM_X_BIT)
+
+#define p4tc_ctrl_create_ok(perm)   (perm & P4TC_CTRL_PERM_C)
+#define p4tc_ctrl_read_ok(perm)     (perm & P4TC_CTRL_PERM_R)
+#define p4tc_ctrl_update_ok(perm)   (perm & P4TC_CTRL_PERM_U)
+#define p4tc_ctrl_delete_ok(perm)   (perm & P4TC_CTRL_PERM_D)
+#define p4tc_ctrl_exec_ok(perm)     (perm & P4TC_CTRL_PERM_X)
+
+#define p4tc_data_create_ok(perm)   (perm & P4TC_DATA_PERM_C)
+#define p4tc_data_read_ok(perm)     (perm & P4TC_DATA_PERM_R)
+#define p4tc_data_update_ok(perm)   (perm & P4TC_DATA_PERM_U)
+#define p4tc_data_delete_ok(perm)   (perm & P4TC_DATA_PERM_D)
+#define p4tc_data_exec_ok(perm)     (perm & P4TC_DATA_PERM_X)
+
+struct p4tc_table_parm {
+	__u32 tbl_keysz;
+	__u32 tbl_max_entries;
+	__u32 tbl_max_masks;
+	__u32 tbl_flags;
+	__u32 tbl_num_entries;
+	__u16 tbl_permissions;
+	__u8  tbl_type;
+	__u8  PAD0;
+};
 
 #define LABELNAMSIZ 32
 
@@ -63,6 +127,7 @@ enum {
 	P4TC_OBJ_META,
 	P4TC_OBJ_HDR_FIELD,
 	P4TC_OBJ_ACT,
+	P4TC_OBJ_TABLE,
 	__P4TC_OBJ_MAX,
 };
 #define P4TC_OBJ_MAX __P4TC_OBJ_MAX
@@ -161,6 +226,53 @@ enum {
 };
 #define P4TC_KERNEL_META_MAX (__P4TC_KERNEL_META_MAX - 1)
 
+/* Table key attributes */
+enum {
+	P4TC_KEY_UNSPEC,
+	P4TC_KEY_ACT, /* nested key actions */
+	__P4TC_TKEY_MAX
+};
+#define P4TC_TKEY_MAX __P4TC_TKEY_MAX
+
+enum {
+	P4TC_TABLE_DEFAULT_UNSPEC,
+	P4TC_TABLE_DEFAULT_ACTION,
+	P4TC_TABLE_DEFAULT_PERMISSIONS,
+	__P4TC_TABLE_DEFAULT_MAX
+};
+#define P4TC_TABLE_DEFAULT_MAX (__P4TC_TABLE_DEFAULT_MAX - 1)
+
+enum {
+	P4TC_TABLE_ACTS_DEFAULT_ONLY,
+	P4TC_TABLE_ACTS_TABLE_ONLY,
+	__P4TC_TABLE_ACTS_FLAGS_MAX,
+};
+#define P4TC_TABLE_ACTS_FLAGS_MAX (__P4TC_TABLE_ACTS_FLAGS_MAX - 1)
+
+enum {
+	P4TC_TABLE_ACT_UNSPEC,
+	P4TC_TABLE_ACT_FLAGS, /* u8 */
+	P4TC_TABLE_ACT_NAME, /* string */
+	__P4TC_TABLE_ACT_MAX
+};
+#define P4TC_TABLE_ACT_MAX (__P4TC_TABLE_ACT_MAX - 1)
+
+/* Table type attributes */
+enum {
+	P4TC_TABLE_UNSPEC,
+	P4TC_TABLE_NAME, /* string */
+	P4TC_TABLE_INFO, /* struct tc_p4_table_type_parm */
+	P4TC_TABLE_PREACTIONS, /* nested table preactions */
+	P4TC_TABLE_KEY, /* nested table key */
+	P4TC_TABLE_POSTACTIONS, /* nested table postactions */
+	P4TC_TABLE_DEFAULT_HIT, /* nested default hit action attributes */
+	P4TC_TABLE_DEFAULT_MISS, /* nested default miss action attributes */
+	P4TC_TABLE_OPT_ENTRY, /* nested const table entry*/
+	P4TC_TABLE_ACTS_LIST, /* nested table actions list */
+	__P4TC_TABLE_MAX
+};
+#define P4TC_TABLE_MAX __P4TC_TABLE_MAX
+
 struct p4tc_hdrfield_ty {
 	__u16 startbit;
 	__u16 endbit;
diff --git a/net/sched/p4tc/Makefile b/net/sched/p4tc/Makefile
index 3f7267366827..de3a7b83305c 100644
--- a/net/sched/p4tc/Makefile
+++ b/net/sched/p4tc/Makefile
@@ -1,4 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0
 
 obj-y := p4tc_types.o p4tc_pipeline.o p4tc_tmpl_api.o p4tc_meta.o \
-	p4tc_parser_api.o p4tc_hdrfield.o p4tc_action.o
+	p4tc_parser_api.o p4tc_hdrfield.o p4tc_action.o p4tc_table.o
diff --git a/net/sched/p4tc/p4tc_pipeline.c b/net/sched/p4tc/p4tc_pipeline.c
index e4cb5ad994e8..51b47b07ba65 100644
--- a/net/sched/p4tc/p4tc_pipeline.c
+++ b/net/sched/p4tc/p4tc_pipeline.c
@@ -297,6 +297,7 @@ static void tcf_pipeline_destroy(struct p4tc_pipeline *pipeline,
 {
 	idr_destroy(&pipeline->p_meta_idr);
 	idr_destroy(&pipeline->p_act_idr);
+	idr_destroy(&pipeline->p_tbl_idr);
 
 	if (free_pipeline)
 		kfree(pipeline);
@@ -323,8 +324,9 @@ static int tcf_pipeline_put(struct net *net,
 	struct p4tc_pipeline *pipeline = to_pipeline(template);
 	struct net *pipeline_net = maybe_get_net(net);
 	struct p4tc_act_dep_node *act_node, *node_tmp;
-	unsigned long m_id, tmp;
+	unsigned long tbl_id, m_id, tmp;
 	struct p4tc_metadata *meta;
+	struct p4tc_table *table;
 
 	if (pipeline_net && !refcount_dec_if_one(&pipeline->p_ref)) {
 		NL_SET_ERR_MSG(extack, "Can't delete referenced pipeline");
@@ -339,6 +341,9 @@ static int tcf_pipeline_put(struct net *net,
 	p4tc_action_destroy(pipeline->preacts);
 	p4tc_action_destroy(pipeline->postacts);
 
+	idr_for_each_entry_ul(&pipeline->p_tbl_idr, table, tmp, tbl_id)
+		table->common.ops->put(net, &table->common, true, extack);
+
 	act_dep_graph_free(&pipeline->act_dep_graph);
 
 	list_for_each_entry_safe(act_node, node_tmp,
@@ -371,6 +376,8 @@ static int tcf_pipeline_put(struct net *net,
 static inline int pipeline_try_set_state_ready(struct p4tc_pipeline *pipeline,
 					       struct netlink_ext_ack *extack)
 {
+	int ret;
+
 	if (pipeline->curr_tables != pipeline->num_tables) {
 		NL_SET_ERR_MSG(extack,
 			       "Must have all table defined to update state to ready");
@@ -388,6 +395,9 @@ static inline int pipeline_try_set_state_ready(struct p4tc_pipeline *pipeline,
 			       "Must specify pipeline postactions before sealing");
 		return -EINVAL;
 	}
+	ret = tcf_table_try_set_state_ready(pipeline, extack);
+	if (ret < 0)
+		return ret;
 
 	/* Will never fail in this case */
 	determine_act_topological_order(pipeline, false);
@@ -542,6 +552,9 @@ static struct p4tc_pipeline *tcf_pipeline_create(struct net *net,
 
 	idr_init(&pipeline->p_act_idr);
 
+	idr_init(&pipeline->p_tbl_idr);
+	pipeline->curr_tables = 0;
+
 	idr_init(&pipeline->p_meta_idr);
 	pipeline->p_meta_offset = 0;
 
diff --git a/net/sched/p4tc/p4tc_table.c b/net/sched/p4tc/p4tc_table.c
new file mode 100644
index 000000000000..1ae4ed6d39e9
--- /dev/null
+++ b/net/sched/p4tc/p4tc_table.c
@@ -0,0 +1,1664 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * net/sched/p4tc_table.c	P4 TC TABLE
+ *
+ * Copyright (c) 2022-2023, Mojatatu Networks
+ * Copyright (c) 2022-2023, Intel Corporation.
+ * Authors:     Jamal Hadi Salim <jhs@mojatatu.com>
+ *              Victor Nogueira <victor@mojatatu.com>
+ *              Pedro Tammela <pctammela@mojatatu.com>
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/slab.h>
+#include <linux/skbuff.h>
+#include <linux/init.h>
+#include <linux/kmod.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/bitmap.h>
+#include <net/net_namespace.h>
+#include <net/sock.h>
+#include <net/sch_generic.h>
+#include <net/pkt_cls.h>
+#include <net/p4tc.h>
+#include <net/netlink.h>
+#include <net/flow_offload.h>
+
+#define P4TC_P_UNSPEC 0
+#define P4TC_P_CREATED 1
+
+static int tcf_key_try_set_state_ready(struct p4tc_table_key *key,
+				       struct netlink_ext_ack *extack)
+{
+	if (!key->key_acts) {
+		NL_SET_ERR_MSG(extack,
+			       "Table key must have actions before sealing pipelline");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int __tcf_table_try_set_state_ready(struct p4tc_table *table,
+					   struct netlink_ext_ack *extack)
+{
+	int i;
+	int ret;
+
+	if (!table->tbl_postacts) {
+		NL_SET_ERR_MSG(extack,
+			       "All tables must have postactions before sealing pipelline");
+		return -EINVAL;
+	}
+
+	if (!table->tbl_key) {
+		NL_SET_ERR_MSG(extack,
+			       "Table must have key before sealing pipeline");
+		return -EINVAL;
+	}
+
+	ret = tcf_key_try_set_state_ready(table->tbl_key, extack);
+	if (ret < 0)
+		return ret;
+
+	table->tbl_masks_array = kcalloc(table->tbl_max_masks,
+					 sizeof(*(table->tbl_masks_array)),
+					 GFP_KERNEL);
+	if (!table->tbl_masks_array)
+		return -ENOMEM;
+
+	table->tbl_free_masks_bitmap =
+		bitmap_alloc(P4TC_MAX_TMASKS, GFP_KERNEL);
+	if (!table->tbl_free_masks_bitmap) {
+		kfree(table->tbl_masks_array);
+		return -ENOMEM;
+	}
+
+	bitmap_fill(table->tbl_free_masks_bitmap, P4TC_MAX_TMASKS);
+
+	return 0;
+}
+
+void free_table_cache_array(struct p4tc_table **set_tables,
+			    int num_tables)
+{
+	int i;
+
+	for (i = 0; i < num_tables; i++) {
+		struct p4tc_table *table = set_tables[i];
+
+		kfree(table->tbl_masks_array);
+		bitmap_free(table->tbl_free_masks_bitmap);
+	}
+}
+
+int tcf_table_try_set_state_ready(struct p4tc_pipeline *pipeline,
+				  struct netlink_ext_ack *extack)
+{
+	int i = 0;
+	struct p4tc_table **set_tables;
+	struct p4tc_table *table;
+	unsigned long tmp, id;
+	int ret;
+
+	set_tables = kcalloc(pipeline->num_tables, sizeof(*set_tables),
+			     GFP_KERNEL);
+	if (!set_tables)
+		return -ENOMEM;
+
+	idr_for_each_entry_ul(&pipeline->p_tbl_idr, table, tmp, id) {
+		ret = __tcf_table_try_set_state_ready(table, extack);
+		if (ret < 0)
+			goto free_set_tables;
+		set_tables[i] = table;
+		i++;
+	}
+	kfree(set_tables);
+
+	return 0;
+
+free_set_tables:
+	free_table_cache_array(set_tables, i);
+	kfree(set_tables);
+	return ret;
+}
+
+static const struct nla_policy p4tc_table_policy[P4TC_TABLE_MAX + 1] = {
+	[P4TC_TABLE_NAME] = { .type = NLA_STRING, .len = TABLENAMSIZ },
+	[P4TC_TABLE_INFO] = { .type = NLA_BINARY,
+			      .len = sizeof(struct p4tc_table_parm) },
+	[P4TC_TABLE_PREACTIONS] = { .type = NLA_NESTED },
+	[P4TC_TABLE_KEY] = { .type = NLA_NESTED },
+	[P4TC_TABLE_POSTACTIONS] = { .type = NLA_NESTED },
+	[P4TC_TABLE_DEFAULT_HIT] = { .type = NLA_NESTED },
+	[P4TC_TABLE_DEFAULT_MISS] = { .type = NLA_NESTED },
+	[P4TC_TABLE_ACTS_LIST] = { .type = NLA_NESTED },
+	[P4TC_TABLE_OPT_ENTRY] = { .type = NLA_NESTED },
+};
+
+static const struct nla_policy p4tc_table_key_policy[P4TC_MAXPARSE_KEYS + 1] = {
+	[P4TC_KEY_ACT] = { .type = NLA_NESTED },
+};
+
+static int tcf_table_key_fill_nlmsg(struct sk_buff *skb,
+				    struct p4tc_table_key *key)
+{
+	int ret = 0;
+	struct nlattr *nest_action;
+
+	if (key->key_acts) {
+		nest_action = nla_nest_start(skb, P4TC_KEY_ACT);
+		ret = tcf_action_dump(skb, key->key_acts, 0, 0, false);
+		if (ret < 0)
+			return ret;
+		nla_nest_end(skb, nest_action);
+	}
+
+	return ret;
+}
+
+static int _tcf_table_fill_nlmsg(struct sk_buff *skb, struct p4tc_table *table)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	int i = 1;
+	struct p4tc_table_perm *tbl_perm;
+	struct p4tc_table_act *table_act;
+	struct nlattr *nested_tbl_acts;
+	struct nlattr *default_missact;
+	struct nlattr *default_hitact;
+	struct nlattr *nested_count;
+	struct p4tc_table_parm parm;
+	struct nlattr *nest_key;
+	struct nlattr *nest;
+	struct nlattr *preacts;
+	struct nlattr *postacts;
+	int err;
+
+	if (nla_put_u32(skb, P4TC_PATH, table->tbl_id))
+		goto out_nlmsg_trim;
+
+	nest = nla_nest_start(skb, P4TC_PARAMS);
+	if (!nest)
+		goto out_nlmsg_trim;
+
+	if (nla_put_string(skb, P4TC_TABLE_NAME, table->common.name))
+		goto out_nlmsg_trim;
+
+	parm.tbl_keysz = table->tbl_keysz;
+	parm.tbl_max_entries = table->tbl_max_entries;
+	parm.tbl_max_masks = table->tbl_max_masks;
+	parm.tbl_num_entries = refcount_read(&table->tbl_entries_ref) - 1;
+
+	tbl_perm = rcu_dereference_rtnl(table->tbl_permissions);
+	parm.tbl_permissions = tbl_perm->permissions;
+
+	if (table->tbl_key) {
+		nest_key = nla_nest_start(skb, P4TC_TABLE_KEY);
+		err = tcf_table_key_fill_nlmsg(skb, table->tbl_key);
+		if (err < 0)
+			goto out_nlmsg_trim;
+		nla_nest_end(skb, nest_key);
+	}
+
+	if (table->tbl_preacts) {
+		preacts = nla_nest_start(skb, P4TC_TABLE_PREACTIONS);
+		if (tcf_action_dump(skb, table->tbl_preacts, 0, 0, false) < 0)
+			goto out_nlmsg_trim;
+		nla_nest_end(skb, preacts);
+	}
+
+	if (table->tbl_postacts) {
+		postacts = nla_nest_start(skb, P4TC_TABLE_POSTACTIONS);
+		if (tcf_action_dump(skb, table->tbl_postacts, 0, 0, false) < 0)
+			goto out_nlmsg_trim;
+		nla_nest_end(skb, postacts);
+	}
+
+	if (table->tbl_default_hitact) {
+		struct p4tc_table_defact *hitact;
+
+		default_hitact = nla_nest_start(skb, P4TC_TABLE_DEFAULT_HIT);
+		rcu_read_lock();
+		hitact = rcu_dereference_rtnl(table->tbl_default_hitact);
+		if (hitact->default_acts) {
+			struct nlattr *nest;
+
+			nest = nla_nest_start(skb, P4TC_TABLE_DEFAULT_ACTION);
+			if (tcf_action_dump(skb, hitact->default_acts, 0, 0,
+					    false) < 0) {
+				rcu_read_unlock();
+				goto out_nlmsg_trim;
+			}
+			nla_nest_end(skb, nest);
+		}
+		if (nla_put_u16(skb, P4TC_TABLE_DEFAULT_PERMISSIONS,
+				hitact->permissions) < 0) {
+			rcu_read_unlock();
+			goto out_nlmsg_trim;
+		}
+		rcu_read_unlock();
+		nla_nest_end(skb, default_hitact);
+	}
+
+	if (table->tbl_default_missact) {
+		struct p4tc_table_defact *missact;
+
+		default_missact = nla_nest_start(skb, P4TC_TABLE_DEFAULT_MISS);
+		rcu_read_lock();
+		missact = rcu_dereference_rtnl(table->tbl_default_missact);
+		if (missact->default_acts) {
+			struct nlattr *nest;
+
+			nest = nla_nest_start(skb, P4TC_TABLE_DEFAULT_ACTION);
+			if (tcf_action_dump(skb, missact->default_acts, 0, 0,
+					    false) < 0) {
+				rcu_read_unlock();
+				goto out_nlmsg_trim;
+			}
+			nla_nest_end(skb, nest);
+		}
+		if (nla_put_u16(skb, P4TC_TABLE_DEFAULT_PERMISSIONS,
+				missact->permissions) < 0) {
+			rcu_read_unlock();
+			goto out_nlmsg_trim;
+		}
+		rcu_read_unlock();
+		nla_nest_end(skb, default_missact);
+	}
+
+	nested_tbl_acts = nla_nest_start(skb, P4TC_TABLE_ACTS_LIST);
+	list_for_each_entry(table_act, &table->tbl_acts_list, node) {
+		nested_count = nla_nest_start(skb, i);
+		if (nla_put_string(skb, P4TC_TABLE_ACT_NAME,
+				   table_act->ops->kind) < 0)
+			goto out_nlmsg_trim;
+		if (nla_put_u32(skb, P4TC_TABLE_ACT_FLAGS,
+				table_act->flags) < 0)
+			goto out_nlmsg_trim;
+
+		nla_nest_end(skb, nested_count);
+		i++;
+	}
+	nla_nest_end(skb, nested_tbl_acts);
+
+	if (nla_put(skb, P4TC_TABLE_INFO, sizeof(parm), &parm))
+		goto out_nlmsg_trim;
+	nla_nest_end(skb, nest);
+
+	return skb->len;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return -1;
+}
+
+static int tcf_table_fill_nlmsg(struct net *net, struct sk_buff *skb,
+				struct p4tc_template_common *template,
+				struct netlink_ext_ack *extack)
+{
+	struct p4tc_table *table = to_table(template);
+
+	if (_tcf_table_fill_nlmsg(skb, table) <= 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Failed to fill notification attributes for table");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static inline void tcf_table_key_put(struct p4tc_table_key *key)
+{
+	p4tc_action_destroy(key->key_acts);
+	kfree(key);
+}
+
+static inline void p4tc_table_defact_destroy(struct p4tc_table_defact *defact)
+{
+	if (defact) {
+		p4tc_action_destroy(defact->default_acts);
+		kfree(defact);
+	}
+}
+
+void tcf_table_acts_list_destroy(struct list_head *acts_list)
+{
+	struct p4tc_table_act *table_act, *tmp;
+
+	list_for_each_entry_safe(table_act, tmp, acts_list, node) {
+		struct p4tc_act *act;
+
+		act = container_of(table_act->ops, typeof(*act), ops);
+		list_del(&table_act->node);
+		kfree(table_act);
+		WARN_ON(!refcount_dec_not_one(&act->a_ref));
+	}
+}
+
+static inline int _tcf_table_put(struct net *net, struct nlattr **tb,
+				 struct p4tc_pipeline *pipeline,
+				 struct p4tc_table *table,
+				 bool unconditional_purge,
+				 struct netlink_ext_ack *extack)
+{
+	bool default_act_del = false;
+	struct p4tc_table_perm *perm;
+
+	if (tb)
+		default_act_del = tb[P4TC_TABLE_DEFAULT_HIT] ||
+				  tb[P4TC_TABLE_DEFAULT_MISS];
+
+	if (!default_act_del) {
+		if (!unconditional_purge &&
+		    !refcount_dec_if_one(&table->tbl_ctrl_ref)) {
+			NL_SET_ERR_MSG(extack,
+				       "Unable to delete referenced table");
+			return -EBUSY;
+		}
+
+		if (!unconditional_purge &&
+		    !refcount_dec_if_one(&table->tbl_ref)) {
+			refcount_set(&table->tbl_ctrl_ref, 1);
+			NL_SET_ERR_MSG(extack,
+				       "Unable to delete referenced table");
+			return -EBUSY;
+		}
+	}
+
+	if (tb && tb[P4TC_TABLE_DEFAULT_HIT]) {
+		struct p4tc_table_defact *hitact;
+
+		rcu_read_lock();
+		hitact = rcu_dereference(table->tbl_default_hitact);
+		if (hitact && !p4tc_ctrl_delete_ok(hitact->permissions)) {
+			NL_SET_ERR_MSG(extack,
+				       "Permission denied: Unable to delete default hitact");
+			rcu_read_unlock();
+			return -EPERM;
+		}
+		rcu_read_unlock();
+	}
+
+	if (tb && tb[P4TC_TABLE_DEFAULT_MISS]) {
+		struct p4tc_table_defact *missact;
+
+		rcu_read_lock();
+		missact = rcu_dereference(table->tbl_default_missact);
+		if (missact && !p4tc_ctrl_delete_ok(missact->permissions)) {
+			NL_SET_ERR_MSG(extack,
+				       "Permission denied: Unable to delete default missact");
+			rcu_read_unlock();
+			return -EPERM;
+		}
+		rcu_read_unlock();
+	}
+
+	if (!default_act_del || tb[P4TC_TABLE_DEFAULT_HIT]) {
+		struct p4tc_table_defact *hitact;
+
+		hitact = rtnl_dereference(table->tbl_default_hitact);
+		if (hitact) {
+			rcu_replace_pointer_rtnl(table->tbl_default_hitact,
+						 NULL);
+			synchronize_rcu();
+			p4tc_table_defact_destroy(hitact);
+		}
+	}
+
+	if (!default_act_del || tb[P4TC_TABLE_DEFAULT_MISS]) {
+		struct p4tc_table_defact *missact;
+
+		missact = rtnl_dereference(table->tbl_default_missact);
+		if (missact) {
+			rcu_replace_pointer_rtnl(table->tbl_default_missact,
+						 NULL);
+			synchronize_rcu();
+			p4tc_table_defact_destroy(missact);
+		}
+	}
+
+	if (default_act_del)
+		return 0;
+
+	if (table->tbl_key)
+		tcf_table_key_put(table->tbl_key);
+
+	p4tc_action_destroy(table->tbl_preacts);
+	p4tc_action_destroy(table->tbl_postacts);
+
+	tcf_table_acts_list_destroy(&table->tbl_acts_list);
+
+	idr_destroy(&table->tbl_masks_idr);
+	idr_destroy(&table->tbl_prio_idr);
+
+	perm = rcu_replace_pointer_rtnl(table->tbl_permissions, NULL);
+	kfree_rcu(perm, rcu);
+
+	idr_remove(&pipeline->p_tbl_idr, table->tbl_id);
+	pipeline->curr_tables -= 1;
+
+	kfree(table->tbl_masks_array);
+	bitmap_free(table->tbl_free_masks_bitmap);
+
+	kfree(table);
+
+	return 0;
+}
+
+static int tcf_table_put(struct net *net, struct p4tc_template_common *tmpl,
+			 bool unconditional_purge,
+			 struct netlink_ext_ack *extack)
+{
+	struct p4tc_pipeline *pipeline =
+		tcf_pipeline_find_byid(net, tmpl->p_id);
+	struct p4tc_table *table = to_table(tmpl);
+
+	return _tcf_table_put(net, NULL, pipeline, table, unconditional_purge,
+			      extack);
+}
+
+static inline struct p4tc_table_key *
+tcf_table_key_add(struct net *net, struct p4tc_table *table, struct nlattr *nla,
+		  struct netlink_ext_ack *extack)
+{
+	int ret = 0;
+	struct nlattr *tb[P4TC_TKEY_MAX + 1];
+	struct p4tc_table_key *key;
+
+	ret = nla_parse_nested(tb, P4TC_TKEY_MAX, nla, p4tc_table_key_policy,
+			       extack);
+	if (ret < 0)
+		goto out;
+
+	key = kzalloc(sizeof(*key), GFP_KERNEL);
+	if (!key) {
+		NL_SET_ERR_MSG(extack, "Failed to allocate table key");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (tb[P4TC_KEY_ACT]) {
+		key->key_acts = kcalloc(TCA_ACT_MAX_PRIO,
+					sizeof(struct tc_action *), GFP_KERNEL);
+		if (!key->key_acts) {
+			ret = -ENOMEM;
+			goto free_key;
+		}
+
+		ret = p4tc_action_init(net, tb[P4TC_KEY_ACT], key->key_acts,
+				       table->common.p_id, 0, extack);
+		if (ret < 0) {
+			kfree(key->key_acts);
+			goto free_key;
+		}
+		key->key_num_acts = ret;
+	}
+
+	return key;
+
+free_key:
+	kfree(key);
+
+out:
+	return ERR_PTR(ret);
+}
+
+struct p4tc_table *tcf_table_find_byid(struct p4tc_pipeline *pipeline,
+				       const u32 tbl_id)
+{
+	return idr_find(&pipeline->p_tbl_idr, tbl_id);
+}
+
+static struct p4tc_table *table_find_byname(const char *tblname,
+					    struct p4tc_pipeline *pipeline)
+{
+	struct p4tc_table *table;
+	unsigned long tmp, id;
+
+	idr_for_each_entry_ul(&pipeline->p_tbl_idr, table, tmp, id)
+		if (strncmp(table->common.name, tblname, TABLENAMSIZ) == 0)
+			return table;
+
+	return NULL;
+}
+
+#define SEPARATOR '/'
+struct p4tc_table *tcf_table_find_byany(struct p4tc_pipeline *pipeline,
+					const char *tblname, const u32 tbl_id,
+					struct netlink_ext_ack *extack)
+{
+	struct p4tc_table *table;
+	int err;
+
+	if (tbl_id) {
+		table = tcf_table_find_byid(pipeline, tbl_id);
+		if (!table) {
+			NL_SET_ERR_MSG(extack, "Unable to find table by id");
+			err = -EINVAL;
+			goto out;
+		}
+	} else {
+		if (tblname) {
+			table = table_find_byname(tblname, pipeline);
+			if (!table) {
+				NL_SET_ERR_MSG(extack, "Table name not found");
+				err = -EINVAL;
+				goto out;
+			}
+		} else {
+			NL_SET_ERR_MSG(extack, "Must specify table name or id");
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	return table;
+out:
+	return ERR_PTR(err);
+}
+
+struct p4tc_table *tcf_table_get(struct p4tc_pipeline *pipeline,
+				 const char *tblname, const u32 tbl_id,
+				 struct netlink_ext_ack *extack)
+{
+	struct p4tc_table *table;
+
+	table = tcf_table_find_byany(pipeline, tblname, tbl_id, extack);
+	if (IS_ERR(table))
+		return table;
+
+	/* Should never be zero */
+	WARN_ON(!refcount_inc_not_zero(&table->tbl_ref));
+	return table;
+}
+
+void tcf_table_put_ref(struct p4tc_table *table)
+{
+	/* Should never be zero */
+	WARN_ON(!refcount_dec_not_one(&table->tbl_ref));
+}
+
+static int tcf_table_init_default_act(struct net *net, struct nlattr **tb,
+				      struct p4tc_table_defact **default_act,
+				      u32 pipeid, __u16 curr_permissions,
+				      struct netlink_ext_ack *extack)
+{
+	int ret;
+
+	*default_act = kzalloc(sizeof(**default_act), GFP_KERNEL);
+	if (!(*default_act))
+		return -ENOMEM;
+
+	if (tb[P4TC_TABLE_DEFAULT_PERMISSIONS]) {
+		__u16 *permissions;
+
+		permissions = nla_data(tb[P4TC_TABLE_DEFAULT_PERMISSIONS]);
+		if (!p4tc_data_exec_ok(*permissions)) {
+			NL_SET_ERR_MSG(extack,
+				       "Default action must have data path execute permissions");
+			ret = -EINVAL;
+			goto default_act_free;
+		}
+		(*default_act)->permissions = *permissions;
+	} else {
+		(*default_act)->permissions = curr_permissions;
+	}
+
+	if (tb[P4TC_TABLE_DEFAULT_ACTION]) {
+		struct tc_action **default_acts;
+
+		if (!p4tc_ctrl_update_ok(curr_permissions)) {
+			NL_SET_ERR_MSG(extack,
+				       "Permission denied: Unable to update default hit action");
+			ret = -EPERM;
+			goto default_act_free;
+		}
+
+		default_acts = kcalloc(TCA_ACT_MAX_PRIO,
+				       sizeof(struct tc_action *), GFP_KERNEL);
+		if (!default_acts) {
+			ret = -ENOMEM;
+			goto default_act_free;
+		}
+
+		ret = p4tc_action_init(net, tb[P4TC_TABLE_DEFAULT_ACTION],
+				       default_acts, pipeid, 0, extack);
+		if (ret < 0) {
+			kfree(default_acts);
+			goto default_act_free;
+		} else if (ret > 1) {
+			NL_SET_ERR_MSG(extack, "Can only have one hit action");
+			tcf_action_destroy(default_acts, TCA_ACT_UNBIND);
+			kfree(default_acts);
+			ret = -EINVAL;
+			goto default_act_free;
+		}
+		(*default_act)->default_acts = default_acts;
+	}
+
+	return 0;
+
+default_act_free:
+	kfree(*default_act);
+
+	return ret;
+}
+
+static int tcf_table_check_defacts(struct tc_action *defact,
+				   struct list_head *acts_list)
+{
+	struct p4tc_table_act *table_act;
+
+	list_for_each_entry(table_act, acts_list, node) {
+		if (table_act->ops->id == defact->ops->id &&
+		    !(table_act->flags & BIT(P4TC_TABLE_ACTS_TABLE_ONLY)))
+			return true;
+	}
+
+	return false;
+}
+
+static struct nla_policy p4tc_table_default_policy[P4TC_TABLE_DEFAULT_MAX + 1] = {
+	[P4TC_TABLE_DEFAULT_ACTION] = { .type = NLA_NESTED },
+	[P4TC_TABLE_DEFAULT_PERMISSIONS] =
+		NLA_POLICY_MAX(NLA_U16, P4TC_MAX_PERMISSION),
+};
+
+static int
+tcf_table_init_default_acts(struct net *net, struct nlattr **tb,
+			    struct p4tc_table *table,
+			    struct p4tc_table_defact **default_hitact,
+			    struct p4tc_table_defact **default_missact,
+			    struct list_head *acts_list,
+			    struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb_default[P4TC_TABLE_DEFAULT_MAX + 1];
+	__u16 permissions = P4TC_CONTROL_PERMISSIONS | P4TC_DATA_PERMISSIONS;
+	int ret;
+
+	*default_missact = NULL;
+	*default_hitact = NULL;
+
+	if (tb[P4TC_TABLE_DEFAULT_HIT]) {
+		struct p4tc_table_defact *defact;
+
+		rcu_read_lock();
+		defact = rcu_dereference(table->tbl_default_hitact);
+		if (defact)
+			permissions = defact->permissions;
+		rcu_read_unlock();
+
+		ret = nla_parse_nested(tb_default, P4TC_TABLE_DEFAULT_MAX,
+				       tb[P4TC_TABLE_DEFAULT_HIT],
+				       p4tc_table_default_policy, extack);
+		if (ret < 0)
+			return ret;
+
+		if (!tb_default[P4TC_TABLE_DEFAULT_ACTION] &&
+		    !tb_default[P4TC_TABLE_DEFAULT_PERMISSIONS])
+			return 0;
+
+		ret = tcf_table_init_default_act(net, tb_default,
+						 default_hitact,
+						 table->common.p_id, permissions,
+						 extack);
+		if (ret < 0)
+			return ret;
+		if (!tcf_table_check_defacts((*default_hitact)->default_acts[0],
+					     acts_list)) {
+			ret = -EPERM;
+			NL_SET_ERR_MSG(extack,
+				       "Action is not allowed as default hit action");
+			goto default_hitacts_free;
+		}
+	}
+
+	if (tb[P4TC_TABLE_DEFAULT_MISS]) {
+		struct p4tc_table_defact *defact;
+
+		rcu_read_lock();
+		defact = rcu_dereference(table->tbl_default_missact);
+		if (defact)
+			permissions = defact->permissions;
+		rcu_read_unlock();
+
+		ret = nla_parse_nested(tb_default, P4TC_TABLE_DEFAULT_MAX,
+				       tb[P4TC_TABLE_DEFAULT_MISS],
+				       p4tc_table_default_policy, extack);
+		if (ret < 0)
+			goto default_hitacts_free;
+
+		if (!tb_default[P4TC_TABLE_DEFAULT_ACTION] &&
+		    !tb_default[P4TC_TABLE_DEFAULT_PERMISSIONS])
+			return 0;
+
+		ret = tcf_table_init_default_act(net, tb_default,
+						 default_missact,
+						 table->common.p_id, permissions,
+						 extack);
+		if (ret < 0)
+			goto default_hitacts_free;
+		if (!tcf_table_check_defacts((*default_missact)->default_acts[0],
+					     acts_list)) {
+			ret = -EPERM;
+			NL_SET_ERR_MSG(extack,
+				       "Action is not allowed as default miss action");
+			goto default_missact_free;
+		}
+	}
+
+	return 0;
+
+default_missact_free:
+	p4tc_table_defact_destroy(*default_missact);
+
+default_hitacts_free:
+	p4tc_table_defact_destroy(*default_hitact);
+
+	return ret;
+}
+
+static const struct nla_policy p4tc_acts_list_policy[P4TC_TABLE_MAX + 1] = {
+	[P4TC_TABLE_ACT_FLAGS] =
+		NLA_POLICY_RANGE(NLA_U8, 0, BIT(P4TC_TABLE_ACTS_FLAGS_MAX)),
+	[P4TC_TABLE_ACT_NAME] = { .type = NLA_STRING, .len = ACTNAMSIZ },
+};
+
+static struct p4tc_table_act *tcf_table_act_init(struct nlattr *nla,
+						 struct p4tc_pipeline *pipeline,
+						 struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[P4TC_TABLE_ACT_MAX + 1];
+	struct p4tc_table_act *table_act;
+	int ret;
+
+	ret = nla_parse_nested(tb, P4TC_TABLE_ACT_MAX, nla,
+			       p4tc_acts_list_policy, extack);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	table_act = kzalloc(sizeof(*table_act), GFP_KERNEL);
+	if (!table_act)
+		return ERR_PTR(-ENOMEM);
+
+	if (tb[P4TC_TABLE_ACT_NAME]) {
+		const char *actname = nla_data(tb[P4TC_TABLE_ACT_NAME]);
+		char *act_name_clone, *act_name, *p_name;
+		struct p4tc_act *act;
+
+		act_name_clone = act_name = kstrdup(actname, GFP_KERNEL);
+		if (!act_name) {
+			ret = -ENOMEM;
+			goto free_table_act;
+		}
+
+		p_name = strsep(&act_name, "/");
+		act = tcf_action_find_byname(act_name, pipeline);
+		if (!act) {
+			NL_SET_ERR_MSG_FMT(extack,
+					   "Unable to find action %s/%s",
+					   p_name, act_name);
+			ret = -ENOENT;
+			kfree(act_name_clone);
+			goto free_table_act;
+		}
+
+		kfree(act_name_clone);
+
+		table_act->ops = &act->ops;
+		WARN_ON(!refcount_inc_not_zero(&act->a_ref));
+	} else {
+		NL_SET_ERR_MSG(extack,
+			       "Must specify allowed table action name");
+		ret = -EINVAL;
+		goto free_table_act;
+	}
+
+	if (tb[P4TC_TABLE_ACT_FLAGS]) {
+		u8 *flags = nla_data(tb[P4TC_TABLE_ACT_FLAGS]);
+
+		table_act->flags = *flags;
+	}
+
+	return table_act;
+
+free_table_act:
+	kfree(table_act);
+	return ERR_PTR(ret);
+}
+
+static int tcf_table_acts_list_init(struct nlattr *nla,
+				    struct p4tc_pipeline *pipeline,
+				    struct list_head *acts_list,
+				    struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[P4TC_MSGBATCH_SIZE + 1];
+	struct p4tc_table_act *table_act;
+	int ret;
+	int i;
+
+	ret = nla_parse_nested(tb, P4TC_MSGBATCH_SIZE, nla, NULL, extack);
+	if (ret < 0)
+		return ret;
+
+	for (i = 1; i < P4TC_MSGBATCH_SIZE + 1 && tb[i]; i++) {
+		table_act = tcf_table_act_init(tb[i], pipeline, extack);
+		if (IS_ERR(table_act)) {
+			ret = PTR_ERR(table_act);
+			goto free_acts_list_list;
+		}
+		list_add_tail(&table_act->node, acts_list);
+	}
+
+	return 0;
+
+free_acts_list_list:
+	tcf_table_acts_list_destroy(acts_list);
+
+	return ret;
+}
+
+static struct p4tc_table *
+tcf_table_find_byanyattr(struct p4tc_pipeline *pipeline,
+			 struct nlattr *name_attr, const u32 tbl_id,
+			 struct netlink_ext_ack *extack)
+{
+	char *tblname = NULL;
+
+	if (name_attr)
+		tblname = nla_data(name_attr);
+
+	return tcf_table_find_byany(pipeline, tblname, tbl_id, extack);
+}
+
+static struct p4tc_table *tcf_table_create(struct net *net, struct nlattr **tb,
+					   u32 tbl_id,
+					   struct p4tc_pipeline *pipeline,
+					   struct netlink_ext_ack *extack)
+{
+	struct p4tc_table_key *key = NULL;
+	struct p4tc_table_parm *parm;
+	struct p4tc_table *table;
+	char *tblname;
+	int ret;
+
+	if (pipeline->curr_tables == pipeline->num_tables) {
+		NL_SET_ERR_MSG(extack,
+			       "Table range exceeded max allowed value");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, P4TC_TABLE_NAME)) {
+		NL_SET_ERR_MSG(extack, "Must specify table name");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	tblname =
+		strnchr(nla_data(tb[P4TC_TABLE_NAME]), TABLENAMSIZ, SEPARATOR);
+	if (!tblname) {
+		NL_SET_ERR_MSG(extack, "Table name must contain control block");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	tblname += 1;
+	if (tblname[0] == '\0') {
+		NL_SET_ERR_MSG(extack, "Control block name is too big");
+		ret = -EINVAL;
+		goto out;
+	}
+
+	table = tcf_table_find_byanyattr(pipeline, tb[P4TC_TABLE_NAME], tbl_id,
+					 NULL);
+	if (!IS_ERR(table)) {
+		NL_SET_ERR_MSG(extack, "Table already exists");
+		ret = -EEXIST;
+		goto out;
+	}
+
+	table = kzalloc(sizeof(*table), GFP_KERNEL);
+	if (!table) {
+		NL_SET_ERR_MSG(extack, "Unable to create table");
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	table->common.p_id = pipeline->common.p_id;
+	strscpy(table->common.name, nla_data(tb[P4TC_TABLE_NAME]), TABLENAMSIZ);
+
+	if (NL_REQ_ATTR_CHECK(extack, NULL, tb, P4TC_TABLE_INFO)) {
+		ret = -EINVAL;
+		NL_SET_ERR_MSG(extack, "Missing table info");
+		goto free;
+	}
+	parm = nla_data(tb[P4TC_TABLE_INFO]);
+
+	if (parm->tbl_flags & P4TC_TABLE_FLAGS_KEYSZ) {
+		if (!parm->tbl_keysz) {
+			NL_SET_ERR_MSG(extack, "Table keysz cannot be zero");
+			ret = -EINVAL;
+			goto free;
+		}
+		if (parm->tbl_keysz > P4TC_MAX_KEYSZ) {
+			NL_SET_ERR_MSG(extack,
+				       "Table keysz exceeds maximum keysz");
+			ret = -EINVAL;
+			goto free;
+		}
+		table->tbl_keysz = parm->tbl_keysz;
+	} else {
+		NL_SET_ERR_MSG(extack, "Must specify table key size");
+		ret = -EINVAL;
+		goto free;
+	}
+
+	if (parm->tbl_flags & P4TC_TABLE_FLAGS_MAX_ENTRIES) {
+		if (!parm->tbl_max_entries) {
+			NL_SET_ERR_MSG(extack,
+				       "Table max_entries cannot be zero");
+			ret = -EINVAL;
+			goto free;
+		}
+		if (parm->tbl_max_entries > P4TC_MAX_TENTRIES) {
+			NL_SET_ERR_MSG(extack,
+				       "Table max_entries exceeds maximum value");
+			ret = -EINVAL;
+			goto free;
+		}
+		table->tbl_max_entries = parm->tbl_max_entries;
+	} else {
+		table->tbl_max_entries = P4TC_DEFAULT_TENTRIES;
+	}
+
+	if (parm->tbl_flags & P4TC_TABLE_FLAGS_MAX_MASKS) {
+		if (!parm->tbl_max_masks) {
+			NL_SET_ERR_MSG(extack,
+				       "Table max_masks cannot be zero");
+			ret = -EINVAL;
+			goto free;
+		}
+		if (parm->tbl_max_masks > P4TC_MAX_TMASKS) {
+			NL_SET_ERR_MSG(extack,
+				       "Table max_masks exceeds maximum value");
+			ret = -EINVAL;
+			goto free;
+		}
+		table->tbl_max_masks = parm->tbl_max_masks;
+	} else {
+		table->tbl_max_masks = P4TC_DEFAULT_TMASKS;
+	}
+
+	if (parm->tbl_flags & P4TC_TABLE_FLAGS_PERMISSIONS) {
+		if (parm->tbl_permissions > P4TC_MAX_PERMISSION) {
+			NL_SET_ERR_MSG(extack,
+				       "Permission may only have 10 bits turned on");
+			ret = -EINVAL;
+			goto free;
+		}
+		if (!p4tc_data_exec_ok(parm->tbl_permissions)) {
+			NL_SET_ERR_MSG(extack,
+				       "Table must have execute permissions");
+			ret = -EINVAL;
+			goto free;
+		}
+		if (!p4tc_data_read_ok(parm->tbl_permissions)) {
+			NL_SET_ERR_MSG(extack,
+				       "Data path read permissions must be set");
+			ret = -EINVAL;
+			goto free;
+		}
+		table->tbl_permissions =
+			kzalloc(sizeof(*table->tbl_permissions), GFP_KERNEL);
+		if (!table->tbl_permissions) {
+			ret = -ENOMEM;
+			goto free;
+		}
+		table->tbl_permissions->permissions = parm->tbl_permissions;
+	} else {
+		table->tbl_permissions =
+			kzalloc(sizeof(*table->tbl_permissions), GFP_KERNEL);
+		if (!table->tbl_permissions) {
+			ret = -ENOMEM;
+			goto free;
+		}
+		table->tbl_permissions->permissions = P4TC_TABLE_PERMISSIONS;
+	}
+
+	if (parm->tbl_flags & P4TC_TABLE_FLAGS_TYPE) {
+		if (parm->tbl_type > P4TC_TABLE_TYPE_MAX) {
+			NL_SET_ERR_MSG(extack, "Table type can only be exact or LPM");
+			ret = -EINVAL;
+			goto free_permissions;
+		}
+		table->tbl_type = parm->tbl_type;
+	} else {
+		table->tbl_type = P4TC_TABLE_TYPE_EXACT;
+	}
+
+	refcount_set(&table->tbl_ref, 1);
+	refcount_set(&table->tbl_ctrl_ref, 1);
+
+	if (tbl_id) {
+		table->tbl_id = tbl_id;
+		ret = idr_alloc_u32(&pipeline->p_tbl_idr, table, &table->tbl_id,
+				    table->tbl_id, GFP_KERNEL);
+		if (ret < 0) {
+			NL_SET_ERR_MSG(extack, "Unable to allocate table id");
+			goto free_permissions;
+		}
+	} else {
+		table->tbl_id = 1;
+		ret = idr_alloc_u32(&pipeline->p_tbl_idr, table, &table->tbl_id,
+				    UINT_MAX, GFP_KERNEL);
+		if (ret < 0) {
+			NL_SET_ERR_MSG(extack, "Unable to allocate table id");
+			goto free_permissions;
+		}
+	}
+
+	INIT_LIST_HEAD(&table->tbl_acts_list);
+	if (tb[P4TC_TABLE_ACTS_LIST]) {
+		ret = tcf_table_acts_list_init(tb[P4TC_TABLE_ACTS_LIST],
+					       pipeline, &table->tbl_acts_list,
+					       extack);
+		if (ret < 0)
+			goto idr_rm;
+	}
+
+	if (tb[P4TC_TABLE_PREACTIONS]) {
+		table->tbl_preacts = kcalloc(TCA_ACT_MAX_PRIO,
+					     sizeof(struct tc_action *),
+					     GFP_KERNEL);
+		if (!table->tbl_preacts) {
+			ret = -ENOMEM;
+			goto table_acts_destroy;
+		}
+
+		ret = p4tc_action_init(net, tb[P4TC_TABLE_PREACTIONS],
+				       table->tbl_preacts, table->common.p_id,
+				       0, extack);
+		if (ret < 0) {
+			kfree(table->tbl_preacts);
+			goto table_acts_destroy;
+		}
+		table->tbl_num_preacts = ret;
+	} else {
+		table->tbl_preacts = NULL;
+	}
+
+	if (tb[P4TC_TABLE_POSTACTIONS]) {
+		table->tbl_postacts = kcalloc(TCA_ACT_MAX_PRIO,
+					      sizeof(struct tc_action *),
+					      GFP_KERNEL);
+		if (!table->tbl_postacts) {
+			ret = -ENOMEM;
+			goto preactions_destroy;
+		}
+
+		ret = p4tc_action_init(net, tb[P4TC_TABLE_POSTACTIONS],
+				       table->tbl_postacts, table->common.p_id,
+				       0, extack);
+		if (ret < 0) {
+			kfree(table->tbl_postacts);
+			goto preactions_destroy;
+		}
+		table->tbl_num_postacts = ret;
+	} else {
+		table->tbl_postacts = NULL;
+		table->tbl_num_postacts = 0;
+	}
+
+	if (tb[P4TC_TABLE_KEY]) {
+		key = tcf_table_key_add(net, table, tb[P4TC_TABLE_KEY], extack);
+		if (IS_ERR(key)) {
+			ret = PTR_ERR(key);
+			goto postacts_destroy;
+		}
+	}
+
+	ret = tcf_table_init_default_acts(net, tb, table,
+					  &table->tbl_default_hitact,
+					  &table->tbl_default_missact,
+					  &table->tbl_acts_list, extack);
+	if (ret < 0)
+		goto key_put;
+
+	table->tbl_curr_used_entries = 0;
+	table->tbl_curr_count = 0;
+
+	refcount_set(&table->tbl_entries_ref, 1);
+
+	idr_init(&table->tbl_masks_idr);
+	idr_init(&table->tbl_prio_idr);
+	spin_lock_init(&table->tbl_masks_idr_lock);
+	spin_lock_init(&table->tbl_prio_idr_lock);
+
+	table->tbl_key = key;
+
+	pipeline->curr_tables += 1;
+
+	table->common.ops = (struct p4tc_template_ops *)&p4tc_table_ops;
+
+	return table;
+
+key_put:
+	if (key)
+		tcf_table_key_put(key);
+
+postacts_destroy:
+	p4tc_action_destroy(table->tbl_postacts);
+
+preactions_destroy:
+	p4tc_action_destroy(table->tbl_preacts);
+
+idr_rm:
+	idr_remove(&pipeline->p_tbl_idr, table->tbl_id);
+
+free_permissions:
+	kfree(table->tbl_permissions);
+
+table_acts_destroy:
+	tcf_table_acts_list_destroy(&table->tbl_acts_list);
+
+free:
+	kfree(table);
+
+out:
+	return ERR_PTR(ret);
+}
+
+static struct p4tc_table *tcf_table_update(struct net *net, struct nlattr **tb,
+					   u32 tbl_id,
+					   struct p4tc_pipeline *pipeline,
+					   u32 flags,
+					   struct netlink_ext_ack *extack)
+{
+	struct p4tc_table_key *key = NULL;
+	int num_postacts = 0, num_preacts = 0;
+	struct p4tc_table_defact *default_hitact = NULL;
+	struct p4tc_table_defact *default_missact = NULL;
+	struct list_head *tbl_acts_list = NULL;
+	struct p4tc_table_perm *perm = NULL;
+	struct p4tc_table_parm *parm = NULL;
+	struct tc_action **postacts = NULL;
+	struct tc_action **preacts = NULL;
+	int ret = 0;
+	struct p4tc_table *table;
+
+	table = tcf_table_find_byanyattr(pipeline, tb[P4TC_TABLE_NAME], tbl_id,
+					 extack);
+	if (IS_ERR(table))
+		return table;
+
+	if (tb[P4TC_TABLE_ACTS_LIST]) {
+		tbl_acts_list = kzalloc(sizeof(*tbl_acts_list), GFP_KERNEL);
+		if (!tbl_acts_list) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		INIT_LIST_HEAD(tbl_acts_list);
+		ret = tcf_table_acts_list_init(tb[P4TC_TABLE_ACTS_LIST],
+					       pipeline, tbl_acts_list, extack);
+		if (ret < 0)
+			goto table_acts_destroy;
+	}
+
+	if (tb[P4TC_TABLE_PREACTIONS]) {
+		preacts = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
+				  GFP_KERNEL);
+		if (!preacts) {
+			ret = -ENOMEM;
+			goto table_acts_destroy;
+		}
+
+		ret = p4tc_action_init(net, tb[P4TC_TABLE_PREACTIONS], preacts,
+				       table->common.p_id, 0, extack);
+		if (ret < 0) {
+			kfree(preacts);
+			goto table_acts_destroy;
+		}
+		num_preacts = ret;
+	}
+
+	if (tb[P4TC_TABLE_POSTACTIONS]) {
+		postacts = kcalloc(TCA_ACT_MAX_PRIO, sizeof(struct tc_action *),
+				   GFP_KERNEL);
+		if (!postacts) {
+			ret = -ENOMEM;
+			goto preactions_destroy;
+		}
+
+		ret = p4tc_action_init(net, tb[P4TC_TABLE_POSTACTIONS],
+				       postacts, table->common.p_id, 0, extack);
+		if (ret < 0) {
+			kfree(postacts);
+			goto preactions_destroy;
+		}
+		num_postacts = ret;
+	}
+
+	if (tbl_acts_list)
+		ret = tcf_table_init_default_acts(net, tb, table,
+						  &default_hitact,
+						  &default_missact,
+						  tbl_acts_list, extack);
+	else
+		ret = tcf_table_init_default_acts(net, tb, table,
+						  &default_hitact,
+						  &default_missact,
+						  &table->tbl_acts_list,
+						  extack);
+	if (ret < 0)
+		goto postactions_destroy;
+
+	if (tb[P4TC_TABLE_KEY]) {
+		key = tcf_table_key_add(net, table, tb[P4TC_TABLE_KEY], extack);
+		if (IS_ERR(key)) {
+			ret = PTR_ERR(key);
+			goto defaultacts_destroy;
+		}
+	}
+
+	if (tb[P4TC_TABLE_INFO]) {
+		parm = nla_data(tb[P4TC_TABLE_INFO]);
+		if (parm->tbl_flags & P4TC_TABLE_FLAGS_KEYSZ) {
+			if (!parm->tbl_keysz) {
+				NL_SET_ERR_MSG(extack,
+					       "Table keysz cannot be zero");
+				ret = -EINVAL;
+				goto key_destroy;
+			}
+			if (parm->tbl_keysz > P4TC_MAX_KEYSZ) {
+				NL_SET_ERR_MSG(extack,
+					       "Table keysz exceeds maximum keysz");
+				ret = -EINVAL;
+				goto key_destroy;
+			}
+			table->tbl_keysz = parm->tbl_keysz;
+		}
+
+		if (parm->tbl_flags & P4TC_TABLE_FLAGS_MAX_ENTRIES) {
+			if (!parm->tbl_max_entries) {
+				NL_SET_ERR_MSG(extack,
+					       "Table max_entries cannot be zero");
+				ret = -EINVAL;
+				goto key_destroy;
+			}
+			if (parm->tbl_max_entries > P4TC_MAX_TENTRIES) {
+				NL_SET_ERR_MSG(extack,
+					       "Table max_entries exceeds maximum value");
+				ret = -EINVAL;
+				goto key_destroy;
+			}
+			table->tbl_max_entries = parm->tbl_max_entries;
+		}
+
+		if (parm->tbl_flags & P4TC_TABLE_FLAGS_MAX_MASKS) {
+			if (!parm->tbl_max_masks) {
+				NL_SET_ERR_MSG(extack,
+					       "Table max_masks cannot be zero");
+				ret = -EINVAL;
+				goto key_destroy;
+			}
+			if (parm->tbl_max_masks > P4TC_MAX_TMASKS) {
+				NL_SET_ERR_MSG(extack,
+					       "Table max_masks exceeds maximum value");
+				ret = -EINVAL;
+				goto key_destroy;
+			}
+			table->tbl_max_masks = parm->tbl_max_masks;
+		}
+		if (parm->tbl_flags & P4TC_TABLE_FLAGS_PERMISSIONS) {
+			if (parm->tbl_permissions > P4TC_MAX_PERMISSION) {
+				NL_SET_ERR_MSG(extack,
+					       "Permission may only have 10 bits turned on");
+				ret = -EINVAL;
+				goto key_destroy;
+			}
+			if (!p4tc_data_exec_ok(parm->tbl_permissions)) {
+				NL_SET_ERR_MSG(extack,
+					       "Table must have execute permissions");
+				ret = -EINVAL;
+				goto key_destroy;
+			}
+			if (!p4tc_data_read_ok(parm->tbl_permissions)) {
+				NL_SET_ERR_MSG(extack,
+					       "Data path read permissions must be set");
+				ret = -EINVAL;
+				goto key_destroy;
+			}
+
+			perm = kzalloc(sizeof(*perm), GFP_KERNEL);
+			if (!perm) {
+				ret = -ENOMEM;
+				goto key_destroy;
+			}
+			perm->permissions = parm->tbl_permissions;
+		}
+
+		if (parm->tbl_flags & P4TC_TABLE_FLAGS_TYPE) {
+			if (parm->tbl_type > P4TC_TABLE_TYPE_MAX) {
+				NL_SET_ERR_MSG(extack, "Table type can only be exact or LPM");
+				ret = -EINVAL;
+				goto key_destroy;
+			}
+			table->tbl_type = parm->tbl_type;
+		}
+	}
+
+	if (preacts) {
+		p4tc_action_destroy(table->tbl_preacts);
+		table->tbl_preacts = preacts;
+		table->tbl_num_preacts = num_preacts;
+	}
+
+	if (postacts) {
+		p4tc_action_destroy(table->tbl_postacts);
+		table->tbl_postacts = postacts;
+		table->tbl_num_postacts = num_postacts;
+	}
+
+	if (default_hitact) {
+		struct p4tc_table_defact *hitact;
+
+		hitact = rcu_replace_pointer_rtnl(table->tbl_default_hitact,
+						  default_hitact);
+		if (hitact) {
+			synchronize_rcu();
+			p4tc_table_defact_destroy(hitact);
+		}
+	}
+
+	if (default_missact) {
+		struct p4tc_table_defact *missact;
+
+		missact = rcu_replace_pointer_rtnl(table->tbl_default_missact,
+						   default_missact);
+		if (missact) {
+			synchronize_rcu();
+			p4tc_table_defact_destroy(missact);
+		}
+	}
+
+	if (key) {
+		if (table->tbl_key)
+			tcf_table_key_put(table->tbl_key);
+		table->tbl_key = key;
+	}
+
+	if (perm) {
+		perm = rcu_replace_pointer_rtnl(table->tbl_permissions, perm);
+		kfree_rcu(perm, rcu);
+	}
+
+	return table;
+
+key_destroy:
+	if (key)
+		tcf_table_key_put(key);
+
+defaultacts_destroy:
+	p4tc_table_defact_destroy(default_missact);
+	p4tc_table_defact_destroy(default_hitact);
+
+postactions_destroy:
+	p4tc_action_destroy(postacts);
+
+preactions_destroy:
+	p4tc_action_destroy(preacts);
+
+table_acts_destroy:
+	if (tbl_acts_list) {
+		tcf_table_acts_list_destroy(tbl_acts_list);
+		kfree(tbl_acts_list);
+	}
+
+out:
+	return ERR_PTR(ret);
+}
+
+static bool tcf_table_check_runtime_update(struct nlmsghdr *n,
+					   struct nlattr **tb)
+{
+	int i;
+
+	if (n->nlmsg_type == RTM_CREATEP4TEMPLATE &&
+	    !(n->nlmsg_flags & NLM_F_REPLACE))
+		return false;
+
+	if (tb[P4TC_TABLE_INFO]) {
+		struct p4tc_table_parm *info;
+
+		info = nla_data(tb[P4TC_TABLE_INFO]);
+		if ((info->tbl_flags & ~P4TC_TABLE_FLAGS_PERMISSIONS) ||
+		    !(info->tbl_flags & P4TC_TABLE_FLAGS_PERMISSIONS))
+			return false;
+	}
+
+	for (i = P4TC_TABLE_PREACTIONS; i < P4TC_TABLE_MAX; i++) {
+		if (i != P4TC_TABLE_DEFAULT_HIT &&
+		    i != P4TC_TABLE_DEFAULT_MISS && tb[i])
+			return false;
+	}
+
+	return true;
+}
+
+static struct p4tc_template_common *
+tcf_table_cu(struct net *net, struct nlmsghdr *n, struct nlattr *nla,
+	     struct p4tc_nl_pname *nl_pname, u32 *ids,
+	     struct netlink_ext_ack *extack)
+{
+	u32 pipeid = ids[P4TC_PID_IDX], tbl_id = ids[P4TC_TBLID_IDX];
+	struct nlattr *tb[P4TC_TABLE_MAX + 1];
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_table *table;
+	int ret;
+
+	pipeline = tcf_pipeline_find_byany(net, nl_pname->data, pipeid, extack);
+	if (IS_ERR(pipeline))
+		return (void *)pipeline;
+
+	ret = nla_parse_nested(tb, P4TC_TABLE_MAX, nla, p4tc_table_policy,
+			       extack);
+	if (ret < 0)
+		return ERR_PTR(ret);
+
+	if (pipeline_sealed(pipeline) &&
+	    !tcf_table_check_runtime_update(n, tb)) {
+		NL_SET_ERR_MSG(extack,
+			       "Only default action updates are allowed in sealed pipeline");
+		return ERR_PTR(-EINVAL);
+	}
+
+	if (n->nlmsg_flags & NLM_F_REPLACE)
+		table = tcf_table_update(net, tb, tbl_id, pipeline,
+					 n->nlmsg_flags, extack);
+	else
+		table = tcf_table_create(net, tb, tbl_id, pipeline, extack);
+
+	if (IS_ERR(table))
+		goto out;
+
+	if (!nl_pname->passed)
+		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+	if (!ids[P4TC_TBLID_IDX])
+		ids[P4TC_TBLID_IDX] = table->tbl_id;
+
+out:
+	return (struct p4tc_template_common *)table;
+}
+
+static int tcf_table_flush(struct net *net, struct sk_buff *skb,
+			   struct p4tc_pipeline *pipeline,
+			   struct netlink_ext_ack *extack)
+{
+	unsigned char *b = nlmsg_get_pos(skb);
+	struct p4tc_table *table;
+	unsigned long tmp, tbl_id;
+	int ret = 0;
+	int i = 0;
+
+	if (nla_put_u32(skb, P4TC_PATH, 0))
+		goto out_nlmsg_trim;
+
+	if (idr_is_empty(&pipeline->p_tbl_idr)) {
+		NL_SET_ERR_MSG(extack, "There are not tables to flush");
+		goto out_nlmsg_trim;
+	}
+
+	idr_for_each_entry_ul(&pipeline->p_tbl_idr, table, tmp, tbl_id) {
+		if (_tcf_table_put(net, NULL, pipeline, table, false, extack) < 0) {
+			ret = -EBUSY;
+			continue;
+		}
+		i++;
+	}
+
+	nla_put_u32(skb, P4TC_COUNT, i);
+
+	if (ret < 0) {
+		if (i == 0) {
+			NL_SET_ERR_MSG(extack, "Unable to flush any table");
+			goto out_nlmsg_trim;
+		} else {
+			NL_SET_ERR_MSG(extack, "Unable to flush all tables");
+		}
+	}
+
+	return i;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return ret;
+}
+
+static int tcf_table_gd(struct net *net, struct sk_buff *skb,
+			struct nlmsghdr *n, struct nlattr *nla,
+			struct p4tc_nl_pname *nl_pname, u32 *ids,
+			struct netlink_ext_ack *extack)
+{
+	u32 pipeid = ids[P4TC_PID_IDX], tbl_id = ids[P4TC_MID_IDX];
+	struct nlattr *tb[P4TC_TABLE_MAX + 1] = {};
+	unsigned char *b = nlmsg_get_pos(skb);
+	int ret = 0;
+	struct p4tc_pipeline *pipeline;
+	struct p4tc_table *table;
+
+	if (nla) {
+		ret = nla_parse_nested(tb, P4TC_TABLE_MAX, nla,
+				       p4tc_table_policy, extack);
+
+		if (ret < 0)
+			return ret;
+	}
+
+	if (n->nlmsg_type == RTM_GETP4TEMPLATE ||
+	    tcf_table_check_runtime_update(n, tb))
+		pipeline = tcf_pipeline_find_byany(net, nl_pname->data, pipeid,
+						   extack);
+	else
+		pipeline = tcf_pipeline_find_byany_unsealed(net, nl_pname->data,
+							    pipeid, extack);
+
+	if (IS_ERR(pipeline))
+		return PTR_ERR(pipeline);
+
+	if (!nl_pname->passed)
+		strscpy(nl_pname->data, pipeline->common.name, PIPELINENAMSIZ);
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE && (n->nlmsg_flags & NLM_F_ROOT))
+		return tcf_table_flush(net, skb, pipeline, extack);
+
+	table = tcf_table_find_byanyattr(pipeline, tb[P4TC_TABLE_NAME], tbl_id,
+					 extack);
+	if (IS_ERR(table))
+		return PTR_ERR(table);
+
+	if (_tcf_table_fill_nlmsg(skb, table) < 0) {
+		NL_SET_ERR_MSG(extack,
+			       "Failed to fill notification attributes for table");
+		return -EINVAL;
+	}
+
+	if (n->nlmsg_type == RTM_DELP4TEMPLATE) {
+		ret = _tcf_table_put(net, tb, pipeline, table, false, extack);
+		if (ret < 0)
+			goto out_nlmsg_trim;
+	}
+
+	return 0;
+
+out_nlmsg_trim:
+	nlmsg_trim(skb, b);
+	return ret;
+}
+
+static int tcf_table_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
+			  struct nlattr *nla, char **p_name, u32 *ids,
+			  struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct p4tc_pipeline *pipeline;
+
+	if (!ctx->ids[P4TC_PID_IDX]) {
+		pipeline = tcf_pipeline_find_byany(net, *p_name,
+						   ids[P4TC_PID_IDX], extack);
+		if (IS_ERR(pipeline))
+			return PTR_ERR(pipeline);
+		ctx->ids[P4TC_PID_IDX] = pipeline->common.p_id;
+	} else {
+		pipeline = tcf_pipeline_find_byid(net, ctx->ids[P4TC_PID_IDX]);
+	}
+
+	if (!ids[P4TC_PID_IDX])
+		ids[P4TC_PID_IDX] = pipeline->common.p_id;
+
+	if (!(*p_name))
+		*p_name = pipeline->common.name;
+
+	return tcf_p4_tmpl_generic_dump(skb, ctx, &pipeline->p_tbl_idr,
+					P4TC_TBLID_IDX, extack);
+}
+
+static int tcf_table_dump_1(struct sk_buff *skb,
+			    struct p4tc_template_common *common)
+{
+	struct p4tc_table *table = to_table(common);
+	struct nlattr *nest = nla_nest_start(skb, P4TC_PARAMS);
+
+	if (!nest)
+		return -ENOMEM;
+
+	if (nla_put_string(skb, P4TC_TABLE_NAME, table->common.name)) {
+		nla_nest_cancel(skb, nest);
+		return -ENOMEM;
+	}
+
+	nla_nest_end(skb, nest);
+
+	return 0;
+}
+
+const struct p4tc_template_ops p4tc_table_ops = {
+	.init = NULL,
+	.cu = tcf_table_cu,
+	.fill_nlmsg = tcf_table_fill_nlmsg,
+	.gd = tcf_table_gd,
+	.put = tcf_table_put,
+	.dump = tcf_table_dump,
+	.dump_1 = tcf_table_dump_1,
+};
diff --git a/net/sched/p4tc/p4tc_tmpl_api.c b/net/sched/p4tc/p4tc_tmpl_api.c
index c294dc0789f0..e5be7db054dd 100644
--- a/net/sched/p4tc/p4tc_tmpl_api.c
+++ b/net/sched/p4tc/p4tc_tmpl_api.c
@@ -45,6 +45,7 @@ static bool obj_is_valid(u32 obj)
 	case P4TC_OBJ_META:
 	case P4TC_OBJ_HDR_FIELD:
 	case P4TC_OBJ_ACT:
+	case P4TC_OBJ_TABLE:
 		return true;
 	default:
 		return false;
@@ -56,6 +57,7 @@ static const struct p4tc_template_ops *p4tc_ops[P4TC_OBJ_MAX] = {
 	[P4TC_OBJ_META] = &p4tc_meta_ops,
 	[P4TC_OBJ_HDR_FIELD] = &p4tc_hdrfield_ops,
 	[P4TC_OBJ_ACT] = &p4tc_act_ops,
+	[P4TC_OBJ_TABLE] = &p4tc_table_ops,
 };
 
 int tcf_p4_tmpl_generic_dump(struct sk_buff *skb, struct p4tc_dump_ctx *ctx,
-- 
2.25.1


