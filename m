Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C52864CCC01
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 03:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236550AbiCDCwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 21:52:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiCDCwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 21:52:07 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF40E7AC8;
        Thu,  3 Mar 2022 18:51:21 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id mv5-20020a17090b198500b001bf2a039831so180700pjb.5;
        Thu, 03 Mar 2022 18:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=owY1s88VHqFIqmWlN/4fq6tMIh7jqxjAFgGkmfxykCc=;
        b=be6F6DUnBVqm6V8lf6rJEZlRStZRBrvf/NOPkoEFbfXxUE3/hQ6TPD10pbNkQro36n
         X7XWV7VX7RwlfhlghkxS6z4KqHuuY6n0xSK59EAzGhcks76Rg7ENd/tmaL+ivQxo6q6q
         ck/39o8bSNRHz6V1//cnQYt9KvTBcQP4LFOST9HXS6FRW1HMZ2cn1rf+8v0JbDm2J6D5
         31dag7spo5VRAo6cPZIsMJM0lFhYVVp6oYxAAXmAOUw2lBTQacPvVqmzt//+4pxDRIDO
         hmEjg+t8xH7tRnRUjjr9UNmNassjZplIQ892Svbf0c1+cOv+Rs0PpGaRI4rqRnG94XkE
         Tb1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=owY1s88VHqFIqmWlN/4fq6tMIh7jqxjAFgGkmfxykCc=;
        b=WxSHBqRCazYOH0jjpI7oROSmthG+tW1ZG29Oc0aeS8gRqVyy/ws6JDkK6cbLVx6BxW
         P3c2PHju2Vc6WMGIB/rFoGFNBE508BfTqun7KVO1ZcYiHPWoNzj4CeCxhDeloMedFMIg
         ia9YzpF7ONGV1hkU/GvgwrQFi0h3hsssbX6FkexcZdW6d3XAYNzypVTf/D0GXppjJx9K
         dFflOWj8b9+GgvcXIxxDLvasRjeI0EdsByyxL8/dR2gVbR7APrPKVBk0/tmFfGJ4DxTD
         yMNBCQwuzMy6ahhqsOvfp5MUZmUklXOa2RqqNM/XtT/sYwKkKh11zYlpww9ZnWwl3Y0p
         Iq7Q==
X-Gm-Message-State: AOAM532DOBK++rGVh3Iy8Fmxf6VObGXbP8Lij/uGSDTmtec9dGYS/aXb
        WZzUuAhNhMXn12EU6PE77BA=
X-Google-Smtp-Source: ABdhPJzFlaLTCsMtGn2cwRd0MGGVF6lbESQ/hRdBkkUekh8Das9Mmy1uSMMmXl5QuWqGAAT+m8xkgQ==
X-Received: by 2002:a17:90b:1bca:b0:1bf:1a17:beda with SMTP id oa10-20020a17090b1bca00b001bf1a17bedamr4491359pjb.215.1646362280440;
        Thu, 03 Mar 2022 18:51:20 -0800 (PST)
Received: from ubuntu.huawei.com ([119.3.119.19])
        by smtp.googlemail.com with ESMTPSA id w5-20020a056a0014c500b004f3a5535431sm4143781pfu.4.2022.03.03.18.51.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Mar 2022 18:51:19 -0800 (PST)
From:   Xiaomeng Tong <xiam0nd.tong@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     arnd@arndb.de, gregkh@linuxfoundation.org, jakobkoschel@gmail.com,
        jannh@google.com, keescook@chromium.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, netdev@vger.kernel.org, xiam0nd.tong@gmail.com
Subject: Re: [PATCH 2/6] list: add new MACROs to make iterator invisiable outside the loop
Date:   Fri,  4 Mar 2022 10:51:09 +0800
Message-Id: <20220304025109.15501-1-xiam0nd.tong@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <CAHk-=whJX52b1jNsmzXeVr6Z898R=9rBcSYx2oLt69XKDbqhOg@mail.gmail.com>
References: <CAHk-=whJX52b1jNsmzXeVr6Z898R=9rBcSYx2oLt69XKDbqhOg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

First of all, thank you very much for your patient reply and valuable
comments. This is a great inspiration to me.

> On Mon, Feb 28, 2022 at 11:59 PM Xiaomeng Tong <xiam0nd.tong@gmail.com> wrote:
> >
> > +#define list_for_each_entry_inside(pos, type, head, member)            \
> 
> So as mentioned in another thread, I actually tried exactly this.
> 
> And it was horrendous.
> 
> It's _technically_ probably a very nice solution, but

