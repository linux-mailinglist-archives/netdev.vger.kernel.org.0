Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37B4458DD
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 11:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbfFNJh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 05:37:29 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42667 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbfFNJh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 05:37:28 -0400
Received: by mail-wr1-f67.google.com with SMTP id x17so1766666wrl.9
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 02:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+StZX0LB0fcBDQu1XtXlYeqeeF/lIYyJnEA2DFKECas=;
        b=UeGA+VczsT1vysx93xe7+TMuGzks4Kbso3G28mmkt8qmLXOg3IHUBdsNaKYLbbwiqJ
         K12yTXWNBux8yaUmB5m5UE1kxJx73XfwKarfzAaTpOnbNqxZ+/4daZZ+EWSfI6j0pE8w
         Q/zafBJw9bTaYVxPl9+nvDAzzkbr/ekD8kI7sxP2/Ts9HSTWMyBat3DnaNebQ25KMoXA
         qSp7K1iruOFRr9wZEm6PIQpG2HZIWi75bBJ3ugTDXtuU4TpF/OJ2HUpAmzfVxnS/93a/
         YJO5PRApYdETbjnwDvfom0LuYbWG6vzsE/RZAP6c605WRRfXcCsuUSkMRYAZOt7lT5YJ
         KHjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+StZX0LB0fcBDQu1XtXlYeqeeF/lIYyJnEA2DFKECas=;
        b=taJ3tm9E9ECdlJCEUElRTKIrHWSHszyOdF7X+zf0xzIkg9vZAklg6BEzZnDaopJG8h
         cKP2MMJO2Dj+0rCo+9GS0WVj7P/FpH5M8I6TVaRrq3+jyY+H3uUxsA38jbLNs9pAL0Xe
         HEfmraOwtvCebKmY8XHO1stOS16HJMcsc0RuS1v8NaMdpX44iWIl2Yive+rF+8881rYo
         CZSIV0ziptcz/khN9wZfIQXUqQ4F552KSraJvAw1gJNl8lzr4f1g5x9GHN7m45/ciyfy
         oyutjK3AJRYm0F09pteqY6qXBE6Rq+kzYNfGTMTqKSz7yJ2x/0BXbYUtWypOG2aynQbq
         WMuw==
X-Gm-Message-State: APjAAAX+3HuwvdNsFDiqjzrZ+nCMH7a5PPiTMe+9XUTlkV3xskhz8zNw
        yIwrOguGirN76ITXoAeDf7QwZtnWFD0=
X-Google-Smtp-Source: APXvYqy6yhlLR4iyulL+0QhRZBC7q92BKi1iIzdvVjhRRDKy244Ma0MRwiprJpts1O8McOKf6EIJFA==
X-Received: by 2002:adf:dc43:: with SMTP id m3mr364720wrj.279.1560505046524;
        Fri, 14 Jun 2019 02:37:26 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:594c:db6f:d0ef:7061? ([2a01:e35:8b63:dc30:594c:db6f:d0ef:7061])
        by smtp.gmail.com with ESMTPSA id 11sm2969922wmd.23.2019.06.14.02.37.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 02:37:25 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [RFC PATCH net-next 1/1] tc-testing: Restore original behaviour
 for namespaces in tdc
To:     Lucas Bates <lucasb@mojatatu.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, jhs@mojatatu.com, kernel@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, mleitner@redhat.com,
        vladbu@mellanox.com, dcaratti@redhat.com
References: <1559768882-12628-1-git-send-email-lucasb@mojatatu.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <30354b87-e692-f1f0-fed7-22c587f9029f@6wind.com>
Date:   Fri, 14 Jun 2019 11:37:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <1559768882-12628-1-git-send-email-lucasb@mojatatu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 05/06/2019 à 23:08, Lucas Bates a écrit :
> Apologies for the delay in getting this out. I've been busy
> with other things and this change was a little trickier than
> I expected.
> 
> This patch restores the original behaviour for tdc prior to the
> introduction of the plugin system, where the network namespace
> functionality was split from the main script.
> 
> It introduces the concept of required plugins for testcases,
> and will automatically load any plugin that isn't already
> enabled when said plugin is required by even one testcase.
> 
> Additionally, the -n option for the nsPlugin is deprecated
> so the default action is to make use of the namespaces.
> Instead, we introduce -N to not use them, but still create
> the veth pair.
> 
> Comments welcome!
Thanks for the follow up. I successfully tested your patch, it fixes the netns case.

Note that there is still a bunch of test that fails or are skipped after your
patch, for example:
ok 431 e41d - Add 1M flower filters with 10 parallel tc instances # skipped -
Not executed because DEV2 is not defined


The message is not really explicit, you have to dig into the code to understand
that '-d <dev>' is needed.
Is it not possible to use a dummy interface by default?

From my point of view, if all tests are not successful by default, it scares
users and prevent them to use those tests suite to validate their patches.


Regards,
Nicolas
