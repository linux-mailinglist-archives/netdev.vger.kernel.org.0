Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 135271B47B3
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 16:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726584AbgDVOv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 10:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbgDVOv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 10:51:28 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23D0C03C1A9
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 07:51:27 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id j4so2585527qkc.11
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 07:51:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oIqIssXp59N0uUXf+Kjms01agVS0+QxwRsWMKR95Mhk=;
        b=KgTaiEYl44SPl4cm/8OtjyzpKRzYx2xNhi+FInYndm95EmPGlo+f1oKueG7/TZ090H
         e1vQjtrnmJAKuzIjvqD16SyWtWPo7CCySxlXQemjGVWb8HAy6T0vw+5Aeqy7PoK5UfHf
         AX3nidDCDgsZ1uutIkCmJ4hHHSUTjkd+TTsIonjdMwk9nMQ05Hr92h4i9DHoe42sBWkk
         3yODwho2zxHzDyBV5qqRQMmknQ43A0j/+6iR1YLW4Px3KlVuBXodsxU6yqOa7bYkWF2w
         LS0IGScpzG0bfb74z5evYivBxg5+M5gVSFCPvR3yCIOcNZb+EPkFl8cg71bZhAvl2PKP
         UxmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oIqIssXp59N0uUXf+Kjms01agVS0+QxwRsWMKR95Mhk=;
        b=K/xXJp/qfTudLbx7RQYibb2/lFwnG0E9d5tHJB6SRp8G3EZgBCluJrUlv2BR3nwjOo
         ZgifV8AacUPRf+jJbV7gpW8M4NRJB69ku5jVfyn+A/desvVQv5SDwguPq4QafVl6YQz4
         vQxGz5Va+XFEknQhD91Z93IEWeR6Jr/18TFRwlqQwyP9KEdzyZ3xbEl08rcWpz2Gw4BI
         1+w4UJA3fpv9jgra0UAZ6u9vsi7NHgVDqa+BpD7npHrj5iWY+rRD5se2tf3tKMot2ia2
         idM9PddUGa3rYtkr/jl3OEg+LAHll7Vdv88j8MmgBHdiNQ+dTpfSudJXs4f3B2XkRuBN
         slRQ==
X-Gm-Message-State: AGi0PuadjlYZboNKAy6Kj/01E5pfJMjsUD73WukDMDSh9Kseh5liwEG+
        FevtcYof85ENodTUm5myvxkUPpSB
X-Google-Smtp-Source: APiQypIkGrQPcdWapyyD76nEnnPfi28BJHCkabmMeKM+0QPYYh3XKyRFpXfZtPjZhLl5HqQ5eSogVw==
X-Received: by 2002:a05:620a:cd7:: with SMTP id b23mr26606065qkj.22.1587567086976;
        Wed, 22 Apr 2020 07:51:26 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c19e:4650:3a73:fee4? ([2601:282:803:7700:c19e:4650:3a73:fee4])
        by smtp.googlemail.com with ESMTPSA id 190sm4046081qkj.87.2020.04.22.07.51.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 07:51:25 -0700 (PDT)
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a
 bpf_attach_type
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
References: <20200420200055.49033-1-dsahern@kernel.org>
 <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk>
 <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com> <87pnc17yz1.fsf@toke.dk>
 <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com> <87k1277om2.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com>
Date:   Wed, 22 Apr 2020 08:51:23 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <87k1277om2.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/22/20 5:21 AM, Toke Høiland-Jørgensen wrote:
> Not saying a fix to freplace *has* to be part of this series; just
> saying that I would be more comfortable if that was fixed before we
> merge this.

You don't have a test case that fails, you just think there is a problem
based on code analysis. Have you taken this presumption up with the
author of the freplace code?
