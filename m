Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3E92117B
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 02:53:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbfEQAxg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 20:53:36 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44985 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726901AbfEQAxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 20:53:36 -0400
Received: by mail-pl1-f194.google.com with SMTP id c5so2445791pll.11
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 17:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=ST4CWYDkh00CffN4lvMYzTylWYrogSWsm37LLMdcgu8=;
        b=XgtfirqoQEzKN22sgji1Ygr3CLjwej2ztadA1uum6yFeX7pQiZumFd8dJBszqya+c6
         erLTAyFLWN43SQxSX63EP5Bw3mF/Vs8Q6U/r5wlw0GD6QppiZPN0q2bU/w+JYqxc6ous
         n7iySIegfzqlCwNQH1nApoW/itBZaLI1AzOQn7274oczy9s9QDookLLcfj3PbOvBNPuw
         Le31kPbAuhH+iixaDtoLgCWLBKkjZGfUfgj08f8lx0B2wfCD4kh1OBZIR2h+Do2uZm58
         yxfOAuQuTcf57S9SWh/VFWrBeYxPVj1Wh9ugwQHG3jTIaZGydYxhR0QuElREIY/7R8gv
         Qyxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=ST4CWYDkh00CffN4lvMYzTylWYrogSWsm37LLMdcgu8=;
        b=MDp+5VJVA+AplIYUfAl4F+rx3bXfoZQuQPRBUd3TaQ9VH0C6us7AyrWSXANm1bToR4
         Ih8TxKgOG+gzLot1TbT7UiIHgohftzRfbzra/S4expq7VrDOKjyVlq4SjM6iXx3C+mbu
         dMf2OoWXvHHWziM8R2karF6f9Lmm2yfOvlEQZJ4KBW/BN3yX/dxRi2Djeumzul+V6OtT
         3Y0ZCrYiksDNOukTXIj3s/dMqXLvoQCpNs1f95ILmR5h07BliqVZzNXTeeH+sANKA1J4
         qgyw9ncya3VfKZec1TV+2Bey7gZvFsE43v16OoGyaOpqJfeASYF93x6ch2ymuffQ109S
         dang==
X-Gm-Message-State: APjAAAXqTcT5RXtP3JCVqpi/5BcSfQmC2PGVHOLAHzNiSm+AozmlTLK5
        T6JUX6dEQMulhEfyGOznE30=
X-Google-Smtp-Source: APXvYqws5ve2eqQ2W5/lchRAf3kmAHt57Ink8gKSi2Pm/JHmIHAewNeqjy8VUYwcIGsFt+MNMKy92g==
X-Received: by 2002:a17:902:e785:: with SMTP id cp5mr34841847plb.167.1558054415913;
        Thu, 16 May 2019 17:53:35 -0700 (PDT)
Received: from fcb2.mtv.corp.google.com ([2620:0:1000:1612:a82:fb4f:909:5b6a])
        by smtp.gmail.com with ESMTPSA id j22sm7990242pfi.139.2019.05.16.17.53.34
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 17:53:35 -0700 (PDT)
Subject: Re: [PATCH bpf] bpf: relax inode permission check for retrieving bpf
 program
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Chenbo Feng <fengc@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        Lorenzo Colitti <lorenzo@google.com>,
        =?UTF-8?Q?Maciej_=c5=bbenczykowski?= <maze@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
References: <20190515024257.36838-1-fengc@google.com>
 <CAADnVQJ6Ezugas2OE1UqMHJP_L-G0LEt1KFCYPE5xLFmF+BXLw@mail.gmail.com>
From:   Chenbo Feng <chenbofeng.kernel@gmail.com>
Message-ID: <a6f447ba-4d75-2b9b-380d-8c3a01a0a9d4@gmail.com>
Date:   Thu, 16 May 2019 17:53:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAADnVQJ6Ezugas2OE1UqMHJP_L-G0LEt1KFCYPE5xLFmF+BXLw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 5/16/19 11:35 AM, Alexei Starovoitov wrote:
> On Tue, May 14, 2019 at 7:43 PM Chenbo Feng <fengc@google.com> wrote:
>> For iptable module to load a bpf program from a pinned location, it
>> only retrieve a loaded program and cannot change the program content so
>> requiring a write permission for it might not be necessary.
>> Also when adding or removing an unrelated iptable rule, it might need to
>> flush and reload the xt_bpf related rules as well and triggers the inode
>> permission check. It might be better to remove the write premission
>> check for the inode so we won't need to grant write access to all the
>> processes that flush and restore iptables rules.
>>
>> Signed-off-by: Chenbo Feng <fengc@google.com>
> Applied. The fix makes sense to me.

Thanks for accepting it Alexei, could you also queue it up for the 
stable as well?


Chenbo Feng

