Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4B4162EEEE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 09:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241324AbiKRIJ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 03:09:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232532AbiKRIJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 03:09:55 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 933B71A83A
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:09:53 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id b62so4428211pgc.0
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 00:09:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8FYBe33ZTkNYlZGeMGSeLBSLDJTO5rxi53C4znOTyLg=;
        b=TDlQrRhWxeglqrlyQljm7uQ0CNanZLRkY5KL0KDic4bJmCnbnpipMrfK6v92zfifmZ
         3Pzr2p5J1HjEtVWZ1yIirics8ZA0FgP8ru84WlWgamJMiMUEtS16NQP0Tt/3Oqkpf/0M
         c+T/akcxHDpyuUElZAv59oEUpmKfsqbWMw5/moEBu8lYF8G5lJ8WE3jkwpT2fUYg+pVc
         tUqVlL6bsAzb29si7InQeg5HHiwda+2HPXm/edVHmvxD1lFYjHzk4M5kKc4BOapN1VyX
         jwWSSHIUAERcdbyZIU9DkOI3CLvVpxleholfof4gLf4JaXXZaA39W0+z+b9s2j5t0Q5W
         SzgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8FYBe33ZTkNYlZGeMGSeLBSLDJTO5rxi53C4znOTyLg=;
        b=T3Yt4yet8RFK/wET7sbLxWmnc8NsjKiPOcI40C8pDn2TvZhgBp5yEUQ0VSnTQ7KkJp
         W2tVuyarlJVtuf5WeK3SvnRQGDQEsMkM9pXKburP5DAZisxYj8IVY33eccvsTYnY0bTP
         aWpOwXNyhcxnXZPDwuAmBQNIFSZnFMEAP+OadqMsp/RT192LrfgjYbreK+l5X2PdXeFD
         5haw113KhKJToQdYdlAee3AMHk4FNfDalBiHZdqo9/qvwrrSGfnua8ye19LGVhrlFQP8
         9lIlVaYI7fG+1dyEP+PxV6foW7d9Ys6pbcWLSEqaKSp9kpRRvF66HnffwwqTJiwdNw8/
         251g==
X-Gm-Message-State: ANoB5pmB0ZQs24oeF8x0wBv2jF1kIaI7xxaaBKlaWwYodcjzNJUmVDtw
        12fCLTC/rPFVO75QQceV1zpsbv1+37XxqQ==
X-Google-Smtp-Source: AA0mqf6r06gum1NNrMFKOm/j9hgx8yTqn9dIyKdKPLjAJ5GOmN47gmzHnwMId+migUPsAEKlnRKayw==
X-Received: by 2002:a63:5b52:0:b0:430:3d93:8c57 with SMTP id l18-20020a635b52000000b004303d938c57mr5747676pgm.397.1668758993033;
        Fri, 18 Nov 2022 00:09:53 -0800 (PST)
Received: from Laptop-X1 ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id b14-20020a170902650e00b001869079d083sm2890279plk.90.2022.11.18.00.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Nov 2022 00:09:52 -0800 (PST)
Date:   Fri, 18 Nov 2022 16:09:48 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [Need Help] tls selftest failed
Message-ID: <Y3c9zMbKsR+tcLHk@Laptop-X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Jakub,

The RedHat CKI got failures when run the net/tls selftest on net-next 6.1.0-rc4
and mainline 6.1.0-rc5 kernel. Here is an example failure[1] with mainline
6.1.0-rc5 kernel[2]. The config link is here[3]. Would you please help
check if there is issue with the test? Please tell me if you can't
access the URLs, then I will attach the config file.

ok 200 tls.13_chacha.shutdown_unsent
#  RUN           tls.13_chacha.shutdown_reuse ...
#            OK  tls.13_chacha.shutdown_reuse
ok 201 tls.13_chacha.shutdown_reuse
#  RUN           tls.13_sm4_gcm.sendfile ...
# tls.c:323:sendfile:Expected ret (-1) == 0 (0)
# sendfile: Test terminated by assertion
#          FAIL  tls.13_sm4_gcm.sendfile
not ok 202 tls.13_sm4_gcm.sendfile
#  RUN           tls.13_sm4_gcm.send_then_sendfile ...
# tls.c:323:send_then_sendfile:Expected ret (-1) == 0 (0)
# send_then_sendfile: Test terminated by assertion
#          FAIL  tls.13_sm4_gcm.send_then_sendfile
not ok 203 tls.13_sm4_gcm.send_then_sendfile
#  RUN           tls.13_sm4_gcm.multi_chunk_sendfile ...
# tls.c:323:multi_chunk_sendfile:Expected ret (-1) == 0 (0)
# multi_chunk_sendfile: Test terminated by assertion
#          FAIL  tls.13_sm4_gcm.multi_chunk_sendfile
not ok 204 tls.13_sm4_gcm.multi_chunk_sendfile
#  RUN           tls.13_sm4_gcm.recv_max ...
# tls.c:323:recv_max:Expected ret (-1) == 0 (0)
# recv_max: Test terminated by assertion
#          FAIL  tls.13_sm4_gcm.recv_max
not ok 205 tls.13_sm4_gcm.recv_max
[...snip...]
not ok 298 tls.13_sm4_ccm.shutdown_unsent
#  RUN           tls.13_sm4_ccm.shutdown_reuse ...
# tls.c:323:shutdown_reuse:Expected ret (-1) == 0 (0)
# shutdown_reuse: Test terminated by assertion
#          FAIL  tls.13_sm4_ccm.shutdown_reuse
not ok 299 tls.13_sm4_ccm.shutdown_reuse
#  RUN           tls.12_aes_ccm.sendfile ...
#            OK  tls.12_aes_ccm.sendfile
ok 300 tls.12_aes_ccm.sendfile

[1] https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/698017956/test%20x86_64%20debug/3340789088/artifacts/run.done.02/results_0001/RESULTS_J%3A7251979_0_R_12962453_T_38_test-kselftest/kselftests.6..82%20selftests%3A%20net%3Atls%20%5BFAIL%5D/resultoutputfile.log
[2] https://datawarehouse.cki-project.org/kcidb/checkouts/60286
[3] https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/index.html?prefix=trusted-artifacts/698017956/build%20x86_64%20debug/3340789060/artifacts/

Thanks
Hangbin
