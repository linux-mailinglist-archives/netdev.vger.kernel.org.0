Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 728C75A1D49
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 01:42:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244447AbiHYXmz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 19:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiHYXmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 19:42:53 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A557B7EF4;
        Thu, 25 Aug 2022 16:42:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661470972; x=1693006972;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=7Fz5dyyX+/YdhjbMg04tyVUtHtuaDFuJrD8QRk+E2eY=;
  b=fZCqbdefiY2Y//o718kuAMZ+QLQunttpeLG5g/0nGtQyHYDAzAQ0VxGS
   jXCrBRe6vX7wccvBPTyXQbwgF7lGRxdjeN69VuRVKb9ZATamhzrv7nSyX
   +49jW/0FIRBgnHuB/P/puGEzSkN62AwB0kVDwR1nT6JGMOtWfJ9aFygMu
   vF0bNdoUvLBOPQ3bbp7OitO62O00XoyN/uD5+ZJyzecCu0QUjZgO6Zg1I
   6TIJGHiBG3zrILxWWH9i4DLawO59PCk/xxccGo4xsAEB8ZIFR/ZOn9JaE
   g9nnB3jMzSKxSsK4F48PIyfDbAsTK3sVApL6RkjHkO8B4lyyA2I9hpusb
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10450"; a="295162739"
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="295162739"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Aug 2022 16:42:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,264,1654585200"; 
   d="scan'208";a="678658422"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga004.fm.intel.com with ESMTP; 25 Aug 2022 16:42:51 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 16:42:51 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 25 Aug 2022 16:42:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 25 Aug 2022 16:42:50 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.47) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 25 Aug 2022 16:42:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FttSdbbaRt63KfvxoO2Q/rr7HP4+dzWrBaX0g5GC+aSbKLq+VU/nPCU1aBjMrTgVIFFLc5Ts5zngK/moBQ+S2sYxRv6G827z279bmbJhUVnrobxARaK8NF/S21IBiDqXgCNaWnuCRhFAaLXzcQJOfDYnVS6zeFfm8kLfU3jhn4AFaYGy2WXVUkE2gy832Z/GUM6GO1AjwWDoSGX+TNhjaE/7W+LD2eePScgYCIrx6S941zCGgqINkJuMnD8KVOD3G+eanYA/7fUtx6kitvM5HhQNkBNIMtczUCpEGEtDEQ4bPe/ThpCoBeaoLpexdlnGaDq+kuzA1SNMLwgUMA3oIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fz6lBvDnGoo1hd4s/R9aBSvSiA1N4HsbxO0aG/a8PZg=;
 b=kvj1OLKSyWA5hZsDy/CXC3ft3cGrNUSCAuBubbUd4vkWATm8TQjCGmOK9Tt3TQKcJMQzfaFLlVX+nNWqR42EMGzFfavFKc9R6yCe67d9EkKw1PQGb9bC+m/VxldNJs76tybUNw8U/IqiMstNlxth+rgByqjKkaNcCEtY2i60pjnSc1ko/a9KcUdfydMqf3c1bMwtfHvz0Qfa8n6dzy/vAgALMKpWfVcUEdwAd44gyHlph2455966tnkHPsTnPKH6logrtUoVxQwUX3LYsABiO73tj/mIqzZbfVYBFAr6dZ75vYJ2h90m+9H9ZSF7R3nOuH8o6brh0HnWnWB8NG18aA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB3113.namprd11.prod.outlook.com (2603:10b6:5:69::19) by
 MWHPR11MB2062.namprd11.prod.outlook.com (2603:10b6:300:2a::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5546.21; Thu, 25 Aug 2022 23:42:47 +0000
Received: from DM6PR11MB3113.namprd11.prod.outlook.com
 ([fe80::7100:8281:521b:ff31]) by DM6PR11MB3113.namprd11.prod.outlook.com
 ([fe80::7100:8281:521b:ff31%5]) with mapi id 15.20.5566.015; Thu, 25 Aug 2022
 23:42:47 +0000
From:   "Laba, SlawomirX" <slawomirx.laba@intel.com>
To:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "songmuchun@bytedance.com" <songmuchun@bytedance.com>,
        "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: BUG: Virtual machine fails to start on 6.0-rc2
Thread-Topic: BUG: Virtual machine fails to start on 6.0-rc2
Thread-Index: Adi42gn6sxbvtLg7QcKy/nSIRHLahA==
Date:   Thu, 25 Aug 2022 23:42:47 +0000
Message-ID: <DM6PR11MB3113DF6EC61D0AB73F3A2FE387729@DM6PR11MB3113.namprd11.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 53a45f0a-83c6-4da7-8ba2-08da86f383f1
x-ms-traffictypediagnostic: MWHPR11MB2062:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4hBaZ/0gE8wfnFlUzURp+nUYDLv/UgVr7jaM9Ktuvd//yKYOiRJqXshIqjQpcDrm3Ioea+xNEZD8m8DPAga88vP/taVCqyHlQoiV+gXbVNVhHA3LRj938WHqamA8NVSnblJaYjBYPJ9x0OhrZF8pDDFzjlLtf6Is3vhb0SXXi3ORtD7B+Z2yNToyKSZYM+nrK1KGNEgJQPy6vGFwgdkLdHWedO943l9iSeW5JfDY8GibGrrzVtDbr7aF5dlf2edqKNPJZzlMR/qZIzdN65pVCZipo/RGNpH5eZcB6+aWjZCSWbjggMKVy6QEt4uj17zZEYWARlCSx08JEAx2g2DPqBldrNRdbNLaNMFdjd20qBWfmBANTy5GtyPvF/KQsBytpiq8QyMXzdvGFyVPxQVku4iD4n92XYUHhovqE6urQ4B16k16SDkt3+4VTDfg6GrnRVwql/pV4Nw69hd/oJIoI0FiVQu1X5g5kI8Hd1SFujGRbUvOxCSF5SQW5YbOJGg3b4c6v5+dkm5CfcCI3hvgKVvaqna3fw/HC8BWwfPdT8lO8S/QU+vG3AZtMSvPAxqaWDpLhDQGTgzSYH1OT04QvX0Of2/oXmabzDJbzUouUFbkG7tEyrFx/w6KWm2PIleoJxGLB3FKSbjV6bB+HJJ4vgVpuTCNCr8sgfs41c45dGtulAhbxOp1EYOkmi7P8LBCIdE90p2JJ9NuFbB7J6mQPZx/sBRpkXcBw2rjmbg1vh4Z6OKL133Ahz0fo4DM/lPGBJn3BPZZIP6l/if5WGxRnFg3CNK2kzFsfzFPZUrdFsc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3113.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(136003)(346002)(396003)(39860400002)(9686003)(26005)(7696005)(54906003)(478600001)(41300700001)(316002)(110136005)(122000001)(86362001)(38100700002)(71200400001)(6506007)(38070700005)(186003)(82960400001)(83380400001)(921005)(4326008)(8676002)(66446008)(66556008)(66476007)(64756008)(33656002)(66946007)(76116006)(8936002)(5660300002)(52536014)(7416002)(55016003)(107886003)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?cXDnHVyV5Tmqx8f8t5nMRdDiqB8uDMH+WNV16LiryFXduQwLZqfEOXKkbvTL?=
 =?us-ascii?Q?4QV92E2pC/Io4iw6Ls8lBiwGxXwSRWR25MXnWUAehGz5MJToia4szWw5CqFr?=
 =?us-ascii?Q?TCYPe3khCsyDazk30ir9U6SbUoUzElC15vz2dYj6SDWqwsC5cpQXK84UyFgc?=
 =?us-ascii?Q?PDvXtOeW1oc6jQcmyX4uy+cAffDnPtgAjYA0ApGuZ/QDmilcgpZsErFRub1a?=
 =?us-ascii?Q?WGvvPl7jwgDLkkSrWrvoeWJAPslfsxM0UtMnLAn8Y58SrCSeEHMhLuKTyM3i?=
 =?us-ascii?Q?zcoIKc9qNMhm4o8RcuTHypEC6Qr78YRfdwplk29ktvQke3csSTADQUPZuVpe?=
 =?us-ascii?Q?sAYbjPrdjj3A/JtSeUWbXi3tT6NYS/ZTBmMzGB5g4VtYa7tmEnnh5eWQYL7G?=
 =?us-ascii?Q?uKinfjqFHcQEK+bsdqXUEVlYaLVkEKE9S1VDkKEUb/BAsRGaNwF+iGP+PYtf?=
 =?us-ascii?Q?0Io5ZD6oZINTEtcoovv1LadThlcZDgU9wukYHDoU17z7WASlhdoU+6XqHTDw?=
 =?us-ascii?Q?D/E1AP3jQDMtGq0G3mtacSURmokpaUfApDVdjtbWwFuAAkC0gRFHGH3b5cWS?=
 =?us-ascii?Q?q+wUac61/berVQjqLyeDaRbQJKG9xZzlDKviLy2ZbPYwnS8iiPqltekwym79?=
 =?us-ascii?Q?42bUKczhzQJ+UPLyx4OqewBuJdoqaGWtsnukHdAArVMDQ3Y95knCaaIF7Myp?=
 =?us-ascii?Q?L2WxZRHVVKs8oktYZydq+UPzqeBfSK3En7SpvBo6yM+6vo3nxCTmvNHky90A?=
 =?us-ascii?Q?ZQwGBnVXOto2G+5cl+/dOPtt4U4zwIhSrO+WI2J0vvvgpoAjyw7m/SneaBCG?=
 =?us-ascii?Q?rmkda51VC9NgRb3LfCB2IwgtOH+IOrW1cBOLdwLWCs0/mcXCLsN6Zgs86ENR?=
 =?us-ascii?Q?8PBV7/kvj3NTcCD96PuB2lzTXVowatUAWyFerDOtj24CzM8lvuJt7Rtyf3dL?=
 =?us-ascii?Q?Ub+ywOqYY54lqIObDePjxmPePdR3iAyOgVh7zW21q6vC9yOAH80dPePo4zP5?=
 =?us-ascii?Q?Y69uqruCiZb2e30iGD4QFoY6lmTj5FNast0vH2r4LnZQ+V3eMyh7IofJ5FDV?=
 =?us-ascii?Q?1PQ8EKn+8zWTtmhTvOdoAfC4CVqR0AjmaNunagNEecFv7lKSLUGuEhHzutDr?=
 =?us-ascii?Q?xwtHF+14Wk5iDRTfCWQcur3O6UfaQq4wwdZuum0Uf3Js74MdUGPdfnouOz4K?=
 =?us-ascii?Q?yV7Kr+WRjK7jPL82NMkweVI4n2ua/45UfkXF5kuxFVr0RBCAxZNnUAtxOlHf?=
 =?us-ascii?Q?382uTxOu5uWqU1LdIhmWS+J9YVMgdSUDQFbAB48vSjZEE6dyvcSj4DD0Hj6S?=
 =?us-ascii?Q?LiWkSE7Ff90/URcUkXoKpy9V4+3UOnoh4TBNt1sIy1Dr3/K6qH7t09ZunOGR?=
 =?us-ascii?Q?1qHHv+/qT0JhZrOtVzqdZAzgFDBnQqEfrad+heK9zwwTP3eGTcRJ+wdrfTvi?=
 =?us-ascii?Q?vOs35tbR5thZx+lU1uO52OsZlLQFcoNInfdqILAOGLChVokLF6mmYkwJhPuF?=
 =?us-ascii?Q?t1+Qtq9SpRM0N4n8CWQa2T74UUEIdJ52p44EKFjtdCvQzYDcf8BUrjOKfJ0n?=
 =?us-ascii?Q?KDrM+DXqw0LiMPd1POApByO6FYOuiCN2JVXFL1nS?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3113.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a45f0a-83c6-4da7-8ba2-08da86f383f1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Aug 2022 23:42:47.4854
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cnEeNt2IpxhgLC6MsFIMQrHoAg6dx0ZaXtfs+3jPHVNuyzRLSYK9nB9pCO0OLL+IbD+8moC09JxTLGuJ5+8v+0PwJWaRzAf0hvOg3buBK/A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB2062
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We were testing the changes for our VF devices and noticed an issue when st=
arting VMs with passthrough VFs. We then moved back to mainline kernel and =
reproduced the issue on 6.0-rc2

We noticed that the startup of the KVM hangs.

Steps to reproduce:
Create a VF from the PF interface.
Configure VM XML with the VF PCI.
Start the KVM.

To isolate the issue we moved back to kernel 5.19 and it was working fine.

Working tag v5.19
Tested failing commit 4c612826bec1

[root@localhost sl]# uname -r
6.0.0-rc2-00159-g4c612826bec1
[root@localhost sl]# echo 1 > /sys/class/net/ens785f3/device/sriov_numvfs
[root@localhost sl]# virsh start rhel_9_0_first
^C
[root@localhost sl]# virsh list --all
 Id   Name             State
-------------------------------
 1    rhel_9_0_first   paused=09

Dmesg:
[  +0.042400] iavf: Intel(R) Ethernet Adaptive Virtual Function Network Dri=
ver
[  +0.000004] Copyright (c) 2013 - 2018 Intel Corporation.
[  +0.000309] iavf 0000:18:19.0: enabling device (0000 -> 0002)
[  +0.073471] iavf 0000:18:19.0: Invalid MAC address 00:00:00:00:00:00, usi=
ng random
[  +0.000674] iavf 0000:18:19.0: Multiqueue Enabled: Queue pair count =3D 1=
6
[  +0.000466] iavf 0000:18:19.0: MAC address: 5a:0c:b5:f7:4f:0b
[  +0.000003] iavf 0000:18:19.0: GRO is enabled
[  +0.005941] iavf 0000:18:19.0 ens785f3v0: renamed from eth0
[  +0.179174] IPv6: ADDRCONF(NETDEV_CHANGE): ens785f3v0: link becomes ready
[  +0.000040] iavf 0000:18:19.0 ens785f3v0: NIC Link is Up Speed is 25 Gbps=
 Full Duplex
[ +26.408503] bridge: filtering via arp/ip/ip6tables is no longer available=
 by default. Update your scripts to load br_netfilter if you need this.
[  +0.399621] VFIO - User Level meta-driver version: 0.3
[  +0.151579] iavf 0000:18:19.0: Remove device
[  +0.292158] ice 0000:18:00.3 ens785f3: Setting MAC 52:54:00:9f:ea:de on V=
F 0. VF driver will be reinitialized
[  +0.083676] ice 0000:18:00.3: Clearing port VLAN on VF 0
[  +0.155905] tun: Universal TUN/TAP device driver, 1.6
[  +0.000976] virbr0: port 1(vnet0) entered blocking state
[  +0.000017] virbr0: port 1(vnet0) entered disabled state
[  +0.000052] device vnet0 entered promiscuous mode
[  +0.000244] virbr0: port 1(vnet0) entered blocking state
[  +0.000003] virbr0: port 1(vnet0) entered listening state
[  +2.019924] virbr0: port 1(vnet0) entered learning state
[  +2.047997] virbr0: port 1(vnet0) entered forwarding state
[  +0.000018] virbr0: topology change detected, propagating
[Aug25 19:12] INFO: task khugepaged:507 blocked for more than 122 seconds.
[  +0.000016]       Tainted: G        W I        6.0.0-rc2-00159-g4c612826b=
ec1 #1
[  +0.000010] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables t=
his message.
[  +0.000010] task:khugepaged      state:D stack:    0 pid:  507 ppid:     =
2 flags:0x00004000
[  +0.000004] Call Trace:
[  +0.000001]  <TASK>
[  +0.000003]  __schedule+0x1bc/0x550
[  +0.000006]  ? osq_unlock+0xf/0x90
[  +0.000005]  schedule+0x5d/0xd0
[  +0.000002]  rwsem_down_write_slowpath+0x2c9/0x5e0
[  +0.000004]  ? find_vma+0x64/0x70
[  +0.000004]  collapse_huge_page+0x1f8/0x8a0
[  +0.000004]  ? _raw_spin_unlock+0x14/0x30
[  +0.000002]  ? preempt_count_add+0x70/0xa0
[  +0.000005]  ? _raw_spin_lock_irqsave+0x21/0x30
[  +0.000001]  ? lock_timer_base+0x61/0x80
[  +0.000005]  khugepaged_scan_pmd+0x33d/0x7b0
[  +0.000003]  khugepaged_scan_mm_slot+0x155/0x440
[  +0.000003]  khugepaged+0x189/0x3e0
[  +0.000002]  ? preempt_count_add+0x70/0xa0
[  +0.000002]  ? _raw_spin_unlock_irqrestore+0x1e/0x40
[  +0.000002]  ? khugepaged_scan_mm_slot+0x440/0x440
[  +0.000001]  kthread+0xf0/0x120
[  +0.000003]  ? kthread_complete_and_exit+0x20/0x20
[  +0.000003]  ret_from_fork+0x1f/0x30
[  +0.000006]  </TASK>

On the working version there is a line that enables the interface for the V=
F which is missing on non-working one:
[  +0.911730] vfio-pci 0000:18:19.0: enabling device (0000 -> 0002)
