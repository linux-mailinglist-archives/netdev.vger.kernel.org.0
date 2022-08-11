Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A0C259073B
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 22:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234083AbiHKUJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 16:09:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231352AbiHKUJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 16:09:11 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F41059C51F
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 13:09:09 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q9-20020a17090a2dc900b001f58bcaca95so6396431pjm.3
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 13:09:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc;
        bh=nefw992BjR2DKJLlRcY/JmF6kb64zkxOsohgksdYdZY=;
        b=YQ7HOy6QqoNgZGonUdkK4UAgFEipkL3adtQgOkxWH05GNQwNmh0fc/TMFTtG/QlC5V
         FZyYVefKbisrRkwsBZ9iIiPq17MIB/AIK4Wx1QN2842BAa18Pza9F49vfCwKjDuMEtKi
         EufhXAlODKUp3CBEFO6yCuijARwdhD5BuFURqDZHvgBMaY+z/b+uIxeIyNfqyRFk9Q9z
         pjL+by7rNDS/4sjW4qnqSMJX3dlTrOySWkrKTHLFFpSF1emnP8e2fDRzD4xw+3pKAkEx
         aU3+mPFStKArnLNhN+hPc5gZKJZIeGxw1ZG6afWWDjmy11YuvHIBFpAtTKlJvH4tBrpY
         AMlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=nefw992BjR2DKJLlRcY/JmF6kb64zkxOsohgksdYdZY=;
        b=JVK0CRLnLh22ROVEzlNy7El5ovEVTnR3xUt24aYOWSqKrnlB4O+COWGq1ONH7lvSCx
         EmE7MYknWELf1CbF/rGRh8xFCGiwpM0it9JjUvsNkLqqsPYw2KRT/0sOsy4oPIR5efP2
         MhvXjCfwt5fLwMM1s10MbCR2ahBtNL3JPQM4MiRVq90XFGJtOTaDhadnzztipyhzkj3d
         hgSMmh16oUlAKdCJcaFWH1JEfe2xMqIvyCOOxAcpgCICxUqZPrHIo89cKfPBXtj+i9uJ
         6ySpQ1/siLPlg3336ZCIp9R0b/qTUyk+FXfMT5udbEAVfr7HUReTPsim0Ac/3c5VufWF
         XJPA==
X-Gm-Message-State: ACgBeo0FJ7vssK99/z5ORi65zejc7kHkWZSAiJecjAdYwC2wA39X/Wjw
        ZCgaVWNJbMAQRusXPhNRo/lYZw==
X-Google-Smtp-Source: AA6agR4IuB4hGOq7TsVdXfmkQFs7cLlG+sLTO/C60fJBgCxAUnlfF2RggBePHqsa2I+PPOJMDaRymw==
X-Received: by 2002:a17:90b:4ccb:b0:1f5:87:a17f with SMTP id nd11-20020a17090b4ccb00b001f50087a17fmr627497pjb.7.1660248549302;
        Thu, 11 Aug 2022 13:09:09 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id n3-20020a622703000000b0052ef9556f47sm95315pfn.40.2022.08.11.13.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Aug 2022 13:09:09 -0700 (PDT)
Date:   Thu, 11 Aug 2022 13:09:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 3/4] ynl: add a sample python library
Message-ID: <20220811130906.198b091d@hermes.local>
In-Reply-To: <20220811022304.583300-4-kuba@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-4-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looks interesting, you might want to consider running your code
through some of the existing Python checkers such as flake8 and pylint.
If you want this to be generally available in repos, best to follow the language conventions

For example flake8 noticed:
 $ flake8 --max-line-length=120 ./tools/net/ynl/samples/ynl.py 
./tools/net/ynl/samples/ynl.py:251:55: F821 undefined name 'file_name'

