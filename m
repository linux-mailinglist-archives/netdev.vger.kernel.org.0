Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653872A184C
	for <lists+netdev@lfdr.de>; Sat, 31 Oct 2020 15:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgJaOqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 10:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgJaOqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Oct 2020 10:46:52 -0400
X-Greylist: delayed 1175 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 31 Oct 2020 07:46:51 PDT
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6628C0617A6;
        Sat, 31 Oct 2020 07:46:51 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1kYrqa-0003gW-K5; Sat, 31 Oct 2020 15:27:12 +0100
Date:   Sat, 31 Oct 2020 15:27:12 +0100
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] iptables 1.8.6 release
Message-ID: <20201031142712.GA10193@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

iptables 1.8.6

This release contains the following fixes and enhancements:

iptables-nft:
- Fix ip6tables error messages, they were incorrectly prefixed
  'iptables:'.
- Fix for pointless 'bitwise' expression being added to each IP address
  match, needlessly slowing down run-time performance (by 50% in worst
  cases).

iptables-nft-restore:
- Correctly print the flushed chains in verbose mode, like legacy
  restore does.
- Restoring multiple tables could fail if a ruleset flush happened in
  parallel (e.g. via 'nft flush ruleset').
- Fix for bogus error messages if a refreshed transaction fails.
- Support basechain policy value of '-' (indicating to not change the
  chain's policy).
- Fix for spurious errors in concurrent restore calls with '--noflush'.

iptables-legacy:
- Allow to configure lock file location via XTABLES_LOCKFILE environment
  variable.

xtables-monitor:
- Fix printing of IP addresses in ip6tables rules.

xtables-translate:
- Exit gracefully when called with '--help'.
- Fix some memory leaks.
- Add support for conntrack '--ctstate' match.
- Fix translation of ICMP type 'any' match.

libxtables:
- Fix for lower extension revisions not supported by the kernel anymore
  being retried each time the extension is used in a rule. This
  significantly improves performance when restoring large rulesets which
  extensively use e.g. conntrack match.

tests:
- Add help text to tests/shell/run-tests.sh.
- Test ip6tables error messages also, not just return codes.

General:
- Rejecting packets with ctstate INVALID might close good connections if
  packet reordering happened. Document this and suggest to use DROP
  target instead.
- Fix for iptables-apply script not being installed by 'make install'.
- Fix 'make uninstall', it was completely broken.
- Fix compiler warnings when building with NO_SHARED_LIBS.
- Extend 'make clean' to remove some generated man pages left in place.
- Fix for gcc-10 zero-length array warnings.

See the attached changelog for more details.

You can download it from:

http://www.netfilter.org/projects/iptables/downloads.html#iptables-1.8.6

To build the code, libnftnl 1.1.6 is required:

* http://netfilter.org/projects/libnftnl/downloads.html#libnftnl-1.1.6

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="iptables-1.8.6.txt"
Content-Transfer-Encoding: 8bit

Arturo Borrero Gonzalez (1):
  xtables-translate: don't fail if help was requested

Giuseppe Scrivano (1):
  iptables: accept lock file name at runtime

Jan Engelhardt (2):
  doc: document danger of applying REJECT to INVALID CTs
  build: resolve iptables-apply not getting installed

Maciej Żenczykowski (1):
  libxtables: compiler warning fixes for NO_SHARED_LIBS

Pablo Neira Ayuso (3):
  extensions: libxt_conntrack: provide translation for DNAT and SNAT
    --ctstate
  iptables: replace libnftnl table list by linux list
  iptables-nft: fix basechain policy configuration

Phil Sutter (31):
  xtables-restore: Fix verbose mode table flushing
  build: Fix for failing 'make uninstall'
  xtables-translate: Use proper clear_cs function
  tests: shell: Add help output to run-tests.sh
  nft: Make table creation purely implicit
  nft: Be lazy when flushing
  nft: cache: Drop duplicate chain check
  nft: Drop pointless nft_xt_builtin_init() call
  nft: Turn nft_chain_save() into a foreach-callback
  nft: Use nft_chain_find() in two more places
  nft: Reorder enum nft_table_type
  nft: Eliminate table list from cache
  nft: Fix command name in ip6tables error message
  tests: shell: Merge and extend return codes test
  xtables-monitor: Fix ip6tables rule printing
  nft: Fix for ruleset flush while restoring
  Makefile: Add missing man pages to CLEANFILES
  nft: cache: Check consistency with NFT_CL_FAKE, too
  nft: Extend use of nftnl_chain_list_foreach()
  nft: Fold nftnl_rule_list_chain_save() into caller
  nft: Use nft_chain_find() in nft_chain_builtin_init()
  nft: Fix for broken address mask match detection
  extensions: libipt_icmp: Fix translation of type 'any'
  libxtables: Make sure extensions register in revision order
  libxtables: Simplify pending extension registration
  libxtables: Register multiple extensions in ascending order
  nft: Make batch_add_chain() return the added batch object
  nft: Fix error reporting for refreshed transactions
  libiptc: Avoid gcc-10 zero-length array warning
  nft: Fix for concurrent noflush restore calls
  tests: shell: Improve concurrent noflush restore test a bit

--k+w/mQv8wyuph6w0--
