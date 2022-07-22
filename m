Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFA7557DA6F
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 08:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234301AbiGVGmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 02:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbiGVGmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 02:42:00 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2717682458
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:41:58 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id e15so4719944edj.2
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 23:41:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nw8tTjTa/PZO5hmV8CKEncBLO7o0ZFuEQVqbEDoX2Ck=;
        b=1fvxKtPmWT/wdCB8Zd+JYdxs8+jWy+PbYJowMNwMC0gF27ApS2xraSu5yoKuNS1eFQ
         FHpKRcCJ5H951J+X3Bf+I+Z8a4PujfT2O2p3PYLwnnXWSQMJp9+u4ckAlCwoPyz4D2aS
         GgHldmwVfW0UP/nqX63iRccR86IclUpNc7E03wnxaYtX6cQzr+F/YR/Sqf34WA+CvUWC
         fHU2EdJFJYvIwHyJOLRQdHcJMBaoFSPtmiQdzsV9i+oiC/fS1id0RgejZHND1ZhMQxax
         BtME/F7QoSXo5wwitIRxypt04Az/pyYq1lae0KhapPwib0E3Uc4ORR8DF60NrwX6G0OJ
         BPLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Nw8tTjTa/PZO5hmV8CKEncBLO7o0ZFuEQVqbEDoX2Ck=;
        b=gVZg0LQC2w7HiQxnt4zPY7XRV4L434Tz3dN7sKRLv464S/6YlbhKd8oqfWGEWsHFGd
         lv0huvSQc8CO+TETNC+yzNE117RVp38UV4yzSXpskGGeR2k3jFUGmoDC+ndEz04Dygju
         /5E3GktyOXZOFDgN2OLrhSVQLOrsnHqGo4pCuNgIKe/v/D7m57yZlUmAYxNSA6LASlD2
         B2xnA9rEw3/GyEt2lyle0eT0B8x+9tu+w5JB67WPnZ+bmNcD9azZhdiQ0lVq4ijhSHB3
         46dJt03P0qLaYUvG/jPk9xTn9UGRnTgFZNTaDQgjB1YIG+SqtjjUTtXhzBKBP+qByuMb
         pHCg==
X-Gm-Message-State: AJIora9tAq+9KvbB507DFysxSCzr1jR3gqfAzSZsTJ4jP/GRtdih9Veg
        DOhYdzX9sJ/fmJg8WJiph2csjA==
X-Google-Smtp-Source: AGRyM1sj00smfpKwICHzY6SpTgaPGzlA5O2QNHSRwppRFDZebT5XOzOVSijAZ0W9a6cEccpCforGDQ==
X-Received: by 2002:a05:6402:190e:b0:43a:e914:8c11 with SMTP id e14-20020a056402190e00b0043ae9148c11mr1924522edz.281.1658472116576;
        Thu, 21 Jul 2022 23:41:56 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id kw26-20020a170907771a00b0072124df085bsm1680382ejc.15.2022.07.21.23.41.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 23:41:55 -0700 (PDT)
Date:   Fri, 22 Jul 2022 08:41:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, dsahern@kernel.org,
        stephen@networkplumber.org, Eric Dumazet <edumazet@google.com>,
        pabeni@redhat.com, ast@kernel.org, leon@kernel.org,
        linux-doc@vger.kernel.org, corbet@lwn.net,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Gospodarek <andrew.gospodarek@broadcom.com>
Subject: Re: [PATCH net-next v4 1/3] devlink: introduce framework for
 selftests
Message-ID: <YtpGsndCvUIlBLUs@nanopsycho>
References: <20220718062032.22426-1-vikas.gupta@broadcom.com>
 <20220721072121.43648-1-vikas.gupta@broadcom.com>
 <20220721072121.43648-2-vikas.gupta@broadcom.com>
 <YtlNGWp0D7M3PXvJ@nanopsycho>
 <CAHLZf_tMsZ-K70oUarNXYRnG10WyHNNVO2KpzECoFRy0C0dQpw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHLZf_tMsZ-K70oUarNXYRnG10WyHNNVO2KpzECoFRy0C0dQpw@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 21, 2022 at 07:32:08PM CEST, vikas.gupta@broadcom.com wrote:
