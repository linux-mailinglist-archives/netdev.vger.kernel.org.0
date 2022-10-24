Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6E7760A1B0
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 13:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230305AbiJXLcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 07:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbiJXLcJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 07:32:09 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35415F7FA
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 04:31:59 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id l28so5409397qtv.4
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 04:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pna0iahsvKNrAR4PJPfEJCF7ulvP3p9hJ//xaJWj+/g=;
        b=bm2Ta5Jv1Gzk64K0dcFSFCbwUhGDjsckyS8tMV+C0UlUgxhQDDxXujYxpVIz/9K8rF
         ZAeSIJlaeTUwsOY8rnniaxJs7ZJ6aeBeB+UBl2DlIPHpfN+SS1/ZoVmb5Zsj4h9+N7pg
         gaKITdFRdy57Q69JXxDs5Ha6bds1YreitMQge+Phs01DITxdlQHQXPuGjXekvFVbvvoP
         5dIIYaaz4ydQWuJBajdw+Dy2hsTYYzmdhlbtrgNElQuPGgAMR4B0uFUVVCkWYd1I/L3o
         ToD8UVz3F/4hMxqu8fs7Yc1jjYiiKYtAjUJ6SQkV9iOJEnntDEATerm8pwH/+4aMO47U
         d//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pna0iahsvKNrAR4PJPfEJCF7ulvP3p9hJ//xaJWj+/g=;
        b=5R9jh1CG0Qc4MR6uzDJy5yHGwux0pHy889awfJPkxPix57xmrA5RNVv5qfxqAa0ScS
         X/ze3W+bLXuXB//Q3XxOF+WhUcdr9V8zLBNJeBn0sIpMUDmE2pkhUINWhsIexDxQCiVh
         7XJD/KJrDpre8q8dMTCiEimg3AKywnQey10A7UB36Th4dEhZmCIXyCcv4EZoyCkklPWN
         tRVg4vAzF5uVF9UWMOxRrXDLrGNP2UhcgvrcXO4VEa08zYz3t/Jw1y/d3dKM+i5IG0uA
         r42gtUq2vGjFV8sc3KyMfx8PuqjFaNW/LxCIwK7T87+rhbPzAjOiai8EdsQ37FyDO0Hj
         k9KQ==
X-Gm-Message-State: ACrzQf3btsxDzh01soYB/ji3s0mqL4++tw5RjX89Y2tNnSiD5vIuSgDx
        cN/rjsNbm4dDXkGUBe1ZPWs4dw==
X-Google-Smtp-Source: AMsMyM4iy9VKppP7ey10nD1NK8EGDW92JdKjothodCQbhsemmVATutiTageJg/yrRDygFB/MHwM0Zw==
X-Received: by 2002:a05:622a:491:b0:39c:e770:2813 with SMTP id p17-20020a05622a049100b0039ce7702813mr27785761qtx.384.1666611118310;
        Mon, 24 Oct 2022 04:31:58 -0700 (PDT)
Received: from localhost.localdomain (bras-base-kntaon1617w-grc-28-184-148-47-103.dsl.bell.ca. [184.148.47.103])
        by smtp.gmail.com with ESMTPSA id u12-20020a05620a0c4c00b006f6874aa615sm393380qki.61.2022.10.24.04.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Oct 2022 04:31:57 -0700 (PDT)
From:   Victor Nogueira <victor@mojatatu.com>
To:     davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        edumazet@google.com, pabeni@redhat.com,
        Victor Nogueira <victor@mojatatu.com>,
        Jeremy Carter <jeremy@mojatatu.com>
Subject: [PATCH] selftests: tc-testing: Add matchJSON to tdc
Date:   Mon, 24 Oct 2022 11:16:03 +0000
Message-Id: <20221024111603.2185410-1-victor@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This allows the use of a matchJSON field in tests to match
against JSON output from the command under test, if that
command outputs JSON.

You specify what you want to match against as a JSON array
or object in the test's matchJSON field. You can leave out
any fields you don't want to match against that are present
in the output and they will be skipped.

An example matchJSON value would look like this:

"matchJSON": [
  {
    "Value": {
      "neighIP": {
        "family": 4,
        "addr": "AQIDBA==",
        "width": 32
      },
      "nsflags": 142,
      "ncflags": 0,
      "LLADDR": "ESIzRFVm"
    }
  }
]

