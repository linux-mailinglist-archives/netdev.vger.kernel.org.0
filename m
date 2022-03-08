Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEB64D2124
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 20:10:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349937AbiCHTLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 14:11:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350008AbiCHTLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 14:11:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83E2E4BFC4
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 11:09:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646766595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rOKRAqWv+5Jc2Mm7hZD9JiUuQs8U4AWYs/o2E66wtms=;
        b=WFzY035vdQbaVybnhxhE3SbHOuA449dUChuB8HVodeYZt/IL3QZu10+tp2H7WfbALEY0NT
        QBRxEgdagm88C8Gi7QMiR+5p+oMEug2XCb3tYWaKBhRmLENqzC0X6o4Cwe2uMyvsQLoalP
        zLXHx8nyA2bfDHsjf09qDzogEfpIXUk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-433-hcMDkY_aN5Cjh0TZAKSzWw-1; Tue, 08 Mar 2022 14:09:54 -0500
X-MC-Unique: hcMDkY_aN5Cjh0TZAKSzWw-1
Received: by mail-wm1-f70.google.com with SMTP id h206-20020a1c21d7000000b003552c13626cso1544053wmh.3
        for <netdev@vger.kernel.org>; Tue, 08 Mar 2022 11:09:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rOKRAqWv+5Jc2Mm7hZD9JiUuQs8U4AWYs/o2E66wtms=;
        b=Q1uUFi+qasMeIu4CWOi+3XHF63EPud3uQSeiU4cEm6BXNeqraYXrP9OKzbrrW0K8Cw
         B9TfljRK8GUE74qjDXSETRfaespNtmikqz5qPSjeyIj1CWO7PO8r6sIDbdfTt5rcDf5X
         dA+hQqVrmTm5uW1KUi5slxfzF5J4RtboRN2u5YwuIabytlfME7ULFLOfiyfzS9CmyO2h
         bDOAx0+PuYqns/AAMtKRS8Sz61we6oaJvMbGu+4DDZ7OgmKrmRfguSbikU0zkFe9WtgO
         +Q351ae1+qD4BrSQDpIVveq4CIXOkEmH+gEXr1/AmNSo1FTwF7rdvmzL9DFB2aEBn0UE
         r6+A==
X-Gm-Message-State: AOAM533DeP/MC3JDlqJMX75oYYCwdCY9BAiwtAwDr3IF5dcsBGdslelX
        xeNCHNpdyNp4Z5g0BSnCdwvrL1Hlnu8oWvh8wdm2sBIjH+ccPRInl/b5uVLOrJUH54cbFIeg3ob
        /FzQVD5AX0TmegQQC
X-Received: by 2002:a7b:c38f:0:b0:385:e56c:8624 with SMTP id s15-20020a7bc38f000000b00385e56c8624mr4847701wmj.19.1646766592401;
        Tue, 08 Mar 2022 11:09:52 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwC0rGDPsrDiMATkvPQqazypaa5qCr/Q1ASEMdjC6vTObs5O8wfuxABhdbftjyb51AINrqn7A==
X-Received: by 2002:a7b:c38f:0:b0:385:e56c:8624 with SMTP id s15-20020a7bc38f000000b00385e56c8624mr4847692wmj.19.1646766592210;
        Tue, 08 Mar 2022 11:09:52 -0800 (PST)
Received: from debian.home (2a01cb058d3818005c1e4a7b0f47339f.ipv6.abo.wanadoo.fr. [2a01:cb05:8d38:1800:5c1e:4a7b:f47:339f])
        by smtp.gmail.com with ESMTPSA id t14-20020a5d49ce000000b001f036a29f42sm14437471wrs.116.2022.03.08.11.09.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 11:09:51 -0800 (PST)
Date:   Tue, 8 Mar 2022 20:09:49 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net] selftests: pmtu.sh: Kill tcpdump processes launched
 by subshell.
