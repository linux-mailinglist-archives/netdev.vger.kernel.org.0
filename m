Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29AAB2D38DD
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 03:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgLICfh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 21:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726413AbgLICfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 21:35:37 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2DCC0613CF
        for <netdev@vger.kernel.org>; Tue,  8 Dec 2020 18:34:51 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id o11so811112ote.4
        for <netdev@vger.kernel.org>; Tue, 08 Dec 2020 18:34:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tfaWPa1rTQiEvMjwMbEEG9jgyOHFzZNCos/49AS2Mk4=;
        b=hWxYDone3tV/FFhH2nBX/Ina1Ontgp+znoilfZDySEKl4789FWs3JRCDKmgABhv9ty
         xVzW5OwNuG53Kap0TCMrBrFqCGTUApEoCkfJ6aRyc6a4yv5HxdGeY9f11V0+3+SnbjmP
         M0QXjgxnyod7vVhXp0d5rpOeAqVQY66j2VHMeW8/C01HQqp/ABsqRd/Cm45djPLrTn0M
         YlClAQYqLW1tCI1lSSMDtWkZiEmuJA1Gb2Ef2sawCyHQLwcMdovZwvk/2SpNq2qCAC6s
         LFwra9G+4QZcBb58AiFNVnT9eTDmAJU++enufWzVVRwg3gKMnTkrOlbXmVA6iZbCjLKf
         EmxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tfaWPa1rTQiEvMjwMbEEG9jgyOHFzZNCos/49AS2Mk4=;
        b=D/aLqtFELZy/qmri4LssVBf3EB9SBwy/r8DgFOxoQ6/yW1rCa/yVW1vYxb8Kw1X66A
         yQ19muzECYmXzfMRTQwd5T2b5H8FgS+DDH45sSjGPfP+I3Aq3XS+PMPTiH9fgAzMt7hK
         SP+Uzp17WX/o/JOxYJCVoL0nvttXSWE/2VgK0Vt8LLKyAEteH/quevQ831+CpySxrFe+
         l9Ed/qThKD76hwohS6wEaLPe1q3TxsBAThCPe4s5QngqCaAz4x++DkQe7w8bV+7MwQwf
         oWS7HkvJZMMA1SSYB2vqGcSQs04NPggidyzYO/5GneD/e26hYLM79EyUoCwN5P35GwWL
         cqhg==
X-Gm-Message-State: AOAM532tcf/E+kHhJKNQbtGacui8FTPPM0VJhFKXB51GzhUGLaMTlCC+
        sTXiLP1ff6tSjyFgu+kXwps=
X-Google-Smtp-Source: ABdhPJxXMWCi6t995SdCb08ihSSdNrmwpJsEDabO8dLd74d6XwIA7a1kRS/pZfcTJNd4LbuWSdlCUA==
X-Received: by 2002:a9d:76d7:: with SMTP id p23mr77960otl.180.1607481290837;
        Tue, 08 Dec 2020 18:34:50 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id m18sm40043ooa.24.2020.12.08.18.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Dec 2020 18:34:50 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2 0/7] Move rate and size parsing and
 output to lib
To:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org
Cc:     Po.Liu@nxp.com, toke@toke.dk, dave.taht@gmail.com,
        edumazet@google.com, tahiliani@nitk.edu.in, leon@kernel.org
References: <cover.1607201857.git.me@pmachata.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3b2d1c50-5673-0c3f-b3f9-2ccff8ae6c3c@gmail.com>
Date:   Tue, 8 Dec 2020 19:34:47 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <cover.1607201857.git.me@pmachata.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/5/20 2:13 PM, Petr Machata wrote:
> The DCB tool will have commands that deal with buffer sizes and traffic
> rates. TC is another tool that has a number of such commands, and functions
> to support them: get_size(), get_rate/64(), s/print_size() and
> s/print_rate(). In this patchset, these functions are moved from TC to lib/
> for possible reuse and modernized.
> 
> s/print_rate() has a hidden parameter of a global variable use_iec, which
> made the conversion non-trivial. The parameter was made explicit,
> print_rate() converted to a mostly json_print-like function, and
> sprint_rate() retired in favor of the new print_rate. Patches #1 and #2
> deal with this.
> 
> The intention was to treat s/print_size() similarly, but unfortunately two
> use cases of sprint_size() cannot be converted to a json_print-like
> print_size(), and the function sprint_size() had to remain as a discouraged
> backdoor to print_size(). This is done in patch #3.
> 
> Patch #4 then improves the code of sprint_size() a little bit.
> 
> Patch #5 fixes a buglet in formatting small rates in IEC mode.
> 
> Patches #6 and #7 handle a routine movement of, respectively,
> get_rate/64() and get_size() from tc to lib.
> 
> This patchset does not actually add any new uses of these functions. A
> follow-up patchset will add subtools for management of DCB buffer and DCB
> maxrate objects that will make use of them.
> 
> v2:
> - Patch #2:
>     - Adapt q_mqprio.c patch, the file changed since v1.
> - Patch #4:
>     - This patch is new. It addresses a request from Stephen Hemminger to
>       clean up the sprint_size() function.
> 
> 

applied to iproute2-next. Thanks, Petr


