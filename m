Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 390D331D3AC
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 02:12:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229924AbhBQBMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 20:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231462AbhBQBJv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 20:09:51 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5583C061797;
        Tue, 16 Feb 2021 17:08:53 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id x136so7366519pfc.2;
        Tue, 16 Feb 2021 17:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sHn1TcXA40LLznUdfZ0EnywfCC8GI0Od3igBD7EM/qA=;
        b=inLrmew4Cded46OMVXm440//MhXtGm/AFsHnPkZUJZ0Si7ZBGly2nyrIYt4eVXqxcT
         PMpocNArusisJd0qlkPyA3DTH1dMjPlc23YjUa59l22XmiX8bb++C+G9mUAB7/Y31a3i
         7tF1TNy/soSno0eOqnG9ONKxyK1t+ZnYoeJ5JD+asBwyi+8nZyAfVvSsgF8iDcMlxFgF
         HYwyuDVU1n4fV+WPPd2J69Hd5bzAA4Z/gM5k8ibY7+sCJKopV8UlUlObq/GRXNutCuyl
         KM2QCoLQcV3hiZyzV1b7pmIryruBGrWvM5b0WqO1nVw+JmREvaQMKM8CEcv/rd1vR4QQ
         JiqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=sHn1TcXA40LLznUdfZ0EnywfCC8GI0Od3igBD7EM/qA=;
        b=N61xoY9htilY5c24HLVrFUqB+YiTZ+p12u5UwUyc59EQx94ZY8CcTHBwQfYHPeDuvC
         EEXzWehBWXKXe6Ua3Kz23XZAljZPuPH+tMPJTMhbROfuhlJQOkxS6YGbq7tDzxoTGgke
         0+4LUgczSybcrIuGBBSWdHsaTXkLSHao/IviMZYlZM0yy5gGlxBdFepgT+Gzf+Hi5smQ
         XobsvgiJaW/qUaTEiQmkO700TOyavshZ7BruZvXln3D/Ls5wor/jOurP/v0qdN5W1+4R
         OMnI48P6Sqz4pOKe+9TP5onpqOt4CPOxTzY5DG8umGOLipzEdsUq83+yhJ0OWJcK8GJE
         9e0A==
X-Gm-Message-State: AOAM531J5inh5hrxGyRKyy64etzkuawxG100MWwTflcyTeyG1s8pCKZB
        mXqDoeK2or0akqIaHD0w7UaZHquE5OtROA==
X-Google-Smtp-Source: ABdhPJys71FeVg+7o5aVJCeZX3Mu9fkvHyCeuAc359Q8UbtC07NsulXwihDGuXTSL8QRccUrb/aD7A==
X-Received: by 2002:a63:4507:: with SMTP id s7mr21678588pga.390.1613524132973;
        Tue, 16 Feb 2021 17:08:52 -0800 (PST)
Received: from localhost.localdomain (c-73-93-5-123.hsd1.ca.comcast.net. [73.93.5.123])
        by smtp.gmail.com with ESMTPSA id c22sm175770pfc.12.2021.02.16.17.08.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Feb 2021 17:08:52 -0800 (PST)
Sender: Joe Stringer <joestringernz@gmail.com>
From:   Joe Stringer <joe@wand.net.nz>
To:     bpf@vger.kernel.org
Cc:     Joe Stringer <joe@cilium.io>, netdev@vger.kernel.org,
        daniel@iogearbox.net, ast@kernel.org, mtk.manpages@gmail.com,
        Quentin Monnet <quentin@isovalent.com>
Subject: [PATCH bpf-next 11/17] scripts/bpf: Add syscall commands printer
Date:   Tue, 16 Feb 2021 17:08:15 -0800
Message-Id: <20210217010821.1810741-12-joe@wand.net.nz>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210217010821.1810741-1-joe@wand.net.nz>
References: <20210217010821.1810741-1-joe@wand.net.nz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Joe Stringer <joe@cilium.io>

Add a new target to bpf_doc.py to support generating the list of syscall
commands directly from the UAPI headers. Assuming that developer
submissions keep the main header up to date, this should allow the man
pages to be automatically generated based on the latest API changes
rather than requiring someone to separately go back through the API and
describe each command.

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
Signed-off-by: Joe Stringer <joe@cilium.io>
---
 scripts/bpf_doc.py | 98 +++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 89 insertions(+), 9 deletions(-)

diff --git a/scripts/bpf_doc.py b/scripts/bpf_doc.py
index 5a4f68aab335..72a2ba323692 100755
--- a/scripts/bpf_doc.py
+++ b/scripts/bpf_doc.py
@@ -14,6 +14,9 @@ import sys, os
 class NoHelperFound(BaseException):
     pass
 
+class NoSyscallCommandFound(BaseException):
+    pass
+
 class ParsingError(BaseException):
     def __init__(self, line='<line not provided>', reader=None):
         if reader:
