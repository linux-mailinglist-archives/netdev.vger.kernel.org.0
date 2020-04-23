Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49E7B1B6405
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 20:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726516AbgDWSuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 14:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgDWSuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 14:50:12 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7314DC09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 11:50:11 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id v26so176693qto.0
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 11:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=q3yakHtkkhToc0mPyRJWA5JgfZ3ksmVduEJf6lecHJk=;
        b=dOSlQN7Dmis0FDKjr3TxpU0IeDYkrlYiXZ6yB68Pfrol0ayNMppJGf6TA61iE4DoFM
         wWVDeYYoxea09Ce8Du5dfIs/J1tTqMDArfHkrrOm6wlA6POQPwB2qYXXdZfc7bIbg/uz
         c6TYRBgfK3q5LkzBcq2qLAcBfYcTvSRW9Axv+PgqdnNOhHLCEapQYXOvB6lX6tsZv0jk
         S6wOa5MZ5MIMOD9sxVOjZSSbq5fWtt3r1+tYnuyqvhi8GBs8JOUrVoJJIRwJK9QVhVnD
         zqFopybn39D69fkMndZaYyI9RA1TSEXrnrNT1Co6RWOhIwhY/yVL+L4gXy0Y7Wgl1r0H
         HkLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=q3yakHtkkhToc0mPyRJWA5JgfZ3ksmVduEJf6lecHJk=;
        b=egWEERhNWG42qfvMsZOoSnZPJ6sEow1sm7OmeUTrzJfetW9lMxKtyrrKWRiN0P+4mj
         yAS7d2jzuczKpyf/0LsbRIhYKU0CIUMGS7JIl0QdOrMaRPoHfi9QbzAqI1JffBVJ7stC
         9A98sJNaPqEc0d1yStak1xmV4x7M6bXYLULcAnmfms3aGg856/gop6Mz9uJIl+Lzu493
         kFWHRIFMShc2FIfj75lHRJt8FuH+GAZKOrQ5aEB2fn/Ca2DI/bObytzV3kHR6rp5Qyyv
         YWRhILZVqmflefsvPO3kHXkkUmYjcSbmh/wn4yUNgsgEk+2Zg5s1QSYD8lcyRsomvnA+
         GCeQ==
X-Gm-Message-State: AGi0PuZeu+7y7PA9Tda3qH9NhaT93Vp3MNWRU1dowdj/J1J3HEqAigh1
        c3M164PHhyhIJSh+u9i7fHM=
X-Google-Smtp-Source: APiQypKIEoGvwZKZYj+avd5bMW+KXaJqZ5eXGIAELuoDWDb6gw0bc1Aq1W7riKc1RUDka+izOKSFEA==
X-Received: by 2002:ac8:6043:: with SMTP id k3mr4989321qtm.99.1587667810784;
        Thu, 23 Apr 2020 11:50:10 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2064:c3f6:4748:be84? ([2601:282:803:7700:2064:c3f6:4748:be84])
        by smtp.googlemail.com with ESMTPSA id k43sm2339159qtk.67.2020.04.23.11.50.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 11:50:09 -0700 (PDT)
Subject: Re: [PATCH bpf-next 13/16] bpftool: Add support for XDP egress
To:     Quentin Monnet <quentin@isovalent.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200420200055.49033-1-dsahern@kernel.org>
 <20200420200055.49033-14-dsahern@kernel.org>
 <d1a6ce5e-bb63-80cf-2e8f-24fbb0b36ec3@isovalent.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <47503e25-96d6-4b22-0c2b-4699f116a147@gmail.com>
Date:   Thu, 23 Apr 2020 12:50:07 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <d1a6ce5e-bb63-80cf-2e8f-24fbb0b36ec3@isovalent.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/20 4:43 AM, Quentin Monnet wrote:
> 
> Thanks for the bpftool update. Can you please also update the man pages
> (bpftool-prog, bpftool-net) and bash completion?
> 

will do
