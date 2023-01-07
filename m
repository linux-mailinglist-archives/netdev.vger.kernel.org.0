Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A54B1660C32
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 04:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbjAGDgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 22:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbjAGDgs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 22:36:48 -0500
Received: from domac.alu.hr (domac.alu.unizg.hr [161.53.235.3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D69E26471;
        Fri,  6 Jan 2023 19:36:45 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id 82DD2604F0;
        Sat,  7 Jan 2023 04:36:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.hr; s=mail;
        t=1673062600; bh=usEPs2z0NeHXunWjrrFs/3ME5ULtPxYq3W+us+xTUc0=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=Kj6BkZsPSyJywfjX9V7qIo8dEDvgNX7K8A/XZRQ0PMqBPKtABzKHXpAWln3clShXU
         tvSt216GdJ2U+iHvZgKKYn21fBtmiQHrkcdit6XujqDuK1kXrslcfcFcyEbxMuPtoY
         0Sr3LXZqOt1eeo2s4iGgKVXCl0vtt2XIEQgLXfXXcZiandiR6lg5VkrsmjEF57kuKC
         MHiJNZZEZg+fFWoRlckrqjdBlBtQRdbAoXrBujgO/qFaJ9F/P5yEYclkKz+m8nNmBA
         amOszf2lE0VljBjmcV1KOxgSQPyEBo5sBBNqlqZRPFcf7atuzWC++5r11i46Hn5cck
         0l5pDHHOBlQrQ==
X-Virus-Scanned: Debian amavisd-new at domac.alu.hr
Received: from domac.alu.hr ([127.0.0.1])
        by localhost (domac.alu.hr [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 4nnbAIEkRzy1; Sat,  7 Jan 2023 04:36:36 +0100 (CET)
Received: by domac.alu.hr (Postfix, from userid 1014)
        id ACA27604F1; Sat,  7 Jan 2023 04:36:36 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=alu.hr; s=mail;
        t=1673062596; bh=usEPs2z0NeHXunWjrrFs/3ME5ULtPxYq3W+us+xTUc0=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=qU7Mx9f2oTM5hKOTPJEediH97wwMbdR/SrdL2n4hlrClAVrMvuDCfmGS47jyzPk3u
         6veyuzZudIwb1lWG7QC+ugeBTYBoYS6xWJbD70Yuj0ky5rOkSnyGOa7/RuORD93nUp
         ShU6C/bnOyNvz7Z8hvzyENtLCL5mV37GNkcW+e2PHsNCHLMCNgUFoibmVv6wVAD29f
         v9FQlNAzWXipofytYwmNZAaYoyRNFBjLhMNB9BM4yXEJFroCxrBQ/3dJ5+oS/vgBte
         YlU4KVDK4B48xsOvbFLGxTqn/pAXBubYsvtUhxc/h2j1VrQ1ODGnUnQ8DrSj+k60sT
         iy5zfjrBtXh7Q==
Received: from localhost (localhost [127.0.0.1])
        by domac.alu.hr (Postfix) with ESMTP id A9C9D604F0;
        Sat,  7 Jan 2023 04:36:36 +0100 (CET)
Date:   Sat, 7 Jan 2023 04:36:36 +0100 (CET)
From:   Mirsad Goran Todorovac <mirsad.todorovac@alu.hr>
To:     Jakub Kicinski <kuba@kernel.org>,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
cc:     Kuniyuki Iwashima <kuniyu@amazon.com>, davem@davemloft.net,
        edumazet@google.com, fw@strlen.de, kuniyu@amazon.co.jp,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, shuah@kernel.org
Subject: Re: [PATCH net v2] af_unix: selftest: Fix the size of the parameter
 to connect()
In-Reply-To: <20230106180808.51550e82@kernel.org>
Message-ID: <alpine.DEB.2.21.2301070433300.26826@domac.alu.hr>
References: <bd7ff00a-6892-fd56-b3ca-4b3feb6121d8@alu.unizg.hr>        <20230106175828.13333-1-kuniyu@amazon.com>        <b80ffedf-3f53-08f7-baf0-db0450b8853f@alu.unizg.hr>        <20230106161450.1d5579bf@kernel.org>        <8fb1a2c5-ee35-67eb-ef3c-e2673061850d@alu.unizg.hr>
 <20230106180808.51550e82@kernel.org>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="899744747-57767353-1673062596=:26826"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--899744747-57767353-1673062596=:26826
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 6 Jan 2023, Jakub Kicinski wrote:

> On Sat, 7 Jan 2023 02:42:43 +0100 Mirsad Goran Todorovac wrote:
> > > still doesn't apply, probably because there are two email footers  
> > 
> > Thank you for the guidelines to make your robots happy :), the next
> > time I will assume all these from start, provided that I find and
> > patch another bug or issue.
> 
> Ah, sorry, wrong assumption :S
> 
> Your email client converts tabs to spaces, that's the problem.
> 
> Could you try get send-email ?

Sorry, couldn't make git send-email nor mutt IMAP running at such a short 
notice.

I've chosen Alpine due to advice in Documentation/process/email-clients.rst

Hope that will work.

Thank you for your patience with guidelines for this patch.

Thanks,
Mirsad

--
Mirsad Goran Todorovac
Sistem inženjer
Grafički fakultet | Akademija likovnih umjetnosti
Sveučilište u Zagrebu

System engineer
Faculty of Graphic Arts | Academy of Fine Arts
University of Zagreb, Republic of Croatia
The European Union
--899744747-57767353-1673062596=:26826--
