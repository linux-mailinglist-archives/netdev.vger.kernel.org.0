Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C033AF790
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 10:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727309AbfIKISE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 04:18:04 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:57630 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726842AbfIKISE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 04:18:04 -0400
Received: from in01.mta.xmission.com ([166.70.13.51])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1i7xpC-0003x6-MR; Wed, 11 Sep 2019 02:18:02 -0600
Received: from 110.8.30.213.rev.vodafone.pt ([213.30.8.110] helo=x220.xmission.com)
        by in01.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1i7xpB-0007og-QA; Wed, 11 Sep 2019 02:18:02 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer\@redhat.com" <brouer@redhat.com>,
        "bpf\@vger.kernel.org" <bpf@vger.kernel.org>
References: <20190906150952.23066-1-cneirabustos@gmail.com>
        <20190906150952.23066-3-cneirabustos@gmail.com>
        <20190906152435.GW1131@ZenIV.linux.org.uk>
        <20190906154647.GA19707@ZenIV.linux.org.uk>
        <20190906160020.GX1131@ZenIV.linux.org.uk>
        <c0e67fc7-be66-c4c6-6aad-316cbba18757@fb.com>
        <20190907001056.GA1131@ZenIV.linux.org.uk>
        <7d196a64-cf36-c2d5-7328-154aaeb929eb@fb.com>
        <20190909174522.GA17882@frodo.byteswizards.com>
        <dadf3657-2648-14ef-35ee-e09efb2cdb3e@fb.com>
        <20190911043225.GA22183@frodo.byteswizards.com>
Date:   Wed, 11 Sep 2019 03:17:41 -0500
In-Reply-To: <20190911043225.GA22183@frodo.byteswizards.com> (Carlos Antonio
        Neira Bustos's message of "Wed, 11 Sep 2019 01:32:25 -0300")
Message-ID: <87impz8cwq.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1i7xpB-0007og-QA;;;mid=<87impz8cwq.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=213.30.8.110;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/ilPKkxouOU5Llp9axJ+W3QKaRnY6WDSs=
X-SA-Exim-Connect-IP: 213.30.8.110
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,TVD_RCVD_IP,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
        T_TooManySym_02,T_TooManySym_03,XMGappySubj_01,XMGappySubj_02,
        XMSubLong autolearn=disabled version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4972]
        *  0.7 XMSubLong Long Subject
        *  1.0 XMGappySubj_02 Gappier still
        *  0.5 XMGappySubj_01 Very gappy subject
        *  0.0 TVD_RCVD_IP Message was received from an IP address
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
        *  0.0 T_TooManySym_03 6+ unique symbols in subject
        *  0.0 T_TooManySym_01 4+ unique symbols in subject
        *  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Carlos Antonio Neira Bustos <cneirabustos@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 148 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 2.9 (1.9%), b_tie_ro: 2.1 (1.4%), parse: 0.96
        (0.7%), extract_message_metadata: 2.7 (1.8%), get_uri_detail_list:
        0.62 (0.4%), tests_pri_-1000: 3.0 (2.0%), tests_pri_-950: 1.07 (0.7%),
        tests_pri_-900: 0.89 (0.6%), tests_pri_-90: 16 (11.1%), check_bayes:
        15 (10.1%), b_tokenize: 3.5 (2.4%), b_tok_get_all: 3.9 (2.7%),
        b_comp_prob: 1.05 (0.7%), b_tok_touch_all: 3.5 (2.4%), b_finish: 2.1
        (1.4%), tests_pri_0: 105 (71.2%), check_dkim_signature: 0.36 (0.2%),
        check_dkim_adsp: 2.3 (1.5%), poll_dns_idle: 0.81 (0.5%), tests_pri_10:
        1.78 (1.2%), tests_pri_500: 5 (3.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH bpf-next v10 2/4] bpf: new helper to obtain namespace data from current task New bpf helper bpf_get_current_pidns_info.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Carlos Antonio Neira Bustos <cneirabustos@gmail.com> writes:

> On Tue, Sep 10, 2019 at 10:35:09PM +0000, Yonghong Song wrote:
> Thanks a lot Yonghong.
> I'll include this patch when submitting changes for version 11 of
> this patch.

Please see my reply to Al.

Eric


