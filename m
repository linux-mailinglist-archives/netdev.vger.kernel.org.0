Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE1B2212CC0
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 21:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726171AbgGBTEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 15:04:40 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:51372 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725878AbgGBTEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 15:04:40 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jr4Vg-0000Na-3K; Thu, 02 Jul 2020 13:04:36 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jr4Ve-00069I-03; Thu, 02 Jul 2020 13:04:35 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Matt Bennett <matt.bennett@alliedtelesis.co.nz>
Cc:     netdev@vger.kernel.org, zbr@ioremap.net,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
Date:   Thu, 02 Jul 2020 13:59:59 -0500
In-Reply-To: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz> (Matt
        Bennett's message of "Thu, 2 Jul 2020 12:26:30 +1200")
Message-ID: <87k0zlspxs.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jr4Ve-00069I-03;;;mid=<87k0zlspxs.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/cThDAnv+o2eEuqq0eobQSsw98Xk5vfJg=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.2 required=8.0 tests=ALL_TRUSTED,BAYES_20,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMNoVowels,XMSubLong,
        XM_B_SpammyTLD autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
        *      [score: 0.0556]
        *  0.7 XMSubLong Long Subject
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 0; Body=1 Fuz1=1 Fuz2=1]
        *  1.0 XM_B_SpammyTLD Contains uncommon/spammy TLD
X-Spam-DCC: ; sa06 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Matt Bennett <matt.bennett@alliedtelesis.co.nz>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1652 ms - load_scoreonly_sql: 0.06 (0.0%),
        signal_user_changed: 11 (0.7%), b_tie_ro: 9 (0.6%), parse: 0.89 (0.1%),
         extract_message_metadata: 15 (0.9%), get_uri_detail_list: 1.59 (0.1%),
         tests_pri_-1000: 6 (0.3%), tests_pri_-950: 1.30 (0.1%),
        tests_pri_-900: 1.08 (0.1%), tests_pri_-90: 72 (4.3%), check_bayes: 70
        (4.2%), b_tokenize: 6 (0.4%), b_tok_get_all: 8 (0.5%), b_comp_prob:
        2.3 (0.1%), b_tok_touch_all: 50 (3.0%), b_finish: 0.93 (0.1%),
        tests_pri_0: 259 (15.7%), check_dkim_signature: 0.55 (0.0%),
        check_dkim_adsp: 2.4 (0.1%), poll_dns_idle: 1263 (76.4%),
        tests_pri_10: 2.0 (0.1%), tests_pri_500: 1282 (77.6%), rewrite_mail:
        0.00 (0.0%)
Subject: Re: [PATCH 0/5] RFC: connector: Add network namespace awareness
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Matt Bennett <matt.bennett@alliedtelesis.co.nz> writes:

> Previously the connector functionality could only be used by processes running in the
> default network namespace. This meant that any process that uses the connector functionality
> could not operate correctly when run inside a container. This is a draft patch series that
> attempts to now allow this functionality outside of the default network namespace.
>
> I see this has been discussed previously [1], but am not sure how my changes relate to all
> of the topics discussed there and/or if there are any unintended side
> effects from my draft

In a quick skim this patchset does not look like it approaches a correct
conversion to having code that works in multiple namespaces.

I will take the changes to proc_id_connector for example.
You report the values in the callers current namespaces.

Which means an unprivileged user can create a user namespace and get
connector to report whichever ids they want to users in another
namespace.  AKA lie.

So this appears to make connector completely unreliable.

Eric



> changes.
>
> Thanks.
>
> [1] https://marc.info/?l=linux-kernel&m=150806196728365&w=2
>
> Matt Bennett (5):
>   connector: Use task pid helpers
>   connector: Use 'current_user_ns' function
>   connector: Ensure callback entry is released
>   connector: Prepare for supporting multiple namespaces
>   connector: Create connector per namespace
>
>  Documentation/driver-api/connector.rst |   6 +-
>  drivers/connector/cn_proc.c            | 110 +++++++-------
>  drivers/connector/cn_queue.c           |   9 +-
>  drivers/connector/connector.c          | 192 ++++++++++++++++++++-----
>  drivers/hv/hv_fcopy.c                  |   1 +
>  drivers/hv/hv_utils_transport.c        |   6 +-
>  drivers/md/dm-log-userspace-transfer.c |   6 +-
>  drivers/video/fbdev/uvesafb.c          |   8 +-
>  drivers/w1/w1_netlink.c                |  19 +--
>  include/linux/connector.h              |  38 +++--
>  include/net/net_namespace.h            |   4 +
>  kernel/exit.c                          |   2 +-
>  samples/connector/cn_test.c            |   6 +-
>  13 files changed, 286 insertions(+), 121 deletions(-)
