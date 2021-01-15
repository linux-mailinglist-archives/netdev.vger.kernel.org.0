Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B842F8868
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 23:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbhAOW3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 17:29:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbhAOW3k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 17:29:40 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C54B1C0613D3;
        Fri, 15 Jan 2021 14:28:59 -0800 (PST)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1l0XaT-0000oS-EB; Fri, 15 Jan 2021 23:28:57 +0100
Date:   Fri, 15 Jan 2021 23:28:57 +0100
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] iptables 1.8.7 release
Message-ID: <20210115222857.GA18001@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0OAP2g/MAC+5xKAE"
Content-Disposition: inline
Sender:  <n0-1@orbyte.nwl.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

iptables 1.8.7

This release contains the following fixes and enhancements:

iptables-nft:
- Improved performance when matching on IP/MAC address prefixes if the
  prefix is byte-aligned. In ideal cases, this doubles packet processing
  performance.
  *NOTE*: Older iptables versions will not recognize the mask and thus
          omit them when listing the ruleset.
- Dump user-defined chains in lexical order. This way ruleset dumps
  become stable and easily comparable.
- Avoid pointless table/chain creation. For instance, 'iptables-nft -L'
  no longer creates missing base-chains.

ebtables-nft:
- Renaming user-defined chains was entirely broken.

extensions:
- Code for printing and parsing of MAC addresses was consolidated
  internally, slightly reducing binary size. As a noticeable
  side-effect, all MAC addresses are now printed in lower-case (affects
  'mac'-extension).
- Fixed DCCP extension's match on 'INVALID' type, a meta-type which
  should match any type value in the range from ten to fifteen. In the
  past it matched on type value 10 only.

xtables-monitor:
- Don't print unrelated rules in the same chain when tracing.
- Flush output buffer after each rule when tracing to improve experience
  when redirecting output.
- Print the table's family when tracing instead of whatever the user
  specified on command line.
- Print the traced packet before the rule it traverses, not vice-versa.
- Recognize loopback interface and print "LOOPBACK" for link layer
  header info instead of "LL=0x304".

xtables-translate:
- Correctly translate DCCP type matches (including 'INVALID').

See the attached changelog for more details.

You can download it from:

http://www.netfilter.org/projects/iptables/downloads.html#iptables-1.8.7

To build the code, libnftnl 1.1.6 is required:

* http://netfilter.org/projects/libnftnl/downloads.html#libnftnl-1.1.6

In case of bugs and feature requests, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--0OAP2g/MAC+5xKAE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables-1.8.7.txt"

Florian Westphal (4):
  xtables-monitor: fix rule printing
  xtables-monitor: fix packet family protocol
  xtables-monitor: print packet first
  xtables-monitor: 'LL=0x304' is not very convenient, print LOOPBACK instead.

Pablo Neira Ayuso (1):
  tests: shell: update format of registers in bitwise payloads.

Phil Sutter (21):
  nft: Optimize class-based IP prefix matches
  ebtables: Optimize masked MAC address matches
  tests/shell: Add test for bitwise avoidance fixes
  ebtables: Fix for broken chain renaming
  iptables-test.py: Accept multiple test files on commandline
  iptables-test.py: Try to unshare netns by default
  libxtables: Extend MAC address printing/parsing support
  xtables-arp: Don't use ARPT_INV_*
  xshared: Merge some command option-related code
  tests/shell: Test for fixed extension registration
  extensions: dccp: Fix for DCCP type 'INVALID'
  nft: Fix selective chain compatibility checks
  nft: cache: Introduce nft_cache_add_chain()
  nft: Implement nft_chain_foreach()
  nft: cache: Move nft_chain_find() over
  nft: Introduce struct nft_chain
  nft: Introduce a dedicated base chain array
  nft: cache: Sort custom chains by name
  tests: shell: Drop any dump sorting in place
  nft: Avoid pointless table/chain creation
  tests/shell: Fix nft-only/0009-needless-bitwise_0

--0OAP2g/MAC+5xKAE--
