Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5E83B1259
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 05:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230236AbhFWDoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Jun 2021 23:44:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhFWDoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Jun 2021 23:44:02 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6345EC061574;
        Tue, 22 Jun 2021 20:41:45 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id n99-20020a9d206c0000b029045d4f996e62so606598ota.4;
        Tue, 22 Jun 2021 20:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S/q1ilT1hs2TT/ds+4HdNsDS+C0sqazQRzGoxal5Y9M=;
        b=PxQfmNFvrGQBO70YokAHlLczCPk+UCQXuBnXSWJgaebVZRomvU1opT4g303+VbW82C
         EYISUruPWGX/gfarPsg5i4H6Ks3Y0MTzN43ezR6kbDDRbU70cwBoGewHjBWlXBi7fTqM
         bs/C0K9rkGzONWLBLNcYNmDpceaHxgId3hyl4g8jMP8Xtp0tLwa2tn+JhFn4sCvdfC4w
         KYj8WDL9UqK64HZUqJhOIjh9T3d064PQ1D/P+CnzcgJ9+6V+6Kgk4nEJUWkRQQJBYpw8
         5MtsTLZlf2hIkdgMU9+EfuXeV7NVijymAncE9190ucUt4ywCkaZZJrluUUauAKaa1Hos
         W0yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S/q1ilT1hs2TT/ds+4HdNsDS+C0sqazQRzGoxal5Y9M=;
        b=uSTfDXuLdYvveD2vqPv2Y8HMuv5HSkWAY0Rxybm9Se/egrdnJEmMp0BjPyAsn/3sMA
         8utDND7lZt0A3C45dKYn0ajBA00qY2BxQLf/m24NL2+5oYMhKbOgvRKOBhVxhVDptsNE
         qwHieHQlLmpcLej6KRHCiztIhpBqQlPe38Md078VQeT3QE8Fo3lQZAhtiN7TVIvN0ea0
         ByrWP8aMR6akxR3/unogc3o58zy/6wg3P7TrtQF1pxsB4d8Ey6jN2Shv8NKhxsvYDp0u
         IFbiQDJh8hpNBcHymyymaOi7dUWMmu6pmvp8Xaftc/myxvLx+gWR6xQGfokQKMbnsGnD
         dVTQ==
X-Gm-Message-State: AOAM531NBJsBruYd2KEHz4o/xuF496ykEY2N1frIbddAQ4ZezHi2Mha0
        VzWRZETOHQ3qIvGb6CLBSfs=
X-Google-Smtp-Source: ABdhPJzhJZpGiwd0SquMzMC6URN8IvrzXjtMucSiKVjc8p8GbVoC1+AoU9gU7wZ1lGpsdbptmD8Dmg==
X-Received: by 2002:a9d:6f88:: with SMTP id h8mr5743849otq.73.1624419704829;
        Tue, 22 Jun 2021 20:41:44 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id f12sm999346ooh.38.2021.06.22.20.41.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Jun 2021 20:41:44 -0700 (PDT)
Subject: Re: [PATCH v9 bpf-next 00/14] mvneta: introduce XDP multi-buffer
 support
To:     John Fastabend <john.fastabend@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, shayagr@amazon.com,
        sameehj@amazon.com, dsahern@kernel.org, brouer@redhat.com,
        echaudro@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
References: <cover.1623674025.git.lorenzo@kernel.org>
 <60d26fcdbd5c7_1342e208f6@john-XPS-13-9370.notmuch>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <efe4fcfa-087b-e025-a371-269ef36a3e86@gmail.com>
Date:   Tue, 22 Jun 2021 21:41:41 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <60d26fcdbd5c7_1342e208f6@john-XPS-13-9370.notmuch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/22/21 5:18 PM, John Fastabend wrote:
> At this point I don't think we can have a partial implementation. At
> the moment we have packet capture applications and protocol parsers
> running in production. If we allow this to go in staged we are going
> to break those applications that make the fundamental assumption they
> have access to all the data in the packet.

What about cases like netgpu where headers are accessible but data is
not (e.g., gpu memory)? If the API indicates limited buffer access, is
that sufficient?
