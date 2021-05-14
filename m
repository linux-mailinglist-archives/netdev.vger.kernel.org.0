Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 949BB380B2D
	for <lists+netdev@lfdr.de>; Fri, 14 May 2021 16:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234216AbhENOLZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 10:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232302AbhENOLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 May 2021 10:11:24 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C66C061574;
        Fri, 14 May 2021 07:10:12 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id n32-20020a9d1ea30000b02902a53d6ad4bdso26544208otn.3;
        Fri, 14 May 2021 07:10:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IYkHGxl+vXpHG5+jn/GdOJhUfxjNFIaEZMKys7siCUM=;
        b=G+/CaNr62gesmlOkjUKxZszrYb5aX7ttcgQmqbDMWqj8lIKin0VQE5TB9rKnzmJ6Yj
         /O6bi1FaTrYa/9HhoydS12Sxgmlc/MG1EChHv1fx6mnhlBtsINzQpW5ZDzAitYW6GMaO
         xRdHhAJa/q1nx6AXokPBj8TNU22PdIaZ9hA/efZZA4Jtkbq/EM/qyuR1VqWFZlwT6r4q
         XwxsSgkho+uD6ISqnKdXsSSR8MG/LYwUYdMrsQ9SpuB/WHV/TZeBICcGBI/MGPtmSKnc
         Q3E3+50VlexPhKCUoZp9UI25ohIGQShsJtj20IZf2UhWud2GC721Qe66j8tSDYS5P+4L
         nMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IYkHGxl+vXpHG5+jn/GdOJhUfxjNFIaEZMKys7siCUM=;
        b=A2JKBUiMCqzslypUFd7kOCFquw0YqpTBetGXL0LgSYzAfkH6b072m2DzjVzUJUr+W3
         Yp5ATrjyWXX5jjnsyYSEjAjtOFTleZec/7pSN51PoKKuRinIjzwDIHytkJePcsXkWVxo
         7T+tJwVC09UQ9Yo0DV5+YQFe/+qM6EmSnwjCeEmmmDKXmreCqU9ei15IXeLJtjsDXOuX
         FcocWTTmeP1PdVCyK/Rnwz20sUG1cyjPBMbfF05MWTcwFj9P0kbQv/TZw/8CMmiI2k4Q
         qxT6q1wuOLvbxpTMxsJBzpKKUtKxJCZ185DsA1kGSDjE6oN+1/nlKO8Nyg08JKJqZe+Y
         xbSA==
X-Gm-Message-State: AOAM531tNXETmw3b8CmOCNvYTNQLJyu1TRbYiX02seM1CN+syGN3Dk7O
        WCh3c3KQ++SVjjSo0n1c2hc=
X-Google-Smtp-Source: ABdhPJzbHDACCTEeXmNSXYWCgTqL1ui7BKhaIj2qt2rxnHA1wPVSst/qWx3Y2f2/mAuF3Qkn08c7iQ==
X-Received: by 2002:a9d:f66:: with SMTP id 93mr39917381ott.229.1621001411846;
        Fri, 14 May 2021 07:10:11 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.22])
        by smtp.googlemail.com with ESMTPSA id f2sm1194979otp.77.2021.05.14.07.10.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 May 2021 07:10:11 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3] lib/fs: fix issue when
 {name,open}_to_handle_at() is not implemented
To:     Petr Vorel <petr.vorel@gmail.com>,
        Heiko Thiery <heiko.thiery@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stephen@networkplumber.org, Dmitry Yakunin <zeil@yandex-team.ru>
References: <20210508064925.8045-1-heiko.thiery@gmail.com>
 <6ba0adf4-5177-c50a-e921-bee898e3fdb9@gmail.com>
 <CAEyMn7a4Z3U-fUvFLcWmPW3hf-x6LfcTi8BZrcDfhhFF0_9=ow@mail.gmail.com>
 <YJ5rJbdEc2OWemu+@pevik>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <82c9159f-0644-40af-fb4c-cc8507456719@gmail.com>
Date:   Fri, 14 May 2021 08:10:09 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YJ5rJbdEc2OWemu+@pevik>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/21 6:20 AM, Petr Vorel wrote:
> 
>>> This causes compile failures if anyone is reusing a tree. It would be
>>> good to require config.mk to be updated if configure is newer.
>> Do you mean the config.mk should have a dependency to configure in the
>> Makefile? Wouldn't that be better as a separate patch?
> I guess it should be a separate patch. I'm surprised it wasn't needed before.
> 


yes, it should be a separate patch, but it needs to precede this one.

This worked for me last weekend; I'll send it when I get a chance.

diff --git a/Makefile b/Makefile
index 19bd163e2e04..5bc11477ab7a 100644
--- a/Makefile
+++ b/Makefile
@@ -60,7 +60,7 @@ SUBDIRS=lib ip tc bridge misc netem genl tipc devlink
rdma dcb man vdpa
 LIBNETLINK=../lib/libutil.a ../lib/libnetlink.a
 LDLIBS += $(LIBNETLINK)

-all: config.mk
+all: config
        @set -e; \
        for i in $(SUBDIRS); \
        do echo; echo $$i; $(MAKE) -C $$i; done
@@ -80,8 +80,10 @@ all: config.mk
        @echo "Make Arguments:"
        @echo " V=[0|1]             - set build verbosity level"

-config.mk:
-       sh configure $(KERNEL_INCLUDE)
+config:
+       @if [ ! -f config.mk -o configure -nt config.mk ]; then \
+               sh configure $(KERNEL_INCLUDE); \
+       fi

 install: all
        install -m 0755 -d $(DESTDIR)$(SBINDIR)

