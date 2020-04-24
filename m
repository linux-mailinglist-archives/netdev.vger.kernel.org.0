Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FABB1B6A8A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 02:58:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728096AbgDXA6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 20:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727906AbgDXA6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 20:58:16 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954F1C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:58:16 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id x8so6630939qtp.13
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 17:58:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7zbleXpcHAzsSqcwr0Cj5bcWEhu/8oIcG9QS5C0Abp8=;
        b=obPehdLsYpb4CdLJS2GV7/to1B2LCWijpHYddq8azg9MvAUNRXSN7zg+X3vOR4f7WY
         i5my9XW+jrCP8pccZtG9tdtagpaCV02Xx4sPjqw5RLmE3PS7JwQnTMwqEWA3ALLEabOR
         AYWu8JDXvAHtgXzTyJ95rGontrBlHdn/61ZepTOyJ6t7RflvSAUwwfuEPuk29zgfdTGM
         ok2g48OncohGv8wZM6Bkynx/fT7IOpbzrIIgGff17y/90xvFP5rHzlMRqTqMHvlxwpMU
         2iu/u7t8ex1NucP4IwdYnmlNnBwgcuH4EntF3R8NcCWDuvqmGMAGDQM49hcgm6+jtv6f
         94Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7zbleXpcHAzsSqcwr0Cj5bcWEhu/8oIcG9QS5C0Abp8=;
        b=NV+Kmidrf9HaBC4um7Z2EDGBWi1hT6LebquruSO/AmO3gqTao/2H2FzkiOabN5VB6p
         vNoubjs3yoDBajCV99jhQwwRKzNDqtsZX8mPH/A6cbm83nZvOl08pnZI+aK1wq85KEv8
         SZZB4WZoaGEHcxkUjwjfkTLa+6GwynKgf08beVTguvbx8foDuPpPeDDtZPXG7Ld2H/cR
         SNMkN7z7geUiAyAFK0zdzZo0ejArjNY+r+P2s+CUECQ65AfSMTNDP9VXXZHGQO3mCvCA
         JrHw/28eCgaeuDIjcWCKDJq50Cvn4APeyCfk5VoYkAaFFuXz3jqudplE59e3GFBsj4Ub
         Ab5Q==
X-Gm-Message-State: AGi0PubGcKbk4f0f8/OyXeHIs7nd4gF4ptvVK953uSLfEeR6r0frOfHX
        bJByrDcO8GsB+QlmC7a9A1U=
X-Google-Smtp-Source: APiQypJIehnLilaKZ62K9xQ0nO3CetcFOZL7KZGP2gczHZGidnFHmzfT5vcuiBupzeCanREKMlF1+g==
X-Received: by 2002:aed:3f1d:: with SMTP id p29mr7083453qtf.14.1587689895751;
        Thu, 23 Apr 2020 17:58:15 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:2064:c3f6:4748:be84? ([2601:282:803:7700:2064:c3f6:4748:be84])
        by smtp.googlemail.com with ESMTPSA id i127sm2735814qkc.93.2020.04.23.17.58.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Apr 2020 17:58:15 -0700 (PDT)
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a
 bpf_attach_type
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dahern@digitalocean.com>
References: <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com>
 <875zdr8rrx.fsf@toke.dk> <783d0842-a83f-c22f-25f2-4a86f3924472@gmail.com>
 <87368v8qnr.fsf@toke.dk>
 <20200423003911.tzuu6cxtg7olvvko@ast-mbp.dhcp.thefacebook.com>
 <878sim6tqj.fsf@toke.dk>
 <CAADnVQ+GDR15oArpEGFFOvZ35WthHyL+b97zQUxjXbz-ec5CGw@mail.gmail.com>
 <874kta6sk9.fsf@toke.dk> <20200423224451.rkvfnv5cbnjpepgo@ast-mbp>
 <87lfml69w0.fsf@toke.dk>
 <20200424005308.kguqn53qti26uvp6@ast-mbp.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <92f6d75c-3d31-f93d-b081-c5897550ec2b@gmail.com>
Date:   Thu, 23 Apr 2020 18:58:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424005308.kguqn53qti26uvp6@ast-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/20 6:53 PM, Alexei Starovoitov wrote:
> 
> I think the issue is not related to xdp egress.

It isn't; that has been my point all along.

> Hence I'd like to push the fix along with selftest into bpf tree.
> The selftest can be:
> void noinline do_bind((struct bpf_sock_addr *ctx)
> {
>   struct sockaddr_in sa = {};
> 
>   bpf_bind(ctx, (struct sockaddr *)&sa, sizeof(sa));
>   return 0;
> }
> SEC("cgroup/connect4")
> int connect_v4_prog(struct bpf_sock_addr *ctx)
> {
>   return do_bind(ctx);
> }
> 
> and freplace would replace do_bind() with do_new_bind()
> that also calls bpf_bind().
> I think without the fix freplace will fail to load, because
> availability of bpf_bind() depends on correct prog->expected_attach_type.
> 
> I haven't looked at the crash you mentioned in the other email related
> to xdp egress set. That could be different issue. I hope it's the same thing :)
> 

it is. The replaced program is accessing ingress_ifindex from xdp egress
context, and Rx stuff is not set (access is blocked by verifier).
