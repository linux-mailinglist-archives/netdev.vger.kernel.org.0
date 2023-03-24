Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F716C88A6
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 23:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232111AbjCXW5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 18:57:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232210AbjCXW5H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 18:57:07 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DC81B2DD
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:57:05 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id d4-20020a056a00198400b00628000145bcso1640998pfl.0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 15:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679698625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/fIRRdgPCgBRvDIGGoFa8ok4zH3WFx33TPTLVE0KAd8=;
        b=SYD3OTPFduy/T7MgK+/Y4Vmd6gcz2iAYriMbT3n5YgDXFHLH+u8BznSuJ7KHLy5G8A
         NisvIEBG7ZGnPzcowYPruW/9cRWXRUZdicoR6qsewdGO9VLV6/ditI3b3CQTWGieKF2A
         aBiSFylQf5X+iNmkblLxbHjEL/oHBQ3GIBgUsE7cDdF07DeqqIAHrj0/hQxRkGSvD72W
         gOvVqz+jm8uL+KAAAMHLcPbA5OBKTS7rQSXxKQAumBRmpUiseOlNv907xwfFYv3fRttL
         AYFdLlYwnIMjt/YpBU0ScAyM5+jj024dJ6eYmokA5PhqT7bF7z8jePdpSbz1R8nmTp66
         Nqdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679698625;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/fIRRdgPCgBRvDIGGoFa8ok4zH3WFx33TPTLVE0KAd8=;
        b=cgRR9vybXu31seBgHVGTKhMFDeEIBiatQM6oER0bcPxcuKrB+M7DFZy5yqr8oWsX0+
         nMAL9Z3kXyVabraM/cG1EqeWXqoUcbel3Ew65jT1Z2g8bV8VlgO9xSDxKz89TFTrJzZV
         49Rb9Jvlvw5JEzdHgIPLaBf48/FnuJy8Nnwp7Nqfj+aqooyAqMUaT3AVtpWm5aYX/7x7
         yZX9+lQR7ABRp3dsKudFa+OSKaIP6U5IfdhMIY4WdTXDy4DVEHP8Qx7ZUkEr1zqSu9gj
         WADsnb5WAf3WRSEsbA1QgQHZyyUqwlUfHPJ6GztIJShMy7yYiMP4IJqtXN4pSpau5PS0
         RcLw==
X-Gm-Message-State: AAQBX9dNkth7yxl3STvFlE03EHrLGN+M58+ltEa53RG52L3f7wKIR3S6
        /ijOLYNgLUKhJApWbH3/RV2F4+CtMm2sVtlBgKf/ykEWHeobGMvswhuBxSwThzoloLtO/R1MdX7
        U93L+PLWMFKojrK6fx9zT/N5QT6ILj5yLflaSsvcNqnbEtaIcarU8Fw==
X-Google-Smtp-Source: AKy350ZxgarTgNAJY012bEkiG0uUm1FWhP4hKTWNz/Npzd+p46a9VeLvBfeTlofogL5iXgI7aFTXBZ0=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:90a:690f:b0:23f:a26e:daa3 with SMTP id
 r15-20020a17090a690f00b0023fa26edaa3mr1320651pjj.9.1679698625129; Fri, 24 Mar
 2023 15:57:05 -0700 (PDT)
Date:   Fri, 24 Mar 2023 15:56:56 -0700
In-Reply-To: <20230324225656.3999785-1-sdf@google.com>
Mime-Version: 1.0
References: <20230324225656.3999785-1-sdf@google.com>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
Message-ID: <20230324225656.3999785-5-sdf@google.com>
Subject: [PATCH net-next v2 4/4] tools: ynl: ethtool testing tool
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is what I've been using to see whether the spec makes sense.
A small subset of getters (mostly the unprivileged ones) is implemented.
Some setters (channels) also work.
Setters for messages with bitmasks are not implemented.

Initially I was trying to make this tool look 1:1 like real ethtool,
but eventually gave up :-)

Sample output:

