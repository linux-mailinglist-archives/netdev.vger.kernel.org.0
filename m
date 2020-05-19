Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 420E01D9D82
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 19:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729432AbgESRHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 13:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729185AbgESRHw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 13:07:52 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9E8C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 10:07:51 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id y22so195954qki.3
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 10:07:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VhF6t8nwVtw96tu4Qljdbs4ZYVn+qtTTRU/PiWIuW3o=;
        b=d4i9P6W+Oa+TB9ROmzQsRW3g2FeCUP4bbwMu1C2OKmywWXsY9bOt9wCciXekUSCmeY
         IZaH1DrgFlbrJQ0uFp6sGX1E67im34BUj8SSx2nsSnve0ZnJ951nnGFZ0p2S1j8XbFOM
         Dzh6QWhNXsIExD32JxCRCMnPiHTGqitg4jXj1yUUg1DhiJyhBXvW9BCY4SAzu87/Kgx1
         YhjOJLD59NR67fdiQd6zO3XpWjTzttEGKGCMvZKo+98ZS2mP17vXlrT7xuSMzwgs7PyQ
         M8YP6V1ZPCxNikYbh4DDabzBOWbhprPU1e+CLTKTFmmUxcZr9H4yD8JdZR/P8vk2WtLs
         SXsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VhF6t8nwVtw96tu4Qljdbs4ZYVn+qtTTRU/PiWIuW3o=;
        b=msWfZxjhedR2Vzbk0SV1k0v/cdJY05PbWD5l5v55k9r07raxhXjPhm/ba8bXtSNhlv
         kQPQc47HLNzXOUmli+ZF6yMVBHM1BmVXtExiyvO/67mOAIxSCzyeJqstxwoAAY4ED2bA
         BWkz46S/RazlyFhAv9Z1seZ4IWiiX7cHQjexFrPBrh+PU3rbavlyoJDvANiHYqqC+R0F
         flcM9ZZ2x1E6dm+pLEw++By1pYJFY/KbracsK5H9poihc1Q3KU2JldBe9XvyTQg5tj3I
         +4kfi0ePRLOILASpo9A++zUhD5QW4Kj18Mq6sI4YJHQID+mRnWfkyE6h/TCl2NyOg8SP
         +iEg==
X-Gm-Message-State: AOAM532pMIizAokX5Xe3eGAjc0yEq1nNKShwwlx//EQCHrVUsl3FnXVE
        hIz5rGeEcOGPw0dkETXwQQJgy8Ms
X-Google-Smtp-Source: ABdhPJzQHcfx0q9tYqQL7iVFqkzE/QocfqA5fvK5mud/4TluBsNorOK7edNh5tA/NhD1KRANd2tm4w==
X-Received: by 2002:a37:b744:: with SMTP id h65mr339457qkf.273.1589908071210;
        Tue, 19 May 2020 10:07:51 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id 66sm87116qkk.31.2020.05.19.10.07.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 May 2020 10:07:50 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] nexthop: support for fdb ecmp nexthops
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Petr Machata <petrm@mellanox.com>
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
 <1589854474-26854-3-git-send-email-roopa@cumulusnetworks.com>
 <4a103e6c-9b23-cbfc-b759-d2ff0c70668d@gmail.com>
 <CAJieiUjXO6h9HtwTn3fv7W=WovyUxzU2+EZ_Off6kxxRfgyUKQ@mail.gmail.com>
 <CAJieiUgHqYo1UZ2VKHK=hTTLZjkScYisdRJ0be0kjtj6c-DRYA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <530d85f9-7fd5-7e7b-7838-8ced98d27f3e@gmail.com>
Date:   Tue, 19 May 2020 11:07:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CAJieiUgHqYo1UZ2VKHK=hTTLZjkScYisdRJ0be0kjtj6c-DRYA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/19/20 11:02 AM, Roopa Prabhu wrote:
> What are the rules here.... does neighbor code only check for NDA_NH_ID
> because the strict start type is set to NDA_NH_ID ?
> 

Lack of checking of unused attributes leads to the kernel silently
ignoring userspace data. From top of memory that has a few problems:

1. does the kernel support feature A (lack of probing for a feature),

2. kernel not implementing what the user requested and not telling the user,

3. impacting the ability to start using feature A in that code at some
point in the future (it was ignored in the past and garbage was passed
in, now suddenly that garbage is acted on).
