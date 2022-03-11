Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DDFB4D6909
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 20:19:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351055AbiCKTUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 14:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236052AbiCKTUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 14:20:15 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8221665834;
        Fri, 11 Mar 2022 11:19:11 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id z26so13332341lji.8;
        Fri, 11 Mar 2022 11:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=+ppRyN1F/joqH7Iccp9cXuXShPjyaDEeEE8XeiK+R9U=;
        b=LNgOqF7/nMiedqnDTfclARNq8iXOKPlLKGPxHtdx34mBA7rmZxEhBOVlbbLD+DuMOX
         Lqcq/SBJ4b/l24B91jEv/YXF6lsDycE21SPngw+QRHlR4dw1HHfvlj1fDu4pRm/XGWDt
         u0kN3MZiGlwVppNjC64NsDdG1dzbsH4ytHq3Mtdm0Y2YgLGoBpWOz5Sz9PlRkmFCZQ60
         gHx8MQdKbN0oNcKGo0tsBPMyPc2YYDZ/MF88IFLU6MQ8ZwDyPBr9XElOdTZKd9QDaBi1
         nRXwyl/mMLDcmjskq3/dgkd/LMklhNoEFTmTMfmrl2ktvfj9AzrCjfw19aYq/63Dw25i
         domQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+ppRyN1F/joqH7Iccp9cXuXShPjyaDEeEE8XeiK+R9U=;
        b=Db75rdbr/eLE3Hm5n8pmypMwLu22MmF3fLl2LEUwnS3FRTOOkLr83DgxZbNej/awot
         S8XRkXP3AdmqWfIRVONtfIEP8gkLN+Bv2pV9ltcIdtubSkx5RAvTqVJPN7aACVo/Ppab
         3t0ghNZF8mStDEFESsYK/2TI0zk3EtrTMi92EhmHvqHd7HnAibIEqM+Mi26F4z+Oayvl
         kkC4/7dAKVNBFQqGyoTvOw1G89If3135O4zE8oFp84w9ognQfll8lRNdJpp7j79zWnC6
         PWaKY1DvjMTpd4KSEbQ6AhjEv//3XpN/C3Gk6OThzE1wpFumEdigurQr+i1oBLRuqCO7
         JT6A==
X-Gm-Message-State: AOAM531V5RW3wP5sj4kfGtKDcUyjbb+H+PGKoObgmQcE1HhJEIycKrOI
        oM/LGwW9hzTqp6dImFTiX+c=
X-Google-Smtp-Source: ABdhPJw6y3HM7NfF+7DmyVLQfpwvi1AwDXqTk10CKH441d/rCCX/p8EIHM0BHEzNOwbZ7xkHauZiOQ==
X-Received: by 2002:a2e:bf0b:0:b0:246:84be:7b11 with SMTP id c11-20020a2ebf0b000000b0024684be7b11mr6811873ljr.145.1647026349843;
        Fri, 11 Mar 2022 11:19:09 -0800 (PST)
Received: from [192.168.1.11] ([94.103.229.107])
        by smtp.gmail.com with ESMTPSA id h14-20020a05651c158e00b00247fda7844dsm1886131ljq.90.2022.03.11.11.19.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 11:19:09 -0800 (PST)
Message-ID: <04e38a81-f159-2764-0b6b-34b8180ee87b@gmail.com>
Date:   Fri, 11 Mar 2022 22:19:08 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [syzbot] INFO: task hung in port100_probe
Content-Language: en-US
To:     syzbot <syzbot+abd2e0dafb481b621869@syzkaller.appspotmail.com>,
        hdanton@sina.com, krzysztof.kozlowski@canonical.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        stern@rowland.harvard.edu, syzkaller-bugs@googlegroups.com
References: <0000000000002e958005d9f6319d@google.com>
From:   Pavel Skripkin <paskripkin@gmail.com>
In-Reply-To: <0000000000002e958005d9f6319d@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/11/22 22:18, syzbot wrote:
> Hello,
> 
> syzbot tried to test the proposed patch but the build/boot failed:
> 
> failed to checkout kernel repo git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b: failed to run ["git" "fetch" "--force" "f569e972c8e9057ee9c286220c83a480ebf30cc5" "3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b"]: exit status 128
> fatal: couldn't find remote ref 3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b
> 

Em, looks like wrong format

#syz test:
git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 
3bf7edc84a9eb4007dd9a0cb8878a7e1d5ec6a3b




With regards,
Pavel Skripkin
