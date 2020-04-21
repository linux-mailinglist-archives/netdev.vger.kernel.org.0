Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8461B2711
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 15:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728909AbgDUNDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 09:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgDUNDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 09:03:37 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F3BCC061A10
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 06:03:37 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id p10so5334165ioh.7
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 06:03:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pyRfRhgyNf8wbP6cqiGlQ94JbUz+zQqhJSA1jkRBFvU=;
        b=Xxc45HminLlDwh20JNBlKpLqQU4w+4xoQGX+Ewi/FjGOCUosLRAAoY9Rf3JI4tO9BE
         9cA1IzVPMxEwmrYOd6YOhiMeKjIhZxqrriBQKe1IrX7C5NDqZ28ZreZ+LA8QZO+EufCo
         TI+/CJAb5AwRMAYAzQxNbj9QT3ZrCVRFOKU2/t6vGiaYr/F99+87F8UJhkEg0NRRsmGv
         Zx2VleXhZTwAMbJ6Ay8QVePVZFlcpEzWKCp9Fc5TCDz0l6r7ICDeNt/8bcIosVHlBifT
         43GsrCioxlGnC7VfTl813dsicmt2lD7ZlUSrbxjhfA5707PwBg+tE3kFr2+BBd1iUOHo
         mW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pyRfRhgyNf8wbP6cqiGlQ94JbUz+zQqhJSA1jkRBFvU=;
        b=YX0pK770lXgjkfCWVvqiCms4wYBErNM2qQ9qzTwk5SWvd8zpOwFKxGUBaYj4S1vPjO
         pmGg2Kw6wodPn09GTOFhZd5euhd9MF/xuBpT2EbWrchKJIIYj8KgMqp2SIXzxymv6R+f
         KvR4uZnC36d7zohBubR56JAJqZqI7WECzgFn4KHqZ4USZXTFf19i/G32biHH1n7FZdC3
         8r8uN7E24wBn+nv2I7czTPfwBgJC1DWqacfFssCKJbUtnx+9W7IzcrLKdSHJIBAvkZIc
         iR9OrFE7sg9sPmEeLICgOdcDfAoUC2c0aAqeoIBvjDS5DY5Mlikdp7Ovh0Rlarh3TwI2
         f58Q==
X-Gm-Message-State: AGi0PuakJEO3z3s2cb2yFEwtzj5wh31X1W40etSe2s/2P1PCNFqNMaRh
        N3glqM98oltm346ShIH+au8=
X-Google-Smtp-Source: APiQypL/m5aBpuoVfgsqi0VSBI4c7rmNIsOYV/h6w7C6SzJpLKlMxZh/Bo7m0+Ya4M0pdF6enfeEcg==
X-Received: by 2002:a05:6638:3f1:: with SMTP id s17mr20088663jaq.44.1587474216544;
        Tue, 21 Apr 2020 06:03:36 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:294e:2b15:7b00:d585? ([2601:282:803:7700:294e:2b15:7b00:d585])
        by smtp.googlemail.com with ESMTPSA id x1sm747624iol.5.2020.04.21.06.03.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 06:03:35 -0700 (PDT)
Subject: Re: [PATCH bpf-next 12/16] libbpf: Add egress XDP support
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200420200055.49033-1-dsahern@kernel.org>
 <20200420200055.49033-13-dsahern@kernel.org> <87a7359m3j.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f2385dfc-87de-b289-c2f0-7ef79de74872@gmail.com>
Date:   Tue, 21 Apr 2020 07:03:34 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87a7359m3j.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/20 4:20 AM, Toke Høiland-Jørgensen wrote:
> Isn't the kernel returning both program types in the same message when
> dumping an interface? So do we really need a separate getter instead of
> just populating xdp_link_info with the egress ID in the existing getter?

That might work with some refactoring of get_xdp_info. I'll take a look.
