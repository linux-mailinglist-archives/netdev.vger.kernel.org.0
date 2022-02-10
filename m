Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E347B4B1311
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 17:39:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244412AbiBJQjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 11:39:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbiBJQjm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 11:39:42 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652621A8;
        Thu, 10 Feb 2022 08:39:43 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id 10so2303324plj.1;
        Thu, 10 Feb 2022 08:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=VyCvMQvGVY3kjERzylhRvh9eJlWVE5dyq2500svQ1kU=;
        b=d8Bk8D7R2QV4lPQwQRa9qVRlrjTslInRci86Cq8Y5GNky2l5t8OEne2EZxM3ML5p4X
         jxIVXKW0BwRaHOGDPBlYJW2FRum2UTwFz/mbe8+Jaqa4RJzfAUebfcZ/euV+kusRR6Lu
         ln/PrH81nG0ViGbdrf/zH9HQe2HGTbjWiFSroPuw8EJSBhYrVJt1+6+ILtVyh0si/Lyk
         TBZksXwTtifJXsFcQAYna71yZw0F/hhos7sPHzQPv5dk7DRC0v53Xt1mir/UrDav0V/x
         5bM678lUoBhpfTHYCnzOPbRju0OZ7+b4jdKuHBRrStoDzImW+SHDF1oxWzKKZhGyhIyB
         JCUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VyCvMQvGVY3kjERzylhRvh9eJlWVE5dyq2500svQ1kU=;
        b=4BzjDFWnGRIdixiJT8QxHf9YlP78JrT6AXMDpgycu5ooo1+lQe/ZUAwIDC049bfS1q
         p7lK3IZtGXvXuNliR2N8hklQSRICNNfKvYf6lHsnPx+6NCpgtBOzTCZiQAkLLQRN07QD
         pEAYDPq14C9XR8h5C7Vkb+ecLt9XRp6bACAvv7/A68CvzCg1I3O355FfW0iWFNz4Mp/d
         gWMqB8bktcKnqov/N+OE3H9XMeI64YAeHqCXc/p/tsy91jYuiidSyg+sG+lGJe6eIbh7
         RvM6mkUAO9UZYhDGRybe/G+rhuvyTrqO1j/yMaVR7a5GMDj25df8h6zB6YS+3kSRfzYb
         yadQ==
X-Gm-Message-State: AOAM530KOihjTuPPCeDOD8ydAfKAaaLdUSJv+Yy05/39lqz0GY4jeBKM
        5qxexFtbEqb6SJbGBg+ewCg=
X-Google-Smtp-Source: ABdhPJzhSEdlxQmJY5qsBi6VTBQgg4dInmdj2X7NVorqBfzv4Q6bf37GrGNxmKssnGJee04i9DPkgQ==
X-Received: by 2002:a17:90a:688e:: with SMTP id a14mr3696420pjd.63.1644511182802;
        Thu, 10 Feb 2022 08:39:42 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id d16sm17367918pfj.1.2022.02.10.08.39.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 08:39:42 -0800 (PST)
Message-ID: <9bb39c37-0fc9-f4a7-dd4b-897f0a8fae18@gmail.com>
Date:   Thu, 10 Feb 2022 08:39:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [syzbot] WARNING in mroute_clean_tables
Content-Language: en-US
To:     syzbot <syzbot+a7c030a05218db921de5@syzkaller.appspotmail.com>,
        davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
References: <000000000000ad4e9c05d7aa7064@google.com>
From:   Eric Dumazet <erdnetdev@gmail.com>
In-Reply-To: <000000000000ad4e9c05d7aa7064@google.com>
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


On 2/10/22 06:05, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=141c859a700000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
> dashboard link: https://syzkaller.appspot.com/bug?extid=a7c030a05218db921de5
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130486f8700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d9f758700000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a7c030a05218db921de5@syzkaller.appspotmail.com


#syz fix: ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() 
on failure path