The real output from the command under test might have some
extra fields that we don't care about for matching, and
since we didn't include them in our matchJSON value, those
fields will not be attempted to be matched. If everything
we included above has the same values as the real command
output, the test will pass.

The matchJSON field's type must be the same as the command
output's type, otherwise the test will fail. So if the
command outputs an array, then the value of matchJSON must
also be an array.

If matchJSON is an array, it must not contain more elements
than the command output's array, otherwise the test will
fail.

Signed-off-by: Jeremy Carter <jeremy@mojatatu.com>
Signed-off-by: Victor Nogueira <victor@mojatatu.com>
---
 tools/testing/selftests/tc-testing/tdc.py | 125 ++++++++++++++++++++--
 1 file changed, 118 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/tc-testing/tdc.py b/tools/testing/selftests/tc-testing/tdc.py
index ee22e3447..7bd94f8e4 100755
--- a/tools/testing/selftests/tc-testing/tdc.py
+++ b/tools/testing/selftests/tc-testing/tdc.py
@@ -246,6 +246,110 @@ def prepare_env(args, pm, stage, prefix, cmdlist, output = None):
                 stage, output,
                 '"{}" did not complete successfully'.format(prefix))
 
+def verify_by_json(procout, res, tidx, args, pm):
+    try:
+        outputJSON = json.loads(procout)
+    except json.JSONDecodeError:
+        res.set_result(ResultState.fail)
+        res.set_failmsg('Cannot decode verify command\'s output. Is it JSON?')
+        return res
+
+    matchJSON = json.loads(json.dumps(tidx['matchJSON']))
+
+    if type(outputJSON) != type(matchJSON):
+        failmsg = 'Original output and matchJSON value are not the same type: output: {} != matchJSON: {} '
+        failmsg = failmsg.format(type(outputJSON).__name__, type(matchJSON).__name__)
+        res.set_result(ResultState.fail)
+        res.set_failmsg(failmsg)
+        return res
+
+    if len(matchJSON) > len(outputJSON):
+        failmsg = "Your matchJSON value is an array, and it contains more elements than the command under test\'s output:\ncommand output (length: {}):\n{}\nmatchJSON value (length: {}):\n{}"
+        failmsg = failmsg.format(len(outputJSON), outputJSON, len(matchJSON), matchJSON)
+        res.set_result(ResultState.fail)
+        res.set_failmsg(failmsg)
+        return res
+    res = find_in_json(res, outputJSON, matchJSON, 0)
+
+    return res
+
+def find_in_json(res, outputJSONVal, matchJSONVal, matchJSONKey=None):
+    if res.get_result() == ResultState.fail:
+        return res
+
+    if type(matchJSONVal) == list:
+        res = find_in_json_list(res, outputJSONVal, matchJSONVal, matchJSONKey)
+
+    elif type(matchJSONVal) == dict:
+        res = find_in_json_dict(res, outputJSONVal, matchJSONVal)
+    else:
+        res = find_in_json_other(res, outputJSONVal, matchJSONVal, matchJSONKey)
+
+    if res.get_result() != ResultState.fail:
+        res.set_result(ResultState.success)
+        return res
+
+    return res
+
+def find_in_json_list(res, outputJSONVal, matchJSONVal, matchJSONKey=None):
+    if (type(matchJSONVal) != type(outputJSONVal)):
+        failmsg = 'Original output and matchJSON value are not the same type: output: {} != matchJSON: {}'
+        failmsg = failmsg.format(outputJSONVal, matchJSONVal)
+        res.set_result(ResultState.fail)
+        res.set_failmsg(failmsg)
+        return res
+
+    if len(matchJSONVal) > len(outputJSONVal):
+        failmsg = "Your matchJSON value is an array, and it contains more elements than the command under test\'s output:\ncommand output (length: {}):\n{}\nmatchJSON value (length: {}):\n{}"
+        failmsg = failmsg.format(len(outputJSONVal), outputJSONVal, len(matchJSONVal), matchJSONVal)
+        res.set_result(ResultState.fail)
+        res.set_failmsg(failmsg)
+        return res
+
+    for matchJSONIdx, matchJSONVal in enumerate(matchJSONVal):
+        res = find_in_json(res, outputJSONVal[matchJSONIdx], matchJSONVal,
+                           matchJSONKey)
+    return res
+
+def find_in_json_dict(res, outputJSONVal, matchJSONVal):
+    for matchJSONKey, matchJSONVal in matchJSONVal.items():
+        if type(outputJSONVal) == dict:
+            if matchJSONKey not in outputJSONVal:
+                failmsg = 'Key not found in json output: {}: {}\nMatching against output: {}'
+                failmsg = failmsg.format(matchJSONKey, matchJSONVal, outputJSONVal)
+                res.set_result(ResultState.fail)
+                res.set_failmsg(failmsg)
+                return res
+
+        else:
+            failmsg = 'Original output and matchJSON value are not the same type: output: {} != matchJSON: {}'
+            failmsg = failmsg.format(type(outputJSON).__name__, type(matchJSON).__name__)
+            res.set_result(ResultState.fail)
+            res.set_failmsg(failmsg)
+            return rest
+
+        if type(outputJSONVal) == dict and (type(outputJSONVal[matchJSONKey]) == dict or
+                type(outputJSONVal[matchJSONKey]) == list):
+            if len(matchJSONVal) > 0:
+                res = find_in_json(res, outputJSONVal[matchJSONKey], matchJSONVal, matchJSONKey)
+            # handling corner case where matchJSONVal == [] or matchJSONVal == {}
+            else:
+                res = find_in_json_other(res, outputJSONVal, matchJSONVal, matchJSONKey)
+        else:
+            res = find_in_json(res, outputJSONVal, matchJSONVal, matchJSONKey)
+    return res
+
+def find_in_json_other(res, outputJSONVal, matchJSONVal, matchJSONKey=None):
+    if matchJSONKey in outputJSONVal:
+        if matchJSONVal != outputJSONVal[matchJSONKey]:
+            failmsg = 'Value doesn\'t match: {}: {} != {}\nMatching against output: {}'
+            failmsg = failmsg.format(matchJSONKey, matchJSONVal, outputJSONVal[matchJSONKey], outputJSONVal)
+            res.set_result(ResultState.fail)
+            res.set_failmsg(failmsg)
+            return res
+
+    return res
+
 def run_one_test(pm, args, index, tidx):
     global NAMES
     result = True