Message-ID: <20220308190949.GA3544@debian.home>
References: <0378c55466d8d1f7b6d99d581811d49429e1f4e7.1646691728.git.gnault@redhat.com>
 <d5a67e6a-6e1b-8f69-8d2a-e05708dfa3c9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5a67e6a-6e1b-8f69-8d2a-e05708dfa3c9@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 08, 2022 at 11:21:58AM -0700, David Ahern wrote:
> On 3/7/22 3:38 PM, Guillaume Nault wrote:
> > The cleanup() function takes care of killing processes launched by the
> > test functions. It relies on variables like ${tcpdump_pids} to get the
> > relevant PIDs. But tests are run in their own subshell, so updated
> > *_pids values are invisible to other shells. Therefore cleanup() never
> > sees any process to kill:
> > 
> > $ ./tools/testing/selftests/net/pmtu.sh -t pmtu_ipv4_exception
> > TEST: ipv4: PMTU exceptions                                         [ OK ]
> > TEST: ipv4: PMTU exceptions - nexthop objects                       [ OK ]
> > 
> > $ pgrep -af tcpdump
> > 6084 tcpdump -s 0 -i veth_A-R1 -w pmtu_ipv4_exception_veth_A-R1.pcap
> > 6085 tcpdump -s 0 -i veth_R1-A -w pmtu_ipv4_exception_veth_R1-A.pcap
> > 6086 tcpdump -s 0 -i veth_R1-B -w pmtu_ipv4_exception_veth_R1-B.pcap
> > 6087 tcpdump -s 0 -i veth_B-R1 -w pmtu_ipv4_exception_veth_B-R1.pcap
> > 6088 tcpdump -s 0 -i veth_A-R2 -w pmtu_ipv4_exception_veth_A-R2.pcap
> > 6089 tcpdump -s 0 -i veth_R2-A -w pmtu_ipv4_exception_veth_R2-A.pcap
> > 6090 tcpdump -s 0 -i veth_R2-B -w pmtu_ipv4_exception_veth_R2-B.pcap
> > 6091 tcpdump -s 0 -i veth_B-R2 -w pmtu_ipv4_exception_veth_B-R2.pcap
> > 6228 tcpdump -s 0 -i veth_A-R1 -w pmtu_ipv4_exception_veth_A-R1.pcap
> > 6229 tcpdump -s 0 -i veth_R1-A -w pmtu_ipv4_exception_veth_R1-A.pcap
> > 6230 tcpdump -s 0 -i veth_R1-B -w pmtu_ipv4_exception_veth_R1-B.pcap
> > 6231 tcpdump -s 0 -i veth_B-R1 -w pmtu_ipv4_exception_veth_B-R1.pcap
> > 6232 tcpdump -s 0 -i veth_A-R2 -w pmtu_ipv4_exception_veth_A-R2.pcap
> > 6233 tcpdump -s 0 -i veth_R2-A -w pmtu_ipv4_exception_veth_R2-A.pcap
> > 6234 tcpdump -s 0 -i veth_R2-B -w pmtu_ipv4_exception_veth_R2-B.pcap
> > 6235 tcpdump -s 0 -i veth_B-R2 -w pmtu_ipv4_exception_veth_B-R2.pcap
> > 
> > Fix this by running cleanup() in the context of the test subshell.
> > Now that each test cleans the environment after completion, there's no
> > need for calling cleanup() again when the next test starts. So let's
> > drop it from the setup() function. This is okay because cleanup() is
> > also called when pmtu.sh starts, so even the first test starts in a
> > clean environment.
> > 
> > Note: PAUSE_ON_FAIL is still evaluated before cleanup(), so one can
> > still inspect the test environment upon failure when using -p.
> > 
> > Fixes: a92a0a7b8e7c ("selftests: pmtu: Simplify cleanup and namespace names")
> > Signed-off-by: Guillaume Nault <gnault@redhat.com>
> > ---
> >  tools/testing/selftests/net/pmtu.sh | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Hum, looks like for such short lived tcpdump sessions, we also need to
disable buffered mode. Otherwise tcpdump can be killed before it
actually processed the packets.

Also there's another problem, with the xfrmudp tests not recording the
correct PID in ${nettest_pids}.

I'll send v2 to also fix all these problems.

