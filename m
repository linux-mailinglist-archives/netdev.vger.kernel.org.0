Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A8B3953B0
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 03:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhEaBd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 21:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbhEaBd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 May 2021 21:33:26 -0400
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B19AC061574
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 18:31:45 -0700 (PDT)
Received: by mail-ot1-x32e.google.com with SMTP id i23-20020a9d68d70000b02902dc19ed4c15so9693104oto.0
        for <netdev@vger.kernel.org>; Sun, 30 May 2021 18:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=A/Dn9ugc/xkidX4z9k+NtNePIBtXCwu2DLEwl+0IIls=;
        b=glLYgJzfXA5ySiTt89c2CJaKMlM52VeHdkDIEzz8/DADH0SBqRdj5qBQ5er+XNWsCR
         /aVNiL/QDhjCfnTz3VqJWx/Sjras89sFFypvkpbYAnfscsk1Zuuii+/s5DtATnuAleTb
         wqsOnFxJBnx9gp8K4Vrhz36XbQEUMu5FTyXGiRRzbXiW49r1SAa+k0PlRr1w3dHc07Ts
         56lIyM7nO0lMgluQ/veaD0pt4DzYtxkZ25yCTt2yqkJP+EVZYFWxmXo1QxKhC+7bi37W
         JNgt9ehwNThKeH2n7MEu7qyw+aOyRZtPxJaADxvCIBYHFPi+NspCITlfO8Oj6TVhkcXi
         WfhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=A/Dn9ugc/xkidX4z9k+NtNePIBtXCwu2DLEwl+0IIls=;
        b=M1W4m11CsTvPVPLum/HljNXV+istp5QzVdsStZWcSR16/LMf9Boiweq6aY2YzzmiNT
         +4dyhuR+0U2aovsat4cIZosf9xN7Vb+PVxunzwcLVPxdu1VJpGvYwpPo434Y45IvmfE5
         ra5S0S8kkBpK0zNW7iwbuWXe9p+0Rsfd6CQ5UaH4yukvtj2Ibd+3GczulklfnB8WMKQB
         vF09np6CLYZ51acbSAT150zPElYtfHkajlIYhavrszCra5UJv82DqFSOcl21dn4aNGbD
         +YRNsq21UVIMqYYKGS8YoVPwjIDkk0jjjW3xTLQcegVxgK+QzihrVzhoUj8Pt9PoqoRn
         UVVA==
X-Gm-Message-State: AOAM533wlOI71lO7yf0PFO8lmBvW68jSjniyVKqsXn25WN7EN28Wnw4F
        0tBfsxQCpU6xRN5TkwyFL5Q=
X-Google-Smtp-Source: ABdhPJx7LiuiqUAzXaIwQ4nb/Xht6YFtrvOyLVGfSTsif6DL6w8/D/TaTkKPPn86/reNf/vTNes9ug==
X-Received: by 2002:a9d:1791:: with SMTP id j17mr5970913otj.366.1622424704843;
        Sun, 30 May 2021 18:31:44 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id 12sm479133ooy.0.2021.05.30.18.31.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 May 2021 18:31:44 -0700 (PDT)
Subject: Re: [PATCH net] udp: fix the len check in udp_lib_getsockopt
To:     Xin Long <lucien.xin@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>
References: <04cb0c7f6884224c99fbf656579250896af82d5b.1622142759.git.lucien.xin@gmail.com>
 <CADvbK_e0PkKBYAUyg6iYyUwUp+owpv1r9_cnS7pbkLSjwX+VWg@mail.gmail.com>
 <20210528153911.4f67a691@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CADvbK_dvj2ywH5nQGcsjAWOKb5hdLfoVnjKNmLsstk3R1j7MyA@mail.gmail.com>
 <54cb4e46-28f9-b6db-85ec-f67df1e6bacf@gmail.com>
 <CADvbK_endt5VLzyDMumn6ks8oF5WkQ0hbx6XguyRbJZzOf4K5A@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cf628b45-c527-3390-4738-de7732268e44@gmail.com>
Date:   Sun, 30 May 2021 19:31:43 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <CADvbK_endt5VLzyDMumn6ks8oF5WkQ0hbx6XguyRbJZzOf4K5A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/29/21 10:47 AM, Xin Long wrote:
> On Fri, May 28, 2021 at 9:57 PM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 5/28/21 7:47 PM, Xin Long wrote:
>>> The partial byte(or even 0) of the value returned due to passing a wrong
>>> optlen should be considered as an error. "On error, -1 is returned, and
>>> errno is set appropriately.". Success returned in that case only confuses
>>> the user.
>>
>> It is feasible that some app could use bool or u8 for options that have
>> 0 or 1 values and that code has so far worked. This change would break that.
> Got it.
> Not sure if it's possible or necessary to also return -EINVAL if optlen == 0
> 

do_tcp_getsockopt for example does not fail on optlen 0; no reason to
make this one fail.
