Return-Path: <netdev+bounces-11642-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60E97733CCA
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 01:18:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DDC832818CA
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 23:18:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 001488C15;
	Fri, 16 Jun 2023 23:18:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E021F398
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 23:18:47 +0000 (UTC)
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38A573C0B
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 16:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686957522; x=1718493522;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=PV96+HHUNiLvjTQMCkf7wf2kNRbcqE8qcqh3TSeya8w=;
  b=QQ3a1/occTqEAK2UJalMjzxexwRss3vu99hGE1F2ah5ZxFfDVEg93H55
   CCcBYz6h1NAVVQntsnBNGBm9VvK11teR4nfGGy2/P2DVhQ5/dDuvnZqqo
   6t4HfjV/4qfUB2cZEYn5lBRcc98yXHxQC3bogiYXw68qSYEXtkIaEtXML
   L/Up2iwO8q25U6M1HkqUeGVmDu7X9oIX38PfKizIxb0+FxRvbIY98ccz8
   lCk5HoKWZUjIPyFwdliYJngT7OKD3dZw3NrBSJp6KEZWfLOs/THIGiiVA
   hPU+QRKzXP5wvRyaTuxrsxJ9kdK6WAZhTJhpom4LNfBvoNVXFI49PD0qm
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="388164855"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="388164855"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2023 16:18:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10743"; a="742820521"
X-IronPort-AV: E=Sophos;i="6.00,248,1681196400"; 
   d="scan'208";a="742820521"
Received: from anguy11-upstream.jf.intel.com ([10.166.9.133])
  by orsmga008.jf.intel.com with ESMTP; 16 Jun 2023 16:18:26 -0700
From: Tony Nguyen <anthony.l.nguyen@intel.com>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com,
	edumazet@google.com,
	netdev@vger.kernel.org
Cc: Tony Nguyen <anthony.l.nguyen@intel.com>,
	pavan.kumar.linga@intel.com,
	emil.s.tantilov@intel.com,
	jesse.brandeburg@intel.com,
	sridhar.samudrala@intel.com,
	shiraz.saleem@intel.com,
	sindhu.devale@intel.com,
	willemb@google.com,
	decot@google.com,
	andrew@lunn.ch,
	leon@kernel.org,
	mst@redhat.com,
	simon.horman@corigine.com,
	shannon.nelson@amd.com,
	stephen@networkplumber.org
Subject: [PATCH net-next v3 00/15][pull request] Introduce Intel IDPF driver
Date: Fri, 16 Jun 2023 16:13:26 -0700
Message-Id: <20230616231341.2885622-1-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Pavan Kumar Linga says:

This patch series introduces the Intel Infrastructure Data Path Function
(IDPF) driver. It is used for both physical and virtual functions. Except
for some of the device operations the rest of the functionality is the
same for both PF and VF. IDPF uses virtchnl version2 opcodes and
structures defined in the virtchnl2 header file which helps the driver
to learn the capabilities and register offsets from the device
Control Plane (CP) instead of assuming the default values.

The format of the series follows the driver init flow to interface open.
To start with, probe gets called and kicks off the driver initialization
by spawning the 'vc_event_task' work queue which in turn calls the
'hard reset' function. As part of that, the mailbox is initialized which
is used to send/receive the virtchnl messages to/from the CP. Once that is
done, 'core init' kicks in which requests all the required global resources
from the CP and spawns the 'init_task' work queue to create the vports.

Based on the capability information received, the driver creates the said
number of vports (one or many) where each vport is associated to a netdev.
Also, each vport has its own resources such as queues, vectors etc.
From there, rest of the netdev_ops and data path are added.

IDPF implements both single queue which is traditional queueing model
as well as split queue model. In split queue model, it uses separate queue
for both completion descriptors and buffers which helps to implement
out-of-order completions. It also helps to implement asymmetric queues,
for example multiple RX completion queues can be processed by a single
RX buffer queue and multiple TX buffer queues can be processed by a
single TX completion queue. In single queue model, same queue is used
for both descriptor completions as well as buffer completions. It also
supports features such as generic checksum offload, generic receive
offload (hardware GRO) etc.
---
v3:
Patch 5:
 * instead of void, used 'struct virtchnl2_create_vport' type for
   vport_params_recvd and vport_params_reqd and removed the typecasting
 * used u16/u32 as needed instead of int for variables which cannot be
   negative and updated in all the places whereever applicable
Patch 6:
 * changed the commit message to "add ptypes and MAC filter support"
 * used the sender Signed-off-by as the last tag on all the patches
 * removed unnecessary variables 0-init
 * instead of fixing the code in this commit, fixed it in the commit
   where the change was introduced first
 * moved get_type_info struct on to the stack instead of memory alloc
 * moved mutex_lock and ptype_info memory alloc outside while loop and
   adjusted the return flow
 * used 'break' instead of 'continue' in ptype id switch case

v2: https://lore.kernel.org/netdev/20230614171428.1504179-1-anthony.l.nguyen@intel.com/
Patch 2:
 * added "Intel(R)" to the DRV_SUMMARY and Makefile.
Patch 4, 5, 6, 15:
 * replaced IDPF_VC_MSG_PENDING flag with mutex 'vc_buf_lock' for the
   adapter related virtchnl opcodes.
 * get the mutex lock in the virtchnl send thread itself instead of
   in receive thread.
