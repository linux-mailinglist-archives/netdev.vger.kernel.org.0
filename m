Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4947B6D159E
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 04:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbjCaCbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 22:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCaCbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 22:31:48 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17258D50B
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 19:31:48 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id d13so19101367pjh.0
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 19:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680229907;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/vR8KQojPzaT8Rw4TNngFn4Gc1GQJLH40isuuHHz2Rg=;
        b=PS2l1w0Q062JGhbQDE6Km+cOMu4J/+JMrQe3V0prHP7TDFKFLo+vK0mARRS6HIKeX5
         f0MKxTbtXhtj1J9QMbk3lZfPZEr/2RS7KiZWXpzG2Lk1s4hGrFs8p3G5II8I19IRnXuZ
         A4jVZRDPtX9ZZ36bw7Vjmmpv+m4Ntj2FF+t5rCfGFvq1noy5QKjzt/mj8vbX3AxH1cb0
         iyqgHQdD728kBLdkPL8RCACugLeVUOSj2b45PaPyjzVjVfYe4hG6Xmna3RjZcDXEn+/o
         /hbylyxpJUxJkOjIDOFp0JOLxVBcsTroQHj98/bB6MNQWQAQpDQVixV+FQhgaheChOsA
         yYgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680229907;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/vR8KQojPzaT8Rw4TNngFn4Gc1GQJLH40isuuHHz2Rg=;
        b=y6ICOTGXR4TyI1mEKGJ4Bw6oy/Low9JiAPbzSDYx7NcjXdEGNo0I5EmdMhcAR2CNNC
         WSvW2zeQ/u902hnYBpedZJ/+Grn3Cz9n55ZknzmTNhcdaMZPC0kFgqubZe89ntFTU2J9
         Gs6st0rpol82sRY00m14V53gn1vH9fInvqP3uizCLTa6GTOlnm6UQvsomat5ZKAQlI5S
         ADH8attK02uwX54oYMFrnFckFm0GLEKOZAMhR7c9xnb7c2YivgCIaXNpZ6Tt8GKJU/Os
         KIB6ozqNJ/xniCOTkFj77NbKIVLgLefC0WdWD/zEpuhXcZNkfQKg+QgM+9NTvLonTXKS
         aoMA==
X-Gm-Message-State: AO0yUKX7SlTU9K3KgvpoJKbezBQ3qkTPWGhSic1HHDSFAcs/d8jTVVZ2
        HoZuvVdClLZbAqlFJrRN2b0=
X-Google-Smtp-Source: AK7set/xhV4Y8cYR17YbebZI+UIuCRXjEy61sBNnkrCfo22W3LguHk/Thbcw/eTrnrktcZoDG7TaMQ==
X-Received: by 2002:a05:6a20:b927:b0:d8:bd6d:e122 with SMTP id fe39-20020a056a20b92700b000d8bd6de122mr22627154pzb.29.1680229907508;
        Thu, 30 Mar 2023 19:31:47 -0700 (PDT)
Received: from Laptop-X1 ([2409:8a02:7821:7c20:eae8:14e5:92b6:47cb])
        by smtp.gmail.com with ESMTPSA id p22-20020aa78616000000b005dd98927cc5sm530202pfn.76.2023.03.30.19.31.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 19:31:46 -0700 (PDT)
Date:   Fri, 31 Mar 2023 10:31:41 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, Jay Vosburgh <j.vosburgh@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Liang Li <liali@redhat.com>
Subject: Re: [PATCH net 2/3] selftests: bonding: re-format bond option tests
Message-ID: <ZCZGDQezuxXJuMd5@Laptop-X1>
References: <20230329101859.3458449-1-liuhangbin@gmail.com>
 <20230329101859.3458449-3-liuhangbin@gmail.com>
 <301d2861-1390-eaea-4521-90d4dcfe7336@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <301d2861-1390-eaea-4521-90d4dcfe7336@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 12:45:11PM -0400, Jonathan Toppins wrote:
> On 3/29/23 06:18, Hangbin Liu wrote:
> > To improve the testing process for bond options, A new bond library is
> > added to our testing setup. The current option_prio.sh file will be
> > renamed to bond_options.sh so that all bonding options can be tested here.
> > Specifically, for priority testing, we will run all tests using module
>                                            I think you mean `modes`^^^

Ah, yes.

> > 1, 5, and 6. These changes will help us streamline the testing process
> > and ensure that our bond options are rigorously evaluated.
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > ---
> > diff --git a/tools/testing/selftests/drivers/net/bonding/bond_lib.sh b/tools/testing/selftests/drivers/net/bonding/bond_lib.sh
> > new file mode 100644
> > index 000000000000..ca64a82e1385
> > --- /dev/null
> > +++ b/tools/testing/selftests/drivers/net/bonding/bond_lib.sh
> 
> I like this idea, we might want to separate network topology from library
> code however. That way a given test case can just include a predefined

Would you like to help explain more clear? Separate network topology to where?

> topology. A quick review of the test cases show a 2 node setup is the most
> common across all test cases.

Liang suggested that with 2 clients we can test xmit_hash_policy. In
client_create() I only create 1 client for current testing. We can add more
clients in future.

Thanks
Hangbin
