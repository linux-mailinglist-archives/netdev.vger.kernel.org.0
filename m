Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C176C5ACB8
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 19:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbfF2RpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 13:45:10 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:39883 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726862AbfF2RpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 13:45:09 -0400
Received: by mail-qt1-f196.google.com with SMTP id i34so10049249qta.6
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 10:45:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ct5GDxJvysFB/eqxmGZVLszEsq1nAd0Nszja5UilWv0=;
        b=YD+Wtlw4hPTLB5gNIWbdmsUC6LGU78hXo55NQz9Ra9f8OLwy7ny1ZLK6VZSPMnqlVT
         HUWOXQT3CwrKeg5P4l5eCzypckoBKfL2tqGD+jfPgfVbsQ4NAKtb+kSvbzpaMRKhezOT
         d5HMQuleUtXZ7/VkPr1239u/ja9yVMQj6hSwfciGwpI3RcwYktlqHjIhEpGckPehfHSb
         mOeT5Yohjbx1Fgq53mue8dzSNScESnpzsryPsDylNIBmEOefBeCZdO43o4NOEoOZ/3ar
         +9oFiVI4VYUiCtiphkS20ebxnsg8SFVAjKXbbBqZyOkSE66ajfWbgsU5IdZmKjMsHIuV
         Rsxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ct5GDxJvysFB/eqxmGZVLszEsq1nAd0Nszja5UilWv0=;
        b=AAdYo9XjcwlzzMwFjzg+j+ZikAS6nZ/f6RZm400fJFf+WbSZArOj0mV7pVZ2EXy7km
         djtHYn5ca94EmjyQSdfC5I/H1w+fYXUO+8t3zJsRhnzgqtqnqviyF3XbHtWwN9IWZcd4
         zLnMsK3Hd4ap2gn7Um0TQfZcoNnjxR/N4WpanCG4xB9fwy2dB2jaZgPca7dLGM6ZUfpa
         SefUwquKLr0uRgIdggDcAfkoHZxpKE3UL1RpUdjpgfJL1e00lQfAcXNKO8B3V9L0/9Ka
         NKqI36jqi9ZyGcZxSadGGWjJfXY0B73f1Yb3dHDtdfJLZXYkzwzXvv5lT/v8FsU7q0Sj
         wWkA==
X-Gm-Message-State: APjAAAVqj2irlUY/nutWTkzu7iuVVbpi5xtlhE3jUVqcSK2MVGq3mk6u
        eLIEbeUBwNzRg/nhe1be+Vc7hA==
X-Google-Smtp-Source: APXvYqyGxsDmiAORs6Y4dYqrBPUudMI62cvik/9a6TmhAawfC1aGSryLctUB9IfcEgkvRskPQj4D2A==
X-Received: by 2002:ac8:2268:: with SMTP id p37mr13297905qtp.187.1561830308945;
        Sat, 29 Jun 2019 10:45:08 -0700 (PDT)
Received: from [192.168.0.248] (CPE00304434642a-CM688f2e1962f0.sdns.net.rogers.com. [174.112.239.66])
        by smtp.googlemail.com with ESMTPSA id c127sm2645901qkg.121.2019.06.29.10.45.07
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 10:45:08 -0700 (PDT)
Subject: Re: [PATCH net-next 0/2] Fix batched event generation for mirred
 action
To:     Roman Mashak <mrv@mojatatu.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
References: <1561746618-29349-1-git-send-email-mrv@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <cacae8de-7a2f-a10b-1b9b-227b3a5c30c4@mojatatu.com>
Date:   Sat, 29 Jun 2019 13:45:06 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <1561746618-29349-1-git-send-email-mrv@mojatatu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-06-28 2:30 p.m., Roman Mashak wrote:
> When adding or deleting a batch of entries, the kernel sends upto
> TCA_ACT_MAX_PRIO entries in an event to user space. However it does not
> consider that the action sizes may vary and require different skb sizes.
> 
> For example :
> 
> % cat tc-batch.sh
> TC="sudo /mnt/iproute2.git/tc/tc"
> 
> $TC actions flush action mirred
> for i in `seq 1 $1`;
> do
>     cmd="action mirred egress redirect dev lo index $i "
>     args=$args$cmd
> done
> $TC actions add $args
> %
> % ./tc-batch.sh 32
> Error: Failed to fill netlink attributes while adding TC action.
> We have an error talking to the kernel
> %
> 
> patch 1 adds callback in tc_action_ops of mirred action, which calculates
> the action size, and passes size to tcf_add_notify()/tcf_del_notify().
> 
> patch 2 updates the TDC test suite with relevant test cases.
> 

Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
