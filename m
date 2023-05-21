Return-Path: <netdev+bounces-4117-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98AE270AF1C
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 19:08:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 584D61C208E8
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 17:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C01746FDC;
	Sun, 21 May 2023 17:08:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1D86FDB
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 17:08:08 +0000 (UTC)
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFA72E5E;
	Sun, 21 May 2023 10:08:06 -0700 (PDT)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-561d611668eso66265247b3.0;
        Sun, 21 May 2023 10:08:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684688885; x=1687280885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vZ93v4l0cZOAEU2RmseKcyvjrhKTYZPk+NiyYKAO2Vk=;
        b=D7WDkyHbZRm4+AdekHJXSmfTXj2PMztrXN00eDcmKmQi+4CTnabT4S0XIFOETpPMQK
         y1dhVQHP/YLa3ZX7xTGe06i/B33b9btG55d5ihUnyTZboGAnBCkNZmHb8JDOBhZL6Dej
         2fGlMonuZ8whjRmzvpXxFEJ4LTkN/Do1Cfku0UfZkPIW+hs9HL+xWPFHQy3dHprcr7xJ
         nr7SN2tLHO1DpwRBm4cgptLAYyiwRADptOZGPKl1zLCtJ6GVKQcNgu7vQrYQNpnyEkLs
         Wrc01zfn5p4phJXvpDB8iLY3SmQaZjRxKPQZVyWA5BYGue9CQnaSuUElbTWnJvq79Y4y
         XetA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684688885; x=1687280885;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vZ93v4l0cZOAEU2RmseKcyvjrhKTYZPk+NiyYKAO2Vk=;
        b=C7hqHThB5UgebOSMNGcT82RExy+Xbf5ujhEuDJ/BxQht3usyw38n5Y/9FXr4o8BhNU
         0gxq4oiqcO1TmFZxHvt8Fy9yr1DNaOveHMVbqkduwaNS/hHwBxS4dUoT/DPQYHs2bNp7
         kzDF14Rz95cJ6I0/gtO2vOOz+P4ASgSYdlNLaSzaYo+LrdrVnfCEQz70vEu9PYqc9xQT
         obOUw9k21OVuM71VJL/S31+gV9dhTu5UAdZSL7HxkZVMB8Kd9aUKgBftJt2oCJpD9C9X
         c9d/s5K3PZTVUQ3IdMYpf8mapebPhwVirl299hobfsWFWJtfKrkZdasqymw8s1axeD6T
         QDIg==
X-Gm-Message-State: AC+VfDzY2EURADqWpXzXI0URKLpglL4j1+cEkYA16zhMcNUguPiW+OqF
	c6ZgFqKLlgjrVm3ssin1M16aJojar+myeVZO
X-Google-Smtp-Source: ACHHUZ432Or7iknCmbL4zjgwqJ39Phl386aFZzG/vSiRCA08s9/PekZ5hIYaFCuIkxTz6N0W8Mn8jA==
X-Received: by 2002:a81:c247:0:b0:55a:20a1:4ba6 with SMTP id t7-20020a81c247000000b0055a20a14ba6mr8802692ywg.25.1684688885423;
        Sun, 21 May 2023 10:08:05 -0700 (PDT)
Received: from imac.fritz.box ([2a02:8010:60a0:0:7d01:949c:686a:2dea])
        by smtp.gmail.com with ESMTPSA id y185-20020a817dc2000000b00545a08184fdsm1420062ywc.141.2023.05.21.10.08.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 10:08:04 -0700 (PDT)
From: Donald Hunter <donald.hunter@gmail.com>
To: netdev@vger.kernel.org,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-doc@vger.kernel.org
Cc: donald.hunter@redhat.com,
	Donald Hunter <donald.hunter@gmail.com>
Subject: [patch net-next v1 1/2] tools: ynl: Use dict of predefined Structs to decode scalar types
Date: Sun, 21 May 2023 18:07:32 +0100
Message-Id: <20230521170733.13151-2-donald.hunter@gmail.com>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230521170733.13151-1-donald.hunter@gmail.com>
References: <20230521170733.13151-1-donald.hunter@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use a dict of predefined Struct() objects to decode scalar types in native,
big or little endian format. This removes the repetitive code for the
scalar variants and ensures all the signed variants are supported.

Signed-off-by: Donald Hunter <donald.hunter@gmail.com>
---
 tools/net/ynl/lib/ynl.py | 107 ++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 59 deletions(-)

diff --git a/tools/net/ynl/lib/ynl.py b/tools/net/ynl/lib/ynl.py
index aa77bcae4807..62e31db07c1f 100644
--- a/tools/net/ynl/lib/ynl.py
+++ b/tools/net/ynl/lib/ynl.py
@@ -1,10 +1,12 @@
 # SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
 
+from collections import namedtuple
 import functools
 import os
 import random
 import socket
 import struct
+from struct import Struct
 import yaml
 
 from .nlspec import SpecFamily
@@ -76,10 +78,17 @@ class NlError(Exception):
 
 
 class NlAttr:
