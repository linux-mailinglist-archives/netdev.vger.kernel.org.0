Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F165E89EA7
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 14:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfHLMo2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 08:44:28 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37611 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfHLMo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 08:44:28 -0400
Received: by mail-ot1-f66.google.com with SMTP id f17so22736575otq.4
        for <netdev@vger.kernel.org>; Mon, 12 Aug 2019 05:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ijiCz8JRyrYS1L1kjWrM7CUmUr5/E+RHKHVXUs+g29M=;
        b=uhMW2JrWfe3RSn/i/WwVMXB4ATntdsWFd4YOAifaZMjDJE9USmWEF2inox1bOyRiTx
         rVlcbC/reN0M41UsIH+5eRwgiQUVJdkXiXb+3apOKKIXdN7C0fEyviJ2reBXYljviN6y
         47S9j1uClX65Hw7/gzUtAzEa9CTrfFkybqjXmtxKu6OhV8xL4HjbieMbf73TWlAddLqS
         CqwI5MsT9rf2+JDYzofj48jLw0yIDvZFzJ6PH6XFo09NFwbb5SL0GF184dxHJ+BuVaAF
         L+KyYX+byXr4Gd2tGI6T0Aa78lo3zJ4Ef7P7CtzGgWt/0PpzxDudno25eWgdRfH6AGET
         pKgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ijiCz8JRyrYS1L1kjWrM7CUmUr5/E+RHKHVXUs+g29M=;
        b=KPoWoGSEa5TfiVXEuRY4SZY68s5kzJMSjKriwXCoI8QZl5EuhokMIjelu27erKpbj8
         TgENDet64IgZk8D76wBUd4StegSEEzqujbFk7A5jjt7+ZY1kIDdbW55LU1FQivQ9LVMu
         66KBLzzb2yRh0B6WWzHGIFCNRKdsjRwb9fEcPwumRYk+veiEJ+XZYSFz90iDV+NdCHEB
         bgB190NbvhCeXYLeKRjW/mYnzXIMnq/HXWEeodSotPmD5CPPqZ+qC68GU6nYLy+G3/It
         r3PnkUJYvC53z+W7UrMwug+7FU5Byr38RpnnNE/aG0wRqjdboNMZEqUSjaP0MnRgJnZd
         Gjdw==
X-Gm-Message-State: APjAAAWO+psoZM1aZ7k0XhFjIbpG3DOYaOayV/ACzmepHXG+U4RGjoDZ
        nbmvNMCyBTehc6SD9w2PpDc=
X-Google-Smtp-Source: APXvYqwzdYRBtua1nENpbcwWp1wqOdjdjDx836PEAp/VhauZgmiJJR1xj4sCJs0coLUbU+V8tbzVJQ==
X-Received: by 2002:a5e:881a:: with SMTP id l26mr33996834ioj.185.1565613867621;
        Mon, 12 Aug 2019 05:44:27 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:886:1872:8a8a:4ea0? ([2601:282:800:fd80:886:1872:8a8a:4ea0])
        by smtp.googlemail.com with ESMTPSA id f9sm12196474ioc.47.2019.08.12.05.44.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 05:44:26 -0700 (PDT)
Subject: Re: [PATCH net] nexthop: use nlmsg_parse_deprecated()
To:     Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>
References: <20190812113616.51725-1-edumazet@google.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6f8f2ba6-f1b4-1da1-69ef-8d757cb1bda8@gmail.com>
Date:   Mon, 12 Aug 2019 06:44:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190812113616.51725-1-edumazet@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/12/19 5:36 AM, Eric Dumazet wrote:
> David missed that commit 8cb081746c03 ("netlink: make validation
> more configurable for future strictness") has renamed nlmsg_parse()

Thanks for the report, Eric. It is quite likely I overlooked something
with that rename given the timing. However, the nexthop code being a new
feature is expected to use all of the strict parsing and checking. I can
take a look at this later today.
