Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A82E6135A9
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiJaMRX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231276AbiJaMRV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:17:21 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5468EE23;
        Mon, 31 Oct 2022 05:17:20 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id z18so12141707edb.9;
        Mon, 31 Oct 2022 05:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hsqRH+vO+rjaZ62MIoRDwiYLhcjXqUkBqkIdEzd2p0M=;
        b=E/YrgHrgTe/w6zX/2SRunSlHYpdYElXZLU3AxNYI9hIKs7kK/7v7QXPBv9BO2EV7Kr
         rk+1HLKp1TJrN85hH3TCVY1ZLiMu2sOon3qSs73rNYAoPgy+dBa9uYSWeeVD/82jcHTw
         u5r0RB+Pgc+0d6kqyX8CPfF9LGe3syTzl/6UW+tEPOSnGB99mqdb/hVKzqtLA1msNm2M
         lgQFsVFRq+03z80r6kWF8iWynJxI8u0ywI/mQ42QEo0yo1udMQ10L58I2uJJea8SuJZH
         kBdAdL/mrqBvDy8Px7IuMzxUoVJy2FAwf1Y2mud6ekY3UOmdqXK+HG3lMbsdrRdifoys
         PPCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsqRH+vO+rjaZ62MIoRDwiYLhcjXqUkBqkIdEzd2p0M=;
        b=6XDrV8z3m5T4ZuIKyKmfLiBua+YchIbLJ0fj9QwXViYw0JWQ+dUEpYMRxXG+CIYqlU
         bPDQ3qayD7297kF3epIS6BAv8nuR1Ufh35R2rIRjtU4+4T5gjQGewnVspnLD6Jzx/2Go
         ef4R2GO9bwQY/ueGqm5OydpuMUdCV0aSsRRZ2fJz/+uWzrgBwqem0R+8tUDUHBf3FLNA
         Prd17oEz25GZlcIJdO8470uKLObQW9msATKpKwLlSg0ZaihNsNtGkxXiFS+nCgt070zH
         ozMoqtPwmhOl4aeMcEskUpQaEC4msyl8ZPkV1MByNYlv0yCKIIw0rCkDQxAkivHAawYX
         R6Bg==
X-Gm-Message-State: ACrzQf3QunuTI+DZGeKdtmzfcYdu4sI+9z+dXzgeVlqeaqYxW1QEQLiE
        UYi/dnRUHm/AA3EpMfKGbfokJCEtHVQ=
X-Google-Smtp-Source: AMsMyM5TO/yroXBvW7mBAHSZW1VulWAGl6IrIbfHHyTNKIkkU4cRW0BdOhbAJsSi76S7Kn9Y+dgMxA==
X-Received: by 2002:a05:6402:1619:b0:462:b059:9655 with SMTP id f25-20020a056402161900b00462b0599655mr13049228edv.316.1667218639338;
        Mon, 31 Oct 2022 05:17:19 -0700 (PDT)
Received: from krava (2001-1ae9-1c2-4c00-726e-c10f-8833-ff22.ip6.tmcz.cz. [2001:1ae9:1c2:4c00:726e:c10f:8833:ff22])
        by smtp.gmail.com with ESMTPSA id o17-20020aa7dd51000000b004637489cf08sm723801edw.88.2022.10.31.05.17.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 05:17:18 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Mon, 31 Oct 2022 13:17:16 +0100
To:     David Laight <David.Laight@aculab.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Linux 6.1-rc3 build fail in include/linux/bpf.h
Message-ID: <Y1+8zIdf8mgQXwHg@krava>
References: <439d8dc735bb4858875377df67f1b29a@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <439d8dc735bb4858875377df67f1b29a@AcuMS.aculab.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 31, 2022 at 11:14:31AM +0000, David Laight wrote:
> The 6.1-rc3 sources fail to build because bpf.h unconditionally
> #define BPF_DISPATCHER_ATTRIBUTES __attribute__((patchable_function_entry(5)))
> for X86_64 builds.
> 
> I'm pretty sure that should depend on some other options
> since the compiler isn't required to support it.
> (The gcc 7.5.0 on my Ubunti 18.04 system certainly doesn't)
> 
> The only other reference to that attribute is in the definition
> of 'notrace' in compiler.h.

I guess we need to make some __has_attribute check and make all that conditional

cc-ing Peter

jirka

> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 