@@ -292,16 +396,22 @@ def run_one_test(pm, args, index, tidx):
     else:
         if args.verbose > 0:
             print('-----> verify stage')
-        match_pattern = re.compile(
-            str(tidx["matchPattern"]), re.DOTALL | re.MULTILINE)
         (p, procout) = exec_cmd(args, pm, 'verify', tidx["verifyCmd"])
         if procout:
-            match_index = re.findall(match_pattern, procout)
-            if len(match_index) != int(tidx["matchCount"]):
-                res.set_result(ResultState.fail)
-                res.set_failmsg('Could not match regex pattern. Verify command output:\n{}'.format(procout))
+            if 'matchJSON' in tidx:
+                verify_by_json(procout, res, tidx, args, pm)
+            elif 'matchPattern' in tidx:
+                match_pattern = re.compile(
+                    str(tidx["matchPattern"]), re.DOTALL | re.MULTILINE)
+                match_index = re.findall(match_pattern, procout)
+                if len(match_index) != int(tidx["matchCount"]):
+                    res.set_result(ResultState.fail)
+                    res.set_failmsg('Could not match regex pattern. Verify command output:\n{}'.format(procout))
+                else:
+                    res.set_result(ResultState.success)
             else:
-                res.set_result(ResultState.success)
+                res.set_result(ResultState.fail)
+                res.set_failmsg('Must specify a match option: matchJSON or matchPattern\n{}'.format(procout))
         elif int(tidx["matchCount"]) != 0:
             res.set_result(ResultState.fail)
             res.set_failmsg('No output generated by verify command.')
@@ -365,6 +475,7 @@ def test_runner(pm, args, filtered_tests):
             res.set_result(ResultState.skip)
             res.set_errormsg(errmsg)
             tsr.add_resultdata(res)
+            index += 1
             continue
         try:
             badtest = tidx  # in case it goes bad
-- 
2.25.1

