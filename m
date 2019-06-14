Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4A28461C5
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 16:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbfFNOzb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 10:55:31 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:35253 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726647AbfFNOzb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 10:55:31 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out03.mta.xmission.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hbnc0-0003mm-3e; Fri, 14 Jun 2019 08:55:28 -0600
Received: from ip72-206-97-68.om.om.cox.net ([72.206.97.68] helo=x220.xmission.com)
        by in02.mta.xmission.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.87)
        (envelope-from <ebiederm@xmission.com>)
        id 1hbnbo-0001cx-AE; Fri, 14 Jun 2019 08:55:27 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     David Ahern <dsahern@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Matteo Croce <mcroce@redhat.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>
References: <20190608125019.417-1-mcroce@redhat.com>
        <20190609.195742.739339469351067643.davem@davemloft.net>
        <d19abcd4-799c-ac2f-ffcb-fa749d17950c@infradead.org>
        <CAGnkfhyS15NPEO2ygkjazECULtUDkJgPk8wCYFhA9zL2+w27pg@mail.gmail.com>
        <49b58181-90da-4ee4-cbb0-80e226d040fc@infradead.org>
        <CAK8P3a1mwnDFeD3xnQ6bm1x8C6yX=YEccxN2jknvTbRiCfD=Bg@mail.gmail.com>
        <47f1889a-e919-e3fd-f90c-39c26cb1ccbb@gmail.com>
        <CAK8P3a0w3K1O23616g3Nz4XQdgw-xHDPWSQ+Rb_O3VAy-3FnQg@mail.gmail.com>
Date:   Fri, 14 Jun 2019 09:54:55 -0500
In-Reply-To: <CAK8P3a0w3K1O23616g3Nz4XQdgw-xHDPWSQ+Rb_O3VAy-3FnQg@mail.gmail.com>
        (Arnd Bergmann's message of "Fri, 14 Jun 2019 16:26:14 +0200")
Message-ID: <87r27wrzcw.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1hbnbo-0001cx-AE;;;mid=<87r27wrzcw.fsf@xmission.com>;;;hst=in02.mta.xmission.com;;;ip=72.206.97.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19xgdtHru1qF4+VUMChfP39qNf75uj1g9o=
X-SA-Exim-Connect-IP: 72.206.97.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=8.0 tests=ALL_TRUSTED,BAYES_20,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        * -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
        *      [score: 0.1644]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Arnd Bergmann <arnd@arndb.de>
X-Spam-Relay-Country: 
X-Spam-Timing: total 11412 ms - load_scoreonly_sql: 0.03 (0.0%),
        signal_user_changed: 2.6 (0.0%), b_tie_ro: 1.85 (0.0%), parse: 0.67
        (0.0%), extract_message_metadata: 11 (0.1%), get_uri_detail_list: 0.98
        (0.0%), tests_pri_-1000: 15 (0.1%), tests_pri_-950: 1.09 (0.0%),
        tests_pri_-900: 0.84 (0.0%), tests_pri_-90: 18 (0.2%), check_bayes: 17
        (0.1%), b_tokenize: 5 (0.0%), b_tok_get_all: 6 (0.1%), b_comp_prob:
        1.44 (0.0%), b_tok_touch_all: 2.8 (0.0%), b_finish: 0.55 (0.0%),
        tests_pri_0: 3307 (29.0%), check_dkim_signature: 0.37 (0.0%),
        check_dkim_adsp: 3095 (27.1%), poll_dns_idle: 11131 (97.5%),
        tests_pri_10: 1.78 (0.0%), tests_pri_500: 8051 (70.6%), rewrite_mail:
        0.00 (0.0%)
Subject: Re: [PATCH net] mpls: fix af_mpls dependencies
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> writes:

> On Fri, Jun 14, 2019 at 4:07 PM David Ahern <dsahern@gmail.com> wrote:
>> On 6/14/19 8:01 AM, Arnd Bergmann wrote:
>> > On Wed, Jun 12, 2019 at 9:41 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>> >> On 6/11/19 5:08 PM, Matteo Croce wrote:
>> >
>> > It clearly shouldn't select PROC_SYSCTL, but I think it should not
>> > have a 'depends on' statement either. I think the correct fix for the
>> > original problem would have been something like
>> >
>> > --- a/net/mpls/af_mpls.c
>> > +++ b/net/mpls/af_mpls.c
>> > @@ -2659,6 +2659,9 @@ static int mpls_net_init(struct net *net)
>> >         net->mpls.ip_ttl_propagate = 1;
>> >         net->mpls.default_ttl = 255;
>> >
>> > +       if (!IS_ENABLED(CONFIG_PROC_SYSCTL))
>> > +               return 0;
>> > +
>> >         table = kmemdup(mpls_table, sizeof(mpls_table), GFP_KERNEL);
>> >         if (table == NULL)
>> >                 return -ENOMEM;
>> >
>>
>> Without sysctl, the entire mpls_router code is disabled. So if sysctl is
>> not enabled there is no point in building this file.
>
> Ok, I see.
>
> There are a couple of other drivers that use 'depends on SYSCTL',
> which may be the right thing to do here. In theory, one can still
> build a kernel with CONFIG_SYSCTRL_SYSCALL=y and no
> procfs.

Which reminds me.  I really need to write the patch to remove
CONFIG_SYSCTL_SYSCALL.

Unless I have missed something we have finally reached default off in
all of the distributions so no one should care.

Eric