-    type_formats = { 'u8' : ('B', 1), 's8' : ('b', 1),
-                     'u16': ('H', 2), 's16': ('h', 2),
-                     'u32': ('I', 4), 's32': ('i', 4),
-                     'u64': ('Q', 8), 's64': ('q', 8) }
+    ScalarFormat = namedtuple('ScalarFormat', ['native', 'big', 'little'])
+    type_formats = {
+        'u8' : ScalarFormat(Struct('B'), Struct("B"),  Struct("B")),
+        's8' : ScalarFormat(Struct('b'), Struct("b"),  Struct("b")),
+        'u16': ScalarFormat(Struct('H'), Struct(">H"), Struct("<H")),
+        's16': ScalarFormat(Struct('h'), Struct(">h"), Struct("<h")),
+        'u32': ScalarFormat(Struct('I'), Struct(">I"), Struct("<I")),
+        's32': ScalarFormat(Struct('i'), Struct(">i"), Struct("<i")),
+        'u64': ScalarFormat(Struct('Q'), Struct(">Q"), Struct("<Q")),
+        's64': ScalarFormat(Struct('q'), Struct(">q"), Struct("<q"))
+    }
 
     def __init__(self, raw, offset):
         self._len, self._type = struct.unpack("HH", raw[offset:offset + 4])
@@ -88,25 +97,17 @@ class NlAttr:
         self.full_len = (self.payload_len + 3) & ~3
         self.raw = raw[offset + 4:offset + self.payload_len]
 
-    def format_byte_order(byte_order):
+    @classmethod
+    def get_format(cls, attr_type, byte_order=None):
+        format = cls.type_formats[attr_type]
         if byte_order:
-            return ">" if byte_order == "big-endian" else "<"
-        return ""
+            return format.big if byte_order == "big-endian" \
+                else format.little
+        return format.native
 
-    def as_u8(self):
-        return struct.unpack("B", self.raw)[0]
-
-    def as_u16(self, byte_order=None):
-        endian = NlAttr.format_byte_order(byte_order)
-        return struct.unpack(f"{endian}H", self.raw)[0]
-
-    def as_u32(self, byte_order=None):
-        endian = NlAttr.format_byte_order(byte_order)
-        return struct.unpack(f"{endian}I", self.raw)[0]
-
-    def as_u64(self, byte_order=None):
-        endian = NlAttr.format_byte_order(byte_order)
-        return struct.unpack(f"{endian}Q", self.raw)[0]
+    def as_scalar(self, attr_type, byte_order=None):
+        format = self.get_format(attr_type, byte_order)
+        return format.unpack(self.raw)[0]
 
     def as_strz(self):
         return self.raw.decode('ascii')[:-1]
@@ -115,17 +116,17 @@ class NlAttr:
         return self.raw
 
     def as_c_array(self, type):
-        format, _ = self.type_formats[type]
-        return list({ x[0] for x in struct.iter_unpack(format, self.raw) })
+        format = self.get_format(type)
+        return list({ x[0] for x in format.iter_unpack(self.raw) })
 
     def as_struct(self, members):
         value = dict()
         offset = 0
         for m in members:
             # TODO: handle non-scalar members
-            format, size = self.type_formats[m.type]
-            decoded = struct.unpack_from(format, self.raw, offset)
-            offset += size
+            format = self.get_format(m.type)
+            decoded = format.unpack_from(self.raw, offset)
+            offset += format.size
             value[m.name] = decoded[0]
         return value
 
@@ -184,11 +185,11 @@ class NlMsg:
                 if extack.type == Netlink.NLMSGERR_ATTR_MSG:
                     self.extack['msg'] = extack.as_strz()
                 elif extack.type == Netlink.NLMSGERR_ATTR_MISS_TYPE:
-                    self.extack['miss-type'] = extack.as_u32()
+                    self.extack['miss-type'] = extack.as_scalar('u32')
                 elif extack.type == Netlink.NLMSGERR_ATTR_MISS_NEST:
-                    self.extack['miss-nest'] = extack.as_u32()
+                    self.extack['miss-nest'] = extack.as_scalar('u32')
                 elif extack.type == Netlink.NLMSGERR_ATTR_OFFS:
-                    self.extack['bad-attr-offs'] = extack.as_u32()
+                    self.extack['bad-attr-offs'] = extack.as_scalar('u32')
                 else:
                     if 'unknown' not in self.extack:
                         self.extack['unknown'] = []
@@ -272,11 +273,11 @@ def _genl_load_families():
                 fam = dict()
                 for attr in gm.raw_attrs:
                     if attr.type == Netlink.CTRL_ATTR_FAMILY_ID:
-                        fam['id'] = attr.as_u16()
+                        fam['id'] = attr.as_scalar('u16')
                     elif attr.type == Netlink.CTRL_ATTR_FAMILY_NAME:
                         fam['name'] = attr.as_strz()
                     elif attr.type == Netlink.CTRL_ATTR_MAXATTR:
