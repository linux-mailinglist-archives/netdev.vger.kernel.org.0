Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCF021C5E69
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 19:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729674AbgEERLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 13:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728804AbgEERLc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 13:11:32 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E007C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 10:11:32 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id g185so3066844qke.7
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 10:11:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=g6cu5u+Dbayo2X6ZeWsqz8k9fk6QcfIB0xhPFJz61wE=;
        b=XmjaRs/qfgFoSTWhrbLTDJzsOCWNbG3kZAAU2JBseDwnAICUitCW33lNtI2a36pzta
         /2liczMr/oPJGw2ySxnkKUsMMxLhxG8CElSJOjDihF79eeT/K3G/e4NeZbOw4cgdgSY+
         skdMOdmUk0SNNod3O0EqtZZzw0ng1987LVVXMccrzJrgE/kttxtmJB2uK9QXf+BYNQNb
         yarLnZaMdPhj35/pjzPy+nW8bh1SPxkvd7hdGQ8XHp0W0dDzLzOVDSv+jEItaXXOfawM
         QQv6gpZGziRag8vvCF1St8d9JISIbFlctdvEUIqu49aYLWJwF67Sn8Bpu1PonIVZcu5a
         Ke5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=g6cu5u+Dbayo2X6ZeWsqz8k9fk6QcfIB0xhPFJz61wE=;
        b=YWvi6rXJD5X6QRjhT6JEOLu9u4fO4uqkrGNHY/M8/+uSXamSlumPqqy2InAFCmqAL6
         fvBJbEDyUEuXl6c8CmCF3Hx8yPAesWejeZTk4B1Wmk53/HRhG4oUafeHP7TF73w9uYAw
         f3kR+0c8+RmJ3pTnrXJWN0qwxl0jg5pmDckfO3I2zUslOKENPoCwpLr01ryzjlO6dKpG
         v1j/xrQ1EU/o4orREpCwN6Tdpb27HxKWzCro+GPX1tG0WHwS4Tlmc6vWWVKscz3ibw/D
         S2o599ZRsHDdkag/5stfOIEJjJX0+mhVx8/C60HDr/nTTW2z8cFXhfm3bUmE7yEc646u
         +L0Q==
X-Gm-Message-State: AGi0Pua6u8hLCcfG/5HLRMrVQPKo3KDr0j0BB/b8KAjwCMsdEhF5HNmd
        ACcmFIj0aWz33XfnhOeuhuc=
X-Google-Smtp-Source: APiQypKa6BT1H7KR5f46QPyk9s3A8/Mbxni437EWhCWWRmyFIsaVjeT/Zn4nYd8eXcskIGf8R0gniw==
X-Received: by 2002:a05:620a:1338:: with SMTP id p24mr4488299qkj.162.1588698691826;
        Tue, 05 May 2020 10:11:31 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19:a884:3b89:d8b6? ([2601:282:803:7700:c19:a884:3b89:d8b6])
        by smtp.googlemail.com with ESMTPSA id o22sm2153333qtm.90.2020.05.05.10.11.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 10:11:30 -0700 (PDT)
Subject: Re: [PATCH iproute2-next RESEND] devlink: support kernel-side
 snapshot id allocation
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     stephen@networkplumber.org, jacob.e.keller@intel.com,
        jiri@resnulli.us, netdev@vger.kernel.org, kernel-team@fb.com
References: <76a99d9c-3574-1c8d-07cb-1f16e1bf9cca@gmail.com>
 <20200505170457.1997205-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8e7a26a4-4d38-d28a-ffd9-0c18a75403a3@gmail.com>
Date:   Tue, 5 May 2020 11:11:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505170457.1997205-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/20 11:04 AM, Jakub Kicinski wrote:
> Make ID argument optional and read the snapshot info
> that kernel sends us.
> 
> $ devlink region new netdevsim/netdevsim1/dummy
> netdevsim/netdevsim1/dummy: snapshot 0
> $ devlink -jp region new netdevsim/netdevsim1/dummy
> {
>     "regions": {
>         "netdevsim/netdevsim1/dummy": {
>             "snapshot": [ 1 ]
>         }
>     }
> }
> $ devlink region show netdevsim/netdevsim1/dummy
> netdevsim/netdevsim1/dummy: size 32768 snapshot [0 1]
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  devlink/devlink.c | 26 +++++++++++++++++++++++---
>  1 file changed, 23 insertions(+), 3 deletions(-)
> 

applied to iproute2-next. Thanks


