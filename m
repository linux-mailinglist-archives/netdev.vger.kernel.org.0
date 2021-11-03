Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042F6443BCA
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 04:18:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230152AbhKCDVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 23:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbhKCDVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 23:21:19 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D23C061714;
        Tue,  2 Nov 2021 20:18:44 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id g125so1791585oif.9;
        Tue, 02 Nov 2021 20:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PEbxxhHJ2eGH/OjLCiM05u+bvjKoPzIV8y8oWEupz6w=;
        b=eJ/n7RH5KFIu9tc0DtEY2eSsoA6R8uQ+D4jeb8mSvYJ9+Azxhtga+UyjGopDf+cxKe
         UWwUoGvnAgYwsGlpRJHfndtWvsteiDS0hOkMGFMB0fKf5GF+xIZvN3b1aM/7K+5Mq01n
         qlxENTi3gEhZqcftCMSvGpmikd20psKB3X2sJlPPSTGh5z1UF4QV13/X5AToW2ST3vFe
         oIE4jWwjCBq1LlbtpovqffV4FxRQ5DrNGxDOY3otTf2d2sYuBA+RINi8Ao6dvPVEacLm
         rS4RN1VTuG+KZpnyZQreMyCKx2vgXq9IxQdxFJyohxeqVN0UDEypEniwZu1vBAbCs2ue
         XkTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PEbxxhHJ2eGH/OjLCiM05u+bvjKoPzIV8y8oWEupz6w=;
        b=RDeWxha5c7reDR7SRPmvq/i/b/s7wbsqySgpiiHToIAE6HMzMsCAlU7BHTxV9IeDjX
         iJTUOwNsAgqPhuweQjQMtf4ajOMI47CkdT80g5gkcOv87fHEP+qaQaOdRrvb2FKC+N+J
         pm8QmZZhgfd6NGaHfSP4RUBDm82K5Rh5FtIOD9ucrRHrd484twG69k0BZZVe7FvPBy74
         AwFLC18JqFRFFMsI2jYVSPeBr62urlYDJmNk3g32tjtjAMyadA0rDKBXYME8BZdkGdiA
         ipKLO9K83a6obm2mrzxyDnbPG9TQnHQfspJwAUIIBGAUEiNXF5EEAIRDwyxuuGGlc8vx
         XeEQ==
X-Gm-Message-State: AOAM530IE24BwVNLc8UCA0MWxR1ZN+9YaeGVWLf/XOFCyCYRsfNqqFqf
        NlpERy8EKsv/kZEmVedCiMY=
X-Google-Smtp-Source: ABdhPJy11Txp6pqUexodtsquZIXuERcqwbncivyGbDc605t27eOpm4i7LopxHFGEpG9biRxDBHM3yg==
X-Received: by 2002:aca:af15:: with SMTP id y21mr4399522oie.61.1635909523555;
        Tue, 02 Nov 2021 20:18:43 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id a13sm244312oiy.9.2021.11.02.20.18.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Nov 2021 20:18:43 -0700 (PDT)
Message-ID: <832e6d49-8490-ab8b-479b-0420596d0aaa@gmail.com>
Date:   Tue, 2 Nov 2021 21:18:41 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH v2] tcp: Initial support for RFC5925 auth option
Content-Language: en-US
To:     Leonard Crestez <cdleonard@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Yuchung Cheng <ycheng@google.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Christoph Paasch <cpaasch@apple.com>,
        Ivan Delalande <colona@arista.com>,
        Priyaranjan Jha <priyarjha@google.com>, netdev@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1635784253.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <cover.1635784253.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 10:34 AM, Leonard Crestez wrote:
> This is similar to TCP MD5 in functionality but it's sufficiently
> different that wire formats are incompatible. Compared to TCP-MD5 more
> algorithms are supported and multiple keys can be used on the same
> connection but there is still no negotiation mechanism.
> 
> Expected use-case is protecting long-duration BGP/LDP connections
> between routers using pre-shared keys. The goal of this series is to
> allow routers using the linux TCP stack to interoperate with vendors
> such as Cisco and Juniper.
> 
> Both algorithms described in RFC5926 are implemented but the code is not
> very easily extensible beyond that. In particular there are several code
> paths making stack allocations based on RFC5926 maximum, those would
> have to be increased.
> 
> This version implements SNE and l3mdev awareness and adds more tests.
> Here are some known flaws and limitations:
> 
> * Interaction with TCP-MD5 not tested in all corners
> * Interaction with FASTOPEN not tested and unlikely to work because
> sequence number assumptions for syn/ack.
> * Not clear if crypto_shash_setkey might sleep. If some implementation
> do that then maybe they could be excluded through alloc flags.
> * Traffic key is not cached (reducing performance)
> * User is responsible for ensuring keys do not overlap.
> * There is no useful way to list keys, making userspace debug difficult.
> * There is no prefixlen support equivalent to md5. This is used in
> some complex FRR configs.
> 
> Test suite was added to tools/selftests/tcp_authopt. Tests are written
> in python using pytest and scapy and check the API in some detail and
> validate packet captures. Python code is already used in linux and in
> kselftests but virtualenvs not very much, this particular test suite
> uses `pip` to create a private virtualenv and hide dependencies.
> 
> This actually forms the bulk of the series by raw line-count. Since
> there is a lot of code it was mostly split on "functional area" so most
> files are only affected by a single code. A lot of those tests are
> relevant to TCP-MD5 so perhaps it might help to split into a separate
> series?
> 
> Some testing support is included in nettest and fcnal-test.sh, similar
> to the current level of tcp-md5 testing.
> 
> SNE was tested by creating connections in a loop until a large SEQ is
> randomly selected and then making it rollover. The "connect in a loop"
> step ran into timewait overflow and connection failure on port reuse.
> After spending some time on this issue and my conclusion is that AO
> makes it impossible to kill remainders of old connections in a manner
> similar to unsigned or md5sig, this is because signatures are dependent
> on ISNs.  This means that if a timewait socket is closed improperly then
> information required to RST the peer is lost.
> 
> The fact that AO completely breaks all connection-less RSTs is
> acknowledged in the RFC and the workaround of "respect timewait" seems
> acceptable.
> 
> Changes for frr (old): https://github.com/FRRouting/frr/pull/9442
> That PR was made early for ABI feedback, it has many issues.
> 

overall looks ok to me. I did not wade through the protocol details.

I did see the comment about no prefixlen support in the tests. A lot of
patches to absorb, perhaps I missed it. Does AuthOpt support for
prefixes? If not, you should consider adding that as a quick follow on
(within the same dev cycle). MD5 added prefix support for scalability;
seems like AO should be concerned about the same.