Yes, I always think it is a perfect solution _technically_, since you
first proposed in the thread of Jakob's first subject.

> 
>  - it means that the already *good* cases are the ones that are
> penalized by having to change

Yes, but it also kills potential risks that one day somebody mistakely
uses iterator after the loop in this already *good* cases, as it removed
the original declare of pos and any use-after-loop will be catched by
compiler.

> 
>  - the syntax of the thing becomes absolutely nasty
> 
> which means that _practially_ it's exactly the wrong thing to do.
> 
> Just as an example, this is a random current "good user" in kernel/exit.c:
> 
> -       list_for_each_entry_safe(p, n, dead, ptrace_entry) {
> +       list_for_each_entry_safe_inside(p, n, struct task_struct,
> dead, ptrace_entry) {
> 
> and while some of the effects are nice (no need to declare p/n ahead
> of time), just look at how nasty that line is.
> 
> Basically every single use will result in an over-long line. The above
> example has minimal indentation, almost minimal variable names (to the
> point of not being very descriptive at all), and one of the most basic
> kernel structure types. And it still ended up 87 columns wide.
> 
>  And no, the answer to that is not "do it on multiple lines then".
> That is just even worse.

Two avoid multiple lines,  there are some mitigations:
1. use a shorter macro name: (add 2 chars)
list_for_each_entry_i instead of list_for_each_entry_inside

2. using a shorter type passing to the macro: (add 3 chars)
+ #define t struct sram_bank_info
- list_for_each_entry(pos, head, member) {
+ list_for_each_entry_i(pos, t, head, member) {

3. restore all name back to list_for_each_entry after everything is done:
   (minus 2 chars)
Although we need replace all the use of list_for_each_entry* (15000+)
with list_for_each_entry*_i, the work can be done gradually rather
than all at once. We can incrementally replace these callers until
all these in the kernel are completely updated with *_i* one. At
that time, we can just remove the implements of origin macros and rename
the *_i* macro back to the origin name just in one single patch.

4. As you mentioned, the "safe" version of list_for_each_entry do not
   need "n" argument anymore with the help of -std=gnu11. (minus 3 chars)

Thus, after all mitigations applied, the "safe" version adds *no* chars to
columns wide, and other version adds 3 chars totally, which is acceptable
to me.

> 
> So I really think this is a major step in the wrong direction.

Maybe yes or maybe no.
Before the list_for_each_entry_inside way, I have tried something like
"typeof(pos) pos" way as and before you proposed in the thread of Jakob's
second subject, to avoid any changes to callers of the macros. But it also
has potential problems. see my previous reply to you here:
https://lore.kernel.org/lkml/20220302093106.8402-1-xiam0nd.tong@gmail.com/

> 
> We should strive for the *bad* cases to have to do extra work, and
> even there we should really strive for legibility.

Indeed, there are many "multiple lines" problems in the current kernel
code, for example (drivers/dma/iop-adma.c):
				list_for_each_entry_from(grp_iter,
					&iop_chan->chain, chain_node) {

> 
> Now, I think that "safe" version in particular can be simplified:
> there's no reason to give the "n" variable a name. Now that we can
> (with -stc=gnu11) just declare our own variables in the for-loop, the
> need for that externally visible 'next' declaration just goes away.
> 
> So three of those 87 columns are pointless and should be removed. The
> macro can just internally decare 'n' like it always wanted (but
> couldn't do due to legacy C language syntax restrictions).

Great, this does reduce three chars. and i will look into other versions.

> 
> But even with that fixed, it's still a very cumbersome line.

With other mitigations mentioned above, the addition to line will be
acceptable.

> 
> Note how the old syntax was "only" 60 characters - long but still
> quite legible (and would have space for two more levels of indentation
> without even hitting 80 characters). And that was _despute_ having to
> have that 'n' declaration.
> 
> And yes, the old syntax does require that
> 
>         struct task_struct *p, *n;
> 
> line to declare the types, but that really is not a huge burden, and
> is not complicated. It's just another "variables of the right type"
> line (and as mentioned, the 'n' part has always been a C syntax
> annoyance).

Yes, that really is not a huge burden, so is the mitigation 2 mentioned
above which defining a shorter type passing to the macro, to shorten the 
new line.

> 
>               Linus

--
Xiaomeng Tong
