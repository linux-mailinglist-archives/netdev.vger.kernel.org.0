Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 572C2620BC6
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 10:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232929AbiKHJJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 04:09:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiKHJJO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 04:09:14 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D042617AB6
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 01:09:13 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id h193so12839297pgc.10
        for <netdev@vger.kernel.org>; Tue, 08 Nov 2022 01:09:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6BdolG571xejYqOL4ulA7/eFGO/ckfowxkb67ea9SlM=;
        b=ewRvUjtoI2wnHV6UiS6g6drC39BnvYw2ntb9e/5RDzRGqmTMTbKO1LPJ7qz4xim2Jc
         6LL69iME5AXWkipM5lQD0V7b4i9Uk6IxbZ+QBLn1hRXZkyTFxsXmOBLOV+kqxSOQCv4+
         isg9beAEnCcwUAyjzbyskhkXvYyF/o7VuFmNoBfTw8eO/joi/9H2SP4kMJgZnbKAPtsN
         vJQQftDUIxFbEu6KibmgmqIg8X9VSgZkmEPFnuWNR4WHBFRHqcAsqqEyVQqCIpPD6Tmj
         UpCueKGefnWdy6koew4siNIiTr0ntHBHy3zjEZm2BdA2icGC7i0e8yXI608odER8yYeS
         33WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6BdolG571xejYqOL4ulA7/eFGO/ckfowxkb67ea9SlM=;
        b=53o0a3KvT7k44qq5fpNunINgGPxCAhsaG9YxZTLsH2P/SBcjzlov+++e26YFfcohC3
         9Cpx/gXgcFytVSPyj6w/tcKHFY2d0fM19OmdmP1P2JtsB6+NwM1Azw5CV3q76L6BIzKO
         CJ8PW5lZuWisZynMSp5rrsdTtE9EgyHPjdcwvOykUHWHzlMAyCB2FBVSlN+csYO+uAED
         dpf6ex4bchyqRyD/ahmLYtGE/WEDM5Z7HX2U8BzdSTGXpyxPmaglhVuzIjcFl1FYmrbA
         49due0IKvE0vMyPHFCtj2qrAadH3a+sFQV7gkJxzp5vaU1xPfnHVVW/sibL3J7h+pXTk
         O0og==
X-Gm-Message-State: ANoB5pnpZ/oY7IXMu84u3wKVHPb/1K5lgu6txTicaP56kq4qRruZFgtN
        R9KV1BFontj22ziPv2jzv36H3XUmvoQ=
X-Google-Smtp-Source: AA0mqf4HRUxgs8Jg/KX5xMtJg9vGIuc3yib8FWU1cHVRxLQwlDyeoMGlXNkDvwJCWL0iSiF8R3FB/g==
X-Received: by 2002:a65:4908:0:b0:470:6287:8886 with SMTP id p8-20020a654908000000b0047062878886mr12394949pgs.199.1667898553321;
        Tue, 08 Nov 2022 01:09:13 -0800 (PST)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y2-20020a17090a6c8200b0020087d7e778sm7501892pjj.37.2022.11.08.01.09.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 01:09:12 -0800 (PST)
Date:   Tue, 8 Nov 2022 17:09:05 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCHv3 iproute2-next] rtnetlink: add new function
 rtnl_echo_talk()
Message-ID: <Y2ocsXykgqIHCcrF@Laptop-X1>
References: <20220929081016.479323-1-liuhangbin@gmail.com>
 <Y2oWDRIIR6gjkM4a@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y2oWDRIIR6gjkM4a@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 08, 2022 at 10:40:45AM +0200, Ido Schimmel wrote:
> > +	return rtnl_talk(&rth, &req.n, NULL);
> >  }
> 
> Hangbin,
> 
> This change breaks the nexthop selftest:
> tools/testing/selftests/net/fib_nexthops.sh
> 
> Which is specifically checking for "2" as the error code. Example:

Hi Ido,

Thanks for the report.

> 
> # attempt to create nh without a device or gw - fails
> run_cmd "$IP nexthop add id 1"
> log_test $? 2 "Nexthop with no device or gateway"
> 
> I think it's better to restore the original error code than "fixing" all
> the tests / applications that rely on it.

I can fix this either in iproute2 or in the selftests.
I'd perfer ask David's opinion.

> 
> The return code of other subcommands was also changed by this patch, but
> so far all the failures I have seen are related to "nexthop" subcommand.

I grep "log_test \$? 2" in selftest/net folder and found the following tests
would use it

fib_tests.sh
test_vxlan_vnifiltering.sh
fcnal-test.sh
fib_nexthops.sh

Thanks
Hangbin