@@ -23,18 +26,27 @@ class ParsingError(BaseException):
         else:
             BaseException.__init__(self, 'Error parsing line: %s' % line)
 
-class Helper(object):
+
+class APIElement(object):
     """
-    An object representing the description of an eBPF helper function.
-    @proto: function prototype of the helper function
-    @desc: textual description of the helper function
-    @ret: description of the return value of the helper function
+    An object representing the description of an aspect of the eBPF API.
+    @proto: prototype of the API symbol
+    @desc: textual description of the symbol
+    @ret: (optional) description of any associated return value
     """
     def __init__(self, proto='', desc='', ret=''):
         self.proto = proto
         self.desc = desc
         self.ret = ret
 
+
+class Helper(APIElement):
+    """
+    An object representing the description of an eBPF helper function.
+    @proto: function prototype of the helper function
+    @desc: textual description of the helper function
+    @ret: description of the return value of the helper function
+    """
     def proto_break_down(self):
         """
         Break down helper function protocol into smaller chunks: return type,
@@ -61,6 +73,7 @@ class Helper(object):
 
         return res
 
+
 class HeaderParser(object):
     """
     An object used to parse a file in order to extract the documentation of a
@@ -73,6 +86,13 @@ class HeaderParser(object):
         self.reader = open(filename, 'r')
         self.line = ''
         self.helpers = []
+        self.commands = []
+
+    def parse_element(self):
+        proto    = self.parse_symbol()
+        desc     = self.parse_desc()
+        ret      = self.parse_ret()
+        return APIElement(proto=proto, desc=desc, ret=ret)
 
     def parse_helper(self):
         proto    = self.parse_proto()
@@ -80,6 +100,18 @@ class HeaderParser(object):
         ret      = self.parse_ret()
         return Helper(proto=proto, desc=desc, ret=ret)
 
+    def parse_symbol(self):
+        p = re.compile(' \* ?(.+)$')
+        capture = p.match(self.line)
+        if not capture:
+            raise NoSyscallCommandFound
+        end_re = re.compile(' \* ?NOTES$')
+        end = end_re.match(self.line)
+        if end:
+            raise NoSyscallCommandFound
+        self.line = self.reader.readline()
+        return capture.group(1)
+
     def parse_proto(self):
         # Argument can be of shape:
         #   - "void"
@@ -141,16 +173,29 @@ class HeaderParser(object):
                     break
         return ret
 
-    def run(self):
-        # Advance to start of helper function descriptions.
-        offset = self.reader.read().find('* Start of BPF helper function descriptions:')
+    def seek_to(self, target, help_message):
+        self.reader.seek(0)
+        offset = self.reader.read().find(target)
         if offset == -1:
-            raise Exception('Could not find start of eBPF helper descriptions list')
+            raise Exception(help_message)
         self.reader.seek(offset)
         self.reader.readline()
         self.reader.readline()
         self.line = self.reader.readline()
 
+    def parse_syscall(self):
+        self.seek_to('* Start of BPF syscall commands:',
+                     'Could not find start of eBPF syscall descriptions list')
+        while True:
+            try:
+                command = self.parse_element()
+                self.commands.append(command)
+            except NoSyscallCommandFound:
+                break
+
+    def parse_helpers(self):
+        self.seek_to('* Start of BPF helper function descriptions:',
+                     'Could not find start of eBPF helper descriptions list')
         while True:
             try:
                 helper = self.parse_helper()
@@ -158,6 +203,9 @@ class HeaderParser(object):
             except NoHelperFound:
                 break
 
+    def run(self):
+        self.parse_syscall()
+        self.parse_helpers()
         self.reader.close()
 
 ###############################################################################
@@ -420,6 +468,37 @@ SEE ALSO
         self.print_elem(helper)
 
 
+class PrinterSyscallRST(PrinterRST):
+    """
+    A printer for dumping collected information about the syscall API as a
+    ReStructured Text page compatible with the rst2man program, which can be
+    used to generate a manual page for the syscall.
+    @parser: A HeaderParser with APIElement objects to print to standard
+             output
+    """
+    def __init__(self, parser):
+        self.elements = parser.commands
+
+    def print_header(self):
+        header = '''\
+===
+bpf
+===
+-------------------------------------------------------------------------------
+Perform a command on an extended BPF object
+-------------------------------------------------------------------------------
+
+:Manual section: 2
+
+COMMANDS
+========
+'''
+        PrinterRST.print_license(self)
+        print(header)
+
+    def print_one(self, command):
+        print('**%s**' % (command.proto))
+        self.print_elem(command)
 
 
 class PrinterHelpers(Printer):
@@ -620,6 +699,7 @@ bpfh = os.path.join(linuxRoot, 'include/uapi/linux/bpf.h')
 
 printers = {
         'helpers': PrinterHelpersRST,
+        'syscall': PrinterSyscallRST,
 }
 
 argParser = argparse.ArgumentParser(description="""
-- 
2.27.0

