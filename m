Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06613662015
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:34:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234347AbjAIIeg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231176AbjAIIee (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:34:34 -0500
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAFC9DF5;
        Mon,  9 Jan 2023 00:34:32 -0800 (PST)
Received: by mail-wm1-f41.google.com with SMTP id m26-20020a05600c3b1a00b003d9811fcaafso5977697wms.5;
        Mon, 09 Jan 2023 00:34:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ai89XU1vTr8jmWYzTC3dz44+t98FTx9wn3aEaRiaIuk=;
        b=Hq3eULkwKSpgiEsZEcTMwXIhs74jCq2uXa/DPWeW8EbJdZpIV9PyYAYxkCPOa/dYuG
         t9bPptkdVaLfEPsQH453Kpi4kSy6CbhGg1Bm4l+2ScSnTQGAjWwmaoEBXOTOO8Tqy7Oc
         4WKriAby1jqh/E+Qxe47w7i9quBfVg2dJRsVsVWrYxQJMsszYbjWwHAPMzGf58MxLnGQ
         OhqwOww7doQH3ar1OzitZD9WoAZihQiNUBgR0xUJxWgmGcpnZRYpUKTsY6uLYe4iK+7h
         tAj72nI+oPv4R05ONlHFHYNXNLZ0OZUDVKEdVGK97dPsuGKrURfifEjS6ibgPiTj8bo9
         ww2Q==
X-Gm-Message-State: AFqh2koychD3BjTnfm0fM9rstqns47vwO/zTsqoI4LaEJhFL8nV2t6ZV
        a7EVU/sjNdsRnFGaZu42EZo=
X-Google-Smtp-Source: AMrXdXtjlHdY/ENv0HKrQhiUW86lNsmrAe9U9q9o1ZJzBphFcyOOuX1i4xq4T+O9/Z+J1SnbwUA6Kw==
X-Received: by 2002:a05:600c:1da3:b0:3d0:965f:63ed with SMTP id p35-20020a05600c1da300b003d0965f63edmr46049641wms.23.1673253271256;
        Mon, 09 Jan 2023 00:34:31 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id l27-20020a05600c2cdb00b003a84375d0d1sm16068925wmc.44.2023.01.09.00.34.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 00:34:30 -0800 (PST)
Message-ID: <ad6efc07-1706-a8e2-1478-45124838a043@kernel.org>
Date:   Mon, 9 Jan 2023 09:34:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] Remove DECnet support from kernel
Content-Language: en-US
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin <npiggin@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Akhmat Karakotov <hmukos@yandex-team.ru>,
        Antoine Tenart <atenart@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Juergen Gross <jgross@suse.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Nathan Fontenot <nathan.fontenot@amd.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Suma Hegde <suma.hegde@amd.com>, Chen Yu <yu.c.chen@intel.com>,
        William Breathitt Gray <vilhelm.gray@gmail.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Alexandre Ghiti <alexandre.ghiti@canonical.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Jeff Layton <jlayton@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Menglong Dong <imagedong@tencent.com>,
        Petr Machata <petrm@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Roopa Prabhu <roopa@nvidia.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Shakeel Butt <shakeelb@google.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Kees Cook <keescook@chromium.org>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Qing <wangqing@vivo.com>, Yu Zhe <yuzhe@nfschina.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:MIPS" <linux-mips@vger.kernel.org>,
        "open list:LINUX FOR POWERPC (32-BIT AND 64-BIT)" 
        <linuxppc-dev@lists.ozlabs.org>,
        "open list:NETFILTER" <netfilter-devel@vger.kernel.org>,
        "open list:NETFILTER" <coreteam@netfilter.org>
References: <20220818004357.375695-1-stephen@networkplumber.org>
 <07786498-2209-3af0-8d68-c34427049947@kernel.org>
 <po9s7-9snp-9so3-n6r5-qs217ss1633o@vanv.qr>
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <po9s7-9snp-9so3-n6r5-qs217ss1633o@vanv.qr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09. 01. 23, 9:14, Jan Engelhardt wrote:
> 
> On Monday 2023-01-09 08:04, Jiri Slaby wrote:
>> On 18. 08. 22, 2:43, Stephen Hemminger wrote:
>>> DECnet is an obsolete network protocol
>>
>> this breaks userspace. Some projects include linux/dn.h:
>>
>>   https://codesearch.debian.net/search?q=include.*linux%2Fdn.h&literal=0
>>
>> I found Trinity fails to build:
>> net/proto-decnet.c:5:10: fatal error: linux/dn.h: No such file or directory
>>      5 | #include <linux/dn.h>
>>
>> Should we provide the above as empty files?
> 
> Not a good idea. There may be configure tests / code that merely checks for
> dn.h existence without checking for specific contents/defines. If you provide
> empty files, this would fail to build:
> 
> #include "config.h"
> #ifdef HAVE_LINUX_DN_H
> #	include <linux/dn.h>
> #endif
> int main() {
> #ifdef HAVE_LINUX_DN_H
> 	socket(AF_DECNET, 0, DNPROTO_NSP); // or whatever
> #else
> 	...
> #endif
> }
> 
> So, with my distro hat on, outright removing header files feels like the
> slightly lesser of two evils. Given the task to port $arbitrary software
> between operating systems, absent header files is something more or less
> "regularly" encountered, so one could argue we are "trained" to deal with it.
> But missing individual defines is a much deeper dive into the APIs and
> software to patch it out.

Right, we used to keep providing also defines and structs in uapi 
headers of removed functionality. So that the above socket would 
compile, but fail during runtime.

I am not biased to any solution. In fact, I found out trinity was fixed 
already. So either path networking takes, it's fine by me. I'm not sure 
about the chromium users, though (and I don't care).

thanks,
-- 
js
suse labs

