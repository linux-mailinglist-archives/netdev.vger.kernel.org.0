Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4160916BF12
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 11:47:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730354AbgBYKry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 05:47:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:22837 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729417AbgBYKry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 05:47:54 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Feb 2020 02:47:53 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,483,1574150400"; 
   d="gz'50?scan'50,208,50";a="260656507"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 25 Feb 2020 02:47:51 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1j6Xkk-000IcJ-GW; Tue, 25 Feb 2020 18:47:50 +0800
Date:   Tue, 25 Feb 2020 18:47:03 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     kbuild-all@lists.01.org,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v2 7/8] PCI: pci-bridge-emul: use PCI_STATUS_ERROR_BITS
Message-ID: <202002251803.taTZxoDE%lkp@intel.com>
References: <4a64e635-728e-2f61-3b85-b0526bb0d9e2@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <4a64e635-728e-2f61-3b85-b0526bb0d9e2@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Heiner,

I love your patch! Yet something to improve:

[auto build test ERROR on pci/next]
[also build test ERROR on sound/for-next net-next/master net/master linus/master v5.6-rc3 next-20200224]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Heiner-Kallweit/PCI-add-and-use-constant-PCI_STATUS_ERROR_BITS-and-helper-pci_status_get_and_clear_errors/20200225-154725
base:   https://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git next
config: arm-mvebu_v7_defconfig (attached as .config)
compiler: arm-linux-gnueabi-gcc (GCC) 7.5.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        GCC_VERSION=7.5.0 make.cross ARCH=arm 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers//pci/pci-bridge-emul.c:53:37: error: expected '}' before ';' token
      .w1c = PCI_STATUS_ERROR_BITS << 16;
                                        ^
   drivers//pci/pci-bridge-emul.c:98:37: error: expected '}' before ';' token
      .w1c = PCI_STATUS_ERROR_BITS << 16;
                                        ^

