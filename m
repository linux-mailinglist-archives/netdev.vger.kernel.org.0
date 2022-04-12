Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700DF4FDBBC
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346842AbiDLKGh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381734AbiDLIYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 04:24:05 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A81554B7
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 00:57:19 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id t25so30756391lfg.7
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 00:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=5k6k5OzQ/nNaAhxNcy8dyG0hqPxB3EyqZUWXJxiNXVA=;
        b=VZVe0At+6TDw7PG/U/Tm9jp7AUkurQCeKoeiTwS7Ewd+b5wIFjM4lFLnE/5MRKVpYw
         oTdiVYhGwcy6799RvVVQ1vhQTQOus+nSEnUAyc6OskwB3X6sy930UNZntaKE+DkDSDgg
         tLrutCJfRHFbdfKMpIVSavG0JGdIAZ/bMDKOw7MpQ8r91/MHfsO+YwyUBxsrQH5lbXxj
         85jtwmFsPxcZxp71FoQcp9dkhpwmD2iokeasjqyfI1JmPJ4uItraV582ieHNxjIRWdBW
         /4bcfbbHyXRJlRBoEbboncuRJ5tk/O38r99LSk1XgmmTMZdFizuSgODQwR9+SlZ279Nd
         JWQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=5k6k5OzQ/nNaAhxNcy8dyG0hqPxB3EyqZUWXJxiNXVA=;
        b=Hw0TaW/kcJ0krujd1xz0Gyu+S03/6VqkR80aP4GzsXUi8huoKG+WX00SxQu/GwHT9T
         JL2zB2s52DFEf7BPqZaanMS7kL5Zv8G3Uc025MQdmD4BMkx4fxFSJNorT6+2+SrMKMe5
         YxmUZ3vB2Z/j5wfK9nAKKusHhl1xN3218lLp7nkd/gj8Mloh5u8kX+LovjMtSt0goeaD
         1YBA97jZktI8Xoj3foQIofCD/okhRBnx/AMCnLKtzZv/DRAPq/pz875vLi4RqapUKckE
         rhJOSnicN4mVjjZreYBXbHaqc13Qqmw0EertenmT6/o8TdB9aJ8YJy2bD0ffELiMKORw
         dd2w==
X-Gm-Message-State: AOAM5305t5mr+3yJqyC8kEmhDHwdZFT+2Bd31JiPUo6TadiFK2K6V88z
        Pv81nZ6dJmQD2QqsgOGtPj8=
X-Google-Smtp-Source: ABdhPJwLNjvF5QSGeOhLDAvLKzk2mwLLULfRnwHewmXY30GlxMr/jJlJoPQOjKhVXE6CruY2xnUD/w==
X-Received: by 2002:ac2:5ed1:0:b0:46b:8d11:84eb with SMTP id d17-20020ac25ed1000000b0046b8d1184ebmr11867442lfq.174.1649750237973;
        Tue, 12 Apr 2022 00:57:17 -0700 (PDT)
Received: from wbg (h-158-174-22-128.NA.cust.bahnhof.se. [158.174.22.128])
        by smtp.gmail.com with ESMTPSA id x40-20020a056512132800b004489691436esm3564520lfu.146.2022.04.12.00.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 00:57:17 -0700 (PDT)
From:   Joachim Wiberg <troglobit@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
        "bridge\@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: Re: [PATCH RFC net-next 09/13] selftests: forwarding: rename test groups for next bridge mdb tests
In-Reply-To: <20220411202315.mxgqmvktodavdmwr@skbuf>
References: <20220411133837.318876-1-troglobit@gmail.com> <20220411133837.318876-10-troglobit@gmail.com> <20220411202315.mxgqmvktodavdmwr@skbuf>
Date:   Tue, 12 Apr 2022 09:57:16 +0200
Message-ID: <87czhmbuoz.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 11, 2022 at 20:23, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> On Mon, Apr 11, 2022 at 03:38:33PM +0200, Joachim Wiberg wrote:
>> -TEST_GROUP_IP4="225.1.2.3"
>> -TEST_GROUP_IP6="ff02::42"
>> -TEST_GROUP_MAC="01:00:01:c0:ff:ee"
>> +PASS_GRP_IP4="225.1.2.3"
>> +FAIL_GRP_IP4="225.1.2.4"
>> +PASS_GRP_MAC="01:00:01:c0:ff:ee"
>> +FAIL_GRP_MAC="01:00:01:c0:ff:ef"
>> +
>> +PASS_GRP_IP6="ff02::42"
>> +FAIL_GRP_IP6="ff02::43"
> This is more than just the advertised rename, the fail groups are new
> and not used in this change.

Yeah I rushed the set out to get feedback on the overall take, sorry
about this.  I'll see to fixing this for the non-RFC drop.  Thanks!