-                        fam['maxattr'] = attr.as_u32()
+                        fam['maxattr'] = attr.as_scalar('u32')
                     elif attr.type == Netlink.CTRL_ATTR_MCAST_GROUPS:
                         fam['mcast'] = dict()
                         for entry in NlAttrs(attr.raw):
@@ -286,7 +287,7 @@ def _genl_load_families():
                                 if entry_attr.type == Netlink.CTRL_ATTR_MCAST_GRP_NAME:
                                     mcast_name = entry_attr.as_strz()
                                 elif entry_attr.type == Netlink.CTRL_ATTR_MCAST_GRP_ID:
-                                    mcast_id = entry_attr.as_u32()
+                                    mcast_id = entry_attr.as_scalar('u32')
                             if mcast_name and mcast_id is not None:
                                 fam['mcast'][mcast_name] = mcast_id
                 if 'name' in fam and 'id' in fam:
@@ -304,9 +305,9 @@ class GenlMsg:
 
         self.fixed_header_attrs = dict()
         for m in fixed_header_members:
-            format, size = NlAttr.type_formats[m.type]
-            decoded = struct.unpack_from(format, nl_msg.raw, offset)
-            offset += size
+            format = NlAttr.get_format(m.type)
+            decoded = format.unpack_from(nl_msg.raw, offset)
+            offset += format.size
             self.fixed_header_attrs[m.name] = decoded[0]
 
         self.raw = nl_msg.raw[offset:]
@@ -381,23 +382,16 @@ class YnlFamily(SpecFamily):
                 attr_payload += self._add_attr(attr['nested-attributes'], subname, subvalue)
         elif attr["type"] == 'flag':
             attr_payload = b''
-        elif attr["type"] == 'u8':
-            attr_payload = struct.pack("B", int(value))
-        elif attr["type"] == 'u16':
-            endian = NlAttr.format_byte_order(attr.byte_order)
-            attr_payload = struct.pack(f"{endian}H", int(value))
-        elif attr["type"] == 'u32':
-            endian = NlAttr.format_byte_order(attr.byte_order)
-            attr_payload = struct.pack(f"{endian}I", int(value))
-        elif attr["type"] == 'u64':
-            endian = NlAttr.format_byte_order(attr.byte_order)
-            attr_payload = struct.pack(f"{endian}Q", int(value))
         elif attr["type"] == 'string':
             attr_payload = str(value).encode('ascii') + b'\x00'
         elif attr["type"] == 'binary':
             attr_payload = value
         else:
-            raise Exception(f'Unknown type at {space} {name} {value} {attr["type"]}')
+            try:
+                format = NlAttr.get_format(attr['type'], attr.byte_order)
+                attr_payload = format.pack(int(value))
+            except:
+                raise Exception(f'Unknown type at {space} {name} {value} {attr["type"]}')
 
         pad = b'\x00' * ((4 - len(attr_payload) % 4) % 4)
         return struct.pack('HH', len(attr_payload) + 4, nl_type) + attr_payload + pad
@@ -434,22 +428,17 @@ class YnlFamily(SpecFamily):
             if attr_spec["type"] == 'nest':
                 subdict = self._decode(NlAttrs(attr.raw), attr_spec['nested-attributes'])
                 decoded = subdict
-            elif attr_spec['type'] == 'u8':
-                decoded = attr.as_u8()
-            elif attr_spec['type'] == 'u16':
-                decoded = attr.as_u16(attr_spec.byte_order)
-            elif attr_spec['type'] == 'u32':
-                decoded = attr.as_u32(attr_spec.byte_order)
-            elif attr_spec['type'] == 'u64':
-                decoded = attr.as_u64(attr_spec.byte_order)
             elif attr_spec["type"] == 'string':
                 decoded = attr.as_strz()
             elif attr_spec["type"] == 'binary':
                 decoded = self._decode_binary(attr, attr_spec)
             elif attr_spec["type"] == 'flag':
                 decoded = True
-            else:
-                raise Exception(f'Unknown {attr.type} {attr_spec["name"]} {attr_spec["type"]}')
+            elif attr_spec["type"]:
+                try:
+                    decoded = attr.as_scalar(attr_spec['type'], attr_spec.byte_order)
+                except:
+                    raise Exception(f'Unknown {attr_spec["type"]} with name {attr_spec["name"]}')
 
             if not attr_spec.is_multi:
                 rsp[attr_spec['name']] = decoded
@@ -555,8 +544,8 @@ class YnlFamily(SpecFamily):
             fixed_header_members = self.consts[op.fixed_header].members
             for m in fixed_header_members:
                 value = vals.pop(m.name)
-                format, _ = NlAttr.type_formats[m.type]
-                msg += struct.pack(format, value)
+                format = NlAttr.get_format(m.type)
+                msg += format.pack(value)
         for name, value in vals.items():
             msg += self._add_attr(op.attr_set.name, name, value)
         msg = _genl_msg_finalize(msg)
-- 
2.39.0


