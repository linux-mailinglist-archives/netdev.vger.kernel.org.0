Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 448901CA6A0
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 10:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726864AbgEHIyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 04:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgEHIyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 04:54:11 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079EFC05BD0A
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 01:54:09 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id l18so923509wrn.6
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 01:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=sAzrRdwhen6mcsuV4DQ0ozpHVnETNzjd3US+qiFlROM=;
        b=NhDDygFhw7HFB+9OdYLggWRA13mUS1gZpYuDL147LM4MF5hYWEyAz6x3+JdXyV+9XT
         CWSMxcKc4sEX2FfxOesI4nYCooVtP34M0MVLA4CLzdiACWBb94K0tdoIEqOb0HiWrv8o
         lo7VmdWYybIC5zs+jc4hsncwcstaZYr0IfLJc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=sAzrRdwhen6mcsuV4DQ0ozpHVnETNzjd3US+qiFlROM=;
        b=fa9JoAirshR4JWsfK/roWhrGLBxNxUUGyOtcIuGuFiA+rG0OaBOhcXJhCCSIiXdcUF
         Bp6Nc5HgIvBXjDSntmgUGP+6hl7bbGo6PWVC1Lrv9qQZZXS9Jl2d2X44gGHpoIjhjNC6
         fXwdaMB1A5Do44bznSPcuiNw6HHChwb9FOO0Gq8IVbIC7Seup2APIAa1HTaUNDmndyck
         iWxmZUUxGWsfHYW9LQbxjl9BxQhdiApjNBJthV1b5W1xDx7leHZy0hWCpVupKG59Mmav
         k3GfYjKaQpEp2E5edRs168J572pzSW1mILG4XQwHbADj2kJwgcSGx6m+nhcJhLs83uhg
         D7oA==
X-Gm-Message-State: AGi0PuYCfk46jTfDjx3mA+Ei0+XBfBIaHBmTpbxpppiHrsOL7Lth9viI
        mRGn9YNOndYHf4WvOs5CuSxBLA==
X-Google-Smtp-Source: APiQypITN6wxpUpGf8yFlRte62yeifNq3OTqk52/CjQnS1e+IK/w1uVj80MCvBPNZm+RuFxo4oHVkA==
X-Received: by 2002:adf:f5cb:: with SMTP id k11mr1699535wrp.300.1588928048585;
        Fri, 08 May 2020 01:54:08 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id x23sm11771158wmj.6.2020.05.08.01.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 01:54:07 -0700 (PDT)
References: <20200506125514.1020829-1-jakub@cloudflare.com> <20200506125514.1020829-3-jakub@cloudflare.com> <CACAyw9-ro_Dit=3M46=JSrkuc8y+UcsvJgVQuG98KdtmM9mCCA@mail.gmail.com> <87eerxuq3k.fsf@cloudflare.com> <20200507205524.pv2pnujxdrbktdc4@kafai-mbp>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Lorenz Bauer <lmb@cloudflare.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        dccp@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Gerrit Renker <gerrit@erg.abdn.ac.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH bpf-next 02/17] bpf: Introduce SK_LOOKUP program type with a dedicated attach point
In-reply-to: <20200507205524.pv2pnujxdrbktdc4@kafai-mbp>
Date:   Fri, 08 May 2020 10:54:06 +0200
Message-ID: <87blmyvmc1.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 07, 2020 at 10:55 PM CEST, Martin KaFai Lau wrote:
> On Wed, May 06, 2020 at 03:53:35PM +0200, Jakub Sitnicki wrote:
>> On Wed, May 06, 2020 at 03:16 PM CEST, Lorenz Bauer wrote:
>> > On Wed, 6 May 2020 at 13:55, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> [...]
>>
>> >> @@ -4012,4 +4051,18 @@ struct bpf_pidns_info {
>> >>         __u32 pid;
>> >>         __u32 tgid;
>> >>  };
>> >> +
>> >> +/* User accessible data for SK_LOOKUP programs. Add new fields at the end. */
>> >> +struct bpf_sk_lookup {
>> >> +       __u32 family;           /* AF_INET, AF_INET6 */
>> >> +       __u32 protocol;         /* IPPROTO_TCP, IPPROTO_UDP */
>> >> +       /* IP addresses allows 1, 2, and 4 bytes access */
>> >> +       __u32 src_ip4;
>> >> +       __u32 src_ip6[4];
>> >> +       __u32 src_port;         /* network byte order */
>> >> +       __u32 dst_ip4;
>> >> +       __u32 dst_ip6[4];
>> >> +       __u32 dst_port;         /* host byte order */
>> >
>> > Jakub and I have discussed this off-list, but we couldn't come to an
>> > agreement and decided to invite
>> > your opinion.
>> >
>> > I think that dst_port should be in network byte order, since it's one
>> > less exception to the
>> > rule to think about when writing BPF programs.
>> >
>> > Jakub's argument is that this follows __sk_buff->local_port precedent,
>> > which is also in host
>> > byte order.
>>
>> Yes, would be great to hear if there is a preference here.
>>
>> Small correction, proposed sk_lookup program doesn't have access to
>> __sk_buff, so perhaps that case matters less.
>>
>> bpf_sk_lookup->dst_port, the packet destination port, is in host byte
>> order so that it can be compared against bpf_sock->src_port, socket
>> local port, without conversion.
>>
>> But I also see how it can be a surprise for a BPF user that one field has
>> a different byte order.
> I would also prefer port and addr were all in the same byte order.
> However, it is not the cases for the other prog_type ctx.
> People has stomped on it from time to time.  May be something
> can be done at the libbpf to hide this difference.
>
> I think uapi consistency with other existing ctx is more important here.
> (i.e. keep the "local" port in host order).  Otherwise, the user will
> be slapped left and right when writting bpf_prog in different prog_type.
>
> Armed with the knowledge on skc_num, the "local" port is
> in host byte order in the current existing prog ctx.  It is
> unfortunate that the "dst"_port in this patch is the "local" port.
> The "local" port in "struct bpf_sock" is actually the "src"_port. :/
> Would "local"/"remote" be clearer than "src"/dst" in this patch?

I went and compared the field naming and byte order in existing structs:

  | struct         | field      | byte order |
  |----------------+------------+------------|
  | __sk_buff      | local_port | host       |
  | sk_msg_md      | local_port | host       |
  | bpf_sock_ops   | local_port | host       |
  | bpf_sock       | src_port   | host       |
  | bpf_fib_lookup | dport      | network    |
  | bpf_flow_keys  | dport      | network    |
  | bpf_sock_tuple | dport      | network    |
  | bpf_sock_addr  | user_port  | network    |

It does look like "local"/"remote" prefix is the sensible choice.

I got carried away trying to match the field names with bpf_sock, which
actually doesn't follow the naming convention.

Will rename fields to local_*, remote_* in v2.
