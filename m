Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB73A52D689
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 16:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240037AbiESO5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 10:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234807AbiESO5o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 10:57:44 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC134AE20;
        Thu, 19 May 2022 07:57:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1652972263; x=1684508263;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2Yd661P2byo+FyiocWCVEEPcL6Bcbu0O87L4kC3aK1w=;
  b=CDql09mWdtJhQlj8sFdW6Q+/tezfmHRuqf8mm7M3XgVuF3CG72QALjRL
   yqqR+aUQlzKj4AnTrq9cLDjFwcZ7Ej/pVmi3SV/UCXJA7G3tMbBFy7591
   6Us0mZ7DSdJps6INw5KLLiENbb+DMnL293QL1gL29RlMSQ4FToupHtCMh
   3kCZjt3bkKrtTTzDh1fjXY01U6FcqUQhdojmKn2MQb5fgd15IO7iaGQXV
   Mjm2QilZ675upsuNzCCSbPotUVSbF2nil8zmknA+dwRRFPEQEGQTG4z52
   MJy41NLothuGG1lpVu9WeT8TeO8TLCjsd9513RTxnZ4ZyvhwdNUrkCngH
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10352"; a="271934595"
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="271934595"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 May 2022 07:57:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,237,1647327600"; 
   d="scan'208";a="701197066"
Received: from lkp-server02.sh.intel.com (HELO 242b25809ac7) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 19 May 2022 07:57:41 -0700
Received: from kbuild by 242b25809ac7 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nrhau-0003ev-BJ;
        Thu, 19 May 2022 14:57:40 +0000
Date:   Thu, 19 May 2022 22:57:24 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org,
        Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next v7 05/11] bpf: implement BPF_PROG_QUERY for
 BPF_LSM_CGROUP
Message-ID: <202205192210.FPl5GoFS-lkp@intel.com>
References: <20220518225531.558008-6-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518225531.558008-6-sdf@google.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stanislav,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220519-065944
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: hexagon-randconfig-r035-20220519 (https://download.01.org/0day-ci/archive/20220519/202205192210.FPl5GoFS-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project e00cbbec06c08dc616a0d52a20f678b8fbd4e304)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/f3b115441e4b11ef3e65cad30e1c8fb7a2becfab
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220519-065944
        git checkout f3b115441e4b11ef3e65cad30e1c8fb7a2becfab
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash kernel/bpf/ lib/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> kernel/bpf/cgroup.c:1091:16: error: use of undeclared identifier 'CGROUP_LSM_START'
                   from_atype = CGROUP_LSM_START;
                                ^
>> kernel/bpf/cgroup.c:1092:14: error: use of undeclared identifier 'CGROUP_LSM_END'
                   to_atype = CGROUP_LSM_END;
                              ^
   2 errors generated.


vim +/CGROUP_LSM_START +1091 kernel/bpf/cgroup.c

  1072	
  1073	/* Must be called with cgroup_mutex held to avoid races. */
  1074	static int __cgroup_bpf_query(struct cgroup *cgrp, const union bpf_attr *attr,
  1075				      union bpf_attr __user *uattr)
  1076	{
  1077		__u32 __user *prog_attach_flags = u64_to_user_ptr(attr->query.prog_attach_flags);
  1078		__u32 __user *prog_ids = u64_to_user_ptr(attr->query.prog_ids);
  1079		enum bpf_attach_type type = attr->query.attach_type;
  1080		enum cgroup_bpf_attach_type atype;
  1081		struct bpf_prog_array *effective;
  1082		struct hlist_head *progs;
  1083		struct bpf_prog *prog;
  1084		int cnt, ret = 0, i;
  1085		int total_cnt = 0;
  1086		u32 flags;
  1087	
  1088		enum cgroup_bpf_attach_type from_atype, to_atype;
  1089	
  1090		if (type == BPF_LSM_CGROUP) {
> 1091			from_atype = CGROUP_LSM_START;
> 1092			to_atype = CGROUP_LSM_END;
  1093		} else {
  1094			from_atype = to_cgroup_bpf_attach_type(type);
  1095			if (from_atype < 0)
  1096				return -EINVAL;
  1097			to_atype = from_atype;
  1098		}
  1099	
  1100		for (atype = from_atype; atype <= to_atype; atype++) {
  1101			progs = &cgrp->bpf.progs[atype];
  1102			flags = cgrp->bpf.flags[atype];
  1103	
  1104			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
  1105							      lockdep_is_held(&cgroup_mutex));
  1106	
  1107			if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
  1108				total_cnt += bpf_prog_array_length(effective);
  1109			else
  1110				total_cnt += prog_list_length(progs);
  1111		}
  1112	
  1113		if (type != BPF_LSM_CGROUP)
  1114			if (copy_to_user(&uattr->query.attach_flags, &flags, sizeof(flags)))
  1115				return -EFAULT;
  1116		if (copy_to_user(&uattr->query.prog_cnt, &total_cnt, sizeof(total_cnt)))
  1117			return -EFAULT;
  1118		if (attr->query.prog_cnt == 0 || !prog_ids || !total_cnt)
  1119			/* return early if user requested only program count + flags */
  1120			return 0;
  1121	
  1122		if (attr->query.prog_cnt < total_cnt) {
  1123			total_cnt = attr->query.prog_cnt;
  1124			ret = -ENOSPC;
  1125		}
  1126	
  1127		for (atype = from_atype; atype <= to_atype; atype++) {
  1128			if (total_cnt <= 0)
  1129				break;
  1130	
  1131			progs = &cgrp->bpf.progs[atype];
  1132			flags = cgrp->bpf.flags[atype];
  1133	
  1134			effective = rcu_dereference_protected(cgrp->bpf.effective[atype],
  1135							      lockdep_is_held(&cgroup_mutex));
  1136	
  1137			if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE)
  1138				cnt = bpf_prog_array_length(effective);
  1139			else
  1140				cnt = prog_list_length(progs);
  1141	
  1142			if (cnt >= total_cnt)
  1143				cnt = total_cnt;
  1144	
  1145			if (attr->query.query_flags & BPF_F_QUERY_EFFECTIVE) {
  1146				ret = bpf_prog_array_copy_to_user(effective, prog_ids, cnt);
  1147			} else {
  1148				struct bpf_prog_list *pl;
  1149				u32 id;
  1150	
  1151				i = 0;
  1152				hlist_for_each_entry(pl, progs, node) {
  1153					prog = prog_list_prog(pl);
  1154					id = prog->aux->id;
  1155					if (copy_to_user(prog_ids + i, &id, sizeof(id)))
  1156						return -EFAULT;
  1157					if (++i == cnt)
  1158						break;
  1159				}
  1160			}
  1161	
  1162			if (prog_attach_flags)
  1163				for (i = 0; i < cnt; i++)
  1164					if (copy_to_user(prog_attach_flags + i, &flags, sizeof(flags)))
  1165						return -EFAULT;
  1166	
  1167			prog_ids += cnt;
  1168			total_cnt -= cnt;
  1169			if (prog_attach_flags)
  1170				prog_attach_flags += cnt;
  1171		}
  1172		return ret;
  1173	}
  1174	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
