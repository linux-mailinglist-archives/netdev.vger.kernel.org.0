Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBFB661EF6
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234287AbjAIHEv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:04:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbjAIHE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:04:29 -0500
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AD881209F;
        Sun,  8 Jan 2023 23:04:28 -0800 (PST)
Received: by mail-wr1-f42.google.com with SMTP id d17so7172691wrs.2;
        Sun, 08 Jan 2023 23:04:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wYsLuw/5810Zy5eTIZ7iJqDyeo47uMIQ6w06dFLUs+Q=;
        b=sAewqlyPfF/tYbLsIM2FVlgzIG7BjDCLgtQ9ugaEgH8k8gwvTWBRfaj201PWt7yPVN
         hwuwAtdkTF7yzoPn2QJKGw145ncqj3htgtDy8NZ9GKoknprlncA+wgLbqJP0uJ2OA0TM
         AWudzCprDqvdOPjR+fMsAXZgF1Oii4RlHuayRmXlsvtFs1JFjBPRTKP+xZppdNOuEjdV
         QNX4wlOn7L71+9maTMik1nvGyYi5IoUs1yyMn2yiiwOvMUuCBFRkHoPiQUs+QMUIS5rU
         ZreC0PyS8TKWfb5UqSXGWTX1DRv8aG1m7/aQbTVRoUWFzc0WZ3m8f2GwVK/VmpGt2Wet
         MJiA==
X-Gm-Message-State: AFqh2kpj5Noxj8G4JUyVZHARTpp/jngq9tZ/h5M8X4j33DQOCNRUmqls
        53uuDuWFJVC9PXMBOmOszmw=
X-Google-Smtp-Source: AMrXdXsEyHJGnZLB96JH3rcVegZBjOFlVPnyGgXG2g9g13hBlhCt3SpTnjtaAmK/XwGxmzdpSoCmAQ==
X-Received: by 2002:a05:6000:38d:b0:2b5:90e:cfa5 with SMTP id u13-20020a056000038d00b002b5090ecfa5mr10255103wrf.29.1673247866783;
        Sun, 08 Jan 2023 23:04:26 -0800 (PST)
Received: from [192.168.1.49] (185-219-167-24-static.vivo.cz. [185.219.167.24])
        by smtp.gmail.com with ESMTPSA id f3-20020adfdb43000000b00236883f2f5csm7846356wrj.94.2023.01.08.23.04.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 23:04:26 -0800 (PST)
Message-ID: <07786498-2209-3af0-8d68-c34427049947@kernel.org>
Date:   Mon, 9 Jan 2023 08:04:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next] Remove DECnet support from kernel
Content-Language: en-US
To:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
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
From:   Jiri Slaby <jirislaby@kernel.org>
In-Reply-To: <20220818004357.375695-1-stephen@networkplumber.org>
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

On 18. 08. 22, 2:43, Stephen Hemminger wrote:
> DECnet is an obsolete network protocol that receives more attention
> from kernel janitors than users. It belongs in computer protocol
> history museum not in Linux kernel.
> 
> It has been "Orphaned" in kernel since 2010. The iproute2 support
> for DECnet was dropped in 5.0 release. The documentation link on
> Sourceforge says it is abandoned there as well.
> 
> Leave the UAPI alone to keep userspace programs compiling.
> This means that there is still an empty neighbour table
> for AF_DECNET.
> 
> The table of /proc/sys/net entries was updated to match
> current directories and reformatted to be alphabetical.
> 
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> Acked-by: David Ahern <dsahern@kernel.org>

...
>   include/uapi/linux/dn.h                       |  149 -
>   include/uapi/linux/netfilter_decnet.h         |   72 -

Hi,

this breaks userspace. Some projects include linux/dn.h:

   https://codesearch.debian.net/search?q=include.*linux%2Fdn.h&literal=0


I found Trinity fails to build:
  net/proto-decnet.c:5:10: fatal error: linux/dn.h: No such file or 
directory
      5 | #include <linux/dn.h>



Should we provide the above as empty files?

thanks,
-- 
js
suse labs

