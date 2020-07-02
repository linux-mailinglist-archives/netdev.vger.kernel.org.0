Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA10212479
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 15:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbgGBNWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 09:22:17 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35486 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726560AbgGBNWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 09:22:16 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jqzAL-0004mh-WB; Thu, 02 Jul 2020 07:22:14 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jqzAK-0002tm-HL; Thu, 02 Jul 2020 07:22:13 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Matt Bennett <matt.bennett@alliedtelesis.co.nz>
Cc:     netdev@vger.kernel.org, zbr@ioremap.net,
        linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>
References: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz>
Date:   Thu, 02 Jul 2020 08:17:38 -0500
In-Reply-To: <20200702002635.8169-1-matt.bennett@alliedtelesis.co.nz> (Matt
        Bennett's message of "Thu, 2 Jul 2020 12:26:30 +1200")
Message-ID: <87h7uqukct.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jqzAK-0002tm-HL;;;mid=<87h7uqukct.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19v+BspXknwer4bSqp3IVqIJsTE2IxbID4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa05.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=8.0 tests=ALL_TRUSTED,BAYES_00,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMNoVowels,XMSubLong,
        XM_B_SpammyTLD autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa05 0; Body=1 Fuz1=1 Fuz2=1]
        *  1.0 XM_B_SpammyTLD Contains uncommon/spammy TLD
X-Spam-DCC: ; sa05 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Matt Bennett <matt.bennett@alliedtelesis.co.nz>
X-Spam-Relay-Country: 
X-Spam-Timing: total 835 ms - load_scoreonly_sql: 0.07 (0.0%),
        signal_user_changed: 11 (1.4%), b_tie_ro: 10 (1.2%), parse: 1.12
        (0.1%), extract_message_metadata: 18 (2.1%), get_uri_detail_list: 1.82
        (0.2%), tests_pri_-1000: 7 (0.8%), tests_pri_-950: 1.38 (0.2%),
        tests_pri_-900: 1.14 (0.1%), tests_pri_-90: 258 (31.0%), check_bayes:
        239 (28.6%), b_tokenize: 7 (0.8%), b_tok_get_all: 7 (0.8%),
        b_comp_prob: 2.5 (0.3%), b_tok_touch_all: 218 (26.1%), b_finish: 1.15
        (0.1%), tests_pri_0: 437 (52.4%), check_dkim_signature: 1.20 (0.1%),
        check_dkim_adsp: 4.1 (0.5%), poll_dns_idle: 69 (8.2%), tests_pri_10:
        2.2 (0.3%), tests_pri_500: 94 (11.2%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 0/5] RFC: connector: Add network namespace awareness
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
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
> of the topics discussed there and/or if there are any unintended side effects from my draft
> changes.

Is there a piece of software that uses connector that you want to get
working in containers?

I am curious what the motivation is because up until now there has been
nothing very interesting using this functionality.  So it hasn't been
worth anyone's time to make the necessary changes to the code.

Eric


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
