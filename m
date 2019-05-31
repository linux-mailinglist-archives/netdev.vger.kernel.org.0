Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9454316AD
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 23:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbfEaViX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 17:38:23 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:44151 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfEaViX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 17:38:23 -0400
Received: by mail-pl1-f193.google.com with SMTP id c5so4489751pll.11
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 14:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=smp5PzOGOtu/oCI60JQsrKYHeSDGlyqMnnQMBX0JiIw=;
        b=bSHqG/s6bqkQBTuFFLSVJ8hlcdD8hPyJZybweoS8ARyul3zwAAn7nAUG5bKGwpkAXv
         kpR7OCiYWf1wvz+dVmsIq2sDr2V+ZC7+dHKe6EMHEAgQf0OUs49NXdMuhhR3N/5bkiea
         MBn3RoGMqi3x0S4YSyNmcDGr+ELkcZH8JVuqaWVnmI98i95jD3PZTmlXUMYj2vR7qSSw
         zLYM+p/tYQcBR+P4HIp/QrmirpB41zLY6+n6T//lyLWmVnbRQ9qUScCMnBPnvZs2v7E4
         GP+DvNV42AkWhfk1Q+kn/Vs2y8DmdIkIZFzb8FM/v3rto19vDS6QqHEry43vGSXssdT7
         rf8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=smp5PzOGOtu/oCI60JQsrKYHeSDGlyqMnnQMBX0JiIw=;
        b=CR/vpFrmtHpfrtE6/Cokw8e6/rf0GUZ0lRGjtbeniYaxYIIkXmF/NC+OpFeCa5C4WW
         rAFKmcBfYh9HGCiQsPcs4sOohGkwv60swOFUvv/Uxb6Lshvsf1gqnyEXK/jJioQaB2w9
         +zteaX0G6mhKwpfxFiWvGn330mqIDYVnan/EWvkepoT4Uf0XtZPNBPfYbgegTyNWnYgB
         M6W9FABgmGpBZpoUZpMsKrw5OpjoFhlEfnxtwOjiKGTwCD/iXuqOaIab+610+uqgLgdu
         tAgPjGULb6T6+dpYtOo2ggs3fSIrkKkanRZ0AXBrHFdI1fGdKPCSr8eYV5/+JakiCnKr
         Rj7w==
X-Gm-Message-State: APjAAAX07zds9FgmlGopf2DUz2lGljQZdYcFgavfKQXmuNy0pLce1flT
        Q/7Teby7tiw0Y94ling6spQ=
X-Google-Smtp-Source: APXvYqygn10SGZKQQxLqwBQlNq0AMNY0nI+3neGEBA7WeNvxErLTgcKrdou91WJvZRdvxUenH02WQw==
X-Received: by 2002:a17:902:b584:: with SMTP id a4mr12430259pls.333.1559338702785;
        Fri, 31 May 2019 14:38:22 -0700 (PDT)
Received: from [172.27.227.252] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id g8sm6249467pjp.17.2019.05.31.14.38.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 14:38:22 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Miller <davem@davemloft.net>, alexei.starovoitov@gmail.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, idosch@mellanox.com,
        saeedm@mellanox.com, kafai@fb.com, weiwan@google.com
References: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
 <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
 <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
 <20190531.142936.1364854584560958251.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
Date:   Fri, 31 May 2019 15:38:19 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190531.142936.1364854584560958251.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/31/19 3:29 PM, David Miller wrote:
> David, can you add some supplementary information to your cover letter
> et al.  which seems to be part of what Alexei is asking for and seems
> quite reasonable?
> 

It is not clear to me what more is wanted in the cover letter. His
complaints were on lack of tests. I sent those separately; they really
aren't tied to this specific set (most of them apply to the previous set
which provided the uapi and core implementation). This set is mostly
mechanical in adding wrappers to 2 fields and shoving existing code into
the else branch of 'if (fi->nh) { new code } else { existing code }'
