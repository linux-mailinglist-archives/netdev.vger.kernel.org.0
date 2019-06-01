Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D37B2318D5
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 03:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbfFABES (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 21:04:18 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44123 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726881AbfFABES (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 21:04:18 -0400
Received: by mail-pf1-f195.google.com with SMTP id x3so1659977pff.11
        for <netdev@vger.kernel.org>; Fri, 31 May 2019 18:04:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iMZgytS8YBAXJ8xycmzx0E4nxddElEe/z/myyA8z6KQ=;
        b=JLzwBsignXgGtv19eadbb54TKq/jhOA3kbrSwdaD7pF3AChq6vRkN14tzOFQeBrBsP
         B0EwuGY4PYFAzqcx5b5RGiv/A6mP2E8JiT7HLRbomQhkzku/b535STUI0rn6UJ4M4sae
         DYmorfRglForIRbM2NrNM76QNpkwYv2sM3v1BpbXOkXI4lhpPro35A4Zw5A4GhcHCznM
         qolW68SOGbyWuWonIe1O8MAK8jBJNTQZdp+ev/103kVavameSx+iodYEz3fljdm8iOF2
         LlO+Jq67sm5ohqE5oYEj+amtkxbW5Ob7haMCDtlv+SJ75FdeoWnFAODHcocuyd/2UHBC
         f2+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iMZgytS8YBAXJ8xycmzx0E4nxddElEe/z/myyA8z6KQ=;
        b=T/3cqtN1EbctzJzUQ7fo3H15V06OzGu+rqJUUdAn2a0PJOA6bgIChl039XVCz0qcd+
         /Gim+t77A7NrRFTMYpdBuWEd0BwOV+hku9Fid+VBSYtOAvkXCbXsNhFyNsPl/Twdfg9P
         QRz66C0mngGzKTfxLDnrPSUIfUhwUULuktOyo5fA5NIMhM9nlWHB4DjSOFgJcB+WTwRX
         YJxHfQHle/kyU4qVh2mgCfL9Usto6X40zzyWp6XX5Cm98+LvgrGTBxwAhoxFALyd7ycs
         S6oFm4EaWWtPfBkzZVEpdinNqQJ7l26ucSEA4v59qudN2ifh1U9gFKyawf6dnmjZLCL2
         QfXQ==
X-Gm-Message-State: APjAAAUpgSHO0hnWMpnGtwazAejL+TfJ0gZmRCkx2RZI1aCNnSMefRCv
        YEbf7Z1YgCuLXovfOX+QEpw=
X-Google-Smtp-Source: APXvYqyvZJS+WmOxUcNKaO3Fvyydaa0/XXvdd1N242rj8cJ/4NRUwd4lKW6FnKrHLHDhrTTrGI/+kw==
X-Received: by 2002:a63:140c:: with SMTP id u12mr12605152pgl.378.1559351057480;
        Fri, 31 May 2019 18:04:17 -0700 (PDT)
Received: from [192.168.84.40] ([107.241.92.149])
        by smtp.gmail.com with ESMTPSA id v9sm6975320pfm.34.2019.05.31.18.04.15
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 31 May 2019 18:04:16 -0700 (PDT)
Subject: Re: [PATCH net-next 0/7] net: add struct nexthop to fib{6}_info
To:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        alexei.starovoitov@gmail.com
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, idosch@mellanox.com,
        saeedm@mellanox.com, kafai@fb.com, weiwan@google.com
References: <CAADnVQJT8UJntO=pSYGN-eokuWGP_6jEeLkFgm2rmVvxmGtUCg@mail.gmail.com>
 <65320e39-8ea2-29d8-b5f9-2de0c0c7e689@gmail.com>
 <CAADnVQ+KqC0XCgKSBcCHB8hgQroCq=JH7Pi5NN4B9hN3xtUvYw@mail.gmail.com>
 <20190531.142936.1364854584560958251.davem@davemloft.net>
 <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <68a9a65c-cd69-6cb8-6aab-4be470b039a8@gmail.com>
Date:   Fri, 31 May 2019 18:04:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <ace2225d-f0fe-03b3-12ee-b442265211dd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/31/19 2:38 PM, David Ahern wrote:
> On 5/31/19 3:29 PM, David Miller wrote:
>> David, can you add some supplementary information to your cover letter
>> et al.  which seems to be part of what Alexei is asking for and seems
>> quite reasonable?
>>
> 
> It is not clear to me what more is wanted in the cover letter. His
> complaints were on lack of tests. I sent those separately; they really
> aren't tied to this specific set (most of them apply to the previous set
> which provided the uapi and core implementation). This set is mostly
> mechanical in adding wrappers to 2 fields and shoving existing code into
> the else branch of 'if (fi->nh) { new code } else { existing code }'
> 

Hi David

I have a bunch (about 15 ) of syzbot reports, probably caused to your latest patch series.

Do we want to stabilize first, or do you expect this new patch series to fix
these issues ?