>Hi Jiri,
>
>
>On Thu, Jul 21, 2022 at 6:27 PM Jiri Pirko <jiri@nvidia.com> wrote:
>>
>> Thu, Jul 21, 2022 at 09:21:19AM CEST, vikas.gupta@broadcom.com wrote:
>> >Add a framework for running selftests.
>> >Framework exposes devlink commands and test suite(s) to the user
>> >to execute and query the supported tests by the driver.
>> >
>> >Below are new entries in devlink_nl_ops
>> >devlink_nl_cmd_selftests_list_doit/dumpit: To query the supported
>> >selftests by the drivers.
>> >devlink_nl_cmd_selftests_run: To execute selftests. Users can
>> >provide a test mask for executing group tests or standalone tests.
>> >
>> >Documentation/networking/devlink/ path is already part of MAINTAINERS &
>> >the new files come under this path. Hence no update needed to the
>> >MAINTAINERS
>> >
>> >Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
>> >Reviewed-by: Michael Chan <michael.chan@broadcom.com>
>> >Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
>> >---
>> > .../networking/devlink/devlink-selftests.rst  |  38 +++
>> > include/net/devlink.h                         |  20 ++
>> > include/uapi/linux/devlink.h                  |  29 +++
>> > net/core/devlink.c                            | 225 ++++++++++++++++++
>> > 4 files changed, 312 insertions(+)
>> > create mode 100644 Documentation/networking/devlink/devlink-selftests.rst
>> >
>> >diff --git a/Documentation/networking/devlink/devlink-selftests.rst b/Documentation/networking/devlink/devlink-selftests.rst
>> >new file mode 100644
>> >index 000000000000..0e9727895987
>> >--- /dev/null
>> >+++ b/Documentation/networking/devlink/devlink-selftests.rst
>> >@@ -0,0 +1,38 @@
>> >+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> >+
>> >+=================
>> >+Devlink Selftests
>> >+=================
>> >+
>> >+The ``devlink-selftests`` API allows executing selftests on the device.
>> >+
>> >+Tests Mask
>> >+==========
>> >+The ``devlink-selftests`` command should be run with a mask indicating
>> >+the tests to be executed.
>> >+
>> >+Tests Description
>> >+=================
>> >+The following is a list of tests that drivers may execute.
>> >+
>> >+.. list-table:: List of tests
>> >+   :widths: 5 90
>> >+
>> >+   * - Name
>> >+     - Description
>> >+   * - ``DEVLINK_SELFTEST_FLASH``
>> >+     - Devices may have the firmware on non-volatile memory on the board, e.g.
>> >+       flash. This particular test helps to run a flash selftest on the device.
>> >+       Implementation of the test is left to the driver/firmware.
>> >+
>> >+example usage
>> >+-------------
>> >+
>> >+.. code:: shell
>> >+
>> >+    # Query selftests supported on the devlink device
>> >+    $ devlink dev selftests show DEV
>> >+    # Query selftests supported on all devlink devices
>> >+    $ devlink dev selftests show
>> >+    # Executes selftests on the device
>> >+    $ devlink dev selftests run DEV test flash
>>
>> "test_id" to be consistend with the attr name and outputs. Please see
>What is "test_id" referring to in this document? Can you please elaborate ?

"test_id" is consistent with the UAPI netlink attribute name, see
below.

>
>> below. Devlink cmdline would accept "test" as well, so you can still use
>Are you mentioning the "test" argument in the above devlink command line option?

Yes, the cmd line accepts shortened option names. So for "test_id", it
would accept:
"test_i"
"test_"
and "test"

I just wanted to say you, as a user, will be able to still use the
shortened version, but the option name "test_id" would be consistent
with UAPI, which is what we usually have.

