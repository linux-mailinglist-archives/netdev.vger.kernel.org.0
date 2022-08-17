Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F335459673F
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238073AbiHQCG3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:06:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235578AbiHQCG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:06:27 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B226798D0D
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 19:06:26 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id f30so10916192pfq.4
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 19:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc;
        bh=1EOMPLdfTNEbts2W3MXnqhTvDU7CeaY/Je/8eiXORa0=;
        b=wJh1aC7g296vphQE2sYy6AjGwImYDSfwhLo1sYyJ29doEosBnvZcIDpv2MzREyTRky
         C2paWcg+lHjPlpudgwUcwUdzkQOE7XHf6VrEG7TEYu9gZo04lZDmX3w7Z+JxgUTl/2hS
         00u2j0vtNglDOtlgac6BZhzRl5nFcbyCBiZkpv11Q4jH/r9b3mA4JAdHV5jdSGOhkOPp
         QEnIING29jOYoJ2mdHmLXjOcJVXZqeYWOZlVc3vuCErKNzk8CyV44oZ+zHIcoMV1pymO
         i/iPuwZB8L40qmPLzeWqw8iIMxz9lF4XJHIU2qpJjoao4Ahc/PZ8sxuypQKmZOMjB4cM
         JEUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=1EOMPLdfTNEbts2W3MXnqhTvDU7CeaY/Je/8eiXORa0=;
        b=u3Pc9GQznK9A6f5Xyjspt5uJeeNYMQ3T6MHv4jb1ynHdJKzU8xSTQcKiEIkpWUCIvd
         ETt4BBoLLqWIonxeSbj2ONz7FEZV50WnpMASlO9ipsnwdQlTwex4ZCmPJGFOlJ+FUW8Q
         vbHF3Od/RmNgV/V5xDQVqqKbczvMZbkB5fpUHHHe5IChPXRmXHoMZlgzeCdL4XiyjwZM
         p6GDKteBZMCWK1WD8dE1IBtP3KjYsgx8kIVRbsPUODn58R+rAiQ1szq02F9wttAm7HQu
         dPEnsU3/ENwbhmavFpjN3sM0MYRWWI5kvGMqYnFATpscSk737CQlSRB74vul4H9f46kJ
         MJgA==
X-Gm-Message-State: ACgBeo2JeEZzfVG0IecNIevO7HvXtKGU4tDkoZWNDV15eEP+Gf+OQh02
        TQH5lo2aglbHmn6l9B07EO4QdIi4vnIFhg==
X-Google-Smtp-Source: AA6agR4edCBR/q/8ZPpJmCQK9oKH6Yyvay9CmOrrO1DCBuFolvryzx9a5C16Aajuqra/jpUnT4fQfQ==
X-Received: by 2002:a05:6a00:17a8:b0:52e:6e3e:9ff with SMTP id s40-20020a056a0017a800b0052e6e3e09ffmr23811806pfg.42.1660701986195;
        Tue, 16 Aug 2022 19:06:26 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id j3-20020a17090276c300b0016d5cf36ff4sm43228plt.289.2022.08.16.19.06.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 19:06:26 -0700 (PDT)
Date:   Tue, 16 Aug 2022 19:06:23 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     jiangheng <15720603159@163.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] genl: modify the command output message of
 genl -h
Message-ID: <20220816190623.6cb655c3@hermes.local>
In-Reply-To: <1c6b71b1.62fc.18290edbaff.Coremail.15720603159@163.com>
References: <1c6b71b1.62fc.18290edbaff.Coremail.15720603159@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Aug 2022 15:21:15 +0800 (CST)
jiangheng <15720603159@163.com> wrote:

> From f4709a324870822066b449bab89980dba8c8af79 Mon Sep 17 00:00:00 2001
> From: jinag <jinag12138@gmail.com>
> Date: Thu, 14 Oct 2021 15:13:03 +0800
> Subject: [PATCH] genl: modify the command output of genl -h
> 
> after the modification, the command output is the same as that of man 8 genl and more readable.


iproute2 follows the kernel style and contribution rules.
This patch has multiple issues

$ checkpatch.pl ~/Downloads/iproute2-genl-modify-the-command-output-message-of-genl--h.patch 
WARNING: Possible unwrapped commit description (prefer a maximum 75 chars per line)
#58: 
after the modification, the command output is the same as that of man 8 genl and more readable.

ERROR: code indent should use tabs where possible
#77: FILE: genl/genl.c:102:
+               "Usage: genl [ OPTIONS ] OBJECT [help]\n"$

WARNING: please, no spaces at the start of a line
#77: FILE: genl/genl.c:102:
+               "Usage: genl [ OPTIONS ] OBJECT [help]\n"$

ERROR: code indent should use tabs where possible
#78: FILE: genl/genl.c:103:
+               "where  OBJECT := { ctrl CTRL_OPTS }\n"$

WARNING: please, no spaces at the start of a line
#78: FILE: genl/genl.c:103:
+               "where  OBJECT := { ctrl CTRL_OPTS }\n"$

ERROR: code indent should use tabs where possible
#79: FILE: genl/genl.c:104:
+               "       OPTIONS := { -s[tatistics] | -d[etails] | -r[aw] | -V[ersion] | -h[elp] }\n"$

WARNING: please, no spaces at the start of a line
#79: FILE: genl/genl.c:104:
+               "       OPTIONS := { -s[tatistics] | -d[etails] | -r[aw] | -V[ersion] | -h[elp] }\n"$

ERROR: code indent should use tabs where possible
#80: FILE: genl/genl.c:105:
+               "       CTRL_OPTS := { help | list | monitor | get PARMS }\n"$

WARNING: please, no spaces at the start of a line
#80: FILE: genl/genl.c:105:
+               "       CTRL_OPTS := { help | list | monitor | get PARMS }\n"$

ERROR: code indent should use tabs where possible
#81: FILE: genl/genl.c:106:
+               "       PARMS := { name NAME | id ID }\n");$

WARNING: please, no spaces at the start of a line
#81: FILE: genl/genl.c:106:
+               "       PARMS := { name NAME | id ID }\n");$

ERROR: Missing Signed-off-by: line(s)