Patch 5, 6, 7, 8, 9, 11, 14, 15:
 * replaced IDPF_VPORT_VC_MSG_PENDING flag with mutex 'vc_buf_lock' for
   the vport related virtchnl opcodes.
 * get the mutex lock in the virtchnl send thread itself instead of
   in receive thread.
Patch 6:
 * converted get_ptype_info logic from 1:N to 1:1 message exchange for
   better handling of mutex lock.
Patch 15:
 * introduced 'stats_lock' spinlock to avoid concurrent stats update.

v1: https://lore.kernel.org/netdev/20230530234501.2680230-1-anthony.l.nguyen@intel.com/

iwl-next:
v6 - https://lore.kernel.org/netdev/20230523002252.26124-1-pavan.kumar.linga@intel.com/
v5 - https://lore.kernel.org/netdev/20230513225710.3898-1-emil.s.tantilov@intel.com/
v4 - https://lore.kernel.org/netdev/20230508194326.482-1-emil.s.tantilov@intel.com/
v3 - https://lore.kernel.org/netdev/20230427020917.12029-1-emil.s.tantilov@intel.com/
v2 - https://lore.kernel.org/netdev/20230411011354.2619359-1-pavan.kumar.linga@intel.com/
v1 - https://lore.kernel.org/netdev/20230329140404.1647925-1-pavan.kumar.linga@intel.com/

The following are changes since commit 5a6f6873606e03a0a95afe40ba5e84bb6e28a26f:
  ip, ip6: Fix splice to raw and ping sockets
and are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 200GbE

Alan Brady (4):
  idpf: configure resources for TX queues
  idpf: configure resources for RX queues
  idpf: add RX splitq napi poll support
  idpf: add ethtool callbacks

Joshua Hay (5):
  idpf: add controlq init and reset checks
  idpf: add splitq start_xmit
  idpf: add TX splitq napi poll support
  idpf: add singleq start_xmit and napi poll
  idpf: configure SRIOV and add other ndo_ops

Pavan Kumar Linga (5):
  virtchnl: add virtchnl version 2 ops
  idpf: add core init and interrupt request
  idpf: add create vport and netdev configuration
  idpf: add ptypes and MAC filter support
  idpf: initialize interrupts and enable vport

Phani Burra (1):
  idpf: add module register and probe functionality

 .../device_drivers/ethernet/index.rst         |    1 +
 .../device_drivers/ethernet/intel/idpf.rst    |  160 +
 drivers/net/ethernet/intel/Kconfig            |   10 +
 drivers/net/ethernet/intel/Makefile           |    1 +
 drivers/net/ethernet/intel/idpf/Makefile      |   18 +
 drivers/net/ethernet/intel/idpf/idpf.h        |  751 +++
 .../net/ethernet/intel/idpf/idpf_controlq.c   |  641 +++
 .../net/ethernet/intel/idpf/idpf_controlq.h   |  131 +
 .../ethernet/intel/idpf/idpf_controlq_api.h   |  169 +
 .../ethernet/intel/idpf/idpf_controlq_setup.c |  175 +
 drivers/net/ethernet/intel/idpf/idpf_dev.c    |  165 +
 drivers/net/ethernet/intel/idpf/idpf_devids.h |   10 +
 .../net/ethernet/intel/idpf/idpf_ethtool.c    | 1331 +++++
 .../ethernet/intel/idpf/idpf_lan_pf_regs.h    |  124 +
 .../net/ethernet/intel/idpf/idpf_lan_txrx.h   |  293 ++
 .../ethernet/intel/idpf/idpf_lan_vf_regs.h    |  128 +
 drivers/net/ethernet/intel/idpf/idpf_lib.c    | 2363 +++++++++
 drivers/net/ethernet/intel/idpf/idpf_main.c   |  271 +
 drivers/net/ethernet/intel/idpf/idpf_mem.h    |   20 +
 .../ethernet/intel/idpf/idpf_singleq_txrx.c   | 1251 +++++
 drivers/net/ethernet/intel/idpf/idpf_txrx.c   | 4608 +++++++++++++++++
 drivers/net/ethernet/intel/idpf/idpf_txrx.h   |  852 +++
 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c |  164 +
 .../net/ethernet/intel/idpf/idpf_virtchnl.c   | 3783 ++++++++++++++
 drivers/net/ethernet/intel/idpf/virtchnl2.h   | 1289 +++++
 .../ethernet/intel/idpf/virtchnl2_lan_desc.h  |  448 ++
 26 files changed, 19157 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/intel/idpf.rst
 create mode 100644 drivers/net/ethernet/intel/idpf/Makefile
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq_api.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_controlq_setup.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_dev.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_devids.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_ethtool.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_pf_regs.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_txrx.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lan_vf_regs.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_lib.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_main.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_mem.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_singleq_txrx.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_txrx.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_txrx.h
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_vf_dev.c
 create mode 100644 drivers/net/ethernet/intel/idpf/idpf_virtchnl.c
 create mode 100644 drivers/net/ethernet/intel/idpf/virtchnl2.h
 create mode 100644 drivers/net/ethernet/intel/idpf/virtchnl2_lan_desc.h

-- 
2.38.1