vim +53 drivers//pci/pci-bridge-emul.c

    40	
    41	static const struct pci_bridge_reg_behavior pci_regs_behavior[] = {
    42		[PCI_VENDOR_ID / 4] = { .ro = ~0 },
    43		[PCI_COMMAND / 4] = {
    44			.rw = (PCI_COMMAND_IO | PCI_COMMAND_MEMORY |
    45			       PCI_COMMAND_MASTER | PCI_COMMAND_PARITY |
    46			       PCI_COMMAND_SERR),
    47			.ro = ((PCI_COMMAND_SPECIAL | PCI_COMMAND_INVALIDATE |
    48				PCI_COMMAND_VGA_PALETTE | PCI_COMMAND_WAIT |
    49				PCI_COMMAND_FAST_BACK) |
    50			       (PCI_STATUS_CAP_LIST | PCI_STATUS_66MHZ |
    51				PCI_STATUS_FAST_BACK | PCI_STATUS_DEVSEL_MASK) << 16),
    52			.rsvd = GENMASK(15, 10) | ((BIT(6) | GENMASK(3, 0)) << 16),
  > 53			.w1c = PCI_STATUS_ERROR_BITS << 16;
    54		},
    55		[PCI_CLASS_REVISION / 4] = { .ro = ~0 },
    56	
    57		/*
    58		 * Cache Line Size register: implement as read-only, we do not
    59		 * pretend implementing "Memory Write and Invalidate"
    60		 * transactions"
    61		 *
    62		 * Latency Timer Register: implemented as read-only, as "A
    63		 * bridge that is not capable of a burst transfer of more than
    64		 * two data phases on its primary interface is permitted to
    65		 * hardwire the Latency Timer to a value of 16 or less"
    66		 *
    67		 * Header Type: always read-only
    68		 *
    69		 * BIST register: implemented as read-only, as "A bridge that
    70		 * does not support BIST must implement this register as a
    71		 * read-only register that returns 0 when read"
    72		 */
    73		[PCI_CACHE_LINE_SIZE / 4] = { .ro = ~0 },
    74	
    75		/*
    76		 * Base Address registers not used must be implemented as
    77		 * read-only registers that return 0 when read.
    78		 */
    79		[PCI_BASE_ADDRESS_0 / 4] = { .ro = ~0 },
    80		[PCI_BASE_ADDRESS_1 / 4] = { .ro = ~0 },
    81	
    82		[PCI_PRIMARY_BUS / 4] = {
    83			/* Primary, secondary and subordinate bus are RW */
    84			.rw = GENMASK(24, 0),
    85			/* Secondary latency is read-only */
    86			.ro = GENMASK(31, 24),
    87		},
    88	
    89		[PCI_IO_BASE / 4] = {
    90			/* The high four bits of I/O base/limit are RW */
    91			.rw = (GENMASK(15, 12) | GENMASK(7, 4)),
    92	
    93			/* The low four bits of I/O base/limit are RO */
    94			.ro = (((PCI_STATUS_66MHZ | PCI_STATUS_FAST_BACK |
    95				 PCI_STATUS_DEVSEL_MASK) << 16) |
    96			       GENMASK(11, 8) | GENMASK(3, 0)),
    97	
    98			.w1c = PCI_STATUS_ERROR_BITS << 16;
    99	
   100			.rsvd = ((BIT(6) | GENMASK(4, 0)) << 16),
   101		},
   102	
   103		[PCI_MEMORY_BASE / 4] = {
   104			/* The high 12-bits of mem base/limit are RW */
   105			.rw = GENMASK(31, 20) | GENMASK(15, 4),
   106	
   107			/* The low four bits of mem base/limit are RO */
   108			.ro = GENMASK(19, 16) | GENMASK(3, 0),
   109		},
   110	
   111		[PCI_PREF_MEMORY_BASE / 4] = {
   112			/* The high 12-bits of pref mem base/limit are RW */
   113			.rw = GENMASK(31, 20) | GENMASK(15, 4),
   114	
   115			/* The low four bits of pref mem base/limit are RO */
   116			.ro = GENMASK(19, 16) | GENMASK(3, 0),
   117		},
   118	
   119		[PCI_PREF_BASE_UPPER32 / 4] = {
   120			.rw = ~0,
   121		},
   122	
   123		[PCI_PREF_LIMIT_UPPER32 / 4] = {
   124			.rw = ~0,
   125		},
   126	
   127		[PCI_IO_BASE_UPPER16 / 4] = {
   128			.rw = ~0,
   129		},
   130	
   131		[PCI_CAPABILITY_LIST / 4] = {
   132			.ro = GENMASK(7, 0),
   133			.rsvd = GENMASK(31, 8),
   134		},
   135	
   136		[PCI_ROM_ADDRESS1 / 4] = {
   137			.rw = GENMASK(31, 11) | BIT(0),
   138			.rsvd = GENMASK(10, 1),
   139		},
   140	
   141		/*
   142		 * Interrupt line (bits 7:0) are RW, interrupt pin (bits 15:8)
   143		 * are RO, and bridge control (31:16) are a mix of RW, RO,
   144		 * reserved and W1C bits
   145		 */
   146		[PCI_INTERRUPT_LINE / 4] = {
   147			/* Interrupt line is RW */
   148			.rw = (GENMASK(7, 0) |
   149			       ((PCI_BRIDGE_CTL_PARITY |
   150				 PCI_BRIDGE_CTL_SERR |
   151				 PCI_BRIDGE_CTL_ISA |
   152				 PCI_BRIDGE_CTL_VGA |
   153				 PCI_BRIDGE_CTL_MASTER_ABORT |
   154				 PCI_BRIDGE_CTL_BUS_RESET |
   155				 BIT(8) | BIT(9) | BIT(11)) << 16)),
   156	
   157			/* Interrupt pin is RO */
   158			.ro = (GENMASK(15, 8) | ((PCI_BRIDGE_CTL_FAST_BACK) << 16)),
   159	
   160			.w1c = BIT(10) << 16,
   161	
   162			.rsvd = (GENMASK(15, 12) | BIT(4)) << 16,
   163		},
   164	};
   165	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--huq684BweRXVnRxX
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--huq684BweRXVnRxX--