$ ./tools/net/ynl/ethtool enp0s31f6
Settings for enp0s31f6:
Supported ports: [ TP ]
Supported link modes: 10baseT/Half 10baseT/Full 100baseT/Half
100baseT/Full 1000baseT/Full
Supported pause frame use: no
Supports auto-negotiation: yes
Supported FEC modes: Not reported
Speed: Unknown!
Duplex: Unknown! (255)
Auto-negotiation: on
Port: Twisted Pair
PHYAD: 2
Transceiver: Internal
MDI-X: Unknown (auto)
Current message level: drv probe link
Link detected: no

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/net/ynl/ethtool       | 424 ++++++++++++++++++++++++++++++++++++
 tools/net/ynl/lib/nlspec.py |   9 +
 tools/net/ynl/lib/ynl.py    |  11 +
 3 files changed, 444 insertions(+)
 create mode 100755 tools/net/ynl/ethtool

diff --git a/tools/net/ynl/ethtool b/tools/net/ynl/ethtool
new file mode 100755
index 000000000000..26a5d93acc70
--- /dev/null
+++ b/tools/net/ynl/ethtool
@@ -0,0 +1,424 @@
+#!/usr/bin/env python3
+# SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
+
+import argparse
+import json
+import pprint
+import sys
+import re
+
+from lib import YnlFamily
+
+def args_to_req(ynl, op_name, args, req):
+  """
+  Verify and convert command-line arguments to the ynl-compatible request.
+  """
+  valid_attrs = ynl.operation_do_attributes(op_name)
+  valid_attrs.remove('header') # not user-provided
+
+  if len(args) == 0:
+    print(f'no attributes, expected: {valid_attrs}')
+    sys.exit(1)
+
+  i = 0
+  while i < len(args):
+    attr = args[i]
+    if i + 1 >= len(args):
+      print(f'expected value for \'{attr}\'')
+      sys.exit(1)
+
+    if attr not in valid_attrs:
+      print(f'invalid attribute \'{attr}\', expected: {valid_attrs}')
+      sys.exit(1)
+
+    val = args[i+1]
+    i += 2
+
+    req[attr] = val
+
+def print_field(reply, *desc):
+  """
+  Pretty-print a set of fields from the reply. desc specifies the
+  fields and the optional type (bool/yn).
+  """
+  if len(desc) == 0:
+    return print_field(reply, *zip(reply.keys(), reply.keys()))
+
+  for spec in desc:
+    try:
+      field, name, tp = spec
+    except:
+      field, name = spec
+      tp = 'int'
+
+    value = reply.get(field, None)
+    if tp == 'yn':
+      value = 'yes' if value else 'no'
+    elif tp == 'bool' or isinstance(value, bool):
+      value = 'on' if value else 'off'
+    else:
+      value = 'n/a' if value is None else value
+
+    print(f'{name}: {value}')
+
+def print_speed(name, value):
+  """
+  Print out the speed-like strings from the value dict.
+  """
+  speed_re = re.compile(r'[0-9]+base[^/]+/.+')
+  speed = [ k for k, v in value.items() if v and speed_re.match(k) ]
+  print(f'{name}: {" ".join(speed)}')
+
+def doit(ynl, args, op_name):
+  """
+  Prepare request header, parse arguments and doit.
+  """
+  req = {
+      'header': {
+        'dev-name': args.device,
+      },
+  }
+
+  args_to_req(ynl, op_name, args.args, req)
+  ynl.do(op_name, req)
+
+def dumpit(ynl, args, op_name, extra = {}):
+  """
+  Prepare request header, parse arguments and dumpit (filtering out the
+  devices we're not interested in).
+  """
+  reply = ynl.dump(op_name, { 'header': {} } | extra)
+  if not reply:
+    return {}
+
+  for msg in reply:
+    if msg['header']['dev-name'] == args.device:
+      if args.json:
+        pprint.PrettyPrinter().pprint(msg)
+        sys.exit(0)
+      msg.pop('header', None)
+      return msg
+
+  print(f"Not supported for device {args.device}")
+  sys.exit(1)
+
+def bits_to_dict(attr):
+  """
+  Convert ynl-formatted bitmask to a dict of bit=value.
+  """
+  ret = {}
+  if 'bits' not in attr:
+    return dict()
+  if 'bit' not in attr['bits']:
+    return dict()
+  for bit in attr['bits']['bit']:
+    if bit['name'] == '':
+      continue
+    name = bit['name']
+    value = bit.get('value', False)
+    ret[name] = value
+  return ret
+
+def main():
+  parser = argparse.ArgumentParser(description='ethtool wannabe')
+  parser.add_argument('--json', action=argparse.BooleanOptionalAction)
+  parser.add_argument('--show-priv-flags', action=argparse.BooleanOptionalAction)
+  parser.add_argument('--set-priv-flags', action=argparse.BooleanOptionalAction)
+  parser.add_argument('--show-eee', action=argparse.BooleanOptionalAction)
+  parser.add_argument('--set-eee', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-a', '--show-pause', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-A', '--set-pause', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-c', '--show-coalesce', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-C', '--set-coalesce', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-g', '--show-ring', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-G', '--set-ring', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-k', '--show-features', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-K', '--set-features', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-l', '--show-channels', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-L', '--set-channels', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-T', '--show-time-stamping', action=argparse.BooleanOptionalAction)
+  parser.add_argument('-S', '--statistics', action=argparse.BooleanOptionalAction)
+  # TODO: --show-tunnels        tunnel-info-get
+  # TODO: --show-module         module-get
+  # TODO: --get-plca-cfg        plca-get
+  # TODO: --get-plca-status     plca-get-status
+  # TODO: --show-mm             mm-get
+  # TODO: --show-fec            fec-get
+  # TODO: --dump-module-eerpom  module-eeprom-get
+  # TODO:                       pse-get
+  # TODO:                       rss-get
+  parser.add_argument('device', metavar='device', type=str)
+  parser.add_argument('args', metavar='args', type=str, nargs='*')
+  global args
+  args = parser.parse_args()
+
+  spec = '/usr/local/google/home/sdf/src/linux/Documentation/netlink/specs/ethtool.yaml'
+  schema = '/usr/local/google/home/sdf/src/linux/Documentation/netlink/genetlink-legacy.yaml'
+
+  ynl = YnlFamily(spec, schema)
+
+  if args.set_priv_flags:
+    # TODO: parse the bitmask
+    print("not implemented")
+    return
+
+  if args.set_eee:
+    return doit(ynl, args, 'eee-set')
+
+  if args.set_pause:
+    return doit(ynl, args, 'pause-set')
+
+  if args.set_coalesce:
+    return doit(ynl, args, 'coalesce-set')
+
+  if args.set_features:
+    # TODO: parse the bitmask
+    print("not implemented")
+    return
+
+  if args.set_channels:
+    return doit(ynl, args, 'channels-set')
+
+  if args.set_ring:
+    return doit(ynl, args, 'rings-set')
+
+  if args.show_priv_flags:
+    flags = bits_to_dict(dumpit(ynl, args, 'privflags-get')['flags'])
+    print_field(flags)
+    return
+
+  if args.show_eee:
+    eee = dumpit(ynl, args, 'eee-get')
+    ours = bits_to_dict(eee['modes-ours'])
+    peer = bits_to_dict(eee['modes-peer'])
+
+    if 'enabled' in eee:
+        status = 'enabled' if eee['enabled'] else 'disabled'
+        if 'active' in eee and eee['active']:
+            status = status + ' - active'
+        else:
+            status = status + ' - inactive'
+    else:
+        status = 'not supported'
+
+    print(f'EEE status: {status}')
+    print_field(eee, ('tx-lpi-timer', 'Tx LPI'))
+    print_speed('Advertised EEE link modes', ours)
+    print_speed('Link partner advertised EEE link modes', peer)
+
+    return
+
+  if args.show_pause:
+    print_field(dumpit(ynl, args, 'pause-get'),
+            ('autoneg', 'Autonegotiate', 'bool'),
+            ('rx', 'RX', 'bool'),
+            ('tx', 'TX', 'bool'))
+    return
+
+  if args.show_coalesce:
+    print_field(dumpit(ynl, args, 'coalesce-get'))
+    return
+
+  if args.show_features:
+    reply = dumpit(ynl, args, 'features-get')
+    available = bits_to_dict(reply['hw'])
+    requested = bits_to_dict(reply['wanted']).keys()
+    active = bits_to_dict(reply['active']).keys()
+    never_changed = bits_to_dict(reply['nochange']).keys()
+
+    for f in sorted(available):
+      value = "off"
+      if f in active:
+        value = "on"
+
+      fixed = ""
+      if f not in available or f in never_changed:
+        fixed = " [fixed]"
+
+      req = ""
+      if f in requested:
+        if f in active:
+          req = " [requested on]"
+        else:
+          req = " [requested off]"
+
+      print(f'{f}: {value}{fixed}{req}')
+
+    return
+
+  if args.show_channels:
+    reply = dumpit(ynl, args, 'channels-get')
+    print(f'Channel parameters for {args.device}:')
+
+    print(f'Pre-set maximums:')
+    print_field(reply,
+        ('rx-max', 'RX'),
+        ('tx-max', 'TX'),
+        ('other-max', 'Other'),
+        ('combined-max', 'Combined'))
+
+    print(f'Current hardware settings:')
+    print_field(reply,
+        ('rx-count', 'RX'),
+        ('tx-count', 'TX'),
+        ('other-count', 'Other'),
+        ('combined-count', 'Combined'))
+
+    return
+
+  if args.show_ring:
+    reply = dumpit(ynl, args, 'channels-get')
+
+    print(f'Ring parameters for {args.device}:')
+
+    print(f'Pre-set maximums:')
+    print_field(reply,
+        ('rx-max', 'RX'),
+        ('rx-mini-max', 'RX Mini'),
+        ('rx-jumbo-max', 'RX Jumbo'),
+        ('tx-max', 'TX'))
+
+    print(f'Current hardware settings:')
+    print_field(reply,
+        ('rx', 'RX'),
+        ('rx-mini', 'RX Mini'),
+        ('rx-jumbo', 'RX Jumbo'),
+        ('tx', 'TX'))
+
+    print_field(reply,
+        ('rx-buf-len', 'RX Buf Len'),
+        ('cqe-size', 'CQE Size'),
+        ('tx-push', 'TX Push', 'bool'))
+
+    return
+
+  if args.statistics:
+    print(f'NIC statistics:')
+
+    # TODO: pass id?
+    strset = dumpit(ynl, args, 'strset-get')
+    pprint.PrettyPrinter().pprint(strset)
+
+    req = {
+      'groups': {
+        'size': 1,
+        'bits': {
+          'bit':
+            # TODO: support passing the bitmask
+            #[
+              #{ 'name': 'eth-phy', 'value': True },
+              { 'name': 'eth-mac', 'value': True },
+              #{ 'name': 'eth-ctrl', 'value': True },
+              #{ 'name': 'rmon', 'value': True },
+            #],
+        },
+      },
+    }
+
+    rsp = dumpit(ynl, args, 'stats-get', req)
+    pprint.PrettyPrinter().pprint(rsp)
+    return
+
+  if args.show_time_stamping:
+    tsinfo = dumpit(ynl, args, 'tsinfo-get')
+
+    print(f'Time stamping parameters for {args.device}:')
+
+    print('Capabilities:')
+    [print(f'\t{v}') for v in bits_to_dict(tsinfo['timestamping'])]
+
+    print(f'PTP Hardware Clock: {tsinfo["phc-index"]}')
+
+    print('Hardware Transmit Timestamp Modes:')
+    [print(f'\t{v}') for v in bits_to_dict(tsinfo['tx-types'])]
+
+    print('Hardware Receive Filter Modes:')
+    [print(f'\t{v}') for v in bits_to_dict(tsinfo['rx-filters'])]
+    return
+
+  print(f'Settings for {args.device}:')
+  linkmodes = dumpit(ynl, args, 'linkmodes-get')
+  ours = bits_to_dict(linkmodes['ours'])
+
+  supported_ports = ('TP',  'AUI', 'BNC', 'MII', 'FIBRE', 'Backplane')
+  ports = [ p for p in supported_ports if ours.get(p, False)]
+  print(f'Supported ports: [ {" ".join(ports)} ]')
+
+  print_speed('Supported link modes', ours)
+
+  print_field(ours, ('Pause', 'Supported pause frame use', 'yn'))
+  print_field(ours, ('Autoneg', 'Supports auto-negotiation', 'yn'))
+
+  supported_fec = ('None',  'PS', 'BASER', 'LLRS')
+  fec = [ p for p in supported_fec if ours.get(p, False)]
+  fec_str = " ".join(fec)
+  if len(fec) == 0:
+    fec_str = "Not reported"
+
+  print(f'Supported FEC modes: {fec_str}')
+
+  speed = 'Unknown!'
+  if linkmodes['speed'] > 0 and linkmodes['speed'] < 0xffffffff:
+    speed = f'{linkmodes["speed"]}Mb/s'
+  print(f'Speed: {speed}')
+
+  duplex_modes = {
+          0: 'Half',
+          1: 'Full',
+  }
+  duplex = duplex_modes.get(linkmodes["duplex"], None)
+  if not duplex:
+    duplex = f'Unknown! ({linkmodes["duplex"]})'
+  print(f'Duplex: {duplex}')
+
+  autoneg = "off"
+  if linkmodes.get("autoneg", 0) != 0:
+    autoneg = "on"
+  print(f'Auto-negotiation: {autoneg}')
+
+  ports = {
+          0: 'Twisted Pair',
+          1: 'AUI',
+          2: 'MII',
+          3: 'FIBRE',
+          4: 'BNC',
+          5: 'Directly Attached Copper',
+          0xef: 'None',
+  }
+  linkinfo = dumpit(ynl, args, 'linkinfo-get')
+  print(f'Port: {ports.get(linkinfo["port"], "Other")}')
+
+  print_field(linkinfo, ('phyaddr', 'PHYAD'))
+
+  transceiver = {
+          0: 'Internal',
+          1: 'External',
+  }
+  print(f'Transceiver: {transceiver.get(linkinfo["transceiver"], "Unknown")}')
+
+  mdix_ctrl = {
+          1: 'off',
+          2: 'on',
+  }
+  mdix = mdix_ctrl.get(linkinfo['tp-mdix-ctrl'], None)
+  if mdix:
+    mdix = mdix + ' (forced)'
+  else:
+    mdix = mdix_ctrl.get(linkinfo['tp-mdix'], 'Unknown (auto)')
+  print(f'MDI-X: {mdix}')
+
+  debug = dumpit(ynl, args, 'debug-get')
+  msgmask = bits_to_dict(debug.get("msgmask", [])).keys()
+  print(f'Current message level: {" ".join(msgmask)}')
+
+  linkstate = dumpit(ynl, args, 'linkstate-get')
+  detected_states = {
+          0: 'no',
+          1: 'yes',
+  }
+  # TODO: wol-get
+  detected = detected_states.get(linkstate['link'], 'unknown')
+  print(f'Link detected: {detected}')
+
+if __name__ == '__main__':
+  main()
diff --git a/tools/net/ynl/lib/nlspec.py b/tools/net/ynl/lib/nlspec.py
index d04450c2a44a..174690fccfcd 100644
--- a/tools/net/ynl/lib/nlspec.py
+++ b/tools/net/ynl/lib/nlspec.py
@@ -392,6 +392,15 @@ jsonschema = None
 
             self.msgs[op.name] = op
 
+    def find_operation(self, name):
+      """
+      For a given operation name, find and return operation spec.
+      """
+      for op in self.yaml['operations']['list']:
+        if name == op['name']:
+          return op
+      return None
+
     def resolve(self):
         self.resolve_up(super())
 
diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index b05c341e278c..cd9d815bb6ec 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -490,6 +490,17 @@ genl_family_name_to_id = None
 
                 self.handle_ntf(nl_msg, gm)
 
+    def operation_do_attributes(self, name):
+      """
+      For a given operation name, find and return a supported
+      set of attributes (as a dict).
+      """
+      op = self.find_operation(name)
+      if not op:
+        return None
+
+      return op['do']['request']['attributes'].copy()
+
     def _op(self, method, vals, dump=False):
         op = self.ops[method]
 
-- 
2.40.0.348.gf938b09366-goog

