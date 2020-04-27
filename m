Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 676F71BABD2
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 19:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgD0R66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 13:58:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726162AbgD0R65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 13:58:57 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4ECCC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:58:57 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id ep1so8996767qvb.0
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 10:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hUAxKe48uAfcTJnG+M70UfMcl0MbBCulsrybuQhl25A=;
        b=Jm+5g4S89kQkTdOk/9RG6VsR/iInaTmrDGZTArgX2f/LK7r5cVScT6jEEdoUrOWRwK
         Ax0xINis4SDi0C8py2cIaaZUZyrOCYnDCb08a9VU+7gOQrz8axnn3cag5hA8oiDQmKrW
         ifjFYMaAKT753vkhscg1IKQlwfcu7RONUs+SeTq5+WTbim6ihGQuE7qCsegEETplzfwk
         0P+mtguHLWMJBvn3S8hwuYjI/PmZo9LJyCI5yHetYFIvc7+RGBg+zPB6swVXaV49CN5r
         nu5rZ8Kdts8EWW1w7MLF+X89SMrd8GL/UiiW9t48u+L+Vye23htfX8/Wyy+lB1OuJjM/
         o7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hUAxKe48uAfcTJnG+M70UfMcl0MbBCulsrybuQhl25A=;
        b=Z0xV+K88ykCw7I3gCrUIvcwa0t/MQDUUJ5j+YcA6h8bvvrhvyxgn/aRAfU6y+s0d4E
         UZ/jjVqhAO45GcXH06hl31Oh0wXXrzPZ80QKFg0P1JDblXuAm8jG6oUEbj9L1obYmJUq
         JzcZkIlz3buSlJlf4KzpeFt1tHnhcuRVKujrM44lzY4X08faME/RrW38k7UBc4Xfdyzc
         w4TXQad0Iu+vN+UNkKmcdWOlhUmPTehU4UOWYSQL3jesce0TqKjf1IPDJ0DspjkSfckt
         zgRjTx5g+Yw4wdO2bSgMk0v3pmJD3pZFaPurUSKvKg8bD6F47wbj/HY6yjsggEqj546+
         tujw==
X-Gm-Message-State: AGi0PuY7BQ4tvX7H2UtPURcTlZnWh+fvJUFB4mZaHfyQ4lW9T/KXD9WR
        oOcuBSEaQP7zYsYeiymp9rQ=
X-Google-Smtp-Source: APiQypJeUwjPEo1xixO2ErI/RgaSDDsCHjt2BFv+D0U0NXzhGzGaShSL7ukcZ2dtAEzJfz4TrBtYuA==
X-Received: by 2002:a05:6214:b88:: with SMTP id fe8mr23850230qvb.250.1588010337090;
        Mon, 27 Apr 2020 10:58:57 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id c139sm11211832qkg.8.2020.04.27.10.58.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 10:58:56 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 13/15] selftest: Add test for xdp_egress
To:     John Fastabend <john.fastabend@gmail.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toke@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, ast@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200424201428.89514-1-dsahern@kernel.org>
 <20200424201428.89514-14-dsahern@kernel.org>
 <5ea71ade547e3_a372ad3a5ecc5b811@john-XPS-13-9370.notmuch>
 <5ea71bcb29f67_a372ad3a5ecc5b864@john-XPS-13-9370.notmuch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <81022ae6-fe5d-e93d-2980-8a8904ab49d7@gmail.com>
Date:   Mon, 27 Apr 2020 11:58:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <5ea71bcb29f67_a372ad3a5ecc5b864@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/27/20 11:52 AM, John Fastabend wrote:
> Also would be nice to have a test case for the xdp redirect into tx case. I think
> this is only going to test the skb path?

I have tests for the xdp_frame case, but it requires multiple nodes -
not namespaces. Multiple node tests no longer fall into the 'selftest'
category. I am not aware of any way to do XDP_REDIRECT testing within a
single node; general shortcoming with all xdp_frame specific tests.