And pylint has more warnings
tools/net/ynl/samples/ynl.py:1:0: C0114: Missing module docstring (missing-module-docstring)
tools/net/ynl/samples/ynl.py:4:0: E0401: Unable to import 'jsonschema' (import-error)
tools/net/ynl/samples/ynl.py:16:0: C0115: Missing class docstring (missing-class-docstring)
tools/net/ynl/samples/ynl.py:16:0: R0903: Too few public methods (0/2) (too-few-public-methods)
tools/net/ynl/samples/ynl.py:49:0: C0115: Missing class docstring (missing-class-docstring)
tools/net/ynl/samples/ynl.py:57:4: C0116: Missing function or method docstring (missing-function-docstring)
tools/net/ynl/samples/ynl.py:60:4: C0116: Missing function or method docstring (missing-function-docstring)
tools/net/ynl/samples/ynl.py:63:4: C0116: Missing function or method docstring (missing-function-docstring)
tools/net/ynl/samples/ynl.py:70:0: C0115: Missing class docstring (missing-class-docstring)
tools/net/ynl/samples/ynl.py:70:0: R0903: Too few public methods (1/2) (too-few-public-methods)
tools/net/ynl/samples/ynl.py:84:0: C0115: Missing class docstring (missing-class-docstring)
tools/net/ynl/samples/ynl.py:84:0: R0902: Too many instance attributes (9/7) (too-many-instance-attributes)
tools/net/ynl/samples/ynl.py:84:0: R0903: Too few public methods (1/2) (too-few-public-methods)
tools/net/ynl/samples/ynl.py:109:0: C0115: Missing class docstring (missing-class-docstring)
tools/net/ynl/samples/ynl.py:109:0: R0903: Too few public methods (1/2) (too-few-public-methods)
tools/net/ynl/samples/ynl.py:123:0: C0103: Constant name "genl_family_name_to_id" doesn't conform to UPPER_CASE naming style (invalid-name)
tools/net/ynl/samples/ynl.py:147:8: W0603: Using the global statement (global-statement)
tools/net/ynl/samples/ynl.py:147:8: C0103: Constant name "genl_family_name_to_id" doesn't conform to UPPER_CASE naming style (invalid-name)
tools/net/ynl/samples/ynl.py:148:33: R1735: Consider using {} instead of dict() (use-dict-literal)
tools/net/ynl/samples/ynl.py:160:16: C0103: Variable name "gm" doesn't conform to snake_case naming style (invalid-name)
tools/net/ynl/samples/ynl.py:174:8: C0103: Attribute name "nl" doesn't conform to snake_case naming style (invalid-name)
tools/net/ynl/samples/ynl.py:172:0: C0115: Missing class docstring (missing-class-docstring)
tools/net/ynl/samples/ynl.py:186:12: C0103: Variable name "a" doesn't conform to snake_case naming style (invalid-name)
tools/net/ynl/samples/ynl.py:172:0: R0903: Too few public methods (1/2) (too-few-public-methods)
tools/net/ynl/samples/ynl.py:191:0: C0115: Missing class docstring (missing-class-docstring)
tools/net/ynl/samples/ynl.py:195:8: W0602: Using global for 'genl_family_name_to_id' but no assignment is done (global-variable-not-assigned)
tools/net/ynl/samples/ynl.py:195:8: C0103: Constant name "genl_family_name_to_id" doesn't conform to UPPER_CASE naming style (invalid-name)
tools/net/ynl/samples/ynl.py:191:0: R0903: Too few public methods (0/2) (too-few-public-methods)
tools/net/ynl/samples/ynl.py:206:0: C0115: Missing class docstring (missing-class-docstring)
tools/net/ynl/samples/ynl.py:207:31: W0621: Redefining name 'yaml' from outer scope (line 8) (redefined-outer-name)
tools/net/ynl/samples/ynl.py:210:21: R1735: Consider using {} instead of dict() (use-dict-literal)
tools/net/ynl/samples/ynl.py:207:23: W0613: Unused argument 'family' (unused-argument)
tools/net/ynl/samples/ynl.py:241:4: C0116: Missing function or method docstring (missing-function-docstring)
tools/net/ynl/samples/ynl.py:245:0: C0115: Missing class docstring (missing-class-docstring)
tools/net/ynl/samples/ynl.py:247:13: W1514: Using open without explicitly specifying an encoding (unspecified-encoding)
tools/net/ynl/samples/ynl.py:251:17: W1514: Using open without explicitly specifying an encoding (unspecified-encoding)
tools/net/ynl/samples/ynl.py:251:54: E0602: Undefined variable 'file_name' (undefined-variable)
tools/net/ynl/samples/ynl.py:259:20: R1735: Consider using {} instead of dict() (use-dict-literal)
tools/net/ynl/samples/ynl.py:260:23: R1735: Consider using {} instead of dict() (use-dict-literal)
tools/net/ynl/samples/ynl.py:302:14: R1735: Consider using {} instead of dict() (use-dict-literal)
tools/net/ynl/samples/ynl.py:317:8: C0103: Variable name "op" doesn't conform to snake_case naming style (invalid-name)
tools/net/ynl/samples/ynl.py:340:16: C0103: Variable name "gm" doesn't conform to snake_case naming style (invalid-name)
tools/net/ynl/samples/ynl.py:316:4: R1710: Either all return statements in a function should return an expression, or none of them should. (inconsistent-return-statements)
tools/net/ynl/samples/ynl.py:245:0: R0903: Too few public methods (0/2) (too-few-public-methods)
tools/net/ynl/samples/ynl.py:5:0: C0411: standard import "import random" should be placed before "import jsonschema" (wrong-import-order)
tools/net/ynl/samples/ynl.py:6:0: C0411: standard import "import socket" should be placed before "import jsonschema" (wrong-import-order)
tools/net/ynl/samples/ynl.py:7:0: C0411: standard import "import struct" should be placed before "import jsonschema" (wrong-import-order)
tools/net/ynl/samples/ynl.py:9:0: C0411: standard import "import os" should be placed before "import jsonschema" (wrong-import-order)

------------------------------------------------------------------
Your code has been rated at 7.64/10 (previous run: 7.64/10, +0.00)


