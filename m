Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDFC1B453F
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 14:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbgDVMgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 08:36:21 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44814 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725839AbgDVMgV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 08:36:21 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.90_1)
        (envelope-from <ebiederm@xmission.com>)
        id 1jREbz-0000ox-TI; Wed, 22 Apr 2020 06:36:19 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1jREbz-0006MT-03; Wed, 22 Apr 2020 06:36:19 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Christoph Hellwig <hch@lst.de>
Cc:     Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20200417064146.1086644-1-hch@lst.de>
        <20200417064146.1086644-5-hch@lst.de>
Date:   Wed, 22 Apr 2020 07:33:11 -0500
In-Reply-To: <20200417064146.1086644-5-hch@lst.de> (Christoph Hellwig's
        message of "Fri, 17 Apr 2020 08:41:44 +0200")
Message-ID: <87d07z4s54.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jREbz-0006MT-03;;;mid=<87d07z4s54.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/34tuHHASgF60MVP0xOvnRF+fIQ45pLt8=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMNoVowels,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  1.5 XMNoVowels Alpha-numberic number with no vowels
        *  0.7 XMSubLong Long Subject
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Christoph Hellwig <hch@lst.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 476 ms - load_scoreonly_sql: 0.04 (0.0%),
        signal_user_changed: 11 (2.3%), b_tie_ro: 9 (2.0%), parse: 0.79 (0.2%),
         extract_message_metadata: 17 (3.5%), get_uri_detail_list: 0.98 (0.2%),
         tests_pri_-1000: 16 (3.4%), tests_pri_-950: 1.59 (0.3%),
        tests_pri_-900: 1.17 (0.2%), tests_pri_-90: 110 (23.2%), check_bayes:
        108 (22.7%), b_tokenize: 8 (1.6%), b_tok_get_all: 6 (1.3%),
        b_comp_prob: 2.2 (0.5%), b_tok_touch_all: 88 (18.4%), b_finish: 1.20
        (0.3%), tests_pri_0: 300 (63.0%), check_dkim_signature: 0.72 (0.2%),
        check_dkim_adsp: 2.5 (0.5%), poll_dns_idle: 0.41 (0.1%), tests_pri_10:
        2.2 (0.5%), tests_pri_500: 12 (2.5%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH 4/6] sysctl: remove all extern declaration from sysctl.c
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christoph Hellwig <hch@lst.de> writes:

> Extern declarations in .c files are a bad style and can lead to
> mismatches.  Use existing definitions in headers where they exist,
> and otherwise move the external declarations to suitable header
> files.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  include/linux/coredump.h |  6 ++++++
>  include/linux/file.h     |  2 ++
>  include/linux/mm.h       |  2 ++
>  include/linux/mmzone.h   |  2 ++
>  include/linux/sysctl.h   |  8 +++++++
>  kernel/sysctl.c          | 45 +++-------------------------------------
>  6 files changed, 23 insertions(+), 42 deletions(-)
>
> diff --git a/include/linux/coredump.h b/include/linux/coredump.h
> index abf4b4e65dbb..0fe8f3131e97 100644
> --- a/include/linux/coredump.h
> +++ b/include/linux/coredump.h
> @@ -22,4 +22,10 @@ extern void do_coredump(const kernel_siginfo_t *siginfo);
>  static inline void do_coredump(const kernel_siginfo_t *siginfo) {}
>  #endif
>  
> +extern int core_uses_pid;
> +extern char core_pattern[];
> +extern unsigned int core_pipe_limit;
> +extern int pid_max;
> +extern int pid_max_min, pid_max_max;

These last two pid_max, pid_max_mind and pid_max_max would make more
sense in pid.h as they have nothing to do with coredumps.

> +
>  #endif /* _LINUX_COREDUMP_H */
