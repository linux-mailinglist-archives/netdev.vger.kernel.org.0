Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5550C2123A5
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 14:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729015AbgGBMqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 08:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728875AbgGBMqp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 08:46:45 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A500EC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 05:46:44 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id dp18so29393251ejc.8
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 05:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=OZapjkMScVIrstSkX0mIC5olbP3zrciZIMCY+tSnuRw=;
        b=Ej7YQvLZnSpoGD8JTwx6ejxc/qvpsz07mRAnzXGMx7CjgG4WzN22X7PuYPFetDoSwk
         acEudpYc6lYUh9/pitVq/f69wSHgZ2V9BOGnEwnS06LA76dd6wJh29n3BkNE63tA6Cb7
         eG6Gz9L9x/MGFiCE5E303onmECFlHpuUU+0hY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=OZapjkMScVIrstSkX0mIC5olbP3zrciZIMCY+tSnuRw=;
        b=m9IkFimd/SKbpaS7QPDxDwXeH4OGxLw1CCg4EJhMf1oMWlzflfVpagTspjcirbfy+I
         vE6NHtS3IheBAE5I+cPUQJuP6gE1MaiOGev5wl7uG9/SAE6FetHfHv2QeWjM1WbAXMUG
         bYTjE3qFbbHq3l850VakqTFEsf6X4Jvp7X5AIKue0tB5wTWFGa7GNBx/17OgpZxFyxyo
         auFZVkkp1H7sqVy0hkfK2KmD0y8qSulMcaTP+F3VAOQQh0pqSjtYsA3790lBLdoFxLp2
         HQMdEasNMNxsrJiFiowqBVZ9DIhTrZ57j6Aj1E1Ok1MtbWox/hAJ716k6SoKP9UVABgC
         3SLw==
X-Gm-Message-State: AOAM530T8rPL9tKIS7+CuYgOQkgCoeZY+EsoHpDC3Niw1Y+SJRvlfa8Q
        SFTqJw3Q2CIK20Z8iZmIDFtTKQ==
X-Google-Smtp-Source: ABdhPJwLGHkfiTaFLMJ+1fVVeiugmoPZq/QdlhhhsZNoVHE6hnqzhCYAxgQ9JFqulll4LuZARS0JLw==
X-Received: by 2002:a17:906:57da:: with SMTP id u26mr28312297ejr.157.1593694003341;
        Thu, 02 Jul 2020 05:46:43 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id n16sm6864449ejo.54.2020.07.02.05.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 05:46:42 -0700 (PDT)
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-5-jakub@cloudflare.com> <CACAyw9-6OCPqg3eoPOPeKYy=kBNVJT8-qbLh6QOo=8aEV6pWjw@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Lorenz Bauer <lmb@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marek Majkowski <marek@cloudflare.com>
Subject: Re: [PATCH bpf-next v3 04/16] inet: Run SK_LOOKUP BPF program on socket lookup
In-reply-to: <CACAyw9-6OCPqg3eoPOPeKYy=kBNVJT8-qbLh6QOo=8aEV6pWjw@mail.gmail.com>
Date:   Thu, 02 Jul 2020 14:46:41 +0200
Message-ID: <87mu4inky6.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 12:27 PM CEST, Lorenz Bauer wrote:
> On Thu, 2 Jul 2020 at 10:24, Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> Run a BPF program before looking up a listening socket on the receive path.
>> Program selects a listening socket to yield as result of socket lookup by
>> calling bpf_sk_assign() helper and returning BPF_REDIRECT (7) code.
>>
>> Alternatively, program can also fail the lookup by returning with
>> BPF_DROP (1), or let the lookup continue as usual with BPF_OK (0) on
>> return. Other return values are treated the same as BPF_OK.
>
> I'd prefer if other values were treated as BPF_DROP, with other semantics
> unchanged. Otherwise we won't be able to introduce new semantics
> without potentially breaking user code.

That might be surprising or even risky. If you attach a badly written
program that say returns a negative value, it will drop all TCP SYNs and
UDP traffic.

