Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61D4C4B7A0A
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 22:54:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbiBOVyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 16:54:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234702AbiBOVyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 16:54:37 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03866F7458
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 13:54:26 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id u5so305622ple.3
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 13:54:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Z7L0pTumzOWCRxfFanuLyigEkGoFmzMvJe1YLjvitFs=;
        b=LqYCsKyIELFGs7z8ESN8ZrfD/a9kBxbNF4rgyIsbvyHgdTtShpxHVnttO40T0ipotV
         08cpF6qH7sMtB1ZoQuL308S3/6CregEdNss7/8aNGqhFZUi4n7AV+3J2bI1Xy3yiKeOw
         8DY4cMVeh17Ut7S2WRqYr3o4yEnuZ2ES6JNn6tPvQ5XwyOT5qQyhHvzMuJVP9GY9XA/e
         QJYpQCGkTGYDcfhxuy11sB+swD0eisaOvF3l71Vzcn2tWvoE37eZ4kqrT1y02SJqcxT4
         GtANmO1I2vRLop5lYJ/jLEo0TQvbfOFdjH/Lxkml6bnXMW+vmZ3bPERzFOE2O1+hV+v2
         vNmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z7L0pTumzOWCRxfFanuLyigEkGoFmzMvJe1YLjvitFs=;
        b=6QO487mVVEoP7MKs26aQ/8r6wwKBIiu6nTvLDD6amTKliekp4xmPBi02uM9DOk/nA4
         58H9lxEAOSoHKKIclismDw8/eQ70CyKD8IrgiKdcyLoELZoyNsMPdR0I4UfOjEhIyaT7
         83prRDZfSUnk/sHjJMEnNfrRCn7j8psj4kzoH3mssEx2XZumP9UMZWMqLcRuPkaGrdD/
         MvFWBcj0I2jsCAsclnw6zlTW+zUbtavkBPDbg9TxHjGa9UpfB1CUbd1zjBXUZOfw49Y7
         87szyfwx+38I5jLMqhCfWk5//mDhVoubXmqDAITrZyXhcOnJxo3vz7PeyElReiUG7zA9
         N4vw==
X-Gm-Message-State: AOAM530rBznbn5L1Rz9WyW2Uz0dVYgz6m6Tpa/8Q1aaQod7JKhTdc6cK
        yz+6sHPzDvyKxuoRNyTGEY0=
X-Google-Smtp-Source: ABdhPJzhDPHI5HKI11e55sXPP0UnRMDSyhElwZ3TlNzc2D4wRlOlRF+QH96CCkG3IQyM9dhroN0C6w==
X-Received: by 2002:a17:90a:6809:b0:1b9:bc46:fdd7 with SMTP id p9-20020a17090a680900b001b9bc46fdd7mr6753755pjj.148.1644962065304;
        Tue, 15 Feb 2022 13:54:25 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id o8sm42379504pfu.52.2022.02.15.13.54.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Feb 2022 13:54:24 -0800 (PST)
Message-ID: <3cb2f39c-b46a-d012-721b-d40285a75aee@gmail.com>
Date:   Tue, 15 Feb 2022 13:54:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: A missing check bug and an inconsistent check bug
Content-Language: en-US
To:     Jinmeng Zhou <jjjinmeng.zhou@gmail.com>, isdn@linux-pingi.de,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, shenwenbosmile@gmail.com
References: <CAA-qYXgrcXsgHMoDyTR74bryDsofzPajTfT6WZHGH-vaDixDwA@mail.gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <CAA-qYXgrcXsgHMoDyTR74bryDsofzPajTfT6WZHGH-vaDixDwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/15/22 04:30, Jinmeng Zhou wrote:
> Dear maintainers,
>
> Hi, our tool finds a missing check bug(v4.18.5),
> and an inconsistent check bug (v5.10.7) using static analysis.
> We are looking forward to having more experts' eyes on this. Thank you!
>
> Before calling sk_alloc() with SOCK_RAW type,
> there should be a permission check, ns_capable(ns,CAP_NET_RAW).
>
> In kernel v4.18.5, there is no check in base_sock_create().
> However, v5.10.7 adds a check.  (1) So is it a missing check bug?

Same answer, v4.18 is not a stable kernel, not sure why anyone would 
care about v4.18.5



