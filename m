Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89994195DA4
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 19:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgC0S3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 14:29:16 -0400
Received: from mail-il1-f170.google.com ([209.85.166.170]:36471 "EHLO
        mail-il1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgC0S3Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 14:29:16 -0400
Received: by mail-il1-f170.google.com with SMTP id p13so9685424ilp.3
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 11:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u/TyTNhFgKd+///fKoTZf1rt0tovLZ/ipGBQvIbMSAk=;
        b=RT+ml4cPIgMWuGs1vLmtrqbdcovAiG2eogYRt+JfyNQvTTcBKULZGS6msZPVWFjEuJ
         ethsPb58YCfUUA0G7nLzIesUsz1lD3m1yiX8RMPbJVvjE90Y3bAC/Yr/oKaXKZG3UKGr
         AaBU88mI3Pe1wt+2BNHugyEh7/iXHEcHh4JW8aw3+zj4vE3n6/ReOufj4Emtl7bUylrB
         bf05cztS4JwKigSxpp8yGjnarlW9e4tbtCd9+odw9AewJKi2VjLpZp3SwpV+CuVG0Gny
         CeRCA2cmGu9tfJUlAGur9EEpZH8f+ZsTUxiJ5ZsP+1ejdhVx09/Zy7x9Thf6o7EBFGF9
         h64A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u/TyTNhFgKd+///fKoTZf1rt0tovLZ/ipGBQvIbMSAk=;
        b=X3LnTVwNKyriZ+NxOX19MkU3Gx6ROOjqePU5Rp5C97S8Ms+cXDvcrDBBQtEITrPZF5
         y4IqdIY1wTcRa9yVMXXu4A/uee3WzAaqGeJGhBO4jta/XvCnOAJN2gftydtNt01Wpa+J
         CJMw1qCygt/hzzePFtyG4ETNDhmoODfubm/xW7opOuUdinVQfnJlMCw/WgBbPaiGlQ59
         2gX2Wl4PtCWr2o1KDh7yWgtrztl6KxvwfVJ78ChtMl+PTDu2+Psyy/nINTiBpCNpjEHF
         gL/CnW6xrnHXap2ZbsYIB7Mde18pmgCzHUrwYK+o6MUtTQsPurTt101mqKnla3VfQlzb
         zkmQ==
X-Gm-Message-State: ANhLgQ0VQrylb7nhQfZf0UnW2AE5tTTbk2WNAFkkkvfHHuwd58y13YS7
        +Uypi97awxKtsjL0sl54LnUtHw==
X-Google-Smtp-Source: ADFU+vu7uRNOMnKwxXGYH+yplH7YdB1nZLfIsbDgKn/V2366Pozvc/8hHISiikGW92IOL16RsGwQXQ==
X-Received: by 2002:a92:5b51:: with SMTP id p78mr440652ilb.250.1585333755712;
        Fri, 27 Mar 2020 11:29:15 -0700 (PDT)
Received: from [10.0.0.125] (23-233-27-60.cpe.pppoe.ca. [23.233.27.60])
        by smtp.googlemail.com with ESMTPSA id f69sm2103137ilg.10.2020.03.27.11.29.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2020 11:29:15 -0700 (PDT)
Subject: Re: [PATCHv3 bpf-next 3/5] bpf: Don't refcount LISTEN sockets in
 sk_assign()
To:     Joe Stringer <joe@wand.net.nz>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Martin KaFai Lau <kafai@fb.com>
References: <20200327042556.11560-1-joe@wand.net.nz>
 <20200327042556.11560-4-joe@wand.net.nz>
 <daf11ebd-e578-10d4-6e4a-00bb396258cf@mojatatu.com>
 <CAOftzPjHhcFpadsBz6qGwx3hcmj2Xe2fs0HN-jBM+-Eh5OgZvg@mail.gmail.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <d5671d2e-9719-271d-fbe5-3494da3a03ee@mojatatu.com>
Date:   Fri, 27 Mar 2020 14:29:13 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CAOftzPjHhcFpadsBz6qGwx3hcmj2Xe2fs0HN-jBM+-Eh5OgZvg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-03-27 1:38 p.m., Joe Stringer wrote:
> On Fri, Mar 27, 2020 at 7:26 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>>

> 
> I think sock_pfree() steps in that direction, we would just need the
> corresponding refactoring for sk_assign bits. Sounds like a good idea.
> 
> This shouldn't functionally affect this series, I'm happy to either
> spin this into next revision of this series (if there's other
> feedback), or send a followup refactor for this, or defer this to your
> TC follow-up series that would consume the refactored functions.
> 

Does not affect this series - a followup would be great.

cheers,
jamal