>
>>
>> This lets the user match packets with listening sockets freely at the last
>> possible point on the receive path, where we know that packets are destined
>> for local delivery after undergoing policing, filtering, and routing.
>>
>> With BPF code selecting the socket, directing packets destined to an IP
>> range or to a port range to a single socket becomes possible.
>>
>> In case multiple programs are attached, they are run in series in the order
>> in which they were attached. The end result gets determined from return
>> code from each program according to following rules.
>>
>>  1. If any program returned BPF_REDIRECT and selected a valid socket, this
>>     socket will be used as result of the lookup.
>>  2. If more than one program returned BPF_REDIRECT and selected a socket,
>>     last selection takes effect.
>>  3. If any program returned BPF_DROP and none returned BPF_REDIRECT, the
>>     socket lookup will fail with -ECONNREFUSED.
>>  4. If no program returned neither BPF_DROP nor BPF_REDIRECT, socket lookup
>>     continues to htable-based lookup.
>>
>> Suggested-by: Marek Majkowski <marek@cloudflare.com>
>> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> ---
>>
>> Notes:
>>     v3:
>>     - Use a static_key to minimize the hook overhead when not used. (Alexei)
>>     - Adapt for running an array of attached programs. (Alexei)
>>     - Adapt for optionally skipping reuseport selection. (Martin)
>>
>>  include/linux/bpf.h        | 29 ++++++++++++++++++++++++++++
>>  include/linux/filter.h     | 39 ++++++++++++++++++++++++++++++++++++++
>>  kernel/bpf/net_namespace.c | 32 ++++++++++++++++++++++++++++++-
>>  net/core/filter.c          |  2 ++
>>  net/ipv4/inet_hashtables.c | 31 ++++++++++++++++++++++++++++++
>>  5 files changed, 132 insertions(+), 1 deletion(-)
>>

[...]

>> diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
>> index 090166824ca4..a7768feb3ade 100644
>> --- a/kernel/bpf/net_namespace.c
>> +++ b/kernel/bpf/net_namespace.c
>> @@ -25,6 +25,28 @@ struct bpf_netns_link {
>>  /* Protects updates to netns_bpf */
>>  DEFINE_MUTEX(netns_bpf_mutex);
>>
>> +static void netns_bpf_attach_type_disable(enum netns_bpf_attach_type type)
>
> Nit: maybe netns_bpf_attach_type_dec()? Disable sounds like it happens
> unconditionally.

attach_type_dec()/_inc() seems a bit cryptic, since it's not the attach
type we are incrementing/decrementing.

But I was considering _need()/_unneed(), which would follow an existing
example, if you think that improves things.

>
>> +{
>> +       switch (type) {
>> +       case NETNS_BPF_SK_LOOKUP:
>> +               static_branch_dec(&bpf_sk_lookup_enabled);
>> +               break;
>> +       default:
>> +               break;
>> +       }
>> +}
>> +
>> +static void netns_bpf_attach_type_enable(enum netns_bpf_attach_type type)
>> +{
>> +       switch (type) {
>> +       case NETNS_BPF_SK_LOOKUP:
>> +               static_branch_inc(&bpf_sk_lookup_enabled);
>> +               break;
>> +       default:
>> +               break;
>> +       }
>> +}
>> +
>>  /* Must be called with netns_bpf_mutex held. */
>>  static void netns_bpf_run_array_detach(struct net *net,
>>                                        enum netns_bpf_attach_type type)
>> @@ -93,6 +115,9 @@ static void bpf_netns_link_release(struct bpf_link *link)
>>         if (!net)
>>                 goto out_unlock;
>>
>> +       /* Mark attach point as unused */
>> +       netns_bpf_attach_type_disable(type);
>> +
>>         /* Remember link position in case of safe delete */
>>         idx = link_index(net, type, net_link);
>>         list_del(&net_link->node);
>> @@ -416,6 +441,9 @@ static int netns_bpf_link_attach(struct net *net, struct bpf_link *link,
>>                                         lockdep_is_held(&netns_bpf_mutex));
>>         bpf_prog_array_free(run_array);
>>
>> +       /* Mark attach point as used */
>> +       netns_bpf_attach_type_enable(type);
>> +
>>  out_unlock:
>>         mutex_unlock(&netns_bpf_mutex);
>>         return err;
>> @@ -491,8 +519,10 @@ static void __net_exit netns_bpf_pernet_pre_exit(struct net *net)
>>         mutex_lock(&netns_bpf_mutex);
>>         for (type = 0; type < MAX_NETNS_BPF_ATTACH_TYPE; type++) {
>>                 netns_bpf_run_array_detach(net, type);
>> -               list_for_each_entry(net_link, &net->bpf.links[type], node)
>> +               list_for_each_entry(net_link, &net->bpf.links[type], node) {
>>                         net_link->net = NULL; /* auto-detach link */
>> +                       netns_bpf_attach_type_disable(type);
>> +               }
>>                 if (net->bpf.progs[type])
>>                         bpf_prog_put(net->bpf.progs[type]);
>>         }
>> diff --git a/net/core/filter.c b/net/core/filter.c

[...]
